{*******************************************************************************
    TWinSplit
    Copyright © Bill Menees
    bmenees@usit.net
    http://www.public.usit.net/bmenees

    This is a window splitting component similar to the one used in the Win95
    Explorer.  To use it, you must assign a control to the TargetControl
    property.  This sets the Cursor property, and a bunch of private properties
    including the Align property.

    The TargetControl is the control that gets resized at the end of the window
    "split" operation.  Thus, TargetControl must have an alignment in [alLeft,
    alRight, alTop, alBottom].

    The other useful properties introduced are MinTargetSize and MaxTargetSize.
    These determine how small or large the Width or Height of the TargetControl
    can be.  If MaxTargetSize = 0 then no maximum size is enforced.

    Note 1: Even though TWinSplit is decended from TCustomPanel, don't think of
    it as a panel.  I only published the panel properties useful to TWinSplit
    and none of the panel events.  I even made it where it won't act as the
    container for controls placed on it at design time.

    Note 2: Some drawing code is from Borland's Resource Explorer example.

*******************************************************************************}
unit WinSplit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TWinSplitOrientation = (wsVertical, wsHorizontal);
  TWinSplit = class(TPanel)
  private
    fOrientation: TWinSplitOrientation;
    fSizing: Boolean;
    fDelta: TPoint;
     fOnEndSplit: TNotifyEvent;
     fypos,fxpos:integer;
     priormode:tpenmode;
     ftop,fleft:integer;
     FshouldAnimate:boolean;
  private
    procedure DrawSizingLine;
    procedure CMMouseEnter(var Msg:TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure GradientRect(col1,col2:TColor);

{This is here so we can update the TargetControl
    property if the target component is removed.}
    procedure Setorientation(Value: TWinSplitOrientation);

    procedure BeginSizing; virtual;
    procedure ChangeSizing(X, Y: Integer); virtual;
    procedure EndSizing; virtual;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  published
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property orientation:TWinSplitOrientation read forientation write setorientation;
    property Visible;
    property sizing:boolean read fsizing write fsizing;
    property OnEndSplit: TNotifyEvent read fOnEndSplit write fOnEndSplit;
    property xpos:integer read fxpos write fxpos;
    property ypos:integer read fypos write fypos;
    property componentTop:integer read ftop write ftop;
    property componentLefT:integer read fleft write fleft;
  end;

procedure Register;

implementation

{$R WinSplit.res}

{******************************************************************************}
{** Non-Member Functions ******************************************************}
{******************************************************************************}

procedure Register;
begin
     RegisterComponents('Comet', [TWinSplit]);
end;



function CToC(C1, C2: TControl; P: TPoint): TPoint;
begin
     Result := C1.ScreenToClient(C2.ClientToScreen(P));
end;

{******************************************************************************}
{** TWinSplit Public Methods **************************************************}
{******************************************************************************}

constructor TWinSplit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     fOrientation:=wshorizontal;
     fDelta:=Point(0,0);
     fSizing:=False;
     Caption:='';
     TabStop:=False;
     Height:=100;
     Width:=3;
     xpos:=0;
     ypos:=0;
     FshouldAnimate:=true;
     fleft:=0;
     ftop:=0;
     {BevelOuter:=bvNone;}
     //ParentColor:=true;
    // color:=clbtnface;
    // doublebuffered:=true;
    // color:=clbtnface;
     {We don't want a TWinSplit to be a container like normal panels.
     We also don't ever want the Caption property to be non-empty.}
    // ControlStyle:=ControlStyle - [csAcceptsControls, csSetCaption];
     //ControlStyle:=ControlStyle + [csopaque];
end;

procedure TWinSplit.Paint;
begin
canvas.lock;
 canvas.pen.color:=color;
 canvas.brush.color:=color;
 canvas.rectangle(0,0,width,height);
canvas.unlock;
end;
{******************************************************************************}
{** TWinSplit Protected Methods ***********************************************}
{******************************************************************************}

procedure TWinSplit.BeginSizing;
var
   ParentForm: TcustomForm;

begin
     ParentForm:=GetParentForm(Self);
     if ParentForm <> nil then begin
          if ((fOrientation = wsVertical) or
              (fOrientation = wsHorizontal)) then begin
               fSizing:=True;
               SetCaptureControl(Self);

               if fOrientation=wsVertical then fDelta:=Point(0, Top)
                else fDelta:=Point(Left, 0);

                                                                                 // or DCX_LOCKWINDOWUPDATE
                  ParentForm.Canvas.Handle := GetDCEx(ParentForm.Handle, 0, DCX_CACHE or DCX_NORESETATTRS or DCX_CLIPSIBLINGS or DCX_LOCKWINDOWUPDATE);

                    ParentForm.Canvas.Pen.Width := 2;
                    ParentForm.Canvas.Pen.Color := clwhite;

                    priormode:=ParentForm.Canvas.pen.mode;
                    ParentForm.Canvas.pen.mode:=pmXor;

               DrawSizingLine;
          end;
     end;
end;

procedure TWinSplit.ChangeSizing(X, Y: Integer);
var
   OldfDelta: TPoint;
begin
     if Sizing then begin
          DrawSizingLine;
          OldfDelta:=fDelta;
          if fOrientation=wsVertical then fDelta.Y:=Y
           else fDelta.X:=X;
          DrawSizingLine;
     end;
end;

procedure TWinSplit.EndSizing;
var
  ParentForm: TcustomForm;
begin
     ParentForm:=GetParentForm(Self);
     fSizing:=False;

     DrawSizingLine;
      releasecapture;

     if ParentForm <> nil then begin
          with ParentForm do begin
               //DC := Canvas.Handle;
               //ParentForm.Canvas.Handle := 0;
               ReleaseDC(ParentForm.Handle, ParentForm.canvas.Handle);
               ParentForm.canvas.pen.mode:=priormode;
          end;
     end;

     fDelta:=Point(0,0);
    

end;

procedure TWinSplit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
   ParentForm: TcustomForm;
begin
     ParentForm:=GetParentForm(Self);
     if ParentForm<>nil then begin

          if Sizing then ChangeSizing(X, Y);


     end;
     inherited MouseMove(Shift, X, Y);
end;

procedure TWinSplit.CMMouseEnter(var Msg:TMessage);
begin

 if FshouldAnimate then begin
  FshouldAnimate:=false;
  GradientRect(color,0);
 end;

end;

procedure TWinSplit.CMMouseLeave(var Msg:TMessage);
begin

if not FShouldAnimate then begin
 FshouldAnimate:=true;
 GradientRect(0,color);
end;

end;


procedure TWinSplit.GradientRect(col1,col2:TColor);
Var
  Max, RC, GC, BC, R : byte;
  RStep, GStep, BStep : Real;
  Red, Green, Blue, Red1, Green1, Blue1, Red2, Green2, Blue2 : byte;
  app:TApplication;
begin
   app:=TApplication.create(nil);

   max:=30;

   { The GetRValue macro retrieves an intensity value for
   the Red component of a 32-bit red, green, blue (RGB) value. }
   Red1:=GetRValue(Col1);
   Green1:=GetGValue(Col1);
   Blue1:=GetBValue(Col1);

   Red2:=GetRValue(Col2);
   Green2:=GetGValue(Col2);
   Blue2:=GetBValue(Col2);

      Red:=Red1;
      Green:=Green1;
      Blue:=Blue1;

   if red1>red2 then RStep:=(Red1-Red2)/Max
    else RStep:=(Red2-Red1)/Max;
   if green1>Green2 then GStep:=(Green1-Green2)/Max
    else GStep:=(Green2-Green1)/Max;
   if Blue1>Blue2 then BStep:=(Blue1-Blue2)/Max
    else BStep:=(Blue2-Blue1)/Max;


   RC:=Red1;
   GC:=Green1;
   BC:=Blue1;

   canvas.lock;
   
   for R:=0 To Max do begin
     Canvas.brush.Color:=RGB(RC,GC,BC);

     if forientation=wsHorizontal then canvas.fillrect(rect(width div 2,0,(width div 2)+1,height))
      else canvas.fillrect(rect(0,height div 2,width,(height div 2)+1));

     if red1>red2 then RC:=Round(Red-R*RStep)
      else RC:=Round(Red+R*RStep);
     if green1>Green2 then GC:=Round(Green-R*GStep)
      else GC:=Round(Green+R*GStep);
     if Blue1>Blue2 then BC:=Round(Blue-R*BStep)
      else BC:=Round(Blue+R*BStep);

     app.processMessages;
     sleep(10);
   End;

   Canvas.brush.Color:=col2;

     if forientation=wsHorizontal then canvas.fillrect(rect(width div 2,0,(width div 2)+1,height))
      else canvas.fillrect(rect(0,height div 2,width,(height div 2)+1));

    canvas.Unlock;

   app.destroy;
end;


procedure TWinSplit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     if Sizing then begin
          xpos:=x;
          ypos:=y;
         EndSizing;
         Paint;
     end;

 inherited MouseUp(Button, Shift, X, Y);

 if Assigned(fOnEndSplit) then fOnEndSplit(Self);

end;

procedure TWinSplit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     inherited MouseDown(Button, Shift, X, Y);
     if (Button = mbLeft) and (Shift = [ssLeft]) then BeginSizing;
end;

{******************************************************************************}
{** TWinSplit Private Methods *************************************************}
{******************************************************************************}

procedure TWinSplit.DrawSizingLine;
var
  P: TPoint;
  ParentForm: TcustomForm;
begin
     ParentForm:=GetParentForm(Self);
     if ParentForm<>nil then begin

          P := CToC(ParentForm, Self, fDelta);
          with ParentForm.Canvas do begin

            if ((p.x>=0) and (p.y>=0) and (p.x<=ParentForm.width) and (p.y<=parentForm.height)) then begin
              if forientation=wsHorizontal then begin//ParentForm.Canvas.fillrect(rect(p.x,p.y,p.X+width,p.y+height));
               ParentForm.Canvas.MoveTo(P.X,P.Y);
               ParentForm.Canvas.LineTo(P.X, ftop+top+height);
              end else begin
               ParentForm.Canvas.MoveTo(P.X, p.y);
               ParentForm.Canvas.LineTo(fleft+left+width, p.y);
              end;
            end;

          end;

     end;
end;

procedure TWinSplit.Setorientation(Value: TWinSplitOrientation);
//var
//w,h:integer;
begin

//w:=width;
//h:=height;

 if value<>forientation then begin
  forientation:=value;
 // width:=h;
 // height:=w;

  if value=wsVertical then Cursor:=crsizeNS
   else Cursor:=crsizeWE;

   invalidate;
 end;


end;


end.
