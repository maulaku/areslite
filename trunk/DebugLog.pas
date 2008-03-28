unit DebugLog;

interface

{$DEFINE DEBUGLOG_ON}

uses
  Classes;

type
  TLogFilter = TStringList;
  TLogFilterMode = (lfmExcept, lfmExtract);

const
  // Log Category
  LOG_NONCATEGORY = '';
  LOG_TEMP        = 'LOG_TEMP';
  LOG_CLASS       = 'LOG_CLASS';
  LOG_THREAD      = 'LOG_THREAD';
  LOG_EVENT       = 'LOG_EVENT';
  LOG_EXCEPTION   = 'LOG_EXCEPTION';

// Option
procedure EnableDebugLog(ASwitch: Boolean = True);
procedure EnableTimeString(ASwitch: Boolean = True);

// Output Debug Log
procedure PrintLog(ALog: String; ALogCategory: String = LOG_NONCATEGORY);
procedure PrintClassLog(AObject: TObject; ALog: String; ALogCategory: String = LOG_CLASS);
procedure TRACE(ALog: String; ALogCategory: String = LOG_NONCATEGORY);
procedure TRACEFMT(const Format: string; const Args: array of const; ALogCategory: String = LOG_NONCATEGORY);

// Log Filter
procedure SetLogFilterMode(AMode: TLogFilterMode);
procedure AddLogFilter(ACategory: String);
procedure ClearAllLogFilter;

procedure  WriteMlogFMT(const Format: string; const Args: array of const);

implementation

uses
  SysUtils, Windows;

{$IFDEF DEBUGLOG_ON}
var
  LogEnable     : Boolean;
  TimeStrEnable : Boolean;
  LogFilter     : TLogFilter;
  LogFilterMode : TLogFilterMode;
{$ENDIF}


procedure  WriteMlogFMT(const Format: string; const Args: array of const);
var
  F       : TextFile;
  LogFile,logdir : string;
  StrLog,nowDay ,strTime : string;

  Formated : String;
begin
    FmtStr(Formated, Format, Args);

    nowDay  := FormatDateTime('yyyymmdd', Now);
    logdir  := ExtractFilePath(paramstr(0))+'\MLOG\';
    if not DirectoryExists(logdir) then MkDir(logDir);

    LogFile := logdir + nowDay+'Spy.log';
    strlog  :=  FormatDateTime('hhnnss',now)+',' + Formated;

    {$I-}
try
    AssignFile(F, LogFile);
    if FileExists(LogFile) then Append(F)
    else                        ReWrite(F);
    Writeln(F, strLog);
finally
    CloseFile(F);
end;
    {$I+}
end;    

function CheckFilter(ACategory: String): Boolean;
var
  i: Integer;
begin
{$IFDEF DEBUGLOG_ON}
  Result := LogFilterMode = lfmExcept;
  if LogFilter = nil then exit;
  for i := 0 to LogFilter.Count-1 do
    if LogFilter.Strings[i] = Trim(ACategory) then
    begin
      Result := not Result;
      Break;
    end;
{$ENDIF}    
end;

procedure EnableDebugLog(ASwitch: Boolean);
begin
{$IFDEF DEBUGLOG_ON}
  LogEnable := ASwitch;
{$ENDIF}
end;

procedure EnableTimeString(ASwitch: Boolean = True);
begin
{$IFDEF DEBUGLOG_ON}
  TimeStrEnable := ASwitch;
{$ENDIF}
end;

procedure PrintLog(ALog: String; ALogCategory: String);
var
  time_str: String;
begin
{$IFDEF DEBUGLOG_ON}
  if LogEnable and CheckFilter(ALogCategory) then
  begin
    if TimeStrEnable then
     // time_str := DateTimeToStr(Now) + ' '
      time_str := FormatDateTime('yyyymmdd hhnnsszzz',now)+ ' '
    else
      time_str := '';

    OutputDebugString(PChar(time_str + ALog));
  end;
{$ENDIF}
end;

procedure TRACEFMT(const Format: string; const Args: array of const; ALogCategory: String = LOG_NONCATEGORY);
var
  Formated : String;
begin
{$IFDEF DEBUGLOG_ON}
   FmtStr(Formated, Format, Args);
   TRACE(Formated);
{$ENDIF}
end;

procedure TRACE(ALog: String; ALogCategory: String = LOG_NONCATEGORY);
var
  time_str: String;
begin
{$IFDEF DEBUGLOG_ON}
  if LogEnable and CheckFilter(ALogCategory) then
  begin
    if TimeStrEnable then
     // time_str := DateTimeToStr(Now) + ' '
      time_str := FormatDateTime('hh:nn:ss:zzz',now)+ ' '
    else
      time_str := '';

    OutputDebugString(PChar(time_str + ALog));
  end;
{$ENDIF}
end;

procedure PrintClassLog(AObject: TObject; ALog: String; ALogCategory: String);
begin
  PrintLog('<' + AObject.ClassName + '> ' + ALog, ALogCategory);
end;

procedure AddLogFilter(ACategory: String);
begin
{$IFDEF DEBUGLOG_ON}
  LogFilter.Add(Trim(ACategory));
{$ENDIF}
end;

procedure ClearAllLogFilter;
begin
{$IFDEF DEBUGLOG_ON}
  LogFilter.Clear;
{$ENDIF}
end;

procedure SetLogFilterMode(AMode: TLogFilterMode);
begin
{$IFDEF DEBUGLOG_ON}
  LogFilterMode := AMode;
{$ENDIF}
end;


{$IFDEF DEBUGLOG_ON}
initialization
  LogFilter := TLogFilter.Create;

  EnableDebugLog;
  EnableTimeString;

  SetLogFilterMode(lfmExcept);

finalization
  LogFilter.Free;
  LogFilter:= nil;
{$ENDIF}

end.
 
