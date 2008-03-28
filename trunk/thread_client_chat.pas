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
chatroom client thread
}

unit thread_client_chat;

interface

uses
  Classes, windows, sysutils, const_ares, ares_types, utility_ares, blcksock,
  classes2, synsock, buttons, graphics, comettrees, keywfunc, tntcomctrls, registry,
  const_timeouts, const_win_messages, const_chatroom, cometPageView, forms;

type
  tstato_socket_canale = (STATO_SOCKET_CANALE_CONNECTING,
    STATO_SOCKET_CANALE_CONNECTED,
    STATO_SOCKET_CANALE_WAITING_FOR_LOGIN_REPLY,
    STATO_SOCKET_CANALE_LOGGED,
    STATO_SOCKET_CANALE_DISCONNECTED);

type
  precord_socket_canale = ^record_socket_canale;
  record_socket_canale = record
    tag: cardinal; //integer;2966+
    first_try_connect, has_tried_internal_ip: boolean;
    ip: cardinal;
    ip_alt: cardinal;
    port: word;
    name: string;
    topic: string;
    version: string;
    socket: ttcpBlockSocket;
    stato: tstato_socket_canale;
    pcanale: precord_canale_chat_visual;
    in_commands_gui: tmystringlist;
    out_commands: tmystringlist;
    in_buffer: string;
    disconnect_time: cardinal;
    last_out: cardinal;
    sent_filelist: boolean;
    support_files: boolean;
    support_pvt: boolean;
    support_compression: boolean; //3025
    retry_connect: byte; //prove riconnessione?
    shareable_types: byte; //tipi ammessi
  end;

type
  tthread_client_chat = class(TThread)
  protected
    buffer_global: array[0..1023] of char; //reduce alloc while receiving?
    content: string; //in buffer global parse

    procedure Execute; override;
    procedure check_30_seconds;
    procedure check_update;

    procedure IO_MainVCL; // synch
    procedure shutdown;

    procedure list_deal;
    procedure free_sockets; //synch

    procedure handler_end_of_userlist; overload; //synch
    function my_online_queue_status_str: string;
    procedure browse_files_copy; //sync copiamo lista qui per velocizzare calcolo categorie
    procedure handler_browse_addnewfile(socket_canale: precord_socket_canale); overload;
    procedure handler_server_update_url(socket_canale: precord_socket_canale); overload;
    procedure handler_server_update_url; overload;
    procedure handler_browse_addnewfile; overload;
    procedure check_send_filelist; //ogni minuto
    procedure add_source_download_result; //synch

    procedure get_out_text_canali; //synch
    procedure out_memo; //synch
    procedure out_memo_simple; //synch
    procedure notice_disconnect_pvts; //synch includi disconnected a tutti i vari pvt se presenti
    procedure updateChannelName; //sync


    procedure start_userlist; //synch
    procedure put_server_features; //synch
    procedure sync_vars; //synch
    function out_login_req(socket: hsocket): integer;
    procedure receive_socket(socket_canale: precord_socket_canale);
    procedure flush_socket(socket_canale: precord_socket_canale);
    procedure process_command(socket_canale: precord_socket_canale);

    procedure send_filelist; //synch
    procedure shutdown_channel; //synch


    procedure handler_login_ok(socket_canale: precord_socket_canale); //server welcomes us
    procedure handler_server_error(socket_canale: precord_socket_canale);
    procedure handler_put_server_features(socket_canale: precord_socket_canale); //server sends its browsable mimetypes
    procedure handler_public(socket_canale: precord_socket_canale); //public chat message
    procedure handler_emote(socket_canale: precord_socket_canale); // emote
    procedure handler_incoming_pvt(socket_canale: precord_socket_canale); overload;
    procedure handler_nosuch(socket_canale: precord_socket_canale);
    procedure handler_join(socket_canale: precord_socket_canale); overload;
    procedure handler_part(socket_canale: precord_socket_canale); overload;
    procedure handler_channel_user(socket_canale: precord_socket_canale); overload;
    procedure handler_channel_topic(socket_canale: precord_socket_canale); overload;
    procedure handler_topic_first(socket_canale: precord_socket_canale); overload;
    procedure handler_update_user_status(socket_canale: precord_socket_canale); overload;
    procedure handler_end_of_userlist(socket_canale: precord_socket_canale); overload;
    procedure handler_endofsearch(socket_canale: precord_socket_canale); overload;
    procedure handler_arrived_result(socket_canale: precord_socket_canale); overload;
    procedure handler_set_startof_browse(socket_canale: precord_socket_canale); overload;
    procedure handler_set_browse_error(socket_canale: precord_socket_canale); overload;
    procedure handler_set_endof_browse(socket_canale: precord_socket_canale); overload;
    procedure handler_offline_bypvt(socket_canale: precord_socket_canale); //destinatario pvt è offline
    procedure handler_ignored_bypvt(socket_canale: precord_socket_canale); //destinatario pvt è offline
    procedure handler_login_redirect(socket_canale: precord_socket_canale); overload;
    procedure handler_login_redirect; overload; //synch
    procedure handler_requested_dirchatpush;
    procedure handler_server_opchange(socket_canale: precord_socket_canale); overload;
    procedure handler_server_opchange; overload; //sync
    procedure handler_server_compressed(socket_canale: precord_socket_canale);

    procedure handler_userlist_clear(socket_canale: precord_socket_canale); overload;
    procedure handler_userlist_clear; overload;

    procedure handler_set_startof_browse; overload; //synch
    procedure handler_set_browse_error; overload; //synch
    procedure handler_set_endof_browse; overload; //synch


    procedure handler_incoming_pvt; overload; //synch
    procedure incoming_pvt_error; //synch

    procedure handler_arrived_result; overload; //synch
    procedure handler_endofsearch; overload; //synch
    procedure handler_channel_user; overload; //synch
    procedure handler_part; overload; //synch
    procedure handler_join; overload; //synch   con dicitura su memo
    procedure handler_update_user_status; overload;
    procedure handler_channel_topic; overload;
    procedure handler_topic_first; overload;
    procedure update_status; // ogni minuto invio update del mio stato...files, stato
    procedure get_in_commands;
    procedure reconnect(socket_canale: precord_socket_canale);
    procedure check_IdtoNick(var cmdLine: string; socket_canale: precord_socket_canale); overload;
    procedure check_IdtoNick; overload; //sync

  end;

procedure send_packet(socket_canale: precord_socket_canale; cmd: byte; cont: string; priority: boolean);
procedure keep_alive_socks;
procedure init_channels;
procedure free_channels;
procedure connect_channel(socket_canale: precord_socket_canale);
procedure init_vars;

function supportFileSharingInFlags(flags: byte): boolean;
function supportPvtInFlags(flags: byte): boolean;
function supportCompressionInFlags(flags: byte): boolean;

var
  socket_list: tmylist;
  last_2_dec,
    last_2_min,
    last_30_sec: cardinal;


    //vars to cover GUI sync events
  pcanale_per_synch: precord_canale_chat_visual;
  socket_canale_per_synch: precord_socket_canale; //per sendfilelist
  testo_per_synch: string;
  randomstr_per_synch: string; //synchronize on arrived events browse/search
  colore_per_synch: tcolor;
  files_per_synch,
    speed_per_synch: integer;
  crc_per_synch: word;
  utente_per_synch: string;
  support_files_per_synch, ModLevelSync: boolean;
  ip_per_synch,
    ip_alt_per_synch,
    ip_server_per_synch: cardinal;
  port_per_synch, port_server_per_synch: word;

    //local vars synchronized in sync_vars
  loc_allow_pvt_browse: boolean;
  my_shared_count_loc: integer; //presi in synch prendi vars
  mypgui_loc: string[16];
  myport_loc: word;
  my_localip_snode: cardinal; //ip esterno rilevato da supernode
  velocita_up_dec_loc: integer;
  mynick_loc: string;
  versioneares_loc: string;
  should_font_change: boolean; //per far cambiare colore font quando arrivano eventi
  my_queued_count, my_upcount, my_uplimit: byte;

implementation

uses
  ufrmmain, helper_unicode, vars_localiz, helper_registry,
  helper_strings, helper_urls, helper_sockets, helper_chatroom,
  helper_ipfunc, helper_sorting, helper_visual_library, vars_global,
  helper_datetime, const_chatroom_commands, helper_altsources, helper_chatclient_share,
  helper_gui_misc, helper_chatroom_gui, helper_share_misc,
  helper_chatroom_share, helper_stringfinal, helper_chat_favorites, mysupernodes,
  helper_private_chat, ufrmchatTab, zlib;

procedure init_vars;
begin
  last_2_dec := gettickcount;
  last_2_min := last_2_dec;
  last_30_sec := last_2_dec;

  socket_list := tmylist.create;
  should_font_change := false;
  init_result_search;
  categs_Setnihil;
end;


//executed every 30 seconds

procedure tthread_client_chat.check_30_seconds;
begin
  last_30_sec := gettickcount;
  keep_alive_socks;
  if not terminated then check_send_filelist;
end;

//thread's loop

procedure tthread_client_chat.Execute;
var
  tempo: cardinal;
begin
  priority := tpnormal;
  freeonterminate := false;


  init_vars;
  synchronize(sync_vars);

  while not terminated do begin
    tempo := gettickcount;

    if tempo - last_2_dec > 2 * TENTHOFSEC then begin
      synchronize(IO_MainVCL); //chiediamo spesso...illusione minore lag
      get_in_commands;
    end;

    if tempo - last_30_sec > 30 * SECOND then check_30_seconds;
    if tempo - last_2_min > 2 * MINUTE then check_update;

    list_deal;

    sleep(10);
  end;

  shutdown;

end;

//send keep alive packet every 2 minutes (this helps us with remote ghosting detection)

procedure tthread_client_chat.check_update;
begin
  last_2_min := gettickcount;
  if not terminated then synchronize(update_status);
end;

procedure tthread_client_chat.update_status; // ogni minuto invio update del mio stato...files, stato
var
  i: integer;
  socket_canale: precord_socket_canale;
  str: string;
begin
  sync_vars; //siamo in synch

  str := int_2_word_string(my_shared_count_loc) +
    CHRNULL + //status_chat_to_byte(my_chat_status_loc))+
    mysupernodes.GetServerStrBinary +
    int_2_dword_string(my_localip_snode) +
    my_online_queue_status_str;

  for i := 0 to socket_list.count - 1 do begin
    socket_canale := socket_list[i];
    if socket_canale^.stato <> STATO_SOCKET_CANALE_LOGGED then continue;
    send_packet(socket_canale, MSG_CHAT_CLIENT_UPDATE_STATUS, str, true);
  end;

end;
///////////////////////////////////////////////////////////////////////////////////////////


// build packet and append it (or insert it) on the outbuffer list

procedure send_packet(socket_canale: precord_socket_canale; cmd: byte; cont: string; priority: boolean);
var
  str: string;
begin

  str := int_2_word_string(length(cont)) +
    chr(cmd) +
    cont;

  if priority then begin //evitiamo la senzazione di creare lag...
    if socket_canale^.out_commands.count > 50 then socket_canale^.out_commands.Insert(0, str)
    else socket_canale^.out_commands.add(str);
  end else socket_canale^.out_commands.add(str);

end;


// thread-safe get user's commands, parse and send them to server

procedure tthread_client_chat.get_in_commands;
var
  socket_canale: precord_socket_canale;
  i: integer;
  command, locom: string;
begin

  for i := 0 to socket_list.count - 1 do begin

    socket_canale := socket_list[i];

    while (socket_canale^.in_commands_gui.count > 0) do begin
      command := socket_canale^.in_commands_gui[0];
      socket_canale^.in_commands_gui.delete(0);

      if length(command) < 1 then continue;

      if command[1] <> '!' then
        if command[1] <> '>' then
          if command[1] <> '/' then continue;

      locom := lowercase(command);

      if pos('reconnect', locom) = 2 then begin
        reconnect(socket_canale);
        exit;
      end else
        if (pos('logout', locom) = 2) or (pos('exit', locom) = 2) or (pos('part', locom) = 2) or (pos('disconnect', locom) = 2) then begin
          pcanale_per_synch := socket_canale^.pcanale;
          synchronize(shutdown_channel);
          exit;
        end;

      if socket_canale.stato <> STATO_SOCKET_CANALE_LOGGED then break; //solo se siamo connessi


      if pos('public', locom) = 2 then begin
        delete(command, 1, 8);
        send_packet(socket_canale, MSG_CHAT_CLIENT_PUBLIC, command, true);
      end else

        if pos('search', locom) = 2 then begin
          delete(command, 1, 8);
          send_packet(socket_canale, MSG_CHAT_CLIENT_SEARCH, command, false);
        end else

          if pos('browse', locom) = 2 then begin
            delete(command, 1, 8);
            send_packet(socket_canale, MSG_CHAT_CLIENT_BROWSE, command, false);
          end else

            if pos('pvt', locom) = 2 then begin
              delete(command, 1, 5);
              send_packet(socket_canale, MSG_CHAT_CLIENT_PVT, command, true);
            end else

              if pos('action', locom) = 2 then begin
                delete(command, 1, 8);
                send_packet(socket_canale, MSG_CHAT_CLIENT_EMOTE, command, true);
              end else

                if pos('me', locom) = 2 then begin
                  delete(command, 1, 4);
                  send_packet(socket_canale, MSG_CHAT_CLIENT_EMOTE, command, true);
                end else

                  if pos('ignore', locom) = 2 then begin
                    check_idtonick(command, socket_canale);
                    delete(command, 1, 8);
                    send_packet(socket_canale, MSG_CHAT_CLIENT_IGNORELIST, chr(1) + command + CHRNULL, true); //add
                  end else

                    if pos('unignore', locom) = 2 then begin
                      check_idtonick(command, socket_canale);
                      delete(command, 1, 10);
                      send_packet(socket_canale, MSG_CHAT_CLIENT_IGNORELIST, CHRNULL + command + CHRNULL, true); //remove
                    end else
                      if (pos('logout', locom) = 2) or (pos('exit', locom) = 2) or (pos('part', locom) = 2) or (pos('disconnect', locom) = 2) then begin
                        pcanale_per_synch := socket_canale^.pcanale;
                        synchronize(shutdown_channel);
                        exit;
                      end else
                        if pos('reconnect', locom) = 2 then begin
                          reconnect(socket_canale);
                          exit;
                        end else
                          if pos('login', locom) = 2 then begin
                            delete(command, 1, 7);
                            send_packet(socket_canale, MSG_CHAT_CLIENT_AUTHLOGIN, command, true);
                            exit;
                          end else
                            if pos('register', locom) = 2 then begin
                              delete(command, 1, 10);
                              send_packet(socket_canale, MSG_CHAT_CLIENT_AUTHREGISTER, command, true);
                            end else begin
                              check_idtonick(command, socket_canale);
                              delete(command, 1, 1);
                              send_packet(socket_canale, MSG_CHAT_CLIENT_COMMAND, command, true); //remove
                            end;
    end;

  end;

end;

procedure tthread_client_chat.check_IdtoNick(var cmdLine: string; socket_canale: precord_socket_canale);
var
  cmdFirstArg: string;
  lenId, posCmd: integer;
begin

  posCmd := pos(' #', cmdLine);
  if posCmd = 0 then exit;
  cmdFirstArg := copy(cmdLine, posCmd + 2, length(cmdLine));

  if length(cmdFirstArg) = 0 then exit; //no # char
  if pos(' ', cmdFirstArg) > 0 then delete(cmdFirstArg, pos(' ', cmdFirstArg), length(cmdFirstArg));

  files_per_synch := strtointdef(cmdFirstArg, -1);
  if files_peR_synch = -1 then exit; // not a number

  lenId := length(cmdFirstArg) + 1;

  if files_per_synch > 999 then exit;
  if files_per_synch < 0 then exit;

  utente_per_synch := '';
  pcanale_per_synch := socket_canale^.pcanale;
  synchronize(check_idtoNick);
  if length(utente_per_synch) = 0 then exit;

  cmdLine := copy(cmdLine, 1, pos(' #', cmdLine)) +
    utente_per_synch +
    copy(cmdLine, posCmd + lenId + 1, length(cmdLine));
end;

procedure tthread_client_chat.check_idToNick; //sync
var
  node: PCMTVNode;
  dataUser: precord_displayed_chat_user;
begin
  try

    node := pcanale_per_synch.listview.GetFirst;
    while (node <> nil) do begin
      dataUser := pcanale_per_synch.listview.GetData(node);
      if dataUser^.id = files_per_synch then begin
        utente_per_synch := dataUser^.nick;
        exit;
      end;
      node := pcanale_per_synch.listview.getNext(node);
    end;

  except
  end;
end;


procedure tthread_client_chat.shutdown_channel;
var
  ind: integer;
begin
  try
    ind := ares_frmmain.panel_chat.GetPagePanelIndex(pcanale_per_synch^.containerPageview);
    if ind <> -1 then ares_frmmain.panel_chat.DeletePanel(ind);
  except
  end;
end;

// receive userlist with listview in 'update' status (should improve speed)
// output widestring to richedit control (thread-safe)

procedure tthread_client_chat.out_memo_simple; //synch
var
  pcanale: precord_canale_chat_visual;
begin
  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

    helper_chatroom_gui.out_text_memo(pcanale^.memo, colore_per_synch, '', utf8strtowidestr(testo_per_synch));
  except
  end;
end;


// we are sending a private message to an offline recipient (server notify us)

procedure tthread_client_chat.notice_disconnect_pvts; //synch includi disconnected a tutti i vari pvt se presenti
var
  h: integer;
  pcanale: precord_canale_chat_visual;
  pvt_chat: precord_pvt_chat_visual;
begin
  pcanale := pcanale_per_synch;

  if pcanale^.lista_pvt = nil then exit; //non ho pvt aperti

  for h := 0 to pcanale^.lista_pvt.count - 1 do begin
    pvt_chat := pcanale^.lista_pvt[h];
    helper_chatroom_gui.out_text_memo(pvt_chat^.memo, colore_per_synch, '', utf8strtowidestr(testo_per_synch));
  end;

    { if ((should_font_change) and (ares_FrmMain.panel_chat.activepanel<>pcanale^.containerPanel)) then begin
      should_font_change:=false;
      assign_chatroom_tabimg(pcanale,true);
     end; }
end;



// server let us know about the browsable/shared mime type(s) and we sendback our filelist(if any)

procedure tthread_client_chat.handler_put_server_features(socket_canale: precord_socket_canale);
var
  supportByte: byte;
begin
  try
    pcanale_per_synch := socket_canale^.pcanale;
    if pcanale_per_synch^.should_exit then exit;

    socket_canale^.version := copy(content, 1, pos(CHRNULL, content) - 1);

    colore_per_synch := COLORE_NOTIFICATION;
    testo_per_synch := 'Server ' + socket_canale^.version;
    synchronize(out_memo_simple);

    delete(content, 1, pos(CHRNULL, content)); //skippiamo versione
    if length(content) < 1 then exit;

    testo_per_synch := content;
    socket_canale_per_synch := socket_canale;
    synchronize(put_server_features);

    supportByte := ord(content[1]);

    socket_canale^.support_compression := supportCompressionInFlags(supportByte);

    if supportFileSharinginFlags(supportByte) then begin
//if ((content[1]=chr(2)) or (content[1]=chr(3))) then begin
      if length(content) > 1 then begin
        socket_canale_per_synch^.shareable_types := ord(content[2]);
        synchronize(send_filelist);
      end;

    end;

  except
  end;
end;

function supportPvtInFlags(flags: byte): boolean;
begin
  result := ((flags and 1) = 1);
end;

function supportFileSharingInFlags(flags: byte): boolean;
begin
  result := ((flags and 2) = 2) or ((flags and 3) = 3);
end;

function supportCompressionInFlags(flags: byte): boolean;
begin
  result := ((flags and 4) = 4);
end;

//should we upload our filelist?

procedure tthread_client_chat.check_send_filelist;
var
  i: integer;
begin
  if not loc_allow_pvt_browse then exit; //non inviare la lista se l'utente non vuole
  try

    for i := 0 to socket_list.count - 1 do begin
      socket_canale_per_synch := socket_list[i];
      if socket_canale_per_synch^.sent_filelist then continue;
      if not socket_canale_per_synch^.support_files then continue;
      synchronize(send_filelist); //invia lista
    end;

  except
  end;
end;




// send filelist according to server's allowed mime types
//(this code sucks, serialization is performed in sync...may be heavy for the GUI aka GUI locked with big sized filelists-many files shared)
// to do..either:
//1 prepare lame disk serialized list (ala DirectConnect)
//2 use a local copy of our filelist on a thread-safe 'lockable' list object
//3 split serialization on multiple part and be easy with the GUI lock
//semaphore? ;)

procedure tthread_client_chat.send_filelist; //synch

  function BuildPacket(cmd: byte; const cont: string): string;
  begin
    result := int_2_word_string(length(cont)) +
      chr(cmd) +
      cont;
  end;
var
  i: integer;
  pfile: precord_file_library;
  outCompressed, outPacket: string;
begin
  if not loc_allow_pvt_browse then exit;
  if socket_canale_per_synch^.sent_filelist then exit;
  if not socket_canale_per_synch^.support_files then begin
    exit;
  end;

  outCompressed := '';
  for i := 0 to vars_global.lista_shared.count - 1 do begin
    pfile := vars_global.lista_shared[i];

    if pfile^.previewing then break; //non è il momento //?!

    if not pfile^.shared then continue;

    if pfile^.corrupt then continue;


    if not is_chatroom_shared_type(socket_canale_per_synch^.shareable_types, pfile^.amime) then begin
      continue;
    end;

    if length(pfile^.title) < 2 then continue;

    socket_canale_per_synch^.sent_filelist := true;

    if socket_canale_per_synch^.support_compression then begin
      outCompressed := outCompressed +
        BuildPacket(MSG_CHAT_CLIENT_ADDSHARE,
        keywfunc.get_chatserver_sharestring(pfile, vars_global.allow_regular_paths_browse, ares_FrmMain.treeview_lib_regfolders));
      if length(outCompressed) > 800 then begin // server limit 2*KBYTE
        outPacket := ZCompressStr(outCompressed); //,zcMax);
        send_packet(socket_canale_per_synch,
          MSG_CHAT_CLIENTCOMPRESSED,
          outPacket,
          false);
        outCompressed := '';
      end;
    end else
      send_packet(socket_canale_per_synch,
        MSG_CHAT_CLIENT_ADDSHARE,
        keywfunc.get_chatserver_sharestring(pfile, vars_global.allow_regular_paths_browse, ares_FrmMain.treeview_lib_regfolders),
        false);

    if (i mod 500) = 0 then application.processMessages;
  end;


  if length(outCompressed) > 0 then begin
    outPacket := ZCompressStr(outCompressed); //,zcMax);
    send_packet(socket_canale_per_synch,
      MSG_CHAT_CLIENTCOMPRESSED,
      outPacket,
      false);
    outCompressed := '';
  end;

end;
///////////////////////////////////////////////////////////////////////////////////////////////////////


// synchronize GUI, this should show the search editbox if channel supports filelists

procedure tthread_client_chat.put_server_features; //synch
var
  pcanale: precord_canale_chat_visual;
begin

  if length(testo_per_synch) < 1 then exit;

  try
    pcanale := pcanale_per_synch;


    pcanale^.support_pvt := supportPvtInFlags(ord(testo_per_synch[1]));
    pcanale^.support_files := supportFileSharingInFlags(ord(testo_per_synch[1]));

  { if testo_per_synch[1]=chr(1) then pcanale^.support_pvt:=true else
    if testo_per_synch[1]=chr(2) then pcanale^.support_files:=true else
     if testo_per_synch[1]=chr(3) then begin
       pcanale^.support_pvt:=true;
       pcanale^.support_files:=true;
     end;   }

    if pcanale^.support_files then begin
      socket_canale_per_synch^.pcanale.listview.beginupdate;
      socket_canale_per_synch^.pcanale.listview.Header.Columns.Items[2].options := [coAllowClick, coEnabled, coDraggable, coParentBidiMode, coResizable, coShowDropMark, coVisible, coParentColor];
      socket_canale_per_synch^.pcanale.listview.Header.Columns.Items[3].options := [coAllowClick, coEnabled, coDraggable, coParentBidiMode, coResizable, coShowDropMark, coVisible, coParentColor];
    // socket_canale_per_synch^.pcanale.listview.Header.Columns.Items[0].Width:=socket_canale_per_synch^.pcanale.listview.Header.Columns.Items[0].Width-109;
      socket_canale_per_synch^.pcanale.listview.Header.Columns.Items[2].Width := 38;
      socket_canale_per_synch^.pcanale.listview.Header.Columns.Items[2].Margin := 4;
      socket_canale_per_synch^.pcanale.listview.Header.Columns.Items[3].Width := 45;
      socket_canale_per_synch^.pcanale.listview.Header.Columns.Items[3].Margin := 4;
      socket_canale_per_synch^.pcanale.listview.endupdate;
    end;

    with socket_canale_per_synch^ do begin
      support_files := pcanale^.support_files;
      support_pvt := pcanale^.support_pvt;
    end;

    if pcanale^.support_files then
      if pcanale^.containerPageview = ares_FrmMain.panel_chat.activepanel then mainGui_togglechats(pcanale, false, false, nil); //mostriamo search se è il caso...

  except
  end;
end;

//again output of text on the richedit, but this time we can set a different imageindex on our tab if it isn't topmost-selected

procedure tthread_client_chat.out_memo; //synch
var
  pcanale: precord_canale_chat_visual;
begin

  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

    helper_chatroom_gui.out_text_memo(pcanale^.memo, colore_per_synch, utf8strtowidestr(utente_per_synch), utf8strtowidestr(testo_per_synch));

    if ((should_font_change) and
      ((ares_FrmMain.panel_chat.activepanel <> pcanale^.containerPageview) or (ares_frmmain.tabs_pageview.activepage <> IDTAB_CHAT) or (pcanale^.containerPageview.activePage <> 0))) then begin
      should_font_change := false;
      assign_chatroom_tabimg(pcanale, true);
    end;

  except
  end;
end;


//if we're using socks we may want to use keep alive dummy packets to wake up proxy server...

procedure keep_alive_socks;
var
  i: integer;
  socket_canale: precord_socket_canale;
begin

  for i := 0 to socket_list.count - 1 do begin
    socket_canale := socket_list[i];
    with socket_canale^ do begin
      if stato <> STATO_SOCKET_CANALE_LOGGED then continue;
      if socket = nil then continue;
      if socket.socksip = '' then continue;
    end;
    send_packet(socket_canale, MSG_CHAT_CLIENT_DUMMY, int_2_word_string(random($FFFC)), false);

  end;
end;


// cycle through our channels...

procedure tthread_client_chat.list_deal;
var
  i, er: integer;
  socket_canale: precord_socket_canale;
  tempo: cardinal;
begin
  try
    tempo := gettickcount;

    for i := 0 to socket_list.count - 1 do begin

      socket_canale := socket_list[i];

      if socket_canale^.socket = nil then begin //è disconnesso?
        if socket_canale^.stato = STATO_SOCKET_CANALE_DISCONNECTED then begin //riceonnessione dopo 2 minuti
          if tempo - socket_canale^.disconnect_time > 2 * MINUTE then begin //proviamo disconnessione azzeriamo vars e proviamo a riconnetterci
            if socket_canale^.retry_connect < 25 then begin //2940 era 5 ora è 25 autorejoin!
              with socket_canale^ do begin
                inc(retry_connect);
                sent_filelist := false; //per inviare una sola volta, ma inviare!
                support_files := false;
                support_pvt := false;
                shareable_types := 0;
                disconnect_time := 0;
                support_compression := false;
                in_commands_gui.clear;
                out_commands.clear;
              end;
              connect_channel(socket_canale);
              pcanale_per_synch := socket_canale^.pcanale;
              testo_per_synch := GetLangStringA(STR_CONNECTING_PLEASE_WAIT) + ' #' + inttostr(socket_canale^.retry_connect);
              colore_per_synch := COLORE_NOTIFICATION;
              synchronize(out_memo_simple);
            end; //retry connect<5?
          end;
        end;
        continue;
      end;

      if socket_canale^.stato = STATO_SOCKET_CANALE_LOGGED then begin
        flush_socket(socket_canale);
        if socket_canale^.socket = nil then continue;
        receive_socket(socket_canale);
        continue;
      end else



        if socket_canale^.stato = STATO_SOCKET_CANALE_CONNECTING then begin //in connessione
          if tempo - socket_canale^.tag > TIMOUT_SOCKET_CONNECTION then begin
            if socket_canale^.first_try_connect then begin
              socket_canale^.first_try_connect := false;
              FreeAndNil(socket_canale^.socket);
              connect_channel(socket_canale);
              continue;
            end;
            with socket_canale^ do begin
              stato := STATO_SOCKET_CANALE_DISCONNECTED;
              FreeAndNil(socket);
              disconnect_time := gettickcount;
              pcanale_per_synch := pcanale;
            end;
            testo_per_synch := GetLangStringA(STR_UNABLE_TO_CONNECT);
            colore_per_synch := COLORE_ERROR;
            synchronize(out_memo_simple);
            continue;
          end;
          er := TCPSocket_ISConnected(socket_canale^.socket);
          if er = WSAEWOULDBLOCK then continue else
            if er <> 0 then begin
              if socket_canale^.first_try_connect then begin
                socket_canale^.first_try_connect := false;
                FreeAndNil(socket_canale^.socket);
                connect_channel(socket_canale);
                continue;
              end;
              with socket_canale^ do begin
                stato := STATO_SOCKET_CANALE_DISCONNECTED;
                FreeAndNil(socket);
                disconnect_time := gettickcount;
                pcanale_per_synch := pcanale;
              end;
              testo_per_synch := GetLangStringA(STR_UNABLE_TO_CONNECT);
              colore_per_synch := COLORE_ERROR;
              synchronize(out_memo_simple);
              continue;
            end;

          socket_canale^.tag := tempo;
          socket_canale^.stato := STATO_SOCKET_CANALE_CONNECTED;
          pcanale_per_synch := socket_canale^.pcanale;
          testo_per_synch := GetLangStringA(STR_CONNECTED_HANDSHAKING);
          colore_per_synch := COLORE_NOTIFICATION;
          synchronize(out_memo_simple);

          synchronize(sync_vars);
          er := out_login_req(socket_canale^.socket.socket);
          if er = WSAEWOULDBLOCK then continue;
          if er <> 0 then begin
            with socket_canale^ do begin
              stato := STATO_SOCKET_CANALE_DISCONNECTED;
              FreeAndNil(socket);
              disconnect_time := gettickcount;
              pcanale_per_synch := pcanale;
            end;
            testo_per_synch := GetLangStringA(STR_SOCKET_CANALE_FAILED_HANDSHAKE_RESET);
            colore_per_synch := COLORE_ERROR;
            synchronize(out_memo_simple);
            continue;
          end;
          socket_canale^.tag := tempo;
          socket_canale^.stato := STATO_SOCKET_CANALE_WAITING_FOR_LOGIN_REPLY;
        end else


          if socket_canale^.stato = STATO_SOCKET_CANALE_WAITING_FOR_LOGIN_REPLY then begin
            if tempo - socket_canale^.tag > TIMEOUT_RECEIVE_REPLY * 2 then begin //30 secondi di timeout qui...canale pieno può essere laggato
              with socket_canale^ do begin
                stato := STATO_SOCKET_CANALE_DISCONNECTED;
                FreeAndNil(socket);
                disconnect_time := gettickcount;
                pcanale_per_synch := pcanale;
              end;
              testo_per_synch := GetLangStringA(STR_SOCKET_CANALE_FAILED_HANDSHAKE_TIMEOUT);
              colore_per_synch := COLORE_ERROR;
              synchronize(out_memo_simple);
              continue;
            end;
            receive_socket(socket_canale);
          end;



    end;

  except
  end;
end;


// channel's main receive loop ,receive buffer size is 1kb, we don't handle more than 4kb long packets!

procedure tthread_client_chat.receive_socket(socket_canale: precord_socket_canale);
var
  len, er, lun: integer;
  to_receive, previous_len: integer;
begin
  try

    if not TCPSocket_CanRead(socket_canale^.socket.socket, 0, er) then begin
      if ((er <> 0) and (er <> WSAEWOULDBLOCK)) then begin
        with socket_canale^ do begin
          stato := STATO_SOCKET_CANALE_DISCONNECTED; // disconnettiamo a prossimo giro di receive....
          FreeAndNil(socket);
          disconnect_time := gettickcount;
          pcanale_per_synch := pcanale;
        end;
        testo_per_synch := GetLangStringA(STR_DISCONNECTED) + ' (' + inttostr(er) + ')';
        colore_per_synch := COLORE_ERROR;
        synchronize(out_memo_simple);
        synchronize(notice_disconnect_pvts);
      end;
      exit;
    end;


    while true do begin

      previous_len := length(socket_canale^.in_buffer);
      if previous_len < 3 then to_receive := 3 - previous_len else begin
        to_receive := ((Ord(socket_canale^.in_buffer[1]) + 256 * Ord(socket_canale^.in_buffer[2])) + 3) - previous_len;
        if to_receive > 1024 then to_receive := 1024;
      end;


      len := TCPSocket_RecvBuffer(socket_canale^.socket.socket, @buffer_global, to_receive, er);

      if er = WSAEWOULDBLOCK then exit
      else
        if er <> 0 then begin
          with socket_canale^ do begin
            stato := STATO_SOCKET_CANALE_DISCONNECTED;
            FreeAndNil(socket);
            disconnect_time := gettickcount;
            pcanale_per_synch := pcanale;
          end;
          testo_per_synch := GetLangStringA(STR_DISCONNECTED) + ' (' + inttostr(er) + ')';
          colore_per_synch := COLORE_ERROR;
          synchronize(out_memo_simple);
          synchronize(notice_disconnect_pvts);
          exit;
        end;

      if len < 1 then exit;

      setlength(socket_canale^.in_buffer, previous_len + len);
      move(buffer_global, socket_canale^.in_buffer[previous_len + 1], len);

      if length(socket_canale^.in_buffer) < 3 then continue;

      lun := Ord(socket_canale^.in_buffer[1]) + 256 * Ord(socket_canale^.in_buffer[2]);
      if lun > 4096 then begin
        with socket_canale^ do begin
          stato := STATO_SOCKET_CANALE_DISCONNECTED; // disconnettiamo a prossimo giro di receive....
          FreeAndNil(socket);
          pcanale_per_synch := pcanale;
        end;
        testo_per_synch := GetLangStringA(STR_DISCONNECTED_OVERFLOW);
        colore_per_synch := COLORE_ERROR;
        synchronize(out_memo_simple);
        synchronize(notice_disconnect_pvts);
        exit;
      end;

      if length(socket_canale^.in_buffer) < lun + 3 then continue; // packet not ready...

      process_command(socket_canale); //send to protocol handler

      socket_canale^.in_buffer := ''; //dealloc
      if socket_canale^.stato = STATO_SOCKET_CANALE_DISCONNECTED then exit;
    end;

  except
  end;
end;


//protocol handler

procedure tthread_client_chat.process_command(socket_canale: precord_socket_canale);
var
  cmd: byte;
begin
  try

    cmd := ord(socket_canale^.in_buffer[3]);

    setlength(content, length(socket_canale^.in_buffer) - 3);
    move(socket_canale^.in_buffer[4], content[1], length(content));

    case cmd of
      MSG_CHAT_SERVER_ERROR: handler_server_error(socket_canale);
      MSG_CHAT_SERVER_LOGIN_ACK: handler_login_ok(socket_canale);
      MSG_CHAT_SERVER_REDIRECT: handler_login_redirect(socket_canale); // added 2005-09-26
      MSG_CHAT_CLIENT_PUBLIC: handler_public(socket_canale);
      MSG_CHAT_CLIENT_EMOTE: handler_emote(socket_canale);
      MSG_CHAT_SERVER_NOSUCH: handler_nosuch(socket_canale);
      MSG_CHAT_SERVER_JOIN: handler_join(socket_canale);
      MSG_CHAT_SERVER_PART: handler_part(socket_canale);
      MSG_CHAT_SERVER_CHANNEL_USER_LIST: handler_channel_user(socket_canale);
      MSG_CHAT_SERVER_TOPIC: handler_channel_topic(socket_canale);
      MSG_CHAT_SERVER_TOPIC_FIRST: handler_topic_first(socket_canale);
      MSG_CHAT_SERVER_UPDATE_USER_STATUS: handler_update_user_status(socket_canale);
      MSG_CHAT_SERVER_CHANNEL_USER_LIST_END: handler_end_of_userlist(socket_canale);
      MSG_CHAT_SERVER_CHANNEL_USERLIST_CLEAR: handler_userlist_clear(socket_canale);
      MSG_CHAT_SERVER_MYFEATURES: handler_put_server_features(socket_canale);
      MSG_CHAT_CLIENT_PVT: handler_incoming_pvt(socket_canale);
      MSG_CHAT_SERVER_OFFLINEUSER: handler_offline_bypvt(socket_canale);
      MSG_CHAT_SERVER_ISIGNORINGYOU: handler_ignored_bypvt(socket_canale);
      MSG_CHAT_SERVER_ENDOFSEARCH: handler_endofsearch(socket_canale);
      MSG_CHAT_SERVER_SEARCHHIT: handler_arrived_result(socket_canale);
      MSG_CHAT_SERVER_BROWSEERROR: handler_set_browse_error(socket_canale);
      MSG_CHAT_SERVER_ENDOFBROWSE: handler_set_endof_browse(socket_canale);
      MSG_CHAT_SERVER_STARTOFBROWSE: handler_set_startof_browse(socket_canale);
      MSG_CHAT_SERVER_BROWSEITEM: handler_browse_addnewfile(socket_canale);
      MSG_CHAT_CLIENT_DIRCHATPUSH: synchronize(handler_requested_dirchatpush);
      MSG_CHAT_SERVER_URL: handler_server_update_url(socket_canale);
      MSG_CHAT_SERVER_OPCHANGE: handler_server_opchange(socket_canale);
      MSG_CHAT_CLIENTCOMPRESSED: handler_server_compressed(socket_canale);
    end;

  except
  end;
end;


procedure tthread_client_chat.handler_server_compressed(socket_canale: precord_socket_canale);
var
  cont: string;
  lenWanted: word;
begin
  try

    cont := ZDecompressStr(content);

    while (length(cont) >= 3) do begin

      move(cont[1], lenWanted, 2);
      if length(cont) < lenWanted + 3 then break;

      setLength(socket_canale^.in_buffer, lenWanted + 3);
      move(lenWanted, socket_canale^.in_buffer[1], 2);
      socket_canale^.in_buffer[3] := cont[3];
      move(cont[4], socket_canale^.in_buffer[4], lenWanted);

      process_Command(socket_canale);

      if socket_canale^.stato = STATO_SOCKET_CANALE_DISCONNECTED then exit;

      delete(cont, 1, lenWanted + 3);
    end;

  except
  end;
end;

// userlevel change

procedure tthread_client_chat.handler_server_opchange(socket_canale: precord_socket_canale);
var
  level: integer;
begin
  if length(content) = 0 then exit;

  pcanale_per_synch := socket_canale^.pcanale;
  synchronize(handler_server_opchange);
end;

procedure tthread_client_chat.handler_server_opchange; //sync
var
  keepHidden: boolean;
begin
  try

    pcanale_per_synch^.ModLevel := (content[1] <> CHRNULL);
    if pcanale_per_synch^.should_exit then exit;

    if length(content) > 1 then begin // AE :)
      keepHidden := (content[2] = CHRNULL);
    end else keepHidden := true;

    if (pcanale_per_synch^.ModLevel) and (not keepHidden) then begin
      with pcanale_per_synch.listview do begin
        header.autosizeindex := 0;
        beginupdate;
        Header.Columns.Items[0].options := [coAllowClick, coEnabled, coDraggable, coParentBidiMode, coResizable, coShowDropMark, coVisible, coParentColor];
        Header.Columns.Items[1].options := [coAllowClick, coEnabled, coDraggable, coParentBidiMode, coResizable, coShowDropMark, coVisible, coParentColor];
        Header.Columns.Items[2].options := [coAllowClick, coEnabled, coDraggable, coParentBidiMode, coResizable, coShowDropMark, coVisible, coParentColor];
        Header.Columns.Items[3].options := [coAllowClick, coEnabled, coDraggable, coParentBidiMode, coResizable, coShowDropMark, coVisible, coParentColor];

        Header.Columns.Items[1].Width := 30;
        Header.Columns.Items[1].Margin := 4;
        Header.Columns.Items[2].Width := 38;
        Header.Columns.Items[2].Margin := 4;
        Header.Columns.Items[3].Width := 45;
        Header.Columns.Items[3].Margin := 4;
        endupdate;
        header.autosizeindex := -1;
      end;

    end else begin
      pcanale_per_synch.listview.header.autosizeindex := 0;
      pcanale_per_synch.listview.Header.Columns.Items[1].options := [coAllowClick, coEnabled, coDraggable, coParentBidiMode, coResizable, coShowDropMark, coParentColor];
      pcanale_per_synch.listview.header.autosizeindex := -1;
    end;

  except
  end;
end;



//one new browsed item received, parse it

procedure tthread_client_chat.handler_browse_addnewfile(socket_canale: precord_socket_canale);
var
  tipo_field, len: byte;
  str, str_details, paths: string;
  len_details: word;
begin
  if length(content) < 30 then exit;

  randomstr_per_synch := copy(content, 1, 2);
  pcanale_per_synch := socket_canale^.pcanale;
  paths := '';

  presult_browse_globale := AllocMem(sizeof(record_file_library));

  reset_result_browse;

  with presult_browse_globale^ do begin
    filedate := 0;
    amime := ord(content[3]);
    fsize := chars_2_dword(copy(content, 4, 4));

    if presult_browse_globale^.amime = ARES_MIME_MP3 then begin //parse quality/length details
      param1 := chars_2_word(copy(content, 24, 2));
      param3 := chars_2_word(copy(content, 26, 2));
      delete(content, 1, 27);
    end else
      if presult_browse_globale^.amime = ARES_MIME_VIDEO then begin
        param1 := chars_2_word(copy(content, 24, 2));
        param2 := chars_2_word(copy(content, 26, 2));
        param3 := chars_2_word(copy(content, 28, 2));
        delete(content, 1, 29);
      end else
        if presult_browse_globale^.amime = ARES_MIME_IMAGE then begin
          param1 := chars_2_word(copy(content, 24, 2));
          param2 := chars_2_word(copy(content, 26, 2));
          param3 := ord(content[28]);
          delete(content, 1, 28);
        end else delete(content, 1, 23);
  end;

  if length(content) < 10 then exit;

  len_details := chars_2_word(copy(content, 1, 2));
  str_details := copy(content, 3, len_details);
  delete(content, 1, len_details + 2);


  with presult_browse_globale^ do begin
    while (length(str_details) > 2) do begin
      len := ord(str_details[1]);
      tipo_field := ord(str_details[2]);
      str := copy(str_details, 3, len);
      delete(str_details, 1, len + 2);
      case tipo_field of
        CHATROOM_RESULT_TITLE: title := str;
        CHATROOM_RESULT_ARTIST: artist := str;
        CHATROOM_RESULT_ALBUM: album := str;
        CHATROOM_RESULT_CATEGORY: category := str;
        CHATROOM_RESULT_YEAR: year := str;
        CHATROOM_RESULT_LANGUAGE: language := str;
        CHATROOM_RESULT_URL: url := str;
        CHATROOM_RESULT_COMMENT: comment := str;
        CHATROOM_RESULT_KEYWORD_GENRE: keywords_genre := str;
        CHATROOM_RESULT_FORMAT: vidinfo := str;
        CHATROOM_RESULT_FILENAME: path := str; //filename
        CHATROOM_RESULT_SHA1: begin
            hash_sha1 := str;
            crcsha1 := crcstring(str);
          end;
        CHATROOM_RESULT_PATH: paths := paths + str; //path regular browse
        CHATROOM_RESULT_SIZEINT64: fsize := chars_2_Qword(copy(str, 1, 8)); //2951+  5-1-2004
      end;
    end;
  end;

  if paths <> '' then
    presult_browse_globale^.path := paths + '\' + presult_browse_globale^.path; //has got regular path

  synchronize(handler_browse_addnewfile); //add it!

end;

//find matching browse panel for this item (thread-safe)

procedure tthread_client_chat.handler_browse_addnewfile;
var
  i: integer;
  pannello_browse: precord_pannello_browse_chat;
  nodo: pCmtVnode;
  data: precord_file_library;
begin
  try

    if pcanale_per_synch^.should_exit then exit;
    if pcanale_per_synch.lista_pannelli_browse = nil then exit;

    for i := 0 to pcanale_per_synch^.lista_pannelli_browse.count - 1 do begin
      pannello_browse := pcanale_per_synch^.lista_pannelli_browse[i];
      if pannello_browse^.randomstr <> randomstr_per_synch then continue;

     //if is_in_progress_sha1(presult_browse_globale^.hash_sha1) then chatclient_add_source_download_frombrowse(pannello_browse,presult_browse_globale);
      pannello_browse^.lista_files.add(presult_browse_globale); //is already in lib è markato in  mostra file library()


     //put progress?
      if (pannello_browse^.lista_files.Count mod 50) = 0 then begin
        nodo := pannello_browse^.listview.getfirst;
        if nodo = nil then exit;
        data := pannello_browse^.listview.getdata(nodo);

        data^.title := GetLangStringA(STR_BROWSEINPROGRESS) + ' (' + format_currency(pannello_browse^.lista_files.count) + ' ' + GetLangStringA(STR_OF) + ' ' +
          format_currency(pannello_browse^.num_files) + ' ' + GetLangStringA(STR_FILES) + ')';

        pannello_browse^.listview.invalidatenode(nodo);
      end;

      exit;
    end;


// no browse panel available...damn lag :)
    reset_result_browse;
    FreeMem(presult_browse_globale, sizeof(record_file_library));

  except
  end;
end;





// copy local filelist to the GUI record

procedure tthread_client_chat.browse_files_copy; //sync
var
  i: integer;
  pannello_browse: precord_pannello_browse_chat;
begin
  if pcanale_per_synch.lista_pannelli_browse = nil then exit;

  for i := 0 to pcanale_per_synch^.lista_pannelli_browse.count - 1 do begin
    pannello_browse := pcanale_per_synch^.lista_pannelli_browse[i];
    if pannello_browse^.randomstr <> randomstr_per_synch then continue;

    while (pannello_browse^.lista_files.count > 0) do begin
      files_browsed.add(pannello_browse^.lista_files[pannello_browse^.lista_files.count - 1]);
      pannello_browse^.lista_files.delete(pannello_browse^.lista_files.count - 1);
    end;

    break;
  end;

end;


// browse error, unavailable filelist

procedure tthread_client_chat.handler_set_browse_error(socket_canale: precord_socket_canale);
begin
// parse result...
  if length(content) < 2 then exit;

  randomstr_per_synch := copy(content, 1, 2);
  pcanale_per_synch := socket_canale^.pcanale;

  synchronize(handler_set_browse_error);
end;

procedure tthread_client_chat.handler_set_browse_error; //synch
var
  i: integer;
  pannello_browse: precord_pannello_browse_chat;
  nodo: pCmtVnode;
  data: precord_file_library;
begin
  try

    if pcanale_per_synch^.should_exit then exit;
    if pcanale_per_synch.lista_pannelli_browse = nil then exit;

    for i := 0 to pcanale_per_synch^.lista_pannelli_browse.count - 1 do begin
      pannello_browse := pcanale_per_synch^.lista_pannelli_browse[i];
      if pannello_browse^.randomstr <> randomstr_per_synch then continue;

      pannello_browse^.num_files := 0;

      nodo := pannello_browse^.listview.getfirst;
      if nodo = nil then exit;
      data := pannello_browse^.listview.getdata(nodo);
      data^.title := GetLangStringA(STR_BROWSE_FAILED_USER_OFFLINE);

      pannello_browse^.listview.invalidatenode(nodo);

      break;
    end;

  except
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////////



//browse started be prepared to receive N items...

procedure tthread_client_chat.handler_set_startof_browse(socket_canale: precord_socket_canale);
begin
// parse result...
  if length(content) < 4 then exit;

  randomstr_per_synch := copy(content, 1, 2);
  delete(content, 1, 2);
  pcanale_per_synch := socket_canale^.pcanale;

  synchronize(handler_set_startof_browse);
end;

procedure tthread_client_chat.handler_set_startof_browse; //synch
var
  i: integer;
  pannello_browse: precord_pannello_browse_chat;
  nodo: pCmtVnode;
  data: precord_file_library;
begin
  try

    if pcanale_per_synch^.should_exit then exit;
    if pcanale_per_synch.lista_pannelli_browse = nil then exit;

    for i := 0 to pcanale_per_synch^.lista_pannelli_browse.count - 1 do begin
      pannello_browse := pcanale_per_synch^.lista_pannelli_browse[i];
      if pannello_browse^.randomstr <> randomstr_per_synch then continue;

      pannello_browse^.num_files := chars_2_word(copy(content, 1, 2));

      nodo := pannello_browse^.listview.getfirst;
      if nodo = nil then exit;
      data := pannello_browse^.listview.getdata(nodo);
      data^.title := GetLangStringA(STR_BROWSEINPROGRESS) + ' (0 ' + GetLangStringA(STR_OF) + ' ' +
        format_currency(pannello_browse^.num_files) + ' ' + GetLangStringA(STR_FILES) + ')';

      pannello_browse^.listview.invalidatenode(nodo);

      break;
    end;

  except
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////
//end of browse, calculate virtual categories and stuff...

procedure tthread_client_chat.handler_set_endof_browse(socket_canale: precord_socket_canale);
begin
// parse result...
  if length(content) < 2 then exit;

  randomstr_per_synch := copy(content, 1, 2);
  pcanale_per_synch := socket_canale^.pcanale;

  categs_free;
  categs_init;

  synchronize(browse_files_copy);
  sleep(100);
  categs_compute; //synch
  categs_sort;
  sleep(100);
  synchronize(handler_set_endof_browse);

  categs_free;
end;

//update the GUI with our virtual folders and stuff (thread-safe)

procedure tthread_client_chat.handler_set_endof_browse; //synch
var
  i: integer;
  pannello_browse: precord_pannello_browse_chat;
  reg: tregistry;
  nodo: pCmtVnode;
  data: precord_file_library;
begin
  try

    if pcanale_per_synch.lista_pannelli_browse = nil then exit;
    if pcanale_per_synch^.should_exit then exit;

    for i := 0 to pcanale_per_synch^.lista_pannelli_browse.count - 1 do begin
      pannello_browse := pcanale_per_synch^.lista_pannelli_browse[i];
      if pannello_browse^.randomstr <> randomstr_per_synch then continue;

      if pannello_browse^.num_files = 0 then begin //non condivide??
        nodo := pannello_browse^.listview.getfirst;
        if nodo = nil then exit;
        data := pannello_browse^.listview.getdata(nodo);
        data^.title := GetLangStringA(STR_BROWSECOMPLETED) + ' 0 ' + GetLangStringA(STR_FILES);
        pannello_browse^.listview.invalidatenode(nodo);
        exit;
      end;

      lockwindowupdate(ares_FrmMain.handle);

      try
        with pannello_browse^.listview do begin
          clear;
          selectable := true;
          canbgcolor := true;
        end;

        reg := tregistry.create;
        with reg do begin
          openkey(areskey + 'bounds', true);
          if valueexists('ChatRoom.BrowseWidth') then begin
            pannello_browse^.panel_left.width := readinteger('ChatRoom.BrowseWidth');
            if pannello_browse^.panel_left.width < 50 then pannello_browse^.panel_left.width := 50 else
              if pannello_browse^.panel_left.width > 500 then pannello_browse^.panel_left.width := 500;
          end else pannello_browse^.panel_left.width := 200;
          closekey;
          openkey(areskey, true);
          writestring('GUI.LastChatRoomBrowse', '');
          closekey;
          destroy;
        end;
        pannello_browse^.splitter2.width := 4;


        add_base_virtualnodes(pannello_browse^.treeview, false);
        write_categs_treeview(pannello_browse^.treeview);


        pannello_browse^.pnl.btncaption := utf8strtowidestr(pannello_browse^.nick) + ' (' + inttostr(files_browsed.count) + ')';

      except
      end;
      lockwindowupdate(0);

      deal_with_regular_folder_browse(files_browsed, pannello_browse^.treeview2);
      nodo := pannello_browse^.treeview2.getfirst;
      if nodo <> nil then
        if nodo.childcount > 0 then begin
          with pannello_browse^ do begin
            treeview2.Expanded[nodo] := true;
            btn_regular_view.visible := True;
          end;
        end;

      while (files_browsed.count > 0) do begin
        pannello_browse^.lista_files.add(files_browsed[files_browsed.count - 1]);
        files_browsed.Delete(files_browsed.count - 1);
      end;

      nodo := pannello_browse^.treeview.getfirst;
      if nodo = nil then exit;
      pannello_browse^.treeview.Selected[nodo] := true;
      ufrmmain.ares_FrmMain.treeviewbrowseclick(pannello_browse^.treeview);

      break;
    end;

  except
  end;
end;
/////////////////////////////////////////////////////////////////////////////////////////






// a new search item from server, parse packet

procedure tthread_client_chat.handler_arrived_result(socket_canale: precord_socket_canale);
var
  tipo_field, len: byte;
  str, str_details: string;
  len_details: word;
begin
  if length(content) < 30 then exit;

  randomstr_per_synch := copy(content, 1, 2);
  presult_globale_search^.amime := ord(content[3]);
  if presult_globale_search^.amime > ARES_MIME_IMAGE then exit;

  reset_result_search;

  with presult_globale_search^ do begin
    fsize := chars_2_dword(copy(content, 4, 4));

    if amime = ARES_MIME_MP3 then begin //parse quality/length details
      param1 := chars_2_word(copy(content, 24, 2));
      param3 := chars_2_word(copy(content, 36, 2));
      delete(content, 1, 27);
    end else
      if amime = ARES_MIME_VIDEO then begin
        param1 := chars_2_word(copy(content, 24, 2));
        param2 := chars_2_word(copy(content, 26, 2));
        param3 := chars_2_word(copy(content, 28, 2));
        delete(content, 1, 29);
      end else
        if amime = ARES_MIME_IMAGE then begin
          param1 := chars_2_word(copy(content, 24, 2));
          param2 := chars_2_word(copy(content, 26, 2));
          param3 := ord(content[28]);
          delete(content, 1, 28);
        end else delete(content, 1, 23);
  end;

  if length(content) < 10 then exit;

  len_details := chars_2_word(copy(content, 1, 2));
  str_details := copy(content, 3, len_details);
  delete(content, 1, len_details + 2);

  with presult_globale_search^ do begin
    while (length(str_details) > 2) do begin
      len := ord(str_details[1]);
      tipo_field := ord(str_details[2]);
      str := copy(str_details, 3, len);
      delete(str_details, 1, len + 2);
      case tipo_field of
        CHATROOM_RESULT_TITLE: title := str;
        CHATROOM_RESULT_ARTIST: artist := str;
        CHATROOM_RESULT_ALBUM: album := str;
        CHATROOM_RESULT_CATEGORY: category := str;
        CHATROOM_RESULT_YEAR: data := str;
        CHATROOM_RESULT_LANGUAGE: language := str;
        CHATROOM_RESULT_URL: url := str;
        CHATROOM_RESULT_COMMENT: comments := str;
        CHATROOM_RESULT_KEYWORD_GENRE: keyword_genre := str;
        CHATROOM_RESULT_FORMAT: vidinfo := str;
        CHATROOM_RESULT_FILENAME: filename := str;
        CHATROOM_RESULT_SHA1: begin
            hash_sha1 := str;
            crcsha1 := crcstring(str);
          end;
        CHATROOM_RESULT_SIZEINT64: fsize := chars_2_Qword(copy(str, 1, 8)); //2951+  5-1-2004
      end;
    end;
  end;

  presult_globale_search^.nickname := copy(content, 1, pos(CHRNULL, content) - 1);
  delete(content, 1, pos(CHRNULL, content));
  if length(presult_globale_search^.nickname) < 2 then exit;
  if length(content) < 19 then exit;

  with presult_globale_search^ do begin
    ip_user := chars_2_dword(copy(content, 1, 4));
    port_user := chars_2_word(copy(content, 5, 2));
    ip_server := chars_2_dword(copy(content, 7, 4));
    port_server := chars_2_word(copy(content, 11, 2));
    ip_alt := chars_2_dword(copy(content, 13, 4));
    up_count := ord(content[17]);
    up_limit := ord(content[18]);
    queued := ord(content[19]);
  end;

  pcanale_per_synch := socket_canale^.pcanale;
  synchronize(handler_arrived_result);
end;

// add this item to the GUI

procedure tthread_client_chat.handler_arrived_result; //synch
var
  h: integer;
  pcanale: precord_canale_chat_visual;
  pannello_result: precord_pannello_result_chat;
begin

  pcanale := pcanale_per_synch;
  if pcanale^.lista_pannelli_result = nil then exit;

  for h := 0 to pcanale^.lista_pannelli_result.count - 1 do begin
    pannello_result := pcanale^.lista_pannelli_result[h];
    if pannello_result^.randomstr <> randomstr_per_synch then continue;
    chatclient_add_result_search(pcanale, pannello_result, presult_globale_search);
    exit;
  end;

end;



// do we have any matching SHA-1 download? do we need another source?

procedure tthread_client_chat.add_source_download_result; //synch
begin
  chatclient_add_source_download_fromresult(presult_globale_search);
end;

//host sends us elsewhere, optional displayed message eg: You're being redirected to channel bla bla bla

procedure tthread_client_chat.handler_login_redirect(socket_canale: precord_socket_canale);
begin
  with socket_canale^ do begin
    ip := chars_2_dword(copy(content, 1, 4));
    port := chars_2_word(copy(content, 5, 2));
    ip_alt := chars_2_dword(copy(content, 7, 4));
    delete(content, 1, 10);
    socket_canale^.name := copy(content, 1, pos(CHRNULL, content) - 1);
    delete(content, 1, pos(CHRNULL, content));
    testo_per_synch := copy(content, 1, pos(CHRNULL, content) - 1);
    stato := STATO_SOCKET_CANALE_DISCONNECTED;
    disconnect_time := 0;
    retry_connect := 0;
    FreeAndNil(socket);

    socket_canale^.pcanale^.name := socket_canale^.name;
    socket_canale^.pcanale^.topic := '';
    sleep(1000);
  end;

  ip_per_synch := socket_canale^.ip;
  port_per_synch := socket_canale^.port;
  ip_alt_per_synch := socket_canale^.ip_alt;

  pcanale_per_synch := socket_canale^.pcanale;

  synchronize(handler_login_redirect);
end;

procedure tthread_client_chat.handler_login_redirect;
begin
  try

    if pcanale_per_synch.should_exit then exit;
    pcanale_per_synch.listview.Beginupdate;
    pcanale_per_synch.listview.clear;
    pcanale_per_synch.listview.endupdate;
    pcanale_per_synch.listview.header.columns[0].text := GetLangStringW(STR_USERS);

    pcanale_per_synch.ip := ip_per_synch;
    pcanale_per_synch.port := port_per_synch;
    pcanale_per_synch.alt_ip := ip_alt_per_synch;

    pcanale_per_synch.pnl.btncaption := utf8strtowidestr(pcanale_per_synch^.name);
    helper_chatroom_gui.out_text_memo(pcanale_per_synch^.memo, COLORE_NOTIFICATION, '', utf8strtowidestr(testo_per_synch));
    ares_frmmain.panel_chat.invalidate;

  except
  end;
end;

// search completed

procedure tthread_client_chat.handler_endofsearch(socket_canale: precord_socket_canale);
begin
  pcanale_per_synch := socket_canale^.pcanale;
  synchronize(handler_endofsearch);
end;

procedure tthread_client_chat.handler_endofsearch; //synch
var
  randomstr: string;
  h: integer;
  pcanale: precord_canale_chat_visual;
  pannello_result: precord_pannello_result_chat;
begin
  randomstr := copy(content, 1, 2);

  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

    if pcanale^.lista_pannelli_result = nil then exit;
    for h := 0 to pcanale^.lista_pannelli_result.count - 1 do begin
      pannello_result := pcanale^.lista_pannelli_result[h];
      if pannello_result^.randomstr = randomstr then begin
        chatclient_set_endofsearch(pcanale, pannello_result);
        exit;
      end;
    end;

  except
  end;
end;
//////////////////////////////////////////////////////////////////////////////////



procedure tthread_client_chat.handler_userlist_clear(socket_canale: precord_socket_canale);
begin
  pcanale_per_synch := socket_canale^.pcanale;
  synchronize(handler_userlist_clear);
end;

procedure tthread_client_chat.handler_userlist_clear; // sync
var
  pcanale: precord_canale_chat_visual;
begin
  pcanale := pcanale_per_synch;
  if pcanale^.should_exit then exit;

  pcanale^.listview.clear;
  pcanale^.listview.endupdate;
  pcanale^.listview.header.columns[0].text := GetLangStringW(STR_USERS);
end;


// just joined the channel endof update of userlist's listview

procedure tthread_client_chat.handler_end_of_userlist(socket_canale: precord_socket_canale);
begin
  pcanale_per_synch := socket_canale^.pcanale;
  synchronize(handler_end_of_userlist);
  socket_canale^.retry_connect := 0;
end;

//end of userlist, this used to clear richedit too...now only updates tab's caption

procedure tthread_client_chat.handler_end_of_userlist; //synch
var
  pcanale: precord_canale_chat_visual;
  nodof: pcmtvnode;
  dataf: precord_chat_favorite;
  has_colors_intopic: boolean;
  found: boolean;
  locrc: word;
  oldip: cardinal;
  oldport: word;

  currentID: integer;
  node: PCmtVNode;
  dataUser: precord_displayed_chat_user;
begin
  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

 // assign numeric user id (admin column ID)
    CurrentID := 0;
    node := pcanale^.listview.getfirst;
    while (node <> nil) do begin
      dataUser := pcanale^.listview.getdata(node);
      dataUser^.id := CurrentID;
      inc(currentID);
      node := pcanale^.listview.getNext(node);
    end;

    pcanale^.listview.header.autosizeindex := 0;
    pcanale^.listview.endupdate;
    pcanale^.listview.header.autosizeindex := -1;


    pcanale^.listview.header.columns[0].text := GetLangStringW(STR_USERS) + ' (' + inttostr(pcanale^.listview.rootnodecount) + ')';

    if not reg_wants_chatautofavorites then exit;


    if pcanale^.ip = 16777343 then exit; // doesn't apply to hosted channel

  // add channel to favorites
    locrc := stringcrc(lowercase(pcanale^.name), true);

    found := false;
    oldip := 0;
    oldport := 0;

    nodof := ares_frmmain.treeview_chat_favorites.getfirst;
    while (nodof <> nil) do begin
      dataf := ares_frmmain.treeview_chat_favorites.getdata(nodof);

      if dataf^.ip = pcanale^.ip then
        if dataf^.port = pcanale^.port then begin
          found := true;
          oldip := dataf^.ip;
          oldport := dataf^.port;
          break;
        end;

      if dataf^.locrc = locrc then
        if dataf^.name = pcanale^.name then begin
          oldip := dataf^.ip;
          oldport := dataf^.port;
          found := true;
          break;
        end;

      nodof := ares_frmmain.treeview_chat_favorites.getnext(nodof);
    end;

    if ((not found) and (ares_frmmain.Check_opt_chat_autoadd.checked)) then begin
      nodof := ares_frmmain.treeview_chat_favorites.addchild(nil);
      dataf := ares_frmmain.treeview_chat_favorites.getdata(nodof);
    end;
    if ((not found) and (not ares_frmmain.Check_opt_chat_autoadd.checked)) then exit;

    dataf^.ip := pcanale^.ip;
    dataf^.alt_ip := pcanale^.alt_ip;
    dataf^.last_joined := DelphiDateTimeToUnix(now);
    dataf^.port := pcanale^.port;
    dataf^.name := pcanale^.name;
    dataf^.topic := pcanale^.topic;
    dataf^.locrc := locrc;
    dataf^.stripped_topic := strip_color_string(utf8strtowidestr(pcanale^.topic), has_colors_intopic);
    dataf^.has_colors_intopic := has_colors_intopic;

    if ares_frmmain.Check_opt_chat_autoadd.checked then helper_chat_favorites.save_favorite_channel(dataf, oldip, oldport);

  except
  end;
end;




/// new details for an existing user, update his/her server ip:port pair and/or number of shared files etc....

procedure tthread_client_chat.handler_update_user_status(socket_canale: precord_socket_canale);
begin
  try

    utente_per_synch := copy(content, 1, pos(CHRNULL, content) - 1);
    if length(content) < 9 then exit;

    delete(content, 1, pos(CHRNULL, content));

    files_per_synch := chars_2_word(copy(content, 1, 2));
    crc_per_synch := stringcrc(utente_per_synch, true);
    ModLevelSync := false;
    ip_serveR_per_synch := chars_2_dword(copy(content, 4, 4));
    port_server_per_synch := chars_2_word(copy(content, 8, 2));
    if length(content) >= 13 then begin
      ip_per_synch := chars_2_dword(copy(content, 10, 4));
      if length(content) > 13 then ModLevelSync := (ord(content[14]) <> 0);
    end else ip_per_synch := 0;

    pcanale_per_synch := socket_canale^.pcanale;

    synchronize(handler_update_user_status);

  except
  end;
end;

procedure tthread_client_chat.handler_update_user_status; //synch
var
  pcanale: precord_canale_chat_visual;
  nodo: pCmtVnode;
  data: precord_displayed_chat_user;
  nickcomp: string;
begin

  nickcomp := utente_per_synch;

  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

    nodo := pcanale^.listview.GetFirst;
    while (nodo <> nil) do begin
      data := pcanale^.listview.getdata(nodo);
      if data^.crcnick = crc_per_synch then
        if data^.nick = nickcomp then begin

          data^.files := files_per_synch;
          if ip_per_synch <> 0 then data^.ip := ip_per_synch;
          data^.ip_server := ip_server_per_synch;
          data^.port_server := port_server_per_synch;
          data^.ModLevel := ModLevelSync;
          pcanale^.listview.invalidatenode(nodo);
          exit;
        end;
      nodo := pcanale^.listview.getnext(nodo);
    end;

  except
  end;

end;
///////////////////////////////////////////////////////////////////////////////////////////////


procedure tthread_client_chat.updateChannelName; //sync
begin
  pcanale_per_synch^.name := testo_per_synch;
  pcanale_per_synch^.pnl.btncaption := utf8strtowidestr(testo_per_synch);

  if pcanale_per_synch^.frmtab <> nil then begin
    (pcanale_per_synch^.frmTab as tfrmChatTab).SetCaption;
  end;

end;

procedure tthread_client_chat.reconnect(socket_canale: precord_socket_canale);
begin
  try
    with socket_canale^ do begin
      stato := STATO_SOCKET_CANALE_DISCONNECTED;
      if socket <> nil then FreeAndNil(socket);
      disconnect_time := 0;
      retry_connect := 1; // no other attempts
      pcanale_per_synch := pcanale;
    end;

    testo_per_synch := GetLangStringA(STR_DISCONNECTED);

    colore_per_synch := COLORE_ERROR;
    synchronize(out_memo_simple);
  except
  end;
end;

procedure tthread_client_chat.handler_server_error(socket_canale: precord_socket_canale);
begin

  with socket_canale^ do begin
    stato := STATO_SOCKET_CANALE_DISCONNECTED;
    FreeAndNil(socket);
    disconnect_time := gettickcount;
    retry_connect := 25; // no other attempts
    pcanale_per_synch := pcanale;
  end;

  if length(content) > 0 then testo_per_synch := GetLangStringA(STR_DISCONNECTED) + ': ' + content
  else testo_per_synch := GetLangStringA(STR_DISCONNECTED);

  colore_per_synch := COLORE_ERROR;
  synchronize(out_memo_simple);

end;

//we are logged, server accepted us, update the GUI

procedure tthread_client_chat.handler_login_ok(socket_canale: precord_socket_canale);
var
  mynickname,
    tempChannelName: string;
begin


  mynickname := copy(content, 1, pos(CHRNULL, content) - 1);
  delete(content, 1, pos(CHRNULL, content));
  if length(content) > 1 then begin
    tempChannelName := copy(content, 1, pos(CHRNULL, content) - 1);

    if (tempChannelName <> socket_canale^.name) and (length(tempChannelName) > MIN_CHAT_NAME_LEN) then begin
      socket_canale^.name := tempChannelName;
      pcanale_per_synch := socket_canale^.pcanale;
      testo_per_synch := tempChannelName;
      synchronize(updateChannelName);
    end;

  end;

  socket_canale^.stato := STATO_SOCKET_CANALE_LOGGED;
  testo_per_synch := GetLangStringA(STR_LOGGED_IN_RETRIEVING_LIST);
  colore_per_synch := COLORE_NOTIFICATION;
  pcanale_per_synch := socket_canale^.pcanale;

  if socket_canale^.ip_alt <> socket_canale^.ip then begin // use succeded IP next time
    if ipint_to_dotstring(socket_canale^.ip_alt) = socket_canale^.socket.ip then
      socket_canale^.ip := socket_canale^.ip_alt
    else socket_canale^.ip_alt := socket_canale^.ip;
  end;

  synchronize(out_memo_simple);
  synchronize(start_userlist);
end;

procedure tthread_client_chat.start_userlist; //synch
var
  pcanale: precord_canale_chat_visual;
begin
  pcanale := pcanale_per_synch;
  with pcanale^.listview do begin
    clear;
    beginupdate;
  end;
end;
////////////////////////////////////////////////////////////////////////////////////////////////




// we have a new topic to show

procedure tthread_client_chat.handler_channel_topic(socket_canale: precord_socket_canale);
begin
  testo_per_synch := content;
  pcanale_per_synch := socket_canale^.pcanale;
  socket_canale^.topic := content;
  synchronize(handler_channel_topic);
end;

procedure tthread_client_chat.handler_channel_topic; //(thread-safe)
var
  pcanale: precord_canale_chat_visual;
begin
  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

    pcanale^.topic := testo_per_synch;

    write_topic_chat(pcanale);

    helper_chatroom_gui.out_text_memo(pcanale^.memo, COLORE_NOTIFICATION, '', GetLangStringW(STR_TOPIC_CHANGED) + ': ' + utf8strtowidestr(testo_per_synch));


  except
  end;
end;
////////////////////////////////////////////////////////////////////////////////////

// just joined...here's the topic

procedure tthread_client_chat.handler_topic_first(socket_canale: precord_socket_canale);
begin
  testo_per_synch := content;
  colore_per_synch := COLORE_NOTIFICATION;
  pcanale_per_synch := socket_canale^.pcanale;
  socket_canale^.topic := content;
  synchronize(handler_topic_first);
end;

procedure tthread_client_chat.handler_topic_first;
var
  pcanale: precord_canale_chat_visual;
begin
  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

    pcanale^.topic := testo_per_synch;

    write_topic_chat(pcanale);

  except
  end;
end;
//////////////////////////////////////////////////////////////////////////////////////

//displayed URL ares 1.9.9.3018 +

procedure tthread_client_chat.handler_server_update_url(socket_canale: precord_socket_canale);
begin
  utente_per_synch := copy(content, 1, pos(CHRNULL, content) - 1);
  delete(content, 1, pos(CHRNULL, content));
  testo_per_synch := copy(content, 1, pos(CHRNULL, content) - 1);

  pcanale_per_synch := socket_canale^.pcanale;
  synchronize(handler_server_update_url);
end;

procedure tthread_client_chat.handler_server_update_url;
var
  pcanale: precord_canale_chat_visual;
begin
  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

    pcanale^.urlPanel.captionurl := utf8strtowidestr(testo_per_synch);
    pcanale^.urlPanel.url := utente_per_synch;
  except
  end;
end;

// a new user joined the channel, parse packet and update our GUI

procedure tthread_client_chat.handler_join(socket_canale: precord_socket_canale);
begin
  try
    if length(content) < 20 then exit;

    files_per_synch := chars_2_word(copy(content, 1, 2));
    speed_per_synch := chars_2_dword(copy(content, 3, 4));

    ip_per_synch := chars_2_dword(copy(content, 7, 4));
    port_per_synch := chars_2_word(copy(content, 11, 2));
    ip_server_per_synch := chars_2_dword(copy(content, 13, 4));
    port_server_per_synch := chars_2_word(copy(content, 17, 2));
    ModLevelSync := false;

    support_files_per_synch := false;
    delete(content, 1, 19);
    utente_per_synch := copy(content, 1, pos(CHRNULL, content) - 1);

    delete(content, 1, pos(CHRNULL, content));
    if length(content) >= 4 then begin
      ip_alt_per_synch := chars_2_dword(copy(content, 1, 4));
      if length(content) > 4 then support_files_per_synch := (ord(content[5]) = 1);
      if length(content) > 5 then ModLevelSync := (ord(content[6]) <> 0);
    end else ip_alt_per_synch := 0;

//if ((length(utente_per_synch)<2) or (length(utente_per_synch)>MAX_NICK_LEN)) then exit;
    crc_per_synch := stringcrc(utente_per_synch, true);

    pcanale_per_synch := socket_canale^.pcanale;
    testo_per_synch := utente_per_synch + ' ' + GetLangStringA(STR_SHARING_CHAT) + ' ' + inttostr(files_per_synch) + ' ' + GetLangStringA(STR_FILES_HAS_JOINED);
    colore_per_synch := COLORE_JOIN;
    synchronize(handler_join);

  except
  end;
end;

procedure tthread_client_chat.handler_join; //synch
//update GUI
var
  pcanale: precord_canale_chat_visual;
  cannadd: boolean;
  nodo: pCmtVnode;
  dataUser: ^record_displayed_chat_user;
  nickcomp: string;
  userID: integer;
  clones: integer;
begin

  nickcomp := utente_per_synch;

  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

    cannadd := true;
    clones := 0;

    nodo := pcanale^.listview.GetFirst;
    while (nodo <> nil) do begin
      dataUser := pcanale^.listview.getdata(nodo);

      if crc_per_synch = dataUser^.crcnick then
        if dataUser^.nick = nickcomp then begin
          cannadd := false;
          break;
        end;
      if ip_per_synch = dataUser^.ip then inc(clones);
      nodo := pcanale^.listview.getnext(nodo);
    end;

    if not cannadd then exit;
    if clones >= 5 then exit;

    if ares_frmmain.check_opt_chat_joinpart.checked then
      helper_chatroom_gui.out_text_memo(pcanale^.memo, colore_per_synch, '', utf8strtowidestr(testo_per_synch));

    userID := 0;
    nodo := pcanale^.listview.getfirst;
    while (nodo <> nil) do begin
      dataUser := pcanale^.listview.getdata(nodo);
      if dataUser^.id = userID then begin
        inc(userID);
        nodo := pcanale^.listview.getfirst;
      end else nodo := pcanale^.listview.getNext(nodo);
    end;

    nodo := pcanale^.listview.addchild(nil);
    dataUser := pcanale^.listview.getdata(nodo);
    with dataUser^ do begin
      id := userID;
      nick := utente_per_synch;
      crcnick := crc_per_synch;
      files := files_per_synch;
      speed := speed_per_synch;
      ip := ip_per_synch;
      ModLevel := ModLevelSync;
      ip_alt := ip_alt_per_synch;
      port := port_per_synch;
      ip_server := ip_server_per_synch;
      port_serveR := port_server_per_synch;
      ignored := false;
      support_files := support_files_per_synch;
    end;

    pcanale^.listview.header.columns[0].text := GetLangStringW(STR_USERS) + ' (' + inttostr(pcanale^.listview.rootnodecount) + ')';

  except
  end;
end;
///////////////////////////////////////////////////////////////////////////////////////////////


// user parted remove him/her from the list on the GUI

procedure tthread_client_chat.handler_part(socket_canale: precord_socket_canale);
begin
  try
    utente_per_synch := copy(content, 1, pos(CHRNULL, content) - 1);
    if ((length(utente_per_synch) < 2) or (length(utente_per_synch) > MAX_NICK_LEN)) then exit;

    crc_per_synch := stringcrc(utente_per_synch, true);
    pcanale_per_synch := socket_canale^.pcanale;
    testo_per_synch := utente_per_synch + ' ' + GetLangStringA(STR_HAS_PARTED);
    colore_per_synch := COLORE_PART;
    synchronize(handler_part);
  except
  end;
end;

procedure tthread_client_chat.handler_part; //synch
var
  nodo: pCmtVnode;
  nickcomp: string;
  data: ^record_displayed_chat_user;
  pcanale: precord_canale_chat_visual;
begin

  nickcomp := utente_per_synch;

  try
    pcanale := pcanale_per_synch;

    nodo := pcanale^.listview.GetFirst;
    while (nodo <> nil) do begin
      data := pcanale^.listview.getdata(nodo);

      if data^.crcnick = crc_per_synch then
        if data^.nick = nickcomp then begin

          if ares_frmmain.check_opt_chat_joinpart.checked then
            helper_chatroom_gui.out_text_memo(pcanale^.memo, colore_per_synch, '', utf8strtowidestr(testo_per_synch));

          pcanale^.listview.deletenode(nodo);

          pcanale^.listview.header.columns[0].text := GetLangStringW(STR_USERS) + ' (' + inttostr(pcanale^.listview.rootnodecount) + ')';
          exit;
        end;
      nodo := pcanale^.listview.getnext(nodo);
    end;

  except
  end;
end;
////////////////////////////////////////////////////////////////////////


procedure tthread_client_chat.handler_requested_dirchatpush; //sync
var
  nick, ips, randoms: string;
  ip: cardinal;
  port: word;
  alt_ip: cardinal;
begin
  if length(content) < 28 then exit;

  nick := copy(content, 1, pos(CHRNULL, content) - 1);
  if ((length(nick) < 2) or (length(nick) > MAX_NICK_LEN)) then exit;
  delete(content, 1, pos(CHRNULL, content));

  if length(content) < 26 then exit;

  move(content[1], ip, 4);
  move(content[5], port, 2);
  move(content[7], alt_ip, 4);

  randoms := copy(content, 11, 16);
  if length(randoms) <> 16 then exit;

  if ares_frmmain.Check_opt_chat_nopm.checked then exit;
  if vars_global.numero_pvt_open > 25 then exit;

  try



    ips := ipint_to_dotstring(ip);
    if ip_firewalled(ips) then exit;

    if reg_bannato(ips) then exit else begin
      inc(vars_global.numero_pvt_open);
      with tthread_chat_push_connector.create(true) do begin
        random_str := randoms;
        his_rem_ip := ip;
        his_rem_port := port;
        his_rem_ip_alt := alt_ip;
        resume;
      end;
    end;

  except
  end;

end;


// we got a private message should we open up a new tab?

procedure tthread_client_chat.handler_incoming_pvt(socket_canale: precord_socket_canale);
var
  utente: string;
begin
  utente := copy(content, 1, pos(CHRNULL, content) - 1);
  if ((length(utente) < 2) or (length(utente) > MAX_NICK_LEN)) then exit;

  delete(content, 1, pos(CHRNULL, content));

  pcanale_per_synch := socket_canale^.pcanale;
  utente_per_synch := utente;
  crc_per_synch := stringcrc(utente, true);

  testo_per_synch := widestrtoutf8str(strippa_fastidiosi2(utf8strtowidestr(content)));

  should_font_change := true;

  synchronize(handler_incoming_pvt);
end;

procedure tthread_client_chat.handler_incoming_pvt; //synch
var
  pcanale: precord_canale_chat_visual;
begin
  if vars_global.block_pm then exit; //2955+

  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;
    chatroom_pvt_event(pcanale, utente_per_synch, crc_per_synch, testo_per_synch);

  except
  end;
end;

// we tried to send a private message to an offline recipient

procedure tthread_client_chat.handler_offline_bypvt(socket_canale: precord_socket_canale);
var utente: string;
begin
  utente := copy(content, 1, pos(CHRNULL, content) - 1);
  if ((length(utente) < 2) or (length(utente) > MAX_NICK_LEN)) then exit;

  delete(content, 1, pos(CHRNULL, content));

  pcanale_per_synch := socket_canale^.pcanale;
  utente_per_synch := utente;
  crc_per_synch := stringcrc(utente, true);

  testo_per_synch := 'User offline';

  should_font_change := true;
  synchronize(incoming_pvt_error);
end;

procedure tthread_client_chat.handler_ignored_bypvt(socket_canale: precord_socket_canale);
var
  utente: string;
begin
  utente := copy(content, 1, pos(CHRNULL, content) - 1);
  if ((length(utente) < 2) or (length(utente) > MAX_NICK_LEN)) then exit;

  delete(content, 1, pos(CHRNULL, content));

  pcanale_per_synch := socket_canale^.pcanale;
  utente_per_synch := utente;
  crc_per_synch := stringcrc(utente, true);

  testo_per_synch := utente + ' is ignoring you';
  colore_per_synch := COLORE_ERROR;
  should_font_change := true;
  synchronize(incoming_pvt_error);
end;

procedure tthread_client_chat.incoming_pvt_error; //synch
var
  pcanale: precord_canale_chat_visual;
begin
  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

    chatroom_pvt_eventerror(pcanale, utente_per_synch, crc_per_synch, testo_per_synch);
  except
  end;
end;
//////////////////////////////////////////////////////////////////////////////////////////////




// just joined, server is sending its userlist, update the GUI(this is done while keeping the listview locked/preventing repaint)

procedure tthread_client_chat.handler_channel_user(socket_canale: precord_socket_canale);
begin
  try
    if length(content) < 20 then exit;

    files_per_synch := chars_2_word(copy(content, 1, 2));
    speed_per_synch := chars_2_dword(copy(content, 3, 4));

    ip_per_synch := chars_2_dword(copy(content, 7, 4));
    port_per_synch := chars_2_word(copy(content, 11, 2));
    ip_server_per_synch := chars_2_dword(copy(content, 13, 4));
    port_server_per_synch := chars_2_word(copy(content, 17, 2));
    ModLevelSync := false;

    support_files_per_synch := false;
    delete(content, 1, 19);
    utente_per_synch := copy(content, 1, pos(CHRNULL, content) - 1);

    delete(content, 1, pos(CHRNULL, content));
    if length(content) >= 4 then begin
      ip_alt_per_synch := chars_2_dword(copy(content, 1, 4));
      if length(content) > 4 then support_files_per_synch := (ord(content[5]) = 1);
      if length(content) > 5 then ModLevelSync := (ord(content[6]) <> 0);
    end else ip_alt_per_synch := 0;

//utente_per_synch:=utente_per_synch + ' '+ipint_to_dotstring(ip_per_synch)+' '+ipint_to_dotstring(ip_alt_per_synch);
//if ((length(utente_per_synch)<2) or (length(utente_per_synch)>MAX_NICK_LEN)) then exit;
    crc_per_synch := stringcrc(utente_per_synch, true);
    pcanale_per_synch := socket_canale^.pcanale;

    synchronize(handler_channel_user);
  except
  end;
end;

procedure tthread_client_chat.handler_channel_user; //synch
var
  pcanale: precord_canale_chat_visual;
  cannadd: boolean;
  nodo: pCmtVnode;
  data: precord_displayed_chat_user;
  nickcomp: string;
  clones: integer;
begin

  nickcomp := utente_per_synch;

  try
    pcanale := pcanale_per_synch;
    if pcanale^.should_exit then exit;

    cannadd := true;
    clones := 0;

    nodo := pcanale^.listview.GetFirst;
    while (nodo <> nil) do begin
      data := pcanale^.listview.getdata(nodo);
      if crc_per_synch = data^.crcnick then
        if data^.nick = nickcomp then begin
          cannadd := false;
          break;
        end;
      if ip_per_synch = data^.ip then inc(Clones);
      nodo := pcanale^.listview.getnext(nodo);
    end;

    if not cannadd then exit;
    if clones >= 5 then exit;

    with pcanale^.listview do begin
      nodo := addchild(nil);
      data := getdata(nodo);
    end;
    with data^ do begin
      id := 0;
      nick := utente_per_synch;
      crcnick := crc_per_synch;
      files := files_per_synch;
      speed := speed_per_synch;
      ip := ip_per_synch;
      ModLevel := ModLevelSync;
      ip_alt := ip_alt_per_synch;
      port := port_per_synch;
      ip_server := ip_server_per_synch;
      port_serveR := port_server_per_synch;
      ignored := false;
      support_files := support_files_per_synch;
    end;

  except
  end;
end;
/////////////////////////////////////////////////////////////////////////////////////////




// pub message...visual output of it

procedure tthread_client_chat.handler_public(socket_canale: precord_socket_canale);
begin
  try
    utente_per_synch := copy(content, 1, pos(CHRNULL, content) - 1);
    if ((length(utente_per_synch) < 2) or (length(utente_per_synch) > MAX_NICK_LEN)) then exit;

    delete(content, 1, pos(CHRNULL, content));

    pcanale_per_synch := socket_canale^.pcanale;
    testo_per_synch := widestrtoutf8str(strippa_fastidiosi2(utf8strtowidestr(content)));
    colore_per_synch := COLORE_PUBLIC;
    should_font_change := true;

    synchronize(out_memo);
  except
  end;
end;


// generic error/notice message...shown with different font color

procedure tthread_client_chat.handler_nosuch(socket_canale: precord_socket_canale);
begin
  try
    pcanale_per_synch := socket_canale^.pcanale;

    testo_per_synch := content;
    colore_per_synch := COLORE_ERROR;
    utente_per_synch := '';

    synchronize(out_memo);
  except
  end;
end;



// emote...different font color, visual layout

procedure tthread_client_chat.handler_emote(socket_canale: precord_socket_canale);
var
  nick: string;
begin
  try
    nick := copy(content, 1, pos(CHRNULL, content) - 1);
    if ((length(nick) < 2) or (length(nick) > MAX_NICK_LEN)) then exit;

    delete(content, 1, pos(CHRNULL, content));

    pcanale_per_synch := socket_canale^.pcanale;
    testo_per_synch := '* ' + nick + ' ' + widestrtoutf8str(strippa_fastidiosi(utf8strtowidestr(content), ' '));
    colore_per_synch := COLORE_EMOTE;
    should_font_change := true;

    synchronize(out_memo_simple);
  except
  end;
end;



// anything to send to server?

procedure tthread_client_chat.flush_socket(socket_canale: precord_socket_canale);
var
  er: integer;
  out_str: string;
  tryed: byte;
  lung: integer;
begin
  try

    with socket_canale^ do begin

      if last_out <> 0 then //check send timeout 60 secs
        if gettickcount - last_out > MINUTE then begin //send timeout....
          stato := STATO_SOCKET_CANALE_DISCONNECTED;
          FreeAndNil(socket);
          pcanale_per_synch := pcanale;
          testo_per_synch := GetLangStringA(STR_DISCONNECTED_SEND_TIMEOUT);
          colore_per_synch := COLORE_ERROR;
          synchronize(out_memo_simple);
          synchronize(notice_disconnect_pvts);
          exit;
        end;


      tryed := 0;
      while (out_commands.count > 0) do begin

        out_str := out_commands.strings[0];
        lung := TCPSocket_SendBuffer(socket.socket, @out_str[1], length(out_str), er);

        if er = WSAEWOULDBLOCK then begin
          if socket_canale^.last_out = 0 then last_out := gettickcount;
          if tryed >= 5 then exit;
          inc(tryed);
          continue;
        end;

        if er <> 0 then begin
          FreeAndNil(socket);
          stato := STATO_SOCKET_CANALE_DISCONNECTED;
          pcanale_per_synch := pcanale;
          testo_per_synch := GetLangStringA(STR_DISCONNECTED);
          colore_per_synch := COLORE_ERROR;
          synchronize(out_memo_simple);
          synchronize(notice_disconnect_pvts);
          exit;
        end;

        if lung < length(out_str) then begin
          delete(out_str, 1, lung);
          out_commands.strings[0] := out_str;
        end else out_commands.delete(0);

        last_out := 0;


      end; // while

      last_out := 0;

    end;

  except
  end;
end;


//synchronize variables from the GUI/globa ones

procedure tthread_client_chat.sync_vars; //synch
begin
  my_shared_count_loc := vars_global.my_shared_count;
  mypgui_loc := vars_global.mypgui;
  if length(mypgui_loc) <> 16 then setlength(mypgui_loc, 16);
  myport_loc := vars_global.myport;
  velocita_up_dec_loc := vars_global.velocita_up_dec;
  mynick_loc := vars_global.mynick;
  if ((length(mynick_loc) < 2) or (length(mynick_loc) > MAX_NICK_LEN)) then
    mynick_loc := STR_ANON + lowercase(inttohex(random($FF), 2) +
      inttohex(random($FF), 2) +
      inttohex(random($FF), 2) +
      inttohex(random($FF), 2));
  versioneares_loc := vars_global.versioneares;
  my_localip_snode := vars_global.localipC;
  my_queued_count := vars_global.numero_queued;
  my_upcount := vars_global.numero_upload;
  my_uplimit := vars_global.limite_upload;
  loc_allow_pvt_browse := ares_frmmain.check_opt_chat_browsable.checked;
end;


//this is shown in search results
//future versions will handle the show_only_notqueued users in searches

function tthread_client_chat.my_online_queue_status_str: string;
begin
  result := chr(my_upcount) +
    chr(my_uplimit) +
    chr(my_queued_count);
end;


//output the login packet string

function tthread_client_chat.out_login_req(socket: hsocket): integer;
var
  str: string;
  carattere_share_browse_allow: string;
begin
  try

    if loc_allow_pvt_browse then carattere_share_browse_allow := chr(3) // should be 7 but we need to maintain backward compat.
    else carattere_share_browse_allow := chr(1); //floppy icon, we allow browse of our filelist

    str := mypgui_loc + //16 bytes user's GUID
      int_2_word_string(my_shared_count_loc) + // 2 shared count
      CHRNULL +
      int_2_word_string(myport_loc) + // tcp port
      mysupernodes.GetServerStrBinary + // 6 bytes dword ip word port
      int_2_dword_string(velocita_up_dec_loc) + // 4 bytes speed
      mynick_loc + CHRNULL + // nickname
      appname + ' ' + versioneares_loc + CHRNULL + // app name + ' ' + null
      int_2_dword_string(LanIPC) +
      int_2_dword_string(my_localip_snode) +
      carattere_share_browse_allow +
      my_online_queue_status_str;

    str := int_2_word_string(length(str)) +
      chr(MSG_CHAT_CLIENT_LOGIN) +
      str;

    TCPSocket_SendBuffer(socket, @str[1], length(str), result);
  except
  end;
end;




// should we part or join a new channel? have we got new commands to issue?  (thread_safe)

procedure tthread_client_chat.IO_MainVCL; // synch
begin
  last_2_dec := gettickcount;

  try
    get_out_text_canali;
  except
  end;

  try
    init_channels;
  except
  end;

  try
    free_channels;
  except
  end;
  if socket_list.count = 0 then terminate; //<<------------ end of thread

end;


//get user's commands

procedure tthread_client_chat.get_out_text_canali;
var
  i, h: integer;
  pcanale: precord_canale_chat_visual;
  socket_canale: ^record_socket_canale;
begin
  try
    if vars_global.list_chatchan_visual = nil then exit;

    for i := 0 to vars_global.list_chatchan_visual.count - 1 do begin
      pcanale := vars_global.list_chatchan_visual[i];
      if pcanale^.out_text.count = 0 then continue;
      for h := 0 to socket_list.count - 1 do begin
        socket_canale := socket_list[h];
        if socket_canale^.pcanale = pcanale then begin
          while (pcanale^.out_text.count > 0) do begin
            socket_canale^.in_commands_gui.add(pcanale^.out_text[0]);
            pcanale^.out_text.delete(0);
          end;
          break;
        end;
      end;

    end;

  except
  end;
end;


// free closed channels (thread_safe)

procedure free_channels;
var
  i, h: integer;
  pcanale: precord_canale_chat_visual;
  socket_canale: precord_socket_canale;
  pvt_chat: precord_pvt_chat_visual;
begin
  try

    if vars_global.list_chatchan_visual = nil then exit;

    for i := 0 to vars_global.list_chatchan_visual.count - 1 do begin
      pcanale := vars_global.list_chatchan_visual[i];

      if not pcanale^.should_exit then continue;

      for h := 0 to socket_list.count - 1 do begin
        socket_canale := socket_list[h];
        if socket_canale^.pcanale = pcanale then begin
          socket_list.delete(h);
          with socket_canale^ do begin
            FreeAndNil(socket);
            name := '';
            topic := '';
            version := '';
            in_buffer := '';
            out_commands.free;
            in_commands_gui.free;
          end;
          FreeMem(socket_canale, sizeof(record_socket_canale));
          break;
        end;
      end;


      try
        if pcanale^.lista_pvt <> nil then begin
          while (pcanale^.lista_pvt.count > 0) do begin
            pvt_chat := pcanale^.lista_pvt[pcanale^.lista_pvt.count - 1];
            pcanale^.lista_pvt.delete(pcanale^.lista_pvt.count - 1);
            pvt_chat^.nickname := '';
            if pvt_chat^.frmTab <> nil then pvt_chat^.frmTab.release;
            FreeMem(pvt_chat, sizeof(record_pvt_chat_visual));
          end;
          pcanale^.lista_pvt.free;
        end;
      except
      end;

 { try
   if pcanale^.lista_pannelli_result<>nil then begin
     while (pcanale^.lista_pannelli_result.count>0) do begin
      pannello_result:=pcanale^.lista_pannelli_result[pcanale^.lista_pannelli_result.count-1];
       pcanale^.lista_pannelli_result.delete(pcanale^.lista_pannelli_result.count-1);
      pannello_result^.randomstr:='';
       FreeMem(pannello_result,sizeof(record_pannello_result_chat));
     end;
    pcanale^.lista_pannelli_result.free;
   end;
   except
   end;  }


  { try
   if pcanale^.lista_pannelli_browse<>nil then begin
     while (pcanale^.lista_pannelli_browse.count>0) do begin
       pannello_browse:=pcanale^.lista_pannelli_browse[pcanale^.lista_pannelli_browse.count-1];
         pcanale^.lista_pannelli_browse.delete(pcanale^.lista_pannelli_browse.count-1);
         pannello_browse^.randomstr:='';
         pannello_browse^.nick:='';
          while (pannello_browse^.lista_files.count>0) do begin  // clear files
            pfile:=pannello_browse^.lista_files[pannello_browse^.lista_files.count-1];
           pannello_browse^.lista_files.delete(pannello_browse^.lista_files.count-1);
            finalize_file_library_item(pfile);
           FreeMem(pfile,sizeof(record_file_library));
          end;
         pannello_browse^.lista_files.free;
         FreeMem(pannello_browse,sizeof(record_pannello_browse_chat));
     end;
     pcanale^.lista_pannelli_browse.free;
   end;
   except
   end;   }

   //index:=ares_frmmain.panel_chat.GetPagePanelIndex(pcanale^.containerPanel);
   //if index<>-1 then ares_frmmain.panel_chat.DeletePanel(index);


      with pcanale^ do begin
        name := '';
        topic := '';
        out_text.free;
        if frmTab <> nil then frmTab.release;
      end;

      pcanale^.containerPageview.free;

      vars_global.list_chatchan_visual.delete(i);
      FreeMem(pcanale, sizeof(record_canale_chat_visual));

      break;

    end;

  except
  end;


end;


//new channels to join?

procedure init_channels; //synch
var
  i: integer;
  pcan: precord_canale_chat_visual;
  socket_canale: precord_socket_canale;
begin
  try
    if vars_global.list_chatchan_visual = nil then exit;
    for i := 0 to vars_global.list_chatchan_visual.count - 1 do begin
      pcan := vars_global.list_chatchan_visual[i];

      if pcan^.just_created then begin
        pcan^.just_created := false;

        socket_canale := AllocMem(sizeof(record_socket_canale));
        with socket_canale^ do begin
          pcanale := pcan;
          name := pcan^.name;
          topic := pcan^.topic;
          version := '';
          ip := pcan^.ip;
          port := pcan^.port;
          ip_alt := pcan^.alt_ip;
          sent_filelist := false;
          support_files := false;
          support_pvt := false;
          shareable_types := 0;
          disconnect_time := 0;
          retry_connect := 0;
          first_try_connect := true;
          in_commands_gui := tmystringlist.create;
          out_commands := tmystringlist.create;
        end;


        socket_canale^.has_tried_internal_ip := (socket_canale^.ip_alt = 0);


        connect_channel(socket_canale);
        socket_list.add(socket_canale);


      end;
    end;
  except
  end;
end;


//start outbound connection

procedure connect_channel(socket_canale: precord_socket_canale);
begin

  with socket_canale^ do begin
    in_buffer := '';
    stato := STATO_SOCKET_CANALE_CONNECTING;
    last_out := 0;
    tag := gettickcount;
    socket := TTCPBlockSocket.Create(true);

    if first_try_connect then begin // first use external IP
      socket.ip := ipint_to_dotstring(ip);
      assign_proxy_settings(socket);
    end else
      if ((ip_alt <> 0) and
        (not has_tried_internal_ip)) then begin // next try internal IP
        has_tried_internal_ip := true;
        socket.ip := ipint_to_dotstring(ip_alt);
        socket.SocksIP := '';
        socket.SocksPort := '0';
      end else begin // can use only external IP
        socket.ip := ipint_to_dotstring(ip);
        assign_proxy_settings(socket);
      end;

    socket.port := port;
    socket.Connect(socket.ip, inttostr(port));
  end;
end;


//terminate the thread and update GUI

procedure tthread_client_chat.shutdown;
begin
  try
    synchronize(free_sockets);
    free_result_search;
    socket_list.free;
  except
  end;
  postmessage(ares_FrmMain.handle, WM_THREADCHATCLIENT_END, 0, 0);
end;

//hard termination of our lists...program quit

procedure tthread_client_chat.free_sockets; //synch
var
  socket_canale: precord_socket_canale;
begin
  try

    while (socket_list.count > 0) do begin
      socket_canale := socket_list[socket_list.count - 1];
      socket_list.delete(socket_list.count - 1);

      if socket_canale <> nil then FreeAndNil(socket_canale^.socket);
      with socket_canale^ do begin
        name := '';
        topic := '';
        in_commands_gui.free;
        out_commands.free;
        in_buffer := '';
        version := '';
      end;

      FreeMem(socket_canale, sizeof(record_socket_canale));
    end;

  except
  end;
end;








end.

