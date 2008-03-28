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
global variables, some related to threads
}

unit vars_global;

interface

uses
 classes2,thread_terminator,DSPack,ufrmhint,classes,windows,graphics,
 ares_types,comettrees,tntmenus,thread_upload,thread_download,
 thread_client,thread_supernode,thread_cacheserver,thread_share,int128,
 thread_client_chat,helper_autoscan,thread_dht,blcksock,synsock,dhtzones,
 dhttypes,thread_bittorrent,tntforms,forms;

var
  COLOR_DL_COMPLETED,
  COLOR_UL_COMPLETED,
  COLOR_UL_CANCELLED,
  COLOR_PROGRESS_DOWN,
  COLOR_PROGRESS_UP,
  COLOR_OVERLAY_UPLOAD,
  COLORE_ALTERNATE_ROW,
  COLORE_LISTVIEW_HOT,
  COLORE_TRANALTERNATE_ROW,
  COLORE_HINT_BG,
  COLORE_HINT_FONT,
  COLORE_GRAPH_BG,
  COLORE_GRAPH_GRID,
  COLORE_PLAYER_BG,
  COLORE_PLAYER_FONT,
  COLORE_LISTVIEWS_BG,
  COLORE_LISTVIEWS_FONT,
  COLORE_LISTVIEWS_FONTALT1,
  COLORE_LISTVIEWS_FONTALT2,
  COLORE_LISTVIEWS_GRIDLINES,
  COLORE_LISTVIEWS_TREELINES,
  COLORE_PARTIAL_UPLOAD,
  COLORE_PARTIAL_DOWNLOAD,
  COLORE_GRAPH_INK,
  COLORE_SEARCH_PANEL,
  COLORE_LIBDETAILS_PANEL,
  COLORE_FONT_SEARCHPNL,
  COLORE_FONT_LIBDET,
  COLORE_PANELS_SEPARATOR,
  COLORE_PANELS_BG,
  COLORE_PANELS_FONT,
  COLORE_LISTVIEWS_HEADERBK,
  COLORE_LISTVIEWS_HEADERFONT,
  COLORE_LISTVIEWS_HEADERBORDER,
  COLOR_MISSING_CHUNK,
  COLOR_CHUNK_COMPLETED,
  COLOR_PARTIAL_CHUNK,
  COLORE_DLSOURCE,
  COLORE_PHASH_VERIFY,
  COLORE_TOOLBAR_BG,
  COLORE_TOOLBAR_FONT,
  COLORE_ULSOURCE_CHUNK:tcolor;
  VARS_SCREEN_LOGO:widestring;
  SETTING_3D_PROGBAR,
  VARS_THEMED_BUTTONS,
  VARS_THEMED_HEADERS,
  VARS_THEMED_PANELS:boolean;
  COLORE_CHAT_FONT,
  COLORE_CHAT_BG,
  COLORE_CHAT_NICK,
  COLORE_CHATPVTNICK,
  COLORE_PUBLIC,
  COLORE_JOIN,
  COLORE_PART,
  COLORE_EMOTE,
  COLORE_NOTIFICATION,
  COLORE_ERROR:byte;

  initialized:boolean;
  app_minimized:boolean;
  mute_on:boolean;
  closing:boolean;
  last_shown_SRCtab:byte;
  
  thread_up:tthread_upload;
  thread_down:tthread_download;
  client:tthread_client;
  hash_server:tthread_supernode;
  share:tthread_share;
  client_chat:tthread_client_chat;
  cache_server:tthread_cache;
  search_dir:tthread_search_dir;
  IDEIsRunning:boolean;
  chat_favorite_height:integer;
  typed_lines_chat:tmystringlist;
  typed_lines_chat_index:integer;
  num_seconds:byte;
  isvideoplaying:boolean;
  last_chat_req:cardinal;
  last_mem_check:cardinal;
  image_less_top,image_more_top,image_back_top:integer;
  allow_regular_paths_browse:boolean;
  browse_type:byte;
  ip_user_granted:cardinal;
  port_user_granted:word;
  ip_alt_granted:cardinal;
  list_chatchan_visual:tmylist;
  chat_chanlist_backup:tmylist;
  lista_pushed_chatrequest:tmylist;
  fresh_downloaded_files:tmylist;
  terminator:tthread_terminator;
  queue_firstinfirstout:boolean;
  src_panel_list:tmylist;
  filtro2:TFilterGraph;
  formhint:tfrmhint;
  MAX_OUTCONNECTIONS:integer;//sp2 limit download outgoing sources
  block_pm,block_pvt_chat:boolean;
  max_dl_allowed:byte;
  up_band_allow,down_band_allow:cardinal;
  numero_upload,numero_download,numero_queued,numTorrentDownloads,
  numTorrentUploads,speedTorrentDownloads,speedTorrentUploads:cardinal;
  downloadedBytes,BitTorrentDownloadedBytes,BitTorrentUploadedBytes:int64;
  lista_shared:tmylist;
  should_show_prompt_nick:boolean;
  MAX_SIZE_NO_QUEUE:cardinal;
  app_path:widestring;
  data_path:widestring;
  versioneares:string;
  mega_uploaded,mega_downloaded:integer;
  hashing:boolean;
  lista_down_temp:tmylist;
  cambiato_search:boolean;
  program_totminuptime,program_start_time,program_first_day:cardinal;
  my_shared_count:integer;
  im_firewalled:boolean;
  logon_time:cardinal;
  velocita_att_upload,velocita_att_download:cardinal;
  LanIPC:cardinal;
  LanIPS:string;
  prev_cursorpos:tpoint;
  minutes_idle:cardinal;
  socks_type:Tsocks_type;
  socks_password,socks_username,socks_ip:string;
  socks_port:word;

  stopped_by_user:boolean;
  font_chat:tfont;

  should_send_channel_list:boolean;
  need_rescan:boolean;
  scan_start_time:cardinal;
  queue_length:byte;
  mypgui:string;
  previous_hint_node:pcmtvnode;
  handle_obj_GraphHint:cardinal;
  graphIsDownload,graphIsUpload:boolean;
  max_ul_per_ip:byte;
  shufflying_playlist:boolean;
  buildno:cardinal;
  FSomeFolderChecked:boolean;
  changed_download_hashes:boolean;
  ShareScans:cardinal;
  update_my_nick:boolean;
  playlist_visible:boolean;
  velocita_up:cardinal;
  velocita_up_dec:integer;
  velocita_down:dword;
  oldhintposx,oldhintposy:integer;
  limite_upload:byte;
  hash_select_in_library:string;
  defLangEnglish:boolean;
  myport:word;
  mynick:string;
  file_visione_da_copiatore,caption_player:widestring;
  panel6sizedefault,panelUploadHeight,default_width_chat:integer;
  ending_session:boolean;
  blendPlaylistForm:tform;
  localip:string;
  localipC:cardinal;
  myshared_folder,my_torrentFolder:widestring;
  last_index_icona_details_library:byte;
  client_h_global:integer;
  bytes_sent:int64;
  muptime:cardinal;
  lista_socket_accept_down:tmylist;
  lista_risorse_temp:tthreadlist;
  lista_risorsepartial_temp:tthreadlist;
  lista_socket_temp_proxy:tmylist;
  lista_push_nostri:tmylist;
  ever_pressed_chat_list:boolean;
  hash_throttle:byte;
  chat_buttons_wantbg:boolean;
  numero_pvt_open:word;
  cambiato_manual_folder_share,cambiato_setting_autoscan,want_stop_autoscan:boolean;
  partialUploadSent:int64;
  speedUploadPartial:cardinal;
  was_on_src_tab:boolean; //for unbolding of search results

  threadDHT:tthread_dht;
  DHT_socket:hsocket;
  DHT_RemoteSin:TVarSin;
  DHT_buffer:array[0..9999] of byte;

  DHT_len_recvd,DHT_len_tosend:integer;
  DHT_routingZone:TRoutingZone;
  DHT_m_Publish:boolean; //autopubblish of own key
  DHT_m_nextID:cardinal;
  DHT_events:Tmylist;
  DHT_Searches:Tmylist;
  DHTme:CU_INT128;
  DHT_availableContacts:integer;
  DHT_AliveContacts:integer;
  DHT_possibleBootstrapClientIP:cardinal;
  DHT_possibleBootstrapClientPort:word;
  DHT_hashFiles:tthreadList;
  DHT_KeywordFiles:tthreadList;
  DHT_LastPublishKeyFiles:cardinal; //milliseconds 
  DHT_LastPublishHashFiles:cardinal; //milliseconds


  BitTorrentTempList:TMyList;
  bittorrent_Accepted_sockets:TMylist;
  thread_bittorrent:tthread_bitTorrent;

  chatTabs:Tmylist;  //taskbar buttons
  ChatServiceRunning:boolean;      
implementation

end.
