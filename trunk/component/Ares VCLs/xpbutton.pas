unit XPbutton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs , Extctrls,imglist;

  type TCometBtnState = set of (csEnabled,csHover, csDown, csClicked);

 type TXPButtonDrawEvent = procedure(Sender:Tobject; TargetCanvas:Tcanvas; Rect:Trect; state:TCometBtnState; var should_continue:boolean) of object;
 //type TXPButtonArrowClickEvent = procedure(Sender:Tobject) of object;
 // type TXPButtonNeutralClickEvent = procedure(Sender:Tobject) of object;

// type
 //   TGrArray=array[1..100] of tcolor;
type
  TXPbutton = class(TPanel)
  private

    fimagelist:timagelist;

    findex_down:byte;
    findex_over:byte;
    findex_off:byte;

    ftextw,ftexth:integer;

    fcaption:widestring;
    fcolorbg:tcolor;
    fbackBitmap:graphics.tbitmap;
    fstate:TCometBtnState;
    fimgleft,fimgtop:integer;

    FXPButtonOnDraw:TXPButtonDrawEvent;
    //FOnArrowClick:TXPButtonArrowClickEvent;
    //FOnNeutralClick:TXPButtonNeutralClickEvent;
    FOnClick:TNotifyEvent;

    procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
    procedure setftextw(value:integer);
    procedure setftexth(value:integer);
    procedure setenableState(value:boolean);
    function getEnableState:boolean;
    procedure setcolorbg(value:tcolor);

    procedure setdownState(value:boolean);
    function getDownState:boolean;
    procedure setcaption(value:string);
    function getcaption:string;
    procedure setState(value:TCometBtnState);

  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure WMPosChg(var Msg : TMessage); message WM_WINDOWPOSCHANGED;
  public

    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure loaded; override;
  published
    property enabled:boolean read GetEnableState write setEnableState;
    property index_down:byte read findex_down write findex_down;
    property index_over:byte read findex_over write findex_over;
    property index_off:byte read findex_off write findex_off;
    property imagelist:timagelist read fimagelist write fimagelist;
    property caption:string read getcaption write setcaption;
    property textleft:integer read ftextw write setftextw;
    property texttop:integer read ftexth write setftexth;
    property imgleft:integer read fimgleft write fimgleft;
    property imgtop:integer read fimgtop write fimgtop;
    property colorbg:tcolor read fcolorbg write setcolorbg;
    property Hint;
    property Down:boolean read getDownState write setdownState;
    property state:TCometBtnState read FState write setState;
    property OnClick:TNotifyEvent read FOnClick write FOnClick;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property font;
    property OnXPButtonDraw:TXPButtonDrawEvent read FXPButtonOnDraw write FXPButtonOnDraw;
   // property OnArrowClick:TXPButtonArrowClickEvent read FOnArrowClick write FOnArrowClick;
  //  property OnNeutralClick:TXPButtonNeutralClickEvent read FOnNeutralClick write FOnNeutralClick;
  end;

procedure Register;
function utf8strtowidestr(strin:string):widestring;
function UTF8BufToWideCharBuf(const utf8Buf; utfByteCount: integer; var unicodeBuf; var leftUTF8: integer): integer;
function widestrtoutf8str(strin:widestring):string;
function WideCharBufToUTF8Buf(const unicodeBuf; uniByteCount: integer; var utf8Buf): integer;

//{$R Data.res}

implementation

procedure TXPButton.setState(value:TCometBtnState);
begin
FState:=value;
invalidate;
end;

function TXPButton.getDownState:boolean;
begin
 result:=(csDown in fstate);
end;

function TXPButton.getEnableState:boolean;
begin
 result:=(csEnabled in fstate);
end;

constructor TXPbutton.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  fstate:=[csEnabled];


  fimagelist:=nil;
  
  fImgTop:=1;
  fImgLeft:=7;
  ftexth:=3;

  //FFrameRgn:=0;
  //ControlStyle := ControlStyle - [csOpaque] + [csNoStdEvents];
  Width := 120;
  Height := 50;
  fcolorbg:=clbtnface;
 { font.name:='Tahoma';
  font.size:=8;
  font.style:=[];
  font.pitch:=fpFixed;
  font.color:=clblack; }
  fbackBitmap:=graphics.tbitmap.create;
  fbackbitmap.pixelformat:=pf24Bit;

  FOnClick:=nil;

  //FFrameRgn:=CreateRoundRectRgn(0,0, width, height,8,8);//<shape type="roundRect" rect="0,0,-1,-1" size="4,4"/>
 // SetWindowRgn(self.Handle, FFrameRgn, true);

  invalidate;
end;

procedure TXPButton.loaded;
begin
 bevelOuter:=bvNone;
 bevelInner:=bvNone;
end;

procedure TXPbutton.WMEraseBkgnd(var Msg:TMessage);  //no flicker!
begin
  Msg.Result := 1;
end;

procedure TXPbutton.Paint;
var
 r:trect;
 should_Continue:boolean;
begin
 try
   r.left:=0;
   r.right:=width;
   r.top:=0;
   r.bottom:=height;

  if (csDesigning in componentstate) then begin
   canvas.brush.color:=clblack;
   canvas.framerect(r);
  exit;
 end;

   fbackbitmap.width:=width;
   fbackBitmap.Height:=height;



   if assigned(FXPButtonOnDraw) then begin
    r:=rect(0,0,width,height);
    FXPButtonOnDraw(self,fbackBitmap.canvas,r,fstate,should_continue);
    //if not should_continue then begin
    //   canvas.lock;
    //    bitBlt(canvas.handle,0,0,width,height,
    //           fbackBitmap.canvas.Handle,0,0,SRCCOPY);
    //   canvas.unlock;
    // exit;
    //end;
   end else should_continue:=true;



if should_continue then begin
  fbackbitmap.canvas.brush.color:=fcolorbg;
  fbackbitmap.canvas.pen.color:=fcolorbg;
  fbackbitmap.canvas.rectangle(0,0,width,height);


 if (csDown in fstate) or (csClicked in fstate) then begin
  DrawEdge(fbackbitmap.canvas.Handle, r, 2, BF_MIDDLE or BF_RECT);
  fbackbitmap.canvas.Brush.Bitmap:=AllocPatternBitmap(fcolorbg, clBtnHighlight);
  fbackbitmap.canvas.FillRect(rect(2,2,width-2,height-2));
 end else
 if (csHover in fstate) then begin
  DrawEdge(fbackbitmap.canvas.Handle, r, EDGE_RAISED, BF_RECT + BF_SOFT);
 end;

end;


//icons and text
if (csDown in fstate) or ((csClicked in fstate)) and (csHover in fstate) then begin
 if imagelist<>nil then begin
  imagelist.drawingstyle:=dsTransparent;
  imagelist.draw(fbackBitmap.canvas,imgleft+1,imgtop+1,findex_down,true);
 end;
 fbackBitmap.Canvas.Brush.Style:=bsClear;
 fbackBitmap.canvas.font:=font;
 Windows.ExtTextOutW(fbackBitmap.canvas.Handle, ftextw+1, ftexth+1, 0, nil, PwideChar(fcaption),Length(fcaption), nil);
end else begin
 if imagelist<>nil then begin
  imagelist.drawingstyle:=dsTransparent;
  if (csHover in fstate) then imagelist.draw(fbackBitmap.canvas,imgleft,imgtop,findex_over,true)
   else imagelist.draw(fbackBitmap.canvas,imgleft,imgtop,findex_off,true);
 end;
 fbackBitmap.Canvas.Brush.Style:=bsClear;
 fbackBitmap.canvas.font:=font;
 Windows.ExtTextOutW(fbackBitmap.canvas.Handle, ftextw, ftexth, 0, nil, PwideChar(fcaption),Length(fcaption), nil);
end;


  canvas.lock;
    bitBlt(canvas.handle,0,0,width,height,
           fbackBitmap.canvas.Handle,0,0,SRCCOPY);
  canvas.unlock;
// bitblt(canvas.handle,0,0,width,height,bitmap.canvas.handle,0,0,SRCCOPY);
 //
 //bitmap.free;
except
end;
end;


procedure TXPbutton.WMPosChg(var Msg : TMessage);
begin
  Invalidate;
  inherited;
end;





procedure TXPbutton.CMMouseLeave(var Msg:TMessage);
var
shouldRedraw:boolean;
begin
if fstate=[] then exit;

 shouldRedraw:=(csHover in fstate);
 exclude(fstate,csHover);

 if shouldRedraw then invalidate;
end;

procedure TXPbutton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
shouldRedraw:boolean;
begin
if (csHover in fstate) then exit;

if (x<0) or (x>width) or (y<0) or (y>height) then begin
 shouldRedraw:=(csHover in fstate);
 exclude(fstate,csHover);
end else begin
 shouldRedraw:=(not (csHover in fstate));
 include(fstate,csHover);
end;

if shouldRedraw then invalidate;
end;

procedure TXPbutton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if (csClicked in fstate) then exit;

include(fstate,csClicked);
invalidate;

inherited;
end;

procedure TXPbutton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); 
var
shouldRedraw:boolean;
begin
if not (csClicked in fstate) then exit;

if (x<0) or (x>width) or (y<0) or (y>height) then begin
  shouldRedraw:=(csClicked in fstate);
  exclude(fState,csClicked);
  if shouldRedraw then invalidate;
exit;
end;

if assigned(FOnClick) then FOnClick(self);

exclude(fstate,csClicked);
invalidate;
end;

destructor TXPbutton.Destroy;
begin
  fbackBitmap.free;
  fcaption:='';
  inherited Destroy;
end;



procedure Register;
begin
  RegisterComponents('Comet', [TXPbutton]);
end;

procedure TXPbutton.setftextw(value:integer);
begin
ftextw:=value;
invalidate;
end;

procedure TXPbutton.setcolorbg(value:tcolor);
begin
fcolorbg:=value;

if imagelist<>nil then begin
imagelist.blendcolor:=fcolorbg;
imagelist.bkcolor:=fcolorbg;
end;

invalidate;
end;

procedure TXPbutton.setftexth(value:integer);
begin
ftexth:=value;
invalidate;
end;

procedure TXPbutton.setenableState(value:boolean);
begin
if value then include(fstate,csEnabled)
 else fstate:=[];
invalidate;
end;

procedure txpbutton.setdownState(value:boolean);
begin

if value then include(fstate,csDown)
 else exclude(fstate,csDown);

invalidate;
end;

procedure txpbutton.setcaption(value:string);
var
size:tsize;
begin
fcaption:=utf8strtowidestr(value);

if length(value)<2 then exit;

canvas.font:=font;
  size.cX := 0;
  size.cY := 0;
  Windows.GetTextExtentPointW(canvas.handle, PwideChar(fcaption), Length(fcaption), size);

 width:=ftextw+size.cX+6;

 //if GetWindowRgn(self.handle,FFrameRgn)<>ERROR then DeleteObject(FFrameRgn);
 //FFrameRgn:=CreateRoundRectRgn(0,0, width, height,8,8);//<shape type="roundRect" rect="0,0,-1,-1" size="4,4"/>
 //SetWindowRgn(Handle, FFrameRgn, true);


invalidate;
end;

function txpbutton.getcaption:string;
begin
result:=widestrtoutf8str(fcaption);
end;

function widestrtoutf8str(strin:widestring):string;
var lung:integer;
begin
if length(strin)=0 then begin
result:='';
exit;
end;
 setlength(result,length(strin)*3);
 lung:=WideCharBufToUTF8Buf(strin[1],length(strin)*sizeof(widechar),result[1]);
 setlength(result,lung);
end;

function WideCharBufToUTF8Buf(const unicodeBuf; uniByteCount: integer; var utf8Buf): integer;
var
  iwc: integer;
  pch: PChar;
  pwc: PWideChar;
  wc : word;

  procedure AddByte(b: byte);
  begin
    pch^ := char(b);
    Inc(pch);
  end; { AddByte }

begin { WideCharBufToUTF8Buf }
  pwc := @unicodeBuf;
  pch := @utf8Buf;
  for iwc := 1 to uniByteCount div SizeOf(WideChar) do begin
    wc := Ord(pwc^);
    Inc(pwc);
    if (wc >= $0001) and (wc <= $007F) then begin
      AddByte(wc AND $7F);
    end
    else if (wc >= $0080) and (wc <= $07FF) then begin
      AddByte($C0 OR ((wc SHR 6) AND $1F));
      AddByte($80 OR (wc AND $3F));
    end
    else begin // (wc >= $0800) and (wc <= $FFFF)
      AddByte($E0 OR ((wc SHR 12) AND $0F));
      AddByte($80 OR ((wc SHR 6) AND $3F));
      AddByte($80 OR (wc AND $3F));
    end;
  end; //for
  Result := integer(pch)-integer(@utf8Buf);
end; { WideCharBufToUTF8Buf }




function utf8strtowidestr(strin:string):widestring;
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
end; { UTF8BufToWideCharBuf }

end.
