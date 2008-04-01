unit bgimPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,Themes;

  //const
 // mxcolors=255;
  type
  ttipo_bitmap=(btmNone,
                btmPattern,
                btmStretch,
                btmNormal);
  ttipo_gradiente=(TGNone,
                   TGOriz,
                   TGVert);

type THeaderBodyDrawEvent = procedure(Sender:TObject; TargetCanvas:Tcanvas; aRect:Trect; HeaderColor:TColor) of object;
type TBackgroundDrawEvent = procedure(Sender:Tobject; TargetCanvas:Tcanvas; aRect:Trect; var should_continue:boolean) of object;
type TXPRoundDrawEvent = procedure(Sender:Tobject; TargetCanvas:Tcanvas; aRect:Trect; include_header:boolean; var should_continue:boolean) of object;
type TOnAfterDrawEvent = procedure(Sender:Tobject; TargetCanvas:Tcanvas) of object;
//type
  // TGrArray=array[1..mxcolors] of tcolor;
  // TGrArray_header=array[1..27] of tcolor;
type
  TbgimPanel = class(TPanel)
   constructor Create(AComponent: TComponent); override;
  private
       //fpicture:TBitmap;
       //ftipo_bitmap:ttipo_bitmap;
       FAlignment: TAlignment;
       Ftipo_gradiente:TTipo_gradiente;
       FColoreGradienteStart,FColoreGradienteEnd:Tcolor;
       FXPRoundCenter:boolean;
       FXPRoundCenterHeader:boolean;
       FXPRoundColor:TColor;
       FXPRoundWidth:integer;
       FXPRoundHeight:integer;
       FXPRoundLeft:integer;
       FXPRoundTop:integer;
       FDrawHeader:boolean;
       FHeaderColor:tcolor;
       FHeaderFont:tfont;
       FHeaderHeight:integer;
       FHeaderCaption:widestring;
       FHeaderCaptionLeft:integer;
       FHeaderCaptionTop:integer;
       //ga:tgrarray;
       //gnew:TGrArray_header;
       FWideCaption:widestring;
       FOwnerDraw:boolean;
       FOnDrawHeaderBody:THeaderBodyDrawEvent;
       FOnDrawBackGround:TBackgroundDrawEvent;
       FOnXPDrawRound:TXPRoundDrawEvent;
       FOnAfterDraw:TOnAfterDrawEvent;
       procedure SetAlignment(Value: TAlignment);
       //procedure SetBitmap(b:tbitmap);
       //Procedure BitmapChanged(sender:tobject);
       //procedure setbtmtype(value:ttipo_bitmap);
       procedure draw_sfondo(acanvas:tcanvas);
       procedure SetDrawHeader(value:boolean);
       procedure SetXPRoundCenterHeader(value:boolean);
       procedure SetHeaderColor(value:tcolor);
       procedure SetHeaderFont(value:tfont);
       procedure SetHeaderHeight(value:integer);
       procedure SetHeaderCaption(value:widestring);
       procedure SetWideCaption(value:widestring);
       procedure HeaderDraw(acanvas:tcanvas);
       procedure DrawHeaderBody(acanvas:tcanvas);
       procedure SetTipoGradiente(value:ttipo_gradiente);
       procedure SetHeaderCaptionLeft(value:integer);
       procedure SetHeaderCaptionTop(value:integer);
      // procedure CalcColGradients(col1,col2:tcolor;n:integer);
      // procedure CalcColGradients_header(col1,col2:tcolor;n:integer);
       //procedure VertOneWay(acanvas:tcanvas);
       //procedure HorzOneWay(acanvas:tcanvas);
       procedure SetColoreGradienteStart(value:tcolor);
       procedure SetColoreGradienteEnd(value:tcolor);
       procedure DrawXPRoundCenter(acanvas:tcanvas);
       procedure SetXpRoundCenter(value:boolean);
       procedure SetXPRoundTop(value:integer);
       procedure SetXPRoundLeft(value:integer);
       procedure SetXPRoundWidth(value:integer);
       procedure SetXPRoundHeight(value:integer);
       procedure SetXPRoundColor(value:Tcolor);
       procedure SetOwnerDraw(value:boolean);
       procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
  protected
    procedure paint; override;
  public
    property canvas;
  published
   property HeaderCaption:widestring read FHeaderCaption write SetHeaderCaption;
   property WideCaption:widestring read FWideCaption write SetWideCaption;
   property HeaderHeight:integer read FHeaderHeight write SetHeaderHeight;
   property HeaderFont:Tfont read FHeaderFont write SetHeaderFont;
   property DrawHeader:boolean read FDrawHeader write SetDrawHeader;
   property HeaderColor:Tcolor read FHeaderColor write SetHeaderColor;
   property HeaderCaptionLeft:integer read FheaderCaptionLeft write SetHeaderCaptionLeft;
   property HeaderCaptionTop:integer read FheaderCaptionTop write SetHeaderCaptionTop;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
   // property Bitmap:TBitmap read fpicture write SetBitmap;
   // property BtmType:ttipo_bitmap read ftipo_bitmap write setbtmtype;
    property tipo_gradiente:ttipo_gradiente read ftipo_gradiente write SetTipoGradiente;
    property ColoreGradienteStart:Tcolor read FColoreGradienteStart write SetColoreGradienteStart;
    property ColoreGradienteEnd:Tcolor read FColoreGradienteEnd write SetColoreGradienteEnd;
    procedure updateHeader;
    property XPRoundCenter:boolean read FXPRoundCenter write SetXPRoundCenter;
    property XPRoundTop:integer read FXPRoundTop write SetXPRoundTop;
    property XPRoundLeft:integer read FXPRoundLeft write SetXPRoundLeft;
    property XPRoundWidth:integer read FXPRoundWidth write SetXPRoundWidth;
    property XPRoundHeight:integer read FXPRoundHeight write SetXPRoundHeight;
    property XPRoundColor:tcolor read FXPRoundColor write SetXPRoundColor;
    property IsOwnerDraw:boolean read FOwnerDraw Write SetOwnerDraw;
    property XPRoundCenterHeader:boolean read FXPRoundCenterHeader write SetXPRoundCenterHeader;
    property OnDrawHeaderBody:THeaderBodyDrawEvent read FOnDrawHeaderBody write FOnDrawHeaderBody;
    property OnDrawBackground:TBackGroundDrawEvent read FOnDrawBackGround write FOnDrawBackGround;
    property OnXPDrawRound:TXPRoundDrawEvent read FOnXPDrawRound write FOnXPDrawRound;
    property OnAfterDraw:TOnAfterDrawEvent read FOnAfterDraw write FOnAfterDraw;
  end;

procedure Register;
//function utf8strtowidestr(strin:string):widestring;
//function UTF8BufToWideCharBuf(const utf8Buf; utfByteCount: integer; var unicodeBuf; var leftUTF8: integer): integer;



implementation

procedure tbgimpanel.WMEraseBkgnd(Var Msg : TMessage);
begin
 msg.result:=1;
end;

procedure tbgimpanel.SetHeaderCaptionLeft(value:integer);
begin
FHeaderCaptionLeft:=value;
HeaderDraw(canvas);
end;

procedure tbgimpanel.SetHeaderCaptionTop(value:integer);
begin
FHeaderCaptionTop:=value;
HeaderDraw(canvas);
end;

procedure tbgimpanel.SetXpRoundCenter(value:boolean);
begin
FXPRoundCenter:=value;
invalidate;
end;

procedure tbgimpanel.SetXpRoundCenterHeader(value:boolean);
begin
FXPRoundCenterHeader:=value;
invalidate;
end;

procedure tbgimpanel.SetXPRoundTop(value:integer);
begin
FXPRoundTop:=value;
invalidate;
end;

procedure tbgimpanel.SetOwnerDraw(value:boolean);
var
cst:TcontrolStyle;
begin
FOwnerDraw:=value;
 cst:=self.ControlStyle;
if FOwnerDraw then Include(cst,CSOpaque) else
EXclude(cst,CSOpaque);
 self.controlStyle:=cst;

invalidate;
end;

procedure tbgimpanel.SetXPRoundLeft(value:integer);
begin
FXPRoundLeft:=value;
invalidate;
end;

procedure tbgimpanel.SetXPRoundWidth(value:integer);
begin
FXPRoundWidth:=value;
invalidate;
end;

procedure tbgimpanel.SetXPRoundHeight(value:integer);
begin
FXPRoundHeight:=value;
invalidate;
end;

procedure tbgimpanel.SetXPRoundColor(value:Tcolor);
begin
FXPRoundColor:=value;

invalidate;
end;

procedure tbgimpanel.updateHeader;
begin
DrawHeaderBody(canvas);
end;

procedure tbgimpanel.HeaderDraw(acanvas:tcanvas);
var
r:trect;
begin

      // r:=rect(0,0,clientwidth+1,FHEaderHeight+1);
     //  DrawEdge(aCanvas.Handle, r, EDGE_ETCHED, BF_RECT {+ BF_SOFT});

       //r:=rect(2,2,width-1,FHEaderHeight-1);
       //acanvas.pen.color:=clbtnface;
       //acanvas.brush.color:=clbtnface;
       //acanvas.fillrect(r);



       DrawHeaderBody(acanvas);
{ exit;
 //   bevelinner:=bvspace;
 //  bevelouter:=bvLowered;

acanvas.pen.color:=$0099A8AC;
acanvas.Brush.color:=$0099A8AC;
r.left:=width-1;
r.Right:=width;
r.top:=0;
r.bottom:=FHEaderHeight;
acanvas.fillrect(r);


acanvas.pen.color:=clwhite;
acanvas.Brush.color:=clwhite;

r.Left:=2;
r.Right:=width-1;
r.Top:=1;
r.Bottom:=2;
acanvas.fillrect(r);

r.right:=3;
r.Bottom:=FHeaderHeight-1;
acanvas.fillrect(r);

acanvas.Brush.color:=$0099A8AC;
acanvas.Pen.color:=$0099A8AC;
r.Left:=1;
r.Right:=width-1;
r.Top:=FheaderHeight-1;
r.Bottom:=FHeaderHeight;
acanvas.fillrect(r);

DrawHeaderBody(acanvas); }
end;

procedure TbgImPanel.DrawHeaderBody(acanvas:tcanvas);
var
r:trect;
Details: TThemedElementDetails;
begin
//r.left:=0{2};
//r.right:=width{-1};
//r.top:=0{2};
//r.bottom:=FHeaderHeight-1;
//acanvas.brush.color:=FHeaderColor;  }
     acanvas.brush.color:=color;
     acanvas.pen.color:=cl3ddkshadow;
     acanvas.rectangle(rect(-1,-1,clientwidth,FHeaderHeight));

  r:=rect(0,0,clientwidth,FHeaderHeight);
 if assigned(FonDrawHeaderBody) then FOnDrawHeaderBody(self,acanvas,r,fheadercolor);

     {  r.top:=FHEaderHeight;
       r.bottom:=r.top+1;
       r.left:=1;
       r.right:=width-1;

       acanvas.brush.color:=color;
       acanvas.pen.color:=color;
       //acanvas.fillrect(r);

       r.right:=1;
       r.left:=0;
       r.top:=FHEaderHeight;
       r.bottom:=r.top+2;
       acanvas.brush.color:=clgray;
       acanvas.pen.color:=clgray;
    //   acanvas.fillrect(r);
       r.right:=width;
       r.left:=r.right-1;    }
     //  acanvas.fillrect(r);


acanvas.font:=FHeaderFont;
r.left:=FHeaderCaptionLeft+2;
r.right:=width-2;
r.top:=FHeaderCaptionTop;
r.bottom:=FHeaderHeight;
SetBkMode(acanvas.Handle, TRANSPARENT);
     // DrawText
//windows.DrawTextW(acanvas.handle,pwidechar(FHeaderCaption),length(FHeaderCaption),r,DT_LEFT	);
Windows.ExtTextOutW(acanvas.Handle, 4, 4, 0, @R, PwideChar(FHeaderCaption),Length(FHeaderCaption), nil);
end;

procedure TbgImPanel.SetHeaderCaption(value:widestring);
begin
FHeaderCaption:=value;
HeaderDraw(canvas);
end;

procedure TbgImPanel.SetWideCaption(value:widestring);
begin
FWideCaption:=value;
invalidate;
end;

procedure TbgImPanel.SetHeaderHeight(value:integer);
begin
FHeaderHeight:=value;
invalidate;
end;

procedure TbgImPanel.SetHeaderFont(value:TFont);
begin
FHeaderFont:=value;
invalidate;
end;

procedure TbgImPanel.SetHeaderColor(value:Tcolor);
begin
FHeaderColor:=value;
invalidate;
end;

procedure TbgImPanel.SetDrawHeader(value:boolean);
begin
FDrawHeader:=value;
invalidate;
end;

constructor TbgimPanel.Create(AComponent: TComponent);
//var cst:Tcontrolstyle;
begin
   inherited Create(AComponent);
    DoubleBuffered:=true;
    
       FDrawHeader:=false;
       FHeaderColor:=color;
       FHeaderFont:=font;
       FHeaderHeight:=20;
       FHeaderCaption:='';
       FHeaderCaptionTop:=2;
       FHeaderCaptionLeft:=2;

  { fpicture:=tbitmap.create;
   fpicture.width:=50;
   fpicture.height:=50;
   fpicture.canvas.brush.color:=clwhite;
   fpicture.canvas.rectangle(0,0,49,49);
   fpicture.OnChange:=bitmapchanged;
   ftipo_bitmap:=btmnone;}
   ControlStyle := ControlStyle + [csOpaque];
   //cst:=self.ControlStyle;
   //Exclude(cst,CSOpaque);
   //self.controlStyle:=cst;

   FOwnerDraw:=false;
   FheaderFont:=font;

    Ftipo_gradiente:=TGNone;
    FColoreGradienteStart:=$00F6F5F3;
    FColoreGradienteEnd:=$00D6EAEE;

   FXPRoundCenter:=false;
   FXPRoundCenterHeader:=false;
    FXPRoundLeft:=10;
    FXPRoundTop:=10;
    FXPRoundWidth:=width-20;
    FXPRoundHeight:=height-20;
    FXPRoundColor:=$00F7DFD6;
    //   CalcColGradients_header($00D87849,$00CB4D1D,26);
end;

//Procedure  TbgimPanel.BitmapChanged(sender:tobject);
//begin
//repaint;
//end;


procedure TbgimPanel.SetAlignment(Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;

//procedure TbgimPanel.setbtmtype(value:ttipo_bitmap);
//begin
//ftipo_bitmap:=value;
//repaint;
//end;

//procedure tbgimpanel.SetBitmap(b:tbitmap);
//begin
//if b=nil then ftipo_bitmap:=btmnone;

//  fpicture.assign(b);
//end;

procedure tbgimpanel.DrawXPRoundCenter(acanvas:tcanvas);
var
offsety,i:integer;
Banda,rec : TRect;
should_continue:boolean;
begin


                 //    $00D7754A

  should_continue:=true;

  if assigned(FOnXPDrawRound) then begin
   rec:=rect(FXPRoundLeft,FXPRoundTop,FXPRoundLeft+FXPRoundWidth,FXPRoundTop+FXPRoundHeight);
   FOnXPDrawRound(self,acanvas,rec,FXPRoundCenterHeader,should_continue);
  end;

  if not should_continue then exit;

    offsety:=FXPRoundTop;

  // if not FXPRoundCenterHeader then begin
    acanvas.Pen.color:=clwhite;
    acanvas.brush.color:=FXPRoundColor;
    acanvas.RoundRect(FXPRoundLeft,FXPRoundTop,FXPRoundLeft+FXPRoundWidth,FXPRoundTop+FXPRoundHeight,10,10);
   // exit;
  // end;

end;

procedure tbgimpanel.paint;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
var i,j,k:integer;
    x,y:integer;
    r:trect;
    FontHeight:integer;
    flags:integer;
    //bitmap:tbitmap;
begin


if not FownerDraw then begin
 inherited paint;
 exit;
end;
    // bitmap:=tbitmap.create;
     //try
     // bitmap.width:=width;
     // bitmap.height:=height;
     // bitmap.pixelformat:=pf24bit;
      inherited;
         if FDrawHeader then HeaderDraw(canvas);
         
         draw_sfondo(canvas);
         if FXpRoundCenter then DrawXPRoundCenter(canvas);

 if fwidecaption<>'' then begin
  Canvas.brush.style:=bsclear;
  canvas.Font := Font;

  FontHeight := canvas.TextHeight('W');
    with R do begin
      Top := ((Bottom + Top) - FontHeight) div 2;
      Bottom := Top + FontHeight;
    end;

    Flags := DT_EXPANDTABS or DT_VCENTER or Alignments[FAlignment];
    Flags := DrawTextBiDiModeFlags(Flags);

     r.Left:=0;
     r.top:=4;
     r.Right:=width;
     r.Bottom:=height;
    //windows.DrawTextW(canvas.Handle, PWideChar(FWideCaption), length(FWideCaption), R, Flags);
    Windows.ExtTextOutW(canvas.Handle, 2, 3, 0, @R, PwideChar(FWideCaption),Length(FWideCaption), nil);
 end;


    
    if assigned(FOnAfterDraw) then FOnAfterDraw(self,canvas);

    // bitblt(canvas.handle,0,0,width,height,bitmap.canvas.Handle,0,0,SRCCOPY);
    // finally
   // bitmap.free;
    //end;
end;

procedure tbgimpanel.SetTipoGradiente(value:ttipo_gradiente);
begin
Ftipo_Gradiente:=value;
invalidate;
end;

procedure tbgimpanel.SetColoreGradienteStart(value:Tcolor);
begin
FColoreGradienteStart:=value;
invalidate;
end;

procedure tbgimpanel.SetColoreGradienteEnd(value:Tcolor);
begin
FColoreGradienteEnd:=value;
invalidate;
end;

procedure tbgimpanel.draw_sfondo(acanvas:tcanvas);    //qui riempiamo sfondo o disegniamo gradiente
var should_continue:boolean;
r:trect;
begin
should_continue:=true;

 if assigned(FOnDrawBackGround) then begin  //se non ho XP torno con should_continue:=true
  r:=rect(0,FHeaderHeight,width,height);
  FOnDrawBackGround(self,acanvas,r,should_continue);
 end;

if not should_continue then exit;

  //if ftipo_gradiente=TGOriz then begin
  // CalcColGradients(FColoreGradienteStart,FColoreGradienteEnd,mxcolors);
  // VertOneWay(acanvas);
  //end else
 // if ftipo_gradiente=TGVert then begin
   //CalcColGradients(FColoreGradienteStart,FColoreGradienteEnd,mxcolors);
   //HorzOneWay(acanvas);
  //end else begin
   acanvas.brush.color:=color;
   acanvas.pen.color:=color;
   if FDrawHeader then acanvas.rectangle(0,FHeaderHeight{-1},width,height)
    else acanvas.rectangle(0,0,width,height);
 // end;

end;

{procedure tbgimpanel.HorzOneWay(acanvas:tcanvas);
var
  Banda : TRect;
  I         : Integer;
  offsety:integer;
begin
   Banda.Left := 0;
   acanvas.brush.color:=FColoreGradienteStart;
   acanvas.pen.color:=FColoreGradienteStart;

   if FDrawHeader then begin
    offsety:=FHeaderHeight+FXPRoundHeight;
    acanvas.rectangle(0,FHeaderHeight,width,offsety);
   end else begin
    offsety:=FXPRoundHeight;
    acanvas.rectangle(0,0,width,offsety);
   end;

   Banda.Right := Width;
   with acanvas do
   for I := 0 to mxcolors-1 do
   begin
       Banda.Top    := MulDiv (I    , (Height-offsety), mxcolors)+offsety;
       Banda.Bottom := MulDiv (I + 1, (Height-offsety), mxcolors)+offsety;
       Brush.Color := ga[i+1];
       FillRect (Banda);
   end; // $00D7754A   $00D15F2E
end;

procedure tbgimpanel.VertOneWay(acanvas:tcanvas);
var
  Banda : TRect;
  I         : Integer;
  offsety:integer;
begin
if FDrawHeader then offsety:=FHeaderHeight else offsety:=0;
   Banda.Top := offsety;
   Banda.Bottom := Height-offsety;
   with acanvas do
   for I := 0 to mxcolors-1 do
   begin
       Banda.Left    := MulDiv (I    , Width, mxcolors);
       Banda.Right := MulDiv (I + 1, Width, mxcolors);
       Brush.Color := ga[i+1];
       FillRect (Banda);
   end;
end; }

procedure Register;
begin
  RegisterComponents('Comet', [TbgimPanel]);
end;

{function utf8strtowidestr(strin:string):widestring;
var lung,left:integer;
begin
if length(strin)=0 then begin
result:='';
exit;
end;
 setlength(result,length(strin));
 lung:=UTF8BufToWideCharBuf(strin[1],length(strin),result[1],left);
 setlength(result,lung div sizeof(widechar));
end;

function UTF8BufToWideCharBuf(const utf8Buf; utfByteCount: integer; var unicodeBuf; var leftUTF8: integer): integer;
var
  c1 : byte;
  c2 : byte;
  ch : byte;
  pch: PChar;
  pwc: PWideChar;
begin
  pch := @utf8Buf;
  pwc := @unicodeBuf;
  leftUTF8 := utfByteCount;
  while leftUTF8 > 0 do begin
    ch := byte(pch^);
    Inc(pch);
    if (ch AND $80) = 0 then begin // 1-byte code
      word(pwc^) := ch;
      Inc(pwc);
      Dec(leftUTF8);
    end
    else if (ch AND $E0) = $C0 then begin // 2-byte code
      if leftUTF8 < 2 then
        break;
      c1 := byte(pch^);
      Inc(pch);
      word(pwc^) := (word(ch AND $1F) SHL 6) OR (c1 AND $3F);
      Inc(pwc);
      Dec(leftUTF8,2);
    end
    else begin // 3-byte code
      if leftUTF8 < 3 then
        break;
      c1 := byte(pch^);
      Inc(pch);
      c2 := byte(pch^);
      Inc(pch);
      word(pwc^) :=
        (word(ch AND $0F) SHL 12) OR
        (word(c1 AND $3F) SHL 6) OR
        (c2 AND $3F);
      Inc(pwc);
      Dec(leftUTF8,3);
    end;
  end; //while
  Result := integer(pwc)-integer(@unicodeBuf);
end;  UTF8BufToWideCharBuf }

{procedure tbgimpanel.CalcColGradients(col1,col2:tcolor;n:integer);
   var i:integer;
       ar,ag,ab,br,bb,bg:integer;
       kr,kg,kb:real;
   begin
     ar:=GetRValue(col1);br:=GetRValue(col2);
     AG:=GetGValue(col1);bG:=GetGValue(col2);
     AB:=GetBValue(col1);bB:=GetBValue(col2);
     kr:=(br-ar) /n;
     kg:=(bg-ag) /n;
     kb:=(bb-ab) /n;
     for i:=0 to n-1 do
     ga[i+1]:=rgb(trunc(ar + i*kr),trunc(ag+i*kg),trunc(ab+i*kb));
   end;

procedure tbgimpanel.CalcColGradients_header(col1,col2:tcolor;n:integer);
   var i:integer;
       ar,ag,ab,br,bb,bg:integer;
       kr,kg,kb:real;
   begin
     ar:=GetRValue(col1);br:=GetRValue(col2);
     AG:=GetGValue(col1);bG:=GetGValue(col2);
     AB:=GetBValue(col1);bB:=GetBValue(col2);
     kr:=(br-ar) /n;
     kg:=(bg-ag) /n;
     kb:=(bb-ab) /n;
     for i:=0 to n-1 do
     gnew[i+1]:=rgb(trunc(ar + i*kr),trunc(ag+i*kg),trunc(ab+i*kb));
   end; }



end.
