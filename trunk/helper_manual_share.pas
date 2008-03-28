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
manual configuration of shared folders, visual component called 'mfolder' in the main GUI
}

unit helper_manual_share;

interface

uses
comettrees,classes,classes2,windows,sysutils,ares_types,
forms,controls;

  const
  STATO_NOT_CHECKED     = 0;
  STATO_CHECKED         = 1;
  STATO_GREY_CHECKED    = 2;
  WORKSTATION_ICON      = 0;
  DRIVE_ICON            = 7;
  FOLDER_NORMAL         = 1;
  FOLDER_SELECTED       = 4;
  CDROM_ICON            = 10;
  NETWORK_ICON          = 13;

Procedure mfolder_EnumerateFolder(node:PCmtVNode);
procedure mfolder_LoadChecksFromDisk;
procedure mfolder_CheckParentFolder ( node : PCmtVNode );
Procedure mfolder_Init;
procedure mfolder_CheckFolder(node:PCmtVNode);
function mfolder_ProofStates(node : PCmtVNode):boolean;
function mfolder_CheckSibling(node:PCmtVNode):boolean;
procedure mfolder_CheckSubFolder ( node : PCmtVNode );
function mfolder_FindNodeInTreeView(StartNode:PCmtVNode; crcpath:word; path:string) : PCmtVNode;
procedure mfolder_AddSubNodesWithFolder(path:string);
procedure mfolder_add_first_child(node:PCmtVNode);
procedure mainGUI_init_manual_share;
Procedure mfolder_SaveChecksToDisk; //tTreeView


implementation

uses
ufrmmain,vars_global,helper_share_settings,helper_unicode,
helper_visual_library,helper_diskio,helper_strings,
helper_urls,helper_registry;


Procedure mfolder_SaveChecksToDisk; //tTreeView
var
  data:ares_types.precord_mfolder;
  node:pCmtVnode;
  prima_cartella:precord_cartella_sharE;
Begin
  prima_cartella:=nil;
  try

  // store checked folder
  node:=ares_frmmain.mfolder.getfirst;
  node:=ares_frmmain.mfolder.getnext(node);
  while (node<>nil) do begin
   data:=ares_frmmain.mfolder.getdata(node);
    if data^.stato<>STATO_CHECKED then begin
     node:=ares_frmmain.mfolder.getnext(node);
     continue;
    end;
     helper_share_settings.add_this_shared_folder(prima_cartella,utf8strtowidestr(data^.path));
     node:=ares_frmmain.mfolder.getnext(node);
  end;

   //cancelliamo old

   helper_share_settings.write_to_file_shared_folders(prima_cartella);
   cancella_cartella_per_treeview2(prima_cartella);
   

  except
  end;

End;

procedure mainGUI_init_manual_share;
begin
 try
     if ares_frmmain.mfolder.RootNodeCount=0 then begin
      mfolder_init;
      mfolder_LoadChecksFromDisk;
     end;
 except
 end;
end;

procedure mfolder_add_first_child(node:pCmtVnode);
var
doserror:integer;
searchrec:ares_types.tsearchrecW;

data,data1:ares_types.precord_mfolder;
node_new:pCmtVnode;
nomeutf8:string;
directory:widestring;
crcpath:word;
begin

data:=ares_frmmain.mfolder.getdata(node);

directory:=utf8strtowidestr(data^.path);

     try
      DosError := helper_diskio.FindFirstW(directory+'\*.*', faAnyFile, SearchRec);
      while DosError = 0 do begin

       if (SearchRec.attr and faDirectory)=0 then begin  //non e directory continuiamo...
        DosError := helper_diskio.FindNextW(SearchRec); {Look for another subdirectory}
        continue;
       end;

       if ((SearchRec.name='.') or
           (SearchRec.name='..')) then begin
                 DosError := helper_diskio.FindNextW(SearchRec); {Look for another subdirectory}
                 continue;
       end;

           nomeutf8:=data^.path+'\'+widestrtoutf8str(searchrec.name);
           crcpath:=stringcrc(nomeutf8,true);
            node_new:=mfolder_findnodeintreeview(node,crcpath,nomeutf8);


            if node_new=nil then begin
             node_new:=ares_frmmain.mfolder.addchild(node);
             data1:=ares_frmmain.mfolder.getdata(node_new);
             data1^.path:=nomeutf8;
             data1^.crcpath:=crcpath;
             if data^.stato=STATO_CHECKED then data1^.stato:=STATO_CHECKED else
              data1^.stato:=STATO_NOT_CHECKED;
              ares_frmmain.mfolder.invalidatenode(node_new);
            end;// else node_new:=mfolder.items.item[index];

      DosError := helper_diskio.FindNextW(SearchRec); {Look for another subdirectory}
     end;

     finally
     helper_diskio.FindCloseW(SearchRec);
     end;
end;


procedure mfolder_AddSubNodesWithFolder(path:string);
var
  node : pCmtVnode;
  path1:string;
  crcpath:worD;
Begin
path1:=widestrtoutf8str(extract_fpathW(utf8strtowidestr(path)));
crcpath:=stringcrc(path1,true);

  node:=mfolder_FindNodeInTreeView(nil,crcpath,path1);

  if node=nil then begin

  exit;
  end;

  mfolder_EnumerateFolder(node);
End;

function mfolder_FindNodeInTreeView(StartNode:pCmtVnode; crcpath:word; path:string) : pCmtVnode;
var
  node : pCmtVnode;
  data:ares_types.precord_mfolder;
  lopath:string;
Begin
  result := nil;
try
  lopath:=lowercase(path);

  if startnode=nil then startnode:=ares_frmmain.mfolder.getfirst;

  node := ares_frmmain.mfolder.getfirstchild(startnode);

  while (node <> nil) do begin

  data:=ares_frmmain.mfolder.getdata(node);
   if crcpath=data^.crcpath then
    if lowercase(data^.path)=lopath then begin
     result:=node;
     exit;
    end;

   node:=ares_frmmain.mfolder.getnext(node);
 end;

except
end;
End;

procedure mfolder_CheckSubFolder ( node : pCmtVnode );
var
  node1:pCmtVnode;
  data,data1:ares_types.precord_mfolder;
  level:cardinal;
Begin
try

  level:=ares_frmmain.mfolder.getnodelevel(node);
  data:=ares_frmmain.mfolder.getdata(node);

  node1 := ares_frmmain.mfolder.GetFirstChild(node);

  while node1 <> nil do begin
   data1:=ares_frmmain.mfolder.getdata(node1);

      data1.stato:=data^.stato;
      ares_frmmain.mfolder.invalidatenode(node1);

    Node1 := ares_frmmain.mfolder.getnext(Node1);   //tutti anche child di child...finchè non arrivo a parent o sibling
    if node1=nil then exit;

    if ares_frmmain.mfolder.getnodelevel(node1)<=level then break;  //ok tutti i child...
  end;


except
end;
End;

function mfolder_CheckSibling(node:pCmtVnode):boolean;
var
  node1:pCmtVnode;
  data:ares_types.precord_mfolder;
Begin
  result := true; // if all folder are checked
  FSomeFolderChecked := false;

  Node1 := ares_frmmain.mfolder.getfirstchild(Node);

  while node1 <> nil do begin
    data:=ares_frmmain.mfolder.getdata(node1);

    if data^.stato=STATO_CHECKED then FSomeFolderChecked := true else
    if data^.stato=STATO_GREY_CHECKED then begin
      FSomeFolderChecked := true;
      result := false;
      break;
    end else
    if data.Stato=STATO_NOT_CHECKED then result := false;

    Node1 := ares_frmmain.mfolder.getnextsibling(Node1);
   end;
End;

function mfolder_ProofStates(node : pCmtVnode):boolean;
var
 data:ares_types.precord_mfolder;
Begin
  result := false;
try
data:=ares_frmmain.mfolder.getdata(node);

  if ((data^.stato=STATO_NOT_CHECKED) or
     (data^.stato=STATO_GREY_CHECKED)) then begin
    data^.stato:=STATO_CHECKED;
    ares_frmmain.mfolder.invalidatenode(node);
    result := true;
  end else
  if (data^.stato=STATO_CHECKED) then begin
   data^.stato:=STATO_NOT_CHECKED;
   ares_frmmain.mfolder.invalidatenode(node);
  end;

     mfolder_CheckParentFolder(node);
     mfolder_CheckSubFolder(node);


  cambiato_manual_folder_share:=true;//dobbiamo riscannare se fa apply
except
end;
End;


procedure mfolder_CheckFolder(node:pCmtVnode);
var
data:ares_types.precord_mfolder;
begin
data:=ares_frmmain.mfolder.getdata(node);
data^.stato:=STATO_CHECKED;

  mfolder_CheckParentFolder ( node );
  mfolder_CheckSubFolder ( node );

end;

Procedure mfolder_Init;
var
  DriveNum: Integer;
  DriveChar: Char;
  DriveType: cardinal;
  DriveBits: set of 0..25;
  str:string;
  node,rootn:pCmtVnode;
  data:ares_types.precord_mfolder;
begin
ares_frmmain.mfolder.onexpanding:=nil;

ares_frmmain.mfolder.header.columns[0].width:=ares_frmmain.mfolder.width;

   rootn:=ares_frmmain.mfolder.Addchild(nil);
    data:=ares_frmmain.mfolder.getdata(rootn);
    data^.path:='';
    data^.stato:=-1;

   seterrormode(SEM_FAILCRITICALERRORS);
                          //get logical drive.....
  Integer(DriveBits) := GetLogicalDrives;
  for DriveNum := 0 to 25 do begin
    if not (DriveNum in DriveBits) then Continue;
    DriveChar := Char(DriveNum + Ord('a'));
    DriveType := GetDriveType(PChar(DriveChar + ':\'));
     if ((DriveType=DRIVE_FIXED) or
         (DriveType=DRIVE_REMOTE) or
         (DriveType=DRIVE_CDROM) or
         (DriveType=DRIVE_RAMDISK)) then begin
         str:=drivechar+':';
              if setcurrentdirectory(pchar(str)) then begin
                node:=ares_frmmain.mfolder.AddChild(rootn);
                data:=ares_frmmain.mfolder.getdata(node);
                data^.drivetype:=DriveType;
                data^.path:=str;//'Disk ('+uppercase(DriveChar+':)');
                data^.crcpath:=stringcrc(str,true);
                data^.stato:=0;
                  ares_frmmain.mfolder.invalidatenode(node);
              end;
     end;
  end;

 ares_frmmain.mfolder.fullexpand;
 

node:=ares_frmmain.mfolder.getfirstchild(rootn);
repeat
if node=nil then break;
  mfolder_EnumerateFolder(node);
  node:=ares_frmmain.mfolder.getnextsibling(node);
until (not true);

ares_frmmain.mfolder.onexpanding:=ufrmmain.ares_frmmain.mfolderExpanding;

End;


procedure mfolder_CheckParentFolder ( node : pCmtVnode );
var
  AllFolderChecked : boolean;
  node1:pCmtVnode;
  data:ares_types.precord_mfoldeR;
Begin
try

node1:=node.parent;

  while ares_frmmain.mfolder.getnodelevel(node1) >= 1 do begin

    AllFolderChecked := mfolder_CheckSibling(node1);  //sono gli altri child selezionati?

    data:=ares_frmmain.mfolder.getdata(node1);

    if (not AllFolderChecked) and
       (not FSomeFolderChecked) then begin
          data^.Stato:=STATO_NOT_CHECKED;
          ares_frmmain.mfolder.invalidatenode(node1);
    end else
    if FSomeFolderChecked then begin
         data^.Stato:=STATO_GREY_CHECKED;
         ares_frmmain.mfolder.invalidatenode(node1);
    end;

    node1:=node1.parent;
    if node1=nil then exit;
  end;

  except
  end;
End;

procedure mfolder_LoadChecksFromDisk;
   procedure mfolder_SplitPathToList ( path : string; list : tmyStringList );
    var
    i : integer;
    str:widestring;
   begin
    str:=utf8strtowidestr(path);

    for i:=1 to length(str) do begin
     if str[i]='\' then begin
      if i>3 then list.add(widestrtoutf8str(copy(str,1,i-1)));
     end;
    end;
     list.add(path);
   end;
var
  k : integer;
  SplitPathList : tmyStringList;
  path : string;
  prima_cartella:precord_cartella_share;
  cartella:precord_cartella_share;
   noder,node:pCmtVnode;
Begin
try
  screen.cursor := crHourGlass;
  application.processmessages;

  SplitPathList := tmyStringList.create;

  try

  prima_cartella:=nil;
  helper_share_settings.get_shared_folders(prima_cartella,not reg_getever_configured_share);


   add_this_shared_folder(prima_cartella,vars_global.myshared_folder);

  // add nodes if necessary
  cartella:=prima_cartella;
  while (cartella<>nil) do begin
    SplitPathList.clear;
    path := cartella^.path_utf8;
    mfolder_SplitPathToList(path,SplitPathList);
    // add nodes without Sub-Nodes
    for k:=0 to SplitPathList.count-1 do begin
         //sho/wmessage(SplitPathList.strings[k]);
     mfolder_AddSubNodesWithFolder(SplitPathList.strings[k]);
      Application.ProcessMessages;
    end;

    cartella:=cartella^.next;

  end;
  // check nodes if necessary
    noder := ares_frmmain.mfolder.getfirst;
    if prima_cartella=nil then exit;

     cartella:=prima_cartella;
     while (cartella<>nil) do begin

      node:= mfolder_FindNodeInTreeView(noder,cartella^.crcpath,cartella^.path_utf8);
      if node<>nil then mfolder_CheckFolder(node);// else s/howmessage('not adding checks on:'+cartella^.path_utf8);
       Application.ProcessMessages;
       cartella:=cartella^.next;
     end;


  except
  end;


  SplitPathList.free;


  if prima_cartella<>nil then cancella_cartella_per_treeview2(prima_cartella);

 except
 end;
 screen.cursor := crDefault;
 ares_frmmain.mfolder.invalidate;
End;


Procedure mfolder_EnumerateFolder(node:pCmtVnode);
var
node_new:pCmtVnode;
begin
try

if ares_frmmain.mfolder.getnodelevel(node)=0 then exit;

if ares_frmmain.mfolder.getfirstchild(node)=nil then begin
 mfolder_add_first_child(node);
 ares_frmmain.mfolder.sort(node,0,sdascending);
end;


node_new:=ares_frmmain.mfolder.getfirstchild(node);
while (node_new<>nil) do begin

 if ares_frmmain.mfolder.getfirstchild(node_new)=nil then begin
  mfolder_add_first_child(node_new);
  ares_frmmain.mfolder.sort(node_new,0,sdascending);
 end;

 node_new:=ares_frmmain.mfolder.getnextsibling(node_new);
 
end;

except
end;
End;


end.