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
chat server/client protocol commands (1 byte)
}

unit const_chatroom_commands;

interface

const

 MSG_CHAT_SERVER_ERROR		              = 0;
 MSG_CHAT_CLIENT_LOGIN		              = 2;
 MSG_CHAT_SERVER_LOGIN_ACK              = 3;
 MSG_CHAT_CLIENT_UPDATE_STATUS          = 4;
 MSG_CHAT_SERVER_UPDATE_USER_STATUS     = 5;
 MSG_CHAT_SERVER_REDIRECT               = 6;
 MSG_CHAT_CLIENT_PUBLIC		              = 10;
 MSG_CHAT_SERVER_PUBLIC		              = 10;
 MSG_CHAT_CLIENT_EMOTE		              = 11;
 MSG_CHAT_SERVER_EMOTE                  = 11;
 MSG_CHAT_SERVER_JOIN			              = 20;
 MSG_CHAT_CLIENT_PVT                    = 25;
 MSG_CHAT_SERVER_ISIGNORINGYOU          = 26;
 MSG_CHAT_SERVER_OFFLINEUSER            = 27;
 MSG_CHAT_SERVER_PART			              = 22;
 MSG_CHAT_SERVER_CHANNEL_USER_LIST	    = 30;
 MSG_CHAT_SERVER_TOPIC		              = 31;
 MSG_CHAT_SERVER_TOPIC_FIRST            = 32;
 MSG_CHAT_SERVER_CHANNEL_USER_LIST_END  = 35;
 MSG_CHAT_SERVER_CHANNEL_USERLIST_CLEAR = 36;
 MSG_CHAT_SERVER_NOSUCH		              = 44;
 MSG_CHAT_CLIENT_IGNORELIST             = 45;
 MSG_CHAT_CLIENT_ADDSHARE               = 50;
 MSG_CHAT_CLIENT_REMSHARE               = 51;
 MSG_CHAT_CLIENT_BROWSE                 = 52;
 MSG_CHAT_SERVER_ENDOFBROWSE            = 53;
 MSG_CHAT_SERVER_BROWSEERROR            = 54;
 MSG_CHAT_SERVER_BROWSEITEM             = 55;
 MSG_CHAT_SERVER_STARTOFBROWSE          = 56;
 MSG_CHAT_CLIENT_SEARCH                 = 60;
 MSG_CHAT_SERVER_SEARCHHIT              = 61;
 MSG_CHAT_SERVER_ENDOFSEARCH            = 62;
 MSG_CHAT_CLIENT_DUMMY                  = 64;
 MSG_CHAT_CLIENT_SEND_SUPERNODES        = 70;
 MSG_CHAT_SERVER_HERE_SUPERNODES        = 70;
 MSG_CHAT_CLIENT_DIRCHATPUSH            = 72;
 MSG_CHAT_SERVER_URL                    = 73;
 MSG_CHAT_CLIENT_COMMAND                = 74;
 MSG_CHAT_SERVER_OPCHANGE               = 75;
 MSG_CHAT_CLIENTCOMPRESSED              = 80;
 MSG_CHAT_CLIENT_AUTHLOGIN              = 82;
 MSG_CHAT_CLIENT_AUTHREGISTER           = 83;
 MSG_CHAT_SERVER_MYFEATURES             = 92;


implementation

end.
