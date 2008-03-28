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
Ares cache server, thread
}

unit thread_cacheserver;

interface

uses
  Classes,windows,blcksock,synsock,winsock,sysutils,const_supernode_commands,
  const_cache_commands,const_commands,registry,utility_ares,ares_types,ares_objects,zlib,classes2,
  keywfunc,class_cmdlist,types_supernode,const_timeouts,const_win_messages,tntwindows,
  types_cacheserver,const_cacheserver,const_ares,helper_cacheserver_crypt,helper_supernode_crypt;



const
 MIN_ALLOWED_BUILD=2966;
 MAX_ALLOWED_BUILD=5500;
 WARNING_BUILD=3100;
 MAX_ALLOWED_SUPERNODES=3000; //v3022        1500(v2993)
 MAX_CHANNEL_PERIP=5;
 MAX_LEN_CHATRAWDATA=25; // used to be 10 before nov 22 2005

type
  tthread_cache = class(TThread)
  protected
   cac_prelogin_buffer:array[0..133] of byte;
   cac_encrypted_login_key,
   cac_unencrypted_login_key:string; //2953

   cac_encrypted_SUP_login_key:string; //supernode to cache and vice versa

  stream_channels:thandlestream;

  testo:string;
  higher_supernode_build:word;
  tempo:cardinal;
  last_second:cardinal;
  last_minute:cardinal;
  last_5_minutes:cardinal;
  last_20_minutes:cardinal; //per rigenerazione enc key

  last_10_second:cardinal;
  outGoingConnections:integer;

  locip:cardinal;
  locip_norm:cardinal; //ip non al contrario



   connections,RequestOutGoingConnections:tmylist;

  buffer_supernodes:array[0..299] of byte;
  len_buffer_supernodes:integer;

  buffer_crypt,buffer_crypt2:array[0..1025] of byte;
  buffer_comp:array[0..4096] of char; //per compressione lista canali out
  FRemoteUDPSin:TVarSin;

  server_socket_tcp:ttcpblocksocket;

  buffer_ricezione:array[0..1023] of byte;
  CacheContent:string;
  anti_flood_list:tmylist;

     loc_percentuale_uptime:double;
     loc_minuti_storici:cardinal;

    my_sc:word;
    my_ca:byte;
    PREPACKED_CMD_SHUTDOWN:string;

    function alreadyRequestedOutGoingConnection(ip:cardinal):boolean;
    procedure AddRequestedOutGoingConnection(ip:cardinal);
    procedure ExpireRequestedOutGoingConnection;
    function ChatClosesCount(ip:cardinal):integer;


    function get_crypt_cache_key(const unenc_key:string):string;
    function get_crypt_super_key(const unenc_key:string):string;
    procedure dump_channels;
    procedure gen_keys;
    procedure init_vars;
    procedure createlists;
    procedure freelists;
    procedure createsockets;
    procedure check_myip_port;//synch ogni 20 minuti se ho cannato porta, lo dovrei capire qui
    procedure Execute; override;
    procedure get_local_ufrmmainip;//synch ip da mp3webars ma al contrario
    procedure put_my_name;//synch
    function probe_sanity_socket(socket:integer):boolean;
    procedure get_mystats;
    procedure ExpireOld;
    procedure shutdown;
    procedure accept;
    function is_flooding_conn(ip:cardinal):boolean;
    procedure expire_antiflooding_list; //ongi 5 secondi?
    function count_clones_ip(ip:cardinal):integer;
    procedure drop_already_connected_cache(ip:cardinal); //because it may be a ghost who we got
    function already_connected_to_cache(ip:cardinal):boolean;
    function d1(cont:string):string;
    function e7(strin:string):string; // criptazione per i push
    function d7(strin:string):string; // criptazione per i push
    procedure Fill_Supernodes;
    function cache_getLoginReq(strIn:string; port:word; var his_ca:byte; var his_sc:word):string;
    function get_6_caches_string:string;

    procedure handler_conn_needed_server(conn:Tconnection;contin:string; isnew:boolean);
    procedure handler_conn_needed_caches(conn:Tconnection; contin:string);   //2957

    procedure handler_wanted_ip(conn:Tconnection);
    procedure handler_hash_supernode_stats(conn:Tconnection);
    procedure handler_hash_supernode_remove_me(ip:cardinal); //csupernode logoff
    procedure handler_client_im_hosting_chat(conn:tconnection); //chat server pong
    function nobody_dwnldng_chanlist:boolean;
    procedure handler_client_remove_my_chat(ipC:cardinal); //chat server, logoff
    procedure CheckHalfSecond;
    procedure CheckMinute;
    procedure drop_exceeding_caches;//

    procedure DisconnectGhostCache;
    procedure links_check; //controlla che ci siano links ad altri cache...
    procedure calculate_hash_stats;
    procedure caches_add_another(ip:cardinal; port:word; priorita:boolean);
    procedure add_trusted_hash_supernode(conn:tconnection);
    procedure PongCaches;
    procedure send_back_cache(cache:tcache;cmd:byte; cont:string);
    function a1(b1:word;ca:byte;a1a:word):word;    //process key according to my algo
    procedure CheckSync;

    procedure process_cache_command1(cache:tcache; lenIn:integer);
    procedure cache_handler_login_ok(cache:tcache); //ci siamo connessi noi e questa è la risposta positiva
    procedure cache_handler_pong(cache:tcache); //ci siamo connessi noi e questa è la risposta positiva
    procedure cache_handler_add_channel(cache:tcache);
    procedure cache_handler_add_supernode(cache:tcache);
    procedure cache_handler_rem_channel(cache:tcache);
    procedure cache_handler_rem_supernode(cache:tcache);
    procedure cache_handler_loginREQ(cache:tcache);
    procedure sync_my_channels(cache:tcache);
    procedure sync_my_supernodes(cache:tcache);
    procedure FlushCache(cache:TCache);
    procedure ConnManage;
    procedure switch_first_command(connection:tconnection);
    procedure receiveCache; overload;
    procedure receiveCache(cache:TCache;cycle:byte); overload;
  end;


   var



    connessioni_prima,connessioni_alminuto,connessioni_ricevute:int64;
    connessioni_rifiutate_flood_prima,connessioni_rifiutate_flood_alminuto,connessioni_rifiutate_flood:int64;
     build_mia:string;

   cache_start_time:cardinal;//per sapere quando posso iniziare ad eleggere

   users_per_hash_cluster:word;
   total_hash_users:cardinal;
   DECIDED_CLUSTER_SIZE:word;
   DECIDED_MAX_LINKS:byte;
   DECIDED_THROTTLE_UDP:word;

   hash_supernodes:TMyList;
   caches:Tmylist;
   channels:TMyList;
   cache_my_tcp_port:word;
   lista_available_caches:tmylist;

implementation

uses
  ufrmmain,helper_sockets,helper_strings,helper_crypt,helper_ipfunc,helper_sorting,
  helper_ares_cacheservers,helper_mimetypes,secureHash,
  vars_global,helper_datetime,
  helper_unicode,helper_diskio,thread_supernode;

procedure tthread_cache.createsockets;
var
 er:integer;
begin
try

if server_socket_tcp<>nil then begin
try
 server_socket_tcp.closesocket;
 server_socket_tcp.free;
except
end;
 server_socket_tcp:=nil;
end;

server_socket_tcp:=ttcpblocksocket.create(true);

    cache_my_tcp_port:=get_ppca(locip_norm);

        while true do begin
         server_socket_tcp.bind(cAnyHost,inttostr(cache_my_tcp_port));
         server_socket_tcp.listen(64);
         er:=server_socket_tcp.lasterror;
          if er<>0 then begin
           sleep(500);
           if terminated then exit;
          end else break;
        end;

except
end;
end;

procedure tthread_cache.createlists;
begin
lista_available_caches:=tmylist.create;
RequestOutGoingConnections:=tmyList.create;
anti_flood_list:=tmylist.create;
connections:=tmylist.create;
caches:=tmylist.create;
channels:=tmylist.create;
hash_supernodes:=TMyList.create;
end;

procedure tthread_cache.freelists;
var
conn:TConnection;
cache:TCache;
cache_candidate:precord_candidato_cache;
hash_supernode:precord_cache_hash_supernode;
channel:precord_cache_channel;
ip_antiflood:precord_ip_antiflood;
ip_requested:precord_requested_ip;
begin
try
while (lista_available_caches.count>0) do begin
  cache_candidate:=lista_available_caches[lista_available_caches.count-1];
                   lista_available_caches.delete(lista_available_caches.count-1);
  FreeMem(cache_candidate,sizeof(record_candidato_cache));
end;
except
end;
lista_available_caches.free;

try
while (RequestOutGoingConnections.count>0) do begin
  ip_requested:=RequestOutGoingConnections[RequestOutGoingConnections.count-1];
                RequestOutGoingConnections.delete(RequestOutGoingConnections.count-1);
  FreeMem(ip_requested,sizeof(record_requested_ip));
end;
except
end;
RequestOutGoingConnections.free;

try
while (anti_flood_list.count>0) do begin
 ip_antiflood:=anti_flood_list[anti_flood_list.count-1];
               anti_flood_list.delete(anti_flood_list.count-1);
 FreeMem(ip_antiflood,sizeof(record_ip_antiflood));
end;
except
end;
anti_flood_list.free;

 try
  while connections.count>0 do begin
   conn:=connections[connections.count-1];
         connections.delete(connections.count-1);
   conn.free;
  end;
 except
 end;
connections.free;


 try
  while caches.count>0 do begin
   cache:=caches[caches.count-1];
          caches.delete(caches.count-1);
   cache.free;
  end;
 except
 end;
caches.free;

try
while channels.count>0 do begin
 channel:=channels[channels.count-1];
          channels.delete(channels.count-1);
 channel^.name:='';
 channel^.topic:='';
 channel^.rawdata:='';
 channel^.serialize:='';
 FreeMem(channel,sizeof(record_cache_channel));
end;
except
end;
channels.free;


try
while hash_supernodes.count>0 do begin
hash_supernode:=hash_supernodes[hash_supernodes.count-1];
                hash_supernodes.delete(hash_supernodes.count-1);
 hash_supernode^.serialize:='';
 hash_supernode^.hoststr:='';
 freemem(hash_supernode,sizeof(record_cache_hash_supernode));
end;
except
end;
hash_supernodes.free;


end;




procedure tthread_cache.check_myip_port;//synch se il mio ip è cambiato allora devo cambiare porta in listening!
var
 numero,temp_locip:cardinal;
begin

if vars_global.localip=cAnyHost then exit;
if vars_global.localip='' then exit;
if vars_global.logon_time=0 then exit;

numero:=inet_addr(pchar(vars_global.localip));  //siamo sicuri che l'ip sia sempre lo stesso??
temp_locip:=chars_2_dword(reverse_order(int_2_dword_string(numero))); //locip:=get_local_ip;

try
if get_ppca(numero)<>cache_my_tcp_port then
 if temp_locip<>locip then begin
   locip:=temp_locip;
   locip_norm:=numero;
    createsockets;
 end;
except
end;


end;

procedure tthread_cache.get_local_ufrmmainip;//ip da ufrmmain ma al contrario
var
 numero:cardinal;
 stringa:string;
begin
numero:=inet_addr(pchar(vars_global.localip));  //siamo sicuri che l'ip sia sempre lo stesso??
stringa:=reverse_order(int_2_dword_string(numero));
locip:=chars_2_dword(stringa); //locip:=get_local_ip;
end;


procedure tthread_cache.init_vars;
begin
tempo:=gettickcount;   //globali
cache_start_time:=tempo; //per sapere quando posso iniziare ad eleggere
last_second:=tempo; //ogni 5 decimi in realtà
last_minute:=tempo;
last_20_minutes:=tempo;
last_5_minutes:=tempo;
 randomize;
build_mia:=vars_global.versioneares;//'1.1.1.48';

my_ca:=random(254)+1; //my crypt algo fisso per ogni sessione evitiamo 1
my_sc:=random(65534)+1;   // second key

len_buffer_supernodes:=0;
// command used to shutdown old supernodes
PREPACKED_CMD_SHUTDOWN:=e7(chr(1)+chr(10)+chr(0)+int_2_dword_string(0));
PREPACKED_CMD_SHUTDOWN:=int_2_word_string(7)+
                        chr(MSG_CCACHE_HERE_ALLSERV)+
                        PREPACKED_CMD_SHUTDOWN;


  randseed:=gettickcount;
  server_socket_tcp:=nil;//per partire la prima volta con creazione e non ri-creazione

  total_hash_users:=0;
  higher_supernode_build:=2970;
  
  connessioni_ricevute:=0;
  connessioni_rifiutate_flood_prima:=0;
  connessioni_rifiutate_flood_alminuto:=0;
  connessioni_rifiutate_flood:=0;
  connessioni_prima:=0;
  connessioni_alminuto:=0;

  users_per_hash_cluster:=8000;
  DECIDED_CLUSTER_SIZE:=9000;
  DECIDED_MAX_LINKS:=90;   //per hash servers..
  DECIDED_THROTTLE_UDP:=333;
  cache_start_time:=tempo;

  stream_channels:=MyFileOpen(data_path+'\Data\TmpChnl.Dat',ARES_OVERWRITE_EXISTING);
  stream_channels.Position:=0;
  stream_channels.size:=0;
  
  init_vars2;
end;



procedure tthread_cache.Execute;
begin
 priority:=tphigher;
 freeonterminate:=false;

 sleep(20000);
 try
  init_vars;


  randseed:=gettickcount;


  synchronize(get_local_ufrmmainip); //prende ip dato da ufrmmain.localip(quindi da supernodi a client!)
  locip_norm:=chars_2_dword( reverse_order ( int_2_dword_string (locip) ) );


 createsockets;
 createlists;
 calculate_hash_stats;


   // after create socket cause preloginbuffer is filles with crypt data using my_tcp_port as key
  synchronize(put_my_name);
  gen_keys;


last_10_second:=tempo;   //per lista antiflood


while not terminated do begin
 tempo:=gettickcount;

  accept;
  ConnManage;
   sleep(5);
  receiveCache;
  accept;
   sleep(10);
  CheckHalfSecond; //mezzo secondo in realtà

end;

except
end;

shutdown;

end;


procedure tthread_cache.links_check; //controlla che ci siano links ad altri cache...
var
i,h,er,num,len:integer;
cache:tcache;
candidato,candi:precord_candidato_cache;
str:string;
begin

if lista_available_caches.count>1 then shuffle_mylist(lista_available_caches,0);  //mescoliamo è l'unico modo di non avere preferenze


i:=0;
while (i<lista_available_caches.count) do begin

   candidato:=lista_available_caches[i];



   case candidato^.stato of

    STATO_CANDIDATOCACHE_WAITING_FOR_CALL:begin
                         if tempo-candidato^.last<10*MINUTE then begin  //ongi 10 minuti
                          inc(i);
                          continue;
                         end;
                         if candidato^.numtry>10 then begin  //10 fallimenti!
                          inc(i);
                          continue;
                         end;

                         num:=0;
                         for h:=0 to lista_available_caches.count-1 do begin
                          candi:=lista_available_caches[h];
                          if candi^.stato<>STATO_CANDIDATOCACHE_WAITING_FOR_CALL then inc(num);
                         end;
                         if num>2 then begin //troppi in connecting ,per sto giro non connetto
                          inc(i);
                          continue;
                         end;

                            if already_connected_to_cache(candidato^.ip) then begin
                              candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                             inc(i);
                             continue;
                            end;

                         //connettiamo!
                          candidato^.stato:=STATO_CANDIDATOCACHE_CONNECTNG;
                          candidato^.last:=tempo;
                           candidato^.socket:=TCPSocket_create;
                           TCPSocket_Block(candidato^.socket,false);
                          inc(candidato^.numtry);
                          TCPSocket_Connect(candidato^.socket,ipint_to_dotstring(candidato^.ip),inttostr(candidato^.port),er);
                            if er<>WSAEWOULDBLOCK then
                             if er<>0 then begin
                              candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                               TCPSocket_Free(candidato^.socket);
                               candidato^.socket:=INVALID_SOCKET;
                               inc(i);
                               continue;
                             end;
                       end;

    STATO_CANDIDATOCACHE_CONNECTNG:begin

                           if tempo-candidato^.last>TIMOUT_SOCKET_CONNECTION then begin
                            candidato^.last:=tempo;
                            candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                            TCPSocket_Free(candidato^.socket);
                            candidato^.socket:=INVALID_SOCKET;
                             inc(i);
                             continue;
                           end;

                           if not TCPSocket_CanWrite(candidato^.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                              candidato^.last:=tempo;
                              candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                              TCPSocket_Free(candidato^.socket);
                              candidato^.socket:=INVALID_SOCKET;
                             end;
                            inc(i);
                            continue;
                           end;


                           str:=chr(0)+CHRNULL+
                                chr(MSG_CCACHE_PRELOGIN_LATEST); //richiesta prelogin
                           TCPSocket_SendBuffer(candidato^.socket,@str[1],length(str),er);

                              if er=WSAEWOULDBLOCK then begin
                               inc(i);
                               continue;
                              end;
                              if er<>0 then begin
                               candidato^.last:=tempo;
                                candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                                TCPSocket_Free(candidato^.socket);
                                candidato^.socket:=INVALID_SOCKET;
                               inc(i);
                               continue;
                              end;  //flushato!

                              candidato^.last:=tempo;
                              candidato^.stato:=STATO_CANDIDATOCACHE_WAITINGFORNA_HEADER;
                              inc(i);
                              continue;
                           end;

      STATO_CANDIDATOCACHE_WAITINGFORNA_HEADER:begin //riceviamo 3 bytes di header here my na
                           if tempo-candidato^.last>TIMOUT_SOCKET_CONNECTION then begin
                            candidato^.last:=tempo;
                            candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                            TCPSocket_Free(candidato^.socket);
                            candidato^.socket:=INVALID_SOCKET;
                             inc(i);
                             continue;
                           end;

                           if not TCPSocket_CanRead(candidato^.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                              candidato^.last:=tempo;
                              candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                              TCPSocket_Free(candidato^.socket);
                              candidato^.socket:=INVALID_SOCKET;
                             end;
                             inc(i);
                             continue;
                           end;

                           len:=TCPSocket_RecvBuffer(candidato^.socket,@buffer_crypt,3,er);
                            if er=WSAEWOULDBLOCK then begin
                             inc(i);
                             continue;
                            end;
                            if er<>0 then begin
                              candidato^.last:=tempo;
                              candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;
                              TCPSocket_Free(candidato^.socket);
                              candidato^.socket:=INVALID_SOCKET;
                             inc(i);
                             continue;
                            end;

                            if len<3 then begin
                              candidato^.last:=tempo;
                              candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;
                              TCPSocket_Free(candidato^.socket);
                              candidato^.socket:=INVALID_SOCKET;
                             inc(i);
                             continue;
                            end;


                             if buffer_crypt[2]<>MSG_CACHE_MY_UNENCKEY then begin
                               candidato^.last:=tempo;
                               candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;
                               TCPSocket_Free(candidato^.socket);
                               candidato^.socket:=INVALID_SOCKET;
                               inc(i);
                               continue;
                             end;

                             move(buffer_crypt[0],candidato^.len_payload,2);
                             if candidato^.len_payload>200 then begin
                               candidato^.last:=tempo;
                               candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;
                               TCPSocket_Free(candidato^.socket);
                               candidato^.socket:=INVALID_SOCKET;
                               inc(i);
                               continue;
                             end;

                             if candidato^.len_payload=128 then candidato^.len_payload:=131;//bug in 2991

                             candidato^.last:=tempo;
                             candidato^.stato:=STATO_CANDIDATOCACHE_WAITINGFORNA_PAYLOAD;
             end;


         STATO_CANDIDATOCACHE_WAITINGFORNA_PAYLOAD:begin
                          if tempo-candidato^.last>TIMOUT_SOCKET_CONNECTION then begin
                            candidato^.last:=tempo;
                            candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                            TCPSocket_Free(candidato^.socket);
                            candidato^.socket:=INVALID_SOCKET;
                             inc(i);
                             continue;
                           end;
                           if not TCPSocket_CanRead(candidato^.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                              candidato^.last:=tempo;
                              candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                              TCPSocket_Free(candidato^.socket);
                              candidato^.socket:=INVALID_SOCKET;
                             end;
                             inc(i);
                             continue;
                           end;
                           len:=TCPSocket_RecvBuffer(candidato^.socket,@buffer_crypt[0],candidato^.len_payload,er);
                           if er=WSAEWOULDBLOCK then begin
                            inc(i);
                            continue;
                           end;
                           if er<>0 then begin
                              candidato^.last:=tempo;
                              candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                              TCPSocket_Free(candidato^.socket);
                              candidato^.socket:=INVALID_SOCKET;
                             inc(i);
                             continue;
                           end;
                           if len<>candidato^.len_payload then begin
                              candidato^.last:=tempo;
                              candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                              TCPSocket_Free(candidato^.socket);
                              candidato^.socket:=INVALID_SOCKET;
                             inc(i);
                             continue;
                           end;

                           if already_connected_to_cache(candidato^.ip) then begin
                               candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;//non si sa mai
                               TCPSocket_Free(candidato^.socket);
                               candidato^.socket:=INVALID_SOCKET;
                               inc(i);
                               continue;
                            end;

                            setlength(str,len);
                            move(buffer_crypt[0],str[1],len);

                          cache:=Tcache.create;
                             cache.ip:=candidato^.ip;
                             cache.port:=candidato^.port; //serve per prima criptazione
                             cache.socket:=candidato^.socket;
                             cache.logtime:=tempo;
                             cache.last_pong:=tempo;
                            cache.out_buffer.add(cache_getLoginReq(str,cache.port,cache.ca,cache.sc));
                             caches.add(cache);

                           candidato^.socket:=INVALID_SOCKET; //non è più un socket linker
                           candidato^.last:=tempo;
                           candidato^.numtry:=0;//azzeriamo per check shit candidate...
                           candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;
                             inc(i);
                             continue;
                       end;
                       
   end;

inc(i);
end;


end;








procedure tthread_cache.caches_add_another(ip:cardinal; port:word; priorita:boolean);
var
i,h:integer;
cache:tcache;
candidato:precord_candidato_cache;
canremove,canadd:boolean;
begin

 try

 if get_ppca(ip)<>port then port:=get_ppca(ip);

i:=0;
while (i<lista_available_caches.count) do begin
candidato:=lista_available_caches[i];
 if candidato.ip=ip then begin
  exit;
 end;
inc(i);
end;

 canadd:=true;

 if lista_available_caches.count>=MAX_CACHE_HORIZON then begin  //flush too many entries
  canadd:=false;

  lista_available_caches.Sort(ordina_candidate_cache_peR_numtry);

    try
     i:=0;
     while ((i<lista_available_caches.count) and (lista_available_caches.count>=MAX_CACHE_HORIZON)) do begin //cancelliamo iniziando dall'ultimo(peggiore)
       candidato:=lista_available_caches[i];

       if candidato^.numtry<2 then begin  //solo se è stato testato un minimo
        inc(i);
        continue;
       end;

        canremove:=true;
        for h:=0 to caches.count-1 do begin   //togliamo solo hosts che non sono connessi! in questo modo manteniamo più possibile i links
         cache:=caches[h];
         if cache.ip=ip then begin
          canremove:=False;
          break;
         end;
        end;

         if canremove then begin
           lista_available_caches.delete(i);
           FreeMem(candidato,sizeof(record_candidato_cache));
           canadd:=true;
           break;
         end else inc(i);

     end;
    except
    end;
 end;


  if not canadd then exit;

candidato:=AllocMem(sizeof(record_candidato_cache));
 candidato^.ip:=ip;
 candidato^.port:=port;
 candidato^.last:=0;
 candidato^.uptime:=0;
 candidato^.socket:=INVALID_SOCKET;
 candidato^.numtry:=0;
 candidato^.stato:=STATO_CANDIDATOCACHE_WAITING_FOR_CALL;
  if ((lista_available_caches.count>1) and (priorita)) then lista_available_caches.insert(0,candidato)
   else lista_available_caches.add(candidato);

  except
  end;
end;


procedure tthread_cache.add_trusted_hash_supernode(conn:tconnection);
var
i,h:integer;
sup:precord_cache_hash_supernode;
cache:tcache;
begin
tempo:=gettickcount;

i:=0;
while (i<hash_supernodes.count) do begin
sup:=hash_supernodes[i];
 if sup^.ip=conn.ip then begin
  sup^.port:=conn.data_sup^.port;
  sup^.horizon:=conn.data_sup^.horizon;
  sup^.users:=conn.data_sup^.users;
  sup^.files:=conn.data_sup^.files;
  sup^.mega:=conn.data_sup^.mega;
  sup^.mine:=true;
  sup^.build_no:=conn.data_sup^.build_no;
  sup^.last:=tempo;

  //inc(sup^.seen); // numero cicli
    sup^.serialize:=int_2_dword_string(sup^.ip)+
                    int_2_word_string(sup^.port)+
                    int_2_word_string(sup^.horizon)+
                    int_2_word_string(sup^.users)+
                    int_2_dword_string(0)+   //latency
                    int_2_dword_string(sup^.files)+
                    int_2_dword_string(sup^.mega)+
                    int_2_word_string(sup^.build_no)+
                    chr(0)+CHRNULL+CHRNULL+CHRNULL;
     sup^.hoststr:=int_2_dword_string(sup^.ip)+
                   int_2_word_string(sup^.port);
     for h:=0 to caches.count-1 do begin
      cache:=caches[h];
      if not cache.handshaked then continue;
      send_back_cache(cache,MSG_CACHE_ADD_HASH_SUPERNODE,sup^.serialize+
                                                         int_2_dword_string(1));//un microsecondo di delay
     end;
  exit;
 end else inc(i);
end;


sup:=AllocMem(sizeof(record_cache_hash_supernode));
  sup^.ip:=conn.ip;
  sup^.port:=conn.data_sup^.port;
  sup^.horizon:=conn.data_sup^.horizon;
  sup^.users:=conn.data_sup^.users;
  sup^.files:=conn.data_sup^.files;
  sup^.mega:=conn.data_sup^.mega;
  sup^.last:=tempo;
  sup^.build_no:=conn.data_sup^.build_no;
  sup^.mine:=true;
 // sup^.seen:=1;
    sup^.serialize:=int_2_dword_string(sup^.ip)+
                    int_2_word_string(sup^.port)+
                    int_2_word_string(sup^.horizon)+
                    int_2_word_string(sup^.users)+
                    int_2_dword_string(0)+        //latency
                    int_2_dword_string(sup^.files)+
                    int_2_dword_string(sup^.mega)+
                    int_2_word_string(sup^.build_no)+
                    chr(0)+CHRNULL+CHRNULL+CHRNULL;
    sup^.hoststr:=int_2_dword_string(sup^.ip)+
                  int_2_word_string(sup^.port);
  hash_supernodes.add(sup);
     for h:=0 to caches.count-1 do begin
      cache:=caches[h];
      if not cache.handshaked then continue;
      send_back_cache(cache,MSG_CACHE_ADD_HASH_SUPERNODE,sup^.serialize+
                                                         int_2_dword_string(1)); //last seen di un microsecondo (utile in sync per tenere fuori stale entries)
     end;

end;







procedure tthread_cache.CheckHalfSecond;//in realtà ogni mezzo secondo
begin
 if tempo-last_second<500 then exit;
 last_second:=tempo;

 links_check;
  if not terminated then sleep(5);
 check_seconds;  
  if not terminated then sleep(5);
 CheckMinute;

 if tempo-last_10_second<10000 then exit;
  last_10_second:=tempo;

 expire_antiflooding_list;
 ExpireRequestedOutGoingConnection;
end;

procedure tthread_cache.ExpireOld;
var
i:integer;
hash_supernode:precord_cache_hash_supernode;
channel:precord_cache_channel;
begin
try
tempo:=gettickcount;   //facciamo qui un refresh!


i:=0;
while (i<hash_supernodes.count) do begin
 hash_supernode:=hash_supernodes[i];
  if tempo-hash_supernode^.last>TIMEOUT_PONG_CACHE_SERVER then begin

   hash_supernode^.serialize:='';
   hash_supernode^.hoststr:='';
    hash_supernodes.delete(i);
   FreeMem(hash_supernode,sizeof(record_cache_hash_supernode));

  end else inc(i);
end;


i:=0;
while (i<channels.count) do begin
 channel:=channels[i];
  if tempo-channel^.last>TIMEOUT_PONG_CACHE_SERVER then begin
   channel^.name:='';
   channel^.topic:='';
   channel^.serialize:='';
   channel^.rawdata:='';
    channels.delete(i);
   FreeMem(channel,sizeof(record_cache_channel));
  end else inc(i);
end;

except
end;
end;



procedure tthread_cache.CheckMinute;
begin
if tempo-last_minute<MINUTE then exit;
last_minute:=tempo;

  Fill_Supernodes; //fill supernodes_buffer

  if connessioni_prima>0 then connessioni_alminuto:=connessioni_ricevute-connessioni_prima else connessioni_alminuto:=0;
   connessioni_prima:=connessioni_ricevute;

   if connessioni_rifiutate_flood_prima>0 then connessioni_rifiutate_flood_alminuto:=connessioni_rifiutate_flood-connessioni_rifiutate_flood_prima else connessioni_rifiutate_flood_alminuto:=0;
    connessioni_rifiutate_flood_prima:=connessioni_rifiutate_flood;

if not terminated then DisconnectGhostCache;
 if not terminated then sleep(5) else exit;
if not terminated then PongCaches;         //attenzione nuovi cache non accettano pong se sono passati meno di 50 secondi e parsano solo 6 indirizzi
 if not terminated then sleep(5) else exit;
if not terminated then ExpireOld;
 if not terminated then sleep(5) else exit;
if not terminated then calculate_hash_stats;
 if not terminated then drop_exceeding_caches;


if tempo-last_5_minutes>5*MINUTE then begin
 last_5_minutes:=tempo;
 dump_channels;
end;

if tempo-last_20_minutes>20*MINUTE then begin
  last_20_minutes:=tempo;

  synchronize(check_myip_port);

  synchronize(put_my_name); //recalc cac_prelogin_buffer
  gen_keys;
end;

end;


procedure tthread_cache.drop_exceeding_caches;// ogni minuto sgancio i caches di troppo
var
to_drop,i,dropped:integer;
cache:tcache;
begin
try



 if caches.count>170 then begin   //almeno  era 130

       shuffle_mylist(caches,0); //mescoliamo

    to_drop:=caches.count-150;   //era 80 prima di maggio 21 2004 2957+ era 110
    dropped:=0;
    i:=0;
    while (i<caches.count) do begin
      cache:=caches[i];
       if not cache.has_received_mysync then begin  //gli ho inviato endofsynch e lui mi ha risposto che aveva tutto
        inc(i);
        continue;
       end;
       if not cache.ive_received_hissync then begin //ho ricevuto tutto di lui e aspetto che anche lui mi dica che ha tutto di me
        inc(i);
        continue;
       end;
       if tempo-cache.logtime<2*MINUTE then begin  //almeno due minuti per ricevere due pong con relativi indirizzi di altri caches
        inc(i);
        continue;
       end;

       caches.delete(i);
       cache.free;
        inc(dropped);

       if dropped>=to_drop then break;
    end;
  end;

except
end;
end;

procedure tthread_cache.calculate_hash_stats; //per sapere quando generarne altri ogni minuto
var
i:integer;
hash_supernode:precord_cache_hash_supernode;
begin

total_hash_users:=0;

 for i:=0 to hash_supernodes.count-1 do begin
  hash_supernode:=hash_supernodes[i];
  if hash_supernode^.users>0 then inc(total_hash_users,hash_supernode^.users);
 end;

end;


procedure tthread_cache.DisconnectGhostCache;
var i:integer;
cache:tcache;
begin
 for i:=0 to caches.count-1 do begin
  cache:=caches[i];
   if tempo-cache.last_pong>3*MINUTE then cache.disconnected:=true; //2957<  era 2 minuti
 end;
end;

function tthread_cache.get_6_caches_string:string;
var
added:integer;
h:integer;
cache_cand:TCache;
begin
result:='';
added:=0;
if caches.count>6 then shuffle_mylist(caches,0);

 for h:=0 to caches.count-1 do begin
  cache_cand:=caches[h];
  if not cache_cand.handshaked then continue;

    result:=result+
            cache_cand.serialize;
            
    inc(added);
    if added>=6 then break;
 end;

end;

procedure tthread_cache.PongCaches;   //inviamo 6 possibili candidati a tutti, così ci autososteniamo
var
h:integer;
cache:tcache;
str:string;
begin

try

if caches.count=0 then exit;//no need to pong anyone

str:=int_2_word_string(caches.count)+
     get_6_caches_string;

 for h:=0 to caches.count-1 do begin
  cache:=caches[h];
  if not cache.handshaked then continue;   //solo entrati correttamente

   if tempo-cache.logtime<50*SECOND then continue;//non mandiamo subito altrimenti non lo calcola

    send_back_cache(cache,MSG_CACHE_PONG,str);
 end;




except
end;

end;

procedure tthread_cache.send_back_cache(cache:tcache; cmd:byte; cont:string);
var
str:string;

b2:word;
cn:byte;
I: cardinal;
len:word;
begin
// my_algo usato per decrpy
// my_name usato per decrypt
try
if length(cont)+2>sizeof(buffer_crypt) then exit;

cn:=random(250)+1; //local ca  evitiamo 0
b2:=a1(cache.sc,cn,ff[cache.ca]);

    buffer_crypt[0]:=cn;
    buffer_crypt[1]:=random(250)+1;

    move(cont[1],buffer_crypt[2],length(cont));

    len:=length(cont)+1; //length(cont)+1 per includere in indice 0 based due caratteri in più
     for I := 2 to Len do begin //criptiamo
        buffer_crypt[I] := buffer_crypt[I] xor (b2 shr 8);
        b2 := (buffer_crypt[I] + b2) * 52845 + 22719;
     end;

     inc(len); //tot length(conn)+2
     setlength(str,len);
     move(buffer_crypt[0],str[1],len);

cache.out_buffer.add(int_2_word_string(len)+
                     chr(cmd)+
                     str);

except
end;
end;



function tthread_cache.a1(b1:word;ca:byte;a1a:word):word;    //process key according to my algo
var g:integer;
begin
 g:=a1a;

g:=(fa[ca])-(fb[ca])+(g-(ca*3))+b1;
g:=(fa[ca])-(fb[ca])+(g-(ca*3))+b1;
g:=(fa[ca])-(fb[ca])+(g-(ca*3))+b1;
g:=(fa[ca])-(fb[ca])+(g-(ca*3))+b1;

result:=g;
end;


procedure tthread_cache.receiveCache;
var
i:integer;
cache:TCache;
begin
try

 i:=0;
  while (i<caches.count) do begin
   cache:=caches[i];

      if cache.disconnected then begin //offline
       caches.delete(i);
       cache.free;
       continue;
      end else flushCache(cache);

      ReceiveCache(cache,0);

      if cache.disconnected then begin //offline
       caches.delete(i);
       cache.free;
       continue;
      end else flushCache(cache);

   inc(i);
  end;

except
end;
end;

procedure tthread_cache.FlushCache(cache:TCache);
var
er:integer;
begin
 try

 if cache.out_buffer.count=0 then begin
  cache.blockingSince:=0;
  exit;
 end;

  if cache.blockingSince<>0 then begin     //check send timeout 30 secondi
   if cache.out_buffer.count>0 then begin
    if tempo-cache.blockingSince>120000 then begin  //send timeout....
     cache.disconnected:=true;
     exit;
    end;
   end;
  end;

  checksync;


 while (cache.out_buffer.count>0) do begin
 try

 if terminated then exit;
 TCPSocket_SendBuffer(cache.socket, pchar(cache.out_buffer.Strings[0]),length(cache.out_buffer.Strings[0]) , er);

 if er=WSAEWOULDBLOCK then begin
  if cache.blockingSince=0 then cache.blockingSince:=tempo;
  exit;
 end;

 if er<>0 then begin
  cache.disconnected:=true;
  exit;
 end;

  cache.out_buffer.delete(0);

  cache.last_pong:=tempo;
  
  cache.blockingSince:=0;

  except
  end;

end;


except
end;
end;

procedure tthread_cache.receiveCache(cache:TCache;cycle:byte);
var
len,er:integer;
wanted_len:word;
previous_len:integer;
begin
try

 if not TCPSocket_CanRead(cache.socket, 0 , er) then begin
  if ((er<>WSAEWOULDBLOCK) and (er<>0)) then begin
   cache.disconnected:=true;
   end;
  exit;
 end;



   if cache.bytes_in_header<3 then begin
    len:=TCPSocket_RecvBuffer(cache.socket,@cache.header_In[0],3-cache.bytes_in_header,er);
    if er=WSAEWOULDBLOCK then exit;
    if er<>0 then begin
     cache.disconnected:=true;
     exit;
    end;
    inc(cache.bytes_in_header,len);
    if cache.bytes_in_header<>3 then begin
     cache.disconnected:=true;
     exit;
    end;
    cache.last_pong:=tempo;
    inc(cycle);
    if cycle<10 then receiveCache(cache,cycle);
    exit;
   end;


    move(cache.header_In[0],wanted_len,2);
    if wanted_len>sizeof(buffer_ricezione) then begin
     cache.disconnected:=true;
     exit;
    end;

    if wanted_len=0 then begin
      cache.last_pong:=tempo;


       process_cache_command1(cache,0);

      cache.bytes_in_header:=0;
      cache.in_buffer:='';

      if cache.disconnected then exit else begin
       if cycle<10 then receiveCache(cache,cycle);
      end;
      exit;
    end;



   previous_len:=length(cache.in_buffer);
   
   len:=TCPSocket_RecvBuffer(cache.socket,@buffer_ricezione[0],wanted_len-previous_len, er);
   if er=WSAEWOULDBLOCK then exit;

   if er<>0 then begin
    cache.disconnected:=true;
    exit;
   end;

   cache.last_pong:=tempo;

   checksync;

   if previous_len+len<wanted_len then begin // temporary fill in_buffer..allocate memory here
    setlength(cache.in_buffer,previous_len+len);
    move(buffer_ricezione[0],cache.in_buffer[previous_len+1],len);
     inc(cycle);
     if cycle<10 then receiveCache(cache,cycle);
    exit;
   end;

   // here we have received payload completely

   if previous_len>0 then begin   //if we had previously allocated, copy buffer
    move(cache.in_buffer[1],buffer_comp[0],previous_len);
    move(buffer_ricezione[0],buffer_comp[previous_len],len);
    move(buffer_comp[0],buffer_ricezione[0],previous_len+len);
   end;

    process_cache_command1(cache,previous_len+len);

     if cache.disconnected then exit;

     cache.in_buffer:='';
     cache.bytes_in_header:=0;

      checksync;

     inc(cycle);
     if cycle<10 then receiveCache(cache,cycle);



 except
 end;
end;

procedure tthread_cache.process_cache_command1(cache:tcache; lenIn:integer);
var
b2,len:word;
i:integer;
begin


 if not cache.handshaked then
  if cache.header_In[2]<>MSG_CACHE_LOGIN_OK then
    if cache.header_In[2]<>MSG_CACHE_LOGIN then
        if cache.header_In[2]<>MSG_CACHE_MY_UNENCKEY then begin
         cache.disconnected:=true;
         exit;
        end;


if lenIn>2 then begin
 // get byte[0], skip byte[1] and decrypt starting from byte[2]
 b2:=a1(my_sc,ord(buffer_ricezione[0]),ff[my_ca]);
 len:=LenIn-2;
 for I:=0 to len-1 do begin
   buffer_crypt[I]:=(buffer_ricezione[I+2] xor (b2 shr 8));
   b2:=(buffer_ricezione[I+2] + b2) * 52845 + 22719;
 end;
 setlength(cache.in_buffer,len);
 move(buffer_crypt[0],cache.in_buffer[1],len);
end else begin
 len:=0;
 setlength(cache.in_buffer,len);
end;



case cache.header_In[2] of
 
 MSG_CACHE_LOGIN_OK:cache_handler_login_ok(cache);
 MSG_CACHE_LOGIN:cache_handler_loginREQ(cache);

 MSG_CACHE_ADD_HASH_SUPERNODE:cache_handler_add_supernode(cache);
 MSG_CACHE_REM_HASH_SUPERNODE:cache_handler_rem_supernode(cache);

 MSG_CACHE_ADD_CHANNEL:cache_handler_add_channel(cache);
 MSG_CACHE_REM_CHANNEL:cache_handler_rem_channel(cache);

 MSG_CACHE_PONG:cache_handler_pong(cache);
 MSG_CACHE_GOTYOURENDOFSYNC:cache.has_received_mysync:=true;
 MSG_CACHE_ENDOFSYNC:begin
                      cache.ive_received_hissync:=true;
                      send_back_cache(cache,MSG_CACHE_GOTYOURENDOFSYNC,'1');
                     end;

end;


end;


procedure tthread_cache.get_mystats;

var minuti_attuali,minuti_uptime:cardinal;

begin

   loc_minuti_storici:=(delphidatetimetounix(now)-vars_global.program_first_day) div 60; //da quanti minuti ho il programma (totali)

   minuti_attuali:=(gettickcount-vars_global.program_start_time) div 60000;
   minuti_uptime:=vars_global.program_totminuptime+minuti_attuali;    //per quanti minuti totali ho usato ares.....

   loc_percentuale_uptime:=(minuti_uptime / loc_minuti_storici)*100;    //che percentuale ho di uptime/downtime
end;


procedure tthread_cache.cache_handler_pong(cache:tcache); //ci siamo connessi noi e questa è la risposta positiva
var
port:word;
ip:cardinal;
added:byte;
begin
try

//if (tempo-cache.last_pong<15*SECONDO) then exit;

cache.last_pong:=tempo;

 delete(cache.in_buffer,1,2);  //skippiamo info su quanti cache ha...questo causava bug da version 2939 non invio più questo dato

added:=0;
while (length(cache.in_buffer)>=6) do begin

  ip:=chars_2_dword(copy(cache.in_buffer,1,4));
  port:=chars_2_word(copy(cache.in_buffer,5,2));  //volendo potremmo controllare validità porta/ip
    delete(cache.in_buffer,1,6);

   if ip=locip_norm then continue;
   if get_ppca(ip)<>port then continue;  //validità per bug #2939 di offset errato

  caches_add_another(ip,port,false);

    inc(added);
    if added>6 then break;
end;

except
end;
end;

procedure tthread_cache.cache_handler_rem_channel(cache:tcache);
var
i:integer;
ip:cardinal;
channel:precord_cache_channel;
begin
try
if length(cache.in_buffer)<4 then exit;

ip:=chars_2_dword(copy(cache.in_buffer,1,4));

i:=0;
while (i<channels.count) do begin
channel:=channels[i];
  if channel^.ip=ip then begin
    channel^.name:='';
    channel^.topic:='';
    channel^.serialize:='';
    channel^.rawdata:='';
     channels.delete(i);
    FreeMem(channel,sizeof(record_cache_channel));
   exit;
  end else inc(i);
end;

except
end;
end;



procedure tthread_cache.cache_handler_add_channel(cache:tcache);
var
i:integer;

users:word;
topic:string;
chname:string;
port:word;
ip,alt_ip:cardinal;
channel:precord_cache_channel;
random_cookie:cardinal;
build_no:word;
rawdata:string;
NumClones:integer;
begin
                                    //i canali entrano senza test?
if length(cache.in_buffer)<12 then exit;

try

move(cache.in_buffer[1],ip,4);

move(cache.in_buffer[5],port,2);

move(cache.in_buffer[7],users,2);
 delete(cache.in_buffer,1,8);

chname:=copy(cache.in_buffer,1,pos(CHRNULL,cache.in_buffer)-1);
 if length(chname)>MAX_CHAT_NAME_LEN then delete(chname,MAX_CHAT_NAME_LEN+1,length(chname));
 delete(cache.in_buffer,1,pos(CHRNULL,cache.in_buffer));
topic:=copy(cache.in_buffer,1,pos(CHRNULL,cache.in_buffer)-1);
 if length(topic)>MAX_CHAT_TOPIC_LEN then delete(topic,MAX_CHAT_TOPIC_LEN+1,length(topic));
 delete(cache.in_buffer,1,pos(CHRNULL,cache.in_buffer));


 build_no:=0;
 rawdata:='';
 alt_ip:=0;
 random_cookie:=0;
 
if length(cache.in_buffer)>=4 then begin
 move(cache.in_buffer[1],alt_ip,4);
  if length(cache.in_buffer)>=8 then begin
   move(cache.in_buffer[5],random_cookie,4);
     if length(cache.in_buffer)>9 then begin
      move(cache.in_buffer[9],build_no,2);
      rawdata:=copy(cache.in_buffer,11,length(cache.in_buffer));
      if length(rawdata)>MAX_LEN_CHATRAWDATA then delete(rawdata,MAX_LEN_CHATRAWDATA+1,length(rawdata));
     end;
  end;
end;

numClones:=0;
i:=0;
while (i<channels.count) do begin
channel:=channels[i];

 if channel^.ip<>ip then begin
  inc(i);
  continue;
 end;


 if ((channel^.alt_ip=alt_ip) or (channel^.port=port)) then begin
  channel^.name:=chname;
  channel^.ip:=ip;
  channel^.users:=users;
  channel^.topic:=topic;
  channel^.port:=port;
  channel^.alt_ip:=alt_ip;
  channel^.last:=gettickcount;
  channel^.mine:=false;
  if build_no>0 then channel^.build_no:=build_no;   // update it here 3024+
  channel^.rawdata:=rawdata;
  channel^.random_cookie:=random_cookie; // update it here 3024+
   channel^.serialize:=int_2_dword_string(channel^.ip)+
                       int_2_word_string(channel^.port)+
                       int_2_word_string(channel^.users)+
                       channel^.name+CHRNULL+
                       channel^.topic+CHRNULL+
                       int_2_dword_string(channel^.alt_ip)+
                       int_2_dword_string(channel^.random_cookie)+
                       int_2_word_string(channel^.build_no)+
                       channel^.rawdata;
  exit;
 end else begin
  inc(NumClones);
  inc(i);
 end;
end;

  if NumClones>MAX_CHANNEL_PERIP then exit;


 channel:=AllocMem(sizeof(record_cache_channel));
  channel^.users:=users;
  channel^.topic:=topic;
  channel^.port:=port;
  channel^.name:=chname;
  channel^.ip:=ip;
  channel^.alt_ip:=alt_ip;
  channel^.mine:=false;
  channel^.last:=gettickcount;
  channel^.random_cookie:=random_cookie;
  channel^.build_no:=build_no;
  channel^.rawdata:=rawdata;

   channel^.serialize:=int_2_dword_string(channel^.ip)+
                       int_2_word_string(channel^.port)+
                       int_2_word_string(channel^.users)+
                       channel^.name+CHRNULL+
                       channel^.topic+CHRNULL+
                       int_2_dword_string(channel^.alt_ip)+
                       int_2_dword_string(channel^.random_cookie)+
                       int_2_word_string(channel^.build_no)+
                       channel^.rawdata;

  channels.add(channel);

except
end;
end;

procedure tthread_cache.cache_handler_rem_supernode(cache:tcache);
var
addr:cardinal;
i:integer;
hash_supernode:precord_cache_hash_supernode;
begin
try
if length(cache.in_buffer)<4 then exit;

addr:=chars_2_dword(copy(cache.in_buffer,1,4));

i:=0;
while (i<hash_supernodes.count) do begin
hash_supernode:=hash_supernodes[i];
 if hash_supernode^.ip=addr then begin
  hash_supernode^.serialize:='';
  hash_supernode^.hoststr:='';
  hash_supernodes.delete(i);
   FreeMem(hash_supernode,sizeof(record_cache_hash_supernode));
 exit;
 end else inc(i);
end;

except
end;
end;


procedure tthread_cache.cache_handler_add_supernode(cache:tcache);
var

addr:cardinal;
port:word;
horizon:word;
users:word;
mega,files,last_seen:cardinal;
i:integer;
build_no:word;
sup:precord_cache_hash_supernode;
begin

if hash_supernodes.count>=MAX_ALLOWED_SUPERNODES then exit;

if length(cache.in_buffer)<24 then exit;

try
move(cache.in_buffer[1],addr,4);

if isAntiP2PIP(addr) then exit;

move(cache.in_buffer[5],port,2);
move(cache.in_buffer[7],horizon,2);
move(cache.in_buffer[9],users,2);

files:=0;
mega:=0;
build_no:=0;
last_seen:=0;  //di default è freschissimo



  move(cache.in_buffer[15],files,4);
  move(cache.in_buffer[19],mega,4);

  move(cache.in_buffer[23],build_no,2);
  if build_no<MIN_ALLOWED_BUILD then exit;
  if build_no>MAX_ALLOWED_BUILD then exit;

  if build_no>2970 then
   if build_no<2980 then exit; //crash failures

   if build_no>WARNING_BUILD then
    if port=1234 then exit; //crash failures

  if users>ACCEPT_HARD_LIMIT then exit;
  if files>MAX_FILES_SHARED_PERSUPERNODE then exit;

  
tempo:=gettickcount;

i:=0;
while (i<hash_supernodes.count) do begin
sup:=hash_supernodes[i];
 if sup^.ip=addr then begin
  sup^.port:=port;
  sup^.horizon:=horizon;
  sup^.users:=users;
  sup^.files:=files;
  sup^.mega:=mega;
  sup^.mine:=false;
   if last_seen>tempo then sup^.last:=0 else sup^.last:=tempo-last_seen; //usiamo last seen microsecondi che ci hanno inviato loro, distinguiamo tra server nuovi e vecchi
  sup^.build_no:=build_no;
 // inc(sup^.seen); // numero cicli
    sup^.serialize:=int_2_dword_string(sup^.ip)+   //1
                    int_2_word_string(sup^.port)+  //5
                    int_2_word_string(sup^.horizon)+ //7
                    int_2_word_string(sup^.users)+    //9
                    int_2_dword_string(0)+   //11    latency
                    int_2_dword_string(sup^.files)+    //15
                    int_2_dword_string(sup^.mega)+     //19
                    int_2_word_string(sup^.build_no);{+  //23
                    chr(hash_range_to_byte(sup^.hashrange))+CHRNULL+CHRNULL+CHRNULL;} //25
     sup^.hoststr:=int_2_dword_string(sup^.ip)+
                   int_2_word_string(sup^.port);
  exit;
 end else inc(i);
end;


sup:=AllocMem(sizeof(record_cache_hash_supernode));
  sup^.ip:=addr;
  sup^.port:=port;
  sup^.horizon:=horizon;
  sup^.users:=users;
  sup^.files:=files;
  sup^.mega:=mega;
   if last_seen>tempo then sup^.last:=0 else sup^.last:=tempo-last_seen; //usiamo last seen microsecondi che ci hanno inviato loro, distinguiamo tra server nuovi e vecchi
  sup^.mine:=false;
  sup^.build_no:=build_no;
 // sup^.seen:=1;
    sup^.serialize:=int_2_dword_string(sup^.ip)+
                    int_2_word_string(sup^.port)+
                    int_2_word_string(sup^.horizon)+
                    int_2_word_string(sup^.users)+
                    int_2_dword_string(0)+     // latency
                    int_2_dword_string(sup^.files)+
                    int_2_dword_string(sup^.mega)+
                    int_2_word_string(sup^.build_no);{+
                    chr(hash_range_to_byte(sup^.hashrange))+CHRNULL+CHRNULL+CHRNULL; }
    sup^.hoststr:=int_2_dword_string(sup^.ip)+
                  int_2_word_string(sup^.port);
  hash_supernodes.add(sup);


except
end;
end;


procedure tthread_cache.cache_handler_login_ok(cache:tcache); //ci siamo connessi noi e questa è la risposta positiva
begin
try

if length(cache.in_buffer)<20 then begin
 cache.disconnected:=true;
 exit;
end;

if not comparemem(@cac_encrypted_login_key[1],@cache.in_buffer[1],20) then begin   //check login str 20char long
 cache.disconnected:=true;
 exit;
end;

 cache.serialize:=int_2_dword_string(cache.ip)+
                  int_2_word_string(cache.port);
                  
cache.iveconnected:=true;//sono stato io a connettermi, lui non è dietro a firewall!

cache.handshaked:=true;
cache.logtime:=tempo;
cache.last_pong:=tempo;

sync_my_supernodes(cache);
sync_my_channels(cache);
send_back_cache(cache,MSG_CACHE_ENDOFSYNC,'1'); //così sa quando ha tutto di me

except
end;
end;

procedure tthread_cache.sync_my_channels(cache:tcache);
var i:integer;
channel:precord_cache_channel;
begin
try

 for i:=0 to channels.count-1 do begin
  channel:=channels[i];
  if not channel^.mine then continue;  //comunichiamo solo i nostri...
      send_back_cache(cache,MSG_CACHE_ADD_CHANNEL,channel^.serialize);
 end;

except
end;
end;

procedure tthread_cache.sync_my_supernodes(cache:tcache);
var i:integer;
hash_supernode:precord_cache_hash_supernode;
//key_supernode:precord_cache_key_supernode;
begin
try
  //importante da 2937 (38) metto last seen per prevenire stale entries più possibile e consentire synch pesante in link nuovi caches

 for i:=0 to hash_supernodes.count-1 do begin
  hash_supernode:=hash_supernodes[i];

 // if i>1000 then
   if not hash_supernode.mine then continue;  //comunichiamo solo i nostri...
   
  //if hash_supernode^.last>TIMEOUT_PONG_CACHE_SERVER then continue;  //non mandiamo scaduti

       send_back_cache(cache,MSG_CACHE_ADD_HASH_SUPERNODE,hash_supernode^.serialize+
                                                          int_2_dword_string(tempo-hash_supernode^.last));  //last seen per impedire propagazione selvaggia
 // if i>=3000 then break;//max 3000, pensiamo al futuro
 end;


except
end;
end;

procedure tthread_cache.CheckSync;
var t:integer;
begin
 t:=(GetTickCount xor 50) mod 200;
 if t>150 then exit;
 if t<10 then sleep(25)
 else if t<40 then sleep(10)
 else if t<80 then sleep(3)
 else sleep(0);
 //last_sync_check:=GetTickCount;
end;



function tthread_cache.probe_sanity_socket(socket:integer):boolean;
var er:integer;
buffer:array[0..1] of char;
begin
if not TCPSocket_CanRead(socket,0,er) then begin
   result:=((er=0) or (er=WSAEWOULDBLOCK));
end else begin
 TCPSocket_RecvBuffer(socket,@buffer,2,er);
 result:=((er=0) or (er=WSAEWOULDBLOCK));
end;
end;


procedure tthread_cache.ConnManage; //recei
var
i,er,len:integer;
connection:TConnection;
cache:Tcache;
len_payload,to_read:word;
begin
try

i:=0;
 while (i<connections.count) do begin
   connection:=connections[i];

   if connection.state=STATE_DISCONNECTED then begin //offline  unico punto di rimozione di cache server!
      connections.delete(i);
       connection.free;
    continue;
   end;

   if tempo-connection.last>30000 then begin //got asleep?
    if connection.state=STATE_SUPERNODE_CHECKING_ACCEPTPORT then Dec(outGoingConnections);
    connection.state:=STATE_DISCONNECTED;
    inc(i);
    continue;
   end;



 case connection.state of

    STATE_FLUSHING_CHANNELLIST:begin  // send channellist, take it from db on disk
                            if not TcpSocket_CanWrite(connection.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then connection.state:=STATE_DISCONNECTED;
                             inc(i);
                             continue;
                            end;

                            if connection.positionStreamChannelList>=stream_channels.size then begin
                             connection.last:=tempo;
                             connection.state:=STATE_QUIT;
                             inc(i);
                             continue;
                            end;

                            stream_channels.position:=connection.positionStreamChannelList;
                            to_read:=200;
                            if stream_channels.position+to_read>stream_channels.size then to_read:=stream_channels.size-stream_channels.position;
                            len:=stream_channels.read(buffer_ricezione[0],to_read);
                            if len=0 then begin
                             connection.last:=tempo;
                             connection.state:=STATE_QUIT;
                             inc(i);
                             continue;
                            end;
                            TcpSocket_SendBuffer(connection.socket,@buffer_ricezione[0],len,er);
                            if er=WSAEWOULDBLOCK then begin
                             inc(i);
                             continue;
                            end;
                            if er<>0 then begin
                             connection.state:=STATE_DISCONNECTED;
                             inc(i);
                             continue;
                            end;
                            inc(connection.positionStreamChannelList,len);
                            connection.last:=tempo;
                            if connection.positionStreamChannelList>=stream_channels.size then begin
                              connection.state:=STATE_QUIT;
                            end;

    end;


    STATE_FLUSHINSUPERNODES:begin  // send supernodes to clients...
                            if not TcpSocket_CanWrite(connection.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then connection.state:=STATE_DISCONNECTED;
                             inc(i);
                             continue;
                            end;
                           if len_buffer_supernodes<50 then Fill_Supernodes;
                           if len_buffer_supernodes<1 then begin
                            connection.state:=STATE_QUIT;
                            inc(i);
                            continue;
                           end;
                           TcpSocket_SendBuffer(connection.socket,@buffer_supernodes,len_buffer_supernodes,er);
                           if er=WSAEWOULDBLOCK then begin
                            inc(i);
                            continue;
                           end;
                           if er<>0 then begin
                             connection.state:=STATE_DISCONNECTED;
                             inc(i);
                             continue;
                           end;
                            connection.last:=tempo;
                            connection.state:=STATE_QUIT;
                       end;


    STATE_QUIT:begin  // just wait and quit
                if tempo-connection.last>10000 then begin
                    connection.state:=STATE_DISCONNECTED;
                    inc(i);
                    continue;
                end;
                if not TCPSocket_CanRead(connection.socket,0,er) then begin
                 if ((er<>0) and (er<>WSAEWOULDBLOCK)) then connection.state:=STATE_DISCONNECTED;
                 inc(i);
                 continue;
                end;
                len:=TCPSocket_RecvBuffer(connection.socket,@buffer_ricezione[0],1,er);
                if er=WSAEWOULDBLOCK then begin
                 inc(i);
                 continue;
                end;
                connection.state:=STATE_DISCONNECTED;  //has received something, drop it now
                inc(i);
                continue;
          end;

          
    STATE_FLUSHANDQUIT:begin // flush out_buffer, then go to quit state
                         if length(connection.out_buffer)=0 then begin
                          connection.state:=STATE_DISCONNECTED;
                          inc(i);
                          continue;
                         end;
                         TCPSocket_SendBuffer(connection.socket,@connection.out_buffer[1],length(connection.out_buffer),er);
                         if er=WSAEWOULDBLOCK then begin
                          inc(i);
                          continue;
                         end;
                         if er<>0 then begin
                            connection.state:=STATE_DISCONNECTED;
                            inc(i);
                            continue;
                         end;
                         connection.last:=tempo;
                         connection.state:=STATE_QUIT;
               end;


     STATE_RECEIVE_PAYLOAD_THEN_QUIT,            // receive payload_len then either go to quit state or to flush_andquit
     STATE_RECEIVE_PAYLOAD_THEN_FLUSHANDQUIT:begin
                             if not TCPSocket_CanRead(connection.socket,0,er) then begin
                              if ((er<>0) and (er<>WSAEWOULDBLOCK)) then connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                             end;
                             len:=TCPSocket_RecvBuffer(connection.socket,@buffer_ricezione[0],connection.len_payload,er);
                             if er=WSAEWOULDBLOCK then begin
                              inc(i);
                              continue;
                             end;
                             if er<>0 then begin
                              connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                             end;
                             if len<>connection.len_payload then begin // all at once
                              connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                             end;
                             connection.last:=Tempo;
                             if connection.state=STATE_RECEIVE_PAYLOAD_THEN_QUIT then begin
                              connection.state:=STATE_QUIT ;
                             end else connection.state:=STATE_FLUSHANDQUIT;
                 end;


    STATE_CACHECANDIDATE_RECEIVINGFIRSTLOG_PAYLOAD,
    STATE_SUPERNODECANDIDATE_RECEIVINGFIRSTLOG_PAYLOAD,
    STATE_RECEIVING_CHATSERVERPAYLOAD:begin  // receive payloads then flush first_log replies
                             if not TCPSocket_CanRead(connection.socket,0,er) then begin
                              if ((er<>0) and (er<>WSAEWOULDBLOCK)) then connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                             end;
                             len:=TCPSocket_RecvBuffer(connection.socket,@buffer_ricezione[0],connection.len_payload,er);
                             if er=WSAEWOULDBLOCK then begin
                              inc(i);
                              continue;
                             end;
                             if er<>0 then begin
                              connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                             end;
                             if len<>connection.len_payload then begin // all at once
                              connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                             end;
                             connection.last:=Tempo;
                             if connection.state=STATE_CACHECANDIDATE_RECEIVINGFIRSTLOG_PAYLOAD then connection.state:=STATE_CACHECANDIDATE_FLUSHING_FIRSTLOG                              else
                               if connection.state=STATE_SUPERNODECANDIDATE_RECEIVINGFIRSTLOG_PAYLOAD then connection.state:=STATE_SUPERNODECANDIDATE_FLUSHING_FIRSTLOG
                                else handler_client_im_hosting_chat(connection);
                  end;


    STATE_CACHECANDIDATE_FLUSHING_FIRSTLOG,
    STATE_SUPERNODECANDIDATE_FLUSHING_FIRSTLOG:begin   //flushing first_log reply
                            if connection.state=STATE_CACHECANDIDATE_FLUSHING_FIRSTLOG then begin
                              cac_prelogin_buffer[0]:=131;
                              cac_prelogin_buffer[1]:=0;
                              cac_prelogin_buffer[2]:=MSG_CACHE_MY_UNENCKEY;
                              TCPSocket_SendBuffer(connection.socket,@cac_prelogin_buffer[0],134,er);
                            end else begin
                             cac_prelogin_buffer[0]:=128;
                             cac_prelogin_buffer[1]:=0;
                             cac_prelogin_buffer[2]:=MSG_CACHE_HERE_MY_KEY_TO_SUP;
                             TCPSocket_SendBuffer(connection.socket,@cac_prelogin_buffer[0],131,er); // supernodes don't need my_sc and my_ca
                            end;
                            if er=WSAEWOULDBLOCK then begin
                             inc(i);
                             continue;
                            end;
                            if er<>0 then begin
                              connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                            end;
                            connection.last:=Tempo;
                            if connection.state=STATE_CACHECANDIDATE_FLUSHING_FIRSTLOG then connection.state:=STATE_CACHE_RECEIVE_LOGINREQHEADER
                             else connection.state:=STATE_SUPERNODECANDIDATE_RECEIVESTATSHEADER;
                    end;

                           
    STATE_CACHE_RECEIVE_LOGINREQHEADER,
    STATE_SUPERNODECANDIDATE_RECEIVESTATSHEADER:begin   // receiving 3 bytes here
                             if not TCPSocket_CanRead(connection.socket,0,er) then begin
                              if ((er<>0) and (er<>WSAEWOULDBLOCK)) then connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                             end;
                             len:=TCPSocket_RecvBuffer(connection.socket,@buffer_ricezione[0],3,er);
                             if er=WSAEWOULDBLOCK then begin
                              inc(i);
                              continue;
                             end;
                             if er<>0 then begin
                              connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                             end;
                             if len<>3 then begin
                              connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                             end;
                             move(buffer_ricezione[0],len_payload,2);
                             if len_payload>300 then begin
                              connection.state:=STATE_DISCONNECTED;
                              inc(i);
                              continue;
                             end;
                             connection.last:=tempo;

                            if connection.state=STATE_CACHE_RECEIVE_LOGINREQHEADER then begin
                               if buffer_ricezione[2]<>MSG_CACHE_LOGIN then begin   // message wasn't what we expected
                                connection.state:=STATE_DISCONNECTED;
                                inc(i);
                                continue;
                               end else begin
                                  cache:=TCache.create; // create object now
                                  with cache do begin
                                   ip:=connection.ip;
                                   socket:=connection.socket;
                                   logtime:=tempo;
                                   last_pong:=tempo;
                                   port:=get_ppca(connection.ip);
                                   serialize:=int_2_dword_string(cache.ip)+
                                              int_2_word_string(cache.port);
                                  end;
                                   cache.bytes_in_header:=3;
                                   move(buffer_ricezione[0],cache.header_in[0],3);
                                    caches.add(cache);

                                  connection.socket:=INVALID_SOCKET;  //get read of this object without messing with socket
                                  connection.state:=STATE_DISCONNECTED;
                                  inc(i);
                                  continue;
                               end;
                            end else begin
                               if buffer_ricezione[2]<>MSG_CCACHE_HASH_ADDME_LATEST then begin // message wasn't what we expected
                                connection.state:=STATE_DISCONNECTED;
                                inc(i);
                                continue;
                               end else begin
                                connection.state:=STATE_SUPERNODECANDIDATE_RECEIVESTATSPAYLOAD;
                                connection.len_payload:=len_payload;
                               end;
                            end;
                       end;


                            
    STATE_SUPERNODECANDIDATE_RECEIVESTATSPAYLOAD:begin   // receiving supernode stats payload
                                                   if not TCPSocket_CanRead(connection.socket,0,er) then begin
                                                     if ((er<>0) and (er<>WSAEWOULDBLOCK)) then connection.state:=STATE_DISCONNECTED;
                                                    inc(i);
                                                    continue;
                                                   end;
                                                   len:=TCPSocket_RecvBuffer(connection.socket,@buffer_ricezione[0],connection.len_payload,er);
                                                   if er=WSAEWOULDBLOCK then begin
                                                    inc(i);
                                                    continue;
                                                   end;
                                                   if er<>0 then begin
                                                    connection.state:=STATE_DISCONNECTED;
                                                    inc(i);
                                                    continue;
                                                   end;
                                                   if len<>connection.len_payload then begin
                                                    connection.state:=STATE_DISCONNECTED;
                                                    inc(i);
                                                    continue;
                                                   end;
                                                   connection.last:=tempo;
                                                   handler_hash_supernode_stats(connection);
                                             end;


     STATE_SUPERNODE_CHECKING_ACCEPTPORT:begin
                                          if tempo-connection.last>10000 then begin    // can't connect, flush a negative reply and quit
                                            Dec(outGoingConnections);
                                            connection.state:=STATE_FLUSHANDQUIT;
                                            connection.out_buffer:=chr(1);
                                            TCPSocket_Free(connection.out_socket);
                                            inc(i);
                                            continue;
                                          end;

                                          if not TCPSocket_CanWrite(connection.out_socket,0,er) then begin
                                            if ((er<>0) and (er<>WSAEWOULDBLOCK)) then begin
                                             Dec(outGoingConnections);
                                             connection.state:=STATE_FLUSHANDQUIT;
                                             connection.out_buffer:=chr(1);
                                             TCPSocket_Free(connection.out_socket);
                                            end;
                                           inc(i);
                                           continue;
                                          end;
                                          
                                           Dec(outGoingConnections);
                                           connection.last:=Tempo;
                                           TCPSocket_Free(connection.out_socket);  //ok we achieved connection, supernode is not firewalled, send back positive reply (it's already in out_buf)
                                           connection.state:=STATE_FLUSHANDQUIT;
                                           add_trusted_hash_supernode(connection);  //ok mi sono connesso, mi basta questo
                                        end;
                                        


    STATE_RECEIVINGFIRST:begin  //don't know yet what to do with him
                           if not TCPSocket_CanRead(connection.socket,0,er) then begin
                             if ((er<>0) and (er<>WSAEWOULDBLOCK)) then connection.state:=STATE_DISCONNECTED;
                             inc(i);
                             continue;
                           end;
                           len:=TCPSocket_RecvBuffer(connection.socket,@buffer_ricezione[0],3,er);
                           if er=WSAEWOULDBLOCK then begin
                            inc(i);
                            continue;
                           end;
                           if er<>0 then begin
                            connection.state:=STATE_DISCONNECTED;
                            inc(i);
                            continue;
                           end;
                           if len<>3 then begin
                            connection.state:=STATE_DISCONNECTED;
                            inc(i);
                            continue;
                           end;
                           connection.last:=tempo;
                           switch_first_command(connection);

      end;    // was receiving first command
   end;  // case


   inc(i);
 end;    // while loop



except
end;
end;


procedure tthread_cache.switch_first_command(connection:tconnection);
var
len_payload:word;
begin

 move(buffer_ricezione[0],len_payload,2);

 case buffer_ricezione[2] of

     MSG_CCACHE_NEED_SERV,
     MSG_CCACHE_NEED_SERV_LATEST,
     MSG_CCACHE_NEED_CACHES:begin  // deprecated supernode election poll
        if len_payload>20 then connection.state:=STATE_DISCONNECTED
         else begin
           if len_payload=0 then connection.state:=STATE_FLUSHANDQUIT
            else begin
             connection.state:=STATE_RECEIVE_PAYLOAD_THEN_FLUSHANDQUIT;
             connection.len_payload:=len_payload;
            end;
           connection.out_buffer:=chr(0);
         end;
     end;

     MSG_CCACHE_GIVE_MEIP:begin  // supernode wants his IP
       if len_payload>20 then connection.state:=STATE_DISCONNECTED
         else begin
           if len_payload=0 then connection.state:=STATE_FLUSHANDQUIT
            else begin
             connection.state:=STATE_RECEIVE_PAYLOAD_THEN_FLUSHANDQUIT;
             connection.len_payload:=len_payload;
            end;
           connection.out_buffer:=reverse_order(int_2_dword_string(connection.ip))+chr(0{pref hash range});
         end;
     end;

     MSG_CCACHE_KEY_ADDME,    // very old messages, just drop them
     MSG_CCACHE_KEY_REMOVEME,
     MSG_CCACHE_SEND_KEYSERVS:connection.state:=STATE_DISCONNECTED;


     MSG_CCACHE_HASH_ADDME,
     MSG_CCACHE_HASH_ADDME_NEW:begin // old supernodes messages, send null packet and quit
       if len_payload>100 then connection.state:=STATE_DISCONNECTED
        else begin
           if len_payload=0 then connection.state:=STATE_FLUSHANDQUIT
            else begin
             connection.state:=STATE_RECEIVE_PAYLOAD_THEN_FLUSHANDQUIT;
             connection.len_payload:=len_payload;
            end;
          connection.out_buffer:=PREPACKED_CMD_SHUTDOWN;
        end;
     end;


     MSG_CCACHE_HASH_REMOVEME:begin  // hash server stopped working
      handler_hash_supernode_remove_me(connection.ip);
       if len_payload>50 then connection.state:=STATE_DISCONNECTED
        else begin
           if len_payload>0 then begin
            connection.state:=STATE_RECEIVE_PAYLOAD_THEN_QUIT;
            connection.len_payload:=len_payload;
           end else connection.state:=STATE_QUIT;
        end;
      end;

      MSG_CCACHE_PRELOGIN_LATEST:begin    // client becomes cache server, receive his payload if any then flush firstlog
         if len_payload>50 then connection.state:=STATE_DISCONNECTED
          else begin
            if len_payload>0 then begin  //2991 received wrong...
             connection.state:=STATE_CACHECANDIDATE_RECEIVINGFIRSTLOG_PAYLOAD;
             connection.len_payload:=len_payload;
            end else connection.state:=STATE_CACHECANDIDATE_FLUSHING_FIRSTLOG;
          end;
      end;


      MSG_CCACHE_SEND_SUPERNODES:connection.state:=STATE_FLUSHINSUPERNODES;  // client wants supernodes list
      MSG_CCACHE_SEND_CHANNELS:connection.state:=STATE_FLUSHING_CHANNELLIST; // client wants chat channels
      MSG_CCACHE_CHANNEL_ADDME:begin
                              connection.len_payload:=len_payload;
                              connection.state:=STATE_RECEIVING_CHATSERVERPAYLOAD;
                              end;

      MSG_CCACHE_CHANNEL_REMOVEME:begin    // remove chat server from list
       handler_client_remove_my_chat(connection.ip);
        if len_payload=0 then connection.state:=STATE_QUIT
         else
         if len_payload<50 then begin
          connection.state:=STATE_RECEIVE_PAYLOAD_THEN_QUIT;
          connection.len_payload:=len_payload;
         end else connection.state:=STATE_DISCONNECTED;
      end;

     MSG_CCACHE_SUPPRELOGIN:begin      // client becomes supernode, receive his payload if any then flush firstlog
         if len_payload=0 then connection.state:=STATE_SUPERNODECANDIDATE_FLUSHING_FIRSTLOG else
         if len_payload<50 then begin
           connection.state:=STATE_SUPERNODECANDIDATE_RECEIVINGFIRSTLOG_PAYLOAD;
           connection.len_payload:=len_payload;
         end else connection.state:=STATE_DISCONNECTED;

         
     end else begin  // finally unknown message receive payload if any then flush error message and quit

           if len_payload>50 then connection.state:=STATE_DISCONNECTED
            else begin
               if len_payload>0 then begin
                connection.state:=STATE_RECEIVE_PAYLOAD_THEN_FLUSHANDQUIT;
                connection.len_payload:=len_payload;
               end else connection.state:=STATE_FLUSHANDQUIT;
            end;
          connection.out_buffer:=chr(0); // error!
       end;

  end;   // case of first command received

end;



procedure tthread_cache.handler_client_im_hosting_chat(conn:tconnection); //chat server pong
var
i,h:integer;
channel:precord_cache_channel;
cache:tcache;

users:word;
port:word;
chname:string;
topic:string;                      //i canali entrano senza test
alt_ip:cardinal;

cont:string;
random_cookie:cardinal;
build_no:word;
rawdata,contin:string;
numClones:integer;
begin

if conn.len_payload<9 then begin
   conn.state:=STATE_FLUSHANDQUIT;
   conn.out_buffer:=chr(1);
   exit;
end;

setlength(contin,conn.len_payload);
move(buffer_ricezione[0],contin[1],conn.len_payload);


cont:=d7(contin);
try
 if chars_2_dword(copy(cont,1,4))<>locip_norm+cache_my_tcp_port then begin //this is a CRC to make sure corrent encryption has been used
   conn.state:=STATE_FLUSHANDQUIT;
   conn.out_buffer:=chr(2);
   exit;
  end;


 move(cont[5],users,2);
 move(cont[7],port,2);
  delete(cont,1,8);
 chname:=copy(cont,1,pos(CHRNULL,cont)-1);
 if length(chname)>MAX_CHAT_NAME_LEN then delete(chname,MAX_CHAT_NAME_LEN+1,length(chname));
  delete(cont,1,pos(CHRNULL,cont));
 topic:=copy(cont,1,pos(CHRNULL,cont)-1);
 if length(topic)>MAX_CHAT_TOPIC_LEN then delete(topic,MAX_CHAT_TOPIC_LEN+1,length(topic));
  delete(cont,1,pos(CHRNULL,cont));

 rawdata:='';
 build_no:=0;
 alt_ip:=0;
 random_cookie:=0;

  if length(cont)>=8 then begin
   move(cont[1],alt_ip,4);
   move(cont[5],random_cookie,4);
    if length(cont)>9 then begin
        move(cont[9],build_no,2);
        if length(cont)>10 then begin
          rawdata:=copy(cont,11,length(cont));
          if length(rawdata)>MAX_LEN_CHATRAWDATA then delete(rawdata,MAX_LEN_CHATRAWDATA+1,length(rawdata));
        end;
    end;
  end;




numClones:=0;

 i:=0;
while (i<channels.count) do begin   //se vengo da stessa macchina e stesso ip aggiorno, oppure se uso stesso nome...
channel:=channels[i];

 if channel^.ip<>conn.ip then begin
  inc(i);
  continue;
 end;


 if ((channel^.alt_ip=alt_ip) or (channel^.port=port)) then begin
  channel^.name:=chname;  // update it here 3024+
  channel^.users:=users;
  channel^.topic:=topic;
  channel^.port:=port;
  channel^.ip:=conn.ip;
  channel^.alt_ip:=alt_ip;
  channel^.mine:=true;
  channel^.rawdata:=rawdata;
  channel^.random_cookie:=random_cookie; // update it here 3024+
  if build_no>0 then channel^.build_no:=build_no;   // update it here 3024+
   channel^.serialize:=int_2_dword_string(channel^.ip)+
                       int_2_word_string(channel^.port)+
                       int_2_word_string(channel^.users)+
                       channel^.name+CHRNULL+
                       channel^.topic+CHRNULL+
                       int_2_dword_string(channel^.alt_ip)+
                       int_2_dword_string(channel^.random_cookie)+
                       int_2_word_string(channel^.build_no)+
                       channel^.rawdata;


    if gettickcount-channel^.last<MINUTE then begin
       conn.state:=STATE_FLUSHANDQUIT;
       conn.out_buffer:=chr(5);
       exit;  //evitiamo di floddare il + possibile...
    end;

        for h:=0 to caches.count-1 do begin
         cache:=caches[h];
         if not cache.handshaked then continue;
         send_back_cache(cache,MSG_CACHE_ADD_CHANNEL,channel^.serialize);
        end;
   channel^.last:=gettickcount;
  conn.state:=STATE_FLUSHANDQUIT;
  conn.out_buffer:=chr(0);
     

  exit;
 end else begin
  inc(NumClones);
  inc(i);
 end;
end;

 if NumClones>MAX_CHANNEL_PERIP then exit;

 channel:=AllocMem(sizeof(record_cache_channel));
  channel^.users:=users;
  channel^.topic:=topic;
  channel^.port:=port;
  channel^.alt_ip:=alt_ip;
  channel^.name:=chname;
  channel^.ip:=conn.ip;
  channel^.mine:=true;
  channel^.last:=gettickcount;
  channel^.random_cookie:=random_cookie;
  channel^.rawdata:=rawdata;
  channel^.build_no:=build_no;
   channel^.serialize:=int_2_dword_string(channel^.ip)+
                       int_2_word_string(channel^.port)+
                       int_2_word_string(channel^.users)+
                       channel^.name+CHRNULL+
                       channel^.topic+CHRNULL+
                       int_2_dword_string(channel^.alt_ip)+
                       int_2_dword_string(channel^.random_cookie)+
                       int_2_word_string(channel^.build_no)+
                       channel^.rawdata;
  channels.add(channel);

        for h:=0 to caches.count-1 do begin
         cache:=caches[h];
         if not cache.handshaked then continue;
         send_back_cache(cache,MSG_CACHE_ADD_CHANNEL,channel^.serialize);
        end;

       conn.state:=STATE_FLUSHANDQUIT;
       conn.out_buffer:=chr(0);

  if nobody_dwnldng_chanlist then dump_channels;
except
end;

end;

function tthread_cache.ChatClosesCount(ip:cardinal):integer;
var
i:integer;
channel:precord_cache_channel;
begin
 result:=0;

 for i:=0 to channels.count-1 do begin
  channel:=channels[i];
  if channel^.ip=ip then inc(result);
 end;

end;

function tthread_cache.nobody_dwnldng_chanlist:boolean;
var
i:integer;
conn:tconnection;
begin
result:=true;

 for i:=0 to connections.count-1 do begin
  conn:=connections[i];
  if conn.state=STATE_FLUSHING_CHANNELLIST then begin
   result:=false;
   exit;
   end;
 end;

end;


procedure tthread_cache.handler_client_remove_my_chat(ipC:cardinal); //chat server, logoff
var i,h:integer;
cache:tcache;
channel:precord_cache_channel;
str:string;
begin
try

i:=0;
while (i<channels.count) do begin
 channel:=channels[i];
  if channel^.ip=ipC then begin
    channel^.name:='';
    channel^.topic:='';
    channel^.serialize:='';
    channel^.rawdata:='';
     channels.delete(i);
    FreeMem(channel,sizeof(record_cache_channel));
     str:=int_2_dword_string(ipC);
     for h:=0 to caches.count-1 do begin
      cache:=caches[h];
      if not cache.handshaked then continue;
      send_back_cache(cache,21,str);
     end;
   exit;
  end;
inc(i);
end;


except
end;
end;

procedure tthread_cache.gen_keys;
var
str,str_out:string;
begin

 cac_prelogin_buffer[1]:=0;
  str:=cac_unencrypted_login_key+
       chr(my_ca)+
       int_2_word_string(my_sc);
 str_out:=e3a(str,cache_my_tcp_port);
 move(str_out[1],cac_prelogin_buffer[3],length(str_out));


 cac_encrypted_login_key:=get_crypt_cache_key(cac_unencrypted_login_key);

 cac_encrypted_SUP_login_key:=get_crypt_super_key(cac_unencrypted_login_key);
end;

procedure tthread_cache.put_my_name;
var
str:string;
guid1:tguid;
begin


cocreateguid(guid1);
setlength(str,16);
move(guid1,str[1],16);   // 16
 cac_unencrypted_login_key:=str;

cocreateguid(guid1);
setlength(str,16);
move(guid1,str[1],16);   //32
 cac_unencrypted_login_key:=cac_unencrypted_login_key+str;

cocreateguid(guid1);
setlength(str,16);
move(guid1,str[1],16);   //48
 cac_unencrypted_login_key:=cac_unencrypted_login_key+str;

cocreateguid(guid1);
setlength(str,16);
move(guid1,str[1],16);   //64
 cac_unencrypted_login_key:=cac_unencrypted_login_key+str;

cocreateguid(guid1);
setlength(str,16);
move(guid1,str[1],16);   //80
 cac_unencrypted_login_key:=cac_unencrypted_login_key+str;

cocreateguid(guid1);
setlength(str,16);
move(guid1,str[1],16);   //96
 cac_unencrypted_login_key:=cac_unencrypted_login_key+str;

cocreateguid(guid1);
setlength(str,16);
move(guid1,str[1],16);   //112
 cac_unencrypted_login_key:=cac_unencrypted_login_key+str;

cocreateguid(guid1);
setlength(str,16);
move(guid1,str[1],16);   //128
 cac_unencrypted_login_key:=cac_unencrypted_login_key+str;  //questo viene inviato

 
end;

procedure tthread_cache.dump_channels;
var
i:integer;
connection:TConnection;
channel:precord_cache_channel;
buffer:pointer;
posi:cardinal;
lenW:word;
cmpsize:integer;
buffer_temp:array[0..1023] of byte;
begin
if stream_channels=nil then exit;

  // erase old db
  stream_channels.position:=0;
  stream_channels.size:=0;

if channels.count=0 then exit;

 // disconnect anyone receiving the old list
 for i:=0 to connections.count-1 do begin
  connection:=connections[i];
  if connection.state<>STATE_FLUSHING_CHANNELLIST then continue;
  connection.state:=STATE_DISCONNECTED;
 end;

posi:=0;

 for i:=0 to channels.count-1 do begin
  channel:=channels[i];

       lenW:=length(channel^.serialize);
       move(lenW,buffer_comp[posi],2);
       move(channel^.serialize[1],buffer_comp[posi+2],lenW);

       inc(posi,lenW+2);

    if posi>600 then begin 
      ZCompress(@buffer_comp,posi,buffer,cmpsize,zcMax);//zcdefault);
       lenW:=cmpsize;
       move(lenW,buffer_temp[0],2);
        buffer_temp[2]:=MSG_CCACHE_HERE_CHANNELS;
         move(buffer^,buffer_temp[3],cmpsize);
          stream_channels.write(buffer_temp[0],cmpsize+3);
          FreeMem(buffer,sizeof(cmpSize));
      posi:=0;
    end;
 end;

  if posi>0 then begin
     ZCompress(@buffer_comp,posi,buffer,cmpsize,zcMax);//zcdefault); comprimiamo a 6...contiene testo è molto comprimibile
       lenW:=cmpsize;
       move(lenW,buffer_temp[0],2);
        buffer_temp[2]:=MSG_CCACHE_HERE_CHANNELS;
         move(buffer^,buffer_temp[3],cmpsize);
          stream_channels.write(buffer_temp[0],cmpsize+3);
          FreeMem(buffer,sizeof(cmpSize));
  end;

  buffer_temp[0]:=0;
  buffer_temp[1]:=0;
  buffer_temp[2]:=MSG_CCACHE_ENDOF_CHANNELS;
  stream_channels.write(buffer_temp[0],3);

end;


procedure tthread_cache.Fill_Supernodes;
var
ran,num,i:integer;
str:string;
lenW:word;
hash_supernode:precord_cache_hash_supernode;
cache:TCache;
begin
str:=CHRNULL;


//////////////////////// 2 caches
if caches.count>2 then shuffle_mylist(caches,0);
num:=0;
for i:=0 to caches.count-1 do begin
 cache:=caches[i];
 if not cache.handshaked then continue; //solo autorizzati!
     str:=str+
          chr(11)+
          cache.serialize;//6 bytes
     inc(num);
     if num>=4 then break;
end;


if hash_supernodes.count>0 then shuffle_mylist(hash_supernodes,0); //always shuffle this list every minute
ran:=0;
////////////////////// supernodes
if hash_supernodes.count>200 then ran:=random(hash_supernodes.count-100); 



num:=0;
for i:=ran to hash_supernodes.count-1 do begin
 hash_supernode:=hash_supernodes[i];

  if hash_supernode^.users>(HASH_SUPERNODE_ALLOWED_USERS-50) then continue;

       str:=str+
            chr(1)+
            hash_supernode^.hoststr; //ip+port

 inc(num);
 if num>=28 then break;
end;



lenW:=length(str);
move(lenW,buffer_supernodes[0],2);
buffer_supernodes[2]:=MSG_CCACHE_HERE_SERV;

if lenW>1 then begin
 str:=e7(str);
 move(str[1],buffer_supernodes[3],lenW);
end;

   checksync;

len_buffer_supernodes:=lenW+3;   //3 + 1 + 28 + 196 = 228 bytes, check sizeof(buffer_supernodes)
end;


function tthread_cache.d1(cont:string):string;
var
b2:word;
i:integer;
begin
try

 b2:=a1(my_sc,ord(cont[1]),ff[my_ca]);

 //delete(contr,1,2);// 2 byte fasullo

 move(cont[3],buffer_crypt2[0],length(cont)-2); //copiamo in buffer
 for I := 0 to length(cont)-3 do begin
        buffer_crypt[I] := (buffer_crypt2[I] xor (b2 shr 8));
        b2 := (buffer_crypt2[I] + b2) * 52845 + 22719;
 end;

   setlength(result,length(cont)-2);
   move(buffer_crypt[0],result[1],length(result));

except
result:=''; // errore<------- esce con zero di result
end;
end;

function tthread_cache.get_crypt_cache_key(const unenc_key:string):string;
var
str2,str1:string;
secH:Tsha1;
i:integer;
begin
result:='';
/////////////////////////////////////////////////////////////////////////////////////
str2:=unenc_key;
for i:=1 to 20 do begin
 str1:=chr(i)+str2+chr(255-i);
    secH:=Tsha1.create;
    secH.transform(str1[1],length(str1));
    secH.complete;
 str2:=str2+secH.HashValue;
    secH.free;
end;
delete(str2,513,length(str2));
if length(str2)<512 then exit;

 //now pass to cypher
move(str2[1],buffer_comp[0],sizeof(ac8));

BF479DD2(@buffer_comp[0]);

setlength(str2,sizeof(ac8)+2);
str2[1]:=chr(0);
move(buffer_comp[0],str2[2],sizeof(ac8));
str2[length(str2)]:=chr(255);

  secH:=TSha1.create;
        secH.transform(str2[1],length(str2));
        secH.complete;
 str1:=secH.HashValue;
        secH.free;
 result:=e64(str1,16932);
//////////////////////////////////////////////////////////////////////////////////////////////////////
end;

function tthread_cache.cache_getLoginReq(strIn:string; port:word; var his_ca:byte; var his_sc:word):string;
var
str,his_unenc_key,his_enc_key,strout1:string;
i:integer;
b2:word;
cn:byte;
begin
try

str:=d3a(strIn,port);

his_unenc_key:=copy(str,1,128);


his_ca:=ord(str[129]);
his_sc:=chars_2_word(copy(str,130,2));

his_enc_key:=get_crypt_cache_key(his_unenc_key);

strout1:=his_enc_key+   //20
         int_2_word_string(cache_my_tcp_port)+   //2    22
         chr(my_ca)+                      // 1    23
         int_2_word_string(my_sc)+        // 2    25
         cac_unencrypted_login_key;       //128   153


//PASS to OLD cipher /////////////////////////////////////////////////////////////////////
cn:=random(250)+1; //local ca  evitiamo 0
b2:=a1(his_sc,cn,ff[his_ca]);

    buffer_crypt[0]:=cn;
    buffer_crypt[1]:=random(250)+1;
    move(strout1[1],buffer_crypt[2],length(strout1));

      for I:=2 to length(strout1)+1 do begin //criptiamo
        buffer_crypt[I]:=buffer_crypt[I] xor (b2 shr 8);
        b2:=(buffer_crypt[I] + b2) * 52845 + 22719;
      end;

     setlength(str,length(strout1)+2);
     move(buffer_crypt[0],str[1],length(strout1)+2);
////////////////////////////////////////////////////////////////////////////////////////////



result:=int_2_word_string(length(str))+
                          chr(MSG_CACHE_LOGIN)+
                          str;

except
end;
end;

procedure tthread_cache.cache_handler_loginREQ(cache:Tcache);
var
his_unenc_key,his_enc_key:string;
begin

if length(cache.in_buffer)<153 then begin
 cache.disconnected:=true;
 exit;
end;

try

if not comparemem(@cac_encrypted_login_key[1],@cache.in_buffer[1],20) then begin   //check login str 20char long
 cache.disconnected:=true;
 exit;
end;


delete(cache.in_buffer,1,20);   //delete auth key


 cache.port:=chars_2_word(cache.in_buffer[1]+cache.in_buffer[2]);
 cache.ca:=ord(cache.in_buffer[3]);
 cache.sc:=chars_2_word(cache.in_buffer[4]+cache.in_buffer[5]);
 cache.iveconnected:=false;//è stato lui a connettersi a me
 delete(cache.in_buffer,1,5);

  his_unenc_key:=copy(cache.in_buffer,1,128);  //get his key

  his_enc_key:=get_crypt_cache_key(his_unenc_key);

 cache.in_buffer:='';
 cache.logtime:=tempo;
 cache.last_pong:=tempo;
 cache.BlockingSince:=0;

 cache.serialize:=int_2_dword_string(cache.ip)+
                  int_2_word_string(cache.port);

cache.disconnected:=false;
cache.handshaked:=true;

checksync;

//send ok
send_back_cache(cache,MSG_CACHE_LOGIN_OK,his_enc_key+
                                         build_mia+chr(0)); // 2953 +);


sync_my_supernodes(cache);
sync_my_channels(cache);
send_back_cache(cache,MSG_CACHE_ENDOFSYNC,'1'); //quando mi fa sapere che ha tutto di me

except
end;
end;


procedure tthread_cache.handler_conn_needed_caches(conn:Tconnection; contin:string);
var
build_no:cardinal;
begin
try

 if ((gettickcount-cache_start_time<30*MINUTE) or (caches.count<10)) then begin
   conn.out_buffer:=CHRNULL;
   exit;
 end;

 build_no:=0; //init var
 if length(contin)<4 then begin //no build infos?
    conn.out_buffer:=CHRNULL;
   exit;
 end;

 build_no:=chars_2_dword(copy(contin,1,4));//build_no_discriminations?

   if caches.count<200 then begin   //minimo 150 cache servers, sempre
    conn.out_buffer:=chr(1);
    exit;
   end;
                                                //8000 connessioni(2000) utenti
                                                                                                                           //400
      if ( ((total_hash_users div caches.count)>MAX_USERCONNECTIONS_PER_CACHES) and (lista_available_caches.count<MAX_CACHE_HORIZON)) then begin
        conn.out_buffer:=chr(1);
        exit;
      end;


  conn.out_buffer:=CHRNULL;
except
end;

end;

procedure tthread_cache.handler_conn_needed_server(conn:Tconnection; contin:string; isnew:boolean);
var
build_no:cardinal;  // new client arriva qui con comando MSG_CCACHE_NEED_SERV_LATEST per evitare massflooding di vecchi supernodi
buildage:word;
begin
try


 if ((gettickcount-cache_start_time<20*MINUTE) or (caches.count<10)) then begin
   conn.out_buffer:=CHRNULL;
   exit;
 end;

 build_no:=0; //init var
 if length(contin)<4 then begin
     conn.out_buffer:=CHRNULL;
     exit;
 end;


  build_no:=chars_2_dword(copy(contin,1,4));

  if build_no<2966 then begin //scartiamo versioni con bug potenziale hangup
     conn.out_buffer:=CHRNULL;
     exit;
  end;


  if build_no>65535 then begin
   conn.out_buffer:=CHRNULL;
   exit;
  end;


   if hash_supernodes.count<150 then begin   //minimo 250 supernodi, sempre
    conn.out_buffer:=chr(1);
    exit;
   end;

   if build_no>higher_supernode_build then higher_supernode_build:=build_no;
   buildage:=higher_supernode_build-build_no;
                                                //140

                                                                               //180
      if (total_hash_users div hash_supernodes.count)>MAX_USER_PER_HASH_SUPERNODE_NEW+buildage then begin
        conn.out_buffer:=chr(1);
        exit;
      end;


  conn.out_buffer:=CHRNULL;


except
end;
end;


procedure tthread_cache.handler_wanted_ip(conn:Tconnection);
begin
try

 conn.out_buffer:=reverse_order(int_2_dword_string(conn.ip))+chr(0{pref hash range});  //qui assegno hash_range...viene chiesta una sola volta sta pagina, minor carico nell'effettuare lo scan(se calcoliamo che i cache sono uno per ogni 10 supernodi per ora...) 200/2000

except
end;
end;

function tthread_cache.e7(strin:string):string; // criptazione per i push
var
in1,in2:word;
strtemp:string;
begin             //sia hash che key che chat server criptano come integer il mio ip
     in1:=(integer(locip) and 65535);
     in2:=(integer(locip) div 65536);


strtemp:=e2(copy(strin,7,length(strin)),in1);
strtemp:=e2(strtemp,in2);
strtemp:=e2(strtemp,cache_my_tcp_port);
strtemp:=e2(strtemp,in1);
strtemp:=e2(strtemp,in2);
strtemp:=e2(strtemp,cache_my_tcp_port);

strtemp:=e2(copy(strin,1,6),15872)+strtemp; //4
result:=e2(strtemp,20308);    //3
end;

function tthread_cache.d7(strin:string):string;  //file push
var in1,in2:word;
str:string;
strtemp:string;
begin

try               //sia key sia hash sia chat server mi considerano ipcache:integer
     in1:=(integer(locip) and 65535);
     in2:=(integer(locip) div 65536);

str:=d2(strin,20308);    //3
strtemp:=d2(copy(str,7,length(str)),cache_my_tcp_port); //4
strtemp:=d2(strtemp,in2);  //5
strtemp:=d2(strtemp,in1);   //6
strtemp:=d2(strtemp,cache_my_tcp_port);  //7
strtemp:=d2(strtemp,in2);   //8
strtemp:=d2(strtemp,in1);   //9

//result:=d2(str,15872)+strtemp; //10
result:=d2(copy(str,1,6),15872)+strtemp;
except
result:='';
end;
end;

function tthread_cache.get_crypt_super_key(const unenc_key:string):string;
var
str2,str1:string;
i:integer;
secH:tsha1;
begin
/////////////////////////////////  super to cache and vice versa
str2:=unenc_key;
for i:=1 to 20 do begin
 str1:=chr(i+1)+str2+chr(254-i);
    secH:=Tsha1.create;
    secH.transform(str1[1],length(str1));
    secH.complete;
 str2:=str2+secH.HashValue;
    secH.free;
end;
delete(str2,513,length(str2));

 //now pass to cypher
move(str2[1],buffer_comp[0],sizeof(ac8));

E090216F(@buffer_comp[0]); 

setlength(str2,sizeof(ac8)+2);
str2[1]:=chr(1);
move(buffer_comp[0],str2[2],sizeof(ac8));
str2[length(str2)]:=chr(254);

  secH:=TSha1.create;
        secH.transform(str2[1],length(str2));
        secH.complete;
 str1:=secH.HashValue;
        secH.free;
 result:=e64(str1,16912);   //fun last encryption
/////////////////////////////////
end;

procedure tthread_cache.handler_hash_supernode_stats(conn:Tconnection);
var
port:word;
horizon:word;
users:word;
files,mega:cardinal;
i:integer;
hash_supernode:precord_cache_hash_supernode;

er:integer;
num:integer;
str,str_enc,str_caches:string;
build_no:word;

cache:tcache;
his_unenc_key,his_enc_key:string;

//str1,str2:string;
added:integer;
contin:string;
begin

/////////////////// attenzione una volta che il deploy delle 2955 sarà completo, in questi tre trap mettiamo invio di comando SPEGNI server


if conn.len_payload<164 then begin
  conn.state:=STATE_FLUSHANDQUIT;
  conn.out_buffer:=chr(1);
 exit;
end;



if not comparemem(@cac_encrypted_SUP_login_key[1],@buffer_ricezione[0],20) then begin   //check login str 20char long
  conn.state:=STATE_FLUSHANDQUIT;
  conn.out_buffer:=chr(2);
 exit;
end;

if isAntiP2PIP(conn.ip) then begin
  conn.state:=STATE_FLUSHANDQUIT;
  conn.out_buffer:=chr(13);
 exit;
end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////



setlength(contin,conn.len_payload-20);
move(buffer_ricezione[20],contin[1],length(contin));

contin:=d64(contin,cache_my_tcp_port); //just to obfuscate a little
his_unenc_key:=copy(contin,1,128);



his_enc_key:=get_crypt_super_key(his_unenc_key);


 delete(contin,1,128);
try




files:=0;
mega:=0;
build_no:=0;

move(contin[1],port,2);
move(contin[3],horizon,2);
move(contin[5],users,2);
move(contin[7],build_no,2);
move(contin[9],files,4);
move(contin[13],mega,4);

 if ((build_no<MIN_ALLOWED_BUILD) or (build_no>MAX_ALLOWED_BUILD)) then begin
  horizon:=0;
  mega:=0;
  files:=0;
  conn.state:=STATE_FLUSHANDQUIT;
  conn.out_buffer:=chr(3);
  exit;
 end;

if build_no>2970 then
 if build_no<2980 then begin //crash failures
  horizon:=0;
  mega:=0;
  files:=0;
  conn.state:=STATE_FLUSHANDQUIT;
  conn.out_buffer:=chr(3);
  exit;
 end;

 if build_no>WARNING_BUILD then
  if port=1234 then begin //crash failures
  horizon:=0;
  mega:=0;
  files:=0;
  conn.state:=STATE_FLUSHANDQUIT;
  conn.out_buffer:=chr(3);
  exit;
 end;

 if users>ACCEPT_HARD_LIMIT then begin
  horizon:=0;
  mega:=0;
  files:=0;
  conn.state:=STATE_FLUSHANDQUIT;
  conn.out_buffer:=chr(3);
  exit;
 end;


 if files>MAX_FILES_SHARED_PERSUPERNODE then begin
  horizon:=0;
  mega:=0;
  files:=0;
  conn.state:=STATE_FLUSHANDQUIT;
  conn.out_buffer:=chr(4);
  exit;
 end;

 
str:=his_enc_key+
     chr(1)+  //add supernode
     chr(10)+ //special IP
     chr(1)+ // here your ip
     int_2_dword_string(conn.ip);



if hash_supernodes.count>200 then begin
 i:=random(hash_supernodes.count-100);
end else begin
 if hash_supernodes.count>0 then shuffle_mylist(hash_supernodes,0);
 i:=0;
end;

 i:=0;     /// send hash supernodes max 50!
 num:=0;
  while (i<hash_supernodes.count) do begin
   hash_supernode:=hash_supernodes[i];


    if hash_supernode^.build_no<2970 then begin
      if hash_supernode^.horizon>7000 then begin //supernodes already full
       inc(i);
       continue;
      end;
    end;

   if build_no>=2991 then begin   //newer builds don't connect to to old ones
    if hash_supernode^.build_no<2991 then begin
     inc(i);
     continue;
    end;
   end else begin //older builds don't connect to new ones
    if hash_supernode^.build_no>=2991 then begin
     inc(i);
     continue;
    end;
   end;

   if hash_supernode^.ip=conn.ip then begin // he doesn't need this one ;)
    inc(i);
    continue;
   end;

    str:=str+
         chr(1)+
         hash_supernode^.hoststr; //ip+port
         
    inc(num);
    if num>49 then break; //max 50 supernodes in 10 minutes?
   inc(i);
  end;


                            str:=str+
                                 chr(25)+
                                 int_2_word_string(DECIDED_CLUSTER_SIZE)+
                                 chr(DECIDED_MAX_LINKS)+ //max users in cluster+max links per hash server
                                 chr(26)+
                                 int_2_word_string(DECIDED_THROTTLE_UDP);


  str_caches:='';
  added:=0;
   for i:=0 to caches.count-1 do begin
    cache:=caches[i];
    if not cache.handshaked then continue; //solo autorizzati!
    //if not cache.iveconnected then continue;//solo quelli ai quali ci siamo connessi noi! 2960+
     str_caches:=str_caches+
                 int_2_dword_string(cache.ip); //4 chars solo ip!!
     inc(added);
     if added>=39 then break; //max 40 a clients?
   end;
   
   str:=Str+chr(35)+  //2952+  prima usavo 31 (supernodi nuovi distinguono
            int_2_word_string(length(str_caches))+
            str_caches;

   
 str_enc:=e64(str,cache_my_tcp_port);


 conn.out_buffer:=int_2_word_string(length(str_enc))+
                  chr(MSG_CCACHE_HERE_ALLSERV)+
                  str_enc;

conn.data_sup:=AllocMem(sizeof(record_test_hash_supernode));
  conn.data_sup^.port:=port;
  conn.data_sup^.users:=users;
  conn.data_sup^.horizon:=horizon;
  conn.data_sup^.files:=files;
  conn.data_sup^.mega:=mega;
  conn.data_sup^.build_no:=build_no;

if ((outGoingConnections<10) and (not alreadyRequestedOutGoingConnection(conn.ip))) then begin
 conn.state:=STATE_SUPERNODE_CHECKING_ACCEPTPORT;

 AddRequestedOutGoingConnection(conn.ip);
 inc(outGoingConnections);

 conn.out_socket:=TCPSocket_Create;
 TCPSocket_Block(conn.out_socket,false);
 TCPSocket_Connect(conn.out_socket, ipint_to_dotstring(conn.ip),inttostr(port),er);

end else begin
 conn.state:=STATE_FLUSHANDQUIT;
 add_trusted_hash_supernode(conn);
end;

except
end;
end;

function tthread_cache.alreadyRequestedOutGoingConnection(ip:cardinal):boolean;
var
i:integer;
ip_rec:precord_requested_ip;
begin
result:=false;
 for i:=0 to RequestOutGoingConnections.count-1 do begin
    ip_rec:=RequestOutGoingConnections[i];
    if ip_rec^.ip=ip then begin
     result:=true;
     exit;
    end;
 end;
end;

procedure tthread_cache.AddRequestedOutGoingConnection(ip:cardinal);
var
ip_rec:precord_requested_ip;
begin
 ip_rec:=AllocMem(sizeof(record_requested_ip));
  ip_rec^.ip:=ip;
  ip_rec^.last_seen:=tempo;
   RequestOutGoingConnections.add(ip_rec);
end;

procedure tthread_cache.ExpireRequestedOutGoingConnection; // every 10 seconds
var
i:integer;
ip_rec:precord_requested_ip;
begin

i:=0;
 while (i<RequestOutGoingConnections.count) do begin
    ip_rec:=RequestOutGoingConnections[i];

    if tempo-ip_rec^.last_seen>90000 then begin
      RequestOutGoingConnections.delete(i);
      FreeMem(ip_rec,sizeof(record_requested_ip));
    end else inc(i);

 end;

end;

procedure tthread_cache.handler_hash_supernode_remove_me(ip:cardinal); //csupernode logoff
var
i,h:integer;
hash_supernode:precord_cache_hash_supernode;
cache:tcache;
str:string;
begin
try

i:=0;
while (i<hash_supernodes.count) do begin
 hash_supernode:=hash_supernodes[i];
 if hash_supernode^.ip=ip then begin
  hash_supernode^.serialize:='';
  hash_supernode^.hoststr:='';
  hash_supernodes.delete(i);
  FreeMem(hash_supernode,sizeof(record_cache_hash_supernode));
   str:=int_2_dword_string(ip);
    for h:=0 to caches.count-1 do begin
     cache:=caches[h];
     if not cache.handshaked then continue;
     send_back_cache(cache,MSG_CACHE_REM_HASH_SUPERNODE,str);
    end;
 exit;
 end else inc(i);
end;

except
end;
end;


procedure tthread_cache.drop_already_connected_cache(ip:cardinal);
var i:integer;
cache:tcache;
begin
try

 for i:=0 to caches.count-1 do begin
  cache:=caches[i];
   if cache.ip<>ip then continue;
  cache.disconnected:=true;
 end;

except
end;
end;

function tthread_cache.already_connected_to_cache(ip:cardinal):boolean;
var i:integer;
cache:tcache;
begin
result:=false;
try

 for i:=0 to caches.count-1 do begin
  cache:=caches[i];
   if cache.ip<>ip then continue;
  result:=true;
  exit;
 end;

except
end;
end;

function tthread_cache.count_clones_ip(ip:cardinal):integer;
var i:integer;
conn:tconnection;
begin
result:=0;
try


 for i:=0 to connections.count-1 do begin
  conn:=connections[i];
   if conn.ip<>ip then continue;
  inc(result);
 end;

except
end;
end;

function tthread_cache.is_flooding_conn(ip:cardinal):boolean;
var
ip_antiflood:precord_ip_antiflood;
i:integer;
begin

result:=false;


if anti_flood_list.count>2000 then begin
 result:=true;
 exit;
end;



 for i:=0 to anti_flood_list.count-1 do begin
  ip_antiflood:=anti_flood_list[i];
  if ip_antiflood^.ip<>ip then continue;
   if ip_antiflood^.polled then result:=true else ip_antiflood^.polled:=true;
   exit;
 end;

 ip_antiflood:=AllocMem(sizeof(record_ip_antiflood));
  ip_antiflood^.ip:=ip;
  ip_antiflood^.logtime:=tempo;    //tempo è globale impostato in execute
  ip_antiflood^.polled:=false;
   anti_flood_list.add(ip_antiflood);
end;

procedure tthread_cache.expire_antiflooding_list; //ogni 5 sec?
var i:integer;
ip_antiflood:precord_ip_antiflood;
begin
i:=0;
while (i<anti_flood_list.count) do begin
 ip_antiflood:=anti_flood_list[i];
  if tempo-ip_antiflood^.logtime>MIN_LOG_INTERVAL_CACHE then begin //tempo è globale impostata in execute
   anti_flood_list.delete(i);
   FreeMem(ip_antiflood,sizeof(recorD_ip_antiflood));
  end else inc(i);
end;

end;


procedure tthread_cache.accept;
var
h: TSocket;
ipi:cardinal;
tot:byte;
sin:synsock.TSockAddrIn;
conn:tconnection;
begin


try
tot:=0;
 while server_socket_tcp.CanRead(0) do begin
 try

   h:=server_socket_tcp.Accept;

   if h=SOCKET_ERROR then exit;
   if h=INVALID_SOCKET then exit;

   TCPSocket_Block(h,false);

    if connections.count>400 then begin
        TCPSocket_Free(H);
        continue;
    end;

   sin:=TCPSocket_GetRemoteSin(h);
   ipi:=Sin.sin_addr.S_addr;

      if is_flooding_conn(ipi) then begin
       TCPSocket_Free(H);
       inc(connessioni_rifiutate_flood);
        continue;
      end;


      if count_clones_ip(ipi)>10 then begin //massimo 3 possono essere connessi! client,supernode e chat server...lasciamo margine per ghost quindi arriviamo a 6
       TCPSocket_Free(H);
       continue;
      end;


    // TCPSocket_KeepAlive(h,true);

    conn:=tconnection.create;
     conn.ip:=ipi;
     conn.socket:=h;
     conn.last:=tempo;
       connections.add(conn);

       inc(connessioni_ricevute);

     inc(tot);
     if tot>MAX_ACCEPT_PER_CALL then exit;

    except
    break;
    end;
 end;


 except
 end;
end;

procedure tthread_cache.shutdown;
begin
try

server_socket_tcp.closesocket;
server_socket_tcp.free;

freelists;

if stream_channels<>nil then begin
 FreeHandleStream(stream_channels);
 helper_diskio.deletefileW(data_path+'\Data\TmpChnl.Dat');
end;

except
end;
end;




end.