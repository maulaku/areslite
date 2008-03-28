{
 this file is part of Ares
 Aresgalaxy ( http://aresgalaxy.sourceforge.net )

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
This is the window of private chats, the following code handles events and UI
}

unit ufrmpvt;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, utility_ares,blcksock,synsock,messages,
   Menus,registry,const_ares,ares_types,ares_objects,classes2,
  ComCtrls, ExtCtrls, Drag_N_Drop, cometTrees, TntComCtrls,
  TntStdCtrls,tntforms, TntMenus,tntwindows,keywfunc, TntExtCtrls,
  xpbutton,jvrichedit,ufrmmain, comettopicpnl,
  thread_private_chat,const_win_messages,vars_global, JvExStdCtrls,
  cometPageView;

 

type
  Tfrmpvt = class(TTntForm)
    menu_filesession: TTntPopupMenu;
    Openfile1: TTntMenuItem;
    OpenExternal1: TTntMenuItem;
    Locatefile1: TTntMenuItem;
    Clearidle1: TTntMenuItem;
    N4: TTntMenuItem;
    Cancelall1: TTntMenuItem;
    Canceltransfer1: TTntMenuItem;
    menu_browse_file: TTntPopupMenu;
    NetworkDownload1: TTntMenuItem;
    N2: TTntMenuItem;
    FindMorefromthesame1: TTntMenuItem;
    Artist1: TTntMenuItem;
    Genre1: TTntMenuItem;
    menu_virfolder_download: TTntPopupMenu;
    Download1: TTntMenuItem;
    ExportHashlink1: TTntMenuItem;
    menu_regfolder_download: TTntPopupMenu;
    Download2: TTntMenuItem;
    menu_colors: TPopupMenu;
    N11: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    N91: TMenuItem;
    N101: TMenuItem;
    N111: TMenuItem;
    N121: TMenuItem;
    N131: TMenuItem;
    N141: TMenuItem;
    N151: TMenuItem;
    N161: TMenuItem;
    popupmemo: TTntPopupMenu;
    selectall1: TTntMenuItem;
    copy1: TTntMenuItem;
    openinnotepad2: TTntMenuItem;
    popuptransfer: TTntPopupMenu;
    send1: TTntMenuItem;
    sendfolder1: TTntMenuItem;
    user_granted: TTntMenuItem;
    autoacceptfiles1: TTntMenuItem;
    grantbrowse1: TTntMenuItem;
    tabview: TCometPageView;
    chatcontainer: TCometTopicPnl;
    splitter1: TTntSplitter;
    listview1: TCometTree;
    chatInnerContainer: TCometTopicPnl;
    cmd_panel: TCometTopicPnl;
    XPbutton6: TXPbutton;
    XPbutton5: TXPbutton;
    XPbutton4: TXPbutton;
    XPbutton3: TXPbutton;
    XPbutton2: TXPbutton;
    XPbutton1: TXPbutton;
    btn_toggle_transfer: TXPbutton;
    input: TTntMemo;
    TntSplitter1: TTntSplitter;
    testo: TJvRichEdit;
    btn_menu_transfer: TXPbutton;
    N1: TTntMenuItem;
    connecttohost1: TTntMenuItem;
    browseuserfile1: TTntMenuItem;
    all1: TTntMenuItem;
    N3: TTntMenuItem;
    audio1: TTntMenuItem;
    video1: TTntMenuItem;
    image1: TTntMenuItem;
    document1: TTntMenuItem;
    software1: TTntMenuItem;
    other1: TTntMenuItem;
    setmeaway1: TTntMenuItem;
    blockthishost1: TTntMenuItem;
    N5: TTntMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Setmeaway1Click(Sender: TObject);
    procedure Blockthishost1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Copytoclipboard1Click(Sender: TObject);
    procedure openinnotepad2Click(Sender: TObject);
    procedure Browseusersfile1Click(Sender: TObject);
    procedure Connecttohost1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ListView1CustomDrawSubItem(Sender: TCustomListView;Item: TListItem; SubItem: Integer; State: TCustomDrawState;var DefaultDraw: Boolean);
    procedure Panel2Resize(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure Send1Click(Sender: TObject);
    procedure listview1GetText(Sender: TBaseCometTree; Node: pCmtVnode; Column: TColumnIndex; var CellText: WideString);
    procedure listview1GetSize(Sender: TBaseCometTree; var Size: Integer);
    procedure listview1AfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: pCmtVnode; Column: TColumnIndex;CellRect: TRect);
    procedure listview1freenode(Sender: TBaseCometTree; Node: pCmtVnode);
    procedure Canceltransfer1Click(Sender: TObject);
    procedure Locatefile1Click(Sender: TObject);
    procedure Openfile1Click(Sender: TObject);
    procedure Clearidle1Click(Sender: TObject);
    procedure listview1HeaderClick(Sender: TCmtHdr; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
    procedure panel_left_resize(sender:tobject);
    procedure Showtransfers1Click(Sender: TObject);
    procedure user_grantedClick(Sender: TObject);
    procedure Cancelall1Click(Sender: TObject);
    procedure OpenExternal1Click(Sender: TObject);
    procedure Audio1Click(Sender: TObject);
    procedure Video1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Document1Click(Sender: TObject);
    procedure Software1Click(Sender: TObject);
    procedure listview1GetImageIndex(Sender: TBaseCometTree; Node: pCmtVnode; var ImageIndex: Integer);
    procedure listview1CompareNodes(Sender: TBaseCometTree; Node1,Node2: pCmtVnode; Column: TColumnIndex; var Result: Integer);
    procedure inputKeyPress(Sender: TObject; var Key: Char);
    procedure CometTree1GetText(Sender: TBaseCometTree;Node: pCmtVnode; Column: TColumnIndex; var CellText: WideString);
    procedure CometTree1CompareNodes(Sender: TBaseCometTree; Node1, Node2: pCmtVnode; Column: TColumnIndex;var Result: Integer);
    procedure Artist1Click(Sender: TObject);
    procedure Genre1Click(Sender: TObject);
    procedure NetworkDownload1Click(Sender: TObject);
    procedure CometTree1MouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure treeview1Click(Sender: TObject);
    procedure treeview2Click(Sender: TObject);
    procedure CometTree1Click(Sender: TObject);
    procedure Download1Click(Sender: TObject);
    procedure treeview1MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure treeview2MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure SendFolder1Click(Sender: TObject);
    procedure Grantbrowse1Click(Sender: TObject);
    procedure ExportHashlink1Click(Sender: TObject);
    procedure tasto_regular_viewclick(Sender: TObject);
    procedure tasto_virtual_viewclick(Sender: TObject);
    procedure Download2Click(Sender: TObject);
    procedure Autoacceptfiles1Click(Sender: TObject);
    procedure testoURLClick(Sender: TObject; const URLText: String;Button: TMouseButton);
    procedure XPbutton1Click(Sender: TObject);
    procedure XPbutton2Click(Sender: TObject);
    procedure XPbutton3Click(Sender: TObject);
    procedure XPbutton4Click(Sender: TObject);
    procedure N161DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;Selected: Boolean);
    procedure N161MeasureItem(Sender: TObject; ACanvas: TCanvas; var Width,Height: Integer);
    procedure N161Click(Sender: TObject);
    procedure XPbutton5Click(Sender: TObject);
    procedure XPbutton6Click(Sender: TObject);
    procedure Other1Click(Sender: TObject);
    procedure TntFormPaint(Sender: TObject);
    procedure chatcontainerResize(Sender: TObject);
    procedure btn_menu_transferMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tabviewPanelShow(Sender, aPanel: TObject);
    procedure enableSysMenus;
  private
    reader:tthread_private_chat;
    default_transfer_height:integer;
    stato_header_library:tstato_library_header;
    wantclose:boolean;
    fbrowseActivated:boolean;
    procedure add_source_download_browse(down:tdownload);
    procedure clear_lista_files_utente;
    procedure attiva_browse;
    procedure prendi_posizione_header_listview;
    procedure salva_posizioni_header_listview;
    procedure trigger_sendinput;
    procedure attiva_reader;
    function AddFile(FileName : wideString; count : integer):boolean;
    procedure salva_posizione_splitter_browse;
    procedure carica_stringe_international;
    procedure prendi_bounds_finestra;
    procedure salva_bounds_finestra;
    procedure addFrameSkin;
    procedure add_this_download(pfile:precord_file_library; folder:widestring);

    Procedure DropFile (var message: TWMDropFiles); message wm_dropfiles;

    procedure CheckMouseCapture;
    procedure drawOverButtons(Overmin:boolean=false; OverMax:boolean=false; OverClose:boolean=false);

    procedure DrawMouseOverButtons(var Message:TWMNCHitTest; point:Tpoint);
    procedure event(var msg:tmessage);message WM_PRIVATECHAT_EVENT;
    procedure show_transferview(var msg:tmessage); message WM_PRIVCHAT_SHOWTRANVIEW;
    procedure thread_end(var msg:tmessage); message WM_THREAD_PRIVCHAT_END;
    procedure WMNCLButtonDblClk(var Message : TWMNCLButtonDblClk);  message WM_NCLBUTTONDBLCLK;
    procedure WMNCLButtonUp(var Message : TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
    procedure WMNCHitTest(var Message : TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCLButtonDown(var Message : TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    
  public
   ISconnected:boolean;
    browseContainerPanel:TPanel;
    CometTree1:tcomettree;
    Treeview1,Treeview2:tcomettree;
    tasto_regular_view,tasto_virtual_view:txpbutton;
    panel_left:tcomettopicPnl;
    splitter2:tsplitter;
    lista_file:tmylist;
    socket:ttcpblocksocket;
    nick:string;
    readyToBrowse:boolean;
    remoteIP:cardinal;
    remoteIP_alt:cardinal;
    remoteIP_server:cardinal;
    remotePort:word;
    remotePort_server:word;

    lista_files_utente:tmylist;
    outtext:tmystringlist;
    browsed_bytes:int64;
    guid_browsestr:string;
    guid_browse:tguid;
    browse_type:byte;
    browse_files_totali_utente:word;
    default_panel_left_width:integer;
    randoms:string;
    user_pguid:string;    // per hotlisting...
    should_browse:boolean;
    should_send_grantbrowse:boolean;

    FrameRgn:HRgn;
    isMaximised:boolean;
    oldwidth,oldheight,oldleft,oldtop:integer;
    FMinDown,FMaxDown,FCloseDown:boolean;
    procedure crea_visual_browse;
    procedure send_file(filename:string;folder:string; randomsen:integer);
    procedure send_folder(folder:widestring);
    procedure seleziona_primo_in_library;
    procedure paintCaption;
    procedure paintFrame;
    procedure out_memo(memo:TjvRichEdit; nick:string; testo:string; should_notice:boolean);
    protected
     procedure WMSysCommand(var msg:TWMSyscommand); message WM_SYSCOMMAND;
     procedure WMWindowPositionChanging(var Message: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
     procedure CreateParams(var Params:TCreateParams); override;
  end;

var
  frmpvt: Tfrmpvt;
  chat_buttons_wantbg:boolean;

//{$EXTERNALSYM DragAcceptFiles}
//procedure DragAcceptFiles(Wnd: HWND; Accept: BOOL); stdcall;

implementation

uses
  ufrmemoticon,helper_search_gui,helper_player,
  helper_visual_headers,vars_localiz,helper_strings,helper_crypt,helper_diskio,
  helper_base64_32,helper_sockets,helper_urls,helper_ipfunc,helper_chatroom,helper_sorting,
  helper_visual_library,helper_mimetypes,helper_datetime,
  const_commands,helper_hashlinks,helper_chatroom_gui,
  helper_share_misc,helper_findmore,helper_download_misc,
  helper_registry,helper_stringfinal,helper_skin,helper_bighints;

{$R *.DFM}

//procedure DragAcceptFiles; external 'shell32.dll' name 'DragAcceptFiles';




///////////////// FRAME SKIN NC DRAWING
procedure tfrmpvt.WMNCLButtonDown(var Message : TWMNCLButtonDown);
begin
if not helper_skin.skinnedFrameLoaded then begin
 inherited;
 exit;
end;


  if IsIconic(Handle) then begin
   inherited;  {Call default processing.}
   exit;
  end;
  
  if (isMaximised) then begin
   if Message.HitTest=HTSYSMENU then inherited;
   exit;
  end;

    case Message.HitTest of

    HTMINBUTTON:begin
       //canvas.draw(clientwidth+skinParser.MinimiseLeft,skinParser.MinimiseTop,minimiseDownBitmap);
       SetCapture(self.handle);
       FMinDown:=true;
       FMaxDown:=false;
       FCloseDown:=false;
      end;

    HTMAXBUTTON:begin
          //canvas.draw(clientwidth+skinParser.MaximiseLeft,skinParser.MaximiseTop,skinParser.maximisedDownBitmap);
          SetCapture(self.handle);
          FMaxDown:=true;
          FMinDown:=false;
          FCloseDown:=false;
      end;

     HTCLOSE:begin
        SetCapture(self.handle);
        FCloseDown:=true;
        FMinDown:=false;
        FMaxDown:=false;
        //canvas.draw(clientwidth+skinParser.closeLeft,skinParser.closeTop,skinParser.closeDownBitmap);
      end;

    else
      inherited;  {Call default processing.}
    end;

end;

procedure tfrmpvt.WMWindowPositionChanging(var Message: TWMWINDOWPOSCHANGING);

  procedure HandleEdge(var Edge: Integer; SnapToEdge: Integer;
    SnapDistance: Integer = 0);
  begin
    if (Abs(Edge + SnapDistance - SnapToEdge) < 10) then
      Edge := SnapToEdge - SnapDistance;
  end;

var
 xr,yr:integer;
begin

 if (isMaximised) and (helper_skin.skinnedFrameLoaded) then begin
  xr:=GetSystemMetrics(SM_CXFRAME);
  yr:=GetSystemMetrics(SM_CYFRAME);
  Message.WindowPos^.x:=screen.WorkAreaRect.Left-xr;
  Message.WindowPos^.y:=screen.WorkAreaRect.top-yr;
  exit;
 end;


  if ((Message.WindowPos^.X <> 0) or (Message.WindowPos^.Y <> 0)) then
    with Message.WindowPos^, Monitor.WorkareaRect do
    begin
      if helper_skin.SkinnedFrameLoaded then begin
       xr:=GetSystemMetrics(SM_CXFRAME);
       yr:=GetSystemMetrics(SM_CYFRAME);
      end else begin
       xr:=0;
       yr:=0;
      end;
      HandleEdge(x, Left, Monitor.WorkareaRect.Left+yr);
      HandleEdge(y, Top, Monitor.WorkareaRect.Top+yr);
      HandleEdge(x, Right, Width-xr);
      HandleEdge(y, Bottom, Height-yr);
    end;

  inherited;
  
end;

procedure tfrmpvt.WMNCHitTest(var Message : TWMNCHitTest);
var
  point:Tpoint;
  sizeHe:integer;
begin

  if not helper_skin.skinnedFrameLoaded then begin
   inherited;
   exit;
  end;
  
   point.x:=Message.Pos.x;
   point.y:=Message.Pos.y;
   point:=ScreenToClient(point);

   //inc(point.X,GetSystemMetrics(SM_CXSIZEFRAME));
   sizeHe:=GetSystemMetrics(SM_CYSIZEFRAME);

  if (point.x<=helper_skin.FBorderWidth) and (not isMaximised) then begin
    CheckMouseCapture;
    if (point.y<helper_skin.FBorderHeight) and (not isMaximised) then Message.Result:=HTTOPLEFT
     else
     if (point.Y>=clientheight-helper_skin.FBorderHeight) and (not isMaximised) then Message.Result:=HTBOTTOMLEFT
      else
       if not isMaximised then Message.Result:=HTLEFT
        else
         Message.result:=windows.HTNOWHERE;
  end else
  if point.x>=clientwidth-helper_skin.FBorderWidth then begin
    CheckMouseCapture;
    drawOverButtons;
    if (point.y<helper_skin.FBorderHeight) and (not isMaximised) then Message.Result:=HTTOPRIGHT
     else
     if (point.Y>=clientheight-helper_skin.FBorderHeight) and (not isMaximised) then Message.Result:=HTBOTTOMRIGHT
      else
       if not isMaximised then Message.result:=HTRIGHT
        else Message.result:=windows.HTNOWHERE;
  end else
  if point.y>=clientheight-helper_skin.FBorderHeight then begin
   CheckMouseCapture;
   if not isMaximised then Message.result:=HTBOTTOM
    else Message.result:=windows.HTNOWHERE;
  end else
  if point.y<2 then begin
   CheckMouseCapture;
   drawOverButtons;
   if not isMaximised then Message.Result:=HTTOP
    else Message.result:=windows.HTNOWHERE;
  end else
  if ((point.y>=2) and (point.y<=helper_skin.FCaptionHeight)) then begin
    if point.x<clientwidth-helper_skin.FrameTopRigthBitmap.SourceCopyWidth then begin
     CheckMouseCapture;
     drawOverButtons;
     if ((point.x<helper_skin.FCaptionIconRect.Left+16) and
         (helper_skin.FCaptionIconRect.left>0)) then message.result:=HTSYSMENU
      else
      Message.Result:=HTCAPTION;
    end else DrawMouseOverButtons(Message,point);//HTCLOSE;//HTMAXBUTTON//HTMAXBUTTON
  end else begin
    CheckMouseCapture;
    drawOverButtons;
    Message.Result:=HTCLIENT;
  end;
end;

procedure tfrmpvt.CMMouseLeave(var Msg:TMessage);
begin
if not helper_skin.skinnedFrameLoaded then exit;

 if getCapture<>self.Handle then begin
  FCloseDown:=false;
  FMaxDown:=false;
  FMinDown:=false;
 end;
 drawOverButtons;
end;

procedure tfrmpvt.paintFrame;
var
//rc:trect;
pointx,pointy:integer;
begin
if helper_skin.frameSourceBitmap=nil then exit;

 canvas.lock;
 // top left
 bitBlt(canvas.handle,
        0,0,helper_skin.FrameTopLeftBitmap.SourceCopyWidth,helper_skin.FrameTopLeftBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.Handle,
        helper_skin.FrameTopLeftBitmap.SourceCopyleft,helper_skin.FrameTopLeftBitmap.SourceCopyTop,
        SRCCopy);

 // top
 pointx:=helper_skin.FrameTopLeftBitmap.SourceCopyWidth;
 while (pointx<clientwidth-helper_skin.FrameTopRigthBitmap.SourceCopyWidth) do begin
  BitBlt(canvas.handle,
         pointx,0,helper_skin.FrameTopBitmap.SourceCopyWidth,helper_skin.FrameTopBitmap.SourceCopyHeight,
         helper_skin.FrameSourceBitmap.canvas.handle,
         helper_skin.FrameTopBitmap.SourceCopyleft,helper_skin.FrameTopBitmap.SourceCopyTop,
         SRCCopy);
  inc(pointx,helper_skin.FrameTopBitmap.SourceCopyWidth);
 end;


 // top right...buttons
 bitBlt(canvas.Handle,
        clientwidth-helper_skin.FrameTopRigthBitmap.SourceCopyWidth,0,helper_skin.FrameTopRigthBitmap.SourceCopyWidth,helper_skin.FrameTopRigthBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.Handle,
        helper_skin.FrameTopRigthBitmap.SourceCopyleft,helper_skin.FrameTopRigthBitmap.SourceCopyTop,
        SRCCopy);


 //lefttop
  bitBlt(canvas.Handle,
        0,helper_skin.FrameTopLeftBitmap.SourceCopyHeight,helper_skin.FrameLeftTopBitmap.SourceCopyWidth,helper_skin.FrameLeftTopBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.Handle,
        helper_skin.FrameLeftTopBitmap.SourceCopyleft,helper_skin.FrameLeftTopBitmap.SourceCopyTop,
        SRCCopy);


 // left border
 pointy:=helper_skin.FrameTopLeftBitmap.SourceCopyHeight+helper_skin.FrameLeftTopBitmap.SourceCopyHeight;
 while (pointy<(clientHeight-helper_skin.FrameLeftBottomBitmap.SourceCopyHeight)-helper_skin.FrameBottomLeftBitmap.SourceCopyHeight) do begin
 // canvas.Draw(0,pointy,helper_skin.leftBitmap);
  BitBlt(canvas.handle,
         0,pointY,helper_skin.FrameLeftBitmap.SourceCopyWidth,helper_skin.FrameLeftBitmap.SourceCopyHeight,
         helper_skin.FrameSourceBitmap.canvas.Handle,
         helper_skin.FrameLeftBitmap.SourceCopyleft,helper_skin.FrameLeftBitmap.SourceCopyTop,
         SRCCopy);
  inc(pointy,helper_skin.FrameLeftBitmap.SourceCopyHeight);
 end;


 // left bottom corner
 BitBlt(canvas.handle,
        0,(clientHeight-helper_skin.FrameLeftBottomBitmap.SourceCopyHeight)-helper_skin.FrameBottomLeftBitmap.SourceCopyHeight,helper_skin.FrameLeftBottomBitmap.SourceCopyWidth,helper_skin.FrameLeftBottomBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.handle,
        helper_skin.FrameLeftBottomBitmap.SourceCopyleft,helper_skin.FrameLeftBottomBitmap.SourceCopyTop,
        SRCCopy);

 // bottom left corner
 BitBlt(canvas.handle,
        0,clientHeight-helper_skin.FrameBottomLeftBitmap.SourceCopyHeight,helper_skin.FrameBottomLeftBitmap.SourceCopyWidth,helper_skin.FrameBottomLeftBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.handle,
        helper_skin.FrameBottomLeftBitmap.SourceCopyleft,helper_skin.FrameBottomLeftBitmap.SourceCopyTop,
        SRCCopy);



 // bottom border
 pointx:=helper_skin.FrameBottomLeftBitmap.SourceCopyWidth;
 while (pointx<clientwidth-helper_skin.FrameBottomRightBitmap.SourceCopyWidth) do begin
  BitBlt(canvas.handle,
         pointx,clientheight-helper_skin.FrameBottomBitmap.SourceCopyHeight,helper_skin.FrameBottomBitmap.SourceCopyWidth,helper_skin.FrameBottomBitmap.SourceCopyHeight,
         helper_skin.FrameSourceBitmap.canvas.handle,
         helper_skin.FrameBottomBitmap.SourceCopyleft,helper_skin.FrameBottomBitmap.SourceCopyTop,
         SRCCopy);
 // canvas.draw(pointx,clientheight-helper_skin.bottomBitmap.height,helper_skin.bottomBitmap);
  inc(pointx,helper_skin.FrameBottomBitmap.SourceCopyWidth);
 end;

 //right border
 pointy:=helper_skin.FrameTopRigthBitmap.SourceCopyHeight+helper_skin.FrameRightTopBitmap.SourceCopyHeight;
 while (pointy<(clientheight-helper_skin.FrameBottomRightBitmap.SourceCopyHeight)-helper_skin.FrameRightBottomBitmap.SourceCopyHeight) do begin
  BitBlt(canvas.handle,
         clientwidth-helper_skin.FrameRightBitmap.SourceCopyWidth,pointY,helper_skin.FrameRightBitmap.SourceCopyWidth,helper_skin.FrameRightBitmap.SourceCopyHeight,
         helper_skin.FrameSourceBitmap.canvas.handle,
         helper_skin.FrameRightBitmap.SourceCopyleft,helper_skin.FrameRightBitmap.SourceCopyTop,
         SRCCopy);
  inc(pointy,helper_skin.FrameRightBitmap.SourceCopyHeight);
 end;


  //rightbottom
  BitBlt(canvas.handle,
         clientWidth-helper_skin.FrameRightBottomBitmap.SourceCopyWidth,(clientHeight-helper_skin.FrameBottomRightBitmap.SourceCopyHeight)-helper_skin.FrameRightBottomBitmap.SourceCopyHeight,helper_skin.FrameRightBottomBitmap.SourceCopyWidth,helper_skin.FrameRightBottomBitmap.SourceCopyHeight,
         helper_skin.FrameSourceBitmap.canvas.handle,
         helper_skin.FrameRightBottomBitmap.SourceCopyleft,helper_skin.FrameRightBottomBitmap.SourceCopyTop,
         SRCCopy);



 //bottom right
 BitBlt(canvas.handle,
        clientwidth-helper_skin.FrameBottomRightBitmap.SourceCopyWidth,clientHeight-helper_skin.FrameBottomRightBitmap.SourceCopyHeight,helper_skin.FrameBottomRightBitmap.SourceCopyWidth,helper_skin.FrameBottomRightBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.handle,
        helper_skin.FrameBottomRightBitmap.SourceCopyleft,helper_skin.FrameBottomRightBitmap.SourceCopyTop,
        SRCCopy);

 // rightTop border
 BitBlt(canvas.handle,
        clientwidth-helper_skin.FrameRightTopBitmap.SourceCopyWidth,helper_skin.FrameTopLeftBitmap.SourceCopyHeight,helper_skin.FrameRightTopBitmap.SourceCopyWidth,helper_skin.FrameRightTopBitmap.SourceCopyHeight,
        helper_skin.FrameSourceBitmap.canvas.handle,
        helper_skin.FrameRightTopBitmap.SourceCopyleft,helper_skin.FrameRightTopBitmap.SourceCopyTop,
        SRCCopy);


 if helper_skin.FCaptionIconRect.left>=0 then begin
 // canvas.Draw(helper_skin.FCaptionIconRect.left,helper_skin.FCaptionIconRect.Top,self.Icon);
   DrawIconEx(canvas.handle, helper_skin.FCaptionIconRect.left,helper_skin.FCaptionIconRect.Top,self.icon.Handle, 0, 0, 0, 0, DI_NORMAL);
  end;

  if helper_skin.FCaptionRect.left>=0 then paintCaption;

 canvas.Unlock;
end;

procedure TFrmpvt.CreateParams(var Params:TCreateParams);
begin
inherited CreateParams(Params);
Params.ExStyle:=Params.ExStyle and not WS_EX_TOOLWINDOW or WS_EX_APPWINDOW;
Params.ExStyle:=Params.ExStyle and not WS_EX_CONTROLPARENT;
Params.ExStyle:=Params.ExStyle or WS_EX_ACCEPTFILES;
end;

procedure TFrmpvt.paintCaption;
var
 rc:TRect;
begin
   SetBkMode(canvas.Handle, TRANSPARENT);
   canvas.font.color:=clWhite;
   canvas.font.style:=[fsBold];
   rc:=rect(helper_skin.FCaptionRect.left,helper_skin.FCaptionRect.top,width-helper_skin.FrameTopRigthBitmap.SourceCopyWidth,height-helper_skin.FCaptionRect.top);
   Windows.ExtTextOutW(canvas.Handle, helper_skin.FCaptionRect.left, helper_skin.FCaptionRect.top, ETO_CLIPPED, @rc, PWideChar(Caption),Length(Caption), nil);
end;

procedure tfrmpvt.CheckMouseCapture;
begin

if GetCapture<>self.handle then begin
 FMinDown:=false;
 FMaxDown:=false;
 FCloseDown:=false;
end;

end;

procedure tfrmpvt.DrawMouseOverButtons(var Message:TWMNCHitTest; point:Tpoint);
var
HasCapture:boolean;
begin
hasCapture:=(GetCapture=self.handle);

 if ((point.x>=clientwidth+helper_skin.MinimisebtnHitRect.Left) and (point.x<=(clientwidth+helper_skin.MinimisebtnHitRect.Left)+helper_skin.MinimisebtnHitRect.right) and
     (point.y>=helper_skin.MinimisebtnHitRect.Top) and (point.y<=helper_skin.MinimisebtnHitRect.Top+helper_skin.MinimisebtnHitRect.bottom)) then begin
  Message.result:=HTMINBUTTON;
  DrawOverButtons(true,false,false);
   if ((not HasCapture) and (FminDown)) then postMessage(self.handle,WM_NCLBUTTONUP,HTMINBUTTON,0) else
   if not HasCapture then begin
    FMinDown:=false;
    FCloseDown:=false;
    FMaxDown:=false;
   end;
 // if HasCapture then
  // if FMinDown then application.Minimize;
 end else
 if ((point.x>=clientwidth+helper_skin.MaximisebtnHitRect.Left) and (point.x<=(clientwidth+helper_skin.MaximisebtnHitRect.Left)+helper_skin.MaximiseBtnHitRect.right) and
     (point.y>=helper_skin.MaximisebtnHitRect.Top) and (point.y<=helper_skin.MaximisebtnHitRect.Top+helper_skin.MaximisebtnHitRect.bottom)) then begin
  Message.result:=HTMAXBUTTON;
  DrawOverButtons(false,true,false);
   if ((not HasCapture) and (FMaxDown)) then postMessage(self.handle,WM_NCLBUTTONUP,HTMAXBUTTON,0) else
   if not HasCapture then begin
    FMinDown:=false;
    FCloseDown:=false;
    FMaxDown:=false;
   end;
 end else
 if ((point.x>=clientwidth+helper_skin.closebtnHitRect.Left) and (point.x<=(clientwidth+helper_skin.closebtnHitRect.Left)+helper_skin.closebtnHitRect.right) and
     (point.y>=helper_skin.closebtnHitRect.Top) and (point.y<=helper_skin.closebtnHitRect.Top+helper_skin.closebtnHitRect.bottom)) then begin
  Message.result:=HTCLOSE;
  DrawOverButtons(false,false,true);
   if ((not HasCapture) and (FCloseDown)) then postMessage(self.handle,WM_NCLBUTTONUP,HTCLOSE,0) else
   if not HasCapture then begin
    FMinDown:=false;
    FCloseDown:=false;
    FMaxDown:=false;
   end;
 end else begin
   drawOverButtons;
    //just guessing...
    if point.y<4 then Message.Result:=HTTOP
     else Message.Result:=HTCAPTION;
   exit;
  end;

end;

procedure tfrmpvt.drawOverButtons(Overmin:boolean=false; OverMax:boolean=false; OverClose:boolean=false);
begin

canvas.lock;

if ((OverMin) and (not FMinDown) and (not FMaxDown) and (not FCloseDown)) then bitBlt(canvas.handle,
                                                                                      clientwidth+helper_skin.MinimiseBtnPaintPoint.x,helper_skin.MinimiseBtnPaintPoint.y,helper_skin.FrameMinimiseOffBitmap.SourceCopyWidth,helper_skin.FrameMinimiseOffBitmap.SourceCopyHeight,
                                                                                      helper_skin.FrameSourceBitmap.Canvas.handle,
                                                                                      helper_skin.FrameMinimiseHoverBitmap.SourceCopyleft,helper_skin.FrameMinimiseHoverBitmap.SourceCopyTop,
                                                                                      SRCCopy)

 else
  if ((FMinDown) and (OverMin)) then bitBlt(canvas.handle,
                                            clientwidth+helper_skin.MinimiseBtnPaintPoint.x,helper_skin.MinimiseBtnPaintPoint.y,helper_skin.FrameMinimiseOffBitmap.SourceCopyWidth,helper_skin.FrameMinimiseOffBitmap.SourceCopyHeight,
                                            helper_skin.FrameSourceBitmap.Canvas.handle,
                                            helper_skin.FrameMinimiseDownBitmap.SourceCopyleft,helper_skin.FrameMinimiseDownBitmap.SourceCopyTop,
                                            SRCCopy)

   else
   bitBlt(canvas.handle,
          clientwidth+helper_skin.MinimiseBtnPaintPoint.x,helper_skin.MinimiseBtnPaintPoint.y,helper_skin.FrameMinimiseOffBitmap.SourceCopyWidth,helper_skin.FrameMinimiseOffBitmap.SourceCopyHeight,
          helper_skin.FrameSourceBitmap.Canvas.handle,
          helper_skin.FrameMinimiseOffBitmap.SourceCopyleft,helper_skin.FrameMinimiseOffBitmap.SourceCopyTop,
          SRCCopy);




if ((OverMax) and (not FMaxDown) and (not FMinDown) and (not FCloseDown)) then bitBlt(canvas.handle,
                                                                                      clientwidth+helper_skin.MaximiseBtnPaintPoint.x,helper_skin.MaximiseBtnPaintPoint.y,helper_skin.FrameMaximiseOffBitmap.SourceCopyWidth,helper_skin.FrameMaximiseOffBitmap.SourceCopyHeight,
                                                                                      helper_skin.FrameSourceBitmap.Canvas.handle,
                                                                                      helper_skin.FrameMaximiseHoverBitmap.SourceCopyleft,helper_skin.FrameMaximiseHoverBitmap.SourceCopyTop,
                                                                                      SRCCopy)
 else
  if ((FMaxDown) and (OverMax)) then bitBlt(canvas.handle,
                                            clientwidth+helper_skin.MaximiseBtnPaintPoint.x,helper_skin.MaximiseBtnPaintPoint.y,helper_skin.FrameMaximiseOffBitmap.SourceCopyWidth,helper_skin.FrameMaximiseOffBitmap.SourceCopyHeight,
                                            helper_skin.FrameSourceBitmap.Canvas.handle,
                                            helper_skin.FrameMaximiseDownBitmap.SourceCopyleft,helper_skin.FrameMaximiseDownBitmap.SourceCopyTop,
                                            SRCCopy)
   else
    bitBlt(canvas.handle,
           clientwidth+helper_skin.MaximiseBtnPaintPoint.x,helper_skin.MaximiseBtnPaintPoint.y,helper_skin.FrameMaximiseOffBitmap.SourceCopyWidth,helper_skin.FrameMaximiseOffBitmap.SourceCopyHeight,
           helper_skin.FrameSourceBitmap.Canvas.handle,
           helper_skin.FrameMaximiseOffBitmap.SourceCopyleft,helper_skin.FrameMaximiseOffBitmap.SourceCopyTop,
           SRCCopy);



if ((OverClose) and (not FCloseDown) and (not FMaxDown) and (not FMinDown)) then bitBlt(canvas.handle,
                                                                                        clientwidth+helper_skin.CloseBtnPaintPoint.x,helper_skin.CloseBtnPaintPoint.y,helper_skin.FrameCloseOffBitmap.SourceCopyWidth,helper_skin.FrameCloseOffBitmap.SourceCopyHeight,
                                                                                        helper_skin.FrameSourceBitmap.Canvas.handle,
                                                                                        helper_skin.FrameCloseHoverBitmap.SourceCopyleft,helper_skin.FrameCloseHoverBitmap.SourceCopyTop,
                                                                                        SRCCopy)
 else
  if ((FCloseDown) and (OverClose)) then bitBlt(canvas.handle,
                                                clientwidth+helper_skin.CloseBtnPaintPoint.x,helper_skin.CloseBtnPaintPoint.y,helper_skin.FrameCloseOffBitmap.SourceCopyWidth,helper_skin.FrameCloseOffBitmap.SourceCopyHeight,
                                                helper_skin.FrameSourceBitmap.Canvas.handle,
                                                helper_skin.FrameCloseDownBitmap.SourceCopyleft,helper_skin.FrameCloseDownBitmap.SourceCopyTop,
                                                SRCCopy)
   else
    bitBlt(canvas.handle,
           clientwidth+helper_skin.CloseBtnPaintPoint.x,helper_skin.CloseBtnPaintPoint.y,helper_skin.FrameCloseOffBitmap.SourceCopyWidth,helper_skin.FrameCloseOffBitmap.SourceCopyHeight,
           helper_skin.FrameSourceBitmap.Canvas.handle,
           helper_skin.FrameCloseOffBitmap.SourceCopyleft,helper_skin.FrameCloseOffBitmap.SourceCopyTop,
           SRCCopy);
           
   canvas.unlock;

end;

procedure tfrmpvt.WMNCLButtonUp(var Message : TWMNCLButtonUp);
begin


if not helper_skin.skinnedFrameLoaded then begin
 inherited;
 exit;
end;

  if IsIconic(self.Handle) then begin
   FCloseDown:=false;
   FMaxDown:=false;
   FMinDown:=false;
   inherited;  {Call default processing.}
   exit;
  end;


  case Message.HitTest of

    HTMINBUTTON:begin
      Sendmessage(self.handle,WM_SYSCOMMAND,SC_MINIMIZE,0);
    end;

    HTMAXBUTTON:begin
       if not isMaximised then SendMessage(self.Handle,WM_SYSCOMMAND,SC_MAXIMIZE,0)
        else SendMessage(self.handle,WM_SYSCOMMAND,SC_RESTORE,0);
      end;

     HTCLOSE:begin
      formhint_hide;
      close;
     end;

     else begin
      inherited;  {Call default processing.}
     end;

    end;

    
  if GetCapture=self.handle then ReleaseCapture;
  FCloseDown:=false;
  FMaxDown:=false;
  FMinDown:=false;
end;

procedure tfrmpvt.WMNCLButtonDblClk(var Message : TWMNCLButtonDblClk);
var
pt : TPoint;
begin
if not helper_skin.skinnedFrameLoaded then begin
 inherited;
 exit;
end;

pt := Point(Message.XCursor, Message.YCursor);

  if (Message.HitTest=HTCAPTION) and not IsIconic(Handle) then begin

       if not isMaximised then SendMessage(self.Handle,WM_SYSCOMMAND,SC_MAXIMIZE,0)
        else SendMessage(self.handle,WM_SYSCOMMAND,SC_RESTORE,0);
  end else
 if (Message.HitTest=HTSYSMENU) and not IsIconic(handle) then SendMessage(self.handle,WM_SYSCOMMAND,SC_CLOSE,0);
end;

///////////////////////////////////


procedure Tfrmpvt.show_transferview(var msg:tmessage);
begin
if not btn_toggle_transfer.down then Showtransfers1Click(nil);
end;

procedure tfrmpvt.seleziona_primo_in_library;
var nodo:pCmtVnode;
begin
 if tasto_virtual_view.down then begin
   nodo:=treeview1.getfirst;
   if nodo=nil then exit;
   treeview1.Selected[nodo]:=true;
   treeview1click(treeview1);
 end else begin
   nodo:=treeview2.getfirst;
   if nodo=nil then exit;
   treeview2.Selected[nodo]:=true;
   treeview2click(treeview2);
 end;
end;

procedure Tfrmpvt.DropFile(var message: TWMDropFiles);
var
   i : integer;
Begin
  for i := 0 to DropFileCount(message)-1 do
   if not addfile(DropGetFile(message,i),i) then exit;

 Dropped(message); // Very important

 if not btn_toggle_transfer.down then showtransfers1click(nil);
end;

function tfrmpvt.AddFile(FileName : wideString; count : integer):boolean;
begin                                                     //.lnk
 if lowercase(extractfileext(widestrtoutf8str(filename)))=chr(46)+chr(108)+chr(110)+chr(107) then filename:=helper_urls.estrai_path_da_lnk(filename);

 if not isfolder(filename) then self.send_file(widestrtoutf8str(filename),'',random($fffffe))
  else self.send_folder(filename);

 result := true;
end;

procedure tfrmpvt.thread_end(var msg:tmessage);
begin
try
 if reader=nil then exit;
  reader.waitfor;
  reader.free;
except
end;

 reader:=nil;

 if ((msg.lparam=11) or (msg.wparam=11)) then wantclose:=True;

  if wantclose then close;
end;

procedure tfrmpvt.out_memo(memo:TjvRichEdit; nick:string; testo:string; should_notice:boolean);
var
i:integer;
begin


if length(nick)>0 then helper_chatroom_gui.out_text_memo(memo,COLORE_CHATPVTNICK,'',utf8strtowidestr(nick)+chr(58),false);
helper_chatroom_gui.out_text_memo(memo,COLORE_CHAT_FONT,'',chr(32)+chr(32)+chr(32)+utf8strtowidestr(testo));

 if should_notice then
  if ((GetForegroundWindow<>self.handle) or (windowstate=WSMINIMIZED)) then
  // for i:=1 to 6 do begin
     FlashWindow(self.handle,false);
   //  sleep(50);
  //   application.processmessages;
  // end;

end;



procedure tfrmpvt.event(var msg:tmessage);
var
i:integer;
begin

if msg.lparam=14 then begin
  attiva_reader;
  exit;
end;

if socket<>nil then begin
ISconnected:=true;

  show;

  //for i:=1 to 6 do begin
   FlashWindow(self.handle,false);
  // sleep(50);
  // application.processmessages;
  //end;

  testo.Font.Name:=vars_global.font_chat.name;
  testo.Font.size:=vars_global.font_chat.size;
  testo.streammode:=[smSelection,smPlainRTF];
  
 reader:=tthread_private_chat.create(true);
  reader.socket:=socket;
  reader.ip:=inet_addr(pchar(socket.ip));
  reader.ip_alt:=0;
  reader.port:=0;
  reader.accepted:=true;
  reader.remnick:='';
  reader.form:=self;
  reader.resume;

end else begin
 postmessage(self.handle,WM_CLOSE,0,0);
end;

end;

procedure tfrmpvt.carica_stringe_international;
begin
font:=ares_FrmMain.font;

listview1.header.font:=ares_FrmMain.font;

caption:=GetLangStringW(STR_CHAT);

 connecttohost1.caption:=GetLangStringW(STR_RECONNECTTOHOST_MENU);
 Browseuserfile1.caption:=GetLangStringW(STR_BRS_HINT);
 All1.caption:=GetLangStringW(STR_ALL);
 Audio1.caption:=GetLangStringW(STR_AUDIO);
 Video1.caption:=GetLangStringW(STR_VIDEO);
 Image1.caption:=GetLangStringW(STR_IMAGE);
 Document1.caption:=GetLangStringW(STR_DOCUMENT);
 Software1.caption:=GetLangStringW(STR_SOFTWARE);
 other1.caption:=GetLangStringW(STR_OTHER);

 btn_menu_transfer.caption:=GetLangStringA(STR_FILE_MENU);
 Send1.caption:=GetLangStringW(STR_SENDFILE_MENU);
 SendFolder1.caption:=GetLangStringW(STR_SENDFOLDER_MENU);
 user_granted.caption:=GetLangStringW(STR_ACCEPTINCOMIN_MENU);
 Autoacceptfiles1.caption:=GetLangStringW(STR_AUTOACCEPTFILES);
 Grantbrowse1.caption:=GetLangStringW(STR_GRANTBROWSE_MENU);

 btn_toggle_transfer.caption:=GetLangStringA(STR_SHOWTRANSFERS_MENU);
 Selectall1.caption:=GetLangStringW(STR_SELECTALL_MENU);
 Copy1.caption:=GetLangStringW(STR_COPY_MENU);
 Openinnotepad2.caption:=GetLangStringW(STR_OPENINNOTEPAD_MENU);
 Setmeaway1.caption:=GetLangStringW(STR_SETMEAWAY_MENU);
 Blockthishost1.caption:=GetLangStringW(STR_BLOCKTHISHOST_MENU);
//popup
Openfile1.caption:=GetLangStringW(STR_OPENPLAY);
OpenExternal1.caption:=GetLangStringW(STR_OPENEXTERNAL);
Clearidle1.caption:=GetLangStringW(STR_CLEARIDLE);
Locatefile1.caption:=GetLangStringW(STR_LOCATEFILE);
Cancelall1.caption:=GetLangStringW(STR_CANCELLALL_MENU);
Canceltransfer1.caption:=GetLangStringW(STR_CANCEL_TRANSFER);

//popup browse
 Download1.caption:=GetLangStringW(STR_DOWNLOAD); //da treeview1
 Download2.caption:=download1.caption;
 NetworkDownload1.caption:=download1.caption;
 ExportHashlink1.caption:=GetLangStringW(STR_EXPORT_HASHLINK);
 Findmorefromthesame1.caption:=GetLangStringW(STR_FINDMOREOFTHESAME);
 Artist1.caption:=GetLangStringW(STR_ARTIST);
 Genre1.caption:=GetLangStringW(STR_GENRE);

 with listview1.header do begin
  columns[0].text:=GetLangStringW(STR_FILE);
  columns[1].text:=GetLangStringW(STR_TYPE);
  columns[2].text:=GetLangStringW(STR_STATUS);
  columns[3].text:=GetLangStringW(STR_PROGRESS);
  columns[4].text:=GetLangStringW(STR_SPEED);
  columns[5].text:=GetLangStringW(STR_REMAINING);
  columns[6].text:=GetLangStringW(STR_TRANSMITTED);
 end;
 
 btn_toggle_transfer.left:=btn_menu_transfer.left+btn_menu_transfer.width+5;

end;

procedure tfrmpvt.prendi_bounds_finestra;
var
reg:tregistry;
lef,topi,wid,hei:integer;
begin
//
reg:=tregistry.create;
with reg do begin
 openkey(areskey+chr(98)+chr(111)+chr(117)+chr(110)+chr(100)+chr(115),true);   //bounds

 if valueexists('PM.Width') then wid:=readinteger('PM.Width') else wid:=500;
 if valueexists('PM.Height') then hei:=readinteger('PM.Height') else hei:=300;
 if valueexists('PM.Left') then lef:=readinteger('PM.Left') else lef:=100;
 if valueexists('PM.Top') then topi:=readinteger('PM.Top') else topi:=100;
 if valueexists('PM.BrowseWidth') then default_panel_left_width:=readinteger('PM.BrowseWidth')
  else default_panel_left_width:=200;

 closekey;
 destroy;
end;

 if topi<0 then topi:=1;
 if lef<0 then lef:=1;
 if topi>screen.Height-20 then topi:=1;
 if lef>screen.width-20 then lef:=1;
 if wid<300 then wid:=300;
 if hei<200 then hei:=200;
 if hei>screen.height then hei:=200;
 if wid>screen.width then wid:=300;

 top:=topi;
 left:=lef;
 height:=hei;
 width:=wid;

      oldwidth:=self.width;
      oldheight:=self.height;
      oldleft:=self.left;
      oldtop:=self.top;
end;

procedure tfrmpvt.salva_bounds_finestra;
var
reg:tregistry;
begin

reg:=tregistry.create;
with reg do begin
 openkey(areskey+chr(98)+chr(111)+chr(117)+chr(110)+chr(100)+chr(115),true);

 if ((top>-1) and (top<screen.height-50)) then writeinteger('PM.Top',top);
 if ((left>-1) and (left<screen.width-50)) then writeinteger('PM.Left',left);
 if ((width>299) and (width<screen.width-50)) then writeinteger('PM.Width',width);
 if ((height>199) and (height<screen.height-50)) then writeinteger('PM.Height',height);

 closekey;
 destroy;
end;

end;

procedure Tfrmpvt.FormShow(Sender: TObject);
var
reg:tregistry;
begin
carica_stringe_international;
prendi_bounds_finestra;

 reg:=tregistry.create;
 with reg do begin
  openkey(areskey,true);
  if valueexists('PrivateMessage.AutoAcceptFiles') then begin
   autoacceptfiles1.checked:=(readinteger('PrivateMessage.AutoAcceptFiles')=1);
  end else autoacceptfiles1.checked:=false;
  closekey;
  destroy;
 end;               
 
 tabview.font.color:=COLORE_TOOLBAR_FONT;
 tabview.buttonsHeight:=ares_frmmain.tabs_pageview.buttonsHeight;
 tabview.buttonsLeftMargin:=ares_frmmain.tabs_pageview.buttonsLeftMargin;
 tabview.buttonsRightMargin:=ares_frmmain.tabs_pageview.buttonsRightMargin;
 tabview.buttonsTopMargin:=ares_frmmain.tabs_pageview.buttonsTopMargin;
 tabview.buttonsLeft:=ares_frmmain.tabs_pageview.buttonsLeft;
 tabview.onPaintButton:=ufrmmain.ares_frmmain.tabs_pageviewPaintButton;
 tabview.onPaintButtonFrame:=ufrmmain.ares_frmmain.tabs_pageviewPaintButtonFrame;
 tabview.AddPanel(IdxBtnChat,GetLangStringW(STR_CHAT),[cometPageView.csDown],chatContainer,nil,false,-1);
 

        testo.color:=colorRTtoTColor(COLORE_CHAT_BG);
        testo.font.color:=colorRTtoTColor(COLORE_CHAT_FONT);
        input.font.color:=testo.font.color;
        input.color:=testo.color;

 XPbutton1.OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
 XPbutton2.OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
 XPbutton3.OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
 XPbutton4.OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
 XPbutton5.OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
 XPbutton6.OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
 btn_toggle_transfer.onXpButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;
 btn_menu_transfer.OnXPButtonDraw:=ufrmmain.ares_frmmain.btn_tab_webXPButtonDraw;

 XPButton4.imagelist:=ufrmmain.ares_frmmain.imglist_emotic;
 XPButton5.imagelist:=ufrmmain.ares_frmmain.imglist_emotic;
 XPButton6.imagelist:=ufrmmain.ares_frmmain.imglist_emotic;
 btn_menu_transfer.imagelist:=ufrmmain.ares_frmmain.imagelist_menu;
 
 with listview1 do begin
  header.font.name:=ares_FrmMain.Font.name;
  header.font.size:=ares_FrmMain.Font.size;
  header.font.color:=COLORE_LISTVIEWS_HEADERFONT;
  header.background:=COLORE_LISTVIEWS_HEADERBK;
  font.name:=ares_frmmain.font.name;
  font.size:=Ares_frmmain.font.size;
  font.color:=COLORE_LISTVIEWS_FONT;
  Color:=COLORE_LISTVIEWS_BG;
  BGColor:=COLORE_ALTERNATE_ROW;
  colors.HotColor:=COLORE_LISTVIEW_HOT;
  colors.GridLineColor:=COLORE_LISTVIEWS_GRIDLINES;
  Colors.BorderColor:=COLORE_LISTVIEWS_HEADERBORDER;
  onPaintHeader:=ufrmmain.ares_frmmain.listview_libPaintHeader;
 if VARS_THEMED_HEADERS then TreeOptions.PaintOptions:=[toShowVertGridLines, toHotTrack,toThemeAware]
  else TreeOptions.PaintOptions:=[toShowVertGridLines,toHotTrack];
 end;

 Grantbrowse1.visible:=(not ares_frmmain.check_opt_chat_browsable.checked); //se ha disabilitato browse mostro eccezione
 with cmd_panel do begin
  color:=COLORE_TOOLBAR_BG;
  font.name:=ares_frmmain.font.name;
  font.size:=ares_frmmain.font.size;
  font.color:=COLORE_PANELS_FONT;
 end;
 TntSplitter1.color:=COLORE_TOOLBAR_BG;
 splitter1.color:=COLORE_PANELS_BG;
{ XPbutton1.colorbg:=COLORE_TOOLBAR_BG;
 XPButton1.color:=COLORE_TOOLBAR_BG;
 XPbutton2.colorbg:=COLORE_TOOLBAR_BG;
 XPButton2.color:=COLORE_TOOLBAR_BG;
 XPbutton3.colorbg:=COLORE_TOOLBAR_BG;
 XPButton3.color:=COLORE_TOOLBAR_BG;
 XPbutton4.colorbg:=COLORE_TOOLBAR_BG;
 XPButton4.color:=COLORE_TOOLBAR_BG;
 XPbutton5.colorbg:=COLORE_TOOLBAR_BG;
 XPButton5.color:=COLORE_TOOLBAR_BG;
 XPbutton6.colorbg:=COLORE_TOOLBAR_BG;
 XPButton6.color:=COLORE_TOOLBAR_BG;
 btn_toggle_transfer.colorbg:=COLORE_TOOLBAR_BG;
 btn_toggle_transfer.color:=COLORE_TOOLBAR_BG;
 btn_menu_transfer.colorbg:=COLORE_TOOLBAR_BG;
 btn_menu_transfer.color:=COLORE_TOOLBAR_BG; }

 // setforegroundwindow(self.handle);

 listview1.height:=0;
 splitter1.height:=0;

try
prendi_posizione_header_listview;
except
end;


 
 
end;

procedure TFrmPvt.addFrameSkin;
var
 style:integer;
begin

self.isMaximised:=false;
self.borderstyle:=bsNone;
self.oldtop:=self.Top;
self.oldheight:=self.height;
self.oldleft:=self.left;
self.oldwidth:=self.width;

WindowState:=wsNormal;
borderstyle:=bsnone;

 style:=GetWindowLong(self.Handle,GWL_STYLE);
 style:=style or WS_SYSMENU or WS_SIZEBOX or WS_MINIMIZEBOX;
 SetWindowLong(self.Handle,GWL_STYLE,style);

 helper_skin.AddCustomSysMenu(self);
 enableSysMenus;

 
end;


procedure tfrmpvt.salva_posizione_splitter_browse;
var
reg:tregistry;
begin
if panel_left=nil then exit;

if panel_left.width<50 then exit else
if panel_left.width>500 then exit;
 if not Comettree1.selectable then exit;

reg:=tregistry.create;
with reg do begin
 openkey(areskey+chr(98)+chr(111)+chr(117)+chr(110)+chr(100)+chr(115),true);   //bounds
 writeinteger('PM.BrowseWidth',panel_left.width);
 closekey;
 destroy;
end;

end;

procedure tfrmpvt.attiva_reader;  //da form show quando voglio chattare o da thread_client in caso di proxy
begin
try
if reader<>nil then exit;

  testo.Font.Name:=vars_global.font_chat.name;
  testo.Font.size:=vars_global.font_chat.size; //prima che reader scriva prima linea!
  testo.streammode:=[smSelection,smPlainRTF];

  caption:=utf8strtowidestr(strip_at_reverse(nick))+' - '+GetLangStringW(STR_CHAT);

 reader:=tthread_private_chat.create(true);
  reader.socket:=nil;  //siamo entrati senza socket, per connetterci noi....
  reader.Ip:=remoteIp;
  reader.port:=remotePort;
  reader.port_server:=RemotePort_server;
  reader.ip_server:=RemoteIP_server;
  reader.ip_alt:=RemoteIP_alt;
  reader.remnick:=ipint_to_dotstring(remoteIP);
  reader.mynick:=vars_global.mynick;
  reader.form:=self;
  reader.accepted:=false;  //connettiamo noi
  reader.resume;
  
except
end;
end;


procedure Tfrmpvt.FormCreate(Sender: TObject);
var
reg:tregistry;
begin
fbrowseActivated:=false;

doubleBuffered:=true;

readyToBrowse:=false;

RemoteIP_alt:=0;
RemotePort:=0;
RemotePort_server:=0;
RemoteIP_server:=0;

FrameRgn:=0;
FMinDown:=false;
FMaxDown:=false;
FCloseDown:=false;
isMaximised:=false;



browseContainerPanel:=nil;
treeview1:=nil;
Comettree1:=nil;
splitter2:=nil;
tasto_regular_view:=nil;
tasto_virtual_view:=nil;
treeview2:=nil;
panel_left:=nil;


    input.font.name:=vars_global.font_chat.name; //assegniamo font corrwetta
    input.font.size:=vars_global.font_chat.size;
    testo.font.name:=vars_global.font_chat.name;
   testo.font.size:=vars_global.font_chat.size;

lista_files_utente:=tmylist.create;

should_browse:=false;
should_send_grantbrowse:=false;//garantiamo a qualcuno browse?
reader:=nil;
 fillchar(guid_browse,16,0);
 
outtext:=tmystringlist.create;
lista_file:=tmylist.create;

wantclose:=false; // per far chiudere form dopo thread...

reg:=tregistry.create;
with reg do begin
 openkey(areskey,true);
if valueexists('GUI.PMTranViewHeight') then
 default_transfer_height:=readinteger('GUI.PMTranViewHeight')
 else default_transfer_height:=100;
 closekey;
 destroy;
end;

if default_transfer_height<40 then default_transfer_height:=40;


if helper_skin.skinnedFrameLoaded then begin
 addFrameSkin;
// dragacceptfiles(self.handle,true);
 formresize(nil);
end;// else dragacceptfiles(self.handle,true);

end;

procedure Tfrmpvt.WMSysCommand(var Msg:TWMSyscommand);
var
shouldRevertMaximise:boolean;
begin

case msg.CmdType of
 SC_MYMINIMIZE:msg.CmdType:=SC_MINIMIZE;
 SC_MYMAXIMIZE:msg.CmdType:=SC_MAXIMIZE;
 SC_MYRESTORE:msg.CmdType:=SC_RESTORE;
 SC_MYCLOSE:msg.CmdType:=SC_CLOSE;
end;


 case msg.CmdType and ($FFF0) of

  SC_MINIMIZE:begin
   ShowWindow(handle,SW_MINIMIZE);
   msg.result:=0;
   enableSysMenus;
  end;

  SC_RESTORE:begin
      shouldRevertMaximise:=(not isIconic(handle));

       ShowWindow(Handle, SW_RESTORE);
         if (helper_skin.SkinnedFrameLoaded) and (isMaximised) and (shouldRevertMaximise) then begin
          isMaximised:=false;

         setWindowPos(self.handle,0,
                       oldleft,oldtop,
                       oldwidth,oldheight,
                       SWP_NOZORDER);
         end else
         if (helper_skin.SkinnedFrameLoaded) and (isMaximised) then begin
          isMaximised:=false;
          ufrmmain.MaximiseForm(self);
          isMaximised:=true;
         end;
    if shouldRevertMaximise then isMaximised:=false;
    enableSysMenus;
  msg.result:=0;
 end;

 SC_MAXIMIZE:begin
   if helper_skin.SkinnedFrameLoaded then begin
     if not isMaximised then begin

      oldwidth:=self.width;
      oldheight:=self.height;
      oldleft:=self.left;
      oldtop:=self.top;
      ufrmmain.MaximiseForm(self);
      isMaximised:=true;

     end else begin
     // if isIconic(handle) then
      PostMessage(self.handle,WM_SYSCOMMAND,SC_RESTORE,0);
     end;
   end else ShowWindow(Handle, SW_MAXIMIZE);
   enableSysMenus;
   msg.result:=0;
 end;

  else inherited;
 end;
end;

procedure Tfrmpvt.enableSysMenus;
var
 sysMenu:THandle;
begin
if not helper_skin.SkinnedFrameLoaded then exit;

sysMenu:=GetSystemMenu(Handle, False);

 SetMenuGrayedState(sysmenu,SC_MYRESTORE,(self.isMaximised) or (isIconic(handle)) or (isIconic(application.handle)));
 SetMenuGrayedState(sysmenu,SC_MYMAXIMIZE,(not self.isMaximised) and not ((isIconic(self.handle)) or (isIconic(application.handle))) );
 SetMenuGrayedState(sysmenu,SC_MYMINIMIZE,not isIconic(self.handle));
end;

procedure Tfrmpvt.FormClose(Sender: TObject; var Action: TCloseAction);
var
pfile:precord_file_chat_send;
begin

showwindow(self.handle,SW_HIDE);
//DragAcceptFiles(self.handle,false);


outtext.free;

salva_bounds_finestra;

clear_lista_files_utente;
lista_files_utente.free;

salva_posizione_splitter_browse;

while (lista_file.count>0) do begin
 pfile:=lista_file[lista_file.count-1];
 with pfile^ do begin
  filenameA:='';
  tipoW:='';
  folderA:='';
 end;
 lista_file.delete(lista_file.count-1);
  FreeMem(pfile,sizeof(record_file_chat_send));
end;
lista_file.free;

 try
 salva_posizioni_header_listview;
 except
 end;
 
 if treeview1<>nil then begin
   treeview1.clear;
   treeview2.clear;
   comettree1.clear;
 end;

 if vars_global.numero_pvt_open>0 then dec(vars_global.numero_pvt_open);

 
 tabview.DeletePanel(0,false);
 tabview.DeletePanel(0,false);

 if browseContainerPanel<>nil then browseContainerPanel.free;

  action:=cafree;
end;

procedure Tfrmpvt.Setmeaway1Click(Sender: TObject);
begin
ares_FrmMain.Check_opt_chat_isaway.checked:=true;
ufrmmain.ares_FrmMain.Check_opt_chat_isawayClick(nil);
end;

procedure Tfrmpvt.Blockthishost1Click(Sender: TObject);
var
reg:tregistry;
strtime,indiriz:string;
begin
indiriz:=ipint_to_dotstring(remoteIP);

// inserisci in lista ban reg...
reg:=tregistry.create;
with reg do begin
 openkey(areskey+'banned',true);

   writestring(indiriz,'');
   if remoteip_alt<>0 then writestring(ipint_to_dotstring(remoteip_alt),'');

 closekey;
 destroy;
end;

      if ares_frmmain.Check_opt_chat_time.checked then strtime:=formatdatetime('hh:nn:ss',now)+' '
       else strtime:='';

        out_memo(testo, '',strtime+nick+' ('+indiriz+') '+GetLangStringA(STR_BANNED_HINT),false);

end;


procedure Tfrmpvt.SelectAll1Click(Sender: TObject);
begin
testo.SelectAll;
end;

procedure Tfrmpvt.Copytoclipboard1Click(Sender: TObject);
begin
testo.CopyToClipboard;
end;

procedure Tfrmpvt.openinnotepad2Click(Sender: TObject);
var
i:integer;
stream:thandlestream;
str:string;
nomefile:widestring;
buffer:array[0..1023] of char;
begin

       tntwindows.Tnt_createdirectoryW(pwidechar(data_path+'\Temp'),nil);

      nomefile:=formatdatetime('mm-dd-yyyy hh.nn.ss',now)+' chat temp.txt';


      stream:=MyFileOpen(data_path+'\Temp\'+nomefile,ARES_CREATE_ALWAYSAND_WRITETHROUGH);
      if stream=nil then exit;

        for i:=0 to testo.lines.count-1 do begin
         str:=widestrtoutf8str(testo.lines.strings[i])+CRLF;
          move(str[1],buffer,length(str));
          stream.write(buffer,length(str));
        end;

       FreeHandleStream(stream);
     Tnt_ShellExecuteW(handle,'open',pwidechar(widestring('notepad')),pwidechar(data_path+'\Temp\'+nomefile),nil,SW_SHOW);
       
end;

procedure Tfrmpvt.Browseusersfile1Click(Sender: TObject);
begin
browse_type:=0;
attiva_browse;
end;

procedure tfrmpvt.attiva_browse;
var
nodo:pCmtVnode;
data:precord_file_library;
i:integer;
begin

browsed_bytes:=0;
browse_files_totali_utente:=0;

   fillchar(guid_browse,16,0);
   cocreateguid(guid_browse);
    setlength(guid_browsestr,16);
    move(guid_browse,guid_browsestr[1],16);

    set_regstring('GUI.LastPMBrowse','');

if browseContainerPanel=nil then crea_visual_browse else begin
  try
   Comettree1.Clear;

   panel_left.width:=0;
   splitter2.width:=0;
   treeview1.clear;
   treeview2.clear;
   treeview1.visible:=true;
   treeview2.visible:=false;
   tasto_virtual_view.down:=true;
   tasto_regular_view.down:=false;//di default
  except
  end;
end;

  with comettree1 do begin
   for i:=0 to 9 do header.columns[i].width:=0;
   header.columns[10].width:=clientwidth;
   canbgcolor:=false;
   selectable:=false;
  end;

clear_lista_files_utente;

     stato_header_library:=library_header_browse_in_prog;

 nodo:=Comettree1.addchild(nil);
   data:=Comettree1.getdata(nodo);
   data^.title:=GetLangStringA(STR_BROWSEINPROGRESS)+' '+GetLangStringA(STR_PLEASE_WAIT);

should_browse:=true;
 tabview.activePage:=1;

end;

procedure tfrmpvt.tasto_regular_viewclick(Sender: TObject);
var
nodo:pCmtVnode;
begin

  tasto_regular_view.down:=true;
  tasto_virtual_view.down:=false;

  treeview2.visible:=true;
  treeview1.visible:=false;

   if treeview2.getfirstselected=nil then begin //nel caso mostra general
    nodo:=treeview2.GetFirst;
    treeview2.selected[nodo]:=true;
    TreeView2Click(treeview2);
   end else TreeView2Click(treeview2);


end;

procedure tfrmpvt.tasto_virtual_viewclick(Sender: TObject);
var
nodo:pCmtVnode;
begin

  tasto_regular_view.down:=false;
  tasto_virtual_view.down:=true;
  treeview1.visible:=true;
  treeview2.visible:=false;


   if treeview1.getfirstselected=nil then begin //nel caso mostra general
    nodo:=treeview1.GetFirst;
    treeview1.selected[nodo]:=true;
    TreeView1Click(treeview1);
   end else TreeView1Click(treeview1);

end;

procedure tfrmpvt.panel_left_resize(sender:tobject);
var
panel_left:tcomettopicpnl;
begin
try
if treeview1=nil then exit;

panel_left:=(sender as tcomettopicpnl);

 treeview1.width:=panel_left.clientwidth;
 treeview2.width:=treeview1.width;
 treeview1.height:=panel_left.clientheight-26;
 treeview2.height:=treeview1.height;

 if panel_left.width>0 then default_panel_left_width:=panel_left.width;//per riapertura prox
except
exit;
end;
end;

procedure tfrmpvt.crea_visual_browse;
var
NewColumn:TvirtualtreeColumn;
i:integer;
begin
try
browseContainerPanel:=TCometTopicPnl.create(self);
browseContainerPanel.caption:='';
browseContainerPanel.bevelouter:=bvNone;
browseContainerPanel.color:=COLORE_PANELS_BG;
tabview.AddPanel(IdxBtnLibrary,GetLangStringW(STR_LIBRARY),[],browseContainerPanel,nil,false,-1);

  //qui mettiamo due panel, uno generale per tenere lontano listview4, l'altro per tenere lontanto treeview1(e ospitare il bottone per change view),
  //poi mettiamo sotto altra treeview2(per normal folder)

  panel_left:=tcomettopicpnl.create(browseContainerPanel);
   with panel_left do begin
    parent:=browseContainerPanel;
    Left:=0;
    Top:=0;
    Width:=0;//partiamo senza dimensione, ci 'allarga' thread_reader on end browse
    Height:=154;
    Align:=alLeft;
    borderstyle:=bsnone;
    bevelinner:=bvnone{bvraised};
    bevelouter:=bvnone{bvlowered};
    autosize:=false;
    bevelwidth:=1;
    color:=COLORE_TOOLBAR_BG;
    parentfont:=false;
    font.name:=ares_frmmain.font.name;
    font.size:=Ares_frmmain.font.size;
    font.color:=COLORE_PANELS_FONT;
    onresize:=panel_left_resize;
    onpaint:=ufrmmain.ares_FrmMain.panel_playlistPaint;
   end;
    //per prox apertura

   tasto_virtual_view:=txpbutton.create(panel_left);
    with tasto_virtual_view do begin
     parent:=panel_left;
     left:=5;
     top:=2;
     width:=68;
     height:=21;
     textleft:=6;
     texttop:=4;
     font.color:=COLORE_PANELS_FONT;
     colorbg:=COLORE_TOOLBAR_BG;
     color:=COLORE_TOOLBAR_BG;
     caption:=GetLangStringA(STR_VIRTUAL_VIEW);
     hint:=caption;
     showhint:=true;
     onclick:=tasto_virtual_viewclick;
     visible:=true;
     OnXPButtonDraw:=ufrmmain.ares_FrmMain.btn_tab_webXPButtonDraw;
     down:=true;//di default si mostra prima questo
    end;

   tasto_regular_view:=txpbutton.create(panel_left);
    with tasto_regular_view do begin
     parent:=panel_left;
     left:=tasto_virtual_view.left+tasto_virtual_view.width+5;
     top:=2;
     width:=68;
     height:=21;
     textleft:=6;
     texttop:=4;
     font.color:=COLORE_PANELS_FONT;
     colorbg:=COLORE_TOOLBAR_BG;
     color:=COLORE_TOOLBAR_BG;
     caption:=GetLangStringA(STR_REGULAR_VIEW);
     hint:=caption;
     showhint:=true;
     onclick:=tasto_regular_viewclick;
     OnXPButtonDraw:=ufrmmain.ares_FrmMain.btn_tab_webXPButtonDraw;
     visible:=false;
    end;

  treeview1:=tcomettree.create(panel_left);
  with treeview1 do begin
   parent:=panel_left;
   Width:=0;
   Height:=154;
   left:=0;//-10;
   top:=26;
   Align:=alnone;
   BiDiMode:=bdLeftToRight;
   BevelEdges:=[];
   BevelInner:=bvraised;
   BevelOuter:=bvlowered;
   BevelKind:=bkFlat;
   BGColor:=COLORE_ALTERNATE_ROW;
   colors.HotColor:=COLORE_LISTVIEW_HOT;
   color:=COLORE_LISTVIEWS_BG;
   Colors.GridLineColor:=COLORE_LISTVIEWS_GRIDLINES;
   Colors.TreeLineColor:=COLORE_LISTVIEWS_TREELINES;
   BorderStyle:=bsNone;
   CanBgColor:=False;
   Ctl3D:=True;
   Font.Charset:=DEFAULT_CHARSET;
   Font.name:=ares_FrmMain.font.name;
   font.color:=COLORE_LISTVIEWS_FONT;
   font.size:=ares_frmmain.font.size;
   with header do begin
    AutoSizeIndex:=0;
    Font.name:=ares_FrmMain.font.name;
    font.size:=Ares_frmmain.font.size;
    font.Color:=Ares_frmmain.font.color;
    Height:=21;
    Options:=[hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoRestrictDrag, hoShowHint, hoShowImages];
   end;
   Images:=ares_FrmMain.img_mime_small;
   ParentBiDiMode:=False;
   ParentCtl3D:=False;
   ParentFont:=False;
   ParentShowHint:=False;
   Selectable:=True;
   ShowHint:=True;
   TabOrder:=2;
   with treeoptions do begin
    AutoOptions:=[toAutoScroll];
    MiscOptions:=[toInitOnSave];
     if VARS_THEMED_HEADERS then PaintOptions:=[toShowButtons,toShowTreeLines, toThemeAware]
      else PaintOptions:=[toShowButtons,toShowTreeLines];
    SelectionOptions:=[toExtendedFocus,  toMiddleClickSelect, toRightClickSelect];
    StringOptions:=[];
   end;
   OnClick:=treeview1Click;
   OnCompareNodes:=ufrmmain.ares_FrmMain.treeviewbrowseCompareNodes;
   OnFreeNode:=ufrmmain.ares_FrmMain.treeviewbrowseFreeNode;
   OnGetText:=ufrmmain.ares_FrmMain.treeviewbrowseGetText;
   OnGetImageIndex:=ufrmmain.ares_FrmMain.treeviewbrowseGetImageIndex;
   OnGetSize:=ufrmmain.ares_FrmMain.treeviewbrowsegetSize;
   OnKeyUp:=ufrmmain.ares_FrmMain.treeviewbrowseKeyUp;
   OnMouseUp:=treeview1MouseUp;
   defaulttext:=' ';
  end;

   NewColumn :=treeview1.header.Columns.Add;
   with newcolumn do begin
    options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coVisible];
    width:=0;
    Position:=0;
    spacing:=0;
    margin:=0;
   end;

    //ora regular folder
  treeview2:=tcomettree.create(panel_left);
  with treeview2 do begin
   parent:=panel_left;
   Width:=0;
   Height:=154;
   left:=0;//-10;
   top:=26;
   Align:=alnone;
   BiDiMode:=bdLeftToRight;
   BevelEdges:=[];
   BevelInner:=bvraised;
   BevelOuter:=bvlowered;
   BevelKind:=bkFlat;
   BGColor:=COLORE_ALTERNATE_ROW;
   colors.HotColor:=COLORE_LISTVIEW_HOT;
   color:=COLORE_LISTVIEWS_BG;
   Colors.GridLineColor:=COLORE_LISTVIEWS_GRIDLINES;
   Colors.TreeLineColor:=COLORE_LISTVIEWS_TREELINES;
   Colors.BorderColor:=COLORE_LISTVIEWS_HEADERBORDER;
   BorderStyle:=bsNone;
   CanBgColor:=False;
   Ctl3D:=True ;
   Font.Charset:=DEFAULT_CHARSET;
   Font.name:=ares_FrmMain.font.name;
   font.Size:=Ares_frmmain.font.size;
   font.color:=COLORE_LISTVIEWS_FONT;
   with header do begin
    AutoSizeIndex:=0;
    Font.name:=ares_FrmMain.font.name;
    font.Size:=ares_frmmain.font.size;
    font.color:=Ares_frmmain.font.Color;
    Height:=21;
    Options:=[hoAutoResize, hoColumnResize, hoDrag,  hoRestrictDrag, hoShowHint, hoShowImages];
   end;
   Images:=ares_FrmMain.img_mime_small;
   ParentBiDiMode:=False;
   ParentCtl3D:=False;
   ParentFont:=False;
   ParentShowHint:=False;
   Selectable:=True;
   ShowHint:=True;
   TabOrder:=2;
   with treeoptions do begin
    AutoOptions:=[toAutoScroll];
    MiscOptions:=[toInitOnSave];
     if VARS_THEMED_HEADERS then PaintOptions:=[toShowButtons,toShowTreeLines, toThemeAware]
      else PaintOptions:=[toShowButtons,toShowTreeLines];
    SelectionOptions:=[toExtendedFocus,  toMiddleClickSelect, toRightClickSelect];
    StringOptions:=[];
   end;
   OnCompareNodes:=ufrmmain.ares_FrmMain.treeview_lib_regfoldersCompareNodes;
   OnFreeNode:=ufrmmain.ares_FrmMain.treeview_lib_regfoldersFreeNode;
   OnGetText:=ufrmmain.ares_FrmMain.treeview_lib_regfoldersGetText;
   OnGetImageIndex:=ufrmmain.ares_FrmMain.treeview_lib_regfoldersGetImageIndex;
   OnGetSize:=ufrmmain.ares_FrmMain.treeview_lib_regfoldersgetSize;
   OnMouseUp:=treeview2MouseUp;
   OnClick:=treeview2Click;
   defaulttext:=' ';
   visible:=false;
  end;

   NewColumn :=treeview2.header.Columns.Add;
   with newcolumn do begin
    options:=[coAllowClick,coEnabled,coDraggable,coParentBidiMode,coResizable,coShowDropMark,coVisible];
    width:=0;
    Position:=0;
    spacing:=0;
    margin:=0;
   end;
 ///////////////////////////////////////////////////////



   splitter2:=tsplitter.create(browseContainerPanel);
    with splitter2 do begin
         parent:=browseContainerPanel;
         Left:=panel_left.width+1;
         align:=alleft;
         color:=COLORE_LISTVIEWS_BG;
         width:=0;  //si parte invisibili
         beveled:=false;
         autosnap:=true;
         Top:=ares_frmmain.btns_library.top;
         Height:=154;
         cursor:=crhsplit;
    end;

    
    CometTree1:=TcometTree.create(browseContainerPanel);
    with CometTree1 do begin
          parent:=browseContainerPanel;
          Left:=panel_left.width+splitter2.width;
          Align:=alClient;
          BiDiMode:=bdLeftToRight;
          BevelEdges:=[];
          BevelInner:=bvraised;
          BevelOuter:=bvlowered;
          BevelKind:=bkFlat;
          BGColor:=COLORE_ALTERNATE_ROW;
          colors.HotColor:=COLORE_LISTVIEW_HOT;
          color:=COLORE_LISTVIEWS_BG;
          Colors.GridLineColor:=COLORE_LISTVIEWS_GRIDLINES;
          Colors.TreeLineColor:=COLORE_LISTVIEWS_TREELINES;
          Colors.BorderColor:=COLORE_LISTVIEWS_HEADERBORDER;
          BorderStyle:=bsNone;
          CanBgColor:=False;
          Ctl3D:=True;
          font.name:=ares_FrmMain.font.name;
          font.size:=ares_frmmain.font.size;
          font.color:=COLORE_LISTVIEWS_FONT;
          with header do begin
           background:=COLORE_LISTVIEWS_HEADERBK;
           AutoSizeIndex:=0;
           Font.name:=ares_FrmMain.font.name;
           font.color:=COLORE_LISTVIEWS_HEADERFONT;
           font.size:=ares_frmmain.font.size;
           Height:=21;
           Options:=[hoAutoResize, hoColumnResize, hoDrag, hoHotTrack, hoRestrictDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible];
           Style:=hsFlatButtons;
          end;
          Images:=ares_FrmMain.img_mime_small;
          ParentBiDiMode:=False;
          ParentCtl3D:=False;
          ParentShowHint:=False;
          Selectable:=True;
          ShowHint:=True;
          TabOrder:=0;
          with treeoptions do begin
           AutoOptions:=[];
           MiscOptions:=[toInitOnSave, toToggleOnDblClick];
            if VARS_THEMED_HEADERS then PaintOptions:=[toShowButtons,toHotTrack, toThemeAware]
             else PaintOptions:=[toShowButtons, toHotTrack];
           SelectionOptions:=[toExtendedFocus, toFullRowSelect, toMiddleClickSelect, toMultiSelect, toCenterScrollIntoView, toRightClickSelect];
           StringOptions:=[];
          end;
          OnClick:=CometTree1Click;
          onPaintHeader:=ufrmmain.ares_frmmain.listview_libPaintHeader;
          OnCompareNodes:=CometTree1CompareNodes;
          OnDblClick:=NetworkDownload1Click;
          OnFreeNode:=ufrmmain.ares_FrmMain.CometTreebrowseFreeNode;
          OnGetText:=CometTree1GetText;
          OnPaintText:=ufrmmain.ares_FrmMain.CometTreebrowsePaintText;
          OnGetImageIndex:=ufrmmain.ares_FrmMain.CometTreebrowseGetImageIndex;
          OnGetSize:=ufrmmain.ares_FrmMain.listview_libgetSize;
          OnHeaderClick:=ufrmmain.ares_FrmMain.TreeviewHeaderClick;
          OnMouseUp:=CometTree1MouseUp;
          DefaultText:=' ';
          end;


         for i:=0 to 9 do begin
           NewColumn :=CometTree1.header.Columns.Add;
           with newcolumn do begin
            MinWidth:=0;
            width:=0;
            Position:=i;
            spacing:=0;
            margin:=4;
            text:='';
           end;
         end;

          NewColumn :=CometTree1.header.Columns.Add;
           with newcolumn do begin
            Options:=[coEnabled, coResizable, coVisible];
            MinWidth:=0;
            Position:=10;
            spacing:=0;
            margin:=4;
            maxwidth:=10000;
            width:=CometTree1.clientwidth-4;
           end;



except
end;
end;

procedure tfrmpvt.clear_lista_files_utente;
var
pfile:precord_file_library;
begin

while (lista_files_utente.count>0) do begin
  pfile:=lista_files_utente[0];
  finalize_file_library_item(pfile);
    lista_files_utente.delete(0);
   FreeMem(pfile,sizeof(record_file_library));
 end;

 
end;

procedure Tfrmpvt.Connecttohost1Click(Sender: TObject);
begin
if reader<>nil then exit;

socket:=nil;

attiva_reader;
end;

procedure Tfrmpvt.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
try

if reader<>nil then begin
 wantclose:=true;

 canclose:=false;
  visible:=false;  //almeno utente non s'incazza
  showwindow(self.handle,SW_HIDE);

  reader.terminate;
end else canclose:=true;
except
end;
end;

procedure tfrmpvt.trigger_sendinput;
var
str:string;
texts:widestring;
begin
try

if not ISconnected then exit;
if input.text='' then exit;


texts:=convert_command_color_str(input.text);
str:=widestrtoutf8str(texts);

while (length(str)>0) do begin
 if mynick='' then mynick:=GetLangStringA(STR_YOU);

 outtext.add(copy(str,1,500));
 out_memo(testo,mynick,copy(str,1,500),false);

 delete(str,1,500);
end;

input.text:='';
     
except
end;
end;

procedure Tfrmpvt.ListView1CustomDrawSubItem(Sender: TCustomListView;Item: TListItem; SubItem: Integer; State: TCustomDrawState;var DefaultDraw: Boolean);
var
 r:trect;
 listview:tlistview;
begin
if subitem<>3 then begin
 defaultdraw:=true;
 exit;
end;

defaultdraw:=false;
r:=item.DisplayRect(drLabel);
listview:=sender as tlistview;
canvas.brush.color:=clyellow;
listview.Canvas.fillrect(r);

end;

procedure Tfrmpvt.Panel2Resize(Sender: TObject);
begin
testo.height:=chatcontainer.clientheight-input.height;
input.top:=testo.height;
input.width:=chatcontainer.clientwidth;
end;

procedure Tfrmpvt.FormResize(Sender: TObject);
var
 borderWi,borderHe:integer;
begin
if helper_skin.skinnedFrameLoaded then begin

 borderwi:=GetSystemMetrics(SM_CXSIZEFRAME);
 borderhe:=GetSystemMetrics(SM_CYSIZEFRAME);

 tabview.left:=fborderWidth;
 tabview.top:=fcaptionHeight;
 tabview.width:=clientwidth-(helper_skin.fborderwidth*2);
 tabview.height:=((clientheight-helper_skin.fcaptionHeight)-helper_skin.fborderHeight);

 self.FrameRgn:=CreateRoundRectRgn(BorderWi-1,BorderHe-1,
                             (self.width-BorderWi)+2, (height-BorderHe)+2,
                             helper_skin.FrameRoundCorner,helper_skin.FrameRoundCorner);//<shape type="roundRect" rect="0,0,-1,-1" size="4,4"/>

 SetWindowRgn(self.Handle, self.FrameRgn, true);


 invalidate;
end else begin
 tabview.top:=0;
 tabview.left:=0;
 tabview.width:=clientwidth;
 tabview.height:=clientheight;
end;
end;

procedure Tfrmpvt.Showtransfers1Click(Sender: TObject);
begin
btn_toggle_transfer.down:=not btn_toggle_transfer.down;

if btn_toggle_transfer.down then begin
 splitter1.height:=3;
 listview1.height:=default_transfer_height;
end else begin
 listview1.height:=0;
 splitter1.height:=0;
end;

FormResize(nil);
end;

procedure Tfrmpvt.Splitter1Moved(Sender: TObject);
begin
listview1.Height:=(chatContainer.clientheight-splitter1.top)-splitter1.height;
default_transfer_height:=listview1.height;
set_reginteger('GUI.PMTranViewHeight',default_transfer_height);
chatcontainerResize(chatcontainer);
listview1.invalidate;
end;

procedure Tfrmpvt.Send1Click(Sender: TObject);
var
filename:widestring;
begin
ares_FrmMain.opendialog1.filter:=GetLangStringW(STR_ANY_FILE)+'|*.*';
if not ares_FrmMain.opendialog1.execute then exit;

filename:=ares_FrmMain.opendialog1.filename;
send_file(widestrtoutf8str(filename),'',random($fffffe));

  bringtofront;
  showtransfers1click(nil);
end;

procedure tfrmpvt.send_file(filename:string; folder:string; randomsen:integer);
var
pfile:precord_file_chat_send;
begin


 pfile:=AllocMem(sizeof(record_file_chat_send));
 with pfile^ do begin
  filenameA:=filename;
  tipoW:=utf8strtowidestr(mediatype_to_str(extstr_to_mediatype(lowercase(extractfileext(filenameA)))));
  folderA:=folder;
  size:=gethugefilesize(utf8strtowidestr(filename));
  remaining:=-1;
  bytesprima:=0;
  progress:=0;
  speed:=0;
  stream:=nil;
  transferring:=false;
  upload:=true;
  accepted:=false;
  completed:=false;
  randomsenu:=randomsen; //assegniamo inizio serie
 end;
   lista_file.add(pfile);

end;

procedure tfrmpvt.send_folder(folder:widestring);
var
lista,lista_filez:tmystringlist;
doserror:integer;
dirinfo:tsearchrecW;
str:string;
folderpath:string;
randomsenu:integer;
begin

lista:=tmystringlist.create;
lista_filez:=tmystringlist.create;
try

folderpath:=widestrtoutf8str(extract_fpathW(folder));
///add all subfolders
lista.add(widestrtoutf8str(folder));


get_subdirs(lista,folder);

////////////////////////////////7now add our files!!!
 while (lista.count>0) do begin

    doserror:=helper_diskio.findfirstW(utf8strtowidestr(lista.strings[0])+chr(92)+chr(42)+chr(46)+chr(42){'\*.*'},FAANYFILE,dirinfo);
      while (doserror=0) do begin

            if (dirinfo.attr and FADIRECTORY)>0 then begin  //non directory contenute
             doserror:=helper_diskio.findnextW(dirinfo);
             continue;
            end;

            if ((dirinfo.name=chr(46)) or
                (dirinfo.name=chr(46)+chr(46))) then begin
                 doserror:=helper_diskio.findnextW(dirinfo);
                 continue;
            end;
         lista_filez.add(lista.strings[0]+chr(92){'\'}+widestrtoutf8str(dirinfo.name));
       doserror:=helper_diskio.findnextW(dirinfo);
      end;

  helper_diskio.findcloseW(dirinfo);
  lista.delete(0);
 end;


/////////////////////////////////////////////////no add everything
randomsenu:=random($fffffe);
while (lista_filez.count>0) do begin//extract folder child

   str:=copy(lista_filez.strings[0], length(folderpath)+1, length(lista_filez.strings[0]));
   str:=extractfiledir(str);

    send_file(lista_filez.strings[0], str, randomsenu);
 lista_filez.delete(0);
end;

except
end;
lista_fileZ.free;
lista.free;

end;

procedure Tfrmpvt.listview1GetText(Sender: TBaseCometTree; Node: pCmtVnode; Column: TColumnIndex; var CellText: WideString);
var
data:precord_file_chat_send;
str1,str2:widestring;
begin
if column<0 then exit;
celltext:=' ';

if column=3 then exit;

data:=sender.getdata(node);
case column of
 0:if data^.folderA<>'' then celltext:=utf8strtowidestr(data^.folderA)+chr(92)+extract_fnameW(utf8strtowidestr(data^.filenameA))
    else celltext:=extract_fnameW(utf8strtowidestr(data^.filenameA));
 1:celltext:=data^.tipoW; //è un widestring
 2:begin
    if data^.completed then begin
      if data^.progress>=data^.size then begin
        if data^.upload then celltext:=GetLangStringW(STR_SENT) else celltext:=GetLangStringW(STR_RECEIVED);
      end else celltext:=GetLangStringW(STR_CANCELLED);
    end else begin  //in progress
       if not data^.accepted then celltext:=GetLangStringW(STR_CONNECTING) else begin
         if data^.upload then celltext:=GetLangStringW(STR_UPLOADING) else celltext:=GetLangStringW(STR_DOWNLOADING);
       end;
    end;
  end;
 4:if ((data^.speed>0) and (not data^.completed)) then celltext:=format_speedW(data^.speed);
 5:if ((data^.speed>0) and (not data^.completed)) then celltext:=format_time(data^.remaining);
 6:begin
    if ((data^.progress<4096) and ((data^.progress>0) or (data^.size<4096))) then str1:=format_currency(data^.progress)+chr(32)+STR_BYTES+chr(32) else str1:=format_currency(data^.progress div KBYTE)+STR_KB+chr(32);
     if data^.size<4096 then str2:=chr(32)+format_currency(data^.size)+chr(32)+STR_BYTES else str2:=chr(32)+format_currency(data^.size div KBYTE)+STR_KB;
     celltext:=str1+GetLangStringW(STR_OF)+str2;
   end;
end;

end;

procedure Tfrmpvt.listview1GetSize(Sender: TBaseCometTree; var Size: Integer);
begin
size:=sizeof(record_file_chat_send);
end;

procedure Tfrmpvt.listview1AfterCellPaint(Sender: TBaseCometTree; TargetCanvas: TCanvas; Node: pCmtVnode; Column: TColumnIndex;CellRect: TRect);
var
oldcolor,oldpencolor:tcolor;
dati:precord_file_chat_send;
progress:double;
str_percent:string;
ind:integer;
colosf:tcolor;
begin
if column<>3 then exit;

dati:=listview1.getdata(node);

with targetcanvas do begin
 oldcolor:=brush.color;
 oldpencolor:=pen.color;

 if ares_frmmain.check_opt_tran_perc.checked then begin
  brush.style:=bsclear;
   progress:=dati^.progress;
   if progress>0 then begin
    progress:=progress/dati^.size;
    progress:=progress*100;
   end else progress:=0;
     str_percent:=FloatToStrF(progress, ffNumber, 18, 2);
     delete(str_percent,pos(chr(46){'.'},str_percent),length(stR_percent));
     str_percent:=str_percent+chr(37){'%'};
   if length(str_percent)=2 then begin //0..9%
    ind:=(textwidth(chr(48){'0'}+str_percent)-textwidth(str_percent)) div 2;
    TextRect(cellrect,cellrect.left+ind,cellrect.Top+2,str_percent);
    cellrect.left:=cellrect.left+(textwidth(chr(48){'0'}+str_percent)+2);
   end else begin
    TextRect(cellrect,cellrect.left,cellrect.Top+2,str_percent);
    cellrect.left:=cellrect.left+(textwidth(str_percent)+2);
   end;
 end;

       {brush.color:=$00FEFFFF;
       pen.color:=clgray;//$00FEFFFF;
       rectangle(cellrect.Left+2,cellrect.Top+1,cellrect.right-2,cellrect.Bottom-1);}
    if SETTING_3D_PROGBAR then begin
       if (node.Index mod 2)=0 then begin //level0 colorato
         colosf := listview1.BGColor;
       end else begin            //level0 non colorato
        colosf :=listview1.Color;
       end;
       draw_3d_progressframe(targetcanvas,cellrect,colosf);
    end;

    if ((dati^.completed) and (dati^.progress=dati^.size)) then begin
      brush.color:=COLOR_DL_COMPLETED;
      pen.color:=COLOR_DL_COMPLETED;
      if not SETTING_3D_PROGBAR then Targetcanvas.framerect(rect(cellrect.left+2,cellrect.Top+1,cellrect.right-2,cellrect.bottom-2));
      draw_progress_tran(Targetcanvas,cellrect,0,10000,10000,false);
    end else begin  //cancelled ? or not
       if dati^.upload then begin
        brush.color:=COLOR_PROGRESS_UP;
        pen.color:=COLOR_PROGRESS_UP;
       end else begin
        brush.color:=COLOR_PROGRESS_DOWN;
        pen.color:=COLOR_PROGRESS_DOWN;
       end;
      if not SETTING_3D_PROGBAR then Targetcanvas.framerect(rect(cellrect.left+2,cellrect.Top+1,cellrect.right-2,cellrect.bottom-2));
      draw_progress_tran(Targetcanvas,cellrect,0,dati^.progress,dati^.size,dati^.completed);
    end;

Brush.Color:=oldcolor;    // progressbar
pen.color:=oldpencolor;
end;

end;

procedure Tfrmpvt.listview1freenode(Sender: TBaseCometTree; Node: pCmtVnode);
var
data:precord_file_chat_send;
begin
data:=listview1.getdata(node);
with data^ do begin
 filenameA:='';
 tipoW:='';
 folderA:='';
end;
end;

procedure Tfrmpvt.Canceltransfer1Click(Sender: TObject);
var
node:pCmtVnode;
data:precord_file_chat_send;
begin
try

node:=listview1.getfirstselected;
while (node<>nil) do begin

 data:=listview1.getdata(node);
 if data^.num<>-1 then data^.should_stop:=true;

nodE:=listview1.getnextselected(node);
end;

except
end;
end;

procedure Tfrmpvt.Locatefile1Click(Sender: TObject);
var
node:pCmtVnode;
data:precord_file_chat_send;
begin
node:=listview1.getfirstselected;
if node=nil then exit;

data:=listview1.getdata(node);

if data^.folderA<>'' then locate_containing_folder(widestrtoutf8str(extract_fpathW(utf8strtowidestr(data^.filenameA)))+data^.folderA+'\'+widestrtoutf8str(extract_fnameW(utf8strtowidestr(data^.filenameA))))
 else locate_containing_folder(data^.filenameA);
end;

procedure tfrmpvt.prendi_posizione_header_listview;
var
reg:tregistry;
stringa:string;
elemento,i:integer;
begin
reg:=tregistry.create;
with reg do begin
try
openkey(areskey+'Columns\Transfers',true);
stringa:=readstring('PMTransfer');
if stringa='' then stringa:='150,60,60,70,60,80,90,';
for i:=0 to 6 do begin
elemento:=strtointdef(copy(stringa,1,pos(chr(44){','},stringa)-1),70);
stringa:=copy(stringa,pos(chr(44){','},stringa)+1,length(stringa));
if listview1.Header.Columns.Items[i].text<>'' then begin
if elemento<5 then elemento:=5;
listview1.Header.Columns.Items[i].width:=elemento;
end else listview1.Header.Columns.Items[i].width:=0;
end;

closekey;


//ora prendi posizioni!
openkey(areskey+'Positions\Transfers',true);
stringa:=readstring('PMTransfer');
if stringa='' then stringa:='0,1,2,3,4,5,6,';
for i:=0 to 6 do begin
elemento:=strtointdef(copy(stringa,1,pos(chr(44){','},stringa)-1),-1);
if elemento=-1 then break;
stringa:=copy(stringa,pos(chr(44){','},stringa)+1,length(stringa));
listview1.Header.Columns.Items[i].position:=elemento;
end;

closekey;

except
end;
destroy;
end;
end;

procedure tfrmpvt.salva_posizioni_header_listview;
var
reg:tregistry;
stringa:string;
i:integer;
begin
reg:=tregistry.create;
with reg do begin
try
 openkey(areskey+'Columns\Transfers\',true);
with listview1.header.columns do
stringa:=inttostr(Items[0].width)+','+
         inttostr(Items[1].width)+','+
         inttostr(Items[2].width)+','+
         inttostr(Items[3].width)+','+
         inttostr(Items[4].width)+','+
         inttostr(Items[5].width)+','+
         inttostr(Items[6].width)+',';
 writestring('PMTransfer',stringa);
 closekey;


 openkey(areskey+'Positions\Transfers',true);
 stringa:='';
 for i:=0 to 6 do stringa:=stringa+inttostr(listview1.Header.Columns.Items[i].position)+',';
 writestring('PMTransfer',stringa);
 closekey;
except
end;
destroy;
end;
end;



procedure Tfrmpvt.Openfile1Click(Sender: TObject);
var
node:pCmtVnode;
data:precord_file_chat_send;
begin
node:=listview1.getfirstselected;
if node=nil then exit;

data:=listview1.getdata(node);

if data^.folderA<>'' then player_playnew(extract_fpathW(utf8strtowidestr(data^.filenameA))+utf8strtowidestr(data^.folderA)+chr(92){'\'}+extract_fnameW(utf8strtowidestr(data^.filenameA)))
 else player_playnew(utf8strtowidestr(data^.filenameA));
end;

procedure Tfrmpvt.Clearidle1Click(Sender: TObject);
var
nodo:pCmtVnode;
data:precord_file_chat_send;
begin
try

nodo:=listview1.getfirst;
while (nodo<>nil) do begin

 data:=listview1.getdata(nodo);
  if data^.num=-1 then begin
   listview1.deletenode(nodo);
   nodo:=listview1.getfirst;
   continue;
  end;

nodo:=listview1.getnext(nodo);
end;

except
end;
end;

procedure Tfrmpvt.listview1HeaderClick(Sender: TCmtHdr; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
begin
if column=7 then exit;
sender.sortcolumn:=column;
if sender.sortdirection=sdAscending then sender.sortdirection:=sdDescending else
sender.sortdirection:=sdAscending;
listview1.Sort(nil,column,sender.sortdirection);
end;

procedure Tfrmpvt.user_grantedClick(Sender: TObject);
begin
user_granted.checked:=not user_granted.checked;
end;

procedure Tfrmpvt.Cancelall1Click(Sender: TObject);
var
node:pCmtVnode;
datao:precord_file_chat_send;
begin
try

node:=listview1.getfirst;
while (node<>nil) do begin

 datao:=listview1.getdata(node);
 if datao^.num<>-1 then datao^.should_stop:=true;

 nodE:=listview1.getnext(node);
end;

except
end;
end;

procedure Tfrmpvt.OpenExternal1Click(Sender: TObject);
var
node:pCmtVnode;
data:precord_file_chat_send;
begin
node:=listview1.getfirstselected;
if node=nil then exit;

data:=listview1.getdata(node);
if data^.folderA<>'' then open_file_external(widestrtoutf8str(extract_fpathW(utf8strtowidestr(data^.filenameA)))+data^.folderA+chr(92){'\'}+widestrtoutf8str(extract_fnameW(utf8strtowidestr(data^.filenameA))))
 else open_file_external(data^.filenameA);
end;

procedure Tfrmpvt.Audio1Click(Sender: TObject);
begin
browse_type:=ARES_MIME_MP3;
attiva_browse;
end;

procedure Tfrmpvt.Video1Click(Sender: TObject);
begin
browse_type:=ARES_MIME_VIDEO;
attiva_browse;
end;

procedure Tfrmpvt.Image1Click(Sender: TObject);
begin
browse_type:=ARES_MIME_IMAGE;
attiva_browse;
end;

procedure Tfrmpvt.Document1Click(Sender: TObject);
begin
browse_type:=ARES_MIME_DOCUMENT;
attiva_browse;
end;

procedure Tfrmpvt.Software1Click(Sender: TObject);
begin
browse_type:=ARES_MIME_SOFTWARE;
attiva_browse;
end;

procedure Tfrmpvt.listview1GetImageIndex(Sender: TBaseCometTree; Node: pCmtVnode; var ImageIndex: Integer);
  var
  data:precord_file_chat_send;
begin

      data:=sender.getdata(node);
             if ((data^.completed) and (data^.size=data^.progress)) then ImageIndex:=2 else
             if data^.completed then ImageIndex:=3
              else ImageIndex:=1;
end;

procedure Tfrmpvt.listview1CompareNodes(Sender: TBaseCometTree; Node1, Node2: pCmtVnode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
  Data2: precord_file_chat_send;
  treeview:TcometTree;
  rem1,rem2:integer;
  pro1,pro2:extended;
  text1,text2:string;
  tipo1,tipo2:byte;
begin
  Data1 := Sender.getdata(Node1);
  Data2 := Sender.getdata(Node2);
   treeview :=sender as TcometTree;

   if widestrtoutf8str(treeview.header.columns.Items[column].text)=GetLangStringA(STR_FILE) then result:=CompareText(extractfilename(Data1^.filenameA), extractfilename(Data2^.filenameA) ) else
   if widestrtoutf8str(treeview.header.columns.Items[column].text)=GetLangStringA(STR_STATUS) then begin

     if data1^.completed then begin
      if data1^.progress=data1^.size then text1:=GetLangStringA(STR_COMPLETED)
       else text1:=GetLangStringA(STR_CANCELLED);
      end else begin
      text1:=GetLangStringA(STR_UPLOADING);
     end;
     if data2^.completed then begin
      if data2^.progress=data2^.size then text2:=GetLangStringA(STR_COMPLETED)
       else text2:=GetLangStringA(STR_CANCELLED);
      end else begin
       text2:=GetLangStringA(STR_UPLOADING);
     end;
     result:=CompareText(text1, text2);

   end else
   if widestrtoutf8str(treeview.header.columns.Items[column].text)=GetLangStringA(STR_TYPE) then begin
    tipo1:=extstr_to_mediatype(lowercase(extractfileext(data1^.filenameA)));
    text1:=mediatype_to_str(tipo1);
    tipo2:=extstr_to_mediatype(lowercase(extractfileext(data2^.filenameA)));
    text2:=mediatype_to_str(tipo2);
    result:=CompareText(text1, text2);
   end else
   if widestrtoutf8str(treeview.header.columns.Items[column].text)=GetLangStringA(STR_TRANSMITTED) then result:=data1^.progress- data2^.progress else
   if widestrtoutf8str(treeview.header.columns.Items[column].text)=GetLangStringA(STR_SPEED) then result:=data1^.speed- data2^.speed else
      if widestrtoutf8str(treeview.header.columns.Items[column].text)=GetLangStringA(STR_PROGRESS) then begin
         pro1:=data1^.progress;
         pro1:=pro1/data1^.size;
         pro1:=pro1*100;
         pro2:=data2^.progress;
         pro2:=pro2/data2^.size;
         pro2:=pro2*100;
         result:=trunc(pro1-pro2);
      end else
   if widestrtoutf8str(treeview.header.columns.Items[column].text)=GetLangStringA(STR_REMAINING) then begin
   rem1:=data1^.speed;
   rem2:=data2^.speed;
   if rem1=0 then rem1:=$fffffff else rem1:=(data1^.size-data1^.progress) div rem1;
   if rem2=0 then rem2:=$fffffff else rem2:=(data2^.size-data2^.progress) div rem2;
    result:=rem1 - rem2;
   end else result:=0;
end;

procedure Tfrmpvt.inputKeyPress(Sender: TObject; var Key: Char);
begin
case integer(key) of
  13:begin
   key:=char(vk_cancel);
     trigger_sendinput;

    end;
  2:begin
    input.text:=input.text+chr(2);
    key:=char(vk_cancel);
    input.SelStart:=length(input.text);
  end;

end;
end;


procedure Tfrmpvt.CometTree1GetText(Sender: TBaseCometTree; Node: pCmtVnode; Column: TColumnIndex; var CellText: WideString);
var
  Data:precord_file_library;
  tipo_colonna:tcolumn_type;
begin
if column<0 then exit;
if column>10 then begin
 celltext:=chr(32);//' ';
 exit;
end;

tipo_colonna:=stato_header_library[column];

  Data := sender.getdata(Node);

case tipo_colonna of
 COLUMN_TITLE:CellText:=utf8strtowidestr(data^.title);
 COLUMN_ARTIST:CellText:=utf8strtowidestr(data^.artist);
 COLUMN_CATEGORY:CellText:=utf8strtowidestr(data^.category);
 COLUMN_ALBUM:CellText:=utf8strtowidestr(data^.album);
 COLUMN_SIZE:begin
               if data^.imageindex=0 then celltext:=chr(32){' '} else begin
                 if data^.fsize<4096 then CellText:=format_currency(data^.fsize)+chr(32)+STR_BYTES
                 else CellText:=format_currency(data^.fsize div 1024)+chr(32)+STR_KB;
               end;
             end;
 COLUMN_DATE:CellText:=utf8strtowidestr(data^.year);
 COLUMN_LANGUAGE:CellText:=utf8strtowidestr(data^.language);
 COLUMN_VERSION:CellText:=utf8strtowidestr(data^.album);
 COLUMN_QUALITY:if data^.param1<>0 then CellText:=inttostr(data^.param1) else CellText:=chr(32);
 COLUMN_FILETYPE:CellText:=extractfileext(data^.path);
 COLUMN_COLORS:begin
                if data^.param3=4 then CellText:=chr(49)+chr(54){'16'} else
                if data^.param3=8 then CellText:=chr(50)+chr(53)+chr(54){'256'} else
                if data^.param3=16 then CellText:=chr(54)+chr(53)+chr(75){'65K'} else
                if data^.param3<>0 then CellText:=chr(50)+chr(52)+chr(77){'24M'} else CellText:=chr(32);
               end;
 COLUMN_LENGTH:if data^.param3=0 then CellText:=chr(32) else CellText:=format_time(data^.param3);
 COLUMN_RESOLUTION:if data^.param1=0 then CellText:=chr(32) else CellText:=inttostr(data^.param1)+chr(120){'x'}+inttostr(data^.param2);
 COLUMN_FILENAME:CellText:=extract_fnameW(utf8strtowidestr(data^.path));
 COLUMN_NULL:CellText:=chr(32);
 COLUMN_YOUR_LIBRARY:CellText:=utf8strtowidestr(data^.title);
 COLUMN_MEDIATYPE:CellText:=utf8strtowidestr(data^.mediatype);
 COLUMN_FORMAT:CellText:=utf8strtowidestr(data^.vidinfo) else CellText:=chr(32);
end;
end;



procedure Tfrmpvt.CometTree1CompareNodes(Sender: TBaseCometTree; Node1, Node2: pCmtVnode; Column: TColumnIndex; var Result: Integer);
var
  Data1,
  Data2: precord_file_library;
  tipo_colonna:tcolumn_type;
begin
if column<0 then exit;

tipo_colonna:=stato_header_library[column];

  Data1 := sender.getdata(Node1);
  Data2 := sender.getdata(Node2);
  
case tipo_colonna of
 COLUMN_TITLE:result:=CompareText(Data1^.title, Data2^.title);
 COLUMN_ARTIST:result:=CompareText(Data1^.artist, Data2^.artist);
 COLUMN_CATEGORY:result:=CompareText(Data1^.category, Data2^.category);
 COLUMN_ALBUM:result:=CompareText(Data1^.album, Data2^.album);
 COLUMN_SIZE:begin
                             if ((data1.fsize-data2.fsize>GIGABYTE) or
                                (data2.fsize-data1.fsize>GIGABYTE)) then result:=(data1.fsize DIV KBYTE)-(data2.fsize DIV KBYTE)
                                else result:=data1.fsize-data2.fsize;
             end;
 COLUMN_DATE:result:=CompareText(Data1^.year, Data2^.year);
 COLUMN_LANGUAGE:result:=CompareText(Data1^.language, Data2^.language);
 COLUMN_VERSION:result:=CompareText(Data1^.album, Data2^.album);
 COLUMN_QUALITY:result:=data1^.param1-data2^.param1;
 COLUMN_COLORS:result:=data1^.param3-data2^.param3;
 COLUMN_LENGTH:result:=data1^.param3-data2^.param3;
 COLUMN_RESOLUTION:result:=data1^.param1-data2^.param1;
 COLUMN_FILENAME:result:=CompareText(extractfilename(Data1^.path), extractfilename(Data2^.path));
 COLUMN_MEDIATYPE:result:=CompareText(Data1^.mediatype, Data2^.mediatype);
 COLUMN_FORMAT:result:=comparetext(data1^.vidinfo,data2^.vidinfo);
 COLUMN_FILETYPE:result:=CompareText(lowercase(extractfileext(Data1^.path)), lowercase(extractfileext(Data2^.path)));
end;

end;

procedure Tfrmpvt.Artist1Click(Sender: TObject);
var
data:precord_file_library;
nodo:pCmtVnode;
begin
if Comettree1=nil then exit;
try
nodo:=Comettree1.getfirstselected;
if nodo=nil then exit;

data:=Comettree1.getdata(nodo);

searchpanel_setfindmore_art(data^.artist);

ares_frmmain.tabs_pageview.activepage:=IDTAB_SEARCH;
except
end;

end;

procedure Tfrmpvt.Genre1Click(Sender: TObject);
var
data:precord_file_library;
nodo:pCmtVnode;
begin
if Comettree1=nil then exit;
try
nodo:=Comettree1.getfirstselected;
if nodo=nil then exit;
data:=Comettree1.getdata(nodo);
searchpanel_setfindmore_gen(data^.category);

ares_frmmain.tabs_pageview.activepage:=IDTAB_SEARCH;
except
end;
end;

procedure Tfrmpvt.NetworkDownload1Click(Sender: TObject);
var
nodo:pCmtVnode;
data:precord_file_library;
down:tdownload;
begin
try

if Comettree1=nil then exit;


nodo:=Comettree1.GetFirstSelected;
while (nodo<>nil) do begin

 data:=Comettree1.getdata(Nodo);

 if is_in_progress_sha1(data^.hash_sha1) then begin
  messageboxW(self.handle,pwidechar(GetLangStringW(STR_TRANSFER_ALREADY_IN_PROGRESS)+CRLF+CRLF+'(  '+extract_fnameW(utf8strtowidestr(data^.path))+'  )'+CRLF+CRLF+GetLangStringW(STR_TAKE_A_LOOK_TO_TRANSFER_TAB)),pwidechar(appname+': '+GetLangStringW(STR_DUPLICATE_REQUEST)),mb_ok+MB_ICONEXCLAMATION);
  exit;
 end;

 if is_in_lib_sha1(data^.hash_sha1) then begin
  messageboxW(self.handle,pwidechar(GetLangStringW(STR_FILE_ALREADY_IN_LIBRARY)+CRLF+CRLF+GetLangStringW(STR_FILE)+': '+extract_fnameW(utf8strtowidestr(data^.path))+CRLF+GetLangStringW(STR_SIZE)+': '+format_currency(data^.fsize)+' '+STR_BYTES+CRLF+CRLF+GetLangStringW(STR_TAKE_A_LOOK_TO_YOUR_LIBRARY)),pwidechar(appname+': '+GetLangStringW(STR_DUPLICATE_FILE)),mb_ok+MB_ICONEXCLAMATION);
  exit;
 end;

 if data^.downloaded then begin
  nodo:=Comettree1.getnextselected(nodo);
  continue;
 end;

 down:=start_download(data,'');
 vars_global.lista_down_temp.add(down);

 add_source_download_browse(down);

 data^.downloaded:=true;
 Comettree1.invalidatenode(nodo);

nodo:=Comettree1.getnextselected(nodo);
end;

except
end;

end;

procedure tfrmpvt.add_this_download(pfile:precord_file_library; folder:widestring);
var
down:tdownload;
begin
 pfile^.downloaded:=true;
 pfile^.being_downloaded:=true;
 down:=start_download(pfile,folder);
  add_source_download_browse(down);
 lista_down_temp.add(down);
end;

procedure tfrmpvt.add_source_download_browse(down:tdownload);
var
risorsa:trisorsa_download;
begin
      risorsa:=trisorsa_download.create;
      with risorsa do begin
       handle_download:=cardinal(down);
       insertServer(RemoteIP_server,RemotePort_server,true);

       ip:=RemoteIP;
       porta:=RemotePort;
       ip_interno:=RemoteIP_alt;

            if pos(chr(64){'@'},self.nick)=0 then nickname:=self.nick+STR_UNKNOWNCLIENT
             else nickname:=self.nick;

           tick_attivazione:=0;
           socket:=nil;
           download:=down;
           AddVisualReference;
        end;

           down.lista_risorse.add(risorsa);
end;


procedure Tfrmpvt.CometTree1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
punto:tpoint;
datao:precord_file_library;
node:pCmtVnode;
begin
try

if (sender as tcomettree).rootnodecount=0 then exit;
if button<>mbright then exit;

 node:=(sender as tcomettree).getfirstselected;
 if node<>nil then begin
     datao:=(sender as tcomettree).getdata(node);
     FindMorefromthesame1.visible:=(datao^.amime=1);
      Artist1.visible:=(length(datao^.artist)>0);
      Genre1.visible:=(length(datao^.category)>0);
       N2.visible:=FindMorefromthesame1.visible;
 end else begin
      FindMorefromthesame1.visible:=false;
      Artist1.visible:=false;
      Genre1.visible:=false;
       N2.visible:=FindMorefromthesame1.visible;
       exit;
 end;


getcursorpos(punto);
menu_browse_file.popup(punto.x,punto.y);
except
end;
end;

procedure Tfrmpvt.treeview2Click(Sender: TObject);
var
level:integer;
node,nodo_child,nodo_file:pCmtVnode;
pfile,pfile_folder:precord_file_library;
data,data_folder:precord_cartella_share;
i:integer;
begin
if treeview2=nil then exit;

node:=treeview2.getfirstselected;
if node=nil then exit;


try
  level:=treeview2.getnodelevel(node);

  if level=0 then begin
    lockwindowupdate(self.handle);
   Comettree1.canbgcolor:=false;
   stato_header_library:=helper_visual_headers.header_library_show('PMBrowse','PMBrowse',Comettree1,'',CAT_YOUR_LIBRARY,CAT_NOGROUP);
   apri_general_library_folder_view(false,lista_files_utente,Comettree1,ares_FrmMain.imagelist_lib_max,treeview2);
    lockwindowupdate(0);
   exit;
  end;

  lockwindowupdate(self.handle);
   with comettree1 do begin
    canbgcolor:=true;
    defaultnodeheight:=18;
    images:=ares_FrmMain.img_mime_small;
    with header do begin
     height:=21;
     autosizeindex:=10;
     options:=[hoAutoResize,hoColumnResize,hoDrag,hoHotTrack,hoRestrictDrag,hoShowHint,hoShowImages,hoShowSortGlyphs,hoVisible];
     columns[0].options:=[coAllowClick,coEnabled,coDraggable,coResizable,coShowDropMark,coVisible];
    end;

    if rootnodecount>0 then begin
       BeginUpdate;
       Clear;
    end;
   end;

  stato_header_library:=header_library_show('PMBrowse','PMBrowse',Comettree1,'',CAT_ALL,CAT_NOGROUP);

  data:=treeview2.getdata(node);

     nodo_child:=treeview2.getfirstchild(node);
      while (nodo_child<>nil) do begin
         data_folder:=treeview2.getdata(nodo_child);
         nodo_file:=Comettree1.addchild(nil);
          pfile_folder:=Comettree1.getdata(nodo_file);
          pfile_folder^.mediatype:=GetLangStringA(STR_FOLDER);
          pfile_folder^.imageindex:=0;
           pfile_folder^.fsize:=0;
           pfile_folder^.title:=widestrtoutf8str(extract_fnameW(data_folder^.path));
           pfile_folder^.language:=widestrtoutf8str(data_folder^.path); //per browsare in trova_nodo_treeview2_folder

       nodo_child:=treeview2.getnextsibling(nodo_child);
      end;

   for i:=0 to lista_files_utente.count-1 do begin
    pfile:=lista_files_utente[i];
    if pfile^.folder_id<>data^.id then continue;

    library_file_show(Comettree1,pfile);
   end;

   Comettree1.EndUpdate;

   lockwindowupdate(0);
except
end;
end;

procedure Tfrmpvt.treeview1Click(Sender: TObject);
var
level:integer;
node:pCmtVnode;
begin
if treeview1=nil then exit;

node:=treeview1.getfirstselected;
if node=nil then exit;

try
  level:=treeview1.getnodelevel(node);

  if level=0 then begin
   Comettree1.canbgcolor:=false;
   stato_header_library:=helper_visual_headers.header_library_show('PMBrowse','PMBrowse',Comettree1,'',CAT_YOUR_LIBRARY,CAT_NOGROUP);
   apri_general_library_virtual_view(false,lista_files_utente,Comettree1,ares_FrmMain.imagelist_lib_max);
   exit;
  end else
  stato_header_library:=apri_categoria_library('PMBrowse','PMBrowse',treeview1,Comettree1,lista_files_utente,level,node);

except
end;
end;

procedure Tfrmpvt.CometTree1Click(Sender: TObject);
var
data:precord_file_library;
nodo,node:pCmtVnode;
begin
if sender=nil then exit;

nodo:=Comettree1.GetFirstSelected;
if nodo=nil then exit;

data:=Comettree1.getdata(nodo);

if ((data^.hash_sha1='') and (data^.path='')) then begin

  if tasto_regular_view.down then begin
    node:=trova_nodo_treeview2_folder(Comettree1,treeview2);
    if node=nil then exit;
     treeview2.Selected[node]:=true;
     treeview2.expanded[node]:=true;
     TreeView2Click(treeview2);
  end else begin
    node:=trova_nodo_treeview1_categoria(treeview1,data^.title);
    if node=nil then exit;
     treeview1.Selected[node]:=true;
     TreeView1Click(treeview1);
  end;

end;

end;

procedure Tfrmpvt.Download1Click(Sender: TObject);
var
data:ares_types.precord_string;
nodo:pCmtVnode;
level:integer;
 nodoroot,nodoall,nodoaudio,nodoimage,nodovideo,nododocument,nodosoftware,
  nodosoftwarebycompany,nodosoftwarebycategory,
  nododocumentbyauthor,nododocumentbycategory,
  nodovideobycategory,
  nodoimagebyalbum,nodoimagebycategory,
  nodoaudiobyartist,nodoaudiobyalbum,nodoaudiobygenre:pCmtVnode;
tipo:byte;
i:integer;
pfile:precord_file_library;
match,match1,match2,match3:string;
begin
// download whole virtual folder
if treeview1=nil then exit;

with treeview1 do begin
 nodo:=getfirstselected;
 if nodo=nil then exit;

 level:=getnodelevel(nodo);
 if level<>3 then exit;

 nodoroot:=GetFirst;
 nodoall:=getfirstchild(nodoroot);

 nodoaudio:=GetNextSibling(nodoall);
   nodoaudiobyartist:=getfirstchild(nodoaudio);
   nodoaudiobyalbum:=getnextsibling(nodoaudiobyartist);
   nodoaudiobygenre:=getnextsibling(nodoaudiobyalbum);
 nodoimage:=getnextsibling(nodoaudio);
   nodoimagebyalbum:=getfirstchild(nodoimage);
   nodoimagebycategory:=getnextsibling(nodoimagebyalbum);
 nodovideo:=getnextsibling(nodoimage);
   nodovideobycategory:=getfirstchild(nodovideo);
 nododocument:=getnextsibling(nodovideo);
   nododocumentbyauthor:=getfirstchild(nododocument);
   nododocumentbycategory:=getnextsibling(nododocumentbyauthor);
 nodosoftware:=getnextsibling(nododocument);
   nodosoftwarebycompany:=getfirstchild(nodosoftware);
   nodosoftwarebycategory:=getnextsibling(nodosoftwarebycompany);
end;

 if nodo.parent.parent=nodoaudio then tipo:=ARES_MIME_MP3 else
 if nodo.parent.parent=nodoimage then tipo:=ARES_MIME_IMAGE else
 if nodo.parent.parent=nodovideo then tipo:=ARES_MIME_VIDEO else
 if nodo.parent.parent=nododocument then tipo:=ARES_MIME_DOCUMENT else
 if nodo.parent.parent=nodosoftware then tipo:=ARES_MIME_SOFTWARE else exit;

 data:=treeview1.getdata(nodo);
 match:=lowercase(data^.str);
 if match=GetLangStringA(STR_UNKNOW_LOWER) then match:='';

         
 for i:=0 to lista_files_utente.count-1 do begin
  pfile:=lista_files_utente[i];
  if pfile^.amime<>tipo then continue;

        if ((nodo.parent.parent<>nodovideo) and (nodo.parent.parent<>nodoimage)) then begin
          match1:=lowercase(pfile^.artist);
          match2:=lowercase(pfile^.category);
          if nodo.parent.parent=nodoaudio then match3:=lowercase(pfile^.album);
        end else
        if nodo.parent.parent=nodovideo then begin
          match1:=lowercase(pfile^.category);
        end else
        if nodo.parent.parent=nodoimage then begin
          match1:=lowercase(pfile^.album);
          match2:=lowercase(pfile^.category);
        end;

        if match1=GetLangStringA(STR_UNKNOW_LOWER) then match1:='';
        if match2=GetLangStringA(STR_UNKNOW_LOWER) then match2:='';
        if match3=GetLangStringA(STR_UNKNOW_LOWER) then match3:='';

   case tipo of
    ARES_MIME_MP3:begin
        if nodo.parent=nodoaudiobyartist then begin
          if match1=match then add_this_download(pfile,'');
        end else
        if nodo.parent=nodoaudiobyalbum then begin
          if match3=match then add_this_download(pfile,'');
        end else
        if nodo.parent=nodoaudiobygenre then begin
          if match2=match then add_this_download(pfile,'');
        end;
      end;
    ARES_MIME_IMAGE:begin
        if nodo.parent=nodoimagebyalbum then begin
          if match1=match then add_this_download(pfile,'');
        end else
        if nodo.parent=nodoimagebycategory then begin
          if match2=match then add_this_download(pfile,'');
        end;
      end;
    ARES_MIME_VIDEO:begin
        if nodo.parent=nodovideobycategory then begin
          if match1=match then add_this_download(pfile,'');
        end;
      end;
    ARES_MIME_DOCUMENT:begin
        if nodo.parent=nododocumentbyauthor then begin
          if match1=match then add_this_download(pfile,'');
        end else
        if nodo.parent=nododocumentbycategory then begin
          if match2=match then add_this_download(pfile,'');
        end;
      end;
    ARES_MIME_SOFTWARE:begin
        if nodo.parent=nodosoftwarebycompany then begin
          if match1=match then add_this_download(pfile,'');
        end else
        if nodo.parent=nodosoftwarebycategory then begin
          if match2=match then add_this_download(pfile,'');
        end;
      end;
   end;



 end;

 treeview1click(nil);
end;


procedure Tfrmpvt.treeview2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
nodo:pCmtVnode;
level:integer;
punto:tpoint;
begin
if treeview2=nil then exit;

if treeview2.rootnodecount=0 then exit;
if button<>mbright then exit;

 nodo:=treeview2.getfirstselected;
 if nodo=nil then exit;

 level:=treeview2.getnodelevel(nodo);
 if level=0 then exit;

 getcursorpos(punto);
 menu_regfolder_download.popup(punto.x,punto.y);

end;

procedure Tfrmpvt.treeview1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
nodo:pCmtVnode;
level:integer;
punto:tpoint;
begin
if treeview1=nil then exit;

if (sender as tcomettree).rootnodecount=0 then exit;
if button<>mbright then exit;

 nodo:=(sender as tcomettree).getfirstselected;
 if nodo=nil then exit;

 level:=(sender as tcomettree).getnodelevel(nodo);
 if level<>3 then exit;

 getcursorpos(punto);
 menu_virfolder_download.popup(punto.x,punto.y);
end;

procedure Tfrmpvt.SendFolder1Click(Sender: TObject);
begin
if not ares_FrmMain.fol.execute then exit;

 send_folder(ares_FrmMain.fol.foldername);

  bringtofront;
  showtransfers1click(nil);
end;

procedure Tfrmpvt.Grantbrowse1Click(Sender: TObject);
begin
 grantbrowse1.checked:=not grantbrowse1.checked;
if grantbrowse1.checked then should_send_grantbrowse:=true;//aggiorniamo reader!
end;

procedure Tfrmpvt.ExportHashlink1Click(Sender: TObject);
var
nodo:pCmtVnode;
data:precord_file_library;
begin
try

if Comettree1=nil then exit;

nodo:=Comettree1.GetFirstSelected;
if nodo<>nil then exit;


 data:=Comettree1.getdata(Nodo);
 export_hashlink(data,false);


except
end;

end;

procedure Tfrmpvt.Download2Click(Sender: TObject);
var
nodo,nodo_child:pCmtVnode;
data:precord_cartella_share;
pfile:precord_file_library;
i,to_cut:integer;
level:cardinal;
folder:widestring;
folderstr:string;
begin

if treeview2=nil then exit;
nodo:=treeview2.getfirstselected;
if nodo=nil then exit;

  level:=treeview2.getnodelevel(nodo);
  data:=treeview2.getdata(nodo); //troviamo folders



       if length(data^.path)=3 then begin
         if data^.path[3]=chr(58){':'} then begin
          folder:=copy(data^.path,1,2)+chr(95){'_'}; //intero HD!
          to_cut:=0;
         end else begin
            folder:=chr(92){'\'}+extract_fnameW(data^.path);
            to_cut:=length(widestrtoutf8str(data^.path))-length(widestrtoutf8str(folder));  //quanti ne dobbiamo togliere dai child per comunicare a add_this_download
         end;
        end else begin
            folder:=chr(92){'\'}+extract_fnameW(data^.path);
            to_cut:=length(widestrtoutf8str(data^.path))-length(widestrtoutf8str(folder));  //quanti ne dobbiamo togliere dai child per comunicare a add_this_download
        end;

   for i:=0 to lista_files_utente.count-1 do begin    //prima tutti i files contenuti in questa cartella
    pfile:=lista_files_utente[i];
    if pfile^.folder_id<>data^.id then continue;
    add_this_download(pfile,folder);
   end;


   //ora tutti i files contenuti nei child
   nodo_child:=treeview2.getnext(nodo);
   while (nodo_child<>nil) do begin
    if treeview2.getnodelevel(nodo_child)<=level then break;  //altro nodo, non sono più in childish

       data:=treeview2.getdata(nodo_child);
        folderstr:=widestrtoutf8str(data^.path);
             if folderstr[3]=chr(58){':'} then folderstr[3]:=chr(95){'_'};

        folder:=utf8strtowidestr(copy(folderstr,to_cut+1,length(folderstr))); //copiamo includendo solo da path main!

         for i:=0 to lista_files_utente.count-1 do begin    //prima tutti i files contenuti in questa cartella
          pfile:=lista_files_utente[i];
           if pfile^.folder_id<>data^.id then continue;

          add_this_download(pfile,folder);
         end;
    nodo_child:=treeview2.getnext(nodo_child);
    end;

    

 treeview2click(nil);  //aggiorniamo

end;

procedure Tfrmpvt.Autoacceptfiles1Click(Sender: TObject);
begin
autoacceptfiles1.checked:=not autoacceptfiles1.checked;
set_reginteger('PrivateMessage.AutoAcceptFiles',integer(autoacceptfiles1.checked));
end;

procedure Tfrmpvt.testoURLClick(Sender: TObject; const URLText: String;
  Button: TMouseButton);
begin
Tnt_ShellExecuteW(0,'open',pwidechar(widestring(urltext)),'','',SW_SHOWNORMAL);
end;

procedure Tfrmpvt.XPbutton1Click(Sender: TObject);
begin
with input do begin
 text:=text+chr(2)+chr(54){'6'};
 SetFocus;
 selstart:=length(text);
 sellength:=0;
end;
end;

procedure Tfrmpvt.XPbutton2Click(Sender: TObject);
begin
with input do begin
 text:=text+chr(2)+chr(57){'9'};
 SetFocus;
 selstart:=length(text);
 sellength:=0;
end;
end;

procedure Tfrmpvt.XPbutton3Click(Sender: TObject);
begin
with input do begin
 text:=text+chr(2)+chr(55){'7'};
 SetFocus;
 selstart:=length(text);
 sellength:=0;
end;
end;

procedure Tfrmpvt.XPbutton4Click(Sender: TObject);
var
punto:tpoint;
begin
ufrmpvt.chat_buttons_wantbg:=false;
getcursorpos(punto);
dec(punto.Y,335);
dec(punto.x,5);
menu_colors.popup(punto.x,punto.y);
end;

procedure Tfrmpvt.N161DrawItem(Sender: TObject; ACanvas: TCanvas;ARect: TRect; Selected: Boolean);
 const
CONVERTER:array[1..16] of tcolor = (clblack,clmaroon,clgreen,$0080ff,clnavy,clpurple,clteal,clgray,clsilver,clred,cllime,clyellow,clblue,clfuchsia,claqua,clwhite);
  var
  ite:tmenuitem;
  colore:tcolor;
begin
ite:=sender as tmenuitem;
colore:=CONVERTER[strtointdef(ite.caption,1)];

with acanvas do begin
 brush.color:=colore;
 if selected then begin
  pen.color:=$00C080FF;
  rectangle(arect.left,arect.top,arect.Right,arect.bottom);
 end else begin
   pen.color:=colore;
   rectangle(arect.left,arect.top,arect.Right,arect.bottom);
 end;
end;
end;

procedure Tfrmpvt.N161MeasureItem(Sender: TObject; ACanvas: TCanvas;var Width, Height: Integer);
begin
width:=50;
height:=20;
end;

procedure Tfrmpvt.N161Click(Sender: TObject);
const
CONVERTER:array[1..16] of string=('01','05','03','07','02','06','10','14','15','04','09','08','12','13','11','00');
var
  ite:tmenuitem;
  str:string;
begin
ite:=sender as tmenuitem;

str:=CONVERTER[strtointdef(ite.caption,1)];

if ufrmpvt.chat_buttons_wantbg then begin
 str:=chr(53){'5'}+str;
end else begin
 str:=chr(51){'3'}+str;
end;



with input do begin
 text:=text+chr(2)+str;
 SetFocus;
 selstart:=length(text);
 sellength:=0;
end;

end;

procedure Tfrmpvt.XPbutton5Click(Sender: TObject);
var
punto:tpoint;
begin
ufrmpvt.chat_buttons_wantbg:=true;
getcursorpos(punto);
dec(punto.Y,335);
dec(punto.x,5);
menu_colors.popup(punto.x,punto.y);
end;

procedure Tfrmpvt.XPbutton6Click(Sender: TObject);
var punto:tpoint;
curredit:ttntmemo;
begin
getcursorpos(punto);
dec(punto.Y,123);
dec(punto.x,95);
curredit:=input;

with Tfrmemoticon.create(application) do begin
 top:=punto.y;
 lefT:=punto.x;
 edit:=nil;
 memo:=curredit;
 show;
end;

end;


procedure Tfrmpvt.Other1Click(Sender: TObject);
begin
browse_type:=8;
attiva_browse;
end;

procedure Tfrmpvt.TntFormPaint(Sender: TObject);
begin
if helper_skin.skinnedFrameLoaded then PaintFrame
 else inherited;
end;

procedure Tfrmpvt.chatcontainerResize(Sender: TObject);
begin
if not btn_toggle_transfer.down then begin
 self.listview1.height:=0;
 self.splitter1.height:=0;
end else begin
 self.splitter1.height:=3;
 self.listview1.height:=default_transfer_height;
end;
end;

procedure Tfrmpvt.btn_menu_transferMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
point:TPoint;
begin
getcursorpos(point);
popuptransfer.popup(point.x,point.y);
(sender as TXPButton).state:=[xpbutton.csEnabled{,xpbutton.csHover}];
end;

procedure Tfrmpvt.tabviewPanelShow(Sender, aPanel: TObject);
begin
if tabview.PanelsCount<2 then exit;

if (readyToBrowse) and (not (FBrowseActivated)) then begin
 fbrowseActivated:=true;
 attiva_Browse;
end;

end;

end.


