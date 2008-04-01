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
Ares media player button panel
}

unit mPlayerPanel;

interface

uses
 controls,windows,sysutils,graphics,classes,ExtCtrls,messages,forms;

const
 BTN_ID_PLAY      = 0;
 BTN_ID_PLAYLIST  = 1;
 BTN_ID_STOP      = 2;
 BTN_ID_PREV      = 3;
 BTN_ID_NEXT      = 4;
 BTN_ID_VOLUME    = 5;
 BTN_ID_RADIO     = 6;

 type
 TMPlayerButtonID=(MPBtnNone,
                   MPBtnPlaylist,
                   MPBtnStop,
                   MPBtnPrev,
                   MPBtnRew,
                   MPBtnPlay,
                   MPBtnPause,
                   MPBtnFF,
                   MPBtnNext,
                   MPBtnVol,
                   MPBtnRadio);

 type TMPlayerNotifyEvent = procedure(BtnId:TMPlayerButtonID) of object;
 type TCmtUrlClickEvent = procedure(Sender: TObject; const URLText: String; Button: TMouseButton) of object;
 
 type
 TMPlayerButtonState=(MPBtnOff,
                      MPBtnHover,
                      MPBtnDown);
 type
 TMPlayerButton=class
  FID:TMPlayerButtonID;
  FHitRect:Trect; // click zone
  FPaintOffset:TPoint; // where to paste pictures on destination (relative to player section left)
  FOffCopyRect,  // where to copy state pictures from
  FHoverCopyRect,
  FDownCopyRect:TRect;
  FState:TMPlayerButtonState;
 end;

 type TMBtnArray=array of TMPlayerButton;

type
 TMPlayerPanel=class(TPanel)
  private
   FLoaded:boolean;

   FButtons:TMBtnArray;
   FSourceBitmap:graphics.TBitmap;

   FRewindDownCopyRect,
   FFastForwardDownCopyRect:TRect;

   FPlaying:boolean;  // swap play to pause

   FleftCenter:integer;
   FOnClick,
   FOnBtnHint:TMPlayerNotifyEvent;
   FOnUrlClick:TCmtUrlClickEvent;
   FOnCaptionClick:TNotifyEvent;

   FSeekTimer,FSeekTickTimer:TTimer;

   FPlayOffCopyRect,
   FPlayHoverCopyRect,
   FPlayDownCopyRect,
   FPauseOffCopyRect,
   FPauseHoverCopyRect,
   FPauseDownCopyRect:TRect;

   FTimeCaption,FUrl:string;
   FCaption,FUrlCaption:widestring;
   FLastposTimeCaption:integer;
   FPosUrl,FPosTimeCaption,FMaxWidthCaption,FSizeUrlCaption:integer;
   procedure SetUrl(const value:string);
   procedure SetwCaption(const value:widestring);
   procedure SetUrlCaption(const value:widestring);
   procedure SetTimeCaption(const value:string);
   procedure RecalcPositions(clRect:tRect; aCanvas:TCanvas);

   procedure InvalidateCaptions(aCanvas:TCanvas=nil);
   procedure InvalidateCaption(clRect:TRect; aCanvas:TCanvas);
   procedure InvalidateTimeCaption(clRect:TRect; aCanvas:TCanvas);
   procedure InvalidateUrlCaption(clRect:TRect; aCanvas:TCanvas);

   procedure SetPlaying(value:boolean);
   procedure drawButtons(aCanvas:TCanvas);  // draw all buttons in their current state (in response to an invalidate component)
   procedure RepaintPreviouslyActiveButtons(ExceptButton:TMPlayerButton; SetState:boolean=true; RemoveDown:boolean=false);
   procedure SeekTimerStartTimer(Sender:TObject);  // is FF or RewButton still pressed?
   procedure SeekTimerEventTimer(Sender:TObject);
   function GetPressedButton:TMPlayerButton;
   procedure SetSourceBitmap(value:graphics.tbitmap);

   procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
   procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
   procedure WMUser(Var msg:TMessage); message WM_USER;
  protected
   procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
   procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
   procedure MouseUP(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
   procedure paint; override;
  public
   constructor Create(Owner:TComponent); override;
   destructor destroy; override;
  published
    property url:string read FUrl write SetUrl;
    property urlCaption:widestring read FUrlCaption write SetUrlCaption;
    property wcaption:widestring read FCaption write SetwCaption;
    property TimeCaption:string read FTimeCaption write SetTimeCaption;
    property Buttons:TMBtnArray read FButtons;
    property SourceBitmap:graphics.TBitmap read FSourceBitmap write SetSourceBitmap;
    property Playing:boolean read FPlaying write SetPlaying;
    property OnClick:TMPlayerNotifyEvent read FOnClick write FOnClick;
    property OnBtnHint:TMPlayerNotifyEvent read FOnBtnHint write FOnBtnHint;
    property OnUrlClick:TCmtUrlClickEvent read FOnUrlClick write FOnUrlClick;
    property OnCaptionClick:TNotifyEvent read FOnCaptionClick write FOnCaptionClick;
 end;

 procedure Register;

implementation

{$R bmpmplayer.res}

procedure TMPlayerPanel.SetSourceBitmap(value:graphics.tbitmap);
begin

if value=nil then begin   // use internal bitmap
  if FSourceBitmap<>nil then FSourceBitmap.free;
  FSourceBitmap:=graphics.TBitmap.create;
  FSourceBitmap.LoadFromResourceName(hinstance,'BTMMPLAYER');
end else begin      // use external bitmap
  if FSourceBitmap<>nil then FSourceBitmap.free;
  FSourceBitmap:=value;
end;

end;

procedure TMPlayerPanel.SetUrl(const value:string);
begin

FUrl:=value;
if length(FUrlCaption)=0 then FUrlCaption:=FUrl;

if not FLoaded then exit;
invalidateCaptions;
end;

procedure TMPlayerPanel.SetwCaption(const value:widestring);
begin
FCaption:=value;
if not FLoaded then exit;
invalidateCaptions;
end;

procedure TMPlayerPanel.SetUrlCaption(const value:widestring);
begin
FUrlCaption:=value;
if not FLoaded then exit;
invalidateCaptions;
end;

procedure TMPlayerPanel.SetTimeCaption(const value:string);
begin
if not FLoaded then exit;
FTimeCaption:=value;
invalidateCaptions;
end;


procedure TMPlayerPanel.SetPlaying(value:boolean);
var
btn:TMPlayerButton;
shouldMove:boolean;
point:Tpoint;
begin
FPlaying:=value;

btn:=FButtons[BTN_ID_PLAY];
if value then begin
 btn.FID:=MPBtnPause;
  btn.FOffCopyRect:=FPauseOffCopyRect;
  btn.FHoverCopyRect:=FPauseHoverCopyRect;
  btn.FDownCopyRect:=FPauseDownCopyRect;
 end else begin
  btn.FID:=MPBtnPlay;
   btn.FOffCopyRect:=FPlayOffCopyRect;
   btn.FHoverCopyRect:=FPlayHoverCopyRect;
   btn.FDownCopyRect:=FPlayDownCopyRect;
 end;

 getCursorPos(point);
 point:=screenToclient(point);
 with point do 
shouldMove:=((x>=btn.FHitRect.left+FleftCenter) and
             (x<=FleftCenter+btn.FHitRect.right) and
             (y>=btn.FHitRect.Top) and
             (y<=btn.FHitRect.bottom));

 repaint;

 if shouldMove then begin
  btn.FState:=MPBtnHover;
  bitBlt(canvas.handle,
         FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FHoverCopyRect.right,btn.FHoverCopyRect.bottom,
         FSourceBitmap.canvas.handle,btn.FHoverCopyRect.left,btn.FHoverCopyRect.top,SRCCopy);
 end;
 
end;

procedure TMPlayerPanel.WMEraseBkgnd(Var Msg : TMessage);
begin
msg.result:=1;
end;

procedure TMPlayerPanel.SeekTimerStartTimer(Sender:TObject);  // is FF or RewButton still pressed?
var
i:integer;
btn:TMPlayerButton;
begin
FSeekTimer.enabled:=false;

for i:=0 to high(FButtons) do begin
 btn:=FButtons[i];

 if btn.FID<>MPBtnPrev then
  if btn.FID<>MPBtnNext then continue;

 if btn.fState<>MPBtnDown then continue;

   // swap down image with the correct seek image
   if btn.FID=MPBtnPrev then
     bitBlt(canvas.handle,
            FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,FRewindDownCopyRect.right,FRewindDownCopyRect.bottom,
            FSourceBitmap.canvas.handle,FRewindDownCopyRect.left,FRewindDownCopyRect.top,SRCCopy)
     else
     bitBlt(canvas.handle,
            FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,FFastForwardDownCopyRect.right,FFastForwardDownCopyRect.bottom,
            FSourceBitmap.canvas.handle,FFastForwardDownCopyRect.left,FFastForwardDownCopyRect.top,SRCCopy);

  FSeekTickTimer.enabled:=true; // time to start seeking!  redraw button as a Rew or FF one
 break;
end;

end;

procedure TMPlayerPanel.SeekTimerEventTimer(Sender:TObject);
var
i:integer;
btn:TMPlayerButton;
begin
FSeekTickTimer.enabled:=false;

for i:=0 to high(FButtons) do begin
 btn:=FButtons[i];
 
 if btn.FID<>MPBtnPrev then
  if btn.FID<>MPBtnNext then continue;

   if btn.fState<>MPBtnDown then continue;

   if Assigned(FOnClick) then begin
    if btn.FID=MPBtnPrev then FOnClick(MPBtnRew)
     else FOnClick(MPBtnFF);  // call event!
   end;

   FSeekTickTimer.enabled:=true; // time to start seeking!
 break;
end;

end;


constructor TMPlayerPanel.create(Owner:TComponent);
var
btn:TMPlayerButton;
begin
inherited create(Owner);

parent:=(Owner as TWInControl);

FLoaded:=false;
FOnClick:=nil;
FOnBtnHint:=nil;
FOnUrlClick:=nil;
FOnCaptionClick:=nil;

FSizeUrlCaption:=0;
FPosTimeCaption:=0;
FPosUrl:=FPosTimeCaption;
FLastposTimeCaption:=0;
FCaption:='';
FUrlCaption:='';
FUrl:='';
FTimeCaption:='';



   FPlayOffCopyRect:=Rect(35,3,25,25);
   FPlayHoverCopyRect:=rect(25,35,25,25);
   FPlayDownCopyRect:=rect(25,35,25,25);

   FPauseOffCopyRect:=rect(98,35,25,25);
   FPauseHoverCopyRect:=rect(123,35,25,25);
   FPauseDownCopyRect:=rect(123,35,25,25);

// FastForward/Rewind timers...if button is still down after a second, seek (by simulating click event every 10 millisecs)
FSeekTimer:=TTimer.create(nil);
 FSeekTimer.Enabled:=false;
 FSeekTimer.Interval:=700;
 FSeekTimer.OnTimer:=SeekTimerStartTimer;

FSeekTickTimer:=TTimer.create(nil);
 FSeekTickTimer.Enabled:=false;
 FSeekTickTimer.Interval:=50;
 FSeekTickTimer.OnTimer:=SeekTimerEventTimer;


// path:='C:\Programmi\Borland\Delphi7\Projects\test\mplayer panel\';
 FSourceBitmap:=graphics.TBitmap.create;
 FSourceBitmap.LoadFromResourceName(hinstance,'BTMMPLAYER');
// FSourceBitmap.savetoFile('c:\sourcebitmap.bmp');

SetLength(FButtons,7);

// play button
 btn:=TMPlayerButton.create;
 with btn do begin
  FID:=MPBtnPlay;
  FHitRect:=rect(35,3,59,27);  //sligthly smaller than paint rect, points sensible to mouse cursor
  with FPaintOffset do begin
   x:=34;
   y:=3;   // where we have to paste state bitmaps on destination canvas (relative to player panel left)
  end;
  FOffCopyRect:=FPlayOffCopyRect;  // where we have to copy state images from on our source bitmap
  FHoverCopyRect:=FPlayHoverCopyRect;
  FDownCopyRect:=FPlayDownCopyRect;
  FState:=MPBtnOff;
 end;
FButtons[BTN_ID_PLAY]:=btn;


//playlist button
 btn:=TMPlayerButton.create;
 with btn do begin
  FID:=MPBtnPlaylist;
  FHitRect:=rect(125,3,145,22);  //sligthly smaller than paint rect, points sensible to mouse cursor
  with FPaintOffset do begin
   x:=125;
   y:=3;   // where we have to paste state bitmaps on destination canvas (relative to player panel left)
  end;
  FOffCopyRect:=rect(126,3,22,24);  // where we have to copy state images from on our source bitmap
  FHoverCopyRect:=rect(0,61,22,24);
  FDownCopyRect:=rect(0,61,22,24);
  FState:=MPBtnOff;
 end;
FButtons[BTN_ID_PLAYLIST]:=btn;

// stop button
 btn:=TMPlayerButton.create;
 with btn do begin
  FID:=MPBtnStop;
  FHitRect:=rect(96,4,119,27);  //sligthly smaller than paint rect, points sensible to mouse cursor
  with FPaintOffset do begin
   x:=95;
   y:=4;   // where we have to paste state bitmaps on destination canvas (relative to player panel left)
  end;
  FOffCopyRect:=rect(96,4,22,22);  // where we have to copy state images from on our source bitmap
  FHoverCopyRect:=rect(75,35,22,22);
  FDownCopyRect:=rect(75,35,22,22);
  FState:=MPBtnOff;
 end;
FButtons[BTN_ID_STOP]:=btn;

// prev button
 btn:=TMPlayerButton.create;
 with btn do begin
  FID:=MPBtnPrev;
  FHitRect:=rect(4,4,28,27);  //sligthly smaller than paint rect, points sensible to mouse cursor
  with FPaintOffset do begin
   x:=3;
   y:=3;   // where we have to paste state bitmaps on destination canvas (relative to player panel left)
  end;
  FOffCopyRect:=rect(4,3,25,25);  // where we have to copy state images from on our source bitmap
  FHoverCopyRect:=rect(0,35,25,25);
  FDownCopyRect:=rect(0,35,25,25);
  FState:=MPBtnOff;
 end;
FButtons[BTN_ID_PREV]:=btn;

 // rects of the media seek equivalents (these images get displayed when theres seeking in progress
FRewindDownCopyRect:=rect(148,35,25,25);
FFastForwardDownCopyRect:=rect(173,35,25,25);




// next button
 btn:=TMPlayerButton.create;
 with btn do begin
  FID:=MPBtnNext;
  FHitRect:=rect(67,4,92,27);  //sligthly smaller than paint rect, points sensible to mouse cursor
  with FPaintOffset do begin
   x:=66;
   y:=3;   // where we have to paste state bitmaps on destination canvas (relative to player panel left)
  end;
  FOffCopyRect:=Rect(67,3,25,25);  // where we have to copy state images from on our source bitmap
  FHoverCopyRect:=Rect(50,35,25,25);
  FDownCopyRect:=Rect(50,35,25,25);
  FState:=MPBtnOff;
 end;
FButtons[BTN_ID_NEXT]:=btn;


// volume button
 btn:=TMPlayerButton.create;
 with btn do begin
  FID:=MPBtnVol;
  FHitRect:=rect(150,3,172,22);  //sligthly smaller than paint rect, points sensible to mouse cursor
  with FPaintOffset do begin
   x:=148;
   y:=2;   // where we have to paste state bitmaps on destination canvas (relative to player panel left)
  end;
  FOffCopyRect:=Rect(149,2,20,24);  // where we have to copy state images from on our source bitmap
  FHoverCopyRect:=Rect(22,61,20,24);
  FDownCopyRect:=Rect(22,61,20,24);
  FState:=MPBtnOff;
 end;
FButtons[BTN_ID_VOLUME]:=btn;

// radio button
 btn:=TMPlayerButton.create;
 with btn do begin
  FID:=MPBtnRadio;
  FHitRect:=rect(170,7,184,23);  //sligthly smaller than paint rect, points sensible to mouse cursor
  with FPaintOffset do begin
   x:=168;
   y:=2;   // where we have to paste state bitmaps on destination canvas (relative to player panel left)
  end;
  FOffCopyRect:=Rect(168,2,23,24);  // where we have to copy state images from on our source bitmap
  FHoverCopyRect:=Rect(42,61,23,24);
  FDownCopyRect:=Rect(42,61,23,24);
  FState:=MPBtnOff;
 end;
FButtons[BTN_ID_RADIO]:=btn;


FLoaded:=true;
end;


procedure TMPlayerPanel.drawButtons(aCanvas:TCanvas);  // draw all buttons in their current state (in response to an invalidate component)
var
 i:integer;
 btn:TMPlayerButton;
begin

for i:=0 to high(FButtons) do begin
 btn:=FButtons[i];

 case btn.FState of
    MPBtnOff:bitBlt(acanvas.handle,
                    FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FOffCopyRect.right,btn.FOffCopyRect.bottom,
                    FSourceBitmap.canvas.handle,btn.FOffCopyRect.left,btn.FOffCopyRect.top,SRCCopy);

    MPBtnHover:bitBlt(acanvas.handle,
                      FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FHoverCopyRect.right,btn.FHoverCopyRect.bottom,
                      FSourceBitmap.canvas.handle,btn.FHoverCopyRect.left,btn.FHoverCopyRect.top,SRCCopy);

    MPBtnDown:bitBlt(acanvas.handle,
                     FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FDownCopyRect.right,btn.FDownCopyRect.bottom,
                     FSourceBitmap.canvas.handle,btn.FDownCopyRect.left,btn.FDownCopyRect.top,SRCCopy);
 end;

end;

end;

function TMPlayerPanel.GetPressedButton:TMPlayerButton;
var
i:integer;
btn:TMPlayerButton;
begin
result:=nil;
for i:=0 to high(FButtons) do begin
 btn:=FButtons[i];
 if btn.FState=MPBtnDown then begin
  result:=btn;
  exit;
 end;
end;
end;

procedure TMPlayerPanel.MouseMove(Shift: TShiftState; X, Y: Integer); // mouse moved over control, if it's over a button's hitrect change its state to Hover (unless it's already in down state)
var
i:integer;
btn,pressedButton:TMPlayerButton;
found:boolean;
begin

if (x>FSourceBitmap.Width+7) and (y>5) and (y<28) then begin
  if ((x>=FSourceBitmap.Width+7+FPosUrl) and
      (length(FUrlCaption)>0) and
      (length(FUrl)>0) and
      (x<=FSourceBitmap.Width+7+FPosUrl+FSizeUrlCaption) and
      (Assigned(FOnUrlClick))) then self.cursor:=CrHandpoint
      else self.cursor:=crDefault;
  exit;
end;

found:=false;
PressedButton:=GetPressedButton;

 for i:=0 to high(FButtons) do begin
 btn:=FButtons[i];
  if x<btn.FHitRect.left+FleftCenter then continue;
  if y<btn.FHitRect.Top then continue;
  if y>btn.FHitRect.bottom then continue;
  if x>btn.FHitRect.right+FleftCenter then continue;
  found:=true;
  if Assigned(FOnBtnHint) then FOnBtnHint(btn.FID);
  RepaintPreviouslyActiveButtons(btn,false);

  if pressedButton<>nil then
   if pressedButton<>btn then break;   // if a button has been pressed then redraw only his state and 'freeze' others

  if btn.FState=MPBtnDown then begin
                     if ((btn.FID=MPBtnPrev) and (FSeekTickTimer.enabled)) then
                          bitBlt(canvas.handle,
                                 FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,FRewindDownCopyRect.right,FRewindDownCopyRect.bottom,
                                 FSourceBitmap.canvas.handle,FRewindDownCopyRect.left,FRewindDownCopyRect.top,SRCCopy)
                      else
                     if ((btn.FID=MPBtnNext) and (FSeekTickTimer.enabled)) then
                          bitBlt(canvas.handle,
                                 FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,FFastForwardDownCopyRect.right,FFastForwardDownCopyRect.bottom,
                                 FSourceBitmap.canvas.handle,FFastForwardDownCopyRect.left,FFastForwardDownCopyRect.top,SRCCopy)
                      else
                        bitBlt(canvas.handle,
                               FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FDownCopyRect.right,btn.FDownCopyRect.bottom,
                               FSourceBitmap.canvas.handle,btn.FDownCopyRect.left,btn.FDownCopyRect.top,SRCCopy);
    end else begin
      btn.FState:=MPBtnHover;
      bitBlt(canvas.handle,
             FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FHoverCopyRect.right,btn.FHoverCopyRect.bottom,
             FSourceBitmap.canvas.handle,btn.FHoverCopyRect.left,btn.FHoverCopyRect.top,SRCCopy);
     end;
    exit;
 end;

 if not found then begin
  RepaintPreviouslyActiveButtons(nil);
  if Assigned(FOnBtnHint) then FOnBtnHint(MPBtnNone);
 end;
end;


procedure TMPlayerPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);   // mouse clicked over control, perform drawing and eventually start FSeekTimer
var
 i:integer;
 btn:TMPlayerButton;
 found,SeekButton:boolean;
 dummy:TMouseButton;
begin

if (x>FSourceBitmap.Width+7) and (y>5) and (y<28) then begin
 self.cursor:=crDefault;
 if ((x<=FSourceBitmap.Width+7+FMaxWidthCaption+4) and (length(FCaption)>0)) then begin
  if Assigned(FOnCaptionClick) then FOnCaptionClick(self);
 end;
 if ((x>=FSourceBitmap.Width+7+FPosUrl) and
     (length(FUrlCaption)>0) and
     (x<=FSourceBitmap.Width+7+FPosUrl+FSizeUrlCaption) and
     (length(FUrl)>0) and
     (Assigned(FOnUrlClick))) then begin
      self.cursor:=crHandpoint;
      FOnUrlClick(self,FUrl,dummy);
     end;
 exit;
end;

 found:=false;
 SeekButton:=false;

 for i:=0 to high(FButtons) do begin
  btn:=FButtons[i];
  if x<btn.FHitRect.left+FleftCenter then continue;
  if y<btn.FHitRect.Top then continue;
  if y>btn.FHitRect.bottom then continue;
  if x>btn.FHitRect.right+FleftCenter then continue;
   found:=true;
   RepaintPreviouslyActiveButtons(btn);
    btn.FState:=MPBtnDown;  // set state
   bitBlt(canvas.handle,
          FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FDownCopyRect.right,btn.FDownCopyRect.bottom,
          FSourceBitmap.canvas.handle,btn.FDownCopyRect.left,btn.FDownCopyRect.top,SRCCopy);

          if ((btn.FID=MPBtnPrev) or (btn.FID=MPBtnNext)) then begin
            SeekButton:=true;
            if ((not FSeekTickTimer.enabled) and (not FSeekTimer.enabled)) then begin
              FSeekTickTimer.enabled:=false;
              FSeekTimer.enabled:=false;
              FSeekTimer.Enabled:=true;
            end;
          end;

   exit;
 end;

 if not found then begin
  FSeekTickTimer.enabled:=false;
  FSeekTimer.enabled:=false;
  RepaintPreviouslyActiveButtons(nil);
 end else
 if not SeekButton then begin
  FSeekTickTimer.enabled:=false;
  FSeekTimer.enabled:=false;
 end;

end;

procedure TMPlayerPanel.MouseUP(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
i:integer;
btn:TMPlayerButton;
found,wasDown:boolean;
seekEnabled,seekInProgress:boolean;
begin
 found:=false;
 seekEnabled:=FSeekTimer.enabled;
 seekInProgress:=FSeekTickTimer.enabled;
 FSeekTickTimer.enabled:=false;
 FSeekTimer.enabled:=false;

 for i:=0 to high(FButtons) do begin
  btn:=FButtons[i];
  if x<btn.FHitRect.left+FleftCenter then continue;
  if y<btn.FHitRect.Top then continue;
  if y>btn.FHitRect.bottom then continue;
  if x>btn.FHitRect.right+FleftCenter then continue;
   found:=true;
   wasDown:=(btn.FState=MPBtnDown);
   RepaintPreviouslyActiveButtons(btn,true,true);

   btn.FState:=MPBtnHover;
      bitBlt(canvas.handle,
             FleftCenter+1+btn.FPaintOffset.x,btn.FPaintOffset.Y,btn.FHoverCopyRect.right,btn.FHoverCopyRect.bottom,
             FSourceBitmap.canvas.handle,btn.FHoverCopyRect.left,btn.FHoverCopyRect.top,SRCCopy);
             
      if Assigned(FOnClick) then begin

           if seekEnabled then begin // if release of mouse button happens within first second then it's a playlist event
            if btn.FID=MPBtnPrev then FOnClick(MPBtnPrev)
             else FOnClick(MPBtnNext);
             exit;
           end else
           if seekInProgress then begin
            exit;
           end;

      if wasDown then FOnClick(btn.FID); // just call btn event
      end;
   exit;
 end;

 if not found then RepaintPreviouslyActiveButtons(nil,true,true);
end;

procedure TMPlayerPanel.CMMouseLeave(var Msg:TMessage);
begin
FSeekTickTimer.enabled:=false;
FSeekTimer.enabled:=false;
RepaintPreviouslyActiveButtons(nil,false);
end;

procedure TMPlayerPanel.WMUser(Var msg:TMessage);
begin
RepaintPreviouslyActiveButtons(nil,true,true);
end;

procedure TMPlayerPanel.RepaintPreviouslyActiveButtons(ExceptButton:TMPlayerButton; SetState:boolean=true; RemoveDown:boolean=false);
var
i:integer;
tmpBtn:TMPlayerButton;
begin
 // now invalidate all other 'inactive buttons'
  for i:=0 to high(FButtons) do begin
   tmpBtn:=FButtons[i];

   if ExceptButton<>nil then
    if tmpBtn=ExceptButton then continue;

   if tmpBtn.FState<>MPBtnOff then begin

    if SetState then
     if tmpBtn.FState=MPBtnHover then tmpBtn.FState:=MPBtnOff;

    if RemoveDown then
     if tmpBtn.FState=MPBtnDown then tmpBtn.FState:=MPBtnOff;

    bitBlt(canvas.handle,
           FleftCenter+1+tmpBtn.FPaintOffset.x,tmpBtn.FPaintOffset.Y,tmpBtn.FOffCopyRect.right,tmpBtn.FOffCopyRect.bottom,
           FSourceBitmap.canvas.handle,tmpBtn.FOffCopyRect.left,tmpBtn.FOffCopyRect.top,SRCCopy);
   end;
 end;
end;





destructor TMPlayerPanel.destroy;
var
i:integer;
btn:TMPlayerButton;
begin

for i:=0 to high(FButtons) do begin
 btn:=FButtons[i];
 btn.free;
end;
SetLength(FButtons,0);



FSeekTimer.enabled:=false;
FSeekTickTimer.enabled:=false;
FSeekTimer.free;
FSeekTickTimer.free;

FSourceBitmap.free;

inherited;
end;

procedure TMPlayerPanel.paint;
var
 tempBitmap:graphics.TBitmap;
 backBitmap:graphics.tbitmap;
begin
if not FLoaded then begin
 inherited;
 exit;
end;

backBitmap:=graphics.TBitmap.create;
try

 backBitmap.PixelFormat:=pf24bit;
 backBitmap.width:=clientWidth;
 backBitmap.Height:=clientHeight;
 backBitmap.canvas.Brush.style:=bsSolid;

 //FleftCenter:=(clientwidth div 2)-((FSourceBitmap.width-2) div 2);
 
 FLeftCenter:=0;

 tempBitmap:=graphics.TBitmap.create;
 try
 tempBitmap.PixelFormat:=pf24bit;
 tempBitmap.width:=1;
 tempBitmap.Height:=clientHeight;//51;

  bitBlt(tempBitmap.canvas.Handle,0,0,tempBitmap.width,tempBitmap.Height,
         FSourceBitmap.canvas.Handle,0,0,SRCCopy);
  backBitmap.canvas.draw(FleftCenter,0,FSourceBitmap);
  backBitmap.canvas.StretchDraw(rect(FleftCenter+FSourceBitmap.width,0,clientwidth,clientHeight),tempBitmap);
 finally
 tempBitmap.free;
 end;

InvalidateCaptions(backBitmap.canvas);


drawButtons(backBitmap.canvas);

BitBlt(canvas.handle,0,0,clientWidth,clientHeight,
       backBitmap.Canvas.handle,0,0,SRCCOPY);

finally
backBitmap.free;
end;

end;

procedure TMPlayerPanel.InvalidateCaptions(aCanvas:TCanvas=nil);
var
 tempBitmap:graphics.TBitmap;
 wi,he,lex,topy:integer;
 cliRect:TRect;
begin
 tempBitmap:=nil;


if aCanvas=nil then begin
 wi:=(clientwidth-1)-(FSourceBitmap.width+2);
 he:=(clientHeight-5)-3;

 tempBitmap:=graphics.TBitmap.create;
 tempBitmap.PixelFormat:=pf24bit;

 tempBitmap.width:=wi;
 tempBitmap.Height:=he;

 aCanvas:=tempBitmap.canvas;
 lex:=0;
 topy:=0;
end else begin
 wi:=(clientwidth-3);
 he:=(clientHeight-5);
 lex:=FSourceBitmap.width;
 topy:=3;
end;

 aCanvas.brush.color:=$00323232;
 aCanvas.fillrect(rect(lex,topy,Wi,He));

 clirect:=rect(lex+1,topy+1,wi-1,he-1);

 aCanvas.brush.color:=clBlack;
 aCanvas.fillrect(clirect);

 inc(cliRect.left,7);
 dec(cliRect.Right,7);
 RecalcPositions(cliRect,aCanvas);

 //DrawCaptionBackGround(doCaption,doUrlCaption,DoTimeCaption);
// if doCaption then
 invalidateCaption(cliRect,aCanvas);
 //if dourlCaption then
 InvalidateUrlCaption(cliRect,aCanvas);
 //if DoTimeCaption then
 invalidateTimeCaption(cliRect,aCanvas);

if tempBitmap<>nil then begin
 BitBlt(self.canvas.Handle,FSourceBitmap.width,3,wi,he,
        aCanvas.handle,0,0,SRCCopy);
 tempBitmap.free;
end;
end;

procedure TMPlayerPanel.InvalidateCaption(clRect:TRect; aCanvas:TCanvas);
var
 rc:trect;
begin
if not FLoaded then exit;

if length(FCaption)=0 then exit;

  acanvas.font.name:='Tahoma';
  acanvas.font.size:=8;
  acanvas.font.style:=[];
  acanvas.font.color:=clSilver;

   rc.left:=clRect.left;
   if clRect.left+FMaxWidthCaption>clRect.right then rc.right:=clRect.right
    else rc.right:=clRect.left+FMaxWidthCaption;
   rc.top:=clRect.top;
   rc.bottom:=clRect.bottom;

  SetBkMode(acanvas.Handle, TRANSPARENT);
  Windows.ExtTextOutW(acanvas.Handle, clRect.left, clRect.top+4, ETO_CLIPPED, @Rc, PwideChar(FCaption),Length(FCaption), nil);
end;

procedure TMPlayerPanel.InvalidateUrlCaption(clRect:TRect; aCanvas:TCanvas);
var
 rc:trect;
begin
if not FLoaded then exit;

if ((length(FUrlCaption)=0) or (length(FUrl)=0)) then exit;

  acanvas.font.name:='Tahoma';
  acanvas.font.size:=8;
  acanvas.font.style:=[fsUnderline];
  acanvas.font.color:=clSilver;


   rc.left:=clRect.left+FposUrl;
   if clRect.left+FposUrl+FSizeUrlCaption>clRect.right then rc.right:=clRect.right
    else rc.right:=clRect.left+FposUrl+FSizeUrlCaption;
   rc.top:=clRect.top;
   rc.bottom:=clRect.bottom;

  SetBkMode(acanvas.Handle, TRANSPARENT);
  Windows.ExtTextOutW(acanvas.Handle, clRect.left+FposUrl, clRect.top+4, ETO_CLIPPED, @Rc, PwideChar(FUrlCaption),Length(FUrlCaption), nil);
end;

procedure TMPlayerPanel.InvalidateTimeCaption(clRect:TRect; aCanvas:TCanvas);
var
 rc:trect;
begin
if not FLoaded then exit;

if length(FTimeCaption)=0 then exit;

  acanvas.font.name:='Tahoma';
  acanvas.font.size:=8;
  acanvas.font.style:=[];
  acanvas.font.color:=clSilver;//$00f0f0f0;


   rc.left:=clRect.left+FposTimeCaption;
   rc.right:=clRect.right;
   rc.top:=clRect.top;
   rc.bottom:=clRect.bottom;

  SetBkMode(acanvas.Handle, TRANSPARENT);
  Windows.ExtTextOut(acanvas.Handle, clRect.left+FposTimeCaption, clRect.top+4, ETO_CLIPPED, @Rc, PChar(FTimeCaption),Length(FTimeCaption), nil);
end;

procedure TMPlayerPanel.RecalcPositions(clRect:TRect; aCanvas:TCanvas);
var
 size:tsize;
 FSizeTimeCaption:integer;
begin
if not FLoaded then exit;

  acanvas.font.name:='Tahoma';
  acanvas.font.size:=8;
  acanvas.font.style:=[];

  // get width of caption
  if length(FCaption)>0 then begin
   size.cX:=0;
   size.cY:=0;
   Windows.GetTextExtentPointW(acanvas.handle, PWideChar(FCaption), Length(FCaption), size);
   FMaxWidthCaption:=size.cx+10;
  end else FMaxWidthCaption:=0;

  FLastposTimeCaption:=FposTimeCaption;
  if length(FTimeCaption)>0 then begin
   size.cX:=0;
   size.cY:=0;
   Windows.GetTextExtentPoint(acanvas.handle, PChar(FTimeCaption), Length(FTimeCaption), size);
   FposTimeCaption:=((clRect.Right-clRect.left)-3)-size.cx;
   FSizeTimeCaption:=size.cx;
  end else begin
   FPosTimeCaption:=0;
   FSizeTimeCaption:=0;
  end;

  if ((length(FUrlCaption)>0) and (length(FUrl)>0)) then begin
   acanvas.font.style:=[fsUnderline];
   size.cX:=0;
   size.cY:=0;
   Windows.GetTextExtentPointW(acanvas.handle, PwideChar(FUrlCaption), Length(FUrlCaption), size);
   if FposTimeCaption>0 then FposUrl:=(FposTimeCaption-3)-size.cx
    else FPosUrl:=((clRect.Right-clRect.left)-3)-size.cx;
   FSizeUrlCaption:=size.cx;
   if (clRect.Right-clRect.left)<FPosUrl+FSizeUrlCaption then FSizeUrlCaption:=(clRect.Right-clRect.left)-FPosUrl; // windows is too small to show UrlCaption, resize accordingly
  end else begin
   FSizeUrlCaption:=0;
   FPosUrl:=0;
  end;

  if ((FmaxWidthCaption+5>FPosUrl) and (FPosUrl>0)) then FMaxWidthCaption:=FPosUrl-5; // caption overlapping URL
  if ((FMaxWidthCaption+5>FposTimeCaption) and (FPosTimeCaption>0)) then FMaxWidthCaption:=FposTimeCaption-5; // caption overlapping Timecaption
  if (clRect.Right-clRect.left)<5+FMaxWidthCaption+5+FSizeUrlCaption+5+FSizeTimeCaption then FMaxWidthCaption:=((clRect.Right-clRect.left)-15)-(FSizeUrlCaption+FSizeTimeCaption);

  if FPosUrl>FMaxWidthCaption+5 then FPosUrl:=FMaxWidthCaption+5; // keep Url close to caption
  if FPosUrl<5 then FPosUrl:=5;

  if (FPosUrl>0) and (length(FUrl)>0) and (length(FUrlCaption)>0) and (FPosTimeCaption<FPosUrl+FSizeUrlCaption) then FPosTimeCaption:=FPosUrl+FSizeUrlCaption+5;

end;


procedure Register;
begin
  RegisterComponents('Comet', [TMPlayerPanel]);
end;

end.