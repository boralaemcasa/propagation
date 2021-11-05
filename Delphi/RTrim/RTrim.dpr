program RTrim;

uses
  Windows, Forms, SysUtils;

var
  f, g: TextFile;
  param, s, tmp: string;
begin
  if paramcount <> 1 then
     exit;
  param := paramstr(1);
  if not FileExists(param) then
  begin
     Application.MessageBox(PChar('Arquivo não existe: ' + param), 'RTrim Error', mb_iconexclamation);
     exit;
  end;
  tmp := ExtractFilePath(param) + '_TRIM_' + ExtractFileName(param) + '.tmp';
  assignFile(g, tmp);
  rewrite(g);

  filemode := 0;
  assignfile(f, param);
  reset(f);
  while not eof(f) do
  begin
    readln(f, s);
    s := TrimRight(s);
    writeln(g, s);
  end;

  closefile(f);
  closefile(g);
  DeleteFile(param);
  RenameFile(tmp, param);
end.
