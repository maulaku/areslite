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
used by ufrmpvt, this thread covers networking of private chat window, including browse and private file transfers
}

unit thread_private_chat;

interface

uses
ares_types,classes,sysutils,classes2,blcksock,forms,comettrees,
registry,const_win_messages,const_commands_privatechat,const_privchat;

 type
   tthread_private_chat=class(tthread)
   private
    fsocket:ttcpblocksocket;
    fnick,fmynick:string;
    fip_alt,fip:cardinal;
    fport:word;
    fform:tform;
    fip_server:cardinal;
    fport_server:word;
    fnum_special:byte;
    randoms:string; //proxy
    faccepted:boolean;
    loc_out_text:tmystringlist;
    str_to_be_printed:string;
    first_req_box:boolean;
    loc_lista_file:tmylist;
    last_stats_file,last_pong_remotehost:cardinal;
    new_protocol:boolean;
    lista_files_per_browse:tmystringlist;
    PfileBrowse:precord_file_library;
    tipo_per_browse_richiesto:byte;
    str1_global:string;

    int64_capable:boolean;

  num_audio:word;
  num_video:word;
  num_image:word;
  num_document:word;
  num_software:word;
  num_other:word;

  buffer_out_pfile:array[0..2047] of byte;

  bytes_in_header:byte;
  bytes_in_buffer:word;
  buffer_header_ricezione:array[0..3] of byte;
  buffer_ricezione:array[0..1023] of byte;
  buffer1:array[0..1023] of char;

  user_is_granted_browse:boolean;

    artists_audio:tmylist;
    albums_audio:tmylist;
    categs_audio:tmylist;
    albums_image:tmylist;
    categs_image:tmylist;
    categs_video:tmylist;
    authors_document:tmylist;
    categs_document:tmylist;
    companies_software:tmylist;
    categs_software:tmylist;

    folders_shared_remote:tmylist;

   protected
   procedure nil_virfolders_entries;
   procedure categs_free;
   procedure execute;override;
   procedure metti_fip_alt;//synch
   procedure categs_init;
   procedure categs_compute;
   procedure categs_sort;
   procedure categs_writetoGUI;//synch
   procedure log_disconnected_while_chatting; //synch
   procedure add_text_msg_away;//synch
   procedure initiate_connection;

   procedure shutdown;
   procedure privchat_transfers_update;
  // procedure check_files_timeouts;
   procedure privchat_update_transferview;   //synch
   function find_privchat_transfernode(listview:tcomettree; pfile:precord_file_chat_send):pCmtVnode;
   procedure send_pong;
   procedure parse_pong(newFormat:boolean=false);

   procedure accetta_browse_diretto;//synch
   procedure log_user_requesting_files;
  function get_free_pfile_num:word;
  procedure piglia_out_text;// in synchronize
  procedure send;
  procedure attiva_pfiles;
  procedure send_text(text:string);
  procedure attiva_pfile(pfile:precord_file_chat_send);
  procedure prendi_pfiles;//synch
  procedure parse_received_str(socket:ttcpblocksocket);
  procedure parse_received_new(socket:ttcpblocksocket);
  procedure file_req_arrived;//synch
  procedure file_ack_arrived;
  procedure file_deny_arrived;
  procedure block_file_received;
  procedure shutdown_transfers;
  procedure process_command(cmd:byte);
  procedure invia_browse_files;
  procedure reset_PfileBrowse;
  procedure get_lista_browse;//synch
  procedure arrivato_file_browse;
  procedure set_end_of_browse;//synch
  procedure set_start_of_browse;  //synch
  procedure add_browse_item2;
  procedure add_result;  //in synch
  procedure put_progress_browse(count:integer);//sync
  procedure print_text; // synch
  procedure send_away_msg;//synch
  function send_chat_connect:boolean;
  procedure close_us;//sync
   procedure ricevi_chat_200_ok(socket:ttcpblocksocket);
   procedure log_connected;// synchronize
   procedure log_connecting;  //synch
   procedure update_peer_addr_binary; // in synch
   procedure update_peer_addr_verbose;//sync
   procedure update_peer_addr_buffer;
   procedure update_peer_addr_newformat;//sync


   procedure metti_form14_nick; //synch
   procedure log_fail_to_connect;//in synchronize
   function do_connect:boolean;
   procedure ricevi_chat_200_ok_ed_invia_nostro;
   procedure receive;
   procedure receive_new;
   procedure piglia_user_is_granted_browse;//synch
    procedure aggiorna_folder_normal(treeview2:tcomettree);  //in synch
    function find_regular_path(treeview2:tcomettree; lista:tmylist; index:integer; path:string):pCmtVnode;
    procedure clear_folders_shared;
    procedure add_folder_shared(folder_id:word;fname:string);
    procedure inc_items_folder_shared(folder_id:word);
    procedure send_folders_regular;//synch
    function is_shared_infolder(nodo:pCmtVnode; cartella:precord_cartella_share):boolean;
   procedure get_avantuale_chatpush_arrived;
   procedure delete_chatpush_req;//synch
   procedure add_new_key_pvt_push;//synch
    function request_Chatpush:boolean;

    procedure privchat_complete_handshake(socket:ttcpblocksocket);
    procedure privchat_start_handshake(socket:ttcpblocksocket);
   public
    property socket:ttcpblocksocket read fsocket write fsocket;
    property remnick:string read fnick write fnick;
    property mynick:string read fmynick write fmynick;
    property ip:cardinal read fip write fip;
    property port:word read fport write fport;
    property form:tform read fform write fform;
    property ip_server:cardinal read fip_server write fip_server;
    property ip_alt:cardinal read fip_alt write fip_alt;
    property port_server:word read fport_server write fport_server;
    property num_special:byte read fnum_special write fnum_special;
    property accepted:boolean read faccepted write faccepted;
   end;



implementation

uses
 ufrmpvt,windows,winsock,vars_global,helper_strings,helper_chatroom,
 ufrmmain,helper_unicode,vars_localiz,helper_crypt,helper_ipfunc,
 helper_urls,helper_mimetypes,const_ares,tntwindows,helper_diskio,
 keywfunc,helper_base64_32,helper_sorting,helper_visual_library,
 helper_datetime,helper_sockets,const_commands,helper_chatroom_gui,
 helper_share_misc,helper_download_misc,mysupernodes;


procedure tthread_private_chat.privchat_complete_handshake(socket:ttcpblocksocket);
var
str,strTemp:string;
begin
         socket.block(true);

           str:='|01:0.0.0.0:0|'+vars_global.localip+':'+inttostr(vars_global.myport)+chr(10)+
                '|02:'+vars_global.mynick+chr(10)+
                '|03:'+vars_global.versioneares+chr(10);


                //send xareip digital?
              strTemp:=helpeR_ipfunc.serialize_myConDetails;
              str:=str+CHRNULL+
                       chr(length(strTemp))+CHRNULL+
                       chr(CMD_PRIVCHAT_USERIPNEW)+
                       strTemp;

              //send mynick here?
              str:=str+CHRNULL+
                   chr(length(vars_global.mynick)+1)+CHRNULL+  //here my fip_alt
                   chr(CMD_PRIVCHAT_USERNICK)+
                   vars_global.mynick+CHRNULL;

                        //send ip alt?
          str:=str+CHRNULL+
                   chr(5)+CHRNULL+
                   chr(CMD_PRIVCHAT_INTERNALIP)+  //here my fip_alt
                   int_2_dword_string(vars_global.LanIPC)+
                   chr(1);  //2951 int64capable marker  <------


              //send you can browse me?
             if ((ares_frmmain.check_opt_chat_browsable.checked) or ((form as tfrmpvt).grantbrowse1.checked)) then begin
               str:=str+CHRNULL+
                        CHRNULL+CHRNULL+
                        chr(CMD_PRIVCHAT_BROWSEGRANTED);
             end;

              socket.sendbuffer(@str[1],length(str));

         socket.block(false);
end;


procedure tthread_private_chat.ricevi_chat_200_ok(socket:ttcpblocksocket);
var
previous_len:integer;
len:integer;
er:integer;
atttime:cardinal;
begin
try
atttime:=gettickcount;
socket.buffstr:='';

repeat
    if terminated then exit;

    if gettickcount-atttime>TIMOUT_SOCKET_CONNECTION then begin   //timeout
     synchronize(close_us);
     exit;
   end;

    if pos(CRLF+CRLF,socket.buffstr)<>0 then begin
        if pos('CHAT/0.1 200 OK',socket.buffstr)=1 then begin
           delete(socket.buffstr,1,pos(CRLF+CRLF,socket.buffstr)+3);
           break;
        end else begin
           socket.buffstr:=copy(socket.buffstr,pos(CRLF+CRLF,socket.buffstr)+4,length(socket.buffstr));
           sleep(10);
           continue;
        end;
    end;

    if not TCPSocket_CanRead(socket.socket,0,er) then begin
     if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
       synchronize(close_us);
       exit;
     end else begin
      sleep(10);
      continue;
     end;
    end;

    previous_len:=length(socket.buffstr);
    setlength(socket.buffstr,previous_len+100);
   len:=TCPSocket_RecvBuffer(socket.socket,@socket.buffstr[previous_len+1],100,er);
    if er=WSAEWOULDBLOCK then begin
     setlength(socket.buffstr,previous_len);
     sleep(10);
     continue;
    end else
    if er<>0 then begin
      synchronize(close_us);
      exit;
   end;
   if len<1 then begin
    setlength(socket.buffstr,previous_len);
    sleep(10);
    continue;
   end;

   if length(socket.buffstr)>previous_len+len then setlength(socket.buffstr,previous_len+len);
until (not true);



synchronize(log_connected); // connection established

except
end;
end;

procedure tthread_private_chat.reset_PfileBrowse;
begin
 with PfileBrowse^ do begin
  title:='';
  artist:='';
  album:='';
  path:='';
  category:='';
  comment:='';
  vidinfo:='';
  language:='';
  url:='';
  year:='';
  hash_sha1:='';
  keywords_genre:='';
  param1:=0;
  param2:=0;
  param3:=0;
 end;
end;

procedure tthread_private_chat.invia_browse_files;
var
i:integer;
str,browse_pguid_richiesto:string;
begin
if bytes_in_buffer<17 then exit;

if not ares_frmmain.check_opt_chat_browsable.checked then begin
 user_is_granted_browse:=false;
 synchronize(piglia_user_is_granted_browse);
 if not user_is_granted_browse then exit;
end;

if lista_files_per_browse<>nil then lista_files_per_browse.free;
lista_files_per_browse:=tmystringlist.create;

 try

tipo_per_browse_richiesto:=buffer_ricezione[0];

if tipo_per_browse_richiesto=0 then tipo_per_browse_richiesto:=255;   //2956+
if tipo_per_browse_richiesto=8 then tipo_per_browse_richiesto:=0;

setlength(browse_pguid_richiesto,16);
move(buffer_ricezione[1],browse_pguid_richiesto[1],16);

synchronize(get_lista_browse);


loc_out_text.add(CHRNULL+
                  chr(18)+CHRNULL+
                  chr(CMD_PRIVCHAT_BROWSESTART)+
                  browse_pguid_richiesto+
                  int_2_word_string(lista_files_per_browse.count));

synchronize(send_folders_regular);

for i:=0 to lista_files_per_browse.count-1 do begin
 str:=browse_pguid_richiesto+
      lista_files_per_browse.strings[i];

 loc_out_text.add(CHRNULL+
                  int_2_word_string(length(str))+
                  chr(CMD_PRIVCHAT_BROWSEITEM)+
                  str);   //browse item
end;

loc_out_text.add(CHRNULL+
                 chr(16)+CHRNULL+
                 chr(CMD_PRIVCHAT_BROWSEENDOF)+
                 browse_pguid_richiesto );//browse endof

 except
 end;

lista_files_per_browse.free;
lista_files_per_browse:=nil;

synchronize(log_user_requesting_files);
end;

procedure tthread_private_chat.piglia_user_is_granted_browse;//synch
var
frmpvt:tfrmpvt;
begin
frmpvt:=form as tfrmpvt;
user_is_granted_browse:=frmpvt.Grantbrowse1.checked;
end;

procedure tthread_private_chat.log_disconnected_while_chatting; //synch
var
frmpvt:tfrmpvt;
begin
frmpvt:=form as tfrmpvt;
helper_chatroom_gui.out_text_memo(frmpvt.testo,8,'',GetLangStringW(STR_CONNECTIONCLOSED));
frmpvt.ISconnected:=false;

    terminate;
end;

procedure tthread_private_chat.print_text; // synch
var
frmpvt:tfrmpvt;
begin
  frmpvt:=form as tfrmpvt;
  frmpvt.out_memo(frmpvt.testo,remnick,str_to_be_printed,true);
end;

procedure tthread_private_chat.parse_received_str(socket:ttcpblocksocket);
var
str:string;
i:integer;
lineaw:widestring;
trovato:boolean;
begin
try

if length(socket.buffstr)=0 then exit;

if socket.buffstr[1]=CHRNULL then begin   //new protocol
 parse_received_new(socket);
 exit;
end;


repeat
if terminated then exit;

lineaW:=utf8strtowidestr(socket.buffstr);

trovato:=false;
for i:=1 to length(lineaw) do begin
 if integer(lineaw[i])=10 then begin
  str:=widestrtoutf8str(copy(lineaw,1,i-1));
  delete(socket.buffstr,1,length(str)+1);
  trovato:=true;
  break;
 end;
end;

if not trovato then break;


          if ((pos('|',str)=1) and (pos(':',str)=4)) then begin
            if pos('|01:',str)=1 then begin
             str_to_be_printed:=copy(str,5,length(str));
             synchronize(update_peer_addr_verbose);
            end else
          {  if pos('|04:',str)=1 then begin
             str:=copy(str,5,length(str));
             xaresip:=headercrypt_to_aresip(str);
             synchronize(metti_form14_xaresip);
             if terminated then exit;
            end else   }
            if pos('|02:',str)=1 then begin
             str:=copy(str,5,length(str));
             remnick:=widestrtoutf8str(strippa_fastidiosi(utf8strtowidestr(str),'_'));
             synchronize(metti_form14_nick);
            end else
            if pos('|03:',str)=1 then begin
             exit;
            end;
            continue;
          end;

          if pos(chr(1),str)=1 then continue;

           str_to_be_printed:=widestrtoutf8str(strippa_fastidiosi2(utf8strtowidestr(str)));
           synchronize(print_text);
until (not true);

except
end;
end;

procedure tthread_private_chat.metti_fip_alt;//synch
var
frmpvt:tfrmpvt;
begin
frmpvt:=form as tfrmpvt;
frmpvt.remoteip_alt:=fip_alt;
end;

function tthread_private_chat.get_free_pfile_num:word;
var
i:integer;
found:boolean;
pfile:precord_file_chat_send;
begin

repeat
result:=random(65535);
found:=false;
 for i:=0 to loc_lista_file.count-1 do begin
  pfile:=loc_lista_file[i];
   if pfile^.num=result then begin
    found:=true;
    break;
   end;
 end;
if not found then exit;
until (not true);

end;

procedure tthread_private_chat.file_req_arrived;//synch
var
frmpvt:tfrmpvt;
str:string;
filename:string;
folder:string;
sizei:int64;
node:pCmtVnode;
data,pfile:precord_file_chat_send;
num_referrer:integer;
prograsso:int64;
stream:thandlestream;
begin
try
frmpvt:=form as tfrmpvt;

if int64_capable then begin
 sizei:=chars_2_Qword(copy(str_to_be_printed,1,8));
 num_referrer:=chars_2_word(copy(str_to_be_printed,9,2));

 delete(str_to_be_printed,1,14);       //2951+
end else begin
 sizei:=chars_2_dword(copy(str_to_be_printed,1,4));
 num_referrer:=chars_2_word(copy(str_to_be_printed,5,2));

 delete(str_to_be_printed,1,10);       //2951+
end;

 filename:=copy(str_to_be_printed,1,pos(CHRNULL,str_to_be_printed)-1);
  delete(str_to_be_printed,1,pos(CHRNULL,str_to_be_printed));
 foldeR:=copy(str_to_be_printed,1,pos(CHRNULL,str_to_be_printed)-1);


if not frmpvt.Autoacceptfiles1.checked then begin
if ((not frmpvt.user_granted.checked) and (not first_req_box)) then begin
  //not accepted
 str:=filename+CHRNULL;
   str:=CHRNULL+
        int_2_word_string(length(str))+
        chr(4)+
        str;
 loc_out_text.add(str); //send request...

  node:=frmpvt.listview1.AddChild(nil);
  data:=frmpvt.listview1.getdata(node);
    with data^ do begin
     num:=-1;
     filenameA:=widestrtoutf8str(vars_global.myshared_folder+chr(92){'\'}+extract_fnameW(utf8strtowidestr(filename)));
     folderA:=folder;
     tipoW:=utf8strtowidestr(mediatype_to_str(extstr_to_mediatype(lowercase(extractfileext(filename)))));
     remaining:=-1;
     size:=sizei;
     progress:=0;
     speed:=0;
     stream:=nil;
     transferring:=false;
     upload:=false;
     accepted:=true;
     completed:=true;
     num_referrer:=-1;
     should_stop:=false;
    end;
if frmpvt.listview1.height=0 then postmessage(frmpvt.handle,WM_PRIVCHAT_SHOWTRANVIEW,0,0);
 exit;
end;
         

if not frmpvt.user_granted.checked then
 if messageboxW(frmpvt.handle,pwidechar(GetLangStringW(STR_WARNING_INCOMING_FILE)),pwidechar(appname+chr(58)+chr(32){': '}+GetLangStringW(STR_INCOMING_FILE)),mb_yesno)=ID_NO then begin
  //not accepted
first_req_box:=false;

 str:=filename+CHRNULL;
   str:=CHRNULL+
        int_2_word_string(length(str))+
        chr(CMD_PRIVCHAT_FILEDENY)+
        str;
 loc_out_text.add(str); //send request...

  node:=frmpvt.listview1.AddChild(nil);
  data:=frmpvt.listview1.getdata(node);
   with data^ do begin
    num:=-1;
    filenameA:=widestrtoutf8str(vars_global.myshared_folder+chr(92){'\'}+extract_fnameW(utf8strtowidestr(filename)));
    folderA:=folder;
    tipoW:=utf8strtowidestr(mediatype_to_str(extstr_to_mediatype(lowercase(extractfileext(filename)))));
    remaining:=-1;
    size:=sizei;
    progress:=0;
    speed:=0;
    stream:=nil;
    transferring:=false;
    upload:=false;
    accepted:=true;
    completed:=true;
    num_referrer:=-1;
    should_stop:=false;
   end;
if frmpvt.listview1.height=0 then postmessage(frmpvt.handle,WM_PRIVCHAT_SHOWTRANVIEW,0,0);
 exit;
end;

frmpvt.user_granted.checked:=true;
first_req_box:=false;
end;
                     //start from! 0

 if folder<>'' then tntwindows.Tnt_createdirectoryW(pwidechar(myshared_folder+'\'+utf8strtowidestr(folder)),nil);



 if folder<>'' then begin

      if helper_diskio.fileexistsW(myshared_folder+'\'+utf8strtowidestr(folder)+'\'+extract_fnameW(utf8strtowidestr(filename))) then begin
         prograsso:=helper_diskio.gethugefilesize(myshared_folder+'\'+utf8strtowidestr(folder)+'\'+extract_fnameW(utf8strtowidestr(filename)));
           if prograsso<sizei then stream:=MyFileOpen(myshared_folder+'\'+utf8strtowidestr(folder)+'\'+extract_fnameW(utf8strtowidestr(filename)),ARES_WRITE_EXISTING_BUT_SEQUENTIAL) else begin
            prograsso:=0;
            stream:=MyFileOpen(myshared_folder+'\'+utf8strtowidestr(folder)+'\'+extract_fnameW(utf8strtowidestr(filename)),ARES_OVERWRITE_EXISTING_BUT_SEQUENTIAL);
           end;
      end else begin
        prograsso:=0;
        stream:=MyFileOpen(myshared_folder+'\'+utf8strtowidestr(folder)+'\'+extract_fnameW(utf8strtowidestr(filename)),ARES_OVERWRITE_EXISTING_BUT_SEQUENTIAL);
      end;

 end else begin

       if helper_diskio.fileexistsW(myshared_folder+'\'+extract_fnameW(utf8strtowidestr(filename))) then begin
         prograsso:=helper_diskio.gethugefilesize(myshared_folder+'\'+extract_fnameW(utf8strtowidestr(filename)));
          if prograsso<sizei then stream:=MyFileOpen(myshared_folder+'\'+extract_fnameW(utf8strtowidestr(filename)),ARES_WRITE_EXISTING_BUT_SEQUENTIAL) else begin
           prograsso:=0;
           stream:=MyFileOpen(myshared_folder+'\'+extract_fnameW(utf8strtowidestr(filename)),ARES_OVERWRITE_EXISTING_BUT_SEQUENTIAL);
          end;
       end else begin
        stream:=MyFileOpen(myshared_folder+'\'+extract_fnameW(utf8strtowidestr(filename)),ARES_OVERWRITE_EXISTING_BUT_SEQUENTIAL);
        prograsso:=0;
       end;

 end; //fine

 if stream=nil then begin
  str:=filename+CHRNULL;
  str:=CHRNULL+
       int_2_word_string(length(str))+
       chr(CMD_PRIVCHAT_FILEDENY)+
       str;
  loc_out_text.add(str);
  exit;
 end;

 pfile:=AllocMem(sizeof(record_file_chat_send));
  pfile^.num:=num_referrer;
  pfile^.num_referrer:=num_referrer;
  pfile^.filenameA:=filename;
  pfile^.folderA:=folder;
  pfile^.tipoW:=utf8strtowidestr(mediatype_to_str(extstr_to_mediatype(lowercase(extractfileext(filename)))));
  pfile^.size:=sizei;
  pfile^.remaining:=-1;

  pfile^.progress:=prograsso;
  pfile^.bytesprima:=pfile^.progress;
  pfile^.waiting_for_activation:=false;
  pfile^.speed:=0;

     pfile^.stream:=stream;
     if pfile^.progress<>0 then pfile^.stream.seek(pfile^.progress,sofrombeginning);

  //resume?
  if int64_capable then   //2951+
  str:=int_2_Qword_string(pfile^.progress)+
       filename+CHRNULL+
       folder+CHRNULL
       else
  str:=int_2_dword_string(pfile^.progress)+
       filename+CHRNULL+
       folder+CHRNULL;

  str:=CHRNULL+
       int_2_word_string(length(str))+
       chr(CMD_PRIVCHAT_FILEACK)+
       str;
 loc_out_text.add(str); //send request...

 with pfile^ do begin
  transferring:=true;
  upload:=false;
  accepted:=true;
  completed:=false;
  last_data:=gettickcount;
 end;
   loc_lista_file.add(pfile);



 node:=frmpvt.listview1.AddChild(nil);
  data:=frmpvt.listview1.getdata(node);
  with data^ do begin
    num:=pfile^.num;
    num_referrer:=pfile^.num_referrer;
    folderA:=folder;
    filenameA:=widestrtoutf8str(myshared_folder+'\'+extract_fnameW(utf8strtowidestr(filename)));
    tipoW:=pfile^.tipoW; //widestring!!
    remaining:=-1;
    size:=pfile^.size;
    progress:=0;
    speed:=0;
    stream:=nil;
    transferring:=true;
    upload:=false;
    accepted:=true;
    completed:=false;
    should_stop:=false;
  end;

if frmpvt.listview1.height=0 then postmessage(frmpvt.handle,WM_PRIVCHAT_SHOWTRANVIEW,0,0);

except
end;
end;


procedure tthread_private_chat.file_deny_arrived;//synch
var
i:integer;
pfile:precord_file_chat_send;
filenameStr:string;
begin
try

for i:=0 to bytes_in_buffer-1 do begin
 if buffer_ricezione[i]=0 then begin
  setlength(filenameStr,i);
  move(buffer_ricezione[0],filenameStr[1],i);
 break;
 end;
end;


for i:=0 to loc_lista_file.count-1 do begin
 pfile:=loc_lista_file[i];
 with pfile^ do begin
   if waiting_for_activation then continue;
   if completed then continue;
   if filenameStr<>filenameA then continue;

   completed:=true;
   transferring:=false;
    if stream<>nil then FreeHandleStream(stream);

   stream:=nil;
 end;
   break;
end;

except
end;
end;

procedure tthread_private_chat.file_ack_arrived;
var
filenameSTR:string;
pfile:precord_file_chat_send;
i:integer;
startP:int64;
begin
try

if int64_capable then begin
 move(buffer_ricezione[0],startP,8);

 for i:=8 to bytes_in_buffer-1 do begin
  if buffer_ricezione[i]=0 then begin
   setlength(filenameStr,i-8);
   move(buffer_ricezione[8],filenameStr[1],i-8);
  break;
  end;
 end;
end else begin
 fillchar(startp,8,0);
 move(buffer_ricezione[0],startP,4);

 for i:=4 to bytes_in_buffer-1 do begin
  if buffer_ricezione[i]=0 then begin
   setlength(filenameStr,i-4);
   move(buffer_ricezione[4],filenameStr[1],i-4);
  break;
  end;
 end;
end;



for i:=0 to loc_lista_file.count-1 do begin
 pfile:=loc_lista_file[i];

 with pfile^ do begin
  if waiting_for_activation then continue;
  if completed then continue;
  if not upload then continue;
  if accepted then continue;
  if transferring then continue;
  if filenameStr<>filenameA then continue;

  accepted:=true;
  transferring:=true;
  last_data:=gettickcount;

  stream:=MyFileOpen(utf8strtowidestr(filenameStr),ARES_READONLY_BUT_SEQUENTIAL);
  if stream=nil then begin
     completed:=true;
     transferring:=false;
     stream:=nil;
    exit;
  end;


  if startP>0 then begin
   stream.seek(startP,SOFROMBEGINNING);
   progress:=startP;
   bytesprima:=startP;
  end else begin
   progress:=0;
   bytesprima:=0;
  end;

 end;
break;
end;

except
end;
end;

procedure tthread_private_chat.block_file_received;
var
num_referrerI:word;
i:integer;
pfile:precord_file_chat_send;
begin
try

move(buffer_ricezione[0],num_referrerI,2);


for i:=0 to loc_lista_file.count-1 do begin
 pfile:=loc_lista_file[i];
 with pfile^ do begin
  if waiting_for_activation then continue;
  if completed then continue;
  if upload then continue;
  if not transferring then continue;
  if num_referrer<>num_referrerI then continue;

   stream.write(buffer_ricezione[2],bytes_in_buffer-2);
    inc(progress,bytes_in_buffer-2);
      last_data:=gettickcount;

     if progress>=size then completed:=true;
   end;
  break;
end;

except
end;
end;

procedure tthread_private_chat.parse_pong(newFormat:boolean=false);
begin
last_pong_remotehost:=gettickcount;

if bytes_in_buffer<12 then exit;

if not newFormat then synchronize(update_peer_addr_buffer);
end;

procedure tthread_private_chat.accetta_browse_diretto;//synch
var
frmpvt:tfrmpvt;
begin
frmpvt:=form as tfrmpvt;

if frmpvt.tabview.PanelsCount=1 then begin
 frmpvt.crea_visual_browse;
 frmpvt.tabview.activePage:=0;
 frmpvt.readyToBrowse:=true; // this enables the tabview.onpanelshow event to trigger the first 'browse event' 
end;

frmpvt.Browseuserfile1.visible:=true;
end;

procedure tthread_private_chat.send_pong;
var
MyDeT:string;
begin
MyDet:=helper_ipFunc.serialize_myConDetails;
loc_out_text.add(CHRNULL+
                 chr(length(MyDet))+CHRNULL+
                 chr(CMD_PRIVCHAT_PONGNEW)+
                 MyDet);
end;

procedure tthread_private_chat.get_lista_browse;//synch
var
i:integer;
pfile:precord_file_library;
begin
try

for i:=0 to vars_global.lista_shared.Count-1 do begin
 pfile:=vars_global.lista_shared[i];

 if not pfile^.shared then continue;
 if pfile^.corrupt then continue;

 if tipo_per_browse_richiesto<>255 then begin
  if pfile^.amime<>tipo_per_browse_richiesto then continue;
 end;

 lista_files_per_browse.add( keywfunc.get_serialize_file_browse_pvt(pfile, vars_global.allow_regular_paths_browse) );
end;

except
end;
end;

procedure tthread_private_chat.send_folders_regular;//synch
var
cartella:precord_cartella_sharE;
nodo:pCmtVnode;
begin

if vars_global.allow_regular_paths_browse then begin
 nodo:=ares_FrmMain.treeview_lib_regfolders.getfirst;
 if nodo=nil then exit;

 repeat
 nodo:=ares_FrmMain.treeview_lib_regfolders.getnext(nodo);
 if nodo=nil then exit;
  cartella:=ares_FrmMain.treeview_lib_regfolders.getdata(nodo);

     if not is_shared_infolder(nodo,cartella) then continue;

     loc_out_text.add(CHRNULL+
                      int_2_word_string(length(cartella^.display_path)+2)+
                      chr(CMD_PRIVCHAT_BROWSE_REALFOLDER)+
                      int_2_word_string(cartella^.id)+
                      cartella^.display_path);
 until (not true);

end;

end;

function tthread_private_chat.is_shared_infolder(nodo:pCmtVnode; cartella:precord_cartella_share):boolean;
var
nodo_child:pCmtVnode;
level_att:cardinal;
data:precord_cartella_share;
begin
result:=false;

if cartella^.items_shared>0 then begin
 result:=true;
 exit;
end;

if nodo.childcount=0 then exit;


level_att:=ares_FrmMain.treeview_lib_regfolders.getnodelevel(nodo);

nodo_child:=ares_FrmMain.treeview_lib_regfolders.getnext(nodo);
while (nodo_child<>nil) do begin

 if ares_FrmMain.treeview_lib_regfolders.getnodelevel(nodo_child)<=level_att then exit;
 data:=ares_FrmMain.treeview_lib_regfolders.getdata(nodo_child);

 if data^.items_shared<1 then begin
  nodo_child:=ares_FrmMain.treeview_lib_regfolders.getnext(nodo_child);
  continue;
 end;

  result:=true;

  exit;

nodo_child:=ares_FrmMain.treeview_lib_regfolders.getnext(nodo_child);
end;

end;

procedure tthread_private_chat.log_user_requesting_files;
var
frmpvt:tfrmpvt;
begin
frmpvt:=form as tfrmpvt;
helper_chatroom_gui.out_text_memo(frmpvt.testo,8,'',GetLangStringW(STR_USERISBROWSINGYOU));
end;

procedure tthread_private_chat.close_us;//sync
var
frmpvt:tfrmpvt;
begin
terminate;
frmpvt:=form as tfrmpvt;
postmessage(frmpvt.handle,WM_THREAD_PRIVCHAT_END,11,11);
end;

procedure tthread_private_chat.add_result;  // synch
var
ext:string;
placeholder:precord_file_library;
frmpvt:tfrmpvt;
begin
try
 frmpvt:=form as tfrmpvt;
 if frmpvt.comettree1=nil then exit;

if not comparemem(@frmpvt.guid_browse,@PfileBrowse^.guid_search,sizeof(tguid)) then exit;

        if ares_frmmain.Check_opt_hlink_filterexe.checked then begin
         if PfileBrowse^.amime=3 then exit;
          if PfileBrowse^.amime=0 then begin
           ext:=lowercase(extractfileext(PfileBrowse^.path));
            if pos(ext,STR_EXE_EXTENS)<>0 then exit;
          end;
        end;

   // match artist, title, album  search complex...
        if length(PfileBrowse^.title)>0 then PfileBrowse^.title:=ucfirst(PfileBrowse^.title);
        if length(PfileBrowse^.album)>0 then PfileBrowse^.album:=ucfirst(PfileBrowse^.album);
        if length(PfileBrowse^.artist)>0 then PfileBrowse^.artist:=ucfirst(PfileBrowse^.artist);
        PfileBrowse^.downloaded:=false;


       inc(frmpvt.browsed_bytes,PfileBrowse^.fsize);


     placeholder:=Allocmem(sizeof(record_file_library));
     with placeholder^ do begin
      filedate:=0;
      title:=PfileBrowse^.title;
      artist:=PfileBrowse^.artist;
      shared:=false;
      folder_id:=PfileBrowse^.folder_id;
         already_in_lib:=(is_in_lib_sha1(PfileBrowse^.hash_sha1));
         being_downloaded:=(is_in_progress_sha1(PfileBrowse^.hash_sha1));
      album:=PfileBrowse^.album;
      path:=PfileBrowse^.path;
      keywords_genre:=PfileBrowse^.keywords_genre;
      category:=PfileBrowse^.category;
      comment:=PfileBrowse^.comment;
      language:=PfileBrowse^.language;
      url:=PfileBrowse^.url;
      year:=PfileBrowse^.year;
      fsize:=PfileBrowse^.fsize;
      param1:=PfileBrowse^.param1;
      param2:=PfileBrowse^.param2;
      param3:=PfileBrowse^.param3;
      amime:=PfileBrowse^.amime;
      hash_sha1:=PfileBrowse^.hash_sha1;
      crcsha1:=PfileBrowse^.crcsha1;
      vidinfo:=PfileBrowse^.vidinfo;
     end;
        frmpvt.lista_files_utente.add(placeholder);

        if (frmpvt.lista_files_utente.count mod 50)=0 then put_progress_browse(frmpvt.lista_files_utente.count);
except
end;
end;


procedure tthread_private_chat.add_browse_item2;
var
mime:byte;
num:byte;
fsize:int64;
hash_sha1,ext,path:string;
param1,param2,param3:integer;
key1,key2,key3,category,album,language,url,year,comments,vidinfo,keyword_genre:string;
search_main_guid:tguid;
folder_id:integer;
global_cont:string;
begin

  fillchar(search_main_guid,16,0);
  move(buffer_ricezione[0],search_main_guid,16);

  setlength(global_cont,bytes_in_buffer-16);
  move(buffer_ricezione[16],global_cont[1],bytes_in_buffer-16);

mime:=ord(global_cont[1]);
fsize:=chars_2_dword(copy(global_cont,2,4));
hash_sha1:=NULL_SHA1;

delete(global_cont,1,21);
ext:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);

if length(ext)<1 then exit;
param1:=0;
param2:=0;
param3:=0;
folder_id:=0;

delete(global_cont,1,pos(CHRNULL,global_cont));

repeat
 if length(global_cont)<3 then break;
  if global_cont[1]=chr(PRIVCHAT_BROWSE_KEY1) then begin
   delete(global_cont,1,1);
   key1:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
   delete(global_cont,1,pos(CHRNULL,global_cont));
  end else
  if global_cont[1]=chr(PRIVCHAT_BROWSE_KEY2) then begin
   delete(global_cont,1,1);
   key2:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
   delete(global_cont,1,pos(CHRNULL,global_cont));
  end else
  if global_cont[1]=chr(PRIVCHAT_BROWSE_KEY3) then begin
   delete(global_cont,1,1);
   key3:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
   delete(global_cont,1,pos(CHRNULL,global_cont));
  end else break;
until (not true);

 if length(global_cont)>2 then begin
  if global_cont[1]=chr(4) then begin

  if mime=ARES_MIME_MP3 then begin
   param1:=chars_2_word(copy(global_cont,2,2));
   param2:=0;
   param3:=chars_2_dword(copy(global_cont,4,4));
   delete(global_cont,1,7);
  end else
  if ((mime=ARES_MIME_VIDEO) or (mime=ARES_MIME_IMAGE)) then begin
   param1:=chars_2_word(copy(global_cont,2,2));
   param2:=chars_2_word(copy(global_cont,4,2));
   param3:=chars_2_dword(copy(global_cont,6,4));
   delete(global_cont,1,9);
      if mime=ARES_MIME_VIDEO then begin
       if ((param1>4000) or (param2>4000)) then begin
         param1:=0;
         param2:=0;
         param3:=0;
       end;
      end;
  end else begin
   param1:=0;
   param2:=0;
   param3:=0;
   delete(global_cont,1,1);
  end;

   if ((mime=ARES_MIME_MP3) or (mime=ARES_MIME_AUDIOOTHER1) or (mime=ARES_MIME_IMAGE)) then album:=key3
    else category:=key3;

repeat
if length(global_cont)<2 then break;
   num:=ord(global_cont[1]);
    delete(global_cont,1,1);
   case num of
    PRIVCHAT_BROWSE_CATEGORY:category:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
    PRIVCHAT_BROWSE_ALBUM:album:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
    PRIVCHAT_BROWSE_COMMENTS:comments:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
    PRIVCHAT_BROWSE_LANGUAGE:language:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
    PRIVCHAT_BROWSE_URL:url:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
    PRIVCHAT_BROWSE_YEAR:year:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
    PRIVCHAT_BROWSE_FORMAT:if mime=5 then vidinfo:=copy(global_cont,1,pos(CHRNULL,global_cont)-1) else vidinfo:='';
    PRIVCHAT_BROWSE_PATH:path:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
    PRIVCHAT_BROWSE_KEYWORD_GENRE:keyword_genre:=copy(global_cont,1,pos(CHRNULL,global_cont)-1);
    PRIVCHAT_BROWSE_SHA1:hash_sha1:=decodebase64(copy(global_cont,1,pos(CHRNULL,global_cont)-1));
    PRIVCHAT_BROWSE_FOLDERID:folder_id:=strtointdef(copy(global_cont,1,pos(CHRNULL,global_cont)-1),0);
    PRIVCHAT_BROWSE_INT64SIZE:fsize:=strtoint64def(copy(global_cont,1,pos(CHRNULL,global_cont)-1),0) else break;
   end;
    delete(global_cont,1,pos(CHRNULL,global_cont));
until (not true);  //loop parse details....

//check overflows...........
      if length(key1)>MAX_LENGTH_TITLE then delete(key1,MAX_LENGTH_TITLE,length(key1));
      if length(key2)>MAX_LENGTH_FIELDS then delete(key2,MAX_LENGTH_FIELDS,length(key2));
      if length(album)>MAX_LENGTH_FIELDS then delete(album,MAX_LENGTH_FIELDS,length(album));
      if length(category)>MAX_LENGTH_FIELDS then delete(category,MAX_LENGTH_FIELDS,length(category));
      if length(language)>MAX_LENGTH_FIELDS then delete(language,MAX_LENGTH_FIELDS,length(language));
      if length(year)>MAX_LENGTH_FIELDS then delete(year,MAX_LENGTH_FIELDS,length(year));
      if length(comments)>MAX_LENGTH_COMMENT then delete(comments,MAX_LENGTH_COMMENT,length(comments));
      if length(url)>MAX_LENGTH_URL then delete(url,MAX_LENGTH_URL,length(url));
////////////////////////////////////

end;
end;

 reset_PfileBrowse;

 PfileBrowse^.title:=key1;
 PfileBrowse^.artist:=key2;
 PfileBrowse^.category:=category;
 PfileBrowse^.keywords_genre:=keyword_genre;
 PfileBrowse^.album:=album;
 PfileBrowse^.path:=path;
 PfileBrowse^.folder_id:=folder_id;
  inc_items_folder_shared(folder_id);

  if PfileBrowse^.path='' then begin
   if ((length(PfileBrowse^.album)>0) and (length(PfileBrowse^.artist)>0)) then PfileBrowse^.path:=PfileBrowse^.artist+chr(32)+chr(45)+chr(32){' - '}+PfileBrowse^.album+chr(32)+chr(45)+chr(32){' - '}+PfileBrowse^.title+ext else
   if length(PfileBrowse^.artist)>0 then PfileBrowse^.path:=PfileBrowse^.artist+chr(32)+chr(45)+chr(32){' - '}+PfileBrowse^.title+ext else
   PfileBrowse^.path:=PfileBrowse^.title+ext;
  end;

 PfileBrowse^.comment:=comments;
 PfileBrowse^.language:=language;
 PfileBrowse^.url:=url;
 PfileBrowse^.vidinfo:=vidinfo;
 PfileBrowse^.year:=year;
 PfileBrowse^.fsize:=fsize;
 PfileBrowse^.amime:=mime;
 PfileBrowse^.param1:=param1;
 PfileBrowse^.param2:=param2;
 PfileBrowse^.param3:=param3;
 PfileBrowse^.guid_search:=search_main_guid;
 PfileBrowse^.hash_sha1:=hash_sha1;
 PfileBrowse^.crcsha1:=crcstring(PfileBrowse^.hash_sha1);


 synchronize(add_result);

end;

procedure tthread_private_chat.arrivato_file_browse;
begin
if bytes_in_buffer<35 then exit;
 add_browse_item2;
end;

procedure tthread_private_chat.categs_sort;
begin
if artists_audio.count>1 then artists_audio.Sort(CompFunc_strings);
if albums_audio.count>1 then albums_audio.Sort(CompFunc_strings);
if albums_image.count>1 then albums_image.Sort(CompFunc_strings);
if authors_document.count>1 then authors_document.Sort(CompFunc_strings);
if companies_software.count>1 then companies_software.Sort(CompFunc_strings);


if categs_audio.count>1 then categs_audio.Sort(CompFunc_strings);
if categs_video.count>1 then categs_video.Sort(CompFunc_strings);
if categs_image.count>1 then categs_image.Sort(CompFunc_strings);
if categs_software.count>1 then categs_software.Sort(CompFunc_strings);
if categs_document.count>1 then categs_document.Sort(CompFunc_strings);
if categs_software.count>1 then categs_software.Sort(CompFunc_strings);
end;

procedure tthread_private_chat.set_end_of_browse;     //synch
var
frmpvt:tfrmpvt;
reg:tregistry;
nodo,nodo_root:pCmtVnode;
datao:precord_file_library;
begin
try
frmpvt:=form as tfrmpvt;
with frmpvt do begin

 if Comettree1=nil then exit;

if length(str_to_be_printed)<16 then exit;

if copy(str_to_be_printed,1,16)<>guid_browsestr then exit;


if lista_files_utente.count=0 then begin //0 files!
 nodo:=Comettree1.GetFirst;
 if nodo=nil then exit;
  datao:=Comettree1.GetData(nodo);
   datao^.title:=GetLangStringA(STR_BROWSECOMPLETED)+' 0 '+GetLangStringA(STR_FILES);
    Comettree1.invalidatenode(nodo);
exit;
end;

categs_compute;
categs_sort;

lockwindowupdate(handle);

try

with comettree1 do begin
 clear;
 selectable:=true;
 canbgcolor:=true;
end;

add_base_virtualnodes(treeview1,false);
aggiorna_folder_normal(treeview2);


categs_writetoGUI;

reg:=tregistry.create;
with reg do begin
 openkey(areskey+'bounds',true);
 if valueexists('PM.BrowseWidth') then begin
  panel_left.width:=readinteger('PM.BrowseWidth');
   if panel_left.width<50 then panel_left.width:=50 else
   if panel_left.width>500 then panel_left.width:=500;
 end else panel_left.width:=200;
 closekey;
 destroy;
end;

 nodo_root:=treeview2.getfirst;
 tasto_regular_view.visible:=(nodo_root.childcount>0);

 splitter2.Width:=4;
except
end;

end;



frmpvt.seleziona_primo_in_library;

except
end;

lockwindowupdate(0);
end;

procedure tthread_private_chat.put_progress_browse(count:integer);//sync
var
frmpvt:tfrmpvt;
percentuale:string;
progress:double;
nodo:pCmtVnode;
datao:precord_file_library;
begin
frmpvt:=form as tfrmpvt;

with frmpvt do begin
 if Comettree1=nil then exit;

   progress:= count;
   progress:= progress/browse_files_totali_utente;
   progress:=progress*100;

   percentuale:=FloatToStrF(progress, ffNumber, 18, 2);
   delete(percentuale,pos(chr(46){'.'},percentuale),length(percentuale));
   percentuale:=percentuale+chr(37){'%'};

 with comettree1 do begin
  nodo:=getfirst;
  if nodo=nil then exit;
  datao:=getdata(nodo);
  datao^.title:=GetLangStringA(STR_BROWSEINPROGRESS)+chr(32)+percentuale+' ('+format_currency(count)+chr(32)+GetLangStringA(STR_OF)+chr(32)+
                format_currency(frmpvt.browse_files_totali_utente)+chr(32)+GetLangStringA(STR_FILES)+chr(41){')'};

   invalidatenode(nodo);
 end;

end;
end;

procedure tthread_private_chat.set_start_of_browse;  //synch
var
frmpvt:tfrmpvt;
nodo:pCmtVnode;
data:precord_file_library;
begin
frmpvt:=form as tfrmpvt;
with frmpvt do begin
 if Comettree1=nil then exit;

 if length(str_to_be_printed)<18 then exit;
if copy(str_to_be_printed,1,16)<>guid_browsestr then exit;
 delete(str_to_be_printed,1,16);


browse_files_totali_utente:=chars_2_word(copy(str_to_be_printed,1,2));

 with comettree1 do begin
  nodo:=getfirst;
  if nodo=nil then exit;

  data:=getdata(nodo);
  data^.title:=GetLangStringA(STR_BROWSEINPROGRESS)+' (0 '+GetLangStringA(STR_OF)+chr(32)+
                        format_currency(frmpvt.browse_files_totali_utente)+chr(32)+GetLangStringA(STR_FILES)+chr(41){')'};
   invalidatenode(nodo);
 end;
end;

end;

procedure tthread_private_chat.clear_folders_shared;
var
cartella:precord_cartella_share;
begin
  if folders_shared_remote<>nil then begin
     while (folders_shared_remote.count>0) do begin
          cartella:=folders_shared_remote[folders_shared_remote.count-1];
                     folders_shared_remote.delete(folders_shared_remote.count-1);
               with cartella^ do begin
                path:='';
                display_path:='';
               end;
             FreeMem(cartella,sizeof(record_cartella_share));
    end;
   end;
end;

procedure tthread_private_chat.inc_items_folder_shared(folder_id:word);
var
i:integer;
cartella:precord_cartella_share;
begin
if folders_shared_remote=nil then exit;

 for i:=0 to folders_shared_remote.count-1 do begin
  cartella:=folders_shared_remote[i];
  if cartella^.id=folder_id then begin
   inc(cartella^.items);
   exit;
  end;
 end;

end;

procedure tthread_private_chat.add_folder_shared(folder_id:word;fname:string);
var
cartella:precord_cartella_share;
begin

cartella:=AllocMem(sizeof(record_cartella_share));
 with cartella^ do begin
  path:=chr(92){'\'}+utf8strtowidestr(fname);
  items:=0;
  id:=folder_id;
  display_path:=fname;
 end;

 if folders_shared_remote=nil then folders_shared_remote:=tmylist.create;
  folders_shared_remote.add(cartella);
end;

procedure tthread_private_chat.process_command(cmd:byte);
var
folder_id:word;
ipi:cardinal;
//ips:string;
begin

try

case cmd of

      CMD_PRIVCHAT_MESSAGE:begin
            if bytes_in_buffer>MAX_DCCHAT_LINE_LEN then bytes_in_buffer:=MAX_DCCHAT_LINE_LEN;
              setlength(str_to_be_printed,bytes_in_buffer);
              move(buffer_ricezione[0],str_to_be_printed[1],bytes_in_buffer);
           synchronize(print_text);
      end;

      CMD_PRIVCHAT_FILEREQUEST:begin //send file request
          setlength(str_to_be_printed,bytes_in_buffer);
          move(buffer_ricezione[0],str_to_be_printed[1],bytes_in_buffer);
        synchronize(file_req_arrived);
      end;

      CMD_PRIVCHAT_FILEACK:file_ack_arrived;

      CMD_PRIVCHAT_FILEDENY:file_deny_arrived;

      CMD_PRIVCHAT_FILECHUNK:block_file_received;

      CMD_PRIVCHAT_PING:send_pong;

      CMD_PRIVCHAT_PONG:parse_pong;
      CMD_PRIVCHAT_PONGNEW:parse_pong(true);

      CMD_PRIVCHAT_INTERNALIP:begin
          move(buffer_ricezione[0],fip_alt,4);
          if bytes_in_buffer>4 then
           if buffer_ricezione[4]=1 then int64_capable:=true;   //2951+  5-1-2005

          synchronize(metti_fip_alt);
         end;

      CMD_PRIVCHAT_BROWSEGRANTED:synchronize(accetta_browse_diretto);

      CMD_PRIVCHAT_BROWSEREQ:invia_browse_files;

      CMD_PRIVCHAT_BROWSEITEM:arrivato_file_browse;//browse_item

      CMD_PRIVCHAT_BROWSEENDOF:begin
        categs_free; //nel caso...
        categs_init;
              setlength(str_to_be_printed,bytes_in_buffer);
              move(buffer_ricezione[0],str_to_be_printed[1],bytes_in_buffer);
       synchronize(set_end_of_browse);
        categs_free;
      end;

      CMD_PRIVCHAT_BROWSESTART:begin
              setlength(str_to_be_printed,bytes_in_buffer);
              move(buffer_ricezione[0],str_to_be_printed[1],bytes_in_buffer);
               clear_folders_shared;
       synchronize(set_start_of_browse);
      end;

      CMD_PRIVCHAT_USERIPNEW:begin
        int64_capable:=true;
        setlength(str_to_be_printed,bytes_in_buffer);
        move(buffer_ricezione[0],str_to_be_printed[1],bytes_in_buffer);
        synchronize(update_peer_addr_newformat);
      end;

      CMD_PRIVCHAT_USERIP:begin //send new xaresip
              setlength(str_to_be_printed,bytes_in_buffer);
              move(buffer_ricezione[0],str_to_be_printed[1],bytes_in_buffer);
            if length(str_to_be_printed)>=12 then begin
               /////////////////////////////////////////////// se è mai connesso questo valore può essere sbagliato
               if chars_2_dword(copy(str_to_be_printed,7,4))=0 then begin
                ipi:=inet_addr(pchar(socket.ip));
                move(ipi,str_to_be_printed[7],4);
               end;
          {   xaresip:=ipint_to_dotstring(chars_2_dword(copy(str_to_be_printed,1,4)))+':'+
                      inttostr(chars_2_word(copy(str_to_be_printed,5,2)))+'|'+
                      ipint_to_dotstring(chars_2_dword(copy(str_to_be_printed,7,4)))+':'+
                      inttostr(chars_2_word(copy(str_to_be_printed,11,2)));  }
             synchronize(update_peer_addr_binary);
           end;
      end;

      CMD_PRIVCHAT_USERNICK:begin //send new nick
          if bytes_in_buffer<2 then exit;
             setlength(str_to_be_printed,bytes_in_buffer);
             move(buffer_ricezione[0],str_to_be_printed[1],bytes_in_buffer);
          if length(str_to_be_printed)>2 then
           remnick:=widestrtoutf8str(strippa_fastidiosi(utf8strtowidestr(copy(str_to_be_printed,1,pos(CHRNULL,str_to_be_printed)-1)),chr(95){'_'}))
            else remnick:=ipdotstring_to_anonnick(ipint_to_dotstring(fip));
           if length(remnick)>MAX_NICK_LEN then remnick:=copy(remnick,1,MAX_NICK_LEN);
          synchronize(metti_form14_nick);
      end;

      CMD_PRIVCHAT_BROWSE_REALFOLDER:begin
             if bytes_in_buffer<3 then exit;
            move(buffer_ricezione[0],folder_id,2);
            setlength(str_to_be_printed,bytes_in_buffer-2);
            move(buffer_ricezione[2],str_to_be_printed[1],bytes_in_buffer-2);
            add_folder_shared(folder_id,str_to_be_printed);
        end;
end;


except
end;
end;

procedure tthread_private_chat.parse_received_new(socket:ttcpblocksocket);
var
cmd:byte;
len:word;
begin
try

repeat
if length(socket.buffstr)<4 then exit;

 move(socket.buffstr[2],len,2);
 cmd:=ord(socket.buffstr[4]);

if length(socket.buffstr)<len+4 then exit;


 move(socket.buffstr[5],buffer_ricezione[0],len);
 bytes_in_buffer:=len;
 delete(socket.buffstr,1,len+4);
 
 process_command(cmd);

if length(socket.buffstr)=0 then begin
 new_protocol:=true;
 bytes_in_buffer:=0;
 bytes_in_header:=0;
 exit;
end;

until (not true);

except
end;
end;

procedure tthread_private_chat.shutdown_transfers;
var
i:integer;
pfile:precord_file_chat_send;
begin
try

for i:=0 to loc_lista_file.count-1 do begin
 pfile:=loc_lista_file[i];
  with pfile^ do begin
    completed:=true;
    if stream<>nil then FreeHandleStream(Stream);

    stream:=nil;
  end;
end;

synchronize(privchat_update_transferview);
except
end;
end;

procedure tthread_private_chat.send;
var
er:integer;
str:string;
i:integer;
pfile:precord_file_chat_send;
hsock:integer;
lenp,len:word;
cicli:byte;
num_presenti:integer;
begin
try

if socket=nil then exit;


while (loc_out_text.count>0) do begin
  str:=loc_out_text.strings[0];
  TCPSocket_SendBuffer(socket.socket,@str[1],length(str),er);

  if er=WSAEWOULDBLOCK then exit;

 if er<>0 then begin
   hsock:=socket.socket;
    TCPSocket_Free(hsock);
   socket.free;
   socket:=nil;
   loc_out_text.clear;
    shutdown_transfers;
    synchronize(log_disconnected_while_chatting);
   exit;
 end;
  loc_out_text.delete(0);

end;



//////////////////////////////////////////////
if loc_lista_file.count=0 then exit;
cicli:=0;
num_presenti:=loc_lista_file.count;

while (true) do begin

if cicli>100 then break;
inc(cicli);

if num_presenti=0 then exit;
num_presenti:=0;

//send files
for i:=0 to loc_lista_file.count-1 do begin
 pfile:=loc_lista_file[i];

 if not pfile^.upload then continue;
 if pfile^.completed then continue;
 if not pfile^.transferring then continue;
   inc(num_presenti);
   if pfile^.stream.position<>pfile^.progress then pfile^.stream.seek(pfile^.progress,SOFROMBEGINNING);


  len:=pfile^.stream.Read(buffer1,1024);
  if len<=0 then begin
    pfile^.completed:=true;
    pfile^.transferring:=false;
    if pfile^.stream<>nil then FreeHandleStream(pfile^.stream);

    pfile^.stream:=nil;
   exit;
  end;

   lenp:=len+2;
   buffer_out_pfile[0]:=0;
  move(lenp,buffer_out_pfile[1],2);
   buffer_out_pfile[3]:=5; //cmd 5
  move(pfile^.num_referrer,buffer_out_pfile[4],2);

  move(buffer1,buffer_out_pfile[6],len);
               
  TCPSocket_SendBuffer(socket.socket,@buffer_out_pfile[0],len+6,er);

  if er=WSAEWOULDBLOCK then begin
   pfile^.stream.seek(pfile^.progress,SOFROMBEGINNING);
   exit;
  end;

  if er<>0 then begin
     hsock:=socket.socket;
     TCPSocket_Free(hsock);
     socket.free;
     socket:=nil;
     loc_out_text.clear;
      shutdown_transfers;
      synchronize(log_disconnected_while_chatting);
     exit;
  end;
         
  pfile^.last_data:=gettickcount;
  inc(pfile^.progress,len);
  
end;


end;

except
end;
end;

procedure tthread_private_chat.attiva_pfile(pfile:precord_file_chat_send);
var
str:string;
begin
try
 pfile^.waiting_for_activation:=false;

if pfile^.size>LIMIT_INTEGER then
 if not int64_capable then begin
  pfile^.completed:=true;
  exit;
 end;

if not int64_capable then begin
 str:=int_2_dword_string(pfile^.size)+
      int_2_word_string(pfile^.num_referrer)+
      int_2_dword_string(pfile^.randomsenu)+
      pfile^.filenameA+CHRNULL+
      pfile^.folderA+CHRNULL;
end else begin
 str:=int_2_Qword_string(pfile^.size)+
      int_2_word_string(pfile^.num_referrer)+
      int_2_dword_string(pfile^.randomsenu)+
      pfile^.filenameA+CHRNULL+
      pfile^.folderA+CHRNULL;
end;

     str:=CHRNULL+
          int_2_word_string(length(str))+
          chr(CMD_PRIVCHAT_FILEREQUEST)+
          str;

loc_out_text.add(str); //send request...
except
end;
end;

procedure tthread_private_chat.attiva_pfiles;
var
i,num_transfer:integer;
pfile:precord_file_chat_send;
begin
try

num_transfer:=0;
for i:=0 to loc_lista_file.count-1 do begin
 pfile:=loc_lista_file[i];
 if ((pfile^.upload) and (not pfile^.completed) and (not pfile^.waiting_for_activation)) then inc(num_transfer);
end;

if num_transfer>=NUM_MAX_TRANSFERS_PRIVCHAT then exit; //max 2 transfers

for i:=0 to loc_lista_file.count-1 do begin
 pfile:=loc_lista_file[i];
 if pfile^.waiting_for_activation then begin
  attiva_pfile(pfile);
  exit;
 end;
end;

except
end;
end;

procedure tthread_private_chat.prendi_pfiles;//synch
var
frmpvt:tfrmpvt;
pfile,datao:precord_file_chat_send;
node:pCmtVnode;
begin
try

 frmpvt:=form as tfrmpvt;
 with frmpvt do begin
  while (lista_file.count>0) do begin

   pfile:=lista_file[0];
          lista_file.delete(0);

   pfile^.waiting_for_activation:=true;
   loc_lista_file.add(pfile);

    pfile^.num_referrer:=get_free_pfile_num;
    pfile^.num:=pfile^.num_referrer;

   node:=listview1.AddChild(nil);
  datao:=listview1.getdata(node);
   with datao^ do begin
    num:=pfile^.num_referrer;
    num_referrer:=pfile^.num_referrer;
    filenameA:=pfile^.filenameA;
    folderA:=pfile^.folderA;
    tipoW:=pfile^.tipoW;
    remaining:=-1;
    size:=pfile^.size;
    progress:=0;
    speed:=0;
    stream:=nil;
    transferring:=false;
    upload:=true;
    accepted:=false;
    completed:=false;
    should_stop:=false;
   end;
  end;
 end;

except
end;
end;

procedure tthread_private_chat.send_text(text:string);
var
str:string;
begin
   str:=text;
    str:=CHRNULL+
         int_2_word_string(length(str))+
         chr(CMD_PRIVCHAT_MESSAGE)+
         str;
   loc_out_text.add(str);
end;

procedure tthread_private_chat.categs_compute;  //synch
var
frmpvt:tfrmpvt;
i:integer;
pfile:precord_file_library;
artista,categoria,album:string;
begin
 frmpvt:=form as tfrmpvt;

 for i:=0 to frmpvt.lista_files_utente.count-1 do begin
  if (i mod 500)=0 then sleep(1);
  pfile:=frmpvt.lista_files_utente[i];


    if length(pfile^.artist)<2 then artista:=GetLangStringA(STR_UNKNOWN)
     else artista:=copy(pfile^.artist,1,length(pfile^.artist));
    if length(pfile^.category)<2 then categoria:=GetLangStringA(STR_UNKNOWN)
     else categoria:=copy(pfile^.category,1,length(pfile^.category));
    if length(pfile^.album)<2 then album:=GetLangStringA(STR_UNKNOWN)
     else album:=copy(pfile^.album,1,length(pfile^.album));

 case pfile^.amime of
  ARES_MIME_OTHER:inc(num_other);
  ARES_MIME_MP3,ARES_MIME_AUDIOOTHER1,ARES_MIME_AUDIOOTHER2:begin
   inc(num_audio); //mp3
    add_virfolders_entry(artists_audio,artista);
    add_virfolders_entry(albums_audio,album);
    add_virfolders_entry(categs_audio,categoria);
  end;
  ARES_MIME_SOFTWARE:begin
   inc(num_software);
    add_virfolders_entry(companies_software,artista);
    add_virfolders_entry(categs_software,categoria);
  end;
  ARES_MIME_VIDEO:begin
   inc(num_Video);
    add_virfolders_entry(categs_video,categoria);
  end;
  ARES_MIME_DOCUMENT:begin
   inc(num_Document);
    add_virfolders_entry(authors_document,artista);
    add_virfolders_entry(categs_document,categoria);
  end;
  ARES_MIME_IMAGE:begin
   inc(num_Image);
    add_virfolders_entry(albums_image,album);
    add_virfolders_entry(categs_image,categoria);
  end;
  end;
end;

end;

procedure tthread_private_chat.aggiorna_folder_normal;  //in synch
var
frmpvt:tfrmpvt;
i:integer;
 nodo_root,nodo_parent,nodo_child:pCmtVnode;
 datao,cartella:precord_cartella_share;
begin
 frmpvt:=form as tfrmpvt;

with frmpvt do begin
with treeview2 do begin
 beginupdate;
 clear;

nodo_root:=addchild(nil);
 datao:=getdata(nodo_root);
 datao^.path:=GetLangStringW(STR_SHARED_FOLDERS);
 datao^.items:=0;

 if folders_shared_remote=nil then begin
  endupdate;
  exit;
 end;

  if folders_shared_remote.count>1 then folders_shared_remote.sort(helper_sorting.ordina_cartelle_parent_prima);

 for i:=0 to folders_shared_remote.count-1 do begin
  cartella:=folders_shared_remote[i];

  nodo_parent:=find_regular_path(treeview2,folders_shared_remote,i,widestrtoutf8str(cartella^.path));
  if nodo_parent=nil then begin
    nodo_parent:=nodo_root;
    nodo_child:=addchild(nodo_parent);
     datao:=getdata(nodo_child);
     datao^.display_path:=cartella^.display_path;
  end else begin
     nodo_child:=addchild(nodo_parent);
    // data_parent:=getdata(nodo_parent);
        datao:=getdata(nodo_child);
        datao^.display_path:=cartella^.display_path;
  end;
     with datao^ do begin
      path:=cartella^.path;
      items:=cartella^.items;
      id:=cartella^.id;
     end;

        sort(nodo_parent,0,sdAscending);
 end;

 Expanded[nodo_root]:=true;
 endupdate;
end;
end;

 clear_folders_shared;

end;

function tthread_private_chat.find_regular_path(treeview2:tcomettree; lista:tmylist; index:integer; path:string):pCmtVnode;
var
i:integer;
nodo:pCmtVnode;
data:precord_cartella_share;
pcartella:precord_cartella_share;
path_utf8:string;
begin
result:=nil;
if index=0 then exit;

 nodo:=treeview2.GetFirst;
 if nodo=nil then exit;

 for i:=index-1 downto 0 do begin
   pcartella:=lista[i];
   path_utf8:=widestrtoutf8str(pcartella.path);
   if length(path_utf8)>=length(path) then continue;
    if pos(path_utf8,path)=1 then begin

         while (true) do begin
          nodo:=treeview2.GetNext(nodo);
          if nodo=nil then exit;
           data:=treeview2.getdata(nodo);
            if data^.path=pcartella^.path then begin
              result:=nodo;
              exit;
            end;
          end;

     exit;
    end;
 end;
end;

procedure tthread_private_chat.categs_writetoGUI;//synch
var
nodoroot,node1,node2,node3,node_new,nodoaudio,nodoall,nodoother,nodosoftware,nodovideo,nododocument,nodoimage:pCmtVnode;
records,datao:precord_string;
frmpvt:tfrmpvt;
begin
try
 frmpvt:=form as tfrmpvt;

with frmpvt do begin
 with treeview1 do begin
  nodoroot:=GetFirst;


  nodoall:=getfirstchild(nodoroot);
  if lista_files_utente.count>0 then begin
   datao:=getdata(nodoall);
   datao^.counter:=lista_files_utente.count;
   invalidatenode(nodoall);
  end;

  nodoaudio:=getnextsibling(nodoall);
  if num_audio>0 then begin
   datao:=getdata(nodoaudio);
   datao^.counter:=num_audio;
   invalidatenode(nodoaudio);
  end;


  nodoimage:=getnextsibling(nodoaudio);
  if num_image>0 then begin
   datao:=getdata(nodoimage);
   datao^.counter:=num_image;
   invalidatenode(nodoimage);
  end;


  nodovideo:=getnextsibling(nodoimage);
  if num_video>0 then begin
   datao:=getdata(nodovideo);
   datao^.counter:=num_video;
   invalidatenode(nodovideo);
  end;


  nododocument:=getnextsibling(nodovideo);
  if num_document>0 then begin
   datao:=getdata(nododocument);
   datao^.counter:=num_document;
   invalidatenode(nododocument);
  end;


  nodosoftware:=getnextsibling(nododocument);
  if num_software>0 then begin
   datao:=getdata(nodosoftware);
   datao^.counter:=num_software;
   invalidatenode(nodosoftware);
  end;


  nodoother:=getnextsibling(nodosoftware);
  if num_other>0 then begin
   datao:=getdata(nodoother);
   datao^.counter:=num_other;
   invalidatenode(nodoother);
  end;



  // audio
node1:=getfirstchild(nodoaudio);
node2:=getnextsibling(node1);
node3:=getnextsibling(node2);

while (artists_audio.count>0) do begin
records:=artists_audio[0];
         artists_audio.delete(0);
 node_new:=addchild(node1);
  datao:=getdata(node_new);
  with datao^ do begin
   str:=copy(records^.str,1,length(records^.str));
   counter:=records^.counter;
  end;
 records^.str:='';
 FreeMem(records,sizeof(record_string));

sleep(1);
end;

if terminated then exit;

while (albums_audio.count>0) do begin
records:=albums_audio[0];
         albums_audio.delete(0);
 node_new:=addchild(node2);
  datao:=getdata(node_new);
  with datao^ do begin
   str:=copy(records^.str,1,length(records^.str));
   counter:=records^.counter;
  end;
 records^.str:='';
 FreeMem(records,sizeof(record_string));
sleep(1);
end;
if terminated then exit;

while (categs_audio.count>0) do begin
records:=categs_audio[0];
         categs_audio.delete(0);
 node_new:=addchild(node3);
  datao:=getdata(node_new);
  with datao^ do begin
   str:=copy(records^.str,1,length(records^.str));
   counter:=records^.counter;
  end;
 records^.str:='';
 FreeMem(records,sizeof(record_string));
sleep(1);
end;

if terminated then exit;

// image
node1:=getfirstchild(nodoimage);
node2:=getnextsibling(node1);
while (albums_image.count>0) do begin
records:=albums_image[0];
         albums_image.delete(0);
 node_new:=addchild(node1);
  datao:=getdata(node_new);
  with datao^ do begin
   str:=copy(records^.str,1,length(records^.str));
   counter:=records^.counter;
  end;
 records^.str:='';
 FreeMem(records,sizeof(record_string));
sleep(1);
end;

if terminated then exit;

while (categs_image.count>0) do begin
records:=categs_image[0];
         categs_image.delete(0);
 node_new:=addchild(node2);
  datao:=getdata(node_new);
  with datao^ do begin
   str:=copy(records^.str,1,length(records^.str));
   counter:=records^.counter;
  end;
 records^.str:='';
 FreeMem(records,sizeof(record_string));
sleep(1);
end;

if terminated then exit;

// video
node1:=getfirstchild(nodovideo);
while (categs_video.count>0) do begin
records:=categs_video[0];
         categs_video.delete(0);
 node_new:=addchild(node1);
  datao:=getdata(node_new);
  with datao^ do begin
   str:=copy(records^.str,1,length(records^.str));
   counter:=records^.counter;
  end;
 records^.str:='';
 FreeMem(records,sizeof(record_string));
sleep(1);
end;

if terminated then exit;

// document
node1:=getfirstchild(nododocument);
node2:=getnextsibling(node1);
while (authors_document.count>0) do begin
records:=authors_document[0];
         authors_document.delete(0);
 node_new:=addchild(node1);
  datao:=getdata(node_new);
   with datao^ do begin
    str:=copy(records^.str,1,length(records^.str));
    counter:=records^.counter;
   end;
 records^.str:='';
 FreeMem(records,sizeof(record_string));
sleep(1);
end;

if terminated then exit;

while (categs_document.count>0) do begin
records:=categs_document[0];
         categs_document.delete(0);
 node_new:=addchild(node2);
  datao:=getdata(node_new);
  with datao^ do begin
   str:=copy(records^.str,1,length(records^.str));
   counter:=records^.counter;
  end;
 records^.str:='';
 FreeMem(records,sizeof(record_string));
sleep(1);
end;

if terminated then exit;

// software
node1:=getfirstchild(nodosoftware);
node2:=getnextsibling(node1);
while (companies_software.count>0) do begin
records:=companies_software[0];
         companies_software.delete(0);
 node_new:=addchild(node1);
  datao:=getdata(node_new);
  with datao^ do begin
   str:=copy(records^.str,1,length(records^.str));
   counter:=records^.counter;
  end;
 records^.str:='';
 FreeMem(records,sizeof(record_string));
sleep(1);
end;

if terminated then exit;

while (categs_software.count>0) do begin
records:=categs_software[0];
         categs_software.delete(0);
 node_new:=addchild(node2);
  datao:=getdata(node_new);
  with datao^ do begin
   str:=copy(records^.str,1,length(records^.str));
   counter:=records^.counter;
  end;
 records^.str:='';
 FreeMem(records,sizeof(record_string));
sleep(1);
end;


end;
end;

except
end;

end;

procedure tthread_private_chat.categs_init;
begin
  num_audio:=0;
  num_video:=0;
  num_image:=0;
  num_document:=0;
  num_software:=0;
  num_other:=0;

  artists_audio:=tmylist.create;
  albums_audio:=tmylist.create;
  categs_audio:=tmylist.create;
  albums_image:=tmylist.create;
  categs_image:=tmylist.create;
     sleep(5);
  categs_video:=tmylist.create;
  authors_document:=tmylist.create;
  categs_document:=tmylist.create;
  companies_software:=tmylist.create;
  categs_software:=tmylist.create;

end;

procedure tthread_private_chat.piglia_out_text;//synchronize
var
frmpvt:tfrmpvt;
str:string;
begin
try
if terminated then exit;
if socket=nil then exit;


frmpvt:=form as tfrmpvt;

while (frmpvt.outtext.count>0) do begin


   str:=frmpvt.outtext.strings[0];
    str:=CHRNULL+
         int_2_word_string(length(str))+
         chr(CMD_PRIVCHAT_MESSAGE)+
         str;
    loc_out_text.add(str);

frmpvt.outtext.delete(0);
end;


 if frmpvt.should_browse then begin
   frmpvt.should_browse:=false;


   str:=CHRNULL+
        int_2_word_string(17)+
        chr(CMD_PRIVCHAT_BROWSEREQ)+
        chr(frmpvt.browse_type)+
        frmpvt.guid_browsestr;
     loc_out_text.add(str);


 end;

 if frmpvt.should_send_grantbrowse then begin
    frmpvt.should_send_grantbrowse:=false;
                str:=str+CHRNULL+
                         CHRNULL+CHRNULL+
                         chr(CMD_PRIVCHAT_BROWSEGRANTED);
                 loc_out_text.add(str);
 end;

except
end;
end;

procedure tthread_private_chat.receive;
var
er:integer;
previous_len:integer;
len:integer;
hsock:integer;
cicli:word;
begin
try
if socket=nil then exit;
if terminated then exit;

if new_protocol then begin
 receive_new;
 exit;
end;

 cicli:=0;
repeat

   if terminated then exit;
      if socket=nil then exit;
   parse_received_str(socket);
   if new_protocol then exit;

      if socket=nil then exit;
   if terminated then exit;

  if not TCPSocket_CanRead(socket.socket,0,er) then begin
     if ((er<>WSAEWOULDBLOCK) and (er<>0)) then begin;
           hsock:=socket.socket;
           TCPSocket_Free(hsock);
           socket.free;
           socket:=nil;
              loc_out_text.clear;
           shutdown_transfers;
           synchronize(log_disconnected_while_chatting);
           exit;
     end;
   break;
  end;

  previous_len:=length(socket.buffstr);
  if previous_len>=4096 then begin
     hsock:=socket.socket;
     TCPSocket_Free(hsock);
     socket.free;
     socket:=nil;
     loc_out_text.clear;
     shutdown_transfers;
     synchronize(log_disconnected_while_chatting);
     exit;
  end;

  setlength(socket.buffstr,previous_len+1024);
   len:=TCPSocket_RecvBuffer(socket.socket,@socket.buffstr[previous_len+1],1024,er);

    if er=WSAEWOULDBLOCK then begin
     setlength(socket.buffstr,previous_len);
     break;
    end;

    if er<>0 then begin
     hsock:=socket.socket;
     TCPSocket_Free(hsock);
     socket.free;
     socket:=nil;
        loc_out_text.clear;
      shutdown_transfers;
      synchronize(log_disconnected_while_chatting);
     exit;
    end;

    if len<1024 then setlength(socket.buffstr,len+previous_len);

   inc(cicli);
   if cicli>100 then break;
   
until (not true);

except
end;
end;

procedure tthread_private_chat.receive_new;
var
len,lun:word;
to_recv:word;
cmd:byte;
er:integer;
hsock:integer;
cicli:word;
begin

cicli:=0;

while (true) do begin

  if terminated then break;

  if not TCPSocket_CanRead(socket.socket,0,er) then begin
     if ((er<>WSAEWOULDBLOCK) and (er<>0)) then begin;
           hsock:=socket.socket;
           TCPSocket_Free(hsock);
           socket.free;
           socket:=nil;
              loc_out_text.clear;
           shutdown_transfers;
           synchronize(log_disconnected_while_chatting);
           exit;
     end;
   break;
  end;

   if bytes_in_header<4 then begin
    len:=TCPSocket_RecvBuffer(socket.socket,@buffer_header_ricezione[bytes_in_header],4-bytes_in_header,er);
   end else begin
    move(buffer_header_ricezione[1],to_recv,2);
    if to_recv>=4096 then begin
      hsock:=socket.socket;
      TCPSocket_Free(hsock);
      socket.free;
      socket:=nil;
      loc_out_text.clear;
      shutdown_transfers;
      synchronize(log_disconnected_while_chatting);
      exit;
    end;
    if bytes_in_buffer>0 then dec(to_recv,bytes_in_buffer);
    len:=TCPSocket_RecvBuffer(socket.socket,@buffer_ricezione[bytes_in_buffer],to_recv,er);
   end;

   if er=WSAEWOULDBLOCK then exit;

   if er<>0 then begin
     hsock:=socket.socket;
     TCPSocket_Free(hsock);
     socket.free;
     socket:=nil;
     loc_out_text.clear;
     shutdown_transfers;
     synchronize(log_disconnected_while_chatting);
     exit;
   end;

   if bytes_in_header<4 then inc(bytes_in_header,len)
    else inc(bytes_in_buffer,len);

    if bytes_in_header<4 then continue;

    move(buffer_header_ricezione[1],lun,2);
    if bytes_in_buffer<lun then continue;

     cmd:=buffer_header_ricezione[3];
     process_command(cmd);

    bytes_in_buffer:=0;
    bytes_in_header:=0;
    
    inc(cicli);
    if cicli>100 then break;
end;
end;

procedure tthread_private_chat.metti_form14_nick; //synch
var
frmpvt:tfrmpvt;
begin
if terminated then exit;
try
frmpvt:=form as tfrmpvt;
 frmpvt.nick:=remnick;
 frmpvt.ISconnected:=true;
 frmpvt.caption:=utf8strtowidestr(remnick)+' - '+GetLangStringW(STR_CHAT);
 frmpvt.paintFrame;
except
end;
end;

procedure tthread_private_chat.log_fail_to_connect;//synchronize
var
frmpvt:tfrmpvt;
begin
try
if terminated then exit;

frmpvt:=form as tfrmpvt;
helper_chatroom_gui.out_text_memo(frmpvt.testo,8,'',GetLangStringW(STR_FEAILED_TO_CONNECT));
frmpvt.ISconnected:=false;

     if socket<>nil then socket.free;
     socket:=nil;
     terminate;
except
end;
end;


procedure tthread_private_chat.update_peer_addr_binary; //  synch
var frmpvt:tfrmpvt;
begin
if terminated then exit;
if length(str_to_be_printed)<12 then exit;

try
frmpvt:=form as tfrmpvt;

 with frmpvt do begin
  //remoteIP:=ipint_to_dotstring(chars_2_dword(copy(str_to_be_printed,7,4)));
  if RemotePort=0 then RemotePort:=chars_2_word(copy(str_to_be_printed,11,2));
  RemotePort_server:=chars_2_word(copy(str_to_be_printed,5,2));
  RemoteIp_server:=chars_2_dword(copy(str_to_be_printed,1,4));
 end;

except
end;
end;

procedure tthread_private_chat.update_peer_addr_newformat;//sync
var
frmpvt:tfrmpvt;
loc_ip_alt,loc_ip_server,loc_ip_user:cardinal;
loc_port_user,loc_port_server:word;
begin
if terminated then exit;
if length(str_to_be_printed)<10 then exit;

loc_ip_user:=chars_2_dword(copy(str_to_be_printed,1,4));
loc_port_user:=chars_2_word(copy(str_to_be_printed,5,2));
loc_ip_alt:=chars_2_dword(copy(str_to_be_printed,7,4));

if length(str_to_be_printed)>10 then begin
 loc_ip_server:=chars_2_dword(copy(str_to_be_printed,11,4));
 loc_port_server:=chars_2_word(copy(str_to_be_printed,15,2));
end else begin
 loc_ip_server:=0;
 loc_port_server:=0;
end;

 if loc_ip_user=0 then exit;
 if loc_port_user=0 then exit;

 try
frmpvt:=form as tfrmpvt;
  with frmpvt do begin
  // indirizzo:=ipint_to_dotstring(loc_ip_user);
   RemoteIP_server:=loc_ip_server;
   if RemotePort=0 then RemotePort:=loc_port_user;
   RemotePort_server:=loc_port_server;
   RemoteIP_alt:=loc_ip_alt;
  end;
 except
 end;

end;

procedure tthread_private_chat.update_peer_addr_buffer;
var
loc_ip_user,loc_ip_server:cardinal;
loc_port_user,loc_port_server:word;
frmpvt:tfrmpvt;
begin
if terminated then exit;

 move(buffer_ricezione[0],loc_ip_user,4);
 move(buffer_ricezione[4],loc_port_user,2);
 move(buffer_ricezione[6],loc_ip_server,4);
 move(buffer_ricezione[10],loc_port_server,2);

 if loc_ip_user=0 then exit;
 if loc_ip_server=0 then exit;
 if loc_port_user=0 then exit;
 if loc_port_server=0 then exit;

 try
frmpvt:=form as tfrmpvt;
  with frmpvt do begin
   //indirizzo:=ipint_to_dotstring(loc_ip_user);
   RemoteIP_server:=loc_ip_server;
   if RemotePort=0 then RemotePort:=loc_port_user;
   RemotePort_server:=loc_port_server;
  end;
 except
 end;
end;

procedure tthread_private_chat.update_peer_addr_verbose;//sync
var frmpvt:tfrmpvt;
str:string;
ip_users,ip_servers:string;
port_servers,port_users:string;
begin
if terminated then exit;
if pos('|',str_to_be_printed)=0 then exit;

try
frmpvt:=form as tfrmpvt;

ip_servers:=copy(str_to_be_printed,1,pos(':',str_to_be_printed)-1);
 port_servers:=copy(str_to_be_printed,pos(':',str_to_be_printed)+1,length(str_to_be_printed));
 port_servers:=copy(port_servers,1,pos('|',port_servers)-1);

str:=copy(str_to_be_printed,pos('|',str_to_be_printed)+1,length(str_to_be_printed));

 ip_users:=copy(str,1,pos(':',str)-1);
 port_users:=copy(str,pos(':',str)+1,length(str));

with frmpvt do begin
// indirizzo:=ip_users;
 RemoteIP_server:=inet_addr(pchar(ip_servers));
 if RemotePort=0 then RemotePort:=strtointdef(port_users,0);
 RemotePort_server:=strtointdef(port_servers,0);
end;


except
end;
end;

procedure tthread_private_chat.log_connecting;  //synch
var frmpvt:tfrmpvt;
begin
try
frmpvt:=form as tfrmpvt;
helper_chatroom_gui.out_text_memo(frmpvt.testo,8,'',GetLangStringW(STR_CONNECTING_PLEASE_WAIT));
frmpvt.ISconnected:=false;
except
end;
end;

procedure tthread_private_chat.log_connected;//synchronize
var
frmpvt:tfrmpvt;
begin
try
frmpvt:=form as tfrmpvt;
helper_chatroom_gui.out_text_memo(frmpvt.testo,COLORE_NOTIFICATION,'',GetLangStringW(STR_CONNECTION_ESTABLISHED));
frmpvt.ISconnected:=true;
except
end;
end;

procedure tthread_private_chat.add_text_msg_away;//synch
var
frmpvt:tfrmpvt;
str,str_temp:string;
begin
try
  frmpvt:=form as tfrmpvt;

if ares_frmmain.memo_opt_chat_away.text='' then frmpvt.out_memo(frmpvt.testo, GetLangStringW(STR_YOU),STR_DEFAULT_AWAYMSG,false)
                                   else begin

                                    str:=widestrtoutf8str(convert_command_color_str(ares_frmmain.memo_opt_chat_away.text));
                                    while (length(str)>0) do begin
                                      if pos(CRLF,str)>0 then begin
                                        str_temp:=copy(str,1,pos(CRLF,str)-1);
                                          delete(str,1,pos(CRLF,str)+1);
                                         if length(str_temp)>0 then frmpvt.out_memo(frmpvt.testo,  GetLangStringW(STR_YOU),str_temp,false);
                                      end else
                                      if pos(chr(10),str)>0 then begin
                                         str_temp:=copy(str,1,pos(chr(10),str)-1);
                                          delete(str,1,pos(chr(10),str));
                                         if length(str_temp)>0 then frmpvt.out_memo(frmpvt.testo,  GetLangStringW(STR_YOU),str_temp,false);
                                      end else begin
                                        str_temp:=str;
                                         str:='';
                                        if length(str_temp)>0 then frmpvt.out_memo(frmpvt.testo,  GetLangStringW(STR_YOU),str_temp,false);
                                      end;
                                    end;

                                   end;
except
end;
end;

procedure tthread_private_chat.initiate_connection;
begin
 if not do_connect then begin    
    synchronize(log_fail_to_connect);
    terminate;
 end;
end;

procedure tthread_private_chat.privchat_start_handshake(socket:ttcpblocksocket);
var
str:string;
begin
str:='CHAT/0.1 200 OK'+CRLF+CRLF;

 with socket do begin
   block(true);
     sendbuffer(@str[1],length(str));
   block(false);
 end;

end;

procedure tthread_private_chat.shutdown;
var
pfile:precord_file_chat_send;
frmpvt:tfrmpvt;
begin

try
if folders_shared_remote<>nil then begin
 clear_folders_shared;
 folders_shared_remote.free;
end;
except
end;

reset_PfileBrowse;
FreeMem(PfileBrowse,sizeof(record_file_library));

try
 if socket<>nil then socket.free;
except
end;
 socket:=nil;

try
loc_out_text.free;
except
end;


  categs_free;

try
while (loc_lista_file.count>0) do begin
 pfile:=loc_lista_file[loc_lista_file.count-1];
  with pfile^ do begin
   filenameA:='';
   tipoW:='';
   folderA:='';
    if stream<>nil then FreeHandleStream(Stream);
    stream:=nil;
  end;
 loc_lista_file.delete(loc_lista_file.count-1);
  FreeMem(pfile,sizeof(record_file_chat_send));
end;
loc_lista_file.free;
except
end;

try
frmpvt:=form as tfrmpvt;
postmessage(frmpvt.handle,WM_THREAD_PRIVCHAT_END,0,0);
except
end;

end;


function tthread_private_chat.find_privchat_transfernode(listview:tcomettree; pfile:precord_file_chat_send):pCmtVnode;
var
i:integer;
data:precord_file_chat_send;
begin
result:=nil;
try

i:=0;
repeat
if i=0 then result:=listview.getfirst
 else result:=listview.getnext(result);
if result=nil then exit;
inc(i);

data:=listview.getdata(result);
if data^.num=pfile^.num then exit;

until (not true);

except
end;
end;

procedure tthread_private_chat.privchat_update_transferview;   //synch
var
nodo:pCmtVnode;
datao,pfile:precord_file_chat_send;
h:integer;
frmpvt:tfrmpvt;
str:string;
begin
try

frmpvt:=form as tfrmpvt;

nodo:=frmpvt.listview1.getfirst;
while (nodo<>nil) do begin

datao:=frmpvt.listview1.getdata(nodo);
if datao^.num=-1 then begin
 nodo:=frmpvt.listview1.getnext(nodo);
 continue;
end;
if not datao^.should_stop then begin
 nodo:=frmpvt.listview1.getnext(nodo);
 continue;
end;

for h:=0 to loc_lista_file.count-1 do begin
 pfile:=loc_lista_file[h];
 if pfile^.num=datao^.num then begin
  pfile^.completed:=true;
    if pfile^.stream<>nil then FreeHandleStream(pfile^.stream);
   pfile^.stream:=nil;
          str:=pfile^.filenameA+CHRNULL;
           str:=CHRNULL+
                int_2_word_string(length(str))+
                chr(4)+
                str;
          loc_out_text.add(str); //send request..
                 if not pfile^.upload then begin
                   if pfile^.folderA<>'' then helper_diskio.deletefileW(myshared_folder+'\'+utf8strtowidestr(pfile^.folderA)+'\'+extract_fnameW(utf8strtowidestr(pfile^.filenameA)))
                    else helper_diskio.deletefileW(myshared_folder+'\'+extract_fnameW(utf8strtowidestr(pfile^.filenameA)));
                 end;
  break;
 end;
end;

nodo:=frmpvt.listview1.getnext(nodo);
end;





h:=0;
while (h<loc_lista_file.count) do begin
  pfile:=loc_lista_file[h];
  nodo:=find_privchat_transfernode(frmpvt.listview1,pfile);
  if nodo=nil then begin
   inc(h);
   continue;
  end;

  datao:=frmpvt.listview1.getdata(nodo);
  with datao^ do begin
   remaining:=pfile^.remaining;
   progress:=pfile^.progress;
   speed:=pfile^.speed;
   transferring:=pfile^.transferring;
   accepted:=pfile^.accepted;
   completed:=pfile^.completed;
  end;
  frmpvt.listview1.invalidatenode(nodo);

  if pfile^.completed then begin
     datao^.num:=-1;
    if pfile^.stream<>nil then FreeHandleStream(pfile^.stream);

     with pfile^ do begin
      stream:=nil;
      filenameA:='';
      tipoW:='';
      folderA:='';
     end;

     loc_lista_file.delete(h);
     FreeMem(pfile,sizeof(record_file_chat_send));
  end else inc(h);
end;


except
end;
end;


procedure tthread_private_chat.privchat_transfers_update;
var
i:integer;
pfile:precord_file_chat_send;
tempo:cardinal;
begin
try
tempo:=gettickcount;

i:=0;
while (i<loc_lista_file.count) do begin
pfile:=loc_lista_file[i];
 if not pfile^.transferring then begin
  inc(i);
  continue;
 end;

 pfile^.speed:=((pfile^.speed div 5)*4)+( ((pfile^.progress-pfile^.bytesprima)*(tempo-last_stats_file)) div 5000);// + 1 sec
   if pfile^.speed>0 then begin
    pfile^.remaining:=(pfile^.size-pfile^.progress) div pfile^.speed;
   end else pfile^.remaining:=-1;
 pfile^.bytesprima:=pfile^.progress;

 inc(i);
end;

synchronize(privchat_update_transferview);

except
end;
end;



procedure tthread_private_chat.execute;
var
last_get_out_text,last_ping_remotehost,tempo:cardinal;
begin
freeonterminate:=false;
priority:=tpnormal;

PfileBrowse:=AllocMem(sizeof(record_file_library));
 PfileBrowse^.filedate:=0;

first_req_box:=true;

loc_lista_file:=tmylist.create;
loc_out_text:=tmystringlist.create;

nil_virfolders_entries;
folders_shared_remote:=nil;

bytes_in_header:=0;
bytes_in_buffer:=0;
new_protocol:=false;
int64_capable:=false;  //2951+
try
 if not accepted then initiate_connection else begin
   synchronize(log_connected);
   if not terminated then synchronize(send_away_msg);
 end;
except
end;

  
last_get_out_text:=gettickcount;
last_stats_file:=gettickcount;
last_pong_remotehost:=gettickcount;
last_ping_remotehost:=0;
//last_decimo:=gettickcount;
try



while (not terminated) do begin

   tempo:=gettickcount;


  if tempo-last_stats_file>SECOND then begin
    if not terminated then privchat_transfers_update;
    last_stats_file:=tempo;
   // if not terminated then check_files_timeouts;

    if tempo-last_ping_remotehost>MINUTE then begin
     last_ping_remotehost:=gettickcount;
     loc_out_text.add(CHRNULL+ CHRNULL+CHRNULL+  chr(10));
    end;


  end;

  if tempo-last_get_out_text>500 then begin
    last_get_out_text:=tempo;
    if not terminated then synchronize(piglia_out_text);
    if not terminated then synchronize(prendi_pfiles);
    if not terminated then attiva_pfiles;
  end;

 if not terminated then receive;
if not terminated then send;
  sleep(10);
 if not terminated then receive;
if not terminated then send;

end;

except
end;


synchronize(shutdown);
end;


procedure tthread_private_chat.categs_free;
begin
  try
     if artists_audio<>nil then free_virfolders_entries(artists_audio);
     if albums_audio<>nil then free_virfolders_entries(albums_audio);
     if categs_audio<>nil then free_virfolders_entries(categs_audio);
     if authors_document<>nil then free_virfolders_entries(authors_document);
     if categs_document<>nil then free_virfolders_entries(categs_document);
     if companies_software<>nil then free_virfolders_entries(companies_software);
     if categs_software<>nil then free_virfolders_entries(categs_software);
     if categs_video<>nil then free_virfolders_entries(categs_video);
     if albums_image<>nil then free_virfolders_entries(albums_image);
     if categs_image<>nil then free_virfolders_entries(categs_image);
  except
  end;
  nil_virfolders_entries;
end;

procedure tthread_private_chat.nil_virfolders_entries;
begin
 lista_files_per_browse:=nil;
 artists_audio:=nil;
 albums_audio:=nil;
 categs_audio:=nil;
 albums_image:=nil;
 categs_image:=nil;
 categs_video:=nil;
 authors_document:=nil;
 categs_document:=nil;
 companies_software:=nil;
 categs_software:=nil;
end;

procedure tthread_private_chat.delete_chatpush_req;//synch
var
i:integer;
pushed_chat_request:precord_pushed_chat_request;
begin
try

for i:=0 to vars_global.lista_pushed_chatrequest.count-1 do begin
  pushed_chat_request:=vars_global.lista_pushed_chatrequest[i];
   if pushed_chat_request^.randoms<>randoms then continue;
    if pushed_chat_request^.socket<>nil then FreeAndNil(pushed_chat_request^.socket);
      vars_global.lista_pushed_chatrequest.delete(i);
       pushed_chat_request^.randoms:='';
       FreeMem(pushed_chat_request,sizeof(record_pushed_chat_request));
       exit;
end;

except
end;
end;

procedure tthread_private_chat.get_avantuale_chatpush_arrived;
var
i:integer;
pushed_chat_request:precord_pushed_chat_request;
begin
try

for i:=0 to vars_global.lista_pushed_chatrequest.count-1 do begin
  pushed_chat_request:=vars_global.lista_pushed_chatrequest[i];

   if pushed_chat_request^.randoms<>randoms then continue;
    if pushed_chat_request^.socket=nil then continue;

       socket:=pushed_chat_request^.socket;
        vars_global.lista_pushed_chatrequest.delete(i);
         pushed_chat_request^.randoms:='';
        FreeMem(pushed_chat_request,sizeof(record_pushed_chat_request));
    exit;
end;

except
end;
end;

function tthread_private_chat.request_Chatpush:boolean;
var
sockt:TTCPBlockSocket;
str:string;
tempo:cardinal;
len,er:integer;
testoricevuto:string;
previous_len:integer;
buffer:array[0..100] of char;
begin
result:=false;
try


sockt:=TTCPBlockSocket.Create(true);
 sockt.ip:=ipint_to_dotstring(ip_server);
 sockt.port:=port_server;
 assign_proxy_settings(sockt);
  sockt.Connect(sockt.ip,inttostr(sockt.port));

 tempo:=gettickcount;
 while true do begin
    if gettickcount-tempo>TIMOUT_SOCKET_CONNECTION then begin
     sockt.free;
     exit;
    end;
    if terminated then begin
     sockt.free;
     exit;
    end;

  er:=TCPSocket_ISConnected(sockt);
  if er=0 then break else
  if er<>WSAEWOULDBLOCK then begin
   sockt.free;
   exit;
  end;
 sleep(10);
 end;

 str1_global:='';
 synchronize(add_new_key_pvt_push);



    //crypt custom ip integer
str:=e7(int_2_dword_string(ip_server),port_server,str1_global);
str:=int_2_word_string(length(str))+chr(MSG_CLIENT_CHAT_NEWPUSH)+str;

tempo:=gettickcount;
while true do begin
    if gettickcount-tempo>TIMOUT_SOCKET_CONNECTION then begin
     sockt.free;
     exit;
    end;
    if terminated then begin
     sockt.free;
     exit;
    end;

 TCPSocket_SendBuffer(sockt.socket,@str[1],length(str),er);
 if er=0 then break else
 if er<>WSAEWOULDBLOCK then begin
  sockt.free;
  exit;
 end;
sleep(10);
end;


testoricevuto:='';

tempo:=gettickcount;
while true do begin

 if terminated then begin
  sockt.free;
  exit;
 end;

 if gettickcount-tempo>TIMOUT_SOCKET_CONNECTION then begin
  sockt.free;
  break;
 end;

 if not TCPSocket_CanRead(sockt.socket,0,er) then begin
  if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
    sockt.free;
    break;
  end;
  sleep(5);
  continue;
 end;

 previous_len:=length(testoricevuto);
 len:=TCPSocket_RecvBuffer(sockt.socket,@buffer,sizeof(buffer),er);

 if er=WSAEWOULDBLOCK then begin
  sleep(10);
  continue;
 end;
 if er<>0 then begin
  sockt.free;
  break;
 end;

 if len<1 then begin
  sleep(10);
  continue;
 end;

 setlength(testoricevuto,previous_len+len);
 move(buffer,testoricevuto[previous_len+1],len);

    sockt.free;
    break;
end;


if testoricevuto='0000' then exit; // user not available



             //try to connect to remote peer:port_NAT using our endpoint ip_misuratoS+myport

           while true do begin

               if gettickcount-tempo>2*MINUTE then begin
                synchronize(delete_chatpush_req);
                exit;
               end;


               synchronize(get_avantuale_chatpush_arrived);

             if socket<>nil then begin    // in connection
                  str:='OK'+chr(10);
                  tempo:=gettickcount;
                  while true do begin
                    if tempo-gettickcount>15*SECOND then begin
                     socket.free;
                     socket:=nil;
                     exit;
                    end;
                    if terminated then break;
                   TCPSocket_SendBuffer(socket.socket,@str[1],3,er);
                    if er=WSAEWOULDBLOCK then begin
                     sleep(10);
                     continue;
                    end;
                    if er<>0 then begin
                     socket.free;
                     socket:=nil;
                     exit;
                    end;
                     privchat_complete_handshake(socket);    //ok we got first push handshake
                     synchronize(log_connected);
                     result:=true;
                    exit;
                  end;
             end;



               if terminated then begin
                if socket<>nil then socket.free;
                socket:=nil;
                exit;
               end;

               sleep(300);
           end;     //while loop



except
end;
end;

procedure tthread_private_chat.add_new_key_pvt_push;//synch
var
i:integer;
pushed_chat_request:precord_pushed_chat_request;
begin
 randoms:='';
 for i:=1 to 16 do randoms:=randoms+chr(random($fe)+1);


str1_global:=int_2_dword_string(fIP)+
             int_2_word_string(vars_global.myport)+
             int_2_dword_string(vars_global.LanIPC)+
             randoms;

 pushed_chat_request:=AllocMem(sizeof(record_pushed_chat_request));
  pushed_chat_request^.randoms:=randoms;
  pushed_chat_request^.socket:=nil;
  pushed_chat_request^.issued:=gettickcount;
vars_global.lista_pushed_chatrequest.add(pushed_chat_request);
end;

function tthread_private_chat.do_connect:boolean;
var
er:integer;
tempo:Cardinal;
failed_to_connect:boolean;
begin
synchronize(log_connecting);

 socket:=ttcpblocksocket.create(true);
  if ip_alt<>0 then begin
    socket.ip:=ipint_to_dotstring(ip_alt);
    socket.SocksIP:='';
    socket.SocksPort:='0';
  end else begin
    assign_proxy_settings(socket);
    socket.ip:=ipint_to_dotstring(FIP);
  end;
 socket.port:=port;

 socket.connect(socket.ip,inttostr(socket.port));

 tempo:=gettickcount;
 failed_to_connect:=true;

 while true do begin

  if (gettickcount-tempo>TIMOUT_SOCKET_CONNECTION) or (terminated) then begin
    socket.free;
    socket:=nil;
    break;
  end;

  er:=TCPSocket_ISConnected(socket);
  if er=0 then begin
   failed_to_connect:=false;
   break;
  end else
  if er<>WSAEWOULDBLOCK then begin
   socket.free;
   socket:=nil;
   break;
  end;
  sleep(10);
 end;



 if ((failed_to_connect) and (ip_alt<>0)) then begin

 socket:=ttcpblocksocket.create(true);
  socket.ip:=ipint_to_dotstring(fIP);
  socket.port:=port;
  assign_proxy_settings(socket);
  socket.connect(socket.ip,inttostr(socket.port));

 tempo:=gettickcount;
 failed_to_connect:=true;

 while true do begin

  if (gettickcount-tempo>TIMOUT_SOCKET_CONNECTION) or (terminated) then begin
    socket.free;
    socket:=nil;
    break;
  end;

  er:=TCPSocket_ISConnected(socket);
  if er=0 then begin
   failed_to_connect:=false;
   break;
  end else
  if er<>WSAEWOULDBLOCK then begin
   socket.free;
   socket:=nil;
   break;
  end;
  sleep(10);
 end;

end;
 ////////////////////////////////////////////////////

if failed_to_connect then begin
 if port_server<>0 then result:=request_Chatpush else result:=False;
 exit;
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

result:=send_chat_connect;  //already ready to receive tcpcanwrite=true
end;

function tthread_private_chat.send_chat_connect:boolean;
var
str:string;
er:integer;
begin
 str:='CHAT CONNECT/0.1'+CRLF+CRLF;


  TCPSocket_SendBuffer(socket.socket,@str[1],length(str),er);
if er<>0 then begin
 socket.free;
 socket:=nil;
 result:=false;
 exit;
end;

socket.block(false);

ricevi_chat_200_ok_ed_invia_nostro;

if not terminated then result:=true
 else result:=false;
end;


procedure tthread_private_chat.send_away_msg;
var
str,str_temp:string;
begin
if ares_frmmain.check_opt_chat_isaway.checked then begin
     if ares_frmmain.Memo_opt_chat_away.text='' then
       send_text(STR_DEFAULT_AWAYMSG)
     else begin
        str:=widestrtoutf8str(convert_command_color_str(ares_frmmain.Memo_opt_chat_away.text));
                                    while (length(str)>0) do begin
                                      if pos(CRLF,str)>0 then begin
                                        str_temp:=copy(str,1,pos(CRLF,str)-1);
                                          delete(str,1,pos(CRLF,str)+1);
                                         if length(str_temp)>0 then send_text(str_temp);
                                      end else
                                      if pos(chr(10),str)>0 then begin
                                         str_temp:=copy(str,1,pos(chr(10),str)-1);
                                          delete(str,1,pos(chr(10),str));
                                         if length(str_temp)>0 then send_text(str_temp);
                                      end else begin
                                        str_temp:=str;
                                         str:='';
                                        if length(str_temp)>0 then send_text(str_temp);
                                      end;
                                    end;
     end;

 add_text_msg_away;  //already in synch
end;
end;

procedure tthread_private_chat.ricevi_chat_200_ok_ed_invia_nostro;
var
previous_len:integer;
len:integer;
er:integer;
atttime:cardinal;
begin
if terminated then exit;
try
socket.buffstr:='';

atttime:=gettickcount;
repeat
    if terminated then exit;
    if gettickcount-atttime>TIMOUT_SOCKET_CONNECTION then begin   //timeout
     synchronize(log_fail_to_connect);
     exit;
   end;

    if pos(CRLF+CRLF,socket.buffstr)<>0 then begin
        if pos('CHAT/0.1 200 OK',socket.buffstr)=1 then begin
           delete(socket.buffstr,1,pos(CRLF+CRLF,socket.buffstr)+3);
        end else begin
         synchronize(log_fail_to_connect);
         exit;
        end;
      break;
    end;

    if not TCPSocket_CanRead(socket.socket,0,er) then begin
     if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
      synchronize(log_fail_to_connect);
      exit;
     end else begin
      sleep(10);
      continue;
     end;
    end;

    previous_len:=length(socket.buffstr);
    setlength(socket.buffstr,previous_len+1024);
   len:=TCPSocket_RecvBuffer(socket.socket,@socket.buffstr[previous_len+1],1024,er);

    if er=WSAEWOULDBLOCK then begin
     setlength(socket.buffstr,previous_len);
     sleep(10);
     continue;
    end else
    if er<>0 then begin
     synchronize(log_fail_to_connect);
     exit;
    end;
    if len<1 then begin
       setlength(socket.buffstr,previous_len);
       sleep(10);
       continue;
    end;

   if length(socket.buffstr)>previous_len+len then setlength(socket.buffstr,previous_len+len);

until (not true);


privchat_start_handshake(socket);
privchat_complete_handshake(socket);

 synchronize(log_connected); //connection established...
 except
 end;
end;


end.
