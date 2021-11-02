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
    edNovaPasta: TLabeledEdit;
    MemoLog: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure edDirExit(Sender: TObject);
    procedure btnPesquisaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure QuickSort(iLo, iHi: Integer);
    procedure DeletarNaoRepetidos;
    procedure CompararBytes;
    procedure MoverArquivo(s: string);
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

procedure TForm1.MoverArquivo(s: string);
var k: integer;
    path: string;
begin
  k := pos(';', s);
  delete(s, 1, k);

  path := ExtractFilePath(s);
  insert('\' + edNovaPasta.Text, path, 3);
  delete(path, length(path), 1);
  ForceDirectories(path);
  MoveFile(PChar(s), PChar(path + '\' + ExtractFileName(s)));
end;

procedure TForm1.processaDir(nomeDir: string);
var search: TSearchRec;
    f: file of char;
    j: integer;
    s: string;
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

      s := uppercase(extractfileext(search.name));
      if copy(s, 2, 1) = '' then
        s := '._adicionar';

      if not (s[2] in ['A'..'Z', '0'..'9', '~']) then
      begin
        AssignFile(f, nomeDir + search.Name);
        try
          reset(f); // exception: unicode

          memo.lines.add(IntToStr(FileSize(f)) + ';' + nomeDir + search.Name);

          inc(contador);
          CloseFile(f);
        except
        end;
      end;

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

procedure TForm1.QuickSort(iLo, iHi: Integer) ;
var
  Lo, Hi: integer;
  pivot, T: string;
begin
  Lo := iLo;
  Hi := iHi;
  Pivot := memo.lines[(Lo + Hi) div 2];
  repeat
    while Comparar(memo.lines[Lo], Pivot) < 0 do
      Inc(Lo) ;
    while Comparar(memo.lines[Hi], Pivot) > 0 do
      Dec(Hi) ;
    if Lo <= Hi then
    begin
      T := memo.lines[Lo];
      memo.lines[Lo] := memo.lines[Hi];
      memo.lines[Hi] := T;
      Inc(Lo) ;
      Dec(Hi) ;

      caption := 'QuickSort: ' + inttostr(lo) + ' x ' + inttostr(hi);
      application.processMessages;

      if cancelar then
        exit;
    end;
  until Lo > Hi;

  if Hi > iLo then QuickSort(iLo, Hi) ;
  if Lo < iHi then QuickSort(Lo, iHi) ;
end;

procedure TForm1.DeletarNaoRepetidos;
var i, j: integer;
begin
  i := 2;
  repeat
    if (memo.Lines[i] = '') or ( pos('\' + edNovaPasta.Text + '\', memo.Lines[i]) > 0 ) then
    begin
      memoLog.Lines.Add('Deletando linha ' + inttostr(i));
      application.ProcessMessages;
      memo.Lines.Delete(i);
    end
    else
      inc(i);
  until i >= memo.lines.count;

  i := 2;
  repeat
    j := i;
    repeat
      inc(j);
    until (j = memo.lines.Count) or (Comparar(memo.lines[i], memo.lines[j]) <> 0);

    if j = i + 1 then
      memo.lines.Delete(i)
    else
      i := j;

    memoLog.Lines.Add('Deletar não repetidos: ' + inttostr(i) + ' x ' + inttostr(j));
    application.ProcessMessages;
	if cancelar then
	  exit;
  until i >= memo.Lines.Count;
end;

procedure TForm1.CompararBytes;
var i, j, k, s_index, max: integer;
    s: array of string;
    ch: char;
    f: file of char;
    nomearq: string;
begin
  contador := 2;
  SetLength(s, memo.Lines.Count + 7); // por garantia

  repeat
    for i := 0 to contador - 2 do
      s[i] := '';

    i := contador;
    while memo.lines[i] = '' do
      inc(i);

    j := i;
    repeat
      inc(j);
    until (j = memo.lines.Count) or (Comparar(memo.lines[i], memo.lines[j]) <> 0);

    //memo.lines.SaveToFile('j:\a.a');

    max := j - i;
    for s_index := 0 to max - 1 do
    begin
      nomearq := memo.lines[i + s_index];
      k := pos(';', nomearq);
      delete(nomearq, 1, k);

      MemoLog.Lines.add('Carregando ' + nomearq);
      application.processMessages;

    //jogar o arquivo em s
      AssignFile(f, nomearq);
      try
        reset(f); // file not found
        k := 0;

        s[i + s_index] := '';
        while not eof(f) do
        begin
          read(f, ch);
          s[i + s_index] := s[i + s_index] + ch;
          inc(k);
          if k mod 10240 = 0 then
          begin
            memoLog.Lines.Add('Contínuo carregamento ' + inttostr(k) + ' / ' + memo.Lines[i + s_index]);
            Application.ProcessMessages;
          end;
        end;

        CloseFile(f);
      except
        memoLog.Lines.Add('Exception: ' + memo.lines[i + s_index]);
        application.ProcessMessages;
        memo.lines[i + s_index] := '';
      end;

	  if cancelar then
	    exit;
    end;

    for i := i to i + max - 2 do
    begin
      j := i + 1;
      repeat
        MemoLog.lines.add('Comparando ' + inttostr(i) + ' com ' + inttostr(j));
        application.processMessages;

        if memo.lines[i + 2] <> '' then
          if memo.lines[j + 2] <> '' then
            if Comparar(memo.lines[i + 2], memo.lines[j + 2]) = 0 then
              if s[i] = s[j] then
              begin
                memoLog.lines.add('Movendo ' + memo.Lines[j + 2]);
                try
                  MoverArquivo(memo.lines[j + 2]);
                except
                  memoLog.Lines.Add('Impossível mover: ' + memo.Lines[j + 2])
                end;
                memo.Lines[j + 2] := '';
                memo.Refresh;
                memoLog.Refresh;
              end;

        inc(j);
		if cancelar then
		  exit;
      until j = i + max;
    end;

    contador := i + 2; // oq poderia acontecer after loop?

	if cancelar then
	  exit;
  until contador >= memo.lines.count - 1;

  memoLog.Lines.Add('');
  memoLog.Lines.Add('Saindo.');
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

  memo.Hide;
  QuickSort(2, memo.Lines.Count - 1);

  caption := inttostr(contador) + ' arquivos encontrados';

  DeletarNaoRepetidos;
  memo.Show;
  CompararBytes;

  if cancelar then
  begin
    memo.lines.add('');
    memo.lines.add('Operação cancelada pelo usuário');
    caption := 'Operação cancelada pelo usuário';
  end;

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
  begin
    cancelar := true;
    memo.show; // it's show time
  end
  else if key = '#' then
  begin
    memo.Hide;
    DeletarNaoRepetidos;
    memo.Show;
    CompararBytes;
  end;
end;

end.
