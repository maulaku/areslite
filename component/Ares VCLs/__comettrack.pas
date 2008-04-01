{
 this file is part of Ares
 Copyright (C)2005 Aresgalaxy ( http://aresgalaxy.sourceforge.org )

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
Ares media player trackbar
}

unit comettrack;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ComCtrls,ExtCtrls;

type
 Tcomettrack = class(TPanel)
 private
  FLoaded:boolean;
  FOnChanged: TNotifyEvent;
  FPosition,FMax:integer;
  FOver,FDown:boolean;
  FTrackBarEnabled:boolean;
  FSourceBitmap:graphics.TBitmap;
  FBackGroundBitmap:graphics.TBitmap;
 private


  procedure SetTrackbarEnabled(value:boolean);

  procedure SetPosition(value:integer);
  procedure SetMax(value:integer);
  procedure CMMouseEnter(var Msg:TMessage); message CM_MOUSEENTER;
  procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;

  procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
  procedure DrawTrackBar;
  procedure SetSourceBitmap(value:graphics.TBitmap);
 protected
  procedure loaded; override;
  procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  procedure Paint; override;
 public
  constructor create(AOwner: TComponent); override;
  destructor destroy; override;
 published
  property sourceBitmap:graphics.TBitmap read FSourceBitmap write SetSourceBitmap;
  property max:integer read FMax write SetMax;
  property position:integer read FPosition write SetPosition;
  property trackBarEnabled:boolean read FTrackbarEnabled write SetTrackbarEnabled;
  property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
 end;

procedure Register;

implementation

{$R bmptrackbar.res}

procedure TCometTrack.SetSourceBitmap(value:graphics.TBitmap);
begin

if value=nil then begin   // use internal bitmap
  if FSourceBitmap<>nil then FSourceBitmap.free;
  FSourceBitmap:=graphics.TBitmap.create;
  FSourceBitmap.LoadFromResourceName(hinstance,'BITMAPTRACKBAR');
end else begin      // use external bitmap
  if FSourceBitmap<>nil then FSourceBitmap.free;
  FSourceBitmap:=value;
end;

end;

procedure TCometTrack.loaded;
begin
FLoaded:=true;
end;

procedure TCometTrack.SetTrackbarEnabled(value:boolean);
begin
FTrackbarEnabled:=value;
if not FLoaded then exit;
invalidate;
end;

procedure TCometTrack.DrawTrackBar;
var
rc:trect;
leftProgress:int64;
tempBitmap:graphics.TBitmap;
begin
if not FLoaded then exit;

tempBitmap:=graphics.TBitmap.create;
 tempBitmap.pixelFormat:=pf24Bit;
 tempBitmap.width:=1;
 tempBitmap.height:=10;


bitBlt(tempBitmap.canvas.handle,0,0,tempBitmap.width,tempBitmap.height,
       FSourceBitmap.canvas.handle,0,22,SRCCOPY);

FBackGroundBitmap.canvas.stretchDraw(rect(0,0,clientwidth,10),tempBitmap);

tempBitmap.free;


bitBlt(FBackGroundBitmap.canvas.handle,0,3,7,5,
       FSourceBitmap.canvas.handle,9,18,SRCCopy);
bitBlt(FBackGroundBitmap.canvas.handle,clientwidth-7,3,7,5,
       FSourceBitmap.canvas.handle,9,24,SRCCopy);


if not FTrackbarEnabled then exit;

// draw progress 3 lines
if FPosition>0 then leftProgress:=5+((int64(FPosition) * int64(clientwidth-26)) div int64(FMax))
 else LeftProgress:=5;

FBackGroundBitmap.canvas.brush.color:=$00ffc584;
rc.left:=5;
rc.Top:=4;
rc.bottom:=5;
rc.Right:=leftProgress;
FBackGroundBitmap.canvas.FillRect(rc);

FBackGroundBitmap.canvas.brush.color:=$00cd410f;
rc.Top:=5;
dec(rc.left);
rc.bottom:=6;
rc.Right:=leftProgress+1;
FBackGroundBitmap.canvas.FillRect(rc);

FBackGroundBitmap.canvas.brush.color:=$00ff966e;
rc.Top:=6;
inc(rc.left);
rc.bottom:=7;
rc.Right:=leftProgress;
FBackGroundBitmap.canvas.FillRect(rc);

           if (FDown) or (Fover) then begin
             if FDown then BitBlt(FBackGroundBitmap.canvas.Handle,leftProgress,1,15,8,
                      FSourceBitmap.canvas.handle,1,8,SRCCOPY)
                      else
             if FOver then BitBlt(FBackGroundBitmap.canvas.Handle,leftProgress,1,15,8,
                      FSourceBitmap.canvas.handle,1,0,SRCCOPY);
           end else begin

             BitBlt(FBackGroundBitmap.canvas.Handle,leftProgress,4,16,3,
                    FSourceBitmap.canvas.handle,1,29,SRCCOPY);
           end;


end;


procedure TCometTrack.WMEraseBkgnd(var Msg:TMessage);  //no flicker!
begin
  Msg.Result:=1;
end;

procedure TCometTrack.SetPosition(value:integer);
var
previousPosition:integer;
begin
if not FLoaded then exit;

if value<0 then value:=0;
if value>FMax then value:=FMax;
previousPosition:=FPosition;
FPosition:=value;

if previousPosition=FPosition then exit;
invalidate;

if assigned(FOnChanged) then FOnChanged(self);
end;

procedure TCometTrack.SetMax(value:integer);
begin
if not FLoaded then exit;

if value<=0 then value:=1;
FMax:=value;
FPosition:=0;

invalidate;
end;

procedure TCometTrack.Paint;
begin
if (csDesigning in componentState) then begin
 inherited;
 exit;
end;

if not FLoaded then exit;


 // clientheight:=31;
  FBackGroundBitmap.width:=self.clientwidth;
  FBackGroundBitmap.height:=self.clientheight;

  //DrawCaptions;
  DrawTrackBar;

  canvas.lock;

   BitBlt(canvas.handle,0,0,self.clientwidth,self.clientheight,
          FBackGroundBitmap.canvas.handle,0,0,SRCCOPY);

  canvas.Unlock;
end;

procedure Tcomettrack.MouseDown(Button: TMouseButton; Shift: TShiftState;
X, Y: Integer);
var
PreviousPosition:integer;
dummy:TMouseButton;
begin

if not FTrackbarEnabled then exit;

self.cursor:=crHandpoint;

FDown:=true;
PreviousPosition:=FPosition;

Fposition:=(int64(x-11)*int64(Fmax)) div int64(clientwidth-26);//int64(x*self.max) div (self.width);
if FPosition>FMax then FPosition:=FMax;
if FPosition<0 then FPosition:=0;
invalidate;

if PreviousPosition=FPosition then exit;


 if assigned(FOnChanged) then FOnChanged(self);
end;

procedure Tcomettrack.MouseMove(Shift: TShiftState;X, Y: Integer);
var
PreviousPosition:cardinal;
begin
{
if y<17 then begin
  if ((x>=FPosUrl) and
      (length(FUrlCaption)>0) and
      (length(FUrl)>0) and
      (x<=FPosUrl+FSizeUrlCaption) and
      (Assigned(FOnUrlClick))) then self.cursor:=CrHandpoint
      else self.cursor:=crDefault;
  exit;
end; }

if not FTrackbarEnabled then begin
 self.cursor:=crDefault;
 exit;
end;

self.cursor:=crHandpoint;
if not FDown then exit;


PreviousPosition:=FPosition;

Fposition:=(int64(x-11)*int64(Fmax)) div int64(clientwidth-26);//int64(x*self.max) div (self.width);
if FPosition>FMax then FPosition:=FMax;
if FPosition<0 then FPosition:=0;

if PreviousPosition=FPosition then exit;
invalidate;

 if assigned(FOnChanged) then FOnChanged(self);
end;

procedure Tcomettrack.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
FDown:=false;
invalidate;
end;

procedure Tcomettrack.CMMouseEnter(var Msg:TMessage);
//var
// Form:TCustomForm;
begin
//Form:=GetParentForm(Self);
//if Form<>nil then Form.DefocusControl(Self, true);
FOver:=true;
invalidate;
end;

procedure Tcomettrack.CMMouseLeave(var Msg:TMessage);
begin
FOver:=false;
invalidate;
end;


constructor Tcomettrack.create;
begin
  inherited Create(AOwner);
   parent:=(AOwner as TWInControl);

  FLoaded:=false;
  FSourceBitmap:=nil;

  FBackGroundBitmap:=graphics.TBitmap.create;
   FBackGroundBitmap.pixelFormat:=pf24Bit;
   FBackGroundBitmap.width:=clientwidth;
   FBackGroundBitmap.height:=clientheight;

  FOnChanged:=nil;

  FSourceBitmap:=graphics.TBitmap.create;
  FSourceBitmap.LoadFromResourceName(hinstance,'BITMAPTRACKBAR');

  FOver:=false;
  FDown:=false;
  FMax:=1000;
  FPosition:=0;


  BevelOuter:=bvNone;
  height:=11;

  FTrackbarEnabled:=true;

end;

destructor tcomettrack.destroy;
begin
  FBackGroundBitmap.free;

  FSourceBitmap.free;

  inherited;
end;

procedure Register;
begin
  RegisterComponents('Comet', [Tcomettrack]);
end;


end.
