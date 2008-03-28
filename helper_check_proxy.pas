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
used by control panel->proxy->check connection event...should help user with proxy configuration
}

unit helper_check_proxy;

interface

uses
classes,classes2,blcksock,helper_sockets,windows,winsock,helper_unicode,vars_localiz;

 type
  tthread_checkproxy=class(tthread)
  protected
  procedure execute; override;
   procedure connection_failed;//synch
   procedure connection_succeded;//synch
  end;

implementation

uses
ufrmmain;

procedure tthread_checkproxy.execute;
var
socket:ttcpblocksocket;
tempo:cardinal;
er:integer;
lista:tmystringlist;
ips:string;
begin
freeonterminate:=true;
priority:=tplower;

socket:=ttcpblocksocket.create(true);
 assign_proxy_settings(socket); //per ip interni non usiamo socks

  if socket.FSockSType=ST_Socks4 then begin //se ho sock4 devo fare resolve name to ip
   lista:=tmystringlist.create;  //otteniamo ip reale per cript decript  e per sock4 eventuale
   ResolveNameToIP('www.dyndns.org',lista);
    if lista.count<1 then begin
     lista.free;
     socket.free;
     exit;
    end;
    ips:=lista.strings[0];
   lista.free;
 end else ips:='www.dyndns.org';


  socket.ip:=ips;
  socket.port:=80;
  socket.Connect(ips,'80');
  
  sleep(100);
   tempo:=gettickcount;
  while (gettickcount-tempo<15000) do begin

    er:=TCPSocket_ISConnected(socket);
    if er=WSAEWOULDBLOCK then begin
     sleep(100);
     continue;
    end;
    if er<>0 then begin
      synchronize(connection_failed);
      socket.free;
      exit;
    end;
     synchronize(connection_succeded);
    socket.free;
    exit;
  end;

   synchronize(connection_failed); //timeout
   socket.free;

end;

procedure tthread_checkproxy.connection_failed;//synch
begin
 with ares_frmmain do begin
  lbl_opt_proxy_check.caption:=GetLangStringW(STR_CHECKPROXY_FAILED);
  btn_opt_proxy_check.enabled:=true;
  radiobtn_noproxy.enabled:=true;
  radiobtn_proxy4.enabled:=true;
  radiobtn_proxy5.enabled:=true;
  Edit_opt_proxy_addr.Enabled:=true;
  edit_opt_proxy_login.Enabled:=true;
  edit_opt_proxy_pass.Enabled:=true;
 end;
end;

procedure tthread_checkproxy.connection_succeded;//synch
begin
 with ares_frmmain do begin
  lbl_opt_proxy_check.caption:=GetLangStringW(STR_CHECKPROXY_SUCCEDED);
  btn_opt_proxy_check.enabled:=true;
  radiobtn_noproxy.enabled:=true;
  radiobtn_proxy4.enabled:=true;
  radiobtn_proxy5.enabled:=true;
  Edit_opt_proxy_addr.Enabled:=true;
  edit_opt_proxy_login.Enabled:=true;
  edit_opt_proxy_pass.Enabled:=true;
 end;
end;

end.
