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

unit ufrmChatTab;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,tntforms,ares_types;

type
  TfrmChatTab = class(tTntForm)
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
  private
    FNumMissed:integer;

    procedure WMSyscommand(var msg:TWmSysCommand); message WM_SYSCOMMAND;
  protected
   procedure CreateParams(var Params:TCreateParams); override;
  public
    channel:precord_canale_chat_visual;
    pvt:precord_pvt_chat_visual;
    procedure IncMissed;
    procedure ResetMissed;
    procedure SetCaption;
  end;

var
  frmChatTab: TfrmChatTab;

implementation

{$R *.dfm}

uses
 ufrmmain,const_ares,helper_unicode,vars_localiz,vars_global;

procedure TfrmChatTab.ResetMissed;
begin

 FNumMissed:=0;

if pvt<>nil then caption:=pvt^.pnl.btncaption+' ('+GetLangStringW(STR_CHANNEL)+' '+utf8strtowidestr(pvt^.canale^.name)+')'
 else caption:=channel^.pnl.btncaption;
// windowState:=wsMinimized;
end;

procedure TFrmChatTab.incMissed;
begin
inc(FNumMissed);
if pvt<>nil then caption:='['+inttostr(FNumMissed)+'] '+pvt^.pnl.btncaption+' ('+GetLangStringW(STR_CHANNEL)+' '+utf8strtowidestr(pvt^.canale^.name)+')'
 else caption:='['+inttostr(FNumMissed)+'] '+channel^.pnl.btncaption;

 FlashWindow(self.handle,false);
// windowState:=wsMinimized;

end;

procedure TFrmChatTab.WMSyscommand(var msg:TWmSysCommand);     // WM_SYSCOMMAND
begin

case (msg.CmdType and $FFF0) of

 SC_MINIMIZE:begin
  ShowWindow(handle,SW_MINIMIZE);
  msg.result:=0;
 end;

 SC_RESTORE:begin

 if widestrtoutf8str(ares_frmmain.tray_minimize.caption)=GetLangStringA(STR_SHOW_ARES) then ufrmmain.ares_frmmain.tray_MinimizeClick(nil)
  else SetForegroundWindow(application.handle);
  
  if isIconic(ares_frmmain.handle) then ShowWindow(ares_frmmain.handle,SW_RESTORE);

 FNumMissed:=0;

 if pvt<>nil then begin
  ares_frmmain.panel_chat.ActivePanel:=pvt^.canale^.containerPageview;
  pvt^.canale^.containerPageview.ActivePanel:=pvt^.containerPanel;
  caption:=pvt^.pnl.btncaption+' ('+GetLangStringW(STR_CHANNEL)+' '+utf8strtowidestr(pvt^.canale^.name)+')';
 end else begin
  ares_frmmain.panel_chat.ActivePanel:=channel^.containerPageview;
  channel^.containerPageview.activepage:=0;
  caption:=channel^.pnl.btncaption;
 end;
  //ares_frmmain.panel_chat.resize;
  
  ares_frmmain.tabs_pageview.activePage:=IDTAB_CHAT;

  msg.result:=0;
 // defwindowproc(self.handle,msg.msg,msg.wparam,msg.lparam);
end;// else defwindowproc(self.handle,msg.msg,msg.wparam,msg.lparam);
 else inherited;
end;

end;

procedure TfrmChatTab.SetCaption;
begin

if FNumMissed>0 then begin
 if pvt<>nil then caption:='['+inttostr(FNumMissed)+'] '+pvt^.pnl.btncaption+' ('+GetLangStringW(STR_CHANNEL)+' '+utf8strtowidestr(pvt^.canale^.name)+')'
  else caption:='['+inttostr(FNumMissed)+'] '+channel^.pnl.btncaption;
end else begin
  if pvt<>nil then caption:=pvt^.pnl.btncaption+' ('+GetLangStringW(STR_CHANNEL)+' '+pvt^.canale^.name+')'
  else caption:=channel^.pnl.btncaption;
end;

end;

procedure TfrmChatTab.CreateParams(var Params:TCreateParams);
begin
inherited CreateParams(Params);
Params.ExStyle:=Params.ExStyle and not WS_EX_TOOLWINDOW or WS_EX_APPWINDOW;
end;

procedure TfrmChatTab.FormCreate(Sender: TObject);
begin
vars_global.chatTabs.add(self);

channel:=nil;
pvt:=nil;
FNumMissed:=0;
end;

procedure TfrmChatTab.FormShow(Sender: TObject);
begin
top:=10000;
end;

procedure TfrmChatTab.TntFormDestroy(Sender: TObject);
var
ind:integer;
begin
if vars_global.chatTabs=nil then exit;

ind:=vars_global.chatTabs.indexof(self);
if ind<>-1 then vars_global.chatTabs.delete(ind);
end;

procedure TfrmChatTab.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
action:=cafree;
end;

end.
