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
main bittorrent constants
}

unit bittorrentConst;

interface

uses
 classes,helper_datetime,const_ares;

const
 TIMEOUTTCPCONNECTION=10*SECOND;
 TIMEOUTTCPRECEIVE=15*SECOND;

 TIMEOUTTCPCONNECTIONTRACKER=15*SECOND;
 TIMEOUTTCPRECEIVETRACKER=30*SECOND;
 
 BTSOURCE_CONN_ATTEMPT_INTERVAL=5*MINUTE;
 BT_MAXSOURCE_FAILED_ATTEMPTS=2;
 BTKEEPALIVETIMEOUT=2*MINUTE;

 BITTORRENT_PIECE_LENGTH=16*KBYTE;
 EXPIRE_OUTREQUEST_INTERVAL=60*SECOND;
 INTERVAL_REREQUEST_WHENNOTCHOCKED=10*SECOND;

 BITTORRENT_INTERVAL_BETWEENCHOKES=10*SECOND;
 BITTORENT_MAXNUMBER_CONNECTION_ESTABLISH = 30;
 BITTORENT_MAXNUMBER_CONNECTION_ACCEPTED  = 55;
 TRACKERINTERVAL_WHENFAILED=2*MINUTE;
 BITTORRENT_MAX_ALLOWED_SOURCES = 100;
 SEVERE_LEECHING_RATIO=10;
 NUMMAX_SOURCES_DOWNLOADING = 4;
 MAX_OUTGOING_ATTEMPTS   = 3;
 MAXNUM_OUTBUFFER_PACKETS = 10;
 NUMMAX_TRANSFER_HASHFAILS  = 8;
 NUMMAX_SOURCE_HASHFAILS    = 4;
 STR_BITTORRENT_PROTOCOL_HANDSHAKE=chr(19)+'BitTorrent protocol';
 STR_BITTORRENT_PROTOCOL_EXTENSIONS=chr($80)+CHRNULL+CHRNULL+CHRNULL+
                                    CHRNULL+CHRNULL+CHRNULL+CHRNULL;  // we support Advanced Azureus Messaging (bit 64, according to specs it's DHT support...doh)
 AZ_BT_PIECE_HEADER=CHRNULL+CHRNULL+CHRNULL+chr(8)+'BT_PIECE'+chr(1);
 
 
 CMD_BITTORRENT_CHOKE         = 0;
 CMD_BITTORRENT_UNCHOKE       = 1;
 CMD_BITTORRENT_INTERESTED    = 2;
 CMD_BITTORRENT_NOTINTERESTED = 3;
 CMD_BITTORRENT_HAVE          = 4;
 CMD_BITTORRENT_BITFIELD      = 5;
 CMD_BITTORRENT_REQUEST       = 6;
 CMD_BITTORRENT_PIECE         = 7;
 CMD_BITTORRENT_CANCEL        = 8;
 CMD_BITTORRENT_PORT          = 9;

 // fast peer extensions
 CMD_BITTORRENT_SUGGESTPIECE  = 13;
 CMD_BITTORRENT_HAVEALL       = 14;
 CMD_BITTORRENT_HAVENONE      = 15;
 CMD_BITTORRENT_REJECTREQUEST = 16;

 // extension protocol
 CMD_BITTORRENT_EXTENSION     = 20;


 // dummy value for addpacket procedure
 CMD_BITTORRENT_KEEPALIVE     = 100;
 CMD_BITTORRENT_UNKNOWN       = 101;
 
 //Azureus Advanced Messaging
 CMD_AZ_BITTORRENT_HANDSHAKE    = 'AZ_HANDSHAKE';
 CMD_AZ_BITTORENT_PEX           = 'AZ_PEER_EXCHANGE';

 CMD_AZ_BITTORRENT_BITFIELD     = 'BT_BITFIELD';
 CMD_AZ_BITTORRENT_HAVE         = 'BT_HAVE';

 CMD_AZ_BITTORRENT_INTERESTED   = 'BT_INTERESTED';
 CMD_AZ_BITTORRENT_UNINTERESTED = 'BT_UNINTERESTED';

 CMD_AZ_BITTORRENT_CHOKE        = 'BT_CHOKE';
 CMD_AZ_BITTORRENT_UNCHOKE      = 'BT_UNCHOKE';

 CMD_AZ_BITTORRENT_REQUEST      = 'BT_REQUEST';
 CMD_AZ_BITTORRENT_CANCEL       = 'BT_CANCEL';
 CMD_AZ_BITTORRENT_PIECE        = 'BT_PIECE';

 CMD_AZ_BITTORRENT_KEEPALIVE    = 'BT_KEEP_ALIVE';


 // fast lookup dummy values
 CMD_AZLOOKUP_HANDSHAKE=9;
 CMD_AZLOOKUP_PEX=10;

 //fast lookup table
 var
 AZ_CMD_LOOKUP:array[0..10] of string = (
   CMD_AZ_BITTORRENT_CHOKE{0},CMD_AZ_BITTORRENT_UNCHOKE{1},
   CMD_AZ_BITTORRENT_INTERESTED{2},CMD_AZ_BITTORRENT_UNINTERESTED{3},
   CMD_AZ_BITTORRENT_HAVE{4},CMD_AZ_BITTORRENT_BITFIELD{5},
   CMD_AZ_BITTORRENT_REQUEST{6},CMD_AZ_BITTORRENT_PIECE{7},CMD_AZ_BITTORRENT_CANCEL{8},
   CMD_AZ_BITTORRENT_HANDSHAKE{9},CMD_AZ_BITTORENT_PEX{10});

implementation

end.