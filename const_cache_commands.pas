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
 cache server communication
}


unit const_cache_commands;

interface

const
 MSG_CCACHE_HERE_SERVNOTCRYPT                    = 49;
 MSG_CCACHE_NEED_SERV                            = 50; // need server?
 MSG_CCACHE_HERE_SERV                            = 51; // need server?
 MSG_CCACHE_HERE_ALLSERV                         = 52; //send 50 hash server(per link) e all key servers to supernodes!
 MSG_CCACHE_NEED_SERV_LATEST                     = 53; // need server?
 MSG_CCACHE_NEED_CACHES                          = 54; //2957+ client asks whether we need caches or not....
 MSG_CCACHE_PRELOGIN_LATEST                      = 78{55};//client diventa cache...gli mando miei na ecc...in e3a
 MSG_CCACHE_SUPPRELOGIN                          = 67; //prelogin di supernodo che vuole darci le stats 2953+
 MSG_CACHE_HERE_MY_KEY_TO_SUP                    = 68;
 MSG_CCACHE_HASH_ADDME_LATEST                    = 69;
 MSG_CACHE_ADDED                                 = 77;
 MSG_CCACHE_GIVE_MEIP                            = 56;
 MSG_CCACHE_HERE_MYCANDIDATES                    = 58;
 MSG_CCACHE_HERE_MYSTATS                         = 59;
 MSG_CCACHE_HASH_ADDME                           = 60; // server stats
 MSG_CCACHE_HASH_REMOVEME                        = 61;
 MSG_CCACHE_HASH_ADDME_NEW                       = 62; // server stats 2948+
 MSG_CCACHE_KEY_ADDME                            = 65; // server stats
 MSG_CCACHE_KEY_REMOVEME                         = 66; // server stats
 MSG_CCACHE_SEND_SUPERNODES                      = 70; // send me servers(include 2 or 3 caches each time)
 MSG_CCACHE_SEND_CHANNELS                        = 71; // send me channels
 MSG_CCACHE_HERE_CHANNELS                        = 72;
 MSG_CCACHE_ENDOF_CHANNELS                       = 73;
 MSG_CCACHE_SEND_KEYSERVS                        = 74; //client give me kserves extremis
 MSG_CCACHE_HERE_KSERV                           = 75; //cache sending kserves extremis
 MSG_CCACHE_IHAVENT_KSERV                        = 76;
 MSG_CCACHE_CHANNEL_ADDME                        = 80;
 MSG_CCACHE_CHANNEL_REMOVEME                     = 81;
 MSG_CCACHE_STATS                                = 83;
 MSG_CACHE_ENDOFSYNC                             = 84;
 MSG_CACHE_GOTYOURENDOFSYNC                      = 85;
 MSG_CACHE_ADDTHIS_CACHES                        = 98;
 MSG_CACHE_LOGIN_OK                              = 1; //ricevuto login ok, tutto bene!
 MSG_CACHE_LOGIN                                 = 2; //cache al quale ho mandato prelogin vuole connettersi , gli mando login ok
 MSG_CACHE_MY_UNENCKEY                           = 4;
 MSG_CHATCACHE_MY_UNENCKEY                       = 5;//2961+
 MSG_CACHE_ADD_HASH_SUPERNODE                    = 10;
 MSG_CACHE_REM_HASH_SUPERNODE                    = 11;
 MSG_CACHE_ADD_KEY_SUPERNODE                     = 15;
 MSG_CACHE_REM_KEY_SUPERNODE                     = 16;
 MSG_CACHE_ADD_CHANNEL                           = 20;
 MSG_CACHE_REM_CHANNEL                           = 21;
 MSG_CACHE_PONG                                  = 30;
 MSG_CACHE_ADDCHATCACHES                         = 31;



 
//MSG_CCACHE_GIVE_CACHEMECANDIDATES               =57;//indirizzi tutti i candidates...da inserire in database....
//MSG_CACHE_OVERLSTATSTRING                       =99;
//MSG_CACHE_MY_NA                                 =3; //cache mi manda suo ok a prelogin, io gli mando cache_login_req

implementation

end.
