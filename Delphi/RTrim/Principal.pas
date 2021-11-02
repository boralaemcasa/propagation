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
    s: string;
    j, k: integer;
    txt, saida: TextFile;
    alterou: boolean;
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

      memo.lines.add(search.Name);

    //exibir a linha
      AssignFile(txt, nomeDir + search.Name);
      AssignFile(saida, ExtractFilePath(Application.ExeName) + 'rtrim.tmp');
      reset(txt);
      rewrite(saida);
      k := 0;
      alterou := false;
      while not eof(txt) do
      begin
        readln(txt, s);
        writeln(saida, trimright(s));
        inc(k);
        if s <> trimright(s) then
          begin
            memo.lines.add(inttostr(k));
            if not alterou then
            begin
              alterou := true;
              inc(contador);
            end;
          end;
      end;
      CloseFile(txt);
      CloseFile(saida);

      if alterou then
      begin
        DeleteFile(nomeDir + search.Name);
        MoveFile(PChar(ExtractFilePath(Application.ExeName) + 'rtrim.tmp'), PChar(nomeDir + search.name));
      end;

      memo.Lines.Add('__________');

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
  contador := 0;
  processaDir(edDir.Text);

  if cancelar then
  begin
    memo.lines.add('');
    memo.lines.add('Operação cancelada pelo usuário');
    caption := 'Operação cancelada pelo usuário'
  end
  else
    caption := inttostr(contador) + ' arquivos alterados';
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

end.
