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
obtain list of available channels(client) and add/update and entry in it(server)

a GWebCache webpage is at http://data.warezclient.com/gcache

!!! please keep a localist of entries and avoid too frequent queries !!!

ips are compressed using zlib
to obtain TCP port value from IP number one must call 'get_ppca' function



quick command reference:
 MSG_CCACHE_SEND_CHANNELS                        = 71;
 MSG_CCACHE_HERE_CHANNELS                        = 72;
 MSG_CCACHE_ENDOF_CHANNELS                       = 73;



function get_ppca(ni:cardinal):word;
var
primo,secondo,terzo,quarto:cardinal;
str:string;
begin
   str:=int_2_dword_string(ni);

      primo:=ord(str[1]); secondo:=primo; terzo:=primo; quarto:=primo;

     result:=(primo*primo)+wh(str);
     result:=result+(primo*primo)+wh(str);
     result:=result+(primo*primo)+wh(str);
     result:=result+wh(int_2_word_string(result)+
                    int_2_word_string(1214))+
                    wh(str);

     result:=result+22809;
     result:=result-(12*(primo-5))+52728;

      if result<1024 then result:=result+2048;
      if result=36278 then inc(result);
end;

function wh(x:string):word;  //gnutella query routing word hashing
var
xors:integer;
j,b:integer;
i:integeR;
prod,ret:int64;
bits:byte;
begin
     bits:=16;//log2(size);
     log (2) 655354  = 16 14;

    x:=lowercase(x);
    xors := 0;
    j   := 0;

    for i:=1 to length(x) do begin
        b := ord(x[i]) and $FF;
        b  := b shl (j * 8);
        xors := xors xor b;
        j   := (j + 1) mod 4;
    end;

    prod := xors * $4F1BBCDC;
    ret  := prod shl 32;
    ret  := ret shr (32 + (32 - bits));
    result:= word(ret);
end;
}


unit helper_channellist;

interface

uses
  Classes, utility_ares, zlib, windows, const_ares,
  blcksock, sysutils, ares_types, comettrees, winsock,
  synsock, classes2, registry, tntwindows, math, cometPageView;




type
  tthread_channellist = class(TThread)
  private
    was_searching: boolean;
    host_per_synchronize,
      serBackup,
      str: string; //per parse gruppo zlib in solo passaggio synch add_this
    filtered_strings: tmystringlist;
    db: thandlestream;

    ip, alt_ip: cardinal;
    port, users: word;
    chname, topic: string;
    stripped_topic: widestring;
    has_colors_intopic: boolean;
  protected
    procedure Execute; override;
    function cache_get: string;
    procedure cache_refresh_host; //synch
    procedure WriteChannelToDisk(const strin: string);
    procedure GUI_searching;
    procedure GUI_error; //synch

    procedure add_channels(strin: string);
    procedure add_channel(filtered_strings: tmystringlist; serialize: string); overload;
    procedure add_channel; overload; //sync


    procedure prepare_header; //synch
    procedure unprepare_header; //synch

    procedure end_update; //synch

    procedure setLastUpdated; //synch
  end;

type
  tthread_parser_chatlist = class(tthread)
  protected
    chan_ser: string;
    filtered_strings: tmystringlist;

    ip, alt_ip: cardinal;
    port, users: word;
    chname, topic: string;
    stripped_topic: widestring;
    has_colors_intopic: boolean;
    procedure execute; override;
    procedure prepare_header;
    procedure add_chan(dummy: boolean); overload;
    procedure add_chan; overload; //synch
    procedure endUpd; //synch
    procedure ChatListStats; //synch
    procedure BeginUpd; //sync
    procedure failed_parse; //synch
  end;

procedure clear_chanlist_backup;
procedure mainGui_trigger_channelfilter;
procedure export_channellist;
procedure export_channel_hashlink;
function channel_to_arlnk(chan: precord_displayed_channel; plaintext: boolean = false): string;
procedure join_arlnk_chat(serialized: string; isPlaintext: boolean = false);
procedure join_channel(datas: precord_displayed_channel);
function fav_channel_to_arlnk(chan: precord_chat_favorite; plaintext: boolean = false): string;
procedure export_favorite_channel_hashlink; //export single channel hashlink
function LoadChatListFromDisk: boolean;
function add_channel(ip, alt_ip: cardinal; port, users: word; const chname, topic: string;
  stripped_topic: widestring; has_colors_intopic: boolean; addBackup: boolean = true; checkFilter: boolean = true; killduplicates: boolean = true): boolean;

procedure add_channel_fromreg;
procedure ChatListPutStats;
procedure chatlist_GUI_error;
function channellist_find_root(ip: cardinal; var Oldchildnode: pcmtvnode): pcmtvnode;
function Chatlist_GetUserStatStr(node: PcmtVnode): string;
function checkChatUserFilter(split_string: Tmystringlist; const matchStr: string): boolean;
function chatlist_getrealcount: integer;
procedure add_mandatory_channels;
procedure strip_tags_from_name(var sname: string; var stopic: string);

implementation

uses
  ufrmmain, helper_crypt, const_timeouts, helper_unicode, vars_localiz,
  helper_strings, helper_sockets, helper_ipfunc, helper_chatroom,
  helper_ares_cacheservers, const_cache_commands, vars_global,
  helper_base64_32, helper_chatroom_gui, helper_gui_misc, helper_datetime,
  thread_client_chat, helper_diskio, helper_filtering, helper_registry,
  helper_urls;


function LoadChatListFromDisk: boolean;
begin
  result := true;
  if not fileexistsW(data_path + '\Data\ChannelList.dat') then begin
    set_regInteger('ChatRoom.LastList', 0);
    result := false;
    exit;
  end;

  tthread_parser_chatlist.create(false);
end;

procedure tthread_parser_chatlist.BeginUpd; //sync
begin
  ares_frmmain.listview_chat_channel.beginupdate;
end;

procedure tthread_parser_chatlist.prepare_header; //sync
begin
  with ares_frmmain.listview_chat_channel do begin
    beginupdate;
    canbgcolor := true;
    selectable := true;
    with header.columns do begin
      Items[0].text := GetLangStringW(STR_NAME);
      Items[1].text := GetLangStringW(STR_USERS);
      Items[2].text := GetLangStringW(STR_TOPIC);
      Items[0].width := gettextwidth(Items[0].text, ares_FrmMain.canvas) + 30;
      if Items[0].width < 200 then Items[0].width := 200;
      Items[1].width := gettextwidth(Items[1].text, ares_FrmMain.canvas) + 30;
      Items[2].width := (ares_frmmain.listview_chat_channel.width - (Items[1].width + Items[0].width)) - 60;
    end;
  end;
end;

procedure tthread_parser_chatlist.failed_parse; //synch
begin
  set_regInteger('ChatRoom.LastList', 0);
  ufrmmain.ares_frmmain.btn_chat_refchanlistClick(nil);
end;

procedure tthread_parser_chatlist.execute;
var
  db: thandlestream;
  len: word;
  i: integer;
begin
  freeonterminate := true;
  priority := tphigher;

  db := MyFileOpen(data_path + '\Data\ChannelList.dat', ARES_READONLY_BUT_SEQUENTIAL);
  if db = nil then begin
    synchronize(failed_parse);
    exit;
  end;

  filtered_strings := tmystringlist.create;
  init_keywfilter('ChanListFilter', filtered_strings);

  try

    i := 0;
    synchronize(prepare_header);


    while (db.position < db.size) do begin
      db.read(len, 2);
      if len = 0 then break;

      if len > 1024 then begin
        db.position := db.position + len;
        continue;
      end;

      setLength(chan_ser, len);
      db.Read(chan_ser[1], len);


      inc(i);

      add_chan(true);

      if i = 100 then begin
        synchronize(EndUpd);
        sleep(100);
        synchronize(BeginUpd);
      end;



    end;


  except
  end;

  synchronize(prepare_header);
  synchronize(EndUpd);


  FreeHandleStream(db);
  filtered_strings.free;

  synchronize(ChatListStats);
end;

procedure tthread_parser_chatlist.ChatListStats; //synch
begin
  helper_channellist.add_mandatory_channels;

  ares_frmmain.listview_chat_channel.sort(nil, 1, sddescending);
  ChatListPutStats;
end;

procedure strip_tags_from_name(var sname: string; var stopic: string);
var
  i: integer;
  lochname: string;
begin


  while true do begin
    lochname := lowercase(sname);

    i := pos(' -', lochname);
    if i > 0 then begin
      delete(sname, i, 3);
      continue;
    end;

    i := pos(' ', lochname);
    if i > 0 then begin
      delete(sname, i, 2);
      continue;
    end;

    i := pos('[is]', lochname);
    if i > 0 then begin
      delete(sname, i, 4);
      stopic := '[is] ' + stopic;
      continue;
    end;

    i := pos('[asax]', lochname);
    if i > 0 then begin
      delete(sname, i, 6);
      stopic := '[ASAX] ' + stopic;
      continue;
    end;

    i := pos('[dg-x]', lochname);
    if i > 0 then begin
      delete(sname, i, 6);
      stopic := '[Dg-x] ' + stopic;
      continue;
    end;

    i := pos('[Σk]', lochname);
    if i > 0 then begin
      delete(sname, i, 5);
      stopic := '[ΣK] ' + stopic;
      continue;
    end;

    i := pos('[ae]', lochname);
    if i > 0 then begin
      delete(sname, i, 4);
      stopic := '[AE] ' + stopic;
      continue;
    end;

    i := pos(chr(160), lochname);
    if i > 0 then delete(lochname, i, 1);

    break;
  end;

end;

procedure tthread_parser_chatlist.add_chan(dummy: boolean);
begin
  move(chan_ser[1], ip, 4);
//ip:=chars_2_dword(copy(chan_ser,1,4));
  move(chan_ser[5], port, 2);
//port:=chars_2_word(copy(chan_ser,5,2));
//users:=chars_2_word(copy(chan_ser,7,2));
  move(chan_ser[7], users, 2);

  if users > 700 then exit; //can't be
  if users = 0 then exit;

  if users > 300 then exit;

  delete(chan_ser, 1, 8);
  chname := copy(chan_ser, 1, pos(CHRNULL, chan_ser) - 1);


  delete(chan_ser, 1, pos(CHRNULL, chan_ser));
  topic := copy(chan_ser, 1, pos(CHRNULL, chan_ser) - 1);
  delete(chan_ser, 1, pos(CHRNULL, chan_ser));

  strip_Tags_From_Name(chname, topic);

  if length(chname) < 4 then exit; //another can't be

  stripped_topic := strip_color_string(utf8strtowidestr(topic), has_colors_intopic);

  if length(chan_ser) >= 4 then move(chan_ser[1], alt_ip, 4) //alt_ip:=chars_2_dword(copy(chan_ser,1,4))     //we have internal IP for this entry
  else alt_ip := 0;

  synchronize(add_chan);
end;

procedure tthread_parser_chatlist.add_chan; //sync
begin
  add_channel(ip, alt_ip, port, users, chname, topic, stripped_topic, has_colors_intopic, true, false, false);
end;

procedure tthread_parser_chatlist.endUpd; //synch
begin
  with ares_frmmain.listview_chat_channel do endupdate;
end;

function channel_to_arlnk(chan: precord_displayed_channel; plaintext: boolean = false): string;
var
  str: string;
begin
  if plaintext then begin
    result := 'arlnk://Chatroom:' + ipint_to_dotstring(chan^.ip) + ':' + inttostr(chan^.port) + '|' + chan^.name + ' (' + ipint_to_dotstring(chan^.alt_ip) + ')';
    exit;
  end;

  str := CHRNULL + CHRNULL + CHRNULL + CHRNULL +
    CHRNULL + CHRNULL + CHRNULL + CHRNULL +
    CHRNULL + CHRNULL + CHRNULL + CHRNULL +
    CHRNULL + CHRNULL + CHRNULL + CHRNULL +
    CHRNULL + CHRNULL + CHRNULL + CHRNULL +
    'CHATCHANNEL' + CHRNULL +
    int_2_dword_string(chan^.ip) +
    int_2_word_string(chan^.port) +
    int_2_dword_string(chan^.alt_ip) +
    chan^.name + CHRNULL +
        //chan^.topic+    // 12/26/2005 removed topic , shorter hashlink
  CHRNULL;

  str := zcompressstr(str);
  str := e67(str, 28435);

  result := 'arlnk://' + encodebase64(str);
end;

function fav_channel_to_arlnk(chan: precord_chat_favorite; plaintext: boolean = false): string;
var
  str: string;
begin
  if plaintext then begin
    result := 'arlnk://Chatroom:' + ipint_to_dotstring(chan^.ip) + ':' + inttostr(chan^.port) + '|' + chan^.name + ' (' + ipint_to_dotstring(chan^.alt_ip) + ')';
    exit;
  end;

  str := CHRNULL + CHRNULL + CHRNULL + CHRNULL +
    CHRNULL + CHRNULL + CHRNULL + CHRNULL +
    CHRNULL + CHRNULL + CHRNULL + CHRNULL +
    CHRNULL + CHRNULL + CHRNULL + CHRNULL +
    CHRNULL + CHRNULL + CHRNULL + CHRNULL +
    'CHATCHANNEL' + CHRNULL +
    int_2_dword_string(chan^.ip) +
    int_2_word_string(chan^.port) +
    int_2_dword_string(chan^.alt_ip) +
    chan^.name + CHRNULL +
        //chan^.topic+
  CHRNULL;

  str := zcompressstr(str);
  str := e67(str, 28435);

  result := 'arlnk://' + encodebase64(str);
end;



procedure join_arlnk_chat(serialized: string; isPlaintext: boolean = false);
var
  ip, alt_ip: cardinal;
  locrc, port: word;
  chname, topic, ips, lochname, urlDeco: string;
  chan: precord_displayed_channel;
  has_colors_intopic: boolean;
begin

  if isPlainText then begin
    ips := copy(serialized, 1, pos(':', serialized) - 1);
    ip := inet_addr(pchar(ips));
    delete(serialized, 1, pos(':', serialized));
    port := strtointdef(copy(serialized, 1, pos('|', serialized) - 1), 0);
    delete(serialized, 1, pos('|', serialized));
    if serialized[length(serialized)] = '/' then delete(serialized, length(serialized), 1);
    urlDeco := helper_urls.urldecode(serialized);

    if length(urlDeco) = length(serialized) then chname := serialized
    else chname := urldeco; //browser urlencodes UTF-8

    topic := '';
    alt_ip := 0;
  end else begin
    ip := chars_2_dword(copy(serialized, 1, 4));
    port := chars_2_word(copy(serialized, 5, 2));
    alt_ip := chars_2_dword(copy(serialized, 7, 4));
    if port = 0 then exit;
    if ip = 0 then exit;

    delete(serialized, 1, 10);
    chname := copy(serialized, 1, pos(CHRNULL, serialized) - 1);
    if length(chname) < MIN_CHAT_NAME_LEN then exit;

    delete(serialized, 1, pos(CHRNULL, serialized));
    topic := copy(serialized, 1, pos(CHRNULL, serialized) - 1);
    ips := ipint_to_dotstring(ip);
  end;

  lochname := lowercase(chname);
  locrc := stringcrc(lochname, true);

  chan := AllocMem(sizeof(record_displayed_channel));
  chan^.ip := ip;
  chan^.port := port;
  chan^.name := chname;
  chan^.locrc := locrc;
  chan^.topic := topic;
  chan^.stripped_topic := strip_color_string(utf8strtowidestr(topic), has_colors_intopic);
  chan^.has_colors_intopic := has_colors_intopic;
  chan^.users := 1; //don't know...
  chan^.alt_ip := alt_ip;

  join_channel(chan);
  if ares_frmmain.tabs_pageview.activepage <> IDTAB_CHAT then ares_frmmain.tabs_pageview.activepage := IDTAB_CHAT;

  with chan^ do begin
    name := '';
    topic := '';
    stripped_topic := '';
  end;
  FreeMem(chan, sizeof(record_displayed_channel));
end;


//join channel triggered event

procedure join_channel(datas: precord_displayed_channel);
var
  i: integer;
  pcanale: precord_canale_chat_visual;
begin
  try

    with ares_frmmain do begin

      for i := 0 to list_chatchan_visual.count - 1 do begin
        pcanale := list_chatchan_visual[i];
        if ((pcanale^.ip = datas^.ip) and
          ((pcanale^.alt_ip = datas^.alt_ip) and (pcanale^.port = datas^.port))) then begin
          panel_chat.activepanel := pcanale^.containerPageview;
          exit;
        end;
      end;

                                         //ora inviamo in widestring
      Pcanale := channel_create_visuals(utf8strtowidestr(datas^.name), datas^.topic);
      with pcanale^ do begin
        ip := datas^.ip;
        just_created := true;
        alt_ip := datas^.alt_ip;
        port := datas^.port;
        out_text := tmystringlist.create;
        support_pvt := false; //di default non supportiamo extra features
        support_files := false;
      end;

      list_chatchan_visual.add(pcanale);

      panel_chat.activepage := panel_chat.PanelsCount - 1;
      mainGui_togglechats(pcanale, false, false, nil);

      helper_chatroom_gui.out_text_memo(pcanale^.memo, COLORE_NOTIFICATION, '', GetLangStringW(STR_CONNECTING_PLEASE_WAIT));

      if client_chat <> nil then exit;
      client_chat := tthread_client_chat.create(false);

    end;

  except
  end;
end;

procedure export_favorite_channel_hashlink; //export single channel hashlink
var
  node: pcmtvnode;
  chan: precord_chat_favorite;
  buffer: array[0..500] of char;
  stream: thandlestream;
  str: string;
  filenw: widestring;
begin
  with ares_frmmain do begin
    node := treeview_chat_favorites.getfirstselected;
    if node = nil then exit;

    filenw := vars_global.data_path + '\Temp\' + formatdatetime('mm-dd-yyyy hh.nn.ss', now) + ' Channel Hashlink.txt';

    tntwindows.Tnt_createdirectoryW(pwidechar(data_path + '\Temp'), nil);

    stream := MyFileOpen(filenw, ARES_CREATE_ALWAYSAND_WRITETHROUGH);
    if stream = nil then exit;

    with stream do begin
      chan := treeview_chat_favorites.getdata(node);
      str := chan^.name + CRLF +
        fav_channel_to_arlnk(chan) + CRLF + CRLF;
      move(str[1], buffer, length(str));
      write(buffer, length(str));
    end;
    FreeHandleStream(stream);
  end;

  Tnt_ShellExecuteW(0, 'open', pwidechar(widestring('notepad')), pwidechar(filenw), nil, SW_SHOW);
end;

procedure export_channel_hashlink; //export single channel hashlink
var
  node: pcmtvnode;
  chan: precord_displayed_channel;
  buffer: array[0..500] of char;
  stream: thandlestream;
  str: string;
  filenw: widestring;
begin
  with ares_frmmain do begin
    node := listview_chat_channel.getfirstselected;
    if node = nil then exit;

    filenw := vars_global.data_path + '\Temp\' + formatdatetime('mm-dd-yyyy hh.nn.ss', now) + ' Channel Hashlink.txt';

    tntwindows.Tnt_createdirectoryW(pwidechar(data_path + '\Temp'), nil);

    stream := MyFileOpen(filenw, ARES_CREATE_ALWAYSAND_WRITETHROUGH);
    if stream = nil then exit;

    with stream do begin
      chan := listview_chat_channel.getdata(node);
      str := chan^.name + CRLF +
        channel_to_arlnk(chan) + CRLF;

      if vars_global.IDEIsRunning then
        str := str +
          channel_to_arlnk(chan, true) + CRLF + CRLF
      else
        str := str + CRLF;

      move(str[1], buffer, length(str));
      write(buffer, length(str));
    end;
    FreeHandleStream(stream);
  end;

  Tnt_ShellExecuteW(0, 'open', pwidechar(widestring('notepad')), pwidechar(filenw), nil, SW_SHOW);
end;

// export channellist , this list may be of some use to website-chat owners

procedure export_channellist;
var
  node: pcmtvnode;
  chan: precord_displayed_channel;
  buffer: array[0..1023] of char;
  stream: thandlestream;
  str: string;
  filenw: widestring;
begin
  with ares_frmmain do begin

    if listview_chat_channel.rootnodecount = 0 then exit;
    filenw := vars_global.data_path + '\Temp\' + formatdatetime('mm-dd-yyyy hh.nn.ss', now) + ' Ares ChannelList.txt';

    tntwindows.Tnt_createdirectoryW(pwidechar(data_path + '\Temp'), nil);


    stream := MyFileOpen(filenw, ARES_CREATE_ALWAYSAND_WRITETHROUGH);
    if stream = nil then exit;

    with stream do begin

      node := listview_chat_channel.getfirst;
      while (node <> nil) do begin

        if node.childcount > 0 then begin
          node := listview_chat_channel.getnext(node);
          continue;
        end;

        chan := listview_chat_channel.getdata(node);
        str := chan^.name + CRLF +
          chan^.topic + CRLF +
          inttostr(chan^.users) + CRLF +
          channel_to_arlnk(chan) + CRLF;

        if vars_global.IDEIsRunning then str := str +
          channel_to_arlnk(chan, true) + CRLF
        else
          str := str + CRLF;

        try
          move(str[1], buffer, length(str));
          write(buffer, length(str));
        except
        end;

        node := listview_chat_channel.getnext(node);
      end;

    end;
    FreeHandleStream(stream);
  end;

  Tnt_ShellExecuteW(0, 'open', pwidechar(widestring('notepad')), pwidechar(filenw), nil, SW_SHOW);
end;

procedure clear_chanlist_backup;
var
  canale: precord_displayed_channel;
begin

  while (vars_global.chat_chanlist_backup.count > 0) do begin
    canale := vars_global.chat_chanlist_backup[vars_global.chat_chanlist_backup.count - 1];
    vars_global.chat_chanlist_backup.delete(vars_global.chat_chanlist_backup.count - 1);
    with canale^ do begin
      topic := '';
      name := '';
      stripped_topic := '';
    end;
    FreeMem(canale, sizeof(record_displayed_channel));
  end;

end;

procedure mainGui_trigger_channelfilter;
var
  i: integer;
  canale: precord_displayed_channel;
  search_str: string;
  split_string: tmystringlist;
  added: integer;
begin

  with ares_frmmain do begin
    with listview_chat_channel do begin
      BeginUpdate;
      Clear;

      if length(edit_chat_chanfilter.text) < 1 then begin
        for i := 0 to vars_global.chat_chanlist_backup.count - 1 do begin
          canale := vars_global.chat_chanlist_backup[i];
          add_channel(canale^.ip,
            canale^.alt_ip,
            canale^.port,
            canale^.users,
            canale^.name,
            canale^.topic,
            canale^.stripped_topic,
            canale^.has_colors_intopic,
            false, false, false);
        end;
        if header.sortcolumn >= 0 then sort(nil, header.sortcolumn, header.sortdirection);
        EndUpdate;
        (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS) + ' (' + inttostr(vars_global.chat_chanlist_backup.count) + ')';
        ares_frmmain.panel_chat.invalidate;
        ares_frmmain.edit_chat_chanfilter.glyphindex := 12;
        ares_frmmain.edit_chat_chanfilter.text := '';
        exit;
      end;

      ares_frmmain.edit_chat_chanfilter.glyphIndex := 11;
      search_str := lowercase(widestrtoutf8str(edit_chat_chanfilter.text));
      split_string := tmystringlist.create;
      SplitString(search_str, split_string);
      added := 0;

      for i := 0 to vars_global.chat_chanlist_backup.count - 1 do begin
        canale := vars_global.chat_chanlist_backup[i];

        if not checkChatUserFilter(split_string, lowercase(canale^.name + ' ' + canale^.topic)) then continue;

        add_channel(canale^.ip,
          canale^.alt_ip,
          canale^.port,
          canale^.users,
          canale^.name,
          canale^.topic,
          canale^.stripped_topic,
          canale^.has_colors_intopic,
          false, false, false);
        inc(added);

      end;

      if header.sortcolumn >= 0 then sort(nil, header.sortcolumn, header.sortdirection);
      endupdate;
    end;
  end;

  split_string.free;

  if ares_frmmain.listview_chat_channel.rootnodecount = cardinal(vars_global.chat_chanlist_backup.count) then
    (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS) + ' (' + inttostr(vars_global.chat_chanlist_backup.count) + ')'
  else
    (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS) + ' (' + inttostr(added) + '/' + inttostr(vars_global.chat_chanlist_backup.count) + ')';

  ares_frmmain.panel_chat.invalidate;
end;

procedure tthread_channellist.cache_refresh_host; //synch
begin
  helper_ares_cacheservers.cache_add_cache_host_patch(host_per_synchronize, 4);
end;

procedure tthread_channellist.Execute;
var
  str: string;
begin
  priority := tpnormal;
  freeonterminate := true;

  db := nil;

  filtered_strings := tmystringlist.create;
  init_keywfilter('ChanListFilter', filtered_strings);

  synchronize(GUI_searching);
  try

    if not terminated then begin
      str := '';
      while true do begin
        str := cache_get;
        if length(str) = 0 then sleep(500) else begin //10 seoncid ad ogni tentativo?
          synchronize(prepare_header);
          synchronize(end_update);
          break;
        end;
      end;
    end;

  except
    synchronize(GUI_error);
  end;

  filtered_strings.free;
  if db <> nil then FreeHandleStream(db);
end;

procedure tthread_channellist.GUI_error; //synch
begin
  chatlist_GUI_error;
end;

procedure tthread_channellist.end_update; //synch
begin
  helper_channellist.add_channel_fromreg;
  helper_channellist.chatListPutStats;
  helper_channellist.add_mandatory_channels;
end;

procedure ChatListPutStats;
begin

  with ares_frmmain do begin
    with listview_chat_channel do begin
      endupdate;

      if vars_global.chat_chanlist_backup.count = 0 then chatlist_GUI_error else begin
        if header.sortcolumn >= 0 then sort(nil, header.sortcolumn, header.sortdirection);
      end;

      edit_chat_chanfilter.enabled := true; //impediamo search while listing
      if ((length(edit_chat_chanfilter.text) > 1) and (edit_chat_chanfilter.glyphindex <> 12) and (edit_chat_chanfilter.glyphindex > 0)) then (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS) + ' (' + inttostr(chatlist_getrealcount) + '/' + inttostr(vars_global.chat_chanlist_backup.count) + ')'
      else (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS) + ' (' + inttostr(vars_global.chat_chanlist_backup.count) + ')';
      ares_frmmain.panel_chat.invalidate;

    end;
  end;
end;

procedure add_mandatory_channels;
var
  i: integer;
  pcanale: precord_canale_chat_visual;

  ip, alt_ip: cardinal;
  topic, chname: string;
  port, users: word;
  has_colors_intopic: boolean;
  stripped_topic: widestring;
begin
 /////////////////////////////// add all the channels I'm in
  for i := 0 to list_chatchan_visual.count - 1 do begin //ora aggiungiamo tutti i canali nei quali sono dentro, evviva imbecilli!!
    pcanale := list_chatchan_visual[i];

    alt_ip := pcanale^.alt_ip;
    ip := pcanale^.ip;
    port := pcanale^.port;
    users := pcanale^.listview.RootNodeCount;
    if users < 1 then users := 1;
    chname := pcanale^.name;
    topic := pcanale^.topic;
    stripped_topic := strip_color_string(utf8strtowidestr(topic), has_colors_intopic);
    helper_channellist.add_channel(ip, alt_ip, port, users, chname, topic, stripped_topic, has_colors_intopic);
  end;
 //////////////////////////////////////////////////////////////////////////////////////////////////
end;

function chatlist_getrealcount: integer;
var
  node: pcmtVnode;
begin
  result := 0;

  with ares_frmmain.listview_chat_channel do begin

    node := getfirst;
    while (node <> nil) do begin
      if node.childcount = 0 then inc(result);
      node := getNext(node);
    end;

  end;

end;

procedure tthread_channellist.GUI_searching;
var
  node: pCmtVnode;
  datao: precord_displayed_channel;
begin


  with ares_frmmain do begin
    with listview_chat_channel do begin
      canbgcolor := false;
      selectable := false;

      with header do begin
        autosizeindex := 2;
        with columns do begin
          Items[0].width := clientwidth;
          Items[1].width := 0;
          Items[2].width := 0;
          Items[0].text := '';
          Items[1].text := '';
          Items[2].text := '';
        end;
      end;

      (ares_frmmain.panel_chat.Panels[0] as TCometPagePanel).btncaption := GetLangStringW(STR_CHANNELS);
      ares_frmmain.panel_chat.invalidate;

      node := addchild(nil);
      datao := getdata(node);
      with datao^ do begin
        name := GetLangStringA(STR_RETRIEVINGLIST_PLEASEWAIT);
        topic := '';
        ip := 0;
        port := 0;
      end;
    end;

    edit_chat_chanfilter.enabled := false; //impediamo search while listing
  end;

  clear_chanlist_backup;

end;


function tthread_channellist.cache_get: string;
var
  str: string;
  portw: word;
  socket, socket2: TTCPBlockSocket;
  er, i: integer;
  tempo, ipi: cardinal;
  previous_len, wantedlen, len {,ip_cache}: integer;
  ricevuto: string;
  list: tmylist;
  recvd: integer;
begin
  result := '';
  try
    str := helper_ares_cacheservers.cache_get_3hosts; //get 3 caches from registry
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
      socket.Connect(socket.ip, inttostr(socket.port));
      list.add(socket);
    end;


    if list.count = 0 then begin
      list.free;
      exit;
    end;


    tempo := gettickcount;
    er := WSAEWOULDBLOCK;

    while true do begin

      if gettickcount - tempo > 15000 {TIMOUT_SOCKET_CONNECTION} then begin
        //if socket.FStatoConn=PROXY_InConnessione then
          //if socket.socksIP<>'' then begin
            //host_per_synchronize:='';
        while list.count > 0 do begin
          socket2 := list[list.count - 1];
          list.delete(list.count - 1);
             //  ipi:=inet_addr(pchar(socket2.ip));
          helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket2.ip)));
          socket2.free;
             //  host_per_synchronize:=host_per_synchronize+int_2_dword_string(ipi);
        end;
           // if length(host_per_synchronize)>=4 then synchronize(cache_refresh_hosts);  }
        // end;
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

 ///////////////////////////////////////////////////////


//flush out request
    str := CHRNULL + CHRNULL +
      chr(MSG_CCACHE_SEND_CHANNELS);

    tempo := gettickcount;
    while true do begin
      if gettickcount - tempo > 10000 {TIMEOUT_FLUSH_TCP} then begin
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


    was_searching := true; //per update treeview
    tempo := gettickcount;

    recvd := 0;
// get data
    ricevuto := '';
    while true do begin
      if gettickcount - tempo > 10000 {TIMEOUT_RECEIVE_REPLY} then begin
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
      inc(recvd, len);

      tempo := gettickcount;
      if len < 1024 then setlength(ricevuto, previous_len + len);

      while true do begin
        if length(ricevuto) < 3 then break;

        wantedlen := chars_2_word(copy(ricevuto, 1, 2));
        if length(ricevuto) < wantedlen + 3 then break;
        if ricevuto[3] = chr(MSG_CCACHE_ENDOF_CHANNELS) then begin //fine lista
          helper_ares_cacheservers.Cache_putHasConnected(inet_addr(pchar(socket.ip)));
          socket.free;
          synchronize(setLastUpdated);
          exit;
        end;
        if ricevuto[3] <> chr(MSG_CCACHE_HERE_CHANNELS) then begin
          helper_ares_cacheservers.Cache_putDisConnected(inet_addr(pchar(socket.ip)));
          socket.free;
          exit;
        end;
        result := 'ok';



        delete(ricevuto, 1, 3);
        add_channels(copy(ricevuto, 1, wantedlen));

        delete(ricevuto, 1, wantedlen);
      end;
    end;

  except
  end;
end;

procedure tthread_channellist.setLastUpdated; //synch
begin
  if ares_frmmain.listview_chat_channel.rootnodecount > 1 then
    set_regInteger('ChatRoom.LastList', DelphiDateTimeToUnix(now));
end;

procedure tthread_channellist.writeChannelToDisk(const strin: string);
var
  buffer: array[0..1023] of byte;
begin
  try
    if length(strin) = 0 then exit;

    if db = nil then db := MyFileOpen(data_path + '\Data\ChannelList.dat', ARES_OVERWRITE_EXISTING);
    if db = nil then exit;

    move(strin[1], buffer, length(strin));
    db.write(buffer, length(strin));
  except
  end;
end;




procedure tthread_channellist.add_channels(strin: string);
var
  chan_ser: string;
  len: integer;
begin

  if length(strin) < 5 then exit;

  try

    str := zdecompressstr(strin);

    synchronize(prepare_header);

    while (length(str) > 0) do begin
      len := chars_2_word(copy(str, 1, 2));
      delete(str, 1, 2);

      chan_ser := copy(str, 1, len);
      delete(str, 1, len);

      if length(chan_ser) = len then begin
        add_channel(filtered_strings, chan_ser);
      end;

    end;

    synchronize(unprepare_header);

  except
  end;
end;



procedure tthread_channellist.prepare_header; //synch
begin
  with ares_frmmain do begin
    with listview_chat_channel do begin
      beginupdate;

      if was_searching then begin
        was_searching := false;

        Clear;
        canbgcolor := true;
        selectable := true;
        with header.columns do begin
          Items[0].text := GetLangStringW(STR_NAME);
          Items[1].text := GetLangStringW(STR_USERS);
          Items[2].text := GetLangStringW(STR_TOPIC);
          Items[0].width := gettextwidth(Items[0].text, ares_FrmMain.canvas) + 30;
          if Items[0].width < 200 then Items[0].width := 200;
          Items[1].width := gettextwidth(Items[1].text, ares_FrmMain.canvas) + 30;
          Items[2].width := (listview_chat_channel.width - (Items[1].width + Items[0].width)) - 60;
        end;
      end;
    end;
  end;

end;


procedure tthread_channellist.unprepare_header; //synch
begin

  with ares_frmmain.listview_chat_channel do begin
    if header.sortcolumn >= 0 then sort(nil, header.sortcolumn, header.sortdirection);
    endupdate;
  end;

end;

procedure tthread_channellist.add_channel(filtered_strings: tmystringlist; serialize: string);
var
  lostr: string;
  widest: widestring;
  buildNo: word;
begin
  if length(serialize) < 10 then exit;

  move(serialize[1], ip, 4);
  move(serialize[5], port, 2);
  move(serialize[7], users, 2);
//ip:=chars_2_dword(copy(serialize,1,4));
//port:=chars_2_word(copy(serialize,5,2));
//users:=chars_2_word(copy(serialize,7,2));

  if users > 700 then exit;
  if users = 0 then inc(users);


  serBackup := int_2_word_string(length(serialize)) + serialize;

  delete(serialize, 1, 8);
  chname := copy(serialize, 1, pos(CHRNULL, serialize) - 1);


  delete(serialize, 1, pos(CHRNULL, serialize));
  topic := copy(serialize, 1, pos(CHRNULL, serialize) - 1);

  widest := utf8strtowidestr(chname) + ' ' + utf8strtowidestr(topic);
  normalize_special_unicode(widest);

  lostr := lowercase(widestrtoutf8str(widest));
  if is_filtered_text(lostr, filtered_strings) then begin

    exit; //filtering?
  end;

  strip_Tags_From_Name(chname, topic);
  if length(chname) < 4 then exit; //another can't be

  delete(serialize, 1, pos(CHRNULL, serialize));
  stripped_topic := strip_color_string(utf8strtowidestr(topic), has_colors_intopic);

  buildNo := 0;

  if length(serialize) >= 4 then begin
    move(serialize[1], alt_ip, 4); //we have internal IP for this entry
    if length(serialize) >= 8 then begin

      if (serialize[5] = CHRNULL) and (serialize[8] = CHRNULL) then begin
        move(serialize[6], buildNo, 2); // hack since 3024+
      end else
        if length(serialize) >= 10 then begin // new caches should send this a raw data
          move(serialize[6], buildNo, 2);
        end;

    end;
  end else alt_ip := 0;



  synchronize(add_channel);
end;

procedure tthread_channellist.add_channel; //sync
begin
  if helper_channellist.add_channel(ip, alt_ip, port, users, chname, topic, stripped_topic, has_colors_intopic) then //synchronize GUI (thread-safe)
    writeChannelToDisk(serbackup);
end;




procedure chatlist_GUI_error;
var
  nodo: pCmtVnode;
  datao: precord_displayed_channel;
begin
  with areS_frmmain do begin
    with listview_chat_channel do begin
      Clear;
      with header.columns do begin
        Items[0].width := width;
        Items[1].width := 0;
        Items[2].width := 0;
        Items[0].text := '';
        Items[1].text := '';
        Items[2].text := '';
      end;

      selectable := false;
      canbgcolor := false;

      nodo := addchild(nil);
      datao := getdata(nodo);
      with datao^ do begin
        name := GetLangStringA(STR_LISTEMPTY_TRYLATER);
        topic := '';
        ip := 0;
        port := 0;
      end;

    end;
  end;


end;

function checkChatUserFilter(split_string: Tmystringlist; const matchStr: string): boolean;
var
  h: integer;
  search_str: string;
  deleteit: boolean;
begin
  result := true;

  if split_string = nil then begin
    deleteit := true;
    search_str := lowercase(widestrtoutf8str(ares_frmmain.edit_chat_chanfilter.text));
    split_string := tmystringlist.create;
    SplitString(search_str, split_string);
  end else deleteit := false;

  for h := 0 to split_string.count - 1 do begin
    if pos(split_string.strings[h], matchstr) = 0 then begin
      result := false;
      break;
    end;
  end;

  if deleteit then split_string.free;

end;

function add_channel(ip, alt_ip: cardinal; port, users: word; const chname, topic: string;
  stripped_topic: widestring; has_colors_intopic: boolean; addBackup: boolean = true; checkFilter: boolean = true;
  killduplicates: boolean = true): boolean;
var
  ips: string;
  lochname: string;
  locrc: word;
  canale, canale_backup, NewChildChannel, OldChildChannel, dummychan: precord_displayed_channel;
  node, rootc, oldChildNode, newchildnode: pCmtVnode;
  i: integer;
//is_firewalled:boolean;
begin
//is_firewalled:=false;
  result := false;

  lochname := lowercase(chname);
  locrc := stringcrc(lochname, true);

  with ares_frmmain do begin
    with listview_chat_channel do begin

      if KillDuplicates then begin
  // use backup list if we're adding channels by threads
        for i := 0 to vars_global.chat_chanlist_backup.count - 1 do begin
          canale := vars_global.chat_chanlist_backup[i];
          if canale^.ip <> ip then continue;

          if ((canale^.alt_ip = alt_ip) or (canale^.port = port)) then exit; //same ip & same lanip or port= duplicate
          if locrc = canale^.locrc then
            if lowercase(canale^.name) = lochname then exit; //same ip & same name= duplicate

   //    is_firewalled:=true;  //different lanip & port + different channel name = 'LAN' channel
          break;
        end;

      end else begin
  // compare using listview if we're called by filter triggers
        node := Getfirst;
        while (node <> nil) do begin
          canale := GetData(node);
          if canale^.ip = ip then begin
    //   is_firewalled:=true;
            break;
          end;
          node := getNextSibling(node);
        end;

      end;

      ips := ipint_to_dotstring(ip);

      if addbackup then begin
        canale_backup := AllocMem(sizeof(record_displayed_channel));
        canale_backup^.ip := ip;
        canale_backup^.port := port;
        canale_backup^.name := chname;
        canale_backup^.locrc := locrc;
        canale_backup^.topic := topic;
        canale_backup^.stripped_topic := stripped_topic;
        canale_backup^.has_colors_intopic := has_colors_intopic;
        canale_backup^.users := users;
        canale_backup^.alt_ip := alt_ip;
        vars_global.chat_chanlist_backup.add(canale_backup);
      end;

      if (edit_chat_chanfilter.glyphindex <> 12) and (edit_chat_chanfilter.glyphindex > 0) then
        if checkFilter then
          if length(ares_frmmain.edit_chat_chanfilter.text) > 0 then
            if not checkChatUserFilter(nil, lochname + ' ' + lowercase(topic)) then exit;

      node := AddChild(nil);
      canale := getdata(node);
      canale^.ip := ip;
      canale^.port := port;
      canale^.name := chname;
      canale^.locrc := locrc;
      canale^.topic := topic;
      canale^.stripped_topic := stripped_topic;
      canale^.has_colors_intopic := has_colors_intopic;
      canale^.users := users;
      canale^.alt_ip := alt_ip;

      result := true;
    end;
  end;
end;

function Chatlist_GetUserStatStr(node: PcmtVnode): string;
var
  child: pcmtVnode;
  datas: precorD_displayed_channel;
begin
  result := '';

  with ares_frmmain.listview_chat_channel do begin

    if node.FirstChild = nil then exit;
    datas := GetData(node.FirstChild);
    result := inttostr(datas^.users);

    child := GetNextSibling(node.FirstChild);
    while (child <> nil) do begin
      datas := GetData(child);
      result := result + '+' + inttostr(datas^.users);
      child := GetNextSibling(child);
    end;

  end;

end;


function channellist_find_root(ip: cardinal; var Oldchildnode: pcmtvnode): pcmtvnode;
var
  datac: precord_displayed_channel;
begin
  result := nil;
  oldChildNode := nil;

  with ares_frmmain.listview_chat_channel do begin
    result := getFirst;
    while (result <> nil) do begin
      datac := getData(result);
      if dataC^.ip = ip then begin

        if result.childcount = 0 then begin // this is not a parent node...
          OldChildNode := result;
          result := nil;
        end;

        exit;
      end;
      result := GetNextSibling(result);
    end;
  end;
end;

procedure add_channel_fromreg;
var
  fname, ports, ips: string;
  reg: tregistry;

  ip: cardinal;
  port: word;
begin
  try

    reg := tregistry.create;
    with reg do begin
      openkey(areskey, true);

      fname := readstring('ch_name');
      ips := readstring('ch_ip');
      ports := readstring('ch_port');

      closekey;
      destroy;
    end;

    if length(fname) > 0 then
      if length(ports) > 0 then
        if length(ips) > 0 then begin
          ip := inet_addr(pchar(ips));
          port := strtointdef(ports, 6666);
          add_channel(ip, 0, port, 1, fname, '', '', false);
        end;


  except
  end;
end;



end.

