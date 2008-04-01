  unit comettopicpnl;

  interface

  uses windows,Graphics,ExtCtrls,Classes,controls,messages,forms;

   type TCmtPaintEvent = procedure(sender:TObject; Acanvas:TCanvas; capt:widestring; var should_continue:boolean) of object;
   type TCmtUrlClickEvent = procedure(Sender: TObject; const URLText: String; Button: TMouseButton) of object;

  type
  TCometTopicPnl = class(TPanel)

    constructor Create(AComponent: TComponent); override;
  protected
    Fcapttop:integer;
    fcapt:widestring;
    FCaptLeft:integer;
    FOnPaint:TCmtPaintEvent;
    procedure invalidate_caption;
    procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
    procedure paint; override;
    procedure SetCapt(value:widestring);
  published
    property capt:widestring read fcapt write setcapt;
    property canvas;
    property OnPaint:TCmtPaintEvent read FOnPaint write FOnPaint;
    property CaptionLeft:integer read FCaptLeft write FCaptLeft default 0;
    property capttop:integer read FCaptTop write FCaptTop;
  end;

  type
  TCometPlayerPanel = class(TCometTopicPnl)
   protected
    FUrl:string;
    FUrlCaption:widestring;
    FOnUrlClick:TCmtUrlClickEvent;
    furlPosx,furlWidth,furlheight:integer;
    procedure paint; override;
    procedure SetUrl(const valueUrl:string);
    procedure SetCaptionUrl(const valueCaption:widestring);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
   published
    property url:string read FUrl write SetUrl;
    property captionurl:widestring read FUrlCaption write SetCaptionUrl;
    property OnUrlClick:TCmtUrlClickEvent read FOnUrlClick write FOnUrlClick;
    procedure invalidate_url;
  end;

  procedure Register;

  implementation

////////// TCometPlayerPanel
procedure TCometPlayerPanel.paint;
begin
inherited paint;

if ((length(FUrl)>0) and (length(FUrlCaption)>0)) then invalidate_url;
end;

procedure TCometPlayerPanel.SetUrl(const valueUrl:string);
begin
fUrl:=valueUrl;

if length(furl)=0 then begin
 furlPosx:=0;
 furlWidth:=0;
end;

invalidate;
end;

procedure TCometPlayerPanel.SetCaptionUrl(const valueCaption:widestring);
begin
FUrlCaption:=valueCaption;
invalidate;
end;

procedure TCometPlayerPanel.invalidate_url;
var
r:trect;
size:tsize;
begin
  canvas.font.name:=Font.name;
  canvas.font.size:=font.size;
  canvas.font.style:=font.style;
  canvas.font.color:=font.color;
  size.cX:=0;
  size.cY:=0;
  Windows.GetTextExtentPointW(canvas.handle, PwideChar(fcapt), Length(fcapt), size);

furlPosx:=size.cx+CaptionLeft+10;


  canvas.font.style:=[fsUnderline];
  canvas.font.color:=clblue;
  size.cX:=0;
  size.cY:=0;
  Windows.GetTextExtentPointW(canvas.handle, PWideChar(furlCaption), Length(furlCaption), size);

furlWidth:=size.cx;
furlheight:=size.cy;

   r.left:=furlPosx;
   r.right:=clientwidth-3;
   r.top:=0;
   r.bottom:=clientHeight;
 Windows.ExtTextOutW(canvas.Handle, furlPosx, Fcapttop, ETO_CLIPPED, @R, PWideChar(FUrlCaption),Length(FUrlCaption), nil);
end;

procedure TCometPlayerPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
if ((x>=furlPosx) and
    (x<=furlPosx+furlWidth) and
    (y>=FCaptTop) and
    (y<=FCaptTop+furlheight)) then cursor:=crHandpoint
     else cursor:=crDefault;

inherited;
end;

procedure TCometPlayerPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
btn:TMouseButton;
begin
if not assigned(FOnUrlClick) then begin
inherited;
exit;
end;

if ((x>=furlPosx) and
    (x<=furlPosx+furlWidth) and
    (y>=FCaptTop) and
    (y<=FCaptTop+furlheight)) then FOnUrlClick(self,furl,btn)
    else
    inherited;
end;



//////// TCometTopicPnl
constructor TCometTopicPnl.create(AComponent: TComponent);
begin
 inherited Create(AComponent);
 ControlStyle := ControlStyle + [csOpaque];
 color:=clbtnface;
 doublebuffered:=true;
 Fcapttop:=4;
end;

procedure TCometTopicPnl.paint;
var
should_continue:boolean;
begin
inherited paint;

   canvas.pen.color:=color;
   canvas.brush.color:=color;    //nessun override di colore!
   if ((bevelinner=bvnone) and (bevelouter=bvnone)) then canvas.rectangle(0,0,width,height)
   else canvas.rectangle(2,2,width-2,height-2);

  if assigned(FOnPaint) then begin
   FOnPaint(self,canvas,fcapt,should_continue);
   if not should_continue then exit;
  end;

  if length(FCapt)=0 then exit;

  invalidate_caption;
end;

procedure TCometTopicPnl.invalidate_caption;
var
r:trect;
begin

  canvas.font.name:=Font.name;
  canvas.font.size:=font.size;
  canvas.font.style:=font.style;
  canvas.font.color:=font.color;

   r.left:=FCaptLeft;
   r.right:=width-3;
   r.top:=0;
   r.bottom:=Height;
   
 SetBkMode(canvas.Handle, TRANSPARENT);
  Windows.ExtTextOutW(canvas.Handle, FCaptLeft+4, Fcapttop, ETO_CLIPPED, @R, PwideChar(FCapt),Length(FCapt), nil);
end;

procedure TCometTopicPnl.SetCapt(value:widestring);
begin
fcapt:=value;
invalidate;
end;

procedure TCometTopicPnl.WMEraseBkgnd(Var Msg : TMessage); //reduce flicker;
begin
msg.result:=1;
end;

procedure Register;
begin
  RegisterComponents('Comet', [TCometTopicPnl,TCometPlayerPanel]);
end;


end.
