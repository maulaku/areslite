(*
     Browse For Folder component
     Delphi 2/3/4/5
     (c) 1998,2000 Ray Adams
*)
unit folderBrowse;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ShlObj;

type
 _exDataW=record
  Path:PwideChar;
  Caption:PwideChar;
  end;
 _exDataA=record
  Path:PChar;
  Caption:PChar;
  end;

 {   _browseinfoW = record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PWideChar;   Return display name of item selected.
    lpszTitle: PWideChar;       text to go in the banner over the tree.
    ulFlags: UINT;            Flags that control the return stuff
    lpfn: TFNBFFCallBack;
    lParam: LPARAM;           extra info that's passed back in callbacks
    iImage: Integer;          output var: where to return the Image index.
  end;

      _browseinfoA = record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PChar;   Return display name of item selected.
    lpszTitle: PChar;       text to go in the banner over the tree.
    ulFlags: UINT;            Flags that control the return stuff
    lpfn: TFNBFFCallBack;
    lParam: LPARAM;           extra info that's passed back in callbacks
    iImage: Integer;          output var: where to return the Image index.
  end; }

  TBrowseInfoW = _browseinfoW;
  TBrowseInfoA = _browseinfoA;
  //TBrowseInfo = TBrowseInfoW;

  TBrowseFlag = (
    bf_BrowseForComputer,
    bf_BrowseForPrinter,
    bf_DontGoBelowDomain,
    bf_statustext,
    bf_ReturnFSanceStors,
    bf_ReturnOnlyFSDIRS,
    bf_EditBox);
  TBrowseFlags = set of TBrowseFlag;

  TBrowseLocation= (
  bl_STANDART,
  bl_CUSTOM,
  bl_DESKTOP,
  bl_PROGRAMS,
  bl_CONTROLS,
  bl_PRINTERS,
  bl_PERSONAL,
  bl_FAVORITES,
  bl_STARTUP,
  bl_RECENT,
  bl_SENDTO,
  bl_BITBUCKET,
  bl_STARTMENU,
  bl_DESKTOPDIRECTORY,
  bl_DRIVES,
  bl_NETWORK,
  bl_NETHOOD,
  bl_FONTS,
  bl_TEMPLATES,
  bl_COMMON_STARTMENU,
  bl_COMMON_PROGRAMS,
  bl_COMMON_STARTUP,
  bl_COMMON_DESKTOPDIRECTORY,
  bl_APPDATA,
  bl_PRINTHOOD);

  TBrowseForFolder = class(TComponent)
  private
  FBrowseInfoA:TBrowseInfoA;
  FBrowseInfoW:TBrowseInfoW;
  FRoot:PItemIDList;
  FDisplayName:wideString;
  FStatusText:wideString;
  FFolderName:wideString;
  FORoot:TBrowseLocation;
  FCaption: wideString;
    { Private declarations }
{    procedure ReadData( Reader :TReader );
    procedure WriteData( Writer :TWriter );}
    procedure SetFlags( Value :TBrowseFlags );
    function GetFlags :TBrowseFlags;
    function GetOperFlagW( F :Cardinal ) :Boolean;
    function GetOperFlagA( F :Cardinal ) :Boolean;
    procedure SetOperFlagW( F :Cardinal; V :Boolean );
    procedure SetOperFlagA( F :Cardinal; V :Boolean );

 //   procedure SetOperFlag( F :Cardinal; V :Boolean );
    procedure SetCaption(const Value: wideString);
  protected
    { Protected declarations }
{    procedure DefineProperties( Filer :TFiler ); override;}
  public
    { Public declarations }
    _inDataA:_exDataA;
    _inDataW:_exDataW;
    constructor Create( anOwner :TComponent ); override;
    destructor Destroy; override;
    function Execute :Boolean;
    function wtostr(strin:widestring):string;
   // procedure SetRoot(Root:PItemIdList);
   // procedure SetFunction(tF:TFNBFFCallBack);
  //  procedure SetLParam(Param:LParam);
  published
    { Published declarations }
  property DisplayName:wideString read FDisplayName;
  property StatusText:wideString read FStatusText write FStatusText;
  property FolderName:wideString read FFolderName write FFolderName;
  property Flags :TBrowseFlags read GetFlags  write SetFlags stored true;
  property Root:TBrowseLocation read FoRoot write FoRoot;
  property Caption:wideString read FCaption write SetCaption;
  end;

function BrowseCallbackProcA(
    dhwnd:HWND;
    uMsg:longint;
    lParam:longint;
    lpData:longint):integer;stdcall;
function BrowseCallbackProcW(
    dhwnd:HWND;
    uMsg:longint;
    lParam:longint;
    lpData:longint):integer;stdcall;

const
  shell32 = 'shell32.dll';

procedure Register;
{$EXTERNALSYM SHBrowseForFolderW}
function SHBrowseForFolderW(var lpbi: TBrowseInfoW): PItemIDList; stdcall;
{$EXTERNALSYM SHBrowseForFolder}
function SHBrowseForFolder(var lpbi: TBrowseInfo): PItemIDList; stdcall;

implementation

function SHBrowseForFolderW;          external shell32 name 'SHBrowseForFolderW';
function SHBrowseForFolder;          external shell32 name 'SHBrowseForFolderW';

constructor TBrowseForFolder.Create( anOwner :TComponent );
begin
 inherited Create( anOwner );
  FFolderName:='C:\';
 FStatusText:='Please select folder';
 FCaption:='Select Folder';
end;

destructor TBrowseForFolder.Destroy;
begin
 inherited Destroy;
end;

function TBrowseForFolder.Execute;
var iGetRoot,Res:PItemIDList;
    sTempW:PWideChar;
    stempa:pchar;
begin
FBrowseInfoW.hwndOwner:=0;
FBrowseInfoA.hwndOwner:=0;
case foRoot of
  bl_CUSTOM:iGetRoot:=FRoot;
  bl_DESKTOP:shGetSpecialFolderLocation(0,CSIDL_DESKTOP ,iGetRoot);
  bl_PROGRAMS:shGetSpecialFolderLocation(0,CSIDL_PROGRAMS ,iGetRoot);
  bl_CONTROLS:shGetSpecialFolderLocation(0,CSIDL_CONTROLS ,iGetRoot);
  bl_PRINTERS:shGetSpecialFolderLocation(0,CSIDL_PRINTERS ,iGetRoot);
  bl_PERSONAL:shGetSpecialFolderLocation(0,CSIDL_PERSONAL ,iGetRoot);
  bl_FAVORITES:shGetSpecialFolderLocation(0,CSIDL_FAVORITES ,iGetRoot);
  bl_STARTUP:shGetSpecialFolderLocation(0,CSIDL_STARTUP ,iGetRoot);
  bl_RECENT:shGetSpecialFolderLocation(0,CSIDL_RECENT ,iGetRoot);
  bl_SENDTO:shGetSpecialFolderLocation(0,CSIDL_SENDTO ,iGetRoot);
  bl_BITBUCKET:shGetSpecialFolderLocation(0,CSIDL_BITBUCKET ,iGetRoot);
  bl_STARTMENU:shGetSpecialFolderLocation(0,CSIDL_STARTMENU ,iGetRoot);
  bl_DESKTOPDIRECTORY:shGetSpecialFolderLocation(0,CSIDL_DESKTOPDIRECTORY ,iGetRoot);
  bl_DRIVES:shGetSpecialFolderLocation(0,CSIDL_DRIVES ,iGetRoot);
  bl_NETWORK:shGetSpecialFolderLocation(0,CSIDL_NETWORK ,iGetRoot);
  bl_NETHOOD:shGetSpecialFolderLocation(0,CSIDL_NETHOOD ,iGetRoot);
  bl_FONTS:shGetSpecialFolderLocation(0,CSIDL_FONTS ,iGetRoot);
  bl_TEMPLATES:shGetSpecialFolderLocation(0,CSIDL_TEMPLATES ,iGetRoot);
  bl_COMMON_STARTMENU:shGetSpecialFolderLocation(0,CSIDL_COMMON_STARTMENU ,iGetRoot);
  bl_COMMON_PROGRAMS:shGetSpecialFolderLocation(0,CSIDL_COMMON_PROGRAMS ,iGetRoot);
  bl_COMMON_STARTUP:shGetSpecialFolderLocation(0,CSIDL_COMMON_STARTUP ,iGetRoot);
  bl_COMMON_DESKTOPDIRECTORY:shGetSpecialFolderLocation(0,CSIDL_COMMON_DESKTOPDIRECTORY ,iGetRoot);
  bl_APPDATA:shGetSpecialFolderLocation(0,CSIDL_APPDATA ,iGetRoot);
  bl_PRINTHOOD:shGetSpecialFolderLocation(0,CSIDL_PRINTHOOD ,iGetRoot);
end;


if Win32Platform=VER_PLATFORM_WIN32_NT then begin

if  foRoot<>bl_STANDART then FBrowseInfoW.pidlRoot:=iGetRoot;
FBrowseInfoW.lpszTitle:=PwideChar(widestring(FCaption));
FBrowseInfoW.hwndOwner:=(owner as TForm).handle;
FBrowseInfoW.lpfn:=@BrowseCallbackProcW;
_inDataW.Path:=PwideChar(FFolderName);
_inDataW.Caption:=PwideChar(FStatusText);
FBrowseInfoW.lParam:=integer(@_inDataW);
FBrowseInfoW.ulFlags:=FBrowseInfoW.ulFlags or BIF_VALIDATE;
GetMem(FBrowseInfoW.pszDisplayName,255);
res:=ShBrowseForFolderW(FBrowseInfoW);
if res=nil then result:=false
else begin
     result:=true;
     GetMem(sTempW,255);
     SHGetPathFromIDListW(Res,sTempW);
     FFolderName:=sTempW;
     freemem(sTempW,255);
     FDisplayName:=FBrowseInfoW.pszDisplayName;
     end;
FreeMem(FBrowseInfoW.pszDisplayName,255);

end else begin

if foRoot<>bl_STANDART then FBrowseInfoA.pidlRoot:=iGetRoot;
FBrowseInfoA.lpszTitle:=PChar(wtostr(FCaption));
FBrowseInfoA.hwndOwner:=(owner as TForm).handle;
FBrowseInfoA.lpfn:=@BrowseCallbackProcA;
_inDataA.Path:=PChar(wtostr(FFolderName));
_inDataA.Caption:=PChar(wtostr(FStatusText));
FBrowseInfoA.lParam:=integer(@_inDataA);
FBrowseInfoA.ulFlags:=FBrowseInfoA.ulFlags or BIF_VALIDATE;
 GetMem(FBrowseInfoA.pszDisplayName,255);
res:=ShBrowseForFolderA(FBrowseInfoA);
if res=nil then result:=false
else begin
     result:=true;
      GetMem(sTempA,255);
     SHGetPathFromIDListA(Res,sTempA);
     FFolderName:=widestring(sTempA);
      freemem(sTempA,255);
     FDisplayName:=FBrowseInfoA.pszDisplayName;
     end;
 FreeMem(FBrowseInfoA.pszDisplayName,255);
end;
end;

function TBrowseForFolder.wtostr(strin:widestring):string;
var
i:integer;
begin
result:='';
for i:=1 to length(strin) do begin
 result:=result+
         chr(integer(strin[i]));
end;

end;

//procedure TBrowseForFolder.SetRoot;
//begin
//FRoot:=Root;
//end;

//procedure TBrowseForFolder.SetFunction;
//begin
//FBrowseInfo.lpfn:=tf;
//end;

//procedure TBrowseForFolder.SetLParam;
//begin
//FBrowseInfo.lParam:=Param;
//end;


procedure Register;
begin
  RegisterComponents('Comet', [TBrowseForFolder]);
end;
{
procedure TBrowseForFolder.DefineProperties( Filer :TFiler );
begin
 Inherited DefineProperties( Filer );
 Filer.DefineProperty( 'data', ReadData, WriteData, true );
end;

procedure TBrowseForFolder.ReadData( Reader :TReader );
begin
  Reader.Read( FBrowseInfo, SizeOf( TBrowseInfo ) );
end;

procedure TBrowseForFolder.WriteData( Writer :TWriter );
begin
  writer.write( FBrowseInfo, SizeOf( TBrowseInfo ) );
end;
}
procedure TBrowseForFolder.SetFlags( Value :TBrowseFlags );
begin
if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
 SetOperFlagW(BIF_BROWSEFORCOMPUTER,bf_BROWSEFORCOMPUTER in Value);
 SetOperFlagW(BIF_BROWSEFORPRINTER,bf_BROWSEFORPRINTER in Value);
 SetOperFlagW(BIF_DONTGOBELOWDOMAIN,bf_DONTGOBELOWDOMAIN in Value);
 SetOperFlagW(BIF_RETURNFSANCESTORS,bf_RETURNFSANCESTORS in Value);
 SetOperFlagW(BIF_RETURNONLYFSDIRS,bf_RETURNONLYFSDIRS in Value);
 SetOperFlagW(BIF_EDITBOX,bf_Editbox in Value);
 SetOperFlagW(BIF_STATUSTEXT,bf_statustext in value);
end else begin
 SetOperFlagA(BIF_BROWSEFORCOMPUTER,bf_BROWSEFORCOMPUTER in Value);
 SetOperFlagA(BIF_BROWSEFORPRINTER,bf_BROWSEFORPRINTER in Value);
 SetOperFlagA(BIF_DONTGOBELOWDOMAIN,bf_DONTGOBELOWDOMAIN in Value);
 SetOperFlagA(BIF_RETURNFSANCESTORS,bf_RETURNFSANCESTORS in Value);
 SetOperFlagA(BIF_RETURNONLYFSDIRS,bf_RETURNONLYFSDIRS in Value);
 SetOperFlagA(BIF_EDITBOX,bf_Editbox in Value);
 SetOperFlagA(BIF_STATUSTEXT,bf_statustext in value);
end;
end;

function TBrowseForFolder.GetFlags;
begin
  result := [];
if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
  if GetOperFlagW(BIF_BROWSEFORCOMPUTER) then include( result,bf_BROWSEFORCOMPUTER);
  if GetOperFlagW(BIF_BROWSEFORPRINTER) then include( result,bf_BROWSEFORPRINTER);
  if GetOperFlagW(BIF_DONTGOBELOWDOMAIN) then include( result,bf_DONTGOBELOWDOMAIN);
  if GetOperFlagW(BIF_RETURNFSANCESTORS) then include( result,bf_RETURNFSANCESTORS);
  if GetOperFlagW(BIF_RETURNONLYFSDIRS) then include( result,bf_RETURNONLYFSDIRS);
  if GetOperFlagW(BIF_EDITBOX) then include( result,bf_Editbox);
  if GetOperFlagW(BIF_STATUSTEXT) then include( result,bf_StatusText);
end else begin
  if GetOperFlagA(BIF_BROWSEFORCOMPUTER) then include( result,bf_BROWSEFORCOMPUTER);
  if GetOperFlagA(BIF_BROWSEFORPRINTER) then include( result,bf_BROWSEFORPRINTER);
  if GetOperFlagA(BIF_DONTGOBELOWDOMAIN) then include( result,bf_DONTGOBELOWDOMAIN);
  if GetOperFlagA(BIF_RETURNFSANCESTORS) then include( result,bf_RETURNFSANCESTORS);
  if GetOperFlagA(BIF_RETURNONLYFSDIRS) then include( result,bf_RETURNONLYFSDIRS);
  if GetOperFlagA(BIF_EDITBOX) then include( result,bf_Editbox);
  if GetOperFlagA(BIF_STATUSTEXT) then include( result,bf_StatusText);
end;
end;

function TBrowseForFolder.GetOperFlagW( F :Cardinal ):boolean;
begin
  result := ( FBrowseInfoW.ulFlags and F ) <> 0;
end;

function TBrowseForFolder.GetOperFlagA( F :Cardinal ):boolean;
begin
  result := ( FBrowseInfoA.ulFlags and F ) <> 0;
end;

procedure TBrowseForFolder.SetOperFlagW( F :Cardinal; V :Boolean );
begin
 with FBrowseInfoW do
  if V then ulFlags := ulFlags or F else ulFlags := ulFlags and ( not F );
end;

procedure TBrowseForFolder.SetOperFlagA( F :Cardinal; V :Boolean );
begin
 with FBrowseInfoA do
  if V then ulFlags := ulFlags or F else ulFlags := ulFlags and ( not F );
end;

function BrowseCallbackProcA;
var sFName:^_exDataA;

begin
 case uMsg of
 BFFM_INITIALIZED:begin
                       sFName:=pointer(lpData);
                       if Length(sFName.Path)<>0 then
                       SendMessage(dhwnd,BFFM_SETSELECTION ,1,integer(sfname.Path));
                       if Length(sFName.Caption)<>0 then
                        SendMessage(dhwnd,BFFM_SETSTATUSTEXT ,1,integer(sfname.Caption));
                       end;
 BFFM_VALIDATEFAILED:begin

                          result:=1;
                          exit;
                          end;
 end;
result:=0;
end;

function BrowseCallbackProcW;
var sFName:^_exDataA;

begin
 case uMsg of
 BFFM_INITIALIZED:begin
                       sFName:=pointer(lpData);
                       if Length(sFName.Path)<>0 then
                       SendMessage(dhwnd,BFFM_SETSELECTION ,1,integer(sfname.Path));
                       if Length(sFName.Caption)<>0 then
                        SendMessage(dhwnd,BFFM_SETSTATUSTEXT ,1,integer(sfname.Caption));
                       end;
 BFFM_VALIDATEFAILED:begin

                          result:=1;
                          exit;
                          end;
 end;
result:=0;
end;


procedure TBrowseForFolder.SetCaption(const Value: wideString);
begin
  FCaption := Value;
end;

end.
