// Uncomment the following directive to create a console application
// or leave commented to create a GUI application... 
// {$APPTYPE CONSOLE}

program AresTests;

uses
  TestFramework {$IFDEF LINUX},
  QForms,
  QGUITestRunner {$ELSE},
  Forms,
  GUITestRunner {$ENDIF},
  TextTestRunner,
  thread_dhtTests in '..\DHT\dunit\thread_dhtTests.pas',
  thread_dht in '..\DHT\thread_dht.pas',
  dhtzonesTests in '..\DHT\dunit\dhtzonesTests.pas',
  thread_shareTests in 'thread_shareTests.pas',
  thread_share in '..\thread_share.pas';

{$R *.RES}

begin
  Application.Initialize;

{$IFDEF LINUX}
  QGUITestRunner.RunRegisteredTests;
{$ELSE}
  if System.IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
{$ENDIF}

end.

