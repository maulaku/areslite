unit thread_shareTests;

interface

uses
  thread_share,
  TestFrameWork;

type
  tthread_shareTests = class(TTestCase)
  private

  protected

//    procedure SetUp; override;
//    procedure TearDown; override;

  published

    // Test methods
    procedure TestInit;
{
    procedure Testlibrary_reset_stats_numbers;
    procedure Testinit_categs;
    procedure Testinit_thread_vars;
    procedure Testnihil_vars;
    procedure TestExecute;
    procedure Testhide_scan_folders;
    procedure Testprepara_form1_library;
    procedure Testscan_in_progress_start;
    procedure Testshutdown;
    procedure Testinit_metareaders;
    procedure Testfree_metareaders;
    procedure Testsharedlist_getGlobal;
    procedure Testsharedlist_clearGlobal;
    procedure Testshow_final_library;
    procedure Testshow_temp_library;
    procedure Testsharedfolder_scan;
    procedure Testis_parent_path_already_in;
    procedure Testsharedfolder_getsubdirs;
    procedure Testregular_libraryview_assign;
    procedure Testreset_mime_stats;
    procedure Testdeal_with_newfile;
    procedure TestDHT_generate_hashFilelist;
    procedure Testsharedfolders_init;
    procedure Testadd_to_sharedlist;
    procedure Testget_hash_throttle;
    procedure Testput_hash_file_name;
    procedure Testput_clear_hash_file_name;
    procedure Testput_hash_progress;
    procedure Testput_end_hash;
    procedure Testput_end_of_global_hashing;
    procedure Testhash_compute;
    procedure TestVirFoldersView_update;
    procedure TestmainGUI_addlibrarynodes;
    procedure TestRegFoldersView_update;
    procedure Testcategs_compute;
    procedure Testadd_keyword_genre;
    procedure Testkeyword_genre_compute;
    procedure Testserialize_top_keyword_genre;
    procedure Testextract_msword_infos;
    procedure TestAddmswordProperty;
    procedure Testclear_listviewLib;
    procedure Testsharedlist_setGlobal;
    procedure Testgetmpeginfo;
    procedure Testmime_stats_reset;
    procedure Testlists_create;
    procedure Testlists_free;
    procedure Testcategs_sort;
    procedure Testparse_iptc;
 }
  end;

implementation

{ tthread_shareTests }

procedure tthread_shareTests.TestInit;
var
  oShare : tthread_share;
begin
  oShare :=  tthread_share.Create(true);
  oShare.Test;
  oShare.Free;
end;

initialization

  TestFramework.RegisterTest('thread_shareTests Suite',
    tthread_shareTests.Suite);

end.
 