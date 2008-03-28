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
init application, get commandline params(any magnet URI?), look for concurrent instances
}

program Ares;

uses
  FastMM4 in 'FastMM4.pas',
  tntforms,
  Forms,
  windows,
  sysutils,
  helper_unicode in 'helper_unicode.pas',
  helper_params in 'helper_params.pas',
  ufrmmain in 'ufrmmain.pas' {ares_frmmain},
  ufrmpvt in 'ufrmpvt.pas' {frmpvt},
  ufrmemoticon in 'ufrmemoticon.pas' {frmemoticon},
  ufrmhint in 'ufrmhint.pas' {frmhint},
  uctrvol in 'uctrvol.pas' {frmctrlvol},
  ufrmpreview in 'ufrmpreview.pas' {frmpreview},
  const_win_messages in 'const_win_messages.pas',
  const_ares in 'const_ares.pas',
  msnNowPlaying in 'msnNowPlaying.pas',
  ufrmChatTab in 'ufrmChatTab.pas' {frmChatTab},
  uplaylistfrm in 'uplaylistfrm.pas' {PlaylistForm},
  helper_search_gui in 'helper_search_gui.pas',
  ZLib in 'ZLib.pas',
  ares_objects in 'ares_objects.pas',
  ares_types in 'ares_types.pas',
  AsyncExTypes in 'AsyncExTypes.pas',
  blcksock in 'blcksock.pas',
  class_cmdlist in 'class_cmdlist.pas',
  Classes2 in 'classes2.pas',
  const_cache_commands in 'const_cache_commands.pas',
  const_cacheserver in 'const_cacheserver.pas',
  const_chatroom in 'const_chatroom.pas',
  const_chatroom_commands in 'const_chatroom_commands.pas',
  const_client in 'const_client.pas',
  const_commands in 'const_commands.pas',
  const_commands_pfs in 'const_commands_pfs.pas',
  const_commands_privatechat in 'const_commands_privatechat.pas',
  const_privchat in 'const_privchat.pas',
  const_supernode_commands in 'const_supernode_commands.pas',
  const_timeouts in 'const_timeouts.pas',
  const_udpTransfer in 'const_udpTransfer.pas',
  Drag_N_Drop in 'Drag_N_Drop.pas',
  FastMM4Messages in 'FastMM4Messages.pas',
  hashlist in 'hashlist.pas',
  helper_altsources in 'helper_altsources.pas',
  helper_ares_cacheservers in 'helper_ares_cacheservers.pas',
  helper_ares_nodes in 'helper_ares_nodes.pas',
  helper_arescol in 'helper_arescol.pas',
  helper_autoscan in 'helper_autoscan.pas',
  helper_base64_32 in 'helper_base64_32.pas',
  helper_bighints in 'helper_bighints.pas',
  helper_cacheserver_crypt in 'helper_cacheserver_crypt.pas',
  helper_channellist in 'helper_channellist.pas',
  helper_chat_favorites in 'helper_chat_favorites.pas',
  helper_chatclient_share in 'helper_chatclient_share.pas',
  helper_chatroom in 'helper_chatroom.pas',
  helper_chatroom_gui in 'helper_chatroom_gui.pas',
  helper_chatroom_share in 'helper_chatroom_share.pas',
  helper_check_proxy in 'helper_check_proxy.pas',
  helper_combos in 'helper_combos.pas',
  helper_crypt in 'helper_crypt.pas',
  helper_datetime in 'helper_datetime.pas',
  helper_diskio in 'helper_diskio.pas',
  helper_download_disk in 'helper_download_disk.pas',
  helper_download_misc in 'helper_download_misc.pas',
  helper_filtering in 'helper_filtering.pas',
  helper_findmore in 'helper_findmore.pas',
  helper_graphs in 'helper_graphs.pas',
  helper_GUI_misc in 'helper_GUI_misc.pas',
  helper_hashlinks in 'helper_hashlinks.pas',
  helper_host_discovery in 'helper_host_discovery.pas',
  helper_http in 'helper_http.pas',
  helper_ICH in 'helper_ICH.pas',
  helper_ipfunc in 'helpeR_ipfunc.pas',
  helper_library_db in 'helper_library_db.pas',
  helper_manual_share in 'helper_manual_share.pas',
  helper_mimetypes in 'helper_mimetypes.pas',
  helper_player in 'helper_player.pas',
  helper_playlist in 'helper_playlist.pas',
  helper_preview in 'helper_preview.pas',
  helper_private_chat in 'helper_private_chat.pas',
  helper_registry in 'helper_registry.pas',
  helper_share_misc in 'helper_share_misc.pas',
  helper_share_settings in 'helper_share_settings.pas',
  helper_skin in 'helper_skin.pas',
  helper_sockets in 'helper_sockets.pas',
  helper_sorting in 'helper_sorting.pas',
  helper_stringfinal in 'helper_stringfinal.pas',
  helper_strings in 'helper_strings.pas',
  helper_supernode_crypt in 'helper_supernode_crypt.pas',
  helper_urls in 'helper_urls.pas',
  helper_visual_headers in 'helper_visual_headers.pas',
  helper_visual_library in 'helper_visual_library.pas',
  keywfunc in 'keywfunc.pas',
  mysupernodes in 'mysupernodes.pas',
  node_upgrade in 'node_upgrade.pas',
  packetFilter in 'packetfilter.pas',
  peerguard in 'peerguard.pas',
  SecureHash in 'securehash.pas',
  serviceManager in 'serviceManager.pas',
  shoutcast in 'shoutcast.pas',
  synsock in 'synsock.pas',
  th_rbld in 'th_rbld.pas',
  thread_cacheserver in 'thread_cacheserver.pas',
  thread_client in 'thread_client.pas',
  thread_client_chat in 'thread_client_chat.pas',
  thread_download in 'thread_download.pas',
  thread_private_chat in 'thread_private_chat.pas',
  thread_share in 'thread_share.pas',
  thread_supernode in 'thread_supernode.pas',
  thread_terminator in 'thread_terminator.pas',
  thread_upload in 'thread_upload.pas',
  types_cacheserver in 'types_cacheserver.pas',
  types_supernode in 'types_supernode.pas',
  umediar in 'umediar.pas',
  Utility_ares in 'utility_ares.pas',
  uxpfirewall in 'uxpfirewall.pas',
  vars_global in 'vars_global.pas',
  vars_localiz in 'vars_localiz.pas',
  BDecode in 'BitTorrent\BDecode.pas',
  bittorrentConst in 'BitTorrent\bittorrentconst.pas',
  BitTorrentDlDb in 'BitTorrent\BitTorrentDlDb.pas',
  BittorrentStringfunc in 'BitTorrent\bitTorrentStringFunc.pas',
  BitTorrentUtils in 'BitTorrent\BitTorrentUtils.pas',
  btcore in 'BitTorrent\btcore.pas',
  Hashes in 'BitTorrent\hashes.pas',
  thread_bitTorrent in 'BitTorrent\thread_bitTorrent.pas',
  TorrentParser in 'BitTorrent\torrentparser.pas',
  dhtconsts in 'DHT\dhtconsts.pas',
  dhtcontact in 'DHT\dhtcontact.pas',
  dhthashlist in 'DHT\dhthashlist.pas',
  dhtkeywords in 'DHT\dhtkeywords.pas',
  dhtroutingbin in 'DHT\dhtroutingbin.pas',
  dhtsearch in 'DHT\dhtsearch.pas',
  dhtsearchManager in 'DHT\dhtsearchManager.pas',
  dhtsocket in 'DHT\dhtsocket.pas',
  dhttypes in 'DHT\dhttypes.pas',
  dhtUtils in 'DHT\dhtUtils.pas',
  dhtzones in 'DHT\dhtzones.pas',
  int128 in 'DHT\int128.pas',
  thread_dht in 'DHT\thread_dht.pas';
{$R *.res}
//{$E .exe}
//{$R ares.RES}

const
 ARES_FRM_CLASS='Tares_frmmain.UnicodeClass';
 STR_ARES_GLBMTX='AresGlbMtx_';
 STR_ARES_CAPTION=' Ares ';

var
 mainfrm:HWnd;
 data:string;
 nfnd,WPrm,LPrm:integer;
 WM_COPYDATA:longint=$004a;
 COPYDATA: TCopyDataStruct;
 hGlobalMutex:hwnd;
 ARES_GLOBAL_MUTEX_NAME:string;
 STR_ARES_TITLE:string=' Ares ';


Function GetUsrName: string;
Var
   UserName : string;
   UserNameLen : Dword;
Begin
   UserNameLen := 255;
   SetLength(userName, UserNameLen) ;
   If GetUserName(PChar(UserName), UserNameLen) Then Result := Copy(UserName,1,UserNameLen - 1)
    else Result := STR_UNKNOWNS;
End;

procedure DoneApplication;
begin
  with Application do
  begin
    if Handle <> 0 then ShowOwnedPopups(Handle, False);
    ShowHint := False;
    Destroying;
    DestroyComponents;
  end;
end;

function LookAtAllWindows(Handle: HWND; Temp: LongInt): BOOL; stdcall;
var
  WndName : Array[0..255] of Char;
  ClsName  : Array[0..255] of Char;

begin
result:=true;

  // Go get the windows class name
  if GetClassName(Handle,ClsName,SizeOf(ClsName))< 26 then exit;

   if StrComp(ClsName,ARES_FRM_CLASS)=0 then begin

       if GetWindowText(Handle,WndName,SizeOf(WndName)) < 6 then exit;

        if comparemem(@WndName,@STR_ARES_CAPTION[1],6) then begin
         mainfrm:=handle;
         inc(nFnd);
        end;
   end;
end;




begin
IsMultiThread:=True;

 ARES_GLOBAL_MUTEX_NAME:=STR_ARES_GLBMTX+GetUsrName;
hGlobalMutex:=OpenMutex(SYNCHRONIZE,FALSE,pchar(ARES_GLOBAL_MUTEX_NAME));

if (hGlobalMutex <> 0)  then begin
  CloseHandle(hGlobalMutex);
  sleep(500); // enough time to create form?
  NFnd:=0;
  mainfrm:=0;

  EnumWindows(@LookAtAllWindows,0);

  if NFnd > 0 then begin

     if IsWindow(mainfrm) then begin
        copydata.dwData:=2;
        copydata.cbData:=0;
        if WideParamCount=1 then begin
         data:=widestrtoutf8str(Wideparamstr(1));
          with COPYDATA do begin
            lpData:=PChar(data);
            cbData:=Length(data);
            dwData:=0;
           end;
        end else
        if WideParamCount=2 then begin
          data:=widestrtoutf8str(Wideparamstr(2));
          with COPYDATA do begin
            lpData:=PChar(data);
            cbData:=Length(data);
            dwData:=1;
           end;
        end;

          WPrm:=Application.Handle;
          LPrm:=Integer(@CopyData);
           SendMessage(mainfrm, // Who are we sending to?
                       WM_COPYDATA,  // This message enables it all
                       WPrm,       // Handle of the sender
                       LPrm // Address of the filled COPYDATASTRUCT
                       );
           ARES_GLOBAL_MUTEX_NAME:='';
           exit;
      end;

  end;

  end else begin

    hGlobalMutex:=CreateMutex(nil,TRUE,pchar(ARES_GLOBAL_MUTEX_NAME));

    try

    application.Initialize;
    application.Title:=' Ares ';
    application.ShowMainForm:=false;
    Application.CreateForm(Tares_frmmain, ares_frmmain);
  application.run;
       
    except
    end;

    ReleaseMutex(hGlobalMutex);
    CloseHandle(hGlobalMutex);
    ARES_GLOBAL_MUTEX_NAME:='';
  end;


end.
