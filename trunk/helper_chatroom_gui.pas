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
handles visual output of chat code chatroom client/server and private chat
}

unit helper_chatroom_gui;

interface

uses
 ares_types,classes,classes2,windows,graphics,imglist,controls,jvrichedit,comettopicpnl,xpbutton,
 sysutils,TntComCtrls,TntExtCtrls,TntStdCtrls,forms,StdCtrls,comettrees,ExtCtrls,helper_chatroom,
 tntwindows,cometpageview;

function channel_create_visuals(nome:widestring; chtopic:string):precord_canale_chat_visual;
procedure canvas_draw_chat_text(acanvas:tcanvas; x,y:integer; cliprect:trect; widestr:widestring; forecolor,backcolor:tcolor;  bold,underline,italic:boolean);
procedure out_text_memo(memo:TjvRichEdit; colore:tcolor; utente:widestring; S:widestring; urldetect:boolean = true);
procedure canvas_draw_topic(ACanvas:TCanvas; cellrect:Trect; imglist:Timagelist; widestr:widestring; forecolor,backcolor,forecolor_gen,backcolor_gen:TColor; offsetxiniz:integer);
procedure write_topic_chat(precord_chat:precord_canale_chat_visual);
function add_img_rtc(imagelist:timagelist; imgindex:integer; coloresfondo:tcolor):string;
function pvt_chat_destroy(pcanale:precord_canale_chat_visual; pvt_chat:precord_pvt_chat_visual):boolean;//qualcuno ha premuto su chiudi

procedure assign_chatroom_tabimg(pcanale:precord_canale_chat_visual; stato:boolean);
function new_chatroom_pvt(pcanale:precord_canale_chat_visual; da :string; crcda:word; alwaysopen:boolean; blockSwitch:boolean):precord_pvt_chat_visual;
procedure chatroom_pvt_eventerror(pcanale:precord_canale_chat_visual;  da:string; crcda:word; testo:string);
procedure chatroom_pvt_event(pcanale:precord_canale_chat_visual; da:string; crcda:word; testo:string);
function create_browse_panel(pcanale:precord_canale_chat_visual; nicks:string; ip_userc,ip_serverc,ip_altc:cardinal; port_userw,port_serverw:word; strrandom:string):precord_pannello_browse_chat;
function create_result_panel(pcanale:ares_types.precord_canale_chat_visual; randomstring:string; search_str:widestring):ares_types.precord_pannello_result_chat;
procedure mainGui_popup_searchresult_event;
procedure mainGui_chatoomBrowse_event;//browse pubblico chat
procedure mainGui_sendprivate_fromresult;
procedure mainGui_chat_fromresult;
procedure mainGui_chat_frombrowse;
procedure mainGui_sendprivate_frombrowse;
procedure mainGui_ClearChatroomScreen;
procedure btn_chat_emocittrigger(toadd:String);
procedure mainGui_copytoclipboard;
procedure mainGui_openinnotepad;
procedure mainGui_chatselectall;
procedure clear_visuals_chat_hosted;//in synch
procedure chatroom_trigger_GUIban;
procedure chatroom_trigger_GUIunban;
procedure chatroom_trigger_ignore;
procedure chatroom_trigger_muzzle;
procedure chatroom_trigger_unmuzzle;
procedure setFocus;
procedure FreeAllPrivates(pcanale:precord_canale_chat_visual);
procedure detachChatBrowses(pcanale:precord_canale_chat_visual);
procedure detachChatSearches(pcanale:precord_canale_chat_visual);
procedure hide_chat_tabs;
procedure show_chat_tabs;

procedure mainGui_banevent_frombrowse;
procedure mainGui_killevent_frombrowse;
procedure mainGui_killevent_fromsearch;
procedure mainGui_banevent_fromsearch;

implementation

uses
 ufrmmain,vars_global,helper_unicode,vars_localiz,const_ares,
 helper_strings,utility_ares,helper_ipfunc,helper_private_chat,
 helper_visual_headers,helper_combos,helper_diskio,
 helper_stringfinal,const_timeouts,
 ufrmChatTab;

procedure hide_chat_tabs;
var
 i:integer;
 form:TfrmChatTab;
begin

for i:=0 to vars_global.chatTabs.count-1 do begin
 form:=chatTabs[i];
 ShowWindow(form.handle,SW_HIDE);
end;

end;

procedure show_chat_tabs;
var
 i:integer;
 form:TfrmChatTab;
begin

for i:=0 to vars_global.chatTabs.count-1 do begin
 form:=chatTabs[i];
 ShowWindow(form.handle,SW_SHOW);
end;

end;

procedure setFocus;
var
i:integer;
pcanale:precord_canale_chat_visual;
point:TPoint;
begin
try

if ares_frmmain.panel_chat.ActivePage=0 then begin

 GetCursorPos(point);
 ScreenToClient(ares_frmmain.listview_chat_channel.handle,point);
 if (point.x>=0) and
    (point.x<=ares_frmmain.listview_chat_channel.width) and
    (point.y>=0) and
    ((point.y<=ares_frmmain.listview_chat_channel.height) or (not ares_frmmain.pnl_chat_fav.visible)) then begin
     if ares_frmmain.listview_chat_channel.canfocus then ares_frmmain.listview_chat_channel.SetFocus;
    end else begin
     if ares_frmmain.treeview_chat_favorites.canfocus then ares_frmmain.treeview_chat_favorites.setfocus;
    end;

end else begin

 for i:=0 to list_chatchan_visual.count-1 do begin
 pcanale:=list_chatchan_visual[i];
 if ares_frmmain.panel_chat.activepanel<>pcanale^.containerPageview then continue;
  GetCursorPos(point);
  ScreenToClient(pcanale^.memo.handle,point);
  if point.x<pcanale^.memo.width then begin
   if pcanale^.memo.canfocus then pcanale^.memo.SetFocus;
  end else begin
   if pcanale^.listview.canfocus then pcanale^.listview.SetFocus;
  end;
  break;
 end;

end;

except
end;
end;

procedure chatroom_trigger_unmuzzle;
var
Data:precord_displayed_chat_user;
pcanale:precord_canale_chat_visual;
nodo:PCmtVNode;
pnl:TCometPagePanel;
begin
try

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 pcanale:=pnl.fdata;

  if not pcanale^.ModLevel then exit;
   nodo:=pcanale^.listview.getfirstselected;
   if nodo=nil then exit;
   data:=pcanale^.listview.getdata(nodo);
  pcanale^.out_text.Add('/unmuzzle '+data^.nick);


  except
  end;
end;

procedure chatroom_trigger_muzzle;
var
Data:precord_displayed_chat_user;
pcanale:precord_canale_chat_visual;
nodo:PCmtVNode;
pnl:TCometPagePanel;
begin
try

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 pcanale:=pnl.fdata;

  if not pcanale^.ModLevel then exit;
   nodo:=pcanale^.listview.getfirstselected;
   if nodo=nil then exit;
   data:=pcanale^.listview.getdata(nodo);
  pcanale^.out_text.Add('/muzzle '+data^.nick);


  except
  end;
end;


procedure chatroom_trigger_ignore;
var
Data:precord_displayed_chat_user;
pcanale:precord_canale_chat_visual;
nodo:PCmtVNode;
pnl:TCometPagePanel;
begin
try

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 if pnl.ID<>IDXChatMAIN then exit;
 pcanale:=pnl.fdata;

  //if pcanale^.ModLevel then exit;
   nodo:=pcanale^.listview.getfirstselected;
   if nodo=nil then exit;
   data:=pcanale^.listview.getdata(nodo);
   data^.ignored:=not data^.ignored;
     if data^.ignored then pcanale^.out_text.Add('/ignore '+data^.nick) else
     pcanale^.out_text.Add('/unignore '+data^.nick);
   pcanale^.listview.invalidatenode(nodo);


  except
  end;
end;

procedure chatroom_trigger_GUIunban;
var
Data:precord_displayed_chat_user;
pcanale:precord_canale_chat_visual;
nodo:PCmtVNode;
pnl:TCometPagePanel;
begin
try

  pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 pcanale:=pnl.fdata;

  if not pcanale^.ModLevel then exit;
   nodo:=pcanale^.listview.getfirstselected;
   if nodo=nil then exit;
   data:=pcanale^.listview.getdata(nodo);
   pcanale^.out_text.Add('/unban '+data^.nick);


  except
  end;
end;

procedure chatroom_trigger_GUIban;
var
Data:precord_displayed_chat_user;
pcanale:precord_canale_chat_visual;
nodo:PCmtVNode;
pnl:TCometPagePanel;
begin
try

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 pcanale:=pnl.fdata;

  if not pcanale^.ModLevel then exit;
   nodo:=pcanale^.listview.getfirstselected;
   if nodo=nil then exit;
   data:=pcanale^.listview.getdata(nodo);
   pcanale^.out_text.Add('/ban '+data^.nick);

  except
  end;
end;

procedure clear_visuals_chat_hosted;//in synch
var
i:integer;
rcanale:precord_canale_chat_visual;
pvt_chat:precord_pvt_chat_visual;
//pannello_result:precord_pannello_result_chat;
//pannello_browse:precord_pannello_browse_chat;
//pfile:precord_file_library;
begin
try

 for i:=0 to list_chatchan_visual.count-1 do begin
  rcanale:=list_chatchan_visual[i];

  if rcanale^.ModLevel then begin
  try


    try

    if rcanale^.lista_pvt<>nil then begin
      while (rcanale^.lista_pvt.count>0) do begin //i visuali sono eliminati da free di pagecontrol
       pvt_chat:=rcanale^.lista_pvt[0];
       rcanale^.lista_pvt.delete(0);
       pvt_chat^.nickname:='';
       if pvt_chat^.frmTab<>nil then pvt_chat^.frmTab.release;
       FreeMem(pvt_chat,sizeof(record_pvt_chat_visual));
      end;
     rcanale^.lista_pvt.free;
    end;

    except
    end;

   {
   try
   if rcanale^.lista_pannelli_result<>nil then begin
     while (rcanale^.lista_pannelli_result.count>0) do begin
      pannello_result:=rcanale^.lista_pannelli_result[0];
      rcanale^.lista_pannelli_result.delete(0);
      pannello_result^.randomstr:='';
      FreeMem(pannello_result,sizeof(record_pannello_result_chat));
     end;
    rcanale^.lista_pannelli_result.free;
   end;
   except
   end;

   try
   if rcanale^.lista_pannelli_browse<>nil then begin
     while (rcanale^.lista_pannelli_browse.count>0) do begin
       pannello_browse:=rcanale^.lista_pannelli_browse[0];
         rcanale^.lista_pannelli_browse.delete(0);
         with pannello_browse^ do begin
          randomstr:='';
          nick:='';
         end;
          while (pannello_browse.lista_files.count>0) do begin  // clear files
           pfile:=pannello_browse.lista_files[0];
           pannello_browse.lista_files.delete(0);
             finalize_file_library_item(pfile);
           FreeMem(pfile,sizeof(record_file_library));
          end;
         pannello_browse.lista_files.free;
         FreeMem(pannello_browse,sizeof(record_pannello_browse_chat));
     end;
     rcanale^.lista_pannelli_browse.free;
   end;
   except
   end; }


   try
    rcanale^.containerPageview.free;
    except
    end;


    try
    with rcanale^ do begin
     name:='';
     topic:='';
     out_text.free;
     if frmtab<>nil then frmTab.release;
    end;
    except
    end;

    list_chatchan_visual.delete(i);
    FreeMem(rcanale,sizeof(record_canale_chat_visual));
  except
  end;
    //ares_frmmain.panel_chat.activePage:=ares_frmmain.panel_chat.activepage;
    //ufrmmain.ares_frmmain.btn_list_channel_toolbarClick(ares_frmmain.panel_chat.activepage);
    //ares_frmmain.panel_chat.activepage:=0;
  break;
 end;

 end;

except
end;
end;

procedure mainGui_chatselectall;
var
pcanale:precord_canale_chat_visual;
pvt_chat:precord_pvt_chat_visual;
pnl:TCometPagePanel;
begin

try
 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 case pnl.ID of
    IDXChatMain:begin
           pcanale:=pnl.FData;
           if pcanale.containerPageview.activepage=0 then pcanale^.memo.selectall else begin
            pnl:=pcanale.containerPageview.panels[pcanale.containerPageview.activePage];
            pvt_chat:=pnl.FData;
            pvt_chat^.memo.selectall;
           end;
         end;
 end;

except
end;
end;

procedure mainGui_openinnotepad;
var
i:integer;
stream:thandlestream;
nomefile:widestring;
str:string;
pcanale:precord_canale_chat_visual;
buffer:array[0..1023] of char;
memo:TjvRichEdit;
pvt_chat:precord_pvt_chat_visual;
pnl:TCometPagePanel;
begin

try
memo:=nil;


 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 case pnl.ID of
    IDXChatMain:begin
           pcanale:=pnl.FData;
           if pcanale.containerPageview.activepage=0 then memo:=pcanale^.memo else begin
            pnl:=pcanale.containerPageview.panels[pcanale.containerPageview.activePage];
            pvt_chat:=pnl.FData;
            memo:=pvt_chat^.memo;
           end;
         end;
 end;


  if memo=nil then exit;//non ho trovato memo???

  
       tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);
       nomefile:=formatdatetime('mm-dd-yyyy hh.nn.ss',now)+' chat temp.txt';



      stream:=MyFileOpen(data_path+'\Temp\'+nomefile,ARES_CREATE_ALWAYSAND_WRITETHROUGH);
      if stream=nil then exit;

        for i:=0 to memo.lines.count-1 do begin
         str:=widestrtoutf8str(memo.lines.strings[i])+CRLF;
          move(str[1],buffer,length(str));
          stream.write(buffer,length(str));
        end;
       FreeHandleStream(stream);
     Tnt_ShellExecuteW(ares_frmmain.handle,'open',pwidechar(widestring('notepad')),pwidechar(data_path+'\Temp\'+nomefile),nil,SW_SHOW);


except
end;
end;

procedure mainGui_copytoclipboard;
var
pcanale:precord_canale_chat_visual;
pvt_chat:precord_pvt_chat_visual;
pnl:TCometPagePanel;
begin

try
  pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];

 case pnl.ID of
   IDXChatMain:begin
           pcanale:=pnl.FData;
           if pcanale.containerPageview.activepage=0 then pcanale^.memo.CopyToClipboard else begin
            pnl:=pcanale.containerPageview.panels[pcanale.containerPageview.activePage];
            pvt_chat:=pnl.FData;
            pvt_chat^.memo.CopyToClipboard;
           end;
         end;
 end;

except
end;


end;

procedure mainGui_ClearChatroomScreen;
var
pcanale:precord_canale_chat_visual;
memo:TjvRichEdit;
edit:ttntedit;
pvt_chat:precord_pvt_chat_visual;
pnl:TCometPagePanel;
begin
try
memo:=nil;    //ClearScreen1STR_CLEARSSCREEN
edit:=nil;

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 case pnl.ID of
    IDXChatMain:begin
           pcanale:=pnl.FData;
           if pcanale.containerPageview.activepage=0 then begin
            memo:=pcanale^.memo;
            edit:=pcanale^.edit_chat;
           end else begin
            pnl:=pcanale.containerPageview.panels[pcanale.containerPageview.activePage];
            pvt_chat:=pnl.FData;
            memo:=pvt_chat^.memo;
            edit:=pvt_chat^.edit_chat;
           end;
         end;
 end;

  if memo=nil then exit;
  if edit=nil then exit;

         with memo do begin
           Lines.BeginUpdate;
          clear;
           lines.EndUpdate;
         end;

          try
          edit.setfocus;
          except
          end;

except
end;
end;

procedure mainGui_sendprivate_frombrowse;
var
pcanale:precord_canale_chat_visual;
pannello_browse:precord_pannello_browse_chat;
//pvt_chat:precord_pvt_chat_visual;
pnl:TCometPagePanel;
begin
try


   pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
   if pnl.ID<>IDXChatBrowse then exit;

   pannello_browse:=pnl.fdata;

   if pannello_browse.canale=nil then exit;

   pcanale:=pannello_browse.canale;
   


   // pvt_chat:=
    new_chatroom_pvt(pcanale,pannello_browse^.nick,stringcrc(pannello_browse^.nick,true),true,false);


except
end;
end;

procedure mainGui_chat_frombrowse;
var
pannello_browse:precord_pannello_browse_chat;
pnl:TCometPagePanel;
ips:string;
begin
try

   pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
   if pnl.ID<>IDXChatBrowse then exit;

   pannello_browse:=pnl.fdata;


   ips:=ipint_to_dotstring(pannello_browse^.ip_user);

   chat_with_user(ips,
                  pannello_browse^.port_user,
                  pannello_browse^.ip_alt,
                  pannello_browse^.ip_server,
                  pannello_browse^.port_server,
                  pannello_browse^.nick);


except
end;
end;

procedure mainGui_chat_fromresult;
var
data:precord_file_result_chat;
pannello_result:precord_pannello_result_chat;
z:integer;
nodo:pCmtVnode;
ips:string;
nick:String;
pnl:TCometPagePanel;
begin

 if gettickcount-last_chat_req<DELAY_BETWEEN_RECHAT_REQUEST then exit;  //antiflood silvy
 last_chat_req:=gettickcount;

try

pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
if pnl.ID<>IDXChatSearch then exit;
pannello_result:=pnl.FData;


          nodo:=pannello_result^.listview.GetFirstSelected;
          if nodo=nil then exit;
            data:=pannello_result^.listview.getdata(nodo);

            nick:=data^.nickname;   //togliamo @ del client da result se sono con client_chat e ho client indicato nel nick
            if length(data^.client)=0 then begin
             for z:=length(nick) downto 1 do
               if nick[z]=chr(64){'@'} then begin
                 nick:=copy(nick,1,z-1);
                break;
              end;
            end;
            if nick='' then exit;

             ips:=ipint_to_dotstring(data^.ip_user);
             
             chat_with_user(ips,
                           data^.port_user,
                           data^.ip_alt,
                           data^.ip_server,
                           data^.port_server,
                           nick);

except
end;
end;

procedure mainGui_sendprivate_fromresult;
var
pcanale:precord_canale_chat_visual;
pannello_result:precord_pannello_result_chat;
z:integer;
nodo:pCmtVnode;
//pvt_chat:precord_pvt_chat_visual;
data:precord_file_result_chat;
nick:string;
pnl:TCometPagePanel;
begin
try

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 if pnl.ID<>IDXChatSearch then exit;
 pannello_result:=pnl.fData;
 
 if pannello_result.canale=nil then exit;
 pcanale:=pannello_result.canale;


          nodo:=pannello_result^.listview.GetFirstSelected;
          if nodo=nil then exit;
            data:=pannello_result^.listview.getdata(nodo);

            nick:=data^.nickname;   //togliamo @ del client da result se sono con client_chat e ho client indicato nel nick
            if length(data^.client)=0 then begin
             for z:=length(nick) downto 1 do
               if nick[z]=chr(64){'@'} then begin
                 nick:=copy(nick,1,z-1);
                break;
              end;
            end;
            if nick='' then exit;

           // pvt_chat:=
            new_chatroom_pvt(pcanale,nick,stringcrc(nick,true),true,false);

 except
 end;
end;

procedure mainGui_chatoomBrowse_event;//browse pubblico chat
var
pcanale:precord_canale_chat_visual;
nodo,nodo_file:pCmtVnode;
data:precord_displayed_chat_user;
strrandom:string;
pannello_browse:precord_pannello_browse_chat;

data_file:precord_file_library;
pnl:TCometPagePanel;
begin

pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
pcanale:=pnl.fdata;

    nodo:=pcanale^.listview.getfirstselected;
    if nodo=nil then exit;

      data:=pcanale^.listview.getdata(nodo);
      if not data^.support_files then exit;
       strrandom:=chr(random(255))+
                  chr(random(255));
      //ok ora aggiungiamo comando
    pcanale^.out_text.Add('/browse '+strrandom+chr(browse_type)+data^.nick+CHRNULL);

    lockwindowupdate(ares_frmmain.handle);
    try
     pannello_browse:=create_browse_panel(pcanale,data^.nick,data^.ip,data^.ip_server,data^.ip_alt,data^.port,data^.port_server,strrandom);
     except
      lockwindowupdate(0);
      exit;
     end;
    lockwindowupdate(0);

    pannello_browse^.stato_header_library:=library_header_browse_in_prog;
     nodo_file:=pannello_browse^.listview.addchild(nil);
      data_file:=pannello_browse^.listview.getdata(nodo_file);
      data_file^.title:=GetLangStringA(STR_BROWSEINPROGRESS)+' '+GetLangStringA(STR_PLEASE_WAIT);
      pannello_browse^.listview.invalidatenode(nodo_file);


end;


procedure mainGui_popup_searchresult_event;
var
pannello_result:precord_pannello_result_chat;
pcanale:precord_canale_chat_visual;
nodo,nodo_user:pCmtVnode;
data_user:precord_displayed_chat_user;//
pnl:TCometPagePanel;
begin

pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
if pnl.ID<>IDXChatSearch then exit;
pannello_result:=pnl.fdata;


   with ares_frmmain do begin

    N8.visible:=false;
    Ban2.visible:=false;
    Kill1.visible:=false;
    Chat4.visible:=true;
    N21.Visible:=true;
   // N21.Visible:=false;


   if pannello_result.canale=nil then begin
    Browse2.visible:=false;
    Sendprivate1.visible:=false;
    Ban2.visible:=false;
    Kill1.visible:=false;
    exit;
   end else begin
    Browse2.visible:=true;
    Sendprivate1.visible:=true;
   end;


   pcanale:=pannello_result.canale;

   nodo:=pannello_result^.listview.getfirstselected;
   if nodo=nil then exit;
   if nodo.childcount>0 then exit;//è un parent...zero bans/kill...


        ////////////////////////////////////////////////////////////////////////////
         // vediamo se supporta browse... troviamo utente da result a lista utenti in chat
          nodo_user:=pcanale^.listview.getfirst;
          while (nodo_user<>nil) do begin
           data_user:=pcanale^.listview.getdata(nodo_user);
             if data_user^.support_files then begin //basta il primo per stabilire se l'host supporta il browse
              ares_frmmain.Browse2.visible:=true;
              break;
             end;
           nodo_user:=pcanale^.listview.getnext(nodo_user);
          end;
         //////////////////////////////////////////////////////////////////////7


        N8.visible:=pcanale^.ModLevel;
        Ban2.visible:=pcanale^.ModLevel;
        Kill1.visible:=pcanale^.ModLevel;
      end;


end;



function create_result_panel(pcanale:ares_types.precord_canale_chat_visual; randomstring:string; search_str:widestring):ares_types.precord_pannello_result_chat;
var
NewColumn:TvirtualtreeColumn;
nodo:pCmtVnode;
datao:ares_types.precord_file_result_chat;
i:integer;
begin
result:=AllocMem(sizeof(ares_types.record_pannello_result_chat));

with result^ do begin
  canale:=pcanale;
    if pcanale^.lista_pannelli_result=nil then pcanale^.lista_pannelli_result:=tmylist.create;
    pcanale^.lista_pannelli_result.add(result);


 containerPanel:=tpanel.create(ares_frmmain);
 containerPanel.caption:='';
 containerPanel.BevelOuter:=bvNone;
 
 ares_frmmain.panel_chat.wrappable:=true;
 pnl:=ares_frmmain.panel_chat.AddPanel(IDXChatSearch,search_str,[csDown],containerPanel,result,true,5);

 randomstr:=randomstring;
 countresult:=0;

 listview:=tcomettree.create(result^.containerPanel);
 with listview do begin
   parent:=containerPanel;
   Align:=alclient;
   Tag:=longint(result);//per velocizzare ritrovamento stato header in get node
   ongetsize:=ufrmmain.ares_frmmain.get_size_result_chats;
   ongettext:=ufrmmain.ares_frmmain.get_text_result_chats;
   OnCompareNodes:=ufrmmain.ares_frmmain.resultchatCompareNodes;
   ongetimageindex:=ufrmmain.ares_frmmain.result_chat_get_imageindex;
   onheaderclick:=ufrmmain.ares_frmmain.TreeviewHeaderClick;
   onfreenode:=ufrmmain.ares_frmmain.result_chat_channelfreenode;
   OnCollapsed:=ufrmmain.ares_frmmain.listview_chat_channelCollapsed;
   OnExpanded:=ufrmmain.ares_frmmain.listview_chat_channelCollapsed;
   onpainttext:=ufrmmain.ares_frmmain.result_chat_channelpainttext;
   onPaintHeader:=ufrmmain.ares_frmmain.listview_libPaintHeader;
   PopupMenu:=ares_frmmain.popup_chat_search;
   OnDblClick:=ufrmmain.ares_frmmain.Download2Click;
    ares_frmmain.popup_chat_search.autopopup:=true;
   with treeoptions do begin
    StringOptions:=[];
    selectionoptions:=[toExtendedFocus,toFullRowSelect,toMiddleClickSelect,toRightClickSelect,toCenterScrollIntoView];
      if VARS_THEMED_HEADERS then PaintOptions:=[toShowButtons,toShowRoot,toShowTreeLines, toHotTrack, toThemeAware]
       else PaintOptions:=[toShowButtons,toShowRoot,toShowTreeLines,toHotTrack];
    MiscOptions:=[toInitOnSave];
    Autooptions:=[toAutoScroll];
    animationoptions:=[];
   end;
   
   with header do begin
    Options:=[hoAutoResize,hoColumnResize,hoDrag,hoHotTrack,hoRestrictDrag,hoShowHint,hoShowImages,hoShowSortGlyphs,hoVisible];
    style:=hsFlatButtons;
    background:=COLORE_LISTVIEWS_HEADERBK;
    font.name:=ares_frmmain.font.name;
    font.size:=ares_frmmain.font.size;
    font.color:=COLORE_LISTVIEWS_HEADERFONT;
    height:=21;

   end;

   bevelinner:=bvlowered;
   bevelkind:=bksoft;
   bevelouter:=bvnone;
   borderstyle:=bsnone;
   BevelEdges:=[];//[betop];
   borderwidth:=0;
   ctl3d:=true;
   parentcolor:=false;
   parentfont:=false;
   color:=COLORE_LISTVIEWS_BG;
   bgcolor:=COLORE_ALTERNATE_ROW;
   canbgcolor:=true;
   colors.HotColor:=COLORE_LISTVIEW_HOT;
   Colors.GridLineColor:=COLORE_LISTVIEWS_GRIDLINES;
   Colors.TreeLineColor:=COLORE_LISTVIEWS_TREELINES;
   Colors.BorderColor:=COLORE_LISTVIEWS_HEADERBORDER;
   cursor:=crdefault;
   defaultnodeheight:=18;
   enabled:=true;
   font.name:=ares_frmmain.font.name;
   font.size:=ares_frmmain.font.size;
   font.color:=COLORE_LISTVIEWS_FONT;
   hint:='';
   images:=ares_frmmain.img_mime_small;
   parentbidimode:=false;
   parentctl3d:=false;
   indent:=18;
   margin:=4;
   nodedatasize:=-1;
   rootnodecount:=0;
   tabstop:=true;
  end;

  stato_header:=chat_search_header_inprog;
  tiporicerca:=combo_to_mimetype(ares_frmmain.combo_chat_srctypes);
  is_adding_result:=false;

 for i:=0 to 8 do begin
  NewColumn:=listview.header.Columns.Add;
  with NewColumn do begin
   options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coVisible];
   text:='';
   style:=vstext;
   MaxWidth:=10000;
   Position:=i;
   MinWidth:=0;
   spacing:=0;
   margin:=4;
   width:=0;
   style:=vstext;
   layout:=blglyphleft;
  end;
 end;

 NewColumn:=listview.header.Columns.Add;
 with NewColumn do begin
  options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coVisible];
  text:='';
  style:=vstext;
  MaxWidth:=10000;
  Position:=9;
  MinWidth:=0;
  width:=containerPanel.clientwidth;
  spacing:=0;
  margin:=0;
  style:=vstext;
  layout:=blglyphleft;
 end;

 with listview do begin
  with scrollbaroptions do begin
   alwaysvisible:=false;
   scrollbars:=ssboth;
   scrollbarstyle:=sbmregular;
  end;
  header.autosizeindex:=9;
  selectable:=false;

 nodo:=addchild(nil);
  datao:=getdata(nodo);
  with datao^ do begin
    hash_sha1:='1234567';
    title:=GetLangStringA(STR_SEARCHING_THE_NET);
    imageindex:=250;
   end;
   invalidatenode(nodo);
 end;

end;

end;

function pvt_chat_destroy(pcanale:precord_canale_chat_visual; pvt_chat:precord_pvt_chat_visual):boolean;//qualcuno ha premuto su chiudi
var
i:integer;
temp:precord_pvt_chat_visual;
begin
result:=false;

try

if pcanale^.lista_pvt=nil then exit;

for i:=0 to pcanale^.lista_pvt.count-1 do begin
 temp:=pcanale^.lista_pvt[i];
 if temp=pvt_chat then begin
   pcanale^.lista_pvt.delete(i);
   pvt_chat^.nickname:='';
   if pvt_chat^.frmtab<>nil then pvt_chat^.frmTab.release;
   pvt_chat^.containerPanel.free;

   FreeMem(pvt_chat,sizeof(record_pvt_chat_visual));
   if pcanale^.lista_pvt.count=0 then begin
    pcanale^.lista_pvt.free;
    pcanale^.lista_pvt:=nil;
   end;

   result:=true;
   exit;
 end;

end;


except
end;
end;

procedure FreeAllPrivates(pcanale:precord_canale_chat_visual);
var
i,indx:integer;
temp:precord_pvt_chat_visual;
begin
try

if pcanale^.lista_pvt=nil then exit;

i:=0;
while (i<pcanale^.lista_pvt.count) do begin
 temp:=pcanale^.lista_pvt[pcanale^.lista_pvt.count-1];
       pcanale^.lista_pvt.delete(pcanale^.lista_pvt.count-1);

 temp^.nickname:='';

 indx:=pcanale^.containerPageview.GetPagePanelIndex(temp.containerPanel);
 pcanale^.containerPageview.DeletePanel(indx,false);
 
 if temp^.frmtab<>nil then temp^.frmTab.release;
 temp^.containerPanel.free;

 FreeMem(temp,sizeof(record_pvt_chat_visual));
 
   if pcanale^.lista_pvt.count=0 then begin
    pcanale^.lista_pvt.free;
    pcanale^.lista_pvt:=nil;
    exit;
   end;

end;


except
end;
end;

procedure detachChatBrowses(pcanale:precord_canale_chat_visual);
var
 temp:precord_pannello_browse_chat;
begin
try

if pcanale^.lista_pannelli_browse=nil then exit;

while (pcanale^.lista_pannelli_browse.count>0) do begin
 temp:=pcanale^.lista_pannelli_browse[pcanale^.lista_pannelli_browse.count-1];
       pcanale^.lista_pannelli_browse.delete(pcanale^.lista_pannelli_browse.count-1);
 temp.canale:=nil;
end;

pcanale^.lista_pannelli_browse.free;
except
end;
pcanale^.lista_pannelli_browse:=nil;
end;

procedure detachChatSearches(pcanale:precord_canale_chat_visual);
var
 temp:ares_types.precord_pannello_result_chat;
begin
try

if pcanale^.lista_pannelli_result=nil then exit;

 while (pcanale^.lista_pannelli_result.count>0) do begin
   temp:=pcanale^.lista_pannelli_result[pcanale^.lista_pannelli_result.count-1];
         pcanale^.lista_pannelli_result.delete(pcanale^.lista_pannelli_result.count-1);
   temp.canale:=nil;
 end;
pcanale^.lista_pannelli_result.free;
except
end;
pcanale^.lista_pannelli_result:=nil;
end;





function create_browse_panel(pcanale:precord_canale_chat_visual; nicks:string; ip_userc,ip_serverc,ip_altc:cardinal; port_userw,port_serverw:word; strrandom:string):precord_pannello_browse_chat;
var
NewColumn:TvirtualtreeColumn;
i:integer;
begin
result:=AllocMem(sizeof(record_pannello_browse_chat));

 if pcanale^.lista_pannelli_browse=nil then pcanale^.lista_pannelli_browse:=tmylist.create;
  pcanale^.lista_pannelli_browse.add(result);

  with result^ do begin
   canale:=pcanale;
   randomstr:=strrandom;
   lista_files:=tmylist.create;
   nick:=nicks;
   ip_user:=ip_userc;
   port_user:=port_userw;
   ip_server:=ip_serverc;
   port_server:=port_serverw;
   ip_alt:=ip_altc;


 containerPanel:=tpanel.create(ares_frmmain);
 containerPanel.caption:='';
 containerPanel.BevelOuter:=bvNone;
 
 ares_frmmain.panel_chat.wrappable:=true;
 pnl:=ares_frmmain.panel_chat.AddPanel(IDXChatBrowse,utf8strtowidestr(nick),[csDown],containerPanel,result,true,6);

 

   panel_left:=tcomettopicpnl.create(containerPanel);
   with panel_left do begin
    parent:=result^.containerPanel;
    Left:=0;
    Top:=0;
    Width:=0;//partiamo senza dimensione, ci 'allarga' thread_reader on end browse
    Height:=154;
    Align:=alLeft;
    borderstyle:=bsnone;
    bevelinner:=bvnone;//bvraised;
    bevelouter:=bvnone;//bvlowered;
    autosize:=false;
    bevelwidth:=1;
    color:=COLORE_TOOLBAR_BG;
    parentfont:=false;
    font.name:=ares_frmmain.Font.Name;
    font.size:=ares_frmmain.font.size;
    font.color:=COLORE_PANELS_FONT;
    tag:=longint(result);
    onresize:=ufrmmain.ares_frmmain.panel_left_browse_resize;
    onpaint:=ufrmmain.ares_frmmain.panel_playlistPaint;
   end;
    //per prox apertura

   btn_virtual_view:=txpbutton.create(panel_left);
    with btn_virtual_view do begin
     parent:=panel_left;
     left:=5;
     top:=2;
     width:=68;
     height:=21;
     textleft:=6;
     texttop:=3;
     colorbg:=COLORE_TOOLBAR_BG;
     color:=COLORE_TOOLBAR_BG;
     font.name:=ares_frmmain.font.Name;
     font.size:=ares_frmmain.font.size;
     font.color:=COLORE_PANELS_FONT;
     caption:=GetLangStringA(STR_VIRTUAL_VIEW);
     hint:=GetLangStringA(STR_VIRTUAL_VIEW_HINT);
     showhint:=true;
     onclick:=ufrmmain.ares_frmmain.btn_chatbrowse_virtual_viewclick;
     visible:=true;
     down:=true;//di default si mostra prima questo
     tag:=longint(result);
     OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
    end;

   btn_regular_view:=txpbutton.create(panel_left);
    with btn_regular_view do begin
     parent:=panel_left;
     left:=btn_virtual_view.left+btn_virtual_view.width+5;
     top:=2;
     width:=68;
     height:=21;
     textleft:=6;
     texttop:=3;
     colorbg:=COLORE_TOOLBAR_BG;
     color:=COLORE_TOOLBAR_BG;
     font.name:=ares_frmmain.font.Name;
     font.size:=ares_frmmain.font.size;
     font.color:=COLORE_PANELS_FONT;
     caption:=GetLangStringA(STR_REGULAR_VIEW);
     hint:=GetLangStringA(STR_REGULAR_VIEW_HINT);
     showhint:=true;
     onclick:=ufrmmain.ares_frmmain.btn_chatbrowse_regular_viewclick;
     visible:=false;
     tag:=longint(result);
     OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
    end;

  treeview:=tcomettree.create(panel_left);
  with treeview do begin
   parent:=panel_left;
   tag:=longint(result);
   Width:=0;
   Height:=154;
   left:=0;//-10;
   top:=26;
   Align:=albottom;
   BiDiMode:=bdLeftToRight;
   BevelEdges:=[];
   BevelInner:=bvRaised;
   BevelOuter:=bvLowered;
   BevelKind:=bkFlat;
   BGColor:=COLORE_ALTERNATE_ROW;
   colors.HotColor:=COLORE_LISTVIEW_HOT;
   BorderStyle:=bsNone;
   CanBgColor:=False;
   Ctl3D:=True;
   color:=COLORE_LISTVIEWS_BG;
   Colors.GridLineColor:=COLORE_LISTVIEWS_GRIDLINES;
   Colors.TreeLineColor:=COLORE_LISTVIEWS_TREELINES;
   Font.Charset:=DEFAULT_CHARSET;
   Font.name:=ares_FrmMain.font.name;
   font.size:=ares_frmmain.font.size;
   font.color:=COLORE_LISTVIEWS_FONT;
   with header do begin
    AutoSizeIndex:=0;
    Font.name:=ares_FrmMain.font.name;
    font.size:=ares_frmmain.font.size;
    font.color:=ares_frmmain.font.color;
    Height:=21;
    Options:=[hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoRestrictDrag, hoShowHint, hoShowImages];
   end;
   Images:=ares_FrmMain.img_mime_small;
   ParentBiDiMode:=False;
   ParentCtl3D:=False;
   ParentFont:=False;
   ParentShowHint:=False;
   Selectable:=True;
   ShowHint:=True;
   TabOrder:=2;
   with treeoptions do begin
    AutoOptions:=[toAutoScroll];
    MiscOptions:=[toInitOnSave];
    if VARS_THEMED_HEADERS then PaintOptions:=[toShowButtons, toShowTreeLines, toThemeAware]
     else PaintOptions:=[toShowButtons, toShowTreeLines];
    SelectionOptions:=[toExtendedFocus, toMiddleClickSelect, toRightClickSelect];
    StringOptions:=[];
   end;
   OnClick:=ufrmmain.ares_frmmain.treeviewbrowseClick;
   OnCompareNodes:=ufrmmain.ares_frmmain.treeviewbrowseCompareNodes;
   OnFreeNode:=ufrmmain.ares_frmmain.treeviewbrowseFreeNode;
   OnGetText:=ufrmmain.ares_frmmain.treeviewbrowseGetText;
   OnGetImageIndex:=ufrmmain.ares_frmmain.treeviewbrowseGetImageIndex;
   OnGetSize:=ufrmmain.ares_frmmain.treeviewbrowseGetSize;
   OnKeyUp:=ufrmmain.ares_frmmain.treeviewbrowseKeyUp;
   OnMouseUp:=ufrmmain.ares_frmmain.treeviewbrowseMouseUp;
   defaulttext:=' ';
  end;

   NewColumn :=treeview.header.Columns.Add;
   with NewColumn do begin
     options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coVisible];
     width:=148;
     Position:=0;
     spacing:=0;
     margin:=0;
   end;

       //ora regular folder
  treeview2:=tcomettree.create(panel_left);
  with treeview2 do begin
   tag:=longint(result);
   parent:=panel_left;
   Width:=0;
   Height:=154;
   left:=0;//-10;
   top:=26;
   Align:=albottom;
   visible:=false;
   BiDiMode:=bdLeftToRight;
   BevelEdges:=[];
   BevelInner:=bvRaised;
   BevelOuter:=bvLowered;
   BevelKind:=bkFlat;
   BGColor:=COLORE_ALTERNATE_ROW;
   colors.HotColor:=COLORE_LISTVIEW_HOT;
   BorderStyle:=bsNone;
   CanBgColor:=False;
   Ctl3D:=True;
   color:=COLORE_LISTVIEWS_BG;
   Colors.GridLineColor:=COLORE_LISTVIEWS_GRIDLINES;
   Colors.TreeLineColor:=COLORE_LISTVIEWS_TREELINES;
   Font.Charset:=DEFAULT_CHARSET;
   Font.name:=ares_FrmMain.font.name;
   font.size:=Ares_frmmain.font.size;
   font.color:=COLORE_LISTVIEWS_FONT;
   with header do begin
    AutoSizeIndex:=0;
    Font.name:=ares_FrmMain.font.name;
    font.size:=ares_frmmain.font.size;
    font.color:=ares_frmmain.font.color;
    Height:=21;
    Options:=[hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoRestrictDrag, hoShowHint, hoShowImages];
   end;
   Images:=ares_FrmMain.img_mime_small;
   ParentBiDiMode:=False;
   ParentCtl3D:=False;
   ParentFont:=False;
   ParentShowHint:=False;
   Selectable:=True;
   ShowHint:=True;
   TabOrder:=2;
   with treeoptions do begin
     AutoOptions:=[toAutoScroll];
     MiscOptions:=[toInitOnSave];
     if VARS_THEMED_HEADERS then PaintOptions:=[toShowButtons, toShowTreeLines, toThemeAware]
      else PaintOptions:=[toShowButtons, toShowTreeLines];
     SelectionOptions:=[toExtendedFocus, toMiddleClickSelect, toRightClickSelect];
     StringOptions:=[];
   end;
   OnCompareNodes:=ufrmmain.ares_frmmain.treeview_lib_regfoldersCompareNodes;
   OnExpanding:=ufrmmain.ares_frmmain.treeview_lib_regfoldersexpanding;//compare autosort on browse!
   OnFreeNode:=ufrmmain.ares_frmmain.treeview_lib_regfoldersFreeNode;
   OnGetText:=ufrmmain.ares_frmmain.treeview_lib_regfoldersGetText;
   OnGetImageIndex:=ufrmmain.ares_frmmain.treeview_lib_regfoldersGetImageIndex;
   OnGetSize:=ufrmmain.ares_frmmain.treeview_lib_regfoldersGetSize;
   OnMouseUp:=ufrmmain.ares_frmmain.treeviewbrowse2MouseUp;
   OnClick:=ufrmmain.ares_frmmain.treeviewbrowse2Click;
   defaulttext:=' ';
   visible:=false;
  end;

   NewColumn :=treeview2.header.Columns.Add;
   with NewColumn do begin
     options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coVisible];
     width:=0;
     Position:=0;
     spacing:=0;
     margin:=0;
   end;
 ///////////////////////////////////////////////////////


   splitter2:=tsplitter.create(containerPanel);
    with splitter2 do begin
         parent:=containerPanel;
         parentcolor:=true;
         Left:=0;
         align:=alleft;
         color:=COLORE_LISTVIEWS_BG;
         width:=0;
         beveled:=false;
         autosnap:=true;
         Top:=0;
         Height:=154;
         cursor:=crsizeWE;
    end;


    listview:=TcometTree.create(containerPanel);
    listview.tag:=longint(result);
    with listview do begin
          parent:=containerPanel;
          Left:=0;
          Top:=0;
          Width:=0;
          Height:=0;
          ParentColor:=false;
          ParentFont:=false;
          color:=COLORE_LISTVIEWS_BG;
          Align:=alClient;
          BiDiMode:=bdLeftToRight;
          BevelEdges:=[];
          BevelInner:=bvRaised;
          BevelOuter:=bvLowered;
          BevelKind:=bkFlat;
          BGColor:=COLORE_ALTERNATE_ROW;
          colors.HotColor:=COLORE_LISTVIEW_HOT;
          BorderStyle:=bsNone;
          CanBgColor:=True;
          Colors.GridLineColor:=COLORE_LISTVIEWS_GRIDLINES;
          Colors.TreeLineColor:=COLORE_LISTVIEWS_TREELINES;
          Colors.BorderColor:=COLORE_LISTVIEWS_HEADERBORDER;
          Ctl3D:=True;
          font.name:=ares_FrmMain.font.name;
          font.size:=ares_FrmMain.font.size;
          font.color:=COLORE_LISTVIEWS_FONT;
          with header do begin
           AutoSizeIndex:=0;
           background:=COLORE_LISTVIEWS_HEADERBK;
           Font.name:=ares_FrmMain.font.name;
           Font.size:=ares_FrmMain.font.size;
           Font.color:=COLORE_LISTVIEWS_HEADERFONT;
           Height:=21;
           Options:=[hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoRestrictDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible];
           Style:=hsFlatButtons;
          end;
          Images:=ares_FrmMain.img_mime_small;
          ParentBiDiMode:=False;
          ParentCtl3D:=False;
          ParentShowHint:=False;
          Selectable:=True;
          ShowHint:=True;
          TabOrder:=0;
          with treeoptions do begin
           AutoOptions:=[];
           MiscOptions:=[toInitOnSave, toToggleOnDblClick];
             if VARS_THEMED_HEADERS then PaintOptions:=[toShowButtons, toHotTrack, toThemeAware]
              else PaintOptions:=[toShowButtons, toHotTrack];
           SelectionOptions:=[toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toMultiSelect, toRightClickSelect,toCenterScrollIntoView];
           StringOptions:=[];
          end;
          OnClick:=ufrmmain.ares_frmmain.CometTreebrowseClick;
          OnCompareNodes:=ufrmmain.ares_frmmain.CometTreebrowseCompareNodes;
          OnDblClick:=ufrmmain.ares_frmmain.Download4Click;
          OnFreeNode:=ufrmmain.ares_frmmain.CometTreebrowseFreeNode;
          OnGetText:=ufrmmain.ares_frmmain.CometTreebrowseGetText;
          OnPaintText:=ufrmmain.ares_frmmain.CometTreebrowsePaintText;
          OnGetImageIndex:=ufrmmain.ares_frmmain.CometTreebrowseGetImageIndex;
          OnGetSize:=ufrmmain.ares_frmmain.listview_libGetSize;
          OnHeaderClick:=ufrmmain.ares_frmmain.TreeviewHeaderClick;
          onPaintHeader:=ufrmmain.ares_frmmain.listview_libPaintHeader;
          OnMouseUp:=ufrmmain.ares_frmmain.CometTreebrowseMouseUp;
          DefaultText:=' ';
        end;

        for i:=0 to 9 do begin
          NewColumn :=listview.header.Columns.Add;
           with newcolumn do begin
            MinWidth:=0;
            width:=0;
            text:='';
            Position:=i;
            spacing:=0;
            margin:=4;
           end;
          end;

          NewColumn :=listview.header.Columns.Add;
           with newcolumn do begin
            Options:=[coEnabled, coResizable, coVisible];
            MinWidth:=0;
            MaxWidth:=10000;
            Position:=10;
            spacing:=0;
            margin:=4;
            text:='';
            width:=containerPanel.clientwidth-4;
           end;

      listview.selectable:=false;
      listview.canbgcolor:=false;
    end;

end;


procedure chatroom_pvt_event(pcanale:precord_canale_chat_visual; da:string; crcda:word; testo:string);
var
 pvt_chat:precord_pvt_chat_visual;
 wstr:widestring;
 str,str_temp:string;
begin
pvt_chat:=new_chatroom_pvt(pcanale,da,crcda,true,true);
if pvt_chat=nil then exit;



out_text_memo(pvt_chat^.memo,COLORE_CHATPVTNICK,'',utf8strtowidestr(da)+':',false);
out_text_memo(pvt_chat^.memo,COLORE_CHAT_FONT,'','   '+utf8strtowidestr(testo));
//qui triggheriamo cambiamento font se non era visibile?
if (pvt_chat^.canale^.containerPageview.activePage=0) or  //pvt tab
   (pvt_chat^.canale^.containerPageview<>ares_frmmain.panel_chat.ActivePanel) or // channel tab
   (ares_frmmain.tabs_pageview.activePage<>IDTAB_CHAT) then begin    // chat view
   if pvt_chat^.pnl.imageindex<>10 then pvt_chat^.pnl.imageindex:=10;
   if pvt_chat^.frmtab<>nil then (pvt_chat^.frmTab as tfrmChatTab).incMissed;
 end;

if not pvt_chat^.has_sent_away_msg then begin
 if ares_frmmain.check_opt_chat_isaway.checked then begin
    if ares_frmmain.Memo_opt_chat_away.text='' then begin
       wstr:=STR_DEFAULT_AWAYMSG;
       pvt_chat^.canale^.out_text.add('/pvt '+da+CHRNULL+widestrtoutf8str(wstr));
        if length(vars_global.mynick)<4 then helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHATPVTNICK,'',GetLangStringW(STR_YOU)+chr(58){':'})
         else helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHATPVTNICK,'',utf8strtowidestr(vars_global.mynick)+chr(58){':'});
         helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHAT_FONT,'','   '+wstr);
     end else begin

        str:=widestrtoutf8str(convert_command_color_str(ares_frmmain.Memo_opt_chat_away.text));
                                    while (length(str)>0) do begin
                                      if pos(CRLF,str)>0 then begin
                                        str_temp:=copy(str,1,pos(CRLF,str)-1);
                                          delete(str,1,pos(CRLF,str)+1);
                                         if length(str_temp)>0 then begin
                                          wstr:=utf8strtowidestr(str_temp);
                                           pvt_chat^.canale^.out_text.add('/pvt '+da+CHRNULL+widestrtoutf8str(wstr));
                                            if length(vars_global.mynick)<4 then helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHATPVTNICK,'',GetLangStringW(STR_YOU)+chr(58){':'})
                                             else helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHATPVTNICK,'',utf8strtowidestr(vars_global.mynick)+chr(58){':'});
                                             helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHAT_FONT,'','   '+wstr);
                                         end;
                                      end else
                                      if pos(chr(10),str)>0 then begin
                                         str_temp:=copy(str,1,pos(chr(10),str)-1);
                                          delete(str,1,pos(chr(10),str));
                                         if length(str_temp)>0 then begin
                                          wstr:=utf8strtowidestr(str_temp);
                                            pvt_chat^.canale^.out_text.add('/pvt '+da+CHRNULL+widestrtoutf8str(wstr));
                                            if length(vars_global.mynick)<4 then helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHATPVTNICK,'',GetLangStringW(STR_YOU)+chr(58){':'})
                                             else helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHATPVTNICK,'',utf8strtowidestr(vars_global.mynick)+chr(58){':'});
                                             helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHAT_FONT,'','   '+wstr);
                                         end;
                                      end else begin
                                        str_temp:=str;
                                         str:='';
                                        if length(str_temp)>0 then begin
                                         wstr:=utf8strtowidestr(str_temp);
                                            pvt_chat^.canale^.out_text.add('/pvt '+da+CHRNULL+widestrtoutf8str(wstr));
                                            if length(vars_global.mynick)<4 then helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHATPVTNICK,'',GetLangStringW(STR_YOU)+chr(58){':'})
                                             else helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHATPVTNICK,'',utf8strtowidestr(vars_global.mynick)+chr(58){':'});
                                             helper_chatroom_gui.out_text_memo(pvt_chat^.memo,COLORE_CHAT_FONT,'','   '+wstr);
                                        end;
                                      end;
                                    end;
     end;
  pvt_chat^.has_sent_away_msg:=true;
 end;
end;

end;

procedure chatroom_pvt_eventerror(pcanale:precord_canale_chat_visual;  da:string; crcda:word; testo:string);
var
pvt_chat:precord_pvt_chat_visual;
begin
pvt_chat:=new_chatroom_pvt(pcanale,da,crcda,false,false);
if pvt_chat=nil then exit;
out_text_memo(pvt_chat^.memo,COLORE_ERROR,'',utf8strtowidestr(testo));
end;

function new_chatroom_pvt(pcanale:precord_canale_chat_visual; da :string; crcda:word; alwaysopen:boolean; blockSwitch:boolean):precord_pvt_chat_visual;
var
i:integer;
pvt_chat:precord_pvt_chat_visual;
panel:tCometTopicPNL;//emoticons
xpbutton:txpbutton;
begin
result:=nil; //per emergenza

 if pcanale^.lista_pvt<>nil then begin
  for i:=0 to pcanale^.lista_pvt.count-1 do begin
   pvt_chat:=pcanale^.lista_pvt[i];
   if pvt_chat.crcnickname<>crcda then continue else
    if pvt_chat^.nickname<>da then continue;
    result:=pvt_chat;
   if not blockSwitch then begin
    ares_frmmain.panel_chat.ActivePanel:=pcanale^.containerPageview;
    pcanale^.containerPageview.ActivePanel:=pvt_chat^.containerPanel;
   end;
    exit;
  end;
 end else pcanale^.lista_pvt:=tmylist.create;

 pvt_chat:=AllocMem(sizeof(record_pvt_chat_visual));

  pcanale^.lista_pvt.add(pvt_chat);

with pvt_chat^ do begin
  canale:=pcanale;

  containerPanel:=tpanel.create(ares_frmmain);
  containerPanel.parent:=ares_frmmain;
  containerPanel.top:=3000;
  containerPanel.caption:='';
  containerPanel.BevelOuter:=bvNone;
 frmtab:=nil;

 containerPanel.color:=COLORE_PANELS_BG;
   //containerPanel.OnShow:=ufrmmain.ares_frmmain.pvt_unhide;

                        
       
       //////////ora creiamo pannello per edit
    panel_edit_chat:=ttntpanel.create(containerPanel);
    panel_edit_chat.parent:=containerPanel;

       panel:=tCometTopicPNL.create(pvt_chat^.panel_edit_chat);
       with panel do begin
        parent:=panel_edit_chat;
        bevelinner:=bvnone;//bvspace;
        bevelouter:=bvnone;//bvlowered;
        color:=COLORE_TOOLBAR_BG;
        parentfont:=false;
        font.name:=ares_frmmain.font.name;
        font.size:=ares_frmmain.font.size;
        font.color:=COLORE_PANELS_FONT;
        Left:=0;
        Top:=0;
        width:=2000;
        top:=0;
        align:=altop;
       end;
          xpbutton:=txpbutton.create(panel);
          with xpbutton do begin
           parent:=panel;
           caption:=chr(66){'B'};
           font.style:=[fsbold];
           textleft:=7;
           texttop:=4;
           height:=21;
           width:=21;
           colorbg:=COLORE_TOOLBAR_BG;
           color:=COLORE_TOOLBAR_BG;
           top:=1;
           left:=4;
           onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_boldclick;
           OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
          end;
           xpbutton:=txpbutton.create(panel);
           with xpbutton do begin
            parent:=panel;
            caption:=chr(73){'I'};
            font.style:=[fsitalic];
            textleft:=7;
            texttop:=4;
            height:=21;
            width:=21;
            colorbg:=COLORE_TOOLBAR_BG;
            color:=COLORE_TOOLBAR_BG;
            top:=1;
            left:=25;
            onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_italicclick;
            OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
           end;
             xpbutton:=txpbutton.create(panel);
             with xpbutton do begin
              parent:=panel;
              caption:=chr(85){'U'};
              font.style:=[fsunderline];
              textleft:=7;
              texttop:=3;
              height:=21;
              width:=21;
              colorbg:=COLORE_TOOLBAR_BG;
              color:=COLORE_TOOLBAR_BG;
              top:=1;
              left:=46;
              onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_underlineclick;
              OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
             end;
              xpbutton:=txpbutton.create(panel);
              with xpbutton do begin
               parent:=panel;
               caption:='';
               font.style:=[];
               textleft:=5;
               texttop:=2;
               height:=21;
               width:=21;
               colorbg:=COLORE_TOOLBAR_BG;
               color:=COLORE_TOOLBAR_BG;
               top:=1;
               left:=67;
               imagelist:=ares_frmmain.imglist_emotic;
               imgleft:=2;
               imgtop:=2;
               index_down:=47;
               index_off:=47;
               index_over:=47;
               onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_textclick;
               OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
              end;
                xpbutton:=txpbutton.create(panel);
                with xpbutton do begin
                 parent:=panel;
                 caption:='';
                 font.style:=[];
                 textleft:=5;
                 texttop:=2;
                 height:=21;
                 width:=21;
                 top:=1;
                 left:=88;
                 colorbg:=COLORE_TOOLBAR_BG;
                 color:=COLORE_TOOLBAR_BG;
                 imagelist:=ares_frmmain.imglist_emotic;
                 imgleft:=2;
                 imgtop:=2;
                 index_down:=48;
                 index_off:=48;
                 index_over:=48;
                 onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_backgroundclick;
                 OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
                end;
                  xpbutton:=txpbutton.create(panel);
                  with xpbutton do begin
                   parent:=panel;
                   caption:='';
                   font.style:=[];
                   textleft:=5;
                   texttop:=2;
                   height:=21;
                   width:=21;
                   top:=1;
                   left:=109;
                   colorbg:=COLORE_TOOLBAR_BG;
                   color:=COLORE_TOOLBAR_BG;
                   imagelist:=ares_frmmain.imglist_emotic;
                   imgleft:=2;
                   imgtop:=2;
                   index_down:=0;
                   index_off:=0;
                   index_over:=0;
                   onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_emoticonsclick;
                   OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
                  end;
                  buttonToggleTask:=txpbutton.create(Panel);
                  with buttonToggleTask do begin
                   parent:=Panel;
                   font.style:=[];
                   textleft:=5;
                   texttop:=4;
                   height:=21;
                   width:=21;
                   colorbg:=COLORE_TOOLBAR_BG;
                   color:=COLORE_TOOLBAR_BG;
                   imagelist:=ares_frmmain.imagelist_chat;
                   top:=1;
                   left:=131;
                   imgleft:=2;
                   imgtop:=2;
                   index_down:=13;
                   index_off:=13;
                   index_over:=13;
                   onclick:=ufrmmain.ares_frmmain.toggleChatTaskButtonClick;
                   down:=ares_frmmain.check_opt_chat_taskbtn.checked;
                   OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
                   caption:='';
                   hint:=widestrtoutf8str(ares_frmmain.check_opt_chat_taskbtn.caption);
                  end;

       edit_chat:=ttntedit.create(panel_edit_chat);
       with edit_chat do begin
        parent:=panel_edit_chat;
        Left:=0;
        width:=2000;
        autoselect:=false;
        autosize:=false;
        oemconvert:=false;
        font.name:=font_chat.name;
        font.size:=font_chat.size;
        onkeypress:=ufrmmain.ares_frmmain.edit_chatKeyPress;
        onkeyup:=ufrmmain.ares_frmmain.edit_chatKeyUp;
        top:=24;
        color:=colorRTtoTColor(COLORE_CHAT_BG);
        font.color:=colorRTtoTColor(COLORE_CHAT_FONT);
        end;
       with panel_edit_chat do begin
        borderstyle:=forms.bsnone;
        caption:='';
        bevelinner:=bvnone;
        bevelouter:=bvnone;
        Height:=edit_chat.height+23;//46;
        OnResize:=ufrmmain.ares_frmmain.resize_pannellobottom_editchat;
        align:=albottom;
       end;

   crcnickname:=crcda;
   nickname:=da;
   memo:=TjvRichEdit.create(containerPanel);
   with memo do begin
     parent:=containerPanel;
     align:=alclient;
     ReadOnly:=true;
     parentbidimode:=false;
     allowobjects:=true;
     scrollbars:=StdCtrls.tscrollstyle(ssvertical);
     wordwrap:=true;
     onurlclick:=ufrmmain.ares_frmmain.testoURLClick;
     popupmenu:=ufrmmain.ares_frmmain.Popup_chat_memo;
     autourldetect:=true;
     HideSelection   := False;
     HideScrollBars  := false;//True;
     color:=edit_chat.color;
     font.color:=edit_chat.font.color;
    plaintext:=false;
    font.name:=font_chat.name;
    font.size:=font_chat.size;
    StreamMode  := [smSelection, smPlainRTF];
  end;

    if not blockSwitch then ares_frmmain.panel_chat.ActivePanel:=pcanale^.containerPageview;
    
    ares_frmmain.panel_chat.wrappable:=true;
    pnl:=pcanale^.containerPageview.AddPanel(IDXChatPvt,utf8strtowidestr(da),[],containerPanel,pvt_chat,true,9,blockSwitch);



    if ares_frmmain.check_opt_chat_taskbtn.checked then begin
     frmTab:=ufrmChatTab.TfrmChatTab.create(ares_frmmain);
    (frmTab as TfrmChatTab).pvt:=pvt_chat;
    frmTab.caption:=utf8strtowidestr(da)+' ('+GetLangStringW(STR_CHANNEL)+' '+utf8strtowidestr(canale^.name)+')';
    ares_frmmain.ImageList_chat.GetIcon(9,frmTab.Icon);
    frmTab.windowState:=wsMinimized;
    frmTab.Show;
   end else frmtab:=nil;
   
   pcanale^.containerPageview.tabsVisible:=true;

   try
    if not blockSwitch then if edit_chat.canFocus then edit_chat.setfocus;
    except
    end;

end;
   pvt_chat^.has_sent_away_msg:=false;   //2952+

   result:=pvt_chat;
end;


procedure assign_chatroom_tabimg(pcanale:precord_canale_chat_visual; stato:boolean);
var
statoi:byte;
begin
if stato then statoi:=3 else statoi:=2;

 if pcanale^.pnl.imageIndex<>statoi then pcanale^.pnl.imageindex:=statoi;

 if pcanale^.frmtab<>nil then begin
  if stato then (pcanale^.frmTab as tfrmChatTab).IncMissed
   else (pcanale^.frmTab as tfrmChatTab).ResetMissed;
 end;
end;

function add_img_rtc(imagelist:timagelist; imgindex:integer; coloresfondo:tcolor):string;
  function BitmapToRTF(pict: graphics.TBitmap): string;
  var
  bi, bb, rtf: string;
  bis, bbs: Cardinal;
  achar: ShortString;
  hexpict: string;
  I: Integer;
  begin
   GetDIBSizes(pict.Handle, bis, bbs);
  SetLength(bi, bis);
  SetLength(bb, bbs);
  GetDIB(pict.Handle, pict.Palette, PChar(bi)^, PChar(bb)^);
  rtf:='{\rtf1 {\pict\picw16\pich16\dibitmap0 ';
  SetLength(hexpict, (Length(bb) + Length(bi)) * 2);
  I := 2;
  for bis:=1 to Length(bi) do begin
    achar:=IntToHex(Integer(bi[bis]), 2);
    hexpict[I - 1] := achar[1];
    hexpict[I] := achar[2];
    Inc(I, 2);
  end;
  for bbs:=1 to Length(bb) do begin
    achar:=IntToHex(Integer(bb[bbs]), 2);
    hexpict[I - 1]:=achar[1];
    hexpict[I]:=achar[2];
    Inc(I, 2);
  end;
  rtf := rtf + hexpict + chr(32)+chr(125)+chr(125);//' }}';
  Result := rtf;
  end;

var
 bmp:graphics.tbitmap;
begin
bmp:=graphics.tbitmap.create;

with bmp do begin
 pixelformat:=pf24bit;
 width:=16;
 height:=16;
 with canvas do begin
  brush.color:=coloresfondo;
  pen.color:=coloresfondo;
  rectangle(0,0,16,16);
 end;
imagelist.draw(canvas,0,0,imgindex);
end;

result:=BitmapToRTF(bmp);
bmp.free;
end;

function channel_create_visuals(nome:widestring; chtopic:string):precord_canale_chat_visual;
var
NewColumn: TvirtualtreeColumn;
xpbutton:txpbutton;
i:integer;
capt:widestring;
begin

result:=AllocMem(sizeof(record_canale_chat_visual));

//lockwindowupdate(ares_frmmain.Handle);

with result^ do begin

 name:=widestrtoutf8str(nome);
 topic:=chtopic;
 ModLevel:=false;
 just_created:=false; //th_client, connettiti
 should_exit:=false;
 support_pvt:=true;
 support_files:=true;

   capt:=nome;

 containerPageview:=tcometpageview.create(ares_frmmain);
  with containerPageview do begin
   BevelOuter:=bvnone;
   caption:='';
   color:=COLORE_PANELS_BG;
   wrappable:=true;
   hideTabsOnSingle:=true;
   tabsVisible:=false;
   switchOnDown:=true;
   drawMargin:=false;
   buttonsHeight:=ares_frmmain.panel_chat.buttonsHeight;
   buttonsLeft:=ares_frmmain.panel_chat.buttonsLeft;
   buttonsLeftMargin:=ares_frmmain.panel_chat.buttonsLeftMargin;
   buttonsTopMargin:=ares_frmmain.panel_chat.buttonsTopMargin;
   buttonsHorizSpacing:=ares_frmmain.panel_chat.buttonsHorizSpacing;
   closeButtonTopMargin:=ares_frmmain.panel_chat.closeButtonTopMargin;
   closeButtonLeftMargin:=ares_frmmain.panel_chat.closeButtonLeftMargin;
   closeButtonWidth:=ares_frmmain.panel_chat.closeButtonWidth;
   closeButtonHeight:=ares_frmmain.panel_chat.closeButtonHeight;
   OnPaintButtonFrame:=ares_frmmain.panel_chat.OnPaintButtonFrame;
   OnPaintButton:=ares_frmmain.panel_chat.OnPaintButton;
   OnPaintCloseButton:=ares_frmmain.panel_chat.OnPaintCloseButton;
   OnPanelShow:=ufrmmain.ares_frmmain.toggleChatPvt;
   OnPanelClose:=ufrmmain.ares_frmmain.closePvt;
  end;


 if ares_frmmain.check_opt_chat_taskbtn.checked then begin
  frmTab:=TfrmChatTab.create(ares_frmmain);
  with (frmTab as TFrmChatTab) do begin
   channel:=result;
   caption:=capt;
   ares_frmmain.ImageList_chat.GetIcon(2,frmTab.Icon);
   windowState:=wsMinimized;
   Show;
 end;
  //frmTab.windowState:=wsMinimized;
 end else frmTab:=nil;

 ares_frmmain.panel_chat.wrappable:=true;
 pnl:=ares_frmmain.panel_chat.AddPanel(IDXChatMain,capt,[],containerPageview,result,true,2);

 containerPnl:=TcomettopicPnl.create(containerPageview);
  containerPnl.BevelOuter:=bvnone;
  containerPnl.caption:='';
  containerPnl.color:=COLORE_PANELS_BG;
 containerPageview.AddPanel(IDNone,GetLangStringW(STR_CHANNEL),[csDown],containerPnl,result,false);


  topicpnl:=TCometTopicPnl.create(containerPnl);
  with topicpnl do begin
   parent:=containerPnl;
   capt:=utf8strtowidestr(topic);
   bevelinner:=bvnone{bvspace};
   bevelouter:=bvnone{bvLowered};
   color:=COLORE_PANELS_BG;
   parentfont:=false;
   font.name:=ares_frmmain.font.name;
   font.size:=Ares_frmmain.font.size;
   font.color:=COLORE_PANELS_FONT;
   onpaint:=ufrmmain.ares_frmmain.painttopicpnl;
   doublebuffered:=true;
   align:=altop;
   height:=21;
  end;
end;

    write_topic_chat(result);   //solo qui e quando cambierò caption

with result^ do begin
           //parentbackground
   pannello:=ttntpanel.create(containerPnl);
   with pannello do begin
     parent:=containerPnl;
     borderstyle:=bsnone;
     caption:='';
     bevelinner:=bvnone;
     bevelouter:=bvnone;
     top:=25;
    // doublebuffered:=true;
     color:=containerPnl.color;
    end;

    //////////ora creiamo pannello per edit
     panel_edit_chat:=ttntpanel.create(containerPnl);
     with panel_edit_chat do begin
      parent:=containerPnl;
     // doublebuffered:=true;
     end;

       urlPanel:=TCometPlayerPanel.create(panel_edit_chat);
       with urlPanel do begin
        parent:=panel_edit_chat;
        bevelinner:=bvnone;//bvspace;
        bevelouter:=bvnone;//bvlowered;
        color:=COLORE_TOOLBAR_BG;
        parentfont:=false;
        font.Name:=ares_frmmain.font.name;
        font.size:=Ares_frmmain.font.size;
        font.color:=COLORE_PANELS_FONT;
        OnUrlClick:=ares_frmmain.testoUrlClick;
        url:='';
        captionLeft:=130;
        CaptionUrl:='';
        Left:=0;
        Top:=0;
        width:=2000;
        top:=0;
        align:=altop;
       end;

          xpbutton:=txpbutton.create(urlPanel);
          with xpbutton do begin
           parent:=urlPanel;
           caption:=chr(66){'B'};
           font.style:=[fsbold];
           textleft:=7;
           texttop:=4;
           height:=21;
           width:=21;
           top:=1;
           left:=4;
           colorbg:=COLORE_TOOLBAR_BG;
           color:=COLORE_TOOLBAR_BG;
           onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_boldclick;
           OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
          end;
           xpbutton:=txpbutton.create(urlPanel);
           with xpbutton do begin
            parent:=urlPanel;
            caption:=chr(73){'I'};
            font.style:=[fsitalic];
            textleft:=7;
            texttop:=4;
            height:=21;
            width:=21;
            colorbg:=COLORE_TOOLBAR_BG;
            color:=COLORE_TOOLBAR_BG;
            top:=1;
            left:=25;
            onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_italicclick;
            OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
           end;
             xpbutton:=txpbutton.create(urlPanel);
             with xpbutton do begin
              parent:=urlPanel;
              caption:=chr(85){'U'};
              font.style:=[fsunderline];
              textleft:=7;
              texttop:=3;
              height:=21;
              width:=21;
              colorbg:=COLORE_TOOLBAR_BG;
              color:=COLORE_TOOLBAR_BG;
              top:=1;
              left:=46;
              onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_underlineclick;
              OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
             end;
              xpbutton:=txpbutton.create(urlPanel);
              with xpbutton do begin
               parent:=urlPanel;
               caption:='';
               font.style:=[];
               textleft:=5;
               texttop:=2;
               height:=21;
               width:=21;
               colorbg:=COLORE_TOOLBAR_BG;
               color:=COLORE_TOOLBAR_BG;
               top:=1;
               left:=67;
               imagelist:=ares_frmmain.imglist_emotic;
               imgleft:=2;
               imgtop:=2;
               index_down:=47;
               index_off:=47;
               index_over:=47;
               onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_textclick;
               OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
              end;
                xpbutton:=txpbutton.create(urlPanel);
                with xpbutton do begin
                 parent:=urlPanel;
                 caption:='';
                 font.style:=[];
                 textleft:=5;
                 texttop:=2;
                 height:=21;
                 colorbg:=COLORE_TOOLBAR_BG;
                 color:=COLORE_TOOLBAR_BG;
                 width:=21;
                 top:=1;
                 left:=88;
                 imagelist:=ares_frmmain.imglist_emotic;
                 imgleft:=2;
                 imgtop:=2;
                 index_down:=48;
                 index_off:=48;
                 index_over:=48;
                 onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_backgroundclick;
                 OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
                end;
                  xpbutton:=txpbutton.create(urlPanel);
                  with xpbutton do begin
                   parent:=urlPanel;
                   caption:='';
                   font.style:=[];
                   textleft:=5;
                   texttop:=2;
                   height:=21;
                   width:=21;
                   colorbg:=COLORE_TOOLBAR_BG;
                   color:=COLORE_TOOLBAR_BG;
                   top:=1;
                   left:=109;
                   imagelist:=ares_frmmain.imglist_emotic;
                   imgleft:=2;
                   imgtop:=2;
                   index_down:=0;
                   index_off:=0;
                   index_over:=0;
                   onclick:=ufrmmain.ares_frmmain.btn_toolbarchat_emoticonsclick;
                   OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
                  end;
                  
                  buttonToggleTask:=txpbutton.create(urlPanel);
                  with buttonToggleTask do begin
                   parent:=urlPanel;

                   font.style:=[];
                   textleft:=5;
                   texttop:=4;
                   height:=21;
                   width:=21;
                   showhint:=true;
                   imagelist:=ares_frmmain.imagelist_chat;
                   colorbg:=COLORE_TOOLBAR_BG;
                   color:=COLORE_TOOLBAR_BG;
                   top:=1;
                   left:=131;
                   imgleft:=2;
                   imgtop:=2;
                   index_down:=13;
                   index_off:=13;
                   index_over:=13;
                   onclick:=ufrmmain.ares_frmmain.toggleChatTaskButtonClick;
                   down:=ares_frmmain.check_opt_chat_taskbtn.checked;
                   OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
                   caption:='';
                   hint:=widestrtoutf8str(ares_frmmain.check_opt_chat_taskbtn.caption);
                  end;
                  urlPanel.captionLeft:=buttonToggleTask.left+buttonToggleTask.width+6;

       edit_chat:=ttntedit.create(panel_edit_chat);
       with edit_chat do begin
        parent:=panel_edit_chat;
        Left:=0;
        width:=2000;
        autoselect:=false;
        autosize:=false;
        oemconvert:=false;
        font.name:=font_chat.name;
        font.size:=font_chat.size;
        onkeypress:=ufrmmain.ares_frmmain.edit_chatKeyPress;
        onkeyup:=ufrmmain.ares_frmmain.edit_chatKeyUp;
        top:=24;
        color:=colorRTtoTColor(COLORE_CHAT_BG);
        font.color:=colorRTtoTColor(COLORE_CHAT_FONT);
        end;

       with panel_edit_chat do begin
         borderstyle:=bsnone;
         caption:='';
         bevelinner:=bvnone;
         bevelouter:=bvnone;
         Height:=edit_chat.height+23;//46;
         OnResize:=ufrmmain.ares_frmmain.resize_pannellobottom_editchat;
         align:=albottom;
        end;



    pannello.align:=alclient;


listview:=tcomettree.create(pannello);
with listview do begin
  parent:=pannello;
  parentcolor:=false;
  parentfont:=false;
  left:=pannello.clientwidth-default_width_chat;
  top:=0;
  height:=pannello.clientheight;
  width:=default_width_chat;
  Align:=alright;
  ongetsize:=ufrmmain.ares_frmmain.get_data_size_user_chats;
  onPaintHeader:=ufrmmain.ares_frmmain.listview_libPaintHeader;
  ongettext:=ufrmmain.ares_frmmain.get_text_users_chats;
  OnCompareNodes:=ufrmmain.ares_frmmain.userchatCompareNodes;
  ongetimageindex:=ufrmmain.ares_frmmain.lista_user_chat_get_imageindex;
  onheaderclick:=ufrmmain.ares_frmmain.TreeviewHeaderClick;
  onfreenode:=ufrmmain.ares_frmmain.treeview_list_user_channelfreenode;
  OnDblClick:=ufrmmain.ares_frmmain.treeview_list_user_channeldblclick;
  onpainttext:=ufrmmain.ares_frmmain.listviewchatPaintText;
  //color:=$00FEFFFF;
  PopupMenu:=ares_frmmain.popup_chat_userlist;
 ares_frmmain.popup_chat_userlist.autopopup:=true;
  with treeoptions do begin
   StringOptions:=[];
   selectionoptions:=[toExtendedFocus,toFullRowSelect,toMiddleClickSelect,toRightClickSelect,toCenterScrollIntoView];
     if VARS_THEMED_HEADERS then PaintOptions:=[toShowButtons, toHotTrack,toThemeAware]
       else PaintOptions:=[toShowButtons,toHotTrack];
   MiscOptions:=[toInitOnSave,toToggleOnDblClick];
   Autooptions:=[toAutoScroll];
   animationoptions:=[];
  end;

  with header do begin
   Options:=[hoAutoResize,hoColumnResize,hoDrag,hoRestrictDrag,hoShowHint,hoShowImages,hoShowSortGlyphs,hoHotTrack,hoVisible];
   background:=COLORE_LISTVIEWS_HEADERBK;
   font.name:=ares_frmmain.font.name;
   font.size:=ares_frmmain.font.size;
   font.color:=COLORE_LISTVIEWS_HEADERFONT;
   height:=21;
   style:=hsFlatButtons;
  end;

  bevelinner:=bvNone;//bvlowered;
  bevelkind:=bksoft;
  bevelouter:=bvnone;
  borderstyle:=bsnone;
  BevelEdges:=[beleft,betop,bebottom];
  borderwidth:=0;
  ctl3d:=true;
  cursor:=crdefault;
  defaultnodeheight:=18;
  enabled:=true;
  font.name:=ares_FrmMain.font.name;
  font.size:=ares_frmmain.font.size;
  hint:='';
  images:=ares_frmmain.ImageList_chat;
  parentbidimode:=false;
  parentctl3d:=false;

  color:=edit_chat.color;
  font.color:=edit_chat.font.color;
  colors.hotcolor:=COLORE_LISTVIEW_HOT;
  Colors.BorderColor:=COLORE_LISTVIEWS_HEADERBORDER;
  indent:=18;
  margin:=4;
  nodedatasize:=-1;
  rootnodecount:=0;
  tabstop:=true;
 end;



NewColumn:=listview.header.Columns.Add;
with NewColumn do begin
 options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coVisible,coParentColor];
 text:=GetLangStringW(STR_USERS);
 width:=95;
 MaxWidth:=10000;
 Position:=0;
 MinWidth:=0;
 spacing:=0;
 margin:=4;
 style:=vstext;
 layout:=blglyphleft;
end;

NewColumn:=listview.header.Columns.Add;
with NewColumn do begin
 options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coParentColor];
 text:='ID';
 width:=0;
 MaxWidth:=10000;
 Position:=1;
 MinWidth:=0;
 spacing:=0;
 margin:=0;
 style:=vstext;
 layout:=blglyphleft;
end;

NewColumn:=listview.header.Columns.Add;
with NewColumn do begin
 options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coParentColor];
 text:=GetLangStringW(STR_FILES_CHAT);
 //if ishosted then width:=38
 // else
 width:=0;//50;
 MaxWidth:=10000;
 Position:=2;
 MinWidth:=0;
 spacing:=0;
// if isHosted then margin:=4
 // else
  margin:=0;

 style:=vstext;
 layout:=blglyphleft;
end;

NewColumn :=listview.header.Columns.Add;
with NewColumn do begin
  //if ishosted then options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coVisible,coParentColor]
  // else
 options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coParentColor];
 text:=GetLangStringW(STR_SPEED);
// if ishosted then width:=45
 // else
 width:=0;//55;
 MaxWidth:=10000;
 MinWidth:=0;
 Position:=3;
 spacing:=0;
// if isHosted then margin:=4
 // else
 margin:=0;
 style:=vstext;
 layout:=blglyphleft;
end;

with listview do begin
 with scrollbaroptions do begin
  alwaysvisible:=false;
  scrollbars:=ssboth;
  scrollbarstyle:=sbmregular;
 end;
 header.autosizeindex:=0;
end;

splitter:=tsplitter.create(pannello);
with splitter do begin
 parent:=pannello;
 left:=listview.left-1;
 align:=alright;
 onmoved:=ufrmmain.ares_frmmain.splitter_chatEndSplit;
 width:=3;
 Color:=pannello.color;
 ParentColor:=false;
 Beveled:=false;
 cursor:=crsizeWE;
end;

memo:=TjvRichEdit.create(pannello);
with memo do begin
 parent:=pannello;
 width:=listview.left-4;
 left:=0;//result^.splitter.left-1;
 align:=alclient;
 ReadOnly:=true;
 allowobjects:=true;
 parentbidimode:=false;
 scrollbars:=tscrollstyle(ssvertical);
 wordwrap:=true;
 onurlclick:=ufrmmain.ares_frmmain.testoURLClick;
 popupmenu:=ufrmmain.ares_frmmain.Popup_chat_memo;
 selectionbar:=false;
 autourldetect:=true;
 ScrollBars:=ssVertical;
 HideSelection:=False;
 HideScrollBars:=false;
 font.name:=font_chat.name;
 font.size:=font_chat.size;

 color:=colorRTtoTColor(COLORE_CHAT_BG);
 font.color:=colorRTtoTColor(COLORE_CHAT_FONT);



   plaintext:=falsE;
   StreamMode:=[smSelection, smPlainRtf];
 end;



//lockwindowupdate(0);


lista_pvt:=nil;
lista_pannelli_result:=nil;
lista_pannelli_browse:=nil;
end;

end;

procedure write_topic_chat(precord_chat:precord_canale_chat_visual);
begin
with precord_chat^.topicpnl do begin
 capt:=utf8strtowidestr(precord_chat.topic);
 invalidate;
end;                                                                                                                           //niente data sul topic!
end;


procedure canvas_draw_topic(ACanvas:TCanvas; cellrect:Trect; imglist:Timagelist; widestr:widestring; forecolor,backcolor,forecolor_gen,backcolor_gen:TColor; offsetxiniz:integer);
var
dascrivere:widestring;
  h,fatti,posizione_in_real,offsetx,prossima_variazione:integer;
  bold,underline,italic:boolean;
  color1,color2:tcolor;
  num:integer;
  bmp:graphics.tbitmap;
  str1:string;
  lungemotic,imgindex,widthdascrivere:integer;
  stile:TFontStyles;
begin
try
bold:=false;
underline:=false;
italic:=false;

             dascrivere:='';
             h:=1;
             offsetx:=offsetxiniz;
              while h<=length(widestr) do begin //scan stringa completa
               num:=integer(widestr[h]);
                case num of
                  40,58,59,61,56,66:begin //'(:;=8B' emoticon?

                    str1:=copy(widestr,h,3);
                     if length(str1)>=2 then begin
                      imgindex:=emoticonstr_to_index(str1,lungemotic);
                      if imgindex<>-1 then begin //è un emoticon! calcoliamo di quanto è lungo...per quelli solo di due
                            if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                 brush.color:=backcolor;
                                 font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style:=stile;
                                  widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                  fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                  brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere:='';
                            end;
                        if cellrect.Bottom-cellrect.top<16 then begin
                         bmp:=graphics.tbitmap.create;
                         imglist.getbitmap(imgindex,bmp);
                          with acanvas do begin
                           brush.color:=backcolor;
                           fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+(cellrect.Bottom-cellrect.top),cellrect.Bottom-cellrect.top));
                           brush.style:=bsclear;
                           StretchDraw(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+(cellrect.Bottom-cellrect.top),cellrect.Bottom-cellrect.top),bmp);
                          end;
                         bmp.free;
                        end else begin
                         with acanvas do begin
                          brush.color:=backcolor;
                          fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+(cellrect.Bottom-cellrect.top),cellrect.Bottom-cellrect.top));
                          brush.style:=bsclear;
                         end;
                         if cellrect.bottom-cellrect.top<20 then imglist.draw(Acanvas,cellrect.left+offsetx,cellrect.top,imgindex)
                          else imglist.draw(Acanvas,cellrect.left+offsetx,cellrect.top+2,imgindex);
                        end;
                        inc(h,lungemotic);//skippiamo di quello che ci serviva
                        inc(offsetx,16);
                        continue;
                      end;
                     end;

                     dascrivere:=dascrivere+widestr[h];
                     inc(h); //non è emoticon superiamo semplicemente carattere
                     continue;
                  end;
                  2:begin //close fore color
                              if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                 brush.color:=backcolor;
                                 font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style:=stile;
                                  widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                  fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                  brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere:='';
                            end;
                    forecolor:=forecolor_gen;
                    inc(h);
                    continue;
                  end;
                  3:begin //fore color  chr(3)
                               if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                 brush.color:=backcolor;
                                 font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style:=stile;
                                  widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                  fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                  brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere:='';
                            end;
                   forecolor:=color_irc_to_color(copy(widestr,h+1,2));
                   inc(h,3);
                   continue;
                  end;
                  4:begin //close back color
                               if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                 brush.color:=backcolor;
                                 font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style:=stile;
                                  widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                  fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                  brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere:='';
                            end;
                    backcolor:=backcolor_gen;
                    inc(h);
                    continue;
                  end;
                  5:begin //back color
                              if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                 brush.color:=backcolor;
                                 font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                   font.Style:=stile;
                                   widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                   fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                   brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere:='';
                            end;
                   backcolor:=color_irc_to_color(copy(widestr,h+1,2));
                   inc(h,3);
                   continue;
                  end;
                  6:begin //bold
                               if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                  brush.color:=backcolor;
                                  font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style:=stile;
                                  widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                   fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                   brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere:='';
                            end;
                    bold:=not bold;
                    inc(h);
                    continue;
                  end;
                  7:begin //underline
                              if dascrivere<>'' then begin    //scriviamo testo precedente!
                                with acanvas do begin
                                  brush.color:=backcolor;
                                 font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style:=stile;
                                  widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                   fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                   brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere:='';
                            end;
                    underline:=not underline;
                    inc(h);
                    continue;
                  end;
                  8:begin //inverse
                              if dascrivere<>'' then begin
                                with acanvas do begin
                                 brush.color:=backcolor;
                                 font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                 acanvas.font.Style:=stile;
                                  widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                   fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                   brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere:='';
                            end;
                   color1:=forecolor;
                   color2:=backcolor;
                   backcolor:=color1;
                   forecolor:=color2;
                    inc(h);
                    continue;
                  end;
                  9:begin //italic
                              if dascrivere<>'' then begin
                                with acanvas do begin
                                 brush.color:=backcolor;
                                 font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                  font.Style:=stile;
                                  widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                   fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                   brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                               inc(offsetx,widthdascrivere);
                               dascrivere:='';
                            end;
                    italic:=not italic;
                    inc(h);
                    continue;
                  end else begin   //semplice avanzamento a prox char
                     dascrivere:=dascrivere+widestr[h];
                     inc(h);
                     continue;
                  end;
              end;//fine case
          end;

                             //scriviamo testo precedente!

                             if dascrivere<>'' then begin
                                with acanvas do begin
                                 brush.color:=backcolor;
                                 font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                 font.Style:=stile;
                                widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+2,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                  //inc(offsetx,widthdascrivere);
                                 // dascrivere:='';
                                end;
                            end;

                          { continue line?

                             while offsetx<cellrect.Right do begin
                                with acanvas do begin
                                 brush.color:=backcolor;
                                 font.color:=forecolor;
                                 stile:=[];
                                 if bold then include(stile,fsBold);
                                 if underline then include(stile,fsunderline);
                                 if italic then include(stile,fsitalic);
                                 font.Style:=stile;
                                 if dascrivere='' then dascrivere:=' ';
                                widthdascrivere:=gettextwidth(dascrivere,acanvas);
                                fillrect(rect(cellrect.left+offsetx,cellrect.top,cellrect.left+offsetx+widthdascrivere,cellrect.Bottom-cellrect.top));
                                brush.style:=bsclear;
                                  canvas_draw_chat_text(acanvas,
                                                        cellrect.Left+offsetx,
                                                        cellrect.top+1,
                                                        cellrect,
                                                        dascrivere,
                                                        forecolor,
                                                        backcolor,
                                                        bold,
                                                        underline,
                                                        italic);
                                end;
                                if widthdascrivere>0 then inc(offsetx,widthdascrivere) else inc(offsetx,10);
                            end;
                        }
except
end;
end;

procedure canvas_draw_chat_text(acanvas:tcanvas; x,y:integer; cliprect:trect; widestr:widestring; forecolor,backcolor:tcolor;  bold,underline,italic:boolean);
begin


 Windows.ExtTextOutW(aCanvas.Handle,
                     x,
                     y,
                     0,
                     @ClipRect,
                     PwideChar(widestr),
                     Length(widestr),
                      nil);
end;

procedure out_text_memo(memo:TjvRichEdit; colore:tcolor; utente:widestring; S:widestring; urldetect:boolean = true);
var
 str,str1,str_time:string;
 MyRT:Tmystringlist;
 italic,underline,bold:boolean;
 st:TStringStream;
 forecolor,backcolor,color1,color2,numEmotes:byte;
 colorebg:tcolor;
 i,num,coloretesto,coloresfondo,coloreutente,lungemotic,imgindex:integer;
begin
try



    coloretesto:=colore;//5;  //navy
    coloresfondo:=vars_global.COLORE_CHAT_BG;//bianco
    coloreutente:=vars_global.COLORE_CHAT_NICK; //nero
    colorebg:=colorRTtoTColor(COLORE_CHAT_BG);

 numEmotes:=0;  // hey Silver ;)

 str:='\fs'+inttostr((vars_global.font_chat.size)*2)+//fonsize
      '\cf'+inttostr(coloreutente)+ //nero per il nick?
      '\highlight'+inttostr(coloresfondo);//+

      if ares_frmmain.Check_opt_chat_time.checked then str_time:=formatdatetime('hh:nn:ss',now)+' '
       else str_time:='';

 if length(utente)>0 then begin
  utente:=str_time+utente+'> ';
  for i:=1 to length(utente) do str:=str+'\u'+inttostr(integer(utente[i]))+'?';
 end else begin
  for i:=1 to length(str_time) do str:=str+'\u'+inttostr(integer(str_time[i]))+'?';
 end;

 str:=str+'\cf'+inttostr(coloretesto);

             italic:=false;
             underline:=false;
             bold:=false;

              forecolor:=colore;
              backcolor:=coloresfondo;

             i:=1;
              while i<=length(s) do begin

               num:=integer(s[i]);
                case num of
                  40,58,59,61,56,66:begin //'(:;=8B' emoticon?
                    str1:=copy(s,i,3);
                     if length(str1)>=2 then begin
                      imgindex:=emoticonstr_to_index(str1,lungemotic);
                      if imgindex<>-1 then begin
                         if (not ares_frmmain.check_opt_chat_noemotes.checked) and (numEmotes<10) then begin
                           str:=str+add_img_rtc(ares_frmmain.imglist_emotic,imgindex,colorRTtoTColor(backcolor));
                           inc(i,lungemotic);
                           inc(numEmotes);
                           continue;
                         end;
                      end;
                     end;
                    str:=str+'\u'+inttostr(num)+'?';
                  end;

                  2:begin //close fore color
                    forecolor:=colore;
                    str:=str+'\cf0\cf'+inttostr(forecolor);
                  end;
                  3:begin //fore color  chr(3)
                   forecolor:=ColorAresToRTColor(strtointdef(copy(s,i+1,2),0));
                   str:=str+'\cf0\cf'+inttostr(forecolor);
                   inc(i,2);
                  end;
                  4:begin //close back color
                    backcolor:=coloresfondo;
                    str:=str+'\highlight0\highlight'+inttostr(backcolor);
                  end;
                  5:begin //back color
                   backcolor:=ColorAresToRTColor(strtointdef(copy(s,i+1,2),0));
                   str:=str+'\highlight0\highlight'+inttostr(backcolor);
                   inc(i,2);
                  end;
                  6:begin //bold
                    bold:=not bold;
                    if bold then str := str + '\b'
                     else str := str + '\b0';
                  end;
                  7:begin //underline
                    underline:=not underline;
                   if underline then str := str + '\ul'
                     else str := str + '\ul0';
                  end;
                  9:begin //italic
                    italic:=not italic;
                    if italic then str := str + '\i'
                     else str := str + '\i0';
                  end;
                  8:begin //inverse
                    color1:=forecolor;
                    color2:=backcolor;
                    backcolor:=color1;
                    forecolor:=color2;
                    str:=str+'\highlight0'+
                             '\cf0'+
                             '\highlight'+inttostr(backcolor)+
                             '\cf'+inttostr(forecolor);

                  end else str:=str+'\u'+inttostr(num)+'?';

                end;  //case

                  inc(i);
                  continue;
              end;//while

              if underline then str := str + '\ul0';
              if italic then str := str + '\i0';
              if bold then str := str + '\b0';

              str := str + '\highlight0\cf0\par';

   MyRT:=tmystringlist.create;
   with MyRT do begin
    add(RTF_HEADER+' '+memo.Font.name+';}}');
    add(RTF_COLORTBL);
    add(str);
    add('}');
   end;

  with memo.lines do begin
   if count>500 then begin     //clear
       beginupdate;
    while (count>450) do delete(0);
       endupdate;
   end;
  end;

  with memo do begin
   hideselection:=true;
   Sellength:=0;
   SelStart:=length(text);
  end;


  ST:=TstringStream.create(MyRT.text);
  memo.Lines.LoadFromStream(ST);
  ST.free;

   MyRT.free;

  with memo do begin
   hideselection:=false;
   SelStart:=length(text);
   Sellength:=0;
  end;

except
end;
end;

procedure btn_chat_emocittrigger(toadd:String);
var
pcanale:precord_canale_chat_visual;
pvt_chat:precord_pvt_chat_visual;
pnl:TCometPagePanel;
begin
try

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activepage];
 if pnl.id<>IDXCHatMain then exit;
 pcanale:=pnl.FData;
 if pcanale^.containerPageview.activePage=0 then begin
   with pcanale^.edit_chat do begin
    text:=text+toadd;
    SetFocus;
    selstart:=length(text);
    sellength:=0;
    end;
 end else begin
   pnl:=pcanale^.containerPageview.panels[pcanale^.containerPageview.activePage];
    pvt_chat:=pnl.FData;
     with pvt_chat^.edit_chat do begin
       text:=text+toadd;
       SetFocus;
       selstart:=length(text);
       sellength:=0;
     end;
 end;

except
end;
end;

procedure mainGui_killevent_frombrowse;
var
pcanale:precord_canale_chat_visual;
pannello_browse:precord_pannello_browse_chat;
pnl:TCometPagePanel;
begin
try

pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
if pnl.ID<>IDXChatBrowse then exit;
pannello_browse:=pnl.fdata;
if pannello_browse.canale=nil then exit;

pcanale:=pannello_browse^.canale;
pcanale^.out_text.add('/kill '+pannello_browse^.nick);

except
end;

end;

procedure mainGui_banevent_frombrowse;
var
pcanale:precord_canale_chat_visual;
pannello_browse:precord_pannello_browse_chat;
pnl:TCometPagePanel;
begin
try


pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
if pnl.ID<>IDXChatBrowse then exit;
pannello_browse:=pnl.fdata;

if pannello_browse.canale=nil then exit;

 pcanale:=pannello_browse.canale;
 if not pcanale^.ModLevel then exit;
 pcanale^.out_text.add('/ban '+pannello_browse^.nick);

 except
 end;
 
end;

procedure mainGui_banevent_fromsearch;
var
pcanale:precord_canale_chat_visual;
pannello_result:precord_pannello_result_chat;
nodo:pCmtVnode;
data:precord_file_result_chat;
pnl:TCometPagePanel;
begin

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 if pnl.ID<>IDXChatSearch then exit;
 pannello_result:=pnl.fdata;

 if pannello_result.canale=nil then exit;

 pcanale:=pannello_result.canale;

 nodo:=pannello_result^.listview.getfirstselected;
 if nodo=nil then exit;
 data:=pannello_result^.listview.getdata(nodo);

 pcanale^.out_text.add('/ban '+data^.nickname);
end;

procedure mainGui_killevent_fromsearch;
var
pcanale:precord_canale_chat_visual;
pannello_result:precord_pannello_result_chat;
nodo:pCmtVnode;
data:precord_file_result_chat;
pnl:TCometPagePanel;
begin

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
 if pnl.ID<>IDXChatSearch then exit;
 pannello_result:=pnl.fdata;

 if pannello_result.canale=nil then exit;

 pcanale:=pannello_result.canale;

 nodo:=pannello_result^.listview.getfirstselected;
 if nodo=nil then exit;
 data:=pannello_result^.listview.getdata(nodo);
 pcanale^.out_text.add('/kill '+data^.nickname); 

end;




end.
