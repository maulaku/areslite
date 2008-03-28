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
bittorrent worker thread
}

unit thread_bitTorrent;

interface

uses
 classes,windows,sysutils,btcore,blcksock,synsock,classes2,
 comettrees;

type
tthread_bitTorrent=class(tthread)
 private
 last_sec,
 lasT_min,
 tick:cardinal;
 acceptedsockets:tmylist;

 loc_numDownloads,loc_numUploads:word;
 loc_speedDownloads,loc_SpeedUploads:cardinal;
 loc_downloadedBytes,loc_UploadedBytes:int64;
 FMaxUlSpeed:cardinal;
 FHasLimitedOutput:boolean;

 protected
  procedure AddVisualTransfers;//sync
  procedure execute; override;
  procedure log(txt:string);
  procedure Update_Hint(node:PCmtVNode; treeview:TCometTree);
  procedure calcSourceUptime(source:TBitTorrentSource);


  procedure checkTracker; overload;
  procedure checkTracker(transfer:TBittorrentTransfer); overload;
  procedure CompleteVisualTransfer;//sync
  procedure init_vars;
  procedure TrackerDeal; overload;
  procedure TrackerDeal(transfer:TBittorrentTransfer); overload;
  procedure transferDeal; overload;
  procedure transferDeal(transfer:TBittorrentTransfer); overload;
  function transferDeal(transfer:TBittorrentTransfer; source:tBitTorrentSource):boolean; overload;
  function GetNumConnecting(transfer:TBitTorrentTransfer):integer;
  procedure SourceFlush(transfer:TBitTorrentTransfer; source:TBittorrentSource);
  procedure SourceParsePacket(transfer:TBitTorrentTransfer; source:TBittorrentSource);
  procedure shutdown;
  procedure getHandshaked_FromAcceptedSockets;
  procedure disconnectSource(transfer:TBittorrentTransfer; source:TBittorrentSource; RemoveRequests:boolean=true);
  procedure RemoveSource(transfer:TBittorrentTransfer; source:TBittorrentSource);

  procedure deleteVisualGlobSource; //synch
  procedure AddVisualGlobSource;//sync
  procedure AddVisualTransferReference(tran:TBitTorrentTransfer);
  procedure SourceAddFailedAttempt(transfer:TBitTorrentTransfer; source:TBittorrentSource);
  procedure ResetBitField(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
  procedure updateBitField(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
  procedure handleIncomingPiece(transfer:TBittorrentTransfer; source:TBittorrentSource);
  procedure HandleIncomingRequest(transfer:TBittorrentTransfer; source:TBittorrentSource);
  procedure checkSourcesVisual(list:tmylist); overload;
  procedure checkSourcesVisual(transfer:TBittorrentTransfer); overload;
  procedure checkSourcesVisual; overload;
  procedure putStats;//sync
  function GetTransferFromHash(const HashStr:string):TbittorrentTransfer;
  procedure updateVisualGlobSource;
  procedure processTempDownloads;//sync
  procedure BitTorrentCancelTransfer(Transfer:TBitTorrentTransfer);
  procedure BitTorrentPauseTransfer(Transfer:TBitTorrentTransfer);
  procedure areWeStillInterested(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
  procedure SetAllNotinterested(transfer:TBitTorrentTransfer);//download completed we no longer need seeders

  procedure Handle_FastPeer_SuggestPiece(transfer:TBittorrentTransfer; source:TBittorrentSource);
  procedure Handle_FastPeer_HaveAll(transfer:TBittorrentTransfer; source:TBittorrentSource);
  procedure Handle_FastPeer_HaveNone(transfer:TBittorrentTransfer; source:TBittorrentSource);
  procedure Handle_FastPeer_RejectRequest(transfer:TBittorrentTransfer; source:TBittorrentSource);

  procedure Handle_ExtensionProtocol_Message(transfer:TBittorrentTransfer; source:TBittorrentSource);
 public
  BittorrentTransfers:tmylist;
end;

 procedure UnChokeBestSourcesForaLeecher(HowMany:integer; transfer:TBittorrentTransfer; tick:cardinal);
 procedure UnChokeBestSourcesForaSeeder(HowMany:integer; transfer:TBittorrentTransfer; tick:cardinal);
 procedure updateVisualGlobSource;
 procedure CancelOutGoingRequestsForPiece(transfer:TBitTorrentTransfer; Source:TBittorrentSource; index:cardinal; offset:Cardinal);

 procedure ChokesDeal(list:Tmylist; tick:cardinal);
 procedure ChokesSeederDeal(transfer:TBittorrentTransfer; tick:cardinal);
 procedure ChokesLeecherDeal(transfer:TBittorrentTransfer; tick:cardinal);
 
 procedure RemoveOutGoingRequestForPiece(transfer:TBittorrentTransfer; index:integer);

 procedure ExpireOutGoingRequests(Transfer:TBitTorrentTransfer; tick:cardinal); overload;
 procedure ExpireOutGoingRequests(list:Tmylist; tick:cardinal); overload;
 procedure checkKeepAlives(list:Tmylist; tick:cardinal); overload;
 procedure checkKeepAlives(transfer:TBitTorrentTransfer; tick:cardinal); overload;
 procedure SendBitField(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
 procedure HandleCancelMessage(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
 procedure CalcChunksPopularity(transfer:TBitTorrentTransfer);
 procedure IncChunkPopularity(transfer:TBitTorrentTransfer; source:TBitTorrentSource; index:integer);
 function AskChunk(Transfer:TBitTorrentTransfer; source:TBitTorrentSource; tick:cardinal):boolean;
 procedure SourceDisconnect(source:TBitTorrentSource);
 procedure BroadcastHave(transfer:TBitTorrentTransfer; piece:TBitTorrentChunk);
 procedure RemoveOutGoingRequests(transfer:TBitTorrentTransfer); overload;
 procedure RemoveOutGoingRequests(transfer:TBitTorrentTransfer; source:TBitTorrentSource); overload;
 procedure CalcNumConnected(transfer:TBitTorrentTransfer);
 procedure DisconnectSeeders(transfer:TBitTorrentTransfer);//download completed we no longer need seeders
 procedure DropOlderIdleSources(transfer:TBitTorrentTransfer);
 function GetoptimumNumOutRequests(speedRecv:cardinal):integer;
 procedure Source_AddOutPacket(source:TBittorrentSource; const packet:string; ID:Byte; haspriority:boolean = false; index:cardinal = 0; offset:cardinal = 0; wantedLen:cardinal = 0); overload;
 procedure Source_AddOutPacket(transfer:TBitTorrentTransfer; sourceId:cardinal; const packet:string; ID:Byte; haspriority:boolean = false; index:cardinal = 0; offset:cardinal = 0; wantedLen:cardinal = 0); overload;
 function FindSourceFromID(transfer:TBitTorrentTransfer; ID:cardinal):TBitTorrentSource;

 function DropWorstConnectedInactiveSource(transfer:TBitTorrentTransfer; source:TBitTorrentSource; tick:cardinal):boolean;
 function PerformOptimisticUnchoke(transfer:TBitTorrentTransfer; tick:cardinal; isUpload:boolean=false):boolean;
 procedure ChokeEveryOneElse(transfer:TBitTorrentTransfer; UntouchableSourcesList:Tmylist);
 procedure CancelOutGoingPiece(transfer:TBitTorrentTransfer; source:TBitTorrentSource; index,offset:cardinal);
 procedure ParseHandshakeReservedBytes(source:TBittorrentSource; const extStr:string);
 Procedure SourceSetConnected(source:TBitTorrentSource);

 function FindPieceNotRequestedBySource(transfer:TBitTorrentTransfer; source:TBittorrentSource; piece:TBitTorrentChunk):integer;
 function FindPieceNotRequestedByAnySource(transfer:TBitTorrentTransfer; piece:TBitTorrentchunk):integer;
 function ChoseIncompleteChunk(transfer:TBitTorrentTransfer; source:TBitTorrentSource; var SuggestedFreeOffSetIndex:integer):TBittorrentChunk;
 function ChoseLeastPopularChunk(transfer:TBitTorrentTransfer; source:TBitTorrentSource; var SuggestedFreeOffSetIndex:integer):TBitTorrentChunk;
 function ChosePrioritaryChunk(transfer:TBitTorrentTransfer; source:TBitTorrentSource; var SuggestedFreeOffSetIndex:integer):TBitTorrentChunk;
 function Source_PeekRequest_InIncomingBuffer(source:TBitTorrentSource; request:precord_BitTorrentoutgoing_request):boolean;
 procedure Source_Increase_ReceiveStats(transfer:TBittorrentTransfer; Source:TBittorrentSource; previousLen,len_recv:integer; tick:cardinal);
 procedure logSourceDisconnect(Source:TBittorrentSource; tick:cardinal);

 procedure SendAzHandshake(transfer:TBitTorrentTransfer;source:TBitTorrentSource);
 procedure SendAzPEX(transfer:TBitTorrentTransfer;source:TBitTorrentSource; tick:cardinal);
 procedure HandleAzHandshake(transfer:TBittorrentTransfer;source:TBittorrentSource);
 procedure HandleAzPEX(transfer:TBittorrentTransfer; source:TBittorrentSource);
 procedure saveTransfersDb(list:Tmylist);
 procedure DropCheatingClients(list:TMylist; tick:cardinal); overload;
 procedure DropCheatingClients(transfer:TBittorrentTransfer; tick:cardinal); overload;
 function CalcSourceOriginality(transfer:TBittorrentTransfer; source:TBittorrentSource):integer;
 function sourceIsTheOnlyOneHavingPiece(transfer:TBittorrentTransfer; source:TBittorrentSource; index:cardinal):boolean;
 function HasLimitedOutPut(UpSpeed:cardinal):boolean;

 var
 globSource:tbittorrentSource;
 GlobTransfer:TBitTorrentTransfer;
 mypeerID,myrandkey,myAzIdentity,aresTorrentSignature:string;

implementation

uses
 ufrmmain,BittorrentStringfunc,bitTorrentConst,vars_global,helper_strings,
 bittorrentUtils,securehash,BitTorrentDlDb,helper_sorting,ares_objects,helper_datetime,
 const_ares,ares_types,helper_unicode,helper_bighints,const_timeouts,vars_localiz,
 helper_ipfunc,helper_sockets,helper_urls;

procedure tthread_bitTorrent.init_vars;
begin
tick:=gettickcount;
last_sec:=tick;
last_min:=tick;
 randseed:=gettickcount;

acceptedsockets:=tmylist.create;

loc_numDownloads:=0;
loc_numUploads:=0;
loc_speedDownloads:=0;
loc_speedUploads:=0;
loc_downloadedBytes:=0;
loc_UploadedBytes:=0;
 FMaxUlSpeed:=0;
 FHasLimitedOutput:=false;


aresTorrentSignature:='-'+BITTORRENT_APPNAME+BittorrentStringFunc.GetSerialized4CharVersionNumber+'-';
myAzidentity:=GetrandomChars(20);
thread_bittorrent.mypeerID:=aresTorrentSignature+GetrandomAsciiChars(12);
thread_bittorrent.myrandkey:=GetrandomAsciiChars(8);
end;



procedure tthread_bitTorrent.AddVisualTransferReference(tran:TBitTorrentTransfer);
var
dataNode:ares_types.precord_data_node;
node:PCMtVNode;
data:precord_displayed_bittorrentTransfer;
begin

     if tran.UploadTreeview then begin
       node:=ares_frmmain.treeview_upload.AddChild(nil);
       dataNode:=ares_frmmain.treeview_upload.getdata(Node);
     end else begin
       node:=ares_frmmain.treeview_download.AddChild(nil);
       dataNode:=ares_frmmain.treeview_download.getdata(Node);
      end;
      dataNode^.m_type:=dnt_bittorrentMain;

      data:=AllocMem(sizeof(record_displayed_bittorrentTransfer));
      dataNode^.data:=Data;

     tran.visualNode:=node;
     tran.visualData:=data;
     tran.visualData^.handle_obj:=longint(tran);
     tran.visualData^.FileName:=widestrtoutf8str(helper_urls.extract_fnameW(utf8strtowidestr(tran.fname)));
     tran.visualData^.Size:=tran.fsize;
     tran.visualData^.downloaded:=tran.fdownloaded;
     tran.visualData^.uploaded:=tran.fuploaded;
     tran.visualData^.hash_sha1:=tran.fhashvalue;
     tran.visualData^.crcsha1:=crcstring(tran.fhashvalue);
     tran.visualData^.SpeedDl:=0;
     tran.visualData^.SpeedUl:=0;
     tran.visualData^.want_cancelled:=false;
     tran.visualData^.want_paused:=false;
     tran.visualData^.want_changeView:=false;
     tran.visualData^.want_cleared:=false;
     tran.visualData^.uploaded:=tran.fuploaded;
     tran.visualData^.downloaded:=tran.fdownloaded;
     tran.visualData^.num_Sources:=0;
     tran.visualData^.ercode:=0;
     tran.visualData^.state:=tran.fstate;
     if tran.tracker<>nil then tran.visualData^.trackerStr:=tran.tracker.URL
      else tran.visualData^.trackerStr:='';
     tran.visualData^.Fpiecesize:=tran.fpieceLength;
     tran.visualData^.NumLeechers:=0;
     tran.visualData^.NumSeeders:=0;
     tran.visualData^.path:=tran.fname;
     tran.visualData^.NumConnectedSeeders:=tran.NumConnectedSeeders;
     tran.visualData^.NumConnectedLeechers:=tran.NumConnectedLeechers;
    SetLength(tran.visualData^.bitfield,length(tran.FPieces));

   btcore.CloneBitField(tran);
end;

procedure tthread_bitTorrent.processTempDownloads;//sync
var
BitTran:tbittorrentTransfer;
sock:TTCPBlockSocket;
begin
  if vars_global.BitTorrentTempList<>nil then
  while (vars_global.BitTorrentTempList.count>0) do begin
      BitTran:=vars_global.BitTorrentTempList[vars_global.BitTorrentTempList.count-1];
               vars_global.BitTorrentTempList.delete(vars_global.BitTorrentTempList.count-1);
      BitTorrentTransfers.add(BitTran);
      outputdebugstring(pchar('bittorrent just added transfer to thread'));
  end;

  while (vars_global.bittorrent_Accepted_sockets.count>0) do begin
     sock:=vars_global.bittorrent_Accepted_sockets[0];
           vars_global.bittorrent_Accepted_sockets.delete(0);
     sock.tag:=tick;
     acceptedsockets.add(sock);
  end;
end;

procedure tthread_bittorrent.BitTorrentCancelTransfer(Transfer:TBitTorrentTransfer);
begin
Transfer.visualData^.handle_obj:=INVALID_HANDLE_VALUE;
Transfer.visualData^.state:=dlCancelled;
Transfer.visualData^.SpeedDl:=0;
Transfer.visualData^.speedUl:=0;

if transfer.uploadtreeview then begin
 ares_frmmain.treeview_upload.invalidatenode(Transfer.visualNode);
 ares_frmmain.treeview_upload.deleteChildren(Transfer.visualNode,true);
end else begin
 ares_frmmain.treeview_download.invalidatenode(Transfer.visualNode);
 ares_frmmain.treeview_download.deleteChildren(Transfer.visualNode,true);
end;


Transfer.FState:=dlCancelled;
Transfer.wipeout;
end;

procedure tthread_bittorrent.BitTorrentPauseTransfer(Transfer:TBitTorrentTransfer);
var
i:integer;
source:TBitTorrentSource;
begin

RemoveOutGoingRequests(transfer);
transfer.numConnected:=0;

if transfer.tracker.socket<>nil then begin
 transfer.tracker.socket.free;
 transfer.tracker.socket:=nil;
 transfer.tracker.next_poll:=tick+(transfer.tracker.interval*1000)+(30*SECOND);
end;

for i:=0 to transfer.fsources.count-1 do begin
 source:=transfer.fsources[i];

 if source.status=btSourceIdle then continue;
  if source.status=btSourceShouldRemove then continue;
   if source.status=btSourceShouldDisconnect then continue;

 disconnectSource(transfer,source,false);
end;

transfer.CalculateLeechsSeeds;

BitTorrentDlDb.BitTorrentDb_updateDbOnDisk(Transfer);
end;

procedure tthread_bittorrent.AddVisualTransfers;//sync
var
i:integer;
tran:TBitTorrentTransfer;
begin
 for i:=0 to BitTorrentTransfers.count-1 do begin
  tran:=BitTorrentTransfers[i];
  AddVisualTransferReference(tran);
 end;
end;

procedure tthread_bitTorrent.execute;
begin
freeonterminate:=false;
priority:=tpnormal;

synchronize(AddVisualTransfers);

init_vars;


while (not terminated) do begin
 try

 tick:=gettickcount;

 if tick-last_sec>SECOND then begin

  if not terminated then checkSourcesVisual(BitTorrentTransfers);
   last_sec:=tick;
  if not terminated then synchronize(processTempDownloads);

  if not terminated then TrackerDeal;
  if not terminated then checkTracker;

   sleep(5);
  if not terminated then getHandshaked_FromAcceptedSockets;
  if not terminated then ExpireOutGoingRequests(BitTorrentTransfers,tick);

  ChokesDeal(BitTorrentTransfers,tick);

   if tick-last_min>MINUTE then begin
    last_min:=tick;
    FMaxUlSpeed:=0; // reset value here as it's a very dynamic value
    if not terminated then checkKeepAlives(BitTorrentTransfers,tick);
    DropCheatingClients(BitTorrentTransfers,tick);
   end;

 end;

 
 TransferDeal;

 if terminated then break else sleep(10);
 except
 end;
end;

shutdown;
end;

function HasLimitedOutPut(UpSpeed:cardinal):boolean;
begin
result:=(UpSpeed<40000);
end;

procedure DropCheatingClients(list:TMylist; tick:cardinal);
var
tran:tbittorrentTransfer;
i:integer;
begin
 for i:=0 to list.count-1 do begin
  tran:=list[i];
  DropCheatingClients(tran,tick);
 end;
end;

procedure DropCheatingClients(transfer:TBittorrentTransfer; tick:cardinal);
var
i:integer;
source:TBittorrentSource;
begin

for i:=0 to transfer.fsources.count-1 do begin
 source:=transfer.fsources[i];
 if source.status=btSourceShouldRemove then continue;
 if tick-source.handshakeTick<MINUTE then continue;

 if copy(source.id,1,8)=aresTorrentSignature then begin
   if length(source.client)<13{'Ares 1.9.4.3XXX'} then begin
    btcore.AddBannedIp(transfer,source.ipC);
    source.status:=btSourceShouldRemove;
   end;
 end;

end;
end;

procedure ChokesDeal(list:Tmylist; tick:cardinal);
var
i:integer;
tran:TbittorrentTransfer;
begin
 for i:=0 to list.count-1 do begin
  tran:=list[i];
  if tran.isCompleted then ChokesSeederDeal(tran,tick)
   else ChokesLeecherDeal(tran,tick);
 end;
end;

procedure tthread_bittorrent.calcSourceUptime(source:TBitTorrentSource);
begin
source.uptime:=(tick-source.handshakeTick) div 1000;
end;

function PerformOptimisticUnchoke(transfer:TBitTorrentTransfer; tick:cardinal; isUpload:Boolean=false):boolean;
var
i:integer;
source:TBitTorrentSource;
candidates:tmylist;
begin
 result:=false;

 candidates:=Tmylist.create;

 for i:=0 to transfer.fsources.count-1 do begin
  source:=transfer.fsources[i];
  if source.status<>btSourceConnected then continue;
   if source.isSeeder then continue;
    if not source.isInterested then continue;
     if not source.isChoked then continue;

      if not isUpload then begin // unchoked three times, received nothing but sent quite a few
        if source.NumOptimisticUnchokes>=3 then
         if source.recv=0 then
          if source.weAreInterested then
           if source.sent>MEGABYTE then continue;
      end;

    if transfer.uploadSlots.IndexOf(source)<>-1 then continue; // it's already a 'best source'

    if transfer.optimisticUnchokedSources.indexof(source)=-1 then candidates.add(source);
 end;



 if transfer.optimisticUnchokedSources.count>0 then
  if candidates.count=0 then begin
    transfer.optimisticUnchokedSources.clear;

      for i:=0 to transfer.fsources.count-1 do begin
       source:=transfer.fsources[i];
       if source.status<>btSourceConnected then continue;
        if source.isSeeder then continue;
         if not source.isInterested then continue;
          if not source.isChoked then continue;

          if not isUpload then begin // unchoked three times, received nothing but sent quite a few
           if source.NumOptimisticUnchokes>=3 then
            if source.weAreInterested then
             if source.recv=0 then
              if source.sent>MEGABYTE then continue;
         end;

         if transfer.uploadSlots.IndexOf(source)<>-1 then continue; // it's already a 'best source'

       candidates.add(source);
     end;
  end;




 if candidates.count=0 then begin
  candidates.free;
  exit;
 end;
 
 randseed:=gettickcount;
 if candidates.count>1 then shuffle_mylist(candidates,0);

 source:=candidates[0];
 source.isChoked:=false;
 Source_AddOutPacket(source,'',CMD_BITTORRENT_UNCHOKE);
  if not isUpload then inc(source.NumOptimisticUnchokes);
 source.SlotType:=ST_OPTIMISTIC;
 source.SlotTimeout:=tick+(30*SECOND);
 transfer.uploadSlots.add(source);
 transfer.optimisticUnchokedSources.add(source);

 candidates.free;

 result:=true;
end;

procedure UnChokeBestSourcesForALeecher(HowMany:integer; transfer:TBittorrentTransfer; tick:cardinal);
var
i,numDone:integer;
source:TBitTorrentSource;
candidates,slowCandidates:tmylist;
begin

 NumDone:=0;

 candidates:=Tmylist.create;
 slowCandidates:=Tmylist.create;

 for i:=0 to transfer.fsources.count-1 do begin
  source:=transfer.fsources[i];
  if source.status<>btSourceConnected then continue;
   if source.isSeeder then continue;
    if not source.isInterested then continue;
     if not source.weAreInterested then continue;
      if transfer.uploadSlots.IndexOf(source)<>-1 then continue; // it's already a 'best source'
       if source.Snubbed then continue;
      if source.speed_recv<256 then begin
          if source.recv>0 then
           if (source.sent div source.recv)<=3 then slowCandidates.add(source); //source too slow, but not leeching badly
      end else candidates.add(source);
      
 end;



 if candidates.count>1 then candidates.Sort(sortBitTorrentBestDownRateFirst);
 if slowCandidates.count>1 then SlowCandidates.Sort(sortBitTorrentBestDownBytesFirst);

   while (candidates.count>0) do begin
     source:=candidates[0];
             candidates.delete(0);

     if source.isChoked then begin
      Source_AddOutPacket(source,'',CMD_BITTORRENT_UNCHOKE);
      source.isChoked:=false;
     end;
     
     source.SlotType:=ST_NORMAL;
     source.SlotTimeout:=tick+(10*SECOND);
     transfer.uploadSlots.add(source);

     inc(NumDone);
     if NumDone>=HowMany then begin
      candidates.free;
      slowCandidates.free;
      exit;
     end;
   end;

   candidates.free;


   // not enough, let's add also historically good sources
   while (SlowCandidates.count>0) do begin
     source:=SlowCandidates[0];
             SlowCandidates.delete(0);

     if source.isChoked then begin
      Source_AddOutPacket(source,'',CMD_BITTORRENT_UNCHOKE);
      source.isChoked:=false;
     end;
     
     source.SlotType:=ST_NORMAL;
     source.SlotTimeout:=tick+(10*SECOND);
     transfer.uploadSlots.add(source);

     inc(NumDone);
     if NumDone>=HowMany then begin
      slowCandidates.free;
      exit;
     end;
   end;


 slowCandidates.free;
end;

procedure UnChokeBestSourcesForaSeeder(HowMany:integer; transfer:TBittorrentTransfer; tick:cardinal);
var
i,numDone:integer;
source:TBitTorrentSource;
candidates,slowCandidates:tmylist;
begin

 NumDone:=0;

 candidates:=Tmylist.create;
 slowCandidates:=Tmylist.create;

 for i:=0 to transfer.fsources.count-1 do begin
  source:=transfer.fsources[i];
  if source.status<>btSourceConnected then continue;
   if source.isSeeder then continue;
    if not source.isInterested then continue;
     if transfer.uploadSlots.IndexOf(source)<>-1 then continue; // it's already a 'best source'

      if source.speed_send<256 then slowCandidates.add(source) //source too slow
       else candidates.add(source);
 end;



 if candidates.count>1 then candidates.Sort(sortBitTorrentBestUpRateFirst);
 if slowCandidates.count>1 then SlowCandidates.Sort(sortBitTorrentBestUpBytesFirst);

   while (candidates.count>0) do begin
     source:=candidates[0];
             candidates.delete(0);

     if source.isChoked then begin
      Source_AddOutPacket(source,'',CMD_BITTORRENT_UNCHOKE);
      source.isChoked:=false;
     end;
     
     source.SlotType:=ST_NORMAL;
     source.SlotTimeout:=tick+(10*SECOND);
     transfer.uploadSlots.add(source);

     inc(NumDone);
     if NumDone>=HowMany then begin
      candidates.free;
      slowCandidates.free;
      exit;
     end;
   end;

   candidates.free;


   // not enough, let's add also historically good sources
   while (SlowCandidates.count>0) do begin
     source:=SlowCandidates[0];
             SlowCandidates.delete(0);

     if source.isChoked then begin
      Source_AddOutPacket(source,'',CMD_BITTORRENT_UNCHOKE);
      source.isChoked:=false;
     end;
     
     source.SlotType:=ST_NORMAL;
     source.SlotTimeout:=tick+(10*SECOND);
     transfer.uploadSlots.add(source);

     inc(NumDone);
     if NumDone>=HowMany then begin
      slowCandidates.free;
      exit;
     end;
   end;


 slowCandidates.free;
end;

procedure ChokesSeederDeal(transfer:TBittorrentTransfer; tick:cardinal);
var
i,NumAllowedSlots:integer;
OptimisticCount:integer;
source:TBitTorrentSource;
begin
try
if transfer.fstate=dlPaused then exit;

 NumAllowedSlots:=4;
 OptimisticCount:=0;
// expire upload slots
i:=0;
while (i<transfer.uploadSlots.count) do begin
 source:=transfer.uploadSlots[i];
 if tick>source.SlotTimeout then transfer.uploadSlots.delete(i)
 else begin
  if source.SlotType=ST_OPTIMISTIC then inc(OptimisticCount);
  inc(i);
 end;
end;



// unchoke best sources (downloadwise)
if OptimisticCount>0 then NumAllowedSlots:=5;
if transfer.uploadSlots.count<NumAllowedSlots then UnChokeBestSourcesForaSeeder(NumAllowedSlots-transfer.uploadSlots.count,transfer,tick);

// perform optimistic unchoke
if (OptimisticCount=0) or
   ((transfer.uploadSlots.count<NumAllowedSlots) and (OptimisticCount<3)) then begin

 while (PerformOptimisticUnchoke(transfer,tick,true)) do begin
  inc(OptimisticCount);
  if OptimisticCount>=3 then break; // leave room for at least one regular unchoke (we need to be able to quickly chose fast sources)
  if transfer.uploadSlots.count>=NumAllowedSlots then break;
 end;

end;


// choke every other source (keeps NumAllowedSlots right)
ChokeEveryOneElse(transfer,transfer.uploadSlots);

except
end;
end;

procedure ChokesLeecherDeal(transfer:TBittorrentTransfer; tick:cardinal);
var
i,NumAllowedSlots,OptimisticCount:integer;
source:TBitTorrentSource;
begin
try
if transfer.fstate=dlPaused then exit;

if transfer.FUlSpeed<5000 then NumAllowedSlots:=2
 else
if transfer.FUlSpeed<10000 then NumAllowedSlots:=3
 else
if transfer.FUlSpeed<25000 then NumAllowedSlots:=4
 else
if transfer.FUlSpeed<45000 then NumAllowedSlots:=5
 else
if transfer.FUlSpeed<70000 then NumAllowedSlots:=6
 else
if transfer.FUlSpeed<100000 then NumAllowedSlots:=7
 else NumAllowedSlots:=8;

OptimisticCount:=0;

// expire upload slots
i:=0;
while (i<transfer.uploadSlots.count) do begin
 source:=transfer.uploadSlots[i];
 if tick>source.SlotTimeout then transfer.uploadSlots.delete(i)
 else begin
  if source.SlotType=ST_OPTIMISTIC then inc(OptimisticCount);
  inc(i);
 end;
end;

// unchoke best sources (downloadwise)
 if OptimisticCount>0 then inc(NumAllowedSlots);
if transfer.uploadSlots.count<NumAllowedSlots then UnChokeBestSourcesForaLeecher(NumAllowedSlots-transfer.uploadSlots.count,transfer,tick);

// perform optimistic unchoke
if (OptimisticCount=0) or
   ((transfer.uploadSlots.count<NumAllowedSlots) and (OptimisticCount<3)) then begin

 while (PerformOptimisticUnchoke(transfer,tick,false)) do begin
  inc(OptimisticCount);
  if OptimisticCount>=3 then break; // leave room for at least two regular unchokes (we need to be able to quickly reciprocate fast sources)
  if transfer.uploadSlots.count>=NumAllowedSlots then break;
 end;

end;


// choke every other source (keeps NumAllowedSlots right)
ChokeEveryOneElse(transfer,transfer.uploadSlots);


except
end;
end;

procedure ChokeEveryOneElse(transfer:TBitTorrentTransfer; UntouchableSourcesList:Tmylist);
var
i:integer;
source:TBitTorrentSource;
begin

for i:=0 to transfer.fsources.count-1 do begin
 source:=transfer.fsources[i];
 if source.status<>btSourceConnected then continue;
 if source.isSeeder then continue;
 if source.isChoked then continue;
 if UntouchableSourcesList.indexof(source)<>-1 then continue;

 source.isChoked:=true;
 Source_AddOutPacket(source,'',CMD_BITTORRENT_CHOKE);
end;

end;

procedure tthread_bitTorrent.checkSourcesVisual(list:tmylist);
var
i:integer;
TempUlSpeed:cardinal;
tran:TBittorrentTransfer;
begin
loc_numDownloads:=0;
loc_numUploads:=0;
loc_speedDownloads:=0;
loc_SpeedUploads:=0;
TempUlSpeed:=0;

 i:=0;
 while (i<BitTorrentTransfers.count) do begin
  tran:=BitTorrentTransfers[i];
  checkSourcesVisual(tran);
  if tran.FUlSpeed>0 then inc(TempUlSpeed,tran.FUlSpeed);
  inc(i);
 end;

 if TempUlSpeed>FMaxUlSpeed then FMaxUlSpeed:=TempUlSpeed;
 FHasLimitedOutput:=HasLimitedOutPut(FMaxUlSpeed);

 synchronize(putStats);
end;

procedure tthread_bitTorrent.putStats;//sync
begin
 numTorrentDownloads:=loc_numDownloads;
 numTorrentUploads:=loc_NumUploads;
 speedTorrentdownloads:=loc_speedDownloads;
 speedTorrentUploads:=loc_speedUploads;
 BitTorrentDownloadedBytes:=loc_downloadedBytes;
 BitTorrentUploadedBytes:=loc_uploadedBytes;
end;


procedure tthread_bitTorrent.checkSourcesVisual(transfer:TBittorrentTransfer);
var
i:integer;
source:TBitTorrentSource;
begin
transfer.FDlSpeed:=0;
transfer.FUlSpeed:=0;


for i:=0 to transfer.fsources.count-1 do begin
 source:=transfer.fsources[i];
 if source.status<>btSourceConnected then continue;

 source.speed_recv:=((source.speed_recv div 10)*9) + ((source.recv-source.bytes_recv_before) div 10);
 source.bytes_recv_before:=source.recv;
 if source.speed_recv>source.speed_recv_max then source.speed_recv_max:=source.speed_recv;

 //if source.isChoked then source.speed_send:=0
  //else
  source.speed_send:=((source.speed_send div 10)*9) + ((source.sent-source.bytes_sent_before) div 10);
 source.bytes_sent_before:=source.sent;
 if source.speed_send>source.speed_send_max then source.speed_send_max:=source.speed_send;

 if transfer.fstate<>dlSeeding then
  if source.speed_recv>0 then
   inc(transfer.FDlSpeed,source.speed_recv);

 if source.speed_send>0 then inc(transfer.FUlSpeed,source.speed_send);

 source.NumBytesToSendPerSecond:=source.speed_recv+1024;
end;

 if transfer.FDlSpeed>transfer.peakSpeedDown then transfer.peakSpeedDown:=transfer.fDlSpeed;

 if transfer.FDlSpeed=0 then begin
  if transfer.fstate=dlDownloading then transfer.fstate:=dlProcessing;
 end else inc(loc_SpeedDownloads,transfer.FDlSpeed);

  
GlobTransfer:=transfer;
synchronize(checkSourcesVisual);
end;



procedure tthread_bitTorrent.checkSourcesVisual; //sync
var
i,index:integer;
source:TBitTorrentSource;
begin
if GlobTransfer.fstate=dlFinishedAllocating then begin
 GlobTransfer.fstate:=dlProcessing;
end;

if GlobTransfer.fstate=dlAllocating then exit;

/////////////////////////////////// CANCEL TRANSFER
if GlobTransfer.visualData^.want_cancelled then begin // cancel transfer, update GUI so clearIdle may be effective
  GlobTransfer.visualData^.want_cancelled:=false;

 if GlobTransfer.Uploadtreeview then begin //remove from treeview_upload and stop seeding

   index:=BittorrentTransfers.indexof(GlobTransfer);
   if index<>-1 then begin
     BittorrentTransfers.delete(index);
      GlobTransfer.visualData^.state:=dlCancelled;
      GlobTransfer.visualData^.handle_obj:=INVALID_HANDLE_VALUE;
      GlobTransfer.visualData^.SpeedDl:=0;
      GlobTransfer.visualData^.speedUl:=0;
      ares_frmmain.treeview_upload.deleteChildren(GlobTransfer.visualNode,true);
      ares_frmmain.treeview_upload.invalidateNode(GlobTransfer.visualNode);
     GlobTransfer.free;
     exit;
   end;

 end else begin

  if GlobTransfer.fstate<>dlSeeding then begin
   index:=BittorrentTransfers.indexof(GlobTransfer);
    if index<>-1 then begin
     BittorrentTransfers.delete(index);
     BitTorrentCancelTransfer(GlobTransfer);
     exit;
    end;
  end;

 end;

end;



// SHOW POSSIBLE ERRORS
if GlobTransfer.ferrorCode<>0 then begin
  if GlobTransfer.visualData^.erCode<>GlobTransfer.ferrorCode then begin
   GlobTransfer.visualData^.erCode:=GlobTransfer.ferrorCode;
    if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then
     if GlobTransfer.uploadTreeview then begin
      ares_frmmain.treeview_upload.InvalidateNode(GlobTransfer.visualNode);
      Update_Hint(GlobTransfer.visualNode,ares_frmmain.treeview_upload);
     end else begin
      ares_frmmain.treeview_download.InvalidateNode(GlobTransfer.visualNode);
      Update_Hint(GlobTransfer.visualNode,ares_frmmain.treeview_download);
    end;
  end;
exit;
end;




// STATS
for i:=0 to GlobTransfer.fsources.count-1 do begin
 source:=GlobTransfer.fsources[i];
 if source.status<>btSourceConnected then continue;
 if source.dataDisplay=nil then continue;
 source.dataDisplay^.recv:=source.recv;
 source.dataDisplay^.sent:=source.sent;
 source.dataDisplay^.speedup:=source.speed_send;
 source.dataDisplay^.speeddown:=source.speed_recv;

 source.datadisplay^.choked:=source.isChoked;
 source.datadisplay^.interested:=source.isinterested;
 source.datadisplay^.weAreChoked:=source.weArechoked;
 Source.datadisplay^.weAreInterested:=Source.weAreInterested;
 Source.datadisplay^.isOptimistic:=((source.slotType=ST_OPTIMISTIC) and (not source.isChoked));
 Source.datadisplay^.port:=source.port;
 Source.dataDisplay^.client:=source.client;

  if source.changedVisualBitField then begin
   source.changedVisualBitField:=false;
   btcore.CloneBitfield(source.bitfield,source.datadisplay^.VisualBitField,source.datadisplay^.progress);
  end;

  if Source.dataDisplay^.should_disconnect then begin
   Source.dataDisplay^.should_disconnect:=false;
   source.status:=btSourceShouldRemove;
   btcore.AddBannedIp(GlobTransfer,source.ipC);
  end;

 if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then
  if GlobTransfer.uploadTreeview then begin
   ares_frmmain.treeview_upload.InvalidateNode(source.nodeDisplay);
   Update_Hint(source.nodeDisplay,ares_frmmain.treeview_upload);
  end else begin
   ares_frmmain.treeview_download.InvalidateNode(source.nodeDisplay);
   Update_Hint(source.nodeDisplay,ares_frmmain.treeview_download);
  end;

end;

GlobTransfer.visualData^.downloaded:=GlobTransfer.TempDownloaded;
GlobTransfer.visualData^.uploaded:=GlobTransfer.fuploaded;
GlobTransfer.visualData^.speedDl:=GlobTransfer.FDlSpeed;
GlobTransfer.visualData^.speedUl:=GlobTransfer.FUlSpeed;
GlobTransfer.visualData^.num_sources:=GlobTransfer.fsources.count;
GlobTransfer.visualData^.state:=GlobTransfer.fstate;

if GlobTransfer.tracker.socket<>nil then GlobTransfer.visualData^.trackerStr:=GlobTransfer.tracker.visualStr
 else begin
    if GlobTransfer.tracker.next_poll<tick then GlobTransfer.visualData^.trackerStr:=GlobTransfer.tracker.visualStr+', '+
                                              GetLangStringW(STR_REFRESH)+' '+
                                              format_time(0)
      else GlobTransfer.visualData^.trackerStr:=GlobTransfer.tracker.visualStr+', '+
                                                GetLangStringW(STR_REFRESH)+' '+
                                                format_time((GlobTransfer.tracker.next_poll-tick) div 1000);
 end;
 
GlobTransfer.visualData^.NumLeechers:=GlobTransfer.tracker.Leechers;
GlobTransfer.visualData^.NumSeeders:=GlobTransfer.tracker.Seeders;
GlobTransfer.visualData^.NumConnectedSeeders:=GlobTransfer.NumConnectedSeeders;
GlobTransfer.visualData^.NumConnectedLeechers:=GlobTransfer.NumConnectedLeechers;

if GlobTransfer.fstate=dlDownloading then inc(loc_numDownloads);

// write upload stats now that this transfer is in treeview_upload
if GlobTransfer.fstate=dlSeeding then
 if GlobTransfer.uploadtreeview then begin
  inc(loc_numUploads);
  inc(loc_speedUploads,GlobTransfer.FUlSpeed);
  inc(loc_UploadedBytes,GlobTransfer.TempUploaded);
  GlobTransfer.TempUploaded:=0;
 end;

if globTransfer.changedVisualBitField then begin
  globTransfer.changedVisualBitField:=false;
  CloneBitfield(GlobTransfer);
end;

if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then
 if globTransfer.Uploadtreeview then begin
  if ares_frmmain.treeview_upload.visible then begin
   ares_frmmain.treeview_upload.invalidatenode(GlobTransfer.visualNode);
   Update_Hint(GlobTransfer.visualNode,ares_frmmain.treeview_upload);
  end;
 end else begin
  if ares_frmmain.treeview_download.visible then begin
   ares_frmmain.treeview_download.invalidatenode(GlobTransfer.visualNode);
   Update_Hint(GlobTransfer.visualNode,ares_frmmain.treeview_download);
  end;
 end;



if GlobTransfer.fstate=dlSeeding then
 if GlobTransfer.visualData^.want_cleared then
  if not GlobTransfer.UploadTreeview then begin  //ClearIdle on a transfer in seed mode...migrate to treeview_upload
   GlobTransfer.visualData^.want_cleared:=false;

   if GlobTransfer.visualnode=previous_hint_node then formhint_hide;
   ares_frmmain.treeview_download.deleteNode(GlobTransfer.visualNode,true);

    GlobTransfer.UploadTreeview:=true;
   AddVisualTransferReference(GlobTransfer);

    for i:=0 to GlobTransfer.FSources.count-1 do begin
     GlobSource:=GlobTransfer.Fsources[i];
     GlobSource.dataDisplay:=nil;
     GlobSource.nodeDisplay:=nil;
     AddVisualGlobSource;
    end;

   exit;
  end;






if GlobTransfer.visualData^.want_paused then begin
  GlobTransfer.visualData^.want_paused:=false;
   if GlobTransfer.fstate<>dlSeeding then begin
    if GlobTransfer.fstate=dlPaused then begin
      GlobTransfer.fstate:=dlProcessing;
      BitTorrentDlDb.BitTorrentDb_updateDbOnDisk(GlobTransfer);
    end else begin
     GlobTransfer.fstate:=dlPaused;
     BitTorrentPauseTransfer(GlobTransfer);
     GlobTransfer.visualData^.speedDl:=0;
    end;
    GlobTransfer.visualData^.state:=GlobTransfer.fstate;
     if GlobTransfer.uploadtreeview then ares_frmmain.treeview_upload.invalidatenode(GlobTransfer.visualNode)
      else ares_frmmain.treeview_download.invalidatenode(GlobTransfer.visualNode);
    exit;
   end;
end;

end;


procedure tthread_bittorrent.Update_Hint(node:PCmtVNode; treeview:TCometTree);
begin
if vars_global.formhint.top=10000 then exit;
if node<>vars_global.previous_hint_node then exit;
helper_bighints.mainGui_hintTimer(treeview,node);
end;

procedure tthread_bittorrent.CompleteVisualTransfer;//sync
var
i:integer;
source:TBitTorrentSource;
begin
GlobTransfer.visualData^.speedDl:=0;
GlobTransfer.fstate:=dlSeeding;
GlobTransfer.visualData^.state:=GlobTransfer.fstate;

for i:=0 to GlobTransfer.fsources.count-1 do begin
 source:=GlobTransfer.fsources[i];
 source.speed_recv:=0;
end;

// TODO
// should we add shareable files to our share list now,
// like we do with regular downloads?
// some torrent downloads come as .rar archive and wait for user action...
ares_frmmain.treeview_download.invalidatenode(GlobTransfer.visualNode);
end;

procedure checkKeepAlives(list:Tmylist; tick:cardinal);
var
i:integer;
tran:TBitTorrentTransfer;
begin
 for i:=0 to list.count-1 do begin
  tran:=list[i];
  checkkeepAlives(tran,tick);
  if (i mod 5)=0 then sleep(1);
 end;
end;

procedure checkKeepAlives(transfer:TBitTorrentTransfer; tick:cardinal);
var
i:integer;
source:TBitTorrentSource;
begin
for i:=0 to transfer.fsources.count-1 do begin
  source:=transfer.fsources[i];
   if source.status<>btSourceConnected then continue;
   if tick-source.lastKeepAliveOut<BTKEEPALIVETIMEOUT then continue;

    if ((source.supportsAzmessaging) and (not transfer.isPrivate)) then SendAzPEX(transfer,source,tick) // <-- send keepalive to azureus there, if PEX is empty
     else source_AddOutPacket(source,'',CMD_BITTORRENT_KEEPALIVE);

   source.lastKeepAliveOut:=tick;
end;
end;


procedure saveTransfersDb(list:Tmylist);
var
i:integer;
tran:TBitTorrentTransfer;
begin
//update fname
for i:=0 to list.count-1 do begin
 tran:=list[i];
 if tran.isCompleted then continue;
 BitTorrentDb_updateDbOnDisk(tran);
end;

end;

procedure tthread_bitTorrent.shutdown;
var
sockeT:ttcpblocksocket;
tmpTran:tbittorrentTransfer;
begin
saveTransfersDb(bittorrentTransfers);

try
while (acceptedsockets.count>0) do begin
 socket:=acceptedsockets[acceptedsockets.count-1];
         acceptedsockets.delete(acceptedsockets.count-1);
 socket.free;
end;
except
end;
acceptedsockets.free;


try
while (bittorrentTransfers.count>0) do begin
   tmpTran:=BittorrentTransfers[BittorrentTransfers.count-1];
            BittorrentTransfers.delete(BittorrentTransfers.Count-1);
   tmpTran.free;
end;
except
end;

BittorrentTransfers.free;
end;

procedure tthread_bitTorrent.getHandshaked_FromAcceptedSockets;
var
i,hi:integer;
ipC:cardinal;
found:boolean;
socket:ttcpblocksocket;
source:TBittorrentSource;
transfer:TBitTorrentTransfer;
begin
try

i:=0;
while (i<acceptedsockets.count) do begin
 socket:=acceptedsockets[i];

   transfer:=GetTransferFromHash(copy(socket.buffstr,29,20));
   if transfer=nil then begin
     acceptedSockets.delete(i);
     socket.free;
     continue;
   end;



   if transfer.fErrorCode<>0 then begin
     acceptedSockets.delete(i);
     socket.free;
     continue;
   end;
   if transfer.fstate=dlAllocating then begin
     acceptedSockets.delete(i);
     socket.free;
     continue;
   end;

   ipC:=inet_addr(pchar(socket.ip));

   if btcore.IsBannedIp(transfer,ipC) then begin
     acceptedSockets.delete(i);
     socket.free;
     continue;
   end;


   // check duplicates
   found:=false;
   for hi:=0 to transfer.fsources.count-1 do begin
    source:=transfer.fsources[hi];
     if ipC<>source.ipC then continue;
     found:=true;
     break;
   end;
   if found then begin
     acceptedSockets.delete(i);
     socket.free;
     continue;
   end;
   
   
   acceptedSockets.delete(i);

   if transfer.fstate=dlPaused then begin
    socket.free;
    continue;
   end;

   
   if transfer.numConnected>=BITTORENT_MAXNUMBER_CONNECTION_ACCEPTED then begin
    socket.free;
    continue;
   end;

    if transfer.fsources.count>=BITTORRENT_MAX_ALLOWED_SOURCES then begin
     socket.free;
     continue;
    end;

  source:=TBittorrentSource.create;
   source.socket:=socket;
   source.IpC:=ipC;
   source.ipS:=socket.ip;
   source.port:=socket.port;
   source.ID:=copy(socket.buffstr,49,20);
   source.Client:=BTIDtoClientName(source.ID);
  transfer.fsources.add(source);
    source.status:=btSourceweMustSendHandshake;
    source.tick:=tick;
    source.IsIncomingConnection:=true;

   ParseHandshakeReservedBytes(source,copy(socket.buffstr,21,8));

   socket.buffstr:='';

   globSource:=source;
   globTransfer:=transfer;
   synchronize(AddVisualGlobSource);

end;

except
end;
end;

function tthread_bittorrent.GetTransferFromHash(const HashStr:string):TbittorrentTransfer;
var
 i:integer;
 tran:tbittorrentTransfer;
begin
result:=nil;

 for i:=0 to BitTorrentTransfers.count-1 do begin
   tran:=BitTorrentTransfers[i];
   if tran.fhashvalue<>HashStr then continue;
    result:=tran;
    exit;
 end;
end;

procedure tthread_bitTorrent.AddVisualGlobSource;//sync
var
dataNode:ares_types.precord_data_node;
node:PcmtVNode;
data:btcore.precord_displayed_source;
begin
      if GlobTransfer.uploadtreeview then begin
       node:=ares_frmmain.treeview_upload.AddChild(GlobTransfer.visualNode);
       dataNode:=ares_frmmain.treeview_upload.getdata(node);
      end else begin
       node:=ares_frmmain.treeview_download.AddChild(GlobTransfer.visualNode);
       dataNode:=ares_frmmain.treeview_download.getdata(node);
      end;

      dataNode^.m_type:=dnt_bittorrentSource;

       data:=AllocMem(sizeof(record_Displayed_source));
       dataNode^.data:=data;

       Globsource.dataDisplay:=data;
       Globsource.nodeDisplay:=node;

       Globsource.dataDisplay^.port:=GlobSource.port;
       Globsource.dataDisplay^.ipS:=GlobSource.ipS;
       Globsource.dataDisplay^.status:=Globsource.status;
       Globsource.dataDisplay^.client:=Globsource.client;
       Globsource.dataDisplay^.ID:=Globsource.ID;
       Globsource.dataDisplay^.sourceHandle:=integer(Globsource);
       Globsource.dataDisplay^.VisualBitField:=TBitTorrentBitField.create(length(GlobTransfer.FPieces));
       Globsource.dataDisplay^.choked:=true;
       Globsource.dataDisplay^.interested:=false;
       Globsource.dataDisplay^.weAreChoked:=true;
       Globsource.dataDisplay^.weAreInterested:=false;
       Globsource.dataDisplay^.sent:=0;
       Globsource.dataDisplay^.recv:=0;
       GlobSource.dataDisplay^.size:=globtransfer.fsize;
       GlobSource.dataDisplay^.FPieceSize:=globtransfer.fpieceLength;
       GlobSource.dataDisplay^.progress:=0;
       GlobSource.dataDisplay^.should_disconnect:=false;
end;


procedure SourceDisconnect(source:TBitTorrentSource);
begin
 source.status:=btSourceShouldDisconnect;
end;

procedure tthread_Bittorrent.transferDeal;
var
i:integer;
tran:TBittorrentTransfer;
begin
 for i:=0 to BitTorrentTransfers.count-1 do begin
  tran:=BitTorrentTransfers[i];
  if tran.fstate=dlAllocating then continue;
  transferDeal(tran);

  if terminated then break;
  if (i mod 3)=0 then sleep(1);
 end;
end;

function tthread_bitTorrent.transferDeal(transfer:TBittorrentTransfer; source:tBitTorrentSource):boolean;
var
er,len_recv,to_recv,previousLen:integer;
wanted_payload_len:cardinal;
buffer:array[0..1023] of char;
begin
result:=false;

try

//reveive and flush
if source.outbuffer.count>0 then begin
 SourceFlush(transfer,source);
 if source.status<>btSourceConnected then exit;
end;

if not TCPSocket_CanRead(source.socket.socket,0,er) then begin
 if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
  calcSourceUptime(source);
  logSourceDisconnect(source,tick);
  SourceDisconnect(source);
 end;
 exit;
end;

// receive 4 byte header
if source.bytes_in_header<4 then begin
 len_recv:=TCPSocket_RecvBuffer(source.socket.socket,@source.header,4-source.bytes_in_header,er);
 if er=WSAEWOULDBLOCK then exit;
 if er<>0 then begin
   calcSourceUptime(source);
   logSourceDisconnect(source,tick);
   SourceDisconnect(source);
   exit;
 end;
 inc(source.bytes_in_header,len_recv);
 if source.bytes_in_header<4 then exit;
end;


  wanted_payload_len:=ord(source.header[0]);
  wanted_payload_len:=wanted_payload_len shl 8;
  wanted_payload_len:=wanted_payload_len + ord(source.header[1]);
  wanted_payload_len:=wanted_payload_len shl 8;
  wanted_payload_len:=wanted_payload_len + ord(source.header[2]);
  wanted_payload_len:=wanted_payload_len shl 8;
  wanted_payload_len:=wanted_payload_len + ord(source.header[3]);

  if wanted_payload_len=0 then begin
   source.bytes_in_header:=0; //next packet
   source.inBuffer:='';
   source.lastKeepAliveIn:=tick;
   exit;
  end;

  if source.SupportsAZmessaging then begin
     if wanted_payload_len>BITTORRENT_PIECE_LENGTH+21 then begin  // 0x00 0x00 0x00 0x08 AZ_PIECE 0x01   0x00 0x00 0x00 0x00   0x00 0x00 0x40 0x00
      source.status:=btSourceShouldDisconnect;
      exit;
     end;
  end else begin
     if wanted_payload_len>BITTORRENT_PIECE_LENGTH+9 then begin
      source.status:=btSourceShouldDisconnect;
      exit;
     end;
  end;

while (cardinal(length(source.inBuffer))<wanted_payload_len) do begin
  to_recv:=wanted_payload_len-cardinal(length(source.inbuffer));
  if to_recv>1024 then to_recv:=1024;

  len_recv:=TCPSocket_RecvBuffer(source.socket.socket,@buffer,to_recv,er);
  if er=WSAEWOULDBLOCK then exit;
  if er<>0 then begin
   calcSourceUptime(source);
   logSourceDisconnect(source,tick);
   SourceDisconnect(source);
   exit;
  end;
  if len_recv=0 then begin
   log('recv 0 bytes from '+source.ips+' '+source.client);
   exit;
  end;

  previousLen:=length(source.inBuffer);
  SetLength(source.inBuffer,previousLen+len_recv);
  move(buffer,source.inBuffer[previousLen+1],len_recv);

  Source_Increase_ReceiveStats(transfer,source,previousLen,len_recv,tick);
  if terminated then exit;
end;


 SourceParsePacket(transfer,source);

 source.bytes_in_header:=0;
 source.inBuffer:='';
 
 if source.status<>btSourceConnected then begin
  result:=false;
  log('Source disconnected by protocol handler'+source.ips+' '+source.client);
  calcSourceUptime(source);
  logSourceDisconnect(source,tick);
 end else result:=true;

except
end;
end;

procedure logSourceDisconnect(Source:TBittorrentSource; tick:cardinal);
begin
   outputdebugstring(pchar(formatdatetime('hh:nn:ss',now)+
   ' disconnected '+source.ips+' '+source.client+
   ' outbuffer:'+inttostr(source.outBuffer.count)+
   ' uptime:'+format_time(source.uptime)+
   ' LastOut:'+format_time((tick-source.lastDataOut) div 1000)+
   ' LastIn:'+format_time((tick-source.lastDataIn) div 1000)+
   ' OutRequests:'+inttostr(source.outRequests)+
   ' Recv:'+inttostr(source.recv)+
   string(AddBoolString(' WeAreChoked',source.weareChoked)))); 
end;

procedure Source_Increase_ReceiveStats(transfer:TBittorrentTransfer; Source:TBittorrentSource; previousLen,len_recv:integer; tick:cardinal);
begin
  // increase receive count if it's a piece packet

  if source.SupportsAZmessaging then begin
   if length(source.inBuffer)<22 then exit;
    if copy(source.inBuffer,1,13)<>AZ_BT_PIECE_HEADER then exit;

    if previousLen=0 then begin
     if Len_recv>21 then inc(source.recv,Len_recv-21);
    end else begin
     inc(source.recv,Len_recv);
    end;

        if transfer.fstate<>dlPaused then
         if transfer.Fstate<>dlSeeding then transfer.fstate:=dlDownloading;
         source.Snubbed:=false;
         source.lastDataIn:=tick; //good guy

   exit;
  end;



  if length(source.InBuffer)=0 then exit;
   if source.InBuffer[1]=chr(CMD_BITTORRENT_PIECE) then begin

     if previousLen=0 then begin
       if len_recv>9 then inc(source.recv,Len_recv-9);
     end else inc(source.recv,Len_recv);

       if transfer.fstate<>dlPaused then
        if transfer.Fstate<>dlSeeding then transfer.fstate:=dlDownloading;
        source.Snubbed:=false;
        source.lastDataIn:=tick; //good guy
   end;
end;

procedure HandleAzHandshake(transfer:TBittorrentTransfer; source:TBittorrentSource);
var
ind,LenStr:integer;
StrTCPPort,strUDPPort,strHandType,
strClientName,strClientVersion:string;
begin
//CHRNULL+CHRNULL+CHRNULL+chr(12)+AZ_HANDSHAKE+chr(1)
 delete(source.inBuffer,1,17);

ind:=pos('6:client',source.inBuffer);
if ind>0 then begin
strClientName:=copy(source.inBuffer,ind+8,30);
lenStr:=StrToIntDef(copy(strClientName,1,pos(':',strClientName)-1),0);
 delete(strClientName,1,pos(':',strClientName));
strClientName:=copy(strClientName,1,lenStr);
end;

ind:=pos('7:version',source.inBuffer);
if ind>0 then begin
strClientVersion:=copy(source.inBuffer,ind+9,30);
lenStr:=StrToIntDef(copy(strClientVersion,1,pos(':',strClientVersion)-1),0);
 delete(strClientVersion,1,pos(':',strClientVersion));
strClientVersion:=copy(strClientVersion,1,lenStr);
end;

if length(StrClientName)>0 then
 if length(StrClientVersion)>0 then source.Client:=strClientName+
                                                   ' '+strClientVersion;

ind:=pos('14:handshake_typei',source.inBuffer);
if ind>0 then begin
 strHandType:=copy(source.inBuffer,ind+18,2);
 Delete(strHandType,pos('e',strHandType),length(strHandType));
 source.AzHandshakeType:=strtointdef(strHandType,0);
end;

ind:=pos('8:tcp_porti',source.inBuffer);
if ind>0 then begin
 StrTCPPort:=copy(source.inBuffer,ind+11,6);
 Delete(StrTCPPort,pos('e',strTCPPort),length(StrTCPPort));
 source.port:=strtointdef(StrTCPPort,source.port);
end;

ind:=pos('8:udp_porti',source.inBuffer);
if ind>0 then begin
 StrUDPPort:=copy(source.inBuffer,ind+11,6);
 Delete(StrUDPPort,pos('e',strUDPPort),length(StrUDPPort));
 source.AzUDPport:=strtointdef(StrUDPPort,0);
end;

end;

procedure HandleAzPEX(transfer:TBittorrentTransfer; source:TBittorrentSource);
var
ipC:cardinal;
port:word;
begin
if transfer.isPrivate then exit;
// 25-30 hosts
// CHRNULL+CHRNULL+CHRNULL+chr(16)+AZ_PEER_EXCHANGE+chr(1)
 delete(source.inBuffer,1,21);

if copy(source.inBuffer,1,9)<>'d5:addedl' then begin //could be also 'd7:droppedl +6:xxxxxx +e'
 exit;
end;

delete(source.inBuffer,1,9);



if transfer.fsources.count>=BITTORRENT_MAX_ALLOWED_SOURCES then exit;


while (pos('6:',source.inBuffer)=1) do begin



  ipC:=chars_2_dword(copy(source.inBuffer,3,4));

  port:=chars_2_wordRev(copy(source.inBuffer,7,2));

   transfer.addSource(ipC,
                      port,
                      '',
                      false);
  delete(source.inBuffer,1,8);

  if transfer.fsources.count>=BITTORRENT_MAX_ALLOWED_SOURCES then break;
end;

end;

procedure tthread_bitTorrent.SourceParsePacket(transfer:TBittorrentTransfer;source:TBittorrentSource);
var
cmdId:byte;
ind,cmdIdlen:integer;
prefix,azcommandStr,CmdIdStr:string;
begin
try
if transfer.fstate=dlPaused then begin
 source.status:=btSourceShouldDisconnect;
 exit;
end;



 if source.SupportsAZmessaging then begin
   cmdIdlen:=chars_2_dwordRev(copy(source.inBuffer,1,4));
   CmdIdStr:=copy(source.inBuffer,5,cmdIdlen);

   prefix:=copy(CmdIdStr,1,3);
   azcommandStr:=copy(CmdIdStr,4,length(CmdIdStr));

   if prefix='AZ_' then begin
     if azCommandStr='HANDSHAKE' then HandleAzHandshake(transfer,source)
      else
       if azCommandStr='PEER_EXCHANGE' then HandleAzPEX(transfer,source)
        else
         log('AZ unknown command:'+azCommandStr+' source:'+source.ips+' '+source.client);
     exit;
   end else
   if prefix='BT_' then begin
     cmdId:=AzAdvancedCommand_to_BittorrentCommand(AzCommandStr);


     if CmdId=CMD_BITTORRENT_UNKNOWN then begin
      log('AZ SOURCE: '+source.ipS+'('+source.client+') sends UNKNOWN PACKET:'+source.inbuffer);
      exit;
     end else
     if CmdId=CMD_BITTORRENT_KEEPALIVE then begin
      source.lastKeepAliveIn:=tick;
      exit;
     end;


     delete(source.inbuffer,1,5+cmdIdLen);
   end else begin
    log('Unknown packet from AZ enabled source:'+source.ipS+'('+source.client+') packet:'+bytestr_to_hexstr(source.inBuffer));
    source.status:=btSourceShouldDisconnect;
    exit;
   end;

 end else begin  // regular client
  cmdId:=ord(source.inBuffer[1]);
  delete(source.inBuffer,1,1);
 end;
 

case cmdId of
 CMD_BITTORRENT_CHOKE:begin
                       source.weAreChoked:=true;
                       if transfer.isCompleted then exit;

                       RemoveOutGoingRequests(transfer,source);//remove all pending 'inUse' requests
                       if not source.isSeeder then
                        if source.SlotType<>ST_OPTIMISTIC then
                         if source.speed_recv>0 then begin
                          source.snubbed:=true;
                            if not source.isChoked then begin
                             source.isChoked:=true;
                             ind:=transfer.UploadSlots.indexof(source);
                             if ind<>-1 then transfer.UploadSlots.delete(ind);
                             source_AddOutPacket(source,'',CMD_BITTORRENT_CHOKE);
                            end;
                          end;
                      end;
 CMD_BITTORRENT_UNCHOKE:begin
                        source.weAreChoked:=false;
                        if source.weAreInterested then
                         begin
                           while (source.outRequests<GetoptimumNumOutRequests(source.speed_recv)) do
                                  if not AskChunk(Transfer,source,tick) then break;
                         end;
                        end;
 CMD_BITTORRENT_INTERESTED:begin
                           source.isInterested:=true;
                          // if not source.ischocked then ChokeWorstDownload(transfer,source); // a good uploader is now interested, let's choke our worst downloader(worst downloading uploader)
                           end;
 CMD_BITTORRENT_NOTINTERESTED:begin
                             source.isInterested:=false;
                             if not source.isSeeder then
                              if not source.isChoked then begin
                               source.isChoked:=true;
                               ind:=transfer.uploadSlots.indexof(source);
                               if ind<>-1 then transfer.uploadSlots.delete(ind);
                               source_AddOutPacket(source,'',CMD_BITTORRENT_CHOKE);
                              end;
                             end;
 CMD_BITTORRENT_HAVE:UpdateBitField(transfer,source);
 CMD_BITTORRENT_BITFIELD:ResetBitField(transfer,source);
 CMD_BITTORRENT_REQUEST:HandleIncomingRequest(transfer,source);
 CMD_BITTORRENT_PIECE:handleIncomingPiece(transfer,source);
 CMD_BITTORRENT_CANCEL:HandleCancelMessage(transfer,source);
 CMD_BITTORRENT_PORT:;//

 CMD_BITTORRENT_SUGGESTPIECE:Handle_FastPeer_SuggestPiece(transfer,source);
 CMD_BITTORRENT_HAVEALL:Handle_FastPeer_HaveAll(transfer,source);
 CMD_BITTORRENT_HAVENONE:Handle_FastPeer_HaveNone(transfer,source);
 CMD_BITTORRENT_REJECTREQUEST:Handle_FastPeer_RejectRequest(transfer,source);
 CMD_BITTORRENT_EXTENSION:Handle_ExtensionProtocol_Message(transfer,source)
  else //DHT port
   log('SOURCE: '+source.ipS+'('+source.client+') sent us UNKNOWN PACKET ID:'+inttostr(cmdId));
 end;

except
end;
end;

procedure tthread_bittorrent.Handle_ExtensionProtocol_Message(transfer:TBittorrentTransfer; source:TBittorrentSource);
begin

if not source.SupportsExtensions then begin
 source.status:=btSourceShouldDisconnect;
 exit;
end;

end;

procedure tthread_bitTorrent.Handle_FastPeer_SuggestPiece(transfer:TBittorrentTransfer; source:TBittorrentSource);
begin
 // Suggest Piece: <len=0x0005><op=0x0D><index>
if not source.SupportsFastPeer then begin
 source.status:=btSourceShouldDisconnect;
 exit;
end;

end;

procedure tthread_bitTorrent.Handle_FastPeer_HaveAll(transfer:TBittorrentTransfer; source:TBittorrentSource);
var
i:integer;
piece:TBitTorrentChunk;
begin

// Have All: <len=0x0001><op=0x0E>
if not source.SupportsFastPeer then begin
 source.status:=btSourceShouldDisconnect;
 exit;
end;

if source.bitfield=nil then source.bitfield:=tbittorrentBitfield.create(length(transfer.fpieces));
for i:=0 to high(source.bitfield.bits) do source.bitfield.bits[i]:=true;


for i:=0 to high(transfer.Fpieces) do begin
 piece:=transfer.FPieces[i];
 if piece.checked then continue;

      if not source.weAreInterested then begin // we are interested, let remote peer know
        source_AddOutPacket(source,'',CMD_BITTORRENT_INTERESTED);
        source.weAreInterested:=true;
      end;
        break;
end;

 source.progress:=100;
 CalcChunksPopularity(transfer);
 source.changedVisualBitField:=true;

 transfer.CalculateLeechsSeeds;

if transfer.isCompleted then
 if source.isSeeder then source.status:=btSourceShouldRemove;
end;

procedure tthread_bitTorrent.Handle_FastPeer_HaveNone(transfer:TBittorrentTransfer; source:TBittorrentSource);
var
i:integer;
//piece:TBitTorrentChunk;
begin
 // Have None: <len=0x0001><op=0x0F>
if not source.SupportsFastPeer then begin
 source.status:=btSourceShouldDisconnect;
 exit;
end;

if source.bitfield=nil then source.bitfield:=tbittorrentBitfield.create(length(transfer.fpieces));
for i:=0 to high(source.bitfield.bits) do source.bitfield.bits[i]:=false;

 if source.weAreInterested then begin // we are interested, let remote peer know
  source_AddOutPacket(source,'',CMD_BITTORRENT_NOTINTERESTED);
  source.weAreInterested:=false;
 end;

 source.progress:=0;
 CalcChunksPopularity(transfer);
 source.changedVisualBitField:=true;
 transfer.CalculateLeechsSeeds;
end;

procedure tthread_bitTorrent.Handle_FastPeer_RejectRequest(transfer:TBittorrentTransfer; source:TBittorrentSource);
begin
 // Reject Request: <len=0x000D><op=0x10><index><begin><offset>

if not source.SupportsFastPeer then begin
 source.status:=btSourceShouldDisconnect;
 exit;
end;

end;

procedure tthread_bitTorrent.HandleIncomingRequest(transfer:TBittorrentTransfer; source:TBittorrentSource);
var
index,offset,wlen:cardinal;
piece:TBitTorrentChunk;
er:integer;
rem:int64;
buffer:array[0..16383] of char;
str:string;
begin
try

if transfer.fstate=dlPaused then exit;
if length(source.inBuffer)<12 then exit;

index:=chars_2_dwordRev(copy(source.inBuffer,1,4));
offset:=chars_2_dwordRev(copy(source.inBuffer,5,4));
wlen:=chars_2_dwordRev(copy(source.inBuffer,9,4));


if wlen>BITTORRENT_PIECE_LENGTH then begin
 source.status:=btSourceShouldDisconnect;
 exit;
end;

if index>cardinal(high(transfer.fpieces)) then begin
 source.status:=btSourceShouldDisconnect;
 exit;
end;

piece:=transfer.fpieces[index];
if not piece.checked then begin
 exit;
end;

if source.isChoked then begin
 exit;
end;

 CancelOutGoingPiece(transfer,source,index,offset); //cancel previous outgoing requests
 

 transfer.read((int64(index)*int64(transfer.fpiecelength))+int64(offset),
               @buffer,
               wlen,
               rem,
               er);
               
 if rem<>0 then begin
   source.status:=btSourceShouldDisconnect;
   log('couldn''t read from files '+source.ips+' '+source.client+' disconnected');
  exit;
 end;

 SetLength(str,wlen-rem);
 move(buffer,str[1],length(str));

 source_AddOutPacket(source,int_2_dword_stringRev(index)+
                            int_2_dword_stringRev(offset)+
                            str,
                            CMD_BITTORRENT_PIECE,
                            false,
                            index,
                            offset,
                            wlen);



except
end;
end;

procedure RemoveOutGoingRequestForPiece(transfer:TBittorrentTransfer; index:integer);
var
i:integer;
request:precord_BitTorrentoutgoing_request;
begin
i:=0;
while (i<transfer.outgoingRequests.Count) do begin
 request:=transfer.outgoingRequests[i];

 if request^.index<>index then begin
  inc(i);
  continue;
 end;

   Source_AddOutPacket(transfer,
                      request^.source,
                      int_2_dword_stringRev(request^.index)+int_2_dword_stringRev(request^.offset)+int_2_dword_stringRev(request^.wantedLen),
                      CMD_BITTORRENT_CANCEL,
                      true,
                      request^.index,
                      request^.offset,
                      request^.wantedLen);

    transfer.outgoingRequests.delete(i);
    freeMem(request,sizeof(record_BitTorrentoutgoing_request));
end;

end;

procedure CancelOutGoingRequestsForPiece(transfer:TBitTorrentTransfer; Source:TBittorrentSource; index:cardinal; offset:Cardinal);
var
i:integer;
request:precord_BitTorrentoutgoing_request;
tmpSource:TBitTorrentSource;
begin
i:=0;
while (i<transfer.outgoingRequests.Count) do begin
 request:=transfer.outgoingRequests[i];

 if cardinal(request^.index)<>index then begin
  inc(i);
  continue;
 end;

 if request^.offset<>offset then begin
   inc(i);
   continue;
 end;

  // if we sent this to another source send a cancel packet for this piece
  if longint(request^.source)<>longint(source) then begin
   tmpSource:=FindSourceFromID(transfer,request^.source);
    if tmpSource<>nil then begin
      if Source_PeekRequest_InIncomingBuffer(tmpsource,request) then begin

      end else begin
       Source_AddOutPacket(tmpSource,
                           int_2_dword_stringRev(request^.index)+int_2_dword_stringRev(request^.offset)+int_2_dword_stringRev(request^.wantedLen),
                           CMD_BITTORRENT_CANCEL,
                           true,
                           request^.index,
                           request^.offset,
                           request^.wantedLen);
      end;
    end;
  end;
  
    transfer.outgoingRequests.delete(i);
    freeMem(request,sizeof(record_BitTorrentoutgoing_request));
 end;
 
end;

procedure tthread_bitTorrent.handleIncomingPiece(transfer:TBittorrentTransfer; source:TBittorrentSource);
var
index,
offset:cardinal;
LenData:integer;

piece:TBitTorrentChunk;
rem:int64;
er:integer;
begin
try
if transfer.fstate=dlPaused then exit;
if transfer.fstate=dlSeeding then exit;

if length(source.inBuffer)<9 then exit;

if source.weAreChoked then begin //should we care?
 log('WARNING piece arrived from source who choked us '+source.ips+' '+source.client);
 exit;
end;



index:=chars_2_dwordRev(copy(source.inBuffer,1,4));
offset:=chars_2_dwordRev(copy(source.inBuffer,5,4));
if index>cardinal(high(transfer.fpieces)) then exit;

 CancelOutGoingRequestsForPiece(transfer,source,index,offset);


 LenData:=length(source.inBuffer)-8;

 piece:=transfer.fpieces[index];

 if (offset div BITTORRENT_PIECE_LENGTH)>cardinal(high(piece.pieces)) then exit;
 if piece.pieces[offset div BITTORRENT_PIECE_LENGTH] then begin

  exit;
 end;

 if lenData<>BITTORRENT_PIECE_LENGTH then begin
   if piece.findex<>cardinal(high(transfer.fpieces)) then begin
    log('source '+source.ips+' '+source.client+' send invalid piece len:'+inttostr(lenData));
    source.status:=btSourceShouldRemove;
    exit;
   end else log('last piece index:'+inttostr(piece.findex)+'  '+inttostr(piece.foffset)+'  requested len:'+inttostr(lenData));
 end;

  transfer.write((int64(piece.findex)*int64(transfer.fpieceLength))+int64(offset),
                 @source.inbuffer[9],
                 lenData,
                 rem,
                 er);
                
  if rem<>0 then begin
   log('could''t write piece#'+inttostr(piece.findex)+' on disk ');
   exit;
  end;

 piece.pieces[offset div BITTORRENT_PIECE_LENGTH]:=true;
 inc(piece.fprogress,lenData);
 if source.outRequests>=1 then dec(source.outRequests);

 if transfer.tempDownloaded+LenData<=transfer.fsize then inc(transfer.tempDownloaded,lenData);
 inc(loc_downloadedBytes,lenData);


 if piece.fprogress=piece.fsize then begin // time to check SHA1
   if transfer.hashFails>=NUMMAX_TRANSFER_HASHFAILS then begin
    if piece=source.assignedChunk then begin
     source.assignedChunk:=nil;
     piece.assignedSource:=nil;
    end;
   end;

   piece.check;
   if piece.checked then begin
    RemoveOutGoingRequestForPiece(transfer,piece.findex);

    if transfer.hashFails>=NUMMAX_TRANSFER_HASHFAILS then inc(source.blocksReceived);

    transfer.changedVisualBitField:=true;
    BroadcastHave(transfer,piece);
    if transfer.isCompleted then begin
     DisconnectSeeders(transfer);
     SetAllNotinterested(transfer);
     transfer.DoComplete;

    // log('Start Date:'+formatDateTime('yyyy/mm/dd hh:nn:ss',UnixToDelphiDateTime(transfer.start_Date)));
    // log('Transfer time:'+format_time(DelphiDateTimeToUnix(now)-transfer.start_date));
    // log('Average speed:'+inttostr(transfer.fsize div (DelphiDateTimeToUnix(now)-transfer.start_date) ));
    // log('Peak speed:'+inttostr(transfer.peakSpeedDown));

     transfer.tracker.next_poll:=0; //send notification to tracker
     transfer.fstate:=dlSeeding;
      GlobTransfer:=transfer;
      synchronize(CompleteVisualTransfer);
    end;
    if source.weAreInterested then areWeStillInterested(transfer,source);
   end else begin
    dec(transfer.tempDownloaded,piece.fsize);
    inc(transfer.hashFails);
    if transfer.hashFails>NUMMAX_TRANSFER_HASHFAILS then begin
     inc(source.hashFails);
       if source.hashFails>=NUMMAX_SOURCE_HASHFAILS then begin
        source.status:=btSourceShouldRemove;
        btcore.AddBannedIp(transfer,source.ipC);
        log('source:'+source.ips+' '+source.client+' removed got wrong hash!');
       end;
    end;
   end;
 end;

  if source.weAreInterested then begin
   while (source.outRequests<GetoptimumNumOutRequests(source.speed_recv)) do begin
    if not AskChunk(Transfer,source,tick) then break; //ask another piece
   end;
  end;


 except
 end;
end;

procedure DisconnectSeeders(transfer:TBitTorrentTransfer);//download completed we no longer need seeders
var
i:integer;
source:TBitTorrentSource;
begin
for i:=0 to transfer.fsources.count-1 do begin
  source:=transfer.fsources[i];
  if source.progress<100 then continue;
  source.status:=btSourceShouldRemove;
end;
end;

procedure tthread_bittorrent.SetAllNotinterested(transfer:TBitTorrentTransfer);//download completed we no longer need seeders
var
i:integer;
source:TBitTorrentSource;
begin
 for i:=0 to transfer.fsources.count-1 do begin
  source:=transfer.fsources[i];
  if source.status<>btSourceConnected then continue;

   if source.isInterested then begin
     source.isInterested:=false;
     Source_AddOutPacket(source,'',CMD_BITTORRENT_NOTINTERESTED);
   end;

 end;
end;

function DropWorstConnectedInactiveSource(transfer:TBitTorrentTransfer; source:TBitTorrentSource; tick:cardinal):boolean;
var
i:integer;
tmpSource:TBitTorrentSource;
begin
result:=false;

if transfer.isCompleted then transfer.fsources.sort(BitTorrentSortWorstForaSeederInactiveSourceFirst)
 else transfer.fsources.sort(BitTorrentSortWorstForaLeecherInactiveSourceFirst);
 
for i:=0 to transfer.fsources.count-1 do begin
 tmpSource:=transfer.fsources[i];
 if tmpSource=source then continue;
 if tmpSource.status<>btSourceConnected then continue;
 if tick-tmpSource.handShakeTick<5*MINUTE then continue;//minimum threshold

 tmpSource.status:=btSourceShouldDisconnect;
 result:=true;
 break;
end;

end;

procedure BroadcastHave(transfer:TBitTorrentTransfer; piece:TBitTorrentChunk);
var
i:integer;
source:TBittorrentSource;
str:string;
begin

str:=int_2_dword_stringRev(piece.findex);
     
for i:=0 to transfer.fsources.count-1 do begin
 source:=transfer.fsources[i];
 if source.status<>btSourceConnected then continue;

 //if source.bitfield<>nil then
  //if source.bitfield.bits[piece.index] then continue; //already have this piece, don't send my have message?

   source_AddOutPacket(source,str,CMD_BITTORRENT_HAVE);
end;

end;

function ChoseIncompleteChunk(transfer:TBitTorrentTransfer; source:TBitTorrentSource; var SuggestedFreeOffSetIndex:integer):TBittorrentChunk;
var
i:integer;
piece:TBitTorrentChunk;
begin
result:=nil;

 for i:=0 to high(transfer.fpieces) do begin
  piece:=transfer.fpieces[i];
  if piece.checked then continue;
  if not piece.downloadable then continue; //this chunk is related to a file we do not want
  if not source.bitfield.bits[i] then continue;
  if piece.fprogress=0 then continue;


   if transfer.isEndGameMode then begin
     SuggestedFreeOffSetIndex:=FindPieceNotRequestedBySource(transfer,source,piece);
     if SuggestedFreeOffSetIndex=-1 then continue;
   end else begin
     if piece.assignedSource<>nil then continue;
     SuggestedFreeOffSetIndex:=FindPieceNotRequestedByAnySource(transfer,piece);
     if SuggestedFreeOffSetIndex=-1 then continue;
   end;

      result:=piece;
      exit;
 end;
end;

function FindPieceNotRequestedByAnySource(transfer:TBitTorrentTransfer; piece:TBitTorrentchunk):integer;
var
i,h:integer;
cmpOffset:cardinal;
request:precord_BitTorrentoutgoing_request;
found:boolean;
begin
result:=-1;

 for i:=0 to high(piece.pieces) do begin
   if piece.pieces[i] then continue;
   cmpOffset:=i*BITTORRENT_PIECE_LENGTH;

    found:=false;
    for h:=0 to transfer.outGoingRequests.count-1 do begin
     request:=transfer.outGoingRequests[h];
      if cardinal(request^.index)<>piece.findex then continue;
      if request^.offset<>cmpOffset then continue;
      found:=true;
      break;
    end;

    if not found then begin
     result:=i;
     exit;
    end;

 end;
end;

function FindPieceNotRequestedBySource(transfer:TBitTorrentTransfer; source:TBittorrentSource; piece:TBitTorrentchunk):integer;
var
i,h:integer;
cmpOffset:cardinal;
request:precord_BitTorrentoutgoing_request;
found:boolean;
begin
result:=-1;

 for i:=0 to high(piece.pieces) do begin
   if piece.pieces[i] then continue;
   cmpOffset:=i*BITTORRENT_PIECE_LENGTH;

    found:=false;
    for h:=0 to transfer.outGoingRequests.count-1 do begin
     request:=transfer.outGoingRequests[h];
      if longint(request^.source)<>longint(source) then continue;
      if request^.index<>piece.findex then continue;
      if request^.offset<>cmpOffset then continue;
      found:=true;
      break;
    end;

    if not found then begin
     result:=i;
     exit;
    end;

 end;
end;

procedure ExpireOutGoingRequests(list:Tmylist; tick:cardinal);
var
i:integer;
tran:TBitTorrentTransfer;
begin
 for i:=0 to list.count-1 do begin
  tran:=list[i];
  ExpireOutGoingRequests(tran,tick);
  if (i mod 3)=0 then sleep(1);
 end;
end;

function Source_PeekRequest_InIncomingBuffer(source:TBitTorrentSource; request:precord_BitTorrentoutgoing_request):boolean;
var
pieceIndex,
pieceOffset:cardinal;
begin
result:=false;

if source.SupportsAZmessaging then begin

 if length(source.InBuffer)<21 then exit; //not enough data
 if copy(source.InBuffer,1,13)<>AZ_BT_PIECE_HEADER then exit; //incoming packet is not a piece packet

 pieceIndex:=chars_2_dwordRev(copy(source.inBuffer,14,4));
 pieceOffset:=chars_2_dwordRev(copy(source.inBuffer,18,4));

end else begin

 if length(source.InBuffer)<9 then exit; //not enough data
 if source.InBuffer[1]<>chr(CMD_BITTORRENT_PIECE) then exit; //incoming packet is not a piece packet

 pieceIndex:=chars_2_dwordRev(copy(source.inBuffer,2,4));
 pieceOffset:=chars_2_dwordRev(copy(source.inBuffer,6,4));
 
end;

if pieceIndex<>cardinal(request^.index) then exit;
if pieceOffset<>request^.offset then exit;

result:=true;
end;

procedure ExpireOutGoingRequests(Transfer:TBitTorrentTransfer; tick:cardinal);
var
i:integer;
request:precord_BitTorrentoutgoing_request;
source:TBitTorrentSource;
piece:TBitTorrentChunk;
begin
try

if transfer.fstate=dlPaused then exit;

i:=0;
while (i<transfer.outgoingRequests.count) do begin
 request:=transfer.outGoingRequests[i];

 if tick-request^.requestedTick<EXPIRE_OUTREQUEST_INTERVAL then begin
  inc(i);
  continue;
 end;



   source:=FindSourceFromID(transfer,request^.source);
   if source=nil then begin
    transfer.outGoingRequests.delete(i);
    FreeMem(request,sizeof(record_BitTorrentoutgoing_request));
    continue;
   end;

   if request^.requested>=5 then begin
    if source.outRequests>=1 then dec(source.outRequests);
    transfer.outGoingRequests.delete(i);
    FreeMem(request,sizeof(record_BitTorrentoutgoing_request));
    continue;
   end;
   
   if Source_PeekRequest_InIncomingBuffer(source,request) then begin  // this piece is arriving, do not ask again, simply leave the request untouched
    inc(i);
    continue;
   end;

   if source.weAreChoked then begin
    if source.outRequests>=1 then dec(source.outRequests);
    transfer.outGoingRequests.delete(i);
    FreeMem(request,sizeof(record_BitTorrentoutgoing_request));
    continue;
   end;

   if not source.weAreInterested then begin
    if source.outRequests>=1 then dec(source.outRequests);
    transfer.outGoingRequests.delete(i);
    FreeMem(request,sizeof(record_BitTorrentoutgoing_request));
    continue;
   end;

   piece:=transfer.fpieces[request^.index];
   if piece.checked then begin
    if source.outRequests>=1 then dec(source.outRequests);
    transfer.outGoingRequests.delete(i);
    FreeMem(request,sizeof(record_BitTorrentoutgoing_request));
    continue;
   end;

   request^.requestedTick:=tick;
   inc(request^.requested);
   Source_AddOutPacket(source,
                       int_2_dword_stringRev(request^.index)+
                       int_2_dword_stringRev(request^.offset)+
                       int_2_dword_stringRev(request^.WantedLen),
                       CMD_BITTORRENT_REQUEST,
                       true,
                       request^.index,
                       request^.offset,
                       request^.WantedLen);

  inc(i);
end;

except
end;
end;

function AskChunk(Transfer:TBitTorrentTransfer; source:TBitTorrentSource; tick:cardinal):boolean;
var
offset,pieceOffsetIndex:integer;
wantedLen:int64;
piece:TBitTorrentChunk;
request:precord_BitTorrentoutgoing_request;
begin
result:=false;

try
if ((source.assignedChunk<>nil) and
    (transfer.hashFails>=NUMMAX_TRANSFER_HASHFAILS) and
    (not transfer.isEndGameMode)) then begin

 piece:=source.assignedChunk;
 pieceOffsetIndex:=FindPieceNotRequestedBySource(transfer,source,piece);
 if pieceOffsetIndex=-1 then exit;

end else begin

  piece:=ChoseIncompleteChunk(transfer,source,pieceOffsetIndex);
  if piece=nil then begin
   piece:=ChosePrioritaryChunk(transfer,source,pieceOffsetIndex);
   if piece=nil then begin
    piece:=ChoseLeastPopularChunk(transfer,source,pieceOffsetIndex);
    if piece=nil then begin

     exit;
    end;
   end;
  end;

end;

offset:=pieceOffsetIndex*BITTORRENT_PIECE_LENGTH;

WantedLen:=BITTORRENT_PIECE_LENGTH;

if piece.findex=cardinal(high(transfer.Fpieces)) then
 if pieceOffsetIndex=high(piece.pieces) then begin
  WantedLen:=transfer.Fsize-int64(int64(piece.findex*transfer.fpieceLength)+offset);
 end;

 Source_AddOutPacket(source,
                     int_2_dword_stringRev(piece.findex)+
                     int_2_dword_stringRev(offset)+
                     int_2_dword_stringRev(WantedLen),
                     CMD_BITTORRENT_REQUEST,
                     true,
                     piece.findex,
                     offset,
                     wantedLen);

inc(source.outRequests);

if ((transfer.hashFails>=NUMMAX_TRANSFER_HASHFAILS) and
    (not transfer.isEndGameMode)) then begin // assign the same chunk to the same source, so that we can isolate malicious clients
 source.assignedChunk:=piece;
 piece.assignedSource:=source;
end;

 request:=AllocMem(sizeof(record_BitTorrentoutgoing_request));
  request^.index:=piece.findex;
  request^.offset:=offset;
  request^.wantedLen:=wantedLen;
  request^.requestedTick:=tick;
  request^.source:=longint(source);
  request^.requested:=1;
   transfer.outGoingRequests.add(request);

result:=true;

except
end;
end;

function FindSourceFromID(transfer:TBittorrentTransfer; ID:cardinal):TBitTorrentSource;
var
i:integer;
source:TBitTorrentSource;
begin
result:=nil;

 for i:=0 to transfer.fsources.count-1 do begin
  source:=transfer.fsources[i];
  if longint(source)<>longint(ID) then continue;
   result:=source;
   break;
 end;

end;

procedure Source_AddOutPacket(transfer:TBitTorrentTransfer; sourceId:cardinal; const packet:string; ID:Byte; haspriority:boolean = false; index:cardinal = 0; offset:cardinal = 0; wantedLen:cardinal = 0);
var
source:TBitTorrentSource;
begin
  source:=FindSourceFromID(transfer,sourceID);
  if source=nil then exit;
  if source.status<>btSourceConnected then exit;
  Source_AddOutPacket(source,packet,ID,haspriority,index,offset,wantedLen);
end;

procedure Source_AddOutPacket(source:TBittorrentSource; const packet:string; ID:Byte; haspriority:boolean = false; index:cardinal = 0; offset:cardinal = 0; wantedLen:cardinal = 0);
var
apacket,cmppacket:TBitTorrentOutPacket;
i,lastAcceptablePos:integer;
begin
aPacket:=TBitTorrentOutPacket.create;
 aPacket.priority:=hasPriority;
 aPacket.isFlushing:=false;
 aPacket.findex:=index;
 aPacket.foffset:=offset;
 aPacket.fwantedLen:=wantedLen;

 if ID=CMD_BITTORRENT_KEEPALIVE then begin
   if source.SupportsAZmessaging then begin
      aPacket.payload:=int_2_dword_stringRev(length(CMD_AZ_BITTORRENT_KEEPALIVE))+
                       CMD_AZ_BITTORRENT_KEEPALIVE+
                       chr(1);
      aPacket.payload:=int_2_dword_stringRev(length(aPacket.payload))+aPacket.payload;
   end
    else aPacket.payload:=int_2_dword_string(0);
 end else begin
    if source.SupportsAZmessaging then begin
        aPacket.payload:=int_2_dword_stringRev(length(AZ_CMD_LOOKUP[ID]))+
                         AZ_CMD_LOOKUP[ID]+
                         chr(1)+
                         packet;
        aPacket.payload:=int_2_dword_stringRev(length(aPacket.payload))+aPacket.payload;
    end
     else aPacket.payload:=int_2_dword_stringRev(length(packet)+1)+
                           chr(ID)+
                           packet;
  end;
  
 aPacket.ID:=ID;

if not hasPriority then begin
 source.outBuffer.add(apacket);
 exit;
end;

if source.outBuffer.count=0 then source.outBuffer.add(apacket)
 else begin
  lastAcceptablePos:=source.outBuffer.count;

  for i:=source.outBuffer.count-1 downto 0 do begin // loop downward till we find a busy packet or another request
   cmpPacket:=source.outBuffer[i];
   if cmpPacket.isFlushing then break;
   if cmpPacket.priority then break;
   lastAcceptablePos:=i;
  end;

  if lastAcceptablePos=source.outBuffer.count then source.outBuffer.add(apacket)
   else source.outbuffer.Insert(lastAcceptablePos,apacket);
 end;
end;


procedure RemoveOutGoingRequests(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
var
i:integer;
request:precord_BitTorrentoutgoing_request;
begin
source.outRequests:=0;

 i:=0;
 while (i<transfer.outgoingRequests.count) do begin
  request:=transfer.outGoingRequests[i];
  if longint(source)=longint(request^.source) then begin
    transfer.outGoingRequests.delete(i);
    FreeMem(request,sizeof(record_BitTorrentoutgoing_request));
    continue;
  end else inc(i);
 end;

end;

procedure RemoveOutGoingRequests(transfer:TBitTorrentTransfer);
var
request:precord_BitTorrentoutgoing_request;
begin

 while (transfer.outgoingRequests.count>0) do begin
  request:=transfer.outGoingRequests[transfer.outgoingRequests.count-1];
            transfer.outGoingRequests.delete(transfer.outgoingRequests.count-1);
    FreeMem(request,sizeof(record_BitTorrentoutgoing_request));
 end;

end;


procedure HandleCancelMessage(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
var
i:integer;
aPacket:TBitTorrentOutPacket;
index,offset,wantedLen:cardinal;
begin
if length(source.inBuffer)<12 then exit;

index:=chars_2_dwordRev(copy(source.inBuffer,1,4));
if index>cardinal(high(transfer.fpieces)) then exit;
offset:=chars_2_dwordRev(copy(source.inBuffer,5,4));
wantedLen:=chars_2_dwordRev(copy(source.inBuffer,9,4));

i:=0;
while (i<source.outbuffer.count) do begin

  aPacket:=source.outbuffer[i];

   if aPacket.isFlushing then begin
    inc(i);
    continue; //we can't remove this...
   end;

  if aPacket.ID<>CMD_BITTORRENT_PIECE then begin
   inc(i);
   continue;
  end;

  if aPacket.findex=index then
   if aPacket.foffset=offset then
    if aPacket.fwantedLen=wantedLen then begin
      source.outbuffer.delete(i);
      aPacket.free;
      continue;
    end;

   inc(i);
end;

end;

procedure CancelOutGoingPiece(transfer:TBitTorrentTransfer; source:TBitTorrentSource; index,offset:cardinal);
var
i:integer;
str:string;
aPacket:TBitTorrentOutPacket;
begin
str:=int_2_dword_stringRev(index)+
     int_2_dword_stringRev(offset);

i:=0;
while (i<source.outbuffer.count) do begin

  aPacket:=source.outbuffer[i];

   if aPacket.isFlushing then begin
    inc(i);
    continue; //we can't remove this...
   end;

  if aPacket.ID<>CMD_BITTORRENT_PIECE then begin
   inc(i);
   continue;
  end;

  if copy(aPacket.payload,6,8)=str then begin
    source.outbuffer.delete(i);
      aPacket.free;
      continue;
   end;

   inc(i);
end;

end;

procedure tthread_bitTorrent.areWeStillInterested(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
var
i:integer;
piece:TBitTorrentChunk;
begin
if transfer.isCompleted then begin
 source.weAreInterested:=false;
 source_AddOutPacket(source,'',CMD_BITTORRENT_NOTINTERESTED);

exit;
end;

for i:=0 to high(transfer.Fpieces) do begin
 piece:=transfer.FPieces[i];
 if piece.checked then continue;
 if source.bitfield.bits[i] then exit; //ok we are still interested
end;

source.weAreInterested:=false;
 source_AddOutPacket(source,'',CMD_BITTORRENT_NOTINTERESTED);

end;

procedure tthread_bitTorrent.ResetBitField(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
var
i:integer;
piece:TBitTorrentChunk;
begin
if source.bitfield=nil then source.bitfield:=tbittorrentBitfield.create(length(transfer.fpieces));
source.bitfield.initWithBitField(source.inBuffer);


for i:=0 to high(transfer.Fpieces) do begin
 piece:=transfer.FPieces[i];
 if piece.checked then continue;
  if not source.bitfield.bits[i] then continue;
    //if not isFullyRequested(transfer,piece) then begin
      if not source.weAreInterested then begin // we are interested, let remote peer know
          source_AddOutPacket(source,'',CMD_BITTORRENT_INTERESTED);
        source.weAreInterested:=true;
      end;
        break;
     //end;
end;

 source.progress:=CalcProgressFromBitField(source);
 CalcChunksPopularity(transfer);
 source.changedVisualBitField:=true;

 transfer.CalculateLeechsSeeds;

{
 if not transfer.isCompleted then
  if source.isLeecher then
   if transfer.numConnected>=BITTORENT_MAXNUMBER_CONNECTION_ESTABLISH then
    if CalcSourceOriginality(transfer,source)=0 then source.status:=btSourceShouldDisconnect;
}


if transfer.isCompleted then
 if source.isSeeder then source.status:=btSourceShouldRemove;
end;

function CalcSourceOriginality(transfer:TBittorrentTransfer; source:TBittorrentSource):integer;
var
i:integer;
piece:TBittorrentChunk;
begin
 result:=0;
 
 for i:=0 to high(source.bitfield.bits) do begin
   if not source.bitfield.bits[i] then continue;
   piece:=transfer.fpieces[i];
    if piece.checked then continue; //computation based on what we need
    if sourceIsTheOnlyOneHavingPiece(transfer,source,i) then begin // this source has a piece that no one else has
     result:=1;
     exit;
    end;
 end;
 
end;

function sourceIsTheOnlyOneHavingPiece(transfer:TBittorrentTransfer; source:TBittorrentSource; index:cardinal):boolean;
var
i:integer;
tmpsource:TBittorrentSource;
begin
 result:=true;

 for i:=0 to transfer.fsources.count-1 do begin
   tmpsource:=transfer.fsources[i];
   if tmpsource=source then continue;
    if tmpsource.status<>btSourceConnected then continue;
     if tmpsource.isSeeder then continue;
      if tmpsource.bitfield=nil then continue;
       if cardinal(high(tmpsource.bitfield.bits))<index then continue; //what?
   if tmpsource.bitfield.bits[index] then begin  //someone else has this piece
    result:=false;
    exit;
   end;
 end;
end;

procedure CalcChunksPopularity(transfer:TBitTorrentTransfer);
var
i,h:integer;
piece:TBitTorrentChunk;
source:TBitTorrentSource;
begin
for i:=0 to high(transfer.FPieces) do begin //reset popularity
 piece:=transfer.FPieces[i];
 if piece.checked then piece.popularity:=1
  else piece.popularity:=0;
end;

for i:=0 to transfer.FSources.count-1 do begin
 source:=transfer.FSources[i];
 if source.isSeeder then continue;
 if source.bitfield=nil then continue;

 for h:=0 to high(transfer.FPieces) do begin
  piece:=transfer.FPieces[h];
  if source.bitfield.bits[h] then inc(piece.popularity);
 end;
end;
end;

function ChosePrioritaryChunk(transfer:TBitTorrentTransfer; source:TBitTorrentSource; var SuggestedFreeOffSetIndex:integer):TBitTorrentChunk;
var
i:integer;
piece:TBitTorrentChunk;
list:TMylist;
begin
result:=nil;

list:=tmylist.create;

for i:=0 to high(transfer.Fpieces) do begin
 piece:=transfer.FPieces[i];
 if piece.checked then continue;
 if not piece.downloadable then continue; //this chunk is related to a file we do not want
 if piece.Priority=0 then continue;
 if not source.bitfield.bits[i] then continue;
 if piece.fprogress>0 then continue; //only brand new pieces
 list.add(piece);
end;

if list.count>1 then list.sort(sortMostPrioritaryFirst);

for i:=0 to list.count-1 do begin
 piece:=list[i];

   if transfer.isEndGameMode then begin
     SuggestedFreeOffSetIndex:=FindPieceNotRequestedBySource(transfer,source,piece);
     if SuggestedFreeOffSetIndex=-1 then continue;
   end else begin
     if piece.assignedSource<>nil then continue;
     SuggestedFreeOffSetIndex:=FindPieceNotRequestedByAnySource(transfer,piece);
     if SuggestedFreeOffSetIndex=-1 then continue;
   end;


  result:=piece;
  list.free;
  exit;
end;



list.free;

end;

function ChoseLeastPopularChunk(transfer:TBitTorrentTransfer; source:TBitTorrentSource; var SuggestedFreeOffSetIndex:integer):TBitTorrentChunk;
var
i,lowestPopularity,oneTenth:integer;
piece:TBitTorrentChunk;
list:TMylist;
begin
result:=nil;

list:=tmylist.create;

// seek a random point in the array
lowestPopularity:=100;
for i:=0 to high(transfer.FPieces) do begin
 piece:=transfer.FPieces[i];

 if piece.checked then continue;
 if not piece.downloadable then continue; //this chunk is related to a file we do not want

  if not transfer.isEndGameMode then
   if piece.assignedSource<>nil then continue;

 if not source.bitfield.bits[i] then continue;
 if piece.fprogress>0 then continue; //only brand new pieces
 list.add(piece);
 if piece.popularity<lowestPopularity then lowestPopularity:=piece.popularity;
end;



if list.count>1 then begin
 // malicious clients seem to fake a lot popularity ratings these days...
 // therefore do not always chose by popularity
  shuffle_mylist(list,0);
  if random(600)>200 then begin
   list.sort(sortLeastPopularFirst);
   oneTenth:=list.count div 10;
   if oneTenth<20 then oneTenth:=20;
   while (list.count>oneTenth) do list.delete(oneTenth);
   shuffle_mylist(list,0);
  end;
end;



for i:=0 to list.count-1 do begin
 piece:=list[i];

   if transfer.isEndGameMode then begin
     SuggestedFreeOffSetIndex:=FindPieceNotRequestedBySource(transfer,source,piece);
     if SuggestedFreeOffSetIndex=-1 then continue;
   end else begin
     SuggestedFreeOffSetIndex:=FindPieceNotRequestedByAnySource(transfer,piece);
     if SuggestedFreeOffSetIndex=-1 then continue;
   end;


  result:=piece;
  list.free;
  exit;
end;



list.free;
end;


procedure IncChunkPopularity(transfer:TBitTorrentTransfer; source:TBitTorrentSource; index:integer);
var
piece:TBitTorrentChunk;
begin
if source.bitfield=nil then source.bitfield:=TBitTorrentBitField.create(length(transfer.FPieces));
if source.bitfield.bits[index] then exit;
piece:=transfer.fpieces[index];
inc(piece.popularity);
end;


procedure tthread_bitTorrent.updateBitField(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
var
indeX:cardinal;
piece:TBitTorrentChunk;
begin
if length(source.inBuffer)<4 then exit;

index:=chars_2_dwordRev(copy(source.inBuffer,1,4));
if index>=cardinal(length(transfer.fpieces)) then begin
 exit;
end;
if source.bitfield=nil then source.bitfield:=tbittorrentBitfield.create(length(transfer.fpieces));

source.bitfield.bits[index]:=true;
source.changedVisualBitField:=true; //update visual bitfield in checkSourceVisual

source.progress:=CalcProgressFromBitField(source);
IncChunkPopularity(transfer,source,index);
transfer.CalculateLeechsSeeds;

{
if not transfer.isCompleted then
 if source.progress>2 then
  if source.isLeecher then
   if transfer.numConnected>=BITTORENT_MAXNUMBER_CONNECTION_ESTABLISH then
    if CalcSourceOriginality(transfer,source)=0 then source.status:=btSourceShouldDisconnect;
}
   
 if transfer.isCompleted then
  if source.isSeeder then begin  //it's a seeder now and we are too, so get rid of it
   source.status:=btSourceShouldRemove;
   exit;
  end;


piece:=transfer.FPieces[index];
if not piece.checked then begin// we are interested, let remote peer know
  if not source.weAreInterested then begin
              source_AddOutPacket(source,'',CMD_BITTORRENT_INTERESTED);

  source.weAreInterested:=true;
  end;
end;

end;

procedure tthread_bitTorrent.SourceFlush(transfer:TBitTorrentTransfer; source:TBittorrentSource);
var
tosend,er,len_sent:integer;
aPacket:TBitTorrentOutPacket;
begin
try
if source.outbuffer.count>40 then begin
  // log('Source '+source.ips+' '+source.client+' disconnected (outbuffer overflow)');
   calcSourceUptime(source);
   //logSourceDisconnect(source,tick);
   SourceDisconnect(source);
 exit;
end;



while (source.outbuffer.count>0) do begin

  aPacket:=source.outbuffer[0];
  toSend:=length(aPacket.payload);

 if not transfer.isCompleted then
  if aPacket.ID=CMD_BITTORRENT_PIECE then
   if not source.isChoked then
    if source.SlotType<>ST_OPTIMISTIC then begin
      if source.NumBytesToSendPerSecond<=0 then exit;
      if source.NumBytesToSendPerSecond-tosend<0 then tosend:=source.NumBytesToSendPerSecond;
    end;

   if tosend>1024 then tosend:=1024;

  len_sent:=TCPSocket_SendBuffer(source.socket.socket,
                                 pchar(aPacket.payload),
                                 tosend,
                                 er);
                                 
  if er=WSAEWOULDBLOCK then exit;
  if er<>0 then begin
   calcSourceUptime(source);
   //logSourceDisconnect(source,tick);
   SourceDisconnect(source);
   exit;
  end;
  if len_sent=0 then begin
   //log('sending 0 bytes '+source.ips+' '+source.client);
   exit;
  end;



  aPacket.isFlushing:=true;

  if aPacket.ID=CMD_BITTORRENT_PIECE then begin
    if not transfer.isCompleted then
     if not source.isChoked then
      if source.SlotType<>ST_OPTIMISTIC then dec(source.NumBytesToSendPerSecond,len_sent);
   inc(source.sent,len_sent);
   inc(transfer.fuploaded,len_sent);
   inc(Transfer.TempUploaded,len_sent);
   source.lastDataOut:=tick;
  end;

  aPacket.isFlushing:=true;
  delete(aPacket.payload,1,len_sent);


  if length(aPacket.payload)=0 then begin
   source.outbuffer.delete(0);
   aPacket.free;
  end;

  if terminated then exit;
end;

except
end;
end;

function tthread_bitTorrent.GetNumConnecting(transfer:TBitTorrentTransfer):integer;
var
i:integer;
source:TBitTorrentSource;
begin
result:=0;
for i:=0 to transfer.fsources.count-1 do begin
 source:=transfer.fsources[i];
 if source.status=btSourceConnecting then inc(result);
enD;
end;

procedure updateVisualGlobSource; //synch
var
MustSort:boolean;
begin
if globsource.dataDisplay=nil then exit;

globsource.dataDisplay^.ID:=globsource.ID;
MustSort:=(globSource.status<>globSource.datadisplay^.status);
globsource.datadisplay^.status:=globsource.status;

 if GlobSource.bitfield<>nil then
  btcore.CloneBitfield(Globsource.bitfield,globsource.datadisplay^.VisualBitField,globsource.datadisplay^.progress);

  globsource.datadisplay^.choked:=Globsource.isChoked;
  globsource.datadisplay^.interested:=Globsource.isinterested;
  globsource.datadisplay^.weAreChoked:=Globsource.weArechoked;
  globSource.datadisplay^.weAreInterested:=GlobSource.weAreInterested;

  globSource.datadisplay^.client:=GlobSource.client;
  globSource.datadisplay^.recv:=GlobSource.recv;
  globSource.datadisplay^.sent:=GlobSource.sent;

if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then begin
 if GlobTransfer.uploadtreeview then begin
   ares_frmmain.treeview_upload.InvalidateNode(globsource.nodeDisplay);
   if MustSort then ares_frmmain.treeview_upload.Sort(Globtransfer.visualNode,3,sdDescending);
 end else begin
   ares_frmmain.treeview_download.InvalidateNode(globsource.nodeDisplay);
   if MustSort then ares_frmmain.treeview_download.Sort(Globtransfer.visualNode,3,sdDescending);
 end;
end;

end;

procedure tthread_bittorrent.updateVisualGlobSource; //synch
var
MustSort:boolean;
begin
if globsource.dataDisplay=nil then exit;

globsource.dataDisplay^.ID:=globsource.ID;
MustSort:=(globSource.status<>globSource.datadisplay^.status);
globsource.datadisplay^.status:=globsource.status;

 if GlobSource.bitfield<>nil then
  btcore.CloneBitfield(Globsource.bitfield,globsource.datadisplay^.VisualBitField,globsource.datadisplay^.progress);

  globsource.datadisplay^.choked:=Globsource.isChoked;
  globsource.datadisplay^.interested:=Globsource.isinterested;
  globsource.datadisplay^.weAreChoked:=Globsource.weArechoked;
  globSource.datadisplay^.weAreInterested:=GlobSource.weAreInterested;

  globSource.datadisplay^.client:=GlobSource.client;
  globSource.datadisplay^.recv:=GlobSource.recv;
  globSource.datadisplay^.sent:=GlobSource.sent;

if ares_frmmain.tabs_pageview.activepage=IDTAB_TRANSFER then begin
 if GlobTransfer.uploadtreeview then begin
   ares_frmmain.treeview_upload.InvalidateNode(globsource.nodeDisplay);
   if MustSort then ares_frmmain.treeview_upload.Sort(Globtransfer.visualNode,3,sdDescending);
 end else begin
   ares_frmmain.treeview_download.InvalidateNode(globsource.nodeDisplay);
   if MustSort then ares_frmmain.treeview_download.Sort(Globtransfer.visualNode,3,sdDescending);
 end;
end;

end;

procedure tthread_bitTorrent.deleteVisualGlobSource; //synch
begin
if globsource.nodedisplay=nil then exit;

 if globsource.nodedisplay=previous_hint_node then formhint_hide;

  if GlobTransfer.uploadtreeview then ares_frmmain.treeview_upload.DeleteNode(globsource.nodeDisplay,true)
   else ares_frmmain.treeview_download.DeleteNode(globsource.nodeDisplay,true);
end;

procedure tthread_bittorrent.disconnectSource(transfer:TBittorrentTransfer; source:TBittorrentSource; RemoveRequests:boolean=true);
var
piece:TBitTorrentChunk;
ind:integer;
begin
 ind:=transfer.uploadSlots.indexof(source);
 if ind<>-1 then transfer.uploadSlots.delete(ind);

 if source.port=0 then begin
  source.status:=btSourceShouldRemove; // we wont be able to connect cause we don't know his port
  exit;
 end;

      source.NumOptimisticUnchokes:=0;
      source.socket.free;
      source.socket:=nil;
      source.bytes_in_header:=0;
      source.ClearOutBuffer;
      source.inbuffer:='';
      source.status:=btSourceIdle;
      
      if source.assignedChunk<>nil then begin
       piece:=source.assignedChunk;
       piece.assignedSource:=nil;
       source.assignedChunk:=nil;
      end;

      source.lastAttempt:=tick; // do not connect before a given interval

      GlobTransfer:=transfer;
      globSource:=source;
      synchronize(updateVisualGlobsource);

      if RemoveRequests then begin
       RemoveOutGoingRequests(transfer,source);
       CalcNumConnected(transfer);
       transfer.CalculateLeechsSeeds;
      end;
end;

procedure TThread_bittorrent.RemoveSource(transfer:TBittorrentTransfer; source:TBittorrentSource);
var
piece:TBitTorrentChunk;
ind:integer;
begin
ind:=transfer.uploadSlots.indexof(source);
if ind<>-1 then transfer.uploadSlots.delete(ind);

RemoveOutGoingRequests(transfer,source);

 if source.assignedChunk<>nil then begin
  piece:=source.assignedChunk;
  piece.assignedSource:=nil;
  source.assignedChunk:=nil;
 end;

 globSource:=source;
 GlobTransfer:=transfer;
 synchronize(deleteVisualGlobSource);

 if source.bitfield<>nil then CalcChunksPopularity(transfer); // must perform before source freeing
 source.free;

 CalcNumConnected(transfer);
 transfer.CalculateLeechsSeeds;
end;

procedure tthread_bitTorrent.transferDeal(transfer:TBittorrentTransfer);
var
i,er,len,hi:integer;
source,tmpSource:tbittorrentSource;
str:string;
buffer:array[0..67] of char;

begin
try

i:=0;
while (i<transfer.fsources.count) do begin
 if terminated then break;
 
 source:=transfer.fsources[i];

 case source.status of

    btSourceShouldDisconnect:begin
      DisconnectSource(transfer,source);
      inc(i);
      continue;
    end;

    btSourceShouldRemove:begin
      transfer.fsources.delete(i);
      RemoveSource(transfer,source);
     continue;
    end;
    
    btSourceConnected:begin
      while transferDeal(transfer,source) do ;
      inc(i);
      continue;
    end;

    btSourceIdle:begin
      if transfer.fstate=dlPaused then begin
       inc(i);
       continue;
      end;
      if transfer.numConnected>=BITTORENT_MAXNUMBER_CONNECTION_ESTABLISH then begin //no need to connect to more sources
       inc(i);
       continue;
      end;
      if GetNumConnecting(transfer)>=MAX_OUTGOING_ATTEMPTS then begin
       inc(i);
       continue;
      end;
      if tick-source.lastAttempt<BTSOURCE_CONN_ATTEMPT_INTERVAL then begin
       inc(i);
       continue;
      end;
      if transfer.fErrorCode<>0 then begin
       exit;
      end;
       
      if transfer.isCompleted then
       if source.isSeeder then begin  //this source is a seeder, connect to leechers only, now that data has been downloaded...
        inc(i);
        continue;
       end;
      source.lastAttempt:=tick;
      if source.socket<>nil then source.socket.free;
      source.ClearOutBuffer;
      source.inbuffer:='';
      source.socket:=TTCPBlockSocket.create(true);
      source.socket.block(false);
      helper_sockets.assign_proxy_settings(source.socket);
      source.tick:=tick;
      source.status:=btSourceConnecting;
      source.IsIncomingConnection:=false;
      source.socket.connect(source.ipS,inttostr(source.port));
      GlobTransfer:=transfer;
      globSource:=source;
      synchronize(updateVisualGlobsource);
    end;


    btSourceConnecting:begin
      if tick-source.tick>TIMEOUTTCPCONNECTION then begin
        SourceAddFailedAttempt(transfer,source);
        inc(i);
        continue;
      end;
      er:=TCPSocket_ISConnected(source.socket);
      if er=WSAEWOULDBLOCK then begin
       inc(i);
       continue;
      end;
      if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
        SourceAddFailedAttempt(transfer,source);
        inc(i);
        continue;
      end;

      str:=STR_BITTORRENT_PROTOCOL_HANDSHAKE+
           STR_BITTORRENT_PROTOCOL_EXTENSIONS+
           transfer.fhashvalue+
           thread_bittorrent.mypeerID;

      TCPSocket_SendBuffer(source.socket.socket,pchar(str),length(str),er);
      if er=WSAEWOULDBLOCK then begin
       inc(i);
       continue;
      end;
      if er<>0 then begin
       SourceAddFailedAttempt(transfer,source);
       inc(i);
       continue;
      end;

      source.status:=btSourceReceivingHandshake;
      source.tick:=tick;
      GlobTransfer:=transfer;
      globSource:=source;
      synchronize(updateVisualGlobsource);
    end;

    btSourceReceivingHandshake:begin
      if tick-source.tick>TIMEOUTTCPRECEIVE then begin
       SourceAddFailedAttempt(transfer,source);
       inc(i);
       continue;
      end;
      if not TCPSocket_CanRead(source.socket.socket,0,er) then begin
        if ((er<>0) and (er<>WSAEWOULDBLOCK)) then SourceAddFailedAttempt(transfer,source);
        inc(i);
        continue;
      end;

      len:=TCPSocket_RecvBuffer(source.socket.socket,@buffer,68,er);
      if er=WSAEWOULDBLOCK then begin
       inc(i);
       continue;
      end;
      if er<>0 then begin
        SourceAddFailedAttempt(transfer,source);
        inc(i);
        continue;
      end;

      SetLength(str,len);
      move(buffer,str[1],len);

      if copy(str,1,20)<>STR_BITTORRENT_PROTOCOL_HANDSHAKE then begin
        SourceAddFailedAttempt(transfer,source);
        inc(i);
        continue;
      end;
      if copy(str,29,20)<>transfer.fhashvalue then begin
       source.status:=btSourceShouldRemove;
       inc(i);
       continue;
      end;
      if length(source.id)=20 then begin
       if copy(str,49,20)<>source.id then begin

       end;
      end else begin
       source.id:=copy(str,49,20);

      end;

       ParseHandshakeReservedBytes(source,copy(str,21,8));

       source.tick:=tick;
       SourceSetConnected(source);

       inc(transfer.numConnected);
       //if GetShouldSendBitfield(transfer) then
       SendBitField(transfer,source);
       if source.SupportsAZmessaging then SendAzHandshake(transfer,source);

       globSource:=source;
       globTransfer:=transfer;
       synchronize(updateVisualGlobsource);
    end;



    btSourceweMustSendHandshake:begin //accepted source we received her handshake, now we send our
       if tick-source.tick>TIMEOUTTCPRECEIVE then begin
        source.status:=btSourceShouldRemove;
        inc(i);
        continue;
       end;
       if not TCPSocket_CanWrite(source.socket.socket,0,er) then begin
         if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
           source.status:=btSourceShouldRemove;
         end;
         inc(i);
         continue;
       end;
       str:=STR_BITTORRENT_PROTOCOL_HANDSHAKE+
            STR_BITTORRENT_PROTOCOL_EXTENSIONS+
            transfer.fhashvalue+
            thread_bittorrent.mypeerID;
       TCPSocket_SendBuffer(source.socket.socket,pchar(str),length(str),er);
       if er=WSAEWOULDBLOCK then begin
        inc(i);
        continue;
       end;
       if er<>0 then begin
        source.status:=btSourceShouldRemove;
        inc(i);
        continue;
       end;

       for hi:=0 to transfer.fsources.count-1 do begin
        tmpsource:=transfer.fsources[hi];
        if tmpsource=source then continue;
         if tmpsource.ipC<>source.ipC then continue;
           if tmpsource.status<>btSourceConnected then tmpsource.status:=btSourceShouldRemove
            else source.status:=btSourceShouldRemove;
         exit;
       end;


       source.tick:=tick;
       SourceSetConnected(source);

       inc(transfer.numConnected);

       GlobTransfer:=transfer;
       globSource:=source;
       synchronize(updateVisualGlobsource);

       if transfer.fsources.count>BITTORRENT_MAX_ALLOWED_SOURCES then begin
        if not DropWorstConnectedInactiveSource(transfer,source,tick) then begin
         source.status:=btSourceShouldRemove;
         inc(i);
         continue;
        end;
       end;

       if transfer.numConnected>BITTORENT_MAXNUMBER_CONNECTION_ACCEPTED then begin //limit accepted connections
         if not DropWorstConnectedInactiveSource(transfer,source,tick) then begin
          source.status:=btSourceShouldRemove;
          inc(i);
          continue;
         end;
       end;

       //if GetShouldSendBitfield(transfer) then
       if source.SupportsAZmessaging then SendAzHandshake(transfer,source);
        SendBitField(transfer,source);
    end;

 end; // endof case switch

inc(i);
end;

except
end;
end;

procedure SendAzHandshake(transfer:TBitTorrentTransfer;source:TBitTorrentSource);
var
str:string;
begin
str:=
'd6:client'+
  inttostr(length(const_ares.appname))+':'+const_ares.appname+   //'7:Azureus'
  '14:handshake_typei0e'+
  '8:identity'+'20:'+myAzidentity+
  '8:messages'+
     'l'+
       'd2:id16:AZ_PEER_EXCHANGE3:ver1:'+chr(1)+'e'+
        'd2:id11:BT_BITFIELD3:ver1:'+chr(1)+'e'+
        'd2:id9:BT_CANCEL3:ver1:'+chr(1)+'e'+
        'd2:id8:BT_CHOKE3:ver1:'+chr(1)+'e'+
        'd2:id12:BT_HANDSHAKE3:ver1:'+chr(1)+'e'+
        'd2:id7:BT_HAVE3:ver1:'+chr(1)+'e'+
        'd2:id13:BT_INTERESTED3:ver1:'+chr(1)+'e'+
        'd2:id13:BT_KEEP_ALIVE3:ver1:'+chr(1)+'e'+
        'd2:id8:BT_PIECE3:ver1:'+chr(1)+'e'+
        'd2:id10:BT_REQUEST3:ver1:'+chr(1)+'e'+
        'd2:id10:BT_UNCHOKE3:ver1:'+chr(1)+'e'+
        'd2:id15:BT_UNINTERESTED3:ver1:'+chr(1)+'e'+
        'd2:id5:AZVER3:ver1:'+chr(1)+'e'+
     'e'+
   '8:tcp_port'+'i'+inttostr(vars_global.myport)+'e'+
   '9:udp2_port'+'i0e'+
   '8:udp_port'+'i0e'+
   '7:version'+inttostr(length(vars_global.versioneares))+':'+vars_global.versioneares+
'e';

Source_AddOutPacket(source,str,CMD_AZLOOKUP_HANDSHAKE,true);
end;

procedure SendAzPEX(transfer:TBitTorrentTransfer; source:TBitTorrentSource; tick:cardinal);
var
strAdded,strHST,strUDP,payload:string;
i,NumAdded:integer;
src:TBitTorrentSource;
begin
// 25-30(10) hosts every 60 seconds  ip + port(rev order)

if transfer.fsources.count>1 then shuffle_mylist(transfer.fsources,0);

payload:='';
strAdded:='';
strHST:='';
strUDP:='';

Numadded:=0;
for i:=0 to transfer.fsources.count-1 do begin
 src:=transfer.fsources[i];

 if src=source then continue;
 if src.ipC=source.ipC then continue;
  if src.IsIncomingConnection then continue;
   //if not src.supportsAzMessaging then continue;

 if transfer.isCompleted then begin
    if src.sent=0 then continue;
    if tick-src.lastDataOut>5*MINUTE then continue;
 end else begin
    if src.status<>btSourceConnected then continue;
    if src.recv=0 then continue;
 end;

 strAdded:=strAdded+
           '6:'+
           int_2_dword_string(src.ipC)+
           int_2_word_stringRev(src.port);
 strHST:=strHST+chr(src.AzHandshakeType);
 strUDP:=strUDP+int_2_word_stringRev(src.AZUDPPort);

 inc(numAdded);
 if numAdded>=10 then break;
end;

if numAdded=0 then begin
 if tick-source.lastDataOut>MINUTE then source_AddOutPacket(source,'',CMD_BITTORRENT_KEEPALIVE);
 exit;
end;

strHST:='9:added_HST'+inttostr(numAdded)+':'+strHST;
strUDP:='9:added_UDP'+inttostr(numAdded*2)+':'+strUDP;

payload:='d'+
            '5:addedl'+StrAdded+'e'+
            strHst+
            strUDP+
            '8:infohash20:'+transfer.fHashValue+
         'e';

Source_AddOutPacket(source,payload,CMD_AZLOOKUP_PEX);
end;



Procedure SourceSetConnected(source:TBitTorrentSource);
begin
with source do begin
 Client:=BTIDtoClientName(ID);
 status:=btSourceConnected;
 lastKeepAliveIn:=tick;
 lastKeepAliveOut:=tick;
 isChoked:=true;
 isInterested:=false;
 weArechoked:=true;
 weAreInterested:=false;
 bytes_in_header:=0;
 recv:=0;
 sent:=0;
 bytes_recv_before:=0;
 bytes_sent_before:=0;
 speed_recv:=0;
 speed_send:=0;
 speed_recv_max:=0;
 speed_send_max:=0;
 handshakeTick:=tick;
 lastDataIn:=0;
 lastDataOut:=0;
 snubbed:=false;
 failedConnectionAttempts:=0;
end;

end;

procedure ParseHandshakeReservedBytes(source:TBittorrentSource; const extStr:string);
begin
 with source do begin
  SupportsAZmessaging:=((ord(extStr[1]) and $80) <> 0);
  SupportsExtensions:=((ord(extStr[6]) and $10) <> 0);
  SupportsFastPeer:=((ord(extStr[1]) and $20) <> 0);
 end;
end;

procedure CalcNumConnected(transfer:TBitTorrentTransfer);
var
i:integer;
source:TBitTorrentSource;
begin
transfer.numConnected:=0;
for i:=0 to transfer.fsources.count-1 do begin
 source:=transfer.fsources[i];
 if source.status=btSourceConnected then inc(transfer.numConnected);
end;
end;

function GetoptimumNumOutRequests(speedRecv:cardinal):integer;
begin
if speedRecv<KBYTE then result:=1
   else
    if speedRecv<5*KBYTE then result:=2
     else
      if speedRecv<10*KBYTE then result:=3
       else
        if speedRecv<20*KBYTE then result:=4
         else
          result:=5;
end;

procedure SendBitField(transfer:TBitTorrentTransfer; source:TBitTorrentSource);
var
str:string;
begin
    {
    if source.SupportsFastPeer then begin
         if transfer.isCompleted then begin
          Source_AddOutPacket(source,'',CMD_BITTORRENT_HAVEALL);
          exit;
         end else
           if transfer.fdownloaded=0 then begin
            Source_AddOutPacket(source,'',CMD_BITTORRENT_HAVENONE);
            exit;
           end;
     end;
     }

  str:=transfer.serialize_bitfield;
  source_AddOutPacket(source,str,CMD_BITTORRENT_BITFIELD,true);
end;

procedure tthread_bitTorrent.SourceAddFailedAttempt(transfer:TBitTorrentTransfer; source:TBittorrentSource);
begin
 source.socket.free;
 source.socket:=nil;
 source.status:=btSourceIdle;
 source.inBuffer:='';
 source.bytes_in_header:=0;
 source.ClearOutBuffer;
 inc(source.failedConnectionAttempts);
 if source.failedConnectionAttempts>=BT_MAXSOURCE_FAILED_ATTEMPTS then source.status:=btSourceShouldRemove;
 GlobTransfer:=transfer;
 globSource:=source;
 synchronize(updateVisualGlobsource);
end;


////  **************   TRACKER   ************************************************

procedure tthread_bittorrent.checkTracker;
var
i:integer;
tran:tbittorrentTransfer;
begin
 for i:=0 to BitTorrentTransfers.count-1 do begin
  tran:=BitTorrentTransfers[i];
  checkTracker(tran);
 end;
end;

procedure tthread_bitTorrent.checkTracker(transfer:TBittorrentTransfer);
begin
try
if transfer.fstate=dlPaused then exit;
if transfer.tracker=nil then exit;
if tick<transfer.tracker.next_poll then exit;
if transfer.tracker.socket<>nil then begin
 transfer.tracker.socket.free;
 transfer.tracker.socket:=nil;
end;
if transfer.fErrorCode<>0 then exit;
if transfer.fstate=dlAllocating then exit;

transfer.tracker.next_poll:=tick+(transfer.tracker.interval*1000)+(30*SECOND);

transfer.tracker.socket:=ttcpblocksocket.create(true);
transfer.tracker.socket.block(false);

transfer.tracker.visualStr:=widestrtoutf8str(AddBoolString(getLangStringW(STR_CONNECTING)+' ['+transfer.tracker.url+']',(not transfer.tracker.isScraping)))+
                            widestrtoutf8str(AddBoolString('Scraping ['+GetFullScrapeURL(transfer.tracker.url)+']',transfer.tracker.isScraping));
assign_proxy_settings(transfer.tracker.socket);
transfer.tracker.socket.Connect(transfer.tracker.host,inttostr(transfer.tracker.port));
transfer.tracker.Status:=bttrackerConnecting;
transfer.tracker.Tick:=tick;
transfer.tracker.FError:='';

except
end;
end;

procedure tthread_bittorrent.TrackerDeal;
var
i:integer;
tran:TBittorrentTransfer;
begin
 for i:=0 to BitTorrentTransfers.count-1 do begin
  tran:=BittorrentTransfers[i];
  TrackerDeal(tran);
 end;
end;

procedure tthread_bitTorrent.TrackerDeal(transfer:tbittorrentTransfer);
var
er,len:integer;
buffer:array[0..1023] of char;
trackerHost,trackerIDStr:string;
stream:tmemorystream;
NumWanted:integer;

ind,ind2,contentLength:integer;
contentLengthStr:string;
headerHTTP,OutStr:string;
previous_len:integer;
begin
try

if transfer.tracker=nil then exit;
if transfer.tracker.socket=nil then exit;

 case transfer.tracker.Status of

   bttrackerConnecting:begin
      if tick-transfer.tracker.Tick>TIMEOUTTCPCONNECTIONTRACKER then begin
       transfer.tracker.socket.free;
       transfer.tracker.socket:=nil;
       transfer.tracker.next_poll:=tick+TRACKERINTERVAL_WHENFAILED;
       transfer.tracker.visualStr:='Socket Error (Timeout)';
       exit;
      end;
      er:=TCPSocket_ISConnected(transfer.tracker.socket);
      if er=WSAEWOULDBLOCK then exit;
      if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
        transfer.tracker.socket.free;
        transfer.tracker.socket:=nil;
        transfer.tracker.next_poll:=tick+TRACKERINTERVAL_WHENFAILED;
        transfer.tracker.visualStr:='Socket Error ('+inttostr(er)+')';
        exit;
      end;



      if transfer.tracker.port<>80 then trackerHost:=transfer.tracker.host+':'+inttostr(transfer.tracker.port)
       else trackerHost:=transfer.tracker.host;

   if transfer.tracker.isScraping then begin
   OutStr:='GET '+GetScrapePathFromUrl(transfer.tracker.Url)+'?'+
           'info_hash='+fullUrlEncode(transfer.fhashvalue)+
           ' HTTP/1.1'+CRLF+
           'User-Agent: '+const_ares.appname+' '+versioneares+CRLF+
           'Connection: close'+CRLF+
           'Host: '+trackerHost+CRLF+
           'Accept: text/html, */*'+CRLF+CRLF;
   end else begin

       NumWanted:=50;
       if ((transfer.isCompleted) and
           (not transfer.Tracker.AlreadyCompleted)) then begin
           transfer.tracker.CurrTrackerEvent:='&event=completed';
       end else
        if ((transfer.tracker.alreadyStarted) or
            (transfer.tracker.alreadyCompleted)) then transfer.tracker.CurrTrackerEvent:=''
         else
          transfer.tracker.CurrTrackerEvent:='&event=started';
         if transfer.fsources.count>=BITTORRENT_MAX_ALLOWED_SOURCES then NumWanted:=0;
         
      if transfer.tracker.trackerID<>'' then trackerIDStr:='&trackerid='+transfer.tracker.trackerID
       else trackerIDStr:='';

   OutStr:='GET '+GetPathFromUrl(transfer.tracker.Url)+'?'+
           'info_hash='+fullUrlEncode(transfer.fhashvalue)+
           '&peer_id='+thread_bittorrent.mypeerID+
           trackerIDStr+
           '&port='+inttostr(vars_global.myport)+
           '&uploaded='+inttostr(transfer.fuploaded)+
           '&downloaded='+inttostr(transfer.fdownloaded)+
           '&left='+inttostr(transfer.fsize-transfer.fdownloaded)+
           transfer.tracker.CurrTrackerEvent+
           '&numwant='+inttostr(NumWanted)+
           '&compact=1'+
           '&key='+thread_bittorrent.myrandkey+
           ' HTTP/1.1'+CRLF+
           'User-Agent: '+const_ares.appname+' '+versioneares+CRLF+
           'Connection: close'+CRLF+
           'Host: '+trackerHost+CRLF+
           'Accept: text/html, */*'+CRLF+CRLF;
     end;


        TCPSocket_SendBuffer(transfer.tracker.socket.socket,pchar(OutStr),length(OutStr),er);
        if er=WSAEWOULDBLOCK then begin
         exit;
        end;
        if er<>0 then begin
          transfer.tracker.socket.free;
          transfer.tracker.socket:=nil;
          transfer.tracker.next_poll:=tick+TRACKERINTERVAL_WHENFAILED;
          transfer.tracker.visualStr:='Socket Error ('+inttostr(er)+')';
          exit;
        end;
      transfer.tracker.BufferReceive:='';
      transfer.tracker.Tick:=tick;
      transfer.tracker.Status:=bttrackerReceiving;
   end;

   bttrackerReceiving:begin
         if tick-transfer.tracker.Tick>TIMEOUTTCPRECEIVETRACKER then begin
          transfer.tracker.socket.free;
          transfer.tracker.socket:=nil;
          transfer.tracker.next_poll:=tick+TRACKERINTERVAL_WHENFAILED;
          transfer.tracker.visualStr:='Socket Error (Timeout)';
          exit;
         end;
         if not TCPSocket_CanRead(transfer.tracker.socket.socket,0,er) then begin
           if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
             transfer.tracker.socket.free;
             transfer.tracker.socket:=nil;
             transfer.tracker.next_poll:=tick+TRACKERINTERVAL_WHENFAILED;
             transfer.tracker.visualStr:='Socket Error ('+inttostr(er)+')';
           end;
           exit;
         end;
         len:=TCPSocket_RecvBuffer(transfer.tracker.socket.socket,@buffer,sizeof(buffer),er);
          if er=WSAEWOULDBLOCK then exit;
          if er<>0 then begin
             transfer.tracker.socket.free;
             transfer.tracker.socket:=nil;
             transfer.tracker.next_poll:=tick+TRACKERINTERVAL_WHENFAILED;
             transfer.tracker.visualStr:='Socket Error ('+inttostr(er)+')';
             exit;
          end;
          if len=0 then begin
             transfer.tracker.socket.free;
             transfer.tracker.socket:=nil;
             transfer.tracker.next_poll:=tick+TRACKERINTERVAL_WHENFAILED;
             transfer.tracker.visualStr:='Socket Error';
             exit;
          end;

         transfer.tracker.Tick:=tick;
         
         previous_len:=length(transfer.tracker.BufferReceive);
         Setlength(transfer.tracker.BufferReceive,previous_len+len);

         move(buffer,transfer.tracker.BufferReceive[previous_len+1],len);

         ind:=pos(CRLF+CRLF,transfer.tracker.BufferReceive);
         if ind>0 then begin
           headerHTTP:=copy(transfer.tracker.BufferReceive,1,ind-1);


           ind2:=pos('content-length:',lowercase(headerHTTP));
           if ind2>0 then begin   // do we have 'Content-Length:' ?
             contentLengthStr:=copy(headerHttp,ind2+15,length(headerHTTP));
             contentLengthStr:=trim(copy(contentLengthStr,1,pos(CRLF,contentLengthStr)-1));
             contentLength:=strtointDef(contentLengthStr,0);
               if contentLength+length(headerHttp)>length(transfer.tracker.BufferReceive) then begin// not enough
                 exit;
               end;
           end;

           delete(transfer.tracker.BufferReceive,1,ind+3);
         end else begin

         if ((pos('HTTP',transfer.tracker.BufferReceive)=1) and (pos(' 200 OK'+chr(10),transfer.tracker.BufferReceive)>0)) then begin
          delete(transfer.tracker.BufferReceive,1,pos(chr(10)+chr(10),transfer.tracker.BufferReceive)+1);
         end;

         end;

       if length(transfer.tracker.BufferReceive)>0 then begin
         stream:=tmemorystream.create;
          stream.Write(transfer.tracker.BufferReceive[1],length(transfer.tracker.BufferReceive));
          stream.position:=0;
          if not transfer.tracker.isScraping then transfer.tracker.Load(stream)
           else transfer.tracker.parseScrape(stream);
         stream.free;
       end;

       transfer.tracker.BufferReceive:='';
       transfer.tracker.socket.free;
       transfer.tracker.socket:=nil;

        if not transfer.tracker.isScraping then begin //it was a regular announce request
         if transfer.fsources.count>BITTORRENT_MAX_ALLOWED_SOURCES then DropOlderIdleSources(transfer);

         transfer.tracker.visualStr:=getLangStringW(STR_OK)+AddBoolString(' '+utf8strtowidestr(copy(transfer.tracker.WarningMessage,1,100)),length(transfer.tracker.WarningMessage)>0);
         transfer.tracker.next_poll:=tick+(transfer.tracker.interval*1000);

         if length(transfer.tracker.FError)>0 then begin
           transfer.tracker.visualStr:=transfer.tracker.FError;
          end else begin
            if transfer.tracker.CurrTrackerEvent='&event=started' then transfer.tracker.alreadyStarted:=true
             else
              if transfer.tracker.CurrTrackerEvent='&event=completed' then transfer.tracker.alreadyCompleted:=true;
            if ((transfer.tracker.seeders=0) and
                (transfer.tracker.leechers=0) and
                (transfer.tracker.SupportScrape)) then begin
                           log('Missing seeders/leechers stats, scraping...');
                           transfer.tracker.isScraping:=true;
                           transfer.tracker.next_poll:=0;
                           end;

          end;
        end else begin  // was scraping....
         transfer.tracker.visualStr:=getLangStringW(STR_OK)+AddBoolString(' '+utf8strtowidestr(copy(transfer.tracker.WarningMessage,1,100)),length(transfer.tracker.WarningMessage)>0);
         transfer.tracker.isScraping:=false;
         transfer.tracker.next_poll:=tick+(transfer.tracker.interval*1000);
          if length(transfer.tracker.FError)>0 then transfer.tracker.visualStr:=transfer.tracker.FError;
        end;


   end;

 end;

 except
 end;
end;

procedure DropOlderIdleSources(transfer:TBitTorrentTransfer);
var
i:integer;
source:TBitTorrentSource;
begin
transfer.fsources.sort(SortSourcesOlderFirst);

i:=0;


while ((i<transfer.fsources.count) and
       (transfer.fsources.count>BITTORRENT_MAX_ALLOWED_SOURCES)) do begin
 source:=transfer.fsources[i];

 if source.status<>btSourceIdle then begin
  inc(i);
  continue;
 end;

 if source.handshakeTick=0 then begin //leave room for newest sources
  inc(i);
  continue;
 end;

 source.status:=btSourceShouldRemove;

 inc(i);
end;

end;

///// *****************************************************************************************


procedure tthread_bitTorrent.log(txt:string);
begin
outputdebugstring(pchar(formatdatetime('hh:nn:ss',now)+'> '+txt));
end;




end.