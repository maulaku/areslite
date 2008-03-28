unit dhtzonesTests;

interface

uses
  dhtzones,
  TestFrameWork;

type
  dhtzonesGlobalsTests = class(TTestCase)
  private

  protected

//    procedure SetUp; override;
//    procedure TearDown; override;

  published

    // Test methods
    procedure TestDHT_readnodeFile;

  end;

implementation
uses
 int128,vars_global,classes2,DebugLog,dhtcontact,helper_ipfunc,helper_registry;

{ dhtzonesGlobalsTests }

procedure dhtzonesGlobalsTests.TestDHT_readnodeFile;
var
 zero: CU_INT128;
 i : integer;

 contacts : TMylist;
 c: TContact;

 line, hex, ipStr, distance: string;
begin
  TRACEFMT('start %d ',[1]);

  reg_getDHT_ID;

  DHT_events := tmylist.create;

  DHT_routingZone := TRoutingZone.create;
  DHT_routingZone.init(nil, 0, @zero, false);

  dhtzones.DHT_readnodeFile('C:\Documents and Settings\changman\Local Settings\Application Data\Ares\Data\DHTnodes.dat', DHT_routingZone);
  DHT_routingZone.startTimer;

  contacts := TMylist.Create;

  dhtzones.DHT_getBootstrapContacts(DHT_routingZone, contacts, 20);

  for i:= 0 to contacts.count-1 do begin
    c:= contacts[i];
    hex := CU_INT128_tohexstr(@c.m_clientID);
    ipStr := ipint_to_dotstring(c.m_ip);
    distance := CU_INT128_tohexstr(@c.m_distance);

    TRACEFMT('%s %s %s ',[hex, ipStr, distance]);
  end;

  contacts.Free;
  DHT_events.Free;
  DHT_routingZone.Free;

end;

initialization

  TestFramework.RegisterTest('dhtzonesTests Suite',
    dhtzonesGlobalsTests.Suite);

end.
 