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
 TCmtUrlClickEvent = procedure(Sender: TObject; const URLText: String; Button: TMouseButton) of object;

type
 Tcomettrack = class(TPanel)
 private
  FLoaded:boolean;
  FOnChanged,FOnCaptionClick: TNotifyEvent;
  FPosition,FMax:integer;
  FOver,FDown:boolean;
  FTimeCaption,FUrl:string;
  FPosUrl,FPosTimeCaption,FMaxWidthCaption,FSizeUrlCaption:integer;
  FCaption,FUrlCaption:widestring;
  FOnUrlClick:TCmtUrlClickEvent;
  FTrackBarEnabled:boolean;
  FLastposTimeCaption:integer;
  FSourceBitmap:graphics.TBitmap;
  FBackGroundBitmap:graphics.TBitmap;
 private
  constructor create(AOwner: TComponent); override;
  destructor destroy; override;
  procedure loaded; override;
  procedure SetTimeCaption(const value:string);
  procedure SetTrackbarEnabled(value:boolean);
  procedure SetUrlCaption(const value:widestring);
  procedure SetUrl(const value:string);
  procedure SetwCaption(const value:widestring);
  procedure SetPosition(value:integer);
  procedure SetMax(value:integer);
  procedure CMMouseEnter(var Msg:TMessage); message CM_MOUSEENTER;
  procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
  procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
  procedure InvalidateCaption;
  procedure drawCaptionBackGround(doCaption:boolean=true; DoUrlCaption:boolean=true; DoTimeCaption:boolean=true);
  procedure InvalidateTimeCaption;
  procedure InvalidateUrlCaption;
  procedure DrawCaptions(doCaption:boolean=true; DoUrlCaption:boolean=true; DoTimeCaption:boolean=true);
  procedure DrawTrackBar;
  procedure SetSourceBitmap(value:graphics.TBitmap);
  procedure RecalcPositions;
  procedure Paint; override;

 published
  property sourceBitmap:graphics.TBitmap read FSourceBitmap write SetSourceBitmap;
  property url:string read FUrl write SetUrl;
  property urlCaption:widestring read FUrlCaption write SetUrlCaption;
  property wcaption:widestring read FCaption write SetwCaption;
  property TimeCaption:string read FTimeCaption write SetTimeCaption;
  property max:integer read FMax write SetMax;
  property position:integer read FPosition write SetPosition;
  property trackBarEnabled:boolean read FTrackbarEnabled write SetTrackbarEnabled;
  property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  property OnUrlClick:TCmtUrlClickEvent read FOnUrlClick write FOnUrlClick;
  property OnCaptionClick:TNotifyEvent read FOnCaptionClick write FOnCaptionClick;
 end;

procedure Register;

implementation

{$R bitmapTrackbar.res}

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


procedure TCometTrack.SetTimeCaption(const value:string);
begin
if not FLoaded then exit;

FTimeCaption:=value;
{
canvas.lock;
 RecalcPositions;
 DrawCaptionBackGround(false,false,true);
 invalidateTimeCaption;
canvas.Unlock; }
invalidate;

end;

procedure TCometTrack.SetwCaption(const value:widestring);
begin
FCaption:=value;
if not FLoaded then exit;
invalidate;
end;

procedure TCometTrack.SetUrlCaption(const value:widestring);
begin
FUrlCaption:=value;
if not FLoaded then exit;
invalidate;
end;

procedure TCometTrack.SetUrl(const value:string);
begin

FUrl:=value;
if length(FUrlCaption)=0 then FUrlCaption:=FUrl;

if not FLoaded then exit;
invalidate;
end;

procedure TCometTrack.DrawCaptions(doCaption:boolean=true; DoUrlCaption:boolean=true; DoTimeCaption:boolean=true);
begin

RecalcPositions;

DrawCaptionBackGround(doCaption,doUrlCaption,DoTimeCaption);
 if doCaption then invalidateCaption;
 if dourlCaption then InvalidateUrlCaption;
 if DoTimeCaption then invalidateTimeCaption;

end;

procedure TCometTrack.RecalcPositions;
var
size:tsize;
FSizeTimeCaption:integer;
begin
if not FLoaded then exit;

  FBackGroundBitmap.canvas.font.name:='Tahoma';
  FBackGroundBitmap.canvas.font.size:=8;
  FBackGroundBitmap.canvas.font.style:=[];

  // get width of caption
  if length(FCaption)>0 then begin
   size.cX:=0;
   size.cY:=0;
   Windows.GetTextExtentPointW(FBackGroundBitmap.canvas.handle, PWideChar(FCaption), Length(FCaption), size);
   FMaxWidthCaption:=size.cx+10;
  end else FMaxWidthCaption:=0;

  FLastposTimeCaption:=FposTimeCaption;
  if length(FTimeCaption)>0 then begin
   size.cX:=0;
   size.cY:=0;
   Windows.GetTextExtentPoint(FBackGroundBitmap.canvas.handle, PChar(FTimeCaption), Length(FTimeCaption), size);
   FposTimeCaption:=(clientwidth-3)-size.cx;
   FSizeTimeCaption:=size.cx;
  end else begin
   FPosTimeCaption:=0;
   FSizeTimeCaption:=0;
  end;

  if ((length(FUrlCaption)>0) and (length(FUrl)>0)) then begin
   FBackGroundBitmap.canvas.font.style:=[fsUnderline];
   size.cX:=0;
   size.cY:=0;
   Windows.GetTextExtentPointW(FBackGroundBitmap.canvas.handle, PwideChar(FUrlCaption), Length(FUrlCaption), size);
   if FposTimeCaption>0 then FposUrl:=(FposTimeCaption-3)-size.cx
    else FPosUrl:=(clientwidth-3)-size.cx;
   FSizeUrlCaption:=size.cx;
   if clientwidth<FPosUrl+FSizeUrlCaption then FSizeUrlCaption:=clientwidth-FPosUrl; // windows is too small to show UrlCaption, resize accordingly
  end else begin
   FSizeUrlCaption:=0;
   FPosUrl:=0;
  end;

  if ((FmaxWidthCaption+5>FPosUrl) and (FPosUrl>0)) then FMaxWidthCaption:=FPosUrl-5; // caption overlapping URL
  if ((FMaxWidthCaption+5>FposTimeCaption) and (FPosTimeCaption>0)) then FMaxWidthCaption:=FposTimeCaption-5; // caption overlapping Timecaption
  if clientwidth<5+FMaxWidthCaption+5+FSizeUrlCaption+5+FSizeTimeCaption then FMaxWidthCaption:=(clientwidth-15)-(FSizeUrlCaption+FSizeTimeCaption);
  if FPosUrl>FMaxWidthCaption+5 then FPosUrl:=FMaxWidthCaption+5; // keep Url close to caption
  if FPosUrl<5 then FPosUrl:=5;

end;


procedure TCometTrack.InvalidateTimeCaption;
var
rc:trect;
begin
if not FLoaded then exit;

if length(FTimeCaption)=0 then exit;

  FBackGroundBitmap.canvas.font.name:='Tahoma';
  FBackGroundBitmap.canvas.font.size:=8;
  FBackGroundBitmap.canvas.font.style:=[];
  FBackGroundBitmap.canvas.font.color:=clwhite;


   rc.left:=FposTimeCaption;
   rc.right:=clientWidth-3;
   rc.top:=0;
   rc.bottom:=clientHeight;

  SetBkMode(FBackGroundBitmap.canvas.Handle, TRANSPARENT);
  Windows.ExtTextOut(FBackGroundBitmap.canvas.Handle, FposTimeCaption, 4, ETO_CLIPPED, @Rc, PChar(FTimeCaption),Length(FTimeCaption), nil);
end;

procedure TCometTrack.InvalidateUrlCaption;
var
rc:trect;
begin
if not FLoaded then exit;

if ((length(FUrlCaption)=0) or (length(FUrl)=0)) then exit;

  FBackGroundBitmap.canvas.font.name:='Tahoma';
  FBackGroundBitmap.canvas.font.size:=8;
  FBackGroundBitmap.canvas.font.style:=[fsUnderline];
  FBackGroundBitmap.canvas.font.color:=$00f0f0f0;


   rc.left:=FposUrl;
   rc.right:=FposUrl+FSizeUrlCaption;
   rc.top:=0;
   rc.bottom:=clientHeight;

  SetBkMode(FBackGroundBitmap.canvas.Handle, TRANSPARENT);
  Windows.ExtTextOutW(FBackGroundBitmap.canvas.Handle, FposUrl, 4, ETO_CLIPPED, @Rc, PwideChar(FUrlCaption),Length(FUrlCaption), nil);
end;

procedure TCometTrack.InvalidateCaption;
var
rc:trect;
begin
if not FLoaded then exit;

if length(FCaption)=0 then exit;

  FBackGroundBitmap.canvas.font.name:='Tahoma';
  FBackGroundBitmap.canvas.font.size:=8;
  FBackGroundBitmap.canvas.font.style:=[];
  FBackGroundBitmap.canvas.font.color:=clwhite;

   rc.left:=5;
   rc.right:=FMaxWidthCaption;
   rc.top:=0;
   rc.bottom:=clientHeight;

  SetBkMode(FBackGroundBitmap.canvas.Handle, TRANSPARENT);
  Windows.ExtTextOutW(FBackGroundBitmap.canvas.Handle, 5, 4, ETO_CLIPPED, @Rc, PwideChar(FCaption),Length(FCaption), nil);
end;

procedure TCometTrack.drawCaptionBackGround(doCaption:boolean=true; DoUrlCaption:boolean=true; DoTimeCaption:boolean=true);
var
rleft:integer;
tempBitmap:graphics.TBitmap;
begin
if not FLoaded then exit;

// draw gradient from downup
if (DoTimeCaption) and (not doCaption) and (not DoUrlCaption) then begin
 if ((FLastposTimeCaption>0) and (FLastposTimeCaption<FPosTimeCaption-5)) then rleft:=FLastposTimeCaption
  else rleft:=FposTimeCaption-5;
end else rleft:=0;

tempBitmap:=graphics.TBitmap.create;
 tempBitmap.pixelFormat:=pf24Bit;
 tempBitmap.width:=1;
 tempBitmap.height:=22;

bitBlt(tempBitmap.canvas.handle,0,0,tempBitmap.width,tempBitmap.height,
       FSourceBitmap.canvas.handle,0,0,SRCCOPY);

FBackGroundBitmap.canvas.stretchDraw(rect(rleft,0,clientwidth,21),tempBitmap);

tempBitmap.free;
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

FBackGroundBitmap.canvas.stretchDraw(rect(0,21,clientwidth,31),tempBitmap);

tempBitmap.free;


bitBlt(FBackGroundBitmap.canvas.handle,0,24,7,5,
       FSourceBitmap.canvas.handle,9,18,SRCCopy);
bitBlt(FBackGroundBitmap.canvas.handle,clientwidth-7,24,7,5,
       FSourceBitmap.canvas.handle,9,24,SRCCopy);


if not FTrackbarEnabled then exit;

// draw progress 3 lines
if FPosition>0 then leftProgress:=5+((int64(FPosition) * int64(clientwidth-26)) div int64(FMax))
 else LeftProgress:=5;

FBackGroundBitmap.canvas.brush.color:=$00ffc584;
rc.left:=5;
rc.Top:=25;
rc.bottom:=26;
rc.Right:=leftProgress;
FBackGroundBitmap.canvas.FillRect(rc);

FBackGroundBitmap.canvas.brush.color:=$00cd410f;
rc.Top:=26;
dec(rc.left);
rc.bottom:=27;
rc.Right:=leftProgress+1;
FBackGroundBitmap.canvas.FillRect(rc);

FBackGroundBitmap.canvas.brush.color:=$00ff966e;
rc.Top:=27;
inc(rc.left);
rc.bottom:=28;
rc.Right:=leftProgress;
FBackGroundBitmap.canvas.FillRect(rc);

           if (FDown) or (Fover) then begin
             if FDown then BitBlt(FBackGroundBitmap.canvas.Handle,leftProgress,22,15,8,
                      FSourceBitmap.canvas.handle,1,8,SRCCOPY)
                      else
             if FOver then BitBlt(FBackGroundBitmap.canvas.Handle,leftProgress,22,15,8,
                      FSourceBitmap.canvas.handle,1,0,SRCCOPY);
           end else begin

             BitBlt(FBackGroundBitmap.canvas.Handle,leftProgress,25,16,3,
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

  DrawCaptions;
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
if y<17 then begin
 self.cursor:=crDefault;
 if ((x<=FMaxWidthCaption+4) and (length(FCaption)>0)) then begin
  if Assigned(FOnCaptionClick) then FOnCaptionClick(self);
 end;
 if ((x>=FPosUrl) and
     (length(FUrlCaption)>0) and
     (x<=FPosUrl+FSizeUrlCaption) and
     (length(FUrl)>0) and
     (Assigned(FOnUrlClick))) then begin
      self.cursor:=crHandpoint;
      FOnUrlClick(self,FUrl,dummy);
     end;
 exit;
end;

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
if y<17 then begin
  if ((x>=FPosUrl) and
      (length(FUrlCaption)>0) and
      (length(FUrl)>0) and
      (x<=FPosUrl+FSizeUrlCaption) and
      (Assigned(FOnUrlClick))) then self.cursor:=CrHandpoint
      else self.cursor:=crDefault;
  exit;
end;

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
  FOnUrlClick:=nil;
  FOnCaptionClick:=nil;

  FSourceBitmap:=graphics.TBitmap.create;
  FSourceBitmap.LoadFromResourceName(hinstance,'BITMAPTRACKBAR');

  FOver:=false;
  FDown:=false;
  FMax:=1000;
  FPosition:=0;
  FSizeUrlCaption:=0;

  FPosTimeCaption:=0;//clientWidth-3;
  FPosUrl:=FPosTimeCaption;
  FLastposTimeCaption:=0;
  BevelOuter:=bvNone;
  height:=32;

  FCaption:='';
  FUrlCaption:='';
  FUrl:='';
  FTimeCaption:='';

  FTrackbarEnabled:=true;

end;

destructor tcomettrack.destroy;
begin
  FSourceBitmap.free;
  FBackGroundBitmap.free;
  FCaption:='';
  FUrlCaption:='';
  FUrl:='';
  FTimeCaption:='';
  inherited;
end;

procedure Register;
begin
  RegisterComponents('Comet', [Tcomettrack]);
end;


end.
