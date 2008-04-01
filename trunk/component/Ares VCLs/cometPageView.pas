unit cometPageView;

interface

uses
 classes,ExtCtrls,windows,graphics,messages,controls,sysutils;

 type TPaintBtnFrameEvent = procedure (Sender:TObject; aCanvas:TCanvas; paintRect:TRect)  of object;
 type TPaintButtonEvent = procedure (Sender:TObject; aPanel:TObject; aCanvas:TCanvas; paintRect:TRect) of object;
 type TCustomPanelShow = procedure (Sender:TObject; aPanel:TObject) of object;
 type TCustomPanelClose = procedure (Sender:TObject; aPanel:TObject; var Proceed:boolean) of object;

 type TCometPagePanelIDx=(
                         IdxBtnWeb,
                         IdxBtnLibrary,
                         IdxBtnScreen,
                         IdxBtnSearch,
                         IdxBtnTransfer,
                         IdxBtnChat,
                         IdxBtnOptions,
                         IDNone,
                         IDXChatPvt,
                         IDXChatMain,
                         IDXChatBrowse,
                         IDXChatSearch,
                         IDXSearch
                         );

 type
  TCometPageBtnState = set of (csHover, csDown, csClicked);
  TCometPageCloseBtnState = set of (bsHover);

 type
 TCometPagePanel=class(TObject)
  ID:TCometPagePanelIDx;
  btnState:TCometPageBtnState;
  panel:TPanel;
  FCaption:widestring;
  BtnHitRect:TRect;
  hasCloseButton:boolean;
  rcCloseButton:TRect;
  closeBtnState:TCometPageCloseBtnState;
  owner:TPanel;
  FImageIndex:integer;
  FData:pointer;
  PaintRow:integer;
  procedure SetCaption(value:widestring);
  procedure SetImageIndex(value:integer);
  published
   property imageIndex:integer read FImageIndex write SetImageIndex;
   property btncaption:widestring read FCaption write SetCaption;
 end;
 
 type TCometPagePanelList=array of TCometPagePanel;

 TCometPageView=class(TPanel)
  private
   FPanels:TCometPagePanelList;
   FButtonsLeft:integer;
   FButtonsLeftMargin,FButtonsTopMargin,FButtonsRightMargin:integer;
   FButtonsHeight:integer;
   FActivePage:integer;
   FHorizBtnSpacing:integer;
   FCloseButtonTopMargin,
   FCloseButtonLeftMargin,
   FCloseButtonWidth,
   FCloseButtonHeight:integer;
   FOnPaintButtonFrame:TPaintBtnFrameEvent;
   FOnPaintButton:TPaintButtonEvent;
   FOnPanelShow:TCustomPanelShow;
   FDrawMargin:boolean;
   FSwitchOnDown:boolean;
   FWrappable:boolean;
   FOnPanelClose:TCustomPanelClose;
   FButtonsTopHitPoint:integer;
   FTabsVisible,FHideTabsOnSigle:boolean;
   FOnPaintCloseButton:TPaintButtonEvent;
   FColorFrame:TColor;
   FNumRows:integer;
   FWidestTab:integer;

   procedure SetButtonsHeight(value:integer);
   procedure SetButtonsTopMargin(value:integer);
   procedure SetButtonsLeftMargin(value:integer);
   procedure SetButtonsRightMargin(value:integer);
   procedure SetActivePage(value:integer);
   procedure SetButtonsLeft(value:integer);
   procedure SetCloseButtonTopMargin(value:integer);
   procedure SetCloseButtonLeftMargin(value:integer);
   procedure SetCloseButtonWidth(value:integer);
   procedure SetCloseButtonHeight(value:integer);
   function hasanyDown:boolean;
   function GlyphWidth(pnl:TCometPagePanel):integer;
   function GetActivePanel:Tpanel;
   procedure SetActivePanel(value:TPanel);
   procedure SetDrawMargin(value:boolean);
   procedure SetTabsVisible(value:boolean);
   procedure SetColorFrame(value:TColor);
   procedure excludeDowns(ExceptPanel:TCometPagePanel);
   procedure ResizeControl;
   procedure ResizePanels;
   function resizeTabsSimple:boolean;
   procedure resizeTabsWrappable;
   procedure SetWrappable(value:boolean);
   procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
   procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
 public
  procedure Paint; override;
  procedure paintButton(pnl:TCometPagePanel);
  procedure checkInvalidate;
  procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  procedure Resize; override;
  function AddPanel(ID:TCometPagePanelIDx; btncaption:widestring; btnState:TCometPageBtnState;
   panel:TPanel; aData:pointer; withCloseButton:Boolean=false; imageIndex:integer=-1; killAutoSwitch:boolean=false):TCometPagePanel;
  function DeletePanel(panelIndex:integer; Notify:boolean=true):integer; overload;
  function DeletePanel(panel:TCometPagePanel):integer; overload;
  function PanelsCount:integer;
  function GetPagePanel(panel:TPanel):TCometPagePanel;
  function GetPagePanelIndex(panel:TPanel):integer;
  constructor Create(Owner:TComponent); override;
  destructor destroy; override;
 published
  property wrappable:boolean read FWrappable write SetWrappable;
  property ColorFrame:TColor read FColorFrame write SetColorFrame;
  property hideTabsOnSingle:boolean read FHideTabsOnSigle write FHideTabsOnSigle default false;
  property tabsVisible:boolean read FTabsVisible write SetTabsVisible;
  property switchOnDown:boolean read FSwitchOnDown write FSwitchOnDown;
  property drawMargin:boolean read FDrawMargin write SetDrawMargin;
  property Panels:TCometPagePanelList read FPanels;
  property ActivePanel:tpanel read GetActivePanel write SetActivePanel;
  property buttonsHeight:integer read FButtonsHeight write SetButtonsHeight;
  property buttonsLeft:integer read FButtonsLeft write SetButtonsLeft;
  property buttonsLeftMargin:integer read FButtonsLeftMargin write SetButtonsLeftMargin;
  property buttonsRightMargin:integer read FButtonsRightMargin write SetButtonsRightMargin;
  property buttonsTopMargin:integer read FButtonsTopMargin write SetButtonsTopMargin;
  property closeButtonTopMargin:integer read FCloseButtonTopMargin write SetCloseButtonTopMargin;
  property closeButtonLeftMargin:integer read FCloseButtonLeftMargin write SetCloseButtonLeftMargin;
  property closeButtonWidth:integer read FCloseButtonWidth write SetCloseButtonWidth;
  property closeButtonHeight:integer read FCloseButtonHeight write SetCloseButtonHeight;
  property activePage:integer read FActivePage write SetActivePage;
  property buttonsHorizSpacing:integer read FHorizBtnSpacing write FHorizBtnSpacing;
  property buttonsTopHitPoint:integer read FButtonsTopHitPoint write FButtonsTopHitPoint;
  property OnPaintButtonFrame:TPaintBtnFrameEvent read FOnPaintButtonFrame write FOnPaintButtonFrame;
  property OnPaintButton:TPaintButtonEvent read FOnPaintButton write FOnPaintButton;
  property OnPaintCloseButton:TPaintButtonEvent read FOnPaintCloseButton write FOnPaintCloseButton;
  property OnPanelShow:TCustomPanelShow read FOnPanelShow write FOnPanelShow;
  property OnPanelClose:TCustomPanelClose read FOnPanelClose write FOnPanelClose;
 end;

 procedure Register;

implementation

procedure TCometPagePanel.SetCaption(value:widestring);
var
size:TSize;
widthbefore,widthafter:integer;
begin
     size.cX:=0;
     if length(btncaption)>0 then begin
      size.cY:=0;
      Windows.GetTextExtentPointW((owner as TCometPageView).canvas.handle, PwideChar(btncaption), Length(btncaption), size);
     end;
     widthBefore:=size.cx;

     size.cX:=0;
     if length(value)>0 then begin
      size.cY:=0;
      Windows.GetTextExtentPointW((owner as TCometPageView).canvas.handle, PwideChar(value), Length(value), size);
     end;
     widthAfter:=size.cx;

     FCaption:=value;

     if widthBefore=widthAfter then (owner as TCometPageView).PaintButton(self)
      else (owner as TCometPageView).Resize;
end;

procedure TCometPagePanel.SetImageIndex(value:integer);
begin
FImageIndex:=value;
(owner as TCometPageView).PaintButton(self);
end;

//////////////////////////// tcometpageview

procedure TCometPageView.SetWrappable(value:boolean);
begin
FWrappable:=value;
resize;
end;


procedure TCometPageView.SetTabsVisible(value:boolean);
begin
FTabsVisible:=value;
resize;
end;

procedure TCometPageView.SetColorFrame(value:TColor);
begin
FColorFrame:=value;
CheckInvalidate;
end;

procedure TCometPageView.SetDrawMargin(value:boolean);
begin
FDrawMargin:=value;
CheckInvalidate;
end;

function TCometPageView.GetPagePanel(panel:TPanel):TCometPagePanel;
var
pnl:TCometPagePanel;
i:integer;
begin
result:=nil;

for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];
 if pnl.panel=panel then begin
  result:=pnl;
  exit;
 end;
end;

end;

function TCometPageView.GetPagePanelIndex(panel:TPanel):integer;
var
pnl:TCometPagePanel;
i:integer;
begin
result:=-1;

for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];
 if pnl.panel=panel then begin
  result:=i;
  exit;
 end;
end;

end;

function TCometPageView.PanelsCount:integer;
begin
result:=length(FPanels);
end;

function TCometPageView.GetActivePanel:TPanel;
var
pnl:TCometPagePanel;
begin
if length(FPanels)=0 then begin
 result:=nil;
 exit;
end;
 pnl:=FPanels[FActivePage];
 result:=pnl.panel;
end;

procedure TCometPageView.SetActivePanel(value:TPanel);
var
pnl:TCometPagePanel;
i:integer;
begin
for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];
 if pnl.panel=value then begin
  activepage:=i;
  exit;
 end;
end;
end;

procedure TCometPageView.SetCloseButtonLeftMargin(value:integer);
begin
FCloseButtonLeftMargin:=value;
resize;
end;

procedure TCometPageView.SetCloseButtonTopMargin(value:integer);
begin
FCloseButtonTopMargin:=value;
resize;
end;

procedure TCometPageView.SetCloseButtonWidth(value:integer);
begin
FCloseButtonWidth:=value;
resize;
end;

procedure TCometPageView.SetCloseButtonHeight(value:integer);
begin
FCloseButtonHeight:=value;
resize;
end;

function TCometPageView.AddPanel(ID:TCometPagePanelIDx; btncaption:widestring; btnState:TCometPageBtnState;
 panel:TPanel; aData:Pointer; withCloseButton:boolean=false; imageIndex:integer=-1; killAutoSwitch:boolean=false):TCometPagePanel;
var
pnl:TCometPagePanel;
CurrentActivePanel:integer;
begin
 //if killAutoSwitch then
  CurrentActivePanel:=FActivePage;

 pnl:=TCometPagePanel.create;
 pnl.PaintRow:=0;
 SetLength(FPanels,length(FPanels)+1);
 FPanels[high(FPanels)]:=pnl;

 pnl.owner:=self;
 panel.Parent:=self;

  pnl.ID:=ID;
  pnl.btnState:=btnState;
  pnl.btncaption:=btncaption;
  pnl.panel:=panel;
  pnl.hasCloseButton:=withCloseButton;
  pnl.FimageIndex:=imageIndex;
  pnl.fdata:=aData;

  if pnl.panel<>nil then begin
   pnl.panel.Top:=FButtonsHeight+integer(FDrawMargin);
   pnl.panel.Left:=integer(FDrawMargin);
   pnl.panel.Width:=clientwidth-(integer(FDrawMargin)*2);
   pnl.panel.Height:=(clientheight-FButtonsHeight)-integer(FDrawMargin);
  end;

  result:=pnl;

  if killAutoSwitch then activePage:=CurrentActivePanel
   else activePage:=high(FPanels);

   resize;

end;

function TCometPageView.DeletePanel(panel:TCometPagePanel):integer;
var
i:integer;
tempPnl:TCometPagePanel;
begin
result:=-1;

 for i:=0 to high(FPanels) do begin
  tempPnl:=FPanels[i];
   if tempPnl=panel then begin
    result:=deletePanel(i);
    exit;
   end;
 end;
 
end;

function TCometPageView.DeletePanel(panelIndex:integer; Notify:boolean):integer;
var
i:integer;
pnl:TCometPagePanel;
proceed:boolean;
begin
result:=-1;
if panelIndex<0 then exit;
if panelIndex>high(FPanels) then exit;


pnl:=FPanels[panelIndex];

 proceed:=true;

 if notify then
  if Assigned(FOnPanelClose) then FOnPanelClose(self,pnl,proceed);

 if not proceed then exit;



pnl.FCaption:='';
pnl.free;

if panelIndex<high(panelIndex) then
 for i:=panelIndex to high(FPanels)-1 do begin
  pnl:=FPanels[i+1];
  FPanels[i]:=pnl;
 end;

SetLength(FPanels,high(FPanels));

result:=length(FPanels);

if (panelIndex>0) and (panelIndex-1<length(FPanels)) then ActivePage:=panelIndex-1
 else ActivePage:=0;
 
 if FHideTabsOnSigle then
  if length(FPanels)=1 then tabsVisible:=false;

 resize;

end;

procedure TCometPageView.setActivePage(value:integer);
var
i:integer;
pnl:TCometPagePanel;
shouldRedraw:boolean;
begin
if value>high(FPanels) then value:=high(FPanels);
if value<0 then value:=0;



for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];
 
 if value<>i then begin
   shouldRedraw:=(csDown in pnl.btnState);
  exclude(pnl.btnState,csDown);
   if shouldRedraw then paintButton(pnl);
 // if pnl.panel<>nil then pnl.panel.visible:=false;

 end else begin
  //shouldRedraw:=not (csDown in pnl.btnState);
  include(pnl.btnState,csDown);

  //if shouldRedraw then
  //paintButton(pnl);
  if pnl.panel<>nil then begin
  
   if FWrappable then pnl.panel.Top:=(integer(FTabsVisible)*(FButtonsHeight*FNumRows))+integer(FDrawMargin)
    else pnl.panel.Top:=(integer(FTabsVisible)*(FButtonsHeight))+integer(FDrawMargin);
   pnl.panel.Left:=0;//integer(FDrawMargin);
   pnl.panel.Width:=clientwidth;//-(integer(FDrawMargin)*2);
   pnl.panel.Height:=clientheight-pnl.panel.Top;
   pnl.panel.visible:=true;
   FActivePage:=i;
  end;

  if assigned(FOnPanelShow) then FOnPanelShow(self,pnl);
  paintButton(pnl);
 end;
end;


for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];
 if not (csDown in pnl.BtnState) then if pnl.panel<>nil then pnl.panel.visible:=false;
end;

if FWrappable then Resize;  // got to take care of paintRow# assignment

end;

procedure TCometPageView.WMEraseBkgnd(Var Msg : TMessage);
begin
msg.result:=1;
end;

procedure TCometPageView.Resize;
begin
inherited;
reSizeControl;
Invalidate;
end;

procedure TCometPageView.ResizeControl;
begin

 canvas.font.name:=self.Font.name;
 canvas.font.size:=self.font.size;
 canvas.font.style:=self.Font.style;


if not FWrappable then ResizeTabsSimple
 else begin
  if not ResizeTabsSimple then ResizeTabsWrappable;
 end;

reSizePanels;
end;

procedure TCometPageView.resizeTabsWrappable;
var
i,offsetX,wid:integer;
pnl:TCometPagePanel;
size:TSize;
TabsPerRow,DownRow,TabsInActualRow,ActualRow:integer;
begin
FNumRows:=1;
offsetX:=FButtonsLeft;
FWidestTab:=0;

for i:=0 to high(FPanels) do begin  // get width of widest tab
 pnl:=FPanels[i];

     size.cX:=0;
     if length(pnl.btncaption)>0 then begin
      size.cY:=0;
      Windows.GetTextExtentPointW(canvas.handle, PwideChar(pnl.btncaption), Length(pnl.btncaption), size);
     end;

     if pnl.hasCloseButton then wid:=GlyphWidth(pnl)+size.cX+(FButtonsLeftMargin+FButtonsRightMargin)+FCloseButtonWidth+2
      else wid:=GlyphWidth(pnl)+size.cX+(FButtonsLeftMargin+FButtonsRightMargin);

     inc(wid,FHorizBtnSpacing);
     if FWidestTab<wid then FWidestTab:=wid;
end;

TabsPerRow:=(clientWidth-(FButtonsLeft*2)) div (FWidestTab+FHorizBtnSpacing);
if tabsPerRow=0 then TabsPerRow:=1;

FWidestTab:=(clientwidth-(FButtonsLeft*2)) div TabsPerRow;

if FWidestTab>(clientwidth-(FButtonsLeft*2)) then FWidestTab:=(clientwidth-(FButtonsLeft*2));

if (length(FPanels) mod TabsPerRow)=0 then FnumRows:=(length(FPanels) div TabsPerRow)
 else FnumRows:=(length(FPanels) div TabsPerRow)+1;


// now assign new widths and temporary tab's paintrow
downrow:=0;
FNumRows:=1;
offsetX:=FButtonsLeft;
for i:=0 to high(FPanels) do begin  // get width of widest tab
 pnl:=FPanels[i];

   if offsetX+FWidestTab+FButtonsLeft>clientwidth then begin
    offsetX:=FButtonsLeft;
    inc(FNumRows);
   end;

    with pnl.BtnHitRect do begin
     left:=offsetX;
     right:=offsetX+FWidestTab;
    end;

   pnl.paintRow:=FNumRows-1;
   if (csDown in pnl.btnState) then DownRow:=pnl.paintRow;
   inc(offsetX,FWidestTab);
end;

// get down row
ActualRow:=0;
TabsInActualRow:=0;
for i:=0 to high(FPanels) do begin  // get width of widest tab
 pnl:=FPanels[i];

 if pnl.PaintRow=DownRow then pnl.paintRow:=FNumRows-1
  else begin
   inc(TabsInActualRow);
   if TabsInActualRow>TabsPerRow then begin
    TabsInActualRow:=1;
    inc(ActualRow);
   end;
    pnl.paintRow:=ActualRow;
  end;


  pnl.BtnHitRect.Top:=pnl.paintRow*FbuttonsHeight;
  pnl.BtnHitRect.bottom:=pnl.BtnHitRect.top+FButtonsHeight;
       if pnl.hasCloseButton then pnl.rcCloseButton:=rect(pnl.BtnHitRect.right-FCloseButtonLeftMargin,
                                                          pnl.BtnHitRect.top+FCloseButtonTopMargin,
                                                          pnl.BtnHitRect.right-FCloseButtonLeftMargin+FCloseButtonWidth,
                                                          pnl.BtnHitRect.top+FCloseButtonTopMargin+FCloseButtonHeight);
end;

end;

function TCometPageView.resizeTabsSimple:boolean;
var
i:integer;
pnl:TCometPagePanel;
size:TSize;
offsetX:integer;
begin
result:=true;

FNumRows:=1;
offsetX:=FButtonsLeft;

for i:=0 to high(FPanels) do begin  // copy buttons on a list
 pnl:=FPanels[i];
 pnl.PaintRow:=0;

     size.cX:=0;
     if length(pnl.btncaption)>0 then begin
      size.cY:=0;
      Windows.GetTextExtentPointW(canvas.handle, PwideChar(pnl.btncaption), Length(pnl.btncaption), size);
     end;

    with pnl.BtnHitRect do begin
     left:=offsetX;
     top:=0;
     bottom:=top+FbuttonsHeight;

     if pnl.hasCloseButton then begin
      right:=offsetX+GlyphWidth(pnl)+size.cX+(FButtonsLeftMargin+FButtonsRightMargin)+FCloseButtonWidth+2;
            pnl.rcCloseButton:=rect(pnl.BtnHitRect.right-FCloseButtonLeftMargin,
                                    pnl.BtnHitRect.top+FCloseButtonTopMargin,
                                    pnl.BtnHitRect.right-FCloseButtonLeftMargin+FCloseButtonWidth,
                                    pnl.BtnHitRect.top+FCloseButtonTopMargin+FCloseButtonHeight);
      end else
      right:=offsetX+GlyphWidth(pnl)+size.cX+(FButtonsLeftMargin+FButtonsRightMargin);

    end;


   inc(offsetX,(pnl.BtnHitRect.Right-pnl.BtnHitRect.left)+FHorizBtnSpacing);
   
   if offsetx>clientwidth then begin
    result:=false;
    if FWrappable then break; //resize tabsWrappable will take care of everything
   end;

end;
end;

procedure TCometPageView.ResizePanels;
var
i:integer;
pnl:TCometPagePanel;
begin
for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];
 
 //if (csDown in pnl.btnState) then
  if pnl.panel<>nil then begin
   if FWrappable then pnl.panel.Top:=(integer(FTabsVisible)*(FButtonsHeight*FNumRows))+integer(FDrawMargin)
    else pnl.panel.Top:=(integer(FTabsVisible)*(FButtonsHeight))+integer(FDrawMargin);
   pnl.panel.Left:=0;//integer(FDrawMargin);
   pnl.panel.Width:=clientwidth;//-(integer(FDrawMargin)*2);
   pnl.panel.Height:=clientheight-pnl.panel.Top;
  end;
end;

end;


procedure TCometPageView.CMMouseLeave(var Msg:TMessage);
var
i:integer;
pnl:TCometPagePanel;
shouldRedraw,shouldRedrawClose:boolean;
begin
//inherited;

for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];
 shouldRedrawClose:=(bsHover in pnl.closeBtnState) and (pnl.hasCloseButton);
 shouldRedraw:=(csHover in pnl.btnState);
 exclude(pnl.btnState,csHover);
 if shouldRedraw or shouldRedrawClose then paintButton(pnl);
end;
//repaint;
end;

procedure TCometPageView.paintButton(pnl:TCometPagePanel);
var
tempBitmap:graphics.tbitmap;
rc,rcCloseButton,TextRect:TRect;
begin

 tempBitmap:=graphics.tbitmap.create;
  tempBitmap.width:=pnl.BtnHitRect.right-pnl.BtnHitRect.left;
  tempBitmap.height:=FbuttonsHeight;
  tempBitmap.pixelformat:=pf24Bit;

   tempBitmap.canvas.font.name:=self.Font.name;
   tempBitmap.canvas.font.size:=self.font.size;
   tempBitmap.canvas.font.style:=self.Font.style;
   tempBitmap.canvas.font.color:=self.font.color;
   tempBitmap.canvas.brush.color:=self.color;

  rc:=rect(0,0,tempBitmap.width,tempBitmap.height);

   if Assigned(FOnPaintButton) then FOnPaintButton(self,pnl,tempBitmap.canvas,rc);

   if pnl.hasCloseButton then begin
    rcCloseButton:=rect(rc.right-FCloseButtonLeftMargin,rc.top+FCloseButtonTopMargin,rc.right-FCloseButtonLeftMargin+FCloseButtonWidth,rc.top+FCloseButtonTopMargin+FCloseButtonHeight);

    if Assigned(FOnPaintCloseButton) then FOnPaintCloseButton(self,pnl,tempBitmap.Canvas,rcCloseButton);
   end;

   SetBkMode(tempBitmap.canvas.Handle, TRANSPARENT);

      TextRect:=rect(rc.left,
                     0,
                     (rc.right-((FCloseButtonWidth+2)*integer(pnl.hasCloseButton)))-5,
                     rc.bottom);


   Windows.ExtTextOutW(tempBitmap.canvas.Handle,
                       FButtonsLeftMargin+1+GlyphWidth(pnl), FButtonsTopMargin,
                       ETO_CLIPPED, @textRect,
                       PwideChar(pnl.btncaption),Length(pnl.btncaption),
                       nil);


   canvas.lock;

      bitBlt(canvas.handle,pnl.BtnHitRect.left,pnl.BtnHitRect.top,pnl.BtnHitRect.right-pnl.BtnHitRect.left,pnl.BtnHitRect.bottom-pnl.BtnHitRect.top,
             TempBitmap.canvas.handle,0,0,SRCCopy);

   canvas.unlock;


   tempBitmap.free;
end;

procedure TCometPageView.SetButtonsHeight(value:integer);
begin
FButtonsHeight:=value;
resize;
end;

procedure TCometPageView.SetButtonsLeft(value:integer);
begin
FButtonsLeft:=value;
resize;
end;

procedure TCometPageView.SetButtonsLeftMargin(value:integer);
begin
FButtonsLeftMargin:=value;
FButtonsRightMargin:=value;
resize;
end;

procedure TCometPageView.SetButtonsRightMargin(value:integer);
begin
FButtonsRightMargin:=value;
resize;
end;


procedure TCometPageView.SetButtonsTopMargin(value:integer);
begin
FButtonsTopMargin:=value;
resize;
end;

function TCometPageView.hasanyDown:boolean;
var
i:integer;
pnl:TCometPagePanel;
begin
for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];
 if (csDown in pnl.btnState) then begin
  result:=true;
  exit;
 end;
end;
result:=False;

end;

procedure TCometPageView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
i:integer;
pnl:TCometPagePanel;
shouldRedraw:boolean;
begin
//someDown:=hasAnyDown;

for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];

 //if ((y>FButtonsHeight) or (y<FButtonsTopHitPoint)) then begin
 if ((y>pnl.BtnHitRect.bottom) or (y<pnl.BtnHitRect.top)) then begin
  shouldRedraw:=(csHover in pnl.btnState) or (csClicked in pnl.btnState);
  exclude(pnl.btnState,csHover);
  Exclude(pnl.btnState,csClicked);
 // if not (csClicked in pnl.btnState) then begin
 //  if pnl.panel<>nil then pnl.panel.Visible:=false;
 // end;
  if shouldRedraw then paintButton(pnl);
  continue;
 end;

 if ((x<pnl.BtnHitRect.left) or
     (x>=pnl.btnHitRect.Right)) then begin
  shouldRedraw:=(csHover in pnl.btnState) or (csClicked in pnl.btnState);
  exclude(pnl.btnState,csHover);
  Exclude(pnl.btnState,csClicked);
 // if not (csClicked in pnl.btnState) then begin
  // if pnl.panel<>nil then pnl.panel.Visible:=false;
 // end;
  if shouldRedraw then paintButton(pnl);
  continue;
 end;

 if (csClicked in pnl.btnState) then begin
  Exclude(pnl.btnState,csClicked);
  include(pnl.btnState,csDown);
  excludeDowns(pnl);
  activePage:=i;
 end;

end;

if not hasAnyDown then activePage:=0;
end;

procedure TCometPageView.excludeDowns(ExceptPanel:TCometPagePanel);
var
i:integer;
pnl:TCometPagePanel;
shouldRedraw:boolean;
begin
 for i:=0 to high(FPanels) do begin
  pnl:=FPanels[i];
  if pnl=ExceptPanel then continue;
  shouldRedraw:=(csDown in pnl.btnState);
  exclude(pnl.btnState,csDown);
  if shouldRedraw then paintButton(pnl);
 end;
end;

procedure TCometPageView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
i:integer;
pnl:TCometPagePanel;
shouldRedraw,shouldRedrawClose:boolean;
begin
//if y>FButtonsHeight then exit;

for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];

// if ((y>FButtonsHeight) or (y<FButtonsTopHitPoint)) then begin
 if ((y>pnl.BtnHitRect.bottom) or (y<pnl.BtnHitRect.top)) then begin
  shouldRedrawClose:=(bsHover in pnl.closeBtnState) and (pnl.hasCloseButton);
  shouldRedraw:=((csHover in pnl.btnState) or (csClicked in pnl.btnState));
  exclude(pnl.btnState,csHover);
  exclude(pnl.btnState,csClicked);
  if shouldRedraw or shouldRedrawClose then paintButton(pnl);
  //if pnl.panel<>nil then pnl.panel.Visible:=false;
  continue;
 end;

 if ((x<pnl.BtnHitRect.left) or
     (x>=pnl.btnHitRect.Right)) then begin
  shouldRedrawClose:=(bsHover in pnl.closeBtnState) and (pnl.hasCloseButton);
  shouldRedraw:=((csHover in pnl.btnState) or (csClicked in pnl.btnState));
  exclude(pnl.btnState,csHover);
  exclude(pnl.btnState,csClicked);
  if shouldRedraw or shouldRedrawClose then paintButton(pnl);
  //if pnl.panel<>nil then pnl.panel.Visible:=false;
  continue;
 end;

 if (pnl.hasCloseButton) and (FActivePage=i) then
   if ((x>=pnl.rcCloseButton.left) and (x<pnl.rcCloseButton.right) and
      (y>=pnl.rcCloseButton.top) and (y<=pnl.rcCloseButton.Bottom)) then begin
      DeletePanel(i);
      break;
   end;
   
 if FSwitchOnDown then begin
  Exclude(pnl.btnState,csClicked);
  include(pnl.btnState,csDown);
  excludeDowns(pnl);
  activePage:=i;
  break;
 end;

 shouldRedraw:=(not (csClicked in pnl.btnState));
 include(pnl.btnState,csClicked);
 if shouldRedraw then paintButton(pnl);
end;

end;

procedure TCometPageView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
i:integer;
pnl:TCometPagePanel;
shouldRedraw:boolean;
overCloseButton,shouldRedrawClose:boolean;
begin
//if y>FButtonsHeight then exit;
overCloseButton:=false;
shouldRedrawClose:=false;

for i:=0 to high(FPanels) do begin
 pnl:=FPanels[i];

 if ((y>pnl.BtnHitRect.bottom) or (y<pnl.BtnHitRect.top)) then begin
  shouldRedraw:=(csHover in pnl.btnState);
  if pnl.hasCloseButton then begin
   if (bsHover in pnl.closeBtnState) then shouldReDraw:=true;
   exclude(pnl.closeBtnState,bsHover);
  end;
  exclude(pnl.btnState,csHover);
  if shouldRedraw then paintButton(pnl);
  continue;
 end;

 if ((x<pnl.BtnHitRect.left) or
     (x>=pnl.btnHitRect.Right)) then begin
  shouldRedraw:=(csHover in pnl.btnState);
  if pnl.hasCloseButton then begin
   if (bsHover in pnl.closeBtnState) then shouldReDraw:=true;
   exclude(pnl.closeBtnState,bsHover);
  end;
  exclude(pnl.btnState,csHover);
  if shouldRedraw then paintButton(pnl);
  continue;
 end;

 if (pnl.hasCloseButton) and (FActivePage=i) then begin

   if ((x>=pnl.rcCloseButton.left) and (x<pnl.rcCloseButton.right) and
      (y>=pnl.rcCloseButton.top) and (y<=pnl.rcCloseButton.Bottom)) then begin
        overCloseButton:=true;
        shouldRedrawClose:=not (bsHover in pnl.closeBtnState);
        include(pnl.closeBtnState,bsHover);
       end else begin
        overCloseButton:=false;
        shouldRedrawClose:=(bsHover in pnl.closeBtnState);
        exclude(pnl.closeBtnState,bsHover);
       end;
 end;

 shouldRedraw:=(not (csHover in pnl.btnState)) or (shouldRedrawClose);
 if not overCloseButton then include(pnl.btnState,csHover);
 if shouldRedraw then paintButton(pnl);
end;

end;

constructor TCometPageView.create;
begin
 inherited;

 FOnPaintButtonFrame:=nil;
 FOnPaintButton:=nil;
 FOnPanelShow:=nil;
 FOnPaintCloseButton:=nil;
 FOnPanelClose:=nil;

 FNumRows:=1;
 FWrappable:=false;
 FTabsVisible:=true;
 FHideTabsOnSigle:=false;
 FDrawMargin:=false;
 FButtonsTopHitPoint:=4;
 FHorizBtnSpacing:=4;
 FActivePage:=0;
 FButtonsLeft:=5;
 FButtonsLeftMargin:=10;
 FButtonsTopMargin:=8;
 FButtonsHeight:=30;
 FColorFrame:=$00262423;
 FCloseButtonLeftMargin:=15;
 FCloseButtonTopMargin:=10;
 FCloseButtonWidth:=13;
 FCloseButtonHeight:=13;
 FSwitchOnDown:=true;

 SetLength(FPanels,0);
end;

destructor TCometPageView.destroy;
var
i:integer;
pnl:TCometPagePanel;
begin
 for i:=0 to high(FPanels) do begin
  pnl:=FPanels[i];
  pnl.free;
 end;
 SetLength(FPanels,0);

 inherited;
end;

function TCometPageView.GlyphWidth(pnl:TCometPagePanel):integer;
begin
if (pnl.imageIndex=-1) or (not pnl.hasCloseButton) then result:=0 else result:=18;
end;

procedure TCometPageView.checkInvalidate;
begin
if visible then invalidate;
end;

procedure TCometPageView.Paint;
var
 i:integer;
 pnl:TCometPagePanel;
 tempBitmap:graphics.tbitmap;
 textrect:TRect;
begin

 if (csDesigning in componentState) then begin
  inherited;
  exit;
 end;

 tempBitmap:=nil;

if FTabsVisible then begin

 tempBitmap:=tbitmap.create;
 tempBitmap.pixelformat:=pf24Bit;

  tempBitmap.width:=clientwidth;
  tempBitmap.Height:=FButtonsHeight*FNumRows;

  if Assigned(FOnPaintButtonFrame) then FOnPaintButtonFrame(self,tempBitmap.canvas,rect(0,0,tempBitmap.width,tempBitmap.Height));

 tempBitmap.canvas.font.name:=self.Font.name;
 tempBitmap.canvas.font.size:=self.font.size;
 tempBitmap.canvas.font.style:=self.Font.style;
 tempBitmap.canvas.font.color:=self.font.color;
 tempBitmap.canvas.brush.color:=self.color;


 for i:=0 to high(FPanels) do begin
  pnl:=FPanels[i];

   if Assigned(FOnPaintButton) then FOnPaintButton(self,pnl,tempBitmap.canvas,pnl.BtnHitRect);

   if pnl.hasCloseButton then
    if Assigned(FOnPaintCloseButton) then FOnPaintCloseButton(self,pnl,tempBitmap.Canvas,pnl.rcCloseButton);


   SetBkMode(tempBitmap.canvas.Handle, TRANSPARENT);


   TextRect:=rect(pnl.BtnHitRect.left,
                  pnl.BtnHitRect.top,
                  (pnl.BtnHitRect.right-((FCloseButtonWidth+2)*integer(pnl.hasCloseButton)))-5,
                  pnl.BtnHitRect.bottom);

   Windows.ExtTextOutW(tempBitmap.canvas.Handle,
                       pnl.BtnHitRect.left+FButtonsLeftMargin+1+GlyphWidth(pnl),pnl.BtnHitRect.top+FButtonsTopMargin,
                       ETO_CLIPPED, @textrect,
                       PwideChar(pnl.btncaption),Length(pnl.btncaption),
                       nil);
   
   {   windows.DrawTextExW(tempBitmap.canvas.Handle,
                       PwideChar(pnl.btncaption),Length(pnl.btncaption),
                       textRect,
                       DT_NOPREFIX or DT_HIDEPREFIX,
                       nil); }


 end;
end;  // endof FTabsVisible



 if FDrawMargin or FTabsVisible then begin
 canvas.Lock;

 if FTabsVisible then BitBlt(canvas.handle,0,0,TempBitmap.Width,tempBitmap.height,
                             TempBitmap.canvas.handle,0,0,SRCCopy);

 if FDrawMargin then begin
  canvas.brush.color:=FColorFrame; 
  canvas.frameRect(rect(-1,FbuttonsHeight,clientwidth+1,clientheight+1));
 end;

 canvas.Unlock;
 end;

 if TempBitmap<>nil then TempBitmap.free;
 
end;

procedure Register;
begin
  RegisterComponents('Comet', [TCometPageView]);
end;

end.