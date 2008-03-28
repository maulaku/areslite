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
thread_client ciclically tests client capabilities and upgrade it to supernode/cache server
}

unit node_upgrade;

interface

uses
classes,blcksock,ares_types,windows,
sysutils,winsock;

const
 MIN_UPTIME_SUPERNODE=45;
 MIN_UPTIME_CACHE=720;
 MIN_BYTES_SEC_SUPERNODE=40000;
 MIN_CPU_PER_CACHE=1400;
 MIN_MEM_PER_CACHE=100;
 MIN_CPU_PER_SUPERNODE=1400;
 MIN_MEM_PER_SUPERNODE=120;


procedure can_become_supernode; //synch 15 min
function start_cache_server:boolean;
procedure start_supernode;
function GetCPUSpeed: cardinal;
procedure GetMemStats(var tot:cardinal; var aval:cardinal);


implementation


uses
 ufrmmain,thread_client,
 helper_sockets,const_cache_commands,helper_ares_cacheservers,
 helper_strings,const_ares,const_timeouts,helper_registry,vars_global,
 helper_datetime,thread_supernode,thread_cacheserver;


procedure start_supernode;
begin
  if hash_server=nil then hash_server:=tthread_supernode.create(false);
end;

function start_cache_server:boolean;
begin
  if cache_server=nil then begin
   cache_server:=tthread_cache.create(false);
   result:=true;
  end else result:=False;
end;



procedure GetMemStats(var tot:cardinal; var aval:cardinal);
var
 Status:TMemoryStatus;
begin
 Status.dwLength:=sizeof(TMemoryStatus);
 GlobalMemoryStatus(Status);
 aval:=Status.dwAvailPhys;
 tot:=Status.dwTotalPhys;
end;

function GetCPUSpeed: cardinal;
const
 DelayTime = 500;
var
 TimerHi, TimerLo: DWORD;
 PriorityClass, Priority: Integer;
begin
        PriorityClass := GetPriorityClass(GetCurrentProcess);
        Priority      := GetThreadPriority(GetCurrentThread);

        SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
        SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

        Sleep(10);
        asm
                dw 310Fh
                mov TimerLo, eax
                mov TimerHi, edx
        end;
        Sleep(DelayTime);
        asm
                dw 310Fh
                sub eax, TimerLo
                sbb edx, TimerHi
                mov TimerLo, eax
                mov TimerHi, edx
        end;

        SetThreadPriority(GetCurrentThread, Priority);
        SetPriorityClass(GetCurrentProcess, PriorityClass);

        Result := round(TimerLo / (1000 * DelayTime));
end;


procedure can_become_supernode; //synch     15 min
var
 tot,aval:cardinal;
 int:integer;
begin
try
if Win32Platform<>VER_PLATFORM_WIN32_NT then exit;
if vars_global.socks_type<>SocTNone then exit;

                                                
if vars_global.velocita_up<MIN_BYTES_SEC_SUPERNODE then
 if vars_global.velocita_down<(MIN_BYTES_SEC_SUPERNODE*2) then exit;

if vars_global.hash_server<>nil then exit;


if GetCPUSpeed<MIN_CPU_PER_SUPERNODE then exit;
GetMemStats(tot,aval);
if (aval div MEGABYTE)<MIN_MEM_PER_SUPERNODE then exit;



if ((vars_global.muptime<MIN_UPTIME_SUPERNODE) and
    (gettickcount-vars_global.program_start_time<HOUR)) then exit;


if prendi_cant_supernode then exit; //by user
if vars_global.im_firewalled then exit; // firewalled?

     int:=random(100);
     if (int>=80) and
        (int<=90) and
        ((vars_global.muptime>MIN_UPTIME_CACHE) or (gettickcount-vars_global.program_start_time>DAY)) then start_cache_server
      else start_supernode;

except
end;
end;



end.
