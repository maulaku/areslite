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

library TcpIpPatcherDll;


uses
  SysUtils,
  Classes,
  TcpIpPatcher in 'TcpIPPatcher.pas';

{$R *.res}


function NeedsPatching:boolean; export;
var
pat:TTcpIpPatcher;
begin
result:=False;

pat:=TTcpIpPatcher.create;

result:=pat.NeedsPatching;

pat.free;
end;

function GetCurrentLimit:integer;
var
pat:TTcpIpPatcher;
begin
result:=0;

pat:=TTcpIpPatcher.create;

pat.LoadDriver;
if pat.IsDriverLoaded then result:=pat.getLimit;
pat.UnloadDriver;

pat.free;
end;

function PatchIt:boolean; export;
var
pat:TTcpIpPatcher;
begin
result:=false;

pat:=TTcpIpPatcher.create;

pat.LoadDriver;
if pat.IsDriverLoaded then begin
 if pat.getLimit<>150 then result:=pat.setlimit(150)
  else result:=True;
 pat.UnloadDriver;
end;

pat.free;
end;

exports NeedsPatching;
exports GetCurrentLimit;
exports PatchIt;

end.
