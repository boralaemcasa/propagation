unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    edDir: TLabeledEdit;
    edMask: TLabeledEdit;
    Button1: TButton;
    Memo: TMemo;
    btnPesquisa: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure edDirExit(Sender: TObject);
    procedure btnPesquisaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    cancelar: boolean;
    contador: integer;
    procedure processaDir(nomeDir: string);
  end;

var
  Form1: TForm1;

implementation

uses FileCtrl;

{$R *.dfm}

procedure TForm1.processaDir(nomeDir: string);
var search: TSearchRec;
    f: file of char;
    j: integer;
begin
  if FindFirst(nomeDir + '*.*', faDirectory, search) = 0 then
    repeat
      if (search.name <> '.') and (search.Name <> '..') and DirectoryExists(nomeDir + search.name) then
      begin
        ProcessaDir(nomeDir + search.name + '\');
        if cancelar then
          exit;
      end;
    until FindNext(search) <> 0;

  j := 0;

  if FindFirst(nomeDir + edMask.Text, faArchive, search) = 0 then
    repeat
      inc(j);
      caption := 'Adding: ' + inttostr(j) + ': ' + search.name;

      memo.lines.insert(random(memo.Lines.Count), nomeDir + search.Name);
      inc(contador);
      application.processmessages;
      if cancelar then
        exit;
    until FindNext(search) <> 0;
end;

function Comparar(x, y: string): integer;
var i, j: integer;
begin
  i := pos(';', x);
  i := StrToInt(copy(x, 1, i - 1));
  j := pos(';', y);
  j := StrToInt(copy(y, 1, j - 1));
  if i < j then
    result := -1
  else if i > j then
    result := 1
  else
    result := 0;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Panel1.Enabled := false;
  FileMode := 0;
  memo.lines.clear;
  cancelar := false;
  contador := 0;
  processaDir(edDir.Text);
end;

procedure TForm1.edDirExit(Sender: TObject);
begin
  if (eddir.Text <> '') and (eddir.Text[length(eddir.Text)] <> '\') then
    eddir.Text := eddir.Text + '\';
end;

procedure TForm1.btnPesquisaClick(Sender: TObject);
var s: string;
begin
  if SelectDirectory('Pesquisar em qual pasta?', edDir.text, s) then
  begin
    edDir.Text := s;
    if (eddir.Text <> '') and (eddir.Text[length(eddir.Text)] <> '\') then
      eddir.Text := eddir.Text + '\';
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if paramcount > 0 then
    edDir.Text := paramstr(1);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
  begin
    cancelar := true;
    memo.show; // it's show time
  end
end;

end.
