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
    Memo2: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure edDirExit(Sender: TObject);
    procedure btnPesquisaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    cancelar: boolean;
    contador: integer;
    procedure processaDir(nomeDir: string);
    procedure processarArq(nomeDir, nomeArq: string);
  end;

var
  Form1: TForm1;

implementation

uses FileCtrl;

{$R *.dfm}

procedure TForm1.processaDir(nomeDir: string);
var
  search: TSearchRec;
  j: integer;
begin
  if FindFirst(nomeDir + '*.*', faDirectory, search) = 0 then
    repeat
      if (search.name <> '.') and (search.Name <> '..') and DirectoryExists(nomeDir + search.name) then
        ProcessaDir(nomeDir + search.name + '\');
    until FindNext(search) <> 0;

  memo.Lines.Add('[' + nomeDir + ']');
  memo.Lines.Add('');

  j := 0;

  if FindFirst(nomeDir + edMask.Text, faArchive, search) = 0 then
    repeat
      inc(j);
      caption := inttostr(j) + ': ' + search.name;

   if true then
      begin
        memo.lines.add(search.Name);

        processarArq(nomeDir, search.Name);

        inc(contador);
      end;

      application.processmessages;
      if cancelar then
        exit;
    until FindNext(search) <> 0;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Panel1.Enabled := false;
  FileMode := 0;
  memo.lines.clear;
  memo.lines.add('Pressione ESC para cancelar.');
  memo.lines.add('');

  cancelar := false;
  contador := 1;
  processaDir(edDir.Text);

  if cancelar then
  begin
    memo.lines.add('');
    memo.lines.add('Operação cancelada pelo usuário');
    caption := 'Operação cancelada pelo usuário'
  end
  else
    caption := inttostr(contador - 1) + ' arquivos encontrados';
  Panel1.Enabled := true;
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
    cancelar := true;
end;

procedure TForm1.processarArq(nomeDir, nomeArq: string);
var
  saida, tmp, s: string;
  i, j: integer;
  f: textFile;
begin
  nomedir := stringReplace(nomedir, '/', '\', [rfreplaceall]);
  memo2.lines.LoadFromFile(nomeDir + nomearq);
  s := memo2.text;
  nomedir := stringReplace(nomedir, 'D:\ocaminho\', 'http://ocaminho.com.br/', [rfreplaceall]);
  nomedir := stringReplace(nomedir, '\', '/', [rfreplaceall]);

  saida := 'engolirCaminho(' + inttostr(contador) + ', ';
  delete(s, 1, pos('lang', s) + 5);
  tmp := copy(s, 1, pos('"', s) - 1);
  if tmp = 'pt-br' then
    saida := saida + '1'
  else if tmp = 'EN-US' then
    saida := saida + '4'
  else if tmp = 'la' then
    saida := saida + '3'
  else if saida = 'fr' then
    saida := saida + '5';

  saida := saida + ', ';

  delete(s, 1, pos('<div class="background">', s) + 31);
  if pos('<p class="H8">', s) > 0 then
  s := copy(s, 1, pos('<p class="H8">', s) - 1);
  s := stringReplace(s, '> <', '><', [rfreplaceall]);
  repeat
    i := pos('<img', s);
    if i = 0 then
      break;
    j := 5;
    while s[i + j] <> '>' do
      inc(j);
    delete(s, i, j + 1);
  until false;

  repeat
    i := pos('<script', s);
    if i = 0 then
      break;
    j := 5;
    while s[i + j] <> '>' do
      inc(j);
    delete(s, i, j + 1);
  until false;

  repeat
    i := pos('<a href', s);
    if i = 0 then
      break;
    insert(nomeDir, s, i + 9);
    insert('target="_blank" ', s, i + 3);
  until false;

  s := stringreplace(s, '"', '\"', [rfreplaceall]);
  memo2.Text := s;

  assignFile(f, 'D:\tenho offline\Delphi\Engolir\saida2.txt');
  append(f);
  writeln(f, saida + ' "' + nomedir + nomearq + '",');
  for i := 0 to memo2.lines.Count - 1 do
  begin
    if i <> 0 then
      write(f, '+ "\n')
    else write(f, '"');
    write(f, stringreplace(stringreplace(memo2.lines[i], #13, '', [rfReplaceAll]), #10, '', [rfreplaceall]) + '"');
    if i <> memo2.lines.Count - 1 then
      writeln(f);
  end;
  writeln(f, ');');
  closefile(f);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  contador := 807;
  processarArq('D:\ocaminho\ocaminho/TDivino/VT/VTL/Et/', 'Et09.htm');
  contador := 8348;
  processarArq('D:\ocaminho\ocaminho/TKardequiano/TKP/', 'TKIndexLivros.htm');
  contador := 8494;
  processarArq('D:\ocaminho\ocaminho/TXavieriano/Livros/Acl/', 'Acl08.htm');
  contador := 19254;
  processarArq('D:\ocaminho\ocaminho/TXavieriano/Livros/Pec/', 'Pec45.htm');
  contador := 23591;
  processarArq('D:\ocaminho\ocaminho/', 'PaginaInicial.html');
  contador := 23592;
  processarArq('D:\ocaminho\', 'index.html');
  contador := 23593;
  processarArq('D:\ocaminho\ocaminho\TDivino\VT\VTL\Is\', 'Is48.htm');
  contador := 23594;
  processarArq('D:\ocaminho\ocaminho\TKardequiano\TKF\Re69\Jan\', 'Re69JanA04.htm');
  contador := 23595;
  processarArq('D:\ocaminho\ocaminho\TXavieriano\Livros\Cvv\', 'Cvv17.htm');
  contador := 23596;
  processarArq('D:\ocaminho\ocaminho\TXavieriano\Livros\Cxe\', 'Cxe06.htm');
  contador := 23597;
  processarArq('D:\ocaminho\ocaminho\TXavieriano\', 'TXIndexAutC2.htm');
end;

end.

