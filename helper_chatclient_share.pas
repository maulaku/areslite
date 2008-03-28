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
chat browse visual helper code
}

unit helper_chatclient_share;

interface

uses
classes,classes2,ares_types,comettrees,sysutils,const_ares;

function find_node_browsefold(tree:tcomettree; pathS:string; crcpath:word):pCmtVnode;
procedure add_regular_folder_browse(tree:tcomettree; pfile:precord_file_library);
procedure chatclient_add_result_search(pcanale:precord_canale_chat_visual; pannello_result:precord_pannello_result_chat; presult_globale_search:precord_file_result_chat);
procedure deal_with_regular_folder_browse(list:tmylist; treeview2:tcomettree);//synch
procedure chatclient_set_endofsearch(pcanale:precord_canale_chat_visual; pannello_result:precord_pannello_result_chat);
procedure categs_init;
procedure reset_result_search;
procedure init_result_search;
procedure reset_result_browse;
procedure free_result_search;
procedure categs_free;
procedure categs_Setnihil;
procedure categs_compute;  //synch
procedure categs_sort;
procedure write_categs_treeview(tree:tcomettree);//synch
procedure categs_add(tree:tcomettree; list:tmylist; node:pCmtVnode);

var
    ///////////////////////////// browse chatroom
  num_audio:word;
  num_video:word;
  num_image:word;
  num_document:word;
  num_software:word;
  num_other:word;

   files_browsed:tmylist;
    artists_audio:tmylist;
    albums_audio:tmylist;
    categs_audio:tmylist;
    albums_image:tmylist;
    categs_image:tmylist;
    categs_video:tmylist;
    authors_document:tmylist;
    categs_document:tmylist;
    companies_software:tmylist;
    categs_software:tmylist;
   /////////////////////////////////////////////

    presult_globale_search:precord_file_result_chat;
    presult_browse_globale:precord_file_library;

implementation

uses
ufrmmain,helper_strings,vars_localiz,helper_unicode,helper_ipfunc,
helper_altsources,helper_urls,helper_sorting,helper_visual_library,
helper_visual_headers,helper_share_misc,helper_stringfinal,helper_mimetypes;


procedure categs_add(tree:tcomettree; list:tmylist; node:pCmtVnode);
var
records,datao:precord_string;
node_new:pCmtVnode;
begin
with tree do begin
 while (list.count>0) do begin
  records:=list[0];
           list.delete(0);

  node_new:=addchild(node);
   datao:=getdata(node_new);
   datao^.str:=records^.str;
   datao^.counter:=records^.counter;
   records^.str:='';
  FreeMem(records,sizeof(record_string));

 end;
end;
end;

procedure write_categs_treeview(tree:tcomettree);//synch
var
noderoot,node1,node2,node3,
nodeaudio,nodeall,nodeother,nodesoftware,
nodevideo,nodedocument,nodeimage:pCmtVnode;
datao:precord_string;
begin

with tree do begin
  noderoot:=GetFirst;

  nodeall:=getfirstchild(noderoot);
  if files_browsed.count>0 then begin
   datao:=getdata(nodeall);
   datao^.counter:=files_browsed.count;
   //invalidatenode(nodeall);
  end;

 nodeaudio:=getnextsibling(nodeall);
  if num_audio>0 then begin
   datao:=getdata(nodeaudio);
   datao^.counter:=num_audio;
   //invalidatenode(nodeaudio);
  end;


  nodeimage:=getnextsibling(nodeaudio);
  if num_image>0 then begin
   datao:=getdata(nodeimage);
   datao^.counter:=num_image;
   //invalidatenode(nodeimage);
  end;


  nodevideo:=getnextsibling(nodeimage);
  if num_video>0 then begin
   datao:=getdata(nodevideo);
   datao^.counter:=num_video;
   //invalidatenode(nodevideo);
  end;


 nodedocument:=getnextsibling(nodevideo);
  if num_document>0 then begin
   datao:=getdata(nodedocument);
   datao^.counter:=num_document;
   //invalidatenode(nodedocument);
  end;


  nodesoftware:=getnextsibling(nodedocument);
  if num_software>0 then begin
   datao:=getdata(nodesoftware);
   datao^.counter:=num_software;
   //invalidatenode(nodesoftware);
  end;


  nodeother:=getnextsibling(nodesoftware);
  if num_other>0 then begin
   datao:=getdata(nodeother);
   datao^.counter:=num_other;
   //invalidatenode(nodeother);
  end;



  // audio
node1:=getfirstchild(nodeaudio);
node2:=getnextsibling(node1);
node3:=getnextsibling(node2);

categs_add(tree,artists_audio,node1);
categs_add(tree,albums_audio,node2);
categs_add(tree,categs_audio,node3);


// image
node1:=getfirstchild(nodeimage);
node2:=getnextsibling(node1);
categs_add(tree,albums_image,node1);
categs_add(tree,categs_image,node2);



// video
node1:=getfirstchild(nodevideo);
categs_add(tree,categs_video,node1);


// document
node1:=getfirstchild(nodedocument);
node2:=getnextsibling(node1);
categs_add(tree,authors_document,node1);
categs_add(tree,categs_document,node2);



// software
node1:=getfirstchild(nodesoftware);
node2:=getnextsibling(node1);
categs_add(tree,companies_software,node1);
categs_add(tree,categs_software,node2);
end;

end;

procedure categs_sort;
begin
if artists_audio.count>1 then artists_audio.Sort(CompFunc_strings);
if albums_audio.count>1 then albums_audio.Sort(CompFunc_strings);
if albums_image.count>1 then albums_image.Sort(CompFunc_strings);
if authors_document.count>1 then authors_document.Sort(CompFunc_strings);
if companies_software.count>1 then companies_software.Sort(CompFunc_strings);


if categs_audio.count>1 then categs_audio.Sort(CompFunc_strings);
if categs_video.count>1 then categs_video.Sort(CompFunc_strings);
if categs_image.count>1 then categs_image.Sort(CompFunc_strings);
if categs_software.count>1 then categs_software.Sort(CompFunc_strings);
if categs_document.count>1 then categs_document.Sort(CompFunc_strings);
if categs_software.count>1 then categs_software.Sort(CompFunc_strings);
end;

procedure categs_compute;  //synch
var
i:integer;
pfile:precord_file_library;
artista,categoria,album,strunknown:string;
begin
strunknown:=GetLangStringA(STR_UNKNOWN);

 for i:=0 to files_browsed.count-1 do begin
  if (i mod 500)=0 then sleep(1);
  pfile:=files_browsed[i];

    if length(pfile^.artist)<2 then artista:=copy(strunknown,1,length(strunknown))
     else artista:=copy(pfile^.artist,1,length(pfile^.artist));

    if length(pfile^.category)<2 then categoria:=copy(strunknown,1,length(strunknown))
     else categoria:=copy(pfile^.category,1,length(pfile^.category));

    if length(pfile^.album)<2 then album:=copy(strunknown,1,length(strunknown))
     else album:=copy(pfile^.album,1,length(pfile^.album));

 case pfile^.amime of
    ARES_MIME_OTHER:inc(num_other);
    ARES_MIME_MP3,ARES_MIME_AUDIOOTHER1,ARES_MIME_AUDIOOTHER2:begin
     inc(num_audio); //mp3
      add_virfolders_entry(artists_audio,artista);
      add_virfolders_entry(albums_audio,album);
      add_virfolders_entry(categs_audio,categoria);
  end;
  ARES_MIME_SOFTWARE:begin
   inc(num_software);
    add_virfolders_entry(companies_software,artista);
    add_virfolders_entry(categs_software,categoria);
  end;
  ARES_MIME_VIDEO:begin
   inc(num_Video);
    add_virfolders_entry(categs_video,categoria);
  end;
  ARES_MIME_DOCUMENT:begin
   inc(num_Document);
    add_virfolders_entry(authors_document,artista);
    add_virfolders_entry(categs_document,categoria);
  end;
  ARES_MIME_IMAGE:begin
   inc(num_Image);
    add_virfolders_entry(albums_image,album);
    add_virfolders_entry(categs_image,categoria);
  end;
  end;

  artista:='';
  categoria:='';
  album:='';

end;

strunknown:='';
end;


procedure categs_Setnihil;
begin
 files_browsed:=nil;
  artists_audio:=nil;
  albums_audio:=nil;
  categs_audio:=nil;
  albums_image:=nil;
  categs_image:=nil;
  categs_video:=nil;
  authors_document:=nil;
  categs_document:=nil;
  companies_software:=nil;
  categs_software:=nil;
end;

procedure categs_free;
var
pfile:precord_file_library;
begin
  try
     if artists_audio<>nil then free_virfolders_entries(artists_audio);
     if albums_audio<>nil then free_virfolders_entries(albums_audio);
     if categs_audio<>nil then free_virfolders_entries(categs_audio);
     if authors_document<>nil then free_virfolders_entries(authors_document);
     if categs_document<>nil then free_virfolders_entries(categs_document);
     if companies_software<>nil then free_virfolders_entries(companies_software);
     if categs_software<>nil then free_virfolders_entries(categs_software);
     if categs_video<>nil then free_virfolders_entries(categs_video);
     if albums_image<>nil then free_virfolders_entries(albums_image);
     if categs_image<>nil then free_virfolders_entries(categs_image);

     if files_browsed<>nil then begin
      while (files_browsed.count>0) do begin
        pfile:=files_browsed[files_browsed.count-1];
               files_browsed.delete(files_browsed.count-1);
          finalize_file_library_item(pfile);
        FreeMem(pfile,sizeof(record_file_library));
      end;
      files_browsed.free;
      files_browsed:=nil;
     end;


  except
  end;
  categs_Setnihil;
end;

procedure init_result_search;
begin
presult_globale_search:=AllocMem(sizeof(record_file_result_chat));
reset_result_search;
end;

procedure reset_result_browse;
begin
 with presult_browse_globale^ do begin
  already_in_lib:=false;
  being_downloaded:=false;
  downloaded:=false;
  shared:=true;
  param1:=0;
  param2:=0;
  param3:=0;
  hash_sha1:='';
  title:='';
  artist:='';
  album:='';
  category:='';
  language:='';
  comment:='';
  year:='';
  url:='';
  keywords_genre:='';
  path:='';
 end;
end;

procedure free_result_search;
begin
reset_result_search;
FreeMem(presult_globale_search,sizeof(record_file_result_chat));
end;


procedure reset_result_search;
begin
 with presult_globale_search^ do begin
  param1:=0;
  param2:=0;
  param3:=0;
  nickname:='';
  hash_sha1:='';
  title:='';
  artist:='';
  album:='';
  category:='';
  language:='';
  comments:='';
  data:='';
  url:='';
  keyword_genre:='';
  filename:='';
 end;
end;

procedure categs_init;
begin
  num_audio:=0;
  num_video:=0;
  num_image:=0;
  num_document:=0;
  num_software:=0;
  num_other:=0;

  files_browsed:=tmylist.create;
  artists_audio:=tmylist.create;
  albums_audio:=tmylist.create;
  categs_audio:=tmylist.create;
  albums_image:=tmylist.create;
  categs_image:=tmylist.create;

  categs_video:=tmylist.create;
  authors_document:=tmylist.create;
  categs_document:=tmylist.create;
  companies_software:=tmylist.create;
  categs_software:=tmylist.create;

end;

procedure chatclient_set_endofsearch(pcanale:precord_canale_chat_visual; pannello_result:precord_pannello_result_chat);
var
node:pCmtVnode;
datao:precord_file_result_chat;
begin

with pannello_result^ do begin
with listview do begin
 if is_adding_result then begin
  is_adding_result:=false;
  endupdate;
 end;

if not selectable then begin
 clear;
  node:=addchild(nil);
  datao:=listview.getdata(node);
  with datao^ do begin
   hash_sha1:='1234567';
   title:=GetLangStringA(STR_SEARCHING_THE_NET_NO_RESULT);
   imageindex:=250;
  end;
   invalidatenode(node);
 exit;
end;
end;
 pnl.btncaption:=pnl.btncaption+' ('+
                 inttostr(listview.rootnodecount)+')';
end;

end;

procedure chatclient_add_result_search(pcanale:precord_canale_chat_visual; pannello_result:precord_pannello_result_chat; presult_globale_search:precord_file_result_chat);
var
node,node_child,node_new:pCmtVnode;
datao,data_child,data_new:precord_file_result_chat;
in_progress:boolean;
begin

with pannello_result^ do begin
 if not listview.selectable then begin
   listview.clear;
   listview.selectable:=true;
   header_result_chat_show(pannello_result);
   is_adding_result:=true;
   listview.canbgcolor:=true;
   listview.beginupdate;
   countresult:=0;
 end else
 if not is_adding_result then begin
   is_adding_result:=true;
   listview.beginupdate;
 end;
end;

with pannello_result^.listview do begin

  node:=getfirst;
  while (node<>nil) do begin

     datao:=getdata(node);
     if datao^.crcsha1<>presult_globale_search^.crcsha1 then begin
      node:=getnextsibling(node);
      continue;
     end;

     if datao^.hash_sha1<>presult_globale_search^.hash_sha1 then begin
      node:=getnextsibling(node);
      continue;
     end;

       if node^.FirstChild=nil then begin
        node_child:=addchild(node);
         data_child:=getdata(node_child);
         with data_child^ do begin
          ip_user:=datao^.ip_user;
          port_user:=datao^.port_user;
          ip_server:=datao^.ip_server;
          port_server:=datao^.port_server;
          ip_alt:=datao^.ip_alt;
          amime:=datao^.amime;
          fsize:=datao^.fsize;
          nickname:=datao^.nickname;
          up_count:=datao^.up_count;
          up_limit:=datao^.up_limit;
          queued:=datao^.queued;
           hash_sha1:=datao^.hash_sha1;
           crcsha1:=datao^.crcsha1;
          title:=datao^.title;
          artist:=datao^.artist;
          album:=datao^.album;
          category:=datao^.category;
          language:=datao^.language;
          comments:=datao^.comments;
          url:=datao^.url;
          data:=datao^.data;
          vidinfo:=datao^.vidinfo;
          keyword_genre:=datao^.keyword_genre;
          filename:=datao^.filename;
          param1:=datao^.param1;
          param2:=datao^.param2;
          param3:=datao^.param3;
          already_in_lib:=datao^.already_in_lib;
          being_downloaded:=datao^.being_downloaded;
          downloaded:=datao^.downloaded;
          imageindex:=datao^.imageindex;
         end;
          datao^.imageindex:=0;
          datao^.ip_alt:=0;
          datao^.port_server:=0;
          datao^.port_user:=0;
          datao^.ip_user:=0;
          datao^.ip_server:=0;
       end else begin
         node_child:=node.firstchild;
         data_child:=getdata(node_child);
       end;

        node_new:=addchild(node);
         data_new:=getdata(node_new);
        with data_new^ do begin
          ip_user:=presult_globale_search^.ip_user;
          port_user:=presult_globale_search^.port_user;
          ip_server:=presult_globale_search^.ip_server;
          port_server:=presult_globale_search^.port_server;
          ip_alt:=presult_globale_search^.ip_alt;
          amime:=datao^.amime;
          fsize:=datao^.fsize;
          nickname:=presult_globale_search^.nickname;
          up_count:=presult_globale_search^.up_count;
          up_limit:=presult_globale_search^.up_limit;
          queued:=presult_globale_search^.queued;
           hash_sha1:=datao^.hash_sha1;
           crcsha1:=datao^.crcsha1;
          title:=presult_globale_search^.title;
          artist:=presult_globale_search^.artist;
          album:=presult_globale_search^.album;
          category:=presult_globale_search^.category;
          language:=presult_globale_search^.language;
          comments:=presult_globale_search^.comments;
          url:=presult_globale_search^.url;
          data:=presult_globale_search^.data;
          vidinfo:=presult_globale_search^.vidinfo;
          keyword_genre:=presult_globale_search^.keyword_genre;
          filename:=presult_globale_search^.filename;
          param1:=presult_globale_search^.param1;
          param2:=presult_globale_search^.param2;
          param3:=presult_globale_search^.param3;
          already_in_lib:=datao^.already_in_lib;
          being_downloaded:=datao^.being_downloaded;
          downloaded:=datao^.downloaded;
          imageindex:=data_child^.imageindex;
         end;

      datao^.nickname:=inttostr(node.childcount)+' '+GetLangStringA(STR_USERS);
      exit;
  end;   //while

end;



  with pannello_result^.listview do begin
       node_new:=addchild(nil);
         data_new:=getdata(node_new);
         with data_new^ do begin
          ip_user:=presult_globale_search^.ip_user;
          port_user:=presult_globale_search^.port_user;
          ip_server:=presult_globale_search^.ip_server;
          port_server:=presult_globale_search^.port_server;
          ip_alt:=presult_globale_search^.ip_alt;
          amime:=presult_globale_search^.amime;
          fsize:=presult_globale_search^.fsize;
          nickname:=presult_globale_search^.nickname;
          up_count:=presult_globale_search^.up_count;
          up_limit:=presult_globale_search^.up_limit;
          queued:=presult_globale_search^.queued;
          hash_sha1:=presult_globale_search^.hash_sha1;
          crcsha1:=presult_globale_search^.crcsha1;
          title:=presult_globale_search^.title;
          artist:=presult_globale_search^.artist;
          album:=presult_globale_search^.album;
          category:=presult_globale_search^.category;
          language:=presult_globale_search^.language;
          comments:=presult_globale_search^.comments;
          url:=presult_globale_search^.url;
          data:=presult_globale_search^.data;
          vidinfo:=presult_globale_search^.vidinfo;
          keyword_genre:=presult_globale_search^.keyword_genre;
          filename:=presult_globale_search^.filename;
          param1:=presult_globale_search^.param1;
          param2:=presult_globale_search^.param2;
          param3:=presult_globale_search^.param3;

               in_progress:=(is_in_progress_sha1(presult_globale_search^.hash_sha1));
               if in_progress then chatclient_add_source_download_fromresult(presult_globale_search);//synch

                already_in_lib:=(is_in_lib_sha1(presult_globale_search^.hash_sha1));
                being_downloaded:=(in_progress);

         downloaded:=false;
               imageindex:=amime_to_imgindexsmall(presult_globale_search^.amime);

         end;//with data_new
     end;//with listview

     
     with pannello_result^ do begin
           inc(countresult);
           if (countresult mod 25)=0 then begin
            listview.endupdate;
            is_adding_result:=false;
           end;
     end;
end;

procedure deal_with_regular_folder_browse(list:tmylist; treeview2:tcomettree);//synch
var
i:integer;
pfile:precord_file_library;
begin

 for i:=0 to list.count-1 do begin
   pfile:=list[i];
   if pos('\',pfile^.path)<>0 then add_regular_folder_browse(treeview2,pfile);
 end;

end;

procedure add_regular_folder_browse(tree:tcomettree; pfile:precord_file_library);
var
utf8_path:string;
crcpath:word;
i:integer;
data_sharedfolder,data:ares_types.precord_cartella_share;
destination_path,actual_path:widestring;
nodo_sharedfolder,nodo_root:pCmtVnode;
begin

destination_path:=extract_fpathW(utf8strtowidestr(pfile^.path))+'\';


nodo_root:=tree.getfirst;
if nodo_root=nil then begin
 nodo_root:=tree.addchild(nil);
  data:=tree.getdata(nodo_root);
  with data^ do begin
   path:=GetLangStringW(STR_SHARED_FOLDERS);
   items:=0;
   items_shared:=0;
  end;
end;


i:=1;
repeat
 inc(i);
  if i>length(destination_path) then exit;//security

    if destination_path[i]='\' then actual_path:=copy(destination_path,1,i-1)
     else continue;

       utf8_path:=widestrtoutf8str(actual_path);
       crcpath:=stringcrc(utf8_path,true);

 nodo_sharedfolder:=find_node_browsefold(tree,utf8_path,crcpath);
  if nodo_sharedfolder=nil then begin
   nodo_sharedfolder:=tree.addchild(nodo_root);
    data_sharedfolder:=tree.getdata(nodo_sharedfolder);
    data_sharedfolder^.path:=actual_path;
    data_sharedfolder^.path_utf8:=utf8_path;
    data_sharedfolder^.crcpath:=crcpath;
    data_sharedfolder^.items:=0;
    data_sharedfolder^.items_shared:=0;
    data_sharedfolder^.display_path:=widestrtoutf8str(extract_fnameW(actual_path));
    data_sharedfolder^.id:=random(40000)+500;
  end;

   if actual_path+'\'=destination_path then begin
    data_sharedfolder:=tree.getdata(nodo_sharedfolder);
        inc(data_sharedfolder^.items_shared);
        inc(data_sharedfolder^.items);
        pfile^.folder_id:=data_sharedfolder^.id;
         exit;
   end;

   nodo_root:=nodo_sharedfolder;

 if i>1000 then exit;
until (not true);


end;


function find_node_browsefold(tree:tcomettree; pathS:string; crcpath:word):pCmtVnode;
var
i:integer;
pfolder:precord_cartella_share;
node_root:pCmtVnode;
begin
result:=nil;

with tree do begin
 node_root:=getfirst;

 i:=0;
 repeat
 if i=0 then result:=getfirstchild(node_root)
  else result:=getnext(result);
  if result=nil then exit;
  inc(i);

  pfolder:=getdata(result);

  if pfolder^.crcpath=crcpath then
   if pfolder^.path_utf8=pathS then exit;

 until (not true);
end;


end;

end.
