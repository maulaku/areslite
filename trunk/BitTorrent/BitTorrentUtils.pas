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
misc stuff
}

unit BitTorrentUtils;

interface

uses
  classes, classes2, windows, sysutils, btcore;

type
  TBitTorrentTransferCreator = class(tthread)
  protected
    BitTorrentTransfer: tBittorrentTransfer;
    procedure execute; override;
    procedure start_thread; //sync
    procedure AddVisualTransferReference;
  public
    path: widestring;
  end;



procedure loadTorrent(filename: widestring);
procedure check_bittorrentTransfers;
function BTRatioToEmotIndex(uploaded: int64; downloaded: int64): integer;

implementation

uses
  helper_diskio, ares_types, helper_unicode,
  tntwindows, torrentParser, ufrmmain, vars_global,
  BitTorrentDlDb, thread_bittorrent, helper_strings, const_ares,
  bittorrentConst, ares_objects, comettrees, helper_urls;

function BTRatioToEmotIndex(uploaded: int64; downloaded: int64): integer;
begin
  if ((uploaded >= downloaded) and (uploaded > 0)) then result := 0
  else result := 9;
end;

procedure check_bittorrentTransfers;
var
  doserror: integer;
  dirinfo: ares_types.TSearchRecW;
  BitTorrentTransfer: tBittorrentTransfer;
  str: string;
begin


  dosError := helper_diskio.FindFirstW(vars_global.data_Path + '\Data\TempDl\PBTHash_*.dat', faAnyfile, dirInfo);
  while (DosError = 0) do begin
    if (((dirinfo.Attr and faDirectory) > 0) or
      (dirinfo.name = '.') or
      (dirinfo.name = '..')) then begin
      DosError := helper_diskio.FindNextW(dirinfo);
      continue;
    end;

    str := dirinfo.name;
    delete(str, 1, 8);
    delete(str, length(str) - 3, 4);

    if length(str) = 40 then begin

      BitTorrentTransfer := tBitTorrentTransfer.create;
      BitTorrentTransfer.fhashvalue := helper_strings.hexstr_to_bytestr(str);

      BitTorrentDlDb.BitTorrentDb_load(BitTorrentTransfer);

      if ((BitTorrentTransfer.ferrorCode > 0) and
        (BitTorrentTransfer.ferrorCode < BT_DBERROR_FILES_LOCKED)) then begin
        BitTorrentTransfer.free;
        DosError := helper_diskio.FindNextW(dirinfo);
        continue;
      end;


      if vars_global.bittorrent_Accepted_sockets = nil then vars_global.bittorrent_Accepted_sockets := tmylist.create;
      if vars_global.thread_bittorrent = nil then begin
        vars_global.thread_bittorrent := tthread_bitTorrent.create(true);
        vars_global.thread_bittorrent.BittorrentTransfers := tmylist.create;
      end;
      vars_global.thread_bittorrent.BittorrentTransfers.add(BitTorrentTransfer);
    end;

    DosError := helper_diskio.FindNextW(dirinfo);
  end;


  if vars_global.thread_bittorrent <> nil then vars_global.thread_bittorrent.resume;
end;


procedure TBitTorrentTransferCreator.execute;
var
  stream: thandlestream;
  Parser: TTorrentParser;

  torrentName, tmpPath: string;
  buffer: array[0..2] of byte;
  i: integer;
  ffile: TBittorrentFile;
begin
  priority := tpnormal;
  freeonterminate := true;

  stream := MyFileOpen(path, ARES_READONLY_BUT_SEQUENTIAL);
  if stream = nil then exit;


  Parser := TTorrentParser.Create;
  Parser.Load(stream);

  torrentName := parser.name;
  TorrentName := StripIllegalFileChars(TorrentName);
  if length(TorrentName) > 200 then delete(TorrentName, 200, length(TorrentName));

  if length(torrentName) = 0 then begin
    tmpPath := widestrtoutf8str(path);
    for i := length(tmpPath) downto 1 do if tmpPath[i] = '\' then break;
    if i > 1 then delete(TmpPath, 1, i);
    torrentName := tmpPath;
    for i := length(torrentName) downto 1 do
      if torrentName[i] = '.' then begin // remove .torrent ext
        delete(TorrentName, i, length(TorrentName));
        break;
      end;
  end;




 {Torrent name already in download?}
  if direxistsW(vars_global.my_torrentFolder + '\' + utf8strtowidestr(torrentName)) then begin
    if fileexistsW(vars_global.data_Path + '\Data\TempDl\PBTHash_' + bytestr_to_hexstr(parser.hashValue) + '.dat') then begin
      parser.free;
      FreeHandleStream(Stream);
      exit;
    end;

    torrentName := torrentName + inttohex(random($FF), 2) + inttohex(random($FF), 2);
  end;
  while direxistsW(vars_global.my_torrentFolder + '\' + utf8strtowidestr(torrentName)) do
    torrentName := copy(torrentName, 1, length(torrentName) - 4) + inttohex(random($FF), 2) + inttohex(random($FF), 2);
  //////////////////////////////////////////

  tntwindows.tnt_createdirectoryW(pwidechar(vars_global.my_torrentFolder), nil);
  tntwindows.tnt_createdirectoryW(pwidechar(vars_global.my_torrentFolder + '\' + utf8strtowidestr(torrentName)), nil);

  BitTorrentTransfer := tBittorrentTransfer.create;
  BitTorrentTransfer.init(widestrtoutf8str(vars_global.my_torrentFolder) + '\' + torrentName,
    Parser);


  parser.free;
  FreeHandleStream(Stream);


  if ((BitTorrentTransfer.ferrorCode > 0) and
    (BitTorrentTransfer.ferrorCode < BT_DBERROR_FILES_LOCKED)) then begin
    BitTorrentTransfer.free;
    exit;
  end;



  buffer[0] := 0;

  synchronize(AddVisualTransferReference);

// let thread_bittorrent know when file is ready for writing
  for i := 0 to bittorrentTransfer.ffiles.count - 1 do begin
    ffile := bittorrentTransfer.ffiles[i];

    FreeHandleStream(ffile.fstream);
    while true do begin
      ffile.fstream := MyFileOpen(utf8strtowidestr(ffile.ffilename), ARES_WRITE_EXISTING);
      if ffile.fstream <> nil then break else sleep(10);
    end;
{
 if ffile.fstream.size>0 then begin
  helper_diskio.MyFileSeek(ffile.fstream,ffile.fsize-1,ord(soFromBeginning));
    while (true) do begin
     if helper_diskio.MyFileSeek(ffile.fstream,0,ord(soCurrent))<>ffile.fsize-1 then begin
      helper_diskio.MyFileSeek(ffile.fstream,ffile.fsize-1,ord(soFromBeginning));
      sleep(50);
      continue;
     end else break;
    end;

    ffile.fstream.Write(buffer,1);
  end; }


  end;


//end;
  bittorrentTransfer.fstate := dlProcessing;


  synchronize(start_thread);
end;


procedure tBittorrentTransferCreator.start_thread; //sync
begin

  if vars_global.BitTorrentTempList = nil then vars_global.BitTorrentTempList := tmylist.create;
  if vars_global.bittorrent_Accepted_sockets = nil then vars_global.bittorrent_Accepted_sockets := tmylist.create;

  if vars_global.thread_bittorrent = nil then begin
    vars_global.thread_bittorrent := tthread_bitTorrent.create(true);
    vars_global.thread_bittorrent.BittorrentTransfers := tmylist.create;
 //    vars_global.thread_bittorrent.BittorrentTransfers.add(bittorrentTransfer);
    vars_global.thread_bittorrent.resume;
  end;
  vars_global.BitTorrentTempList.add(bittorrentTransfer);

  if ares_frmmain.tabs_pageview.activePage <> IDTAB_TRANSFER then ares_frmmain.tabs_pageview.activePage := IDTAB_TRANSFER;
end;

procedure tBittorrentTransferCreator.AddVisualTransferReference;
var
  dataNode: ares_types.precord_data_node;
  node: PCMtVNode;
  data: precord_displayed_bittorrentTransfer;
begin

  if bittorrentTransfer.UploadTreeview then begin
    node := ares_frmmain.treeview_upload.AddChild(nil);
    dataNode := ares_frmmain.treeview_upload.getdata(Node);
  end else begin
    node := ares_frmmain.treeview_download.AddChild(nil);
    dataNode := ares_frmmain.treeview_download.getdata(Node);
  end;
  dataNode^.m_type := dnt_bittorrentMain;

  data := AllocMem(sizeof(record_displayed_bittorrentTransfer));
  dataNode^.data := Data;

  bittorrentTransfer.visualNode := node;
  bittorrentTransfer.visualData := data;
  bittorrentTransfer.visualData^.handle_obj := longint(bittorrentTransfer);
  bittorrentTransfer.visualData^.FileName := widestrtoutf8str(helper_urls.extract_fnameW(utf8strtowidestr(bittorrentTransfer.fname)));
  bittorrentTransfer.visualData^.Size := bittorrentTransfer.fsize;
  bittorrentTransfer.visualData^.downloaded := bittorrentTransfer.fdownloaded;
  bittorrentTransfer.visualData^.uploaded := bittorrentTransfer.fuploaded;
  bittorrentTransfer.visualData^.hash_sha1 := bittorrentTransfer.fhashvalue;
  bittorrentTransfer.visualData^.crcsha1 := crcstring(bittorrentTransfer.fhashvalue);
  bittorrentTransfer.visualData^.SpeedDl := 0;
  bittorrentTransfer.visualData^.SpeedUl := 0;
  bittorrentTransfer.visualData^.want_cancelled := false;
  bittorrentTransfer.visualData^.want_paused := false;
  bittorrentTransfer.visualData^.want_changeView := false;
  bittorrentTransfer.visualData^.want_cleared := false;
  bittorrentTransfer.visualData^.uploaded := bittorrentTransfer.fuploaded;
  bittorrentTransfer.visualData^.downloaded := bittorrentTransfer.fdownloaded;
  bittorrentTransfer.visualData^.num_Sources := 0;
  bittorrentTransfer.visualData^.ercode := 0;
  bittorrentTransfer.visualData^.state := bittorrentTransfer.fstate;
  if bittorrentTransfer.tracker <> nil then bittorrentTransfer.visualData^.trackerStr := bittorrentTransfer.tracker.URL
  else bittorrentTransfer.visualData^.trackerStr := '';
  bittorrentTransfer.visualData^.Fpiecesize := bittorrentTransfer.fpieceLength;
  bittorrentTransfer.visualData^.NumLeechers := 0;
  bittorrentTransfer.visualData^.NumSeeders := 0;
  bittorrentTransfer.visualData^.path := bittorrentTransfer.fname;
  bittorrentTransfer.visualData^.NumConnectedSeeders := bittorrentTransfer.NumConnectedSeeders;
  bittorrentTransfer.visualData^.NumConnectedLeechers := bittorrentTransfer.NumConnectedLeechers;
  SetLength(bittorrentTransfer.visualData^.bitfield, length(bittorrentTransfer.FPieces));

  btcore.CloneBitField(bittorrentTransfer);
end;



procedure loadTorrent(filename: widestring);
begin
  if not FileExistsW(filename) then exit;

  with TBitTorrentTransferCreator.Create(true) do begin
    path := filename;
    resume;
  end;

end;

end.
d.
