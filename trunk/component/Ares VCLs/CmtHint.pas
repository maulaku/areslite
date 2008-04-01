unit CmtHint;
{
  Hint95 version 1.05 *** BETA ***

  by Torsten Detsch
  email: tdetsch@bigfoot.com


  You are free to use, modify and distribute this code as you like. But I
  ask you to send me a copy of new versions. And please give me credit when
  you use parts of my code in other components or applications.


  Credits: THint95 is based on TDanHint by Dan Ho (danho@cs.nthu.edu.tw).
  I also got some ideas from TToolbar97 by Jordan Russell (jordanr@iname.com).


  Changes to this version:

  1.05  Fixes and minor improvements:
          - Dropped some source code that was not necessary.
          - Joe Chizmas fixed a bug that caused Delphi 3 to loose its hints when
            used together with Hint95.
          - Changed the code for finding the font Tahoma again. Now there is a
            Boolean variable that holds the state of the font Tahoma. This var
            is updates whenever a WM_FONTCHANGE occurs.
          - Hopefully fixed a bug that caused the tooltips to have a wordbreak
            when there shouldn't be one. 

}

//{$IFNDEF WIN32} Delphi 1 is not supported by Hint95. Sorry! {$ENDIF}

interface

uses
  Classes, Windows, Graphics, Messages, Controls, Forms,sysutils;

//const
 // Hint95Version = '1.05';

type
  { THint95 }

 // THintStyle = (hsFlat, hsOffice97, hsWindows95);

  TCmtHint = class(TComponent)
  private
   // FTahomaAvail: Boolean; { True when Tahoma is available. }
    FHintFont: TFont;
    //FHintStyle: THintStyle;
    FWindowHandle: HWND;
    FOnShowHint: TShowHintEvent;
    Fhintbgcolor:tcolor;
    procedure GetHintInfo(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
   // procedure GetTahomaAvail;
    procedure GetTooltipFont;
  //  procedure SetHintStyle(AHintStyle: THintStyle);
    procedure WndProc(var Msg: TMessage);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    //property HintStyle: THintStyle read FHintStyle write SetHintStyle default hsWindows95;
    property OnShowHint: TShowHintEvent read FOnShowHint write FOnShowHint;
    property bgcolor:tcolor read Fhintbgcolor write Fhintbgcolor;
    property Font:Tfont read FHintFont write FHintFont;
  end;

  { THintWindow95 }

  TCmtHintWindow = class(THintWindow)
  private
    FHint: TCmtHint;
    ACapt: string;
    FTextHeight, FTextWidth: Integer;
    function FindHint: TCmtHint;
  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); Override;
    function CalcHintRect(MaxWidth: Integer; const AHint: String; AData: Pointer): TRect; override;
  published
  end;


function utf8strtowidestr(strin:string):widestring;
function UTF8BufToWideCharBuf(const utf8Buf; utfByteCount: integer; var unicodeBuf; var leftUTF8: integer): integer;
procedure Register;

implementation

var
  HintControl: TControl; { control the tooltip belongs to }
  HintMaxWidth: Integer; { max width of the tooltip }

procedure Register;
begin
  RegisterComponents('Comet', [TCmtHint]);
end;

constructor TCmtHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if not (csDesigning in ComponentState) then begin
    HintWindowClass := TCmtHintWindow;
    FWindowHandle := AllocateHWnd(WndProc);

    with Application do begin
      ShowHint := not ShowHint;
      ShowHint := not ShowHint;
      OnShowHint := GetHintInfo;

      { NOTE: These values are similar to those Win95 uses. But Win95
        does only display a tooltip when the mouse cursor doesn't move
        on the control anymore. Delphi doesn't do this. }
      HintShortPause := 25;
      HintPause := 500;
      HintHidePause := 5000;
    end;
  end;

 // FHintStyle := hsWindows95;
  FHintFont := TFont.Create;
  FHintFont.Color := clInfoText;
  Fhintbgcolor:=GetSysColor(COLOR_INFOBK);
 // GetTahomaAvail;
  GetTooltipFont;
end;

destructor TCmtHint.Destroy;
begin
  FHintFont.Free;
  if not (csDesigning in ComponentState) then DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

procedure TCmtHint.GetHintInfo(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if Assigned(FOnShowHint) then FOnShowHint(HintStr, CanShow, HintInfo);
  HintControl := HintInfo.HintControl;
  HintMaxWidth := HintInfo.HintMaxWidth;
end;

//procedure THint95.GetTahomaAvail;
//begin
 // FTahomaAvail := Screen.Fonts.IndexOf('Tahoma') <> -1;
//end;

procedure TCmtHint.GetTooltipFont;
var
  NCM: TNonClientMetrics;
begin
  { Get tooltip font using SystemParametersInfo }
  NCM.cbSize := SizeOf(TNonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, NCM.cbSize, @NCM, 0);
  with NCM.lfStatusFont, FHintFont do begin
    Name := lfFaceName;
    Height := lfHeight;
    Style := [];
    if lfWeight > FW_MEDIUM then Style := Style + [fsBold];
    if lfItalic <> 0 then Style := Style + [fsItalic];
    if lfUnderline <> 0 then Style := Style + [fsUnderline];
    if lfStrikeOut <> 0 then Style := Style + [fsStrikeOut];
    Pitch := TFontPitch(lfPitchAndFamily);
    {$IFNDEF VER90} { Delphi 3 or C++Builder }
    CharSet := TFontCharSet(lfCharSet);
    {$ENDIF}
  end;

  { Office 97 style? Then use Tahoma instead of MS Sans Serif }
  //if (FHintFont.Name='MS Sans Serif') and FTahomaAvail then FHintFont.Name := 'Tahoma';
end;

//procedure THint95.SetHintStyle(AHintStyle: THintStyle);
//begin
//  if AHintStyle <> FHintStyle then begin
//    FHintStyle := AHintStyle;
//    if FHintStyle = hsOffice97 then GetTooltipFont;
//  end;
//end;

procedure TCmtHint.WndProc(var Msg: TMessage);
begin
  with Msg do
    case Msg of
      WM_SETTINGCHANGE: GetTooltipFont;
      //WM_FONTCHANGE: GetTahomaAvail;
      { ^ Update TahomaAvail whenever a font was installed or removed. }
      else Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
    end;
end;

{ THintWindow95 }

function TCmtHintWindow.FindHint: TCmtHint;
var
  I: Integer;
begin
  Result := nil;

  with Application.MainForm do
  for I := 0 to ComponentCount-1 do
    if Components[I] is TCmtHint then begin
      Result := TCmtHint(Components[I]);
      Break;
    end;
end;

procedure TCmtHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style - WS_BORDER;
end;

procedure TCmtHintWindow.Paint;
var
  DC: HDC;
  R, RD: TRect;
  //Brush, SaveBrush: HBRUSH;
  widestr:widestring;

  //str,str1:string;
 // i:integer;
 // col:cardinal;
  { DCFrame3D was taken from TToolbar97 by Jordan Russell }
  procedure DCFrame3D(var R: TRect; const TopLeftColor, BottomRightColor: TColor);
  { Similar to VCL's Frame3D function, but accepts a DC rather than a Canvas }
  var
    Pen, SavePen: HPEN;
    P: array[0..2] of TPoint;
  begin
    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(TopLeftColor));
    SavePen := SelectObject(DC, Pen);
    P[0] := Point(R.Left, R.Bottom-2);
    P[1] := Point(R.Left, R.Top);
    P[2] := Point(R.Right-1, R.Top);
    PolyLine(DC, P, 3);
    SelectObject(DC, SavePen);
    DeleteObject(Pen);

    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(BottomRightColor));
    SavePen := SelectObject(DC, Pen);
    P[0] := Point(R.Left, R.Bottom-1);
    P[1] := Point(R.Right-1, R.Bottom-1);
    P[2] := Point(R.Right-1, R.Top-1);
    PolyLine(DC, P, 3);
    SelectObject(DC, SavePen);
    DeleteObject(Pen);
  end;

begin
  FHint := FindHint;
  Canvas.Font:=FHint.FHintFont;

  DC := Canvas.Handle;
  R := ClientRect; RD := ClientRect;

  //col:=Fhint.bgcolor+16769256;
  //setlength(str1,4);
  //move(col,str1[1],4);

  //str:='$';
  //for i:=1 to 4 do str:=str+inttohex(ord(str1[i]),2);
                          //messagebox(0,pchar(str+' '+inttostr(cardinal(Fhint.bgcolor))+'  '+inttostr(cardinal(clbtnface))),pchar('gf'),mb_ok);
  { Background }
  canvas.brush.color:=FHint.bgcolor;
  canvas.pen.color:=FHint.bgcolor;
  canvas.FillRect(r);
  //Brush := CreateSolidBrush(Fhint.bgcolor);
  //SaveBrush := SelectObject(DC, Brush);
  //FillRect(DC, R, Brush);
  //SelectObject(DC, SaveBrush);
  //DeleteObject(Brush);

  { Border }
 // case FHint.FHintStyle of
   // hsFlat:
  // DCFrame3D(R, clWindowFrame, clWindowFrame);
  //  else
  DCFrame3D(R, cl3DLight, cl3DDkShadow);
 // end;

  { Caption }
  SetBkMode(DC, TRANSPARENT);
  RD.Left := R.Left + (R.Right-R.Left - FTextWidth) div 2;
  RD.Top := R.Top + (R.Bottom-R.Top - FTextHeight) div 2;
  RD.Bottom := RD.Top + FTextHeight;



  widestr:=utf8strtowidestr(ACapt);
   Windows.ExtTextOutW(DC, 3, 2, 0, @RD, @widestr[1],Length(widestr), nil);
   //DrawTextW(DC, @widestr[1], Length(widestr), RD, DT_NOPREFIX or DT_LEFT or DT_SINGLELINE);
end;

function TCmtHintWindow.CalcHintRect(MaxWidth: Integer; const AHint: String; AData: Pointer): TRect;
var
  WideHintStr: WideString;
  size:tsize;
begin

    Result := Rect(0, 0, MaxWidth, 0);

      FHint := FindHint;
      Canvas.Font:=FHint.FHintFont;
      ACapt:=Ahint;
      WideHintStr := utf8strtowidestr(AHint);

    //DrawTextW(Canvas.Handle, PWideChar(WideHintStr), -1, Result, DT_CALCRECT or DT_LEFT or DT_NOPREFIX or DT_SINGLELINE	or DrawTextBiDiModeFlagsReadingOnly);

    GetTextExtentPoint32W(Canvas.Handle,@WideHintstr[1],Length(WideHintStr), Size); //serve allargare?
    result.right:=result.left+size.cx;
    result.bottom:=result.top+size.cy;


    Inc(Result.Right, 6);
    Inc(Result.Bottom, 2);
end;

procedure TCmtHintWindow.ActivateHint(Rect: TRect; const AHint: string);
var
  dx, dy, rch: Integer;
  Pnt: TPoint;
  II: TIconInfo;
  WideHintStr:widestring;
  size:tsize;
  function RealCursorHeight(Cur: HBITMAP): Integer;
  { Scans a cursor bitmap to get its real height }
  var
    Bmp: TBitmap;
    x, y: Integer;
    found: Boolean;
  begin
    Result := 0;

    Bmp := TBitmap.Create;
    Bmp.Handle := Cur;

    { Scan the "normal" cursor mask (lines 1 to 32) }
    for y := 31 downto 0 do begin
      for x := 0 to 31 do begin
        found := GetPixel(Bmp.Canvas.Handle, x, y)=clBlack;
        if found then Break;
      end;

      if found then begin
        Result := y-II.yHotSpot;
        Break;
      end;
    end;

    { No result? Then scan the inverted mask (lines 32 to 64) }
    if not found then
    for y := 63 downto 31 do begin
      for x := 0 to 31 do begin
        found := GetPixel(Bmp.Canvas.Handle, x, y)=clWhite;
        if found then Break;
      end;

      if found then begin
        Result := y-II.yHotSpot-32;
        Break;
      end;
    end;

    { No result yet?! Ok, let's say the cursor height is 32 pixels... }
    if not found then Result := 32;

    Bmp.Free;
  end;

begin
//  Caption := AHint;
  ACapt:=Ahint;
  FHint := FindHint;
  Canvas.Font.Assign(FHint.FHintFont);
  WideHintStr := utf8strtowidestr(AHint);

  //case FHint.FHintStyle of
  //  hsFlat:               { Internet Explorer style }
   //   begin dx := 6; dy := 4; end;
  //  hsOffice97:           { Office 97 style }
      begin dx := 6; dy := 6; end;
  //  hsWindows95:          { Windows 95 style }
  //    begin dx := 8; dy := 4; end;
 // end;



  with Rect do begin
    { Calculate width and height }   // DrawText

    Rect.Right := Rect.Left + HintMaxWidth - dx; { this hopefully fixes the problem with HintMaxWidth }

    GetTextExtentPoint32W(Canvas.Handle,@WideHintStr[1],Length(WideHintStr), Size); //serve allargare?
     rect.right:=rect.left+size.cx;
     rect.bottom:=rect.top+size.cy;

    Inc(Right, dx); Inc(Bottom, dy);
    FTextWidth := Right-Left-dx;
    FTextHeight := Bottom-Top-dy;

    { Calculate position }
    GetCursorPos(Pnt); GetIconInfo(GetCursor, II);
    Right := Right-Left + Pnt.X; Left := Pnt.X;
    rch := RealCursorHeight(II.hbmMask);
    Bottom := Bottom-Top + Pnt.Y + rch; Top := Pnt.Y + rch;

    { Make sure the tooltip is completely visible }
    if Right > Screen.Width then begin
      Left := Screen.Width - Right+Left;
      Right := Left + FTextWidth + dx;
    end;
    if Bottom > Screen.Height then begin
     // if (FHint.FHintStyle=hsOffice97) or (HintControl is TForm) then begin
        { Office 97 displays the tooltips 2 pixels above
          the cursor position.

          NOTE: Tooltips for forms are included here for 2 reasons:
          1. For forms "HintControl.Parent.ClientToScreen()" causes
             an exception.
          2. Forms are normally very big (at least bigger than buttons)
             and I don't think it looks good when the mouse cursor is
             at the bottom of the screen and the tooltip is at the top. }
        Bottom := Pnt.Y - 2;
        Top := Bottom - FTextHeight - dy;
     // end
     // else begin
        { Win95 and IE display the tooltips right above the
          control they belong to. }
     //   if HintControl <> nil then begin
     //     P := HintControl.Parent.ClientToScreen(Point(0, HintControl.Top));
     //     Bottom := P.Y;
     //     Top := Bottom - FTextHeight - dy;
    //    end;
     // end;
    end;
  end;
  BoundsRect := Rect;

  Pnt := ClientToScreen(Point(0, 0));
  SetWindowPos(Handle, HWND_TOPMOST, Pnt.X, Pnt.Y, 0, 0, SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
end;

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
