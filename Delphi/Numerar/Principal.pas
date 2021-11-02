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
  i, n, j: integer;
  origem, destino, bat: string;
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
  deletefile(ExtractFilePath(origem) + 'num_tmp.txt');
  winexec(PChar('cmd /c dir/b "' + origem + '" > "' + ExtractFilePath(origem) + 'num_tmp.txt"'), SW_HIDE);
  repeat
  until fileexists(ExtractFilePath(origem) + 'num_tmp.txt');
  sleep(1000);
  //origem := paramstr(1);
  //if not FileExists(origem) then exit;
  //if not InputQuery('Arquivo de Destino', 'Caminho completo do arquivo:', destino) then exit;
  bat := ExtractFilePath(origem) + 'num_tmp.bat';
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
  for i := 0 to memo.Lines.Count - 1 do
  begin
    inc(n);
    //if n mod 5 = 0 then
    //  inc(n, 2);
    origem := memo.lines[i];
    j := 1;
    while origem[j] in ['0'..'9', '_', ' ', '-','.'] do
      inc(j);
    if multiplicador = 0 then
      destino := ''
    else
    begin
      destino := inttostr(inicio + i);
      while length(destino) < 4 do
        destino := '0' + destino;
    end;

    destino := destino + extractfileext(origem);
    writeln(f, 'ren "' + origem + '" "' + destino + '"');
  end;
  CloseFile(f);
  winexec(PChar('cmd /c "' + bat + '"'), SW_HIDE);
  application.Terminate;
end;

end.

