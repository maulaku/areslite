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
Ares cache server, used to bootstrap clients, cache server keep lists of supernodes and chat channels
}

unit types_cacheserver;

interface

uses
ares_types,windows,winsock,blcksock,classes2,ares_objects;

 type
 tstato_candidato_cache=(STATO_CANDIDATOCACHE_WAITING_FOR_CALL,
                         STATO_CANDIDATOCACHE_CONNECTNG,
                         STATO_CANDIDATOCACHE_FLUSHING_LOGREQ,
                         STATO_CANDIDATOCACHE_WAITINGFORNA_HEADER,
                         STATO_CANDIDATOCACHE_WAITINGFORNA_PAYLOAD);



 type   //cache to cache link WARNING serialized structure
 precord_candidato_cache=^record_candidato_cache;
 record_candidato_cache=record
  ip:cardinal;
  port:word;
  last:cardinal;
  stato:tstato_candidato_cache;
  uptime:cardinal;
  numtry:cardinal;
  socket:hsocket;
  len_payload:word;
 end;

 type
 precord_cache_channel=^record_cache_channel;
 record_cache_channel=record
  ip:cardinal;
  alt_ip:cardinal;//ip interno fastweb
  port:word;
  topic:string;
  name:string;
  users:word;
  last:cardinal;
  mine:boolean;
  serialize:string;
  random_cookie:cardinal;//per evitare doppi canale
  build_no:word;
  rawdata:string;
 end;

 type
 precord_test_hash_supernode=^record_test_hash_supernode;
 record_test_hash_supernode=record
 port:word;
  users:word;
  build_no:word;
  horizon:word;
  files:cardinal;
  mega:cardinal;
 end;
 
type
TCacheConnectionState=(STATE_DISCONNECTED,                     // going to be removed soon
                       STATE_RECEIVINGFIRST,                   // receive first packet header 3 bytes

                       STATE_RECEIVE_PAYLOAD_THEN_FLUSHANDQUIT, // receive useless payload then flush out buffer, finally go to quit state
                       STATE_FLUSHANDQUIT,             // flush out_buffer then go to quit state
                       STATE_RECEIVE_PAYLOAD_THEN_QUIT,   // receive useless payload then go to quit state
                       STATE_QUIT, // wait 10 seconds from last event and then server connection

                       STATE_RECEIVING_CHATSERVERPAYLOAD,    // receiving chat channel payload, then go to quit

                       STATE_CACHECANDIDATE_RECEIVINGFIRSTLOG_PAYLOAD, // receiving cache firstlog payload
                       STATE_SUPERNODECANDIDATE_RECEIVINGFIRSTLOG_PAYLOAD, // receiving supernode firstlog payload
                       STATE_CACHECANDIDATE_FLUSHING_FIRSTLOG,           // flushing firstlog reply
                       STATE_SUPERNODECANDIDATE_FLUSHING_FIRSTLOG,        // flushing firstlog reply
                       STATE_SUPERNODECANDIDATE_RECEIVESTATSHEADER,
                       STATE_SUPERNODECANDIDATE_RECEIVESTATSPAYLOAD,
                       STATE_CACHE_RECEIVE_LOGINREQHEADER,

                       STATE_FLUSHINSUPERNODES,             // flushing supernode list, since list is prefilled we just send the same stuff to anyone
                       STATE_FLUSHING_CHANNELLIST,          // flushing channellist, this is from our disk db file
                       STATE_SUPERNODE_CHECKING_ACCEPTPORT, // connecting to supernode's port
                       STATE_FLUSING_LINKS);
type
TConnection = class(Tobject)
 socket,out_socket:hsocket;
 ip:cardinal;
 len_payload:word;
 state:TCacheConnectionState;
 positionStreamChannelList:cardinal;
 last:cardinal;
 out_buffer:string;
 data_sup:precord_test_hash_supernode;
 constructor create;
 destructor destroy; override;
end;

precord_cache_hash_supernode=^record_cache_hash_supernode;
 record_cache_hash_supernode=record
 ip:cardinal;
 port:word;
 users:word;
 last:cardinal;
  horizon:word;
  files:cardinal;
  mega:cardinal;
 serialize:string;
 hoststr:string;
 mine:boolean;
 build_no:word;
 //seen:cardinal;//numero volte passato qui...
 end;



type
precord_requested_ip=^record_requested_ip;
record_requested_ip=record
 ip:cardinal;
 last_seen:cardinal;
end;




type
TCache = class(Tobject)
 ip:cardinal;
 port:word;
 socket:hsocket;
 logtime:cardinal;
 disconnected:boolean;
 handshaked:boolean;
 ive_received_hissync,has_received_mysync:boolean;
 out_buffer:tmystringlist;
 last_pong:cardinal;
 in_buffer:string;
 blockingSince:cardinal;
 iveconnected:boolean;
  ca:byte;
  sc:word;
  serialize:string;
  bytes_in_header:byte;
  header_In:array[0..2] of byte;
 constructor create;
 destructor destroy; override;
end;

implementation

constructor TConnection.create;
begin
inherited create;
out_socket:=INVALID_SOCKET;
state:=STATE_RECEIVINGFIRST;
data_sup:=nil;
positionStreamChannelList:=0;
end;

destructor TConnection.destroy;
begin
 if socket<>INVALID_SOCKET then TCPSocket_Free(socket);
 if out_socket<>INVALID_SOCKET then TCPSocket_Free(out_socket);
 out_buffer:='';
 if data_sup<>nil then FreeMem(data_sup,sizeof(record_test_hash_supernode));

inherited;
end;

constructor TCache.create;
begin
inherited create;

blockingSince:=0;
bytes_in_header:=0;
out_buffer:=tmystringlist.create;
in_buffer:='';
disconnected:=false;
handshaked:=false;
ive_received_hissync:=false;
has_received_mysync:=false;
iveconnected:=false;//non sono stato io a connettermi, non passero indirizzo nei pong
end;

destructor TCache.destroy;
begin
 if socket<>INVALID_SOCKET then TCPSocket_Free(socket);

 out_buffer.free;

 in_buffer:='';
 serialize:='';
 
inherited;
end;

end.
