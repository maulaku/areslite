{
 this file is part of Ares
 Aresgalaxy ( http://aresgalaxy.sourceforge.net )

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either
  version 2 of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 }

{
Description:
code used to catch special chat color/emoticon combinations
}

unit helper_chatroom;

interface

uses
 classes,classes2,imglist,graphics,controls,jvrichedit,windows,
 sysutils,utility_ares,ares_types,registry,tntdialogs;

const
  RTF_HEADER    = '{\rtf1\ansi\ansicpg1252\deff0\deflang1040{\fonttbl{\f0\fswiss\fprq2\fcharset0';// Tahoma;}}';
  RTF_COLORTBL1 = '{\colortbl;\red0\green0\blue0;\red128\green0\blue0;\red0\green128\blue0;\red255\green128\blue0;\red0\green0\blue128;\red128\green0\blue128;\red0\green128\blue128;\red128\green128\blue128';
  RTF_COLORTBL2 = ';\red192\green192\blue192;\red255\green0\blue0;\red0\green255\blue0;\red255\green255\blue0;\red0\green0\blue255;\red255\green0\blue255;\red0\green255\blue255;\red255\green255\blue255;}';
  RTF_COLORTBL  = RTF_COLORTBL1 + RTF_COLORTBL2;

function ColorAresToRTColor(col:byte):byte;
function emoticonstr_to_index(const str:string; var lung:integer):integer;
function strip_color_string(const text:widestring; var stripped:boolean):widestring;
function convert_command_color_str(const text:widestring):widestring;
function color_irc_to_color(const colorin:widestring):tcolor;
procedure mainGui_host_channel_click_event;
procedure mainGUI_rehost_ifrestarted;
function colorRTtoTColor(col:byte):tcolor;

procedure stopChatService;
procedure checkChatService;
procedure startChatService(joinChannel:boolean=false);
procedure JoinHostedChannel(nameCh:widestring); overload;
procedure JoinHostedChannel; overload;
function GetHostChannelPort(DefaultValue:integer):integer;


implementation

uses
 ufrmmain,vars_global,helper_strings,const_chatroom_commands,
 comettrees,vars_localiz,helper_unicode,const_ares,helper_chatroom_gui,
 helper_gui_misc,serviceManager,helper_diskio,helper_ipfunc,thread_client_chat,
 helper_ares_cacheservers,helper_datetime,blcksock,uxpfirewall;

procedure mainGUI_rehost_ifrestarted;
var
reg:tregistry;
pcanale:precord_canale_chat_visual;
namech:widestring;
begin
reg:=tregistry.create;
 with reg do begin
  openkey(areskey,true);

  if not reg.valueexists('ChatRoom.Running') then begin
   closekey;
   destroy;
   exit;
  end;

  if reg.ReadInteger('ChatRoom.Running')<>1 then begin
   closekey;
   destroy;
   exit;
  end;


 closekey;
 destroy;
end;

 startChatService(true);
end;

procedure startChatService(joinChannel:boolean=false);
var
 reg:tregistry;
 serMngr:TServiceManager;
 namech:widestring;
 str:string;
 i:integer;
 stream:THandleStream;
 tick:cardinal;
begin

reg:=TRegistry.create;
with reg do begin
 openkey(areskey,true);
 namech:=utf8strtowidestr(hexstr_to_bytestr( readstring('History.LastHostedChannel')));
 WriteInteger('ChatRoom.Running',1);
 closekey;
 destroy;
end;

// fix bad channel names
if length(namech)<MIN_CHAT_NAME_LEN then namech:='TestChannel';
if length(namech)>MAX_CHAT_NAME_LEN then delete(namech,MAX_CHAT_NAME_LEN+1,length(namech));
for i:=1 to length(namech) do if namech[i]=' ' then namech[i]:='_';



// write safe chatprefs
if not fileexistsW(app_path+'\Data\ChatConf.txt') then stream:=MyfileOpen(app_path+'\Data\ChatConf.txt',ARES_OVERWRITE_EXISTING)
 else stream:=MyfileOpen(app_path+'\Data\ChatConf.txt',ARES_WRITE_EXISTING);
 stream.seek(0,soFromEnd);
 str:='ChannelName= '+widestrtoutf8str(namech)+CRLF+
      'ChannelLanguage= '+ vars_localiz.getDefLang +CRLF+
      helper_ares_cacheservers.cache_get_chathosts;
 stream.write(str[1],length(str));
FreeHandleStream(stream);


// start service
 serMngr:=TServiceManager.create;
 if not serMngr.Connect then begin
  serMngr.free;
  exit;
 end;

 if not serMngr.OpenServiceConnection(pchar('AresChatServer')) then begin
  serMngr.free;
  exit;
 end;

 serMngr.UpdateConfig;
 

 tick:=gettickcount;
 while (not serMngr.ServiceRunning) do begin
  serMngr.StartService;
  sleep(50);
  if gettickcount-tick>SECOND then break;
  //application.processmessages;
 end;
 vars_global.ChatServiceRunning:=serMngr.ServiceRunning;

 serMngr.free;

 ares_frmmain.btn_opt_chat_start.enabled:=not vars_global.ChatServiceRunning;
 ares_frmmain.btn_opt_chat_stop.enabled:=vars_global.ChatServiceRunning;
 ares_frmmain.btn_opt_chat_join.enabled:=vars_global.ChatServiceRunning;

 if joinChannel then JoinHostedChannel(nameCh);
end;

procedure stopChatService;
var
 serMngr:TServiceManager;
 reg:TRegistry;
 tick:cardinal;
begin
if not vars_global.ChatServiceRunning then exit;

 try
 reg:=tregistry.create;
 with reg do begin
  openkey(areskey,true);
  WriteInteger('ChatRoom.Running',0);
  closekey;
  destroy;
 end;

 serMngr:=TServiceManager.create;
 if not serMngr.Connect then begin
  serMngr.free;
  exit;
 end;

  if not serMngr.OpenServiceConnection(pchar('AresChatServer')) then begin
   serMngr.free;
   exit;
  end;

  tick:=gettickcount;
  while serMngr.ServiceRunning do begin
   serMngr.StopService;
   sleep(50);
   if gettickcount-tick>SECOND then break;
   //application.progressmessages;
  end;
  
  vars_global.ChatServiceRunning:=serMngr.ServiceRunning;
  serMngr.free;

  ares_frmmain.btn_opt_chat_start.enabled:=not vars_global.ChatServiceRunning;
  ares_frmmain.btn_opt_chat_stop.enabled:=vars_global.ChatServiceRunning;
  ares_frmmain.btn_opt_chat_join.enabled:=vars_global.ChatServiceRunning;

  except
  end;
end;

procedure checkChatService;
var
 serMngr:TServiceManager;
begin
try

serMngr:=TServiceManager.create;

if not serMngr.Connect then begin
 serMngr.free;
 exit;
end;

if not serMngr.OpenServiceConnection(pchar('AresChatServer')) then begin
 serMngr.free;
 exit;
end;

 vars_global.ChatServiceRunning:=serMngr.ServiceRunning;
 serMngr.free;

  ares_frmmain.btn_opt_chat_start.enabled:=not vars_global.ChatServiceRunning;
  ares_frmmain.btn_opt_chat_stop.enabled:=vars_global.ChatServiceRunning;
  ares_frmmain.btn_opt_chat_join.enabled:=vars_global.ChatServiceRunning;
except
end;
end;

procedure mainGui_host_channel_click_event;
var
serMngr:TServiceManager;
stream:THandleStream;
namech:widestring;
str:string;
i:integer;
reg:tregistry;
tick:cardinal;
tempPort:integer;
begin



reg:=tregistry.create;
with reg do begin
 openkey(areskey,true);
  namech:=utf8strtowidestr(hexstr_to_bytestr( readstring('History.LastHostedChannel')));
 closekey;
 destroy;
end;


if vars_global.ChatServiceRunning then begin
 messageboxW(ares_frmmain.handle,pwidechar(GetLangStringW(STR_YOUR_ARE_ALREADY_HOSTING)+' '+utf8strtowidestr(namech)),
             pwidechar(appname+': '+GetLangStringW(STR_WARNING)),mb_ok+mb_iconexclamation);
exit;
end;
{
if not Wideinputquery(ares_frmmain.left,ares_frmmain.top+ares_frmmain.panel_chat.Top+ares_frmmain.btns_chat.Top+ares_frmmain.btn_chat_host.top,
                      GetLangStringW(STR_HOST_A_CHANNEL),GetLangStringW(STR_CHANNEL_NAME),namech) then begin
                     exit;
                    end;
 }



if length(namech)<MIN_CHAT_NAME_LEN then begin
 messageboxW(ares_frmmain.handle,pwidechar(GetLangStringW(STR_WRONG_NAME)+CRLF+GetLangStringW(STR_PLEASE_CHOSE_ANOTHER_NAME)),pwidechar(appname+': '+GetLangStringW(STR_WARNING)),mb_ok+mb_iconexclamation);
 exit;
end;
if length(namech)>MAX_CHAT_NAME_LEN then delete(namech,MAX_CHAT_NAME_LEN+1,length(namech));
for i:=1 to length(namech) do if namech[i]=' ' then namech[i]:='_';


// get channelPort value from ChatConf.txt
TempPort:=GetHostChannelPort(-1);
if TempPort=-1 then begin
 reg:=TRegistry.create;  // try to get port from previous registry values
 with reg do begin
  openkey(areskey,true);
  if valueExists('ChatRoom.ServerPort') then TempPort:=readInteger('ChatRoom.ServerPort');
  closekey;
  destroy;
 end;
end;
if TempPort<1 then TempPort:=5000
 else
if TempPort>65535 then TempPort:=5000;



if not fileexistsW(app_path+'\Data\ChatConf.txt') then stream:=MyfileOpen(app_path+'\Data\ChatConf.txt',ARES_OVERWRITE_EXISTING)
 else stream:=MyfileOpen(app_path+'\Data\ChatConf.txt',ARES_WRITE_EXISTING);
 stream.seek(0,soFromEnd);
 str:='ChannelName= '+widestrtoutf8str(namech)+CRLF+
      'ChannelPort= '+inttostr(TempPort)+CRLF+
      'ChannelLanguage= '+ vars_localiz.getDefLang +CRLF+
      helper_ares_cacheservers.cache_get_chathosts;
 stream.write(str[1],length(str));
FreeHandleStream(stream);

try
uxpfirewall.OpenPort(TempPort);
except
end;

serMngr:=TServiceManager.create;
if not serMngr.Connect then begin
 serMngr.free;
 exit;
end;

if not serMngr.OpenServiceConnection(pchar('AresChatServer')) then begin
 serMngr.free;
 exit;
end;

serMngr.UpdateConfig;

tick:=gettickcount;
while (not serMngr.serviceRunning) do begin
 serMngr.StartService;
 sleep(50);
 if gettickcount-tick>SECOND then break;
end;

vars_global.ChatServiceRunning:=serMngr.ServiceRunning;

serMngr.free;

  ares_frmmain.btn_opt_chat_start.enabled:=not vars_global.ChatServiceRunning;
  ares_frmmain.btn_opt_chat_stop.enabled:=vars_global.ChatServiceRunning;
  ares_frmmain.btn_opt_chat_join.enabled:=vars_global.ChatServiceRunning;
  
 reg:=tregistry.create;
 with reg do begin
  openkey(areskey,true);
  WriteInteger('ChatRoom.Running',integer(vars_global.ChatServiceRunning));
  writestring('History.LastHostedChannel',bytestr_to_hexstr(widestrtoutf8str(namech)));
  closekey;
  destroy;
 end;

 joinHostedChannel(nameCh);
end;

procedure JoinHostedChannel;
var
i:integer;
pchan:precord_canale_chat_visual;
reg:TRegistry;
chname:widestring;
begin
for i:=0 to list_chatchan_visual.count-1 do begin
 pchan:=list_chatchan_visual[i];
 if pchan^.ip=16777343 then begin
  ares_frmmain.tabs_pageview.activePage:=IDTAB_CHAT;
  ares_frmmain.panel_chat.ActivePanel:=pchan^.containerPageview;
  exit;
 end;
end;

 reg:=tregistry.create;
 with reg do begin
  openkey(areskey,true);
  chname:=utf8strtowidestr(hexstr_to_bytestr(readstring('History.LastHostedChannel')));
  closekey;
  destroy;
 end;

JoinHostedChannel(chname);

for i:=0 to list_chatchan_visual.count-1 do begin
 pchan:=list_chatchan_visual[i];
 if pchan^.ip=16777343 then begin
  ares_frmmain.tabs_pageview.activePage:=IDTAB_CHAT;
  ares_frmmain.panel_chat.ActivePanel:=pchan^.containerPageview;
  exit;
 end;
end;
end;

function GetHostChannelPort(DefaultValue:integer):integer;
var
 tof:Textfile;
 lineStr,varName,varValue:string;
begin
result:=defaultValue;


if not FileExistsW(app_path+'\Data\ChatConf.txt') then exit;

SetCurrentDirectoryW(pwidechar(app_path+'\Data'));
assignfile(tof,'chatconf.txt');
reset(tof);


while (not eof(tof)) do begin

 readln(tof,lineStr);
 linestr:=trim(lineStr);

 if pos('#',linestr)=1 then continue;
 if length(lineStr)=0 then continue;

 varName:=lowercase(copy(linestr,1,pos('=',linestr)-1));
 if length(varName)=0 then continue;

 varValue:=trim(copy(linestr,pos('=',linestr)+1,length(linestr)));
 if length(varValue)=0 then continue;

 if varName='channelport' then begin
  result:=strtointdef(varValue,5000);
  break;
 end;

end;

closefile(tof);
end;

procedure JoinHostedChannel(nameCh:widestring);
var
pcanale:precord_canale_chat_visual;
begin
 Pcanale:=channel_create_visuals(namech,'');
 with pcanale^ do begin
  ip:=16777343;
  port:=GetHostChannelPort(5000);
  support_pvt:=true;
  support_files:=true;
  out_text:=tmystringlist.create;
  just_created:=true;
  alt_ip:=LanIPC;
  should_exit:=false;
 end;
 list_chatchan_visual.add(pcanale);


  ares_frmmain.panel_chat.activepage:=ares_frmmain.panel_chat.PanelsCount-1;
  mainGui_togglechats(pcanale, false, false,nil);

  helper_chatroom_gui.out_text_memo(pcanale^.memo,COLORE_NOTIFICATION,'',GetLangStringW(STR_CONNECTING_PLEASE_WAIT));

 if vars_global.client_chat=nil then vars_global.client_chat:=tthread_client_chat.create(false);
end;



function color_irc_to_color(const colorin:widestring):tcolor;
const
 arconv:array[0..15] of tcolor = ($00FEFFFF,
                                  clblack,
                                  clnavy,
                                  clgreen,
                                  clred,
                                  clmaroon,
                                  clpurple,
                                  $000080FF,
                                  clyellow,
                                  cllime,
                                  clteal,
                                  claqua,
                                  clblue,
                                  clfuchsia,
                                  clgray,
                                  clsilver);
var
num:integer;
begin
num:=strtointdef(colorin,0);

 if ((num<0) or
     (num>high(arconv))) then begin
  result:=clblack;
  exit;
 end;

result:=tcolor(arconv[num]);

{
case num of
 0:result:=$00FEFFFF;
 1:result:=clblack;
 2:result:=clnavy;
 3:result:=clgreen;
 4:result:=clred;
 5:result:=clmaroon;
 6:result:=clpurple;
 7:result:=$000080FF;
 8:result:=clyellow;
 9:result:=cllime;
 10:result:=clteal;
 11:result:=claqua;
 12:result:=clblue;
 13:result:=clfuchsia;
 14:result:=clgray;
 15:result:=clsilver else result:=clblack;
end;  }

end;



function convert_command_color_str(const text:widestring):widestring;
var
i:integer;
begin                       //entra chr(2)+intero(ascii) numero + due interi(ascii) numero
i:=1;                       //esce chr(comando) + due interi(ascii) numero
result:='';
 repeat
  if i>length(text) then break;
   if text[i]=chr(2) then begin
      if length(text)<i+1 then break;  //security over malformed
    result:=result+
            chr(strtointdef(text[i+1],2));
    inc(i,2);
   end else begin
    result:=result+text[i];
    inc(i);
   end;
  until (not true);

end;

function strip_color_string(const text:widestring; var stripped:boolean):widestring;
const
arconv:array[0..9] of byte = (1,1,
                              1,3,1,3,1,1,1,1);
var
i:integer;
num:integer;
begin
stripped:=false;

i:=1;
result:='';
 while i<=length(text) do begin
    num:=integer(text[i]);
    if num>high(arconv) then begin
     result:=result+text[i];
     inc(i);
     continue;
    end;

    stripped:=true;

    inc(i,arconv[num]);

   { case num of
     2:inc(i);
     3:inc(i,3);
     4:inc(i);
     5:inc(i,3);
     6:inc(i);
     7:inc(i);
     8:inc(i);
     9:inc(i) else inc(i);
    end; }
 end;

end;

function emoticonstr_to_index(const str:string; var lung:integer):integer;
begin
 lung:=3;
 result:=-1;

if pos(':',str)=1 then begin
 if pos('-)',str)=2 then result:=0 else
  if pos(')',str)=2  then begin
                           result:=0;
                           lung:=2;
                          end else
   if pos('D',str)=2  then begin
                            result:=1;
                            lung:=2;
                          end else
    if pos('-D',str)=2 then result:=1 else
     if pos('d',str)=2  then begin
                              result:=1;
                              lung:=2;
                             end else
      if pos('-O',str)=2 then result:=3 else
       if pos('O',str)=2  then begin
                                result:=3;
                                lung:=2;
                               end else
        if pos('o',str)=2  then begin
                                 result:=3;
                                 lung:=2;
                                end else
         if pos('-P',str)=2 then result:=4 else
          if pos('-p',str)=2 then result:=4 else
           if pos('-@',str)=2 then result:=6 else
            if pos('P',str)=2  then begin
                                    result:=4;
                                    lung:=2;
                                    end else
             if pos('p',str)=2  then begin
                                     result:=4;
                                     lung:=2;
                                     end else
              if pos('@',str)=2  then begin
                                      result:=6;
                                      lung:=2;
                                      end else
               if pos('$',str)=2  then begin
                                       result:=7;
                                       lung:=2;
                                       end else
                if pos('-$',str)=2 then result:=7 else
                 if pos('-S',str)=2 then result:=8 else
                  if pos('S',str)=2  then begin
                                          result:=8;
                                          lung:=2;
                                          end else
                   if pos('s',str)=2  then begin
                                           result:=8;
                                           lung:=2;
                                           end else
                    if pos('-(',str)=2 then result:=9 else
                     if pos('(',str)=2  then begin
                                             result:=9;
                                             lung:=2;
                                             end else
                      if pos('''(',str)=2 then result:=10 else
                       if pos('-|',str)=2  then result:=11 else
                        if pos('|',str)=2   then begin
                                                 result:=11;
                                                 lung:=2;
                                                 end else
                         if pos('-[',str)=2  then result:=42 else
                           if pos('[',str)=2 then begin
                                                  result:=42;
                                                  lung:=2;
                                                  end;
   end else
   if pos('(',str)=1 then begin
      if pos('H)',str)=2 then result:=5 else
       if pos('h)',str)=2 then result:=5 else
        if pos('6)',str)=2 then result:=12 else
         if pos('A)',str)=2 then result:=13 else
          if pos('a)',str)=2 then result:=13 else
           if pos('L)',str)=2 then result:=14 else
            if pos('l)',str)=2 then result:=14 else
             if pos('U)',str)=2 then result:=15 else
              if pos('u)',str)=2 then result:=15 else
               if pos('M)',str)=2 then result:=16 else
                if pos('m)',str)=2 then result:=16 else
                 if pos('@)',str)=2 then result:=17 else
                  if pos('&)',str)=2 then result:=18 else
                   if pos('S)',str)=2 then result:=19 else
                    if pos('*)',str)=2 then result:=20 else
                     if pos('~)',str)=2 then result:=21 else
                      if pos('E)',str)=2 then result:=22 else
                       if pos('e)',str)=2 then result:=22 else
                        if pos('8)',str)=2 then result:=23 else
                         if pos('F)',str)=2 then result:=24 else
                          if pos('f)',str)=2 then result:=24 else
                           if pos('W)',str)=2 then result:=25 else
                            if pos('w)',str)=2 then result:=25 else
                             if pos('O)',str)=2 then result:=26 else
                              if pos('o)',str)=2 then result:=26 else
                               if pos('K)',str)=2 then result:=27 else
                                if pos('k)',str)=2 then result:=27 else
                                 if pos('G)',str)=2 then result:=28 else
                                  if pos('g)',str)=2 then result:=28 else
                                   if pos('^)',str)=2 then result:=29 else
                                    if pos('P)',str)=2 then result:=30 else
                                     if pos('p)',str)=2 then result:=30 else
                                      if pos('I)',str)=2 then result:=31 else
                                       if pos('i)',str)=2 then result:=31 else
                                        if pos('C)',str)=2 then result:=32 else
                                         if pos('c)',str)=2 then result:=32 else
                                          if pos('T)',str)=2 then result:=33 else
                                           if pos('t)',str)=2 then result:=33 else
                                            if pos('{)',str)=2 then result:=34 else
                                             if pos('})',str)=2 then result:=35 else
                                              if pos('B)',str)=2 then result:=36 else
                                               if pos('b)',str)=2 then result:=36 else
                                                if pos('D)',str)=2 then result:=37 else
                                                 if pos('d)',str)=2 then result:=37 else
                                                  if pos('Z)',str)=2 then result:=38 else
                                                   if pos('z)',str)=2 then result:=38 else
                                                    if pos('X)',str)=2 then result:=39 else
                                                     if pos('x)',str)=2 then result:=39 else
                                                      if pos('Y)',str)=2 then result:=40 else
                                                       if pos('y)',str)=2 then result:=40 else
                                                        if pos('N)',str)=2 then result:=41 else
                                                         if pos('n)',str)=2 then result:=41 else
                                                          if pos('1)',str)=2 then result:=43 else
                                                           if pos('2)',str)=2 then result:=44 else
                                                            if pos('3)',str)=2 then result:=45 else
                                                             if pos('4)',str)=2 then result:=46;
   end else
   if str='=)'  then begin
                     result:=0;
                     lung:=2;
                     end else
    if str=';-)' then result:=2 else
     if str=';)'  then begin
                       result:=2;
                       lung:=2;
                       end else
      if str='8-)' then result:=5 else
       if str='B-)' then result:=5;


end;


function colorRTtoTColor(col:byte):tcolor;
const
 arconv:array[0..16] of tcolor = (clblack,
                                  clblack,
                                  clmaroon,
                                  clgreen,
                                  $000080ff,
                                  clnavy,
                                  clpurple,
                                  clteal,
                                  clgray,
                                  clsilver,
                                  clred,
                                  cllime,
                                  clyellow,
                                  clblue,
                                  clfuchsia,
                                  claqua,
                                  clwhite);
begin

if col>high(arconv) then begin
 result:=clblack;
 exit;
end;

result:=arconv[col];

{
case col of
 1:result:=clblack;
 2:result:=clmaroon;
 3:result:=clgreen;
 4:result:=$000080ff;
 5:result:=clnavy;
 6:result:=clpurple;
 7:result:=clteal;
 8:result:=clgray;
 9:result:=clsilver;
 10:result:=clred;
 11:result:=cllime;
 12:result:=clyellow;
 13:result:=clblue;
 14:result:=clfuchsia;
 15:result:=claqua;
 16:result:=clwhite
  else result:=clblack;
end; }
end;

function ColorAresToRTColor(col:byte):byte;
const
 arconv:array[0..15] of byte = (16,
                                1,
                                5,
                                3,
                                10,
                                2,
                                6,
                                4,
                                12,
                                11,
                                7,
                                15,
                                13,
                                14,
                                8,
                                9);
begin
if col>high(arconv) then col:=0;

result:=arconv[col];

{
  case col of
    1 : Result := 1; //black
    5 : Result := 2;  //maroon
    3 : Result := 3; //green
    7 : Result := 4;  //doh 0080ff  orange
    2 : Result := 5; //navy
    6 : Result := 6;   //purple
    10: Result := 7; //teal
    14: Result := 8;  //gray
    15: Result := 9;    //silver
    4 : Result := 10; //red
    9 : Result := 11;  //lime
    8 : Result := 12;    //yellow
    12: Result := 13;  //blue
    13: Result := 14;    //fuchsia
    11: Result := 15; //aqua
    0 : Result := 16;//white
  else
    Result := 16;
  end;  }
end;




end.
