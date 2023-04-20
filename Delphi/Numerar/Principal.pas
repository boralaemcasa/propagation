unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormPrincipal = class(TForm)
    Memo: TMemo;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.FormActivate(Sender: TObject);
var f: TextFile;
  i, n, j, k, L: integer;
  origem, destino, bat, saida, conjini, conjfim, conjmeio, conjrand, numero: string;
  inicio, multiplicador: integer;
begin
  //dir/b *.mp3 > lista.txt

  repeat
    if not InputQuery('Começar de qual número', 'Informe o número inicial:', origem) then exit;
    try
      inicio := StrToInt(origem);
    except
      inicio := -1;
    end;

    if not InputQuery('Múltiplos de Quanto', 'Informe o multiplicador:', origem) then exit;
    try
      multiplicador := StrToInt(origem);
    except
      multiplicador := -1;
    end;
  until multiplicador >= 0;

  if not InputQuery('Diretório\Máscara', 'Caminho completo do arquivo:', origem) then exit;

  destino := ExtractFilePath(Application.ExeName) + 'pini.txt';
  if not FileExists(destino) then
  begin
    AssignFile(f, destino);
    rewrite(f);
    writeln(f, '0123456789_ -.');
    CloseFile(f);
  end;
  memo.lines.loadfromfile(destino);
  conjini := stringReplace(memo.text, #13#10, '', [rfReplaceAll]);

  destino := ExtractFilePath(Application.ExeName) + 'pfim.txt';
  if not FileExists(destino) then
  begin
    AssignFile(f, destino);
    rewrite(f);
    writeln(f, '0123456789 ()');
    CloseFile(f);
  end;
  memo.lines.loadfromfile(destino);
  conjfim := stringReplace(memo.text, #13#10, '', [rfReplaceAll]);

  destino := ExtractFilePath(Application.ExeName) + 'pmeio.txt';
  if not FileExists(destino) then
  begin
    AssignFile(f, destino);
    rewrite(f);
    writeln(f, '.');
    CloseFile(f);
  end;
  memo.lines.loadfromfile(destino);
  conjmeio := stringReplace(memo.text, #13#10, '', [rfReplaceAll]);

  deletefile(ExtractFilePath(origem) + 'num_tmp.txt');
  winexec(PChar('cmd /c dir/b "' + origem + '" > "' + ExtractFilePath(origem) + 'num_tmp.txt"'), SW_HIDE);
  repeat
  until fileexists(ExtractFilePath(origem) + 'num_tmp.txt');
  sleep(1000);
  //origem := paramstr(1);
  //if not FileExists(origem) then exit;
  //if not InputQuery('Arquivo de Destino', 'Caminho completo do arquivo:', destino) then exit;
  bat := ExtractFilePath(origem) + 'num_tmp.bat';
  saida := ExtractFilePath(origem) + 'saida.txt';
  //destino := paramstr(2);
  //if FileExists(destino) then exit;

  memo.Lines.LoadFromFile(ExtractFilePath(origem) + 'num_tmp.txt');
  AssignFile(f, bat);
  rewrite(f);
  if origem[2] = ':' then
    writeln(f, origem[1] + ':')
  else if origem[3] = ':' then
    writeln(f, origem[2] + ':');
  writeln(f, 'cd ' + ExtractFilePath(origem));
  n := 0;
  conjrand := '';
  for i := 0 to memo.Lines.Count - 1 do
  begin
    inc(n);
    //if n mod 5 = 0 then
    //  inc(n, 2);
    origem := memo.lines[i];
    j := 1;
    while pos(origem[j], conjini) > 0 do
      inc(j);
    if multiplicador = 0 then
      numero := ''
    else
    begin
      repeat
        numero := inttostr(inicio + random(memo.lines.count));
        while length(numero) < 4 do
          numero := '0' + numero;
      until pos(numero + ' ', conjrand) = 0;
      conjrand := conjrand + numero + ' ';
    end;

    destino := copy(origem, j, length(origem));
    if pos('.', destino) = 0 then
      destino := '.' + destino;
    L := pos('.', destino);
    k := length(destino);
    if L > 0 then
    begin
      while destino[k] <> '.' do
        dec(k);
      dec(k);
    end;
    if k > 0 then
      while pos(destino[k], conjfim) > 0 do
      begin
        delete(destino, k, 1);
        dec(k);
        if k = 0 then
           break;
      end;
    if k > 0 then
      while pos(destino[k], conjmeio) > 0 do
      begin
        if (k > 1) or (destino[1] <> '.') then
          delete(destino, k, 1);
        dec(k);
        if k = 0 then
          break;
      end;

    writeln(f, 'ren "' + origem + '" "' + numero + destino + '.numerar"');
  end;
  writeln(f, 'ren *.numerar *.');
  CloseFile(f);
  winexec(PChar('cmd /c "' + bat + '" > "' + saida + '"'), SW_HIDE);
  application.Terminate;
end;

end.

