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
window shown when chat helper buttons have been pressed (smileys)
}

unit ufrmemoticon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntExtCtrls, TntStdCtrls;

type
  Tfrmemoticon = class(TForm)
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    memo: ttntmemo;
    edit: ttntedit;
  end;

var
  frmemoticon: Tfrmemoticon;

implementation

uses ufrmmain;

{$R *.dfm}

procedure Tfrmemoticon.FormDeactivate(Sender: TObject);
begin
  close;
end;

procedure Tfrmemoticon.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := cafree;
end;

procedure Tfrmemoticon.FormPaint(Sender: TObject);
var x, y, i: integer;
  r: trect;

begin
  canvas.pen.color := clgray;
  canvas.brush.color := clgray;
  r.lefT := 0;
  r.top := 0;
  r.bottom := 1;
  r.right := width;
  canvas.framerect(r);

  r.lefT := 0;
  r.top := 0;
  r.bottom := height;
  r.right := 1;
  canvas.framerect(r);

  r.lefT := width - 1;
  r.top := 0;
  r.bottom := height;
  r.right := width;
  canvas.framerect(r);

  r.lefT := 0;
  r.top := height - 1;
  r.bottom := height;
  r.right := width;
  canvas.framerect(r);

  x := 4;
  y := 4;
  for i := 0 to 9 do begin
    ares_frmmain.imglist_emotic.draw(canvas, x, y, i, true);
    inc(x, 22);
  end;

  y := 24;
  x := 4;
  for i := 10 to 19 do begin
    ares_frmmain.imglist_emotic.draw(canvas, x, y, i, true);
    inc(x, 22);
  end;

  y := 46;
  x := 4;
  for i := 20 to 29 do begin
    ares_frmmain.imglist_emotic.draw(canvas, x, y, i, true);
    inc(x, 22);
  end;

  y := 68;
  x := 4;
  for i := 30 to 39 do begin
    ares_frmmain.imglist_emotic.draw(canvas, x, y, i, true);
    inc(x, 22);
  end;

  y := 90;
  x := 4;
  for i := 40 to 46 do begin
    ares_frmmain.imglist_emotic.draw(canvas, x, y, i, true);
    inc(x, 22);
  end;

end;

procedure Tfrmemoticon.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  with canvas do begin
    pen.color := $00FEFFFF;
    brush.color := $00FEFFFF;
    FrameRect(rect(2, 2, 22, 22)); //clear cells
    FrameRect(rect(24, 2, 44, 22)); //clear cells
    FrameRect(rect(46, 2, 66, 22)); //clear cells
    FrameRect(rect(68, 2, 88, 22)); //clear cells
    FrameRect(rect(90, 2, 110, 22)); //clear cells
    FrameRect(rect(112, 2, 132, 22)); //clear cells
    FrameRect(rect(134, 2, 154, 22)); //clear cells
    FrameRect(rect(156, 2, 176, 22)); //clear cells
    FrameRect(rect(178, 2, 198, 22)); //clear cells
    FrameRect(rect(200, 2, 220, 22)); //clear cells

    FrameRect(rect(2, 22, 22, 42)); //clear cells
    FrameRect(rect(24, 22, 44, 42)); //clear cells
    FrameRect(rect(46, 22, 66, 42)); //clear cells
    FrameRect(rect(68, 22, 88, 42)); //clear cells
    FrameRect(rect(90, 22, 110, 42)); //clear cells
    FrameRect(rect(112, 22, 132, 42)); //clear cells
    FrameRect(rect(134, 22, 154, 42)); //clear cells
    FrameRect(rect(156, 22, 176, 42)); //clear cells
    FrameRect(rect(178, 22, 198, 42)); //clear cells
    FrameRect(rect(200, 22, 220, 42)); //clear cells

    FrameRect(rect(2, 44, 22, 64)); //clear cells
    FrameRect(rect(24, 44, 44, 64)); //clear cells
    FrameRect(rect(46, 44, 66, 64)); //clear cells
    FrameRect(rect(68, 44, 88, 64)); //clear cells
    FrameRect(rect(90, 44, 110, 64)); //clear cells
    FrameRect(rect(112, 44, 132, 64)); //clear cells
    FrameRect(rect(134, 44, 154, 64)); //clear cells
    FrameRect(rect(156, 44, 176, 64)); //clear cells
    FrameRect(rect(178, 44, 198, 64)); //clear cells
    FrameRect(rect(200, 44, 220, 64)); //clear cells

    FrameRect(rect(2, 66, 22, 86)); //clear cells
    FrameRect(rect(24, 66, 44, 86)); //clear cells
    FrameRect(rect(46, 66, 66, 86)); //clear cells
    FrameRect(rect(68, 66, 88, 86)); //clear cells
    FrameRect(rect(90, 66, 110, 86)); //clear cells
    FrameRect(rect(112, 66, 132, 86)); //clear cells
    FrameRect(rect(134, 66, 154, 86)); //clear cells
    FrameRect(rect(156, 66, 176, 86)); //clear cells
    FrameRect(rect(178, 66, 198, 86)); //clear cells
    FrameRect(rect(200, 66, 220, 86)); //clear cells

    FrameRect(rect(2, 88, 22, 108)); //clear cells
    FrameRect(rect(24, 88, 44, 108)); //clear cells
    FrameRect(rect(46, 88, 66, 108)); //clear cells
    FrameRect(rect(68, 88, 88, 108)); //clear cells
    FrameRect(rect(90, 88, 110, 108)); //clear cells
    FrameRect(rect(112, 88, 132, 108)); //clear cells
    FrameRect(rect(134, 88, 154, 108)); //clear cells
    FrameRect(rect(156, 88, 176, 108)); //clear cells
    FrameRect(rect(178, 88, 198, 108)); //clear cells
    FrameRect(rect(200, 88, 220, 108)); //clear cells

    pen.color := clpurple;
    brush.color := clpurple;
    if y < 24 then begin
      if x < 24 then begin
        FrameRect(rect(2, 2, 22, 22));
      end else
        if x < 46 then begin //row#2
          FrameRect(rect(24, 2, 44, 22)); //clear cells
        end else
          if x < 68 then begin //row#3
            FrameRect(rect(46, 2, 66, 22)); //clear cells
          end else
            if x < 90 then begin //row#4
              FrameRect(rect(68, 2, 88, 22)); //clear cells
            end else
              if x < 112 then begin //row#5
                FrameRect(rect(90, 2, 110, 22)); //clear cells
              end else
                if x < 134 then begin //row#6
                  FrameRect(rect(112, 2, 132, 22)); //clear cells
                end else
                  if x < 156 then begin //row#7
                    FrameRect(rect(134, 2, 154, 22)); //clear cells
                  end else
                    if x < 178 then begin //row#8
                      FrameRect(rect(156, 2, 176, 22)); //clear cells
                    end else
                      if x < 200 then begin //row#9
                        FrameRect(rect(178, 2, 198, 22)); //clear cells
                      end else
                      begin //row#10 lol
                        FrameRect(rect(200, 2, 220, 22)); //clear cells
                      end;
    end else
      if y < 46 then begin
        if x < 24 then begin
          FrameRect(rect(2, 22, 22, 42));
        end else
          if x < 46 then begin //row#2
            FrameRect(rect(24, 22, 44, 42)); //clear cells
          end else
            if x < 68 then begin //row#3
              FrameRect(rect(46, 22, 66, 42)); //clear cells
            end else
              if x < 90 then begin //row#4
                FrameRect(rect(68, 22, 88, 42)); //clear cells
              end else
                if x < 112 then begin //row#5
                  FrameRect(rect(90, 22, 110, 42)); //clear cells
                end else
                  if x < 134 then begin //row#6
                    FrameRect(rect(112, 22, 132, 42)); //clear cells
                  end else
                    if x < 156 then begin //row#7
                      FrameRect(rect(134, 22, 154, 42)); //clear cells
                    end else
                      if x < 178 then begin //row#8
                        FrameRect(rect(156, 22, 176, 42)); //clear cells
                      end else
                        if x < 200 then begin //row#9
                          FrameRect(rect(178, 22, 198, 42)); //clear cells
                        end else
                        begin //row#10 lol
                          FrameRect(rect(200, 22, 220, 42)); //clear cells
                        end;
      end else
        if y < 68 then begin
          if x < 24 then begin
            FrameRect(rect(2, 44, 22, 64));
          end else
            if x < 46 then begin //row#2
              FrameRect(rect(24, 44, 44, 64)); //clear cells
            end else
              if x < 68 then begin //row#3
                FrameRect(rect(46, 44, 66, 64)); //clear cells
              end else
                if x < 90 then begin //row#4
                  FrameRect(rect(68, 44, 88, 64)); //clear cells
                end else
                  if x < 112 then begin //row#5
                    FrameRect(rect(90, 44, 110, 64)); //clear cells
                  end else
                    if x < 134 then begin //row#6
                      FrameRect(rect(112, 44, 132, 64)); //clear cells
                    end else
                      if x < 156 then begin //row#7
                        FrameRect(rect(134, 44, 154, 64)); //clear cells
                      end else
                        if x < 178 then begin //row#8
                          FrameRect(rect(156, 44, 176, 64)); //clear cells
                        end else
                          if x < 200 then begin //row#9
                            FrameRect(rect(178, 44, 198, 64)); //clear cells
                          end else
                          begin //row#10 lol
                            FrameRect(rect(200, 44, 220, 64)); //clear cells
                          end;
        end else
          if y < 90 then begin
            if x < 24 then begin
              FrameRect(rect(2, 66, 22, 86));
            end else
              if x < 46 then begin //row#2
                FrameRect(rect(24, 66, 44, 86)); //clear cells
              end else
                if x < 68 then begin //row#3
                  FrameRect(rect(46, 66, 66, 86)); //clear cells
                end else
                  if x < 90 then begin //row#4
                    FrameRect(rect(68, 66, 88, 86)); //clear cells
                  end else
                    if x < 112 then begin //row#5
                      FrameRect(rect(90, 66, 110, 86)); //clear cells
                    end else
                      if x < 134 then begin //row#6
                        FrameRect(rect(112, 66, 132, 86)); //clear cells
                      end else
                        if x < 156 then begin //row#7
                          FrameRect(rect(134, 66, 154, 86)); //clear cells
                        end else
                          if x < 178 then begin //row#8
                            FrameRect(rect(156, 66, 176, 86)); //clear cells
                          end else
                            if x < 200 then begin //row#9
                              FrameRect(rect(178, 66, 198, 86)); //clear cells
                            end else
                            begin //row#10 lol
                              FrameRect(rect(200, 66, 220, 86)); //clear cells
                            end;
          end else begin
            if x < 24 then begin
              FrameRect(rect(2, 88, 22, 108));
            end else
              if x < 46 then begin //row#2
                FrameRect(rect(24, 88, 44, 108)); //clear cells
              end else
                if x < 68 then begin //row#3
                  FrameRect(rect(46, 88, 66, 108)); //clear cells
                end else
                  if x < 90 then begin //row#4
                    FrameRect(rect(68, 88, 88, 108)); //clear cells
                  end else
                    if x < 112 then begin //row#5
                      FrameRect(rect(90, 88, 110, 108)); //clear cells
                    end else
                      if x < 134 then begin //row#6
                        FrameRect(rect(112, 88, 132, 108)); //clear cells
                      end else
                        if x < 156 then begin //row#7
                          FrameRect(rect(134, 88, 154, 108)); //clear cells
                        end;
          end;
  end;
end;

procedure Tfrmemoticon.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//trigger emoticon!

  if y < 24 then begin
    if x < 24 then begin // :-)  imgindex 0
      if edit <> nil then edit.text := edit.text + chr(58) + chr(45) + chr(41) {':-)'}
      else memo.text := memo.text + chr(58) + chr(45) + chr(41) {':-)'};
    end else
      if x < 46 then begin // :-D   imgindex 1
        if edit <> nil then edit.text := edit.text + chr(58) + chr(45) + chr(68) {':-D'}
        else memo.text := memo.text + chr(58) + chr(45) + chr(68) {':-D'};
      end else
        if x < 68 then begin // ;-)      imgindex 2
          if edit <> nil then edit.text := edit.text + chr(59) + chr(45) + chr(41) {';-)'}
          else memo.text := memo.text + chr(59) + chr(45) + chr(41) {';-)'};
        end else
          if x < 90 then begin // :-O   imgindex 3
            if edit <> nil then edit.text := edit.text + chr(58) + chr(45) + chr(79) {':-O'}
            else memo.text := memo.text + chr(58) + chr(45) + chr(79) {':-O'};
          end else
            if x < 112 then begin // :-P
              if edit <> nil then edit.text := edit.text + chr(58) + chr(45) + chr(80) {':-P'}
              else memo.text := memo.text + chr(58) + chr(45) + chr(80) {':-P'};
            end else
              if x < 134 then begin // :@
                if edit <> nil then edit.text := edit.text + chr(40) + chr(72) + chr(41) {'(H)'}
                else memo.text := memo.text + chr(40) + chr(72) + chr(41) {'(H)'};
              end else
                if x < 156 then begin // :$
                  if edit <> nil then edit.text := edit.text + chr(58) + chr(64) {':@'}
                  else memo.texT := memo.text + chr(58) + chr(64) {':@'};
                end else
                  if x < 178 then begin // :-S
                    if edit <> nil then edit.text := edit.text + chr(58) + chr(36) {':$'}
                    else memo.text := memo.text + chr(58) + chr(36) {':$'};
                  end else
                    if x < 200 then begin // :-(
                      if edit <> nil then edit.text := edit.text + chr(58) + chr(45) + chr(83) {':-S'}
                      else memo.text := memo.text + chr(58) + chr(45) + chr(83) {':-S'};
                    end else
                    begin // :'(
                      if edit <> nil then edit.text := edit.text + chr(58) + chr(45) + chr(40) {':-('}
                      else memo.text := memo.text + chr(58) + chr(45) + chr(40) {':-('};
                    end;
  end else
    if y < 46 then begin
      if x < 24 then begin //11  :-|
        if edit <> nil then edit.text := edit.text + chr(58) + chr(39) + chr(40) {':''('}
        else memo.text := memo.text + chr(58) + chr(39) + chr(40) {':''('};
      end else
        if x < 46 then begin //row#12 (6)
          if edit <> nil then edit.text := edit.text + chr(58) + chr(45) + chr(124) {':-|'}
          else memo.text := memo.text + chr(58) + chr(45) + chr(124) {':-|'};
        end else
          if x < 68 then begin //row#13
            if edit <> nil then edit.text := edit.text + chr(40) + chr(54) + chr(41) {'(6)'}
            else memo.text := memo.text + chr(40) + chr(54) + chr(41) {'(6)'};
          end else
            if x < 90 then begin //row#14
              if edit <> nil then edit.text := edit.text + chr(40) + chr(65) + chr(41) {'(A)'}
              else memo.text := memo.text + chr(40) + chr(65) + chr(41) {'(A)'};
            end else
              if x < 112 then begin //row#15
                if edit <> nil then edit.text := edit.text + chr(40) + chr(76) + chr(41) {'(L)'}
                else memo.text := memo.text + chr(40) + chr(76) + chr(41) {'(L)'};
              end else
                if x < 134 then begin //row#16
                  if edit <> nil then edit.text := edit.text + chr(40) + chr(85) + chr(41) {'(U)'}
                  else memo.text := memo.text + chr(40) + chr(85) + chr(41) {'(U)'};
                end else
                  if x < 156 then begin //row#17
                    if edit <> nil then edit.text := edit.text + chr(40) + chr(77) + chr(41) {'(M)'}
                    else memo.text := memo.text + chr(40) + chr(77) + chr(41) {'(M)'};
                  end else
                    if x < 178 then begin //row#18
                      if edit <> nil then edit.text := edit.text + chr(40) + chr(64) + chr(41) {'(@)'}
                      else memo.text := memo.text + chr(40) + chr(64) + chr(41) {'(@)'};
                    end else
                      if x < 200 then begin //row#19
                        if edit <> nil then edit.text := edit.text + chr(40) + chr(38) + chr(41) {'(&)'}
                        else memo.text := memo.text + chr(40) + chr(38) + chr(41) {'(&)'};
                      end else
                      begin //row#20 lol
                        if edit <> nil then edit.text := edit.text + chr(40) + chr(83) + chr(41) {'(S)'}
                        else memo.text := memo.text + chr(40) + chr(83) + chr(41) {'(S)'};
                      end;
    end else
      if y < 68 then begin
        if x < 24 then begin //21
          if edit <> nil then edit.text := edit.text + chr(40) + chr(42) + chr(41) {'(*)'}
          else memo.text := memo.text + chr(40) + chr(42) + chr(41) {'(*)'};
        end else
          if x < 46 then begin //row#22
            if edit <> nil then edit.text := edit.text + chr(40) + chr(126) + chr(41) {'(~)'}
            else memo.texT := memo.text + chr(40) + chr(126) + chr(41) {'(~)'};
          end else
            if x < 68 then begin //row#23
              if edit <> nil then edit.text := edit.text + chr(40) + chr(69) + chr(41) {'(E)'}
              else memo.texT := memo.text + chr(40) + chr(69) + chr(41) {'(E)'};
            end else
              if x < 90 then begin //row#24
                if edit <> nil then edit.text := edit.text + chr(40) + chr(56) + chr(41) {'(8)'}
                else memo.text := memo.text + chr(40) + chr(56) + chr(41) {'(8)'};
              end else
                if x < 112 then begin //row#25
                  if edit <> nil then edit.text := edit.text + chr(40) + chr(70) + chr(41) {'(F)'}
                  else memo.text := memo.text + chr(40) + chr(70) + chr(41) {'(F)'};
                end else
                  if x < 134 then begin //row#26
                    if edit <> nil then edit.text := edit.text + chr(40) + chr(87) + chr(41) {'(W)'}
                    else memo.texT := memo.text + chr(40) + chr(87) + chr(41) {'(W)'};
                  end else
                    if x < 156 then begin //row#27
                      if edit <> nil then edit.text := edit.text + chr(40) + chr(79) + chr(41) {'(O)'}
                      else memo.texT := memo.text + chr(40) + chr(79) + chr(41) {'(O)'};
                    end else
                      if x < 178 then begin //row#28
                        if edit <> nil then edit.text := edit.text + chr(40) + chr(75) + chr(41) {'(K)'}
                        else memo.text := memo.text + chr(40) + chr(75) + chr(41) {'(K)'};
                      end else
                        if x < 200 then begin //row#29
                          if edit <> nil then edit.text := edit.text + chr(40) + chr(71) + chr(41) {'(G)'}
                          else memo.texT := memo.text + chr(40) + chr(71) + chr(41) {'(G)'};
                        end else
                        begin //row#30 lol
                          if edit <> nil then edit.text := edit.text + chr(40) + chr(94) + chr(41) {'(^)'}
                          else memo.text := memo.text + chr(40) + chr(94) + chr(41) {'(^)'};
                        end;
      end else
        if y < 90 then begin
          if x < 24 then begin //31
            if edit <> nil then edit.text := edit.text + chr(40) + chr(80) + chr(41) {'(P)'}
            else memo.text := memo.text + chr(40) + chr(80) + chr(41) {'(P)'};
          end else
            if x < 46 then begin //row#2
              if edit <> nil then edit.text := edit.text + chr(40) + chr(73) + chr(41) {'(I)'}
              else memo.text := memo.text + chr(40) + chr(73) + chr(41) {'(I)'};
            end else
              if x < 68 then begin //row#3
                if edit <> nil then edit.text := edit.text + chr(40) + chr(67) + chr(41) {'(C)'}
                else memo.texT := memo.text + chr(40) + chr(67) + chr(41) {'(C)'};
              end else
                if x < 90 then begin //row#4
                  if edit <> nil then edit.text := edit.text + chr(40) + chr(84) + chr(41) {'(T)'}
                  else memo.text := memo.text + chr(40) + chr(84) + chr(41) {'(T)'};
                end else
                  if x < 112 then begin //row#5
                    if edit <> nil then edit.text := edit.text + chr(40) + chr(123) + chr(41) //'({)'
                    else memo.text := memo.text + chr(40) + chr(123) + chr(41); //'({)';
                  end else
                    if x < 134 then begin //row#6
                      if edit <> nil then edit.text := edit.text + chr(40) + chr(125) + chr(41) //'(})'
                      else memo.text := memo.text + chr(40) + chr(125) + chr(41); //'(})'};
                    end else
                      if x < 156 then begin //row#7
                        if edit <> nil then edit.text := edit.text + chr(40) + chr(66) + chr(41) {'(B)'}
                        else memo.text := memo.text + chr(40) + chr(66) + chr(41) {'(B)'};
                      end else
                        if x < 178 then begin //row#8
                          if edit <> nil then edit.text := edit.text + chr(40) + chr(68) + chr(41) {'(D)'}
                          else memo.text := memo.text + chr(40) + chr(68) + chr(41) {'(D)'};
                        end else
                          if x < 200 then begin //row#9
                            if edit <> nil then edit.text := edit.text + chr(40) + chr(90) + chr(41) {'(Z)'}
                            else memo.texT := memo.text + chr(40) + chr(90) + chr(41) {'(Z)'};
                          end else
                          begin //row#10 lol
                            if edit <> nil then edit.text := edit.text + chr(40) + chr(88) + chr(41) {'(X)'}
                            else memo.texT := memo.text + chr(40) + chr(88) + chr(41) {'(X)'};
                          end;
        end else begin
          if x < 24 then begin //40
            if edit <> nil then edit.text := edit.text + chr(40) + chr(89) + chr(41) {'(Y)'}
            else memo.text := memo.text + chr(40) + chr(89) + chr(41) {'(Y)'};
          end else
            if x < 46 then begin //row#2
              if edit <> nil then edit.text := edit.text + chr(40) + chr(78) + chr(41) {'(N)'}
              else memo.text := memo.text + chr(40) + chr(78) + chr(41) {'(N)'};
            end else
              if x < 68 then begin //row#3
                if edit <> nil then edit.text := edit.text + chr(58) + chr(45) + chr(91) {':-['}
                else memo.text := memo.text + chr(58) + chr(45) + chr(91) {':-['};
              end else
                if x < 90 then begin //row#4
                  if edit <> nil then edit.text := edit.text + chr(40) + chr(49) + chr(41) {'(1)'}
                  else memo.text := memo.text + chr(40) + chr(49) + chr(41) {'(1)'};
                end else
                  if x < 112 then begin //row#5
                    if edit <> nil then edit.text := edit.text + chr(40) + chr(50) + chr(41) {'(2)'}
                    else memo.text := memo.text + chr(40) + chr(50) + chr(41) {'(2)'};
                  end else
                    if x < 134 then begin //row#6
                      if edit <> nil then edit.text := edit.text + chr(40) + chr(51) + chr(41) {'(3)'}
                      else memo.text := memo.text + chr(40) + chr(51) + chr(41) {'(3)'};
                    end else
                      if x < 156 then begin //row#7
                        if edit <> nil then edit.text := edit.text + chr(40) + chr(52) + chr(41) {'(4)'}
                        else memo.text := memo.text + chr(40) + chr(52) + chr(41) {'(4)'};
                      end;
        end;

  if edit <> nil then begin
    edit.SetFocus;
    edit.selstart := length(edit.text);
    edit.sellength := 0;
  end else begin
    memo.setfocus;
    memo.selstart := length(memo.text);
    memo.sellength := 0;
  end;

  close;

end;

end.

