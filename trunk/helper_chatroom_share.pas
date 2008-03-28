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
code used by chat_client to share and download from browse/search
}

unit helper_chatroom_share;

interface

uses
ares_types,ares_objects,comettrees,windows,sysutils,
registry,classes2,classes,tntsysutils,cometPageView;

procedure add_result_localsearch(pannello_result:precord_pannello_result_chat; presult:precord_file_result_chat);
procedure add_source_download_result(presult:precord_file_result_chat);//synch
procedure reset_result(presult:precord_file_result_chat);
function browse_chat_destroy(pcanale:precord_canale_chat_visual; pannello_browse:precord_pannello_browse_chat):boolean;

function search_chat_destroy(pcanale:precord_canale_chat_visual; panel_result:precord_pannello_result_chat):boolean;
procedure mainGui_trigger_channelsearch;
procedure mainGui_chat_dl_virfolder;
procedure mainGui_chat_dl_browsedfile;
procedure result_chat_dobrowse;
procedure mainGui_chat_dl_regfolder;
procedure result_chat_add_download(listview:tcomettree);
function is_chatroom_shared_type(shareable_types:byte; tipo:byte):boolean;


implementation

uses
ufrmmain,helper_share_misc,vars_global,helper_unicode,vars_localiz,
helper_urls,const_ares,helper_strings,helper_download_misc,helper_altsources,
helper_chatroom_gui,helper_visual_headers,
helper_combos,helper_mimetypes;


function is_chatroom_shared_type(shareable_types:byte; tipo:byte):boolean;
begin
//000
//+1 audio
//+1 video
//+1 image
//+1 document
//+1 software
//+1 other


result:=false;
case tipo of
 0:result:=(byte((shareable_types shl 7))>=128);
 1:result:=(byte((shareable_types shl 2))>=128);
 3:result:=(byte((shareable_types shl 6))>=128);
 5:result:=(byte((shareable_types shl 3))>=128);
 6:result:=(byte((shareable_types shl 5))>=128);
 7:result:=(byte((shareable_types shl 4))>=128);
end;

end;

procedure result_chat_add_download(listview:tcomettree);
var
node,nodo_child:pCmtVnode;
datao,data_child:precord_file_result_chat;
down:tdownload;
begin
node:=listview.getfirstselected;
if node=nil then exit;

if listview.getnodelevel(node)=1 then node:=node.Parent;

datao:=listview.getdata(node);

if datao^.downloaded then exit;

 if is_in_progress_sha1(datao^.hash_sha1) then begin
  messageboxW(ares_frmmain.handle,pwidechar(GetLangStringW(STR_TRANSFER_ALREADY_IN_PROGRESS)+CRLF+CRLF+'(  '+extract_fnameW(utf8strtowidestr(datao^.filename))+
              '  )'+CRLF+CRLF+GetLangStringW(STR_TAKE_A_LOOK_TO_TRANSFER_TAB)),pwidechar(appname+': '+GetLangStringW(STR_DUPLICATE_REQUEST)),mb_ok+MB_ICONEXCLAMATION);
  exit;
 end else
 if is_in_lib_sha1(datao^.hash_sha1) then begin
  messageboxW(ares_frmmain.handle,pwidechar(GetLangStringW(STR_FILE_ALREADY_IN_LIBRARY)+CRLF+CRLF+GetLangStringW(STR_FILE)+': '+
              extract_fnameW(utf8strtowidestr(datao^.filename))+CRLF+GetLangStringW(STR_SIZE)+': '+format_currency(datao^.fsize)+' '+STR_BYTES+CRLF+CRLF+GetLangStringW(STR_TAKE_A_LOOK_TO_YOUR_LIBRARY)),pwidechar(appname+': '+GetLangStringW(STR_DUPLICATE_FILE)),mb_ok+MB_ICONEXCLAMATION);
  exit;
 end;

down:=start_download(datao);
lista_down_temp.add(down);

 datao^.downloaded:=true;
 listview.invalidatenode(node);

if node.childcount>0 then begin
  nodo_child:=listview.getfirstchild(node);
  if nodo_child=nil then exit;
  data_child:=listview.getdata(nodo_child);
  add_child_chatsource_to_down(down,data_child);
      data_child^.downloaded:=true;
      listview.invalidatenode(nodo_child);
   repeat
    nodo_child:=listview.getnextsibling(nodo_child);
    if nodo_child=nil then exit;
    data_child:=listview.getdata(nodo_child);
     add_child_chatsource_to_down(down,data_child);
        data_child^.downloaded:=true;
        listview.invalidatenode(nodo_child);
   until (not true);

end else add_child_chatsource_to_down(down,datao);

end;

procedure mainGui_chat_dl_regfolder;

     procedure add_this_download(pannello_browse:precord_pannello_browse_chat; pfile:precord_file_library; folder:widestring);
            procedure add_source_download_browse(pannello_browse:precord_pannello_browse_chat; down:tdownload);
            var
            risorsa:trisorsa_download;
            begin
              risorsa:=trisorsa_download.create;
              with risorsa do begin
                 handle_download:=cardinal(down);
                 InsertServer(pannello_browse^.ip_server,pannello_browse^.port_server);
                 ip:=pannello_browse^.ip_user;
                 porta:=pannello_browse^.port_user;
                 ip_interno:=pannello_browse^.ip_alt;
                   if pos('@',pannello_browse^.nick)=0 then nickname:=pannello_browse^.nick+STR_UNKNOWNCLIENT
                    else nickname:=pannello_browse^.nick;
                 tick_attivazione:=0;
                 socket:=nil;
                 download:=down;
                 AddVisualReference;
               end;
                  down.lista_risorse.add(risorsa);
              end;
      var
     down:tdownload;
     begin
      pfile^.downloaded:=true;
      pfile^.being_downloaded:=true;
       down:=start_download(pfile,folder);
        add_source_download_browse(pannello_browse, down);
      lista_down_temp.add(down);
     end;

var
nodo,nodo_child:pCmtVnode;
data:precord_cartella_share;
pfile:precord_file_library;
i,to_cut:integer;
folder:widestring;
folderstr:string;
level:cardinal;
pannello_browse:precord_pannello_browse_chat;
pnl:TCometPagePanel;
begin
try

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activepage];
 if pnl.ID<>IDXChatBrowse then exit;
 pannello_browse:=pnl.fdata;


       nodo:=pannello_browse^.treeview2.getfirstselected;
       if nodo=nil then exit;
       level:=pannello_browse^.treeview2.getnodelevel(nodo);
       data:=pannello_browse^.treeview2.getdata(nodo);

        if length(data^.path)=2 then begin
          folder:='\'+copy(data^.path,1,1)+'_';
          to_cut:=0;
        end else begin
            folder:='\'+extract_fnameW(data^.path);
            to_cut:=length(widestrtoutf8str(data^.path))-length(widestrtoutf8str(folder));  //quanti ne dobbiamo togliere dai child per comunicare a add_this_download
        end;

        for i:=0 to pannello_browse^.lista_files.count-1 do begin    //prima tutti i files contenuti in questa cartella
         pfile:=pannello_browse^.lista_files[i];
         if pfile^.folder_id<>data^.id then continue;
         add_this_download(pannello_browse,pfile,folder);
        end;

        //ora tutti i files contenuti nei child
          nodo_child:=pannello_browse^.treeview2.getnext(nodo);
          while (nodo_child<>nil) do begin

          if pannello_browse^.treeview2.getnodelevel(nodo_child)<=level then break;  //altro nodo, non sono più in childish

             data:=pannello_browse^.treeview2.getdata(nodo_child);

             folderstr:=widestrtoutf8str(data^.path);
             if folderstr[2]=':' then begin  //intero HD!!
              folderstr[2]:='_';
              folderstr:='\'+folderstr; //togliamo due punti e aggiungiamo slash iniziale
             end;

             folder:=utf8strtowidestr(copy(folderstr,to_cut+1,length(folderstr))); //copiamo includendo solo da path main!

             for i:=0 to pannello_browse^.lista_files.count-1 do begin    //prima tutti i files contenuti in questa cartella
              pfile:=pannello_browse^.lista_files[i];
              if pfile^.folder_id<>data^.id then continue;
               add_this_download(pannello_browse,pfile,folder);
             end;
            nodo_child:=pannello_browse^.treeview2.getnext(nodo_child);
            end;

            ufrmmain.ares_frmmain.treeviewbrowse2click(pannello_browse^.treeview2);  //aggiorniamo


 except
 end;
end;

procedure result_chat_dobrowse;
var
z:integer;
pcanale:precord_canale_chat_visual;
nodo,nodo_file:pCmtVnode;
data:precord_file_result_chat;
strrandom,nick:string;
pannello_browse:precord_pannello_browse_chat;
pannello_result:precord_pannello_result_chat;
data_file:precord_file_library;
pnl:TCometPagePanel;
begin

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activepage];
 if pnl.ID<>IDXChatSearch then exit;
 pannello_result:=pnl.fdata;

 if pannello_result.canale=nil then exit;
 pcanale:=pannello_result^.canale;


          nodo:=pannello_result^.listview.GetFirstSelected;
          if nodo=nil then exit;
            data:=pannello_result^.listview.getdata(nodo);

            nick:=data^.nickname;  //togliamo @ del client da result se sono con client_chat e ho client indicato nel nick
            if length(data^.client)=0 then begin
             for z:=length(nick) downto 1 do
               if nick[z]='@' then begin
                 nick:=copy(nick,1,z-1);
                break;
              end;
            end;
            if nick='' then exit;

       strrandom:=chr(random(255))+
                  chr(random(255));
      //ok ora aggiungiamo comando
    pcanale^.out_text.Add('/browse '+strrandom+chr(browse_type)+nick+CHRNULL);

    lockwindowupdate(ares_frmmain.handle);
     try
     pannello_browse:=create_browse_panel(pcanale,nick,data^.ip_user,data^.ip_server,data^.ip_alt,data^.port_user,data^.port_server,strrandom);
     except
      pannello_browse:=nil;
     end;
    lockwindowupdate(0);

    if pannello_browse=nil then exit;
    
    pannello_browse^.stato_header_library:=library_header_browse_in_prog;
     nodo_file:=pannello_browse^.listview.addchild(nil);
      data_file:=pannello_browse^.listview.getdata(nodo_file);
      data_file^.title:=GetLangStringA(STR_BROWSEINPROGRESS)+' '+GetLangStringA(STR_PLEASE_WAIT);
      pannello_browse^.listview.invalidatenode(nodo_file);

end;

procedure mainGui_chat_dl_browsedfile;
var
pannello_browse:precord_pannello_browse_chat;
nodo:pCmtVnode;
data:precord_file_library;
pnl:TCometPagePanel;
begin
try

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activepage];
 if pnl.ID<>IDXChatBrowse then exit;
 
 pannello_browse:=pnl.fdata;



            nodo:=pannello_browse^.listview.GetFirstSelected;
            while (nodo<>nil) do begin

               data:=pannello_browse^.listview.getdata(nodo);
                data^.downloaded:=true;
                data^.being_downloaded:=true;
                add_this_download_from_browse(data,pannello_browse,'');

                pannello_browse^.listview.invalidatenode(nodo);
               nodo:=pannello_browse^.listview.getnextselected(nodo);
             end;


except
end;
end;

procedure mainGui_chat_dl_virfolder;
var
pannello_browse:precord_pannello_browse_chat;
pcanale:precord_canale_chat_visual;

data:ares_types.precord_string;
nodo:pCmtVnode;
level:integer;
 nodoroot,nodoall,nodoaudio,nodoimage,nodovideo,nododocument,nodosoftware,
  nodosoftwarebycompany,nodosoftwarebycategory,
  nododocumentbyauthor,nododocumentbycategory,
  nodovideobycategory,
  nodoimagebyalbum,nodoimagebycategory,
  nodoaudiobyartist,nodoaudiobyalbum,nodoaudiobygenre:pCmtVnode;
tipo:byte;
i,z,h:integer;
pfile:precord_file_library;
match,match1,match2,match3:string;
pnl:TCometPagePanel;
begin
try

 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activepage];
 if pnl.ID<>IDXChatBrowse then exit;
 pannello_browse:=pnl.fdata;

       nodo:=pannello_browse^.treeview.getfirstselected; //primo nodo nella cartella...
       if nodo=nil then exit;
       level:=pannello_browse^.treeview.getnodelevel(nodo);
       if level<>3 then exit;   //livello giusto?

       with pannello_browse^.treeview do begin
           //ora troviamo il tipo e la sottoclasse
           nodoroot:=GetFirst;
           nodoall:=getfirstchild(nodoroot);

           nodoaudio:=GetNextSibling(nodoall);
            nodoaudiobyartist:=getfirstchild(nodoaudio);
            nodoaudiobyalbum:=getnextsibling(nodoaudiobyartist);
            nodoaudiobygenre:=getnextsibling(nodoaudiobyalbum);
           nodoimage:=getnextsibling(nodoaudio);
            nodoimagebyalbum:=getfirstchild(nodoimage);
            nodoimagebycategory:=getnextsibling(nodoimagebyalbum);
           nodovideo:=getnextsibling(nodoimage);
            nodovideobycategory:=getfirstchild(nodovideo);
           nododocument:=getnextsibling(nodovideo);
            nododocumentbyauthor:=getfirstchild(nododocument);
            nododocumentbycategory:=getnextsibling(nododocumentbyauthor);
           nodosoftware:=getnextsibling(nododocument);
            nodosoftwarebycompany:=getfirstchild(nodosoftware);
            nodosoftwarebycategory:=getnextsibling(nodosoftwarebycompany);
         end;

           if nodo.parent.parent=nodoaudio then tipo:=1 else
            if nodo.parent.parent=nodoimage then tipo:=7 else
             if nodo.parent.parent=nodovideo then tipo:=5 else
              if nodo.parent.parent=nododocument then tipo:=6 else
               if nodo.parent.parent=nodosoftware then tipo:=3 else begin
                tipo:=0; //makes compiler happy
                exit;
               end;

            data:=pannello_browse^.treeview.getdata(nodo);
             match:=lowercase(data^.str);
            if match=GetLangStringA(STR_UNKNOW_LOWER) then match:='';


             for i:=0 to pannello_browse^.lista_files.count-1 do begin
                pfile:=pannello_browse^.lista_files[i];
              if pfile^.amime<>tipo then continue;

               if ((nodo.parent.parent<>nodovideo) and (nodo.parent.parent<>nodoimage)) then begin
                 match1:=lowercase(pfile^.artist);
                 match2:=lowercase(pfile^.category);
                 if nodo.parent.parent=nodoaudio then match3:=lowercase(pfile^.album);
               end else
               if nodo.parent.parent=nodovideo then begin
                match1:=lowercase(pfile^.category);
               end else
               if nodo.parent.parent=nodoimage then begin
                match1:=lowercase(pfile^.album);
                match2:=lowercase(pfile^.category);
               end;

               if match1=GetLangStringA(STR_UNKNOW_LOWER) then match1:='';
               if match2=GetLangStringA(STR_UNKNOW_LOWER) then match2:='';
               if match3=GetLangStringA(STR_UNKNOW_LOWER) then match3:='';

             case tipo of
              ARES_MIME_MP3:begin
                 if nodo.parent=nodoaudiobyartist then begin
                  if match1=match then add_this_download_from_browse(pfile,pannello_browse,'');
                 end else
                 if nodo.parent=nodoaudiobyalbum then begin
                  if match3=match then add_this_download_from_browse(pfile,pannello_browse,'');
                 end else
                 if nodo.parent=nodoaudiobygenre then begin
                  if match2=match then add_this_download_from_browse(pfile,pannello_browse,'');
                end;
               end;
             ARES_MIME_IMAGE:begin
                if nodo.parent=nodoimagebyalbum then begin
                 if match1=match then add_this_download_from_browse(pfile,pannello_browse,'');
                end else
                if nodo.parent=nodoimagebycategory then begin
                 if match2=match then add_this_download_from_browse(pfile,pannello_browse,'');
                end;
              end;
             ARES_MIME_VIDEO:begin
                if nodo.parent=nodovideobycategory then begin
                 if match1=match then add_this_download_from_browse(pfile,pannello_browse,'');
                end;
               end;
             ARES_MIME_DOCUMENT:begin
                if nodo.parent=nododocumentbyauthor then begin
                 if match1=match then add_this_download_from_browse(pfile,pannello_browse,'');
                end else
                if nodo.parent=nododocumentbycategory then begin
                 if match2=match then add_this_download_from_browse(pfile,pannello_browse,'');
                end;
               end;
             ARES_MIME_SOFTWARE:begin
                 if nodo.parent=nodosoftwarebycompany then begin
                  if match1=match then add_this_download_from_browse(pfile,pannello_browse,'');
                 end else
                 if nodo.parent=nodosoftwarebycategory then begin
                  if match2=match then add_this_download_from_browse(pfile,pannello_browse,'');
                 end;
              end;
           end; //case
         end;//for files browse

           ufrmmain.ares_frmmain.treeviewbrowseclick(pannello_browse^.treeview);


except
end;

end;


procedure mainGui_trigger_channelsearch;
var
  reg:tregistry;
  lista:tstringlist;
  strwide:widestring;
  i:integer;
  pcanale:ares_types.precord_canale_chat_visual;
  randomstr,str,str_temp:string;
  inizio:integer;
//pannello_result:ares_types.precord_pannello_result_chat;
pnl:TCometPagePanel;
begin
with ares_frmmain do begin

if length(combo_chat_search.text)<2 then exit;

 strwide:=combo_chat_search.text;

 i:=1;
 while (i<length(strwide)) do begin
      if integer(strwide[i])=32 then
       if integer(strwide[i+1])=32 then begin
        delete(strwide,i,1);
        i:=0;
       end;
      inc(i);
 end;

 strwide:=Tnt_WideLowerCase(strwide);

 if length(strwide)>0 then
  if integer(strwide[length(strwide)])=32 then delete(strwide,length(strwide),1);
 if length(strwide)>0 then
  if integer(strwide[1])=32 then delete(strwide,1,1);

   combo_chat_search.text:=strwide;

  str_temp:='';
  strwide:=strwide+' ';
  inizio:=-1;
  for i:=1 to length(strwide) do begin
     if inizio=-1 then begin
      if integer(strwide[i])<>32 then inizio:=i;
     end else begin
       if integer(strwide[i])=32 then begin
        str_temp:=str_temp+widestrtoutf8str(copy(strwide,inizio,i-inizio))+CHRNULL;
        inizio:=-1;
       end;
     end;
  end;

reg:=tregistry.create;
 with reg do begin
   openkey(areskey+'Search.History\gen.gen',true);
   lista:=tstringlist.create;
   getvaluenames(lista);
   delete_excedent_history(reg,lista);
   lista.free;
   if add_tntcombo_history(combo_chat_search) then writestring(bytestr_to_hexstr(widestrtoutf8str(combo_chat_search.text)),'');
 closekey;
 destroy;
 end;

       randomstr:=chr(random(255))+
                  chr(random(255));

       str:='/search '+randomstr+
                       CHRNULL+  //only queued on?
                       chr(combo_to_mimetype(combo_chat_srctypes))+
                       int_2_word_string(length(str_temp))+
                       str_temp;


 pnl:=ares_frmmain.panel_chat.panels[ares_frmmain.panel_chat.activepage];
 pcanale:=pnl.fdata;

     lockwindowupdate(ares_frmmain.handle);
      //pannello_result:=
      create_result_panel(pcanale,randomstr,combo_chat_search.text);
     lockwindowupdate(0);

     pcanale^.out_text.add(str);


end;
end;


function search_chat_destroy(pcanale:precord_canale_chat_visual; panel_result:precord_pannello_result_chat):boolean;
var
i:integer;
temp:precord_pannello_result_chat;
begin
result:=false;
try

if pcanale=nil then begin    // is it detached?
   if panel_result^.listview.selectable then header_search_chat_save(panel_result^.tiporicerca,panel_result^.listview);
   panel_result^.containerPanel.free;
   panel_result^.randomstr:='';
   FreeMem(panel_result,sizeof(record_pannello_result_chat));
 exit;
end;

except
end;


try

with pcanale^ do begin
 if lista_pannelli_result=nil then exit;


for i:=0 to lista_pannelli_result.count-1 do begin
 temp:=lista_pannelli_result[i];
 if temp=panel_result then begin
   lista_pannelli_result.delete(i);
    if panel_result^.listview.selectable then header_search_chat_save(panel_result^.tiporicerca,panel_result^.listview);
   panel_result^.containerPanel.free;
   panel_result^.randomstr:='';
   FreeMem(panel_result,sizeof(record_pannello_result_chat));

   if lista_pannelli_result.count=0 then begin
    lista_pannelli_result.free;
    lista_pannelli_result:=nil;
   end;

   result:=true;
   exit;
 end;

end;
end;

except
end;
end;


function browse_chat_destroy(pcanale:precord_canale_chat_visual; pannello_browse:precord_pannello_browse_chat):boolean;

 procedure FreeBrowse(pannello_browse:precord_pannello_browse_chat);
 var
 pfile:precord_file_library;
 begin
   with pannello_browse^ do begin
    nick:='';

    randomstr:='';

          while (lista_files.count>0) do begin  // clear files
           pfile:=lista_files[lista_files.count-1];
                  lista_files.delete(lista_files.count-1);
             with pfile^ do begin
              album:='';
              artist:='';
              category:='';
              mediatype:='';
              vidinfo:='';
              comment:='';
              language:='';
              path:='';
              title:='';
              url:='';
              year:='';
              hash_sha1:='';
              hash_of_phash:='';
              ext:='';
              keywords_genre:='';
             end;
           FreeMem(pfile,sizeof(record_file_library));
          end;
         lista_files.free;

    containerPanel.free;
   end;
   FreeMem(pannello_browse,sizeof(record_pannello_browse_chat));
 end;

var
i:integer;
temp:precord_pannello_browse_chat;
begin
result:=false;

try

if pcanale=nil then begin // is it detached?
 FreeBrowse(pannello_browse);
 exit;
end;

except
end;


try
if pcanale^.lista_pannelli_browse=nil then exit;

i:=0;
while (i<pcanale^.lista_pannelli_browse.count) do begin
 temp:=pcanale^.lista_pannelli_browse[i];

 if pannello_browse<>temp then begin
  inc(i);
  continue;
 end;

   pcanale^.lista_pannelli_browse.delete(i);

   FreeBrowse(pannello_browse);

   result:=true;

   if pcanale^.lista_pannelli_browse.count=0 then begin
    pcanale^.lista_pannelli_browse.free;
    pcanale^.lista_pannelli_browse:=nil;
   end;

   exit;

end;


except
end;
end;

procedure reset_result(presult:precord_file_result_chat);
begin
 with presult^ do begin
   hash_sha1:='';
   filename:='';
   nickname:='';
   title:='';
   artist:='';
   album:='';
   category:='';
   language:='';
   data:='';
   url:='';
   client:='';
   comments:='';
   vidinfo:='';
   keyword_genre:='';
   param1:=0;
   param2:=0;
   param3:=0;
 end;
end;

procedure add_source_download_result(presult:precord_file_result_chat);//synch
var
risorsa:trisorsa_download;
node:pCmtVnode;
dataNode:precord_data_node;
DnData:precord_displayed_download;
crcsha1:word;
fhandle_download:cardinal;
list:tlist;
begin

fhandle_download:=INVALID_HANDLE_VALUE;
try


crcsha1:=crcstring(presult^.hash_sha1);

node:=ares_FrmMain.treeview_download.getfirst;
while (node<>nil) do begin
     dataNode:=ares_FrmMain.treeview_download.getdata(node);
     if dataNode^.m_type<>dnt_download then begin
      node:=ares_FrmMain.treeview_download.getnextsibling(node);
      continue;
     end;

     DnData:=dataNode^.data;
     if DnData^.handle_obj<>INVALID_HANDLE_VALUE then
      if DnData^.crcsha1=crcsha1 then
       if DnData^.hash_sha1=presult^.hash_sha1 then
        if DnData^.hash_sha1<>'' then begin
          fhandle_download:=DnData^.handle_Obj;
          break;
        end;
   node:=ares_FrmMain.treeview_download.getnextsibling(node);
end;

if fhandle_download=INVALID_HANDLE_VALUE then exit;


  risorsa:=trisorsa_download.create;
   with risorsa do begin
    InsertServer(presult^.ip_server,presult^.port_server);
   ip:=presult^.ip_user;
   porta:=presult^.port_user;
   handle_download:=fhandle_download;
   ip_interno:=presult^.ip_alt;
   if pos('@',presult^.nickname)=0 then nickname:=presult^.nickname+STR_UNKNOWNCLIENT
    else nickname:=presult^.nickname;
   tick_attivazione:=0;
   socket:=nil;
  end;
  list:=vars_global.lista_risorse_temp.locklist;
   list.add(risorsa);
  vars_global.lista_risorse_temp.unlocklist;
  
except
end;
end;


procedure add_result_localsearch(pannello_result:precord_pannello_result_chat; presult:precord_file_result_chat);
var
node,node_child,node_new:pCmtVnode;
datao,data_child,data_new:precord_file_result_chat;
is_progress:boolean;
begin

  node:=pannello_result^.listview.getfirst;
  while (node<>nil) do begin

     datao:=pannello_result^.listview.getdata(node);
     if datao^.crcsha1<>presult^.crcsha1 then begin
      node:=pannello_result^.listview.getnextsibling(node);
      continue;
     end else
     if datao^.hash_sha1<>presult^.hash_sha1 then begin
      node:=pannello_result^.listview.getnextsibling(node);
      continue;
     end;

       if node^.FirstChild=nil then begin
        node_child:=pannello_result^.listview.addchild(node);
         data_child:=pannello_result^.listview.getdata(node_child);
         with data_child^ do begin
          ip_user:=datao^.ip_user;
          port_user:=datao^.port_user;
          ip_server:=datao^.ip_server;
          port_server:=datao^.port_server;
          ip_alt:=datao^.ip_alt;
          amime:=datao^.amime;
          fsize:=datao^.fsize;
          nickname:=datao^.nickname;
          client:=datao^.client;
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
         data_child:=pannello_result^.listview.getdata(node_child);
       end;

        node_new:=pannello_result^.listview.addchild(node);
         data_new:=pannello_result^.listview.getdata(node_new);
         with data_new^ do begin
          ip_user:=presult^.ip_user;
          port_user:=presult^.port_user;
          ip_server:=presult^.ip_server;
          port_server:=presult^.port_server;
          ip_alt:=presult^.ip_alt;
          amime:=datao^.amime;
          fsize:=datao^.fsize;
          nickname:=presult^.nickname;
          client:=presult^.client;
          up_count:=presult^.up_count;
          up_limit:=presult^.up_limit;
          queued:=presult^.queued;
          hash_sha1:=datao^.hash_sha1;
          crcsha1:=datao^.crcsha1;
          title:=presult^.title;
          artist:=presult^.artist;
          album:=presult^.album;
          category:=presult^.category;
          language:=presult^.language;
          comments:=presult^.comments;
          url:=presult^.url;
          data:=presult^.data;
          vidinfo:=presult^.vidinfo;
          keyword_genre:=presult^.keyword_genre;
          filename:=presult^.filename;
          param1:=presult^.param1;
          param2:=presult^.param2;
          param3:=presult^.param3;
          already_in_lib:=datao^.already_in_lib;
          being_downloaded:=datao^.being_downloaded;
          downloaded:=datao^.downloaded;
          imageindex:=data_child^.imageindex;
         end;
      datao^.nickname:=inttostr(node.childcount)+' '+GetLangStringA(STR_USERS);
      datao^.client:='';
      exit;
  end;

       node_new:=pannello_result^.listview.addchild(nil);
         data_new:=pannello_result^.listview.getdata(node_new);
         with data_new^ do begin
          ip_user:=presult^.ip_user;
          port_user:=presult^.port_user;
          ip_server:=presult^.ip_server;
          port_server:=presult^.port_server;
          ip_alt:=presult^.ip_alt;
          amime:=presult^.amime;
          fsize:=presult^.fsize;
          nickname:=presult^.nickname;
          client:=presult^.client;
          up_count:=presult^.up_count;
          up_limit:=presult^.up_limit;
          queued:=presult^.queued;
          hash_sha1:=presult^.hash_sha1;
          crcsha1:=presult^.crcsha1;
          title:=presult^.title;
          artist:=presult^.artist;
          album:=presult^.album;
          category:=presult^.category;
          language:=presult^.language;
          comments:=presult^.comments;
          url:=presult^.url;
          data:=presult^.data;
          vidinfo:=presult^.vidinfo;
          keyword_genre:=presult^.keyword_genre;
          filename:=presult^.filename;
          param1:=presult^.param1;
          param2:=presult^.param2;
          param3:=presult^.param3;

         is_progress:=(is_in_progress_sha1(presult^.hash_sha1));
         if is_progress then add_source_download_result(presult);

         already_in_lib:=(is_in_lib_sha1(presult^.hash_sha1));
         being_downloaded:=(is_progress);
         downloaded:=false;
           imageindex:=amime_to_imgindexsmall(presult^.amime);

      end;

end;

end.
