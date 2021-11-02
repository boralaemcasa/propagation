unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    cancelar: boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  s, capitulo: string;
  i, j: integer;
begin
  capitulo := '';
  //memo.hide;
  memo.Lines.LoadFromFile('C:\_VINICIUS CLAUDINO FERRAZ\tenho em pen drive\novo.txt');
  for i := 0 to memo.Lines.Count - 1 do
  begin
    s := memo.lines[i];
    if s[1] = '[' then
    begin
      capitulo := copy(s, 2, pos(']', s) - 2) + ', ';
      memo.Lines.Delete(i);
      s := memo.lines[i];
    end;
    j := pos('.', s);
    if j > 0 then
      s := copy(s, 1, j - 1);
    memo.lines[i] := capitulo + s;
    application.ProcessMessages;
  end;
  //memo.show;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: integer;
  s, capitulo: string;
begin
  cancelar := false;
  capitulo := '';
  memo.clear;
  memo.Lines.LoadFromFile('C:\_VINICIUS CLAUDINO FERRAZ\tenho em pen drive\processa biba\newtestament.txt');
  for i := 0 to memo.lines.count - 1 do
  begin
    if cancelar then
      break;
    s := memo.lines[i];
    if s = 'Chapter 1' then
      capitulo := memo.Lines[i - 1] + ' 1, '
    else if pos('Chapter', s) > 0 then
    begin
      delete(capitulo, pos(' ', capitulo), 5);
      capitulo := capitulo + copy(s, 8, 5) + ', ';
    end;

    try
      if strtoint(s) > 0 then
        memo.lines[i] := capitulo + s;
    except
      application.processmessages;
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  cancelar := true;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i: integer;
  s, capitulo: string;
begin
  cancelar := false;
  capitulo := '';
  memo.clear;
  memo.Lines.LoadFromFile('D:\tenho offline\Delphi\processa biba\newtestament.txt');
  for i := 0 to memo.lines.count - 1 do
  begin
    if cancelar then
      break;
    s := memo.lines[i];
    if pos('Chapter', s) > 0 then
    begin
      memo.Lines.Delete(i);
      s := memo.Lines[i];
    end;
    application.processmessages;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i: integer;
  s, capitulo: string;
begin
  cancelar := false;
  capitulo := '';
  memo.clear;
  memo.Lines.LoadFromFile('C:\_VINICIUS CLAUDINO FERRAZ\tenho em pen drive\processa biba\newtestament.txt');
  for i := 0 to memo.lines.count - 1 do
  begin
    if cancelar then
      break;
    s := memo.lines[i];
    if (pos('0', s) > 0) or (pos('1', s) > 0) or (pos('2', s) > 0) or (pos('3', s) > 0) or (pos('4', s) > 0) or
    (pos('5', s) > 0) or (pos('6', s) > 0) or (pos('7', s) > 0) or (pos('8', s) > 0) or (pos('9', s) > 0) then
    begin
      memo.lines[i] := 'Util.processar("' + s + '",';
      if i > 1 then
        memo.Lines[i - 1] := '"' + memo.Lines[i - 1] + '");';
    end;

    application.processmessages;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  i: integer;
  s, capitulo: string;
begin
  cancelar := false;
  capitulo := '';
  memo.clear;
  memo.Lines.LoadFromFile('C:\_VINICIUS CLAUDINO FERRAZ\tenho em pen drive\processa biba\newtestament.txt');
  for i := 0 to memo.lines.count - 1 do
  begin
    if cancelar then
      break;
    s := memo.lines[i];
    if copy(s, 1, 5) = 'Util.' then
    else if copy(s, length(s) - 2, 3) = '");' then
    else
    begin
      memo.lines[i] := '"' + s + ' " +';
    end;

    application.processmessages;
  end;
end;

end.
