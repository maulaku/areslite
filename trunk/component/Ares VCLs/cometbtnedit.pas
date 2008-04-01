unit cometbtnedit;

interface

uses
  SysUtils, Classes,
  Windows,
  Messages,
  controls,
  tntStdCtrls,
  Graphics,
  Clipbrd,
  forms;

  type TCometBtnState = set of (csDown,csHover);
  type TPaintEvent = procedure (Sender:TObject; aCanvas:TCanvas; paintRect:TRect; btnState:TCometBtnState)  of object;

 type
 TCometbtnEdit = class(TTntEdit)
  private
   FCanvas: TControlCanvas;
    FFocused: Boolean;
    FbtnVisible: Boolean;
    FbtnWidth: integer;
    FBorderColor: Tcolor;
    FMouseInControl: boolean;
    FMouseIsDown: boolean;
    FAlignment : TAlignment;
    FOnPaint: TPaintEvent;
    FOnBtnClick: TNotifyEvent;
    FGlyphIndex:integer;
    FBtnState:TCometBtnState;
    FOnBtnStateChange:TNotifyEvent;
    Procedure PaintEdit;
    procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
    procedure SetEditRect;
    Procedure SetbtnVisible(Value: Boolean);
    Procedure SetBtnWidth(Value: Integer);
    Procedure SetFocused(Value: Boolean);
    function GetTextMargins: TPoint;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure SetGlyphIndex(value:integer);
    procedure SetAlignment(Value: TAlignment);
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property BorderColor: Tcolor read FBorderColor write FBorderColor default clblack;
    Property Canvas: TcontrolCanvas read FCanvas write FCanvas;
  protected
    Procedure loaded; override;
    procedure WndProc(var Message: TMessage); override;
    procedure CreateWnd; override;
    procedure CreateParams(var Params: TCreateParams);  override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property btnState:TcometBtnState read FBtnState write FBtnState;
    property OnPaint: TPaintEvent read FOnPaint write FOnPaint;
    property OnBtnClick:TNotifyEvent read FOnBtnClick write FOnBtnClick;
    property OnBtnStateChange:TNotifyEvent read FOnBtnStateChange write FOnBtnStateChange;
    property glyphIndex:integer read FGlyphIndex write SetGlyphIndex;
    property btnWidth: integer read FbtnWidth write SetbtnWidth default 16;
    property btnVisible: Boolean read FbtnVisible write SetbtnVisible default true;
  public
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ButtonClick;
    property MouseInControl: Boolean read FMouseInControl;
    property MouseIsDown: Boolean read FMouseIsDown;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Comet', [tcometbtnedit]);
end;

function ALMediumPos(LTotal, LBorder, LObject : integer):Integer;
Begin
  result := (LTotal - (LBorder*2) - LObject) div 2 + LBorder;
End;

Procedure DrawEditFace(edt: TCometBtnEdit);
var
  R: TRect;
 // BordWidth: integer;

begin
    with edt do begin
      If canvas = nil then exit;


     // If BorderColor = ClNone then BordWidth := 0
     // else BordWidth := 1;


      {--------------}
      R := ClientRect;
     // canvas.Brush.Style := BsSolid;

      If not BtnVisible then exit;

     // inflaterect(r,-1*BordWidth,-1*BordWidth);
      R.Left := R.Right - BtnWidth;


    //  canvas.Brush.Color := Color;
    //  canvas.FillRect(r);

      If assigned(FOnPaint) then FOnPaint(edt, canvas, r, FBtnState);

    end;
end;

procedure TCometBtnEdit.SetGlyphIndex(value:integer);
begin
FGlyphIndex:=value;
paintEdit;
end;

procedure TCometBtnEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
inherited;

if (x>=clientwidth-FBtnWidth) and (x<=clientwidth) and (y>=0) and (y<=height) then begin
 include(FBtnState,csDown);
 if assigned(FOnBtnStateChange) then FOnBtnStateChange(self);
end;



end;

procedure TCometBtnEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
inherited;

if (csDown in FBtnState) then begin
 Exclude(FBtnState,csDown);
 if assigned(FOnBtnStateChange) then FOnBtnStateChange(self);
end;

 if (x>=clientwidth{-FBtnWidth}) and (x<=clientwidth+FBtnWidth) and (y>=0) and (y<=height) then begin
  // has capture
   if assigned(FOnBtnClick) then FOnBtnClick(self);
 end;

end;

procedure TCometBtnEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
inherited;

 if x>=clientwidth-FBtnWidth then begin
   if not (csHover in FBtnState) then begin
    Include(FBtnState,csHover);
    if assigned(FOnBtnStateChange) then FOnBtnStateChange(self);
   end;
 end else begin
   if (csHover in FBtnState) then begin
    Exclude(FBtnState,csHover);
    if assigned(FOnBtnStateChange) then FOnBtnStateChange(self);
   end;
 end;

end;

procedure TCometBtnEdit.CMMouseLeave(var Msg:TMessage);
begin
inherited;

if (csHover in FBtnState) then begin
 Exclude(FBtnState,csHover);
 if assigned(FOnBtnStateChange) then FOnBtnStateChange(self);
end;

end;

constructor TCometBtnEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCanvas := Nil;
  FOnBtnStateChange:=nil;
  FFocused := False;
  FbtnVisible:= true;
  FbtnWidth:= 16;
  FBorderColor:= clblack;
  FMouseInControl := False;
  FMouseIsDown := False;
  Falignment := taleftjustify;
  FBtnState:=[];
  ParentCtl3D := False;
  Ctl3D := true;
  BevelInner := bvnone;
  BevelKind := bknone;
  BevelOuter := BVNone;
  BorderStyle := forms.bsSingle;
  BevelEdges := [];
  ParentBiDiMode := False;
  BiDiMode := bdLeftToRight;
  ImeMode := imDontCare;
  ImeName := '';
  Text := '';

  ControlStyle := ControlStyle - [csSetCaption];
end;

{*******************************}
destructor TCometBtnEdit.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

{**********************************************************************************}
procedure TCometBtnEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
end;

{*************************************************}
procedure TCometBtnEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then begin
    FFocused := Value;
    if (FAlignment <> taLeftJustify) then Refresh;
  end;
end;

{**************************************************************}
procedure TCometBtnEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //ES_password ne semble pas marcher avec ES_multiline (du moins en D7)
  //ES_password implique SetEditRect ne marche pas ...
  If passwordchar = #0 then Params.Style := Params.Style or ES_MULTILINE;
end;

{********************************}
procedure TCometBtnEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;

{*****************************}
procedure TCometBtnEdit.loaded;
begin
  inherited;
  seteditRect;
end;

{**********************************}
procedure TCometBtnEdit.SetEditRect;
var Loc: TRect;
    BordWidth : integer;
begin
  //This function is not compatible with passwordchar (passwordchar work only on no multiline edit
  If (not (csloading in ComponentState)) and (passwordChar = #0) then begin
    SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
    Loc.Bottom := ClientHeight + 1;

    If FBorderColor <> ClNone then BordWidth := 1
    Else BordWidth := 0;

    If FBtnVisible then Loc.Right := ClientWidth - FBtnWidth - BordWidth
    else Loc.Right := ClientWidth;

    Loc.Top := 0;
    Loc.Left := 1;
    SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
  end;
end;

{*****************************************************}
procedure TCometBtnEdit.WMPaint(var Message: TWMPaint);
const
  AlignStyle : array[Boolean, TAlignment] of DWORD =
   ((WS_EX_LEFT, WS_EX_RIGHT, WS_EX_LEFT),
    (WS_EX_RIGHT, WS_EX_LEFT, WS_EX_LEFT));
var
  Left: Integer;
  Margins: TPoint;
  R: TRect;
  DC: HDC;
  PS: TPaintStruct;
  S: string;
  AAlignment: TAlignment;
  BordWidth: integer;
begin
  if FCanvas = nil then begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := Self;
  end;

  AAlignment := FAlignment;
  if (AAlignment = taLeftJustify) or FFocused then begin
    inherited;
    Paintedit;
    Exit;
  end;

{ Since edit controls do not handle justification unless multi-line (and
  then only poorly) we will draw right and center justify manually unless
  the edit has the focus. }

  DC := Message.DC;
  if DC = 0 then DC := BeginPaint(Handle, PS);
  FCanvas.Handle := DC;
  try
    FCanvas.Font := Font;
    with FCanvas do begin

      R := ClientRect;
      If FBorderColor = ClNone then BordWidth := 0
      else BordWidth := 1;
      inflaterect(r,-1*BordWidth,-1*BordWidth);
      If BtnVisible then R.Right := R.Right - BtnWidth;

      Brush.Color := Color;
      S := Text;
      if PasswordChar <> #0 then FillChar(S[1], Length(S), PasswordChar);
      Margins := GetTextMargins;
      case AAlignment of
        taRightJustify: Left := R.Right - R.Left - TextWidth(S) - Margins.X - 1;
        Else Left := (R.Right - R.Left - TextWidth(S)) div 2;
      end;
      TextRect(R, Left, Margins.Y, S);
    end;
  finally
    FCanvas.Handle := 0;
    if Message.DC = 0 then EndPaint(Handle, PS);
  end;

  Paintedit;
end;

//procedure TCometBtnEdit.ReplaceInvalidateInQueueByRefresh;
//begin
//  ValidateRect(handle,nil);
//  Refresh;
//end;

Procedure TCometBtnEdit.PaintEdit;
begin
DrawEditFace(self);
end;

procedure TCometBtnEdit.ButtonClick;
begin
  If not focused then setfocus;
end;

procedure TCometBtnEdit.KeyPress(var Key: Char);
begin
  if key = chr(vk_return) then Key := #0;
  inherited KeyPress(Key);
end;

function TCometBtnEdit.GetTextMargins: TPoint;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  Result.X := 1;

  if NewStyleControls then Result.Y := 2
  else begin
    DC := GetDC(0);
    GetTextMetrics(DC, SysMetrics);
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
    ReleaseDC(0, DC);
    I := SysMetrics.tmHeight;
    if I > Metrics.tmHeight then I := Metrics.tmHeight;
    I := I div 4;
    Result.Y := I;
  end;
end;

procedure TCometBtnEdit.WndProc(var Message: TMessage);
Var ClipBoardText : string;
    x,z : integer;


   Function GetBorderWidth:Integer;
   Begin
     If BorderColor <> ClNone then result := 1
     Else result := 0;
   End;


begin
  case Message.Msg of

    WM_LButtonDown: begin
                      x := selstart;
                      z := sellength;
                      inherited;
                      If not (csDesigning in ComponentState) and
                          FBtnVisible and
                         (TWMLButtonDown(Message).XPos > width - FBtnWidth - 2*Getborderwidth) then begin
                        selstart := x;
                        sellength := z;
                        FMouseIsDown := True;
                        paintEdit;
                      end;
                    end;

    WM_LButtonUp: begin
                    if FMouseIsDown then begin
                      if (TWMLButtonUP(Message).XPos > width - FBtnWidth - 2*Getborderwidth) and
                         (TWMLButtonUP(Message).XPos < width) and
                         FmouseInControl then begin
                           buttonClick;
                           TWMLButtonUP(message).XPos := width+1 ;
                         end;
                      FMouseIsDown := False;
                      PaintEdit;
                    end;
                    inherited;
                  end;

    WM_LButtonDblClk: begin
                        x := selstart;
                        z := sellength;
                        inherited;
                        If not (csDesigning in ComponentState) and
                            FBtnVisible and
                           (TWMLButtonDown(Message).XPos > width - FBtnWidth - 2*Getborderwidth) then begin
                          selstart := x;
                          sellength := z;
                          FMouseIsDown := True;
                          paintEdit;
                        end
                      end;

    CM_MouseEnter: Begin
                     inherited;
                     FmouseinControl := true;
                     Paintedit;
                   End;

    CM_MouseLeave: Begin
                     inherited;
                     FmouseinControl := false;
                     Paintedit;
                   End;

    CM_FontChanged: begin
                      inherited;
                      seteditRect;
                    end;

    CM_Enter: begin
                SetFocused(True);
                inherited;
                SelStart := Length(Text);
                Sellength := 0;
                Paintedit;
              end;

    CM_Exit: begin
               inherited;
               SetFocused(False);
               If FMouseIsDown then FMouseIsDown := False;
               Paintedit;
             end;

    WM_Size: begin
               inherited;
               SetEditRect;
               Paintedit;
             end;

    WM_MouseMove: begin
                    inherited;
                    If FBtnVisible then begin
                      If TWMMouseMove(message).XPos > width - FBtnWidth - 2*Getborderwidth then cursor := crArrow
                      else Cursor := crdefault;
                    end;
                  end;

    WM_PASTE: Begin
                Clipboard.Open;
                if Clipboard.HasFormat(CF_TEXT) then ClipBoardText := Clipboard.AsText
                else ClipBoardText := '';
                Clipboard.Close;

                If (pos(#13,ClipBoardText) = 0) and (pos(#10,ClipBoardText) = 0) then inherited;
              end;

     else inherited;
  end;
end;

Procedure TCometBtnEdit.SetbtnVisible(Value: Boolean);
Begin
  If Value <> FbtnVisible then Begin
    FbtnVisible := Value;
    SetEditRect;
    Refresh;
  end;
End;

Procedure TCometBtnEdit.SetBtnWidth(Value: Integer);
Begin
  If Value <> Fbtnwidth then Begin
    Fbtnwidth := Value;
    SetEditRect;
    Refresh;
  end;
End;

procedure TCometBtnEdit.SetAlignment;
begin
   if FAlignment <> Value then begin
    FAlignment := Value;
    Refresh;
  end;
end;

end.
