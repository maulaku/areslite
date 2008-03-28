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
Ares main form, general UI events and procedures
}

unit ufrmmain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, tntforms, Forms, Dialogs,
  Menus, ComCtrls, OleCtrls, ExtCtrls, StdCtrls, registry, ImgList, uTrayIcon,
  Buttons, comobj, ActiveX, messages, cometTrees, synsock, Drag_N_Drop, directshow9,
  TntStdCtrls, TntButtons, TntComCtrls, OleServer, TntExtCtrls, jvrichedit,
  comettrack, WinSplit, XPbutton, zlib,
  tntdialogs, tntsysutils, tntwindows, TntMenus, tntsystem, themes,
  CheckLst, comettopicpnl, CmtHint, math,
  folderBrowse, DSPack,
  ufrmhint,
  blcksock,
  ares_types,
  ares_objects,
  classes2,
  class_cmdlist,
  const_ares,
  utility_ares,
  thread_upload,
  thread_share,
  thread_download,
  thread_client,
  thread_terminator,
  thread_supernode,
  thread_cacheserver,
  thread_client_chat,
  helper_channellist,
  helper_manual_share,
  helper_visual_headers,
  helper_check_proxy,
  vars_localiz,
  helper_diskio,
  helper_strings,
  helper_crypt,
  helper_base64_32,
  helper_urls,
  helper_ipfunc,
  helper_chatroom,
  helper_mimetypes,
  SecureHash,
  umediar,
  helper_datetime,
  helper_combos,
  helper_registry,
  helper_bighints,
  helper_visual_library,
  helper_share_settings,
  helper_preview,
  vars_global,
  const_win_messages,
  helper_params,
  helper_search_gui,
  helper_altsources,
  helper_library_db,
  helper_playlist,
  helper_hashlinks,
  helper_arescol,
  helper_player,
  helper_gui_misc,
  node_upgrade,
  helper_download_misc,
  helper_private_chat,
  helper_chatroom_gui,
  helper_chatroom_share,
  helper_stringfinal,
  helper_findmore,
  helper_autoscan,
  helper_ares_cacheservers,
  helper_share_misc,
  const_timeouts,
  helper_chat_favorites,
  helper_skin,
  helper_unicode,
  btcore,
  bitTorrentStringFunc,
  DSUtil,
  AsyncExTypes,
  shoutcast,
  msnNowPlaying, mPlayerPanel, cometPageView, XPMan, cometbtnedit;




type
  Tares_frmmain = class(TTntForm, IAsyncExCallBack)
    Popup_search: TTntPopupMenu;
    img_mime_small: TImageList;
    Download1: TTntMenuItem;
    Popup_library: TTntPopupMenu;
    AddRemovefolderstosharelist2: TTntMenuItem;
    Timer_sec: TTimer;
    imglist_transfer: TImageList;
    PopupMenuvideo: TTntPopupMenu;
    Fullscreen2: TTntMenuItem;
    OpenPlay1: TTntMenuItem;
    Locate1: TTntMenuItem;
    Play1: TTntMenuItem;
    Stop2: TTntMenuItem;
    Pause1: TTntMenuItem;
    N1: TTntMenuItem;
    Openwithexternalplayer2: TTntMenuItem;
    Addtoplaylist1: TTntMenuItem;
    ShareUn1: TTntMenuItem;
    N5: TTntMenuItem;
    DeleteFile2: TTntMenuItem;
    fittoscreen1: TTntMenuItem;
    Popup_download: TTntPopupMenu;
    Cancel2: TTntMenuItem;
    ClearIdle2: TTntMenuItem;
    OpenPreview2: TTntMenuItem;
    NewSearch1: TTntMenuItem;
    N6: TTntMenuItem;
    PauseResume1: TTntMenuItem;
    N12: TTntMenuItem;
    Addtoplaylist2: TTntMenuItem;
    Locate2: TTntMenuItem;
    Popup_upload: TTntPopupMenu;
    OpenPlay2: TTntMenuItem;
    LocateFile1: TTntMenuItem;
    Addtoplaylist3: TTntMenuItem;
    N13: TTntMenuItem;
    Cancel1: TTntMenuItem;
    BanUser1: TTntMenuItem;
    Chat1: TTntMenuItem;
    Chat2: TTntMenuItem;
    N4: TTntMenuItem;
    N10: TTntMenuItem;
    Stopsearch1: TTntMenuItem;
    ImageList_chat: TImageList;
    popup_chat_userlist: TTntPopupMenu;
    Sendaprivatemessage1: TTntMenuItem;
    popup_chat_chanlist: TTntPopupMenu;
    Joinchannel1: TTntMenuItem;
    Popup_chat_memo: TTntPopupMenu;
    SelectAll1: TTntMenuItem;
    CopytoClipboard1: TTntMenuItem;
    Openinnotepad1: TTntMenuItem;
    imagelist_lib_max: TImageList;
    N17: TTntMenuItem;
    Disconnect2: TTntMenuItem;
    ClearIdle1: TTntMenuItem;
    PauseallUnpauseAll1: TTntMenuItem;
    Play3: TTntMenuItem;
    IgnoreUnignore1: TTntMenuItem;
    Ban1: TTntMenuItem;
    Unban1: TTntMenuItem;
    Muzzle1: TTntMenuItem;
    UnMuzzle1: TTntMenuItem;
    Originalsize1: TTntMenuItem;
    Findmoreofthesameartist1: TTntMenuItem;
    Artist1: TTntMenuItem;
    Genre1: TTntMenuItem;
    Findmorefromthesame2: TTntMenuItem;
    Artist3: TTntMenuItem;
    Genre3: TTntMenuItem;
    Openexternal1: TTntMenuItem;
    OpenExternal2: TTntMenuItem;
    Popup_queue: TTntPopupMenu;
    Blockhost1: TTntMenuItem;
    Chatwithuser1: TTntMenuItem;
    MenuItem7: TTntMenuItem;
    MenuItem8: TTntMenuItem;
    MenuItem9: TTntMenuItem;
    MenuItem10: TTntMenuItem;
    MenuItem11: TTntMenuItem;
    MenuItem12: TTntMenuItem;
    Findmorefromthesame1: TTntMenuItem;
    Artist2: TTntMenuItem;
    Genre2: TTntMenuItem;
    TrayIcon1: TTrayIcon;
    Popup_playlist: TTntPopupMenu;
    playlist_RemoveAll1: TTntMenuItem;
    playlist_Removeselected1: TTntMenuItem;
    playlist_openext: TTntMenuItem;
    playlist_Locate: TTntMenuItem;
    playlist_Sort1: TTntMenuItem;
    playlist_Alphasortasc: TTntMenuItem;
    playlist_Alphasortdesc: TTntMenuItem;
    playlist_sortInv: TTntMenuItem;
    MenuItem14: TTntMenuItem;
    playlist_Randomplay1: TTntMenuItem;
    playlist_Continuosplay1: TTntMenuItem;
    fol: TBrowseForFolder;
    imagelist_menu: TImageList;
    panel_playlist: TcometTopicPnl;
    btn_playlist_close: TXPbutton;
    listview_playlist: TCometTree;
    popup_tray: TTntPopupMenu;
    tray_Play: TTntMenuItem;
    tray_Pause: TTntMenuItem;
    tray_Stop: TTntMenuItem;
    N2: TTntMenuItem;
    tray_showPlaylist: TTntMenuItem;
    N11: TTntMenuItem;
    tray_quit: TTntMenuItem;
    tray_Minimize: TTntMenuItem;
    OpenDialog1: TTntOpenDialog;
    SaveDialog1: TTntSaveDialog;
    popup_lib_virfolders: TTntPopupMenu;
    AddtoPlaylist4: TTntMenuItem;
    SendPrivateMessage1: TTntMenuItem;
    popup_chat_search: TTntPopupMenu;
    Download2: TTntMenuItem;
    Ban2: TTntMenuItem;
    Kill1: TTntMenuItem;
    N8: TTntMenuItem;
    GrantSlot1: TTntMenuItem;
    Grantupslot1: TTntMenuItem;
    Browse1: TTntMenuItem;
    All1: TTntMenuItem;
    N9: TTntMenuItem;
    Audio1: TTntMenuItem;
    Video1: TTntMenuItem;
    Image1: TTntMenuItem;
    Document1: TTntMenuItem;
    Software1: TTntMenuItem;
    popup_chat_dlvirfolder: TTntPopupMenu;
    Download3: TTntMenuItem;
    popup_chat_browse: TTntPopupMenu;
    Download4: TTntMenuItem;
    N14: TTntMenuItem;
    Findmoreofthesame1: TTntMenuItem;
    Artist4: TTntMenuItem;
    Genre4: TTntMenuItem;
    N18: TTntMenuItem;
    Ban3: TTntMenuItem;
    Kill2: TTntMenuItem;
    Chat4: TTntMenuItem;
    Browse2: TTntMenuItem;
    Sendprivate1: TTntMenuItem;
    All2: TTntMenuItem;
    N19: TTntMenuItem;
    Audio2: TTntMenuItem;
    Video2: TTntMenuItem;
    Image3: TTntMenuItem;
    Document2: TTntMenuItem;
    Software2: TTntMenuItem;
    N21: TTntMenuItem;
    Chat5: TTntMenuItem;
    SendPrivate2: TTntMenuItem;
    ExportHashLink1: TTntMenuItem;
    ExportHashlink2: TTntMenuItem;
    ExportHashlink3: TTntMenuItem;
    popup_lib_regfolders: TTntPopupMenu;
    AddtoPlaylist5: TTntMenuItem;
    OpenFolder1: TTntMenuItem;
    popup_chat_dlregfolder: TTntPopupMenu;
    Download5: TTntMenuItem;
    imagelist_panel_search: TImageList;
    ExportHashlink4: TTntMenuItem;
    imglist_mfolder: TImageList;
    Fold: TBrowseForFolder;
    imglist_emotic: TImageList;
    FontDialog1: TFontDialog;
    Popup_chat_emotic: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    N91: TMenuItem;
    N101: TMenuItem;
    N111: TMenuItem;
    N121: TMenuItem;
    N131: TMenuItem;
    N141: TMenuItem;
    N151: TMenuItem;
    N161: TMenuItem;
    CmtHint: TCmtHint;
    Clearscreen1: TTntMenuItem;
    Saveas1: TTntMenuItem;
    Exporthashlink5: TTntMenuItem;
    popup_capt_player: TTntPopupMenu;
    OpenExternal3: TTntMenuItem;
    Locate3: TTntMenuItem;
    addtoplaylist6: TTntMenuItem;
    Grantslot2: TTntMenuItem;
    AddtoFavorites1: TTntMenuItem;
    popup_chat_fav: TTntPopupMenu;
    Join1: TTntMenuItem;
    Remove1: TTntMenuItem;
    N3: TTntMenuItem;
    ExportHashlink6: TTntMenuItem;
    N15: TTntMenuItem;
    Other1: TTntMenuItem;
    Other2: TTntMenuItem;
    RemoveSource1: TTntMenuItem;
    imglist_stars: TImageList;
    RemoveSource2: TTntMenuItem;
    AutoJoin1: TTntMenuItem;
    ListentoRadio1: TTntMenuItem;
    N16: TTntMenuItem;
    New1: TTntMenuItem;
    N20: TTntMenuItem;
    Riptodisk1: TTntMenuItem;
    Locate4: TTntMenuItem;
    Enable1: TTntMenuItem;
    ExportHashlink7: TTntMenuItem;
    Directory1: TTntMenuItem;
    tmr_stop_radio: TTimer;
    Volume1: TTntMenuItem;
    timer_fullScreenHideCursor: TTimer;
    MPlayerPanel1: TMPlayerPanel;
    trackbar_player: Tcomettrack;
    tabs_pageview: TCometPageView;
    XPManifest1: TXPManifest;
    btns_chat: TCometTopicPnl;
    btn_chat_fav: TXPbutton;
    btn_chat_host: TXPbutton;
    btn_chat_join: TXPbutton;
    btn_chat_refchanlist: TXPbutton;
    btn_chat_search: TXPbutton;
    combo_chat_search: TTntComboBox;
    combo_chat_srctypes: TTntComboBox;
    btns_library: TCometTopicPnl;
    btn_lib_addtoplaylist: TXPbutton;
    btn_lib_delete: TXPbutton;
    btn_lib_refresh: TXPbutton;
    btn_lib_toggle_details: TXPbutton;
    btn_lib_toggle_folders: TXPbutton;
    btn_lib_virtual_view: TXPbutton;
    btn_lib_regular_view: TXPbutton;
    btns_options: TCometTopicPnl;
    lbl_opt_statusconn: TTntLabel;
    btn_opt_connect: TXPbutton;
    btn_opt_disconnect: TXPbutton;
    btns_transfer: TCometTopicPnl;
    btn_tran_cancel: TXPbutton;
    btn_tran_clearidle: TXPbutton;
    btn_tran_locate: TXPbutton;
    btn_tran_play: TXPbutton;
    btn_tran_toggle_queup: TXPbutton;
    panel_transfer: TPanel;
    panel_tran_down: TCometTopicPnl;
    treeview_download: TCometTree;
    panel_tran_upqu: TCometTopicPnl;
    treeview_queue: TCometTree;
    treeview_upload: TCometTree;
    splitter_transfer: TWinSplit;
    splitter_library: TWinSplit;
    panel_vid: TCometTopicPnl;
    panel_search: TCometTopicPnl;
    Label_date_search: TTntLabel;
    icon_mime_search: TImage;
    lbl_capt_search: TTntLabel;
    label_back_src: TTntLabel;
    label_more_searchopt: TTntLabel;
    Label_title_search: TTntLabel;
    Label_auth_search: TTntLabel;
    label_cat_search: TTntLabel;
    label_album_search: TTntLabel;
    label_lang_search: TTntLabel;
    label_sel_duration: TTntLabel;
    label_sel_size: TTntLabel;
    label_sel_quality: TTntLabel;
    lbl_srcmime_all: TTntLabel;
    lbl_srcmime_audio: TTntLabel;
    lbl_srcmime_video: TTntLabel;
    lbl_srcmime_document: TTntLabel;
    lbl_srcmime_image: TTntLabel;
    lbl_srcmime_software: TTntLabel;
    lbl_srcmime_other: TTntLabel;
    combo_lang_search: TComboBox;
    combo_wanted_duration: TComboBox;
    combo_wanted_quality: TComboBox;
    combo_wanted_size: TComboBox;
    combotitsearch: TTntComboBox;
    comboautsearch: TTntComboBox;
    combocatsearch: TTntComboBox;
    comboalbsearch: TTntComboBox;
    combodatesearch: TTntComboBox;
    combo_sel_duration: TTntComboBox;
    combo_sel_quality: TTntComboBox;
    combo_sel_size: TTntComboBox;
    Btn_start_search: TTntButton;
    btn_stop_search: TTntButton;
    combo_search: TTntComboBox;
    radio_srcmime_all: TTntRadioButton;
    radio_srcmime_audio: TTntRadioButton;
    radio_srcmime_video: TTntRadioButton;
    radio_srcmime_image: TTntRadioButton;
    radio_srcmime_document: TTntRadioButton;
    radio_srcmime_software: TTntRadioButton;
    radio_srcmime_other: TTntRadioButton;
    panel_hash: TCometTopicPnl;
    lbl_hash_file: TTntLabel;
    lbl_hash_folder: TTntLabel;
    lbl_hash_progress: TTntLabel;
    lbl_hash_pri: TTntLabel;
    lbl_hash_hint: TTntLabel;
    lbl_hash_filedet: TTntLabel;
    progbar_hash_file: TProgressBar;
    hash_pri_trx: TTrackBar;
    progbar_hash_total: TProgressBar;
    listview_lib: TCometTree;
    panel_details_library: TCometTopicPnl;
    lbl_title_detlib: TTntLabel;
    lbl_descript_detlib: TTntLabel;
    lbl_url_detlib: TTntLabel;
    lbl_categ_detlib: TTntLabel;
    lbl_author_detlib: TTntLabel;
    lbl_album_detlib: TTntLabel;
    lbl_language_detlib: TTntLabel;
    lbl_year_detlib: TTntLabel;
    lbl_folderlib_hint: TTntLabel;
    lbl_lib_fileshared: TTntLabel;
    edit_language: TComboBox;
    edit_title: TTntEdit;
    edit_description: TTntMemo;
    edit_url_library: TTntEdit;
    combocatlibrary: TTntComboBox;
    edit_author: TTntEdit;
    edit_album: TTntEdit;
    edit_year: TTntEdit;
    chk_lib_fileshared: TTntCheckBox;
    treeview_lib_regfolders: TCometTree;
    treeview_lib_virfolders: TCometTree;
    panel_chat: TCometPageView;
    panel_list_channels: TCometTopicPnl;
    Splitter_chat_channel: TWinSplit;
    pnl_chat_fav: TCometTopicPnl;
    treeview_chat_favorites: TCometTree;
    listview_chat_channel: TCometTree;
    settings_control: TCometPageView;
    pnl_opt_general: TCometTopicPnl;
    lbl_opt_gen_lan: TTntLabel;
    Combo_opt_gen_gui_lang: TTntComboBox;
    check_opt_gen_autostart: TTntCheckBox;
    check_opt_gen_autoconnect: TTntCheckBox;
    check_opt_gen_gclose: TTntCheckBox;
    check_opt_gen_nohint: TTntCheckBox;
    check_opt_gen_pausevid: TTntCheckBox;
    check_opt_gen_capt: TTntCheckBox;
    GrpBx_nick: TTntGroupBox;
    lbl_opt_gen_nick: TTntLabel;
    lbl_opt_gen_speed: TTntLabel;
    edit_opt_gen_nick: TTntEdit;
    combo_opt_gen_speed: TComboBox;
    pnl_opt_transfer: TCometTopicPnl;
    lbl_opt_tran_port: TTntLabel;
    grpbx_opt_tran_shfolder: TTntGroupBox;
    lbl_opt_tran_shfolder: TTntLabel;
    lbl_opt_tran_disksp: TTntLabel;
    btn_opt_tran_chshfold: TTntButton;
    btn_opt_tran_defshfold: TTntButton;
    edit_opt_tran_shfolder: TTntEdit;
    Edit_opt_tran_port: TEdit;
    check_opt_tran_warncanc: TTntCheckBox;
    check_opt_tran_perc: TTntCheckBox;
    grpbx_opt_tran_band: TTntGroupBox;
    lbl_opt_tran_upband: TTntLabel;
    lbl_opt_tran_dnband: TTntLabel;
    check_opt_tran_inconidle: TTntCheckBox;
    Edit_opt_tran_upband: TEdit;
    Edit_opt_tran_dnband: TEdit;
    grpbx_opt_tran_sims: TTntGroupBox;
    Label_max_uploads: TTntLabel;
    label_max_upperip: TTntLabel;
    label_max_dl: TTntLabel;
    Edit_opt_tran_limup: TEdit;
    UpDown1: TUpDown;
    Edit_opt_tran_upip: TEdit;
    UpDown2: TUpDown;
    Edit_opt_tran_limdn: TEdit;
    UpDown3: TUpDown;
    pnl_opt_chat: TCometTopicPnl;
    grpbx_opt_chat: TTntGroupBox;
    grpbx_opt_chat_misc: TTntGroupBox;
    TntLabel7: TTntLabel;
    Check_opt_chat_nopm: TTntCheckBox;
    Check_opt_chat_isaway: TTntCheckBox;
    Memo_opt_chat_away: TTntMemo;
    check_opt_chat_browsable: TTntCheckBox;
    check_opt_chat_realbrowse: TTntCheckBox;
    Check_opt_chat_time: TTntCheckBox;
    btn_opt_chat_font: TButton;
    check_opt_chat_joinpart: TTntCheckBox;
    Check_opt_chat_autoadd: TTntCheckBox;
    pnl_opt_network: TCometTopicPnl;
    check_opt_net_nosprnode: TTntCheckBox;
    grpbx_opt_proxy: TTntGroupBox;
    lbl_opt_proxy_addr: TTntLabel;
    lbl_opt_proxy_login: TTntLabel;
    lbl_opt_proxy_pass: TTntLabel;
    lbl_opt_proxy_check: TTntLabel;
    radiobtn_noproxy: TTntRadioButton;
    radiobtn_proxy4: TTntRadioButton;
    radiobtn_proxy5: TTntRadioButton;
    Edit_opt_proxy_addr: TEdit;
    edit_opt_proxy_login: TTntEdit;
    edit_opt_proxy_pass: TTntEdit;
    btn_opt_proxy_check: TTntButton;
    pnl_opt_hashlinks: TCometTopicPnl;
    check_opt_hlink_magnet: TTntCheckBox;
    Check_opt_hlink_filterexe: TTntCheckBox;
    Memo_opt_hlink: TTntMemo;
    btn_opt_hlink_down: TTntButton;
    check_opt_hlink_pls: TTntCheckBox;
    pnl_opt_skin: TCometTopicPnl;
    lbl_opt_skin_author: TTntLabel;
    lbl_opt_skin_version: TTntLabel;
    lbl_opt_skin_title: TTntLabel;
    lbl_opt_skin_url: TTntLabel;
    lbl_opt_skin_urlcap: TTntLabel;
    lbl_opt_skin_comments: TTntLabel;
    lbl_opt_skin_date: TTntLabel;
    lstbox_opt_skin: TTntListBox;
    pnl_opt_bittorrent: TCometTopicPnl;
    grpbx_opt_bittorrent_dlfolder: TTntGroupBox;
    lbl_opt_torrent_shfolder: TTntLabel;
    lbl_opt_torrent_disksp: TTntLabel;
    btn_opt_torrent_chshfold: TTntButton;
    btn_opt_torrent_defshfold: TTntButton;
    edit_opt_bittorrent_dlfolder: TTntEdit;
    check_opt_torrent_assoc: TTntCheckBox;
    pagesrc: TCometPageView;
    panel_src_default: TCometTopicPnl;
    pnl_opt_sharing: TCometTopicPnl;
    btn_shareset_ok: TTntButton;
    btn_shareset_cancel: TTntButton;
    pgctrl_shareset: TCometPageView;
    pnl_shareset_autoscan: TCometTopicPnl;
    pnl_shareset_auto: TPanel;
    lbl_shareset_auto: TTntLabel;
    progbar_shareset_auto: TProgressBar;
    chklstbx_shareset_auto: TCheckListBox;
    btn_shareset_atuostart: TTntButton;
    btn_shareset_atuostop: TTntButton;
    btn_shareset_atuocheckall: TTntButton;
    btn_shareset_atuoUncheckall: TTntButton;
    pnl_shareset_manual: TCometTopicPnl;
    lbl_shareset_manuhint: TTntLabel;
    mfolder: TCometTree;
    grpbx_shareset_manuhint: TTntGroupBox;
    img_shareset_manuhint1: TImage;
    img_shareset_manuhint2: TImage;
    lbl_shareset_manuhint1: TTntLabel;
    lbl_shareset_manuhint2: TTntLabel;
    lbl_shareset_hint: TTntLabel;
    lbl_src_status: TTntLabel;
    edit_lib_search: TCometbtnEdit;
    edit_chat_chanfilter: TCometbtnEdit;
    lbl_chat_capt: TTntLabel;
    edit_src_filter: TCometbtnEdit;
    edit_opt_network_yourip: TEdit;
    N22: TTntMenuItem;
    loadplaylist1: TTntMenuItem;
    saveplaylist1: TTntMenuItem;
    addfile1: TTntMenuItem;
    addfolder1: TTntMenuItem;
    N23: TTntMenuItem;
    check_opt_gen_msnsong: TTntCheckBox;
    check_opt_chat_taskbtn: TTntCheckBox;
    lbl_opt_homepage: TLabel;
    btn_opt_chat_start: TTntButton;
    btn_opt_chat_stop: TTntButton;
    btn_opt_chat_join: TTntButton;
    check_opt_chat_autocloseroom: TTntCheckBox;
    btn_opt_chat_connect: TTntButton;
    edit_opt_chat_connect: TEdit;
    Check_opt_chatroom_nopm: TTntCheckBox;
    clientPanel: TPanel;
    check_opt_chat_noemotes: TTntCheckBox;
    Shoutcast1: TTntMenuItem;
    uner21: TTntMenuItem;
    RadioToolbox1: TTntMenuItem;
    btn_opt_chat_set: TTntButton;
    ImageList_tabs: TImageList;

    procedure FormShow(Sender: TObject);
    procedure Btn_start_searchClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure minimizeapp(Sender: TObject);
    procedure restoreapp(Sender: TObject);
    procedure appexcept(sender: tobject; e: exception);
    procedure btn_stop_searchClick(Sender: TObject);
    procedure Download1Click(Sender: TObject);
    procedure tray_quitClick(Sender: TObject);
    procedure tray_MinimizeClick(Sender: TObject);
    procedure flatedit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure listview_srcGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure listview_srcGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure listview_srcGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure result_chat_Get_imageindex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure get_text_result_chats(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure listview_srcAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
    procedure listview_srcDblClick(Sender: TObject);
    procedure treeview_list_user_channeldblclick(sender: tobject); //apertura pvt o chat
    procedure painttopicpnl(sender: Tobject; Acanvas: Tcanvas; Capt: widestring; var should_continue: boolean);
    procedure Folders1Click(Sender: TObject);
    procedure Moreinfo1Click(Sender: TObject);
    procedure listview_libGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure listview_libGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure listview_libGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure deleteClick(Sender: TObject);
    procedure listview_libClick(Sender: TObject);
    procedure Edit_titleKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit_keywordsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit_category_videoClick(Sender: TObject);
    procedure chk_lib_filesharedMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ShareUnsharefile1Click(Sender: TObject);
    procedure Timer_secTimer(Sender: TObject);
    procedure ToolButton18Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure ToolButton27Click(Sender: TObject);
    procedure treeview_downloadGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure treeview_downloadGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure treeview_downloadGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure treeview_downloadAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
    procedure ToolButton21Click(Sender: TObject);
    procedure RadiosearchmimeClick(Sender: TObject);
    procedure OpenPreview1Click(Sender: TObject);
    procedure panel_vidResize(Sender: TObject);
    procedure Fullscreen2Click(Sender: TObject);
    procedure btn_player_pauseClick(Sender: TObject);
    procedure btn_player_playClick(Sender: TObject);
    procedure OpenPlay1Click(Sender: TObject);
    procedure Locate1Click(Sender: TObject);
    procedure track_not_enabled_to_change(Sender: TObject);
    procedure btn_tab_webXPButtonDraw(Sender: Tobject; TargetCanvas: Tcanvas; Rect: Trect; state: XPbutton.TCometBtnState; var should_continue: boolean);
    procedure btn_player_volClick(Sender: TObject);
    procedure Openwithexternalplayer1Click(Sender: TObject);
    procedure ksoOfficeSpeedButton13Click(Sender: TObject);
    procedure treeview_uploadGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure treeview_uploadGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure TreeviewHeaderClick(Sender: TCmtHdr; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure treeview_uploadAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
    procedure treeview_uploadGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure panel_transferResize(Sender: TObject);
    procedure resize_pannellobottom_editchat(Sender: TObject);
    procedure PauseResume1Click(Sender: TObject);
    procedure split_tranCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure Addtoplaylist1Click(Sender: TObject);
    procedure Addtoplaylist2Click(Sender: TObject);
    procedure Popup_downloadPopup(Sender: TObject);
    procedure treeview_uploadDblClick(Sender: TObject);
    procedure Locate2Click(Sender: TObject);
    procedure OpenPlay2Click(Sender: TObject);
    procedure locateupload3Click(Sender: TObject);
    procedure Sendmessage1Click(Sender: TObject);
    procedure listview_srcMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Addtoplaylist3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Cancel1Click(Sender: TObject);
    procedure treeview_uploadMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BanUser1Click(Sender: TObject);
    procedure combocatlibraryClick(Sender: TObject);
    procedure Chat1Click(Sender: TObject);
    procedure Chat2Click(Sender: TObject);
    procedure treeview_downloadMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure treeview_downloadMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure treeview_uploadMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure panel_tran_upquResize(Sender: TObject);
    procedure panel_tran_downResize(Sender: TObject);
    procedure label_back_srcClick(Sender: TObject);
    procedure label_more_searchoptClick(Sender: TObject);
    procedure radio_search_allClick(Sender: TObject);
    procedure TreeView2GetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure btn_lib_virtual_viewClick(Sender: TObject);
    procedure btn_lib_refreshClick(Sender: TObject);
    procedure splitter_libraryEndSplit(Sender: TObject);
    procedure btn_playlist_closeClick(Sender: TObject);
    procedure btn_chat_hostClick(Sender: TObject);
    procedure btn_chat_refchanlistClick(Sender: TObject);
    procedure listview_chat_channelGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure get_data_size_user_chats(Sender: TBaseCometTree; var Size: Integer);
    procedure get_text_users_chats(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure listview_chat_channelGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure splitter_chatEndSplit(Sender: TObject);
    procedure lista_user_chat_get_imageindex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure listview_srcMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Joinchannel1Click(Sender: TObject);
    procedure listview_chat_channelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Sendaprivatemessage1Click(Sender: TObject);
    procedure testoURLClick(Sender: TObject; const URLText: string; Button: TMouseButton);
    procedure listview_libMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SelectAll1Click(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
    procedure Openinnotepad1Click(Sender: TObject);
    procedure Connect1Click(Sender: TObject);
    procedure Disconnect1Click(Sender: TObject);
    procedure treeview_lib_regfoldersGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure treeview_lib_regfoldersGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure Disconnect2Click(Sender: TObject);
    procedure treeview_lib_regfoldersGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure listview_srcFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure result_chat_channelfreenode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure listview_libFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure listview_playlistGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure treeview_downloadfreenode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeview_uploadfreenode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeview_list_user_channelfreenode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure listview_chat_channelFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeview_lib_virfoldersClick(Sender: TObject);
    procedure treeview_lib_regfoldersClick(Sender: TObject);
    procedure listview4SelectionChange(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeview_lib_virfoldersKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure treeview_lib_regfoldersKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edit_lib_searchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure listview_srcPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure result_chat_channelpainttext(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure listviewchatPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure btn_tran_locateClick(Sender: TObject);
    procedure PauseallUnpauseAll1Click(Sender: TObject);
    procedure Play3Click(Sender: TObject);
    procedure hash_pri_trxChanged(Sender: TObject);
    procedure Ban1Click(Sender: TObject);
    procedure Unban1Click(Sender: TObject);
    procedure IgnoreUnignore1Click(Sender: TObject);
    procedure Muzzle1Click(Sender: TObject);
    procedure UnMuzzle1Click(Sender: TObject);
    procedure treeview_downloadHintStart(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeview_lib_virfoldersGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure treeview_downloadHintStop(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure edit_chatKeyPress(Sender: TObject; var Key: Char);
    procedure edit_chatKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure treeview_lib_virfoldersGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure edit_caption_chatMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edit_caption_chatKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure videoDblClick(Sender: TObject);
    procedure Originalsize1Click(Sender: TObject);
    procedure edit_src_filterKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure listview_libKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ClearIdle2Click(Sender: TObject);
    procedure ClearIdle1Click(Sender: TObject);
    procedure Artist1Click(Sender: TObject);
    procedure Genre1Click(Sender: TObject);
    procedure Artist2Click(Sender: TObject);
    procedure Genre2Click(Sender: TObject);
    procedure Artist3Click(Sender: TObject);
    procedure Genre3Click(Sender: TObject);
    procedure Openexternal1Click(Sender: TObject);
    procedure OpenExternal2Click(Sender: TObject);
    procedure browsebtnClick(Sender: TObject);
    procedure btn_tran_toggle_queupClick(Sender: TObject);
    procedure treeview_queuefreenode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeview_queueGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure treeview_queueGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure listview_playlistFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeview_queueMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Blockhost1Click(Sender: TObject);
    procedure Chatwithuser1Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure treeview_queueGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure treeview_queueMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure treeview_queueHintStop(Sender: TBaseCometTree);
    procedure Connect1DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure playlist_RemoveAll1Click(Sender: TObject);
    procedure playlist_Removeselected1Click(Sender: TObject);
    procedure playlist_openextClick(Sender: TObject);
    procedure playlist_LocateClick(Sender: TObject);
    procedure playlist_Randomplay1Click(Sender: TObject);
    procedure playlist_Continuosplay1Click(Sender: TObject);
    procedure playlist_AlphasortascClick(Sender: TObject);
    procedure playlist_AlphasortdescClick(Sender: TObject);
    procedure listview_playlistDblClick(Sender: TObject);
    procedure listview_playlistMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure listview_playlistKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure treeview_lib_regfoldersFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeview_lib_virfoldersGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure listview_playlistGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure listview_playlistGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure get_size_result_chats(Sender: TBaseCometTree; var Size: Integer);
    procedure Loadplaylist1Click(Sender: TObject);
    procedure Saveplaylist1Click(Sender: TObject);
    procedure playlist_sortInvClick(Sender: TObject);
    procedure btn_playlist_addfileClick(Sender: TObject);
    procedure btn_playlist_addfolderClick(Sender: TObject);
    procedure listview_srcCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure resultChatCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure listview_libCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure trackbar_playerTimer(sender: TObject; CurrentPos, StopPos: Cardinal);
    procedure userchatCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure filtroGraphComplete(sender: TObject; Result: HRESULT; Renderer: IBaseFilter);
    procedure panel_vidMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure treeview_downloadCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure treeview_uploadCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure listview_chat_channelCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure panel_playlistResize(Sender: TObject);
    procedure combo_lang_searchClick(Sender: TObject);
    procedure listview_playlistCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure treeview_lib_virfoldersCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure combotitsearchKeyPress(Sender: TObject; var Key: Char);
    procedure edit_titleKeyPress(Sender: TObject; var Key: Char);
    procedure treeview_lib_virfoldersMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AddtoPlaylist4Click(Sender: TObject);
    procedure listview_chat_channelAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
    procedure SendPrivateMessage1Click(Sender: TObject);
    procedure pvt_unhide(sender: tobject);
    procedure popup_chat_userlistPopup(Sender: TObject);
    procedure edit_chat_chanfilterKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure combo_chat_searchClick(Sender: TObject);
    procedure combo_chat_searchKeyPress(Sender: TObject; var Key: Char);
    procedure Download2Click(Sender: TObject);
    procedure btn_chat_searchClick(Sender: TObject);
    procedure popup_chat_searchPopup(Sender: TObject);
    procedure Ban2Click(Sender: TObject);
    procedure Kill1Click(Sender: TObject);
    procedure listview_chat_channelCollapsed(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure listview_libPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure GrantSlot1Click(Sender: TObject);
    procedure Grantupslot1Click(Sender: TObject);
    procedure treeview_downloadMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure All1Click(Sender: TObject);
    procedure Audio1Click(Sender: TObject);
    procedure Video1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Document1Click(Sender: TObject);
    procedure Software1Click(Sender: TObject);
    procedure libraryOnResize(Sender: TObject);
    procedure treeviewbrowseCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure treeviewbrowseClick(Sender: TObject);
    procedure treeviewbrowse2Click(Sender: TObject);
    procedure treeviewbrowseFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure treeviewbrowseGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure treeviewbrowseGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure treeviewbrowseGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure treeviewbrowseKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure treeviewbrowseMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure treeviewbrowse2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CometTreebrowseMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CometTreebrowseClick(Sender: TObject);
    procedure CometTreebrowseCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure CometTreebrowseFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure CometTreebrowseGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure CometTreebrowsePaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure CometTreebrowseGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure Download3Click(Sender: TObject);
    procedure Download4Click(Sender: TObject);
    procedure paintToolbar(sender: TObject; Acanvas: TCanvas; capt: widestring; var should_continue: boolean);
    procedure Artist4Click(Sender: TObject);
    procedure Genre4Click(Sender: TObject);
    procedure popup_chat_browsePopup(Sender: TObject);
    procedure Ban3Click(Sender: TObject);
    procedure Kill2Click(Sender: TObject);
    procedure Sendprivate1Click(Sender: TObject);
    procedure Chat4Click(Sender: TObject);
    procedure All2Click(Sender: TObject);
    procedure Audio2Click(Sender: TObject);
    procedure Video2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Document2Click(Sender: TObject);
    procedure Software2Click(Sender: TObject);
    procedure Chat5Click(Sender: TObject);
    procedure SendPrivate2Click(Sender: TObject);
    procedure DownloadHashLink1Click(Sender: TObject);
    procedure ExportHashLink1Click(Sender: TObject);
    procedure ExportHashlink2Click(Sender: TObject);
    procedure ExportHashlink3Click(Sender: TObject);

    procedure treeview_lib_regfoldersMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AddtoPlaylist5Click(Sender: TObject);
    procedure treeview_lib_regfoldersCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure btn_lib_regular_viewClick(Sender: TObject);
    procedure OpenFolder1Click(Sender: TObject);
    procedure panel_left_browse_resize(sender: tobject);
    procedure btn_chatbrowse_regular_viewclick(Sender: TObject);
    procedure btn_chatbrowse_virtual_viewclick(Sender: TObject);
    procedure Download5Click(Sender: TObject);
    procedure treeview_downloadDblClick(Sender: TObject);
    procedure panel_searchDrawHeaderBody(sender: TObject; TargetCanvas: TCanvas; aRect: TRect; HeaderColor: TColor);
    procedure label_back_srcMouseEnter(Sender: TObject);
    procedure label_back_srcMouseLeave(Sender: TObject);
    procedure panel_details_libraryAfterDraw(Sender: TObject; TargetCanvas: TCanvas);
    procedure panel_searchDraw(sender: TObject; Acanvas: TCanvas; capt: widestring; var should_continue: boolean);
    procedure panel_searchMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure panel_searchMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ExportHashlink4Click(Sender: TObject);
    procedure treeview_lib_regfoldersExpanding(Sender: TBaseCometTree; Node: PCmtVNode; var Allowed: Boolean);
    procedure btn_shareset_cancelClick(Sender: TObject);
    procedure btn_shareset_okClick(Sender: TObject);
    procedure pnl_opt_sharingResize(Sender: TObject);
    procedure mfolderCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure mfolderExpanding(Sender: TBaseCometTree; Node: PCmtVNode; var Allowed: Boolean);
    procedure mfolderGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
    procedure mfolderFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
    procedure mfolderGetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure mfolderGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure mfolderClick(Sender: TObject);
    procedure tabsheet_shareset_manuResize(Sender: TObject);
    procedure btn_shareset_atuostopClick(Sender: TObject);
    procedure btn_shareset_atuocheckallClick(Sender: TObject);
    procedure btn_shareset_atuoUncheckallClick(Sender: TObject);
    procedure btn_shareset_atuostartClick(Sender: TObject);
    procedure chklstbx_shareset_autoDblClick(Sender: TObject);
    procedure chklstbx_shareset_autoClick(Sender: TObject);
    procedure tabsheet_shareset_autoResize(Sender: TObject);
    procedure chklstbx_shareset_autoDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure btn_opt_tran_chshfoldClick(Sender: TObject);
    procedure btn_opt_tran_defshfoldClick(Sender: TObject);
    procedure Check_opt_chat_isawayClick(Sender: TObject);
    procedure btn_opt_proxy_checkClick(Sender: TObject);
    procedure radiobtn_noproxyClick(Sender: TObject);
    procedure edit_opt_proxy_loginChange(Sender: TObject);
    procedure edit_opt_proxy_passChange(Sender: TObject);
    procedure check_opt_net_nosprnodeClick(Sender: TObject);
    procedure check_opt_hlink_magnetClick(Sender: TObject);
    procedure Check_opt_hlink_filterexeClick(Sender: TObject);
    procedure Combo_opt_gen_gui_langClick(Sender: TObject);
    procedure edit_opt_gen_nickChange(Sender: TObject);
    procedure combo_opt_gen_speedClick(Sender: TObject);
    procedure check_opt_gen_autostartClick(Sender: TObject);
    procedure check_opt_gen_autoconnectClick(Sender: TObject);
    procedure check_opt_gen_gcloseClick(Sender: TObject);
    procedure check_opt_gen_nohintClick(Sender: TObject);
    procedure check_opt_gen_pausevidClick(Sender: TObject);
    procedure check_opt_gen_captClick(Sender: TObject);
    procedure Edit_dataportClick(Sender: TObject);
    procedure Edit_opt_tran_limupChange(Sender: TObject);
    procedure Edit_opt_tran_upipChange(Sender: TObject);
    procedure Edit_opt_tran_limdnChange(Sender: TObject);
    procedure Edit_opt_tran_upbandChange(Sender: TObject);
    procedure check_opt_tran_inconidleClick(Sender: TObject);
    procedure Edit_opt_tran_dnbandChange(Sender: TObject);
    procedure check_opt_tran_warncancClick(Sender: TObject);
    procedure check_opt_tran_percClick(Sender: TObject);
    procedure Check_opt_chat_timeClick(Sender: TObject);
    procedure Check_opt_chat_nopmClick(Sender: TObject);
    procedure check_opt_chat_browsableClick(Sender: TObject);
    procedure check_opt_chat_realbrowseClick(Sender: TObject);
    procedure Memo_opt_chat_awayChange(Sender: TObject);
    procedure treeview_downloadPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure btn_opt_chat_fontClick(Sender: TObject);
    procedure btn_toolbarchat_emoticonsclick(sender: tobject);
    procedure btn_toolbarchat_backgroundclick(sender: tobject);
    procedure btn_toolbarchat_textclick(sender: tobject);
    procedure btn_toolbarchat_underlineclick(sender: tobject);
    procedure btn_toolbarchat_italicclick(sender: tobject);
    procedure btn_toolbarchat_boldclick(sender: tobject);
    procedure N161DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure N161MeasureItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);
    procedure N161Click(Sender: TObject);
    procedure trackbar_playerChange(Sender: TObject);
    procedure Clearscreen1Click(Sender: TObject);
    procedure MsgHandler(var Msg: TMsg; var Handled: Boolean);
    procedure TntFormDestroy(Sender: TObject);
    procedure listview_chat_channelResize(Sender: TObject);
    procedure check_opt_chat_joinpartClick(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Exporthashlink5Click(Sender: TObject);
    procedure Memo_opt_chat_awayKeyPress(Sender: TObject; var Key: Char);
    procedure Locate3Click(Sender: TObject);
    procedure OpenExternal3Click(Sender: TObject);
    procedure addtoplaylist6Click(Sender: TObject);
    procedure Grantslot2Click(Sender: TObject);
    procedure btn_opt_chat_connectClick(Sender: TObject);
    procedure btn_chat_favClick(Sender: TObject);
    procedure treeview_chat_favoritesAfterCellPaint(Sender: TBaseCometTree;
      TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure treeview_chat_favoritesFreeNode(Sender: TBaseCometTree;
      Node: PCmtVNode);
    procedure treeview_chat_favoritesGetSize(Sender: TBaseCometTree;
      var Size: Integer);
    procedure treeview_chat_favoritesGetText(Sender: TBaseCometTree;
      Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
    procedure treeview_chat_favoritesGetImageIndex(Sender: TBaseCometTree;
      Node: PCmtVNode; var ImageIndex: Integer);
    procedure treeview_chat_favoritesCompareNodes(Sender: TBaseCometTree;
      Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
    procedure AddtoFavorites1Click(Sender: TObject);
    procedure Join1Click(Sender: TObject);
    procedure Remove1Click(Sender: TObject);
    procedure treeview_chat_favoritesMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ExportHashlink6Click(Sender: TObject);
    procedure Other1Click(Sender: TObject);
    procedure Other2Click(Sender: TObject);
    procedure radiostationclick(Sender: TObject);
    procedure RemoveSource1Click(Sender: TObject);
    procedure lbl_opt_skin_urlMouseEnter(Sender: TObject);
    procedure lbl_opt_skin_urlMouseLeave(Sender: TObject);
    procedure lbl_opt_skin_urlClick(Sender: TObject);
    procedure lstbox_opt_skinClick(Sender: TObject);
    procedure lbl_srcmime_audioClick(Sender: TObject);
    procedure lbl_srcmime_videoClick(Sender: TObject);
    procedure lbl_srcmime_documentClick(Sender: TObject);
    procedure lbl_srcmime_imageClick(Sender: TObject);
    procedure lbl_srcmime_softwareClick(Sender: TObject);
    procedure lbl_srcmime_otherClick(Sender: TObject);
    procedure lbl_lib_filesharedClick(Sender: TObject);
    procedure Check_opt_chatroom_nopmClick(Sender: TObject);
    procedure panel_vidDblClick(Sender: TObject);
    procedure TntFormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure listview_chat_channelPaintText(Sender: TBaseCometTree;
      const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure listview_chat_channelCollapsing(Sender: TBaseCometTree;
      Node: PCmtVNode; var Allowed: Boolean);
    procedure treeview_uploadPaintText(Sender: TBaseCometTree;
      const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
    procedure RemoveSource2Click(Sender: TObject);
    procedure AutoJoin1Click(Sender: TObject);
    procedure Check_opt_chat_autoaddClick(Sender: TObject);
    procedure btn_opt_torrent_chshfoldClick(Sender: TObject);
    procedure btn_opt_torrent_defshfoldClick(Sender: TObject);
    procedure check_opt_torrent_assocClick(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Locate4Click(Sender: TObject);
    procedure Enable1Click(Sender: TObject);
    procedure btn_player_radioClick(Sender: TObject);
    procedure ExportHashlink7Click(Sender: TObject);
    procedure check_opt_hlink_plsClick(Sender: TObject);
    procedure tmr_stop_radioTimer(Sender: TObject);
    procedure Volume1Click(Sender: TObject);
    procedure timer_fullScreenHideCursorTimer(Sender: TObject);
    procedure fullscreenMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PopupMenuvideoPopup(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntFormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure panel_player_captclick(Sender: TObject);
    procedure MPlayerPanel1Click(BtnId: TMPlayerButtonID);
    procedure MPlayerPanel1BtnHint(BtnId: TMPlayerButtonID);
    procedure TntFormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure tabs_pageviewPaintButtonFrame(Sender: TObject;
      aCanvas: TCanvas; paintRect: TRect);
    procedure smalltabs_pageviewPaintButtonFrame(Sender: TObject;
      aCanvas: TCanvas; paintRect: TRect);
    procedure tabs_pageviewPaintButton(Sender, aPanel: TObject;
      aCanvas: TCanvas; paintRect: TRect);
    procedure smallTabsPaintButton(Sender, aPanel: TObject;
      aCanvas: TCanvas; paintRect: TRect);
    procedure tabs_pageviewPanelShow(Sender, aPanel: TObject);
    procedure blendPlaylistFormDeactivate(Sender: TObject);
    procedure resizeSearch(Sender: TObject);
    procedure splitter_transferEndSplit(Sender: TObject);
    procedure btns_transferResize(Sender: TObject);
    procedure Splitter_chat_channelEndSplit(Sender: TObject);
    procedure panel_chatResize(Sender: TObject);
    procedure panel_chatPanelShow(Sender, aPanel: TObject);
    procedure pnl_chat_favResize(Sender: TObject);
    procedure panel_chatPaintCloseButton(Sender, aPanel: TObject;
      aCanvas: TCanvas; paintRect: TRect);
    procedure panel_chatPanelClose(Sender, aPanel: TObject; var Proceed: boolean);
    procedure btns_optionsResize(Sender: TObject);
    procedure pagesrcPanelShow(Sender, aPanel: TObject);
    procedure pagesrcPanelClose(Sender, aPanel: TObject;
      var Proceed: Boolean);
    procedure settings_controlPanelShow(Sender, aPanel: TObject);
    procedure edit_src_filterClick(Sender: TObject);
    procedure edit_lib_searchPaint(Sender: TObject; aCanvas: TCanvas;
      paintRect: TRect; btnState: TCometBtnState);
    procedure edit_lib_searchClick(Sender: TObject);
    procedure edit_lib_searchBtnClick(Sender: TObject);
    procedure edit_chat_chanfilterBtnClick(Sender: TObject);
    procedure edit_chat_chanfilterClick(Sender: TObject);
    procedure edit_chat_chanfilterBtnStateChange(Sender: TObject);
    procedure edit_src_filterBtnClick(Sender: TObject);
    procedure listview_libPaintHeader(Sender: TBaseCometTree;
      TargetCanvas: TCanvas; R: TRect; isDownIndex, isHoverIndex: Boolean;
      var shouldContinue: Boolean);
    procedure AddRemovefolderstosharelist2Click(Sender: TObject);
    procedure tray_showPlaylistClick(Sender: TObject);
    procedure check_opt_gen_msnsongClick(Sender: TObject);
    procedure check_opt_chat_taskbtnClick(Sender: TObject);
    procedure toggleChatTaskButtonClick(sender: TObject);
    procedure lbl_opt_homepageClick(Sender: TObject);
    procedure lbl_opt_homepageMouseLeave(Sender: TObject);
    procedure lbl_opt_homepageMouseEnter(Sender: TObject);
    procedure Stop2Click(Sender: TObject);
    procedure panel_playlistPaint(sender: TObject; Acanvas: TCanvas;
      capt: WideString; var should_continue: Boolean);
    procedure btn_opt_chat_stopClick(Sender: TObject);
    procedure btn_opt_chat_startClick(Sender: TObject);
    procedure btn_opt_chat_joinClick(Sender: TObject);
    procedure check_opt_chat_autocloseroomClick(Sender: TObject);
    procedure radio_srcmime_audioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TntFormPaint(Sender: TObject);
    procedure enableSysMenus;
    procedure toggleChatPvt(Sender, aPanel: TObject);
    procedure closePvt(Sender, aPanel: TObject; var Proceed: boolean);
    procedure check_opt_chat_noemotesClick(Sender: TObject);
    procedure Shoutcast1Click(Sender: TObject);
    procedure uner21Click(Sender: TObject);
    procedure RadioToolbox1Click(Sender: TObject);
    procedure tray_StopClick(Sender: TObject);
    procedure btn_opt_chat_setClick(Sender: TObject);
  private
    FDecsSecond: byte;
    FOleInPlaceActiveObject: IOleInPlaceActiveObject;

    procedure CheckMouseCapture;
    procedure DrawMouseOverButtons(var Message: TWMNCHitTest; point: Tpoint);
    procedure drawOverButtons(Overmin: boolean = false; OverMax: boolean = false; OverClose: boolean = false);
    procedure init_gui_first(sender: tobject);
    procedure init_gui_second(sender: Tobject);
    procedure init_core_first(Sender: TObject);
    procedure init_global_vars;
    procedure init_threads_var;
    procedure init_lists;
    procedure init_hint_wnd;
    procedure init_GUI_last;
    procedure trigger_sendedit_chat(edit_chat: ttntedit);
    procedure delete_file_da_tree_normal(folder_id: word; was_shared: boolean);
    procedure shared_unshare_treeview_normal(folder_id: word; shared: boolean);
    procedure tthread_lists_free;
    procedure crea_thread_share;


    function AsyncExFilterState(Buffering: LongBool; PreBuffering: LongBool; Connecting: LongBool; Playing: LongBool; BufferState: integer): HRESULT; stdcall;
    function AsyncExICYNotice(IcyItemName: PChar; ICYItem: PChar): HRESULT; stdcall;
    function AsyncExMetaData(Title: PChar; URL: PChar): HRESULT; stdcall;
    function AsyncExSockError(ErrString: PChar): HRESULT; stdcall;

    procedure global_shutdown; overload;
    procedure global_shutdown(dummy: boolean); overload;
    procedure global_shutdown(var message: tmessage); overload; message WM_USER_QUIT;
    procedure thread_share_end(var msg: tmessage); message WM_THREADSHARE_END;
    procedure thread_clientchat_end(var msg: tmessage); message WM_THREADCHATCLIENT_END;
    procedure DropFile(var message: TWMDropFiles); message WM_DROPFILES;
    procedure previewstart_event(var msg: tmessage); message WM_PREVIEW_START;
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure WMActivate(var msg: TWMACTIVATE); message WM_ACTIVATE;
    procedure thread_autoscan_end(var msg: tmessage); message WM_THREADSEARCHDIR_END;
    procedure WMQueryEndSession(var Message: TWMQUERYENDSESSION); message WM_QUERYENDSESSION;
    procedure WMUserShow(var msg: tmessage); message WM_USERSHOW;

    procedure WMNCLButtonDblClk(var Message: TWMNCLButtonDblClk); message WM_NCLBUTTONDBLCLK;
    procedure WMNCLButtonUp(var Message: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WMSyscommand(var msg: TWmSysCommand); message WM_SYSCOMMAND;
  public
    FrameRgn: HRgn;
    FSizing: boolean;
    FMinDown, FMaxDown, FCloseDown: boolean;
    isMaximised: boolean;
    oldwidth, oldheight, oldleft, oldtop: integer;
    procedure update_status_transfer;
    procedure paintFrame;
  end;

procedure MaximiseForm(MyForm: TForm);
function Drag_And_Drop_AddFile(FileName: wideString; count: integer): boolean;
procedure SetAnimation(Value: Boolean);
function GetAnimation: Boolean;
procedure DrawAppMinimizeAnimation(isMinimize: boolean);

var
  ares_frmmain: tares_frmmain;
  ThemeServices: TThemeServices;
  imgscnlogo: timage;
  GblTopMostList: tlist;

implementation

uses
  uctrvol, ufrmpvt, ufrmemoticon, dhtconsts, dhtkeywords, dhttypes,
  BitTorrentUtils, helper_ares_nodes, mysupernodes, thread_dht,
  ufrmChatTab;

{$R *.DFM}



function GetAnimation: Boolean;
var
  Info: TAnimationInfo;
begin
  Info.cbSize := SizeOf(TAnimationInfo);
  if SystemParametersInfo(SPI_GETANIMATION, SizeOf(Info), @Info, 0) then
    Result := Info.iMinAnimate <> 0 else
    Result := False;
end;

procedure SetAnimation(Value: Boolean);
var
  Info: TAnimationInfo;
begin
  Info.cbSize := SizeOf(TAnimationInfo);
  BOOL(Info.iMinAnimate) := Value;
  SystemParametersInfo(SPI_SETANIMATION, SizeOf(Info), @Info, 0);
end;

procedure DrawAppMinimizeAnimation(isMinimize: boolean);
var
  FormRect, TrayRect: TRect;
  hTray: THandle;
begin
  hTray := FindWindowEx(FindWindow('Shell_TrayWnd', nil), 0, 'TrayNotifyWnd', nil);
  if hTray = 0 then exit;

  FormRect := ares_frmmain.BoundsRect;
  GetWindowRect(hTray, TrayRect);

  if isMinimize then DrawAnimatedRects(ares_frmmain.Handle, IDANI_CAPTION, FormRect, TrayRect)
  else DrawAnimatedRects(ares_frmmain.Handle, IDANI_CAPTION, TrayRect, FormRect);
end;



///////////////// FRAME SKIN NC DRAWING

procedure tares_frmmain.WMWindowPosChanging(var Message: TWMWindowPosChanging);

  procedure HandleEdge(var Edge: Integer; SnapToEdge: Integer;
    SnapDistance: Integer = 0);
  begin
    if (Abs(Edge + SnapDistance - SnapToEdge) < 10) then
      Edge := SnapToEdge - SnapDistance;
  end;

var
  xr, yr: integer;
begin

  if (isMaximised) and (helper_skin.skinnedFrameLoaded) then begin
    xr := GetSystemMetrics(SM_CXFRAME);
    yr := GetSystemMetrics(SM_CYFRAME);
    Message.WindowPos^.x := screen.WorkAreaRect.Left - xr;
    Message.WindowPos^.y := screen.WorkAreaRect.top - yr;
    exit;
  end;


  if ((Message.WindowPos^.X <> 0) or (Message.WindowPos^.Y <> 0)) then
    with Message.WindowPos^, Monitor.WorkareaRect do
    begin
      if helper_skin.SkinnedFrameLoaded then begin
        xr := GetSystemMetrics(SM_CXFRAME);
        yr := GetSystemMetrics(SM_CYFRAME);
      end else begin
        xr := 0;
        yr := 0;
      end;
      HandleEdge(x, Left, Monitor.WorkareaRect.Left + yr);
      HandleEdge(y, Top, Monitor.WorkareaRect.Top + yr);
      HandleEdge(x, Right, Width - xr);
      HandleEdge(y, Bottom, Height - yr);
    end;

  inherited;
end;

procedure tares_frmmain.enableSysMenus;
var
  sysMenu: THandle;
begin
  if not helper_skin.SkinnedFrameLoaded then exit;
  sysMenu := GetSystemMenu(ares_frmmain.Handle, False);
  SetMenuGrayedState(sysmenu, SC_MYRESTORE, (ares_frmmain.isMaximised) or (isIconic(ares_frmmain.handle)) or (isIconic(application.handle)));
  SetMenuGrayedState(sysmenu, SC_MYMAXIMIZE, (not ares_frmmain.isMaximised) and not ((isIconic(ares_frmmain.handle)) or (isIconic(application.handle))));
  SetMenuGrayedState(sysmenu, SC_MYMINIMIZE, not isIconic(ares_frmmain.handle));
end;

procedure tares_frmmain.WMNCLButtonDown(var Message: TWMNCLButtonDown);
begin
  if not helper_skin.skinnedFrameLoaded then begin
    inherited;
    exit;
  end;

  if IsIconic(Handle) then begin
    inherited; {Call default processing.}
    exit;
  end;

  if (isMaximised) then begin
    if Message.HitTest = HTSYSMENU then inherited;
    exit;
  end;

  case Message.HitTest of

    HTMINBUTTON: begin
       //canvas.draw(clientwidth+skinParser.MinimiseLeft,skinParser.MinimiseTop,minimiseDownBitmap);
        SetCapture(self.handle);
        FMinDown := true;
        FMaxDown := false;
        FCloseDown := false;
      end;

    HTMAXBUTTON: begin
          //canvas.draw(clientwidth+skinParser.MaximiseLeft,skinParser.MaximiseTop,skinParser.maximisedDownBitmap);
        SetCapture(self.handle);
        FMaxDown := true;
        FMinDown := false;
        FCloseDown := false;
      end;

    HTCLOSE: begin
        SetCapture(self.handle);
        FCloseDown := true;
        FMinDown := false;
        FMaxDown := false;
        //canvas.draw(clientwidth+skinParser.closeLeft,skinParser.closeTop,skinParser.closeDownBitmap);
      end;

  else begin
      inherited; {Call default processing.}
    end;
  end;

end;

procedure tares_frmmain.WMNCHitTest(var Message: TWMNCHitTest);
var
  point: Tpoint;
  sizeHe, sizeWi: integer;
begin

  if not helper_skin.skinnedFrameLoaded then begin
    inherited; {Call default processing.}
    exit;
  end;

  point.x := Message.Pos.x;
  point.y := Message.Pos.y;
  point := ScreenToClient(point);

  // inc(point.X,GetSystemMetrics(SM_CXSIZEFRAME));
  sizeHe := GetSystemMetrics(SM_CYSIZEFRAME);

  if (point.x <= helper_skin.FBorderWidth) and (not isMaximised) then begin
    CheckMouseCapture;
    if (point.y < helper_skin.FBorderHeight) and (not isMaximised) then Message.Result := HTTOPLEFT
    else
      if (point.Y >= clientheight - helper_skin.FBorderHeight) and (not isMaximised) then Message.Result := HTBOTTOMLEFT
      else
        if not isMaximised then Message.Result := HTLEFT
        else Message.result := windows.HTNOWHERE;
  end else
    if (point.x >= clientwidth - helper_skin.FBorderWidth) and (not isMaximised) then begin
      CheckMouseCapture;
      drawOverButtons;
      if (point.y < helper_skin.FBorderHeight) and (not isMaximised) then Message.Result := HTTOPRIGHT
      else
        if (point.Y >= clientheight - helper_skin.FBorderHeight) and (not isMaximised) then Message.Result := HTBOTTOMRIGHT
        else
          if not isMaximised then Message.result := HTRIGHT
          else Message.result := windows.HTNOWHERE;
    end else
      if point.y >= clientheight - helper_skin.FBorderHeight then begin
        CheckMouseCapture;
        if not isMaximised then Message.result := HTBOTTOM
        else Message.result := windows.HTNOWHERE;
      end else
        if point.y < sizeHe then begin
          CheckMouseCapture;
          drawOverButtons;
          if not isMaximised then Message.Result := HTTOP
          else Message.result := windows.HTNOWHERE;
        end else
          if ((point.y >= sizeHe {default border height}) and (point.y <= helper_skin.FCaptionHeight)) then begin
            if point.x < clientwidth - helper_skin.FrameTopRigthBitmap.SourceCopyWidth then begin
              CheckMouseCapture;
              drawOverButtons;
              if ((point.x < helper_skin.FCaptionIconRect.Left + 16) and
                (helper_skin.FCaptionIconRect.left > 0)) then message.result := HTSYSMENU
              else
                Message.Result := HTCAPTION;
            end else DrawMouseOverButtons(Message, point); //HTCLOSE;//HTMAXBUTTON//HTMAXBUTTON
          end else begin
            CheckMouseCapture;
            drawOverButtons;
            Message.Result := HTCLIENT;
          end;

end;

procedure tares_frmmain.CMMouseLeave(var Msg: TMessage);
begin
  if not helper_skin.skinnedFrameLoaded then exit;
  if getCapture <> self.Handle then begin
    FCloseDown := false;
    FMaxDown := false;
    FMinDown := false;
  end;
  drawOverButtons;
end;

procedure tares_frmmain.paintFrame;
var
  rc: trect;
  pointx, pointy: integer;

begin

  canvas.Lock;

 // top left
  bitBlt(canvas.handle,
    0, 0, helper_skin.FrameTopLeftBitmap.SourceCopyWidth, helper_skin.FrameTopLeftBitmap.SourceCopyHeight,
    helper_skin.FrameSourceBitmap.canvas.Handle,
    helper_skin.FrameTopLeftBitmap.SourceCopyleft, helper_skin.FrameTopLeftBitmap.SourceCopyTop,
    SRCCopy);

 // top
  pointx := helper_skin.FrameTopLeftBitmap.SourceCopyWidth;
  while (pointx < clientwidth - helper_skin.FrameTopRigthBitmap.SourceCopyWidth) do begin
    BitBlt(canvas.handle,
      pointx, 0, helper_skin.FrameTopBitmap.SourceCopyWidth, helper_skin.FrameTopBitmap.SourceCopyHeight,
      helper_skin.FrameSourceBitmap.canvas.handle,
      helper_skin.FrameTopBitmap.SourceCopyleft, helper_skin.FrameTopBitmap.SourceCopyTop,
      SRCCopy);
    inc(pointx, helper_skin.FrameTopBitmap.SourceCopyWidth);
  end;


 //lefttop
  bitBlt(canvas.handle,
    0, helper_skin.FrameTopLeftBitmap.SourceCopyHeight, helper_skin.FrameLeftTopBitmap.SourceCopyWidth, helper_skin.FrameLeftTopBitmap.SourceCopyHeight,
    helper_skin.FrameSourceBitmap.canvas.Handle,
    helper_skin.FrameLeftTopBitmap.SourceCopyleft, helper_skin.FrameLeftTopBitmap.SourceCopyTop,
    SRCCopy);


 // left border
  pointy := helper_skin.FrameTopLeftBitmap.SourceCopyHeight + helper_skin.FrameLeftTopBitmap.SourceCopyHeight;
  while (pointy < (clientHeight - helper_skin.FrameLeftBottomBitmap.SourceCopyHeight) - helper_skin.FrameBottomLeftBitmap.SourceCopyHeight) do begin
 // canvas.Draw(0,pointy,helper_skin.leftBitmap);
    BitBlt(canvas.handle,
      0, pointY, helper_skin.FrameLeftBitmap.SourceCopyWidth, helper_skin.FrameLeftBitmap.SourceCopyHeight,
      helper_skin.FrameSourceBitmap.canvas.Handle,
      helper_skin.FrameLeftBitmap.SourceCopyleft, helper_skin.FrameLeftBitmap.SourceCopyTop,
      SRCCopy);
    inc(pointy, helper_skin.FrameLeftBitmap.SourceCopyHeight);
  end;


 // left bottom corner
  BitBlt(canvas.handle,
    0, (clientHeight - helper_skin.FrameLeftBottomBitmap.SourceCopyHeight) - helper_skin.FrameBottomLeftBitmap.SourceCopyHeight, helper_skin.FrameLeftBottomBitmap.SourceCopyWidth, helper_skin.FrameLeftBottomBitmap.SourceCopyHeight,
    helper_skin.FrameSourceBitmap.canvas.handle,
    helper_skin.FrameLeftBottomBitmap.SourceCopyleft, helper_skin.FrameLeftBottomBitmap.SourceCopyTop,
    SRCCopy);

 // bottom left corner
  BitBlt(canvas.handle,
    0, clientHeight - helper_skin.FrameBottomLeftBitmap.SourceCopyHeight, helper_skin.FrameBottomLeftBitmap.SourceCopyWidth, helper_skin.FrameBottomLeftBitmap.SourceCopyHeight,
    helper_skin.FrameSourceBitmap.canvas.handle,
    helper_skin.FrameBottomLeftBitmap.SourceCopyleft, helper_skin.FrameBottomLeftBitmap.SourceCopyTop,
    SRCCopy);



 // bottom border
  pointx := helper_skin.FrameBottomLeftBitmap.SourceCopyWidth;
  while (pointx < clientwidth - helper_skin.FrameBottomRightBitmap.SourceCopyWidth) do begin
    BitBlt(canvas.handle,
      pointx, clientheight - helper_skin.FrameBottomBitmap.SourceCopyHeight, helper_skin.FrameBottomBitmap.SourceCopyWidth, helper_skin.FrameBottomBitmap.SourceCopyHeight,
      helper_skin.FrameSourceBitmap.canvas.handle,
      helper_skin.FrameBottomBitmap.SourceCopyleft, helper_skin.FrameBottomBitmap.SourceCopyTop,
      SRCCopy);
 // canvas.draw(pointx,clientheight-helper_skin.bottomBitmap.height,helper_skin.bottomBitmap);
    inc(pointx, helper_skin.FrameBottomBitmap.SourceCopyWidth);
  end;

 //right border
  pointy := helper_skin.FrameTopRigthBitmap.SourceCopyHeight + helper_skin.FrameRightTopBitmap.SourceCopyHeight;
  while (pointy < (clientheight - helper_skin.FrameBottomRightBitmap.SourceCopyHeight) - helper_skin.FrameRightBottomBitmap.SourceCopyHeight) do begin
    BitBlt(canvas.handle,
      clientwidth - helper_skin.FrameRightBitmap.SourceCopyWidth, pointY, helper_skin.FrameRightBitmap.SourceCopyWidth, helper_skin.FrameRightBitmap.SourceCopyHeight,
      helper_skin.FrameSourceBitmap.canvas.handle,
      helper_skin.FrameRightBitmap.SourceCopyleft, helper_skin.FrameRightBitmap.SourceCopyTop,
      SRCCopy);
    inc(pointy, helper_skin.FrameRightBitmap.SourceCopyHeight);
  end;


  //rightbottom
  BitBlt(canvas.handle,
    clientWidth - helper_skin.FrameRightBottomBitmap.SourceCopyWidth, (clientHeight - helper_skin.FrameBottomRightBitmap.SourceCopyHeight) - helper_skin.FrameRightBottomBitmap.SourceCopyHeight, helper_skin.FrameRightBottomBitmap.SourceCopyWidth, helper_skin.FrameRightBottomBitmap.SourceCopyHeight,
    helper_skin.FrameSourceBitmap.canvas.handle,
    helper_skin.FrameRightBottomBitmap.SourceCopyleft, helper_skin.FrameRightBottomBitmap.SourceCopyTop,
    SRCCopy);



 //bottom right
  BitBlt(canvas.handle,
    clientwidth - helper_skin.FrameBottomRightBitmap.SourceCopyWidth, clientHeight - helper_skin.FrameBottomRightBitmap.SourceCopyHeight, helper_skin.FrameBottomRightBitmap.SourceCopyWidth, helper_skin.FrameBottomRightBitmap.SourceCopyHeight,
    helper_skin.FrameSourceBitmap.canvas.handle,
    helper_skin.FrameBottomRightBitmap.SourceCopyleft, helper_skin.FrameBottomRightBitmap.SourceCopyTop,
    SRCCopy);

 // rightTop border
  BitBlt(canvas.handle,
    clientwidth - helper_skin.FrameRightTopBitmap.SourceCopyWidth, helper_skin.FrameTopLeftBitmap.SourceCopyHeight, helper_skin.FrameRightTopBitmap.SourceCopyWidth, helper_skin.FrameRightTopBitmap.SourceCopyHeight,
    helper_skin.FrameSourceBitmap.canvas.handle,
    helper_skin.FrameRightTopBitmap.SourceCopyleft, helper_skin.FrameRightTopBitmap.SourceCopyTop,
    SRCCopy);



  if helper_skin.FCaptionIconRect.left >= 0 then begin
    DrawIconEx(canvas.handle, helper_skin.FCaptionIconRect.left, helper_skin.FCaptionIconRect.Top, self.icon.Handle, 0, 0, 0, 0, DI_NORMAL);
  end;

  canvas.font.color := helper_skin.color_skinned_caption;
  canvas.font.name := font.name;
  canvas.font.size := font.size;
  canvas.font.style := [fsBold];

  rc := rect(helper_skin.FCaptionRect.left, helper_skin.FCaptionRect.top, width - helper_skin.FrameTopRigthBitmap.SourceCopyWidth, helper_skin.FrameTopLeftBitmap.SourceCopyHeight - helper_skin.FCaptionRect.top);

  SetBkMode(canvas.Handle, TRANSPARENT);
  canvas.brush.style := bsclear;
  Windows.ExtTextOutW(canvas.Handle, helper_skin.FCaptionRect.left, helper_skin.FCaptionRect.top, ETO_CLIPPED, @rc, PWideChar(caption), Length(Caption), nil);


    // top right...buttons
  bitBlt(canvas.handle,
    clientwidth - helper_skin.FrameTopRigthBitmap.SourceCopyWidth, 0, helper_skin.FrameTopRigthBitmap.SourceCopyWidth, helper_skin.FrameTopRigthBitmap.SourceCopyHeight,
    helper_skin.FrameSourceBitmap.canvas.Handle,
    helper_skin.FrameTopRigthBitmap.SourceCopyleft, helper_skin.FrameTopRigthBitmap.SourceCopyTop,
    SRCCopy);

  canvas.unlock;

end;

procedure tares_frmmain.CheckMouseCapture;
begin

  if GetCapture <> self.handle then begin
    FMinDown := false;
    FMaxDown := false;
    FCloseDown := false;
  end;

end;

procedure MaximiseForm(MyForm: TForm);
var
  r: TRect;
  xr, yr: integer;
begin

  xr := GetSystemMetrics(SM_CXFRAME);
  yr := GetSystemMetrics(SM_CYFRAME);

  r := myform.Monitor.WorkareaRect;
      //r:=screen.WorkAreaRect;
  setWindowPos(myform.handle, 0,
    r.Left - xr, r.top - yr,
    (r.right - r.left) + 1 + (xr * 2), (r.bottom - r.top) + 1 + (yr * 2),
    SWP_NOZORDER);

end;

procedure tares_frmmain.DrawMouseOverButtons(var Message: TWMNCHitTest; point: Tpoint);
var
  HasCapture: boolean;
begin
  hasCapture := (GetCapture = self.handle);

  if ((point.x >= width + helper_skin.MinimisebtnHitRect.Left) and (point.x <= (width + helper_skin.MinimisebtnHitRect.Left) + helper_skin.MinimisebtnHitRect.right) and
    (point.y >= helper_skin.MinimisebtnHitRect.Top) and (point.y <= helper_skin.MinimisebtnHitRect.Top + helper_skin.MinimisebtnHitRect.bottom)) then begin
    Message.result := HTMINBUTTON;
    DrawOverButtons(true, false, false);
    if ((not HasCapture) and (FminDown)) then postMessage(self.handle, WM_NCLBUTTONUP, HTMINBUTTON, 0) else
      if not HasCapture then begin
        FMinDown := false;
        FCloseDown := false;
        FMaxDown := false;
      end;
 // if HasCapture then
  // if FMinDown then application.Minimize;
  end else
    if ((point.x >= width + helper_skin.MaximisebtnHitRect.Left) and (point.x <= (width + helper_skin.MaximisebtnHitRect.Left) + helper_skin.MaximiseBtnHitRect.right) and
      (point.y >= helper_skin.MaximisebtnHitRect.Top) and (point.y <= helper_skin.MaximisebtnHitRect.Top + helper_skin.MaximisebtnHitRect.bottom)) then begin
      Message.result := HTMAXBUTTON;
      DrawOverButtons(false, true, false);
      if ((not HasCapture) and (FMaxDown)) then postMessage(self.handle, WM_NCLBUTTONUP, HTMAXBUTTON, 0) else
        if not HasCapture then begin
          FMinDown := false;
          FCloseDown := false;
          FMaxDown := false;
        end;
    end else
      if ((point.x >= width + helper_skin.closebtnHitRect.Left) and (point.x <= (width + helper_skin.closebtnHitRect.Left) + helper_skin.closebtnHitRect.right) and
        (point.y >= helper_skin.closebtnHitRect.Top) and (point.y <= helper_skin.closebtnHitRect.Top + helper_skin.closebtnHitRect.bottom)) then begin
        Message.result := HTCLOSE;
        DrawOverButtons(false, false, true);
        if ((not HasCapture) and (FCloseDown)) then postMessage(self.handle, WM_NCLBUTTONUP, HTCLOSE, 0) else
          if not HasCapture then begin
            FMinDown := false;
            FCloseDown := false;
            FMaxDown := false;
          end;
      end else begin
        drawOverButtons;
    //just guessing...
        if point.y < 4 then Message.Result := HTTOP
        else Message.Result := HTCAPTION;
        exit;
      end;

end;

procedure tares_frmmain.drawOverButtons(Overmin: boolean = false; OverMax: boolean = false; OverClose: boolean = false);
begin

  canvas.lock;

  if ((OverMin) and (not FMinDown) and (not FMaxDown) and (not FCloseDown)) then bitBlt(canvas.handle,
      clientwidth + helper_skin.MinimiseBtnPaintPoint.x, helper_skin.MinimiseBtnPaintPoint.y, helper_skin.FrameMinimiseOffBitmap.SourceCopyWidth, helper_skin.FrameMinimiseOffBitmap.SourceCopyHeight,
      helper_skin.FrameSourceBitmap.Canvas.handle,
      helper_skin.FrameMinimiseHoverBitmap.SourceCopyleft, helper_skin.FrameMinimiseHoverBitmap.SourceCopyTop,
      SRCCopy)

  else
    if ((FMinDown) and (OverMin)) then bitBlt(canvas.handle,
        clientwidth + helper_skin.MinimiseBtnPaintPoint.x, helper_skin.MinimiseBtnPaintPoint.y, helper_skin.FrameMinimiseOffBitmap.SourceCopyWidth, helper_skin.FrameMinimiseOffBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.Canvas.handle,
        helper_skin.FrameMinimiseDownBitmap.SourceCopyleft, helper_skin.FrameMinimiseDownBitmap.SourceCopyTop,
        SRCCopy)

    else
      bitBlt(canvas.handle,
        clientwidth + helper_skin.MinimiseBtnPaintPoint.x, helper_skin.MinimiseBtnPaintPoint.y, helper_skin.FrameMinimiseOffBitmap.SourceCopyWidth, helper_skin.FrameMinimiseOffBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.Canvas.handle,
        helper_skin.FrameMinimiseOffBitmap.SourceCopyleft, helper_skin.FrameMinimiseOffBitmap.SourceCopyTop,
        SRCCopy);




  if ((OverMax) and (not FMaxDown) and (not FMinDown) and (not FCloseDown)) then bitBlt(canvas.handle,
      clientwidth + helper_skin.MaximiseBtnPaintPoint.x, helper_skin.MaximiseBtnPaintPoint.y, helper_skin.FrameMaximiseOffBitmap.SourceCopyWidth, helper_skin.FrameMaximiseOffBitmap.SourceCopyHeight,
      helper_skin.FrameSourceBitmap.Canvas.handle,
      helper_skin.FrameMaximiseHoverBitmap.SourceCopyleft, helper_skin.FrameMaximiseHoverBitmap.SourceCopyTop,
      SRCCopy)
  else
    if ((FMaxDown) and (OverMax)) then bitBlt(canvas.handle,
        clientwidth + helper_skin.MaximiseBtnPaintPoint.x, helper_skin.MaximiseBtnPaintPoint.y, helper_skin.FrameMaximiseOffBitmap.SourceCopyWidth, helper_skin.FrameMaximiseOffBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.Canvas.handle,
        helper_skin.FrameMaximiseDownBitmap.SourceCopyleft, helper_skin.FrameMaximiseDownBitmap.SourceCopyTop,
        SRCCopy)
    else
      bitBlt(canvas.handle,
        clientwidth + helper_skin.MaximiseBtnPaintPoint.x, helper_skin.MaximiseBtnPaintPoint.y, helper_skin.FrameMaximiseOffBitmap.SourceCopyWidth, helper_skin.FrameMaximiseOffBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.Canvas.handle,
        helper_skin.FrameMaximiseOffBitmap.SourceCopyleft, helper_skin.FrameMaximiseOffBitmap.SourceCopyTop,
        SRCCopy);



  if ((OverClose) and (not FCloseDown) and (not FMaxDown) and (not FMinDown)) then bitBlt(canvas.handle,
      clientwidth + helper_skin.CloseBtnPaintPoint.x, helper_skin.CloseBtnPaintPoint.y, helper_skin.FrameCloseOffBitmap.SourceCopyWidth, helper_skin.FrameCloseOffBitmap.SourceCopyHeight,
      helper_skin.FrameSourceBitmap.Canvas.handle,
      helper_skin.FrameCloseHoverBitmap.SourceCopyleft, helper_skin.FrameCloseHoverBitmap.SourceCopyTop,
      SRCCopy)
  else
    if ((FCloseDown) and (OverClose)) then bitBlt(canvas.handle,
        clientwidth + helper_skin.CloseBtnPaintPoint.x, helper_skin.CloseBtnPaintPoint.y, helper_skin.FrameCloseOffBitmap.SourceCopyWidth, helper_skin.FrameCloseOffBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.Canvas.handle,
        helper_skin.FrameCloseDownBitmap.SourceCopyleft, helper_skin.FrameCloseDownBitmap.SourceCopyTop,
        SRCCopy)
    else
      bitBlt(canvas.handle,
        clientwidth + helper_skin.CloseBtnPaintPoint.x, helper_skin.CloseBtnPaintPoint.y, helper_skin.FrameCloseOffBitmap.SourceCopyWidth, helper_skin.FrameCloseOffBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.Canvas.handle,
        helper_skin.FrameCloseOffBitmap.SourceCopyleft, helper_skin.FrameCloseOffBitmap.SourceCopyTop,
        SRCCopy);

  canvas.unlock;
end;

procedure tares_frmmain.WMNCLButtonUp(var Message: TWMNCLButtonUp);
begin


  if not helper_skin.skinnedFrameLoaded then begin
    inherited;
    exit;
  end;

  if IsIconic(self.Handle) then begin
    FCloseDown := false;
    FMaxDown := false;
    FMinDown := false;
    inherited; {Call default processing.}
    exit;
  end;


  case Message.HitTest of

    HTMINBUTTON: begin
        Sendmessage(self.handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
      end;

    HTMAXBUTTON: begin
        if not isMaximised then SendMessage(self.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0)
        else SendMessage(self.handle, WM_SYSCOMMAND, SC_RESTORE, 0);
      end;

    HTCLOSE: begin
        sendmessage(self.handle, WM_SYSCOMMAND, SC_CLOSE, 0);
      end;

  else begin
      inherited; {Call default processing.}
    end;

  end;


  if GetCapture = self.handle then ReleaseCapture;
  FCloseDown := false;
  FMaxDown := false;
  FMinDown := false;
end;

procedure tares_frmmain.WMNCLButtonDblClk(var Message: TWMNCLButtonDblClk);
//var
//pt : TPoint;
begin
  if not helper_skin.skinnedFrameLoaded then begin
    inherited;
    exit;
  end;

//pt := Point(Message.XCursor, Message.YCursor);

  if (Message.HitTest = HTCAPTION) and not IsIconic(Handle) then begin

    if windowState <> wsMaximized then SendMessage(self.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0)
    else SendMessage(self.handle, WM_SYSCOMMAND, SC_RESTORE, 0);

  end else
    if (Message.HitTest = HTSYSMENU) and not IsIconic(handle) then SendMessage(self.handle, WM_SYSCOMMAND, SC_CLOSE, 0);
end;

///////////////////////////////////////////////////////////////////////////////
// dra&drop
/////////////////////////////////////////////////////////////////////////////

function Drag_And_Drop_AddFile(FileName: wideString; count: integer): boolean;
var
  nomeutf8, estensione: string;
  shouldEnqueue: boolean;
begin
  result := true;

 //helper_gui_misc.showMainWindow;

  if copy(filename, 1, 4) = '/ADD' then begin
    delete(filename, 1, 4);
    shouldEnqueue := true;
  end else shouldEnqueue := false;

  nomeutf8 := widestrtoutf8str(filename);
  estensione := lowercase(extractfileext(nomeutf8));

  if estensione = '.arescol' then begin //load arescollection
    arescol_parse_file(filename);
    exit;
  end;
  if estensione = '.torrent' then begin
    bittorrentUtils.loadTorrent(filename);
    exit;
  end;
  if estensione = '.m3u' then begin //load playlist file
    playlist_loadm3u(filename, false);
    if not shouldEnqueue then playlist_playnext('');
    exit;
  end;
  if estensione = '.pls' then begin
    playlist_loadpls(filename);
    exit;
  end;
  if (estensione = '.wax') or (estensione = '.asx') then begin
    playlist_loadwax(filename);
    exit;
  end;

  if estensione = '.lnk' then filename := estrai_path_da_lnk(filename); //obtain real path

  if isfolder(filename) then playlist_addfolder(nomeutf8)
  else playlist_addfile(nomeutf8, -1, false, '');

  if pos(estensione, PLAYABLE_IMAGE_EXT) <> 0 then player_playnew(filename);

  if helper_player.m_GraphBuilder <> nil then if helper_player.player_GetState <> gsStopped then exit; //already playing

  helper_player.player_actualfile := '';

  if not shouldEnqueue then playlist_playnext(filename); //a call to player
end;

procedure Tares_frmmain.DropFile(var message: TWMDropFiles);
begin
  DropGetFiles(message, Drag_And_Drop_AddFile);
  Dropped(message); // Very important
end;
/////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////// init procedures

procedure tares_frmmain.init_global_vars;
begin

  randomize;

  FrameRgn := 0;
  helper_skin.NilFrameImages;
  blendPlaylistForm := nil;
  vars_global.ChatServiceRunning := false;
  vars_global.IDEIsRunning := false;
  isMaximised := false;

  DHT_availableContacts := 0; // need bootstrap?
  DHT_AliveContacts := 0;
  DHT_possibleBootstrapClientIP := 0;
  DHT_possibleBootstrapClientPort := 0;
  availableCaches := nil;
  DHT_hashFiles := nil;
  DHT_KeywordFiles := nil;
  DHT_LastPublishKeyFiles := 0;
  DHT_LastPublishHashFiles := 0;

  helper_player.m_GraphBuilder := nil;
  helper_player.m_MediaControl := nil;
  helper_player.m_AsyncEx := nil;
  helper_player.m_AsyncExControl := nil;
  helpeR_player.m_Pin := nil;
  helper_player.m_FileSource := nil;
  helper_player.m_Mp3Dec := nil;

  helper_player.FFullScreenWindow := nil;

  shoutcast.isPlayingShoutcast := false;
  shoutcast.RenderError := false;

  lista_down_temp := nil;
  imgscnlogo := nil;
  filtro2 := nil;

  BitTorrentTempList := nil;
  bittorrent_Accepted_sockets := nil;
  thread_bittorrent := nil;

  app_minimized := false;
  last_shown_SRCtab := 0;
  typed_lines_chat := nil;
  ending_session := false;
  chat_favorite_height := 0;
  vars_global.closing := false;
  initialized := false;
  cambiato_manual_folder_share := false;
  isvideoplaying := false;
  allow_regular_paths_browse := true;
  cambiato_setting_autoscan := false;
  program_start_time := gettickcount;
  changed_download_hashes := false;
  ShareScans := 0;
  shufflying_playlist := false;
  stopped_by_user := false;
  logon_time := 0;
  vars_global.was_on_src_tab := false;
  velocita_att_upload := 0;
  velocita_att_download := 0;
  hash_select_in_library := '';
  ever_pressed_chat_list := false;
  hashing := false;
  queue_firstinfirstout := true;
  numero_pvt_open := 0;
  socks_type := SoctNone;
  socks_password := '';
  socks_username := '';
  socks_ip := '';
  socks_port := 0;
  ip_user_granted := 0;
  port_user_granted := 0;
  FDecsSecond := 0;
  ip_alt_granted := 0;
  image_less_top := -1;
  image_more_top := -1;
  image_back_top := -1;
  MAX_SIZE_NO_QUEUE := 256 * KBYTE;
// sizexvideo:=0;
  queue_length := 0;
  numero_upload := 0;
  numero_download := 0;
  numTorrentDownloads := 0;
  numTorrentUploads := 0;
  speedTorrentDownloads := 0;
  speedTorrentUploads := 0;
  downloadedBytes := 0;
  BitTorrentDownloadedBytes := 0;
  BitTorrentUploadedBytes := 0;
  numero_queued := 0;
  localip := cAnyHost;
  previous_hint_node := nil;
  graphIsDownload := false;
  graphIsUpload := false;
  handle_obj_graphhint := INVALID_HANDLE_VALUE;
  player_actualfile := '';
  panel6sizedefault := 175;
  default_width_chat := 220;
  num_seconds := 0;
  up_band_allow := 0;
  down_band_allow := 0;
  im_firewalled := true;
  update_my_nick := false;
  last_chat_req := 0;
  last_mem_check := 0;
  need_rescan := false;
  playlist_visible := false;
  should_send_channel_list := false;
  my_shared_count := 0;
  oldhintposy := 0;
  oldhintposx := 0;
  partialUploadSent := 0;
  speedUploadPartial := 0;

  helper_diskio.SetfilePointerEx := nil;
  helper_diskio.kern32handle := 0;



end;



procedure tares_frmmain.init_threads_var;
begin
  search_dir := nil;
  thread_down := nil;
  thread_up := nil;
  hash_server := nil;
  client_chat := nil;
  cache_server := nil;
  threadDHT := nil;
  share := nil;
  client := nil;
end;

procedure tares_frmmain.init_lists;
begin
  lista_shared := nil;
  lista_socket_accept_down := nil;
  lista_risorse_temp := nil;
  lista_risorsepartial_temp := nil;
  lista_socket_temp_proxy := nil;
  list_chatchan_visual := tmylist.create;
  src_panel_list := tmylist.create;
  chat_chanlist_backup := tmylist.create;
  fresh_downloaded_files := nil;
end;



////////////////////////////////////////////////////////////////////////////////////
// init GUI
/////////////////////////////////////////////////////////////////////////////////////

procedure tares_frmmain.init_gui_first(sender: tobject); //1 second after oncreate?
begin

  with sender as ttimer do free;

  init_global_vars;
  init_threads_var;
  init_lists;


  font_chat := tfont.create;

  try
    app_path := get_app_path;
    if Win32Platform = VER_PLATFORM_WIN32_NT then begin
      data_path := Get_App_DataPath + '\' + appname;
      tntwindows.Tnt_createdirectoryW(pwidechar(data_path), nil);
    end else data_path := app_path;

  except
  end;

  init_hint_wnd;
  helper_gui_misc.init_tabs_first;
  helper_skin.GetOemMenuStrings(self);

  mainGUI_loadStartSkin;
  localiz_loadlanguage;



  helper_gui_misc.init_Tabs_second;
  mainGui_apply_languageFirst;


  panel_Src_default.font.color := vars_global.COLORE_LISTVIEWS_FONT;
  panel_search.color := COLORE_SEARCH_PANEL;
  edit_src_filter.font.color := font.color;


  panel_search.OnPaint := panel_searchDraw;

  DoubleBuffered := True;
  mainGui_setposition;

  try
    if combo_search.canFocus then combo_search.SetFocus; //fixes the hide issue in vista

  except
  end;

  with ttimer.create(self) do begin
    ontimer := init_gui_second;
    interval := 10;
    enabled := true;
  end;

end;

procedure tares_frmmain.init_gui_second(sender: Tobject);
begin

  with sender as ttimer do free;

  prendi_prefs_reg;
  mainGui_applyChanges;
  mainGui_apply_language;
  listview_lib.bgcolor := COLORE_ALTERNATE_ROW;
  listview_lib.colors.HotColor := COLORE_LISTVIEW_HOT;
  listview_chat_channel.bgcolor := COLORE_ALTERNATE_ROW;
  listview_chat_channel.colors.HotColor := COLORE_LISTVIEW_HOT;

  panel_tran_down.capt := chr(32) + GetLangStringW(STR_DOWNLOAD) + ': 0' + STR_KB + chr(32) + GetLangStringW(STR_RECEIVED);
  panel_tran_upqu.capt := chr(32) + GetLangStringW(STR_UPLOAD) + ': 0' + STR_KB + chr(32) + GetLangStringW(STR_SENT);
  lbl_opt_statusconn.caption := '';
  mainGui_applymaxlengths;


  imglist_emotic.BkColor := clnone;
  imglist_emotic.BlendColor := clnone;


  panel_transferResize(panel_transfer);
  update_status_transfer;

  with trayicon1 do begin
    icon := application.icon;
    minimizetotray := true;
    enabled := true;
    showhint := true;
    ondblclick := tray_MinimizeClick;
    popupmenu := Popup_Tray;
    handle_main := self.Handle;
  end;



  try
    panelUploadHeight := get_default_upload_height(200);
  except
  end;

  if btn_lib_virtual_view.down then ufrmmain.ares_frmmain.btn_lib_virtual_viewclick(nil)
  else ufrmmain.ares_frmmain.btn_lib_regular_viewclick(nil);

  checkChatService;

  with ttimer.create(self) do begin
    interval := 500;
    ontimer := init_core_first;
    enabled := true;
  end;

end;

procedure tares_frmmain.init_GUI_last;
begin

  try
    if FAILED(CoCreateInstance(TGUID(CLSID_FilterGraph), nil, CLSCTX_INPROC, TGUID(IID_IGraphBuilder), helper_player.m_GraphBuilder)) then begin
      helper_player.player_working := false;
    end else helper_player.player_working := true;

    helper_player.m_GraphBuilder := nil;

    with trackbar_player do begin
      OnChanged := trackbar_playerchange;
      OnUrlClick := testoUrlClick;
      OnCaptionClick := panel_player_captclick;
      cursor := crDefault;
      visible := true;
      TrackbarEnabled := false;
      Wcaption := ''; //'Media Player';
      timeCaption := ''; //'0:00';
    end;
  except
    mplayerPanel1.visible := false;
    if trackbar_player <> nil then trackbar_player.visible := False;
  end;

  playlist_loadm3u(data_path + '\Data\default.m3u', true);

  mainGui_initprefpanel;


  header_download_load;
  header_upload_load;

  chatTabs := tmylist.create;
  mainGUI_rehost_ifrestarted; //todd terry

  shoutcast.AddMenuRadio;
  helper_chat_favorites.AutoJoinRooms;

  trayicon1.iconvisible := true;

  vars_global.IDEIsRunning := (FindWindow(pchar('TAppBuilder'), nil) <> 0);
end;



procedure tares_frmmain.init_hint_wnd;
begin
  try
    formhint := tfrmhint.create(self);
    with formhint do begin
      top := 10000;
      show;
      setwindowpos(handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOSENDCHANGING);
    end;
  except
  end;
end;

///////////////////////////////////////////////////////////
//init CORE
//////////////////////////////////////////////////////////////

procedure Tares_frmmain.init_core_first(Sender: TObject);
var
  str: string;
  tmp_str: string;
  WideStr: widestring;
begin

  with sender as ttimer do free;


  try
    LanIPC := getlocalip;
    LanIPS := ipint_to_dotstring(LanIPC);
  except
    LanIPC := 0;
    LanIPS := cAnyHost;
  end;

  getcursorpos(prev_cursorpos);
  vars_global.minutes_idle := 0;


  try

    myshared_folder := prendi_reg_my_shared_folder(data_path);

    if not direxistsW(myshared_folder) then begin
      tntwindows.Tnt_createdirectoryW(pwidechar(data_path + '\' + STR_MYSHAREDFOLDER), nil);
      myshared_folder := data_path + '\' + STR_MYSHAREDFOLDER;
    end;
  except
  end;

  try
    my_torrentFolder := regGetMyTorrentFolder(myshared_folder);
    if not dirExistsW(my_torrentFolder) then begin
      tntwindows.Tnt_createdirectoryW(pwidechar(myshared_folder + '\' + STR_MYTORRENTS), nil);
      my_torrentFolder := myshared_folder + '\' + STR_MYTORRENTS;
    end;
  except
  end;

  erase_dir_recursive(data_path + widestring('\Temp'));


  try

    vars_global.versioneares := get_program_version;
    tmp_str := vars_global.versioneares; //1.8.1.2927
    delete(tmp_str, 1, pos('.', tmp_str)); //8.1.2927
    delete(tmp_str, 1, pos('.', tmp_str)); //1.2927
    delete(tmp_str, 1, pos('.', tmp_str)); //2927
    vars_global.buildno := strtointdef(tmp_str, DEFAULT_BUILD_NO);

  except
    vars_global.versioneares := ARES_VERS;
    vars_global.buildno := DEFAULT_BUILD_NO;
  end;

  if Win32Platform = VER_PLATFORM_WIN32_NT then begin // OS supports setfilepointerEX?
    helper_diskio.kern32handle := SafeLoadLibrary('kernel32.dll');
    if helper_diskio.kern32handle <> 0 then
      @helper_diskio.SetfilePointerEx := GetProcAddress(helper_diskio.kern32handle, 'SetFilePointerEx');
  end;

  randseed := gettickcount;

  if reg_justInstalled then begin // clear old dbs
    helper_ares_cacheservers.clear_nodes_db;
    helper_ares_nodes.clear_nodes_db;
  end;

  mysupernodes.mysupernodes_create;
  lista_shared := tmylist.create;
  lista_socket_accept_down := tmylist.create;
  lista_risorse_temp := tthreadlist.create;
  lista_risorsepartial_temp := tthreadlist.create;
  lista_socket_temp_proxy := tmylist.create;
  lista_push_nostri := tmylist.create;
  lista_pushed_chatrequest := tmylist.create;
  availableCaches := TThreadList.create;
  DHT_hashFiles := TThreadList.create;
  DHT_KeywordFiles := TThreadList.create;



  scan_start_time := gettickcount;

  if lista_down_temp = nil then lista_down_temp := tmylist.create;
  if thread_down     = nil then thread_down     := tthread_download.create(true);
  if share           = nil then share           := tthread_share.create(true);
  if thread_up = nil then thread_up             := tthread_upload.create(true);
  if client = nil then client                   := tthread_client.create(false);
  if threadDHT = nil then threadDHT             := tthread_dht.create(false);

  share.paused := false;
  share.juststarted := true;

  share.Resume;
  thread_down.resume;
  thread_up.resume;





  try
    if WideParamCount = 1 then begin
      str := widestrtoutf8str(wideparamstr(1));

      if pos('arlnk://', lowercase(str)) = 1 then add_weblink(copy(str, 9, length(str)))
      else if pos('magnet:?', lowercase(str)) = 1 then add_magnet_link(copy(str, 9, length(str)))
      else Drag_And_Drop_AddFile(wideParamStr(1), 0);

    end else
      if WideParamCount = 2 then begin
        WideStr := '/ADD' + wideparamstr(2);
        Drag_And_Drop_AddFile(wideStr, 0);
      end;


  except
  end;

  should_show_prompt_nick := true;
  timer_sec.enabled := true;


  init_GUI_last;

end;
/////////////////////////////////////////////////////////////////

//////////////////////////////////////// tray icon and popupmenu events


procedure Tares_frmmain.tray_MinimizeClick(Sender: TObject);
var
  shouldAnimate: boolean;
begin



  if widestrtoutf8str(tray_minimize.caption) = GetLangStringA(STR_HIDE_ARES) then begin

    formhint_hide;
    hide_chat_tabs;

    if playlist_visible then ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);
//  if not ares_frmmain.check_opt_gen_gclose.checked then begin
//   sendmessage(self.handle,wm_syscommand,sc_close,0);
//   exit;
//  end;

    shouldAnimate := GetAnimation;
    if shouldAnimate then begin
      SetAnimation(false);
      application.Minimize;
      SetAnimation(true);
      DrawAppMinimizeAnimation(true);
    end else application.Minimize;
    TrayIcon1.iconvisible := true;
    enableSysMenus;



  end
  else begin
 //application.ShowMainForm:=false;
// ares_frmmain.WindowState:=wsMinimized;
// ares_frmmain.visible:=false;
    tray_minimize.caption := GetLangStringW(STR_HIDE_ARES);

    shouldAnimate := GetAnimation;
    if shouldAnimate then begin
      DrawAppMinimizeAnimation(false);
      SetAnimation(false);
      application.Restore;
      SetAnimation(true);
    end else application.Restore;

 {  if ((start_minimized) and (not has_first_autopositioned_tray)) then begin
    top:=9000;
     mainGui_setposition;
     has_first_autopositioned_tray:=true;
     trayicon1.iconvisible:=true;
   end;
  }
    enableSysMenus;
    show_chat_tabs;

  end;
end;

procedure tares_frmmain.minimizeapp(Sender: TObject);
//type TNotifyEvent = procedure (Sender: TObject) of object;
begin
  showWindow(application.handle, SW_HIDE);
  tray_minimize.caption := GetLangStringW(STR_SHOW_ARES);
  app_minimized := true;
end;


procedure tares_frmmain.restoreapp(Sender: TObject);
begin
  SetForeGroundWindow(application.handle);
  if windowState = wsMinimized then sendmessage(self.handle, wm_syscommand, SC_RESTORE, 0);

  app_minimized := false;
end;


///////////////////////////////////////////////////////////////////


/////////// browser keyevent workaround

procedure tares_frmmain.MsgHandler(var Msg: TMsg; var Handled: Boolean);
begin

  if tabs_pageview.activepage = IDTAB_SCREEN then begin
    if isvideoplaying then
      if (Msg.Message = WM_SYSCOMMAND) then
        if (Msg.wParam = SC_SCREENSAVE) or (msg.wParam = SC_MONITORPOWER) then Handled := True;
    exit;
  end else exit;

end;
/////////////////////////////////////////////////////


/////// refresh chat memo workaround

procedure tares_frmmain.WMActivate(var msg: TWMACTIVATE);
//Refresh chat memo on activate
var
  i: integer;
  pcanale: precord_canale_chat_visual;
//pvt_chat:precord_pvt_chat_visual;
  memo: TjvRichEdit;
begin
  inherited;


  if tabs_pageview.activepage <> IDTAB_CHAT then exit;

  for i := 0 to list_chatchan_visual.count - 1 do begin
    pcanale := list_chatchan_visual[i];
    if panel_chat.activepanel <> pcanale^.containerPageview then continue;
      //memo:=nil;
      //if pcanale^.pagecontrol.ActivePageIndex=0 then
    memo := pcanale^.memo; { else begin
       if pcanale^.lista_pvt=nil then exit;
         for h:=0 to pcanale^.lista_pvt.count-1 do begin
          pvt_chat:=pcanale^.lista_pvt[h];
          if pvt_chat.tabsheet<>pcanale^.pagecontrol.ActivePage then continue;
          memo:=pvt_chat^.memo;
          break;
         end;
      end; }
      //if memo<>nil then
    SendMessage(memo.Handle, WM_NCPaint, 0, 0);
  end;

end;
//////////////////////////////////////////////////////////////////////


///////////////////////////////////////////// self exception handler/logger

procedure tares_frmmain.appexcept(sender: tobject; e: exception);
//var
//stream:thandlestream;
//str:string;
//Msg: string;
//buffer:array[0..500] of char;
//freeavailable,
//totalspace:int64;
begin
  exit;
{
if num_eccept>100 then exit;

try
tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);

if not helper_diskio.FileExistsW(data_path+'\Data\Except Log.dat') then stream:=Myfileopen(data_path+'\Data\Except Log.dat',ARES_CREATE_ALWAYSAND_WRITETHROUGH)
 else stream:=Myfileopen(data_path+'\Data\Except Log.dat',ARES_WRITEEXISTING_WRITETHROUGH); //open to append  existing
if stream=nil then exit;

with stream do begin

 if  size>10*MEGABYTE then size:=0
  else seek(0,sofromend);  //append
try

 if position=0 then begin    //write intro
   str:='NT='+inttostr(integer(Win32Platform=VER_PLATFORM_WIN32_NT))+',Maj='+inttostr(Win32MajorVersion)+',Min='+inttostr(Win32MajorVersion)+chr(32)+inttostr(vars_global.cpu_freq)+'MHz '+inttostr(vars_global.aval_mem)+'MB'+CRLF+
        'Install path:'+app_path+CRLF+
        'Data Path:'+data_path+CRLF;
      // if Tnt_GetDiskFreeSpaceExW(pwidechar(app_path),freeavailable,totalspace,nil) then
       //   str:=str+inttostr(freeavailable div MEGABYTE)+'Mb ('+inttostr(freeavailable div GIGABYTE)+'Gb)'+CRLF;

     str:=str+CRLF;
        move(str[1],buffer,length(str));
        write(buffer,length(str));
         FlushFileBuffers(handle);
 end;

  Msg := E.Message;
  if (Msg <> '') and (AnsiLastChar(Msg) > '.') then Msg := Msg + '.';

 str:=formatdatetime('mm/dd/yyyy hh:nn:ss',now)+' B#:'+inttostr(buildno)+' E:'+msg+CRLF;

 move(str[1],buffer,length(str));
 write(buffer,length(str));
  FlushFileBuffers(handle);

except
end;

end;//with stream
FreeHandleStream(stream);

except
end;
inc(num_eccept);
if closing then halt; }
end;
////////////////////////////////////////////////////////////////////////////////


procedure Tares_frmmain.MenuItem11Click(Sender: TObject);
var
  node: PCmtVNode;
  data: precord_queued;
begin
  node := treeview_queue.getfirstselected;
  if node = nil then exit;
  data := treeview_queue.getdata(node);
  playlist_addfile(data^.nomefile, -1, false, '');
end;

procedure Tares_frmmain.MenuItem10Click(Sender: TObject);
var
  node: PCmtVNode;
  data: precord_queued;
begin
  node := treeview_queue.getfirstselected;
  if node = nil then exit;
  data := treeview_queue.getdata(node);
  locate_containing_folder(data^.nomefile);
end;

procedure Tares_frmmain.MenuItem9Click(Sender: TObject);
var
  node: PCmtVNode;
  data: precord_queued;
begin
  node := treeview_queue.getfirstselected;
  if node = nil then exit;
  data := treeview_queue.getdata(node);
  open_file_external(data^.nomefile);
end;

procedure Tares_frmmain.MenuItem8Click(Sender: TObject);
var
  node: PCmtVNode;
  data: precord_queued;
begin
  node := treeview_queue.getfirstselected;
  if node = nil then exit;
  data := treeview_queue.getdata(node);
  player_playnew(utf8strtowidestr(data^.nomefile));
end;


procedure tares_frmmain.global_shutdown(var message: tmessage);
begin
  if vars_global.closing then exit;



  vars_global.closing := true;

  trayicon1.iconvisible := false;
  timer_sec.enabled := false;

  visible := false;

  try
    if message.WParam <> 1 then stopChatService; // installer may post wm_user_quit...we need to shutdown chat service
  except
  end;

  onresize := nil; //prevent some weird bugs?

  try
    client.terminate;
    thread_down.Terminate;
    thread_up.Terminate;
  except
  end;

  try
    if hash_server <> nil then hash_server.terminate;
    if cache_server <> nil then cache_server.terminate;
    if client_chat <> nil then client_chat.terminate;
    if threadDHT <> nil then threadDHT.terminate;
    if thread_bittorrent <> nil then thread_bittorrent.terminate;
  except
  end;

  try
    set_NEWtrusted_metas;
  except
  end;

  try
    if program_start_time > 0 then stats_uptime_write(program_start_time, program_totminuptime);
    stats_maxspeed_write;
    header_search_save;
    header_upload_save;
    header_download_save;
    header_library_save('Library', 'Library', listview_lib);
    mainGui_saveposition;
    if ares_frmmain.btn_chat_fav.down then reg_save_chatfav_height
  except
  end;


  global_shutdown;
end;


procedure tares_frmmain.global_shutdown;
begin

  terminator := tthread_terminator.create(false);

  try
    stopmedia(nil); //stop player!
    if blendPlaylistForm <> nil then blendPlaylistForm.visible := false;
  except
  end;

  try
    if share <> nil then begin
      need_rescan := false;
      share.terminate;
      exit;
    end;
  except
  end;


  global_shutdown(true);
end;

procedure tares_frmmain.global_shutdown(dummy: boolean);
var
  canale_chat_visual: precord_canale_chat_visual;
  lastTick: cardinal;
//i:integer;
begin


  try
    playlist_savem3u(data_path + '\Data\default.m3u');

    erase_dir_recursive(data_path + '\Temp');
    erase_emptydir(data_path + '\Data\TempDl');
    erase_directory(data_path + '\Data\TempUl');
  except
  end;


  try
    thread_down.waitfor;
    thread_down.free;
    thread_down := nil;
  except
  end;

  try
    client.waitfor;
    client.free;
    client := nil;
  except
  end;

  try
    if threadDHT <> nil then begin
      threadDHT.waitfor;
      threadDHT.free;
      threadDHT := nil;
    end;
  except
  end;

  try
    if hash_server <> nil then begin
      hash_server.WaitFor;
      hash_server.free;
      hash_server := nil;
    end;
  except
  end;

  try
    if cache_server <> nil then begin
      cache_server.waitfor;
      cache_server.free;
      cache_server := nil;
    end;
  except
  end;

  if check_opt_chat_autocloseroom.checked then stopChatService;

 //if helper_player.m_GraphBuilder<>nil then helper_player.player_NillAll;
  if filtro2 <> nil then begin
    filtro2.cleargraph;
    FreeAndNil(filtro2);
  end;

  try
    thread_up.waitfor;
    thread_up.free;
    thread_up := nil;
  except
  end;

  try
    if vars_global.thread_bittorrent <> nil then begin
      vars_global.thread_bittorrent.waitfor;
      vars_global.thread_bittorrent.free;
      vars_global.thread_bittorrent := nil;
    end;
  except
  end;

  try
    if availableCaches <> nil then begin
      cacheservers_saveTodisk;
      cacheservers_freeList;

    end;
  except
  end;



  try
    while (list_chatchan_visual.count > 0) do begin
      canale_chat_visual := list_chatchan_visual[list_chatchan_visual.count - 1];
      list_chatchan_visual.delete(list_chatchan_visual.count - 1);
      with canale_chat_visual^ do begin
        name := '';
        topic := '';
        if out_text <> nil then out_text.free;
        if frmTab <> nil then frmTab.release;
      end;
      FreeMem(canale_chat_visual, sizeof(record_canale_chat_visual));
    end;
  except
  end;
  FreeAndNil(list_chatchan_visual);


  if font_chat <> nil then FreeAndNil(font_chat);
  if typed_lines_chat <> nil then typed_lines_chat.free;

  try
    tthread_lists_free;
  except
  end;

  helper_skin.FreeFrameBitmaps;
  if FrameRgn <> 0 then DeleteObject(FrameRgn);

  if ((shoutcast.isPlayingShoutcast)) then begin
    lastTick := gettickcount;
    while (gettickcount - lasttick < 1500) do application.processmessages;
  end;

  ares_frmmain.timer_fullScreenHideCursor.enabled := false;
  if helper_player.FFullScreenwindow <> nil then helper_player.FFullScreenWindow.release;
  helper_player.FFullScreenWindow := nil;
  ares_frmmain.timer_fullScreenHideCursor.enabled := false;


  utility_ares.clear_treeview(treeview_download);
  utility_ares.clear_treeview(treeview_upload);
  utility_ares.clear_treeview(treeview_queue);
  utility_ares.clear_treeview(listview_lib);
  utility_ares.clear_treeview(treeview_lib_regfolders);
  utility_ares.clear_treeview(treeview_lib_virfolders);
  while (pagesrc.PanelsCount > 1) do pagesrc.DeletePanel(1);

  if helper_diskio.kern32handle <> 0 then FreeLibrary(helper_diskio.kern32handle);
  FreeAndNil(chatTabs);

  sleep(100);
  formhint.close;

  terminator.terminate;
  terminator.waitfor;
  terminator.free;

  sleep(100);

  application.terminate;
end;





procedure tares_frmmain.tthread_lists_free;
var
  ffile: precord_file_library;
  socket: ttcpblocksocket;
  psocket: precord_socket;
  push_to_go: precord_push_to_go;
  down: tdownload;
  kwdlst: tlist;
  push_chat_req: precord_pushed_chat_request;
  pkeyw: dhttypes.precord_DHT_keywordFilePublishReq;
  Pip: precord_ipc;
//pcanale:precord_canale_chat_visual;
begin
{
try
while (list_chatchan_visual.count>0) do begin
 pcanale:=list_chatchan_visual[list_chatchan_visual.count-1];
          list_chatchan_visual.delete(list_chatchan_visual.count-1);
 pcanale^.name:='';
 pcanale^.topic:='';
 FreeMem(pcanale,sizeof(record_canale_chat_visual));
end;
list_chatchan_visual.free;
except
end; }
  FreeAndNil(src_panel_list);

  try
    while (helper_ares_nodes.hardFailed.count > 0) do begin
      pIP := hardFailed[hardFailed.count - 1];
      hardFailed.delete(hardFailed.Count - 1);
      FreeMem(pIP, sizeof(record_ipc));
    end;
    hardFailed.free;
  except
  end;

  try
    if DHT_hashFiles <> nil then begin
      dhtkeywords.DHT_clear_hashFilelist; //stop sharing
      DHT_hashFiles.free;
    end;

    if DHT_KeywordFiles <> nil then begin
      kwdlst := DHT_KeywordFiles.locklist;
      while (kwdlst.count > 0) do begin
        pkeyw := kwdlst[kwdlst.count - 1];
        kwdlst.delete(kwdlst.count - 1);
        pkeyw^.keyW := '';
        pkeyw^.fileHashes.free;
        FreeMem(pkeyw, sizeof(record_DHT_keywordFilePublishReq));
      end;
      DHT_KeywordFiles.unlocklist;
      DHT_KeywordFiles.Free;
    end;
  except
  end;

  try
    if vars_global.fresh_downloaded_files <> nil then
      FreeAndNil(vars_global.fresh_downloaded_files); //should be already empty...
  except
  end;

  try
    if lista_down_temp <> nil then begin
      try
        while (lista_down_temp.count > 0) do begin
          down := lista_down_temp[lista_down_temp.count - 1];
          lista_down_temp.delete(lista_down_temp.count - 1);
          down.free;
        end;
      except
      end;
      lista_down_temp.free;
    end;
  except
  end;

  try
    while (lista_shared.count > 0) do begin
      ffile := lista_shared[lista_shared.count - 1];
      lista_shared.delete(lista_shared.count - 1);

      finalize_file_library_item(ffile);

      FreeMem(ffile, sizeof(record_file_library));
    end;
  except
  end;
  lista_shared.free;


  try
    while (lista_push_nostri.count > 0) do begin
      push_to_go := lista_push_nostri[lista_push_nostri.count - 1];
      lista_push_nostri.delete(lista_push_nostri.count - 1);
      push_to_go^.filename := '';
      FreeMem(push_to_go, sizeof(recorD_push_to_go));
    end;
  except
  end;
  lista_push_nostri.free;


  clear_chanlist_backup;
  chat_chanlist_backup.free;

  try
    while (lista_socket_accept_down.count > 0) do begin
      socket := lista_socket_accept_down[lista_socket_accept_down.count - 1];
      lista_socket_accept_down.delete(lista_socket_accept_down.count - 1);
      socket.free;
    end;
  except
  end;
  lista_socket_accept_down.free;

  lista_risorse_temp.free;


  lista_risorsepartial_temp.free;

  try
    while (lista_socket_temp_proxy.count > 0) do begin
      psocket := lista_socket_temp_proxy[lista_socket_temp_proxy.count - 1];
      lista_socket_temp_proxy.delete(lista_socket_temp_proxy.count - 1);
      with psocket^ do begin
        buffstr := '';
        ip := '';
      end;
      FreeMem(psocket, sizeof(record_socket));
    end;
  except
  end;
  lista_socket_temp_proxy.free;


  try
    while (lista_pushed_chatrequest.count > 0) do begin
      push_chat_req := lista_pushed_chatrequest[lista_pushed_chatrequest.count - 1];
      lista_pushed_chatrequest.delete(lista_pushed_chatrequest.count - 1);
      if push_chat_req^.socket <> nil then FreeAndNil(push_chat_req^.socket);
      push_chat_req^.randoms := '';
      FreeMem(push_chat_req, sizeof(record_pushed_chat_request));
    end;
    lista_pushed_chatrequest.free;
  except
  end;


  try
    if vars_global.BitTorrentTempList <> nil then vars_global.BitTorrentTempList.free;
  except
  end;

  try
    if vars_global.bittorrent_Accepted_sockets <> nil then begin
      while (vars_global.bittorrent_Accepted_sockets.count > 0) do begin
        socket := vars_global.bittorrent_Accepted_sockets[vars_global.bittorrent_Accepted_sockets.count - 1];
        vars_global.bittorrent_Accepted_sockets.delete(vars_global.bittorrent_Accepted_sockets.count - 1);
        socket.free;
      end;
      vars_global.bittorrent_Accepted_sockets.free;
    end;
  except
  end;


  try
    mysupernodes.mysupernodes_free;
  except
  end;
end;



procedure Tares_frmmain.FormShow(Sender: TObject);
begin
  initialized := true;
end;

procedure Tares_frmmain.RadiosearchmimeClick(Sender: TObject);
begin
  mainGui_invalidate_searchpanel;
  if radio_srcmime_all.checked then
    if combo_search.canfocus then combo_search.setfocus;
end;

procedure Tares_frmmain.FormResize(Sender: TObject);
var
  borderWi, borderHe: integer;
begin
  if helper_skin.skinnedFrameLoaded then begin

    borderwi := GetSystemMetrics(SM_CXSIZEFRAME);
    borderhe := GetSystemMetrics(SM_CYSIZEFRAME);

    clientPanel.left := fborderWidth;
    clientPanel.top := fcaptionHeight;
    clientPanel.width := clientwidth - (helper_skin.fborderwidth * 2);
    clientPanel.height := ((clientheight - helper_skin.fcaptionHeight) - helper_skin.fborderHeight);

    FrameRgn := CreateRoundRectRgn(BorderWi - 1, BorderHe - 1, (width - BorderWi) + 2, (height - BorderHe) + 2, helper_skin.FrameRoundCorner, helper_skin.FrameRoundCorner); //<shape type="roundRect" rect="0,0,-1,-1" size="4,4"/>
    SetWindowRgn(Handle, FrameRgn, true);

    invalidate;
  end else begin
    clientPanel.top := 0;
    clientPanel.left := 0;
    clientPanel.width := clientwidth;
    clientPanel.height := clientheight;
  end;
end;

procedure tares_Frmmain.libraryOnResize(Sender: TObject);
var
  nodo: PCmtVNode;
begin
  treeview_lib_regfolders.left := 0;
  treeview_lib_virfolders.left := 0;
  treeview_lib_regfolders.top := btns_library.height;
  treeview_lib_virfolders.top := btns_library.height;
  treeview_lib_regfolders.height := (sender as tpanel).clientheight - btns_library.height;
  treeview_lib_virfolders.height := (sender as tpanel).clientheight - btns_library.height;
  treeview_lib_regfolders.Header.Columns[0].width := treeview_lib_regfolders.width;
  treeview_lib_virfolders.Header.Columns[0].width := treeview_lib_virfolders.width;

//if panel_lib_folders.width>152 then btn_lib_hidefolders.left:=panel_lib_folders.width-btn_lib_hidefolders.width-2
// else btn_lib_hidefolders.left:=132;


  splitter_library.top := btns_library.height;
  panel_hash.Top := btns_library.height;
  listview_lib.top := btns_library.height;
  splitter_library.componentTop := (sender as tpanel).top + (integer(helper_skin.SkinnedFrameLoaded) * helper_skin.fcaptionHeight);

  if hashing then begin
    with splitter_library do begin
      visible := true;
      top := btns_library.top + btns_library.height;
      height := (sender as tpanel).clientheight - top;
    end;
    treeview_lib_virfolders.visible := btn_lib_virtual_view.down;
    treeview_lib_regfolders.visible := btn_lib_regular_view.down;
    if btn_lib_virtual_view.down then begin
      nodo := treeview_lib_virfolders.getfirst;
      if nodo <> nil then begin
        if treeview_lib_virfolders.selected[nodo] then begin
          panel_hash.visible := true;
          listview_lib.visible := false;
        end else begin
          listview_lib.visible := true;
          panel_hash.visible := false;
        end;
      end;
    end else begin
      nodo := treeview_lib_regfolders.getfirst;
      if nodo <> nil then begin
        if treeview_lib_regfolders.selected[nodo] then begin
          panel_hash.visible := true;
          listview_lib.visible := false;
        end else begin
          listview_lib.visible := true;
          panel_hash.visible := false;
        end;
      end;
    end;
  end else begin
    with splitter_library do begin
      visible := true;
      top := btns_library.top + btns_library.height;
      height := (sender as tpanel).clientheight - top;
    end;
    treeview_lib_virfolders.visible := btn_lib_virtual_view.down;
    treeview_lib_regfolders.visible := btn_lib_regular_view.down;
    listview_lib.visible := true;
    panel_hash.visible := false;
  end;

  if btn_lib_toggle_folders.down then begin
    treeview_lib_virfolders.width := vars_global.panel6sizedefault;
    treeview_lib_regfolders.width := vars_global.panel6sizedefault;
    splitter_library.left := vars_global.panel6sizedefault;
    splitter_library.width := 3;
    listview_lib.left := splitter_library.left + splitter_library.width {+1};
    panel_hash.left := listview_lib.left;
    panel_details_library.left := listview_lib.left;
    listview_lib.width := (sender as tpanel).clientwidth - listview_lib.left;
    panel_hash.width := listview_lib.width + 2;
    panel_details_library.width := listview_lib.width;
  end else begin
    treeview_lib_virfolders.width := 0;
    treeview_lib_regfolders.width := 0;
    splitter_library.left := 0;
    splitter_library.width := 0;
    listview_lib.left := 0;
    panel_hash.left := 0;
    panel_details_library.left := 0;
    listview_lib.width := (sender as tpanel).clientwidth;
    panel_hash.width := listview_lib.width + 2;
    panel_details_library.width := listview_lib.width;
  end;

  if ((not btn_lib_toggle_details.down) or
    (listview_lib.header.height = 34) or
    (hashing)) then begin
    listview_lib.height := (sender as tpanel).clientHeight - listview_lib.top;
    listview_lib.BevelEdges := [];
    panel_hash.height := listview_lib.height + 1;
    panel_details_library.visible := false;
    panel_details_library.height := 0;
  end else begin
    listview_lib.height := ((sender as tpanel).clientHeight - listview_lib.top) - 129; //165;
    listview_lib.BevelEdges := [beBottom];
    panel_hash.height := listview_lib.height + 1;
    with panel_details_library do begin
      visible := true;
      left := listview_lib.left;
      top := listview_lib.top + listview_lib.Height;
      width := listview_lib.width;
      height := 129; //164;
    end;
  end;

end;

procedure Tares_frmmain.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = vk_return then
    if Btn_start_search.enabled then
      if Btn_start_search.enabled then Btn_start_searchclick(nil);
end;

procedure Tares_frmmain.FormCreate(Sender: TObject);
var
  style: integer;
begin
  helper_skin.skinnedFrameLoaded := false;

  application.OnException := appexcept;
  application.OnRestore := restoreapp;
  application.OnMinimize := minimizeapp;

  ShowWindow(Application.handle, SW_HIDE);

  style := GetWindowLong(Application.Handle, GWL_EXSTYLE);
  style := style and (not WS_EX_APPWINDOW) or (WS_EX_TOOLWINDOW);
  style := style or WS_EX_ACCEPTFILES;
  SetWindowLong(Application.Handle, GWL_EXSTYLE, style);

 //style:=GetWindowLong(Application.Handle,GWL_STYLE);  // vista
 //style:=style and (not WS_POPUPWINDOW);
 //SetWindowLong(Application.Handle,GWL_STYLE,style);

  ShowWindow(application.handle, SW_HIDE);
 //SHowWindow(Application.Handle,SW_SHOW);


  with ttimer.create(self) do begin
    ontimer := init_gui_first;
    interval := 10;
    enabled := true;
  end;

end;

procedure Tares_frmmain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle and not WS_EX_TOOLWINDOW or WS_EX_APPWINDOW;
  Params.ExStyle := Params.ExStyle and not WS_EX_CONTROLPARENT;
  Params.ExStyle := Params.ExStyle or WS_EX_ACCEPTFILES;
end;

procedure Tares_frmmain.Btn_start_searchClick(Sender: TObject);
begin
  gui_start_search;
end;



procedure Tares_frmmain.btn_stop_searchClick(Sender: TObject);
begin
  gui_stop_search;
end;

procedure Tares_frmmain.Download1Click(Sender: TObject);
var
  node, node_child, selected_node: PCmtVNode;
  datao, data_child: precord_search_result;
  down: tdownload;
  hi: integer;
  src: precord_panel_search;
begin

  try

    for hi := 0 to src_panel_list.count - 1 do begin
      src := src_panel_list[hi];
      if src^.containerPanel <> pagesrc.activepanel then continue;

      with src^.listview do begin

        node := GetFirstSelected;
        while (node <> nil) do begin


          if getnodelevel(node) > 0 then selected_node := node.parent
          else selected_node := node;

          datao := getdata(selected_node);

          if datao^.downloaded then begin
            node := getnextselected(node);
            continue;
          end;

          if is_in_progress_sha1(datao^.hash_sha1) then begin
            messageboxW(self.handle, pwidechar(GetLangStringW(STR_TRANSFER_ALREADY_IN_PROGRESS) + CRLF + CRLF + '(  ' + extract_fnameW(utf8strtowidestr(datao^.filenameS)) + '  )' + CRLF + CRLF + GetLangStringW(STR_TAKE_A_LOOK_TO_TRANSFER_TAB)), pwidechar(appname + ': ' + GetLangStringW(STR_DUPLICATE_REQUEST)), mb_ok + MB_ICONEXCLAMATION);
            exit;
          end;

          if is_in_lib_sha1(datao^.hash_sha1) then begin
            messageboxW(self.handle, pwidechar(GetLangStringW(STR_FILE_ALREADY_IN_LIBRARY) + CRLF + CRLF + GetLangStringW(STR_FILE) + ': ' + extract_fnameW(utf8strtowidestr(datao^.filenameS)) + CRLF + GetLangStringW(STR_SIZE) + ': ' + format_currency(datao^.fsize) + chr(32) + STR_BYTES + CRLF + CRLF + GetLangStringW(STR_TAKE_A_LOOK_TO_YOUR_LIBRARY)), pwidechar(appname + chr(58) + chr(32) {': '} + GetLangStringW(STR_DUPLICATE_FILE)), mb_ok + MB_ICONEXCLAMATION);
            exit;
          end;

          down := start_download(datao);
          lista_down_temp.add(down);
          GUI_add_sources_ares(src^.listview, down, selected_node, datao);

          datao^.downloaded := true;
          if node.childcount > 0 then begin
            node_child := getfirstchild(selected_node);
            while (node_child <> nil) do begin
              data_child := getdata(node_child);
              data_child^.downloaded := true;
              invalidatenode(node_child);
              node_child := getnextsibling(node_child);
            end;
          end;
          invalidatenode(selected_node);
          put_backup_results_inprogress(src, datao);

          node := getnextselected(node);
        end;

      end;

      break;
    end;


  except
  end;

end;


procedure tares_frmmain.WMSyscommand(var msg: TWmSysCommand); // WM_SYSCOMMAND
var
  shouldRevertMaximise, shouldAnimate: boolean;
begin

  case msg.CmdType of
    SC_MYMINIMIZE: msg.CmdType := SC_MINIMIZE;
    SC_MYMAXIMIZE: msg.CmdType := SC_MAXIMIZE;
    SC_MYRESTORE: msg.CmdType := SC_RESTORE;
    SC_MYCLOSE: msg.CmdType := SC_CLOSE;
  end;

  case (msg.CmdType and $FFF0) of

    SC_MINIMIZE, SC_MYMINIMIZE: begin
        formhint_hide;
        if playlist_visible then ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);
        ShowWindow(handle, SW_MINIMIZE);
        msg.result := 0;
        enableSysMenus;
      end;

    SC_RESTORE: begin
        formhint_hide;
        if playlist_visible then ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);

        shouldRevertMaximise := (not isIconic(handle));

        ShowWindow(Handle, SW_RESTORE);
        if (helper_skin.SkinnedFrameLoaded) and (isMaximised) and (shouldRevertMaximise) then begin
          isMaximised := false;

          setWindowPos(self.handle, 0,
            oldleft, oldtop,
            oldwidth, oldheight,
            SWP_NOZORDER);
        end else
          if (helper_skin.SkinnedFrameLoaded) and (isMaximised) then begin
            isMaximised := false;
            ufrmmain.MaximiseForm(self);
            isMaximised := true;
          end;
        if shouldRevertMaximise then isMaximised := false;
        enableSysMenus;
        msg.result := 0;
      end;

    SC_MAXIMIZE: begin
        formhint_hide;
        if playlist_visible then ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);

        if helper_skin.SkinnedFrameLoaded then begin
          if not isMaximised then begin

            oldwidth := self.width;
            oldheight := self.height;
            oldleft := self.left;
            oldtop := self.top;
            ufrmmain.MaximiseForm(self);
            isMaximised := true;

          end else begin
     // if isIconic(handle) then
            PostMessage(self.handle, WM_SYSCOMMAND, SC_RESTORE, 0);
          end;
        end else ShowWindow(Handle, SW_MAXIMIZE);
        enableSysMenus;
        msg.result := 0;
      end;

    SC_CLOSE: begin
        formhint_hide;
        hide_chat_tabs;
        if playlist_visible then ufrmmain.ares_frmmain.btn_playlist_closeClick(nil);
 //visible:=false;
        msg.result := 0;
        if ares_frmmain.check_opt_gen_gclose.checked then begin
          sendmessage(self.handle, WM_USER_QUIT, 1, 0);
          exit;
        end;

        shouldAnimate := GetAnimation;
        if shouldAnimate then begin
          SetAnimation(false);
          application.Minimize;
          SetAnimation(true);
          DrawAppMinimizeAnimation(true);
        end else application.Minimize;

 // SendMessage(application.handle,WM_SYSCOMMAND,SC_MINIMIZE,0);
        TrayIcon1.iconvisible := true;
        enableSysMenus;
  //application.minimize;
      end;

  else inherited;
  end;

end;

procedure Tares_frmmain.tray_quitClick(Sender: TObject);
begin
  postmessage(self.handle, wm_user_quit, 1, 0);
end;

procedure Tares_frmmain.flatedit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = vk_return then
    Btn_start_searchclick(nil);
end;

procedure Tares_frmmain.listview_srcGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  Data: precord_search_result;
begin
  imageindex := -1;
  if sender.getnodelevel(node) > 0 then exit;

  Data := sender.getdata(node);
  if data^.downloaded then ImageIndex := data^.imageindex + 12
  else ImageIndex := data^.imageindex;

end;

procedure Tares_frmmain.result_chat_get_imageindex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  Data: precord_file_result_chat;
begin
  imageindex := -1;


  Data := sender.getdata(node);

  if data^.downloaded then begin
    if data^.imageindex <> 0 then ImageIndex := data^.imageindex + 12
    else begin
      if (vsexpanded in node.States) then imageindex := 21
      else ImageIndex := 20;
    end;
  end else begin
    if data^.imageindex = 0 then begin
      if (vsexpanded in node.States) then imageindex := 1
      else imageindex := 0;
    end else ImageIndex := data^.imageindex;
  end;

end;

procedure Tares_frmmain.listview_srcGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  Size := SizeOf(record_search_result);
end;

procedure tares_frmmain.get_text_result_chats(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  Data: precord_file_result_chat;
  tipo_colonna: tcolumn_type;
  rec_res: precord_pannello_result_chat;
  str_status: string;
begin
  if column < 0 then exit;

  rec_res := precord_pannello_result_chat(sender.tag);
  tipo_colonna := rec_res^.stato_header[column];
  Data := sender.getdata(Node);

  with data^ do begin

    case tipo_colonna of
      COLUMN_NULL: CellText := chr(32);
      COLUMN_TITLE: CellText := utf8strtowidestr(title);
      COLUMN_FILENAME: CellText := utf8strtowidestr(filename);
      COLUMN_USER: begin
          if sender.getnodelevel(node) = 0 then begin
            if node^.childcount > 0 then str_status := ''
            else str_status := chr(32) + chr(32) + inttostr(up_count) + chr(117) + chr(112) + chr(47) {'up/'} + inttostr(up_limit) + chr(109) + chr(97) + chr(120) + chr(32) {'max '} + inttostr(queued) + chr(113) {'q'};
          end else str_status := chr(32) + chr(32) + inttostr(up_count) + chr(117) + chr(112) + chr(47) {'up/'} + inttostr(up_limit) + chr(109) + chr(97) + chr(120) + chr(32) {'max '} + inttostr(queued) + chr(113) {'q'};

          if length(client) > 0 then celltext := utf8strtowidestr(nickname) + chr(64) {'@'} + client + str_status
          else celltext := utf8strtowidestr(nickname) + str_status;
        end;
      COLUMN_TYPE: CellText := utf8strtowidestr(mediatype_to_str(amime));
      COLUMN_FILETYPE: celltext := extractfileext(filename);
      COLUMN_SIZE: begin
          if fsize < 4096 then CellText := format_currency(fsize) + chr(32) + STR_BYTES
          else CellText := format_currency(fsize div 1024) + chr(32) + STR_KB;
        end;
      COLUMN_ARTIST: CellText := utf8strtowidestr(artist);
      COLUMN_CATEGORY: CellText := utf8strtowidestr(category);
      COLUMN_ALBUM: CellText := utf8strtowidestr(album);
      COLUMN_DATE: CellText := utf8strtowidestr(data);
      COLUMN_LANGUAGE: CellText := utf8strtowidestr(language);
      COLUMN_VERSION: CellText := utf8strtowidestr(album);
      COLUMN_QUALITY: if param1 = 0 then CellText := chr(32) else CellText := inttostr(param1);
      COLUMN_COLORS: begin
          if param3 = 4 then CellText := chr(49) + chr(54) {'16'} else
            if param3 = 8 then CellText := chr(50) + chr(53) + chr(54) {'256'} else
              if param3 = 16 then CellText := chr(54) + chr(53) + chr(75) {'65K'} else
                if param3 <> 0 then CellText := chr(49) + chr(54) + chr(77) {'16M'} else CellText := chr(32);
        end;
      COLUMN_LENGTH: if param3 = 0 then CellText := chr(32) else CellText := format_time(param3);
      COLUMN_RESOLUTION: if ((param1 > 0) and (param2 > 0)) then CellText := inttostr(param1) + chr(120) {'x'} + inttostr(param2) else CellText := chr(32);
      COLUMN_FORMAT: if length(vidinfo) > 0 then celltext := utf8strtowidestr(vidinfo) else celltext := chr(32);
      COLUMN_INPROGRESS: CellText := utf8strtowidestr(title) else CellText := chr(32);
    end;


  end;
end;

procedure Tares_frmmain.listview_srcGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  Data: precord_search_result;
  tipo_colonna: tcolumn_type;
  rec_res: precord_panel_search;
begin

  if column < 0 then exit;

  rec_res := precord_panel_search(sender.tag);
  tipo_colonna := rec_res^.stato_header[column];

  Data := sender.getdata(Node);

  with data^ do begin

    case tipo_colonna of
      COLUMN_TITLE: CellText := utf8strtowidestr(title);
      COLUMN_STATUS: celltext := chr(32);
      COLUMN_USER: begin
          if node.ChildCount > 1 then celltext := inttostr(node.childcount) + chr(32) + GetLangStringW(STR_USERS)
          else celltext := utf8strtowidestr(nickname);
        end;
      COLUMN_TYPE: if sender.getnodelevel(node) = 0 then CellText := utf8strtowidestr(mediatype_to_str(amime)) else celltext := chr(32);
      COLUMN_FILETYPE: begin
          CellText := lowercase(extractfileext(filenameS));
        end;
      COLUMN_SIZE: begin
          if sender.getnodelevel(node) = 0 then begin
            if fsize < 4096 then CellText := format_currency(fsize) + chr(32) + STR_BYTES else
              CellText := format_currency(fsize div 1024) + chr(32) + STR_KB;
          end else celltext := chr(32);
        end;
      COLUMN_FILENAME: CellText := utf8strtowidestr(filenameS);
      COLUMN_ARTIST: CellText := utf8strtowidestr(artist);
      COLUMN_CATEGORY: CellText := utf8strtowidestr(category);
      COLUMN_ALBUM: CellText := utf8strtowidestr(album);
      COLUMN_DATE: CellText := utf8strtowidestr(year);
      COLUMN_LANGUAGE: CellText := utf8strtowidestr(language);
      COLUMN_VERSION: CellText := utf8strtowidestr(album);
      COLUMN_QUALITY: if sender.getnodelevel(node) = 0 then begin
          if param1 = 0 then CellText := chr(32) else CellText := inttostr(param1);
        end else celltext := chr(32);
      COLUMN_COLORS: begin
          if sender.getnodelevel(node) = 0 then begin
            if param3 = 4 then CellText := chr(49) + chr(54) {'16'} else
              if param3 = 8 then CellText := chr(50) + chr(53) + chr(54) {'256'} else
                if param3 = 16 then CellText := chr(54) + chr(53) + chr(75) {'65K'} else
                  if param3 <> 0 then CellText := chr(49) + chr(54) + chr(77) {'16M'} else CellText := chr(32);
          end else celltext := chr(32);
        end;
      COLUMN_LENGTH: if sender.getnodelevel(node) = 0 then begin
          if param3 = 0 then CellText := chr(32) else CellText := format_time(param3);
        end else celltext := chr(32);
      COLUMN_RESOLUTION: if sender.getnodelevel(node) = 0 then begin
          if ((param1 > 0) and (param2 > 0)) then CellText := inttostr(param1) + chr(120) {'x'} + inttostr(param2) else CellText := chr(32);
        end else celltext := chr(32);
      COLUMN_NULL: CellText := chr(32);
      COLUMN_INPROGRESS: CellText := utf8strtowidestr(title) else CellText := chr(32);
    end;

  end;
end;

procedure Tares_frmmain.TreeviewHeaderClick(Sender: TCmtHdr; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not sender.Treeview.Selectable then exit;

  with sender do begin
    sortcolumn := column;
    if sortdirection = sdAscending then sortdirection := sdDescending
    else sortdirection := sdAscending;
    Treeview.Sort(nil, column, sender.sortdirection);
  end;
end;

procedure Tares_frmmain.listview_srcAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
var
  bitmap_search_stars: graphics.tbitmap;
  num: byte;
  sources: word;
  tipo_colonna: tcolumn_type;
  rec_res: precord_panel_search;
begin
  if column < 0 then exit;

  rec_res := precord_panel_search(sender.tag);
  tipo_colonna := rec_res^.stato_header[column];

  if tipo_colonna <> COLUMN_STATUS then exit;
  if sender.getnodelevel(node) > 0 then exit;

  sources := node.childcount;
  if sources = 0 then inc(sources);

  num := availibility_to_point(sources);

  bitmap_search_stars := graphics.tbitmap.create;
  with bitmap_search_stars do begin
    pixelformat := pf24bit;
    if (node = sender.HotNode) and (not (vsSelected in node.states)) then Canvas.Brush.color := (sender as tcomettree).Colors.HotColor else
      if (vsSelected in node.States) then Canvas.brush.color := clhighlight else
        if (node.Index mod 2) = 0 then Canvas.brush.color := sender.BGColor else
          canvas.brush.color := (sender as tcomettree).color;

    canvas.fillrect(rect(0, 0, width, height));

    imglist_stars.GetBitmap(num - 1, bitmap_search_stars);

    width := 12 * num;
    transparentcolor := clfuchsia;
    transparent := true;
    TargetCanvas.draw(cellrect.Left + 3, cellrect.Top + 2, bitmap_search_stars);
    free;
  end;

end;

procedure Tares_frmmain.listview_srcDblClick(Sender: TObject);
var
  punto: tpoint;
  nodo: PCmtVNode;
  data: precord_search_result;
begin
  if (sender as tcomettree).GetFirstSelected = nil then exit;
  getcursorpos(punto);
//if punto.x<left+pageweb.left+23 then exit;

  nodo := (sender as tcomettree).getfirstselected;
  if nodo = nil then exit;
  if (sender as tcomettree).getnodelevel(nodo) > 0 then nodo := nodo.parent;

  data := (sender as tcomettree).getdata(nodo);
  if data^.already_in_lib then Play3Click(nil) else
    download1click(nil);
end;

procedure Tares_frmmain.Folders1Click(Sender: TObject);
begin
  btn_lib_toggle_folders.down := not btn_lib_toggle_folders.down;
  btn_lib_virtual_view.visible := btn_lib_toggle_folders.down;
  btn_lib_regular_view.visible := btn_lib_toggle_folders.down;

  if btn_lib_virtual_view.visible then begin
    btn_lib_virtual_view.left := btn_lib_toggle_folders.left + btn_lib_toggle_folders.width + 3;
    btn_lib_regular_view.left := btn_lib_virtual_view.left + btn_lib_virtual_view.width + 3;
    edit_lib_search.left := btn_lib_regular_view.left + btn_lib_regular_view.width + 10;

// lbl_lib_search.left:=btn_lib_regular_view.left+btn_lib_regular_view.width+15;
  end else edit_lib_search.left := btn_lib_toggle_folders.left + btn_lib_toggle_folders.width + 10;
 //else lbl_lib_search.left:=btn_lib_toggle_folders.left+btn_lib_toggle_folders.width+15;

  btn_lib_toggle_details.left := edit_lib_search.left + edit_lib_search.width + 10;
  btn_lib_delete.left := btn_lib_toggle_details.left + btn_lib_toggle_details.width + 7;
  btn_lib_addtoplaylist.left := btn_lib_delete.left + btn_lib_delete.width;
  btn_lib_refresh.left := btn_lib_addtoplaylist.left + btn_lib_addtoplaylist.width;

  libraryOnResize(ares_frmmain.listview_lib.parent);
end;

procedure Tares_frmmain.Moreinfo1Click(Sender: TObject);
var
  nodo: PCmtVNode;
begin
  btn_lib_toggle_details.down := not btn_lib_toggle_details.down;
  set_reginteger('Libray.ShowDetails', integer(btn_lib_toggle_details.down));

  try
    if ((listview_lib.rootnodecount > 0) and
      (btn_lib_toggle_Details.down)) then begin
      nodo := listview_lib.getfirstselected;
      if nodo = nil then nodo := listview_lib.getfirst;
      listview_lib.selected[nodo] := true;
      listview_libclick(nil);
    end;
  except
  end;

  libraryOnResize(ares_frmmain.listview_lib.parent);
end;

procedure Tares_frmmain.listview_libGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  Size := SizeOf(record_file_library);
end;

procedure Tares_frmmain.listview_libGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  Data: precord_file_library;
begin

  Data := sender.getdata(node);
  if data^.shared then imageindex := data^.imageindex + 6
  else ImageIndex := data^.imageindex;

end;

procedure Tares_frmmain.WMCopyData(var Msg: TWMCopyData);
var
  Str: string;
  CopyDataStructure: TCopyDataStruct;
  i: integer;
  len: integer;
begin


  CopyDataStructure := Msg.CopyDataStruct^;

  if CopyDataStructure.dwData = 2 then begin
    helper_gui_misc.showMainWindow;
    exit;
  end;

  Str := '';
  len := CopyDataStructure.cbData;
  for i := 0 to len - 1 do begin
    Str := Str + (PChar(CopyDataStructure.lpData) + i)^;
  end;



  if pos('arlnk://', lowercase(str)) = 1 then add_weblink(copy(str, 9, length(str)))
  else
    if pos('magnet:?', lowercase(str)) = 1 then add_magnet_link(copy(str, 9, length(str)))
    else begin
      if CopyDataStructure.dwData = 1 then str := '/ADD' + str;
      Drag_And_Drop_AddFile(utf8strtowidestr(str), 0);
    end;
end;


procedure Tares_frmmain.ExportHashLink1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  data: precord_file_library;
begin

  nodo := listview_lib.GetFirstSelected;
  if nodo = nil then exit;
  data := listview_lib.getdata(nodo);

  export_hashlink(data, true);
end;


procedure Tares_frmmain.listview_libGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  Data: precord_file_library;
  tipo_colonna: tcolumn_type;
begin
  if column < 0 then exit;
  if column > 9 then begin
    celltext := chr(32);
    exit;
  end;

  tipo_colonna := stato_header_library[column];

  Data := sender.getdata(Node);

  with data^ do begin

    case tipo_colonna of
      COLUMN_TITLE: CellText := utf8strtowidestr(title);
      COLUMN_ARTIST: if imageindex <> 0 then CellText := utf8strtowidestr(artist) else celltext := chr(32);
      COLUMN_CATEGORY: if imageindex <> 0 then CellText := utf8strtowidestr(category) else celltext := chr(32);
      COLUMN_ALBUM: CellText := utf8strtowidestr(album);
      COLUMN_SIZE: begin
          if imageindex = 0 then celltext := chr(32) else begin
            if fsize < 4096 then CellText := format_currency(fsize) + chr(32) + STR_BYTES else
              CellText := format_currency(fsize div 1024) + chr(32) + STR_KB;
          end;
        end;
      COLUMN_DATE: CellText := utf8strtowidestr(year);
      COLUMN_LANGUAGE: CellText := utf8strtowidestr(language);
      COLUMN_VERSION: CellText := utf8strtowidestr(album);
      COLUMN_QUALITY: if param1 <> 0 then CellText := inttostr(param1) else CellText := chr(32);
      COLUMN_FILETYPE: begin
          CellText := lowercase(extractfileext(path));
        end;
      COLUMN_COLORS: begin
          if param3 = 4 then CellText := chr(49) + chr(54) {'16'} else
            if param3 = 8 then CellText := chr(50) + chr(53) + chr(54) {'256'} else
              if param3 = 16 then CellText := chr(54) + chr(53) + chr(75) {'65K'} else
                if param3 <> 0 then CellText := chr(50) + chr(52) + chr(77) {'24M'} else CellText := chr(32);
        end;
      COLUMN_LENGTH: if param3 = 0 then CellText := chr(32) else CellText := format_time(param3);
      COLUMN_RESOLUTION: if param1 = 0 then CellText := chr(32) else CellText := inttostr(param1) + chr(120) {'x'} + inttostr(param2);
      COLUMN_FILENAME: CellText := extract_fnameW(utf8strtowidestr(path));
      COLUMN_NULL: CellText := chr(32);
      COLUMN_YOUR_LIBRARY: CellText := utf8strtowidestr(title);
      COLUMN_MEDIATYPE: CellText := utf8strtowidestr(mediatype);
      COLUMN_FORMAT: CellText := utf8strtowidestr(vidinfo);
      COLUMN_FILEDATE: CellText := formatdatetime('mm/dd/yyyy  h:nn AM/PM', filedate) else CellText := chr(32);
    end;

  end;
end;


procedure Tares_frmmain.deleteClick(Sender: TObject);
var
  node: PCmtVNode;
  datao: precord_file_library;
  nomefilew: widestring;
  stringa, stringai: widestring;
  list: tlist;
begin
  try
    stringa := '';

    node := listview_lib.GetFirstSelected;
    if node = nil then exit;

    list := tlist.create;
    repeat
      if node = nil then break;
      list.add(node);
      datao := listview_lib.getdata(node);
      if datao^.previewing then begin
        node := listview_lib.getnextselected(node);
        continue;
      end;
      stringa := stringa + CRLF + extract_fnameW(utf8strtowidestr(datao^.path));
      node := listview_lib.getnextselected(node);
      if list.count > 30 then break;
    until (not true);

    if list.count = 0 then begin
      list.free;
      exit;
    end;

    if list.count = 1 then stringai := GetLangStringW(STR_DELETE_FILE) + CRLF else stringai := GetLangStringW(STR_DELETE_FILES) + CRLF;


    if messageboxW(self.handle, pwidechar(stringai + stringa + '?' {+CRLF+CRLF+GetLangStringW(STR_THERES_NO_UNDO)}), pwidechar(appname + ': ' + GetLangStringW(STR_WARNING_HD_ERASE)), MB_YESNO + MB_ICONWARNING) = ID_NO then begin
      list.free;
      exit;
    end;



    while (list.count > 0) do begin

      node := list[0];
      list.delete(0);
      datao := listview_lib.getdata(node);

      nomefileW := utf8strtowidestr(datao^.path);
      if helper_diskio.fileexistsW(nomefileW) then begin

        if lowercase(widestrtoutf8str(nomefileW)) = lowercase(widestrtoutf8str(player_actualfile)) then stopmedia(nil);

    //helper_diskio.deletefileW(nomefileW);
        helper_diskio.MoveToRecycle(nomefileW);

        delete_file_da_tree_normal(datao^.folder_id, datao^.shared);
        mainGui_deletesharefile(datao^.path);
        mainGui_erase_shared_entry(datao^.crcsha1, datao^.hash_sha1);

        listview_lib.DeleteNode(node);
      end else begin

      end;

    end;
    list.free;

  except
  end;
  details_library_hideall;
  details_library_toggle(false);

end;

procedure tares_frmmain.shared_unshare_treeview_normal(folder_id: word; shared: boolean);
var
  nodo: PCmtVNode;
  cartella: precord_cartella_share;
begin

  nodo := treeview_lib_regfolders.getfirst;
  if nodo = nil then exit;

  repeat
    nodo := treeview_lib_regfolders.getnext(nodo);
    if nodo = nil then exit;
    cartella := treeview_lib_regfolders.getdata(nodo);
    if cartella^.id <> folder_id then continue;

    if shared then inc(cartella^.items_shared) else begin
      if cartella^.items_shared > 0 then dec(cartella^.items_shared);
    end;
    treeview_lib_regfolders.invalidatenode(nodo);
    exit;
  until (not true);

end;


procedure tares_frmmain.delete_file_da_tree_normal(folder_id: word; was_shared: boolean);
var
  nodo, nodo_parent, nodo_next: PCmtVNode;
  cartella, cartella_parent: precord_cartella_share;
begin
  nodo := treeview_lib_regfolders.getfirst;
  if nodo = nil then exit;


  repeat
    nodo := treeview_lib_regfolders.getnext(nodo);
    if nodo = nil then exit;
    cartella := treeview_lib_regfolders.getdata(nodo);
    if cartella^.id <> folder_id then continue;

    if was_shared then
      if cartella^.items_shared > 0 then dec(cartella^.items_shared);

    if cartella^.items > 0 then dec(cartella^.items);

    if cartella^.items = 0 then begin
      if nodo.childcount > 0 then exit;

      nodo_parent := nodo.parent;
      treeview_lib_regfolders.deletenode(nodo, true);

      while true do begin
        if nodo_parent = nil then exit;
        if nodo_parent.childcount > 0 then exit;
        if treeview_lib_regfolders.getnodelevel(nodo_parent) = 0 then exit;

        cartella_parent := treeview_lib_regfolders.getdata(nodo_parent);
        if cartella_parent^.items > 0 then exit;


        nodo_next := nodo_parent.parent;
        treeview_lib_regfolders.deletenode(nodo_parent, true);
        nodo_parent := nodo_next;
      end;


    end else treeview_lib_regfolders.invalidatenode(nodo);

    exit;
  until (not true);


end;


procedure Tares_frmmain.listview_libClick(Sender: TObject);
var
  data: precord_file_library;
  nodo, node: PCmtVNode;
begin
  try
    if share <> nil then exit;
  except
  end;
  formhint_hide;

  nodo := listview_lib.GetFirstSelected;
  if nodo = nil then exit;
  data := listview_lib.getdata(Nodo);

  if ((data^.hash_sha1 = '') and (data^.path = '')) then begin

    if btn_lib_regular_view.down then begin
      node := trova_nodo_treeview2_folder(listview_lib, treeview_lib_regfolders);
      if node = nil then exit;
      treeview_lib_regfolders.Selected[node] := true;
      treeview_lib_regfolders.expanded[node] := true;
      treeview_lib_regfoldersClick(treeview_lib_regfolders);
    end else begin
      node := trova_nodo_treeview1_categoria(treeview_lib_virfolders, data^.title);
      if node = nil then exit;
      treeview_lib_virfolders.Selected[node] := true;
      treeview_lib_virfoldersClick(treeview_lib_virfolders);
    end;

    exit;
  end;


  library_file_showdetails(data^.hash_sha1);
end;

procedure Tares_frmmain.Edit_titleKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  mainGui_updatevirfolders_entry;
end;

procedure Tares_frmmain.Edit_keywordsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  mainGui_updatevirfolders_entry;
end;

procedure Tares_frmmain.Edit_category_videoClick(Sender: TObject);
begin
  mainGui_updatevirfolders_entry;
end;

procedure Tares_frmmain.chk_lib_filesharedMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ShareUnsharefile1Click(nil);
end;

procedure Tares_frmmain.ShareUnsharefile1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  pfile: precorD_file_library;
  data: precord_file_library;
  i: integer;
  crcsha1: word;
begin

  nodo := listview_lib.GetFirstSelected;
  while (nodo <> nil) do begin
    data := listview_lib.getdata(nodo);
    if data^.previewing then begin
      nodo := listview_lib.getnextselected(nodo);
      continue;
    end;
    crcsha1 := crcstring(data^.hash_sha1);

    try
      for i := 0 to lista_shared.count - 1 do begin
        pfile := lista_shared[i];
        if pfile^.crcsha1 <> crcsha1 then continue;
        if pfile^.hash_sha1 <> data^.hash_sha1 then continue;
        if length(pfile^.title) < 2 then continue;
        if pfile^.corrupt then continue;

        pfile^.shared := not pfile^.shared;
        if pfile^.shared then addfile_tofresh_downloads(pfile); // send to supernodes
        data^.shared := pfile^.shared;
        pfile^.write_to_disk := true;

        shared_unshare_treeview_normal(pfile^.folder_id, pfile^.shared);

        if not pfile^.shared then begin
          if my_shared_count > 0 then dec(my_shared_count);
        end else begin
          inc(my_shared_count);
        end;

        listview_lib.invalidatenode(nodo);

        break;
      end;
    except
    end;


    nodo := listview_lib.getnextselected(nodo);
  end;

end;



procedure Tares_frmmain.Timer_secTimer(Sender: TObject);
begin
  try

    inc(FDecsSecond);
    if FDecsSecond < 10 then exit;
    FDecsSecond := 0;

    scan_in_progress_caption;

    if helper_player.m_GraphBuilder <> nil then begin
      if shoutcast.isPlayingShoutcast then begin
        if (not shoutcast.isConnectingShoutcast) and (not shoutcast.isReconnecting) then ufrmmain.ares_frmmain.trackbar_playertimer(ufrmmain.ares_frmmain.trackbar_player, 0, 0);
      end else helper_player.player_setTrackbar(false);
    end;



/////////////////////////////
 //transfer downloaded KB
    if ares_FrmMain.treeview_Download.visible then
      ares_frmmain.panel_tran_down.capt := ' ' + GetLangStringW(STR_DOWNLOAD) + ': ' +
        format_currency((vars_global.downloadedBytes + vars_global.BitTorrentDownloadedBytes) div KBYTE) + STR_KB + ' ' + GetLangStringW(STR_RECEIVED);
 //transfer uploaded KB
    if ares_FrmMain.treeview_upload.visible then
      if not ares_FrmMain.treeview_queue.visible then
        ares_FrmMain.panel_tran_upqu.capt := ' ' + GetLangStringW(STR_UPLOAD) + ': ' +
          format_currency((vars_global.bytes_sent + vars_global.BitTorrentUploadedBytes) div KBYTE) + STR_KB + ' ' +
          GetLangStringW(STR_SENT);
////////////////


    if check_opt_gen_capt.checked then mainGUI_refresh_caption(false);


    if formhint.top <> 10000 then check_bounds_hint;

    if num_seconds = 60 then begin

      if should_show_prompt_nick then choose_nickname_prompt;

      num_seconds := 0;
      is_idle_cursor(true);


      if DHT_LastPublishKeyFiles <> 0 then
        if gettickcount - DHT_LastPublishKeyFiles >= DHT_REPUBLISHKEYTIMEms then dhtkeywords.DHT_RepublishKeyFiles;

      if DHT_LastPublishHashFiles <> 0 then
        if gettickcount - DHT_LastPublishHashFiles >= DHT_REPUBLISHHASHTIMEms then dhtkeywords.DHT_RepublishHashFiles;

    end else inc(num_seconds);


  except
  end;

end;



procedure Tares_frmmain.trackbar_playerTimer(sender: TObject; CurrentPos, StopPos: Cardinal);
begin // 86400000
  try

    if shoutcast.isPlayingShoutcast then begin
      inc(shoutcast.CurrentPos);
      ares_frmmain.trackbar_player.TimeCaption := format_time(shoutcast.CurrentPos);
      exit;
    end;

    if currentPos >= stoppos then begin
      filtroGraphComplete(nil, 0, nil);
      exit;
    end;


    trackbar_player.TimeCaption := format_time(CurrentPos div 1000) + ' / ' +
      format_time(StopPos div 1000);

  except
  end;
end;

procedure tares_frmmain.update_status_transfer;
var
  stringa_down, stringa_up: widestring;
begin
  try

    if numero_download = 1 then stringa_down := ' ' + GetLangStringW(STR_DOWNLOAD) + ': ' + inttostr(numero_download) + '  '
    else stringa_down := chr(32) + GetLangStringW(STR_DOWNLOADS) + ': ' + inttostr(numero_download) + '   ';

    if numero_upload = 1 then stringa_up := GetLangStringW(STR_UPLOAD) + ': ' + inttostr(numero_upload)
    else stringa_up := GetLangStringW(STR_UPLOADS) + ': ' + inttostr(numero_upload);


    trayicon1.hintw := appname + ' ' +
      stringa_down +
      stringa_up + ' (' + inttostr(numero_queued) +
      ' ' + GetLangStringW(STR_IN_QUEUE) + ')';



  except
  end;
end;


procedure Tares_frmmain.ToolButton18Click(Sender: TObject); //new search
begin
  pagesrc.ActivePage := 0;
end;



procedure Tares_frmmain.ToolButton19Click(Sender: TObject);
begin
  Download1Click(nil);
end;

procedure Tares_frmmain.ToolButton27Click(Sender: TObject);
var
  node, node2, nodetmp: PCmtVNode;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
  dataNode: precord_data_node;
begin
  try
    node := treeview_download.GetFirstselected;
    if node <> nil then begin
      if check_opt_tran_warncanc.checked then begin
        if messageboxW(self.handle, pwidechar(GetLangStringW(STR_ARES_YOU_SURETOCANCEL)), pwidechar(appname + ': ' + GetLangStringW(STR_CANCEL_DL)), mb_yesno + mb_iconquestion) <> IDYES then exit;
      end;


      with treeview_download do begin
        node := GetFirstselected;
        while (node <> nil) do begin

          if getnodelevel(node) = 1 then begin
            node2 := node.parent;
            dataNode := getdata(node2);
          end else dataNode := getData(node);

          case dataNode^.m_type of

            dnt_download,
              dnt_partialDownload: begin
                DnData := dataNode^.data;
                if DnData^.handle_obj <> INVALID_HANDLE_VALUE then DnData^.want_cancelled := true;
              end;

            dnt_bittorrentMain: begin
                BtData := dataNode^.data;
                if BtData^.state = dlSeeding then begin
                  node := GetNextselected(node);
                  continue;
                end;
                BtData^.want_cancelled := true;
              end;

            dnt_bittorrentSource: begin
                nodetmp := node.parent;
                dataNode := getData(nodetmp);
                BtData := dataNode^.data;
                if BtData^.state = dlSeeding then begin
                  node := GetNextselected(node);
                  continue;
                end;
                BtData^.want_cancelled := true;
              end;

          end;

          node := GetNextselected(node);
        end;
      end;

    end else begin
      if btn_tran_toggle_queup.caption = GetLangStringA(STR_SHOW_QUEUE) then Cancel1Click(nil);
    end;


  except
  end;
end;

procedure Tares_frmmain.treeview_downloadGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  Size := SizeOf(record_data_node);
end;

procedure Tares_frmmain.treeview_downloadPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
var
  dataNode: precord_data_node;
begin
  dataNode := sender.getdata(node);
  if dataNode^.m_type <> dnt_PartialDownload then exit;

  TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT1;
  if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext;
end;

procedure Tares_frmmain.treeview_downloadGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
  BtSrcData: btcore.precord_Displayed_source;
  DsData: precord_displayed_downloadsource;
  str1, str2: widestring;
  rem_secs: integer;
begin
  dataNode := sender.getdata(node);
  case DataNode^.m_type of

    dnt_downloadSource: begin
        DsData := dataNode^.data;
        with DsData^ do begin
          case column of
            0: CellText := nomedisplayW;
            1: CellText := '';
            2: CellText := CHRSPACE + utf8strtowidestr(nickname);
            3: CellText := CHRSPACE + SourceStateToStrW(DsData);

            5: if ((state = srs_receiving) or (state = srs_UDPDownloading)) then CellText := format_speedW(speed)
              else CellText := '';
            6: celltext := '';
            7: if ((state = srs_receiving) or (state = srs_UDPDownloading)) then begin
                if ((progress < 4096) and ((progress > 0) or (size < 4096))) then str1 := format_currency(progress) + chr(32) + STR_BYTES + chr(32) else str1 := format_currency(progress div 1024) + STR_KB + chr(32);
                if ((size < 4096) and (size > 0)) then str2 := chr(32) + format_currency(size) + chr(32) + STR_BYTES else str2 := chr(32) + format_currency(size div 1024) + STR_KB;
                celltext := str1 + GetLangStringW(STR_OF) + str2;
              end;
          end;
        end;
      end;

    dnt_bittorrentSource: begin
        BtSrcData := datanode^.data;
        case Column of
          0: if BtSrcDatA^.port > 0 then CellText := BtSrcData^.ipS + ':' + inttostr(BtSrcData^.port)
            else CellText := BtSrcData^.ipS;
          1: CellText := '';
          2: CellText := BtSrcData^.client;
          3: Celltext := bitTorrentStringFunc.BTSourceStatusToStringW(BtSrcData^.status);
          4: Celltext := '';
          5: if BtSrcData^.status = btSourceConnected then
              if ((BtSrcData^.speedDown > 0) or (BtSrcDatA^.speedUp > 0)) then
                CellText := format_speedW(BtSrcData^.speedDown, false) + ' / ' + format_speedW(BtSrcData^.speedUp);
          6: CellText := '';
          7: celltext := format_currency(BtSrcData^.recv div 1024) + ' / ' + format_currency(BtSrcData^.sent div 1024) + STR_KB;
        end;
      end;


    dnt_bittorrentMain: begin
        BtData := dataNode^.data;
        with BtData^ do begin
          case column of
            0: CellText := utf8strtowidestr(filename);
            1: CellText := STR_BITTORRENT;
            2: if BtData^.num_Sources = 1 then CellText := '1 ' + GetLangStringW(STR_USER)
              else CellText := inttostr(BtData^.num_sources) + ' ' + GetLangStringW(STR_USERS);
            3: if ((BtData^.ercode <> 0) and (BtData^.state <> dlCancelled)) then CellText := 'Error (' + inttostr(BtData^.ercode) + ')'
              else CellText := downloadStatetoStrW(BtData);
            5: if speedDl > 0 then CellText := format_speedW(speedDl);
            6: begin
                if speedDl > 0 then
                  if size > downloaded then begin
                    rem_secs := (size - downloaded) div speedDl;
                    CellText := format_time(rem_secs);
                  end;
              end;
            7: begin
                if ((downloaded < 4096) and ((downloaded > 0) or (size < 4096))) then str1 := format_currency(downloaded) + chr(32) + STR_BYTES + chr(32) else str1 := format_currency(downloaded div 1024) + STR_KB + chr(32);
                if ((size < 4096) and (size > 0)) then str2 := chr(32) + format_currency(size) + chr(32) + STR_BYTES else str2 := chr(32) + format_currency(size div 1024) + STR_KB;
                celltext := str1 + GetLangStringW(STR_OF) + str2;
              end;
          end;
        end;
      end;

    dnt_download: begin
        DnData := dataNode^.data;
        with DnData^ do begin
          case column of
            0: CellText := nomedisplayw;
            1: if node.parent = sender.rootnode then CellText := mediatype_to_widestr(tipo) else celltext := chr(32);
            2: if DnData^.state = dlDownloading then begin
                if DnData^.numInDown > 1 then CellText := inttostr(DnData^.numInDown) + ' ' + GetLangStringW(STR_USERS)
                else
                  if DnData^.numInDown = 1 then CellText := '1 ' + GetLangStringW(STR_USER);
              end else begin
                if node.childcount > 1 then CellText := inttostr(node.childcount) + ' ' + GetLangStringW(STR_USERS)
                else
                  if node.childcount = 1 then CellText := '1 ' + GetLangStringW(STR_USER)
                  else
                    CellText := '';
              end;
            3: if node.parent <> sender.rootnode then CellText := ' ' + downloadStatetoStrW(DnData)
              else CellText := downloadStatetoStrW(DnData);
            7: begin
                if size = 0 then begin
                  celltext := chr(32);
                  exit; //MAGNET!
                end;
                if node.parent = sender.rootnode then begin
                  if ((progress < 4096) and ((progress > 0) or (size < 4096))) then str1 := format_currency(progress) + chr(32) + STR_BYTES + chr(32) else str1 := format_currency(progress div 1024) + STR_KB + chr(32);
                  if ((size < 4096) and (size > 0)) then str2 := chr(32) + format_currency(size) + chr(32) + STR_BYTES else str2 := chr(32) + format_currency(size div 1024) + STR_KB;
                  celltext := str1 + GetLangStringW(STR_OF) + str2;
                end else begin
                  if ((state = dlDownloading) or (state = dlUploading)) then begin
                    if ((progress < 4096) and ((progress > 0) or (size < 4096))) then str1 := format_currency(progress) + chr(32) + STR_BYTES + chr(32) else str1 := format_currency(progress div 1024) + STR_KB + chr(32);
                    if ((size < 4096) and (size > 0)) then str2 := chr(32) + format_currency(size) + chr(32) + STR_BYTES else str2 := chr(32) + format_currency(size div 1024) + STR_KB;
                    celltext := str1 + GetLangStringW(STR_OF) + str2;
                  end else celltext := chr(32);
                end;
              end;
            5: begin
                if ((state = dlDownloading) or ((state = dlUploading) and (node.parent <> sender.rootnode))) then begin
                  if size > progress then CellText := format_speedW(velocita) else CellText := chr(32);
                end else celltext := chr(32);
              end;
            6: begin
                if state = dlDownloading then
                  if node.parent = sender.rootnode then begin
                    if size > progress then begin
                      if velocita > 0 then begin
                        rem_secs := (size - progress) div velocita;
                        CellText := format_time(rem_secs);
                      end else CellText := chr(32);
                    end else CellText := chr(32);
                  end else CellText := chr(32);
              end else CellText := chr(32);
          end;
        end;

      end;


  end;

end;


procedure Tares_frmmain.treeview_downloadGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
  BtSrcData: btcore.precord_Displayed_source;
  DsData: precord_displayed_downloadsource;
//len1,len2:integer;
begin
  imageindex := -1;
 //len1:=length(GetLangStringA(STR_QUEUED_STATUS));
 //len2:=length(GetLangStringA(STR_BUSY));

  dataNode := sender.getdata(node);
  case dataNode^.m_type of

    dnt_downloadSource: begin
        DsData := dataNode^.data;
        case DsData^.state of
          srs_receiving, srs_udpDownloading: ImageIndex := 1;
          srs_connecting,
            srs_readytorequest,
            srs_connected,
            srs_ReceivingReply: ImageIndex := 7
        else ImageIndex := 8
        end;
      end;

    dnt_BittorrentSource: begin
        BtSrcData := dataNode^.data;
        case BtSrcData^.status of
          btSourceIdle: ImageIndex := 8;
          btSourceConnected: if BtSrcData^.isOptimistic then ImageIndex := 9
            else ImageIndex := 1;
        else ImageIndex := 7;
        end;
      end;

    dnt_bittorrentMain: begin
        BtData := dataNode^.data;
        with BtData^ do begin
          case state of
            dlDownloading,
              dlUploading: ImageIndex := 1;
            dlSeeding: ImageIndex := 2;
            dlCancelled: ImageIndex := 3;
            dlPaused,
              dlLeechPaused,
              dlLocalPaused: ImageIndex := 6;
          else begin
              if num_sources = 0 then ImageIndex := 0 //searching
              else ImageIndex := 7; //connecting
            end;
          end;
        end;
      end;



    dnt_download: begin
        DnData := dataNode^.data;
        with DnData^ do begin

          if sender.getnodelevel(node) = 1 then begin

            case state of
              dlDownloading,
                dlUploading: ImageIndex := 1;
              dlQueuedSource: ImageIndex := 8
            else ImageIndex := 7;
            end;

          end else begin

            case state of
              dlDownloading,
                dlUploading: ImageIndex := 1;
              dlCompleted: ImageIndex := 2;
              dlCancelled: ImageIndex := 3;
              dlPaused,
                dlLeechPaused,
                dlLocalPaused: ImageIndex := 6;
            else begin
                if num_sources = 0 then ImageIndex := 0 //searching
                else ImageIndex := 7; //connecting
              end;
            end;

          end;
        end;
      end;

    dnt_partialdownload: ImageIndex := 9;
  end;
end;

procedure Tares_frmmain.treeview_downloadAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
var
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
  BtSrcData: btcore.Precord_displayed_source;
  DsData: precord_displayed_downloadsource;
begin
  if column <> 4 then exit;

  dataNode := sender.getdata(node);
  case dataNode^.m_type of

    dnt_bittorrentSource: begin
        BtSrcData := dataNode^.data;
        if BtSrcData^.visualBitfield = nil then exit;
        if length(BtSrcData^.visualBitfield.bits) = 0 then exit;
   //if BtSrcData^.progress=0 then exit;
        if BtSrcData^.progress < 100 then
          draw_progressbarBitTorrent(sender as TCometTree, node,
            targetCanvas,
            CellRect,
            COLOR_DL_COMPLETED,
            BtSrcData)
        else
          draw_progressbarDownload(sender as tcomettree, node,
            targetCanvas,
            CellRect,
            10000,
            10000,
            COLOR_DL_COMPLETED);
      end;

    dnt_bittorrentMain: begin
        BtData := dataNode^.data;
        if BtData^.state = dlCancelled then exit;
        if BtData^.state <> dlSeeding then draw_progressbarBitTorrent(sender as tcomettree, node,
            targetCanvas,
            CellRect,
            COLOR_DL_COMPLETED,
            BtData)
        else draw_progressbarDownload(sender as tcomettree, node,
            targetCanvas,
            CellRect,
            10000,
            10000,
            COLOR_DL_COMPLETED);
      end;

    dnt_download: begin
        DnData := dataNode^.data;
        if DnData^.state = dlCancelled then exit;
        if DnData^.state <> dlCompleted then draw_progressbarDownload(sender as tcomettree, node,
            targetCanvas,
            CellRect,
            DnData^.progress,
            DnData^.size,
            COLOR_PROGRESS_DOWN)
        else draw_progressbarDownload(sender as tcomettree, node,
            targetCanvas,
            CellRect,
            10000,
            10000,
            COLOR_DL_COMPLETED);
      end;

    dnt_downloadSource: begin
        DsData := dataNode^.data;
        if ((DsData^.state <> srs_receiving) and (DsData^.state <> srs_UDPDownloading)) then exit;
        draw_progressbarDownload(sender as tcomettree,
          node,
          targetCanvas,
          CellRect,
          DsData^.progress,
          DsData^.size,
          COLORE_DLSOURCE);
      end;

  end;
end;





procedure Tares_frmmain.ToolButton21Click(Sender: TObject);
begin
  ClearIdle2Click(nil);
  ClearIdle1Click(nil);
end;

procedure tares_frmmain.thread_share_end(var msg: tmessage);
var
  node: PCmtVNode;
  paused: boolean;
begin
  if share = nil then exit;

  try
    share.waitfor;
    share.free;
  except
  end;
  share := nil;

  lbl_hash_hint.visible := false;
  lbl_hash_pri.visible := false;
  hash_pri_trx.visible := false;
  progbar_hash_file.visible := false;
  lbl_hash_progress.visible := false;
  lbl_hash_folder.visible := false;
  lbl_hash_file.visible := false;

  if vars_global.closing then begin
    sleep(5000);
    global_shutdown(true);
    exit;
  end;


  try
    if btn_lib_virtual_view.down then begin
      node := treeview_lib_virfolders.GetFirst;
      if node = nil then exit;
      hashing := false;
      treeview_lib_virfolders.selected[node] := true;
      treeview_lib_virfoldersClick(treeview_lib_virfolders);
    end else begin
      node := treeview_lib_regfolders.GetFirst;
      if node = nil then exit;
      hashing := false;
      treeview_lib_regfolders.selected[node] := true;
      treeview_lib_regfoldersClick(treeview_lib_regfolders);
    end;

    listview_lib.color := COLORE_LISTVIEWS_BG;
    listview_lib.bringtofront;
    listview_lib.color := COLORE_LISTVIEWS_BG;
  except
  end;


  if not need_rescan then exit;
  try
    need_rescan := false;

    paused := set_NEWtrusted_metas;

    vars_global.scan_start_time := gettickcount;

    share := tthread_share.create(true);
    share.paused := paused;
    share.juststarted := false;
    share.Resume;
  except
  end;
end;

procedure tares_frmmain.thread_clientchat_end(var msg: tmessage);
begin
  try

    if client_chat = nil then exit;

    with client_chat do begin
      waitfor;
      free;
    end;

  except
  end;
  client_chat := nil;

end;

procedure Tares_frmmain.OpenPreview1Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
begin
  try

    node := treeview_download.getfirstselected;
    if node <> nil then begin

      if treeview_download.getnodelevel(node) = 1 then node := node.Parent;
      dataNode := treeview_download.getdata(node);

      case dataNode^.m_type of
        dnt_bittorrentMain: Locate2Click(nil);
        dnt_download,
          dnt_partialDownload: begin
            DnData := dataNode^.data;
            if DnData^.state <> dlCompleted then Preview_copyAndOpen(DnData)
            else player_playnew(utf8strtowidestr(DnData^.filename));
          end;
      end;

    end else
      if btn_tran_toggle_queup.caption = GetLangStringA(STR_SHOW_QUEUE) then OpenPlay2Click(nil)
      else MenuItem8Click(nil);

  except
  end;
end;

procedure Tares_frmmain.panel_vidResize(Sender: TObject);
begin
  resize_video_window;
end;

procedure Tares_frmmain.Fullscreen2Click(Sender: TObject);
begin
  if not isvideoplaying then exit;
  if helper_player.m_GraphBuilder = nil then exit;
  if helper_player.player_GetState = gsStopped then exit;

  fullscreen2.checked := not fullscreen2.checked;

  player_togglefullscreen(fullscreen2.checked);
end;

procedure Tares_frmmain.btn_player_pauseClick(Sender: TObject);
begin
  if helper_player.m_GraphBuilder = nil then exit;

  if helper_player.player_GetState = gsPaused then begin
    runmedia;
  end else begin
    if ((sender = nil) and (not check_opt_gen_pausevid.checked)) then exit;
    pausemedia;
    if sender <> nil then stopped_by_user := true;
  end;

end;

procedure Tares_frmmain.btn_player_playClick(Sender: TObject);
var
  state: TGraphState;
begin
  if not helper_player.player_working then exit;

  if player_actualfile = '' then begin
    playlist_playnext('');
    exit;
  end;
  state := helper_player.player_GetState;
  if ((state = gsStopped) or (state = gsUninitialized)) then begin
    player_playnew(player_actualfile);
  end else runmedia;
end;

procedure tares_frmmain.previewstart_event(var msg: tmessage);
begin
  player_playnew(file_visione_da_copiatore);
end;

procedure Tares_frmmain.OpenPlay1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  data: ^record_file_library;
begin
  nodo := listview_lib.GetFirstSelected;
  if nodo = nil then exit;
  data := listview_lib.getdata(nodo);
  player_playnew(utf8strtowidestr(data^.path));
end;

procedure Tares_frmmain.Locate1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  data: ^record_file_library;
begin
  nodo := listview_lib.GetFirstSelected;
  if nodo = nil then exit;
  data := listview_lib.getdata(nodo);

  locate_containing_folder(data^.path);
//Tnt_ShellExecuteW(0,'open',pwidechar(folder_id_to_folder_name(data^.folder_id,treeview_lib_regfolders)+'\'),'','',Sw_ShOwNORMAL);
end;

procedure Tares_frmmain.track_not_enabled_to_change(Sender: TObject);
begin
//
end;

procedure Tares_frmmain.btn_player_volClick(Sender: TObject);
var
  punto: tpoint;
  frm: Tfrmctrlvol;
begin
  frm := Tfrmctrlvol.create(self);
  with frm do begin
    width := 80;
    checkbox1.Width := 78 - checkbox1.left;
    btn_close.left := 78 - btn_close.width;
    getcursorpos(punto);
    with punto do begin
      left := x - 20;
      top := (y - height);
    end;
    formstyle := fsStayOnTop;
    show;
  end;

end;

procedure Tares_frmmain.Openwithexternalplayer1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  data: precord_file_library;
begin
  nodo := listview_lib.GetFirstSelected;
  if nodo = nil then exit;
  data := listview_lib.getdata(nodo);
  open_file_external(data^.path);
end;




procedure Tares_frmmain.ksoOfficeSpeedButton13Click(Sender: TObject);
begin
  if not isvideoplaying then exit;

  if fullscreen2.checked then Fullscreen2Click(nil);

  fittoscreen1.checked := not fittoscreen1.checked;
  originalsize1.checked := (not fittoscreen1.checked);
  panel_vidresize(nil);
end;

procedure Tares_frmmain.treeview_uploadGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  Size := SizeOf(record_data_node);
end;

procedure Tares_frmmain.treeview_uploadGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  UpData: precord_displayed_upload;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
  BtSrcData: btcore.precord_Displayed_source;
  dataNode: precord_data_node;
  str1, str2: widestring;
begin
  DataNode := sender.getdata(Node);
  case DataNode^.m_type of

    dnt_bittorrentSource: begin
        BtSrcData := datanode^.data;
        case Column of
          0: if BtSrcData^.port > 0 then CellText := BtSrcData^.ips + ':' + inttostr(BtSrcData^.port)
            else CellText := BtSrcData^.ips;
          1: CellText := '';
          2: CellText := BtSrcData^.client;
          3: Celltext := bitTorrentStringFunc.BTSourceStatusToStringW(BtSrcData^.status);
          4: Celltext := '';
          5: if BtSrcData^.status = btSourceConnected then
              if BtSrcDatA^.speedUp > 0 then
                CellText := format_speedW(BtSrcData^.speedUp);
          6: CellText := '';
          7: celltext := format_currency(BtSrcData^.recv div 1024) + ' / ' + format_currency(BtSrcData^.sent div 1024) + STR_KB;
        end;
      end;


    dnt_bittorrentMain: begin
        BtData := dataNode^.data;
        with BtData^ do begin
          case column of
            0: CellText := utf8strtowidestr(filename);
            1: CellText := STR_BITTORRENT;
            2: if BtData^.num_Sources = 1 then CellText := '1 ' + GetLangStringW(STR_USER)
              else CellText := inttostr(BtData^.num_sources) + ' ' + GetLangStringW(STR_USERS);
            3: if ((BtData^.ercode <> 0) and (BtData^.state <> dlCancelled)) then CellText := 'Error (' + inttostr(BtData^.ercode) + ')'
              else CellText := downloadStatetoStrW(BtData);
            5: if speedUl > 0 then CellText := format_speedW(speedUl);
            6: CellText := '';
            7: begin
                if ((uploaded < 4096) and ((uploaded > 0) or (size < 4096))) then str1 := format_currency(uploaded) + chr(32) + STR_BYTES + chr(32) else str1 := format_currency(uploaded div 1024) + STR_KB + chr(32);
                if ((size < 4096) and (size > 0)) then str2 := chr(32) + format_currency(size) + chr(32) + STR_BYTES else str2 := chr(32) + format_currency(size div 1024) + STR_KB;
                celltext := str1 + GetLangStringW(STR_OF) + str2;
              end;
          end;
        end;
      end;


    dnt_upload: begin
        UpData := DataNode^.data;
        with UpData^ do begin
          case column of
            0: CellText := extract_fnameW(utf8strtowidestr(nomefile));
            1: CellText := mediatype_to_widestr(extstr_to_mediatype(lowercase(extractfileext(nomefile))));
            2: CellText := utf8strtowidestr(nickname);
            3: begin
                if completed then begin
                  if progress = size then CellText := GetLangStringW(STR_COMPLETED)
                  else CellText := GetLangStringW(STR_CANCELLED);
                end else CellText := GetLangStringW(STR_UPLOADING);
              end;
            5: if completed then CellText := chr(32) else CellText := format_speedW(velocita);
            6: if completed then CellText := chr(32) else begin
                if velocita > 0 then CellText := format_time((size - progress) div velocita)
                else CellText := chr(32);
              end;
            7: begin

                if ((progress + continued_from < 4096) and ((progress + continued_from > 0) or (size + continued_from < 4096))) then str1 := format_currency(progress + continued_from) + chr(32) + STR_BYTES + chr(32) else str1 := format_currency((progress + continued_from) div 1024) + STR_KB + chr(32);
                if ((size + continued_from < 4096) and (size + continued_from > 0)) then str2 := chr(32) + format_currency(size + continued_from) + chr(32) + STR_BYTES else str2 := chr(32) + format_currency((size + continued_from) div 1024) + STR_KB;
                celltext := str1 + GetLangStringW(STR_OF) + str2;

              end else CellText := chr(32);

          end;
        end;
      end;

    dnt_Partialupload: begin
        DnData := dataNode^.data;
        with DnData^ do begin
          case column of
            0: CellText := nomedisplayw;
            1: CellText := mediatype_to_widestr(tipo);
         //2:CellText:=utf8strtowidestr(nickname);
            3: CellText := GetLangStringW(STR_UPLOADING);
            5: CellText := format_speedW(velocita);
            6: if velocita > 0 then CellText := format_time((size - progress) div velocita) else CellText := chr(32);
            7: begin
                if ((progress < 4096) and ((progress > 0) or (size < 4096))) then str1 := format_currency(progress) + chr(32) + STR_BYTES + chr(32)
                else str1 := format_currency(progress div 1024) + STR_KB + chr(32);
                if ((size < 4096) and (size > 0)) then str2 := chr(32) + format_currency(size) + chr(32) + STR_BYTES
                else str2 := chr(32) + format_currency(size div 1024) + STR_KB;
                celltext := str1 + GetLangStringW(STR_OF) + str2;
              end;
          end;
        end;
      end;

  end;

end;

procedure Tares_frmmain.treeview_uploadAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
var
  oldcolor, oldpencolor, colosf: tcolor;
  UpData: precord_displayed_upload;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
  BtSrcData: btcore.Precord_displayed_source;
  dataNode: precord_data_node;
  progress: double;
  str_percent: string;
  ind: integer;
  fprogress, fsize: int64;
  fcompleted: boolean;
begin
  if column <> 4 then exit;

  datanode := sender.getdata(node);
  case dataNode^.m_type of

    dnt_bittorrentSource: begin
        BtSrcData := dataNode^.data;
        if BtSrcData^.visualBitfield = nil then exit;
        if length(BtSrcData^.visualBitfield.bits) = 0 then exit;
   //if BtSrcData^.status<>btSourceConnected then exit;
        if BtSrcData^.progress < 100 then
          draw_progressbarBitTorrent(sender as TCometTree, node,
            targetCanvas,
            CellRect,
            COLOR_DL_COMPLETED,
            BtSrcData)
        else
          draw_progressbarDownload(sender as tcomettree, node,
            targetCanvas,
            CellRect,
            10000,
            10000,
            COLOR_DL_COMPLETED);
        exit;
      end;

    dnt_bittorrentMain: begin
        BtData := dataNode^.data;
        if BtData^.state = dlCancelled then exit;
        draw_progressbarDownload(sender as tcomettree, node,
          targetCanvas,
          CellRect,
          10000,
          10000,
          COLOR_DL_COMPLETED);
        exit;
      end;

    dnt_upload: begin
        Updata := dataNode^.data;
        fprogress := UpData^.progress;
        fsize := Updata^.size;
        fcompleted := UpData^.completed;
      end;
    dnt_partialUpload: begin
        DnData := dataNode^.data;
        fprogress := DnData^.progress;
        fsize := DnData^.size;
        fcompleted := false;
      end else exit;
  end;

  with targetcanvas do begin
    oldcolor := brush.color;
    oldpencolor := pen.color;

    if check_opt_tran_perc.checked then begin
      brush.style := bsclear;
      progress := fprogress;
      if progress > 0 then begin
        if fsize = 0 then progress := 100 else begin
          progress := progress / fsize;
          progress := progress * 100;
        end;
      end else progress := 0;
      str_percent := FloatToStrF(progress, ffNumber, 18, 2);
      delete(str_percent, pos('.', str_percent), length(stR_percent));
      str_percent := str_percent + '%';
      if length(str_percent) = 2 then begin //0..9%
        ind := (textwidth(chr(48) {'0'} + str_percent) - textwidth(str_percent)) div 2;
        TextRect(cellrect, cellrect.left + ind, cellrect.Top + 2, str_percent);
        cellrect.left := cellrect.left + (textwidth(chr(48) {'0'} + str_percent) + 2);
      end else begin
        TextRect(cellrect, cellrect.left, cellrect.Top + 2, str_percent);
        cellrect.left := cellrect.left + (textwidth(str_percent) + 2);
      end;
    end;

    if SETTING_3D_PROGBAR then begin
      if (node.Index mod 2) = 0 then begin //level0 colorato
        colosf := treeview_download.BGColor;
      end else begin //level0 non colorato
        colosf := treeview_download.Color;
      end;

      draw_3d_progressframe(targetcanvas, cellrect, colosf);
    end;


    if ((fcompleted) and
      (fprogress = fsize)) then begin
      brush.color := COLOR_UL_COMPLETED;
      pen.color := COLOR_UL_COMPLETED;
      if not SETTING_3D_PROGBAR then Targetcanvas.framerect(rect(cellrect.left + 2, cellrect.Top + 1, cellrect.right - 2, cellrect.bottom - 2));
      draw_progress_tran(TargetCanvas, cellrect, 0, 10000, 10000, false);
    end else begin

      if dataNode^.m_type = dnt_partialUpload then begin
        brush.color := COLORE_PARTIAL_UPLOAD;
        pen.color := COLORE_PARTIAL_UPLOAD; ;
      end else begin
        brush.color := COLOR_PROGRESS_UP;
        pen.color := COLOR_PROGRESS_UP;
      end;

      if not SETTING_3D_PROGBAR then Targetcanvas.framerect(rect(cellrect.left + 2, cellrect.Top + 1, cellrect.right - 2, cellrect.bottom - 2));
      draw_progress_tran(TargetCanvas, cellrect, 0, fprogress, fsize, fcompleted);
    end;


    Brush.Color := oldcolor;
    pen.color := oldpencolor;
  end;

end;


procedure Tares_frmmain.treeview_uploadGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  DataNode: precord_data_node;
  UpData: precord_displayed_upload;
  BtData: precord_displayed_bittorrentTransfer;
  BtSrcData: btcore.precord_Displayed_source;
begin
  dataNode := sender.getdata(node);
  case dataNode^.m_type of

    dnt_BittorrentSource: begin
        BtSrcData := dataNode^.data;
        case BtSrcData^.status of
          btSourceIdle: ImageIndex := 8;
          btSourceConnected: if BtSrcData^.isOptimistic then ImageIndex := 9
            else ImageIndex := 1;
        else ImageIndex := 7;
        end;
      end;

    dnt_bittorrentMain: begin
        BtData := dataNode^.data;
        with BtData^ do begin
          case state of
            dlDownloading,
              dlUploading: ImageIndex := 1;
            dlSeeding: ImageIndex := 2;
            dlCancelled: ImageIndex := 3;
            dlPaused,
              dlLeechPaused,
              dlLocalPaused: ImageIndex := 6;
          else begin
              if num_sources = 0 then ImageIndex := 0 //searching
              else ImageIndex := 7; //connecting
            end;
          end;
        end;
      end;

    dnt_upload: begin
        UpData := DataNode^.data;
        if ((UpData^.completed) and
          (UpData^.size = UpData^.progress)) then ImageIndex := 2
        else
          if UpData^.completed then ImageIndex := 3
          else ImageIndex := 9;
      end;
    dnt_Partialupload: ImageIndex := 9;
  end;
end;

procedure Tares_frmmain.panel_transferResize(Sender: TObject);
begin
  splitter_transfer.componentTop := (sender as tpanel).top;
  splitter_transfer.componentLeft := (sender as tpanel).left + (integer(helper_skin.SkinnedFrameLoaded) * helper_skin.fBorderWidth);
  splitter_transfer.width := panel_tran_down.width;

  panel_tran_upqu.height := panelUploadHeight;
 //panel_tran_upqu.Top:=splitter_transfer.clientheight+panelUploadHeight;

  splitter_transfer.top := panel_tran_upqu.Top - splitter_transfer.height;

//if panel_transfer.height-panelUploadHeight>20 then
  panel_tran_down.height := splitter_transfer.top;

  panel_tran_downResize(panel_tran_down);
  panel_tran_upquResize(panel_tran_upqu);
end;

procedure Tares_frmmain.resize_pannellobottom_editchat(Sender: TObject);
var
  panel: ttntpanel;
  edit: ttntedit;
  i: integer;
begin
  try

    panel := sender as ttntpanel;
    for i := 0 to panel.ControlCount - 1 do begin
      if panel.controls[i] is ttntedit then begin
        edit := panel.controls[i] as ttntedit;
        edit.width := panel.clientwidth;
        edit.top := panel.clientheight - edit.height;
      end;
    end;

  except
  end;
end;


procedure Tares_frmmain.PauseResume1Click(Sender: TObject);
var
  node, node2: PCmtVNode;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
  dataNode: precord_data_node;
begin
  node := treeview_download.GetFirstselected;
  while (node <> nil) do begin

    if treeview_download.getnodelevel(node) = 1 then begin
      node2 := node.parent;
      dataNode := treeview_download.getdata(node2);
    end else dataNode := treeview_download.getdata(node);

    if dataNode^.m_type = dnt_download then begin
      DnData := dataNode^.data;
      DnData^.change_paused := true;
    end else
      if dataNode^.m_type = dnt_bittorrentMain then begin
        BtData := dataNode^.data;
        if BtData^.state <> dlCancelled then
          if btData^.state <> dlSeeding then BtData^.want_paused := true;
      end;

    node := treeview_download.GetNextselected(node);
  end;

end;


procedure Tares_frmmain.split_tranCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
begin
  accept := ((newsize > 38) and (newsize < panel_transfer.clientheight - 10));
end;

procedure Tares_frmmain.Addtoplaylist1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  data: precord_file_library;
begin
  try

    nodo := listview_lib.GetFirstSelected;
    repeat
      if nodo = nil then break;
      data := listview_lib.getdata(nodo);

      playlist_addfile(data^.path, data^.param3, false, '');

      nodo := listview_lib.getnextselected(nodo);
    until (not true);

  except
  end;
end;

procedure Tares_frmmain.Addtoplaylist2Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
begin

  node := treeview_download.GetFirstselected;
  while (node <> nil) do begin

    if treeview_download.getnodelevel(node) <> 0 then begin
      node := treeview_download.GetNextselected(node);
      continue;
    end;

    dataNode := treeview_download.getdata(node);
    if ((dataNode^.m_type = dnt_download) or
      (dataNode^.m_type = dnt_partialDownload)) then begin
      DnData := dataNode^.data;
      playlist_addfile(DnData^.filename, DnData^.param3, false, '');
    end;


    node := treeview_download.GetNextselected(node);
  end;

end;


procedure Tares_frmmain.Popup_downloadPopup(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
  BtSrcData: btcore.Precord_displayed_source;
begin
  Addtoplaylist2.visible := false;
  node := treeview_download.getfirstselected;

  if node = nil then begin

    locate2.visible := false;
    n12.visible := false;
    Addtoplaylist2.visible := false;
    removesource1.visible := false;

  end else begin
    locate2.visible := true;
    n12.visible := true;
    dataNode := treeview_download.getdata(node);
    case dataNode^.m_type of

      dnt_bittorrentMain,
        dnt_BitTorrentSource: begin
          if dataNode^.m_type = dnt_bittorrentSource then begin
            BtSrcData := dataNode^.data;
            removesource1.visible := (btSrcData^.status = btSourceConnected);
          end else removesource1.visible := false;
          Chat2.visible := false;
          Addtoplaylist2.visible := false;
          OpenPreview2.visible := false;
        end;

      dnt_downloadSource: begin
          removesource1.visible := true;
          chat2.visible := true;
        end;

      dnt_download,
        dnt_partialDownloaD: begin
      // DnData:=dataNode^.data;
      // OpenPreview2.visible:=(DnData^.progress>0);
          removesource1.visible := false;
          Chat2.visible := false;
        end;

    end;

  end;

//   N4.visible:=((chat2.visible) or
//                (removesource1.visible));


  node := treeview_download.GetFirstselected;
  while (node <> nil) do begin
    dataNode := treeview_download.getdata(node);
    if dataNode^.m_type <> dnt_download then begin
      node := treeview_download.GetNextselected(node);
      continue;
    end;
    DnData := dataNode^.data;
    Addtoplaylist2.visible := (DnData^.state = dlCompleted);
    break;
  end;


end;

procedure Tares_frmmain.treeview_uploadDblClick(Sender: TObject);
var
  node: PCmtVNode;
  DataNode: precord_data_node;
  UpData: precord_displayed_upload;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
begin
  node := treeview_upload.GetFirstselected;
  if node = nil then exit;

  dataNode := treeview_upload.getdata(node);
  case dataNode^.m_type of
    dnt_upload: begin
        UpData := datanode^.data;
        player_playnew(utf8strtowidestr(UpData^.nomefile));
      end;
    dnt_partialUpload: begin
        DnData := dataNode^.data;
        Preview_copyAndOpen(DnData);
      end;

    dnt_bittorrentMain: begin
        BtData := dataNode^.data;
        locate_containing_folder(BtData^.path);
      end;

    dnt_bittorrentSource: begin
        node := node.parent;
        dataNode := treeview_upload.getData(node);
        BtData := dataNode^.data;
        locate_containing_folder(BtData^.path);
      end;

  end;

end;



procedure Tares_frmmain.Locate2Click(Sender: TObject);
var
  node: PCmtVNode;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
  dataNode: precord_data_node;
begin
  node := treeview_download.GetFirstselected;
  if node = nil then exit;

  if treeview_download.getnodelevel(node) = 1 then node := node.parent;
  dataNode := treeview_download.getdata(node);
  case dataNode^.m_type of

    dnt_bittorrentMain: begin
        BtData := dataNode^.data;
        locate_containing_folder(BtData^.path);
      end;

    dnt_bittorrentSource: begin
        node := node.parent;
        dataNode := treeview_download.getData(node);
        BtData := dataNode^.data;
        locate_containing_folder(BtData^.path);
      end;

    dnt_download,
      dnt_partialDownload: begin
        DnData := dataNode^.data;
        locate_containing_folder(DnData^.filename);
      end;
  end;

end;

procedure Tares_frmmain.OpenPlay2Click(Sender: TObject);
var
  node: PCmtVNode;
  UpData: precord_displayed_upload;
  DnData: precord_displayed_download;
  dataNode: precord_data_node;
  BtData: precord_displayed_bittorrentTransfer;
begin
  node := treeview_upload.getfirstselected;
  if node = nil then exit;

  dataNode := treeview_upload.getdata(node);
  case dataNode^.m_type of
    dnt_bittorrentMain: begin
        BtData := dataNOde^.data;
        locate_containing_folder(BtData^.path);
      end;
    dnt_bittorrentSource: begin
        node := node.parent;
        dataNode := treeview_upload.getData(node);
        BtData := dataNOde^.data;
        locate_containing_folder(BtData^.path);
      end;
    dnt_upload: begin
        UpData := dataNode^.data;
        player_playnew(utf8strtowidestr(UpData^.nomefile));
      end;
    dnt_partialUpload: begin
        DnData := dataNode^.data;
        Preview_copyAndOpen(DnData)
      end;
  end;

end;

procedure Tares_frmmain.locateupload3Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
  UpData: precord_displayed_upload;
  BtData: precord_displayed_bittorrentTransfer;
begin
  node := treeview_upload.getfirstselected;
  if node = nil then exit;

  datanode := treeview_upload.getdata(node);
  case dataNode^.m_type of

    dnt_bittorrentMain: begin
        BtData := dataNOde^.data;
        locate_containing_folder(BtData^.path);
      end;
    dnt_bittorrentSource: begin
        node := node.parent;
        dataNode := treeview_upload.getData(node);
        BtData := dataNode^.data;
        locate_containing_folder(BtData^.path);
      end;

    dnt_upload: begin
        UpData := dataNode^.data;
        locate_containing_folder(UpData^.nomefile);
      end;
    dnt_partialupload: begin
        DnData := dataNode^.data;
        locate_containing_folder(DnData^.filename);
      end;
  end;

end;

procedure Tares_frmmain.Sendmessage1Click(Sender: TObject);
var
  nodo: PCmtVNode;
begin
  nodo := treeview_download.getfirstselected;
  if nodo = nil then begin
    if treeview_upload.visible then begin
      nodo := treeview_upload.getfirstselected;
      if nodo = nil then exit;
      Chat1Click(nil);
    end else begin
      nodo := treeview_queue.getfirstselected;
      if nodo = nil then exit;
      Chatwithuser1Click(nil);
    end;

  end else Chat2Click(nil);
end;


procedure Tares_frmmain.listview_srcMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nodo: PCmtVNode;
  data: precord_search_result;
  punto: tpoint;
begin

  if not (sender as tcomettree).selectable then exit;
  if button <> mbright then exit;

  nodo := (sender as tcomettree).getfirstselected;
  if nodo = nil then exit;
  if (sender as tcomettree).GetNodeLevel(nodo) > 0 then nodo := nodo.parent;

  data := (sender as tcomettree).getdata(nodo);

  if data^.already_in_lib then begin
    Download1.visible := false;
    Play3.visible := true;
  end else begin
    Download1.visible := true;
    Play3.visible := false;
  end;


  Artist2.visible := ((length(data^.artist) > 0) and (data^.amime = ARES_MIME_MP3));
  Genre2.visible := ((length(data^.category) > 0) and (data^.amime = ARES_MIME_MP3));
  Findmorefromthesame1.visible := ((Artist2.visible) or (Genre2.visible));

  getcursorpos(punto);
  popup_search.popup(punto.x, punto.y);
end;





procedure Tares_frmmain.Cancel1Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  UpData: precord_displayed_upload;
  BtData: precord_displayed_bittorrentTransfer;
//BtSrcData:btcore.precord_Displayed_source;
begin
  node := treeview_upload.getfirstselected;
  if node = nil then exit;

  dataNode := treeview_upload.getdata(node);
  if dataNode^.m_type = dnt_upload then begin
    UpData := dataNode^.data;
    UpData^.should_stop := true;
  end else
    if dataNode^.m_type = dnt_bittorrentMain then begin
      BtData := dataNode^.data;
      BtData^.want_cancelled := true;
    end else
      if dataNode^.m_type = dnt_bitTorrentSource then begin
        dataNode := treeview_upload.getdata(node.parent);
        BtData := dataNode^.data;
        BtData^.want_cancelled := true;
      end;
end;

procedure Tares_frmmain.treeview_uploadMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  punto: tpoint;
  dataNode: precord_data_node;
  UpData: precord_displayed_upload;
//DnData:precord_displayed_download;
  BtSrcData: btcore.Precord_displayed_source;
  node: PCmtVNode;
begin
  formhint_hide;

  if button <> mbright then exit;
  if treeview_upload.rootnodecount = 0 then exit;
  node := treeview_upload.getfirstselected;
  if node = nil then begin
    chat1.Visible := false;
    grantslot2.visible := false;
    n13.visible := false;
    removesource2.visible := false;
  end else begin
    dataNode := treeview_upload.getdata(node);

    case DataNode^.m_type of

      dnt_bittorrentMain,
        dnt_BitTorrentSource: begin
          if dataNode^.m_type = dnt_bittorrentSource then begin
            BtSrcData := dataNode^.data;
            removesource2.visible := (btSrcData^.status = btSourceConnected);
          end else removesource2.visible := false;
          Chat1.visible := false;
          GrantSlot2.visible := false;
          addToPlaylist3.visible := false;
          cancel1.visible := true;
          clearIdle1.visible := true;
          BanUser1.visible := false;
          n10.Visible := false;
        end;

      dnt_upload: begin
          UpData := dataNode^.data;
          Chat1.visible := (UpData^.port <> 0);
          GrantSlot2.visible := true;
          addToPlaylist3.visible := true;
          cancel1.visible := true;
          ClearIdle1.visible := true;
          BanUser1.visible := True;
          N10.visible := true;
          removesource2.visible := false;
        end;

      dnt_Partialupload: begin
     //DnData:=dataNode^.data;
     //Chat1.visible:=(DnData^.port<>0);
          GrantSlot2.visible := false;
          addToPlaylist3.visible := false;
          cancel1.visible := false;
          ClearIdle1.visible := false;
          BanUser1.visible := false;
          N10.visible := false;
          removesource2.visible := false;
        end;
    end;

    N13.visible := (chat1.Visible) or
      (grantslot2.visible) or
      (removesource2.visible);
  end;

  getcursorpos(punto);
  popup_upload.popup(punto.x, punto.y);
end;

procedure Tares_frmmain.Chat1Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  UpData: precord_displayed_upload;
//DnData:precord_displayed_download;
  ips: string;
begin
  try
    node := treeview_upload.getfirstselected;
    if node = nil then exit;

    if gettickcount - last_chat_req < DELAY_BETWEEN_RECHAT_REQUEST then exit;
    last_chat_req := gettickcount;

    dataNode := treeview_upload.getdata(node);
    case dataNode^.m_type of
      dnt_upload: begin
          UpData := dataNode^.data;
          if UpData^.port = 0 then exit;

          ips := ipint_to_dotstring(UpData^.ip);
          chat_with_user(ips,
            UpData^.port,
            UpData^.ip_alt,
            UpData^.ip_server,
            UpData^.port_server,
            UpData^.nickname);
        end;

      dnt_Partialupload: begin
   // DnData:=dataNode^.data;
   // if DnData^.port_server=0 then exit;
   // ips:=ipint_to_dotstring(DnData^.ip);
   { chat_with_user(ips,
                   DnData^.port,
                   DnData^.ip_alt,
                   DnData^.ip_server,
                   DnData^.port_server,
                   widestrtoutf8str(DnData^.nicknamew));}
        end;

    end;

  except
  end;
end;

procedure Tares_frmmain.BanUser1Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  UpData: precord_displayed_upload;
begin
  node := treeview_upload.getfirstselected;
  if node = nil then exit;

  datanode := treeview_upload.getdata(node);
  if dataNode^.m_type <> dnt_upload then exit;

  UpData := dataNode^.data;
  UpData^.should_ban := true;
end;

procedure Tares_frmmain.combocatlibraryClick(Sender: TObject);
begin
  mainGui_updatevirfolders_entry;
end;

procedure Tares_frmmain.Chat2Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  DsData: precord_displayed_downloadsource;
  ips: string;
begin
  node := treeview_download.getfirstselected;
  if node = nil then exit;

  if treeview_download.getfirstchild(node) <> nil then exit;

  dataNode := treeview_download.getdata(node);
  if dataNode^.m_type <> dnt_downloadSource then
    if dataNode^.m_type <> dnt_partialDownload then exit;

  if dataNode^.m_type = dnt_downloadSource then begin
    DsData := dataNode^.data;
    if DsData^.port = 0 then exit;

    if gettickcount - last_chat_req < DELAY_BETWEEN_RECHAT_REQUEST then exit;
    last_chat_req := gettickcount;


    ips := ipint_to_dotstring(DsData^.ip);

    chat_with_user(ips,
      DsData^.port,
      DsData^.ip_alt,
      DsData^.ip_server,
      DsData^.port_server,
      DsData^.nickname);
  end else begin
  end;
end;



procedure Tares_frmmain.treeview_downloadMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  punto: tpoint;
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
//BtData:precord_displayed_bittorrentTransfer;
//DsData:precord_displayed_downloadsource;
  node: PCmtVNode;
begin
  formhint_hide;

  if treeview_download.rootnodecount = 0 then exit;
  if button <> mbright then exit;

  node := treeview_download.getfirstselected;
  if node <> nil then begin
    dataNode := treeview_download.getdata(node);
    case dataNode^.m_type of

      dnt_bittorrentMain,
        dnt_bittorrentSource: begin
         //removesource1.visible:=false;
          openpreview2.visible := false;
          pauseresume1.visible := true;
          cancel2.visible := true;
          openexternal1.visible := false;
          Chat2.visible := false;
          N4.visible := false;
          RemoveSource1.visible := false;
          Findmorefromthesame2.visible := false;
        end;

      dnt_download,
        dnt_PartialDownload: begin
          DnData := dataNode^.data;
          Chat2.visible := false;
          N4.visible := false;
          RemoveSource1.visible := false;
          pauseresume1.visible := true;
          cancel2.visible := true;
          openpreview2.visible := (DnData^.progress > 0);
          openexternal1.visible := openpreview2.visible;
          Findmorefromthesame2.visible := (DnData^.tipo = ARES_MIME_MP3);
          Artist3.visible := (length(DnData^.artist) > 0);
          Genre3.visible := (length(DnData^.category) > 0);
        end;


      dnt_downloadSource: begin
          dataNode := treeview_download.getData(node.parent);
          DnData := dataNode^.data;
          Chat2.visible := true;
          N4.visible := true;
          RemoveSource1.visible := true;
          pauseresume1.visible := true;
          cancel2.visible := true;
          openpreview2.visible := (DnData^.progress > 0);
          openexternal1.visible := openpreview2.visible;
          Findmorefromthesame2.visible := (DnData^.tipo = ARES_MIME_MP3);
          Artist3.visible := (length(DnData^.artist) > 0);
          Genre3.visible := (length(DnData^.category) > 0);
        end;

    end;

  end else begin
    openpreview2.visible := false;
    openexternal1.visible := false;
    pauseresume1.visible := false;
    cancel2.visible := false;
    Findmorefromthesame2.visible := false;
    Artist3.visible := false;
    Genre3.visible := false;
    Chat2.visible := false;
    N4.visible := false;
    RemoveSource1.visible := false;
  end;


  getcursorpos(punto);
  popup_download.popup(punto.x, punto.y);
end;


procedure Tares_frmmain.treeview_downloadMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nodo: PCmtVNode;
begin

  formhint_hide;
  repeat
    nodo := treeview_upload.GetFirstSelected;
    if nodo = nil then break;
    treeview_upload.Selected[nodo] := false;
  until (not true);

  repeat
    nodo := treeview_queue.getfirstselected;
    if nodo = nil then break;
    treeview_queue.selected[nodo] := false;
  until (not true);

end;

procedure Tares_frmmain.treeview_uploadMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nodo: PCmtVNode;
begin


  formhint_hide;
  repeat
    nodo := treeview_download.GetFirstSelected;
    if nodo = nil then break;
    treeview_download.Selected[nodo] := false;
  until (not true);

  repeat
    nodo := treeview_queue.GetFirstSelected;
    if nodo = nil then break;
    treeview_queue.Selected[nodo] := false;
  until (not true);

end;

procedure Tares_frmmain.panel_tran_upquResize(Sender: TObject);
begin
  treeview_upload.height := panel_tran_upqu.clientheight - 18;
  treeview_queue.height := panel_tran_upqu.clientheight - 18;
end;

procedure Tares_frmmain.panel_tran_downResize(Sender: TObject);
begin
  with treeview_download do begin
// width:=panel_tran_down.clientwidth{-4};
    height := panel_tran_down.clientheight - 23 {top) -2};
  end;
end;


procedure Tares_frmmain.label_back_srcClick(Sender: TObject);
begin
  if btn_stop_search.enabled then btn_stop_searchclick(nil);
  search_toggle_back;
end;

procedure Tares_frmmain.label_more_searchoptClick(Sender: TObject);
begin
  if btn_stop_search.enabled then btn_stop_searchclick(nil);
  search_toggle_moreopt;
end;

procedure Tares_frmmain.radio_search_allClick(Sender: TObject);
begin
  if btn_stop_search.enabled then btn_stop_searchclick(nil);
  searchpanel_add_histories;
end;

procedure Tares_frmmain.TreeView2GetSelectedIndex(Sender: TObject; Node: TTreeNode);
begin
  if node.level > 0 then begin
    node.SelectedIndex := 1;
    node.imageindex := 0;
  end;
end;

procedure Tares_frmmain.btn_lib_virtual_viewClick(Sender: TObject);
var
  nodo: PCmtVNode;
begin
  btn_lib_virtual_view.down := true;
  btn_lib_regular_view.down := false;

  treeview_lib_virfolders.visible := true;
  treeview_lib_regfolders.visible := false;

  listview_lib.clear;
  details_library_toggle(false);
  if treeview_lib_virfolders.getfirstselected = nil then begin
    nodo := treeview_lib_virfolders.GetFirst;
    treeview_lib_virfolders.selected[nodo] := true;
    treeview_lib_virfoldersClick(treeview_lib_virfolders);
  end else treeview_lib_virfoldersClick(treeview_lib_virfolders);

  set_reginteger('General.LastLibraryMode', 0);
end;

procedure Tares_frmmain.btn_lib_refreshClick(Sender: TObject);
var
  paused: boolean;
begin
  try
    if share <> nil then begin
      need_rescan := true;
      share.terminate;
      exit;
    end;
  except
  end;

  try
    paused := set_NEWtrusted_metas;

    scan_start_time := gettickcount;
    share := tthread_share.create(true);
    share.paused := paused;
    share.juststarted := false;
    share.resume;
  except
  end;

end;

procedure tares_frmmain.toggleChatPvt(Sender, aPanel: TObject);
var
  pagepanel: TCometPagePanel;
  pcanale: precord_canale_chat_visual;
  pvt: precord_pvt_chat_visual;
begin
  pagePanel := aPanel as TCometPagePanel;

  if pagePanel.ID = IDNONE then begin
    pcanale := pagePanel.FData;
    assign_chatroom_tabimg(pcanale, false);
  end else begin
    pvt := pagePanel.FData;
    pcanale := pvt^.canale;
    if pagePanel.imageindex <> 9 then pagePanel.imageindex := 9;
    if pvt^.frmTab <> nil then (pvt^.frmTab as tfrmChatTab).ResetMissed;
    if pvt^.edit_chat.CanFocus then pvt^.edit_chat.setfocus;
  end;
end;

procedure Tares_frmmain.panel_chatPanelShow(Sender, aPanel: TObject);
var
  pcanale: precord_canale_chat_visual;
  i: integer;
  pagepanel: TCometPagePanel;

begin
  pagePanel := aPanel as TCometPagePanel;

  try

    if pagePanel.panel = panel_list_channels then begin
      mainGui_togglechats(nil, true, false, nil);
      exit;
    end;

    for i := 0 to list_chatchan_visual.count - 1 do begin
      pcanale := list_chatchan_visual[i];
      if pagePanel.panel = pcanale^.containerPageview then begin
        mainGui_togglechats(pcanale, false, true, nil);
        exit;
      end;
    end;

    mainGui_togglechats(nil, false, false, pagePanel); // pvt or browse or search...hide search field

  except
  end;
end;

procedure Tares_frmmain.splitter_chatEndSplit(Sender: TObject);
var
  i: integer;
  precord_chat: precord_canale_chat_visual;
begin

  for i := 0 to list_chatchan_visual.count - 1 do begin
    precord_chat := list_chatchan_visual[i];
    if panel_chat.activepanel <> precord_chat^.containerPageview then continue;

    default_width_chat := precord_chat^.listview.width;

    if default_width_chat > 100 then begin
      set_reginteger('GUI.ChatRoomWidth', default_width_chat);
    end;

    break;
  end;
end;


procedure Tares_frmmain.splitter_libraryEndSplit(Sender: TObject);
begin
  with splitter_library do begin
    invalidate;
    left := left + xpos;
    panel6sizedefault := left;
  end;

  if panel6sizedefault > 50 then begin
    set_reginteger('GUI.FoldersWidth', panel6sizedefault);
  end;

  libraryOnResize(ares_frmmain.listview_lib.parent);
end;

procedure Tares_frmmain.btn_playlist_closeClick(Sender: TObject);
begin
  playlist_visible := false;
  blendPlaylistForm.visible := false;
end;

procedure Tares_frmmain.btn_chat_hostClick(Sender: TObject);
begin
  mainGui_host_channel_click_event;
end;

procedure tares_frmmain.painttopicpnl(sender: Tobject; Acanvas: Tcanvas; Capt: widestring; var should_continue: boolean);
var
  widestr: widestring;
  panel: TCometTopicPnl;
  CellRec: Trect;
  forecolor, backcolor, forecolor_gen, backcolor_gen: TColor;
begin
  should_continue := false;
  try
    panel := sender as TCometTopicPnl;
    widestr := capt;

    with cellrec do begin
      left := -1;
      top := 1;
      right := panel.width;
      bottom := panel.height + 1 {-2};
    end;

    with acanvas do begin
      brush.color := COLORE_PANELS_BG;
      pen.color := COLORE_PANELS_BG;
      fillrect(cellrec);
      font.name := font_chat.name;
      Font.Size := font_chat.size;
      font.color := COLORE_PANELS_FONT;
    end;

    forecolor_gen := COLORE_PANELS_FONT;
    forecolor := forecolor_gen;
    backcolor_gen := COLORE_PANELS_BG;
    backcolor := backcolor_gen;

    canvas_draw_topic(Acanvas, CellRec, imglist_emotic, ' ' + widestr, forecolor, backcolor, forecolor_gen, backcolor_gen, 1);
  except
  end;
end;



procedure tares_frmmain.treeview_list_user_channeldblclick(sender: tobject);
var
  i: integer;
  pcanale: precord_canale_chat_visual;
begin
  try
    for i := 0 to list_chatchan_visual.count - 1 do begin
      pcanale := list_chatchan_visual[i];
      if panel_chat.activepanel <> pcanale^.containerPageview then continue;
      if pcanale^.support_pvt then SendPrivateMessage1Click(nil)
      else Sendaprivatemessage1Click(nil);
      exit;
    end;
  except
  end;
end;


procedure Tares_frmmain.btn_chat_refchanlistClick(Sender: TObject);
begin
  should_send_channel_list := true;
end;

procedure Tares_frmmain.listview_chat_channelGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  Size := SizeOf(record_displayed_channel);
end;

procedure Tares_frmmain.get_data_size_user_chats(Sender: TBaseCometTree; var Size: Integer);
begin
  Size := SizeOf(record_displayed_chat_user);
end;


procedure Tares_frmmain.listview_chat_channelGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  Data: precord_displayed_channel;
begin
  Data := sender.getdata(Node);

  if not sender.selectable then begin
    if column = 0 then celltext := utf8strtowidestr(data^.name);
    exit;
  end;
  case column of
    0: celltext := utf8strtowidestr(data^.name);
    1: if node.childcount = 0 then celltext := inttostr(data^.users) else celltext := Chatlist_GetUserStatStr(node);
    2: begin
        if data^.has_colors_intopic then begin
          celltext := data^.stripped_topic;
        end else
          celltext := data^.stripped_topic;
      end else celltext := chr(32);
  end;

end;


procedure tares_frmmain.get_text_users_chats(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  Data: precord_displayed_chat_user;
begin
  Data := Sender.getdata(Node);

  case column of
    0: celltext := utf8strtowidestr(data^.nick);
    1: begin
        if data^.id < 10 then celltext := '00' + inttostr(data^.id)
        else
          if data^.id < 100 then celltext := '0' + inttostr(data^.id)
          else
            celltext := inttostr(data^.id);
      end;
    2: celltext := inttostr(data^.files);
    3: celltext := napspeed_tostring(bytesec_to_napspeed(data^.speed))
  else text := chr(32);
  end;
end;


procedure Tares_frmmain.lista_user_chat_get_imageindex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  data: precord_displayed_chat_user;
begin
  data := sender.getdata(node);
  if data^.ModLevel then begin
    if ((data^.support_files) and (data^.files > 0)) then imageindex := 14
    else imageindex := 4;
  end else begin
    if ((data^.support_files) and (data^.files > 0)) then imageindex := 1
    else imageindex := 0;
  end;
end;

procedure Tares_frmmain.listview_srcMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  formhint_hide;
end;

procedure Tares_frmmain.Joinchannel1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  datas: precord_displayed_channel;
begin
  nodo := listview_chat_channel.getfirstselected;
  if nodo = nil then exit;

  if nodo.childcount > 0 then
    nodo := nodo.firstchild;


  datas := listview_chat_channel.getdata(nodo);

  update_FAVchannel_last(nil, datas);
  helper_channellist.join_channel(datas);

end;


procedure Tares_frmmain.listview_chat_channelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  punto: tpoint;
  datao, pchan: precord_displayed_channel;
  i: integer;
  node: pcmtvnode;
begin
  if button <> mbright then exit;
  if not listview_chat_channel.selectable then exit;

  with listview_chat_channel do begin

    if not selectable then exit;

    node := getfirstselected;

    if node <> nil then begin

      if node.childcount > 0 then begin //multiple channel on same IP
        joinchannel1.Visible := false;
        AddtoFavorites1.Visible := false;
        exporthashlink5.visible := false;
        N3.visible := false;
        getcursorpos(punto);
        popup_chat_chanlist.popup(punto.x, punto.y);
        exit;
      end;

      datao := getdata(node);
      joinchannel1.Visible := true;
      exporthashlink5.visible := true;
      AddtoFavorites1.Visible := true; //TODO is already in list?
      N3.visible := true;

    end else begin
      joinchannel1.Visible := false;
      exporthashlink5.visible := false;
      AddtoFavorites1.Visible := false;
      N3.visible := false;
    end;

  end;

  getcursorpos(punto);
  popup_chat_chanlist.popup(punto.x, punto.y);
end;

procedure Tares_frmmain.Sendaprivatemessage1Click(Sender: TObject);
var
  Data: precord_displayed_chat_user;
  pcanale: precord_canale_chat_visual;
  nodo: PCmtVNode;
  ips: string;
  pnl: TCometPagePanel;
begin
  if gettickcount - last_chat_req < DELAY_BETWEEN_RECHAT_REQUEST then exit;
  last_chat_req := gettickcount;
  try

    pnl := panel_chat.Panels[panel_chat.activePage];
    if pnl.ID <> IDXChatMain then exit;

    pcanale := pnl.fdata;

    nodo := pcanale^.listview.GetFirstSelected;
    if nodo = nil then exit;
    data := pcanale^.listview.getdata(nodo);
    ips := ipint_to_dotstring(data^.ip);

    chat_with_user(ips, data^.port, data^.ip_alt, data^.ip_server, data^.port_server, data^.nick);

  except
  end;
end;

procedure Tares_frmmain.testoURLClick(Sender: TObject; const URLText: string; Button: TMouseButton);
var
  posi: integer;
begin
  posi := pos('arlnk://', lowercase(urltext));

  if posi > 0 then begin
    helper_hashlinks.add_WebLink(copy(urltext, posi + 8, length(urltext)));
    exit;
  end;

  Tnt_ShellExecuteW(0, 'open', pwidechar(widestring(urltext)), '', '', SW_SHOWNORMAL);
end;

procedure Tares_frmmain.listview_libMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nodo: PCmtVNode;
  data: precord_file_library;
  nomefile, estensione: string;
  punto: tpoint;
begin
  if listview_lib.header.height = 34 then exit;

  nodo := listview_lib.getfirstselected;
  if nodo = nil then begin
    locate1.visible := false;
    openwithexternalplayer2.visible := false;
    addtoplaylist1.visible := false;
    deletefile2.visible := false;
    shareun1.visible := false;
    openplay1.visible := false;
    n5.visible := false;
    Findmoreofthesameartist1.visible := false;
    ExportHashLink1.visible := false;
  end else begin
    data := listview_lib.getdata(nodo);
    n5.visible := true;
    openwithexternalplayer2.visible := true;
    locate1.visible := true;

    shareun1.visible := (not data^.previewing);
    DeleteFile2.visible := (not data^.previewing);
    ExportHashLink1.visible := (not data^.previewing);
    data := listview_lib.getdata(nodo);
    nomefile := data^.path;


    Artist1.visible := ((length(data^.artist) > 0) and (data^.amime = ARES_MIME_MP3));
    Genre1.visible := ((length(data^.category) > 0) and (data^.amime = ARES_MIME_MP3));
    Findmoreofthesameartist1.visible := ((Artist1.visible) or (Genre1.visible));

    estensione := lowercase(extractfileext(nomefile));
    if ((pos(estensione, PLAYABLE_AUDIO_EXT) = 0) and
      (pos(estensione, PLAYABLE_IMAGE_EXT) = 0) and
      (pos(estensione, PLAYABLE_VIDEO_EXT) = 0)) then begin
      addtoplaylist1.visible := false;
      openplay1.visible := false;
    end else begin
      addtoplaylist1.visible := true;
      openplay1.visible := true;
    end;
  end;

  if button <> mbright then exit;
  getcursorpos(punto);
  popup_library.popup(punto.x, punto.y);
end;

procedure Tares_frmmain.SelectAll1Click(Sender: TObject);
begin
  mainGui_chatselectall;
end;

procedure Tares_frmmain.CopytoClipboard1Click(Sender: TObject);
begin
  mainGui_copytoclipboard;
end;

procedure Tares_frmmain.Openinnotepad1Click(Sender: TObject);
begin
  mainGui_openinnotepad;
end;

procedure Tares_frmmain.Disconnect2Click(Sender: TObject);
var
  Data: precord_displayed_chat_user;
  pcanale: precord_canale_chat_visual;
  nodo: PCmtVNode;
  pnl: TCometPagePanel;
begin
  try

    pnl := ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
    pcanale := pnl.fdata;

    if not pcanale^.ModLevel then exit;
    nodo := pcanale^.listview.getfirstselected;
    if nodo = nil then exit;
    data := pcanale^.listview.getdata(nodo);
    pcanale^.out_text.add('/kill ' + data^.nick);

  except
  end;
end;

procedure Tares_frmmain.listview_srcFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_search_result(sender, node);
  if node = previous_hint_node then formhint_hide;
end;

procedure Tares_frmmain.result_chat_channelfreenode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_search_result_chat(sender, node);
end;

procedure Tares_frmmain.listview_libFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_file_library(sender, node);
  if node = previous_hint_node then formhint_hide;
end;

procedure Tares_frmmain.treeview_downloadfreenode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_displayed_download(sender, node);
  if node = previous_hint_node then formhint_hide;
end;

procedure Tares_frmmain.treeview_uploadfreenode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_displayed_treeviewupload(sender, node);
  if node = previous_hint_node then formhint_hide;
end;

procedure Tares_frmmain.treeview_list_user_channelfreenode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_user_channel(sender, node);
end;

procedure Tares_frmmain.listviewchatPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
begin
 {if (vsSelected in node.States) then TargetCanvas.Font.color:=clhighlighttext
 else targetCanvas.font.color:=COLORE_CHAT_FONT;}
end;

procedure Tares_frmmain.listview_chat_channelFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_chatchannel(sender, node);
end;

procedure Tares_frmmain.treeview_lib_virfoldersClick(Sender: TObject);
var
  level: integer;
  node: PCmtVNode;
begin

  details_library_hideall;

  node := treeview_lib_virfolders.getfirstselected;
  if node = nil then exit;

  try
    level := treeview_lib_virfolders.getnodelevel(node);

    if level = 0 then begin

      if hashing then begin
        libraryOnResize(treeview_lib_regfolders.parent);
        exit;
      end;
   // listview_lib.color:=COLORE_LISTVIEWS_BG;
      stato_header_library := helper_visual_headers.header_library_show('Library', 'Library', listview_lib, GetLangStringA(STR_YOUR_LIBRARY), CAT_YOUR_LIBRARY, CAT_NOGROUP);
      apri_general_library_virtual_view(true, lista_shared, listview_lib, imagelist_lib_max);
      libraryOnResize(treeview_lib_regfolders.parent);

    end else begin

      stato_header_library := apri_categoria_library('Library', 'Library', treeview_lib_virfolders, listview_lib, lista_shared, level, node);
      if listview_lib.Header.sortcolumn <> -1 then listview_lib.Sort(nil, listview_lib.Header.sortcolumn, listview_lib.Header.sortdirection);
      if ((listview_lib.rootnodecount > 0) and
        (btn_lib_toggle_Details.down) and
        (not hashing)) then begin
        node := listview_lib.getfirst;
        listview_lib.selected[node] := true;
        listview_libclick(nil);
      end;
      libraryOnResize(treeview_lib_regfolders.parent);
    end;


  except
  end;
end;

procedure Tares_frmmain.treeview_lib_regfoldersClick(Sender: TObject);
var
  i: integer;
  pfile: precord_file_library;
  data, data_folder: ^record_cartella_share;
  nodo, nodo_child, nodo_file: PCmtVNode;
  pfile_folder: precord_file_library;
begin

  details_library_hideall;

  nodo := treeview_lib_regfolders.getfirstselected;
  if nodo = nil then exit;

  try

    details_library_toggle(false);

    if treeview_lib_regfolders.getnodelevel(nodo) = 0 then begin

      if hashing then begin
        libraryOnResize(treeview_lib_regfolders.parent);
        exit;
      end;

      stato_header_library := header_library_show('Library', 'Library', listview_lib, GetLangStringA(STR_YOUR_LIBRARY), CAT_YOUR_LIBRARY, CAT_NOGROUP);
      apri_general_library_folder_view(true, lista_shared, listview_lib, imagelist_lib_max, treeview_lib_regfolders);
      libraryOnResize(treeview_lib_regfolders.parent);
      exit;
    end;




    with listview_lib do begin
      defaultnodeheight := 18;
      images := img_mime_small;
      canbgcolor := true;
      with header do begin
        height := 21;
        autosizeindex := 10;
        options := [hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoRestrictDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible];
        columns[0].options := [coAllowClick, coEnabled, coDraggable, coResizable, coShowDropMark, coVisible];
      end;
    end;

    libraryOnResize(treeview_lib_regfolders.parent);
    with listview_lib do begin
      if rootnodecount > 0 then begin
        BeginUpdate;
        Clear;
      end;
    end;
    stato_header_library := header_library_show('Library', 'Library', listview_lib, GetLangStringA(STR_YOUR_LIBRARY), CAT_ALL, CAT_NOGROUP);

    data := treeview_lib_regfolders.getdata(nodo);

    nodo_child := treeview_lib_regfolders.getfirstchild(nodo);
    while (nodo_child <> nil) do begin
      data_folder := treeview_lib_regfolders.getdata(nodo_child);
      nodo_file := listview_lib.addchild(nil);
      pfile_folder := listview_lib.getdata(nodo_file);
      with pfile_folder^ do begin
        mediatype := GetLangStringA(STR_FOLDER);
        imageindex := 0;
        fsize := 0;
        title := widestrtoutf8str(extract_fnameW(data_folder^.path));
        language := widestrtoutf8str(data_folder^.path);
        artist := GetLangStringA(STR_FOLDER) + ': ' + widestrtoutf8str(extract_fnameW(data_folder^.path));
        category := inttostr(data_folder^.items) + ' ' + GetLangStringA(STR_FOUND);
        album := inttostr(data_folder^.items_shared) + ' ' + GetLangStringA(STR_SHARED);
        year := GetLangStringA(STR_LOCATION) + ': ' + widestrtoutf8str(extract_fpathW(data_folder^.path));
      end;
      nodo_child := treeview_lib_regfolders.getnextsibling(nodo_child);
    end;

    for i := 0 to lista_shared.count - 1 do begin
      pfile := lista_shared[i];
      if pfile^.folder_id = data^.id then
        library_file_show(listview_lib, pfile);
    end;

    with listview_lib do begin
      if Header.sortcolumn <> -1 then Sort(nil, Header.sortcolumn, Header.sortdirection);
      endupdate;
    end;

  except
  end;

end;

procedure Tares_frmmain.listview4SelectionChange(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  listview_libclick(nil);
end;

procedure Tares_frmmain.treeview_lib_virfoldersKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ((key = VK_UP) or (key = VK_DOWN)) then treeview_lib_virfoldersclick(nil);
end;

procedure Tares_frmmain.treeview_lib_regfoldersKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ((key = VK_UP) or (key = VK_DOWN)) then treeview_lib_regfoldersclick(nil);
end;

procedure Tares_frmmain.edit_lib_searchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i, h: integer;
  ffile: precord_file_library;
  search_str: string;
  split_string: tmystringlist;
  filestr: string;
  found: boolean;
begin


  try
    if length(edit_lib_search.text) < 1 then begin
      if btn_lib_virtual_view.down then treeview_lib_virfoldersclick(nil)
      else treeview_lib_regfoldersclick(nil);
      edit_lib_search.glyphindex := 12;
      edit_lib_search.text := '';
      exit;
    end;

    edit_lib_search.glyphIndex := 11;

    with listview_lib do begin
      canbgcolor := true;
      defaultnodeheight := 18;
      images := ares_FrmMain.img_mime_small;
      with header do begin
        autosizeindex := 10;
        options := [hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoRestrictDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible];
        columns[0].options := [coAllowClick, coEnabled, coDraggable, coResizable, coShowDropMark, coVisible];
        height := 21;
      end;
      if rootnodecount > 0 then begin
        BeginUpdate;
        Clear;
      end;
    end;

    stato_header_library := header_library_show('Library', 'Library', listview_lib, GetLangStringA(STR_YOUR_LIBRARY), CAT_ALL, CAT_NOGROUP);
  except
  end;


  search_str := lowercase(widestrtoutf8str(edit_lib_search.text));
  split_string := tmystringlist.create;
  try
    SplitString(search_str, split_string);

    for i := 0 to lista_shared.count - 1 do begin
      try
        ffile := lista_shared[i];
        filestr := lowercase(ffile^.title + chr(32) +
          ffile^.artist + chr(32) +
          ffile^.album);

        found := true;
        for h := 0 to split_string.count - 1 do begin
          if pos(split_string.strings[h], filestr) = 0 then begin
            found := false;
            break;
          end;
        end;
        if found then library_file_show(listview_lib, ffile);

      except
      end;
    end;

    if listview_lib.Header.sortcolumn >= 0 then
      listview_lib.Sort(nil, listview_lib.Header.sortcolumn, listview_lib.Header.sortdirection);

    listview_lib.endupdate;
    listview_lib.color := COLORE_LISTVIEWS_BG;

  except
  end;
  split_string.clear;
  split_string.free;
end;

procedure Tares_frmmain.listview_srcPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
var
  data: precorD_search_result;
begin
  if not sender.selectable then exit;

  data := sender.getdata(node);

  if data^.bold_font then TargetCanvas.Font.style := [fsBold]
  else TargetCanvas.Font.style := [];

  if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext else begin
    if data^.already_in_lib then TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT1 {clgray} else
      if data^.being_downloaded then TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT2 {cl$00FFBF95}
      else TargetCanvas.font.color := COLORE_LISTVIEWS_FONT;
  end;


end;

procedure Tares_frmmain.result_chat_channelpainttext(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
var
  data: precord_file_result_chat;
begin
  if not sender.selectable then exit;

  data := sender.getdata(node);
  if data^.already_in_lib then TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT1 {clgray} else
    if data^.being_downloaded then TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT2 {_$00FFBF95};

  if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext;

end;

procedure Tares_frmmain.btn_tran_locateClick(Sender: TObject);
var
  nodo: PCmtVNode;
begin
  nodo := treeview_download.GetFirstselected;
  if nodo = nil then begin
    nodo := treeview_upload.GetFirstselected;
    if nodo = nil then begin
      open_file_external(myshared_folder);
      exit;
    end else begin
      if btn_tran_toggle_queup.caption = GetLangStringA(STR_SHOW_QUEUE) then LocateUpload3Click(nil)
      else MenuItem10Click(nil);
    end;
  end else Locate2Click(nil);
end;

procedure Tares_frmmain.PauseallUnpauseAll1Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
begin
  node := treeview_download.GetFirst;
  while (node <> nil) do begin
    dataNode := treeview_download.getdata(node);

    case dataNode^.m_type of

      dnt_download: begin
          DnData := dataNode^.data;
          DnData^.change_paused := true;
        end;

      dnt_bittorrentMain: begin
          BtData := dataNode^.data;
          if BtData^.state <> dlCancelled then
            if BtData^.state <> dlSeeding then BtData^.want_paused := true;
        end;

    end;

    node := treeview_download.GetNextsibling(node);
  end;
end;

procedure Tares_frmmain.Play3Click(Sender: TObject);
var
  nodo: PCmtVNode;
  data: precord_search_result;
  i, hi: integer;
  pfile: precord_file_library;
  src: precord_panel_search;
begin

  for hi := 0 to src_panel_list.count - 1 do begin
    src := src_panel_list[hi];
    if src^.containerPanel <> pagesrc.activepanel then continue;

    nodo := src^.listview.getfirstselected;
    if nodo = nil then exit;

    if src^.listview.GetNodeLevel(nodo) > 0 then nodo := nodo.parent;
    data := src^.listview.getdata(nodo);

    for i := 0 to lista_shared.count - 1 do begin
      pfile := lista_shared[i];

      if pfile^.crcsha1 = data^.crcsha1 then
        if pfile^.hash_sha1 = data^.hash_sha1 then begin
          player_playnew(utf8strtowidestr(pfile^.path));
          break;
        end;

    end;
    break;

  end;


end;

procedure Tares_frmmain.hash_pri_trxChanged(Sender: TObject);
begin
  set_reginteger(chr(72) + chr(97) + chr(115) + chr(104) + chr(105) + chr(110) + chr(103) + chr(46) + chr(80) + chr(114) + chr(105) + chr(111) + chr(114) + chr(105) + chr(116) + chr(121) {'Hashing.Priority'}, hash_pri_trx.Max - hash_pri_trx.position);
  hash_throttle := hash_pri_trx.Max - hash_pri_trx.position;
  hash_update_GUIpry;
end;

procedure Tares_frmmain.Ban1Click(Sender: TObject);
begin
  chatroom_trigger_GUIban;
end;

procedure Tares_frmmain.Unban1Click(Sender: TObject);
begin
  chatroom_trigger_GUIunban;
end;

procedure Tares_frmmain.IgnoreUnignore1Click(Sender: TObject);
begin
  chatroom_trigger_ignore;
end;

procedure Tares_frmmain.Muzzle1Click(Sender: TObject);
begin
  chatroom_trigger_muzzle;
end;

procedure Tares_frmmain.UnMuzzle1Click(Sender: TObject);
begin
  chatroom_trigger_unmuzzle;
end;

procedure Tares_frmmain.treeview_downloadHintStart(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  if (sender as tcomettree).rootnodecount = 0 then exit;
  if not (sender as tcomettree).selectable then exit;
  if check_bounds_hint then mainGui_hintTimer((sender as tcomettree), node);
end;

procedure Tares_frmmain.treeview_downloadHintStop(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  formhint_hide;
end;

procedure tares_frmmain.trigger_sendedit_chat(edit_chat: ttntedit);
var
  i, h: integer;
  pcanale: precord_canale_chat_visual;
  str, str_comando: string;
  pvt_chat: precord_pvt_chat_visual;
begin
  try

    if edit_chat.text = '' then exit;

////////////////////////// input history 2005-09-26
    if typed_lines_chat = nil then typed_lines_chat := tmystringlist.create;
    if typed_lines_chat.count > 0 then begin
      if typed_lines_chat.strings[typed_lines_chat.count - 1] <> widestrtoutf8str(edit_chat.text) then
        typed_lines_chat.add(widestrtoutf8str(edit_chat.text));
    end else typed_lines_chat.add(widestrtoutf8str(edit_chat.text));
    typed_lines_chat_index := typed_lines_chat.count;
    if typed_lines_chat.count >= MAX_HISTORY_TYPEDCHATLINES then typed_lines_chat.delete(0);
//////////////////////////////////

    pcanale := nil;
    pvt_chat := nil;
    str_comando := '';

    for i := 0 to list_chatchan_visual.count - 1 do begin
      pcanale := list_chatchan_visual[i];
      if pcanale^.edit_chat = edit_chat then break;

      if pcanale^.lista_pvt = nil then continue;

      for h := 0 to pcanale^.lista_pvt.count - 1 do begin
        pvt_chat := pcanale^.lista_pvt[h];
        if edit_chat <> pvt_chat.edit_chat then continue;
        str_comando := '/pvt ' + pvt_chat^.nickname + CHRNULL;
        break;
      end;
      if str_comando <> '' then break;
    end;


    if pcanale = nil then begin
      exit;
    end;


    str := widestrtoutf8str(convert_command_color_str(edit_chat.text));
    if length(str) > MAX_CHAT_LINE_LEN then delete(str, MAX_CHAT_LINE_LEN, length(str));

    if str_comando <> '' then begin
      if pvt_chat <> nil then begin
        if length(mynick) < 4 then helper_chatroom_gui.out_text_memo(pvt_chat^.memo, COLORE_CHATPVTNICK, '', GetLangStringW(STR_YOU) + ':')
        else helper_chatroom_gui.out_text_memo(pvt_chat^.memo, COLORE_CHATPVTNICK, '', utf8strtowidestr(mynick) + ':');
        helper_chatroom_gui.out_text_memo(pvt_chat^.memo, COLORE_CHAT_FONT, '', '   ' + utf8strtowidestr(str));
      end;
    end;

    str := str_comando + str;

    if ((pos('/', str) = 1) or (pos('!', str) = 1) or (pos('>', str) = 1)) then pcanale^.out_text.add(str)
    else pcanale^.out_text.add('/public ' + str);


    edit_chat.text := '';


  except
  end;
end;

procedure Tares_frmmain.edit_chatKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  edit_chat: ttntedit;
begin
  if typed_lines_chat = nil then exit;

  edit_chat := (sender as ttntedit);


  if key = 40 then begin //arrow down

    inc(typed_lines_chat_index);
    if typed_lines_chat_index >= typed_lines_chat.count then begin
      typed_lines_chat_index := typed_lines_chat.count;
      edit_chat.text := '';
    end else edit_chat.text := utf8strtowidestr(typed_lines_chat.strings[typed_lines_chat_index]);

    edit_chat.selstart := length(edit_chat.text);
    edit_chat.sellength := 0;
  end else
    if key = 38 then begin // arrow up

      if typed_lines_chat_index > 0 then dec(typed_lines_chat_index);

      edit_chat.text := utf8strtowidestr(typed_lines_chat.strings[typed_lines_chat_index]);

      edit_chat.selstart := length(edit_chat.text);
      edit_chat.sellength := 0;
    end;

end;

procedure Tares_frmmain.edit_chatKeyPress(Sender: TObject; var Key: Char);
var
  edit_chat: ttntedit;
begin
  edit_chat := (sender as ttntedit);


  case integer(key) of
    13: begin
        key := char(vk_cancel);
        trigger_sendedit_chat(edit_chat);
      end;

    2: begin
        edit_chat.text := edit_chat.text + chr(2);
        key := char(vk_cancel);
        edit_chat.SelStart := length(edit_chat.text);
      end;
  end;

end;

procedure Tares_frmmain.edit_caption_chatMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (sender as TjvRichEdit).ScrollBy(0, -5000);
  (sender as TjvRichEdit).selstart := 0;
end;

procedure Tares_frmmain.edit_caption_chatKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  (sender as TjvRichEdit).ScrollBy(0, -5000);
  (sender as TjvRichEdit).selstart := 0;
end;



procedure Tares_frmmain.Originalsize1Click(Sender: TObject);
begin
  if not isvideoplaying then exit;
  if fullscreen2.checked then Fullscreen2Click(nil);

  originalsize1.checked := not originalsize1.checked;

  if not originalsize1.checked then begin
    fittoscreen1.checked := true;
  end else fittoscreen1.checked := false;
  resize_video_window;
end;



procedure Tares_frmmain.edit_src_filterKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i, hi, h: integer;
  resu: precord_search_result;
  search_str: string;
  split_string: tmystringlist;
  filestr: string;
  found: boolean;
  src: precord_panel_search;
begin
  try



    for hi := 0 to src_panel_list.count - 1 do begin
      src := src_panel_list[hi];
      if src^.containerPanel <> pagesrc.activepanel then continue;


      if length(edit_src_filter.text) < 1 then begin
        src^.listview.BeginUpdate;
        src^.listview.Clear;
        for i := 0 to src^.backup_results.count - 1 do begin
          resu := src^.backup_results[i];
          add_search_result(src^.listview, resu);
        end;
        if src^.listview.Header.sortcolumn >= 0 then src^.listview.Sort(nil, src^.listview.header.sortcolumn, src^.listview.header.sortdirection);
        src^.listview.endupdate;
        edit_src_filter.glyphindex := 12;
        exit;
      end;

      edit_src_filter.glyphIndex := 11;
      split_string := tmystringlist.create;


      src^.listview.BeginUpdate;
      src^.listview.Clear;

      search_str := lowercase(widestrtoutf8str(edit_src_filter.text));
      SplitString(search_str, split_string);

      for i := 0 to src^.backup_results.count - 1 do begin
        try
          resu := src^.backup_results[i];
          with resu^ do filestr := lowercase(title + chr(32) +
              artist + chr(32) +
              album + chr(32) +
              category + chr(32) +
              language);


          found := true;
          for h := 0 to split_string.count - 1 do begin
            if pos(split_string.strings[h], filestr) = 0 then begin
              found := false;
              break;
            end;
          end;

          if found then add_search_result(src^.listview, resu);

        except
        end;
      end;

      if src^.listview.Header.sortcolumn >= 0 then src^.listview.Sort(nil, src^.listview.header.sortcolumn, src^.listview.header.sortdirection);
      src^.listview.endupdate;


      split_string.clear;
      split_string.free;

      break;
    end;

  except
  end;
end;

procedure Tares_frmmain.listview_libKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = vk_delete then deleteClick(nil) else
    if key = VK_RETURN then OpenPlay1Click(nil);
end;

procedure Tares_frmmain.ClearIdle2Click(Sender: TObject);
var
  node, next: PCmtVNode;
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
begin
  node := treeview_download.GetFirst;
  while (node <> nil) do begin

    dataNode := treeview_download.getdata(node);

    case dataNode^.m_type of

      dnt_bittorrentMain: begin
          BtData := dataNode^.data;
          if vars_global.previous_hint_node = node then formhint_hide;

          if BtData^.handle_obj = INVALID_HANDLE_VALUE then begin //already cancelled, just clear node
            next := treeview_download.GetNextsibling(node);
            treeview_download.deletenode(node);
            node := next;
            continue;
          end else begin
            if BtData^.state = dlSeeding then BtData^.want_cleared := true; // let thread_bittorrent know it's time to stop seeding
          end;
          node := treeview_download.GetNextsibling(node);
          continue;
        end;

      dnt_download: begin
          DnData := dataNode^.data;
          if helpeR_download_misc.isDownloadTerminated(DnData) then begin
            if vars_global.previous_hint_node = node then formhint_hide;
            next := treeview_download.GetNextsibling(node);
            treeview_download.deletenode(node);
            node := next;
            continue;
          end;

        end;
    end;

    node := treeview_download.GetNextsibling(node);
  end;

end;

procedure Tares_frmmain.ClearIdle1Click(Sender: TObject);
var
  node, next: PCmtVNode;
  dataNode: precord_data_node;
  UpData: precord_displayed_upload;
  BtData: precord_displayed_bittorrentTransfer;
begin
  if sender <> nil then begin
    clearIdle1.checked := not clearIdle1.checked;
    helper_registry.set_reginteger('Upload.AutoClearIdle', integer(clearIdle1.checked));
  end;

  node := treeview_upload.GetFirst;
  while (node <> nil) do begin

    dataNode := treeview_upload.getdata(node);

    if dataNode^.m_type = dnt_BitTorrentMain then begin //clear bittorrent uploads
      BtData := dataNode^.data;
      if BtData.handle_obj = INVALID_HANDLE_VALUE then begin
        if vars_global.previous_hint_node = node then formhint_hide;
        next := treeview_upload.GetNextSibling(node);
        treeview_upload.deletenode(node, true);
        node := next;
      end else node := treeview_upload.GetNextSibling(node);
      continue;
    end;

    if dataNode^.m_type <> dnt_upload then begin
      node := treeview_upload.GetNextSibling(node);
      continue;
    end;


    UpData := dataNode^.data;

    if UpData^.completed then begin
      if vars_global.previous_hint_node = node then formhint_hide;

      next := treeview_upload.GetNextSibling(node);
      treeview_upload.deletenode(node, true);
      node := next;
      continue;
    end;

    node := treeview_upload.GetNextSibling(node);
  end;

end;

procedure Tares_frmmain.Artist1Click(Sender: TObject);
var
  data: precord_file_library;
  nodo: PCmtVNode;
begin
  try
    nodo := listview_lib.getfirstselected;
    if nodo = nil then exit;

    data := listview_lib.getdata(nodo);
    searchpanel_setfindmore_art(data^.artist);

    ares_frmmain.tabs_pageview.activepage := IDTAB_SEARCH;

  except
  end;
end;

procedure Tares_frmmain.Genre1Click(Sender: TObject);
var
  data: precord_file_library;
  nodo: PCmtVNode;
begin
  try
    nodo := listview_lib.getfirstselected;
    if nodo = nil then exit;

    data := listview_lib.getdata(nodo);
    searchpanel_setfindmore_gen(data^.category);

    ares_frmmain.tabs_pageview.activepage := IDTAB_SEARCH;

  except
  end;
end;

procedure Tares_frmmain.Artist2Click(Sender: TObject);
var
  data: precord_search_result;
  nodo: PCmtVNode;
  src: precord_panel_search;
  i: integer;
begin
  try

    for i := 0 to src_panel_list.count - 1 do begin
      src := src_panel_list[i];
      if src^.containerPanel <> pagesrc.activepanel then continue;
      pagesrc.activepage := 0;

      nodo := src^.listview.getfirstselected;
      if nodo = nil then exit;

      data := src^.listview.getdata(nodo);
      searchpanel_setfindmore_art(data^.artist);

      Btn_start_searchclick(nil);
      break;
    end;

  except
  end;
end;



procedure Tares_frmmain.Genre2Click(Sender: TObject);
var
  data: precord_search_result;
  nodo: PCmtVNode;
  src: precord_panel_search;
  i: integer;
begin
  try

    for i := 0 to src_panel_list.count - 1 do begin
      src := src_panel_list[i];
      if src^.containerPanel <> pagesrc.activepanel then continue;
      pagesrc.activepage := 0;

      nodo := src^.listview.getfirstselected;
      if nodo = nil then exit;

      data := src^.listview.getdata(nodo);
      searchpanel_setfindmore_gen(data^.category);

      Btn_start_searchclick(nil);

      break;
    end;

  except
  end;
end;

procedure Tares_frmmain.Artist3Click(Sender: TObject);
var
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
  node: PCmtVNode;
begin
  try
    node := treeview_download.getfirstselected;
    if node = nil then exit;

    if treeview_download.getnodelevel(node) = 1 then node := node.Parent;
    dataNode := treeview_download.getdata(node);

    if dataNode^.m_type <> dnt_download then
      if dataNode^.m_type <> dnt_partialDownload then exit;

    DnData := dataNode^.data;
    searchpanel_setfindmore_art(DnData^.artist);
    ares_frmmain.tabs_pageview.activepage := IDTAB_SEARCH;


  except
  end;
end;

procedure tares_frmmain.genre3click(sender: tobject);
var
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
  node: PCmtVNode;
begin
  try
    node := treeview_download.getfirstselected;
    if node = nil then exit;

    if treeview_download.getnodelevel(node) = 1 then node := node.Parent;
    dataNode := treeview_download.getdata(node);
    if dataNode^.m_type <> dnt_download then
      if dataNode^.m_type <> dnt_partialDownload then exit;

    DnData := dataNode^.data;
    searchpanel_setfindmore_gen(DnData^.category);
    ares_frmmain.tabs_pageview.activepage := IDTAB_SEARCH;


  except
  end;
end;



procedure Tares_frmmain.Openexternal1Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  DnData: precord_displayed_download;
//BtData:precord_displayed_bittorrentTransfer;
begin
  node := treeview_download.GetFirstSelected;
  if node = nil then exit;
  if treeview_download.getnodelevel(node) = 1 then node := node.Parent;
  dataNode := treeview_download.getdata(node);

  case dataNode^.m_type of

    dnt_bittorrentMain, dnt_bittorrentSource: Locate2Click(nil);

    dnt_download,
      dnt_partialDownload: begin
        DnData := dataNode^.data;
        open_file_external(DnData^.filename);
      end;

  end;

end;

procedure Tares_frmmain.OpenExternal2Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  UpData: precord_displayed_upload;
  DnData: precord_displayed_download;
  BtData: precord_displayed_bittorrentTransfer;
begin
  node := treeview_upload.GetFirstSelected;
  if node = nil then exit;

  datanode := treeview_upload.getdata(node);
  case dataNode^.m_type of
    dnt_bittorrentMain: begin
        BtData := dataNOde^.data;
        locate_containing_folder(BtData^.path);
      end;
    dnt_bittorrentSource: begin
        node := node.parent;
        dataNode := treeview_upload.getData(node);
        BtData := dataNode^.data;
        locate_containing_folder(BtData^.path);
      end;
    dnt_upload: begin
        UpData := dataNode^.data;
        open_file_external(UpData^.nomefile);
      end;
    dnt_partialUpload: begin
        DnData := dataNode^.data;
        open_file_external(DnData^.filename);
      end;
  end;
end;

procedure Tares_frmmain.browsebtnClick(Sender: TObject);
begin
//
end;

procedure Tares_frmmain.btn_tran_toggle_queupClick(Sender: TObject);
begin
  if btn_tran_toggle_queup.caption = GetLangStringA(STR_SHOW_QUEUE) then begin
    btn_tran_toggle_queup.caption := GetLangStringA(STR_SHOW_UPLOAD);
    btn_tran_toggle_queup.hint := GetLangStringA(STR_SHOW_UPLOAD_HINT);
    treeview_queue.clear;
    treeview_queue.visible := true;
    treeview_upload.visible := false;
  end else begin
    btn_tran_toggle_queup.caption := GetLangStringA(STR_SHOW_QUEUE);
    btn_tran_toggle_queup.hint := GetLangStringA(STR_HINT_SHOW_QUEUE);
    treeview_upload.visible := true;
    treeview_queue.clear;
    treeview_queue.visible := false;
  end;

  btns_transferResize(btns_transfer);
end;

procedure Tares_frmmain.treeview_queuefreenode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_displayed_queued(sender, node);
  if node = previous_hint_node then formhint_hide;
end;

procedure Tares_frmmain.treeview_queueGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  Size := SizeOf(record_queued);
end;

procedure Tares_frmmain.treeview_queueGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  Data: precord_queued;
begin
  Data := sender.getdata(Node);

  case column of
    1: CellText := extract_fnameW(utf8strtowidestr(data^.nomefile));
    0: CellText := utf8strtowidestr(data^.user);
    2: begin
        if data^.size < 4096 then CellText := format_currency(data^.size)
        else CellText := format_currency(data^.size div 1024) + STR_KB + ' (' + format_currency(data^.size) + chr(32) + STR_BYTES + chr(41) {')'};
      end else CellText := chr(32);
  end;
end;

procedure Tares_frmmain.treeview_queueMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  punto: tpoint;
begin

  if button <> mbright then exit;
  if treeview_queue.getfirstselected = nil then exit;

  getcursorpos(punto);
  popup_queue.popup(punto.x, punto.y);
end;

procedure Tares_frmmain.Blockhost1Click(Sender: TObject);
var
  node: PCmtVNode;
  data, datacomp: precord_queued;
  i: integer;
begin

  node := treeview_queue.getfirstselected;
  if node = nil then exit;
  data := treeview_queue.getdata(node);
  data^.banned := true;

  i := 0;
  repeat
    if i = 0 then node := treeview_queue.getfirst
    else node := treeview_queue.getnextsibling(node);
    if node = nil then break;
    inc(i);
    datacomp := treeview_queue.getdata(node);
    if ((datacomp^.ip = data^.ip) and (datacomp^.port = data^.port)) then datacomp^.banned := true;
  until (not true);

end;

procedure Tares_frmmain.Chatwithuser1Click(Sender: TObject);
var
  node: PCmtVNode;
  data: precord_queued;
begin
  try
    if gettickcount - last_chat_req < DELAY_BETWEEN_RECHAT_REQUEST then exit;
    last_chat_req := gettickcount;

    node := treeview_queue.getfirstselected;
    if node = nil then exit;
    data := treeview_queue.getdata(node);

    if data^.port = 0 then exit;

    chat_with_user(ipint_to_dotstring(data^.ip),
      data^.port,
      data^.ip_alt,
      data^.server_ip,
      data^.server_port,
      data^.user);

  except
  end;
end;

procedure Tares_frmmain.treeview_queueGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
begin
  ImageIndex := 8;
end;

procedure Tares_frmmain.treeview_queueMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nodo: PCmtVNode;
begin

  try
    formhint_hide;
    repeat
      nodo := treeview_download.GetFirstSelected;
      if nodo = nil then break;
      treeview_download.Selected[nodo] := false;
    until (not true);

    repeat
      nodo := treeview_upload.GetFirstSelected;
      if nodo = nil then break;
      treeview_upload.Selected[nodo] := false;
    until (not true);

  except
  end;
end;

procedure Tares_frmmain.treeview_queueHintStop(Sender: TBaseCometTree);
begin
//hide_formhint;
end;

procedure Tares_frmmain.Connect1DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
//
end;

procedure Tares_frmmain.treeview_lib_virfoldersGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  size := sizeof(ares_types.record_string);
end;

procedure Tares_frmmain.treeview_lib_regfoldersFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_regular_browse_folder(sender, node);
end;

procedure Tares_frmmain.treeview_lib_regfoldersGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  size := sizeof(ares_types.record_cartella_share);
end;

procedure Tares_frmmain.treeview_lib_regfoldersGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
begin
  if not (vsSelected in node.states) then ImageIndex := 0
  else ImageIndex := 1;
end;

procedure Tares_frmmain.treeview_lib_virfoldersGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
begin
  if not (vsSelected in node.states) then ImageIndex := 0
  else ImageIndex := 1;
end;

procedure Tares_frmmain.treeview_lib_virfoldersGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  data: ares_types.precord_string;
begin
  Data := sender.getdata(Node);
  if data^.counter = 0 then CellText := utf8strtowidestr(data^.str)
  else CellText := utf8strtowidestr(data^.str) + ' (' +
    inttostr(data^.counter) + ')';
end;

procedure Tares_frmmain.treeview_lib_regfoldersGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  data: ares_types.precord_cartella_share;
  str_of_shared: string;
begin
  Data := sender.getdata(Node);

  if sender.getnodelevel(node) > 0 then begin
    if data^.items > 0 then begin
      if sender = treeview_lib_regfolders then str_of_shared := inttostr(data^.items_shared) + '/' else str_of_shared := '';
      celltext := extract_fnameW(data^.path) + ' (' + str_of_shared + inttostr(data^.items) + ')';
    end else celltext := extract_fnameW(data^.path);
  end else CellText := data^.path;

end;

procedure Tares_frmmain.treeview_lib_regfoldersCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
    Data2: precord_cartella_share;
begin
  Data1 := Sender.getdata(Node1);
  Data2 := Sender.getdata(Node2);
  if column = 0 then result := CompareText(extractfilename(data1^.path_utf8), extractfilename(data2^.path_utf8));
end;

procedure Tares_frmmain.listview_playlistGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  size := sizeof(ares_types.record_file_playlist);
end;

procedure Tares_frmmain.get_size_result_chats(Sender: TBaseCometTree; var Size: Integer);
begin
  size := sizeof(ares_types.record_file_result_chat);
end;

procedure Tares_frmmain.listview_playlistFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_file_playlist(sender, node);
end;

procedure Tares_frmmain.listview_playlistGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  data: ares_types.precord_file_playlist;
begin
  data := sender.getdata(node);

  case column of
    -1, 0: celltext := utf8strtowidestr(data^.displayName);
    1: celltext := format_time(data^.length);
  end;

end;

procedure Tares_frmmain.listview_playlistCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  data1, data2: ares_types.precord_file_playlist;
begin
  if shufflying_playlist then begin
    result := 50 - random(100);
    exit;
  end;

  if column < 0 then exit;
  data1 := sender.getdata(node1);
  data2 := sender.getdata(node2);

  case column of
    0: result := comparetext(data1^.displayName, data2^.displayName);
    1: result := data1^.length - data2^.length;
  end;

end;

procedure Tares_frmmain.listview_playlistGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  data: ares_types.precord_file_playlist;
begin

  Data := sender.getdata(node);
  if data^.amime = ARES_MIME_VIDEO then ImageIndex := 4
  else ImageIndex := 3;

end;

procedure Tares_frmmain.playlist_RemoveAll1Click(Sender: TObject);
begin
  listview_playlist.clear;
end;

procedure Tares_frmmain.playlist_Removeselected1Click(Sender: TObject);
var
  nodo: PCmtVNode;
begin

  repeat
    nodo := listview_playlist.getfirstselected;
    if nodo = nil then exit;
    listview_playlist.DeleteNode(nodo);
  until (not true);

end;

procedure Tares_frmmain.playlist_openextClick(Sender: TObject);
var
  nodo: PCmtVNode;
  data: ares_types.precord_file_playlist;
begin
  nodo := listview_playlist.getfirstselected;
  if nodo = nil then exit;
  data := listview_playlist.getdata(nodo);
  open_file_external(data^.filename);
end;


procedure Tares_frmmain.playlist_LocateClick(Sender: TObject);
var
  nodo: PCmtVNode;
  data: ares_types.precord_file_playlist;
begin
  nodo := listview_playlist.getfirstselected;
  if nodo = nil then exit;
  data := listview_playlist.getdata(nodo);
  locate_containing_folder(data^.filename);
end;


procedure Tares_frmmain.playlist_Randomplay1Click(Sender: TObject);
begin
  playlist_randomplay1.checked := not playlist_randomplay1.checked;
  set_reginteger('Playlist.Shuffle', integer(playlist_randomplay1.checked));
end;

procedure Tares_frmmain.playlist_Continuosplay1Click(Sender: TObject);
begin
  playlist_continuosplay1.checked := not playlist_continuosplay1.checked;
  set_reginteger('Playlist.Repeat', integer(playlist_continuosplay1.checked));
end;

procedure Tares_frmmain.playlist_AlphasortascClick(Sender: TObject);
begin
  listview_playlist.Sort(nil, 0, sdAscending);
end;

procedure Tares_frmmain.playlist_AlphasortdescClick(Sender: TObject);
begin
  listview_playlist.Sort(nil, 0, sdDescending);
end;


procedure Tares_frmmain.listview_playlistDblClick(Sender: TObject);
var
  nodo: PCmtVNode;
  data: ares_types.precord_file_playlist;
begin
  nodo := listview_playlist.getfirstselected;
  if nodo = nil then exit;
  data := listview_playlist.getdata(nodo);
  player_playnew(utf8strtowidestr(data^.filename));
end;

procedure Tares_frmmain.listview_playlistMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  popup_playlist.autopopup := true;
end;

procedure Tares_frmmain.listview_playlistKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = vk_delete then playlist_Removeselected1Click(nil) else
    if key = VK_RETURN then listview_playlistDblClick(nil) else
      if key = 66 then begin
        playlist_select_prev;
        listview_playlistDblClick(nil);
      end else
        if key = 78 then begin
          playlist_select_next;
          listview_playlistDblClick(nil);
        end else
          if key = VK_DOWN then playlist_select_next else
            if key = VK_UP then playlist_select_prev;
end;

procedure Tares_frmmain.Loadplaylist1Click(Sender: TObject);
begin
  opendialog1.filter := GetLangStringW(STR_PLAYLIST_FILES) + '|*.m3u';
  if not opendialog1.execute then exit;

  playlist_loadm3u(opendialog1.filename, false);
end;

procedure Tares_frmmain.Saveplaylist1Click(Sender: TObject);
var
  filename: widestring;
begin
  savedialog1.filter := GetLangStringW(STR_PLAYLIST_FILES) + '|*.m3u';
  savedialog1.filename := GetLangStringW(STR_PLAYLIST) + chr(46) + chr(109) + chr(51) + chr(117);

  if not savedialog1.execute then exit;

  filename := savedialog1.filename;
  if lowercase(extractfileext(widestrtoutf8str(filename))) <> '.m3u' then filename := filename + '.m3u';
  playlist_savem3u(filename);
end;

procedure Tares_frmmain.playlist_sortInvClick(Sender: TObject);
begin
  shufflying_playlist := true;
  listview_playlist.Sort(nil, 0, sdascending);
  shufflying_playlist := false;
end;

procedure Tares_frmmain.btn_playlist_addfileClick(Sender: TObject);
var
  estensione: string;
  filename: widestring;
begin
  opendialog1.Filter := GetLangStringW(STR_ANY_FILE) + '|*.*';
  if not opendialog1.execute then exit;

  filename := opendialog1.filename;
  estensione := lowercase(extractfileext(widestrtoutf8str(filename)));

  if estensione = '.m3u' then playlist_loadm3u(filename, false)
  else playlist_addfile(widestrtoutf8str(filename), -1, false, '');

end;

procedure Tares_frmmain.btn_playlist_addfolderClick(Sender: TObject);
begin
  if not fol.execute then exit;
  playlist_addfolder(fol.foldername);
end;

procedure Tares_frmmain.resultChatCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: precord_file_result_chat;
  pannello_result: precord_pannello_result_chat;
  tipo_colonna: tcolumn_type;
begin
  if column < 0 then exit;

  try
    pannello_result := precord_pannello_result_chat(sender.Tag);

    tipo_colonna := pannello_result.stato_header[column];
    Data1 := sender.getdata(Node1);
    Data2 := sender.getdata(Node2);

    case tipo_colonna of
      COLUMN_TITLE: result := CompareText(Data1^.title, Data2^.title);
      COLUMN_ARTIST: result := CompareText(Data1^.artist, Data2^.artist);
      COLUMN_CATEGORY: result := CompareText(Data1^.category, Data2^.category);
      COLUMN_ALBUM: result := CompareText(Data1^.album, Data2^.album);
      COLUMN_TYPE: result := Data1^.amime - Data2^.amime;
      COLUMN_SIZE: begin
          if ((data1.fsize - data2.fsize > GIGABYTE) or
            (data2.fsize - data1.fsize > GIGABYTE)) then result := (data1.fsize div KBYTE) - (data2.fsize div KBYTE)
          else result := data1.fsize - data2.fsize;
        end;
      COLUMN_DATE: result := CompareText(data1^.data, data2^.data);
      COLUMN_LANGUAGE: result := CompareText(Data1^.language, Data2^.language);
      COLUMN_VERSION: result := CompareText(Data1^.album, Data2^.album);
      COLUMN_QUALITY: result := data1^.param1 - data2^.param1;
      COLUMN_COLORS: result := data1^.param3 - data2^.param3;
      COLUMN_LENGTH: result := data1^.param3 - data2^.param3;
      COLUMN_RESOLUTION: result := data1.param1 - data2.param1;
      COLUMN_USER: result := CompareText(data1^.nickname, data2^.nickname);
      COLUMN_FORMAT: result := CompareText(data1^.vidinfo, data2^.vidinfo);
      COLUMN_FILENAME: result := CompareText(Data1^.filename, Data2^.filename);
      COLUMN_FILETYPE: result := CompareText(lowercase(extractfileext(Data1^.filename)), lowercase(extractfileext(Data2^.filename)));
    end;

  except
  end;

end;

procedure Tares_frmmain.listview_srcCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: precord_search_result;
  tipo_colonna: tcolumn_type;
  str1, str2: string;
  rec_res: precord_panel_search;
begin
  if column < 0 then exit;

  rec_res := precord_panel_search(sender.tag);
  tipo_colonna := rec_res^.stato_header[column];

  Data1 := sender.getdata(Node1);
  Data2 := sender.getdata(Node2);

  case tipo_colonna of
    COLUMN_TITLE: result := CompareText(Data1.title, Data2.title);
    COLUMN_ARTIST: result := CompareText(Data1.artist, Data2.artist);
    COLUMN_CATEGORY: result := CompareText(Data1.category, Data2.category);
    COLUMN_ALBUM: result := CompareText(Data1.album, Data2.album);
    COLUMN_TYPE: result := Data1.amime - Data2.amime;
    COLUMN_SIZE: begin
        if ((data1.fsize - data2.fsize > GIGABYTE) or
          (data2.fsize - data1.fsize > GIGABYTE)) then result := (data1.fsize div KBYTE) - (data2.fsize div KBYTE)
        else result := data1.fsize - data2.fsize;
      end;
    COLUMN_DATE: result := CompareText(data1^.year, data2^.year);
    COLUMN_LANGUAGE: result := CompareText(Data1.language, Data2.language);
    COLUMN_VERSION: result := CompareText(Data1.album, Data2.album);
    COLUMN_QUALITY: result := data1.param1 - data2.param1;
    COLUMN_COLORS: result := data1.param3 - data2.param3;
    COLUMN_LENGTH: result := data1.param3 - data2.param3;
    COLUMN_RESOLUTION: result := data1.param1 - data2.param1;
    COLUMN_STATUS: begin
        result := ((node1.childcount * 256) + data1^.DHTload) - ((node2.childcount * 256) + data2^.DHTLoad);
      end;
    COLUMN_USER: begin
        if node1.childcount > 0 then str1 := inttostr(node1.childcount) + ' ' + GetLangStringA(STR_USERS) else str1 := data1^.nickname;
        if node2.childcount > 0 then str2 := inttostr(node2.childcount) + ' ' + GetLangStringA(STR_USERS) else str2 := data2^.nickname;
        result := CompareText(str1, str2);
      end;
    COLUMN_FILENAME: result := CompareText(Data1.filenameS, Data2.filenameS);
    COLUMN_FILETYPE: result := CompareText(lowercase(extractfileext(Data1.filenameS)), lowercase(extractfileext(Data2.filenameS)));
  end;

end;

procedure Tares_frmmain.userchatCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
    Data2: precord_displayed_chat_user;
begin
  Data1 := Sender.getdata(Node1);
  Data2 := Sender.getdata(Node2);
  case column of
    0: result := CompareText(Data1.nick, Data2.nick);
    1: result := Data1^.id - data2.id;
    2: result := Data1.files - Data2.files else
    result := data1.speed - data2.speed;
  end;
end;

procedure Tares_frmmain.listview_libCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
    Data2: precord_file_library;
  tipo_colonna: tcolumn_type;
begin
  if column < 0 then exit;

  tipo_colonna := stato_header_library[column];

  Data1 := sender.getdata(Node1);
  Data2 := sender.getdata(Node2);

  case tipo_colonna of
    COLUMN_TITLE: result := CompareText(Data1^.title, Data2^.title);
    COLUMN_ARTIST: result := CompareText(Data1^.artist, Data2^.artist);
    COLUMN_CATEGORY: result := CompareText(Data1^.category, Data2^.category);
    COLUMN_ALBUM: result := CompareText(Data1^.album, Data2^.album);
    COLUMN_SIZE: begin
        if ((data1.fsize - data2.fsize > GIGABYTE) or
          (data2.fsize - data1.fsize > GIGABYTE)) then result := (data1.fsize div KBYTE) - (data2.fsize div KBYTE)
        else result := data1.fsize - data2.fsize;
      end;
    COLUMN_DATE: result := CompareText(Data1^.year, Data2^.year);
    COLUMN_LANGUAGE: result := CompareText(Data1^.language, Data2^.language);
    COLUMN_VERSION: result := CompareText(Data1^.album, Data2^.album);
    COLUMN_QUALITY: result := data1^.param1 - data2^.param1;
    COLUMN_COLORS: result := data1^.param3 - data2^.param3;
    COLUMN_LENGTH: result := data1^.param3 - data2^.param3;
    COLUMN_RESOLUTION: result := data1^.param1 - data2^.param1;
    COLUMN_FILENAME: result := CompareText(extractfilename(Data1^.path), extractfilename(Data2^.path));
    COLUMN_MEDIATYPE: result := CompareText(Data1^.mediatype, Data2^.mediatype);
    COLUMN_FORMAT: result := comparetext(data1^.vidinfo, data2^.vidinfo);
    COLUMN_FILEDATE: result := DelphiDateTimeToUnix(data1^.filedate) - DelphiDateTimeToUnix(data2^.filedate);
    COLUMN_FILETYPE: result := CompareText(lowercase(extractfileext(Data1^.path)), lowercase(extractfileext(Data2^.path)));
  end;

end;


procedure Tares_frmmain.filtroGraphComplete(sender: TObject; Result: HRESULT; Renderer: IBaseFilter);
begin
  if helper_player.player_is_playing_image then exit;
  if length(file_visione_da_copiatore) > 0 then begin
    pausemedia;
    exit;
  end;

  stopmedia(nil);

  trackbar_player.Position := 0;


  trackbar_player.TimeCaption := format_time(0) + ' / ' +
    format_time(trackbar_player.max div 1000);


  if not vars_global.closing then playlist_playnext('');
end;


procedure Tares_frmmain.panel_vidMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  punto: tpoint;
  VideoWindow: IVideoWindow;
  pleft, ptop, pwidth, pheight: integer;
begin
  if not isvideoplaying then exit;
  if button <> mbright then exit;
  if helper_player.m_GraphBuilder = nil then exit;

  if not fullscreen2.checked then begin
    if helper_player.m_GraphBuilder.QueryInterface(IVideoWindow, VideoWindow) <> S_OK then exit;
    videowindow.GetWindowPosition(pleft, ptop, pwidth, pheight);
    getcursorpos(punto);
    if punto.x < pLeft then exit else
      if punto.x > pleft + pwidth then exit else
        if punto.y < ptop then exit else
          if punto.y > ptop + pheight then exit;
  end else getcursorpos(punto);


  popupmenuvideo.popup(punto.x, punto.y);

end;

procedure Tares_frmmain.treeview_downloadCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  dataNode1, dataNode2: precord_data_node;
  DnData1, DnData2: precord_displayed_download;
  BtData1, BtData2: precord_displayed_bittorrentTransfer;
  BtSrcData1, BtSrcData2: btcore.precord_Displayed_source;
  DsData1, DsData2: precord_displayed_downloadsource;
  rem1, rem2: integer;
  pro1, pro2: extended;
  filename1, filename2, str1, str2: string;
  num1, num2: integer;
  size1, size2, progress1, progress2: int64;

begin
  DataNode1 := Sender.getdata(Node1);
  DataNode2 := Sender.getdata(Node2);

  case column of

    0: begin
        if dataNode1^.m_type = dnt_Download then begin
          DnData1 := dataNode1^.data;
          filename1 := extractfilename(DnData1^.filename);
        end else
          if dataNode1^.m_type = dnt_bittorrentMain then begin
            BtData1 := dataNode1^.data;
            filename1 := extractfilename(BtData1^.filename);
          end else
            if dataNode1^.m_type = dnt_downloadSource then begin
              DsData1 := dataNode1^.data;
              filename1 := widestrtoutf8str(DsData1^.nomedisplayw);
            end else
              if dataNode1^.m_type = dnt_bittorrentSource then begin
                btsrcdata1 := dataNode1^.data;
                filename1 := btsrcdata1^.ipS;
              end;

        if dataNode2^.m_type = dnt_Download then begin
          DnData2 := dataNode2^.data;
          filename2 := extractfilename(DnData2^.filename);
        end else
          if dataNode2^.m_type = dnt_bittorrentMain then begin
            BtData2 := dataNode2^.data;
            filename2 := extractfilename(BtData2^.filename);
          end else
            if dataNode2^.m_type = dnt_downloadSource then begin
              DsData2 := dataNode2^.data;
              filename2 := widestrtoutf8str(DsData2^.nomedisplayw);
            end else
              if dataNode2^.m_type = dnt_bittorrentSource then begin
                btsrcdata2 := dataNode2^.data;
                filename2 := btsrcdata2^.ipS;
              end;

        result := CompareText(filename1, filename2);
      end;

    1: begin
        if dataNode1^.m_type = dnt_Download then begin
          DnData1 := dataNode1^.data;
          str1 := mediatype_to_str(DnData1^.tipo);
        end else
          if dataNode1^.m_type = dnt_downloadSource then str1 := ''
          else
            if dataNode1^.m_type = dnt_bittorrentMain then str1 := STR_BITTORRENT
            else
              if dataNode1^.m_type = dnt_bittorrentSource then str1 := '';


        if dataNode2^.m_type = dnt_Download then begin
          DnData2 := dataNode2^.data;
          str2 := mediatype_to_str(DnData2^.tipo);
        end else
          if dataNode2^.m_type = dnt_downloadSource then str2 := ''
          else
            if dataNode2^.m_type = dnt_bittorrentMain then str2 := STR_BITTORRENT
            else
              if dataNode2^.m_type = dnt_bittorrentSource then str1 := '';

        result := CompareText(str1, str2);
      end;

    2: begin
        if dataNode1^.m_type = dnt_Download then str1 := inttostr(node1.childcount)
        else
          if dataNode1^.m_type = dnt_DownloadSource then begin
            DsData1 := dataNode1^.data;
            str1 := DsData1^.nickname;
          end else
            if dataNode1^.m_type = dnt_bittorrentMain then str1 := inttostr(node1.childCount) + ' ' + GetLangStringW(STR_USERS)
            else
              if dataNode1^.m_type = dnt_bittorrentSource then begin
                BtSrcData1 := dataNode1^.data;
                str1 := BtSrcData1^.client;
              end;

        if dataNode2^.m_type = dnt_Download then str2 := inttostr(node2.childcount)
        else
          if dataNode2^.m_type = dnt_downloadSource then begin
            DsData2 := dataNode2^.data;
            str2 := DsData2^.nickname;
          end else
            if dataNode2^.m_type = dnt_bittorrentMain then str2 := inttostr(node2.childCount) + ' ' + GetLangStringW(STR_USERS)
            else
              if dataNode2^.m_type = dnt_bittorrentSource then begin
                BtSrcData2 := dataNode2^.data;
                str2 := BtSrcData2^.client;
              end;
        result := CompareText(str1, str2);
      end;


    3: begin
        num1 := 0;
        num2 := 0;
        if dataNode1^.m_type = dnt_Download then begin
          DnData1 := dataNode1^.data;
          num1 := downloadstate_to_byte(DnData1^.state);
        end else
          if dataNode1^.m_type = dnt_downloadSource then begin
            DsData1 := dataNode1^.data;
            num1 := sourcestate_to_byte(DsData1);
          end else
            if dataNode1^.m_type = dnt_bittorrentMain then begin
              BtData1 := dataNode1^.data;
              num1 := downloadstate_to_byte(BtData1^.state);
            end else
              if dataNode1^.m_type = dnt_bittorrentSource then begin
                BtSrcData1 := dataNode1^.data;
                num1 := BTSourceStatusToByte(BtsrcData1^.status);
              end;

        if dataNode2^.m_type = dnt_Download then begin
          DnData2 := dataNode2^.data;
          num2 := downloadstate_to_byte(DnData2^.state);
        end else
          if dataNode2^.m_type = dnt_downloadSource then begin
            DsData2 := dataNode2^.data;
            num2 := sourcestate_to_byte(DsData2);
          end else
            if dataNode2^.m_type = dnt_bittorrentMain then begin
              BtData2 := dataNode2^.data;
              num2 := downloadstate_to_byte(BtData2^.state);
            end else
              if dataNode2^.m_type = dnt_bittorrentSource then begin
                BtSrcData2 := dataNode2^.data;
                num2 := BTSourceStatusToByte(BtsrcData2^.status);
              end;

        result := num1 - num2;
      end;


    4: begin
        progress1 := 0;
        progress2 := 0;
        size1 := 0;
        size2 := 0;
        if dataNode1^.m_type = dnt_Download then begin
          DnData1 := dataNode1^.data;
          size1 := DnData1^.size;
          progress1 := DnData1^.progress;
        end else
          if dataNode1^.m_type = dnt_downloadSource then begin
            DsData1 := dataNode1^.data;
            size1 := DsData1^.size;
            progress1 := DsData1^.progress;
          end else
            if dataNode1^.m_type = dnt_bittorrentMain then begin
              BtData1 := dataNode1^.data;
              size1 := BtData1^.size;
              progress1 := BtData1^.downloaded;
            end else
              if dataNode1^.m_type = dnt_bittorrentSource then begin
                BtSrcData1 := dataNode1^.data;
                progress1 := btsrcdata1^.progress;
                size1 := progress1;
              end;

        if dataNode2^.m_type = dnt_Download then begin
          DnData2 := dataNode2^.data;
          size2 := DnData2^.size;
          progress2 := DnData2^.progress;
        end else
          if dataNode1^.m_type = dnt_downloadSource then begin
            DsData2 := dataNode2^.data;
            size2 := DsData2^.size;
            progress2 := DsData2^.progress;
          end else
            if dataNode2^.m_type = dnt_bittorrentMain then begin
              BtData2 := dataNode2^.data;
              size2 := BtData2^.size;
              progress2 := BtData2^.downloaded;
            end else
              if dataNode2^.m_type = dnt_bittorrentSource then begin
                BtSrcData2 := dataNode2^.data;
                progress2 := btsrcdata2^.progress;
                size2 := progress2;
              end;
        if size1 = 0 then exit;
        if size2 = 0 then exit;

        pro1 := progress1;
        pro1 := pro1 / size1;
        pro1 := pro1 * 100;
        pro2 := progress2;
        pro2 := pro2 / size2;
        pro2 := pro2 * 100;
        result := trunc(pro1 - pro2);
      end;


    5: begin
        num1 := 0;
        num2 := 0;
        if dataNode1^.m_type = dnt_Download then begin
          DnData1 := dataNode1^.data;
          num1 := DnData1^.velocita;
        end else
          if dataNode1^.m_type = dnt_downloadSource then begin
            DsData1 := dataNode1^.data;
            num1 := DsData1^.speed;
          end else
            if dataNode1^.m_type = dnt_bittorrentMain then begin
              BtData1 := dataNode1^.data;
              num1 := BtData1^.speedDl;
            end else
              if dataNode1^.m_type = dnt_bittorrentSource then begin
                BtSrcData1 := dataNode1^.data;
                num1 := BtSrcData1^.speedDown;
              end;

        if ((dataNode2^.m_type = dnt_Download) or
          (dataNode2^.m_type = dnt_PartialDownload)) then begin
          DnData2 := dataNode2^.data;
          num2 := DnData2^.velocita;
        end else
          if dataNode2^.m_type = dnt_downloadSource then begin
            DsData2 := dataNode2^.data;
            num2 := DsData2^.speed;
          end else
            if dataNode2^.m_type = dnt_bittorrentMain then begin
              BtData2 := dataNode2^.data;
              num2 := BtData2^.SpeedDl;
            end else
              if dataNode2^.m_type = dnt_bittorrentSource then begin
                BtSrcData2 := dataNode2^.data;
                num2 := BtSrcData2^.speedDown;
              end;
        result := num1 - num2;
      end;

    6: begin
        rem1 := 0;
        rem2 := 0;
        progress1 := 0;
        progress2 := 0;
        size1 := 0;
        size2 := 0;
        if dataNode1^.m_type = dnt_Download then begin
          DnData1 := dataNode1^.data;
          rem1 := DnData1^.velocita;
          size1 := DnData1^.size;
          progress1 := Dndata1^.progress;
        end else
          if dataNode1^.m_type = dnt_downloadSource then begin
            DsData1 := dataNode1^.data;
            rem1 := DsData1^.speed;
            size1 := DsData1^.size;
            progress1 := Dsdata1^.progress;
          end else
            if dataNode1^.m_type = dnt_bittorrentMain then begin
              BtData1 := dataNode1^.data;
              rem1 := BtData1^.SpeedDl;
              size1 := BtData1^.size;
              progress1 := Btdata1^.downloaded;
            end else
              if dataNode1^.m_type = dnt_bittorrentSource then begin
                BtSrcData1 := dataNode1^.data;
                rem1 := BtSrcdata1^.speedDown;
                size1 := BtSrcdata1^.size;
                progress1 := BtSrcData1^.recv;
              end;

        if dataNode2^.m_type = dnt_Download then begin
          DnData2 := dataNode2^.data;
          rem2 := DnData2^.velocita;
          size2 := DnData2^.size;
          progress2 := Dndata2^.progress;
        end else
          if dataNode2^.m_type = dnt_downloadSource then begin
            DsData2 := dataNode2^.data;
            rem2 := DsData2^.speed;
            size2 := DsData2^.size;
            progress2 := Dsdata2^.progress;
          end else
            if dataNode2^.m_type = dnt_bittorrentMain then begin
              BtData2 := dataNode2^.data;
              rem2 := BtData2^.SpeedDl;
              size2 := BtData2^.size;
              progress2 := Btdata2^.downloaded;
            end else
              if dataNode2^.m_type = dnt_bittorrentSource then begin
                BtSrcData2 := dataNode2^.data;
                rem2 := BtSrcdata2^.speedDown;
                size2 := BtSrcdata2^.size;
                progress2 := BtSrcData2^.recv;
              end;
        if rem1 = 0 then rem1 := $FFFFFFF else rem1 := (size1 - progress1) div rem1;
        if rem2 = 0 then rem2 := $FFFFFFF else rem2 := (size2 - progress2) div rem2;
        result := rem1 - rem2;
      end;


    7: begin
        progress1 := 0;
        progress2 := 0;
        if dataNode1^.m_type = dnt_Download then begin
          DnData1 := dataNode1^.data;
          progress1 := DnData1^.progress;
        end else
          if dataNode1^.m_type = dnt_downloadSource then begin
            DsData1 := dataNode1^.data;
            progress1 := DsData1^.progress;
          end else
            if dataNode1^.m_type = dnt_bittorrentMain then begin
              BtData1 := dataNode1^.data;
              progress1 := BtData1^.downloaded;
            end else
              if dataNode1^.m_type = dnt_bittorrentSource then begin
                BtSrcData1 := dataNode1^.data;
                progress1 := BtSrcData1^.recv;
              end;

        if dataNode2^.m_type = dnt_Download then begin
          DnData2 := dataNode2^.data;
          progress2 := DnData2^.progress;
        end else
          if dataNode2^.m_type = dnt_downloadSource then begin
            DsData2 := dataNode2^.data;
            progress2 := DsData2^.progress;
          end else
            if dataNode2^.m_type = dnt_bittorrentMain then begin
              BtData2 := dataNode2^.data;
              progress2 := BtData2^.downloaded;
            end else
              if dataNode2^.m_type = dnt_bittorrentSource then begin
                BtSrcData2 := dataNode2^.data;
                progress2 := BtSrcData2^.recv;
              end;
        result := progress1 - progress2;
      end;
  end;


end;

procedure Tares_frmmain.treeview_uploadCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  UpData1, UpData2: precord_displayed_upload;
  DnData1, DnData2: precord_displayed_download;
  BtData1, BtData2: precord_displayed_bittorrentTransfer;
  BtSrcData1, BtSrcData2: btcore.precord_Displayed_source;
  dataNode1, dataNode2: precord_data_node;
  rem1, rem2: integer;
  pro1, pro2: extended;
  text1, text2: string;
  progress1, size1, continued1, progress2, size2, continued2: int64;
  num1, num2: integer;
begin
  DataNode1 := Sender.getdata(Node1);
  DataNode2 := Sender.getdata(Node2);

  case column of

    0: begin
        if dataNode1^.m_type = dnt_bittorrentMain then begin
          BtData1 := dataNode1^.data;
          text1 := BtData1^.FileName;
        end else
          if dataNode1^.m_type = dnt_bittorrentSource then begin
            BtSrcData1 := dataNode1^.data;
            text1 := BtsrcData1^.ipS;
          end else
            if dataNode1^.m_type = dnt_upload then begin
              UpData1 := dataNode1^.data;
              text1 := extractfilename(UpData1^.nomefile);
            end; { else begin
          DnData1:=dataNode1^.data;
          text1:=widestrtoutf8str(dndata1^.nomedisplayw);
        end; }
        if dataNode2^.m_type = dnt_bittorrentMain then begin
          BtData2 := dataNode2^.data;
          text2 := BtData2^.FileName;
        end else
          if dataNode2^.m_type = dnt_bittorrentSource then begin
            BtSrcData2 := dataNode2^.data;
            text2 := BtsrcData2^.ipS;
          end else
            if dataNode2^.m_type = dnt_upload then begin
              UpData2 := dataNode2^.data;
              text2 := extractfilename(UpData2^.nomefile);
            end; { else begin
          DnData2:=dataNode2^.data;
          text2:=widestrtoutf8str(dndata2^.nomedisplayw);
        end; }
        result := CompareText(text1, text2);
      end;

    1: begin
        if dataNode1^.m_type = dnt_bittorrentSource then begin
          text1 := '';
        end else
          if dataNode1^.m_type = dnt_bitTorrentMain then begin
            text1 := STR_BITTORRENT;
          end else
            if dataNode1^.m_type = dnt_upload then begin
              UpData1 := dataNode1^.data;
              text1 := mediatype_to_str(extstr_to_mediatype(lowercase(extractfileext(UpData1^.nomefile))));
            end; { else begin
          DnData1:=dataNode1^.data;
          text1:=mediatype_to_str(DnData1^.tipo);
        end; }

        if dataNode2^.m_type = dnt_bittorrentSource then begin
          text2 := '';
        end else
          if dataNode2^.m_type = dnt_bitTorrentMain then begin
            text2 := STR_BITTORRENT;
          end else
            if dataNode2^.m_type = dnt_upload then begin
              UpData2 := dataNode2^.data;
              text2 := mediatype_to_str(extstr_to_mediatype(lowercase(extractfileext(UpData2^.nomefile))));
            end; { else begin
          DnData2:=dataNode2^.data;
          text2:=mediatype_to_str(DnData2^.tipo);
        end; }
        result := CompareText(text1, text2);
      end;

    2: begin
        if dataNode1^.m_type = dnt_bittorrentSource then begin
          btSrcData1 := dataNode1^.data;
          text1 := btsrcData1^.client;
        end else
          if dataNode1^.m_type = dnt_bittorrentMain then begin
            Text1 := inttostr(node1.ChildCount) + ' ' + GetLangStringW(STR_USERS);
          end else
            if dataNode1^.m_type = dnt_upload then begin
              UpData1 := dataNode1^.data;
              text1 := UpData1^.nickname;
            end; { else begin
          DnData1:=dataNode1^.data;
          text1:=widestrtoutf8str(DnData1^.nicknamew);
        end; }

        if dataNode2^.m_type = dnt_bittorrentSource then begin
          btSrcData2 := dataNode2^.data;
          text2 := btsrcData2^.client;
        end else
          if dataNode2^.m_type = dnt_bittorrentMain then begin
            Text2 := inttostr(node2.ChildCount) + ' ' + GetLangStringW(STR_USERS);
          end else
            if dataNode2^.m_type = dnt_upload then begin
              UpData2 := dataNode2^.data;
              text2 := UpData2^.nickname;
            end; { else begin
          DnData2:=dataNode2^.data;
          text2:=widestrtoutf8str(DnData2^.nicknamew);
        end;}
        result := CompareText(text1, text2);
      end;


    3: begin
        if dataNode1^.m_type = dnt_bittorrentMain then begin
          BtData1 := dataNode1^.data;
          num1 := downloadstate_to_byte(BtData1^.state);
        end else
          if dataNode1^.m_type = dnt_bittorrentSource then begin
            BtSrcData1 := dataNode1^.data;
            num1 := BTSourceStatusToByte(BtsrcData1^.status);
          end else
            if dataNode1^.m_type = dnt_upload then begin
              UpData1 := dataNode1^.data;
              if UpData1^.completed then begin
                if Updata1^.progress = Updata1^.size then num1 := 0
                else num1 := 1;
              end else num1 := 2;
            end else num1 := 2;

        if dataNode2^.m_type = dnt_bittorrentMain then begin
          BtData2 := dataNode2^.data;
          num2 := downloadstate_to_byte(BtData2^.state);
        end else
          if dataNode2^.m_type = dnt_bittorrentSource then begin
            BtSrcData2 := dataNode2^.data;
            num2 := BTSourceStatusToByte(BtsrcData2^.status);
          end else
            if dataNode2^.m_type = dnt_upload then begin
              UpData2 := dataNode2^.data;
              if UpData2^.completed then begin
                if Updata2^.progress = Updata2^.size then num2 := 0
                else num2 := 1;
              end else num2 := 2;
            end else num2 := 2;
        result := num1 - num2;
      end;


    4: begin
        progress1 := 0;
        progress2 := 0;
        size1 := 0;
        size2 := 0;
        continued1 := 0;
        continued2 := 0;
        if dataNode1^.m_type = dnt_bittorrentMain then begin
          btData1 := dataNode1^.data;
          progress1 := BtData1^.uploaded;
          size1 := BtData1^.downloaded;
        end else
          if dataNode1^.m_type = dnt_bittorrentSource then begin
            btsrcData1 := dataNode1^.data;
            progress1 := BtsrcData1^.sent;
            size1 := BtsrcData1^.recv;
          end else
            if dataNode1^.m_type = dnt_upload then begin
              UpData1 := dataNode1^.data;
              progress1 := UpData1^.progress;
              size1 := UpData1^.size;
              continued1 := UpData1^.continued_from;
            end; { else begin
          DnData1:=dataNode1^.data;
          progress1:=DnData1^.progress;
          size1:=DnData1^.size;
          continued1:=0;
        end;}

        if dataNode2^.m_type = dnt_bittorrentMain then begin
          btData2 := dataNode2^.data;
          progress2 := BtData2^.uploaded;
          size2 := BtData2^.downloaded;
        end else
          if dataNode2^.m_type = dnt_bittorrentSource then begin
            btsrcData2 := dataNode2^.data;
            progress2 := BtsrcData2^.sent;
            size2 := BtsrcData2^.recv;
          end else
            if dataNode2^.m_type = dnt_upload then begin
              UpData2 := dataNode2^.data;
              progress2 := UpData2^.progress;
              size2 := UpData2^.size;
              continued2 := UpData2^.continued_from;
            end; { else begin
          DnData2:=dataNode2^.data;
          progress2:=DnData2^.progress;
          size2:=DnData2^.size;
          continued2:=0;
        end; }
        if size1 = 0 then exit;
        if size2 = 0 then exit;
        pro1 := progress1 + continued1;
        pro1 := pro1 / size1 + continued1;
        pro1 := pro1 * 100;
        pro2 := progress2 + continued2;
        pro2 := pro2 / size2 + continued2;
        pro2 := pro2 * 100;
        result := trunc(pro1 - pro2);
      end;

    5: begin
        num1 := 0;
        num2 := 0;
        if dataNode1^.m_type = dnt_bittorrentMain then begin
          btData1 := dataNode1^.data;
          num1 := btdata1^.speedUl;
        end else
          if dataNode1^.m_type = dnt_bittorrentSource then begin
            btSrcData1 := dataNode1^.data;
            num1 := btsrcData1^.speedUp;
          end else
            if dataNode1^.m_type = dnt_upload then begin
              UpData1 := dataNode1^.data;
              num1 := UpData1^.velocita;
            end; { else begin
          DnData1:=dataNode1^.data;
          num1:=DnData1^.velocita;
        end;}
        if dataNode2^.m_type = dnt_bittorrentMain then begin
          btData2 := dataNode2^.data;
          num2 := btdata2^.speedUl;
        end else
          if dataNode2^.m_type = dnt_bittorrentSource then begin
            btSrcData2 := dataNode2^.data;
            num2 := btsrcData2^.speedUP;
          end else
            if dataNode2^.m_type = dnt_upload then begin
              UpData2 := dataNode2^.data;
              num2 := UpData2^.velocita;
            end; { else begin
          DnData2:=dataNode2^.data;
          num2:=DnData2^.velocita;
        end;}
        result := num1 - num2;
      end;

    6: begin
        rem1 := 0;
        rem2 := 0;
        progress1 := 0;
        progress2 := 0;
        size1 := 0;
        size2 := 0;
        if dataNode1^.m_type = dnt_bittorrentMain then begin
          rem1 := 0;
        end else
          if dataNode1^.m_type = dnt_bittorrentSource then begin
            rem1 := 0;
          end else
            if dataNode1^.m_type = dnt_upload then begin
              UpData1 := dataNode1^.data;
              rem1 := UpData1^.velocita;
              size1 := Updata1^.size;
              progress1 := UpData1^.progress;
            end; {else begin
          DnData1:=dataNode1^.data;
          rem1:=DnData1^.velocita;
          size1:=DnData1^.size;
          progress1:=DnData1^.progress;
        end; }
        if dataNode2^.m_type = dnt_bittorrentMain then begin
          rem2 := 0;
        end else
          if dataNode2^.m_type = dnt_bittorrentSource then begin
            rem2 := 0;
          end else
            if dataNode2^.m_type = dnt_upload then begin
              UpData2 := dataNode2^.data;
              rem2 := UpData2^.velocita;
              size2 := Updata2^.size;
              progress2 := UpData2^.progress;
            end; { else begin
          DnData2:=dataNode2^.data;
          rem2:=DnData2^.velocita;
          size2:=DnData2^.size;
          progress2:=DnData2^.progress;
        end; }
        if rem1 = 0 then rem1 := $FFFFFFF else rem1 := (size1 - progress1) div rem1;
        if rem2 = 0 then rem2 := $FFFFFFF else rem2 := (size2 - progress2) div rem2;
        result := rem1 - rem2;
      end;

    7: begin
        continued1 := 0;
        continued2 := 0;
        progress1 := 0;
        progress2 := 0;
        if dataNode1^.m_type = dnt_bittorrentMain then begin
          btData1 := dataNode1^.data;
          progress1 := btData1^.uploaded;
          continued1 := 0;
        end else
          if dataNode1^.m_type = dnt_bittorrentSource then begin
            btsrcdata1 := dataNode1^.data;
            progress1 := btsrcdata1^.sent;
            continued1 := 0;
          end else
            if dataNode1^.m_type = dnt_upload then begin
              UpData1 := dataNode1^.data;
              progress1 := UpData1^.progress;
              continued1 := UpData1^.continued_from;
            end; { else begin
          DnData1:=dataNode1^.data;
          progress1:=DnData1^.progress;
          continued1:=0;
        end; }
        if dataNode2^.m_type = dnt_bittorrentMain then begin
          btData2 := dataNode2^.data;
          progress2 := btData2^.uploaded;
          continued2 := 0;
        end else
          if dataNode2^.m_type = dnt_bittorrentSource then begin
            btsrcdata2 := dataNode2^.data;
            progress2 := btsrcdata2^.sent;
            continued2 := 0;
          end else
            if dataNode2^.m_type = dnt_upload then begin
              UpData2 := dataNode2^.data;
              progress2 := UpData2^.progress;
              continued2 := UpData2^.continued_from;
            end; { else begin
          DnData2:=dataNode2^.data;
          progress2:=DnData2^.progress;
          continued2:=0;
        end; }
        result := (progress1 + continued1) - (progress2 + continued2);
      end;

  end;


end;

procedure Tares_frmmain.listview_chat_channelCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
    Data2: precord_displayed_channel;
begin
  Data1 := Sender.getdata(Node1);
  Data2 := Sender.getdata(Node2);
  case column of
    0: result := CompareText(Data1.name, Data2.name);
    2: result := CompareText(widestrtoutf8str(Data1.stripped_topic), widestrtoutf8str(Data2.stripped_topic));
    1: result := data1.users - data2.users;
  end;
end;

procedure Tares_frmmain.panel_playlistResize(Sender: TObject);
begin
  btn_playlist_close.left := panel_playlist.width - btn_playlist_close.width - 2;
  listview_playlist.Height := panel_playlist.Height - 20;
  listview_playlist.Width := panel_playlist.width - 1;
end;

procedure Tares_frmmain.combo_lang_searchClick(Sender: TObject);
var
  combo: ttntcombobox;
begin
  if not (sender is ttntcombobox) then exit;

  combo := (sender as ttntcombobox);

  with combo do begin

    if itemindex = 0 then begin
      if widestrtoutf8str(text) = GetLangStringA(PURGE_SEARCH_STR) then begin
        if not clear_search_history then begin
          itemindex := -1;
          text := '';
        end;
      end;
    end;

  end;
end;



procedure Tares_frmmain.treeview_lib_virfoldersCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  data1, data2: ares_types.precord_string;
begin
  data1 := sender.getdata(node1);
  data2 := sender.getdata(node2);
  result := comparetext(data1^.str, data2^.str);
end;

procedure Tares_frmmain.combotitsearchKeyPress(Sender: TObject; var Key: Char);
var
  time1: cardinal;
begin
  case integer(key) of
    13: begin
        key := char(vk_cancel);
        if Btn_start_search.enabled then Btn_start_searchclick(nil) else begin
          btn_stop_searchclick(nil);
          time1 := gettickcount;
          while gettickcount - time1 < 250 do application.processmessages;
          Btn_start_searchclick(nil);
        end;
      end else begin
      if btn_stop_search.enabled then btn_stop_searchclick(nil);
    end;
  end;
end;

procedure Tares_frmmain.edit_titleKeyPress(Sender: TObject; var Key: Char);
begin
  if integer(key) = 13 then key := char(VK_CANCEL);
end;

procedure Tares_frmmain.treeview_lib_virfoldersMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nodo: PCmtVNode;
  level: integer;
  punto: tpoint;
  nodoroot, nodoall, nodoaudio, nodoimage, nodovideo: PCmtVNode;
begin
  with treeview_lib_virfolders do begin

    if rootnodecount = 0 then exit;
    if button <> mbright then exit;

    nodo := getfirstselected;
    if nodo = nil then exit;

    level := getnodelevel(nodo);
    if level <> 3 then exit;

    nodoroot := GetFirst;
    nodoall := getfirstchild(nodoroot);

    nodoaudio := GetNextSibling(nodoall);
    nodoimage := getnextsibling(nodoaudio);
    nodovideo := getnextsibling(nodoimage);
  end;


  if nodo.parent.parent <> nodoaudio then
    if nodo.parent.parent <> nodovideo then exit;

  getcursorpos(punto);
  popup_lib_virfolders.popup(punto.x, punto.y);
end;

procedure Tares_frmmain.AddtoPlaylist4Click(Sender: TObject);
var
  nodo: PCmtVNode;
  level: integer;
  nodoroot, nodoall, nodoaudio, nodoimage, nodovideo: PCmtVNode;
  nodoaudiobyartist, nodoaudiobyalbum, nodoaudiobygenre: PCmtVNode;
  nodovideobycategory: PCmtVNode;

  pfile: precord_file_library;
  data: ares_types.precord_string;
  match, match1, match2, match3: string;
  i: integer;
  tipo: byte;
begin
  with treeview_lib_virfolders do begin

    if rootnodecount = 0 then exit;

    nodo := getfirstselected;
    if nodo = nil then exit;

    level := getnodelevel(nodo);
    if level <> 3 then exit;

    nodoroot := GetFirst;
    nodoall := getfirstchild(nodoroot);

    nodoaudio := GetNextSibling(nodoall);
    nodoaudiobyartist := getfirstchild(nodoaudio);
    nodoaudiobyalbum := getnextsibling(nodoaudiobyartist);
    nodoaudiobygenre := getnextsibling(nodoaudiobyalbum);
    nodoimage := getnextsibling(nodoaudio);
    nodovideo := getnextsibling(nodoimage);
    nodovideobycategory := getfirstchild(nodovideo);

  end;


  if nodo.parent.parent <> nodoaudio then
    if nodo.parent.parent <> nodovideo then exit;

  if nodo.parent.parent = nodoaudio then tipo := ARES_MIME_MP3 else
    if nodo.parent.parent = nodovideo then tipo := ARES_MIME_VIDEO else exit;

  data := treeview_lib_virfolders.getdata(nodo);
  match := lowercase(data^.str);
  if match = GetLangStringA(STR_UNKNOW_LOWER) then match := '';

  for i := 0 to lista_shared.count - 1 do begin
    pfile := lista_shared[i];
    if pfile^.amime <> tipo then continue;

    if ((nodo.parent.parent <> nodovideo) and (nodo.parent.parent <> nodoimage)) then begin
      match1 := lowercase(pfile^.artist);
      match2 := lowercase(pfile^.category);
      if nodo.parent.parent = nodoaudio then match3 := lowercase(pfile^.album);
    end else
      if nodo.parent.parent = nodovideo then begin
        match1 := lowercase(pfile^.category);
      end else
        if nodo.parent.parent = nodoimage then begin
          match1 := lowercase(pfile^.album);
          match2 := lowercase(pfile^.category);
        end;

    if match1 = GetLangStringA(STR_UNKNOW_LOWER) then match1 := '';
    if match2 = GetLangStringA(STR_UNKNOW_LOWER) then match2 := '';
    if match3 = GetLangStringA(STR_UNKNOW_LOWER) then match3 := '';

    case tipo of
      ARES_MIME_MP3: begin
          if nodo.parent = nodoaudiobyartist then begin
            if match1 = match then playlist_addfile(pfile^.path, pfile^.param3, false, '');
          end else
            if nodo.parent = nodoaudiobyalbum then begin
              if match3 = match then playlist_addfile(pfile^.path, pfile^.param3, false, '');
            end else
              if nodo.parent = nodoaudiobygenre then begin
                if match2 = match then playlist_addfile(pfile^.path, pfile^.param3, false, '');
              end;
        end;
      ARES_MIME_VIDEO: begin
          if nodo.parent = nodovideobycategory then begin
            if match1 = match then playlist_addfile(pfile^.path, pfile^.param3, false, '');
          end;
        end;
    end;
  end;

end;

procedure Tares_frmmain.listview_chat_channelAfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex; CellRect: TRect);
var
  data: precord_displayed_channel;
  widestr: widestring;
  cellrec: trect;
  forecolor, backcolor, forecolor_gen, backcolor_gen: Tcolor;
begin
  if column <> 2 then exit;

  data := sender.getdata(node);
  if not data^.has_colors_intopic then exit;

  try

    widestr := utf8strtowidestr(data^.topic);

    with cellrec do begin
      left := cellrect.left;
      top := cellrect.top + 1;
      bottom := cellrect.bottom;
      right := cellrect.right;
    end;

    if (vsSelected in Node.States) then begin
      backcolor_gen := clHighLight;
      forecolor_gen := $00FEFFFF;
      backcolor := clHighLight;
      forecolor := $00FEFFFF;
    end else begin
      forecolor_gen := clblack;
      forecolor := clblack;
      if (node.Index mod 2) = 0 then backcolor_gen := sender.BGColor else backcolor_gen := $00FEFFFF;
      backcolor := backcolor_gen;
    end;

    canvas_draw_topic(Targetcanvas, CellRec, imglist_emotic, widestr, forecolor, backcolor, forecolor_gen, backcolor_gen, 8);

  except
  end;
end;

procedure tares_frmmain.pvt_unhide(sender: tobject);
begin
  (sender as ttnttabsheet).imageindex := 11;
end;

procedure Tares_frmmain.SendPrivateMessage1Click(Sender: TObject);
var
  Data: precord_displayed_chat_user;
  pcanale: precord_canale_chat_visual;
  nodo: PCmtVNode;
//pvt_chat:precord_pvt_chat_visual;
  pnl: TCometPagePanel;
begin
  try

    pnl := panel_chat.Panels[panel_chat.activePage];
    pcanale := pnl.fdata;

    if not pcanale^.support_pvt then exit;
    nodo := pcanale^.listview.GetFirstSelected;
    if nodo = nil then exit;

    data := pcanale^.listview.getdata(nodo);
  //pvt_chat:=
    new_chatroom_pvt(pcanale, data^.nick, data^.crcnick, true, false);

  except
  end;
end;

procedure Tares_frmmain.popup_chat_userlistPopup(Sender: TObject);
var
  nodo: PCmtVNode;
  Data: ^record_displayed_chat_user;
  pcanale: precord_canale_chat_visual;
  i: integer;
begin
  try

    IgnoreUnignore1.visible := true;
    Ban1.visible := false;
    Disconnect2.visible := false;
    Unban1.visible := false;
    Muzzle1.visible := false;
    UnMuzzle1.visible := false;
    N17.visible := false;
    SendPrivateMessage1.visible := false;
    Sendaprivatemessage1.visible := false;
    Grantupslot1.visible := false;
    Browse1.visible := false;

    for i := 0 to list_chatchan_visual.count - 1 do begin
      pcanale := list_chatchan_visual[i];
      if panel_chat.activepanel <> pcanale^.containerPageview then continue;

      nodo := pcanale^.listview.GetFirstSelected;
      if nodo = nil then exit;
      data := pcanale^.listview.getdata(nodo);
      Sendaprivatemessage1.visible := ((data^.ip <> 0) and (data^.port <> 0));
      Grantupslot1.visible := Sendaprivatemessage1.visible;
      Browse1.visible := ((data^.support_files) and
        (pcanale^.support_files) and
        (data^.files > 0));

      IgnoreUnignore1.visible := true; //(not pcanale^.ModLevel);
      Ban1.visible := pcanale^.ModLevel;
      Unban1.visible := pcanale^.ModLevel;
      Disconnect2.visible := pcanale^.ModLevel;
      Muzzle1.visible := pcanale^.ModLevel;
      UnMuzzle1.visible := pcanale^.ModLevel;
      SendPrivateMessage1.visible := pcanale^.support_pvt;
      break;
    end;

    N17.visible := (((Sendaprivatemessage1.visible) or (SendPrivateMessage1.visible) or (Grantupslot1.visible) or (browse1.visible)) and
      ({(IgnoreUnignore1.visible) or }(ban1.visible)));

  except
  end;
end;

procedure Tares_frmmain.edit_chat_chanfilterKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  mainGui_trigger_channelfilter;
end;

procedure Tares_frmmain.combo_chat_searchClick(Sender: TObject);
var
  combo: ttntcombobox;
begin
  combo := (sender as ttntcombobox);

  with combo do begin

    if itemindex = 0 then begin
      if widestrtoutf8str(text) = GetLangStringA(PURGE_SEARCH_STR) then begin
        if not clear_search_history then begin
          itemindex := -1;
          text := '';
        end;
      end;
    end;

  end;
end;

procedure Tares_frmmain.combo_chat_searchKeyPress(Sender: TObject; var Key: Char);
begin
  if integer(key) = 13 then begin
    key := char(vk_cancel);
    btn_chat_searchClick(nil);
  end;
end;

procedure Tares_frmmain.btn_chat_searchClick(Sender: TObject);
begin
  mainGui_trigger_channelsearch;
end;

procedure Tares_frmmain.treeviewbrowseCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  data1, data2: ares_types.precord_string;
begin
  data1 := sender.getdata(node1);
  data2 := sender.getdata(node2);
  result := comparetext(data1^.str, data2^.str);
end;

procedure Tares_frmmain.treeviewbrowseFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_virtualbrowse_entry(sender, node);
end;

procedure Tares_frmmain.treeviewbrowseGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  data: ares_types.precord_string;
begin
  Data := sender.getdata(Node);
  if data^.counter = 0 then CellText := utf8strtowidestr(data^.str) else
    CellText := utf8strtowidestr(data^.str) + chr(32) + chr(40) {' ('} +
      inttostr(data^.counter) + chr(41) {')'};
end;

procedure Tares_frmmain.treeviewbrowseGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
begin
  if not (vsSelected in node.states) then ImageIndex := 0
  else ImageIndex := 1;
end;

procedure Tares_frmmain.treeviewbrowseGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  size := sizeof(ares_types.record_string);
end;

procedure Tares_frmmain.treeviewbrowseKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ((key = VK_UP) or (key = VK_DOWN)) then
    treeviewbrowseclick(sender);
end;

procedure Tares_frmmain.treeviewbrowse2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nodo: PCmtVNode;
  level: integer;
  punto: tpoint;
begin
  if sender = nil then exit;

  if (sender as tcomettree).rootnodecount = 0 then exit;
  if button <> mbright then exit;

  nodo := (sender as tcomettree).getfirstselected;
  if nodo = nil then exit;

  level := (sender as tcomettree).getnodelevel(nodo);
  if level = 0 then exit;

  getcursorpos(punto);
  popup_chat_dlregfolder.popup(punto.x, punto.y);
end;

procedure Tares_frmmain.treeviewbrowseMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nodo: PCmtVNode;
  level: integer;
  punto: tpoint;
begin
  if sender = nil then exit;

  if (sender as tcomettree).rootnodecount = 0 then exit;
  if button <> mbright then exit;

  nodo := (sender as tcomettree).getfirstselected;
  if nodo = nil then exit;

  level := (sender as tcomettree).getnodelevel(nodo);
  if level <> 3 then exit;

  getcursorpos(punto);
  popup_chat_dlvirfolder.popup(punto.x, punto.y);
end;

procedure tares_frmmain.CometTreebrowseMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  punto: tpoint;
  data: precord_file_library;
  nodo: PCmtVNode;
  pannello_browse: precord_pannello_browse_chat;
  listview: tcomettree;
begin
  try

    if (sender as tcomettree).rootnodecount = 0 then exit;
    if button <> mbright then exit;

    listview := (sender as tcomettree);
    pannello_browse := precord_pannello_browse_chat(listview.tag);

    if pannello_browse^.btn_virtual_view.down then begin
      nodo := pannello_browse^.treeview.getfirst;
      if pannello_browse^.treeview.selected[nodo] then exit;
    end else begin
      nodo := pannello_browse^.treeview2.getfirst;
      if pannello_browse^.treeview2.selected[nodo] then exit;
    end;


    nodo := (sender as tcomettree).getfirstselected;
    if nodo <> nil then begin
      data := (sender as tcomettree).getdata(nodo);
      Findmoreofthesame1.visible := (data^.amime = ARES_MIME_MP3);
      Artist4.visible := (length(data^.artist) > 0);
      Genre4.visible := (length(data^.category) > 0);
    end else begin
      Findmoreofthesame1.visible := false;
      Artist4.visible := false;
      Genre4.visible := false;
      exit;
    end;

    getcursorpos(punto);
    popup_chat_browse.popup(punto.x, punto.y);
  except
  end;
end;

procedure Tares_frmmain.CometTreebrowseClick(Sender: TObject);
var
  data: precord_file_library;
  nodo, node: PCmtVNode;
  listview: tcomettree;
  pannello_browse: precord_pannello_browse_chat;
begin
  if sender = nil then exit;

  listview := (sender as tcomettree);
  pannello_browse := precord_pannello_browse_chat(listview.tag);

  nodo := pannello_browse^.listview.GetFirstSelected;
  if nodo = nil then exit;

  data := pannello_browse^.listview.getdata(nodo);

  if ((data^.hash_sha1 = '') and (data^.path = '')) then begin

    if pannello_browse^.btn_virtual_view.down then begin
      node := trova_nodo_treeview1_categoria(pannello_browse^.treeview, data^.title);
      if node = nil then exit;
      pannello_browse^.treeview.Selected[node] := true;
      TreeViewbrowseClick(pannello_browse^.treeview);
    end else begin
      node := trova_nodo_treeview2_folder(pannello_browse^.listview, pannello_browse^.treeview2);
      if node = nil then exit;
      pannello_browse^.treeview2.Selected[node] := true;
      pannello_browse^.treeview2.expanded[node] := true;
      TreeViewbrowse2Click(pannello_browse^.treeview2);
    end;

    exit;
  end;

end;

procedure Tares_frmmain.CometTreebrowseCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
    Data2: precord_file_library;
  tipo_colonna: tcolumn_type;
  listview: tcomettree;
  pannello_browse: precord_pannello_browse_chat;
begin
  if column < 0 then exit;

  if sender = nil then exit;

  listview := (sender as tcomettree);
  pannello_browse := precord_pannello_browse_chat(listview.tag);



  tipo_colonna := pannello_browse^.stato_header_library[column];

  Data1 := sender.getdata(Node1);
  Data2 := sender.getdata(Node2);

  case tipo_colonna of
    COLUMN_TITLE: result := CompareText(Data1^.title, Data2^.title);
    COLUMN_ARTIST: result := CompareText(Data1^.artist, Data2^.artist);
    COLUMN_CATEGORY: result := CompareText(Data1^.category, Data2^.category);
    COLUMN_ALBUM: result := CompareText(Data1^.album, Data2^.album);
    COLUMN_SIZE: begin
        if ((data1.fsize - data2.fsize > GIGABYTE) or
          (data2.fsize - data1.fsize > GIGABYTE)) then result := (data1.fsize div KBYTE) - (data2.fsize div KBYTE)
        else result := data1.fsize - data2.fsize;
      end;
    COLUMN_DATE: result := CompareText(Data1^.year, Data2^.year);
    COLUMN_LANGUAGE: result := CompareText(Data1^.language, Data2^.language);
    COLUMN_VERSION: result := CompareText(Data1^.album, Data2^.album);
    COLUMN_QUALITY: result := data1^.param1 - data2^.param1;
    COLUMN_COLORS: result := data1^.param3 - data2^.param3;
    COLUMN_LENGTH: result := data1^.param3 - data2^.param3;
    COLUMN_RESOLUTION: result := data1^.param1 - data2^.param1;
    COLUMN_FILENAME: result := CompareText(extractfilename(Data1^.path), extractfilename(Data2^.path));
    COLUMN_MEDIATYPE: result := CompareText(Data1^.mediatype, Data2^.mediatype);
    COLUMN_FORMAT: result := comparetext(data1^.vidinfo, data2^.vidinfo);
    COLUMN_FILETYPE: result := CompareText(lowercase(extractfileext(Data1^.path)), lowercase(extractfileext(Data2^.path)));
  end;

end;

procedure Tares_frmmain.CometTreebrowseFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_file_library(sender, node);
end;

procedure Tares_frmmain.CometTreebrowseGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  Data: precord_file_library;
  tipo_colonna: tcolumn_type;
  listview: tcomettree;
  pannello_browse: precord_pannello_browse_chat;
begin

  if column < 0 then exit;
  if column > 10 then begin
    celltext := chr(32);
    exit;
  end;

  if sender = nil then exit;

  listview := (sender as tcomettree);
  pannello_browse := precord_pannello_browse_chat(listview.tag);


  tipo_colonna := pannello_browse^.stato_header_library[column];


  Data := sender.getdata(Node);
  with data^ do begin

    case tipo_colonna of
      COLUMN_TITLE: CellText := utf8strtowidestr(title);
      COLUMN_ARTIST: CellText := utf8strtowidestr(artist);
      COLUMN_CATEGORY: CellText := utf8strtowidestr(category);
      COLUMN_ALBUM: CellText := utf8strtowidestr(album);
      COLUMN_SIZE: begin
          if imageindex = 0 then celltext := chr(32) else begin
            if fsize < 4096 then CellText := format_currency(fsize) + chr(32) + STR_BYTES
            else CellText := format_currency(fsize div 1024) + chr(32) + STR_KB;
          end;
        end;
      COLUMN_DATE: CellText := utf8strtowidestr(year);
      COLUMN_LANGUAGE: CellText := utf8strtowidestr(language);
      COLUMN_VERSION: CellText := utf8strtowidestr(album);
      COLUMN_QUALITY: if data^.param1 <> 0 then CellText := inttostr(param1) else CellText := chr(32);
      COLUMN_FILETYPE: CellText := extractfileext(path);
      COLUMN_COLORS: begin
          if param3 = 4 then CellText := '16' else
            if param3 = 8 then CellText := '256' else
              if param3 = 16 then CellText := '65K' else
                if param3 <> 0 then CellText := '24M' else CellText := chr(32);
        end;
      COLUMN_LENGTH: if param3 = 0 then CellText := chr(32) else CellText := format_time(param3);
      COLUMN_RESOLUTION: if param1 = 0 then CellText := chr(32) else CellText := inttostr(param1) + chr(120) {'x'} + inttostr(param2);
      COLUMN_FILENAME: CellText := extract_fnameW(utf8strtowidestr(path));
      COLUMN_NULL: CellText := chr(32);
      COLUMN_YOUR_LIBRARY: CellText := utf8strtowidestr(title);
      COLUMN_MEDIATYPE: CellText := utf8strtowidestr(mediatype);
      COLUMN_FORMAT: CellText := utf8strtowidestr(vidinfo) else CellText := chr(32);
    end;

  end;
end;

procedure Tares_frmmain.CometTreebrowsePaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
var
  data: precorD_file_library;
begin
  try
    data := sender.getdata(node);
    if data^.already_in_lib then TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT1 {clgray} else
      if data^.being_downloaded then TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT2
      else TargetCanvas.Font.Color := COLORE_LISTVIEWS_FONT;

    if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext;
  except
  end;

end;

procedure Tares_frmmain.CometTreebrowseGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  Data: precord_file_library;
begin
  imageindex := -1;

  if not sender.selectable then exit;
  Data := sender.getdata(node);
  if data^.downloaded then ImageIndex := data^.imageindex + 12
  else ImageIndex := data^.imageindex;
end;

procedure tares_frmmain.panel_left_browse_resize(sender: tobject);
var
  panel_left: tcomettopicpnl;
  pbrowse: precord_pannello_browse_chat;
begin
  try


    panel_left := (sender as tcomettopicpnl);
    pbrowse := precord_pannello_browse_chat(panel_left.tag);

    if pbrowse^.treeview = nil then exit;
    with pbrowse^ do begin
  //treeview.width:=panel_left.clientwidth;
  //treeview2.width:= treeview.width;
      treeview.height := panel_left.clientheight - 26;
      treeview2.height := treeview.height;
    end;

  except
    exit;
  end;
end;

procedure tares_frmmain.btn_chatbrowse_regular_viewclick(Sender: TObject);
var
  nodo: PCmtVNode;
  pbrowse: precord_pannello_browse_chat;
  btn_regular_view_browse: TXPButton;
begin
  btn_regular_view_browse := (sender as txpbutton);
  pbrowse := precord_pannello_browse_chat(btn_regular_view_browse.tag);
  with pbrowse^ do begin
    btn_regular_view.down := true;
    btn_virtual_view.down := false;

    treeview2.visible := true;
    treeview.visible := false;

    if treeview2.getfirstselected = nil then begin
      nodo := treeview2.GetFirst;
      treeview2.selected[nodo] := true;
      treeviewbrowse2Click(treeview2);
    end else treeviewbrowse2Click(treeview2);
  end;
end;

procedure tares_frmmain.btn_chatbrowse_virtual_viewclick(Sender: TObject);
var
  nodo: PCmtVNode;
  pbrowse: precord_pannello_browse_chat;
  btn_virtual_view_browse: TXPButton;
begin
  btn_virtual_view_browse := (sender as txpbutton);
  pbrowse := precord_pannello_browse_chat(btn_virtual_view_browse.tag);
  with pbrowse^ do begin
    btn_regular_view.down := false;
    btn_virtual_view.down := true;

    treeview.visible := true;
    treeview2.visible := false;

    if treeview.getfirstselected = nil then begin
      nodo := treeview.GetFirst;
      treeview.selected[nodo] := true;
      treeviewbrowseClick(treeview);
    end else treeviewbrowseClick(treeview);
  end;

end;

procedure Tares_frmmain.treeviewbrowse2Click(Sender: TObject); //regular folders
begin
  if sender = nil then exit;
  toggle_regularchatfolderbrowse_click(sender);
end;

procedure Tares_frmmain.treeviewbrowseClick(Sender: TObject);
var
  level: integer;
  node: PCmtVNode;
  treeview: tcomettree;
  pannello_browse: precord_pannello_browse_chat;
begin
  if sender = nil then exit;
  try

    treeview := (sender as tcomettree);
    pannello_browse := precord_pannello_browse_chat(treeview.tag);


    node := treeview.getfirstselected;
    if node = nil then exit;

    level := pannello_browse^.treeview.getnodelevel(node);

    if level = 0 then begin
      pannello_browse^.stato_header_library := helper_visual_headers.header_library_show(chr(67) + chr(104) + chr(97) + chr(116) + chr(82) + chr(111) + chr(111) + chr(109) + chr(66) + chr(114) + chr(111) + chr(119) + chr(115) + chr(101) {'ChatRoomBrowse'}, chr(67) + chr(104) + chr(97) + chr(116) + chr(82) + chr(111) + chr(111) + chr(109) + chr(66) + chr(114) + chr(111) + chr(119) + chr(115) + chr(101) {'ChatRoomBrowse'}, pannello_browse^.listview, '', CAT_YOUR_LIBRARY, CAT_NOGROUP);
      apri_general_library_virtual_view(false, pannello_browse^.lista_files, pannello_browse^.listview, imagelist_lib_max);
      exit;
    end else begin
      pannello_browse^.stato_header_library := apri_categoria_library(chr(67) + chr(104) + chr(97) + chr(116) + chr(82) + chr(111) + chr(111) + chr(109) + chr(66) + chr(114) + chr(111) + chr(119) + chr(115) + chr(101) {'ChatRoomBrowse'}, chr(67) + chr(104) + chr(97) + chr(116) + chr(82) + chr(111) + chr(111) + chr(109) + chr(66) + chr(114) + chr(111) + chr(119) + chr(115) + chr(101) {'ChatRoomBrowse'}, pannello_browse^.treeview, pannello_browse^.listview, pannello_browse^.lista_files, level, node);
      if pannello_browse^.listview.Header.sortcolumn <> -1 then pannello_browse^.listview.Sort(nil, pannello_browse^.listview.Header.sortcolumn, pannello_browse^.listview.Header.sortdirection);
    end;
  except
  end;
end;



procedure Tares_frmmain.Download2Click(Sender: TObject);
var
  pannello_ricerca: precord_pannello_result_chat;
  pnl: TCometPagePanel;
begin

  pnl := ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
  if pnl.ID <> IDXChatSearch then exit;
  pannello_ricerca := pnl.fdata;

  result_chat_add_download(pannello_ricerca^.listview);


end;


procedure Tares_frmmain.popup_chat_searchPopup(Sender: TObject);
begin
  mainGui_popup_searchresult_event;
end;

procedure Tares_frmmain.Ban2Click(Sender: TObject);
begin
  mainGui_banevent_fromsearch;
end;

procedure Tares_frmmain.Kill1Click(Sender: TObject);
begin
  mainGui_killevent_fromsearch;
end;

procedure Tares_frmmain.listview_chat_channelCollapsed(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  sender.invalidate;
end;

procedure Tares_frmmain.listview_libPaintText(Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
var
  data: precord_file_library;

begin
  data := sender.getdata(node);
  if (vsselected in node.states) then targetcanvas.font.color := clhighlighttext else begin
    if data^.previewing then targetcanvas.font.color := COLORE_LISTVIEWS_FONTALT1
    else targetcanvas.Font.color := COLORE_LISTVIEWS_FONT;
  end;
end;

procedure Tares_frmmain.GrantSlot1Click(Sender: TObject);
var
  node: PCmtVNode;
  data: precord_queued;
begin
  try

    node := treeview_queue.getfirstselected;
    if node = nil then exit;
    data := treeview_queue.getdata(node);

    ip_user_granted := data^.ip;
    port_user_granted := data^.port;
    ip_alt_granted := data^.ip_alt;

  except
  end;
end;

procedure Tares_frmmain.Grantupslot1Click(Sender: TObject);
var
  Data: precord_displayed_chat_user;
  pcanale: precord_canale_chat_visual;
  nodo: PCmtVNode;
  pnl: TcometPagePanel;
begin
  try

    pnl := panel_chat.Panels[panel_chat.activePage];
    pcanale := pnl.fdata;

    if not pcanale^.support_files then exit;

    nodo := pcanale^.listview.GetFirstSelected;
    if nodo = nil then exit;
    data := pcanale^.listview.getdata(nodo);

    ip_user_granted := data^.ip;
    port_user_granted := data^.port;
    ip_alt_granted := data^.ip_alt;

  except
  end;
end;

procedure Tares_frmmain.treeview_downloadMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  punto: tpoint;
  hitinfo: comettrees.thitinfo;
  hnd: hwnd;
begin
  if (sender as tcomettree).rootnodecount = 0 then begin
    formhint_hide;
    exit;
  end;

  getcursorpos(punto);
  punto := (sender as tcomettree).screentoclient(punto);

  (sender as tcomettree).GetHitTestInfoAt(punto.x, punto.y, true, hitinfo);

  if hitinfo.hitnode = nil then begin
    formhint_hide;
    exit;
  end;

  if not (hiOnItemLabel in HitInfo.HitPositions) then begin
    formhint_hide;
    exit;
  end;

  hnd := GetForegroundWindow;
  if hnd <> self.handle then
    if hnd <> formhint.handle then begin
      formhint_hide;
      exit;
    end;

end;

procedure Tares_frmmain.All1Click(Sender: TObject);
begin
  browse_type := ARES_MIME_OTHER;
  mainGui_chatoomBrowse_event;
end;

procedure Tares_frmmain.Audio1Click(Sender: TObject);
begin
  browse_type := ARES_MIME_MP3;
  mainGui_chatoomBrowse_event;
end;

procedure Tares_frmmain.Video1Click(Sender: TObject);
begin
  browse_type := ARES_MIME_VIDEO;
  mainGui_chatoomBrowse_event;
end;

procedure Tares_frmmain.Image1Click(Sender: TObject);
begin
  browse_type := ARES_MIME_IMAGE;
  mainGui_chatoomBrowse_event;
end;

procedure Tares_frmmain.Document1Click(Sender: TObject);
begin
  browse_type := ARES_MIME_DOCUMENT;
  mainGui_chatoomBrowse_event;
end;

procedure Tares_frmmain.Software1Click(Sender: TObject);
begin
  browse_type := ARES_MIME_SOFTWARE;
  mainGui_chatoomBrowse_event;
end;


procedure Tares_frmmain.Download3Click(Sender: TObject); //download folder from chatroom panel browse
begin
  mainGui_chat_dl_virfolder;
end;

procedure Tares_frmmain.Download4Click(Sender: TObject);
begin
  mainGui_chat_dl_browsedfile;
end;


procedure Tares_frmmain.Artist4Click(Sender: TObject);
begin
  mainGui_findartist_frombrowse;
end;

procedure Tares_frmmain.Genre4Click(Sender: TObject);
begin
  mainGui_findgenre_frombrowse;
end;

procedure Tares_frmmain.popup_chat_browsePopup(Sender: TObject);
var
  pcanale: precord_canale_chat_visual;
  pnl: TCometPagePanel;
  pannello_browse: precord_pannello_browse_chat;
begin

  N18.visible := false;
  Ban3.visible := false;
  Kill2.visible := false;
  N14.Visible := Findmoreofthesame1.visible;

  pnl := ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activePage];
  if pnl.ID <> IDXChatBrowse then exit;
  pannello_browse := pnl.fdata;

  pcanale := pannello_browse^.canale;
  if pcanale = nil then begin
    N18.visible := false;
    Ban3.visible := false;
    Kill2.visible := false;
    SendPrivate2.visible := false;
    exit;
  end;


  N18.visible := pcanale^.ModLevel;
  Ban3.visible := pcanale^.ModLevel;
  Kill2.visible := pcanale^.ModLevel;
  SendPrivate2.visible := true;

end;

procedure Tares_frmmain.Ban3Click(Sender: TObject);
begin
  mainGui_banevent_frombrowse;
end;

procedure Tares_frmmain.Kill2Click(Sender: TObject);
begin
  mainGui_killevent_frombrowse;
end;

procedure Tares_frmmain.Sendprivate1Click(Sender: TObject);
begin
  mainGui_sendprivate_fromresult;
end;

procedure Tares_frmmain.Chat4Click(Sender: TObject);
begin
  mainGui_chat_fromresult;
end;

procedure Tares_frmmain.All2Click(Sender: TObject);
begin
  browse_type := ARES_MIME_OTHER;
  result_chat_dobrowse;
end;

procedure Tares_frmmain.Audio2Click(Sender: TObject);
begin
  browse_type := ARES_MIME_MP3;
  result_chat_dobrowse;
end;

procedure Tares_frmmain.Video2Click(Sender: TObject);
begin
  browse_type := ARES_MIME_VIDEO;
  result_chat_dobrowse;
end;

procedure Tares_frmmain.Image3Click(Sender: TObject);
begin
  browse_type := ARES_MIME_IMAGE;
  result_chat_dobrowse;
end;

procedure Tares_frmmain.Document2Click(Sender: TObject);
begin
  browse_type := ARES_MIME_DOCUMENT;
  result_chat_dobrowse;
end;

procedure Tares_frmmain.Software2Click(Sender: TObject);
begin
  browse_type := ARES_MIME_SOFTWARE;
  result_chat_dobrowse;
end;

procedure Tares_frmmain.Chat5Click(Sender: TObject);
begin
  mainGui_chat_frombrowse;
end;

procedure Tares_frmmain.SendPrivate2Click(Sender: TObject);
begin
  mainGui_sendprivate_frombrowse;
end;

procedure Tares_frmmain.ExportHashlink2Click(Sender: TObject);
begin
  export_hashlink_fromchatroombrowse;
end;

procedure Tares_frmmain.ExportHashlink3Click(Sender: TObject);
begin
  export_hashlink_fromchatroomresult;
end;

procedure Tares_frmmain.treeview_lib_regfoldersMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  nodo: PCmtVNode;
  level: integer;
  punto: tpoint;
  data: ares_types.precord_cartella_share;
begin
  if treeview_lib_regfolders.rootnodecount = 0 then exit;
  if button <> mbright then exit;

  nodo := treeview_lib_regfolders.getfirstselected;
  if nodo = nil then exit;

  level := treeview_lib_regfolders.getnodelevel(nodo);
  if level = 0 then exit;
  data := treeview_lib_regfolders.getdata(nodo);
  AddtoPlaylist5.visible := (data^.items > 0);

  getcursorpos(punto);
  popup_lib_regfolders.popup(punto.x, punto.y);
end;

procedure Tares_frmmain.AddtoPlaylist5Click(Sender: TObject);
var
  nodo: PCmtVNode;
  level: integer;
  pfile: precord_file_library;
  data: ares_types.precord_cartella_share;
  i: integer;
begin
  if treeview_lib_regfolders.rootnodecount = 0 then exit;

  nodo := treeview_lib_regfolders.getfirstselected;
  if nodo = nil then exit;

  level := treeview_lib_regfolders.getnodelevel(nodo);
  if level = 0 then exit;

  data := treeview_lib_regfolders.getdata(nodo);
  if data^.items = 0 then exit;


  for i := 0 to lista_shared.count - 1 do begin
    pfile := lista_shared[i];
    if pfile^.folder_id <> data^.id then continue;
    if pfile^.amime <> ARES_MIME_MP3 then
      if pfile^.amime <> ARES_MIME_VIDEO then continue;
    playlist_addfile(pfile^.path, pfile^.param3, false, '');
  end;

end;

procedure tares_frmmain.WMUserShow(var msg: tmessage);
begin
  if widestrtoutf8str(tray_minimize.caption) = GetLangStringA(STR_HIDE_ARES) then exit;
  tray_MinimizeClick(nil);
end;

procedure Tares_frmmain.btn_lib_regular_viewClick(Sender: TObject);
var
  nodo: PCmtVNode;
begin
  btn_lib_regular_view.down := true;
  btn_lib_virtual_view.Down := false;

  treeview_lib_regfolders.visible := true;
  treeview_lib_virfolders.visible := false;

  listview_lib.clear;
  details_library_toggle(false);
  if treeview_lib_regfolders.getfirstselected = nil then begin
    nodo := treeview_lib_regfolders.GetFirst;
    treeview_lib_regfolders.selected[nodo] := true;
    treeview_lib_regfoldersClick(treeview_lib_regfolders);
  end else treeview_lib_regfoldersClick(treeview_lib_regfolders);


  set_reginteger('General.LastLibraryMode', 1);
end;

procedure Tares_frmmain.OpenFolder1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  level: integer;
  data: ares_types.precord_cartella_share;
begin
  if treeview_lib_regfolders.rootnodecount = 0 then exit;

  nodo := treeview_lib_regfolders.getfirstselected;
  if nodo = nil then exit;

  level := treeview_lib_regfolders.getnodelevel(nodo);
  if level = 0 then exit;
  data := treeview_lib_regfolders.getdata(nodo);
  open_file_external(data^.path + chr(92) {'\'});
end;

procedure Tares_frmmain.Download5Click(Sender: TObject);
begin
  mainGui_chat_dl_regfolder;
end;

procedure Tares_frmmain.ClearScreen1Click(Sender: TObject);
begin
  mainGui_ClearChatroomScreen;
end;

procedure Tares_frmmain.treeview_downloadDblClick(Sender: TObject);
var
  punto: tpoint;
begin
  getcursorpos(punto);
  punto := treeview_download.screentoclient(punto);
  if punto.x < 30 then exit;
  OpenPreview1Click(nil);
end;

procedure Tares_frmmain.panel_searchDrawHeaderBody(sender: TObject; TargetCanvas: TCanvas; aRect: TRect; HeaderColor: TColor);
//var
//Details: TThemedElementDetails;
begin
{ if ((ThemeServices.ThemesEnabled) and (VARS_THEMED_PANELS)) then begin
  Details := ThemeServices.GetElementDetails(thHeaderItemNormal);
  ThemeServices.DrawElement(TargetCanvas.Handle, Details, aRect, @aRect);
 end else begin }
  with targetcanvas do begin
    if sender = panel_playlist then begin
      brush.Color := cl3ddkshadow;
      fillrect(rect(arect.left, arect.top, arect.right, arect.top + 1));
      fillrect(rect(arect.Left, arect.top, arect.left + 1, arect.bottom));
    end;
  end;
// end;
end;

procedure Tares_frmmain.label_back_srcMouseEnter(Sender: TObject);
var
  labels: ttntlabel;
begin
  labels := sender as ttntlabel;
  labels.Font.color := clhotlight;
end;

procedure Tares_frmmain.label_back_srcMouseLeave(Sender: TObject);
var
  labels: ttntlabel;
begin
  labels := sender as ttntlabel;
  labels.Font.color := clWindowText;
end;

procedure Tares_frmmain.panel_details_libraryAfterDraw(Sender: TObject; TargetCanvas: TCanvas);
begin
  ImageList_lib_max.draw(targetcanvas, 12, 32, last_index_icona_details_library);
end;

procedure Tares_frmmain.panel_searchDraw(sender: TObject; Acanvas: TCanvas; capt: widestring; var should_continue: boolean);
//var
//Details: TThemedElementDetails;
//rec:trect;
begin

 //if ((not ThemeServices.ThemesEnabled) or (not VARS_THEMED_BIGPANELS)) then begin
  if image_back_top <> -1 then imagelist_panel_search.draw(acanvas, 12, image_back_top, 1);
  if image_less_top <> -1 then imagelist_panel_search.draw(acanvas, 12, image_less_top, 0);
  if image_more_top <> -1 then imagelist_panel_search.draw(acanvas, 12, image_more_top, 2);
  should_continue := false;
{ end else begin
  if image_back_top<>-1 then begin
        with rec do begin
         left:=12;
         right:=31;
         top:=image_back_top;
         bottom:=top+19;
        end;
        Details := ThemeServices.GetElementDetails(tebNormalGroupCollapseNormal);
        ThemeServices.DrawElement(Targetcanvas.Handle, Details, Rec, @Rec);
  end;
  if image_less_top<>-1 then begin
        with rec do begin
         left:=12;
         right:=31;
         top:=image_less_top;
         bottom:=top+19;
        end;
        Details := ThemeServices.GetElementDetails(tebNormalGroupCollapseNormal);
        ThemeServices.DrawElement(Targetcanvas.Handle, Details, Rec, @Rec);
  end;
  if image_more_top<>-1 then begin
        with rec do begin
         left:=12;
         right:=31;
         top:=image_more_top;
         bottom:= top+19;
        end;
        Details := ThemeServices.GetElementDetails(tebNormalGroupExpandNormal);
        ThemeServices.DrawElement(Targetcanvas.Handle, Details, Rec, @Rec);
  end;
 end;}
end;

procedure Tares_frmmain.panel_searchMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin

  if ((y < 0) or (x > 31) or (x < 12)) then begin
    panel_search.cursor := crdefault;
    label_more_searchopt.Font.color := COLORE_FONT_SEARCHPNL;
    label_back_src.Font.color := COLORE_FONT_SEARCHPNL;
    exit;
  end;

  if ((image_back_top = -1) and
    (image_less_top = -1) and
    (image_more_top = -1)) then begin
    panel_search.cursor := crdefault;
    label_back_src.Font.color := COLORE_FONT_SEARCHPNL;
    label_more_searchopt.Font.color := COLORE_FONT_SEARCHPNL;
    exit;
  end;

  if ((x >= 12) and (x <= 31) and (y >= image_back_top) and (y <= image_back_top + 19)) then begin
    panel_search.cursor := crhandpoint;
    label_back_src.Font.color := clhotlight;
    label_more_searchopt.Font.color := COLORE_FONT_SEARCHPNL;
  end else
    if ((x >= 12) and (x <= 31) and (y >= image_less_top) and (y <= image_less_top + 19)) then begin
      panel_search.cursor := crhandpoint;
      label_back_src.Font.color := COLORE_FONT_SEARCHPNL;
      label_more_searchopt.Font.color := clhotlight;
    end else
      if ((x >= 12) and (x <= 31) and (y >= image_more_top) and (y <= image_more_top + 19)) then begin
        panel_search.cursor := crhandpoint;
        label_back_src.Font.color := COLORE_FONT_SEARCHPNL;
        label_more_searchopt.Font.color := clhotlight;
      end else begin
        panel_search.cursor := crdefault;
        label_more_searchopt.Font.color := COLORE_FONT_SEARCHPNL;
        label_back_src.Font.color := COLORE_FONT_SEARCHPNL;
      end;

end;

procedure Tares_frmmain.panel_searchMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if image_back_top <> -1 then begin
    if ((x >= 12) and (x <= 31) and (y >= image_back_top) and (y <= image_back_top + 19)) then label_back_srcClick(label_back_src);
  end;

  if image_less_top <> -1 then begin
    if ((x >= 12) and (x <= 31) and (y >= image_less_top) and (y <= image_less_top + 19)) then label_more_searchoptClick(label_more_searchopt);
  end;

  if image_more_top <> -1 then begin
    if ((x >= 12) and (x <= 31) and (y >= image_more_top) and (y <= image_more_top + 19)) then label_more_searchoptClick(label_more_searchopt);
  end;
end;

procedure Tares_frmmain.ExportHashlink4Click(Sender: TObject);
begin
  mainGui_exporthashlink_fromresult;
end;

procedure Tares_frmmain.treeview_lib_regfoldersExpanding(Sender: TBaseCometTree; Node: PCmtVNode; var Allowed: Boolean);
begin
  ares_FrmMain.treeview_lib_regfolders.sort(node, 0, sdAscending);
end;

procedure Tares_frmmain.DownloadHashLink1Click(Sender: TObject);
begin
  download_hashlink_frommemo;
end;

procedure Tares_frmmain.Disconnect1Click(Sender: TObject);
var
  reg: tregistry;
begin
  if btn_opt_disconnect.down then exit;

  reg := tregistry.create; //when user is messin with this we may want to reset some antiflood countermeasures
  with reg do begin
    openkey(areskey, true);
    writeinteger('Stats.LstCaQueryInt', MIN_INTERVAL_QUERY_CACHE_ROOT); //minimum amount of time between queries
    writeinteger('Stats.LstCaQuery', 0); //reset antiflood on gwebcache
    closekey;
    destroy;
  end;


  btn_opt_disconnect.down := true;
  btn_opt_connect.Down := false;
  logon_time := 0;
  lbl_opt_statusconn.caption := ' ' + GetLangStringW(STR_NOT_CONNECTED);

end;

procedure Tares_frmmain.Connect1Click(Sender: TObject);
begin
  if btn_opt_connect.down then exit;

  btn_opt_connect.down := true;
  btn_opt_disconnect.Down := false;
  logon_time := 0;
  lbl_opt_statusconn.caption := ' ' + GetLangStringW(STR_CONNECTING_TO_NETWORK);
end;

procedure Tares_frmmain.btn_shareset_cancelClick(Sender: TObject);
begin
  cambiato_manual_folder_share := false;
  mfolder.clear;

  stop_autoscan_folder;

  cambiato_setting_autoscan := false;
  chklstbx_shareset_auto.Items.clear;

  btn_shareset_atuostart.enabled := true;
  btn_shareset_atuostop.enabled := false;
  btn_shareset_atuocheckall.enabled := false;
  btn_shareset_atuoUncheckall.enabled := false;
  lbl_shareset_auto.caption := ' ' + GetLangStringW(STR_HIT_START_TOBEGIN);
  progbar_shareset_auto.Position := 0;

  settings_control.activePage := 0;
//btn_lib_settings.onclick:=btn_lib_settingsClick;
end;

procedure Tares_frmmain.btn_shareset_okClick(Sender: TObject);
begin
  stop_autoscan_folder;

  if cambiato_manual_folder_share then begin
    mfolder_savecheckstodisk;
    set_reginteger('Share.EverConfigured', 1);
    crea_thread_share;
  end else
    if cambiato_setting_autoscan then begin
      cambiato_setting_autoscan := false;
      write_prefs_autoscan;
      set_reginteger('Share.EverConfigured', 1);
      crea_thread_share;
    end;

  cambiato_manual_folder_share := false;
  mfolder.clear;
  cambiato_setting_autoscan := false;
  chklstbx_shareset_auto.Items.clear;
  btn_shareset_atuostart.enabled := true;
  btn_shareset_atuostop.enabled := false;
  btn_shareset_atuocheckall.enabled := false;
  btn_shareset_atuoUncheckall.enabled := false;
  lbl_shareset_auto.caption := ' ' + GetLangStringW(STR_HIT_START_TOBEGIN);
  progbar_shareset_auto.Position := 0;

  settings_control.activePage := 0;
// btn_lib_settings.onclick:=btn_lib_settingsClick;
end;



procedure tares_frmmain.crea_thread_share;
var
  paused: boolean;
begin
  try
    if vars_global.share <> nil then begin
      vars_global.need_rescan := true;
      vars_global.share.terminate;
    end else begin

      paused := set_NEWtrusted_metas;

      vars_global.scan_start_time := gettickcount;
      vars_global.share := tthread_share.create(true);
      vars_global.share.paused := paused;
      vars_global.share.juststarted := false;
      vars_global.share.resume;
    end;
  except
  end;
end;

procedure Tares_frmmain.pnl_opt_sharingResize(Sender: TObject);
begin
  with lbl_shareset_hint do begin
    Width := btns_library.clientwidth - left;
    autosize := false;
    autosize := true;
    pgctrl_shareset.Top := 0; //top+Height+5;
  end;

  btn_shareset_ok.Top := (pnl_opt_sharing.clientheight - btn_shareset_ok.height) - 10;
  btn_shareset_cancel.Top := btn_shareset_ok.Top;
  btn_shareset_ok.left := pnl_opt_sharing.clientwidth - 100;
  btn_shareset_cancel.Left := (pnl_opt_sharing.clientwidth - btn_shareset_cancel.width) - 10;
  btn_shareset_ok.left := (btn_shareset_cancel.Left - btn_shareset_cancel.width) - 10;

  lbl_shareset_hint.width := pnl_opt_sharing.clientwidth - lbl_shareset_hint.left;

  with pgctrl_shareset do begin
    Width := pnl_opt_sharing.clientwidth;
    height := (btn_shareset_ok.Top - top) - 10;
  end;
end;



procedure Tares_frmmain.mfolderCompareNodes(Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex; var Result: Integer);
var
  data1, data2: ares_types.precord_mfolder;
begin
  data1 := sender.getdata(node1);
  data2 := sender.getdata(node2);
  result := comparetext(widestrtoutf8str(extract_fnameW(utf8strtowidestr(data1^.path))), widestrtoutf8str(extract_fnameW(utf8strtowidestr(data2^.path))));
end;

procedure Tares_frmmain.mfolderExpanding(Sender: TBaseCometTree; Node: PCmtVNode; var Allowed: Boolean);
begin
  allowed := true;
  screen.cursor := crhourglass;
  mfolder_EnumerateFolder(node);
  screen.cursor := crdefault;
end;

procedure Tares_frmmain.mfolderGetImageIndex(Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
var
  level: integer;
  data: ares_types.precord_mfolder;
begin
  if not (vsSelected in node.states) then begin

    data := sender.getdata(node);
    level := mfolder.getnodelevel(node);
    case level of
      0: imageindex := WORKSTATION_ICON;
      1: begin
          if data^.drivetype = DRIVE_CDROM then ImageIndex := CDROM_ICON + data^.stato
          else begin
            if data^.drivetype = DRIVE_REMOTE then imageindex := NETWORK_ICON + data^.stato
            else Imageindex := DRIVE_ICON + data^.stato;
          end;
        end else begin
        if vsExpanded in node.States then imageindex := FOLDER_SELECTED + data^.stato
        else Imageindex := FOLDER_NORMAL + data^.stato;
      end;
    end;
    exit;
  end;

  data := sender.getdata(node);
  level := mfolder.getnodelevel(node);
  case level of
    0: Imageindex := WORKSTATION_ICON;
    1: begin
        if data^.drivetype = DRIVE_CDROM then ImageIndex := CDROM_ICON + data^.stato else
          if data^.drivetype = DRIVE_REMOTE then imageindex := NETWORK_ICON + data^.stato
          else Imageindex := DRIVE_ICON + data^.stato;
      end else begin
      if vsExpanded in node.States then imageindex := FOLDER_SELECTED + data^.stato
      else Imageindex := FOLDER_NORMAL + data^.stato;
    end;
  end;
end;

procedure Tares_frmmain.mfolderFreeNode(Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_mfolder(sender, node);
end;

procedure Tares_frmmain.mfolderGetSize(Sender: TBaseCometTree; var Size: Integer);
begin
  size := sizeof(ares_types.record_mfolder);
end;

procedure Tares_frmmain.mfolderGetText(Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex; var CellText: WideString);
var
  data: ares_types.precord_mfolder;
  level: integer;
begin

  data := mfolder.getdata(node);

  level := mfolder.getnodelevel(node);

  if level = 0 then celltext := 'My computer' else
    if level = 1 then begin
      if data^.drivetype = DRIVE_CDROM then celltext := 'CDRom ' + utf8strtowidestr(data^.path) else
        if data^.drivetype = DRIVE_REMOVABLE then celltext := 'Floppy ' + utf8strtowidestr(data^.path) else
          if data^.drivetype = DRIVE_FIXED then celltext := 'Local Drive ' + utf8strtowidestr(data^.path) else
            if data^.drivetype = DRIVE_REMOTE then celltext := 'Network Drive ' + utf8strtowidestr(data^.path) else
              celltext := 'Drive ' + utf8strtowidestr(data^.path);
    end else celltext := extract_fnameW(utf8strtowidestr(data^.path));
end;

procedure Tares_frmmain.mfolderClick(Sender: TObject);
var
  punto: tpoint;
  hitinfo: THitinfo;
begin
  try
    getcursorpos(punto);
    punto := mfolder.screentoclient(punto);

    mfolder.GetHitTestInfoAt(punto.x, punto.y, true, hitinfo);

    if hitinfo.hitnode = nil then exit;

    if mfolder.getnodelevel(hitinfo.hitnode) < 1 then exit;


    if ((hiOnNormalIcon in hitinfo.HitPositions) or
      (hiOnStateIcon in hitinfo.HitPositions)) then begin
      mfolder_proofstates(hitinfo.hitnode);
    end;
  except
  end;
end;

procedure Tares_frmmain.tabsheet_shareset_manuResize(Sender: TObject);
begin
  lbl_shareset_manuhint.width := pnl_shareset_manual.clientwidth - 16;
  mfolder.width := pnl_shareset_manual.clientwidth - 8;
  grpbx_shareset_manuhint.width := pnl_shareset_manual.clientwidth - 8;
  grpbx_shareset_manuhint.top := (pnl_shareset_manual.clientheight - grpbx_shareset_manuhint.height) - 5;
  mfolder.height := (grpbx_shareset_manuhint.top - mfolder.top) - 3;
  lbl_shareset_manuhint1.width := grpbx_shareset_manuhint.clientwidth - lbl_shareset_manuhint1.left - 4;
  lbl_shareset_manuhint2.width := lbl_shareset_manuhint1.width;
end;

procedure Tares_frmmain.btn_shareset_atuostopClick(Sender: TObject);
begin
  stop_autoscan_folder;
end;

procedure Tares_frmmain.btn_shareset_atuocheckallClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to chklstbx_shareset_auto.items.count - 1 do chklstbx_shareset_auto.Checked[i] := true;
  cambiato_setting_autoscan := true;
end;

procedure Tares_frmmain.btn_shareset_atuoUncheckallClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to chklstbx_shareset_auto.items.count - 1 do chklstbx_shareset_auto.Checked[i] := false;
  cambiato_setting_autoscan := true;
end;

procedure Tares_frmmain.btn_shareset_atuostartClick(Sender: TObject);
begin
  cambiato_setting_autoscan := true;
  lbl_shareset_auto.caption := GetLangStringW(STR_SCAN_IN_PROGRESS);
  start_autoscan_folder;
end;

procedure Tares_frmmain.chklstbx_shareset_autoDblClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to chklstbx_shareset_auto.items.count - 1 do
    if chklstbx_shareset_auto.Selected[i] then begin

      Tnt_ShellExecuteW(handle, 'open', pwidechar(utf8strtowidestr(hexstr_to_bytestr(chklstbx_shareset_auto.Items[i])) + '\'), '', '', SW_SHOWNORMAL);
      break;
    end;
end;

procedure tares_frmmain.thread_autoscan_end(var msg: tmessage);
begin
  try
    if search_dir <> nil then begin
      search_dir.waitfor;
      search_dir.free;
    end;
  except
  end;

  search_dir := nil;

  if want_stop_autoscan then begin
    want_stop_autoscan := false;
    chklstbx_shareset_auto.Items.clear;
    lbl_shareset_auto.caption := ' ' + GetLangStringW(STR_HIT_START_TOBEGIN);
    progbar_shareset_auto.Position := 0;
  end;

end;

procedure Tares_frmmain.chklstbx_shareset_autoClick(Sender: TObject);
begin
  cambiato_setting_autoscan := true;
end;

procedure Tares_frmmain.tabsheet_shareset_autoResize(Sender: TObject);
begin
  pnl_shareset_auto.width := pnl_shareset_autoscan.clientwidth - 16;
  progbar_shareset_auto.width := pnl_shareset_autoscan.clientwidth - 16;
  chklstbx_shareset_auto.width := pnl_shareset_autoscan.clientwidth - 16;
  lbl_shareset_auto.width := pnl_shareset_auto.clientwidth - 8;
  btn_shareset_atuostart.top := (pnl_shareset_autoscan.clientheight - btn_shareset_atuostart.height) - 5;
  btn_shareset_atuostop.top := btn_shareset_atuostart.top;
  btn_shareset_atuocheckall.top := btn_shareset_atuostart.top;
  btn_shareset_atuoUncheckall.top := btn_shareset_atuostart.top;
  chklstbx_shareset_auto.height := (btn_shareset_atuostart.top - chklstbx_shareset_auto.top) - 4;
end;

procedure Tares_frmmain.chklstbx_shareset_autoDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  checklistbox: TCheckListBox;
  Flags: Longint;
  widstr: widestring;
begin
  checklistbox := control as TCheckListBox;


  with checklistbox.canvas do begin
    FillRect(Rect);
    font.name := ares_frmmain.font.name;
    font.size := ares_frmmain.font.size;
    if (odSelected in state) then font.color := $00FEFFFF else
      font.color := COLORE_LISTVIEWS_FONT;

    if Index < checklistbox.Items.Count then begin
      Flags := checklistbox.DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER);
      if not checklistbox.UseRightToLeftAlignment then Inc(Rect.Left, 2) else
        Dec(Rect.Right, 2);
      widstr := utf8strtowidestr(hexstr_to_bytestr(checklistbox.Items[Index]));
      DrawTextW(Handle, PwideChar(widstr), Length(widstr), Rect, Flags, false);
    end;
  end;

end;

procedure Tares_frmmain.btn_opt_tran_chshfoldClick(Sender: TObject);
begin
  try
    fold.FolderName := vars_global.myshared_folder;
    if not Fold.execute then exit;

    if direxistsW(fold.foldername) then begin
      vars_global.myshared_folder := fold.foldername;
      edit_opt_tran_shfolder.text := vars_global.myshared_folder;
      getfreedrivespace;

      set_regstring('Download.Folder', bytestr_to_hexstr(widestrtoutf8str(vars_global.myshared_folder)));
    end;

  except
  end;
end;

procedure Tares_frmmain.btn_opt_tran_defshfoldClick(Sender: TObject);
begin
  try
    tntwindows.Tnt_createdirectoryW(pwidechar(data_path + '\' + STR_MYSHAREDFOLDER), nil);
    vars_global.myshared_folder := data_path + '\' + STR_MYSHAREDFOLDER;
    edit_opt_tran_shfolder.text := vars_global.myshared_folder;
    getfreedrivespace;

    set_regstring('Download.Folder', bytestr_to_hexstr(widestrtoutf8str(vars_global.myshared_folder)));
  except
  end;
end;

procedure Tares_frmmain.btn_opt_chat_fontClick(Sender: TObject);
var
  reg: tregistry;
begin
  if not FontDialog1.execute then exit;

  fontdialog1.font.style := [];
  if fontdialog1.font.size > 12 then fontdialog1.font.size := 12;

  btn_opt_chat_font.font.name := FontDialog1.font.name;
  btn_opt_chat_font.font.size := FontDialog1.font.size;

  if ((font_chat.size <> btn_opt_chat_font.font.size) or
    (font_chat.name <> btn_opt_chat_font.font.name)) then begin
    font_chat.name := btn_opt_chat_font.font.name;
    font_chat.size := btn_opt_chat_font.font.size;
    reg := tregistry.create;
    with reg do begin
      openkey(areskey, true);
      Writestring('ChatRoom.FontName', btn_opt_chat_font.font.name);
      Writeinteger('ChatRoom.FontSize', btn_opt_chat_font.font.size);
      closekey;
      destroy;
    end;
    mainGui_applychatfont;
  end;
end;

procedure Tares_frmmain.Check_opt_chat_isawayClick(Sender: TObject);
begin
  memo_opt_chat_away.enabled := check_opt_chat_isaway.checked;
  set_reginteger('PrivateMessage.SetAway', integer(check_opt_chat_isaway.checked));
end;

procedure Tares_frmmain.btn_opt_proxy_checkClick(Sender: TObject);
begin
  lbl_opt_proxy_check.caption := GetLangStringW(STR_CHECKPROXY_TESTING);
  btn_opt_proxy_check.enabled := false;
  radiobtn_noproxy.enabled := false;
  radiobtn_proxy4.enabled := false;
  radiobtn_proxy5.enabled := false;
  Edit_opt_proxy_addr.Enabled := false;
  edit_opt_proxy_login.Enabled := false;
  edit_opt_proxy_pass.Enabled := false;
  tthread_checkproxy.create(false);
end;

procedure Tares_frmmain.radiobtn_noproxyClick(Sender: TObject);
var
  reg: tregistry;
begin

  lbl_opt_proxy_addr.enabled := not radiobtn_noproxy.checked;
  lbl_opt_proxy_login.enabled := lbl_opt_proxy_addr.enabled;
  lbl_opt_proxy_pass.enabled := lbl_opt_proxy_addr.enabled;
  Edit_opt_proxy_addr.enabled := lbl_opt_proxy_addr.enabled;
  edit_opt_proxy_login.enabled := lbl_opt_proxy_addr.enabled;
  edit_opt_proxy_pass.enabled := lbl_opt_proxy_addr.enabled;

  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);

    if radiobtn_noproxy.checked then begin
      vars_global.socks_type := SoctNone;
      writeinteger('Proxy.Protocol', 0);
    end else
      if radiobtn_proxy4.checked then begin
        vars_global.socks_type := SoctSock4;
        writeinteger('Proxy.Protocol', 4);
      end else begin
        vars_global.socks_type := SoctSock5;
        writeinteger('Proxy.Protocol', 5);
      end;

    closekey;
    destroy;
  end;

end;

procedure Tares_frmmain.edit_opt_proxy_loginChange(Sender: TObject);
begin
  vars_global.socks_username := edit_opt_proxy_login.text;
  set_regstring('Proxy.Username', bytestr_to_hexstr(widestrtoutf8str(vars_global.socks_username)));
end;

procedure Tares_frmmain.edit_opt_proxy_passChange(Sender: TObject);
begin
  vars_global.socks_password := edit_opt_proxy_pass.text;
  set_regstring('Proxy.Password', bytestr_to_hexstr(widestrtoutf8str(vars_global.socks_password)));
end;

procedure Tares_frmmain.check_opt_net_nosprnodeClick(Sender: TObject);
begin
  set_reginteger('Network.NoSupernode', integer(check_opt_net_nosprnode.checked));
end;

procedure Tares_frmmain.check_opt_hlink_magnetClick(Sender: TObject);
begin
  reg_toggle_magnetassoc;
end;

procedure Tares_frmmain.Check_opt_hlink_filterexeClick(Sender: TObject);
begin
  set_reginteger('Search.BlockExe', integer(Check_opt_hlink_filterexe.checked));
end;

procedure Tares_frmmain.Combo_opt_gen_gui_langClick(Sender: TObject);
begin


  set_regstring('General.Language', bytestr_to_hexstr(widestrtoutf8str(Combo_opt_gen_gui_lang.text)));


  localiz_loadlanguage;
  mainGui_apply_language;

  if combo_search.Items.count > 1 then combo_search.items.strings[0] := GetLangStringW(PURGE_SEARCH_STR);
  if combo_chat_search.Items.count > 1 then combo_chat_search.items.strings[0] := GetLangStringW(PURGE_SEARCH_STR);


end;

procedure Tares_frmmain.edit_opt_gen_nickChange(Sender: TObject);
begin
  vars_global.mynick := widestrtoutf8str(strippa_fastidiosi(edit_opt_gen_nick.text, chr(95) {'_'}));
  vars_global.update_my_nick := true;

  set_regstring('Personal.Nickname', bytestr_to_hexstr(vars_global.mynick));
end;

procedure Tares_frmmain.combo_opt_gen_speedClick(Sender: TObject);
begin
  vars_global.velocita_up_dec := napspeed_to_bytesec(combo_opt_gen_speed.itemindex);
  set_reginteger('Personal.ConnectionType', vars_global.velocita_up_dec);
end;

procedure Tares_frmmain.check_opt_gen_autostartClick(Sender: TObject);
begin
  reg_toggle_autostart;
end;

procedure Tares_frmmain.check_opt_gen_autoconnectClick(Sender: TObject);
begin
  set_reginteger('General.AutoConnect', integer(check_opt_gen_autoconnect.checked));
end;

procedure Tares_frmmain.check_opt_gen_gcloseClick(Sender: TObject);
begin
  set_reginteger('General.CloseOnQuery', integer(check_opt_gen_gclose.checked));
end;

procedure Tares_frmmain.check_opt_gen_nohintClick(Sender: TObject);
begin
  set_reginteger('Extra.BlockHints', integer(check_opt_gen_nohint.checked));
end;

procedure Tares_frmmain.check_opt_gen_pausevidClick(Sender: TObject);
begin
  set_reginteger('Extra.PauseVideoOnLeave', integer(check_opt_gen_pausevid.checked));
end;

procedure Tares_frmmain.check_opt_gen_captClick(Sender: TObject);
begin
  set_reginteger('Extra.ShowActiveCaption', integer(check_opt_gen_capt.checked));
  mainGUI_refresh_caption(true);
end;

procedure Tares_frmmain.Edit_dataportClick(Sender: TObject);
var
  porta_server: integer;
begin
  porta_server := strtointdef(Edit_opt_tran_port.text, 80);
  if ((porta_server < 1) or (porta_server > 65535)) then porta_server := 80;
  set_reginteger('Transfer.ServerPort', porta_server);
end;

procedure Tares_frmmain.Edit_opt_tran_limupChange(Sender: TObject);
begin
  vars_global.limite_upload := strtointdef(Edit_opt_tran_limup.text, 4);
  set_reginteger('Transfer.MaxUpCount', vars_global.limite_upload);
end;

procedure Tares_frmmain.Edit_opt_tran_upipChange(Sender: TObject);
begin
  vars_global.max_ul_per_ip := strtointdef(Edit_opt_tran_upip.text, 3);
  set_reginteger('Transfer.MaxUpPerUser', vars_global.max_ul_per_ip);
end;

procedure Tares_frmmain.Edit_opt_tran_limdnChange(Sender: TObject);
begin
  vars_global.max_dl_allowed := strtointdef(Edit_opt_tran_limdn.text, MAXNUM_ACTIVE_DOWNLOADS);
  set_reginteger('Transfer.MaxDlCount', vars_global.max_dl_allowed);
end;

procedure Tares_frmmain.Edit_opt_tran_upbandChange(Sender: TObject);
begin
  vars_global.up_band_allow := strtointdef(Edit_opt_tran_upband.text, 0);
  set_reginteger('Transfer.AllowedUpBand', vars_global.up_band_allow);
end;

procedure Tares_frmmain.check_opt_tran_inconidleClick(Sender: TObject);
begin
  set_reginteger('Transfer.MaximizeUpBandOnIdle', integer(check_opt_tran_inconidle.checked));
end;

procedure Tares_frmmain.Edit_opt_tran_dnbandChange(Sender: TObject);
begin
  vars_global.down_band_allow := strtointdef(Edit_opt_tran_dnband.text, 0);
  set_reginteger('Transfer.AllowedDownBand', vars_global.down_band_allow);
end;

procedure Tares_frmmain.check_opt_tran_warncancClick(Sender: TObject);
begin
  set_reginteger('Extra.WarnOnCancelDL', integer(check_opt_tran_warncanc.checked));
end;

procedure Tares_frmmain.check_opt_tran_percClick(Sender: TObject);
begin
  set_reginteger('Extra.ShowTransferPercent', integer(check_opt_tran_perc.checked));
end;

procedure Tares_frmmain.Check_opt_chat_timeClick(Sender: TObject);
begin
  set_reginteger('ChatRoom.ShowTimeLog', integer(Check_opt_chat_time.checked));
end;


procedure Tares_frmmain.Check_opt_chat_nopmClick(Sender: TObject);
begin
  set_reginteger('PrivateMessage.BlockAll', integer(Check_opt_chat_nopm.checked));
end;

procedure Tares_frmmain.check_opt_chat_browsableClick(Sender: TObject);
begin
  set_reginteger('PrivateMessage.AllowBrowse', integer(check_opt_chat_browsable.checked));
  check_opt_chat_realbrowse.enabled := check_opt_chat_browsable.checked;
end;

procedure Tares_frmmain.check_opt_chat_realbrowseClick(Sender: TObject);
begin
  set_reginteger('Privacy.SendRegularPath', integer(check_opt_chat_realbrowse.checked));
end;

procedure Tares_frmmain.Memo_opt_chat_awayChange(Sender: TObject);
begin
  set_regstring('PrivateMessage.AwayMessage', bytestr_to_hexstr(widestrtoutf8str(Memo_opt_chat_away.text)));
end;

procedure Tares_frmmain.N161DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
const
  CONVERTER: array[1..16] of tcolor = (clblack, clmaroon, clgreen, $0080FF, clnavy, clpurple, clteal, clgray, clsilver, clred, cllime, clyellow, clblue, clfuchsia, claqua, clwhite); //cl00feffff0
var
  ite: tmenuitem;
  colore: tcolor;
begin
  ite := sender as tmenuitem;
  colore := CONVERTER[strtointdef(ite.caption, 1)];

  with acanvas do begin
    brush.color := colore;
    if selected then begin
      pen.color := $00C080FF;
      rectangle(arect.left, arect.top, arect.Right, arect.bottom);
    end else begin
      pen.color := colore;
      rectangle(arect.left, arect.top, arect.Right, arect.bottom);
    end;
  end;

end;

procedure Tares_frmmain.N161MeasureItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);
begin
  width := 50;
  height := 20;
end;

procedure Tares_frmmain.N161Click(Sender: TObject);
const
  CONVERTER: array[1..16] of string = ('01', '05', '03', '07', '02', '06', '10', '14', '15', '04', '09', '08', '12', '13', '11', '00');
var
  ite: tmenuitem;
  str: string;
begin
  ite := sender as tmenuitem;

  str := CONVERTER[strtointdef(ite.caption, 1)];

  if vars_global.chat_buttons_wantbg then str := chr(53) {'5'} + str else str := chr(51) {'3'} + str;

  btn_chat_emocittrigger(chr(2) + str);
end;

procedure tares_frmmain.btn_toolbarchat_emoticonsclick(sender: tobject);
var
  punto: tpoint;
  curredit: ttntedit;
  pcanale: precord_canale_chat_visual;
  pvt_chat: precord_pvt_chat_visual;
  pnl: TCometPagePanel;
begin
  try
    curredit := nil;

    pnl := panel_chat.panels[panel_chat.activepage];
    if pnl.id <> IDXChatMain then exit;
    pcanale := pnl.FData;

    if pcanale^.containerPageview.activePage = 0 then begin
      curredit := pcanale^.edit_chat;
    end else begin
      pnl := pcanale^.containerPageview.panels[pcanale^.containerPageview.activePage];
      pvt_chat := pnl.FData;
      curredit := pvt_chat^.edit_chat;
    end;

    if curredit = nil then exit;

    getcursorpos(punto);
    dec(punto.Y, 123);
    dec(punto.x, 95);



    with Tfrmemoticon.create(application) do begin
      top := punto.y;
      lefT := punto.x;
      edit := curredit;
      memo := nil;
      show;
    end;

  except
  end;

end;

procedure tares_frmmain.btn_toolbarchat_backgroundclick(sender: tobject);
var
  punto: tpoint;
begin
  vars_global.chat_buttons_wantbg := true;
  getcursorpos(punto);
  with punto do begin
    dec(Y, 335);
    dec(x, 5);
    Popup_chat_emotic.popup(x, y);
  end;
end;

procedure tares_frmmain.btn_toolbarchat_textclick(sender: tobject);
var
  punto: tpoint;
begin
  vars_global.chat_buttons_wantbg := false;
  getcursorpos(punto);
  with punto do begin
    dec(Y, 335);
    dec(x, 5);
    Popup_chat_emotic.popup(x, y);
  end;
end;

procedure tares_frmmain.btn_toolbarchat_underlineclick(sender: tobject);
begin
  btn_chat_emocittrigger(chr(2) + '7');
end;

procedure tares_frmmain.btn_toolbarchat_italicclick(sender: tobject);
begin
  btn_chat_emocittrigger(chr(2) + '9');
end;

procedure tares_frmmain.btn_toolbarchat_boldclick(sender: tobject);
begin
  btn_chat_emocittrigger(chr(2) + '6');
end;

procedure Tares_frmmain.trackbar_playerChange(Sender: TObject);
var
  currentPosition, Duration: int64;
  MediaSeeking: IMediaSeeking;
  hr: HResult;
begin

  if helper_player.m_GraphBuilder = nil then exit;

  hr := helper_player.m_GraphBuilder.QueryInterface(IMediaSeeking, MediaSeeking);
  if FAILED(hr) then exit;

 //hr:=MediaSeeking.GetDuration(Duration);
 //if FAILED(hr) then exit;

  CurrentPosition := MiliSecToRefTime(trackbar_player.Position);
  Duration := MiliSecToRefTime(trackbar_player.Max);

  hr := MediaSeeking.SetPositions(CurrentPosition, AM_SEEKING_AbsolutePositioning, Duration, AM_SEEKING_NoPositioning);
  if FAILED(hr) then exit;

  trackbar_playerTimer(trackbar_player, trackbar_player.Position, trackbar_player.max);

end;

procedure Tares_frmmain.TntFormDestroy(Sender: TObject);
begin
  FOleInPlaceActiveObject := nil;
end;

procedure Tares_frmmain.WMQueryEndSession(var Message: TWMQUERYENDSESSION);
begin
  ending_session := True;
  application.onmessage := nil;
  message.Result := 1;
end;


procedure Tares_frmmain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canclose := ((ending_session) or (vars_global.closing));
  if not canclose then postmessage(self.handle, wm_SYSCOMMAND, sc_close, 0);
end;

procedure Tares_frmmain.Addtoplaylist3Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  UpData: precord_displayed_upload;
begin
  node := treeview_upload.GetFirstselected;
  if node = nil then exit;

  dataNode := treeview_upload.getdata(node);
  if dataNode^.m_type <> dnt_upload then exit;

  UpData := dataNode^.data;
  playlist_addfile(UpData^.nomefile, -1, false, '');
end;

procedure Tares_frmmain.listview_chat_channelResize(Sender: TObject);
begin
  with (sender as tcomettree) {ares_frmmain.listview_chat_channel} do begin
    if Selectable then begin
      if Header.Columns.Items[2].width < clientwidth - (Header.Columns.Items[1].width + Header.Columns.Items[0].width) then
        Header.Columns.Items[2].width := clientwidth - (Header.Columns.Items[1].width + Header.Columns.Items[0].width);
    end else begin
      with header.columns do begin
        Items[0].width := clientwidth;
        Items[1].width := 0;
        Items[2].width := 0;
      end;
    end;
  end;
end;

procedure Tares_frmmain.check_opt_chat_joinpartClick(Sender: TObject);
begin
  set_reginteger('ChatRoom.ShowJP', integer(check_opt_chat_joinpart.checked));
end;

procedure Tares_frmmain.Saveas1Click(Sender: TObject);
begin
  export_channellist;
end;

procedure Tares_frmmain.Exporthashlink5Click(Sender: TObject);
begin
  export_channel_hashlink;
end;

procedure Tares_frmmain.Memo_opt_chat_awayKeyPress(Sender: TObject;
  var Key: Char);
var
  edit_chat: ttntMemo;
begin
  edit_chat := (sender as ttntMemo);

  case integer(key) of
    2: begin
        edit_chat.text := edit_chat.text + chr(2);
        key := char(vk_cancel);
        edit_chat.SelStart := length(edit_chat.text);
      end;
  end;
end;

procedure Tares_frmmain.Locate3Click(Sender: TObject);
begin
  if player_actualfile = '' then exit;
  if not fileexistsW(player_actualfile) then exit;
  locate_containing_folder(widestrtoutf8str(player_actualfile));
end;

procedure Tares_frmmain.OpenExternal3Click(Sender: TObject);
begin
  if player_actualfile = '' then exit;
  if not fileexistsW(player_actualfile) then exit;
  open_file_external(widestrtoutf8str(player_actualfile));
end;

procedure Tares_frmmain.addtoplaylist6Click(Sender: TObject);
begin
  if player_actualfile = '' then exit;
  if not fileexistsW(player_actualfile) then exit;
  playlist_addfile(widestrtoutf8str(player_actualfile), -1, false, '');
end;

procedure Tares_frmmain.Grantslot2Click(Sender: TObject);
var
  node: PCmtVNode;
  dataNode: precord_data_node;
  UpData: precord_displayed_upload;
begin
  try
    node := treeview_upload.getfirstselected;
    if node = nil then exit;

    dataNode := treeview_upload.getdata(node);
    if dataNode^.m_type <> dnt_upload then exit;

    UpData := dataNode^.data;
    ip_user_granted := UpData^.ip;
    port_user_granted := UpData^.port;
    ip_alt_granted := UpData^.ip_alt;

  except
  end;
end;

procedure Tares_frmmain.btn_opt_chat_connectClick(Sender: TObject);
var
  reg: tregistry;
  ips: string;
  porT: word;
begin
  if pos(':', edit_opt_chat_connect.text) = 0 then exit;
  ips := copy(edit_opt_chat_connect.text, 1, pos(':', edit_opt_chat_connect.text) - 1);
  port := strtointdef(copy(edit_opt_chat_connect.text, pos(':', edit_opt_chat_connect.text) + 1, length(edit_opt_chat_connect.text)), 0);
  chat_with_user(ips, port, 0, 0, 0, ips + ':' + inttostr(port));



  reg := tregistry.create;
  with reg do begin
    openkey(areskey, true);
    writestring('ChatRoom.LastDCHost', edit_opt_chat_connect.text);
    closekey;
    destroy;
  end;
end;

procedure Tares_frmmain.btn_chat_favClick(Sender: TObject);
begin
  try

    btn_chat_fav.down := not btn_chat_fav.down;

    if not btn_chat_fav.down then reg_save_chatfav_height
    else showChatFavorites;

    panel_chatResize(panel_chat);


  except
  end;
end;

procedure Tares_frmmain.treeview_chat_favoritesAfterCellPaint(
  Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: PCmtVNode;
  Column: TColumnIndex; CellRect: TRect);
var
  data: precord_chat_favorite;
  widestr: widestring;
  cellrec: trect;
  forecolor, backcolor, forecolor_gen, backcolor_gen: Tcolor;
begin
  if column <> 2 then exit;

  data := sender.getdata(node);
  if not data^.has_colors_intopic then exit;

  try

    widestr := utf8strtowidestr(data^.topic);

    with cellrec do begin
      left := cellrect.left;
      top := cellrect.top + 1;
      bottom := cellrect.bottom;
      right := cellrect.right;
    end;

    if (vsSelected in Node.States) then begin
      backcolor_gen := clHighLight;
      forecolor_gen := $00FEFFFF;
      backcolor := clHighLight;
      forecolor := $00FEFFFF;
    end else begin
      forecolor_gen := clblack;
      forecolor := clblack;
      if (node.Index mod 2) = 0 then backcolor_gen := sender.BGColor else backcolor_gen := $00FEFFFF;
      backcolor := backcolor_gen;
    end;

    canvas_draw_topic(Targetcanvas, CellRec, imglist_emotic, widestr, forecolor, backcolor, forecolor_gen, backcolor_gen, 8);

  except
  end;
end;

procedure Tares_frmmain.treeview_chat_favoritesFreeNode(
  Sender: TBaseCometTree; Node: PCmtVNode);
begin
  finalize_chatfavorite(sender, node);
end;

procedure Tares_frmmain.treeview_chat_favoritesGetSize(
  Sender: TBaseCometTree; var Size: Integer);
begin
  Size := SizeOf(record_chat_favorite);
end;

procedure Tares_frmmain.treeview_chat_favoritesGetText(
  Sender: TBaseCometTree; Node: PCmtVNode; Column: TColumnIndex;
  var CellText: WideString);
var
  Data: precord_chat_favorite;
begin
  Data := sender.getdata(Node);

  if not sender.selectable then begin
    if column = 0 then celltext := utf8strtowidestr(data^.name);
    exit;
  end;
  case column of
    0: celltext := utf8strtowidestr(data^.name);
    1: celltext := formatdatetime('yyyy/mm/dd hh:nn:ss', UnixToDelphiDateTime(data^.last_joined));
    2: begin
        if data^.has_colors_intopic then begin
          celltext := data^.stripped_topic;
        end else
          celltext := data^.stripped_topic;
      end else celltext := chr(32);
  end;
end;

procedure Tares_frmmain.treeview_chat_favoritesGetImageIndex(
  Sender: TBaseCometTree; Node: PCmtVNode; var ImageIndex: Integer);
begin
  imageindex := 3;
end;

procedure Tares_frmmain.treeview_chat_favoritesCompareNodes(
  Sender: TBaseCometTree; Node1, Node2: PCmtVNode; Column: TColumnIndex;
  var Result: Integer);
var
  Data1,
    Data2: precord_chat_favorite;
begin
  Data1 := Sender.getdata(Node1);
  Data2 := Sender.getdata(Node2);
  case column of
    0: result := CompareText(Data1.name, Data2.name);
    2: result := CompareText(widestrtoutf8str(Data1.stripped_topic), widestrtoutf8str(Data2.stripped_topic));
    1: result := Data1.last_joined - Data2.last_joined;
  end;
end;

procedure Tares_frmmain.AddtoFavorites1Click(Sender: TObject);
var
  nodo, nodof: PCmtVNode;
  datas: precord_displayed_channel;
  dataf: precord_chat_favorite;
begin
  nodo := listview_chat_channel.getfirstselected;
  if nodo = nil then exit;

  if not btn_chat_fav.down then btn_chat_favClick(btn_chat_fav);

  datas := listview_chat_channel.getdata(nodo);

  nodof := treeview_chat_favorites.getfirst;
  while (nodof <> nil) do begin
    dataf := treeview_chat_favorites.getdata(nodof);
    if dataf^.ip = datas^.ip then
      if dataf^.port = datas^.port then exit;
    nodof := treeview_chat_favorites.getnext(nodof);
  end;

  nodof := treeview_chat_favorites.addchild(nil);
  dataf := treeview_chat_favorites.getdata(nodof);
  dataf^.ip := datas^.ip;
  dataf^.alt_ip := datas^.alt_ip;
  dataf^.last_joined := DelphiDateTimeToUnix(now);
  dataf^.port := datas^.port;
  dataf^.name := datas^.name;
  dataf^.topic := datas^.topic;
  dataf^.locrc := datas^.locrc;
  dataf^.stripped_topic := datas^.stripped_topic;
  dataf^.has_colors_intopic := datas^.has_colors_intopic;
  save_favorite_channel(dataf);


end;

procedure Tares_frmmain.Join1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  datas: precord_displayed_channel;
  dataf: precord_chat_favorite;
begin
  try

    nodo := treeview_chat_favorites.getfirstselected;
    if nodo = nil then exit;
    dataf := treeview_chat_favorites.getdata(nodo);

    update_FAVchannel_last(dataf, nil);


    datas := AllocMem(sizeof(record_displayed_channel));
    datas^.ip := dataf^.ip;
    datas^.alt_ip := dataf^.alt_ip;
    datas^.port := dataf^.port;
    datas^.users := 1;
    datas^.name := dataf^.name;
    datas^.topic := dataf^.topic;
    datas^.locrc := dataf^.locrc;
    datas^.stripped_topic := dataf^.stripped_topic;
    datas^.has_colors_intopic := dataf^.has_colors_intopic;

    helper_channellist.join_channel(datas);

    datas^.name := '';
    datas^.topic := '';
    datas^.stripped_topic := '';
    FreeMem(datas, sizeof(record_displayed_channel));


  except
  end;
end;

procedure Tares_frmmain.Remove1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  dataf: precord_chat_favorite;
  kname: string;
  reg: tregistry;
begin
  try

    nodo := treeview_chat_favorites.getfirstselected;

    while (nodo <> nil) do begin
      if nodo = nil then exit;
      dataf := treeview_chat_favorites.getdata(nodo);

      kname := bytestr_to_hexstr(int_2_dword_string(dataf^.ip) + int_2_word_string(dataf^.port));

      reg := tregistry.create;
      reg.RootKey := HKEY_CURRENT_USER;
      with reg do begin
        openkey(areskey + 'ChatFavorites', true);
        deletekey(kname);
        closekey;
        destroy;
      end;

      treeview_chat_favorites.DeleteNode(nodo, true);
      nodo := treeview_chat_favorites.getfirstselected;
    end;

  except
  end;
end;

procedure Tares_frmmain.treeview_chat_favoritesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  dataf: precord_chat_favorite;
  nodo: pCMTVnode;
  punto: tpoint;
begin
  if button <> mbright then exit;
  nodo := treeview_chat_favorites.getfirstselected;
  if nodo = nil then exit;

  dataf := treeview_chat_favorites.getdata(nodo);

  autoJoin1.checked := dataf^.autoJoin;

  getcursorpos(punto);
  popup_chat_fav.popup(punto.x, punto.y);
end;

procedure Tares_frmmain.ExportHashlink6Click(Sender: TObject);
begin
  export_favorite_channel_hashlink;
end;

procedure Tares_frmmain.Other1Click(Sender: TObject);
begin
  browse_type := 8; //2956+
  mainGui_chatoomBrowse_event;
end;

procedure Tares_frmmain.Other2Click(Sender: TObject);
begin
  browse_type := 8; //2956+
  result_chat_dobrowse;
end;

procedure Tares_frmmain.RemoveSource1Click(Sender: TObject);
var
  node: pCmtVnode;
  dataNode: precord_data_node;
  DsData: precord_displayed_downloadsource;
  BtSrcData: btcore.Precord_displayed_source;
begin
  node := treeview_download.GetFirstselected;
  if node = nil then exit;

  dataNode := treeview_download.getdata(node);

  if dataNode^.m_type <> dnt_downloadSource then
    if dataNode^.m_type <> dnt_partialDownload then
      if datanode^.m_type <> dnt_bittorrentSource then exit;

  if dataNode^.m_type = dnt_downloadSource then begin
    DsData := dataNode^.data;

    if (DsData^.state in [srs_receiving,
      srs_connecting,
        srs_readytorequest,
        srs_receivingReply,
        srs_connected,
        srs_UDPreceivingICH,
        srs_UDPDownloading,
        srs_receivingICH]) then DsData^.should_disconnect := true;

  end else
    if dataNode^.m_type = dnt_bittorrentSource then begin
      BtSrcData := dataNode^.data;
      if btSrcData^.status = btSourceConnected then BtSrcData^.should_disconnect := true;
    end;

end;

procedure Tares_frmmain.lbl_opt_skin_urlMouseEnter(Sender: TObject);
begin
  (sender as ttntlabel).font.style := [fsunderline];
end;

procedure Tares_frmmain.lbl_opt_skin_urlMouseLeave(Sender: TObject);
begin
  (sender as ttntlabel).font.style := [];
end;

procedure Tares_frmmain.lbl_opt_skin_urlClick(Sender: TObject);
begin
  utility_ares.browser_go((sender as ttntlabel).caption);
end;

procedure Tares_frmmain.lstbox_opt_skinClick(Sender: TObject);
begin
  if lstbox_opt_skin.ItemIndex = -1 then exit;
  load_new_skin;
end;

procedure Tares_frmmain.lbl_srcmime_audioClick(Sender: TObject);
begin
  radio_srcmime_audio.Checked := true;
end;

procedure Tares_frmmain.lbl_srcmime_videoClick(Sender: TObject);
begin
  radio_srcmime_video.Checked := true;
end;

procedure Tares_frmmain.lbl_srcmime_documentClick(Sender: TObject);
begin
  radio_srcmime_document.Checked := true;
end;

procedure Tares_frmmain.lbl_srcmime_imageClick(Sender: TObject);
begin
  radio_srcmime_image.Checked := true;
end;

procedure Tares_frmmain.lbl_srcmime_softwareClick(Sender: TObject);
begin
  radio_srcmime_software.Checked := true;
end;

procedure Tares_frmmain.lbl_srcmime_otherClick(Sender: TObject);
begin
  radio_srcmime_other.Checked := true;
end;

procedure Tares_frmmain.lbl_lib_filesharedClick(Sender: TObject);
begin
  chk_lib_fileshared.checked := not chk_lib_fileshared.checked;
  ShareUnsharefile1Click(nil);
end;

procedure Tares_frmmain.Check_opt_chatroom_nopmClick(Sender: TObject);
begin
  set_reginteger('ChatRoom.BlockPM', integer(Check_opt_chatroom_nopm.checked));
end;

procedure Tares_frmmain.panel_vidDblClick(Sender: TObject);
begin
  Fullscreen2Click(nil);
end;

procedure Tares_frmmain.videoDblClick(Sender: TObject);
begin
  Fullscreen2Click(nil);
end;

procedure Tares_frmmain.TntFormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin


  if key = VK_ESCAPE then
    if tabs_pageview.activepage = IDTAB_SCREEN then
      if fullscreen2.checked then
        Fullscreen2Click(nil);
end;

procedure Tares_frmmain.listview_chat_channelPaintText(
  Sender: TBaseCometTree; const TargetCanvas: TCanvas; Node: PCmtVNode;
  Column: TColumnIndex);
begin
  if node.childcount = 0 then exit;

  TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT1;
  if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext;
end;

procedure Tares_frmmain.listview_chat_channelCollapsing(
  Sender: TBaseCometTree; Node: PCmtVNode; var Allowed: Boolean);
begin
  allowed := false;
end;

procedure Tares_frmmain.treeview_uploadPaintText(Sender: TBaseCometTree;
  const TargetCanvas: TCanvas; Node: PCmtVNode; Column: TColumnIndex);
var
  datanode: precord_data_node;
begin
  dataNode := sender.getdata(node);
  if dataNode^.m_type <> dnt_partialUpload then exit;

  TargetCanvas.font.color := COLORE_LISTVIEWS_FONTALT1;
  if (vsSelected in node.States) then TargetCanvas.Font.color := clhighlighttext;
end;

procedure Tares_frmmain.RemoveSource2Click(Sender: TObject);
var
  datanode: precord_data_node;
  node: PCmtVNode;
  BtSrcData: btcore.Precord_displayed_source;
begin
  node := treeview_upload.GetFirstselected;
  if node = nil then exit;

  dataNode := treeview_upload.getdata(node);

  if dataNode^.m_type = dnt_bittorrentSource then begin
    BtSrcData := dataNode^.data;
    if btSrcData^.status = btSourceConnected then BtSrcData^.should_disconnect := true;
  end;
end;

procedure Tares_frmmain.AutoJoin1Click(Sender: TObject);
var
  nodo: PCmtVNode;
  dataf: precord_chat_favorite;
begin
  try
    autojoin1.checked := not autojoin1.checked;

    nodo := treeview_chat_favorites.getfirstselected;
    if nodo = nil then exit;
    dataf := treeview_chat_favorites.getdata(nodo);
    dataf^.autoJoin := autojoin1.checked;
    setAutoJoin(dataf, autojoin1.checked);

  except
  end;
end;

procedure Tares_frmmain.Check_opt_chat_autoaddClick(Sender: TObject);
begin
  set_reginteger('ChatRoom.AutoAddToFavorites', integer(Check_opt_chat_autoadd.checked));
end;

procedure Tares_frmmain.btn_opt_torrent_chshfoldClick(Sender: TObject);
begin
  try
    fold.FolderName := vars_global.my_torrentFolder;
    if not Fold.execute then exit;

    if direxistsW(fold.foldername) then begin
      vars_global.my_torrentFolder := fold.foldername;
      edit_opt_bittorrent_dlfolder.text := vars_global.my_torrentFolder;
      getfreedrivespace;

      set_regstring('Torrents.Folder', bytestr_to_hexstr(widestrtoutf8str(vars_global.my_torrentFolder)));
    end;

  except
  end;
end;

procedure Tares_frmmain.btn_opt_torrent_defshfoldClick(Sender: TObject);
begin
  try
    tntwindows.Tnt_createdirectoryW(pwidechar(data_path + '\' + STR_MYSHAREDFOLDER + '\' + STR_MYTORRENTS), nil);
    vars_global.my_torrentFolder := data_path + '\' + STR_MYSHAREDFOLDER + '\' + STR_MYTORRENTS;
    edit_opt_bittorrent_dlfolder.text := vars_global.my_torrentFolder;
    getfreedrivespace;

    set_regstring('Torrents.Folder', bytestr_to_hexstr(widestrtoutf8str(vars_global.my_torrentFolder)));
  except
  end;
end;

procedure Tares_frmmain.check_opt_torrent_assocClick(Sender: TObject);
var
  reg: Tregistry;
begin
  Set_regInteger('General.HookBitTorrentExt', integer(check_opt_torrent_assoc.checked));

  reg := Tregistry.create;
  if not check_opt_torrent_assoc.checked then restorePreviousBittorrentApp(reg)
  else check_bittorrent_association(reg);
  reg.destroy;

end;

function Tares_frmmain.AsyncExFilterState(Buffering: LongBool; PreBuffering: LongBool; Connecting: LongBool; Playing: LongBool; BufferState: integer): HRESULT; stdcall;
var
  hr: hresult;
begin
  Result := S_OK;

  if ((Buffering) or (PreBuffering) or (connecting)) then begin
    shoutcast.isConnectingShoutcast := true;
    if connecting then bufferstate := -1;
    if shoutcast.RenderError then exit;
    shoutcast.UpdateCaptionShoutcast(BufferState);
  end else

    if ((not Connecting) and
      (not PreBuffering) and
      (not buffering) and
      (not playing) and
      (BufferState = 100)) then begin

      if renderingMp3Stream then begin
        if not shoutcast.isReconnecting then begin
          if assigned(helper_player.m_GraphBuilder) then begin
            hr := helper_player.m_GraphBuilder.Render(helper_player.m_Pin);
            if FAILED(hr) then begin
              shoutcast.RenderError := true;
              vars_global.caption_player := 'GraphBuilder Render Error: ' + DSUtil.GetErrorString(HR);
              ares_frmmain.trackbar_player.wcaption := vars_global.caption_player;
              exit;
            end;
          end;
        end else shoutcast.isReconnecting := false;

        helper_player.player_get_volumesettings;

        if assigned(helper_player.m_MediaControl) then begin
          hr := helper_player.m_MediaControl.Run;
          if FAILED(hr) then begin
            shoutcast.RenderError := true;
            vars_global.caption_player := 'MediaControl Run Error: ' + DSUtil.GetErrorString(HR);
            ares_frmmain.trackbar_player.wcaption := vars_global.caption_player;
            exit;
          end;
        end;
      end;

      helper_registry.Set_regstring('ShoutCast.LastURL', shoutcast.radioURL);

      shoutcast.isConnectingShoutcast := false;
      if not shoutcast.RenderError then shoutcast.UpdateCaptionShoutcast;
      ares_frmmain.MPlayerPanel1.Playing := true;
    end else

      if Playing then begin
        shoutcast.isConnectingShoutcast := false;
        shoutcast.UpdateCaptionShoutcast;
      end;

end;

function Tares_frmmain.AsyncExICYNotice(IcyItemName: PChar; ICYItem: PChar): HRESULT; stdcall;
const
// ICY Item Names
  c_ICYName = 'icy-name:';
  //c_ICYGenre = 'icy-genre:';
  c_ICYURL = 'icy-url:';
 // c_ICYBitrate = 'icy-br:';
  c_ICYError = 'icy-error:';
  c_ICYStreamMime = 'icy-internalmime:';
 // c_ICYMetaInterval = 'icy-metainterval:';
 // c_ICYNotice2 = 'icy-notice2:';
var
  str: string;
begin
  Result := S_OK;

  if shoutcast.RenderError then exit;

  if IcyItemName = c_ICYName then begin
    if length(ares_frmmain.trackbar_player.urlCaption) = 0 then begin
      str := copy(ICYItem, 1, length(ICYItem));
      ares_frmmain.trackbar_player.urlCaption := widestring(str);
      shoutcast.AddMenuRadio(widestrtoutf8str(ares_frmmain.trackbar_player.urlCaption), shoutcast.radioUrl);
    end;
  end;

  if IcyItemName = c_ICYURL then begin
    if length(ares_frmmain.trackbar_player.url) = 0 then begin
      ares_frmmain.trackbar_player.url := copy(ICYItem, 1, length(ICYItem));
    end;
  end;

  if IcyItemName = c_ICYStreamMime then begin
    str := copy(ICYItem, 1, length(ICYItem));
    if lowercase(str) = 'audio/mpeg' then shoutcast.connectmp3
    else shoutcast.connectaac;
  end;

  if IcyItemName = c_ICYError then begin
    str := copy(ICYItem, 1, length(ICYItem));

    if pos('ICY 40', str) = 1 then begin
      vars_global.caption_player := 'Service Unavailable, Radio Offline';
      ares_frmmain.trackbar_player.wcaption := vars_global.caption_player;
      shoutcast.RenderError := true;
      tmr_stop_radio.enabled := true; // we cant stop in its callback
      exit;
    end else
      if pos('stream type ', lowercase(str)) = 1 then begin // Apple's AAC+ thingy?
        vars_global.caption_player := str;
        ares_frmmain.trackbar_player.wcaption := vars_global.caption_player;
        shoutcast.RenderError := true;
        tmr_stop_radio.enabled := true; // we cant stop in its callback
        exit;
      end;
    if ((pos('socket error ', lowercase(str)) = 1) or
      (pos('network error ', lowercase(str)) = 1)) then begin // disconnected while playing stream
      shoutcast.isConnectingShoutcast := true;
      shoutcast.isReconnecting := true;
     //helper_player.pauseMedia;
    end;

    vars_global.caption_player := str;
    ares_frmmain.trackbar_player.wcaption := vars_global.caption_player;
  end;


end;

function Tares_frmmain.AsyncExSockError(ErrString: PChar): HRESULT; stdcall;
begin
  Result := S_OK;
end;

function Tares_frmmain.AsyncExMetaData(Title: PChar; URL: PChar): HRESULT; stdcall;
var
  Temptitle: string;
begin
  Result := S_OK;
  if shoutcast.RenderError then exit;

  TempTitle := copy(title, 1, length(title));

  while (true) do
    if pos(' - ', TempTitle) = length(TempTitle) - 2 then delete(TempTitle, length(TempTitle) - 2, 3)
    else break;

  if shoutcast.titleStream <> TempTitle then begin
    shoutcast.CurrentPos := 0; // set time to 0
    shoutcast.titleStream := TempTitle;
 //Riptodisk1.visible:=true;
    ares_frmmain.ExportHashlink7.visible := true;
    shoutcast.UpdateCaptionShoutcast;
    if Enable1.checked then
      if not shoutcast.hasEverStartedRip then begin
        SetRipStream(true);
        shoutcast.hasEverStartedRip := true;
      end;

    msnNowPlaying.UpdateMsn(TempTitle, widestrtoutf8str(ares_frmmain.trackbar_player.urlCaption));
  end else
    if TempTitle = '' then msnNowPlaying.UpdateMsn('', widestrtoutf8str(ares_frmmain.trackbar_player.urlCaption));

end;

procedure Tares_frmmain.New1Click(Sender: TObject);
var
  fURL: string;

begin
  fURL := get_regstring('ShoutCast.LastURL');
  if length(furl) = 0 then fUrl := 'http://';
  if not inputquery('Internet Radio', 'URL:', fUrl) then exit;

  n20.visible := true;
  shoutcast.openRadioUrl(furl);

end;

procedure Tares_frmmain.radiostationclick(Sender: TObject);
var
  item: TTntMenuItem;
begin
  item := sender as ttntmenuitem;
  shoutcast.OpenRadioStation(widestrtoutf8str(item.caption));
end;

procedure Tares_frmmain.Locate4Click(Sender: TObject);
begin
  if shoutcast.renderingMp3Stream then
    locate_containing_folder(widestrtoutf8str(vars_global.myshared_folder + '\Radio\' + shoutcast.titleStream + '.mp3'))
  else
    locate_containing_folder(widestrtoutf8str(vars_global.myshared_folder + '\Radio\' + shoutcast.titleStream + '.aac'))
end;

procedure Tares_frmmain.Enable1Click(Sender: TObject);
begin
  Enable1.checked := not Enable1.checked;
  shoutcast.SetRipStream(Enable1.checked);
end;

procedure Tares_frmmain.btn_player_radioClick(Sender: TObject);
var
  punto: tpoint;
begin
  OpenExternal3.visible := false;
  Locate3.visible := false;
  addtoplaylist6.visible := false;
  N16.visible := false;

  ListentoRadio1.visible := true;
  ExportHashlink7.visible := (length(shoutcast.radioUrl) >= 10);
  getcursorpos(punto);

  popup_capt_player.popup(punto.x - 10, punto.y - 10);
end;

procedure Tares_frmmain.ExportHashlink7Click(Sender: TObject);
begin
  if length(shoutcast.radioUrl) >= 10 then
    shoutcast.export_radioArlnk(shoutcast.radioUrl);
end;

procedure Tares_frmmain.check_opt_hlink_plsClick(Sender: TObject);
var
  reg: Tregistry;
begin
  reg := TRegistry.create;

  with reg do begin
    openkey(areskey, true);
    writeInteger('General.HookPls', integer(check_opt_hlink_pls.checked));
    closekey;
  end;

  check_pls_association(reg);
  reg.destroy;
end;

procedure Tares_frmmain.tmr_stop_radioTimer(Sender: TObject);
begin
  tmr_stop_radio.enabled := false;
  stopmedia(nil);
end;

procedure Tares_frmmain.Volume1Click(Sender: TObject);
begin
  timer_fullScreenHideCursor.enabled := false;
  while ShowCursor(true) < 0 do ;
  btn_player_volClick(nil);
end;

procedure Tares_frmmain.timer_fullScreenHideCursorTimer(Sender: TObject);
begin
  timer_fullScreenHideCursor.enabled := false;

  if helper_player.FFullScreenWindow = nil then begin
    try
      while ShowCursor(true) < 0 do application.processmessages;
    except
    end;
    exit;
  end;

  while ShowCursor(false) >= 0 do application.processmessages;
  GetCursorPos(vars_global.prev_cursorpos);
end;

procedure Tares_frmmain.fullscreenMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if x - 10 < vars_global.prev_cursorpos.x then
    if x + 10 > vars_global.prev_cursorpos.x then
      if y - 10 < vars_global.prev_cursorpos.y then
        if y + 10 > vars_global.prev_cursorpos.y then exit;
  try
    while ShowCursor(true) < 0 do application.processmessages;
    GetCursorPos(vars_global.prev_cursorpos);
  except
  end;
  timer_fullScreenHideCursor.enabled := false;
  timer_fullScreenHideCursor.interval := 4000;
  timer_fullScreenHideCursor.enabled := true;
end;

procedure Tares_frmmain.PopupMenuvideoPopup(Sender: TObject);
begin
  timer_fullScreenHideCursor.enabled := false;
  try
    while ShowCursor(true) < 0 do application.processmessages;
    GetCursorPos(vars_global.prev_cursorpos);
  except
  end;
end;

procedure Tares_frmmain.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    if ActiveControl <> nil then
      if (ActiveControl.ClassType = TEdit) or
        (ActiveControl.ClassType = TTntEdit) or
        (ActiveControl.ClassType = TCometBtnEdit) or
        (ActiveControl.ClassType = TTntCombobox) then exit;

    if key = VK_RIGHT then begin
      helper_player.player_step_forward;
    end else
      if key = VK_LEFT then begin
        helper_player.player_step_backward;
      end;
  except
  end;
end;

procedure Tares_frmmain.TntFormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  Handled := false;
  try
    if tabs_pageview.activepage = IDTAB_LIBRARY then begin
      if listview_lib.enabled then listview_lib.SetFocus;
    end else
      if tabs_pageview.activepage = IDTAB_SEARCH then helper_search_gui.SetFocusSrc else
        if tabs_pageview.activepage = IDTAB_CHAT then helper_chatroom_gui.SetFocus else
          if tabs_pageview.activepage = IDTAB_TRANSFER then helper_download_misc.setFocus;
  except
  end;
end;

procedure Tares_frmmain.panel_player_captclick(Sender: TObject);
var
  punto: tpoint;
begin
//if button<>mbright then exit;
  if ((length(player_actualfile) = 0) or
    (not fileexistsW(player_actualfile))) then begin
    OpenExternal3.visible := false;
    Locate3.visible := false;
    addtoplaylist6.visible := false;
    N16.visible := false;
    ExportHashlink7.visible := (length(shoutcast.radioUrl) >= 10);
  end else begin
    OpenExternal3.visible := true;
    Locate3.visible := true;
    addtoplaylist6.visible := true;
    N16.visible := true;
    ExportHashlink7.visible := false;
  end;
  getcursorpos(punto);
  popup_capt_player.popup(punto.x, punto.y);
end;

procedure Tares_frmmain.MPlayerPanel1Click(BtnId: TMPlayerButtonID);
begin

  case BtnId of
    MPBtnPlaylist: begin
        formhint_hide;
        toggle_playlist;
      end;
    MPBtnStop: stopmedia(mplayerpanel1);
    MPBtnPrev: begin
        playlist_select_prev;
        listview_playlistDblClick(nil);
      end;
    MPBtnRew: helper_player.player_step_backward;
    MPBtnPlay: btn_player_playClick(nil);
    MPBtnPause: btn_player_pauseClick(mplayerpanel1);
    MPBtnFF: helper_player.player_step_forward;
    MPBtnNext: begin
        playlist_select_next;
        listview_playlistDblClick(nil);
      end;
    MPBtnVol: btn_player_volClick(mplayerpanel1);
    MPBtnRadio: btn_player_radioClick(mplayerpanel1);
  end;

end;

procedure Tares_frmmain.MPlayerPanel1BtnHint(BtnId: TMPlayerButtonID);

  function BtnIdtoHint(BtnId: TMPlayerButtonID): string;
  begin
    case BtnId of
      MPBtnPlaylist: result := GetLangStringA(STR_SHOW_PLAYLIST);
      MPBtnRadio: result := 'Internet Radio'
    end;
  end;

var
  point: TPoint;
begin

  if BtnID <> MPBtnRadio then
    if BtnID <> MPBtnPlaylist then begin
      MPlayerPanel1.hint := '';
      Application.CancelHint;
      exit;
    end;

  if BtnIdtoHint(BtnID) <> MPlayerPanel1.hint then begin
    GetCursorPos(point);
    MPlayerPanel1.hint := BtnIdtoHint(BtnID);
    Application.ActivateHint(point);
  end;
end;

procedure Tares_frmmain.TntFormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if newWidth < 300 then begin
    resize := false;
    exit;
  end else
    if newHeight < 200 then begin
      resize := false;
      exit;
    end else
      resize := true;
end;

procedure Tares_frmmain.tabs_pageviewPaintButtonFrame(Sender: TObject;
  aCanvas: TCanvas; paintRect: TRect);
var
  pointX: integer;
  Details: TThemedElementDetails;
begin
  if helper_skin.TabsSourceBitmap = nil then begin
    if ThemeServices.ThemesEnabled then begin
      Details := ThemeServices.GetElementDetails(ttbToolBarRoot); //trRebarRoot);
   //paintRect:=rect(0,0,tabs_pageview.clientwidth,tabs_pageview.buttonsHeight);
      ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @PaintRect); //@paintRect);
  // aCanvas.Brush.color:=clBlack;
  // aCanvas.fillrect(rect(paintRect.left,paintRect.bottom-1,paintRect.right,paintrect.Bottom));
    end else begin
      aCanvas.pen.color := clBlack;
      aCanvas.brush.Color := clBtnFace;
      aCanvas.rectangle(paintRect.left, paintRect.top, paintRect.right, paintRect.bottom);
    end;
    exit;
  end;

  BitBlt(aCanvas.handle, 0, 0, TabsCopyPointLeft.y {y=placeholder for width}, tabs_pageview.buttonsHeight,
    TabsSourceBitmap.canvas.handle, TabsCopyPointLeft.x, 0, SRCCOpy);

  pointx := TabsCopyPointLeft.y {y=placeholder for width};
  while (pointX < paintRect.right - (TabsCopyPointRight.y - 1) {y=placeholder for width}) and (TabsCopyPointMiddle.y > 0) do begin
    BitBlt(aCanvas.Handle, pointx, 0, TabsCopyPointMiddle.y, tabs_pageview.buttonsHeight,
      helper_skin.TabsSourceBitmap.canvas.handle, TabsCopyPointMiddle.x, 0, SRCCopy);
    inc(pointX, TabsCopyPointMiddle.y);
  end;

  BitBlt(aCanvas.handle, paintRect.right - TabsCopyPointRight.y, 0, TabsCopyPointRight.y, tabs_pageview.buttonsHeight,
    helper_skin.TabsSourceBitmap.canvas.handle, TabsCopyPointRight.x, 0, SRCCOpy);
end;

procedure Tares_frmmain.smalltabs_pageviewPaintButtonFrame(Sender: TObject;
  aCanvas: TCanvas; paintRect: TRect);
var
  pointX, offsety: integer;
  Details: TThemedElementDetails;
begin
  if helper_skin.smallTabsSourceBitmap = nil then begin
    if ThemeServices.ThemesEnabled then begin
      Details := ThemeServices.GetElementDetails(ttBody);
      ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
      aCanvas.Brush.color := clBlack;
      aCanvas.fillrect(rect(paintRect.left, paintRect.bottom - 1, paintRect.right, paintrect.Bottom));
    end else begin
      aCanvas.pen.color := clBlack;
      aCanvas.brush.Color := clBtnFace;
      aCanvas.rectangle(paintRect.left, paintRect.top, paintRect.right, paintRect.bottom);
    end;
    exit;
  end;

  offsety := 0;

  while (offsety + (sender as TCometPageView).buttonsHeight <= paintRect.bottom) do begin
    BitBlt(aCanvas.handle, 0, offsety, smallTabsCopyPointLeft.y {y=placeholder for width}, panel_chat.buttonsHeight,
      smallTabsSourceBitmap.canvas.handle, smallTabsCopyPointLeft.x, 0, SRCCOpy);

    pointx := smallTabsCopyPointLeft.y {y=placeholder for width};
    while (pointX < paintRect.right - (smallTabsCopyPointRight.y - 1) {y=placeholder for width}) and (smallTabsCopyPointMiddle.y > 0) do begin
      BitBlt(aCanvas.Handle, pointx, offsety, smallTabsCopyPointMiddle.y, panel_chat.buttonsHeight,
        helper_skin.smallTabsSourceBitmap.canvas.handle, smallTabsCopyPointMiddle.x, 0, SRCCopy);
      inc(pointX, smallTabsCopyPointMiddle.y);
    end;

    BitBlt(aCanvas.handle, paintRect.right - smallTabsCopyPointRight.y, offsety, smallTabsCopyPointRight.y, panel_chat.buttonsHeight,
      helper_skin.smallTabsSourceBitmap.canvas.handle, smallTabsCopyPointRight.x, 0, SRCCOpy);
    inc(offsety, (sender as TCometPageView).buttonsHeight);
  end;
end;

procedure Tares_frmmain.tabs_pageviewPaintButton(Sender, aPanel: TObject;
  aCanvas: TCanvas; paintRect: TRect);
var
  pointX, wid: integer;
//gowithOsTheme:boolean;
  Details: TThemedElementDetails;
  r: TRect;
  bitmap: TBitmap;
  pnl: TCometPagePanel;
  hovState: boolean;
begin
  if helper_skin.TabsSourceBitmap = nil then begin

    if ThemeServices.ThemesEnabled then begin

      pnl := aPanel as TCometPagePanel;
   { bitmap:=tbitmap.create;
    bitmap.width:=tabs_pageview.clientwidth;
    bitmap.height:=tabs_pageview.buttonsheight;
    bitmap.PixelFormat:=pf24bit;
    Details:=ThemeServices.GetElementDetails(trRebarRoot);}
    //r:=rect(0,0,tabs_pageview.clientWidth,tabs_pageview.buttonsHeight);



      Details := ThemeServices.GetElementDetails(ttbToolBarRoot);
      ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
    //bitBlt(aCanvas.handle,paintRect.left,paintrect.top,paintrect.right-paintRect.left,(paintRect.bottom-paintrect.top),
    //       bitmap.canvas.handle,pnl.BtnHitRect.left,pnl.BtnHitRect.top,SRCCOPY);
   // bitmap.free;
      inc(paintRect.top, 2);
      dec(PaintRect.bottom, 3);

      if (aPanel as TCometPagePanel).btnState = [cometpageview.csDown, cometpageview.csHover] then begin
        Details := ThemeServices.GetElementDetails(ttbButtonCheckedHot); //tbPushButtonDefaulted);
        ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
      end else
        if ((cometpageview.csClicked in (APanel as TCometPagePanel).btnState) and
          ((cometpageview.csHover in (APanel as TCometPagePanel).btnState))) then begin
          Details := ThemeServices.GetElementDetails(ttbButtonChecked); //tbPushButtonPressed);
          ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
        end else
          if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then begin
            Details := ThemeServices.GetElementDetails(ttbButtonPressed);
            ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
          end else
            if (cometpageview.csHover in (APanel as TCometPagePanel).btnState) then begin
              Details := ThemeServices.GetElementDetails(ttbButtonHot);
              ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
            end else begin

            end;

      if ImageList_tabs.count >= 12 then begin // draw Icons
        hovState := (cometpageview.csHover in (APanel as TCometPagePanel).btnState);
        case (aPanel as TCometPagePanel).ID of
          IdxBtnLibrary: ImageList_tabs.draw(aCanvas, paintRect.left + 5, paintRect.top + 5, 6 - (integer(hovState) * 6));
          IdxBtnScreen: ImageList_tabs.draw(aCanvas, paintRect.left + 5, paintRect.top + 5, 7 - (integer(hovState) * 6));
          IdxBtnSearch: ImageList_tabs.draw(aCanvas, paintRect.left + 5, paintRect.top + 5, 8 - (integer(hovState) * 6));
          IdxBtnTransfer: ImageList_tabs.draw(aCanvas, paintRect.left + 5, paintRect.top + 5, 9 - (integer(hovState) * 6));
          IdxBtnChat: ImageList_tabs.draw(aCanvas, paintRect.left + 5, paintRect.top + 5, 10 - (integer(hovState) * 6));
          IdxBtnOptions: ImageList_tabs.draw(aCanvas, paintRect.left + 5, paintRect.top + 5, 11 - (integer(hovState) * 6));
        end;
      end;
   // if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then aCanvas.Brush.color:=clbtnface
   //  else
    //paintRect.top:=paintRect.Bottom;
   // paintRect.Bottom:=paintRect.top+2;
    //Details:=ThemeServices.GetElementDetails(ttBody);
    //ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);

    //aCanvas.Brush.color:=clBlack;
    //aCanvas.fillrect(rect(paintRect.left,paintRect.bottom-1,paintRect.right,paintrect.Bottom));

    end else begin
      aCanvas.pen.color := clblack;
      if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then aCanvas.brush.color := clwhite
      else aCanvas.brush.color := clBtnface;
      aCanvas.rectangle(paintRect.left, paintRect.Top, paintRect.right, paintrect.bottom);
    end;
    exit;
  end;
//if (APanel as TCometPagePanel).btnState=[] then exit; //nothing to do


  if (aPanel as TCometPagePanel).btnState = [cometpageview.csDown, cometpageview.csHover] then begin // down/hover
    BitBlt(aCanvas.handle,
      paintRect.left, paintRect.top, helper_skin.TabsDownHoverCopyPointA.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
      helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsDownHoverCopyPointA.x, 0, SRCCOpy);

    pointx := paintRect.left + helper_skin.TabsDownHoverCopyPointA.y {y=placeholder for width};
    while (pointX < paintRect.right - (helper_skin.TabsDownHoverCopyPointC.y - 1)) do begin
      wid := helper_skin.TabsDownHoverCopyPointB.y;
      if wid = 0 then break;
      if pointx + wid > paintRect.right - (helper_skin.TabsDownHoverCopyPointC.y - 1) then wid := (paintRect.right - (helper_skin.TabsDownHoverCopyPointC.y - 1)) - pointx;
      BitBlt(aCanvas.Handle, pointx, 0, wid, paintRect.bottom - paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsDownHoverCopyPointB.x, 0, SRCCopy);
      inc(pointX, wid);
    end;

    BitBlt(aCanvas.handle, paintRect.right - helper_skin.TabsDownHoverCopyPointC.y, 0, helper_skin.TabsDownHoverCopyPointC.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
      helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsDownHoverCopyPointC.x, 0, SRCCOpy);
  end else

    if ((cometpageview.csClicked in (APanel as TCometPagePanel).btnState) and
      ((cometpageview.csHover in (APanel as TCometPagePanel).btnState))) then begin // clicked/Hover

      BitBlt(aCanvas.handle,
        paintRect.left, paintRect.top, helper_skin.TabsClickedCopyPointA.y, paintRect.bottom - paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsClickedCopyPointA.x, 0, SRCCOpy);

      pointx := paintRect.left + helper_skin.TabsClickedCopyPointA.y;
      while (pointX < paintRect.right - (helper_skin.TabsClickedCopyPointC.Y - 1)) do begin
        wid := helper_skin.TabsClickedCopyPointB.y;
        if wid = 0 then break;
        if pointx + wid > paintRect.right - (helper_skin.TabsClickedCopyPointC.y - 1) then wid := (paintRect.right - (helper_skin.TabsClickedCopyPointC.y - 1)) - pointx;
        BitBlt(aCanvas.Handle, pointx, 0, wid, paintRect.bottom - paintRect.top,
          helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsClickedCopyPointB.x, 0, SRCCopy);
        inc(pointX, wid);
      end;

      BitBlt(aCanvas.handle, paintRect.right - helper_skin.TabsClickedCopyPointC.y, 0, helper_skin.TabsClickedCopyPointC.y, paintRect.bottom - paintRect.top,
        helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsClickedCopyPointC.x, 0, SRCCOpy);
    end else

      if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then begin // down
        BitBlt(aCanvas.handle,
          paintRect.left, paintRect.top, helper_skin.TabsDownCopyPointA.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
          helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsDownCopyPointA.x, 0, SRCCOpy);

        pointx := paintRect.left + helper_skin.TabsDownCopyPointA.y;
        while (pointX < paintRect.right - (helper_skin.TabsDownCopyPointC.Y - 1)) do begin
          wid := helper_skin.TabsDownCopyPointB.y;
          if wid = 0 then break;
          if pointx + wid > paintRect.right - (helper_skin.TabsDownCopyPointC.y - 1) then wid := (paintRect.right - (helper_skin.TabsDownCopyPointC.y - 1)) - pointx;
          BitBlt(aCanvas.Handle, pointx, 0, wid, paintRect.bottom - paintRect.top,
            helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsDownCopyPointB.x, 0, SRCCopy);
          inc(pointX, wid);
        end;

        BitBlt(aCanvas.handle, paintRect.right - helper_skin.TabsDownCopyPointC.y, 0, helper_skin.TabsDownCopyPointC.y, paintRect.bottom - paintRect.top,
          helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsDownCopyPointC.x, 0, SRCCOpy);
      end else



        if (cometpageview.csHover in (APanel as TCometPagePanel).btnState) then begin //Hover
          BitBlt(aCanvas.handle,
            paintRect.left, paintRect.top, helper_skin.TabsHoverCopyPointA.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
            helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsHoverCopyPointA.x, 0, SRCCOpy);

          pointx := paintRect.left + helper_skin.TabsHoverCopyPointA.y {y=placeholder for width};
          while (pointX < paintRect.right - (helper_skin.TabsHoverCopyPointC.y - 1)) do begin
            wid := helper_skin.TabsHoverCopyPointB.y;
            if wid = 0 then break;
            if pointx + wid > paintRect.right - (helper_skin.TabsHoverCopyPointC.y - 1) then wid := (paintRect.right - (helper_skin.TabsHoverCopyPointC.y - 1)) - pointx;
            BitBlt(aCanvas.Handle, pointx, 0, wid, paintRect.bottom - paintRect.top,
              helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsHoverCopyPointB.x, 0, SRCCopy);
            inc(pointX, wid);
          end;

          BitBlt(aCanvas.handle, paintRect.right - helper_skin.TabsHoverCopyPointC.y {y=placeholder for width}, 0, helper_skin.TabsHoverCopyPointC.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
            helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsHoverCopyPointC.x, 0, SRCCOpy);
        end else begin //Hover
          BitBlt(aCanvas.handle,
            paintRect.left, paintRect.top, helper_skin.TabsOffCopyPointA.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
            helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsOffCopyPointA.x, 0, SRCCOpy);

          pointx := paintRect.left + helper_skin.TabsOffCopyPointA.y {y=placeholder for width};
          while (pointX < paintRect.right - (helper_skin.TabsOffCopyPointC.y - 1)) do begin
            wid := helper_skin.TabsHoverCopyPointB.y;
            if wid = 0 then break;
            if pointx + wid > paintRect.right - (helper_skin.TabsOffCopyPointC.y - 1) then wid := (paintRect.right - (helper_skin.TabsOffCopyPointC.y - 1)) - pointx;
            BitBlt(aCanvas.Handle, pointx, 0, wid, paintRect.bottom - paintRect.top,
              helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsOffCopyPointB.x, 0, SRCCopy);
            inc(pointX, wid);
          end;

          BitBlt(aCanvas.handle, paintRect.right - helper_skin.TabsOffCopyPointC.y {y=placeholder for width}, 0, helper_skin.TabsOffCopyPointC.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
            helper_skin.TabsSourceBitmap.canvas.handle, helper_skin.TabsOffCopyPointC.x, 0, SRCCOpy);
        end;


end;

procedure Tares_frmmain.smallTabsPaintButton(Sender, aPanel: TObject;
  aCanvas: TCanvas; paintRect: TRect);
var
  pointX, wid: integer;
  pnl: TCometPagePanel;
  Details: TThemedElementDetails;
begin
  if helper_skin.smallTabsSourceBitmap = nil then begin

    if ThemeServices.ThemesEnabled then begin
      inc(paintRect.top, 2);

  {
  if (aPanel as TCometPagePanel).btnState=[cometpageview.csDown,cometpageview.csHover] then
  Details:=ThemeServices.GetElementDetails(ttTabItemFocused)
   else
  if ((cometpageview.csClicked in (APanel as TCometPagePanel).btnState) and
     ((cometpageview.csHover in (APanel as TCometPagePanel).btnState))) then
     Details:=ThemeServices.GetElementDetails(ttTabItemSelected)
   else    }
      if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then Details := ThemeServices.GetElementDetails(ttTabItemSelected)
      else begin
        dec(PaintRect.bottom, 1);
        if (cometpageview.csHover in (APanel as TCometPagePanel).btnState) then Details := ThemeServices.GetElementDetails(ttTabItemHot)
        else Details := ThemeServices.GetElementDetails(ttTabItemNormal);
      end;
      ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);

   // paintRect.top:=paintRect.Bottom;
   // paintRect.Bottom:=paintRect.top+1;
   // Details:=ThemeServices.GetElementDetails(ttBody);
   // ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);

      if not (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then
    //aCanvas.Brush.color:=clWhite
    // else
        aCanvas.Brush.color := clBlack;
      aCanvas.fillrect(rect(paintRect.left, paintRect.bottom, paintRect.right, paintrect.Bottom + 1));

    end else begin
      aCanvas.pen.color := clblack;
      if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then aCanvas.brush.color := cl3dlight
      else aCanvas.brush.color := clBtnface;
      aCanvas.rectangle(paintRect.left, paintRect.Top, paintRect.right, paintrect.bottom);
    end;
    exit;
  end;
//if (APanel as TCometPagePanel).btnState=[] then exit; //nothing to do


  if (aPanel as TCometPagePanel).btnState = [cometpageview.csDown, cometpageview.csHover] then begin // down/hover
    BitBlt(aCanvas.handle,
      paintRect.left, paintRect.top, helper_skin.smallTabsDownHoverCopyPointA.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
      helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsDownHoverCopyPointA.x, 0, SRCCOpy);

    pointx := paintRect.left + helper_skin.smallTabsDownHoverCopyPointA.y {y=placeholder for width};
    while (pointX < paintRect.right - (helper_skin.smallTabsDownHoverCopyPointC.y - 1)) do begin
      wid := helper_skin.smallTabsDownHoverCopyPointB.y;
      if wid = 0 then break;
      if pointx + wid > paintRect.right - (helper_skin.smallTabsDownHoverCopyPointC.y - 1) then wid := (paintRect.right - (helper_skin.smallTabsDownHoverCopyPointC.y - 1)) - pointx;
      BitBlt(aCanvas.Handle, pointx, paintRect.top, wid, paintRect.bottom - paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsDownHoverCopyPointB.x, 0, SRCCopy);
      inc(pointX, wid);
    end;

    BitBlt(aCanvas.handle, paintRect.right - helper_skin.smallTabsDownHoverCopyPointC.y, paintRect.top, helper_skin.smallTabsDownHoverCopyPointC.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
      helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsDownHoverCopyPointC.x, 0, SRCCOpy);
  end else

    if ((cometpageview.csClicked in (APanel as TCometPagePanel).btnState) and
      ((cometpageview.csHover in (APanel as TCometPagePanel).btnState))) then begin // clicked/Hover

      BitBlt(aCanvas.handle,
        paintRect.left, paintRect.top, helper_skin.smallTabsClickedCopyPointA.y, paintRect.bottom - paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsClickedCopyPointA.x, 0, SRCCOpy);

      pointx := paintRect.left + helper_skin.smallTabsClickedCopyPointA.y;
      while (pointX < paintRect.right - (helper_skin.smallTabsClickedCopyPointC.Y - 1)) do begin
        wid := helper_skin.smallTabsClickedCopyPointB.y;
        if wid = 0 then break;
        if pointx + wid > paintRect.right - (helper_skin.smallTabsClickedCopyPointC.y - 1) then wid := (paintRect.right - (helper_skin.smallTabsClickedCopyPointC.y - 1)) - pointx;
        BitBlt(aCanvas.Handle, pointx, paintRect.top, wid, paintRect.bottom - paintRect.top,
          helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsClickedCopyPointB.x, 0, SRCCopy);
        inc(pointX, wid);
      end;

      BitBlt(aCanvas.handle, paintRect.right - helper_skin.smallTabsClickedCopyPointC.y, paintRect.top, helper_skin.smallTabsClickedCopyPointC.y, paintRect.bottom - paintRect.top,
        helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsClickedCopyPointC.x, 0, SRCCOpy);
    end else

      if (cometpageview.csDown in (aPanel as TCometPagePanel).btnState) then begin // down
        BitBlt(aCanvas.handle,
          paintRect.left, paintRect.top, helper_skin.smallTabsDownCopyPointA.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
          helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsDownCopyPointA.x, 0, SRCCOpy);

        pointx := paintRect.left + helper_skin.smallTabsDownCopyPointA.y;
        while (pointX < paintRect.right - (helper_skin.smallTabsDownCopyPointC.Y - 1)) do begin
          wid := helper_skin.smallTabsDownCopyPointB.y;
          if wid = 0 then break;
          if pointx + wid > paintRect.right - (helper_skin.smallTabsDownCopyPointC.y - 1) then wid := (paintRect.right - (helper_skin.smallTabsDownCopyPointC.y - 1)) - pointx;
          BitBlt(aCanvas.Handle, pointx, paintRect.top, wid, paintRect.bottom - paintRect.top,
            helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsDownCopyPointB.x, 0, SRCCopy);
          inc(pointX, wid);
        end;

        BitBlt(aCanvas.handle, paintRect.right - helper_skin.smallTabsDownCopyPointC.y, paintRect.top, helper_skin.smallTabsDownCopyPointC.y, paintRect.bottom - paintRect.top,
          helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsDownCopyPointC.x, 0, SRCCOpy);
      end else



        if (cometpageview.csHover in (APanel as TCometPagePanel).btnState) then begin //Hover
          BitBlt(aCanvas.handle,
            paintRect.left, paintRect.top, helper_skin.smallTabsHoverCopyPointA.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
            helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsHoverCopyPointA.x, 0, SRCCOpy);

          pointx := paintRect.left + helper_skin.smallTabsHoverCopyPointA.y {y=placeholder for width};
          while (pointX < paintRect.right - (helper_skin.smallTabsHoverCopyPointC.y - 1)) do begin
            wid := helper_skin.smallTabsHoverCopyPointB.y;
            if wid = 0 then break;
            if pointx + wid > paintRect.right - (helper_skin.smallTabsHoverCopyPointC.y - 1) then wid := (paintRect.right - (helper_skin.smallTabsHoverCopyPointC.y - 1)) - pointx;
            BitBlt(aCanvas.Handle, pointx, paintRect.top, wid {y=placeholder for width}, paintRect.bottom - paintRect.top,
              helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsHoverCopyPointB.x, 0, SRCCopy);
            inc(pointX, wid);
          end;

          BitBlt(aCanvas.handle, paintRect.right - helper_skin.smallTabsHoverCopyPointC.y {y=placeholder for width}, paintRect.top, helper_skin.smallTabsHoverCopyPointC.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
            helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsHoverCopyPointC.x, 0, SRCCOpy);
        end else begin

          BitBlt(aCanvas.handle,
            paintRect.left, paintRect.top, helper_skin.smallTabsOffCopyPointA.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
            helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsOffCopyPointA.x, 0, SRCCOpy);

          pointx := paintRect.left + helper_skin.smallTabsOffCopyPointA.y {y=placeholder for width};
          while (pointX < paintRect.right - (helper_skin.smallTabsOffCopyPointC.y - 1)) do begin
            wid := helper_skin.smallTabsOffCopyPointB.y;
            if wid = 0 then break;
            if pointx + wid > paintRect.right - (helper_skin.smallTabsOffCopyPointC.y - 1) then wid := (paintRect.right - (helper_skin.smallTabsOffCopyPointC.y - 1)) - pointx;
            BitBlt(aCanvas.Handle, pointx, paintRect.top, wid, paintRect.bottom - paintRect.top,
              helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsOffCopyPointB.x, 0, SRCCopy);
            inc(pointX, wid);
          end;

          BitBlt(aCanvas.handle, paintRect.right - helper_skin.smallTabsOffCopyPointC.y {y=placeholder for width}, paintRect.top, helper_skin.smallTabsOffCopyPointC.y {y=placeholder for width}, paintRect.bottom - paintRect.top,
            helper_skin.smallTabsSourceBitmap.canvas.handle, helper_skin.smallTabsOffCopyPointC.x, 0, SRCCOpy);

        end;

  pnl := aPanel as TCometPagePanel;
  if pnl.imageindex <> -1 then begin
    imagelist_chat.draw(aCanvas, paintRect.left + (sender as TCometPageView).ButtonsLeftMargin,
      paintRect.top + (sender as TCometPageView).ButtonsTopMargin - 1,
      pnl.imageindex);
  end;

end;


procedure Tares_frmmain.resizeSearch(Sender: TObject);
var
  panel: tpanel;
begin
  panel := sender as tpanel;
  panel_search.height := panel.clientheight - panel_search.top;
  pagesrc.height := panel_search.height;
//pagesrc.width:=panel.clientwidth-panel_search.width;

  //if btn_src_togglefield.down then
  panel_search.width := 218;
  lbl_src_status.width := panel_search.clientWidth - (lbl_src_status.left * 2);
  edit_src_filter.Width := panel_search.clientWidth - (edit_src_filter.left * 2);
   // else panel_search.width:=0;

  pagesrc.left := panel_search.left + panel_search.width;
  pagesrc.width := Panel.clientwidth - pagesrc.left;

  if radio_srcmime_all.checked then begin
    lbl_src_status.top := ((panel_search.clientheight - edit_src_filter.height) - 20) - lbl_src_status.height;
    if lbl_src_status.top < radio_srcmime_other.top + 20 then lbl_src_status.top := radio_srcmime_other.top + 20;
    edit_src_filter.top := lbl_src_status.top + lbl_src_status.height + 10;
  end else
    if widestrtoutf8str(label_more_searchopt.caption) = GetLangStringA(MORE_SEARCH_OPTION_STR) then begin
      lbl_src_status.top := ((panel_search.clientheight - edit_src_filter.height) - 20) - lbl_src_status.height;
      if lbl_src_status.top < image_more_top + 20 then lbl_src_status.top := image_more_top + 20;
      edit_src_filter.top := lbl_src_status.top + lbl_src_status.height + 10;
    end else begin
      lbl_src_status.top := ((panel_search.clientheight - edit_src_filter.height) - 20) - lbl_src_status.height;
      if lbl_src_status.top < image_less_top + 20 then lbl_src_status.top := image_less_top + 20;
      edit_src_filter.top := lbl_src_status.top + lbl_src_status.height + 10;
    end;
end;

procedure Tares_frmmain.tabs_pageviewPanelShow(Sender, aPanel: TObject);
var
  pagepanel: TCometPagePanel;
begin
  pagePanel := aPanel as TCometPagePanel;

  case pagePanel.ID of
    IdxBtnLibrary: helper_gui_misc.mainGui_showlibrary;
    IdxBtnScreen: helper_gui_misc.mainGui_showscreen;
    IdxBtnSearch: helper_gui_misc.mainGui_showsearch;
    IdxBtnTransfer: helper_gui_misc.mainGui_showtransfer;
    IdxBtnChat: helper_gui_misc.mainGui_showChat;
    IdxBtnOptions: helper_gui_misc.mainGui_showoptions;
  end;

end;

procedure tares_frmmain.blendPlaylistFormDeactivate(Sender: TObject);
begin
  (sender as tform).visible := false;
  playlist_visible := false;
  blendPlaylistForm.visible := false;
end;




procedure Tares_frmmain.splitter_transferEndSplit(Sender: TObject);
begin

  with splitter_transfer do begin
 //invalidate;
    top := top + ypos;
    panelUploadHeight := ares_frmmain.panel_transfer.clientheight - (top);
  end;

  if panelUploadHeight < 100 then panelUploadHeight := 100;
  if panelUploadHeight + 100 > ares_frmmain.panel_transfer.clientheight then panelUploadHeight := ares_frmmain.panel_transfer.clientheight - 100;

  panel_tran_upqu.height := panelUploadHeight;
  splitter_transfer.top := panel_tran_upqu.Top - splitter_transfer.height;
  panel_tran_down.height := splitter_transfer.top;


  write_default_upload_height;

  panel_transferResize(panel_transfer);
end;

procedure Tares_frmmain.btns_transferResize(Sender: TObject);
begin
  if ares_frmmain.btn_tran_clearIdle.left + ares_frmmain.btn_tran_clearIdle.width + ares_frmmain.btn_tran_toggle_queup.width + 7 < ares_frmmain.btns_transfer.clientwidth then
    ares_frmmain.btn_tran_toggle_queup.left := (ares_frmmain.btns_transfer.clientwidth - ares_frmmain.btn_tran_toggle_queup.width) - 3
  else ares_frmmain.btn_tran_toggle_queup.left := ares_frmmain.btn_tran_clearIdle.left + ares_frmmain.btn_tran_clearIdle.width + 7;
end;

procedure Tares_frmmain.Splitter_chat_channelEndSplit(Sender: TObject);
begin
  splitter_chat_channel.top := splitter_chat_channel.top + splitter_chat_channel.ypos;

  chat_favorite_height := ares_frmmain.panel_list_channels.clientheight - splitter_chat_channel.top;
  if chat_favorite_height < 150 then chat_favorite_height := 150;
  if chat_favorite_height + 150 > panel_chat.clientHeight then chat_favorite_height := panel_chat.clientHeight - 150;

  reg_save_chatfav_height;
  panel_chatResize(panel_chat);
end;

procedure Tares_frmmain.panel_chatResize(Sender: TObject);
begin
  splitter_chat_channel.width := panel_list_channels.clientwidth;
  splitter_chat_channel.componentTop := panel_chat.top + panel_list_channels.top + (integer(helper_skin.SkinnedFrameLoaded) * helper_skin.fcaptionHeight);
  splitter_chat_channel.componentLefT := (integer(helper_skin.SkinnedFrameLoaded) * helper_skin.fborderWidth); //+panel_chat.left;
  splitter_chat_channel.left := 0;
  listview_chat_channel.Width := panel_list_channels.clientwidth;
  pnl_chat_fav.width := panel_list_channels.clientWidth;

  splitter_chat_channel.visible := btn_chat_fav.down;
  pnl_chat_fav.visible := btn_chat_fav.down;

  if btn_chat_fav.down then begin
    pnl_chat_fav.height := chat_favorite_height;
    pnl_chat_fav.top := panel_list_channels.clientHeight - pnl_chat_fav.height;
    splitter_chat_channel.top := pnl_chat_fav.top - splitter_chat_channel.height;
    listview_chat_channel.height := splitter_chat_channel.top;
  end else listview_chat_channel.height := panel_list_channels.clientHeight;

end;

procedure Tares_frmmain.paintToolbar(sender: TObject; Acanvas: TCanvas; capt: widestring; var should_continue: boolean);
var
  rc: TRect;
  tbar: Tpanel;
begin
  tbar := sender as tpanel;

  acanvas.brush.color := COLORE_PANELS_SEPARATOR; //$00C9B7A9;//A9B7C9;
  rc := rect(0, btns_transfer.Height - 1, tbar.clientwidth, btns_transfer.Height);
  acanvas.fillrect(rc);
end;

procedure Tares_frmmain.btn_tab_webXPButtonDraw(Sender: Tobject; TargetCanvas: Tcanvas; Rect: Trect; state: XPbutton.TCometBtnState; var should_continue: boolean);
var
  Details: TThemedElementDetails;
  drawdetail: boolean;
  gowithOsTheme: boolean;
  pointx, wid: integer;
begin
 //if ((not ThemeServices.ThemesEnabled) or (not VARS_THEMED_BUTTONS)) then begin
//  should_continue:=true;
 // exit;
// end;
  gowithOsTheme := (ThemeServices.ThemesEnabled) and (VARS_THEMED_BUTTONS);

  if (not gowithOsTheme) and (helper_skin.buttonsBitmap = nil) then begin
    should_Continue := true;
    exit;
  end;
  drawdetail := true;

  if (xpbutton.csClicked in state) and (xpbutton.csHover in state) then begin
    if gowithOsTheme then Details := ThemeServices.GetElementDetails(ttbButtonPressed) else
    begin
      BitBlt(TargetCanvas.handle, rect.left, rect.Top, rect.left + helper_skin.buttonsClickedCopyPointA.y {placeholder of width}, rect.bottom,
        helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsClickedCopyPointA.x, 0, SRCCopy);

      pointx := rect.left + helper_skin.buttonsClickedCopyPointA.y;
      while (pointX < rect.right) do begin
        wid := helper_skin.buttonsClickedCopyPointB.y;
        if wid = 0 then break;
        if pointx + wid > rect.right then wid := rect.right - pointx;
        BitBlt(targetCanvas.Handle, pointx, rect.top, pointx + wid, rect.bottom - rect.top,
          helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsClickedCopyPointB.x, 0, SRCCopy);
        inc(pointX, wid);
      end;
      BitBlt(TargetCanvas.handle, rect.right - helper_skin.buttonsClickedCopyPointC.y, rect.Top, rect.right, rect.bottom,
        helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsClickedCopyPointC.x, 0, SRCCopy);
    end;

  end else

    if (xpbutton.csHover in state) then begin
    // if (xpbutton.csDown in state) then Details := ThemeServices.GetElementDetails(ttbButtonCheckedHot)
     //  else
      if gowithOsTheme then Details := ThemeServices.GetElementDetails(ttbButtonHot) else
      begin
        BitBlt(TargetCanvas.handle, rect.left, rect.Top, rect.left + helper_skin.buttonsHoverCopyPointA.y {placeholder of width}, rect.bottom,
          helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsHoverCopyPointA.x, 0, SRCCopy);

        pointx := rect.left + helper_skin.buttonsHoverCopyPointA.y;
        while (pointX < rect.right) do begin
          wid := helper_skin.buttonsHoverCopyPointB.y;
          if wid = 0 then break;
          if pointx + wid > rect.right then wid := rect.right - pointx;
          BitBlt(targetCanvas.Handle, pointx, rect.top, pointx + wid, rect.bottom - rect.top,
            helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsHoverCopyPointB.x, 0, SRCCopy);
          inc(pointX, wid);
        end;
        BitBlt(TargetCanvas.handle, rect.right - helper_skin.buttonsHoverCopyPointC.y, rect.Top, rect.right, rect.bottom,
          helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsHoverCopyPointC.x, 0, SRCCopy);
      end;

    end else begin

      if (xpbutton.csDown in state) then begin

        if gowithOsTheme then Details := ThemeServices.GetElementDetails(ttbButtonChecked) else
        begin
          BitBlt(TargetCanvas.handle, rect.left, rect.Top, rect.left + helper_skin.buttonsDownCopyPointA.y {placeholder of width}, rect.bottom,
            helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsDownCopyPointA.x, 0, SRCCopy);

          pointx := rect.left + helper_skin.buttonsDownCopyPointA.y;
          while (pointX < rect.right) do begin
            wid := helper_skin.buttonsDownCopyPointB.y;
            if wid = 0 then break;
            if pointx + wid > rect.right then wid := rect.right - pointx;
            BitBlt(targetCanvas.Handle, pointx, rect.top, pointx + wid, rect.bottom - rect.top,
              helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsDownCopyPointB.x, 0, SRCCopy);
            inc(pointX, wid);
          end;
          BitBlt(TargetCanvas.handle, rect.right - helper_skin.buttonsDownCopyPointC.y, rect.Top, rect.right, rect.bottom,
            helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsDownCopyPointC.x, 0, SRCCopy);
        end;

      end else begin

        if gowithOsTheme then drawdetail := false {ThemeServices.GetElementDetails(ttbButtonNormal)} else
        begin
          BitBlt(TargetCanvas.handle, rect.left, rect.Top, rect.left + helper_skin.buttonsCopyPointA.y {placeholder of width}, rect.bottom,
            helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsCopyPointA.x, 0, SRCCopy);

          pointx := rect.left + helper_skin.buttonsCopyPointA.y;
          while (pointX < rect.right) do begin
            wid := helper_skin.buttonsCopyPointB.y;
            if wid = 0 then break;
            if pointx + wid > rect.right then wid := rect.right - pointx;
            BitBlt(targetCanvas.Handle, pointx, rect.top, pointx + wid, rect.bottom - rect.top,
              helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsCopyPointB.x, 0, SRCCopy);
            inc(pointX, wid);
          end;
          BitBlt(TargetCanvas.handle, rect.right - helper_skin.buttonsCopyPointC.y, rect.Top, rect.right, rect.bottom,
            helper_skin.buttonsBitmap.canvas.handle, helper_skin.buttonsCopyPointC.x, 0, SRCCopy);
        end;

      end;
    end;

  if gowithOsTheme then begin
       //// Vista ////
    TargetCanvas.brush.color := (Sender as TXPButton).Color;
    TargetCanvas.FillRect(rect);
    /////////////////////////
    if drawdetail then begin
      TargetCanvas.Brush.Style := bsClear;
      ThemeServices.DrawElement(TargetCanvas.Handle, Details, Rect, @Rect);
    end;
  end;

  should_continue := false;
end;


procedure Tares_frmmain.pnl_chat_favResize(Sender: TObject);
begin
  treeview_chat_favorites.height := (sender as tpanel).clientheight - 18;
end;

procedure Tares_frmmain.panel_chatPaintCloseButton(Sender, aPanel: TObject;
  aCanvas: TCanvas; paintRect: TRect);
var
  pagepanel: TCometPagePanel;
  Details: TThemedElementDetails;
begin
  pagePanel := aPanel as TCometPagePanel;

  if helper_skin.smallTabsSourceBitmap = nil then begin
    if ThemeServices.ThemesEnabled then begin
      if (bsHover in pagePanel.closeBtnState) then Details := ThemeServices.GetElementDetails(tbCheckBoxMixedHot)
      else Details := ThemeServices.GetElementDetails(tbCheckBoxMixedNormal);
      ThemeServices.DrawElement(aCanvas.Handle, Details, paintRect, @paintRect);
    end else aCanvas.TextOut(paintRect.left, paintRect.top, 'X');
    exit;
  end;

  if (bsHover in pagePanel.closeBtnState) then begin
 // aCanvas.brush.color:=clblack;
 // aCanvas.pen.color:=clblack;
 // aCanvas.framerect(paintRect);
    bitBlt(aCanvas.Handle, paintRect.left, paintRect.top, paintRect.Right - paintRect.left, paintRect.bottom - paintRect.top,
      helper_skin.smallTabsSourceBitmap.canvas.Handle, helper_skin.smalltabsHoverCloseBtnRect.left, helper_skin.smalltabsHoverCloseBtnRect.Top, SRCCOPY);

  end else begin
 //aCanvas.brush.color:=clgray;
 //aCanvas.pen.color:=clgray;
 //aCanvas.framerect(paintRect);
    bitBlt(aCanvas.Handle, paintRect.left, paintRect.top, paintRect.Right - paintRect.left, paintRect.bottom - paintRect.top,
      helper_skin.smallTabsSourceBitmap.canvas.Handle, helper_skin.smalltabsOffCloseBtnRect.left, helper_skin.smalltabsOffCloseBtnRect.Top, SRCCOPY);

  end;
end;



procedure tares_frmmain.closePvt(Sender, aPanel: TObject; var Proceed: boolean);
var
  pvt_chat: precord_pvt_chat_visual;
  canale: precord_canale_chat_visual;
  pnl: TCometPagePanel;
begin
  pnl := aPanel as TCometPagePanel;
  Proceed := true;

  pvt_chat := pnl.FData;
  canale := pvt_chat.canale;
  helper_chatroom_gui.pvt_chat_destroy(canale, pvt_chat);

end;


procedure Tares_frmmain.panel_chatPanelClose(Sender, aPanel: TObject; var Proceed: boolean);
var
  canale: precord_canale_chat_visual;
  pnl: TCometPagePanel;
  pannello_browse: precord_pannello_browse_chat;
  pvt_chat: precord_pvt_chat_visual;
  search_chat: ares_types.precord_pannello_result_chat;
begin
  try

    pnl := aPanel as TCometPagePanel;
    Proceed := true;

    case pnl.ID of

  { IDXChatPvt:begin   //pvt
           pvt_chat:=pnl.FData;
           canale:=pvt_chat.canale;
           helper_chatroom_gui.pvt_chat_destroy(canale,pvt_chat);
         end;}

      IDXChatMain: begin // main channel
          canale := pnl.FData;
          if check_opt_chat_autocloseroom.checked then
            if canale^.ip = 16777343 then btn_opt_chat_stopClick(nil);
          FreeAllPrivates(canale);
          detachChatBrowses(canale);
          detachChatSearches(canale);
          canale^.should_exit := true;
        end;

      IDXChatBrowse: begin //browse channel
          pannello_browse := pnl.FData;
          canale := pannello_browse^.canale;
          helper_chatroom_share.browse_chat_destroy(canale, pannello_browse);
        end;

      IDXChatSearch: begin //search channel
          search_chat := pnl.FData;
          canale := search_chat^.canale;
          helper_chatroom_share.search_chat_destroy(canale, search_chat);
        end;

    end;

  except
  end;
end;

procedure Tares_frmmain.btns_optionsResize(Sender: TObject);
begin
  settings_control.Height := btns_options.clientheight - 30;
end;

procedure Tares_frmmain.pagesrcPanelShow(Sender, aPanel: TObject);
var
  src: precord_panel_search;
  pnl: TCometPagePanel;
begin

  try
    unbold_results; // using last_shown_SRCtab
  except
  end;

  pnl := aPanel as TCometPagePanel;
  try
    if ((pnl.Fdata = nil) or (pnl.ID = IDNone)) then begin
      lbl_src_status.caption := '';
      last_shown_SRCtab := 0;
      edit_src_filter.visible := false;
      combo_search.text := '';
      clear_search_fields;
      btn_stop_search.enabled := false;
      btn_start_search.enabled := true;
      edit_src_filter.Enabled := false;
      enable_search_fields;
      exit;
    end;
  except
  end;


  try

    src := pnl.FData;

    lbl_src_status.caption := src^.lbl_src_status_caption;
    edit_src_filter.visible := true;

    last_shown_SRCtab := pagesrc.activepage; //cares next unbolding

    if src^.is_advanced then label_more_searchopt.caption := GetLangStringW(LESS_SEARCH_OPTION_STR)
    else label_more_searchopt.caption := GetLangStringW(MORE_SEARCH_OPTION_STR);


    case src^.mime_search of
      ARES_MIME_GUI_ALL: radio_srcmime_all.checked := true;
      ARES_MIME_MP3: radio_srcmime_audio.checked := true;
      ARES_MIME_VIDEO: radio_srcmime_video.checked := true;
      ARES_MIME_IMAGE: radio_srcmime_image.checked := true;
      ARES_MIME_DOCUMENT: radio_srcmime_document.checked := true;
      ARES_MIME_SOFTWARE: radio_srcmime_software.checked := true
    else radio_srcmime_other.checked := true;
    end;

     //ufrmmain.ares_frmmain.RadiosearchmimeClick(nil);

    combo_search.text := src^.combo_search_text;
    comboalbsearch.text := src^.comboalbsearch_text;
    comboautsearch.text := src^.comboautsearch_text;
    combodatesearch.text := src^.combodatesearch_text;
    combotitsearch.text := src^.combotitsearch_text;
    combocatsearch.text := src^.combocatsearch_text;
    combo_lang_search.text := src^.combo_lang_search_text;

    combo_sel_duration.itemindex := src^.combo_sel_duration_index;
    combo_sel_quality.itemindex := src^.combo_sel_quality_index;
    combo_sel_size.itemindex := src^.combo_sel_size_index;
    combo_wanted_duration.itemindex := src^.combo_wanted_duration_index;
    combo_wanted_quality.itemindex := src^.combo_wanted_quality_index;
    combo_wanted_size.itemindex := src^.combo_wanted_size_index;



    if src^.started = 0 then begin
      btn_stop_search.enabled := false;
      btn_start_search.enabled := true;
    end else begin
      btn_stop_search.enabled := true;
      btn_start_search.enabled := false;
    end;
    edit_src_filter.Enabled := src^.listview.Selectable;
    enable_search_fields;

  except
  end;
end;

procedure Tares_frmmain.pagesrcPanelClose(Sender, aPanel: TObject;
  var Proceed: Boolean);
var
  pnl: TCometPagePanel;
  src: precord_panel_search;
  ind: integer;
begin
  pnl := aPanel as TCometPagePanel;
  if pnl.ID = IDNone then begin
    proceed := false;
    exit;
  end;

  proceed := true;



  try
    src := pnl.FData;
    if src^.started <> 0 then gui_stop_search;

    clear_backup_results(src);
    src^.search_string := '';
    src^.lbl_src_status_caption := '';
    src^.combo_search_text := '';
    src^.comboalbsearch_text := '';
    src^.comboautsearch_text := '';
    src^.combodatesearch_text := '';
    src^.combotitsearch_text := '';
    src^.combocatsearch_text := '';
    src^.combo_lang_search_text := '';

    clear_treeview(src^.listview);
    src^.listview.free;
    src^.containerPanel.Free;

    if src_panel_list <> nil then begin
      ind := src_panel_list.indexof(src);
      if ind <> -1 then src_panel_list.delete(ind);
    end;

    FreeMem(src, sizeof(record_panel_search));
    cambiato_search := true; //let the client know

  except
  end;
//pagesrc.ActivePage:=0;
end;

procedure Tares_frmmain.settings_controlPanelShow(Sender, aPanel: TObject);
var
  pnl: TCometPagePanel;
begin
  pnl := aPanel as TcometPagePanel;
  if pnl.panel = pnl_opt_sharing then begin
    lbl_opt_statusconn.visible := false;
    btn_opt_connect.visible := false;
    btn_opt_disconnect.visible := false;
    lbl_shareset_hint.visible := true;
    lbl_shareset_hint.left := 16;
    mfolder.onexpanding := nil;
    update;
    application.processmessages;
    mainGUI_init_manual_share;
  end else begin
 // btn_shareset_cancelClick(nil);
    lbl_shareset_hint.visible := false;
    lbl_opt_statusconn.visible := true;
    btn_opt_connect.visible := true;
    btn_opt_disconnect.visible := true;
  end;
end;

procedure Tares_frmmain.edit_src_filterClick(Sender: TObject);
begin
  if edit_src_filter.text = GetLangStringW(STR_FILTER) then edit_src_filter.text := '';
end;

procedure Tares_frmmain.edit_lib_searchPaint(Sender: TObject;
  aCanvas: TCanvas; paintRect: TRect; btnState: TCometBtnState);
var
  edit: TCometBtnEdit;
begin
  edit := sender as tcometBtnEdit;
  acanvas.brush.color := edit.color;
  acanvas.FillRect(paintRect);
  imagelist_chat.Draw(aCanvas, paintRect.left, paintRect.top, edit.glyphindex);
end;

procedure Tares_frmmain.edit_lib_searchClick(Sender: TObject);
begin
  if edit_lib_search.text = GetLangStringW(STR_SEARCH) then edit_lib_search.text := '';
end;

procedure Tares_frmmain.edit_lib_searchBtnClick(Sender: TObject);
begin

  if edit_lib_search.glyphindex <> 12 then begin
    if btn_lib_virtual_view.down then treeview_lib_virfoldersclick(nil)
    else treeview_lib_regfoldersclick(nil);
    edit_lib_search.text := '';
  end else edit_lib_search.text := '';

  edit_lib_search.glyphindex := 12;

end;

procedure Tares_frmmain.edit_chat_chanfilterBtnClick(Sender: TObject);
begin
  if edit_chat_chanfilter.glyphindex <> 12 then begin
    edit_chat_chanfilter.text := '';
    mainGui_trigger_channelfilter;
    edit_lib_search.glyphindex := 12;
  end else edit_chat_chanfilter.text := '';


end;

procedure Tares_frmmain.edit_chat_chanfilterClick(Sender: TObject);
begin
  if edit_chat_chanfilter.text = GetLangStringW(STR_FILTER) then edit_chat_chanfilter.text := '';
end;

procedure Tares_frmmain.edit_chat_chanfilterBtnStateChange(
  Sender: TObject);
begin
//
end;

procedure Tares_frmmain.edit_src_filterBtnClick(Sender: TObject);
var
  wor: word;
begin
  if edit_src_filter.glyphindex <> 12 then begin
    edit_src_filter.text := '';
    wor := 13;
    edit_src_filterkeyup(edit_src_filter, wor, []);
    edit_src_filter.glyphindex := 12;
  end else edit_src_filter.text := '';
end;

procedure Tares_frmmain.listview_libPaintHeader(Sender: TBaseCometTree;
  TargetCanvas: TCanvas; R: TRect; isDownIndex, isHoverIndex: Boolean;
  var shouldContinue: Boolean);

var
  pointX, wid: integer;
begin
  if (helper_skin.listviewHeaderBitmap = nil) or (VARS_THEMED_HEADERS) then begin
    shouldContinue := true;
    exit;
  end;

//targetcanvas.brush.color:=clgray;
//targetcanvas.framerect(r);
  shouldContinue := false;

  if ((not isDownIndex) and (not isHoverIndex)) then begin
    bitBlt(TargetCanvas.handle, r.left, r.top, r.left + helper_skin.listviewHeaderCopyPointA.y {placeholder for width}, r.bottom - r.top,
      helper_skin.listviewHeaderBitmap.canvas.handle, helper_skin.listviewHeaderCopyPointA.x, 0, SRCCOPY);

    pointx := r.left + helper_skin.listviewHeaderCopyPointA.y; //paintRect.left+helper_skin.smallTabsOffCopyPointA.y{y=placeholder for width};
    while (pointX < r.right) do begin
      wid := helper_skin.listviewHeaderCopyPointB.y;
      if wid = 0 then break;
      if pointx + wid > r.right then wid := r.right - pointx;
      BitBlt(targetCanvas.Handle, pointx, r.top, pointx + wid, r.bottom - r.top,
        helper_skin.listviewHeaderBitmap.canvas.handle, helper_skin.listviewHeaderCopyPointB.x, 0, SRCCopy);
      inc(pointX, wid);
    end;

  end else
    if (isHoverIndex) and (not isDownIndex) then begin
      bitBlt(TargetCanvas.handle, r.left, r.top, r.left + helper_skin.listviewHeaderHoverCopyPointA.y {placeholder for width}, r.bottom - r.top,
        helper_skin.listviewHeaderBitmap.canvas.handle, helper_skin.listviewHeaderHoverCopyPointA.x, 0, SRCCOPY);

      pointx := r.left + helper_skin.listviewHeaderHoverCopyPointA.y; //paintRect.left+helper_skin.smallTabsOffCopyPointA.y{y=placeholder for width};
      while (pointX < r.right) do begin
        wid := helper_skin.listviewHeaderHoverCopyPointB.y;
        if wid = 0 then break;
        if pointx + wid > r.right then wid := r.right - pointx;
        BitBlt(targetCanvas.Handle, pointx, r.top, pointx + wid, r.bottom - r.top,
          helper_skin.listviewHeaderBitmap.canvas.handle, helper_skin.listviewHeaderHoverCopyPointB.x, 0, SRCCopy);
        inc(pointX, wid);
      end;

    end else begin
      bitBlt(TargetCanvas.handle, r.left, r.top, r.left + helper_skin.listviewHeaderDownCopyPointA.y {placeholder}, r.bottom - r.top,
        helper_skin.listviewHeaderBitmap.canvas.handle, helper_skin.listviewHeaderDownCopyPointA.x, 0, SRCCOPY);

      pointx := r.left + helper_skin.listviewHeaderDownCopyPointA.y; //paintRect.left+helper_skin.smallTabsOffCopyPointA.y{y=placeholder for width};
      while (pointX < r.right) do begin
        wid := helper_skin.listviewHeaderDownCopyPointB.y;
        if wid = 0 then break;
        if pointx + wid > r.right then wid := r.right - pointx;
        BitBlt(targetCanvas.Handle, pointx, r.top, pointx + wid, r.bottom - r.top,
          helper_skin.listviewHeaderBitmap.canvas.handle, helper_skin.listviewHeaderDownCopyPointB.x, 0, SRCCopy);
        inc(pointX, wid);
      end;
      bitBlt(TargetCanvas.handle, r.right - helper_skin.listviewHeaderDownCopyPointC.y, r.top, r.right, r.bottom - r.top,
        helper_skin.listviewHeaderBitmap.canvas.handle, helper_skin.listviewHeaderDownCopyPointC.x, 0, SRCCOPY);
    end;

  if sender = listview_chat_channel then begin
    dec(r.top);
    TargetCanvas.brush.color := (sender as tcomettree).color;
    TargetCanvas.fillrect(rect(r.left, r.Top, r.right, r.top + 2));
    inc(r.top, 2);
    exit;
  end;

  if (sender <> listview_lib) and
    (sender <> treeview_download) and
    (sender <> treeview_upload) and
    (sender <> treeview_queue) and
    (sender <> listview_chat_channel) then begin

    if sender.parent <> nil then
      if sender.parent.parent <> nil then
        if sender.parent.parent = pagesrc then exit; // search

    if tabs_pageview.activepage = IDTAB_CHAT then begin
      if panel_chat.activepage > high(panel_chat.panels) then exit; //deleting panel?
      if (panel_chat.panels[panel_chat.activepage].ID = IDXChatSearch) or (panel_chat.panels[panel_chat.activepage].ID = IDXChatBrowse) then exit;
    end;

    TargetCanvas.brush.color := (sender as tcomettree).colors.BorderColor;
    TargetCanvas.fillrect(rect(r.left, r.Top, r.right, r.top + 1));
  end;

end;

procedure Tares_frmmain.AddRemovefolderstosharelist2Click(Sender: TObject);
begin
  tabs_pageview.activepage := IDTAB_OPTION;
  settings_control.activePage := 7;

end;

procedure Tares_frmmain.tray_showPlaylistClick(Sender: TObject);
begin
  if widestrtoutf8str(tray_minimize.caption) <> GetLangStringA(STR_HIDE_ARES) then tray_MinimizeClick(nil);
  toggle_playlist;
end;

procedure Tares_frmmain.check_opt_gen_msnsongClick(Sender: TObject);
begin
  if not check_opt_gen_msnsong.checked then msnNowPlaying.UpdateMsn('', '', '', false);
  set_reginteger('General.MSNSongNotif', integer(check_opt_gen_msnsong.checked));
end;

procedure Tares_frmmain.check_opt_chat_taskbtnClick(Sender: TObject);
var
  pchan: precord_canale_chat_visual;
  pvt: precord_pvt_chat_visual;
  i, h: integer;
begin
  set_reginteger('ChatRoom.ShowTaskBtn', integer(check_opt_chat_taskbtn.checked));

  try

    if list_chatchan_visual = nil then exit;

    for i := 0 to list_chatchan_visual.count - 1 do begin
      pchan := list_chatchan_visual[i];

      with pchan^ do begin
        if check_opt_chat_taskbtn.checked then begin
          if frmTab = nil then begin
            frmTab := ufrmChatTab.TfrmChatTab.create(ares_frmmain);
            (frmTab as TfrmChatTab).channel := pchan;
            ImageList_chat.GetIcon(2, frmTab.Icon);
            frmTab.windowState := wsMinimized;
            (frmTab as tfrmChatTab).SetCaption;
            frmTab.Show;
          end;
        end else begin
          if frmTab <> nil then begin
            frmTab.release;
            frmTab := nil;
          end;
        end;
      end;

      if pchan^.lista_pvt <> nil then
        for h := 0 to pchan^.lista_pvt.count - 1 do begin
          pvt := pchan^.lista_pvt[h];
          with pvt^ do begin
            if check_opt_chat_taskbtn.checked then begin
              if frmtab = nil then begin
                frmTab := ufrmChatTab.TfrmChatTab.create(ares_frmmain);
                (frmTab as TfrmChatTab).pvt := pvt;
                ares_frmmain.ImageList_chat.GetIcon(9, frmTab.Icon);
                frmTab.windowState := wsMinimized;
                (frmTab as tfrmChatTab).SetCaption;
                frmTab.Show;
              end;
            end else begin
              if frmTab <> nil then begin
                frmTab.release;
                frmTab := nil;
              end;
            end;
          end;
        end;
    end;


  except
  end;
end;

procedure tares_frmmain.toggleChatTaskButtonClick(sender: TObject);
var
  btn: TXPButton;
  pnl: TCometPagePanel;
  pchan: precord_canale_chat_visual;
  pvt: precord_pvt_chat_visual;
begin
  btn := (sender as TXPButton);
  btn.down := not btn.Down;

  pnl := panel_chat.panels[panel_chat.activePage];
  case pnl.ID of

    IDXChatMain: begin
        pchan := pnl.FData;
        if pchan^.containerPageview.activePage = 0 then begin
          with pchan^ do begin
            if buttonToggleTask.down then begin
              if frmtab = nil then begin
                frmTab := ufrmChatTab.TfrmChatTab.create(ares_frmmain);

                (frmTab as TfrmChatTab).channel := pchan;
                ImageList_chat.GetIcon(2, frmTab.Icon);
                frmTab.windowState := wsMinimized;
                (frmTab as tfrmChatTab).SetCaption;
                frmTab.show;
              end;
            end else begin
              if frmTab <> nil then begin
                (frmTab as TfrmChatTab).release;
                frmTab := nil;
              end;
            end;
          end;
        end else begin //PVT

          pnl := pchan^.containerPageview.panels[pchan^.containerPageview.activePage];
          pvt := pnl.FData;
          with pvt^ do begin
            if buttonToggleTask.down then begin
              if frmTab = nil then begin
                frmTab := ufrmChatTab.TfrmChatTab.create(ares_frmmain);
                (frmTab as TfrmChatTab).pvt := pvt;
                ares_frmmain.ImageList_chat.GetIcon(9, frmTab.Icon);
                frmTab.windowState := wsMinimized;
                (frmTab as tfrmChatTab).SetCaption;
                frmTab.Show;
              end;
            end else begin
              if frmTab <> nil then begin
                frmTab.release;
                frmTab := nil;
              end;
            end;
          end;
        end;

      end;


  end;

end;

procedure Tares_frmmain.lbl_opt_homepageClick(Sender: TObject);
begin
  browser_go(STR_DEFAULT_WEBSITE);
end;

procedure Tares_frmmain.lbl_opt_homepageMouseLeave(Sender: TObject);
begin
  (sender as TLabel).font.style := [];
end;

procedure Tares_frmmain.lbl_opt_homepageMouseEnter(Sender: TObject);
begin
  (sender as TLabel).font.style := [fsUnderline];
end;

procedure Tares_frmmain.Stop2Click(Sender: TObject);
begin
  helper_player.stopmedia(sender);
end;



procedure Tares_frmmain.panel_playlistPaint(sender: TObject;
  Acanvas: TCanvas; capt: WideString; var should_continue: Boolean);
var
  widestr: widestring;
  r: Trect;
  pnl: TCometTopicPnl;
begin
  should_Continue := true;
  if sender = panel_playlist then begin
    r := rect(0, 0, panel_playlist.width, 20);
    acanvas.brush.color := panel_playlist.color;
    acanvas.pen.Color := cl3ddkshadow;
    acanvas.rectangle(r.left - 1, r.top, r.right + 1, r.bottom);
    widestr := GetLangStringW(STR_PLAYLIST);
    SetBkMode(acanvas.Handle, TRANSPARENT);
    Windows.ExtTextOutW(acanvas.Handle, r.left + 6, r.top + 3, 0, @r, PwideChar(widestr), Length(widestr), nil);
  end else
    if sender = panel_hash then begin
      r := rect(0, 0, panel_playlist.width, 20);
      acanvas.brush.color := panel_hash.color;
      acanvas.pen.Color := listview_lib.colors.bordercolor;
      acanvas.rectangle(r.left - 1, r.top - 1, r.right + 1, r.bottom);
    end else begin // chat browse's panel left
      pnl := sender as tcometTopicPnl;
      r := rect(0, 0, pnl.width, 26);
      acanvas.brush.color := pnl.color;
      acanvas.pen.Color := listview_lib.colors.bordercolor;
      acanvas.rectangle(r.left - 1, r.top - 1, r.right, r.bottom);
    end;

end;

procedure Tares_frmmain.btn_opt_chat_stopClick(Sender: TObject);
begin
  try
    stopChatService;
  except
  end;
end;

procedure Tares_frmmain.btn_opt_chat_startClick(Sender: TObject);
begin
  startChatService;
end;

procedure Tares_frmmain.btn_opt_chat_joinClick(Sender: TObject);
begin
  JoinHostedChannel;
end;

procedure Tares_frmmain.check_opt_chat_autocloseroomClick(Sender: TObject);
begin
  set_reginteger('ChatRoom.AutoClose', integer(check_opt_chat_autocloseroom.checked));
end;

procedure Tares_frmmain.radio_srcmime_audioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if btn_stop_search.enabled then btn_stop_searchclick(nil);
end;

procedure Tares_frmmain.TntFormPaint(Sender: TObject);
begin
  if not helper_skin.SkinnedFrameLoaded then inherited
  else paintFrame;
end;

procedure Tares_frmmain.check_opt_chat_noemotesClick(Sender: TObject);
begin
  set_reginteger('ChatRoom.BlockEmotes', integer(check_opt_chat_noemotes.checked));
end;

procedure Tares_frmmain.Shoutcast1Click(Sender: TObject);
begin
  utility_ares.browser_go('http://www.shoutcast.com');
end;

procedure Tares_frmmain.uner21Click(Sender: TObject);
begin
  utility_ares.browser_go('http://www.tuner2.com');
end;

procedure Tares_frmmain.RadioToolbox1Click(Sender: TObject);
begin
  utility_ares.browser_go('http://www.radiotoolbox.com/dir/');
end;

procedure Tares_frmmain.tray_StopClick(Sender: TObject);
begin
  stopmedia(sender);
end;

procedure Tares_frmmain.btn_opt_chat_setClick(Sender: TObject);
begin
  if btn_opt_chat_stop.enabled then btn_opt_chat_stopclick(btn_opt_chat_stop);
  Tnt_ShellExecuteW(0, 'open', pwidechar(widestring('notepad')), pwidechar(app_path + '\Data\ChatConf.txt'), nil, SW_SHOWNORMAL);
end;

initialization
  ThemeServices := TThemeServices.Create;
  OleInitialize(nil);

finalization
  ThemeServices.Free;
  OleUninitialize;

end.

