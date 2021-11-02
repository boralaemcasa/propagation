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
    edBusca: TLabeledEdit;
    Button1: TButton;
    Memo: TMemo;
    cbSensitive: TCheckBox;
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
    s, upper: string;
    f: file of char;
    ch: char;
    j, k: integer;
    txt: TextFile;
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

    //jogar o arquivo em s
      AssignFile(f, nomeDir + search.Name);
      reset(f);
      s := '';
      while not eof(f) do
      begin
        read(f, ch);
        if not cbSensitive.Checked then
          ch := upcase(ch);
        s := s + ch;
      end;
      CloseFile(f);

      if //(pos('DELETE', s) > 0) and
        (pos(edBusca.Text, s) > 0)  then
      begin
        memo.lines.add(search.Name);

      //exibir a linha
        AssignFile(txt, nomeDir + search.Name);
        reset(txt);
        k := 0;
        while not eof(txt) do
        begin
          readln(txt, s);
          inc(k);
          if not cbSensitive.Checked then
            upper := UpperCase(s)
          else upper := s;
          if pos(edBusca.Text, upper) > 0 then
            Memo.Lines.Add('<' + IntToStr(k) + '> ' + s);
        end;
        CloseFile(txt);

        memo.Lines.Add('__________');
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

  if not cbSensitive.Checked then
    edBusca.Text := uppercase(edBusca.Text);

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
    caption := inttostr(contador) + ' arquivos encontrados';
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
