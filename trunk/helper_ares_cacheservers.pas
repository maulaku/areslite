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

unit helper_ares_cacheservers;

interface

uses
  classes, classes2, sysutils, ares_objects, const_ares, windows, blcksock, synsock;

const
  MAX_SAVED_CACHES = 100;
  CACHE_RECONNECT_INTERVAL = 600; //seconds
  MAX_CACHES_FROM_PATCH = 25;

type
  tthread_check_cache = class(tthread)
  protected
    procedure execute; override;
    function connect: boolean;
  end;

function cacheservers_loadfromdisk: integer; // load from registry
procedure get_caches_from_reg;
function get_ppca(ni: cardinal): word;
procedure cacheservers_savetodisk;
procedure cacheservers_freeList;

function cache_get_1host: string;
function cache_get_3hosts: string;
procedure cacheservers_purge_exceeding(caches: tlist; NumTodelete: integer);
procedure cache_merge_hkey_local_machine_entries;
procedure cache_add_cache_host_patch(hosts: string; lenhosts: byte);
function FindCache(ip: cardinal; list: tlist): Tcacheserver;

procedure Cache_putDisConnected(ip: cardinal); //remove inuse flag
procedure Cache_putHasConnected(ip: cardinal); //remove inuse flag, increment connects count
procedure Cache_AddReported(ipC: cardinal);
procedure Cache_checkRandom;
procedure cache_get_20hosts(buffer: pchar; var len: integer);
procedure clear_nodes_db;
function cache_get_chathosts: string;


var
  db_cacheservers_oldest_last_seen: cardinal;
  availableCaches: TThreadList;
//cache_patched:cardinal;

implementation

uses
  helper_strings, registry, helper_crypt, helpeR_ipfunc, helper_datetime,
  vars_global, helper_diskio, helper_sorting, tntwindows, helper_sockets,
  const_cache_commands;

procedure Cache_checkRandom;
begin
  tthread_check_cache.create(false);
end;

procedure tthread_check_cache.execute;
var
  tries: byte;
begin
  priority := tpnormal;
  freeonterminate := true;

  tries := 0;
  while not connect do begin
    inc(tries);
    if tries >= 10 then break;
    sleep(10);
  end;

end;

function tthread_check_cache.connect: boolean;
var
  socket: ttcpblocksocket;
  er, len: integer;
  checktime: cardinal;

  caches: Tlist;
  cache: TcacheServer;
  ipC: cardinal;
  str: string;
  buffer: array[0..1023] of byte;

  ip_cache: integer; //!!!
  len_payload: word;
begin
  result := false;

  ipC := 0;
  caches := availableCaches.Locklist;
  if caches.count > 1 then begin
    cache := caches[random(caches.count)];
    ipC := cache.ip;
    inc(cache.attempts);
  end;
  availableCaches.UnLocklist;
  if ipC = 0 then exit;


  socket := TTCPBlockSocket.create(true);
  socket.ip := ipint_to_dotstring(ipC);
  socket.port := get_ppca(ipC);
  assign_proxy_settings(socket);

  socket.Connect(socket.ip, inttostr(socket.port));

  checktime := gettickcount;
  while (true) do begin

    if gettickcount - checktime > 15000 then begin
      socket.free;
      exit;
    end;

    er := TCPSocket_ISConnected(socket);

    if er = 0 then begin
      cache_putHasConnected(ipC); //checked...
      result := true;
      break;
    end;

    sleep(30);
  end;

  str := chr(0) + CHRNULL + chr(MSG_CCACHE_SEND_SUPERNODES);
  socket.SendBuffer(@str[1], length(str));

  str := '';
  checktime := gettickcount;
  while (true) do begin
    if gettickcount - checktime > 15000 then begin
      socket.free;
      exit;
    end;

    if not TCPSocket_CanRead(socket.socket, 0, er) then begin
      if ((er <> 0) and (er <> WSAEWOULDBLOCK)) then begin
        socket.free;
        exit;
      end;
      sleep(30);
      continue;
    end;
    len := TCPSocket_RecvBuffer(socket.socket, @buffer[0], sizeof(buffer), er);
    if er = WSAEWOULDBLOCK then begin
      sleep(30);
      continue;
    end;
    if er <> 0 then begin
      socket.free;
      exit;
    end;
    if len < 3 then begin
      socket.free;
      exit;
    end;
    if buffer[2] <> MSG_CCACHE_HERE_SERV then
      if buffer[2] <> MSG_CCACHE_HERE_SERVNOTCRYPT then begin
        socket.free;
        exit;
      end;

    move(buffer[0], len_payload, 2);
    if len <> len_payload + 3 then begin
      socket.free;
      exit;
    end;

    setlength(str, len_payload);
    move(buffer[3], str[1], len_payload);

    if buffer[2] = MSG_CCACHE_HERE_SERV then begin
      ip_cache := chars_2_dword(reverse_order(int_2_dword_string(inet_addr(pchar(socket.ip)))));
      str := d7spec(ip_cache, socket.port, str);
    end;

    if length(str) > 0 then begin
      if str[1] = CHRNULL then delete(str, 1, 1) else
        if ord(str[1]) > 11 then delete(str, 1, pos(CHRNULL, str));
    end;

    while (length(str) >= 6) do begin
      case ord(str[1]) of
        11: begin
            helper_ares_cacheservers.Cache_AddReported(chars_2_dword(copy(str, 2, 4)));
            delete(str, 1, 7);
          end;
        1: delete(str, 1, 7);
        3: delete(str, 1, 8)
      else delete(str, 1, 7);
      end;
    end;

    socket.free;
    exit;
  end;
end;

procedure Cache_AddReported(ipC: cardinal);
var
  caches: Tlist;
  cache: TcacheServer;
begin

  if ip_firewalled(ipC) then exit;
  if isAntiP2PIP(ipC) then exit;

  caches := availableCaches.Locklist;
  try

    cache := FindCache(ipC, caches);
    if cache <> nil then begin
      if not cache.dejavu then begin
        cache.dejaVu := false;
        inc(cache.reports);
      end;
      cache.last_seen := delphidatetimetounix(now);
    end else begin

      if caches.count >= MAX_SAVED_CACHES then cacheservers_purge_exceeding(caches, 1);
      cache := TcacheServer.create;
      with cache do begin
        ip := ipC;
        port := get_ppca(ipC);
        first_seen := delphidatetimetounix(now);
        last_seen := first_seen;
        last_attempt := first_seen - CACHE_RECONNECT_INTERVAL;
      end;
      caches.add(cache);

    end;

  except
  end;
  availableCaches.UnLocklist;
end;

procedure Cache_putHasConnected(ip: cardinal); //remove inuse flag, increment connects count
var
  caches: Tlist;
  cache: TcacheServer;
begin
  caches := availableCaches.Locklist;
  try

    cache := FindCache(ip, caches);
    if cache <> nil then begin
      inc(cache.connects);
      cache.inUse := false;
      cache.last_seen := delphidatetimetounix(now);
    end;

  except
  end;
  availableCaches.Unlocklist;
end;

procedure Cache_putDisConnected(ip: cardinal); //remove inuse flag
var
  caches: Tlist;
  cache: TcacheServer;
begin
  if availableCaches = nil then exit;

  caches := availableCaches.Locklist;
  try

    cache := FindCache(ip, caches);
    if cache <> nil then cache.inUse := false;

  except
  end;
  availableCaches.UnLocklist;
end;

function FindCache(ip: cardinal; list: tlist): Tcacheserver;
var
  i: integer;
  cache: tcacheserver;
begin
  result := nil;
  for i := 0 to list.count - 1 do begin
    cache := list[i];
    if cache.ip = ip then begin
      result := cache;
      exit;
    end;
  end;

end;



procedure cache_add_cache_host_patch(hosts: string; lenhosts: byte);
var
  numEntries, added: integer;
  caches: Tlist;
  ipC: cardinal;
  cache: tcacheserver;
  nowt: cardinal;
begin
//if cache_patched>=MAX_CACHES_FROM_PATCH then exit;

  numEntries := length(hosts) div lenhosts;
  if numEntries > MAX_SAVED_CACHES div 3 then numEntries := MAX_SAVED_CACHES div 3;
  added := 0;
  nowt := delphidatetimetounix(now);

  caches := availableCaches.Locklist;
  try

    if numEntries + caches.count > MAX_SAVED_CACHES then
      cacheservers_purge_exceeding(caches, (numEntries + caches.count) - MAX_SAVED_CACHES);


    while ((length(hosts) >= lenhosts) and (added < numEntries)) do begin // add those fresh entries

      ipC := chars_2_dword(copy(hosts, 1, 4));
      delete(hosts, 1, lenhosts);

      if ip_firewalled(ipC) then continue;
      if isAntiP2PIP(ipC) then continue;

      cache := FindCache(ipC, caches);
      if cache <> nil then begin
        if not cache.dejavu then begin
          inc(cache.reports);
          cache.dejaVu := true;
        end;
        cache.last_seen := nowt;
        continue;
      end;

      cache := TcacheServer.create;
      with cache do begin
        ip := ipC;
        port := get_ppca(ipC);
        first_seen := nowt;
        last_seen := first_seen;
        last_attempt := nowt - CACHE_RECONNECT_INTERVAL;
      end;
      caches.add(cache);

    // inc(cache_patched);
     //if cache_patched>=MAX_CACHES_FROM_PATCH then break;
      inc(added);
    end;

  except
  end;
  availableCaches.UnLocklist;

end;

procedure cache_merge_hkey_local_machine_entries;
var
  reg: tregistry;
  buffer: array[0..1203] of byte; //max 200 caches
  lun_to, lun_got: integer;
begin
  lun_got := 0;

  reg := tregistry.create; //prendiamo host presenti

  with reg do begin

    try

      if openkey(areskey + getdatastr, false) then begin
        if valueexists(GetAresNet1) then begin //we already have our 'user' entries
          lun_to := GetDataSize(GetAresNet1);
          if lun_to > 10 then begin
            closekey;
            destroy;
            exit;
          end;
        end;
        closekey;
      end;

      rootkey := HKEY_LOCAL_MACHINE;
      if not OpenKeyReadOnly(areskey + getdatastr) then begin
        destroy;
        exit;
      end;

      if not valueexists(GetAresNet1) then begin
        closekey;
        destroy;
        exit;
      end;

      lun_to := GetDataSize(GetAresNet1);
      if lun_to = 0 then begin
        closekey;
        destroy;
        exit;
      end;

      if lun_to > sizeof(buffer) then lun_to := sizeof(buffer);

      lun_got := ReadBinaryData(GetAresNet1, buffer, lun_to);
      if lun_got <> lun_to then begin
        closekey;
        destroy;
        exit;
      end;

      closekey;
    except
    end;
    destroy;
  end;

  if lun_got = 0 then exit;

  reg := tregistry.create;
  with reg do begin
    try
      openkey(areskey + getdatastr, true);
      WriteBinaryData(GetAresNet1, buffer, lun_got);
      closekey;
    except
    end;

    destroy;
  end;

end;

function get_ppca(ni: cardinal): word;
var
  first: cardinal;
  str: string;
begin

  str := int_2_dword_string(ni);
  first := ord(str[1]);

  result := (first * first) + wh(str);
  result := result + (first * first) + wh(str);
  result := result + (first * first) + wh(str);
  result := result + wh(int_2_word_string(result) +
    int_2_word_string(1214)) +
    wh(str);
  result := result + 22809;
  result := result - (12 * (first - 5)) + 52728;
  if result < 1024 then result := result + 2048;
  if result = 36278 then inc(result);
end;

procedure get_caches_from_reg;
var
  lun_to, lun_got, i: integer;
  stringa: string;
  buffer: array[0..1203] of byte; //max 200 hosts
  reg: tregistry;
  cache: tcacheserver;
  nowt: cardinal;
  caches: tlist;
begin
  reg := Tregistry.create;
  with reg do begin
    openkey(areskey + getdatastr, true);

    if not valueexists(GetAresNet1) then begin
      closekey;
      destroy;
      exit;
    end;

    lun_to := GetDataSize(GetAresNet1);
    if lun_to = 0 then begin
      closekey;
      destroy;
      exit;
    end;
    if lun_to > sizeof(buffer) then lun_to := sizeof(buffer);

    lun_got := ReadBinaryData(GetAresNet1, buffer, lun_to);
    if lun_got <> lun_to then begin
      closekey;
      destroy;
      exit;
    end;

    setlength(stringa, lun_got);
    move(buffer, stringa[1], lun_got);
    stringa := d67(stringa, 4978);

    nowt := DelphiDateTimetoUnix(now);

    if chars_2_dword(copy(stringa, 1, 4)) = 0 then begin //first null 4 byte entry (new format since 2953+)
      delete(stringa, 1, 4); //skip marker

      caches := availableCaches.Locklist;
      try

        i := 1;
        while (i + 6 < length(stringa)) do begin //parsiamo senza un casino di deallocazioni
          if copy(stringa, i, 6) = chr(0) + chr(0) + chr(0) + chr(0) + chr(0) + chr(0) then break; //till null entry is found

          cache := Tcacheserver.create;
          with cache do begin
            ip := chars_2_dword(copy(stringa, i, 4));
            port := chars_2_word(copy(stringa, i, 2));
            first_seen := nowt;
            last_seen := first_seen;
            last_attempt := nowt - CACHE_RECONNECT_INTERVAL;
            if last_seen < db_cacheservers_oldest_last_seen then db_cacheservers_oldest_last_seen := last_seen;
          end;
          caches.add(cache);

          inc(i, 6);
        end;

      except
      end;
      availableCaches.UnlockList;


    end else begin


      caches := availableCaches.Locklist;
      try

        i := 1;
        while (i + 4 < length(stringa)) do begin //parsiamo senza un casino di deallocazioni
          if copy(stringa, i, 4) = chr(0) + chr(0) + chr(0) + chr(0) then break; //last null 6 byte entry is found

          cache := Tcacheserver.create;
          with cache do begin
            ip := chars_2_dword(copy(stringa, i, 4));
            port := get_ppca(chars_2_dword(copy(stringa, i, 4)));
            first_seen := nowt;
            last_seen := first_seen;
            last_attempt := nowt - CACHE_RECONNECT_INTERVAL;
            if last_seen < db_cacheservers_oldest_last_seen then db_cacheservers_oldest_last_seen := last_seen;
          end;
          caches.add(cache);

          inc(i, 4);
        end;

      except
      end;
      availableCaches.UnlockList;


    end;

    closekey;
    destroy;
  end;

end;

procedure clear_nodes_db;
begin
  try
    helper_diskio.deletefileW(data_path + '\Data\CNodes.dat');
    helper_diskio.deletefileW(data_path + '\Data\CNodes');
    helper_diskio.deletefileW(app_path + '\Data\CNodes.dat');
    helper_diskio.deletefileW(app_path + '\Data\CNodes');
  except
  end;
end;

function cacheservers_loadfromdisk: integer; // load from registry
var
  cache, cache2: tcacheserver;
  str_temp, hostSTR: string;
  list: tmystringlist;
  found: boolean;
  h: integer;
  cachepath: widestring;
  nowt: cardinal;
  caches: tlist;
  ipC: cardinal;
begin
  result := 0;
  db_cacheservers_oldest_last_seen := DelphiDateTimetoUnix(now);
//cache_patched:=0;

  cachepath := data_path + '\Data\CNodes.dat';

  if not fileexistsW(cachepath) then begin
    cachepath := data_path + '\Data\CNodes';
    if not fileexistsW(cachepath) then begin
      cachepath := app_path + '\Data\CNodes.dat';
      if not fileexistsW(cachepath) then begin
        get_caches_from_reg;
        exit;
      end;
    end;
  end;

  list := tmystringlist.create;
  parse_file_lines(cachepath, list);

  nowt := DelphiDateTimetoUnix(now);

  caches := availableCaches.Locklist;
  try

    while (list.count) > 0 do begin
      str_temp := list.strings[list.count - 1];
      list.delete(list.count - 1);
      if pos('<', str_temp) <> 0 then continue;
      if pos('#', str_temp) <> 0 then continue;

      hostSTR := copy(str_temp, 1, pos(' ', str_temp) - 1);
      ipC := inet_addr(pchar(hostSTR));

      if isAntiP2PIP(ipC) then continue;
      if ip_Firewalled(ipC) then continue;

  // check for duplicates
      found := false;
      for h := 0 to caches.count - 1 do begin
        cache2 := caches[h];
        if cache2.ip = ipC then begin
          found := true;
          break;
        end;
      end;
      if found then continue;

      cache := tcacheserver.create;
      with cache do begin
        ip := ipC;
        delete(str_temp, 1, pos(' ', str_temp));
        port := Strtointdef(copy(str_temp, 1, pos(' ', str_temp) - 1), 0);
        if port = 0 then continue;
        delete(str_temp, 1, pos(' ', str_temp));
        reports := Strtointdef(copy(str_temp, 1, pos(' ', str_temp) - 1), 0);
        delete(str_temp, 1, pos(' ', str_temp));
        attempts := Strtointdef(copy(str_temp, 1, pos(' ', str_temp) - 1), 0);
        delete(str_temp, 1, pos(' ', str_temp));
        connects := Strtointdef(copy(str_temp, 1, pos(' ', str_temp) - 1), 0);
        delete(str_temp, 1, pos(' ', str_temp));
        first_seen := Strtointdef(copy(str_temp, 1, pos(' ', str_temp) - 1), 0);
        delete(str_temp, 1, pos(' ', str_temp));
        last_seen := Strtointdef(copy(str_temp, 1, pos(' ', str_temp) - 1), 0);
        delete(str_temp, 1, pos(' ', str_temp));
        if pos(' ', str_temp) <> 0 then begin
          last_attempt := Strtointdef(copy(str_temp, 1, pos(' ', str_temp) - 1), 0);
        end else begin
          last_attempt := StrToIntDef(str_temp, 0);
        end;

        if nowt - last_attempt < CACHE_RECONNECT_INTERVAL then
          last_attempt := nowt - CACHE_RECONNECT_INTERVAL;

        if ((first_seen = 0) or (last_seen = 0)) then begin
          first_seen := nowt;
          last_seen := first_seen;
        end;

        if last_seen < db_cacheservers_oldest_last_seen then db_cacheservers_oldest_last_seen := last_seen;

      end;

      caches.add(cache);
      if caches.count >= MAX_SAVED_CACHES then break;
    end;



    result := caches.count;
  except
  end;

  availableCaches.UnLocklist;

  list.free;
  if result = 0 then get_caches_from_reg;

end;

function cache_get_1host: string;
var
  cache: tcacheserver;
  nowunix: cardinal;
  i: integer;
  caches: tlist;
begin
  result := '';
  if availableCaches = nil then exit;

  nowunix := delphidatetimetounix(now);

  caches := availableCaches.Locklist;
  try

    caches.sort(sort_cacheservers_bestrating);


    for i := 0 to caches.count - 1 do begin
      cache := caches[i];
      if cache.inuse then continue;
      if nowunix - cache.last_attempt < CACHE_RECONNECT_INTERVAL then continue; //10 mins

      result := ipint_to_dotstring(cache.ip);

      cache.inuse := true;
      cache.last_attempt := nowunix;
      inc(cache.attempts);
      break;
    end;

  except
  end;
  availableCaches.UnLocklist
end;

function cache_get_3hosts: string;
var
  cache: tcacheserver;
  nowunix: cardinal;
  i, added: integer;
  caches: tlist;
begin
  result := '';

  nowunix := delphidatetimetounix(now);
  added := 0;

  caches := availableCaches.Locklist;
  try

    caches.sort(sort_cacheservers_bestrating);


    for i := 0 to caches.count - 1 do begin
      cache := caches[i];
      if cache.inuse then continue;
      if nowunix - cache.last_attempt < CACHE_RECONNECT_INTERVAL then continue; //10 mins

      result := result + int_2_dword_string(cache.ip);

      cache.inuse := true;
      cache.last_attempt := nowunix;
      inc(cache.attempts);

      inc(added);
      if added >= 3 then break;
    end;

  except
  end;
  availableCaches.UnLocklist;

end;

function cache_get_chathosts: string;
var
  cache: tcacheserver;
  i, added: integer;
  caches: tlist;
begin
  added := 0;
  result := '';

  caches := availableCaches.Locklist;
  try
    caches.sort(sort_cacheservers_bestrating);

    for i := 0 to caches.count - 1 do begin
      cache := caches[i];
      result := result + 'Cache= ' + ipint_to_dotstring(cache.ip) + CRLF;

      inc(added);
      if added >= 30 then break;
    end;

  except
  end;
  availableCaches.UnLocklist;
end;

procedure cache_get_20hosts(buffer: pchar; var len: integer);
var
  cache: tcacheserver;
  i, added: integer;
  caches: tlist;
begin
  len := 0;
  added := 0;

  caches := availableCaches.Locklist;
  try

    caches.sort(sort_cacheservers_bestrating);


    for i := 0 to caches.count - 1 do begin
      cache := caches[i];
      try
        move(cache.ip, buffer^, 4);
        inc(buffer, 4);
        inc(len, 4);
      except
      end;

      inc(added);
      if added >= 20 then break;
    end;

  except
  end;
  availableCaches.UnLocklist;

end;

procedure cacheservers_savetodisk;
var
  stream: thandlestream;
  i, saved: integer;
  cache: tcacheserver;
  str: string;
  buffer: array[0..511] of char;
  caches: TList;
begin

  saved := 0;
  stream := MyFileOpen(data_path + '\Data\CNodes.dat', ARES_OVERWRITE_EXISTING);
  if stream = nil then exit;

  caches := availableCaches.Locklist;
  try

    caches.sort(sort_cacheservers_bestrating);

    for i := 0 to caches.count - 1 do begin
      cache := caches[i];

      str := ipint_to_dotstring(cache.ip) + ' ' +
        inttostr(cache.port) + ' ' +
        inttostr(cache.reports) + ' ' +
        inttostr(cache.attempts) + ' ' +
        inttostr(cache.connects) + ' ' +
        inttostr(cache.first_seen) + ' ' +
        inttostr(cache.last_seen) + ' ' +
        inttostr(cache.last_attempt) + ' ' +
        CRLF;

      move(str[1], buffer[0], length(str));
      stream.write(buffer, length(str));
      inc(saved);
      if saved >= MAX_SAVED_CACHES then break;
    end;

  except
  end;
  availableCaches.UnLocklist;

  FreeHandleStream(stream);

  try
    if fileexists(data_path + '\Data\CNodes') then helper_diskio.deletefileW(data_path + '\Data\CNodes');
  except
  end;
end;

procedure cacheservers_freeList;
var
  cache: tcacheserver;
  caches: TList;
begin
  caches := availableCaches.Locklist;
  while (caches.count > 0) do begin
    cache := caches[caches.count - 1];
    caches.delete(caches.count - 1);
    cache.free;
  end;
  availableCaches.unlocklist;

  availableCaches.free;
  availableCaches := nil;
end;

procedure cacheservers_purge_exceeding(caches: tlist; NumTodelete: integer);
var
  cache: TcacheServer;
  i, deleted: integer;
begin

  if caches.count < MAX_SAVED_CACHES then exit;

  caches.sort(sort_cacheservers_worstrating);

  deleted := 0;
  i := 0;
  while ((i < caches.count) and (deleted < NumTodelete)) do begin
    cache := caches[i];

    if cache.inuse then begin
      inc(i);
      continue;
    end;

    caches.delete(i);
    cache.free;

    inc(deleted);
  end;

end;


end.

