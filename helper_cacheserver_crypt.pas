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
Ares cacheserver crypt
}

unit helper_cacheserver_crypt;

interface

uses
 classes,classes2,sysutils,winsock,blcksock,windows;

   type
  pac64=^ac64;
  ac64=array[0..63] of int64;

  pac32=^ac32;
  ac32=array[0..127] of cardinal;

  pac16=^ac16;
  ac16=array[0..255] of word;

  pac8=^ac8;
  ac8=array[0..511] of byte;

function ROR1 (value:int64; count:byte):int64;
function ROL1 (value:int64; count:byte):int64;
function ROR2(value:int64; count:byte):int64;
function ROL2(value:int64; count:byte):int64;
procedure BF479DD2(p:pointer);
procedure E75454F4(p:pointer);

 procedure init_vars2;
 procedure check_seconds;


implementation

uses
 thread_cacheserver;


procedure init_vars2;
begin
  //
end;

procedure check_seconds; //ogni secondo
begin
 //
end;


function ROR1 (value:int64; count:byte):int64;
begin
	count:= (count and $ff) mod 32;
	result:= (value shr count) or (value shl (32 - count));
end;

function ROL1 (value:int64; count:byte):int64;
begin
	count:= (count and $ff) mod 32;
	result:= (value shl count) or (value shr (32 - count));
end;

function ROR2(value:int64; count:byte):int64;
begin
result:=((value) shr ((count) and $1f) or ((value) shl (32 - (((count) and $1f)))));
end;

function ROL2(value:int64; count:byte):int64;
begin
result:=((value) shl ((count) and $1f) or ((value) shr (32 - (((count) and $1f)))))
end;


///////////////////////////////////////////////////////////////// CRYPT CACHE /////////////////////////////////////////

procedure BF479DD2(p:pointer);
var num:int64;
begin

 pac8(pchar(p)+323)^[0] := pac8(pchar(p)+323)^[0] + ror2(pac8(pchar(p)+341)^[0] , 3 );
 pac32(pchar(p)+69)^[0] := pac32(pchar(p)+69)^[0] xor $d206;

 if pac16(pchar(p)+1)^[0] > pac16(pchar(p)+239)^[0] then begin
   num:=pac8(pchar(p)+306)^[0]; pac8(pchar(p)+306)^[0]:=pac8(pchar(p)+175)^[0]; pac8(pchar(p)+175)^[0]:=num;
   pac8(pchar(p)+84)^[0] := pac8(pchar(p)+84)^[0] or (pac8(pchar(p)+3)^[0] + $64);
   num:=pac16(pchar(p)+260)^[0]; pac16(pchar(p)+260)^[0]:=pac16(pchar(p)+98)^[0]; pac16(pchar(p)+98)^[0]:=num;
 end;

 pac8(pchar(p)+364)^[0] := pac8(pchar(p)+364)^[0] or ror2(pac8(pchar(p)+13)^[0] , 3 );
 pac32(pchar(p)+86)^[0] := pac32(pchar(p)+86)^[0] or $e2a19c;
 pac64(pchar(p)+323)^[0] := pac64(pchar(p)+323)^[0] + (pac64(pchar(p)+257)^[0] - $dcd12c39fa);
 pac16(pchar(p)+308)^[0] := pac16(pchar(p)+308)^[0] or $3e;
 pac8(pchar(p)+268)^[0] := pac8(pchar(p)+268)^[0] - ror2(pac8(pchar(p)+509)^[0] , 4 );
 num:=pac16(pchar(p)+94)^[0]; pac16(pchar(p)+94)^[0]:=pac16(pchar(p)+213)^[0]; pac16(pchar(p)+213)^[0]:=num;
 pac64(pchar(p)+24)^[0] := pac64(pchar(p)+24)^[0] - (pac64(pchar(p)+56)^[0] + $da870743c3);

 if pac16(pchar(p)+442)^[0] > pac16(pchar(p)+462)^[0] then begin
   pac64(pchar(p)+386)^[0] := pac64(pchar(p)+386)^[0] + $ba4ee6a58e;
   pac64(pchar(p)+243)^[0] := pac64(pchar(p)+243)^[0] + $9096bc2f;
 end;

 num:=pac8(pchar(p)+95)^[0]; pac8(pchar(p)+95)^[0]:=pac8(pchar(p)+181)^[0]; pac8(pchar(p)+181)^[0]:=num;
 pac64(pchar(p)+8)^[0] := pac64(pchar(p)+8)^[0] xor $8a35b7aa;
 pac32(pchar(p)+367)^[0] := pac32(pchar(p)+367)^[0] - $3298;
 if pac32(pchar(p)+434)^[0] < pac32(pchar(p)+408)^[0] then pac64(pchar(p)+306)^[0] := pac64(pchar(p)+306)^[0] - (pac64(pchar(p)+341)^[0] + $9ee0d9aa) else pac8(pchar(p)+401)^[0] := pac8(pchar(p)+401)^[0] + ror1(pac8(pchar(p)+38)^[0] , 2 );
 pac16(pchar(p)+451)^[0] := pac16(pchar(p)+451)^[0] - $ae;

 if pac64(pchar(p)+41)^[0] > pac64(pchar(p)+59)^[0] then begin
   num:=pac32(pchar(p)+74)^[0]; pac32(pchar(p)+74)^[0]:=pac32(pchar(p)+486)^[0]; pac32(pchar(p)+486)^[0]:=num;
   pac8(pchar(p)+93)^[0] := pac8(pchar(p)+93)^[0] xor $32;
 end;


E75454F4(p);

end;

procedure E75454F4(p:pointer);
var num:int64;
begin

 pac16(pchar(p)+148)^[0] := pac16(pchar(p)+148)^[0] + $84;
 pac32(pchar(p)+135)^[0] := pac32(pchar(p)+135)^[0] + (pac32(pchar(p)+357)^[0] xor $060cd4);
 pac64(pchar(p)+76)^[0] := pac64(pchar(p)+76)^[0] or (pac64(pchar(p)+27)^[0] or $4a5ad8f0517f);

 if pac64(pchar(p)+30)^[0] > pac64(pchar(p)+427)^[0] then begin
   pac32(pchar(p)+58)^[0] := pac32(pchar(p)+58)^[0] - $54b952;
   if pac32(pchar(p)+129)^[0] > pac32(pchar(p)+381)^[0] then begin  num:=pac32(pchar(p)+92)^[0]; pac32(pchar(p)+92)^[0]:=pac32(pchar(p)+378)^[0]; pac32(pchar(p)+378)^[0]:=num; end else begin  num:=pac32(pchar(p)+35)^[0]; pac32(pchar(p)+35)^[0]:=pac32(pchar(p)+63)^[0]; pac32(pchar(p)+63)^[0]:=num; end;
   num:=pac32(pchar(p)+273)^[0]; pac32(pchar(p)+273)^[0]:=pac32(pchar(p)+328)^[0]; pac32(pchar(p)+328)^[0]:=num;
 end;

 if pac32(pchar(p)+192)^[0] > pac32(pchar(p)+344)^[0] then pac64(pchar(p)+270)^[0] := pac64(pchar(p)+270)^[0] - $b27f01a7c6dd else begin  num:=pac32(pchar(p)+143)^[0]; pac32(pchar(p)+143)^[0]:=pac32(pchar(p)+38)^[0]; pac32(pchar(p)+38)^[0]:=num; end;
 if pac64(pchar(p)+447)^[0] < pac64(pchar(p)+342)^[0] then begin  num:=pac32(pchar(p)+386)^[0]; pac32(pchar(p)+386)^[0]:=pac32(pchar(p)+300)^[0]; pac32(pchar(p)+300)^[0]:=num; end else pac16(pchar(p)+32)^[0] := pac16(pchar(p)+32)^[0] xor ror2(pac16(pchar(p)+328)^[0] , 2 );
 pac16(pchar(p)+492)^[0] := pac16(pchar(p)+492)^[0] xor ror2(pac16(pchar(p)+143)^[0] , 9 );
 pac64(pchar(p)+214)^[0] := pac64(pchar(p)+43)^[0] xor $7459a7e9fe;
 pac64(pchar(p)+71)^[0] := pac64(pchar(p)+71)^[0] xor $ea4ed50f;
 pac32(pchar(p)+311)^[0] := pac32(pchar(p)+311)^[0] + $f442;
 pac16(pchar(p)+181)^[0] := pac16(pchar(p)+181)^[0] - rol1(pac16(pchar(p)+213)^[0] , 5 );
 pac32(pchar(p)+286)^[0] := pac32(pchar(p)+286)^[0] - $10f4;
 pac64(pchar(p)+186)^[0] := pac64(pchar(p)+186)^[0] xor $8605700c;
 pac8(pchar(p)+405)^[0] := pac8(pchar(p)+405)^[0] + ror2(pac8(pchar(p)+429)^[0] , 6 );
 pac8(pchar(p)+327)^[0] := ror2(pac8(pchar(p)+204)^[0] , 4 );
 pac64(pchar(p)+359)^[0] := pac64(pchar(p)+359)^[0] - $b42909e69af9;

 if pac64(pchar(p)+33)^[0] < pac64(pchar(p)+407)^[0] then begin
   num:=pac32(pchar(p)+197)^[0]; pac32(pchar(p)+197)^[0]:=pac32(pchar(p)+497)^[0]; pac32(pchar(p)+497)^[0]:=num;
   pac8(pchar(p)+64)^[0] := pac8(pchar(p)+64)^[0] - ror2(pac8(pchar(p)+0)^[0] , 6 );
   pac64(pchar(p)+368)^[0] := pac64(pchar(p)+368)^[0] - $18538e64;
 end;


end;


end.