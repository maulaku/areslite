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
unit TcpIpPatcher;

interface

uses
 classes,WinSvc,sysutils;

 type
 HWND = type LongWord;
 DWORD = type LongWord;
 BOOL = type LongBool;
 LPCSTR = PAnsiChar;
 FARPROC = Pointer;
   PSecurityAttributes = ^TSecurityAttributes;
  _SECURITY_ATTRIBUTES = record
    nLength: DWORD;
    lpSecurityDescriptor: Pointer;
    bInheritHandle: BOOL;
  end;
  TSecurityAttributes = _SECURITY_ATTRIBUTES;
  SECURITY_ATTRIBUTES = _SECURITY_ATTRIBUTES;

 const
 INVALID_HANDLE_VALUE = DWORD(-1);
 kernel32='kernel32.dll';
 VER_PLATFORM_WIN32_NT = 2;
 GENERIC_READ             = DWORD($80000000);
 GENERIC_WRITE            = $40000000;
 OPEN_EXISTING = 3;
 FILE_ATTRIBUTE_NORMAL    = $00000080;

  ERROR_SERVICE_MARKED_FOR_DELETE = 1072;
  ERROR_SERVICE_EXISTS = 1073;
  ERROR_SERVICE_ALREADY_RUNNING = 1056;

 type
TTcpIpPatcher=class(TObject)
   private
    FDriverLog:string;
    function OpenDeviceHandle:hwnd;
   public
    function NeedsPatching:boolean;
    function RunningInWow64:boolean;
    function IsDriverLoaded:boolean;
    function LoadDriver:boolean;
    function UnloadDriver:boolean;
    function GetLimit:cardinal;
    function SetLimit(NewLimit:cardinal):boolean;
    function GetDriverLog:string;
end;

  type
  _OSVERSIONINFOEXA = record
    dwOSVersionInfoSize:DWORD;
    dwMajorVersion:DWORD;
    dwMinorVersion:DWORD;
    dwBuildNumber:DWORD;
    dwPlatformId:DWORD;
    szCSDVersion:array[0..127] of AnsiChar;
    wServicePackMajor:WORD;
    wServicePackMinor:WORD;
    wSuiteMask:WORD;
    wProductType:BYTE;
    wReserved:BYTE;
   end;
  _OSVERSIONINFOEXW = record
    dwOSVersionInfoSize:DWORD;
    dwMajorVersion:DWORD;
    dwMinorVersion:DWORD;
    dwBuildNumber:DWORD;
    dwPlatformId:DWORD;
    szCSDVersion:array[0..127] of widechar;
    wServicePackMajor:WORD;
    wServicePackMinor:WORD;
    wSuiteMask:WORD;
    wProductType:BYTE;
    wReserved:BYTE;
  end;
  _OSVERSIONINFOEX = _OSVERSIONINFOEXW;
  TOSVersionInfoEXW = _OSVERSIONINFOEXW;
  TOSVersionInfoEX = TOSVersionInfoEXW;
  OSVERSIONINFOEXW = _OSVERSIONINFOExW;
  OSVERSIONINFOEX = OSVERSIONINFOEXW;

  const
  DRIVER_IMAGE_PATH='\tcpip_patcher.sys';
  DRIVER_NAME='tcpip_patcher';
  DEVICE_PATH='\\.\TCPIP_PATCHER';
  PATCHER_DEVICE_NAME_A=DEVICE_PATH;
  LOG_BUFFER_SIZE=3072;
  PATCHER_ERROR_SUCCESS=0;
  PATCHER_ERROR_FAILURE=1;
  FILE_DEVICE_PATCHER=$00000022;
  FILE_DEVICE_UNKNOWN=$00000022;
  METHOD_BUFFERED=0;
  FILE_READ_ACCESS = 1;
  FILE_WRITE_ACCESS = 2;

type
PATCHER_LIMIT_DATA= record
	HalfOpenLimit:DWORD;
	CurrentHalfOpen:DWORD;
	ErrorCode:DWORD;
	LogString:char;
end;


type
  POverlapped = ^TOverlapped;
  _OVERLAPPED = record
    Internal: DWORD;
    InternalHigh: DWORD;
    Offset: DWORD;
    OffsetHigh: DWORD;
    hEvent: THandle;
  end;
  TOverlapped = _OVERLAPPED;
  OVERLAPPED = _OVERLAPPED;

function GetVersionEx(var lpVersionInformation: TOSVersionInfoEX): BOOL; stdcall;
function GetVersionExW(var lpVersionInformation: TOSVersionInfoEX): BOOL; stdcall;
function CloseHandle(hObject: THandle): BOOL; stdcall;
function DeviceIoControl(hDevice: THandle; dwIoControlCode: DWORD; lpInBuffer: Pointer; nInBufferSize: DWORD; lpOutBuffer: Pointer; nOutBufferSize: DWORD; var lpBytesReturned: DWORD; lpOverlapped: POverlapped): BOOL; stdcall;
function GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
function GetModuleHandle(lpModuleName: PChar): HMODULE; stdcall;
function GetModuleHandleA(lpModuleName: PAnsiChar): HMODULE; stdcall;
function GetModuleHandleW(lpModuleName: PWideChar): HMODULE; stdcall;
function GetCurrentProcess: THandle; stdcall;
function CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle; stdcall;
function CreateFileA(lpFileName: PAnsiChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle; stdcall;
function CreateFileW(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle; stdcall;
function GetModuleFileNameW(hModule: HINST; lpFilename: PWideChar; nSize: DWORD): DWORD; stdcall;
implementation

function GetVersionEx; external kernel32 name 'GetVersionExW';
function GetVersionExW; external kernel32 name 'GetVersionExW';
function CloseHandle; external kernel32 name 'CloseHandle';
function DeviceIoControl; external kernel32 name 'DeviceIoControl';
function GetProcAddress; external kernel32 name 'GetProcAddress';
function GetModuleHandle; external kernel32 name 'GetModuleHandleA';
function GetModuleHandleA; external kernel32 name 'GetModuleHandleA';
function GetModuleHandleW; external kernel32 name 'GetModuleHandleW';
function GetCurrentProcess; external kernel32 name 'GetCurrentProcess';
function CreateFile; external kernel32 name 'CreateFileA';
function CreateFileA; external kernel32 name 'CreateFileA';
function CreateFileW; external kernel32 name 'CreateFileW';
function GetModuleFileNameW; external kernel32 name 'GetModuleFileNameW';


function CTL_CODE( DeviceType, Func, Method, Access: DWORD ): DWORD;
begin
  Result:=(DeviceType SHL 16) OR
          (Access     SHL 14) OR
          (Func       SHL  2) OR
          Method;
end;

function IOCTL_PATCHER_GET_LIMIT:cardinal;
begin
 result:=CTL_CODE(FILE_DEVICE_PATCHER, $0801, METHOD_BUFFERED,FILE_READ_ACCESS);
end;

function IOCTL_PATCHER_SET_LIMIT:cardinal;
begin
 result:=CTL_CODE(FILE_DEVICE_PATCHER, $0802, METHOD_BUFFERED,FILE_READ_ACCESS or FILE_WRITE_ACCESS);
end;

function TTcpIpPatcher.GetDriverLog:string;
begin
result:=FDriverLog;
end;

function TTcpIpPatcher.SetLimit(NewLimit:cardinal):boolean;
var
hDevice:hwnd;
LimitData:^PATCHER_LIMIT_DATA;
BytesReturned:DWORD;
Limit:cardinal;
previous_len:integer;
begin
  result:=false;
  Limit:=0;

  hDevice:=OpenDeviceHandle;

	if hDevice=INVALID_HANDLE_VALUE then exit;

	LimitData:=AllocMem(sizeof(PATCHER_LIMIT_DATA) + LOG_BUFFER_SIZE);
    if LimitData=nil then begin
        CloseHandle(hDevice);
        exit;
    end;

    LimitData.HalfOpenLimit:=NewLimit;

    if DeviceIoControl(hDevice, IOCTL_PATCHER_SET_LIMIT,
	                     LimitData,sizeof(PATCHER_LIMIT_DATA),
	                     LimitData,sizeof(PATCHER_LIMIT_DATA) + LOG_BUFFER_SIZE,
	                     BytesReturned,nil) then begin
        if LimitData.ErrorCode=PATCHER_ERROR_SUCCESS then Limit:=LimitData.HalfOpenLimit;
          if BytesReturned>sizeof(patcher_limit_data) then
           FDriverLog:=FdriverLog+strpas(@LimitData^.LogString);
    end;

    freeMem(LimitData);
    CloseHandle(hDevice);
    result:=(Limit=NewLimit);
end;

function TTcpIpPatcher.GetLimit:cardinal;
var
hDevice:hwnd;
i:integer;
LimitData:^PATCHER_LIMIT_DATA;
BytesReturned:DWORD;
Limit:cardinal;
previous_len:integer;
begin
  Limit:=0;
  result:=0;

	hDevice:=OpenDeviceHandle;
  if hDevice=INVALID_HANDLE_VALUE then exit;
  

	LimitData:=AllocMem(sizeof(PATCHER_LIMIT_DATA) + LOG_BUFFER_SIZE);
    if LimitData=nil then begin
        CloseHandle(hDevice);
        exit;
    end;

    if DeviceIoControl(hDevice, IOCTL_PATCHER_GET_LIMIT,
	                     nil, 0,
	                     LimitData,sizeof(PATCHER_LIMIT_DATA) + LOG_BUFFER_SIZE,
	                     BytesReturned,nil) then begin

        if (LimitData.ErrorCode=PATCHER_ERROR_SUCCESS) then begin
         Limit:=LimitData.HalfOpenLimit;
          if BytesReturned>sizeof(patcher_limit_data) then
           FDriverLog:=FdriverLog+strpas(@LimitData^.LogString);
        end;
    end;

    freeMem(LimitData);
    CloseHandle(hDevice);
    result:=Limit;
end;

function TTcpIpPatcher.UnloadDriver:boolean;
var
hService,hSCManager:SC_HANDLE;
ServiceStatus:SERVICE_STATUS;
ServiceDeleted:boolean;
begin
result:=false;

	hSCManager:=OpenSCManager(nil,nil,SC_MANAGER_ALL_ACCESS);
  if hSCManager=0 then exit;


	hService:=OpenService(hSCManager,DRIVER_NAME,SERVICE_ALL_ACCESS);
  if hService=0 then begin
		CloseServiceHandle(hSCManager);
     exit;
  end;

    // stop the service, if this fails we still try to remove it though
	ControlService(hService,SERVICE_CONTROL_STOP,ServiceStatus);

  ServiceDeleted:=true;
	if not DeleteService(hService) then
   ServiceDeleted:=(GetLastError=ERROR_SERVICE_MARKED_FOR_DELETE);


	CloseServiceHandle(hService);
	CloseServiceHandle(hSCManager);
	result:=ServiceDeleted;
end;

function WinCheckH(RetVal: Cardinal): Cardinal;
begin
  if RetVal = 0 then RaiseLastOSError;
  Result := RetVal;
end;

function WideGetModuleFileName(Instance: HModule): WideString;
begin
  SetLength(Result, 260);
  WinCheckH(GetModuleFileNameW(Instance, PWideChar(Result), Length(Result)));
  Result := PWideChar(Result)
end;

function TTcpIpPatcher.LoadDriver:boolean;
var
ImagePath:widestring;
hSCManager,hService:SC_HANDLE;
ServiceRunning:boolean;
ServiceArgVects:pChar;
i:integer;
begin
result:=false;

    if IsDriverLoaded then begin
        result:=true;
        exit;
    end;

    // our driver is for 32 bit only
    if RunningInWow64 then exit;

    ImagePath:=WideGetModuleFileName(0);
    for i:=length(ImagePath) downto 1 do if ImagePath[i]='\' then break;
    delete(imagePath,i,length(imagePath));
    ImagePath:=ImagePath+DRIVER_IMAGE_PATH;

  	hSCManager:=OpenSCManager(0{sMachine},nil,SC_MANAGER_ALL_ACCESS);
    if hSCManager<=0 then exit;

	  hService:=CreateServiceW(hSCManager,
                            DRIVER_NAME,
                            DRIVER_NAME,
                            SERVICE_ALL_ACCESS,
                            SERVICE_KERNEL_DRIVER,
                            SERVICE_DEMAND_START,
                            SERVICE_ERROR_NORMAL,
                            PWideChar(ImagePath),
                            nil,
                            nil,
                            nil,
                            nil,
                            nil);


	if hService=0 then begin
		if GetLastError<>ERROR_SERVICE_EXISTS then begin
			CloseServiceHandle(hSCManager);
			exit;
		end;

        // service is already installed, try to open it
		hService:=OpenService(hSCManager,DRIVER_NAME,SERVICE_ALL_ACCESS);
    if hService=0 then begin
			CloseServiceHandle(hSCManager);
			exit;
	  end;
  end;


    // start service
  ServiceRunning:=true;
	if not StartService(hService,0,ServiceArgVects) then begin
        if GetLastError<>ERROR_SERVICE_ALREADY_RUNNING then begin
            ServiceRunning:=false;
            DeleteService(hService);
        end;
     
  end;

	CloseServiceHandle(hService);
	CloseServiceHandle(hSCManager);
	result:=ServiceRunning;
end;

function TTcpIpPatcher.IsDriverLoaded:boolean;
var
hDevice:hwnd;
begin
	hDevice:=OpenDeviceHandle;
 result:=(hDevice<>INVALID_HANDLE_VALUE);
  if result then CloseHandle(hDevice);
end;

function TTcpIpPatcher.RunningInWow64:boolean;
type
LPFN_ISWOW64PROCESS=function(Hand:Hwnd; Isit:Pboolean):boolean; stdcall;
var
pIsWow64Process:LPFN_ISWOW64PROCESS;
IsWow64:boolean;
begin
result:=false;

    @pIsWow64Process:=GetProcAddress(GetModuleHandle('kernel32'),'IsWow64Process');
    if @pIsWow64Process=nil then exit;

    pIsWow64Process(GetCurrentProcess,@IsWow64);
    result:=IsWow64;
end;

function TTcpIpPatcher.OpenDeviceHandle:Hwnd;
begin
result:=CreateFile(DEVICE_PATH,GENERIC_READ or GENERIC_WRITE,
                   0, Nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0);
end;

function TTcpIpPatcher.NeedsPatching:boolean;
var
    OSVerEx:OSVERSIONINFOEX;
begin
result:=false;

    OSVerEx.dwOSVersionInfoSize:=sizeof(OSVERSIONINFOEX);

    // if this fails we are certainly below XP SP2
    if not GetVersionEx(OSVerEx) then exit;

    // needs to be 2k+ system
    if ((OSVerEx.dwPlatformId <> VER_PLATFORM_WIN32_NT) or (OSVerEx.dwMajorVersion <> 5)) then exit;

    // XP with SP2+
    if ((OSVerEx.dwMinorVersion = 1) and (OSVerEx.wServicePackMajor >= 2)) then begin
        result:=true;
        exit;
    end;

    // Windows Server 2003 with SP1+
    if ((OSVerEx.dwMinorVersion = 2) and (OSVerEx.wServicePackMajor >= 1)) then begin
        result:=true;
        exit;
    end;

    result:=false;
end;

end.