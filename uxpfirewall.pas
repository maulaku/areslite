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

unit uxpfirewall;

interface

uses
 ActiveX,ComObj,Variants;

 const
  NET_FW_PROFILE_DOMAIN      =  0;
  NET_FW_PROFILE_STANDARD    =  1;

const
  NET_FW_IP_PROTOCOL_TCP     = 6;
  NET_FW_IP_PROTOCOL_UDP     = 17;

const
  NET_FW_SCOPE_ALL           =  0;

const
  NET_FW_IP_VERSION_ANY      =  2;

procedure OpenPort(port:word);

var
 ovMgr:OleVariant;
 ovProfile:OleVariant;
 ovPort:OleVariant;

implementation

procedure OpenPort(port:word);
begin

  // Create manager interface
  ovMgr:=CreateOleObject('HNetCfg.FwMgr');

     // Get local profile interface
     ovProfile:=ovMgr.LocalPolicy.CurrentProfile;

        // Create new port interface
        ovPort:=CreateOleObject('HNetCfg.FwOpenPort');

           // Set port properties
           ovPort.Port:=port;
           ovPort.Name:='AresChatServer';
           ovPort.Scope:=NET_FW_SCOPE_ALL;
           ovPort.IpVersion:=NET_FW_IP_VERSION_ANY;
           ovPort.Protocol:=NET_FW_IP_PROTOCOL_TCP;
           ovPort.Enabled:=True;


              // Add to globally open ports
         ovProfile.GloballyOpenPorts.Add(ovPort);

// Remove from globally open ports
// ovProfile.GloballyOpenPorts.Remove(port, NET_FW_IP_PROTOCOL_TCP);
 ovPort:=Unassigned;
 ovProfile:=Unassigned;
 ovMgr:=Unassigned;
end;

end.
