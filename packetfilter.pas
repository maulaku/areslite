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

unit packetFilter;

interface

uses
 classes,windows,sysutils;

 const
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128; // arb.
  {$EXTERNALSYM MAX_ADAPTER_DESCRIPTION_LENGTH}
  MAX_ADAPTER_NAME_LENGTH        = 256; // arb.
  {$EXTERNALSYM MAX_ADAPTER_NAME_LENGTH}
  MAX_ADAPTER_ADDRESS_LENGTH     = 8; // arb.
  {$EXTERNALSYM MAX_ADAPTER_ADDRESS_LENGTH}
  DEFAULT_MINIMUM_ENTITIES       = 32; // arb.
  {$EXTERNALSYM DEFAULT_MINIMUM_ENTITIES}
  MAX_HOSTNAME_LEN               = 128; // arb.
  {$EXTERNALSYM MAX_HOSTNAME_LEN}
  MAX_DOMAIN_NAME_LEN            = 128; // arb.
  {$EXTERNALSYM MAX_DOMAIN_NAME_LEN}
  MAX_SCOPE_ID_LEN               = 256; // arb.
  {$EXTERNALSYM MAX_SCOPE_ID_LEN}
type
  // #include <time.h>
  time_t = Longint;
  {$EXTERNALSYM time_t}

  type
  PIP_MASK_STRING = ^IP_MASK_STRING;
  {$EXTERNALSYM PIP_MASK_STRING}
  IP_ADDRESS_STRING = record
    S: array [0..15] of Char;
  end;
  {$EXTERNALSYM IP_ADDRESS_STRING}
  PIP_ADDRESS_STRING = ^IP_ADDRESS_STRING;
  {$EXTERNALSYM PIP_ADDRESS_STRING}
  IP_MASK_STRING = IP_ADDRESS_STRING;
  {$EXTERNALSYM IP_MASK_STRING}
  TIpAddressString = IP_ADDRESS_STRING;
  PIpAddressString = PIP_MASK_STRING;
//
// IP_ADDR_STRING - store an IP address with its corresponding subnet mask,
// both as dotted decimal strings
//

  PIP_ADDR_STRING = ^IP_ADDR_STRING;
  {$EXTERNALSYM PIP_ADDR_STRING}
  _IP_ADDR_STRING = record
    Next: PIP_ADDR_STRING;
    IpAddress: IP_ADDRESS_STRING;
    IpMask: IP_MASK_STRING;
    Context: DWORD;
  end;
  {$EXTERNALSYM _IP_ADDR_STRING}
  IP_ADDR_STRING = _IP_ADDR_STRING;
  {$EXTERNALSYM IP_ADDR_STRING}
  TIpAddrString = IP_ADDR_STRING;
  PIpAddrString = PIP_ADDR_STRING;
type
  PIP_ADAPTER_INFO = ^IP_ADAPTER_INFO;
  {$EXTERNALSYM PIP_ADAPTER_INFO}
  _IP_ADAPTER_INFO = record
    Next: PIP_ADAPTER_INFO;
    ComboIndex: DWORD;
    AdapterName: array [0..MAX_ADAPTER_NAME_LENGTH + 3] of Char;
    Description: array [0..MAX_ADAPTER_DESCRIPTION_LENGTH + 3] of Char;
    AddressLength: UINT;
    Address: array [0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of BYTE;
    Index: DWORD;
    Type_: UINT;
    DhcpEnabled: UINT;
    CurrentIpAddress: PIP_ADDR_STRING;
    IpAddressList: IP_ADDR_STRING;
    GatewayList: IP_ADDR_STRING;
    DhcpServer: IP_ADDR_STRING;
    HaveWins: BOOL;
    PrimaryWinsServer: IP_ADDR_STRING;
    SecondaryWinsServer: IP_ADDR_STRING;
    LeaseObtained: time_t;
    LeaseExpires: time_t;
  end;
  {$EXTERNALSYM _IP_ADAPTER_INFO}
  IP_ADAPTER_INFO = _IP_ADAPTER_INFO;
  {$EXTERNALSYM IP_ADAPTER_INFO}
  TIpAdapterInfo = IP_ADAPTER_INFO;
  PIpAdapterInfo = PIP_ADAPTER_INFO;
  
    const
  	IN_DIRECTION = $0;
		OUT_DIRECTION = $1;
		ANY_TCPUDP_PORTS = $00;
		ANY_ICMP_TYPES = $ff;
		ANY_ICMP_CODES = $ff;

    FD_FLAGS_NOSYN = $1;
    FILTER_TCPUDP_PORT_ANY=0;
    FILTER_PROTO_ANY=0;
    FILTER_PROTO_TCP=6;

    type
    _PfAddresType=(PF_IPV4,PF_IPV6);
    PFADDRESSTYPE=_PfAddresType;
    PPFADDRESSTYPE=^PFADDRESSTYPE;

    type
    _PF_FILTER_DESCRIPTOR = record
      dwFilterFlags:DWORD;
      dwRule:DWORD;
      pfatType:PFADDRESSTYPE;
      SrcAddr:Pointer;
      SrcMask:Pointer;
      DstAddr:Pointer;
      DstMask:Pointer;
      dwProtocol:DWORD;
      fLateBound:DWORD;
      wSrcPort:WORD;
      wDstPort:WORD;
      wSrcPortHighRange:WORD;
      wDstPortHighRange:WORD;
    end;
    PPF_FILTER_DESCRIPTOR =^PF_FILTER_DESCRIPTOR;
    PF_FILTER_DESCRIPTOR=_PF_FILTER_DESCRIPTOR;

    type
  PFForward_action=(PF_ACTION_FORWARD = 0,
                    PF_ACTION_DROP);

     INTERFACE_HANDLE=hwnd;//=pointer;
    PINTERFACE_HANDLE=^INTERFACE_HANDLE;
     FILTER_HANDLE=hwnd;
    PFILTER_HANDLE=^FILTER_HANDLE;


function lockTCPPort(port:word):boolean;//synch
function UnlockTCPPort:boolean;//synch
Procedure SafeGetNetworkIPS(Lista:TStrings);


var

  pktFltrHandle:thandle;
  interfaces:Tlist;


implementation

uses
 vars_global,synsock,utility_ares,blcksock,classes2;


function UnlockTCPPort:boolean;//synch
type
 pfRemoveFiltersFromInterface=function(ih:INTERFACE_HANDLE; cInFilters:DWORD; pfiltIn:PPF_FILTER_DESCRIPTOR; cOutFilters:DWORD; pfiltOut:PPF_FILTER_DESCRIPTOR):Longint; stdcall;
 PfUnBindInterface=function(ppInterface:INTERFACE_HANDLE): LongInt; stdcall;
 PfDeleteInterface=function(ppInterface:INTERFACE_HANDLE): LongInt; stdcall;
var
reso:longint;
 _PfDeleteInterface:PfDeleteInterface;
_PfUnBindInterface:PfUnBindInterface;
hinter:INTERFACE_HANDLE;
PInt: PINTERFACE_HANDLE;
begin
 result:=false;
try
if pktFltrHandle=0 then exit;//errore, mai impostato filtro

_PfDeleteInterface:=GetProcAddress(pktFltrHandle,'_PfDeleteInterface@4');
if @_PfDeleteInterface=nil then begin
 FreeLibrary(pktFltrHandle);
 exit;
end;

_PfUnBindInterface:=GetProcAddress(pktFltrHandle,'_PfUnBindInterface@4');
if @_PfUnBindInterface=nil then begin
 FreeLibrary(pktFltrHandle);
 exit;
end;


 while (interfaces.count>0) do begin
  PInt:=interfaces[0];
        interfaces.delete(0);
  Hinter:=Pint^;

  reso:=_PfUnBindInterface(Hinter);
  reso:=_PfDeleteInterface(Hinter);
  FreeMem(Pint,sizeof(INTERFACE_HANDLE));
  end;


FreeLibrary(pktFltrHandle);

pktFltrHandle:=0;
FreeAndNil(interfaces);
except
end;

end;

Procedure SafeGetNetworkIPS(Lista:TStrings);
type
PGetAdaptersInfo=function(pAdapterInfo: PIP_ADAPTER_INFO; var pOutBufLen: ULONG): DWORD; stdcall;//name 'GetAdaptersInfo';
var
    PGetAdInf:PGetAdaptersInfo;
    Adapters, Adapter: PIpAdapterInfo;
    Size: ULONG;
    IpAddrString: PIpAddrString;
    AdapterName : String;
    pktFltrHandle:thandle;
begin

  pktFltrHandle:=SafeLoadLibrary('iphlpapi.dll');
  if pktFltrHandle=0 then exit;

   Size := 0;
  PGetAdInf:=GetProcAddress(pktFltrHandle,'GetAdaptersInfo');
  if @PGetAdInf=nil then exit;
  if PGetAdInf(nil, Size) <> ERROR_BUFFER_OVERFLOW then Exit;
  Adapters := AllocMem(Size);
  try
    if PGetAdInf(Adapters,Size)=NO_ERROR then begin
      Adapter := Adapters;

      while Adapter <> nil do begin
        AdapterName := Trim(StrPas(@adapter^.Description));
        IpAddrString := @Adapter^.IpAddressList;

        Lista.Add(IpAddrString^.IpAddress.S);
        while IpAddrString <> nil do IpAddrString := IpAddrString^.Next;
        Adapter := Adapter^.Next;
      end;

    end;
  finally
    FreeMem(Adapters);
  end;
  FreeLibrary(pktFltrHandle);

end;

Procedure GetNetworkIPS(Lista:TStrings);
type
PGetAdaptersInfo=function(pAdapterInfo: PIP_ADAPTER_INFO; var pOutBufLen: ULONG): DWORD; stdcall;//name 'GetAdaptersInfo';
var
    PGetAdInf:PGetAdaptersInfo;
    Adapters, Adapter: PIpAdapterInfo;
    Size: ULONG;
    IpAddrString: PIpAddrString;
    AdapterName : String;
begin
  Size := 0;
  PGetAdInf:=GetProcAddress(pktFltrHandle,'GetAdaptersInfo');
  if @PGetAdInf=nil then exit;
  if PGetAdInf(nil, Size) <> ERROR_BUFFER_OVERFLOW then Exit;
  Adapters := AllocMem(Size);
  try
    if PGetAdInf(Adapters,Size)=NO_ERROR then begin
      Adapter := Adapters;

      while Adapter <> nil do begin
        AdapterName := Trim(StrPas(@adapter^.Description));
        IpAddrString := @Adapter^.IpAddressList;

        Lista.Add(IpAddrString^.IpAddress.S);
        while IpAddrString <> nil do IpAddrString := IpAddrString^.Next;
        Adapter := Adapter^.Next;
      end;

    end;
  finally
    FreeMem(Adapters);
  end;
end;

function lockTCPPort(port:word):boolean;//synch
type
 PfCreateInterface=function(dwName:dword; inAction:PFForward_Action; OutAction:PFForward_Action; UseLog:boolean; MustBeUnique:boolean; ppInterface:pINTERFACE_HANDLE): LongInt; stdcall;
 PfBindInterfaceToIPAddress=function(ppInterface:INTERFACE_HANDLE;pfatType:PFADDRESSTYPE;IPAddress:pointer):LongInt; stdcall;
 PfAddFiltersToInterface=function(ih:INTERFACE_HANDLE; cInFilters:DWORD; pfiltIn:PPF_FILTER_DESCRIPTOR; cOutFilters:DWORD; pfiltOut:PPF_FILTER_DESCRIPTOR; pfHandle:PFILTER_HANDLE):LongInt; stdcall;
 PGetAdaptersInfo=function(pAdapterInfo: PIP_ADAPTER_INFO; var pOutBufLen: ULONG): DWORD; stdcall;
var
 _PfAddFiltersToInterface:PfAddFiltersToInterface;
 _PfCreateInterface:PfCreateInterface;
_PfBindInterfaceToIPAddress:PfBindInterfaceToIPAddress;
 PGetAdInf:PGetAdaptersInfo;

 pfHandle:PFILTER_HANDLE;
 DstMask,SrcMask,SrcAddr,DstAddr:array[0..3] of byte;

 num:cardinal;
 i:integer;
 thisip:cardinal;
 hinter:INTERFACE_HANDLE;
 Pint:PINTERFACE_HANDLE;
  reso:longint;
  ipFlt:PF_FILTER_DESCRIPTOR;
  list:Tstringlist;
begin
 result:=False;

if interfaces<>nil then unLockTCPPort;


try
pktFltrHandle:=SafeLoadLibrary('iphlpapi.dll');
if pktFltrHandle=0 then exit;

_PfCreateInterface:=GetProcAddress(pktFltrHandle,'_PfCreateInterface@24');
if @_PfCreateInterface=nil then begin
 FreeLibrary(pktFltrHandle);
 exit;
end;

_PfBindInterfaceToIPAddress:=GetProcAddress(pktFltrHandle,'_PfBindInterfaceToIPAddress@12');
if @_PfBindInterfaceToIPAddress=nil then begin
 FreeLibrary(pktFltrHandle);
 exit;
end;

_PfAddFiltersToInterface:=GetProcAddress(pktFltrHandle,'_PfAddFiltersToInterface@24');
if @_PfAddFiltersToInterface=nil then begin
 FreeLibrary(pktFltrHandle);
 exit;
end;

PGetAdInf:=GetProcAddress(pktFltrHandle,'GetAdaptersInfo');
if @PGetAdInf=nil then begin
 FreeLibrary(pktFltrHandle);
 exit;
end;


interfaces:=TList.create;


list:=Tstringlist.create;
GetNetworkIPS(List);

for i:=0 to list.count-1 do begin

 thisip:=inet_addr(pchar(list.strings[i]));
 move(thisip,DstAddr,4);

  Pint:=AllocMem(sizeof(INTERFACE_HANDLE));
  reso:=_PfCreateInterface(0,PF_ACTION_FORWARD,PF_ACTION_FORWARD,FALSE,TRUE,Pint);

  interfaces.add(Pint);
  HInter:=Pint^;

  reso:=_PfBindInterfaceToIPAddress(hInter, PF_IPV4, @DstAddr);


   num:=$ffFFffFF;
   move(num,dstMask[0],4);
   num:=0;
   move(num,SrcMask[0],4);
   move(num,SrcAddr[0],4);

     ipFlt.SrcAddr:=@SrcAddr;
     ipFlt.SrcMask:=@SrcMask;
     ipFlt.DstAddr:=@DstAddr;
     ipFlt.DstMask:=@DstMask;

    ipFlt.dwFilterFlags     := FD_FLAGS_NOSYN;
    ipFlt.dwRule            := 0;
    ipFlt.pfatType          := PF_IPV4;
    ipFlt.dwProtocol        := FILTER_PROTO_TCP;//FILTER_PROTO_ANY;
    ipFlt.fLateBound        := 0;
    ipFlt.wSrcPort          := FILTER_TCPUDP_PORT_ANY;
    ipFlt.wDstPort          := port;//port;
    ipFlt.wSrcPortHighRange := ipFlt.wSrcPort;
    ipFlt.wDstPortHighRange := ipFlt.wDstPort;

    reso:=_PfAddFiltersToInterface(hInter,1,@ipFlt,0,nil,@pfHandle);
    result:=(reso=0);
 end;

 list.free;
except
end;
end;

initialization
interfaces:=nil;

finalization
if interfaces<>nil then UnLockTCPPort;

end.




