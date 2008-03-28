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
handles NT service, loads ChatServer
}

unit serviceManager;

interface

uses
  SysUtils, Windows, WinSvc;

type

  TServiceManager = class
  private
    ServiceControlManager:SC_Handle;
    ServiceHandle:SC_Handle;
  protected
    function DoStartService(NumberOfArgument: DWORD; ServiceArgVectors: PChar): Boolean;
  public
    function Connect(MachineName: PChar = nil; DatabaseName: PChar = nil; Access: DWORD = SC_MANAGER_ALL_ACCESS): Boolean;  // Access may be SC_MANAGER_ALL_ACCESS
    function OpenServiceConnection(ServiceName: PChar): Boolean;
    function StartService: Boolean; overload; 
    function StopService: Boolean;
    procedure ShutdownService;
    procedure DisableService;
    function GetStatus: DWORD;
    function ServiceRunning: Boolean;
    function ServiceStopped: Boolean;
    function UpdateConfig:boolean;

  end;


implementation

 { TServiceManager }

function TServiceManager.Connect(MachineName, DatabaseName: PChar;
  Access: DWORD): Boolean;
begin
  Result := False;
  { open a connection to the windows service manager }
  ServiceControlManager := OpenSCManager(MachineName, DatabaseName, Access);
  Result := (ServiceControlManager <> 0);
end;

function TServiceManager.OpenServiceConnection(ServiceName: PChar): Boolean;
begin
  Result := False;
  { open a connetcion to a specific service }
  ServiceHandle := OpenService(ServiceControlManager, ServiceName, SERVICE_ALL_ACCESS);
  Result := (ServiceHandle <> 0);
end;

function TServiceManager.UpdateConfig:boolean;
begin
try
ChangeServiceConfig(ServiceHandle,SERVICE_WIN32_OWN_PROCESS or SERVICE_INTERACTIVE_PROCESS,
                    SERVICE_NO_CHANGE,//SERVICE_DEMAND_START,
                    SERVICE_ERROR_NORMAL,nil,nil,
                    nil,nil,
                    nil, //LocalSystem account.,
                    nil,
                    nil);
except
end;

end;

function TServiceManager.StopService: Boolean;
var
  ServiceStatus: TServiceStatus;
begin
  { Stop the service }
  Result := ControlService(ServiceHandle, SERVICE_CONTROL_STOP, ServiceStatus);
end;


procedure TServiceManager.ShutdownService;
var
  ServiceStatus: TServiceStatus;
begin
  { Shut service down: attention not supported by all services }
  ControlService(ServiceHandle, SERVICE_CONTROL_SHUTDOWN, ServiceStatus);
end;

function TServiceManager.StartService: Boolean;
begin
  Result := DoStartService(0, '');
end;


function TServiceManager.GetStatus: DWORD;
var
  ServiceStatus: TServiceStatus;
begin
{ Returns the status of the service. Maybe you want to check this
  more than once, so just call this function again.
  Results may be: SERVICE_STOPPED
                  SERVICE_START_PENDING
                  SERVICE_STOP_PENDING
                  SERVICE_RUNNING
                  SERVICE_CONTINUE_PENDING
                  SERVICE_PAUSE_PENDING
                  SERVICE_PAUSED   }
  Result := 0;
  QueryServiceStatus(ServiceHandle, ServiceStatus);
  Result := ServiceStatus.dwCurrentState;
end;

procedure TServiceManager.DisableService;
begin
  { Implementation is following... }
end;

function TServiceManager.ServiceRunning: Boolean;
begin
  Result := (GetStatus = SERVICE_RUNNING);
end;

function TServiceManager.ServiceStopped: Boolean;
begin
  Result := (GetStatus = SERVICE_STOPPED);
end;

function TServiceManager.DoStartService(NumberOfArgument: DWORD;
  ServiceArgVectors: PChar): Boolean;
var
  err: integer;
begin
  Result := WinSvc.StartService(ServiceHandle, NumberOfArgument, ServiceArgVectors);
end;

end.