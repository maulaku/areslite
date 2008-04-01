unit CmtVerNfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,tntwindows;

type
  VS_FIXEDFILEINFO = record
    dwSignature : Integer;
    dwStrucVersion : Integer;
    dwFileVersionMS : Integer;
    dwFileVersionLS : Integer;
    dwProductVersionMS : Integer;
    dwProductVersionLS : Integer;
    dwFileFlagsMask : Integer;
    dwFileFlags : Integer;
    dwFileOS : Integer;
    dwFileType : Integer;
    dwFileSubtype : Integer;
    dwFileDateMS : Integer;
    dwFileDateLS : Integer
  end;

  TCmtVerNfo = class(TComponent)
  private
    { Private declarations }
    FAutoGetInfo : Boolean;
    FHaveVersionInfo : Boolean;
    FhZero : DWORD;
    FVersionInfoSize : Integer;
    FVersionInfoBuffer : PwideChar;
    FFileName : widestring;
    FParam : Pointer;
    FParameterLength : UINT;
    FLanguage : Integer;
    FCharSet : Integer;
    FLangChar : String[8];
    FLanguageStr : String[4];
    FCharSetStr : String[4];
    FFixedFileInfo : VS_FIXEDFILEINFO;
  protected
    { Protected declarations }
    function GetFileName : wideString;
    procedure SetFileName(Name : wideString);
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    procedure GetFileInfo(FileName : WideString);
    procedure SetAutoGetInfo(Value : Boolean);

    property FileName : wideString read GetFileName write SetFileName;
    property AutoGetInfo : Boolean read FAutoGetInfo write SetAutoGetInfo default True;

    property HaveVersionInfo : Boolean read FHaveVersionInfo;
    property Language : Integer read FLanguage;
    property CharSet : Integer read FCharSet;
    property Signature : Integer read FFixedFileInfo.dwSignature;
    property StrucVersion : Integer read FFixedFileInfo.dwStrucVersion;
    property FileVersionMS : Integer read FFixedFileInfo.dwFileVersionMS;
    property FileVersionLS : Integer read FFixedFileInfo.dwFileVersionLS;
    property ProductVersionMS : Integer read FFixedFileInfo.dwProductVersionMS;
    property ProductVersionLS : Integer read FFixedFileInfo.dwProductVersionLS;
    property FileFlagsMask : Integer read FFixedFileInfo.dwFileFlagsMask;
    property FileFlags : Integer read FFixedFileInfo.dwFileFlags;
    property FileOS : Integer read FFixedFileInfo.dwFileOS;
    property FileType : Integer read FFixedFileInfo.dwFileType;
    property FileSubtype : Integer read FFixedFileInfo.dwFileSubtype;
    property FileDateMS : Integer read FFixedFileInfo.dwFileDateMS;
    property FileDateLS : Integer read FFixedFileInfo.dwFileDateLS;
    function GetValue(ValueName : String) :widestring;
  end;

procedure Register;

implementation

constructor TCmtVerNfo.Create(AOwner : TComponent);
var
lung:integer;
buffer:array[0..MAX_PATH-1] of widechar;
widstr:widestring;
begin
  inherited Create(AOwner);
  try
  FFileName := '';
  FAutoGetInfo := True;
  FLanguage := 0;
  FCharSet := 0;
       
  lung:=tntwindows.Tnt_GetModuleFileNameW(0, Buffer, SizeOf(Buffer));

  if lung=0 then exit;

  setlength(widstr,lung);
  move(buffer,widstr[1],lung*2);

  SetFileName(widstr);
  GetFileInfo(FileName);
  except
  end;
end;

destructor TCmtVerNfo.Destroy;
begin
  inherited Destroy;
  try
  ffilename:='';
  if FVersionInfoBuffer <> nil then
    FreeMem(FVersionInfoBuffer);
  except
  end;
end;

function TCmtVerNfo.GetFileName : wideString;
begin
  Result := FFileName;
end;

procedure TCmtVerNfo.SetFileName(Name : wideString);
begin
  Ffilename:=name;
end;

procedure TCmtVerNfo.SetAutoGetInfo(Value : Boolean);
begin
try
  if FAutoGetInfo <> Value then begin
    FAutoGetInfo := Value;
    if FAutoGetInfo then
      SetFileName(ParamStr(0));
    GetFileInfo(FFileName);
  end;
except
end;
end;

procedure TCmtVerNfo.GetFileInfo(FileName:wideString);
var
  Temp : Integer;
begin
try

  FVersionInfoSize := tntwindows.Tnt_GetFileVersionInfoSizeW(pwidechar(FFileName), FhZero);
  FHaveVersionInfo := (FVersionInfoSize <> 0);

    FVersionInfoBuffer := AllocMem(FVersionInfoSize);
    FHaveVersionInfo := tntwindows.Tnt_GetFileVersionInfoW(pwidechar(FFileName), 0, FVersionInfoSize, FVersionInfoBuffer);

    if FHaveVersionInfo then begin
      tntwindows.Tnt_VerQueryValueW(FVersionInfoBuffer,
                    '\',
                    FParam, FParameterLength);
      CopyMemory(@FFixedFileInfo, FParam, FParameterLength);
      tntwindows.Tnt_VerQueryValueW(FVersionInfoBuffer,
                    '\VarFileInfo\Translation',
                    FParam, FParameterLength);
      Temp := Integer(FParam^);
      FLanguage := Temp and $FFFF;
      FCharSet := ((Temp and $FFFF0000) shr 16) and $FFFF;
      FLanguageStr := IntToHex(FLanguage, 4);
      FCharSetStr := IntToHex(FCharSet, 4);
      FLangChar := FLanguageStr + FCharSetStr;
    end;

  except
    FVersionInfoBuffer := nil;
  end;
end;

function TCmtVerNfo.GetValue(ValueName : String) : WideString;
var
res:boolean;
begin
try
               
if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
                         res:=tntwindows.Tnt_VerQueryValueW(FVersionInfoBuffer,pwidechar(widestring('\StringFileInfo\' + FLangChar + '\' + ValueName)),FParam, FParameterLength);
                             if res then begin
                                         setlength(result,FParameterLength-1);
                                         move(FParam^,result[1],(FParameterLength-1)*2);
                                        end else Result := inttostr(getlasterror);
                         end else begin
                             res:=VerQueryValue(FVersionInfoBuffer,
                                                PChar(string('\StringFileInfo\' + FLangChar + '\' + ValueName)),
                                                FParam, FParameterLength);
                              if res then Result := strpas(FParam) else Result := inttostr(getlasterror);
                         end;

except
end;
end;

procedure Register;
begin
  RegisterComponents('Comet', [TCmtVerNfo]);
end;

end.
