unit thread_dhtTests;

interface

uses
  thread_dht,
  TestFrameWork;

type
  tthread_dhtTests = class(TTestCase)
  private

  protected

    dhtThread :   TThread_dht;

    procedure SetUp; override;
    procedure TearDown; override;

  published

    // Test methods
    procedure Testget_library_file;
{   procedure Testhandler_publish_keyFile;
    procedure TestDHT_ParseFileInfo;
    procedure TestDHT_AddSrcResults;
    procedure TestFreeResultSearch;
    procedure TestcheckOutHashSearches;
    procedure TestcheckOutKeySearches;
    procedure TestFindDownloadSha1Treeview;
    procedure TestFindDlHash;
    procedure TestDHT_ParseKeywords;
    procedure TestDHT_parseSearch;
    procedure TestDHT_HasEnoughKeys;
    procedure TestDHT_ParseComplexField;
    procedure TestDHT_localSearch;
    procedure TestDHT_FindRarestKeyword;
    procedure TestDHT_matchFile;
    procedure TestDHT_SerializeResult;
    procedure TestDHT_SendKeywordResult;
    procedure Testcheck_shareHashFile;
    procedure Testcheck_shareKeyFile;
    procedure Testcheck_GUI;
    procedure Testfill_random_id;
    procedure TestAddContacts;
    procedure Testcheck_events;
    procedure Testcheck_second;
    procedure Testcheck_bootstrap;
    procedure Testexecute;
    procedure Testshutdown;
    procedure Testinit_vars;
    procedure Testcreate_listener;
    procedure Testudp_Receive;
    procedure TestprocessBootstrapRequest;
    procedure TestprocessBootstrapResponse;
    procedure TestprocessHelloRequest;
    procedure TestprocessHelloResponse;
    procedure TestprocessSearchIDRequest;
    procedure TestprocessSearchIDResponse;
    procedure TestprocessSearchKeyRequest;
    procedure TestprocessSearchKeyResponse;
    procedure TestprocessPublishKeyRequest;
    procedure TestprocessPublishKeyResponse;
    procedure TestprocessPublishHashRequest;
    procedure TestprocessPublishHashResponse;
    procedure TestprocessSearchHashRequest;
    procedure TestprocessSearchPartialSourceHashRequest;
    procedure TestprocessSearchPartialSourceHashResponse;
    procedure TestprocessSearchHashResponse;
    procedure TestDHT_SendPartialSources;
    procedure TestprocessIpRequest;
    procedure TestprocessCachesRequest;
    procedure TestprocessCachesResponse;
    procedure TestprocessFirewallCheckRequest;
    procedure TestFirewallChecksDeal;
    procedure TestprocessFirewallCheckStart;
    procedure TestSendCheckFirewall;
    procedure TestprocessFirewallCheckResult;
    procedure TestSyncNotFirewalled;
    procedure TestAddContact;
 }
  end;

implementation
uses
  vars_global;

{ tthread_dhtTests }

procedure tthread_dhtTests.SetUp;
begin
  inherited;
  vars_global.data_path := 'C:\Documents and Settings\changman\Local Settings\Application Data\Ares';
  dhtThread := tthread_dht.Create(false);
end;

procedure tthread_dhtTests.TearDown;
begin
  inherited;

  dhtThread.Destroy;

end;

procedure tthread_dhtTests.Testget_library_file;
begin
  
  Check(true);
end;

initialization

  TestFramework.RegisterTest('thread_dhtTests Suite',
    tthread_dhtTests.Suite);

end.
 