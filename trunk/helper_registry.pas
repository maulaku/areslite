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
everything related to registry save/load of settings
}

unit helper_registry;

interface

uses
  windows, classes2, classes, registry, const_ares, helper_strings,
  helper_unicode, sysutils, utility_ares, vars_global, forms, ares_types,
  helper_gui_misc, activex, blcksock;

function reg_bannato(const ip: string): boolean;
function prendi_porta_server(reg: tregistry): word;
function prendi_mynick(reg: tregistry): string;
function prendi_my_pgui(reg: tregistry): string;
procedure write_default_upload_height;
function get_default_upload_height(maxHeight: integer): integer;
function reg_get_avgUptime: integer;
function prendi_cant_supernode: boolean; //non possiamo, true se non possiamo
function prendi_reg_my_shared_folder(const data_path: widestring): widestring;
function regGetMyTorrentFolder(const sharedFolder: widestring): widestring;

procedure stats_maxspeed_write;
procedure stats_uptime_write(start_time: cardinal; totminuptime: cardinal);
procedure prendi_prefs_reg;
procedure set_reginteger(const vname: string; value: integer);
procedure set_regstring(const vname: string; const value: string);
procedure reg_toggle_autostart;
procedure mainGui_initprefpanel;
function get_reginteger(const vname: string; defaultv: integer): integer;
function get_regstring(const vname: string): string;

procedure reg_get_transpeed(reg: tregistry; var UpI: cardinal; var DnI: cardinal);
procedure reg_get_megasent(reg: tregistry; var MUp: integer; var MDn: integer);
procedure reg_get_totuptime(reg: tregistry; var tot: cardinal);
procedure reg_zero_avg_uptime(reg: tregistry);
procedure reg_get_first_rundate(reg: tregistry; var frdate: cardinal);
function reg_getever_configured_share: boolean;
function reg_check_agelast_chatlist: boolean;
function reg_ChatGetBindIp: string;
function reg_needs_fresh_HomePage: boolean;
function reg_wants_chatautofavorites: boolean;
procedure reg_save_chatfav_height;

procedure reg_SetDHT_ID;
procedure reg_GetDHT_ID;

function reg_justInstalled: boolean;

implementation

uses
  ufrmmain, helper_hashlinks, vars_localiz, helper_crypt,
  helper_datetime, helper_combos, helper_diskio, helper_chatroom_share,
  const_timeouts, int128;

function reg_justInstalled: boolean;
var
  reg: TRegistry;
begin
  result := false;

  reg := Tregistry.create;
  with reg do begin
    openkey(areskey, true);

    if not valueExists('General.JustInstalled') then begin
      closekey;
      destroy;
      exit;
    end;

    result := true;
    deleteValue('General.JustInstalled');
    closekey;
    destroy;
  end;

end;

procedure reg_GetDHT_ID;
var
  reg: tregistry;
  buffer: array[0..15] of byte;
begin

  reg := Tregistry.create;
  with reg do begin
    openkey(areskey, true);
    if not valueexists('Network.DHTID') then begin
      closekey;
      destroy;
      exit;
    end;
    if GetDataSize('Network.DHTID') <> 16 then begin
      closekey;
      destroy;
      exit;
    end;

    if ReadBinaryData('Network.DHTID', buffer, sizeof(buffer)) <> 16 then begin
      closekey;
      destroy;
      exit;
    end;

    CU_INT128_CopyFromBuffer(@buffer[0], @DHTMe);
    closekey;
    destroy;
  end;

end;

procedure reg_SetDHT_ID;
var
  reg: tregistry;
  buffer: array[0..15] of byte;
begin

  int128.CU_INT128_CopyToBuffer(@DHTme, @buffer[0]);

  reg := Tregistry.create;
  with reg do begin
    openkey(areskey, true);
    WriteBinaryData('Network.DHTID', buffer, sizeof(buffer));
    closekey;
    destroy;
  end;
end;

procedure reg_save_chatfav_height;
var
  reg: tregistry;
begin
  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);
    writeinteger('ChatRoom.PanelFavHeight', vars_global.chat_favorite_height);
    closekey;
    destroy;
  end;
end;

function reg_wants_chatautofavorites: boolean;
var
  reg: tregistry;
begin
  result := true;

  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);
    if valueexists('ChatRoom.AutoAddToFavorites') then result := (readinteger('ChatRoom.AutoAddToFavorites') <> 0);
    closekey;
    destroy;
  end;
end;

function reg_needs_fresh_HomePage: boolean;
var
  reg: tregistry;
begin
  result := true;

  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);
    if valueexists('Browser.LastHomePage') then begin
      if DelphiDateTimeToUnix(now) - readinteger('Browser.LastHomePage') < 604800 then result := false;
    end;
    closekey;
    destroy;
  end;

end;

function reg_ChatGetBindIp: string;
var
  reg: tregistry;
begin
  result := cAnyHost;

  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);
    if valueexists('ChatRoom.BindAddr') then
      result := readstring('ChatRoom.BindAddr');
    closekey;
    destroy;
  end;

end;

function reg_check_agelast_chatlist: boolean;
var
  reg: tregistry;
  last: cardinal;
begin
  result := false;

  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);
    if valueexists('ChatRoom.LastList') then begin
      last := readinteger('ChatRoom.LastList');
      if DelphiDateTimeToUnix(now) - last < cardinal(172800) then result := true; // max 2 days of age
    end;
    closekey;
    destroy;
  end;

end;

function reg_getever_configured_share: boolean;
var
  reg: tregistry;
begin
  result := false;

  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);
    if valueexists('Share.EverConfigured') then result := (readinteger('Share.EverConfigured') = 1);
    closekey;
    destroy;
  end;

end;

function get_reginteger(const vname: string; defaultv: integer): integer;
var
  reg: tregistry;
begin

  result := defaultv;

  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);

    if valueexists(vname) then result := readinteger(vname);

    closekey;
    destroy;
  end;

end;

function get_regstring(const vname: string): string;
var
  reg: tregistry;
begin
  result := '';


  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);

    if valueexists(vname) then result := readstring(vname);

    closekey;
    destroy;
  end;

end;

procedure mainGui_initprefpanel;
var
  reg: tregistry;
  temp_port: integer;
begin

  mainGui_enumlangs;
  ares_frmmain.lbl_opt_homepage.caption := 'Web: ' + const_ares.STR_DEFAULT_WEBSITE;

//GENERAL////////////////////////////////
  reg := tregistry.create;
  with reg do begin
    rootkey := HKEY_CURRENT_USER;
    openkey(areskey, true);
    with ares_frmmain do begin
 //personal details
      edit_opt_gen_nick.text := utf8strtowidestr(hexstr_to_bytestr(readstring('Personal.Nickname')));
      combo_opt_gen_speed.itemindex := bytesec_to_napspeed(vars_global.velocita_up_dec);

      if valueexists('General.AutoStartUP') then begin
        check_opt_gen_autostart.checked := (readinteger('General.AutoStartUp') = 1);
      end else check_opt_gen_autostart.checked := true;

      if valueexists('General.AutoConnect') then begin
        check_opt_gen_autoconnect.checked := (readinteger('General.AutoConnect') = 1);
      end else check_opt_gen_autoconnect.checked := true;

      if valueexists('General.MSNSongNotif') then begin
        check_opt_gen_msnsong.checked := (readinteger('General.MSNSongNotif') = 1);
      end else check_opt_gen_msnsong.checked := true;

      if reg.valueexists('General.CloseOnQuery') then begin
        check_opt_gen_gclose.checked := (reg.readinteger('General.CloseOnQuery') = 1);
      end else check_opt_gen_gclose.checked := false;

      if reg.valueExists('Extra.WarnOnCancelDL') then begin
        check_opt_tran_warncanc.checked := (reg.readinteger('Extra.WarnOnCancelDL') <> 0);
      end else check_opt_tran_warncanc.checked := false;


      if reg.valueexists('Extra.ShowActiveCaption') then begin
        check_opt_gen_capt.checked := (reg.readinteger('Extra.ShowActiveCaption') = 1);
      end else check_opt_gen_capt.checked := true;

      if reg.valueexists('Extra.ShowTransferPercent') then begin
        check_opt_tran_perc.checked := (reg.readinteger('Extra.ShowTransferPercent') = 1);
      end else check_opt_tran_perc.checked := false;

      if reg.valueExists('Extra.PauseVideoOnLeave') then begin
        check_opt_gen_pausevid.checked := (reg.readinteger('Extra.PauseVideoOnLeave') = 1);
      end else check_opt_gen_pausevid.checked := false;

      if reg.valueexists('Extra.BlockHints') then begin
        check_opt_gen_nohint.checked := (reg.readinteger('Extra.BlockHints') = 1);
      end else check_opt_gen_nohint.checked := false;


 //share folder
      edit_opt_tran_shfolder.text := vars_global.myshared_folder;
      edit_opt_bittorrent_dlfolder.text := vars_global.my_torrentFolder;
      getfreedrivespace;

  //TRANSFER////////////////////////////////////
      Edit_opt_tran_port.text := inttostr(vars_global.myport);
      updown1.position := vars_global.limite_upload;
      updown2.position := vars_global.max_ul_per_ip;
      updown3.position := vars_global.max_dl_allowed;
      Edit_opt_tran_upband.text := inttostr(vars_global.up_band_allow);

      if reg.valueexists('Transfer.MaximizeUpBandOnIdle') then begin
        check_opt_tran_inconidle.checked := (reg.readinteger('Transfer.MaximizeUpBandOnIdle') <> 0);
      end else check_opt_tran_inconidle.checked := true;

      Edit_opt_tran_dnband.text := inttostr(vars_global.down_band_allow);


  //chatroom ->chat
  //CHAT//////////////////////////////////////////

      if reg.valueexists('ChatRoom.LastDCHost') then edit_opt_chat_connect.text := reg.readstring('ChatRoom.LastDCHost');

      if valueexists('ChatRoom.ShowTimeLog') then begin
        Check_opt_chat_time.checked := (readinteger('ChatRoom.ShowTimeLog') = 1);
      end else Check_opt_chat_time.checked := false;

      if valueexists('ChatRoom.AutoAddToFavorites') then begin
        Check_opt_chat_autoadd.checked := (readinteger('ChatRoom.AutoAddToFavorites') = 1);
      end else Check_opt_chat_autoadd.checked := true;

      if valueexists('ChatRoom.ShowJP') then begin //channel join part
        check_opt_chat_joinpart.checked := (readinteger('ChatRoom.ShowJP') = 1);
      end else check_opt_chat_joinpart.checked := true;

      if valueExists('ChatRoom.ShowTaskBtn') then begin
        check_opt_chat_taskbtn.checked := (readinteger('ChatRoom.ShowTaskBtn') = 1);
      end else check_opt_chat_taskbtn.checked := true;

      btn_opt_chat_font.font.name := vars_global.font_chat.name;
      btn_opt_chat_font.font.size := vars_global.font_chat.size;
      fontdialog1.font.name := vars_global.font_chat.name;
      fontdialog1.font.size := vars_global.font_chat.size;

  //chat->pvt
      if reg.valueexists('PrivateMessage.BlockAll') then begin
        Check_opt_chat_nopm.checked := (reg.readinteger('PrivateMessage.BlockAll') = 1);
      end else Check_opt_chat_nopm.checked := false;

      if reg.valueexists('ChatRoom.BlockPM') then begin
        Check_opt_chatRoom_nopm.checked := (reg.readinteger('ChatRoom.BlockPM') = 1);
      end else Check_opt_chatRoom_nopm.checked := false;

      if reg.valueexists('ChatRoom.BlockEmotes') then begin
        check_opt_chat_noemotes.checked := (reg.readinteger('ChatRoom.BlockEmotes') = 1);
      end else check_opt_chat_noemotes.checked := false;

      if reg.ValueExists('ChatRoom.AutoClose') then begin
        check_opt_chat_autocloseroom.checked := (reg.readinteger('ChatRoom.AutoClose') = 1);
      end else check_opt_chat_autocloseroom.checked := true;

      if reg.valueexists('PrivateMessage.AllowBrowse') then begin
        check_opt_chat_browsable.checked := (reg.readinteger('PrivateMessage.AllowBrowse') = 1);
      end else check_opt_chat_browsable.checked := true;

      if reg.valueexists('Privacy.SendRegularPath') then begin
        check_opt_chat_realbrowse.checked := (reg.readinteger('Privacy.SendRegularPath') <> 0)
      end else check_opt_chat_realbrowse.checked := true; //di default ok
      check_opt_chat_realbrowse.enabled := check_opt_chat_browsable.checked; //not enabled per dementi

      if reg.valueExists('PrivateMessage.SetAway') then begin
        check_opt_chat_isaway.checked := (reg.readinteger('PrivateMessage.SetAway') = 1);
      end else check_opt_chat_isaway.checked := false;

      memo_opt_chat_away.enabled := Check_opt_chat_isaway.checked;
      memo_opt_chat_away.text := utf8strtowidestr(hexstr_to_bytestr(readstring('PrivateMessage.AwayMessage')));
      if length(memo_opt_chat_away.text) < 1 then memo_opt_chat_away.text := STR_DEFAULT_AWAYMSG;


  //connection
      if valueexists('Network.NoSupernode') then begin
        check_opt_net_nosprnode.checked := (readinteger('Network.NoSupernode') = 1);
      end else check_opt_net_nosprnode.checked := false;


  //proxy
      if vars_global.socks_ip <> '' then Edit_opt_proxy_addr.text := vars_global.socks_ip + ':' + inttostr(vars_global.socks_port)
      else Edit_opt_proxy_addr.text := '';
      edit_opt_proxy_login.text := utf8strtowidestr(vars_global.socks_username);
      edit_opt_proxy_pass.text := utf8strtowidestr(vars_global.socks_password);

      if vars_global.socks_type = SoctNone then radiobtn_noproxy.checked := true else
        if vars_global.socks_type = SoctSock4 then radiobtn_proxy4.checked := true else
          radiobtn_proxy5.checked := true;


  //search
      if valueexists('Search.BlockExe') then begin
        Check_opt_hlink_filterexe.checked := (readinteger('Search.BlockExe') = 1);
      end else Check_opt_hlink_filterexe.checked := false;

    end; //with ares_frmmain

    closekey;
    destroy;
  end;

end;


procedure reg_toggle_autostart;
var
  reg: tregistry;
begin
  reg := tregistry.create;

  with reg do begin
    openkey(areskey, true);
    writeinteger('General.AutoStartUp', integer(ares_frmmain.check_opt_gen_autostart.checked));
    closekey;



    if ares_frmmain.check_opt_gen_autostart.checked then begin
      openkey('Software\Microsoft\Windows\CurrentVersion\Run', true);
      writestring(lowercase(appname), '"' + application.exename + '" -h');
      CloseKey;
    end else begin
      try
        rootkey := HKEY_LOCAL_MACHINE; //rimuoviamo anche root, per utenti di prima
        if openkey('Software\Microsoft\Windows\CurrentVersion\Run', false) then begin
          try
            deletevalue(lowercase(appname));
          except
          end;
          CloseKey;
        end;
      except
      end;

      try
        rootkey := HKEY_CURRENT_USER;
        openkey('Software\Microsoft\Windows\CurrentVersion\Run', true);
        deletevalue(lowercase(appname));
        CloseKey;
      except
      end;

    end;

    destroy;
  end;

end;

procedure set_regstring(const vname: string; const value: string);
var
  reg: tregistry;
begin
  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);
    writestring(vname, value);
    closekey;
    destroy;
  end;
end;

procedure set_reginteger(const vname: string; value: integer);
var
  reg: tregistry;
begin
  reg := tregistry.create;
  with reg do begin
    try
      openkey(areskey, true);
      writeinteger(vname, value);
      closekey;
    except
    end;
    destroy;
  end;
end;




procedure prendi_prefs_reg;
var
  reg: tregistry;
begin


  muptime := reg_get_avgUptime;

  reg := tregistry.create;

  check_hashlink_associations(reg);
  check_bittorrent_association(reg);
  check_pls_association(reg);
  try

    reg.rootkey := HKEY_CURRENT_USER;

    with reg do begin
      openkey(areskey, true);


      if valueexists('General.AutoStartUp') then begin //autostartup?
        if readinteger('General.AutoStartUp') = 1 then begin
          closekey;
          openkey('Software\Microsoft\Windows\CurrentVersion\Run', true);
          writestring(lowercase(appname), '"' + application.exename + '" -h');
          CloseKey;
          openkey(areskey, true);
        end;
      end else begin
        closekey;
        openkey('Software\Microsoft\Windows\CurrentVersion\Run', true);
        writestring(lowercase(appname), '"' + application.exename + '" -h');
        CloseKey;
        openkey(areskey, true);
      end;
    end;

    check_magnet_association(reg);

    with reg do begin

      if valueexists('Proxy.Protocol') then begin
        if readinteger('Proxy.Protocol') = 5 then socks_type := SoctSock5 else
          if readinteger('Proxy.Protocol') = 4 then socks_type := SoctSock4 else
            socks_type := SoctNone;
      end else socks_type := SoctNone;

      socks_username := hexstr_to_bytestr(readstring('Proxy.Username'));
      socks_password := hexstr_to_bytestr(readstring('Proxy.Password'));

      socks_ip := readstring('Proxy.Addr');

      if valueexists('Proxy.Port') then begin
        socks_port := readinteger('Proxy.Port');
      end else socks_port := 1080;

      if valueexists('Upload.AutoClearIdle') then begin //default autoclear Idle=true
        ares_frmmain.clearidle1.checked := (readinteger('Upload.AutoClearIdle') = 1);
      end else ares_frmmain.clearidle1.checked := true;

      writeinteger('Stats.HasLQCa', 0); //sblocco eventuale richiesta di un cache root...
      writeinteger('Stats.LstCaQueryInt', MIN_INTERVAL_QUERY_CACHE_ROOT); //minimum amount of time between queries
      writeinteger('Stats.LstCaQuery', 0); //reset antiflood on gwebcache


      if valueexists('Playlist.Repeat') then begin
        ares_frmmain.playlist_Continuosplay1.checked := (readinteger('Playlist.Repeat') = 1);
      end else ares_frmmain.playlist_Continuosplay1.checked := false;

      if valueexists('Playlist.Shuffle') then begin
        ares_frmmain.playlist_Randomplay1.checked := (readinteger('Playlist.Shuffle') = 1);
      end else ares_frmmain.playlist_Randomplay1.checked := false;


      if valueexists('General.LastLibraryMode') then begin
        if readinteger('General.LastLibraryMode') = 1 then begin
          ares_frmmain.btn_lib_regular_view.down := true;
          ares_frmmain.btn_lib_virtual_view.down := false;
        end else begin
          ares_frmmain.btn_lib_regular_view.down := false;
          ares_frmmain.btn_lib_virtual_view.down := true;
        end;
      end else begin
        ares_frmmain.btn_lib_regular_view.down := false;
        ares_frmmain.btn_lib_virtual_view.down := true;
      end;

      if valueexists('Connections.MaxDlOutgoing') then MAX_OUTCONNECTIONS := reg.readinteger('Connections.MaxDlOutgoing')
      else MAX_OUTCONNECTIONS := 25;

      if valueexists('Hashing.Priority') then hash_throttle := readinteger('Hashing.Priority')
      else hash_throttle := 1; //default highest -1
      ares_frmmain.hash_pri_trx.position := 5 - hash_throttle;
    end;

    hash_update_GUIpry;

    with reg do begin

      if valueexists('Libray.ShowDetails') then begin
        ares_frmmain.btn_lib_toggle_details.down := (readinteger('Libray.ShowDetails') = 1); //should show details in library?
      end else begin
        ares_frmmain.btn_lib_toggle_details.down := false;
      end;

      if valueexists('Transfer.QueueFirstInFirstOut') then begin
        queue_firstinfirstout := (readinteger('Transfer.QueueFirstInFirstOut') = 1);
      end else queue_firstinfirstout := false;

      if valueexists('Transfer.MaxDLCount') then begin
        max_dl_allowed := readinteger('Transfer.MaxDLCount');
        if max_dl_allowed = 0 then max_dl_allowed := 10; //MAXNUM_ACTIVE_DOWNLOADS;
        if max_dl_allowed > MAXNUM_ACTIVE_DOWNLOADS then max_dl_allowed := MAXNUM_ACTIVE_DOWNLOADS;
      end else max_dl_allowed := 10;
      ares_frmmain.UpDown3.max := MAXNUM_ACTIVE_DOWNLOADS;
      ares_frmmain.UpDown3.position := max_dl_allowed;
      ares_frmmain.Edit_opt_tran_limdn.text := inttostr(max_dl_allowed);
      ares_frmmain.Edit_opt_tran_limdn.OnChange := ufrmmain.ares_frmmain.Edit_opt_tran_limdnChange;

      if valueexists('GUI.FoldersWidth') then panel6sizedefault := readinteger('GUI.FoldersWidth');
      if panel6sizedefault < 50 then panel6sizedefault := 50;

      if valueexists('GUI.ChatRoomWidth') then default_width_chat := readinteger('GUI.ChatRoomWidth');
      if default_width_chat < 100 then default_width_chat := 100;


      if valueexists('Transfer.AllowedUpBand') then up_band_allow := readinteger('Transfer.AllowedUpBand');
      if valueexists('Transfer.AllowedDownBand') then down_band_allow := readinteger('Transfer.AllowedDownBand');
      if up_band_allow > 65535 then up_band_allow := 0;
      if down_band_allow > 65535 then down_band_allow := 0;

      if valueexists('General.AutoConnect') then begin
        if readinteger('General.AutoConnect') = 0 then begin
          ares_frmmain.btn_opt_connect.down := false;
          ares_frmmain.btn_opt_disconnect.down := true;
          ares_frmmain.lbl_opt_statusconn.caption := ' ' + GetLangStringW(STR_NOT_CONNECTED);
        end else begin
          ares_frmmain.btn_opt_disconnect.down := false;
          ares_frmmain.btn_opt_connect.down := true;
          ares_frmmain.lbl_opt_statusconn.caption := ' ' + GetLangStringW(STR_CONNECTING_TO_NETWORK);
        end;
      end else begin
        ares_frmmain.btn_opt_disconnect.down := false;
        ares_frmmain.btn_opt_connect.down := true;
        ares_frmmain.lbl_opt_statusconn.caption := ' ' + GetLangStringW(STR_CONNECTING_TO_NETWORK);
      end;

      reg_get_transpeed(reg, velocita_up, velocita_down);

      reg_get_megasent(reg, mega_uploaded, mega_downloaded);



      if valueexists('Personal.ConnectionType') then begin
        velocita_up_dec := readinteger('Personal.ConnectionType');
      end else velocita_up_dec := 0;
    end;


    mypgui := prendi_my_pgui(reg);


    with reg do begin
      if valueexists('Transfer.MaxUpPerUser') then begin
        max_ul_per_ip := ReadInteger('Transfer.MaxUpPerUser');
        if max_ul_per_ip > 10 then max_ul_per_ip := 10;
      end else max_ul_per_ip := 3;
      ares_frmmain.updown2.max := 10;
      ares_frmmain.updown2.position := vars_global.max_ul_per_ip;
      ares_frmmain.Edit_opt_tran_upip.text := inttostr(max_ul_per_ip);
      ares_frmmain.Edit_opt_tran_upip.onchange := ufrmmain.ares_frmmain.Edit_opt_tran_upipChange;

      if valueexists('Transfer.MaxUpCount') then begin
        limite_upload := ReadInteger('Transfer.MaxUpCount');
        if limite_upload > 25 then limite_upload := 25;
      end else limite_upload := 6;
      ares_frmmain.updown1.max := 25;
      ares_frmmain.updown1.position := vars_global.limite_upload;
      ares_frmmain.Edit_opt_tran_limup.text := inttostr(limite_upload);
      ares_frmmain.Edit_opt_tran_limup.onchange := ufrmmain.ares_frmmain.Edit_opt_tran_limupChange;
    end;

    mynick := prendi_mynick(reg);



    myport := prendi_porta_server(reg);
    if myport = 0 then myport := random(60000) + 5000;


    with reg do begin
      deletekey('banned'); //per chat

      reg_get_totuptime(reg, program_totminuptime);
      reg_get_first_rundate(reg, program_first_day);

      if program_totminuptime * 59 > delphidatetimetounix(now) - program_first_day then begin
        program_totminuptime := 0;
      end;

      if not valueexists(REG_STR_STATS_AVGUPTIME) then reg_zero_avg_uptime(reg); ;



      writestring('GUI.LastLibrary', '');
      writestring('GUI.LastSearch', '');
      writestring('GUI.LastPMBrowse', '');
      writestring('GUI.LastChatRoomBrowse', '');

      closekey;
    end;


  except
  end;
  reg.destroy;

end;

procedure reg_get_first_rundate(reg: tregistry; var frdate: cardinal);
var
  str: string;
  num: cardinal;
  lenred: integer;
  buffer: array[0..10] of char;
begin

  try

    with reg do begin

      if not valueexists(REG_STR_STATS_FIRSTDAY) then begin //missing
        num := delphidatetimetounix(now);
        str := chr(random(255)) +
          int_2_dword_string(num) +
          CHRNULL +
          chr(random(255)) +
          int_2_word_string(wh(int_2_dword_string(num)) + 12);

        str := e64(e67(str, 7193) + CHRNULL, 24884);
        move(str[1], buffer, length(str));
        writebinarydata(REG_STR_STATS_FIRSTDAY, buffer, length(str)); //update average uptime

        frdate := delphidatetimetounix(now);
      end else begin
        lenred := readbinarydata(REG_STR_STATS_FIRSTDAY, buffer, 10);
        if lenred = 10 then begin
          setlength(str, lenred);
          move(buffer, str[1], lenred);
          str := d67(d64(str, 24884), 7193);
          delete(str, 1, 1); //remove random char 2047+
          if ((str[5] = CHRNULL) and (chars_2_word(copy(str, 7, 2)) = word(wh(copy(str, 1, 4)) + 12))) then begin
            frdate := chars_2_dword(copy(str, 1, 4));

          end else begin
            frdate := 0;

          end;
        end else frdate := 0;

        if ((frdate > delphidatetimetounix(now)) or (frdate = 0)) then begin //crack
          frdate := delphidatetimetounix(now);
          str := chr(random(255)) +
            int_2_dword_string(frdate) +
            CHRNULL +
            chr(random(255)) +
            int_2_word_string(wh(int_2_dword_string(frdate)) + 12);
          str := e64(e67(str, 7193) + CHRNULL, 24884);
          move(str[1], buffer, length(str));
          writebinarydata(REG_STR_STATS_FIRSTDAY, buffer, length(str)); //update average uptime
        end;

      end;


    end;

  except
    frdate := delphidatetimetounix(now);
  end;



end;

procedure reg_get_totuptime(reg: tregistry; var tot: cardinal);
var
  str: string;
  lenred: integer;
  buffer: array[0..10] of char;
begin
  try

    with reg do begin
      if valueexists(REG_STR_STATS_TOTUPTIME) then begin
        lenred := readbinarydata(REG_STR_STATS_TOTUPTIME, buffer, 10);
        if lenred = 10 then begin
          setlength(str, lenred);
          move(buffer, str[1], lenred);
          str := d67(d64(str, 65284), 16793);
          delete(str, 1, 1); //remove random char 2047+
          if ((str[5] = CHRNULL) and (chars_2_word(copy(str, 7, 2)) = word(wh(copy(str, 1, 4)) + 14))) then begin
            tot := chars_2_dword(copy(str, 1, 4));

          end else begin
            tot := 0;

          end;
        end else tot := 0;
      end else tot := 0;
    end;

  except
    tot := 0;
  end;
end;

procedure reg_zero_avg_uptime(reg: tregistry);
var
  str: string;
  buffer: array[0..10] of char;
begin
  with reg do begin
    str := chr(random(255)) +
      int_2_dword_string(0) +
      CHRNULL +
      chr(random(255)) +
      int_2_word_string(wh(int_2_dword_string(0)) + 17);

    str := e64(e67(str, 6793) + CHRNULL, 44284);
    move(str[1], buffer, length(str));
    writebinarydata(REG_STR_STATS_AVGUPTIME, buffer, length(str)); //update average uptime
  end;
end;

procedure stats_uptime_write(start_time: cardinal; totminuptime: cardinal);
var
  reg: tregistry;
  minutes_this_session, actual_average: integer;
  num: cardinal;
  str: string;
  lenred: integer;
  buffer: array[0..10] of char;
begin
  reg := tregistry.create;
  with reg do begin
    try
      openkey(areskey, true);
      minutes_this_session := (gettickcount - start_time) div 60000;


      if valueexists(REG_STR_STATS_AVGUPTIME) then begin //get average uptime
        lenred := readbinarydata(REG_STR_STATS_AVGUPTIME, buffer, 10);
        if lenred = 10 then begin
          setlength(str, lenred);
          move(buffer, str[1], lenred);
          str := d67(d64(str, 44284), 6793);
          delete(str, 1, 1); //remove random char 2047+
          if ((str[5] = CHRNULL) and (chars_2_word(copy(str, 7, 2)) = word(wh(copy(str, 1, 4)) + 17))) then begin
            actual_average := chars_2_dword(copy(str, 1, 4));

          end else begin
            actual_average := 0;

          end;
        end else actual_average := 0;
      end else actual_average := 0;

      num := ((actual_average div 5) * 4) + (minutes_this_session div 5); //smoth

      str := chr(random(255)) +
        int_2_dword_string(num) +
        CHRNULL +
        chr(random(255)) +
        int_2_word_string(wh(int_2_dword_string(num)) + 17);

      str := e64(e67(str, 6793) + CHRNULL, 44284);
      move(str[1], buffer, length(str));
      writebinarydata(REG_STR_STATS_AVGUPTIME, buffer, length(str)); //update average uptime




      num := totminuptime + minutes_this_session; //write minutes online!
      str := chr(random(255)) + //now store to registry
        int_2_dword_string(num) +
        CHRNULL +
        chr(random(255)) +
        int_2_word_string(wh(int_2_dword_string(num)) + 14);

      str := e64(e67(str, 16793) + CHRNULL, 65284);
      move(str[1], buffer, length(str));
      writebinarydata(REG_STR_STATS_TOTUPTIME, buffer, length(str));

      closekey;
    except
    end;
    destroy;
  end;
end;

procedure reg_get_megasent(reg: tregistry; var MUp: integer; var MDn: integer);
var
  lenred: integer;
  str: string;
  buffer: array[0..10] of char;
begin
  with reg do begin

 //if valueexists('Stats.TMBUpload') then deletevalue('Stats.TMBUpload');
 //if valueexists('Stats.TMBDownload') then deletevalue('Stats.TMBDownload');

    try
      if valueexists(REG_STR_STATSUPHIST) then begin
        try
          lenred := readbinarydata(REG_STR_STATSUPHIST, buffer, 10);
          if lenred = 10 then begin
            setlength(str, lenred);
            move(buffer, str[1], lenred);
            str := d67(d64(str, 59812), 1451);
            delete(str, 1, 1); //remove random char 2047+
            if ((str[5] = CHRNULL) and (chars_2_word(copy(str, 7, 2)) = word(wh(copy(str, 1, 4)) + 32))) then begin
              MUp := chars_2_dword(copy(str, 1, 4));

            end else begin

              MUp := 0;

            end;
          end else MUp := 0;
        except
          MUp := 0;
        end;
      end else MUp := 0;


      if valueexists(REG_STR_STATSDNHIST) then begin
        try
          lenred := readbinarydata(REG_STR_STATSDNHIST, buffer, 10);
          if lenred = 10 then begin
            setlength(str, lenred);
            move(buffer, str[1], lenred);
            str := d67(d64(str, 52812), 1481);
            delete(str, 1, 1); //remove random char 2047+
            if ((str[5] = CHRNULL) and (chars_2_word(copy(str, 7, 2)) = word(wh(copy(str, 1, 4)) + 31))) then begin
              MDn := chars_2_dword(copy(str, 1, 4));

            end else begin
              MDn := 0;

            end;
          end else MDn := 0;
        except
          MDn := 0;
        end;
      end else MDn := 0;

    except
    end;

  end;
end;



procedure reg_get_transpeed(reg: tregistry; var UpI: cardinal; var DnI: cardinal);
var
  lenred: integer;
  str: string;
  buffer: array[0..10] of char;
begin
  with reg do begin
    try
      if valueexists(REG_STR_STATS_UPSPEED) then begin //encrypted since 2947+  22/12/2004
        lenred := readbinarydata(REG_STR_STATS_UPSPEED, buffer, 10);
        if lenred = 10 then begin
          setlength(str, lenred);
          move(buffer, str[1], lenred);
          str := d67(d64(str, 51812), 6451);
          delete(str, 1, 1); //remove random char 2047+
          if ((str[5] = CHRNULL) and (chars_2_word(copy(str, 7, 2)) = word(wh(copy(str, 1, 4)) + 14))) then begin
            UpI := chars_2_dword(copy(str, 1, 4));

          end else begin
            UpI := 0;

          end;
        end else UpI := 0;
      end else UpI := 0; // 33 k di default

      if valueexists(REG_STR_STATS_DNSPEED) then begin
        lenred := readbinarydata(REG_STR_STATS_DNSPEED, buffer, 10);
        if lenred = 10 then begin
          setlength(str, lenred);
          move(buffer, str[1], lenred);
          str := d67(d64(str, 31942), 7451);
          delete(str, 1, 1); //remove random char 2047+
          if ((str[5] = CHRNULL) and (chars_2_word(copy(str, 7, 2)) = word(wh(copy(str, 1, 4)) + 15))) then begin
            DnI := chars_2_dword(copy(str, 1, 4));

          end else begin
            DnI := 0;

          end;
        end else DnI := 0;
      end else DnI := 0; // 33 k di default
    except
    end;
  end;
end;




procedure stats_maxspeed_write;
var
  reg: tregistry;
  media: int64;
  str: string;
  buffer: array[0..10] of char;
  lenred: integer;
begin
  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);

    try
      if not valueexists(REG_STR_STATS_UPSPEED) then begin

        str := chr(random(255)) +
          int_2_dword_string(velocita_up) +
          CHRNULL +
          chr(random(255)) +
          int_2_word_string(wh(int_2_dword_string(velocita_up)) + 14);

        str := e64(e67(str, 6451) + CHRNULL, 51812);
        move(str[1], buffer, length(str));
        reg.writebinarydata(REG_STR_STATS_UPSPEED, buffer, length(str));
      end else begin

        lenred := readbinarydata(REG_STR_STATS_UPSPEED, buffer, 10); //retrieve old value
        if lenred = 10 then begin
          setlength(str, lenred);
          move(buffer, str[1], lenred);
          str := d67(d64(str, 51812), 6451);
          delete(str, 1, 1); //remove random char 2047+
          if ((str[5] = CHRNULL) and (chars_2_word(copy(str, 7, 2)) = word(wh(copy(str, 1, 4)) + 14))) then begin
            media := chars_2_dword(copy(str, 1, 4));

          end else begin
            media := 0;

          end;
        end else media := 0;
        if media > 0 then begin //calculate average sum
          if velocita_up = media then velocita_up := ((media div 10) * 9) else
            velocita_up := ((media div 10) * 9) + (velocita_up div 10);
        end;

        str := chr(random(255)) + //now store to registry
          int_2_dword_string(velocita_up) +
          CHRNULL +
          chr(random(255)) +
          int_2_word_string(wh(int_2_dword_string(velocita_up)) + 14);

        str := e64(e67(str, 6451) + CHRNULL, 51812);
        move(str[1], buffer, length(str));
        reg.writebinarydata(REG_STR_STATS_UPSPEED, buffer, length(str));
      end;
    except
    end;



    try
      if not valueexists(REG_STR_STATS_DNSPEED) then begin

        str := chr(random(255)) +
          int_2_dword_string(velocita_down) +
          CHRNULL +
          chr(random(255)) +
          int_2_word_string(wh(int_2_dword_string(velocita_down)) + 15);

        str := e64(e67(str, 7451) + CHRNULL, 31942);
        move(str[1], buffer, length(str));
        reg.writebinarydata(REG_STR_STATS_DNSPEED, buffer, length(str));
      end else begin

        lenred := readbinarydata(REG_STR_STATS_DNSPEED, buffer, 10); //retrieve old value
        if lenred = 10 then begin
          setlength(str, lenred);
          move(buffer, str[1], lenred);
          str := d67(d64(str, 31942), 7451);
          delete(str, 1, 1); //remove random char 2047+
          if ((str[5] = CHRNULL) and (chars_2_word(copy(str, 7, 2)) = word(wh(copy(str, 1, 4)) + 15))) then begin
            media := chars_2_dword(copy(str, 1, 4));

          end else begin
            media := 0;

          end;
        end else media := 0;
        if media > 0 then begin //calculate average sum
          if velocita_down = media then velocita_down := ((media div 10) * 9) else
            velocita_down := ((media div 10) * 9) + (velocita_down div 10);
        end;

        str := chr(random(255)) + //now store to registry
          int_2_dword_string(velocita_down) +
          CHRNULL +
          chr(random(255)) +
          int_2_word_string(wh(int_2_dword_string(velocita_down)) + 15);

        str := e64(e67(str, 7451) + CHRNULL, 31942);
        move(str[1], buffer, length(str));
        reg.writebinarydata(REG_STR_STATS_DNSPEED, buffer, length(str));
      end;



    except
    end;
    closekey;
    destroy;
  end;

end;

function regGetMyTorrentFolder(const sharedFolder: widestring): widestring;
var
  reg: tregistry;
  str: string;
begin
  reg := tregistry.create;
  with reg do begin
    try
      if openkey(areskey, false) then begin
        str := hexstr_to_bytestr(readstring('Torrents.Folder'));
        closekey;
      end;
    except
    end;
    destroy;
  end;

  if length(str) > 2 then begin
    result := utf8strtowidestr(str);
  end else begin
    result := sharedFolder + '\' + STR_MYTORRENTS;
  end;
end;

function prendi_reg_my_shared_folder(const data_path: widestring): widestring;
var
  reg: tregistry;
  str: string;
begin
  reg := tregistry.create;
  with reg do begin
    try
      if openkey(areskey, false) then begin
        str := hexstr_to_bytestr(readstring('Download.Folder'));
        closekey;
      end;
    except
    end;
    destroy;
  end;

  if length(str) > 2 then begin
    result := utf8strtowidestr(str);
  end else begin
    result := data_path + '\' + STR_MYSHAREDFOLDER;
  end;
end;

function prendi_cant_supernode: boolean; //non possiamo, true se non possiamo
var reg: tregistry;
begin
  reg := tregistry.create;
  with reg do begin
    try
      openkey(areskey, true);

      if valueexists('Network.NoSupernode') then begin
        result := (readinteger('Network.NoSupernode') = 1);
      end else result := false;

      closekey;
    except
      result := true;
    end;
    destroy;
  end;
end;

function reg_get_avgUptime: integer;
var
  reg: tregistry;
  lenred: integer;
  str: string;
  buffer: array[0..10] of char;
begin
  result := 0;

  reg := tregistry.create;
  with reg do begin
    try
      openkey(areskey, true);

      if valueexists(REG_STR_STATS_AVGUPTIME) then begin //get average uptime
        lenred := readbinarydata(REG_STR_STATS_AVGUPTIME, buffer, 10);
        if lenred = 10 then begin
          setlength(str, lenred);
          move(buffer, str[1], lenred);
          str := d67(d64(str, 44284), 6793);
          delete(str, 1, 1); //remove random char 2047+
          if ((str[5] = CHRNULL) and (chars_2_word(copy(str, 7, 2)) = word(wh(copy(str, 1, 4)) + 17))) then begin
            result := chars_2_dword(copy(str, 1, 4));

          end else begin
            result := 0;

          end;
        end else result := 0;
      end else result := 0;

      closekey;
    except
    end;
    destroy;
  end;
end;

function get_default_upload_height(maxHeight: integer): integer;
var
  reg: tregistry;
begin
  result := 120;
  reg := tregistry.create;
  with reg do begin
    try
      openkey(areskey, true);

      if valueexists('GUI.UpHeight') then begin
        result := readinteger('GUI.UpHeight');
        deletevalue('GUI.UpHeight');
        closekey;
        openkey(areskey + '\Bounds', true);
        writeinteger('UpHeight', result);
      end else begin
        closekey;
        openkey(areskey + '\Bounds', true);
        if valueExists('UpHeight') then result := readinteger('UpHeight')
        else result := 120;
      end;

      closekey;
    except
    end;
    destroy;
  end;

  if result < 20 then result := 20 else
    if result > maxHeight then result := maxHeight;
end;

procedure write_default_upload_height;
var
  reg: tregistry;
begin
  reg := tregistry.create;
  with reg do begin
    try
      openkey(areskey + '\Bounds', true);
      writeinteger('UpHeight', vars_global.panelUploadHeight);
      closekey;
    except
    end;
    destroy;
  end;
end;

function prendi_my_pgui(reg: tregistry): string;
var
  guid: tguid;
  str: string;
begin
  try
    with reg do begin
      str := readstring('Personal.GUID');
      if length(str) <> 32 then writestring('Personal.GUID', '')
      else result := hexstr_to_bytestr(readstring('Personal.GUID'));

      if length(result) <> 16 then begin
        fillchar(guid, sizeof(tguid), 0);
        CoInitialize(nil);
        cocreateguid(guid);
        CounInitialize;
        setlength(result, 16);
        move(guid, result[1], sizeof(tguid));
        writestring('Personal.GUID', bytestr_to_hexstr(result));
      end;
    end;

  except
  end;
end;

function prendi_mynick(reg: tregistry): string;
var
  str: string;
begin
  str := hexstr_to_bytestr(reg.readstring('Personal.Nickname'));
  str := copy(str, 1, 20);
  result := widestrtoutf8str(strippa_fastidiosi(utf8strtowidestr(str), '_'));
end;

function prendi_porta_server(reg: tregistry): word;
begin
  try
    with reg do begin
      if valueexists('Transfer.ServerPort') then result := readinteger('Transfer.ServerPort') else begin
        repeat
          result := random(50000) + 1024;
          if result = 1214 then continue else
            if result = 6346 then continue else
              if result = 8888 then continue else
                if result = 3306 then continue;
          break;
        until (not true);
        writeinteger('Transfer.ServerPort', result);
      end;
    end;

  except
    result := 80;
  end;
end;

function reg_bannato(const ip: string): boolean;
var
  reg: tregistry;
begin
  result := false;

  reg := tregistry.create;
  with reg do begin
    try
      openkey(areskey + 'banned', true);
      result := ValueExists(ip);
      closekey;
    except
    end;
    destroy;
  end;

end;

end.

