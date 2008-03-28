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
p2p client thread
}

unit thread_client;

interface

uses
  Classes, windows, blcksock, synsock, const_commands,
  sysutils, ares_types, ares_objects, const_ares,
  registry, forms, comctrls, const_cache_commands, const_supernode_commands,
  classes2, comettrees, graphics, zlib, class_cmdlist,
  const_win_messages, const_timeouts, const_client, helper_ares_cacheservers;

type
  tthread_client = class(TThread)
  private
    last_sec, tempo, last_status_click, last_third_ofsec, last_send_me_channel,
    last_update_download_hashes, last_refresh_chat, last_check_election, // per sapere da quanto sono attivo in elezione snode:cardinal;
    last_10_sec, last_30_sec, logontime, last_out_filelist, last_supernodes_dump, last_check_random_cache,
  //us,fi,gi,
    my_speed,
    his_local_ip: cardinal;
    should_avoid_exe: boolean;
    stringa_nickname: widestring;
    our_build, my_localip, //host_per_synchronize,
    user_nick, ip_per_synch, mynick, content: string;

    pheader_recuser: precord_user_resultcl;
    result_search: precord_search_result;
    nap_cmd_generale: ^tnapcmd;
 // risorsa_globale:trisorsa_download;

    should_connect,
    ares_disconnected,
    is_updating_treeview: boolean;
    m_is_firewalled: integer;
    m_firewall_tests: integer;

    numero_upload, limite_upload, my_queue_length: byte;
    should_refresh_lbl: boolean;
    mypgui: string[16];
    myport, port_per_synch: word;

    download_hashes, ares_aval_nodes, ares_connected_nodes, lista_test_firewall, ares_busy_nodes: tmylist;

    filtered_keywords: tmystringlist;

    buffer_ricezione: array[0..4095] of char;

    GlobNode: Tares_node;
  protected
    procedure ares_sendback(nodo_Ares: tares_node; cmd: byte; cont: string);
    procedure ares_sendback_node(nodo_Ares: tares_node; cmd: byte; cont: string);
    procedure ares_connect;
    procedure ares_connect_cache;
    procedure ares_doIdle_in_connecting;
    procedure ares_disconnect; //synch
    procedure ares_check_timeout_server_stats;
    procedure ares_receive; overload;
    procedure ares_receive(node: tares_node); overload;

    procedure ares_flush_socket;
    function ares_getout_login_str(node: tares_node; na: string): string;
    function ares_connected_level: integer;
    procedure Synch_node_Send_Filelist; //synch
    procedure update_fresh_download_files;
    procedure SyncNotFirewalled;

    procedure ares_process_command(nodo_ares: tares_node; cmd: byte; cnt: string);
    procedure ares_keep_alive_proxy;
    function find_download_hash(crcsha1: word; hash_sha1: string): precord_download_hash;
    procedure clear_download_hash;
    procedure sync_hashrequests(nodo_ares: tares_node);
    procedure end_update_treeviews; //synch
    procedure update_caption_search;
    procedure patchSp2;
    procedure checkDHT_bootstrap; //sync

    procedure check_third_ofsec;
    procedure check_second;
    procedure check_10_seconds;
    procedure check_30_seconds;
    procedure check_minute;

    procedure Execute; override;
    procedure refresh_labels;
    procedure init_vars;
    procedure reset_result;
    procedure GUI_add_result;
    procedure send_me_channels;
    procedure shutdown;
    procedure check_elections;
    procedure get_nick_fromreg;
    procedure sync_vars;
    function ares_cache_parse_supernodes(strin: string): string;

    procedure handler_login_ok(nodo_ares: tares_node); overload;
    procedure handler_login_ok; overload; //put server ip
    procedure handler_hit(nodo_ares: tares_node); overload;
    procedure handler_hit; overload;
    procedure handler_hit(nodo_ares: tares_node; dummy: boolean); overload;
    procedure handler_push_req_ares2;
    procedure handler_my_ip(nodo_ares: tares_node);
    procedure handler_stats(nodo_ares: tares_node); overload;
    procedure handler_stats; overload;
    procedure handler_push_chat_req;
    procedure handler_patch_caches;
    procedure handler_patch_caches_old;
    procedure handler_patch_caches_new; //synch la 2952+
    procedure handler_test_user_firewall;
    procedure handler_endofsearch; //synch
    procedure handler_test_firewall_result(nodo_ares: Tares_node);

    procedure deal_test_firewall;
    procedure ares_send_file_list(nodo_ares: tares_node);

    procedure send_server_update_my_nick;
    procedure ares_update_status_on_server;
    procedure update_download_hashes;

    procedure sync_GUI;
    procedure log_not_connected;
    procedure log_connecting_to_node;
   // procedure log_connecting_to_network;
  end;


var
  STR_NEW_PRELOGIN: string = chr(3) + CHRNULL +
  chr(MSG_CLIENT_FIRST_LOG) +
    chr(CHAR_MARKER_NOCRYPT) + chr(CHAR_MARKER_NOCRYPT) + chr(CHAR_MARKER_NEWSTACK);

implementation

uses
  ufrmmain, ufrmpvt, helper_channellist, keywfunc, winsock, helper_unicode, vars_localiz, helper_strings,
  helper_crypt, helper_sockets, helper_ipfunc, helper_datetime, helper_registry,
  helper_mimetypes, helper_filtering, helper_combos, secureHash, mysupernodes,
  vars_global, node_upgrade, utility_ares, thread_download, thread_supernode, thread_cacheserver,
  helper_private_chat, helper_search_gui, helper_visual_headers, helper_share_misc, helper_base64_32,
  helper_ares_nodes, helper_sorting, helper_stringfinal, thread_dht, dhtutils, helper_download_misc;



procedure tthread_client.reset_result;
begin
  with result_search^ do begin
    nickname := '';
    title := '';
    artist := '';
    album := '';
    filenameS := ''; //2941-2 +
    category := '';
    comments := '';
    language := '';
    url := '';
    year := '';
    hash_sha1 := '';
    hash_of_phash := '';
    crcsha1 := 0;
    keyword_genre := '';
    param1 := 0;
    param2 := 0;
    param3 := 0;
  end;
end;



procedure tthread_client.shutdown;
var
  nodo_ares: tares_node;
  socket: ttcpblocksocket;
  i: integer;
begin

  try


    try
      i := 0;
      while (i < ares_connected_nodes.count) do begin
        nodo_ares := ares_connected_nodes[i];
        aresnodes_putConnected(nodo_ares, ares_aval_nodes);
        inc(i);
      end;
      ares_connected_nodes.free;
    except
    end;

    try
      ares_busy_nodes.free;
    except
    end;


    if ares_aval_nodes.count > 0 then aresnodes_savetodisk(ares_aval_nodes);


    try
      while (ares_aval_nodes.count > 0) do begin
        nodo_ares := ares_aval_nodes[ares_aval_nodes.count - 1];
        ares_aval_nodes.delete(ares_aval_nodes.count - 1);
        nodo_ares.free;
      end;
      ares_aval_nodes.free;
    except
    end;


    try
      while (lista_test_firewall.count > 0) do begin
        socket := lista_test_firewall[lista_test_firewall.count - 1];
        lista_test_firewall.delete(lista_test_firewall.count - 1);
        socket.free;
      end;
      lista_test_firewall.free;
    except
    end;


    clear_download_hash;
    download_hashes.free;

    filtered_keywords.Free;

    reset_result;
    FreeMem(result_search, sizeof(record_search_Result));

    FreeMem(nap_cmd_generale, sizeof(tnapcmd));

    FreeMem(pheader_recuser, sizeof(record_user_resultcl));

    user_nick := '';
    ip_per_synch := '';
    mynick := '';
    content := '';
  except
  end;
end;

procedure tthread_client.ares_check_timeout_server_stats; // servers must send stats regularly
var
  nodo_ares: tares_node;
  i: integer;
begin

  for i := 0 to ares_connected_nodes.count - 1 do begin
    nodo_ares := ares_connected_nodes[i];
    if nodo_ares.state <> sessestablished then continue;
    if gettickcount - nodo_ares.last > 120000 then begin //two minutes without stats?
      nodo_ares.state := sessDisconnected;
    end;
  end;

end;

procedure tthread_client.ares_keep_alive_proxy; // keep alive proxy sock servers
var
  i: integer;
  nodo_ares: tares_node;
begin

  for i := 0 to ares_connected_nodes.count - 1 do begin
    nodo_ares := ares_connected_nodes[i];

    if nodo_ares.state <> sessestablished then continue;
    if nodo_ares.socket.SocksIP <> '' then ares_sendback(nodo_ares, MSG_CLIENT_DUMMY, chr(numero_upload) + chr(limite_upload));

  end;

end;



procedure tthread_client.init_vars;
begin
  stringa_nickname := '';
  my_localip := ''; //assegnato da supernodo...

  sleep(SECOND);

  should_refresh_lbl := false;
  sleep(10);

  download_hashes := tmylist.create;
  ares_aval_nodes := tmylist.create;
  ares_connected_nodes := tmylist.create;
  ares_busy_nodes := tmylist.create;
  lista_test_firewall := tmylist.create;

  filtered_keywords := tmystringlist.create;
  init_keywfilter('P2PFilter', filtered_keywords);

  nap_cmd_generale := AllocMem(sizeof(tnapcmd));
  pheader_recuser := AllocMem(sizeof(record_user_resultcl));


  ares_disconnected := false;
  is_updating_treeview := false;
  m_is_firewalled := 5;
  m_firewall_tests := 0;


  result_search := AllocMem(sizeof(record_search_Result));

  last_update_download_hashes := 0;


  last_out_filelist := 0;

  my_queue_length := 0;

  tempo := gettickcount;
  last_check_election := tempo; // primo controllo dopo dieci minuti, nel caso non perdiamo tempo?
  last_sec := tempo;
  last_status_click := tempo;
  last_third_ofsec := tempo;
  last_10_sec := tempo;
  last_30_sec := tempo;
  last_send_me_channel := 0;
  last_refresh_chat := tempo;
  last_supernodes_dump := tempo;
  last_check_random_cache := 0;


end;

procedure tthread_client.end_update_treeviews; //synch
var
  i: integer;
  src: precord_panel_search;
begin
  for i := 0 to src_panel_list.count - 1 do begin
    src := src_panel_list[i];
    if not src^.is_updating then continue;
    src^.is_updating := false;
    if src^.listview.Header.sortcolumn >= 0 then src^.listview.Sort(nil, src^.listview.header.sortcolumn, src^.listview.header.sortdirection);
    src^.listview.EndUpdate;
  end;

end;

procedure tthread_client.update_caption_search;
var
  i: integer;
  src: precord_panel_search;
begin

  for i := 0 to src_panel_list.count - 1 do begin
    src := src_panel_list[i];

    if src^.started = 0 then continue;

    if src^.numresults > 0 then begin

      if src^.numresults = 1 then src^.lbl_src_status_caption := format_time((tempo - src^.started) div 1000) + '   1 (' + inttostr(src^.numhits) + ') ' + GetLangStringW(STR_RESULT_FOR) + ' ' + utf8strtowidestr(src^.search_string)
      else src^.lbl_src_status_caption := format_time((tempo - src^.started) div 1000) + '   ' + inttostr(src^.numresults) + ' (' + inttostr(src^.numhits) + ') ' + GetLangStringW(STR_RESULTS_FOR) + ' ' + utf8strtowidestr(src^.search_string);

      src^.pnl.btncaption := utf8strtowidestr(src^.search_string) + ' (' + inttostr(src^.numresults) + ')';

    end else src^.lbl_src_status_caption := format_time((tempo - src^.started) div 1000) + '   ' + GetLangStringW(STR_SEARCHING_FOR) + ' ' + utf8strtowidestr(src^.search_string) + ', ' + GetLangStringW(STR_PLEASE_WAIT);


    if src^.containerPanel.visible then ares_frmmain.lbl_src_status.caption := src^.lbl_src_status_caption;


  end;

end;

procedure tthread_client.patchSp2;
type
  pNeedsPatching = function: boolean;
  PPatchIt = function: boolean;
  PGetLimit = function: integer;
var
  NeedsPatch: pNeedsPatching;
  PatchIt: PPatchIt;
  GetCurrentLimit: PGetLimit;
  hndl: hwnd;
begin
  hndl := SafeLoadLibrary('TcpIpPatcherDll.dll');
  if hndl = 0 then exit;

  try

    NeedsPatch := GetProcAddress(hndl, 'NeedsPatching');
    if @NeedsPatch = nil then begin
      FreeLibrary(hndl);
      exit;
    end;

    PatchIt := GetProcAddress(hndl, 'PatchIt');
    if @PatchIt = nil then begin
      FreeLibrary(hndl);
      exit;
    end;

    GetCurrentLimit := GetProcAddress(hndl, 'GetCurrentLimit');
    if @GetCurrentLimit = nil then begin
      FreeLibrary(hndl);
      exit;
    end;

    if NeedsPatch then
      if GetCurrentLimit < 150 then PatchIt;

  except
  end;

  FreeLibrary(hndl);
end;



procedure tthread_client.check_second;
begin
  last_sec := tempo;

  synchronize(update_caption_search);

  ares_update_status_on_server;

  deal_test_firewall;
  sleep(2);
end;

procedure tthread_client.check_10_seconds;
begin
  last_10_sec := tempo;
  synchronize(send_server_update_my_nick);

  sleep(2);
  if tempo - last_30_sec > 30207 then check_30_seconds;
end;

procedure tthread_client.check_30_seconds;
begin
  last_30_sec := tempo;
  ares_keep_alive_proxy;

  if tempo - last_status_click > 60411 then check_minute;
end;

procedure tthread_client.check_minute;
begin
  last_status_click := tempo;


  ares_check_timeout_server_stats;

  if last_status_click - last_check_election >= 10 * MINUTE then
    if ares_connected_nodes.count > 0 then synchronize(check_elections);

  if ((tempo - last_check_random_cache >= 90 * MINUTE) or
    (last_check_random_cache = 0)) then begin
    if ares_connected_nodes.count > 0 then begin
      last_check_random_cache := tempo;
      helper_ares_cacheservers.Cache_checkRandom;
    end;
  end;

  if tempo - last_supernodes_dump >= 45 * MINUTE then begin // save dbs to disk in case of crash
    aresnodes_savetodisk(ares_aval_nodes);
    cacheservers_savetodisk;
    last_supernodes_dump := tempo;
  end;

end;

procedure tthread_client.check_third_ofsec;
begin
  last_third_ofsec := tempo;

  try
    synchronize(sync_GUI);

    sleep(2);

    if is_updating_treeview then begin
      is_updating_treeview := false;
      synchronize(end_update_treeviews);
    end;

    if should_connect then begin
      if ares_connected_nodes.count < ares_connected_level then ares_connect;
    end else ares_disconnect;

  except
  end;
end;

procedure tthread_client.Execute;
begin
  priority := tpnormal;
  freeonterminate := false;

  cacheservers_loadfromdisk;
  sleep(1000); // we need know our accept port



  init_vars;
  patchsp2;

  // cache µÈ ¼­¹ö ¸®½ºÆ®¸¦ ÀÐ¾î ¿Â´Ù. 
  aresnodes_loadfromdisk(ares_aval_nodes); //load from reg

  synchronize(sync_vars);

  while (not terminated) do begin

    try

      tempo := gettickcount;

      if tempo - last_third_ofsec > 333 then check_third_ofsec;
      if tempo - last_sec > 1000 then check_second;
      if tempo - last_10_sec > 10105 then check_10_seconds;


      ares_flush_socket;
      ares_receive;

      sleep(10);

    except
    end;

  end;

  shutdown;
end;



procedure tthread_client.check_elections;
begin
  last_check_election := gettickcount;

  if my_localip <> '' then begin
     //if node_upgrade.can_become_cache then exit; DEBUG

    node_upgrade.can_become_supernode;
  end;

end;

function tthread_client.find_download_hash(crcsha1: word; hash_sha1: string): precord_download_hash;
var
  i: integer;
  rec: precord_download_hash;
begin
  result := nil;

  if length(hash_sha1) = 20 then begin //collisione sha1?
    for i := 0 to download_hashes.count - 1 do begin
      rec := download_hashes[i];

      if rec.crchash <> crcsha1 then continue;
      if rec.hash <> hash_sha1 then continue;
      result := rec;
      exit;
    end;
  end;

end;

procedure tthread_client.clear_download_hash;
var
  i: integer;
  dl_hash: precord_download_hash;
begin
  i := 0;
  while (i < download_hashes.count) do begin
    dl_hash := download_hashes[i];

    download_hashes.delete(i);
    dl_hash.hash := '';
    FreeMem(dl_hash, sizeof(record_download_hash));
  end;

end;

procedure tthread_client.sync_hashrequests(nodo_ares: tares_node); //appena connesso
var
  i: integer;
  dl_hash: precord_download_hash;
begin
  for i := 0 to download_hashes.count - 1 do begin
    dl_hash := download_hashes[i];
    ares_sendback_node(nodo_ares, MSG_CLIENT_ADD_HASHREQUEST, dl_hash^.hash + CHRNULL); //sha1=0
  end;
end;

procedure tthread_client.update_download_hashes; //synch
// ogni 60 secondi controllo che non ci siano nuovi download per ricerca alternates
// rimozione search download completati...unico caso carente transfer interrotto...
var
  i: integer;
  node: pCmtVnode;
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
  found: boolean;
  dl_hash, dl_hash2: precord_download_hash;
begin
  if ares_connected_nodes.count < ares_connected_level then exit;

  if gettickcount - last_update_download_hashes < 10 * SECOND then exit; //evitiamo flood
  last_update_download_hashes := gettickcount;

  try


    i := 0; //primo rimuoviamo da download hash, download che non esistono
    while (i < download_hashes.count) do begin

      found := false;
      dl_hash := download_hashes[i];

      node := ares_FrmMain.treeview_download.GetFirst;
      while (node <> nil) do begin
        dataNode := ares_FrmMain.treeview_download.getdata(node);
        if dataNode^.m_type <> dnt_download then begin
          node := ares_FrmMain.treeview_download.getnextsibling(node);
          continue;
        end;

        DnData := dataNode^.data;
        if DnData^.handle_obj <> INVALID_HANDLE_VALUE then
          if DnData^.crcsha1 = dl_hash^.crchash then
            if DnData^.hash_sha1 = dl_hash^.hash then begin
              found := true;
              break;
            end;
        node := ares_FrmMain.treeview_download.getnextsibling(node);
      end;

      if not found then begin
        ares_sendback(nil, MSG_CLIENT_REM_HASHREQUEST, dl_hash^.hash + CHRNULL); //md4=1
        download_hashes.delete(i);
        dl_hash^.hash := '';
        FreeMem(dl_hash, sizeof(record_download_hash));
      end else inc(i);
    end;


    node := ares_FrmMain.treeview_download.GetFirst;
    while (node <> nil) do begin
      dataNode := ares_FrmMain.treeview_download.getdata(node);
      if dataNode^.m_type <> dnt_download then begin
        node := ares_FrmMain.treeview_download.getnextsibling(node);
        continue;
      end;

      DnData := dataNode^.data;
      if DnData^.handle_obj = INVALID_HANDLE_VALUE then begin
        node := ares_FrmMain.treeview_download.getnextsibling(node);
        continue;
      end;

      if not helper_download_misc.isDownloadActive(DnData) then begin //should be removed

        dl_hash := find_download_hash(DnData^.crcsha1, DnData^.hash_sha1);
        if dl_hash <> nil then begin
          ares_sendback(nil, MSG_CLIENT_REM_HASHREQUEST, dl_hash^.hash + CHRNULL); //md4=1
          for i := 0 to download_hashes.count - 1 do begin
            dl_hash2 := download_hashes[i];
            if dl_hash2 = dl_hash then begin
              download_hashes.delete(i);
              break;
            end;
          end;
          dl_hash.hash := '';
          FreeMem(dl_hash, sizeof(record_download_hash));
        end;

      end else begin //should be added
        if download_hashes.count >= 15 {MAXNUM_ACTIVE_DOWNLOADS} then begin
          node := ares_FrmMain.treeview_download.getnextsibling(node);
          continue;
        end;
        dl_hash := find_download_hash(DnData^.crcsha1, DnData^.hash_sha1);
        if dl_hash = nil then begin
          if length(DnData^.hash_sha1) = 20 then begin
            dl_Hash := AllocMem(sizeof(record_download_hash));
            dl_hash^.crchash := DnData^.crcsha1;
            dl_hash^.hash := DnData^.hash_sha1;
            dl_hash^.handle_download := DnData^.handle_obj;
            download_hashes.add(dl_hash);
            if DnData^.num_sources < MAX_NUM_SOURCES then ares_sendback(nil, MSG_CLIENT_ADD_HASHREQUEST, dl_hash^.hash + CHRNULL); //sha1=0
          end;
        end;
      end;

      node := ares_FrmMain.treeview_download.getnextsibling(node);
    end;

    vars_global.changed_download_hashes := false;
  except
  end;
end;



procedure tthread_client.ares_update_status_on_server; // ping supernode
var
  i: integer;
  nodo_ares: tares_node;
begin

  synchronize(sync_vars); //prendi vars da ufrmmain.....

  for i := 0 to ares_connected_nodes.count - 1 do begin
    nodo_ares := ares_connected_nodes[i];
    if nodo_ares.state = sessestablished then
      if gettickcount - nodo_ares.logtime > 20000 then
        if gettickcount - nodo_ares.last_out_stats >= MINUTE then begin
          nodo_ares.last_out_stats := gettickcount;
          ares_sendback(nodo_ares, MSG_CLIENT_STAT_REQ, chr(numero_upload) +
            chr(limite_upload) +
            chr(0) +
            chr(my_queue_length) +
            int_2_word_string(my_speed) +
            chr(0));
        end;
  end;

end;

procedure tthread_client.ares_sendback_node(nodo_ares: tares_node; cmd: byte; cont: string);
var
  str, s1: string;
begin

  if nodo_ares.state <> sessestablished then exit;

  s1 := '';
  str := '';

  if length(cont) > 0 then begin
    if nodo_ares.noCrypt then s1 := cont
    else s1 := e1(nodo_ares.fc, nodo_ares.sc, cont);
  end;

  str := int_2_word_string(length(s1)) +
    chr(cmd) +
    s1;


  if ((cmd = MSG_CLIENT_ADD_SEARCH_NEW) or
    (cmd = MSG_CLIENT_UPDATING_NICK)) then begin
    if nodo_ares.out_buf.count > 0 then nodo_ares.out_buf.Insert(0, str)
    else nodo_ares.out_buf.add(str);
  end else nodo_ares.out_buf.add(str);

end;

procedure tthread_client.ares_sendback(nodo_ares: tares_node; cmd: byte; cont: string);
var
  i: integer;
  nodo_ares_nuovo: tares_node;
begin

  if nodo_ares <> nil then ares_sendback_node(nodo_ares, cmd, cont) else begin //broadcast?

    for i := 0 to ares_connected_nodes.count - 1 do begin
      nodo_ares_nuovo := ares_connected_nodes[i];

      if nodo_ares_nuovo.state <> sessestablished then continue;
  //if nodo_Ares_nuovo.klass<>nodeklasssuper then continue;

      ares_sendback_node(nodo_ares_nuovo, cmd, cont);
    end;

  end;

end;


function tthread_client.ares_cache_parse_supernodes(strin: string): string; //cache server sends some supernodes to us (other caches and supernodes)
var
  tipo: byte;
  host: string;
//num_added:integer;
begin
 //num_added:=0;
 //delete(strin,1,pos(CHRNULL,strin));      //skip default hostsite if any
  if length(strin) > 1 then begin
    if strin[1] = CHRNULL then delete(strin, 1, 1) else
      if ord(strin[1]) > 11 then delete(strin, 1, pos(CHRNULL, strin));
  end;

  while (length(strin) > 6) do begin
    tipo := ord(strin[1]);
    host := copy(strin, 2, 6);
    delete(strin, 1, 7);

    case tipo of
      11: begin
          helper_ares_cacheservers.Cache_AddReported(chars_2_dword(copy(host, 1, 4)));
          result := chr(111) + chr(107) {'ok'};
        end;
      1: begin
          aresnodes_addreported(ipint_to_dotstring(chars_2_dword(copy(host, 1, 4))), chars_2_word(copy(host, 5, 2)), ares_aval_nodes);
       // inc(num_added);
          result := chr(111) + chr(107) {'ok'};
        end;
      3: begin
          aresnodes_addreported(ipint_to_dotstring(chars_2_dword(copy(host, 1, 4))), chars_2_word(copy(host, 5, 2)), ares_aval_nodes);
       //inc(num_added);
          result := chr(111) + chr(107) {'ok'};
          delete(strin, 1, 1); //skip last branched byte
        end;
    end;

  end;
end;

procedure tthread_client.ares_connect_cache; //
var
  str: string;
  portw: word;
  socket, socket2: TTCPBlockSocket;
  er, i: integer;
  tempo, ipi: cardinal;
  previous_len, wantedlen, len {,ip_cache}: integer;
  ricevuto: string;
  list: tmylist;
  ip_cache: integer; //!!!
  nocrypt: boolean;
begin
  socket := nil;
  try

    str := cache_get_3hosts; //get 3 caches from registry
    if str = '' then exit;

    list := tmylist.create;

    while length(str) >= 4 do begin
      ipi := chars_2_dword(copy(str, 1, 4));
      delete(str, 1, 4);

      portw := get_ppca(ipi);

      socket := TTCPBlockSocket.create(true);
      with socket do begin
        ip := ipint_to_dotstring(ipi);
        port := portw;
      end;
      assign_proxy_settings(socket);
      socket.Connect(socket.ip, inttostr(portw));
      list.add(socket);
    end;


    if list.count = 0 then begin
      list.free;
      exit;
    end;


    tempo := gettickcount;
    er := WSAEWOULDBLOCK;

    while true do begin
      if gettickcount - tempo > 15000 then begin
        while list.count > 0 do begin
          socket2 := list[list.count - 1];
          list.delete(list.count - 1);
          helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket2.ip)));
          socket2.free;
        end;
        list.free;
        exit;
      end;

      for i := 0 to list.count - 1 do begin
        socket := list[i];
        er := TCPSocket_ISConnected(socket);
        if er = 0 then break; //one is now connected!
      end;

      if er = 0 then break else sleep(10);
    end;


    while list.count > 0 do begin
      socket2 := list[list.count - 1];
      list.delete(list.count - 1);
      if socket2 <> socket then begin
        helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket2.ip)));
        socket2.free; //clear all but the working one
      end;
    end;
    list.free;


    str := chr(0) + CHRNULL +
      chr(MSG_CCACHE_SEND_SUPERNODES);

     //Todo
     //chr(5)+CHRNULL+chr(MSG_CCACHE_SEND_SUPERNODES)+chr(1)+chr(10)+chr(1)+int_2_word_string(minum_wanted_build)
     //sends us unencrypted reply, but put higher load on cache server

    tempo := gettickcount;
    while true do begin
      if gettickcount - tempo > 10000 then begin
        helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket.ip)));
        socket.free;
        exit;
      end;
      TCPSocket_Sendbuffer(socket.socket, @str[1], length(str), er);
      if er = WSAEWOULDBLOCK then begin
        sleep(10);
        continue;
      end else
        if er <> 0 then begin
          helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket.ip)));
          socket.free;
          exit;
        end;
      break;
    end;


  ///////////////////////////////////////// ok ho inviatyo req, ora attendo lista hosts


    tempo := gettickcount;
 //recvd:=0;
    ricevuto := '';
    while true do begin
      if gettickcount - tempo > 10000 then begin
        helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket.ip)));
        socket.free;
        exit;
      end;


      if not TCPSocket_CanRead(socket.socket, 0, er) then begin
        if ((er <> 0) and (er <> WSAEWOULDBLOCK)) then begin
          helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket.ip)));
          socket.free;
          exit;
        end;
        sleep(10);
        continue;
      end;

      previous_len := length(ricevuto);
      setlength(ricevuto, previous_len + 1024);
      len := TCPSocket_RecvBuffer(socket.socket, @ricevuto[previous_len + 1], 1024, er);
      if er = WSAEWOULDBLOCK then begin
        setlength(ricevuto, previous_len);
        sleep(10);
        continue;
      end;
      if er <> 0 then begin
        helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket.ip)));
        socket.free;
        exit;
      end;
     //inc(recvd,len);

      tempo := gettickcount;
      if len < 1024 then setlength(ricevuto, previous_len + len);

      while true do begin
        if length(ricevuto) < 3 then break;
        wantedlen := chars_2_word(copy(ricevuto, 1, 2));
        if length(ricevuto) < wantedlen + 3 then break;

        if ricevuto[3] <> chr(MSG_CCACHE_HERE_SERV) then
          if ricevuto[3] <> chr(MSG_CCACHE_HERE_SERVNOTCRYPT) then begin //fine lista
            helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket.ip)));
            socket.free;
            exit;
          end;

        nocrypt := (ricevuto[3] = chr(MSG_CCACHE_HERE_SERVNOTCRYPT));
        delete(ricevuto, 1, 3);

        if nocrypt then str := ricevuto else begin
          ip_cache := chars_2_dword(reverse_order(int_2_dword_string(inet_addr(pchar(socket.ip)))));
          str := d7spec(ip_cache, socket.port, ricevuto); //decrypt
        end;

        if ares_cache_parse_supernodes(str) = 'ok' then helper_ares_cacheservers.Cache_putHasConnected(inet_addr(pchar(socket.ip)))
        else helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket.ip)));

        socket.free;
        exit;
      end; //while parse
    end; //while receive

  except
  end;

end;

procedure tthread_client.Ares_doIdle_in_connecting;
var
  nodo_ares: tares_node;
begin
  while (ares_busy_nodes.count > 0) do begin
    nodo_ares := ares_busy_nodes[ares_busy_nodes.count - 1];
    ares_busy_nodes.delete(ares_busy_nodes.count - 1);
    aresnodes_putDisconnected(nodo_ares, ares_aval_nodes);
  end;
end;


procedure tthread_client.ares_connect;
var
  str: string;
  i, er, lung, len, previous_len: integer;
  nodo_ares: tares_node;
  naS: string;
begin
  ares_disconnected := false;

  try
    if ares_connected_nodes.count = 0 then synchronize(log_connecting_to_node);

    if ares_busy_nodes.count < MAX_CLIENTOUTCONN then begin
      nodo_ares := aresnodes_getsuitable(ares_aval_nodes);
      if nodo_ares = nil then begin
        if ares_busy_nodes.count = 0 then begin
          ares_connect_cache;
          exit;
        end;
      end else begin
        with nodo_ares do begin
          state := SessConnecting;
          last := gettickcount;
          socket := TTCPBlockSocket.Create(true);
          assign_proxy_settings(socket);
          with socket do begin
            ip := host;
            port := nodo_ares.port;
            Connect(ip, inttostr(port));
          end;
        end;
        ares_busy_nodes.add(nodo_ares);
      end;
    end;

    i := 0;
    while (i < ares_busy_nodes.count) do begin
      nodo_ares := ares_busy_nodes[i];

      if nodo_ares.state = sessConnecting then begin
        if gettickcount - nodo_ares.last > 10000 then begin
          aresnodes_putFailed(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;
        er := TCPSocket_ISConnected(nodo_ares.socket);
        if er = WSAEWOULDBLOCK then begin
          inc(i);
          continue;
        end;
        if er <> 0 then begin
          aresnodes_putFailed(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;

        TCPSocket_SendBuffer(nodo_ares.socket.socket, @STR_NEW_PRELOGIN[1], length(STR_NEW_PRELOGIN), er);
        if er = WSAEWOULDBLOCK then begin
          inc(i);
          continue;
        end;
        if er <> 0 then begin
          aresnodes_putFailed(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;
        nodo_ares.state := SessReceivingNa;
        nodo_ares.last := gettickcount;
      end;

      if nodo_ares.state = SessReceivingNa then begin
        if gettickcount - nodo_ares.last > TIMOUT_SOCKET_CONNECTION then begin
          aresnodes_putFailed(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;
        if not TCPSocket_CanRead(nodo_ares.socket.socket, 0, er) then begin
          if ((er <> 0) and (er <> WSAEWOULDBLOCK)) then begin
            aresnodes_putFailed(nodo_ares, ares_aval_nodes);
            ares_busy_nodes.delete(i);
            continue;
          end else inc(i);
          continue;
        end;
        len := TCPSocket_RecvBuffer(nodo_ares.socket.socket, @buffer_ricezione, sizeof(buffer_ricezione), er);
        if er = WSAEWOULDBLOCK then begin
          inc(i);
          continue;
        end;
        if er <> 0 then begin
          aresnodes_putFailed(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;
        previous_len := length(nodo_ares.socket.buffstr);
        setlength(nodo_ares.socket.buffstr, previous_len + len);
        move(buffer_ricezione, nodo_ares.socket.buffstr[previous_len + 1], len);
        if length(nodo_ares.socket.buffstr) < 3 then begin
          inc(i);
          continue;
        end;
        if nodo_ares.socket.buffstr[3] <> chr(MSG_SERVER_PRELOGIN_OK) then
          if nodo_ares.socket.buffstr[3] <> chr(MSG_SERVER_PRELGNOKNOCRYPT) then
            if nodo_ares.socket.buffstr[3] <> chr(MSG_SERVER_PRELGNOK) then begin
              aresnodes_putFailed(nodo_ares, ares_aval_nodes);
              ares_busy_nodes.delete(i);
              continue;
            end;

        lung := chars_2_word(copy(nodo_ares.socket.buffstr, 1, 2));
        if lung > 2048 then begin
          aresnodes_putFailed(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;
        if lung < 21 then begin
          aresnodes_putFailed(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;
        if length(nodo_ares.socket.buffstr) < lung + 3 then begin
          inc(i);
          continue;
        end;

        if nodo_ares.socket.buffstr[3] = chr(MSG_SERVER_PRELOGIN_OK) then begin
          nodo_ares.oldProt := true;
        end;

        if nodo_ares.socket.buffstr[3] = chr(MSG_SERVER_PRELGNOKNOCRYPT) then begin
          nodo_ares.noCrypt := true;
        end;

        delete(nodo_ares.socket.buffstr, 1, 3);

        str := d3a(nodo_ares.socket.buffstr, nodo_ares.port); //decrypt whole
        nodo_ares.socket.buffstr := str;
      //  sup_users:=chars_2_word(copy(nodo_ares.socket.buffstr,1,2));
        delete(nodo_ares.socket.buffstr, 1, 2);

        naS := copy(nodo_ares.socket.buffstr, 1, 16);
        nodo_ares.sc := chars_2_word(copy(nodo_ares.socket.buffstr, 17, 2));
        nodo_ares.fc := ord(nodo_ares.socket.buffstr[19]);

        synchronize(get_nick_fromreg);
        synchronize(sync_vars);

               { if ((nodo_ares.oldProt) or (ares_aval_nodes.count<10)) then begin

                 delete(nodo_ares.socket.buffstr,1,19);
                  while (length(nodo_ares.socket.buffstr)>=6) do begin   //ora parsiamo i servers alt...almeno sappiamo che lui non è pacco? 2967+ 24-6-2005
                   str:=copy(nodo_ares.socket.buffstr,1,4);

                   if ((str[3]<>chr(0)) and (str[3]<>chr(1)) and (str[3]<>chr(2))) then begin
                     hostS:=ipint_to_dotstring(chars_2_dword(copy(nodo_ares.socket.buffstr,1,4)));
                     portW:=chars_2_word(copy(nodo_ares.socket.buffstr,5,2));
                     aresnodes_addreported(hostS,portW,ares_aval_nodes);
                   end;
                     delete(nodo_ares.socket.buffstr,1,6);
                  end;
                end;  }


        nodo_ares.socket.buffstr := ares_getout_login_str(nodo_ares, naS);

        nodo_ares.last := gettickcount;
        nodo_ares.state := SessFlushingLogin;
      end;

      if nodo_ares.state = SessFlushingLogin then begin
        if gettickcount - nodo_ares.last > TIMOUT_SOCKET_CONNECTION then begin
          aresnodes_removenode(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;
        TCPSocket_SendBuffer(nodo_ares.socket.socket, @nodo_ares.socket.buffstr[1], length(nodo_ares.socket.buffstr), er);
        if er = WSAEWOULDBLOCK then begin
          inc(i);
          continue;
        end;
        if er <> 0 then begin
          aresnodes_removenode(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;
        with nodo_ares do begin
          last := gettickcount;
          state := SessWaitingForLoginReply;
          socket.buffstr := '';
        end;
      end;

      if nodo_ares.state = SessWaitingForLoginReply then begin
        if gettickcount - nodo_ares.last > TIMOUT_SOCKET_CONNECTION then begin
          aresnodes_removenode(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;
        if not TCPSocket_CanRead(nodo_ares.socket.socket, 0, er) then begin
          if ((er <> 0) and (er <> WSAEWOULDBLOCK)) then begin
            aresnodes_removenode(nodo_ares, ares_aval_nodes);
            ares_busy_nodes.delete(i);
            continue;
          end else inc(i);
          continue;
        end;

        len := TCPSocket_RecvBuffer(nodo_ares.socket.socket, @buffer_ricezione, 3, er);

        if er = WSAEWOULDBLOCK then begin
          inc(i);
          continue;
        end;
        if er <> 0 then begin
          aresnodes_removenode(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end;

        previous_len := length(nodo_ares.socket.buffstr);
        setlength(nodo_ares.socket.buffstr, previous_len + len);
        move(buffer_ricezione, nodo_ares.socket.buffstr[previous_len + 1], len);

        if previous_len + len < 3 then begin
          inc(i);
          continue;
        end;

        if nodo_ares.socket.buffstr[3] <> chr(MSG_SERVER_LOGIN_OK) then begin //login reply failed
          aresnodes_removenode(nodo_ares, ares_aval_nodes);
          ares_busy_nodes.delete(i);
          continue;
        end else begin
          with nodo_ares do begin
            last := gettickcount;
            state := sessestablished;
            out_buf := tmystringlist.create;
            ready_for_filelist := false; // can't send anything till we got handler_my_ip
          end;

          ares_busy_nodes.delete(i);
          ares_connected_nodes.add(nodo_ares);
          continue;
        end;
      end;


      inc(i);
    end; //fine while

  except
  end;
end;




procedure tthread_client.handler_login_ok; // sychronize
begin
  vars_global.logon_time := logontime; //connected
  should_refresh_lbl := true;
end;


procedure tthread_client.log_connecting_to_node; // synchronize
begin
  should_refresh_lbl := true;
  vars_global.logon_time := 0;
  logontime := 0;
end;

procedure tthread_client.log_not_connected; // synch
begin
  should_refresh_lbl := true;
  vars_global.logon_time := 0;
  logontime := 0;
end;

procedure tthread_client.refresh_labels;
var
  condivisi: integer;
  stringa_sharing: widestring;
  ipints: string;
begin
  should_refresh_lbl := false;

  if vars_global.localip <> my_localip then begin
    vars_global.localip := my_localip;
    vars_global.localipC := inet_addr(pchar(my_localip));
  end;

  ipints := vars_global.LanIPS;
  if ipints <> vars_global.localip then ares_frmmain.edit_opt_network_yourip.text := 'IP: ' + vars_global.localip + ' (' + ipints + ')'
  else
    ares_frmmain.edit_opt_network_yourip.text := 'IP: ' + vars_global.localip;

  if ares_connected_nodes.count = 0 then begin
    if not ares_frmmain.btn_opt_connect.down then ares_FrmMain.lbl_opt_statusconn.caption := ' ' + GetLangStringW(STR_NOT_CONNECTED)
    else ares_FrmMain.lbl_opt_statusconn.caption := ' ' + GetLangStringW(STR_CONNECTING_TO_NETWORK);
  end else begin
    get_nick_fromreg;
    if vars_global.mynick = '' then vars_global.mynick := STR_ANON + ip_to_hex_str(vars_global.localipC);
    condivisi := vars_global.my_shared_count; //impostato da apri general library view;
    stringa_sharing := ', ' + GetLangStringW(STR_SHARING) + ' ' + format_currency(condivisi) + ' ' + GetLangStringW(STR_FILES) + '  ';
    stringa_nickname := ' ' + GetLangStringW(STR_CONNECTED_AS) + ' ' + utf8strtowidestr(vars_global.mynick);
    ares_FrmMain.lbl_opt_statusconn.caption := stringa_nickname + stringa_sharing;
  end;

end;



procedure tthread_client.get_nick_fromreg; //in synch per evitare di rimandare anon con agigunti caratteri...
var
  reg: tregistry;
begin
  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);
    vars_global.mynick := prendi_mynick(reg);
    closekey;
    destroy;
  end;
  if ((length(vars_global.mynick) < 2) or (length(vars_global.mynick) > MAX_NICK_LEN)) then vars_global.mynick := '';
end;


procedure tthread_client.sync_vars; //synch
begin
  numero_upload := vars_global.numero_upload;
  limite_upload := vars_global.limite_upload;
  mypgui := vars_global.mypgui;
  myport := vars_global.myport;
  mynick := vars_global.mynick;
  my_speed := vars_global.velocita_up div 100;
  should_connect := ares_FrmMain.btn_opt_connect.down;
  our_build := vars_global.versioneares; // da comunicare a ne.php
end;


function tthread_client.ares_getout_login_str(node: tares_node; na: string): string;
const
  HashPass = '00000000000000000000';
var
  strout, str, strlogin: string;
  secHash: TSecHash2;
  nas: string;
begin

  if node.OldProt then begin

    secHash := TSecHash2.create; //primo hash
    nas := secHash.compute(na);
    secHash.free;

    str := int_2_word_string((a1(node.sc, node.fc, ff[node.fc]) + 1)) +
      int_2_word_string(wh(nas)) +
      nas;

    strlogin := dcba(str);

    strout := CHRNULL +
      strlogin +
      int_2_word_string(wh(strlogin));

  end else begin

 {   // v1.9.3.3012    10-19-2006  get rid of encryption

  sha1:=Tsha1.create;
   sha1.transform(na[1],length(na));
  sha1.complete;
str2:=sha1.HashValue;
  sha1.free;

 i:=128;
 h:=128;
 while (length(str2)<sizeof(ac8)) do begin   //expand key
   str1:=chr(i)+str2+chr(h);
     sha1:=Tsha1.create;
      sha1.transform(str1[1],length(str1));
     sha1.complete;
  str2:=str2+sha1.HashValue;
     sha1.free;
    inc(i);
    dec(h);
 end;
 delete(str2,sizeof(ac8)+1,length(str2));

  mem:=allocmem(sizeof(ac8));
  move(str2[1],mem^,sizeof(ac8));


   E9B38B8BEF(mem);
   FCA7EF2B0A(mem);
   BF064C2058(mem);
   CC403C4410(mem);
   C508D27CC9(mem);
   FD72C169D2(mem);
   C0CBCDF9C5(mem);
   A527AB88DD(mem);
   D38652CD27(mem);
   CFE4F66A87(mem);
   ADF861B37F(mem);
   AA98CEA7BB(mem);
   B2D998611D(mem);
   E21381C3A2(mem);
   D649E52353(mem);
   F6947F2E70(mem);
   F511A48ADF(mem);
   EFFF43E2B2(mem);
   A925779B20(mem);
   EB4C45B8AD(mem);

  setlength(str1,sizeof(ac8));
  move(mem^,str1[1],sizeof(ac8));
   freemem(mem,sizeof(ac8));

  //then perform last hash
    Sha1:=TSha1.create;
          Sha1.transform(str1[1],length(str1));
          Sha1.complete;
  strout:=Sha1.HashValue;
          Sha1.free;}

    strout := HashPass;
  end;


  strout := strout +
    int_2_word_string(my_speed) +
    chr(numero_upload) + //26
    chr(limite_upload) + //27
    CHRNULL + //29 proxycount deprecated
    chr(my_queue_length) + //29
    int_2_word_string(myport) +
    mynick + CHRNULL +
    mypgui +
    CHRNULL {cant be supernode} +
    CHRNULL {str_firewalled} +
    appname + CHRNULL +
    int_2_dword_string(vars_global.LanIPC);

  if node.noCrypt then str := strout
  else str := e1(node.fc, node.sc, strout);


  result := int_2_word_string(length(str)) +
    chr(MSG_CLIENT_LOGIN_REQ) +
    str;
end;

procedure tthread_client.ares_flush_socket;
var
  str: string;
  er: integer;
  lung, i: integer;
  nodo_ares: tares_node;
begin


  try

    i := 0;
    while (i < ares_connected_nodes.count) do begin
      nodo_ares := ares_connected_nodes[i];


      while (nodo_ares.out_buf.count > 0) do begin
        str := nodo_ares.out_buf.strings[0];

        if length(str) > 4096 then begin
          nodo_ares.out_buf.delete(0);
          continue;
        end else
          if length(str) = 0 then begin
            nodo_ares.out_buf.delete(0);
            continue;
          end;


        lung := TCPSocket_SendBuffer(nodo_ares.socket.socket, @str[1], length(str), er);
        if er = WSAEWOULDBLOCK then break;
        if er <> 0 then begin
          nodo_ares.state := sessdisconnected;
          exit;
        end;

        if lung < length(str) then begin
          delete(str, 1, lung);
          nodo_ares.out_buf.strings[0] := str;
        end else nodo_ares.out_buf.delete(0);
      end;

      inc(i);
    end;

  except
  end;
end;

procedure tthread_client.ares_receive;
var
  i: integer;
  nodo_ares: tares_node;
begin
  try

    i := 0;
    while (i < ares_connected_nodes.count) do begin
      nodo_ares := ares_connected_nodes[i];

      if nodo_ares.state = sessdisconnected then begin
        ares_connected_nodes.delete(i);
        mysupernodes.mysupernodes_remove(inet_addr(pchar(nodo_ares.host)));

        if tempo - nodo_ares.logtime > 600000 then aresnodes_putConnected(nodo_ares, ares_aval_nodes); // good node, save it to db
        aresnodes_putDisconnected(nodo_ares, ares_aval_nodes);
        continue;
      end;

      ares_receive(nodo_ares);

      inc(i);
    end;


  except
  end;
end;

procedure tthread_client.ares_receive(node: tares_node);
var
  len, er: integer;
  previous_len: integer;
  wanted_len: word;
begin

  while (true) do begin

    if not TCPSocket_CanRead(node.socket.socket, 0, er) then begin
      if ((er <> WSAEWOULDBLOCK) and (er <> 0)) then begin
        node.state := sessdisconnected;
      end;
      exit;
    end;

    previous_len := length(node.socket.buffstr);

    if previous_len < 3 then begin
      len := TCPSocket_RecvBuffer(node.socket.socket, @buffer_ricezione[0], 3 - previous_len, er);
      if er = WSAEWOULDBLOCK then exit;
      if er <> 0 then begin
        node.state := sessdisconnected;
        exit;
      end;
      setlength(node.socket.buffstr, previous_len + len);
      move(buffer_ricezione[0], node.socket.buffstr[previous_len + 1], len);
      continue;
    end;

    move(node.socket.buffstr[1], wanted_len, 2);

    if wanted_len = 0 then begin
      ares_process_command(node, ord(node.socket.buffstr[3]), '');
      if node.state = sessdisconnected then exit;
      node.socket.buffstr := '';
      continue;
    end;

    if wanted_len + 3 > sizeof(buffer_ricezione) then begin
      node.state := sessdisconnected;
      exit;
    end;


    len := TCPSocket_RecvBuffer(node.socket.socket, @buffer_ricezione[0], (wanted_len + 3) - previous_len, er);
    if er = WSAEWOULDBLOCK then exit;
    if er <> 0 then begin
      node.state := sessdisconnected;
      exit;
    end;

    setlength(node.socket.buffstr, previous_len + len);
    move(buffer_ricezione[0], node.socket.buffstr[previous_len + 1], len);

    if length(node.socket.buffstr) = wanted_len + 3 then begin
      ares_process_command(node, ord(node.socket.buffstr[3]), copy(node.socket.buffstr, 4, wanted_len));
      if node.state = sessdisconnected then exit;
      node.socket.buffstr := '';
    end;

  end;

end;

procedure tthread_client.ares_process_command(nodo_ares: tares_node; cmd: byte; cnt: string);
begin
  try

    if length(cnt) > 0 then begin
      if nodo_ares.noCrypt then content := cnt
      else content := d1(nodo_ares.fc, nodo_ares.sc, cnt);
    end else content := '';

    case cmd of
      MSG_SERVER_LOGIN_OK: handler_login_ok(nodo_ares);
      MSG_SERVER_YOUR_NICK: should_refresh_lbl := true;
      MSG_SERVER_PUSH_REQ: handler_push_req_ares2;
      MSG_SERVER_SEARCH_RESULT: handler_hit(nodo_ares);
 //MSG_SERVER_SEARCH_ENDOF:synchronize(handler_endofsearch);   // 3008 network fakers caused search to terminate too soon
      MSG_SERVER_STATS: handler_stats(nodo_ares);
      MSG_SERVER_YOUR_IP: handler_my_ip(nodo_ares);
      MSG_SERVER_PUSH_CHATREQ_NEW: synchronize(handler_push_chat_req);

      MSG_CLIENT_USERFIREWALL_REQ: handler_test_user_firewall;
      MSG_CLIENT_USERFIREWALL_RESULT: handler_test_firewall_result(nodo_ares); //supernode gives us our firewalled status

      MSG_SERVER_HERE_CACHEPATCH3: begin
          if tempo - nodo_ares.logtime >= 5 * MINUTE then synchronize(handler_patch_caches_new) else begin
            nodo_ares.state := SessDisconnected; //DEBUG
          end;
        end;


 // MSG_SERVER_HERE_CACHEPATCH:begin
 //                            if tempo-nodo_ares.logtime>=5*MINUTO then synchronize(handler_patch_caches_old);
 //                           end;
 // MSG_SERVER_HERE_CACHEPATCH2:begin
 //                             if tempo-nodo_ares.logtime>=5*MINUTO then synchronize(handler_patch_caches);
 //                            end;
 // MSG_SERVER_HERE_CHATCACHEPATCH:synchronize(handler_chat_patch_caches);
 // MSG_SERVER_STATUS_LINK:;//new supernodes 2944+ send this after stats(election stuff)

    end;

  except
  end;
end;


procedure tthread_client.handler_test_firewall_result(nodo_ares: Tares_node);
var
  resultID: word;
begin
  if length(content) < 1 then exit;
// byte[0] can have these values:
// 0 = firewalled(cant connect)  1= not firewalled (established connection)


  if length(content) >= 3 then begin
 // 12/29/2005 supernodes send back our remote 'resultID'
 // to be used by UDP NAT Transfer protocol (ping-pong)
    move(content[2], resultId, 2);
    mysupernodes.mysupernodes_add(inet_addr(pchar(nodo_ares.host)),
      nodo_ares.port,
      resultId);
  end else
    mysupernodes.mysupernodes_add(inet_addr(pchar(nodo_ares.host)),
      nodo_ares.port,
      -1);


  if content[1] = chr(1) then
    if m_is_firewalled > 0 then begin
      dec(m_is_firewalled);
      if m_is_firewalled <= 2 then synchronize(SyncNotFirewalled);
    end;

end;

procedure tthread_client.SyncNotFirewalled;
begin
  vars_global.im_firewalled := false;
end;




procedure tthread_client.handler_test_user_firewall;
var
  ip: cardinal;
  port: word;
  socket: ttcpblocksocket;
begin
  if length(content) < 6 then exit;

// TODO check max rate of out connections requested by this supernode
  ip := chars_2_dword(copy(content, 1, 4));
  port := chars_2_word(copy(content, 5, 2));

  socket := TTCPBlockSocket.Create(true);
  assign_proxy_settings(socket);
  socket.ip := ipint_to_dotstring(ip);
  socket.port := port;
  socket.tag := tempo;
  socket.Connect(socket.ip, inttostr(socket.port));
  lista_test_firewall.add(socket);
end;

procedure tthread_client.deal_test_firewall;
var
  i, er: integer;
  socket: ttcpblocksocket;
begin
  try

    i := 0;
    while (i < lista_test_firewall.count) do begin
      socket := lista_test_firewall[i];

      if tempo - socket.tag > 10000 then begin
        ares_sendback(nil, MSG_CLIENT_USERFIREWALL_REPORT, CHRNULL + int_2_dword_string(inet_addr(pchar(socket.ip))));
        socket.free;
        lista_test_firewall.delete(i);
        continue;
      end;


      if not TCPSocket_CanWrite(socket.socket, 0, er) then begin
        if ((er <> 0) and (er <> WSAEWOULDBLOCK)) then begin
          ares_sendback(nil, MSG_CLIENT_USERFIREWALL_REPORT, CHRNULL + int_2_dword_string(inet_addr(pchar(socket.ip))));
          socket.free;
          lista_test_firewall.delete(i);
        end else inc(i);
        continue;
      end;

      ares_sendback(nil, MSG_CLIENT_USERFIREWALL_REPORT, chr(1) + int_2_dword_string(inet_addr(pchar(socket.ip)))); //ok siamo riusciti a connetterci, mandiamo esito!
      socket.free;
      lista_test_firewall.delete(i);
    end;

  except
  end;
end;


procedure tthread_client.handler_patch_caches_old; //vers #2940 had a format alignment bug
var
  ip: cardinal;
  port: word;
begin

  ip := chars_2_dword(copy(content, 1, 4));
  porT := get_ppca(ip);
  delete(content, 1, 4);

  content := int_2_dword_string(ip) +
    int_2_word_string(port) +
    content;

  helper_ares_cacheservers.cache_add_cache_host_patch(content, 6); //qui arrivano 4 a 4 ip+port da 2941

end;


procedure tthread_client.handler_endofsearch; //synch
var
  h, z, ind: integer;
  src: precord_panel_search;
  numW: word;
  nodo_Ares: tares_node;
  nodo: pCmtVnode;
  data: precord_search_result;
begin
  if length(content) < 2 then exit;

  move(content[1], numW, 2);


  for z := 0 to ares_connected_nodes.count - 1 do begin //remove from ares_nodes
    nodo_ares := ares_connected_nodes[z];
    with nodo_ares do begin
      if searchIDs = nil then continue;
      ind := searchIDS.indexof(copy(content, 1, 2));
      if ind <> -1 then begin
        searchIDS.delete(ind);
        if searchIDS.count = 0 then FreeAndNil(searchIDS);
      end;
    end;
  end;



  for h := 0 to src_panel_list.count - 1 do begin //update GUI
    src := src_panel_list[h];
    if src^.started = 0 then continue;
    if src^.searchID <> numW then continue;


    src^.started := 0;
    if src^.numresults > 1 then src^.lbl_src_status_caption := inttostr(src^.numresults) + ' (' + inttostr(src^.numhits) + ') ' + GetLangStringW(STR_RESULTS_FOR) + ' ' + utf8strtowidestr(src^.search_string) else
      if src^.numresults = 1 then src^.lbl_src_status_caption := '1 (' + inttostr(src^.numhits) + ') ' + GetLangStringW(STR_RESULT_FOR) + ' ' + utf8strtowidestr(src^.search_string) else begin
        src^.lbl_src_status_caption := '0 ' + GetLangStringW(STR_RESULTS_FOR) + ' ' + utf8strtowidestr(src^.search_string);
        with src^.listview do begin
          nodo := GetFirst;
          data := getdata(nodo);
          data^.title := GetLangStringA(STR_SEARCHING_THE_NET_NO_RESULT);
          invalidatenode(nodo);
        end;
      end;


    if ares_Frmmain.pagesrc.activepanel = src^.containerPanel then begin // mettere detection flooding con unlisten /scoprire motivo violazione d'accesso
      with ares_frmmain do begin
        lbl_src_status.caption := src^.lbl_src_status_caption;
        btn_stop_search.enabled := false;
        btn_start_search.enabled := true;
        edit_src_filter.Enabled := src^.listview.Selectable;
        helper_search_gui.enable_search_fields;
      end;
    end;

    break;
  end;

end;

procedure tthread_client.handler_patch_caches; //synch la 2941> manda solo ip da 4 bytes
begin
  helper_ares_cacheservers.cache_add_cache_host_patch(content, 4); //qui arrivano 4 a 4 ip+port da 2941
end;

procedure tthread_client.handler_patch_caches_new; //synch la 2952+
  function d12e(const S: string; b: Word): string;
  var
    I: cardinal;
  begin
    if length(s) = 0 then exit;
    SetLength(result, length(s));

    result := s;
    for I := 1 to Length(S) do begin
      Result[I] := char(byte(S[I]) xor (b shr 8));
      b := (byte(S[I]) + b) * 15271 + 16125;
    end;
  end;

begin
  if length(content) = 0 then exit;
  exit; //DEBUG


  content := d12e(content, 1432); //2952+

  helper_ares_cacheservers.cache_add_cache_host_patch(content, 4); //qui arrivano 4 a 4 ip+port da 2941
end;


procedure tthread_client.handler_push_chat_req; // (thread-safe) supernode issues us a request to push an outbound chat connection
var
  randoms,
    ips: string;
  his_alt_ip,
    his_ip: cardinal;
  his_port: word;
begin
  if ares_frmmain.Check_opt_chat_nopm.checked then exit;

  if vars_global.numero_pvt_open > 25 then exit;

  if length(content) < 26 then exit;


  try

    his_ip := chars_2_dword(copy(content, 1, 4));
    his_porT := chars_2_word(copy(content, 5, 2));
    his_alt_ip := chars_2_dword(copy(content, 7, 4));


    randoms := copy(content, 11, 16);
    if length(randoms) <> 16 then exit;

    ips := ipint_to_dotstring(his_ip);
    if ip_firewalled(ips) then exit;

    if reg_bannato(ips) then exit else begin
      inc(vars_global.numero_pvt_open);
      with tthread_chat_push_connector.create(true) do begin
        random_str := randoms;
        his_rem_ip := his_ip;
        his_rem_port := his_port;
        his_rem_ip_alt := his_alt_ip;
        resume;
      end;

    // con zero attiva, con 1 mostra
    end;
  except
  end;
end;


procedure tthread_client.handler_my_ip(nodo_ares: tares_node); //server let us know our external IP
var
  resultId: word;
  ipC: cardinal;
begin
  if length(content) < 4 then exit;

  my_localip := ipint_to_dotstring(chars_2_dword(copy(content, 1, 4)));
  GlobNode := nodo_ares;

  if length(content) >= 9 then begin
  //nodo_ares.hash_range:=byte_to_hash_range(ord(content[5]));
    move(content[8], resultId, 2);
    ipC := inet_addr(pchar(nodo_ares.host));
    mysupernodes.mysupernodes_add(ipC,
      nodo_ares.port,
      resultId);


    if length(content) >= 13 then synchronize(checkDHT_bootstrap);
  end;


  should_refresh_lbl := true; //imposta ip in refresh labels

  sync_hashrequests(nodo_ares); // send resume requests

  nodo_ares.last := tempo;
  nodo_ares.ready_for_filelist := true;
  nodo_ares.HistSentFilelists := 0;
  nodo_ares.EverSentFilelist := false; // we need to know if we have to send unshare all before resending filelist in case of rescan

  synchronize(Synch_node_Send_Filelist);

end;

procedure tthread_client.checkDHT_bootstrap; //sync
var
  ipC: cardinal;
  portW: word;
begin
  try
    ipC := inet_addr(pchar(GlobNode.host));
    portW := chars_2_word(copy(content, 12, 2));
    DHT_possibleBootstrapClientIP := ipC;
    DHT_possibleBootstrapClientPort := portW;
  except
  end;
end;

procedure tthread_client.Synch_node_Send_Filelist; //synch
begin
  if Vars_global.ShareScans > 0 then GlobNode.ListSents := vars_global.ShareScans - 1 // we need to update files now
  else GlobNode.ListSents := Vars_global.ShareScans; // not yet scanthread is running or we don't have a filelist
end;


procedure tthread_client.handler_push_req_ares2; //server issue us a request to perform a download push
var
  portto: word;
  ipto: integer;
  push_to_go: precord_push_to_go;
begin

  if length(content) < 35 then exit;
  if vars_global.lista_push_nostri.count > 20 then exit; //non posso mandare anche questo...mi autofloddo

 //formas:
 //   old       PUSH ABCDEF0123456789            +randoms
 //   new       PUSH SHA1:ABCDEFABCD01234567890  +randoms
 //

  ipto := chars_2_dword(copy(content, 1, 4));
  portto := chars_2_word(copy(content, 5, 2));

  push_to_go := AllocMem(sizeof(record_push_to_go));

                                        //hash + NULL + randoms
  push_to_go^.filename := copy(content, 7, 20) + copy(content, 28, length(content)); {chr(83)+chr(72)+chr(65)+chr(49)+chr(58)'SHA1:'+}
                          //hash_sha1+
                          //randoms;

  push_to_go^.ip := ipto;
  push_to_go^.port := portto;
  vars_global.lista_push_nostri.add(push_to_go);

end;


procedure tthread_client.handler_hit(nodo_ares: tares_node);
// byte tipo
// 1) se hash fromhost+ipdword+portdword+special+nick+null+hash
// 2) se key guids(16)+fromhosts+fromhost+ipdword+portdword+special+nick+null+ details
//
//details veri:   byte tipo+
//                dword size+
//                estensione + null
//               [ chr(1)+title+null ]
//               [ chr(2)+artist+null ]
//               [ chr(3)+key3+null ]
//               [ chr(4)+str_metadetails ]
begin
  if length(content) < 33 then exit; // security...

  case ord(content[1]) of
    1: handler_hit;
    0: handler_hit(nodo_Ares, true);
  end;

end;

procedure tthread_client.handler_hit;
var
  dl_hash: precord_download_hash;
  list: tlist;
  source: trisorsa_download;
begin
  try

    move(content[2], pheader_recuser^, 13);
    if isAntiP2PIP(pheader_recuser^.serverip) then exit;
    if isAntiP2PIP(pHeader_recUser^.userip) then exit;

    delete(content, 1, 14);

    user_nick := copy(content, 1, pos(CHRNULL, content) - 1);

 // parse error during supernode login handshake?
    if pos('@Unknown', user_nick) <> 0 then user_nick := copy(STR_ANON, 1, length(STR_ANON)) +
      ip_to_hex_str(pHeader_recUser^.userip) +
        copy(STR_UNKNOWNCLIENT, 1, length(STR_UNKNOWNCLIENT));


    delete(content, 1, pos(CHRNULL, content));

    if length(content) < 20 then exit;
    result_search^.hash_sha1 := copy(content, 1, 20);
    result_search^.crcsha1 := crcstring(result_search^.hash_sha1);
    dl_hash := find_download_hash(result_search^.crcsha1, result_search^.hash_sha1);

    if dl_hash <> nil then begin

      if length(content) >= 20 then his_local_ip := chars_2_dword(copy(content, 21, 4))
      else his_local_ip := 0;

      source := trisorsa_download.create;
      with source do begin
        InsertServer(pheader_recuser^.serverip, pheader_recuser^.serverport);
        ip := pheader_recuser^.userip;
        porta := pheader_recuser^.userport;
        handle_download := dl_hash^.handle_download;
        ip_interno := his_local_ip;
        if pos('@', user_nick) = 0 then nickname := copy(user_nick, 1, length(user_nick)) + copy(STR_UNKNOWNCLIENT, 1, length(STR_UNKNOWNCLIENT))
        else nickname := copy(user_nick, 1, length(user_nick));
        tick_attivazione := 0;
        socket := nil;
      end;
      list := vars_global.lista_risorse_temp.locklist;
      list.add(source);
      vars_global.lista_risorse_temp.unlocklist;
    end;


    user_nick := '';

  except
  end;
end;

procedure tthread_client.handler_hit(nodo_ares: tares_node; dummy: boolean);
var
  ext, key1, key2, key3, lostr, lusernick, detStr: string;
  num: byte;
  search_id: word;
  dl_hash: precord_download_hash;
  source: trisorsa_download;
  list: tlist;
begin
  try

    if length(content) < 30 then exit;

    search_id := chars_2_word(copy(content, 2, 2)); //not the current search

///////////////////parse user details
    move(content[4], pheader_recuser^, 13);
    if isAntiP2PIP(pheader_recuser^.serverip) then exit;
    if isAntiP2PIP(pHeader_recUser^.userip) then exit;

    delete(content, 1, 16);
    user_nick := copy(content, 1, pos(CHRNULL, content) - 1);

    lusernick := lowercase(user_nick);
    if pos('@warez lite', lusernick) <> 0 then exit else
      if pos('@filecroc 1.50', lusernick) <> 0 then exit else
        if pos('@ares lite', lusernick) <> 0 then exit;

    delete(content, 1, pos(CHRNULL, content));

//////////////details user....
    if length(content) < 23 then exit;



    reset_result; //prepare record

    result_search^.amime := ord(content[6]);
    if result_search^.amime > ARES_MIME_IMAGE then begin

      exit;
    end;

    result_search^.fsize := chars_2_dword(copy(content, 7, 4));
    if result_search^.fsize < 1 then begin

      exit;
    end;

    if length(content) < 30 then begin

      exit;
    end;

    result_search^.hash_sha1 := copy(content, 11, 20);
    result_search^.crcsha1 := crcstring(result_search^.hash_sha1);

    dl_hash := find_download_hash(result_search^.crcsha1, result_search^.hash_sha1);
    if dl_hash <> nil then begin
      source := trisorsa_download.create;
      with source do begin
        InsertServer(pheader_recuser^.serverip, pheader_recuser^.serverport);
        ip := pheader_recuser^.userip;
        porta := pheader_recuser^.userport;
        handle_download := dl_hash^.handle_download;
        ip_interno := 0;
        if pos('@', user_nick) = 0 then nickname := copy(user_nick, 1, length(user_nick)) + copy(STR_UNKNOWNCLIENT, 1, length(STR_UNKNOWNCLIENT))
        else nickname := copy(user_nick, 1, length(user_nick));
        tick_attivazione := 0;
        socket := nil;
      end;
      list := vars_global.lista_risorse_temp.locklist;
      list.add(source);
      vars_global.lista_risorse_temp.unlocklist;
    end;

    delete(content, 1, 30);


    ext := lowercase(copy(content, 1, pos(CHRNULL, content) - 1));

    if pos(chr(46) {'.'}, ext) <> 1 then begin

      exit;
    end
    else if length(ext) < 1 then begin

      exit;
    end;

    if ext <> '.arescol' then
      if extstr_to_mediatype(ext) <> result_search^.amime then begin

        exit;
      end;
// if pos(ext,STR_DCM)<>0 then exit;//filtriamo WMV

    delete(content, 1, pos(CHRNULL, content));
    if length(content) > 2 then begin
      if content[1] = chr(CLIENT_RESULT_KEY1) then begin
        delete(content, 1, 1);
        key1 := copy(content, 1, pos(CHRNULL, content) - 1);
        if length(key1) < 1 then begin

          exit; //empty title no!
        end;
        if str_isWebSpam(key1) then begin

          exit; //block spam!!
        end;
        if ((result_search^.amime = ARES_MIME_VIDEO) or (result_search^.amime = ARES_MIME_IMAGE)) then
          if is_teen_content(key1) then begin

            exit;
          end;
        delete(content, 1, pos(CHRNULL, content));
      end;
    end;

    if length(content) > 2 then begin
      if content[1] = chr(CLIENT_RESULT_KEY2) then begin
        delete(content, 1, 1);
        key2 := copy(content, 1, pos(CHRNULL, content) - 1);
        delete(content, 1, pos(CHRNULL, content));
        if str_isWebSpam(key2) then key2 := '' else begin
          if ((result_search^.amime = ARES_MIME_VIDEO) or (result_search^.amime = ARES_MIME_IMAGE)) then
            if is_teen_content(key2) then begin

              exit;
            end;
        end;

      end;
    end;

    if length(content) > 2 then begin
      if content[1] = chr(CLIENT_RESULT_KEY3) then begin
        delete(content, 1, 1);
        key3 := copy(content, 1, pos(CHRNULL, content) - 1);
        delete(content, 1, pos(CHRNULL, content));
        if str_isWebSpam(key3) then key3 := '' else begin
          if ((result_search^.amime = ARES_MIME_VIDEO) or (result_search^.amime = ARES_MIME_IMAGE)) then
            if is_teen_content(key3) then begin

              exit;
            end;
        end;
      end;
    end;

    if length(content) > 2 then begin
      if content[1] = chr(CLIENT_RESULT_KEYEXT) then begin

        if result_search^.amime = ARES_MIME_MP3 then begin
          result_search^.param1 := chars_2_word(copy(content, 2, 2));
          result_search^.param2 := 0;
          result_search^.param3 := chars_2_dword(copy(content, 4, 4));
          delete(content, 1, 7);
        end else
          if ((result_search^.amime = ARES_MIME_VIDEO) or (result_search^.amime = ARES_MIME_IMAGE)) then begin
            result_search^.param1 := chars_2_word(copy(content, 2, 2));
            result_search^.param2 := chars_2_word(copy(content, 4, 2));
            result_search^.param3 := chars_2_dword(copy(content, 6, 4));
            if ((result_search^.param1 > 4000) or (result_search^.param2 > 4000)) then begin
              result_search^.param1 := 0;
              result_search^.param2 := 0;
              result_search^.param3 := 0;
            end;
            delete(content, 1, 9);
          end else begin
            result_search^.param1 := 0;
            result_search^.param2 := 0;
            result_search^.param3 := 0;
            delete(content, 1, 1);
          end;
// parse anche di rich
// 1 = category
// 2 = album
// 3 = comments
// 4 = language
// 5 = url
// 6 = year
        repeat
          if length(content) < 2 then break;
          num := ord(content[1]);
          delete(content, 1, 1);
          detStr := copy(content, 1, pos(CHRNULL, content) - 1);
          case num of
            CLIENT_RESULT_CATEGORY: result_search^.category := detStr;
            CLIENT_RESULT_ALBUM: begin
                if not str_isWebSpam(detStr) then result_search^.album := detStr;
              end;
            CLIENT_RESULT_COMMENTS: result_search^.comments := detStr;
            CLIENT_RESULT_LANGUAGE: result_search^.language := detStr;
            CLIENT_RESULT_URL: begin
                if not str_isWebSpam(detStr) then result_search^.url := detStr;
              end;
            CLIENT_RESULT_YEAR: result_search^.year := detStr;
            7: ;
            11: ;
            CLIENT_RESULT_KEYWORD_GENRE: begin
                if not str_isWebSpam(detStr) then result_search^.keyword_genre := detStr;
              end;
            CLIENT_RESULT_FILENAME: result_search^.filenameS := detStr; //2941-2 +
            CLIENT_RESULT_INT64SIZE: begin
                result_search^.fsize := strtointdef(detStr, 0); //2951+ 5-1-2004
                if result_search^.fsize = 0 then begin
                  detStr := '';
                  exit;
                end;
              end;
            CLIENT_RESULT_HASHOFPHASH: result_search^.hash_of_phash := DecodeBase64(copy(detStr, 1, length(detStr)));
          end;
          detStr := '';
          delete(content, 1, pos(CHRNULL, content));
        until (not true);

      end;
    end;
//parse ips

//check overflows...........
    if length(key1) > MAX_LENGTH_TITLE then delete(key1, MAX_LENGTH_TITLE, length(key1));
    if length(key2) > MAX_LENGTH_FIELDS then delete(key2, MAX_LENGTH_FIELDS, length(key2));
    if length(result_search^.album) > MAX_LENGTH_FIELDS then delete(result_search^.album, MAX_LENGTH_FIELDS, length(result_search^.album));
    if length(result_search^.category) > MAX_LENGTH_FIELDS then delete(result_search^.category, MAX_LENGTH_FIELDS, length(result_search^.category));
    if length(result_search^.language) > MAX_LENGTH_FIELDS then delete(result_search^.language, MAX_LENGTH_FIELDS, length(result_search^.language));
    if length(result_search^.year) > MAX_LENGTH_FIELDS then delete(result_search^.year, MAX_LENGTH_FIELDS, length(result_search^.year));
    if length(result_search^.comments) > MAX_LENGTH_COMMENT then delete(result_search^.comments, MAX_LENGTH_COMMENT, length(result_search^.comments));
    if length(result_search^.url) > MAX_LENGTH_URL then delete(result_search^.url, MAX_LENGTH_URL, length(result_search^.url));
////////////////////////////////////


    with result_search^ do begin //fill in user's info
      ip_user := pheader_recuser^.userip;
      port_user := pheader_recuser^.userport;
      ip_server := pheader_recuser^.serverip;
      port_server := pheader_recuser^.serverport;
      ip_alt := 0;
  // if pheader_recuser^.spchar=97 then

      nickname := copy(user_nick, 1, length(user_nick));

  // nickname:=ipint_to_dotstring(ip_user)+':'+inttostr(port_user)+'   '+
  //           ipint_to_dotstring(ip_server)+':'+inttostr(port_server);

    //nickname:=user_nick+' '+inttostr(ord(pheader_recuser^.spchar));
    end;


    result_search^.title := key1;
    result_search^.artist := key2;
    if ((result_search^.amime = ARES_MIME_MP3) or (result_search^.amime = ARES_MIME_AUDIOOTHER1) or (result_search^.amime = ARES_MIME_IMAGE)) then result_search^.album := key3
    else result_search^.category := key3;

    if ((result_search^.amime = ARES_MIME_VIDEO) or (result_search^.amime = ARES_MIME_IMAGE)) then begin
      if is_teen_content(result_search^.category) then begin

        exit;
      end;
    end;


    if ext = '.exe' then begin
      result_search^.title := trim(result_search^.title);
      result_search^.artist := trim(result_search^.artist);
      result_search^.album := trim(result_search^.album);
    end;

    if result_search^.filenameS <> '' then begin //has original filename ? versions < 2942 didn't send it (filename was generated from meta infos)
      if ((result_search^.amime = ARES_MIME_VIDEO) or (result_search^.amime = ARES_MIME_IMAGE)) then begin
        if is_teen_content(result_search^.filenameS) then begin

          exit;
        end;
      end;
    end else begin
      if ((length(result_search^.album) > 0) and (length(result_search^.artist) > 0)) then result_search^.filenameS := result_search^.artist + chr(32) + chr(45) + chr(32) {' - '} + result_search^.album + chr(32) + chr(45) + chr(32) {' - '} + result_search^.title + ext else
        if length(result_search^.artist) > 0 then result_search^.filenameS := result_search^.artist + chr(32) + chr(45) + chr(32) {' - '} + result_search^.title + ext else
          result_search^.filenameS := result_search^.title + ext;
    end;

    if result_search^.comments <> result_search^.url then begin //if comments=url chances of spam are too high ,drop the result
      if result_search^.comments <> '' then result_search^.comments := strip_spamcomments(result_search^.comments); //assign comments only if they aren't selated to spam
    end else begin
      result_search^.comments := '';
      result_search^.url := '';
    end;

    if filtered_keywords.count > 0 then begin
      with result_search^ do
        lostr := lowercase(filenameS + chr(32) +
          title + chr(32) +
          artist + chr(32) +
          album + chr(32) +
          category + chr(32) +
          comments + chr(32) +
          url + chr(32) +
          language + chr(32) +
          year);
      if is_filtered_text(lostr, filtered_keywords) then begin

        exit;
      end;
      if result_search^.amime = ARES_MIME_MP3 then
        if is_copyrighted_content(lostr) then begin

          exit;
        end;
    end else
      if result_search^.amime = ARES_MIME_MP3 then begin //nathan stone 1-7-2005
        with result_search^ do
          lostr := lowercase(filenameS + chr(32) +
            title + chr(32) +
            artist + chr(32) +
            album);
        if is_copyrighted_content(lostr) then begin

          exit;
        end;
      end;
    if length(result_search^.title) > 0 then result_search^.title := ucfirst(result_search^.title);
    if length(result_search^.album) > 0 then result_search^.album := ucfirst(result_search^.album);
    if length(result_search^.artist) > 0 then result_search^.artist := ucfirst(result_search^.artist);
    result_search^.downloaded := false;

    if should_avoid_exe then begin
      if result_search^.amime = ARES_MIME_SOFTWARE then exit;
      if result_search^.amime = ARES_MIME_OTHER then if pos(ext, STR_EXE_EXTENS) <> 0 then exit;
    end;

    result_search^.search_id := search_id;

    synchronize(GUI_add_result); //update GUI

  except
  end;
end;



procedure tthread_client.GUI_add_result; //in synch
var
  i: integer;
  scannode, newnode1, newnode2, node_child: pCmtVnode;
  nodedata, newdata1, newdata2, data_child, newdata3: precord_search_result;
  src: precord_panel_search;
begin
  try


//if result_search^.port_user=vars_global.myport then
 //if result_search^.ip_user=vars_global.localipC then exit; //not myself.... UDP searches may bring it


    for i := 0 to src_panel_list.count - 1 do begin
      src := src_panel_list[i];
      if src^.started = 0 then continue;
      if src^.searchID <> result_search^.search_id then continue;

      if src^.is_advanced then begin
        if not helper_search_gui.check_complex_search(src, result_search) then exit;

        if ((src^.combo_sel_quality_index = -1) or
          (src^.combo_wanted_quality_index = -1)) then
          if result_search^.amime = ARES_MIME_MP3 then
            if result_search^.param1 < 128 then exit;

      end else begin

        if result_search^.amime = ARES_MIME_MP3 then
          if result_search^.param1 < 128 then exit;

      end;

      if not helper_search_gui.check_matching_srcmime(src, result_search) then exit;

  // limit big sharer's exposure
      if result_search^.amime = ARES_MIME_VIDEO then
        if result_search^.fsize > 100 * MEGABYTE then
          if helper_search_gui.IP_excedeedPublishLimit(src^.backup_results, result_search^.ip_user) then exit;


      if not src^.is_updating then begin
        src^.listview.beginupdate;
        src^.is_updating := true;
        is_updating_treeview := true;
      end;

      scannode := src^.listview.GetFirst;
      while (scannode <> nil) do begin
        nodedata := src^.listview.getdata(scannode);

        if result_search^.fsize <> nodedata^.fsize then begin
          scannode := src^.listview.GetNextSibling(scannode);
          continue;
        end;

        if result_search^.crcsha1 <> 0 then
          if result_search^.crcsha1 = nodedata^.crcsha1 then
            if result_search^.hash_sha1 = nodedata^.hash_sha1 then begin


              helper_search_gui.FillMissingSearchMeta(result_search, nodedata);

              if scannode^.childcount = 0 then begin
                if nodedata^.ip_user = result_search^.ip_user then exit;
              end else
                if ((scannode^.childcount >= MAX_NUM_SOURCES) and (result_search^.fsize < 200 * MEGABYTE)) or
                  ((scannode^.childcount >= MAX_NUM_SOURCES * 2) and (result_search^.fsize >= 200 * MEGABYTE)) then exit else begin
                  node_child := src^.listview.getfirstchild(scannode);
                  while (node_child <> nil) do begin
                    data_child := src^.listview.getdata(node_child);
                    if data_child^.ip_user = result_search^.ip_user then
                      if data_child^.port_user = result_search^.port_user then exit;
                    node_child := src^.listview.getnextsibling(node_child);
                  end;
                end;



              if scannode^.childcount = 0 then begin
                newnode1 := src^.listview.addchild(scannode);
                newdata1 := src^.listview.getdata(newnode1);
                with newdata1^ do begin
                  DHTLoad := nodedata^.DHTLoad;
                  bold_font := nodedata^.bold_font;
                  nickname := nodedata^.nickname;
                  filenameS := nodedata^.filenameS;
                  ip_alt := nodedata^.ip_alt;
                  ip_user := nodedata^.ip_user;
                  ip_server := nodedata^.ip_server;
                  port_user := nodedata^.port_user;
                  port_server := nodedata^.port_server;
                  hash_of_phash := nodedata^.hash_of_phash;
                  title := nodedata^.title;
                  artist := nodedata^.artist;
                  album := nodedata^.album;
                  keyword_genre := nodedata^.keyword_genre;
                  category := nodedata^.category;
                  comments := nodedata^.comments;
                  language := nodedata^.language;
                  url := nodedata^.url;
                  year := nodedata^.year;
                  fsize := nodedata^.fsize;
                  param1 := nodedata^.param1;
                  param2 := nodedata^.param2;
                  param3 := nodedata^.param3;
                  amime := nodedata^.amime;
                  being_downloaded := nodedata^.being_downloaded;
                  already_in_lib := nodedata^.already_in_lib;
                  downloaded := nodedata^.downloaded;
                end;

                nodedata^.nickname := '';
                nodedata^.ip_alt := 0;
                nodedata^.port_server := 0;
                nodedata^.ip_server := 0;
                nodedata^.ip_user := 0;
                nodedata^.port_user := 0;

                newnode2 := src^.listview.addchild(scannode);
                newdata2 := src^.listview.getdata(newnode2);
                with newdata2^ do begin
                  DHTLoad := nodedata^.DHTLoad;
                  bold_font := nodedata^.bold_font;
                  nickname := result_search^.nickname;
                  filenameS := result_search^.filenameS;
                  ip_alt := result_search^.ip_alt;
                  ip_user := result_search^.ip_user;
                  ip_server := result_search^.ip_server;
                  port_user := result_search^.port_user;
                  port_server := result_search^.port_server;
                  hash_of_phash := result_search^.hash_of_phash;
                  hash_sha1 := result_search^.hash_sha1;
                  crcsha1 := result_search^.crcsha1;
                  title := result_search^.title;
                  artist := result_search^.artist;
                  album := result_search^.album;
                  keyword_genre := result_search^.keyword_genre;
                  category := result_search^.category;
                  comments := result_search^.comments;
                  language := result_search^.language;
                  url := result_search^.url;
                  year := result_search^.year;
                  fsize := result_search^.fsize;
                  param1 := result_search^.param1;
                  param2 := result_search^.param2;
                  param3 := result_search^.param3;
                  amime := nodedata^.amime;
                  being_downloaded := nodedata^.being_downloaded;
                  already_in_lib := nodedata^.already_in_lib;
                  downloaded := nodedata^.downloaded;
                end;
              end else begin
                newnode1 := src^.listview.addchild(scannode);
                newdata1 := src^.listview.getdata(newnode1);
                with newdata1^ do begin
                  DHTLoad := nodedata^.DHTLoad;
                  bold_font := nodedata^.bold_font;
                  nickname := result_search^.nickname;
                  filenameS := result_search^.filenameS;
                  ip_alt := result_search^.ip_alt;
                  ip_user := result_search^.ip_user;
                  ip_server := result_search^.ip_server;
                  port_user := result_search^.port_user;
                  port_server := result_search^.port_server;
                  hash_of_phash := result_search^.hash_of_phash;
                  hash_sha1 := result_search^.hash_sha1;
                  crcsha1 := result_search^.crcsha1;
                  title := result_search^.title;
                  artist := result_search^.artist;
                  album := result_search^.album;
                  keyword_genre := result_search^.keyword_genre;
                  category := result_search^.category;
                  comments := result_search^.comments;
                  language := result_search^.language;
                  url := result_search^.url;
                  year := result_search^.year;
                  fsize := result_search^.fsize;
                  param1 := result_search^.param1;
                  param2 := result_search^.param2;
                  param3 := result_search^.param3;
                  amime := nodedata^.amime;
                  being_downloaded := nodedata^.being_downloaded;
                  already_in_lib := nodedata^.already_in_lib;
                  downloaded := nodedata^.downloaded;
                end;
              end;


              newdata3 := AllocMem(sizeof(record_search_result));
              with newdata3^ do begin
                DHTLoad := 0;
                nickname := result_search^.nickname;
                filenameS := result_search^.filenameS;
                ip_alt := result_search^.ip_alt;
                ip_user := result_search^.ip_user;
                ip_server := result_search^.ip_server;
                port_user := result_search^.port_user;
                port_server := result_search^.port_server;
                hash_of_phash := result_search^.hash_of_phash;
                hash_sha1 := result_search^.hash_sha1;
                crcsha1 := result_search^.crcsha1;
                title := result_search^.title;
                artist := result_search^.artist;
                album := result_search^.album;
                keyword_genre := result_search^.keyword_genre;
                category := result_search^.category;
                comments := result_search^.comments;
                language := result_search^.language;
                url := result_search^.url;
                year := result_search^.year;
                fsize := result_search^.fsize;
                param1 := result_search^.param1;
                param2 := result_search^.param2;
                param3 := result_search^.param3;
                amime := nodedata^.amime;
                being_downloaded := nodedata^.being_downloaded;
                already_in_lib := nodedata^.already_in_lib;
                downloaded := nodedata^.downloaded;
              end;
              src^.backup_results.add(newdata3);
              inc(src^.numhits);

              exit;
            end;

        scannode := src^.listview.GetNextSibling(scannode);
      end;




     // should add new rootnode
      if src^.numresults = 0 then begin
        src^.listview.canbgcolor := true;
        header_search_show(src);
        if src^.containerPanel.visible then begin
          ares_frmmain.edit_src_filter.Enabled := true;
        end;
      end;



      newnode1 := src^.listview.AddChild(nil);
      NodeData := src^.listview.GetData(newnode1);


      with nodedata^ do begin
        DHTLoad := 0;
        bold_font := ((ares_frmmain.tabs_pageview.activepage <> IDTAB_SEARCH) or (src^.containerPanel <> ares_frmmain.pagesrc.activepanel));
        artist := result_search^.artist;
        title := result_search^.title;
        album := result_search^.album;
        hash_of_phash := result_search^.hash_of_phash;
        hash_sha1 := result_search^.hash_sha1;
        crcsha1 := result_search^.crcsha1;
        already_in_lib := (is_in_lib_sha1(result_search^.hash_sha1));
        being_downloaded := (is_in_progress_sha1(result_search^.hash_sha1));
        amime := result_search^.amime;
        filenameS := result_search^.filenameS;
        nickname := result_search^.nickname;
        ip_alt := result_search^.ip_alt;
        ip_user := result_search^.ip_user;
        ip_server := result_search^.ip_server;
        port_user := result_search^.port_user;
        port_server := result_search^.port_server;

        downloaded := result_search^.downloaded;
        fsize := result_search^.fSize;
        param1 := result_search^.param1;
        param2 := result_search^.param2;
        param3 := result_search^.param3;
        keyword_genre := result_search^.keyword_genre;
        category := result_search^.category;
        comments := result_search^.comments;
        language := result_search^.language;
        year := result_search^.year;
        url := result_search^.url;
        imageindex := amime_to_imgindexsmall(result_search^.amime);
      end;

      newdata3 := AllocMem(sizeof(record_search_result));
      with newdata3^ do begin
        DHTLoad := 0;
        nickname := result_search^.nickname;
        filenameS := result_search^.filenameS;
        ip_alt := result_search^.ip_alt;
        ip_user := result_search^.ip_user;
        ip_server := result_search^.ip_server;
        port_user := result_search^.port_user;
        port_server := result_search^.port_server;
        hash_of_phash := result_search^.hash_of_phash;
        hash_sha1 := result_search^.hash_sha1;
        crcsha1 := result_search^.crcsha1;
        title := result_search^.title;
        artist := result_search^.artist;
        album := result_search^.album;
        keyword_genre := result_search^.keyword_genre;
        category := result_search^.category;
        comments := result_search^.comments;
        language := result_search^.language;
        url := result_search^.url;
        year := result_search^.year;
        fsize := result_search^.fsize;
        param1 := result_search^.param1;
        param2 := result_search^.param2;
        param3 := result_search^.param3;
        amime := nodedata^.amime;
        being_downloaded := nodedata^.being_downloaded;
        already_in_lib := nodedata^.already_in_lib;
        downloaded := nodedata^.downloaded;
      end;
      src^.backup_results.add(newdata3);

      inc(src^.numresults);
      inc(src^.numhits);

      break;
    end;


  except
  end;
end;

procedure tthread_client.send_server_update_my_nick;
begin
  if vars_global.update_my_nick then begin
    vars_global.update_my_nick := false;
    ares_sendback(nil, MSG_CLIENT_UPDATING_NICK, vars_global.mynick + CHRNULL);
  end;
end;



procedure tthread_client.send_me_channels;
begin
  if not vars_global.should_send_channel_list then exit;

  if gettickcount - last_send_me_channel < 15 * SECOND then exit;
  last_send_me_channel := gettickcount;

  vars_global.should_send_channel_list := false;

  ares_FrmMain.listview_chat_channel.clear;

  tthread_channellist.create(false);

end;

function tthread_client.ares_connected_level: integer;
begin
  result := NUM_SESSIONS_TO_SUPERNODES; //+(integer(m_is_firewalled)*2);
end;

procedure tthread_client.update_fresh_download_files;
var
  i: integer;
  nodo_ares: tares_node;
  canUpdate: boolean;
  pfile: precord_file_library;
  str, strSerial: string;
  naplist: tnapcmdlist;
begin
  if vars_global.fresh_downloaded_files = nil then exit;
  if vars_global.fresh_downloaded_files.count = 0 then exit;

  canUpdate := false;
  for i := 0 to ares_connected_nodes.count - 1 do begin
    nodo_ares := ares_connected_nodes[i];
    if not nodo_ares.ready_for_filelist then continue; //not received handler my ip yet
    if nodo_ares.ListSents < vars_Global.ShareScans then continue; //...going to send the whole list soon
    canUpdate := true;
    break;
  end;


  if not canUpdate then begin // no need to go through this  clear new entries
    while (vars_global.fresh_downloaded_files.count > 0) do begin
      pfile := vars_global.fresh_downloaded_files[vars_global.fresh_downloaded_files.count - 1];
      vars_global.fresh_downloaded_files.delete(vars_global.fresh_downloaded_files.count - 1);
      finalize_file_library_item(pfile);
      FreeMem(pfile, sizeof(record_file_library));
    end;
    FreeAndNil(vars_global.fresh_downloaded_files);
    exit;
  end;

  naplist := tnapcmdlist.create;

  while (vars_global.fresh_downloaded_files.count > 0) do begin
    pfile := vars_global.fresh_downloaded_files[0];
    vars_global.fresh_downloaded_files.delete(0);

    for i := 0 to ares_connected_nodes.count - 1 do begin
      nodo_ares := ares_connected_nodes[i];
      if not nodo_ares.ready_for_filelist then continue; //not received handler my ip yet
      if nodo_ares.ListSents < vars_Global.ShareScans then continue; //...going to send the whole list soon

      strSerial := serialize_sharedfile(naplist, pfile); //preparata da thread share , o aggiorna detail reg
      str := zcompressstr(strSerial);
      str := int_2_word_string(length(str)) +
        chr(MSG_CLIENT_COMPRESSED) +
        str;
      nodo_ares.out_buf.add(str);

    end;


    finalize_file_library_item(pfile);
    FreeMem(pfile, sizeof(record_file_library));
  end;

  naplist.free;
  FreeAndNil(vars_global.fresh_downloaded_files);


end;

procedure tthread_client.sync_GUI; // chiamato in synchronize
var
  i, h, z: integer;
  nodo_ares: tares_node;
  searchID: word;
  foundID: boolean;
  src: precord_panel_search;
begin

  try
    should_connect := ares_FrmMain.btn_opt_connect.down;
    if ((not should_connect) or
      (ares_connected_nodes.count = 0)) then vars_global.cambiato_search := true;

    my_speed := vars_global.velocita_up div 100; //in caso di relogin...
    my_queue_length := vars_global.queue_length; //invio update anche in stats

    should_avoid_exe := ares_frmmain.Check_opt_hlink_filterexe.checked;

    if should_refresh_lbl then refresh_labels;

    send_me_channels;

    update_fresh_download_files;

    if ares_connected_nodes.count = 0 then exit;

    if ares_connected_nodes.count >= ares_connected_level then update_download_hashes;

    for i := 0 to ares_connected_nodes.count - 1 do begin
      nodo_ares := ares_connected_nodes[i];
      if not nodo_ares.ready_for_filelist then continue; //not received handler my ip yet

      if nodo_ares.ListSents < vars_Global.ShareScans then begin
        ares_send_file_list(nodo_ares);
        refresh_labels;
        break;
      end;

    end;

//////////////////////////////////////// update keyword searches
    if not vars_global.cambiato_search then exit;

    if ares_connected_nodes.count >= ares_connected_level then vars_global.cambiato_search := false;

    for z := 0 to ares_connected_nodes.count - 1 do begin
      nodo_ares := ares_connected_nodes[z];
      with nodo_ares do begin
        if searchIDs = nil then continue;

        i := 0;
        while (i < searchIDS.count) do begin              //anything to remove?
          SearchID := chars_2_word(searchIDS.strings[i]);
          foundId := false;
          for h := 0 to src_panel_list.count - 1 do begin
            src := src_panel_list[h];
            if src^.searchID = searchid then begin
              foundID := (src^.started <> 0);
              break;
            end;
          end;
          if not foundID then begin
            ares_sendback(nodo_ares, MSG_CLIENT_ENDOFSEARCH, searchIDS.strings[i]);
            searchIDs.delete(i);
            if searchIDs.count = 0 then begin
              FreeAndNil(searchIDs);
              break;
            end;
          end else inc(i);
        end;
      end;
    end;

    for h := 0 to src_panel_list.count - 1 do begin
      src := src_panel_list[h];
      if src^.started = 0 then continue;

      for z := 0 to ares_connected_nodes.count - 1 do begin
        nodo_ares := ares_connected_nodes[z];

        if nodo_ares.searchIDs = nil then nodo_ares.searchIDs := tmystringlist.create;

        if nodo_ares.searchIDS.indexof(int_2_word_string(src^.searchID)) = -1 then begin
          nodo_ares.searchIDs.add(int_2_word_string(src^.searchID));
          ares_sendback(nodo_ares, MSG_CLIENT_ADD_SEARCH_NEW, keywfunc.get_search_packet(src));
         //ares_send_search(nodo_ares,src);
        end;

      end;
    end;

  except
  end;
end;









procedure tthread_client.handler_login_ok(nodo_ares: tares_node); //synch
begin

  try
 //us:=chars_2_dword(copy(content,1,4));
 //fi:=chars_2_dword(copy(content,5,4));
 //gi:=chars_2_dword(copy(content,9,4));
    nodo_Ares.logtime := Tempo;


    if ares_connected_nodes.count > ares_connected_level then begin //non in eccesso
      nodo_ares.state := sessDisconnected; //disconnect in receive loop
      exit;
    end else
      if ares_connected_nodes.count = ares_connected_level then begin
        ares_Doidle_in_connecting;
      end;


    if logontime = 0 then logontime := gettickcount;

    ip_per_synch := nodo_ares.host; //per sinchronizes vari
    port_per_synch := nodo_ares.port;
    synchronize(handler_login_ok); //e mette logon_time
    synchronize(handler_stats);



    nodo_ares.last_out_stats := 0; //next stats after a minute

  except
  end;
end;




procedure tthread_client.handler_stats(nodo_ares: tares_node);
var
  host: string;
  port: word;
  added: integer;
begin
//us:=chars_2_dword(copy(content,1,4));
//fi:=chars_2_dword(copy(content,5,4));
//gi:=chars_2_dword(copy(content,9,4));

  nodo_ares.last := tempo; //timeout inactivity

  synchronize(handler_stats);

  exit; //DEBUG

  delete(content, 1, 12);

  added := 0;
  while (length(content) >= 6) do begin
    host := ipint_to_dotstring(chars_2_dword(copy(content, 1, 4)));
    port := chars_2_word(copy(content, 5, 2));
    delete(content, 1, 6);
    aresnodes_addreported(host, port, ares_aval_nodes);
    inc(added);
    if added >= 2 then break;
  end;

end;



procedure tthread_client.handler_stats; //synchro
var
  stringa_sharing: widestring;
  condivisi: integer;
begin

  if stringa_nickname = '' then exit; //all'inizio risparmiamo doppio refresh

  condivisi := vars_global.my_shared_count; //impostato da apri general library view

  stringa_sharing := ', ' + GetLangStringW(STR_SHARING) + ' ' + format_currency(condivisi) + ' ' + GetLangStringW(STR_FILES) + '  ';

  ares_FrmMain.lbl_opt_statusconn.caption := stringa_nickname + stringa_sharing;
end;



procedure tthread_client.ares_send_file_list(nodo_ares: tares_node); // ogni 10 secondi in synch...50 files
var
  i: integer;
  pfile: precord_file_library;
  str_cmds, str_out_cpr: string;
//condivisi:cardinal;
  naplist: tnapcmdlist;
  num_sent: integer;
begin
  try

    if nodo_ares.EverSentFilelist then begin //unshare ALL first...
      ares_sendback_node(nodo_ares, MSG_CLIENT_REMOVING_SHARED, '');
    end;


//condivisi:=0;
    naplist := tnapcmdlist.create;

    if vars_global.lista_shared.count > thread_supernode.MAX_FILES_SHARED_PERUSER then begin
      if (random($FFFF) mod 2) = 1 then vars_global.lista_shared.sort(ordina_per_size)
      else shuffle_Mylist(vars_global.lista_shared, 0);
    end;


    str_cmds := '';
    num_sent := 0;

    for i := 0 to vars_global.lista_shared.count - 1 do begin
      try
        pfile := vars_global.lista_shared[i];

        if not pfile^.shared then continue;
        if pfile^.previewing then continue; //not yet hashed
        if pfile^.corrupt then continue; //corrupted deprecated code
        if pfile^.fsize = 0 then continue;
        if length(pfile^.title) < 2 then continue;
        if length(pfile^.title) > MAX_LENGTH_TITLE then continue;

        if pfile^.amime = ARES_MIME_IMAGE then begin
          if pos(STR_ALBUMART, lowercase(pfile^.title)) <> 0 then continue; //unsearchable stuff
        end;

        if pfile^.amime = ARES_MIME_MP3 then if pos(pfile^.ext, STR_DRM_EXT) <> 0 then continue;

    // inc(condivisi);

        str_cmds := str_cmds +
          serialize_sharedfile(naplist, pfile); //preparata da thread share , o aggiorna detail reg

        if length(str_cmds) > 800 then begin //attenzione era 3500...quindi non accorciare buffer ricezione...
          str_out_cpr := zcompressstr(str_cmds);
          str_out_cpr := int_2_word_string(length(str_out_cpr)) +
            chr(MSG_CLIENT_COMPRESSED) +
            str_out_cpr;
          nodo_ares.out_buf.add(str_out_cpr);
          str_cmds := '';
        end;

        inc(num_sent);
        if num_sent >= thread_supernode.MAX_FILES_SHARED_PERUSER then break;

      except
      end;
    end;


    try
      if length(str_cmds) > 0 then begin //ho terminato i files da inviare, ma non avevo compilato ultimi <3500
        str_out_cpr := zcompressstr(str_cmds);
        str_out_cpr := int_2_word_string(length(str_out_cpr)) +
          chr(MSG_CLIENT_COMPRESSED) +
          str_out_cpr;
        nodo_ares.out_buf.add(str_out_cpr);
      end;
    except
    end;

    inc(nodo_ares.ListSents);
    inc(nodo_ares.HistSentFilelists);

    nodo_ares.EverSentFilelist := true;

    naplist.free;

    should_refresh_lbl := true;
  except
  end;

end;

procedure tthread_client.ares_disconnect;
var
  nodo_ares: tares_node;
begin
  if ares_disconnected then exit;

  mysupernodes.mysupernodes_clear;

  while (ares_connected_nodes.count > 0) do begin //cancelliamoli del tutto, meglio riciclo...
    nodo_ares := ares_connected_nodes[ares_connected_nodes.count - 1];
    nodo_ares.last_attempt := DelphiDateTimetoUnix(now) - MIN_SUPERNODE_RECONNECT_INTERVAL; // reconnect immediately
    aresnodes_putConnected(nodo_ares, ares_aval_nodes);
    aresnodes_putDisconnected(nodo_ares, ares_aval_nodes);
    ares_connected_nodes.delete(ares_connected_nodes.count - 1);
  end;
  ares_doIdle_in_connecting;

  ares_disconnected := true;
  synchronize(log_not_connected);
end;



end.

