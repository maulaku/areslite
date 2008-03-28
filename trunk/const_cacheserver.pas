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
some constants used by cache server alone
}

unit const_cacheserver;

interface

uses
const_ares,helper_datetime;

  const
   TIMEOUT_PONG_CACHE_SERVER=25*MINUTE;//tempo necessario per mollare supernodo che non pinga o canale di chat
   MAX_USER_PER_HASH_SUPERNODE=110; //poi alzeremo, ma se alziamo ora, i supernodi che non ce la fanno ci stroncano la rete...  2947+  +20 users  25/12/2004
   MAX_USER_PER_HASH_SUPERNODE_NEW=100; //nuovi, esprimo così preferenza e faccio eleggere più nuovi quando possibile          2947+  +20 users

     MAX_USERCONNECTIONS_PER_CACHES=8000; // mille utenti(connessioni) per un cache server  2957+
     MAX_CACHE_HORIZON=400;//hard limit per i caches nella lista available!
   //il valore inoltre dev'essere piùttosto ampio per compensare con supernodi che non funzionano
  // MAX_CACHES_LINKED          =150; //limite d'emergenza...

   iphlpapilib = 'iphlpapi.dll';

    const
  	IN_DIRECTION = $0;
		OUT_DIRECTION = $1;
		ANY_TCPUDP_PORTS = $00;
		ANY_ICMP_TYPES = $ff;
		ANY_ICMP_CODES = $ff;

    FD_FLAGS_NOSYN = $1;
    FILTER_TCPUDP_PORT_ANY=0;
    FILTER_PROTO_ANY=0;
    FILTER_PROTO_TCP=$6;
    
implementation

end.
