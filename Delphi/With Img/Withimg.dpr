program Withimg;
uses Forms, Windows, Dialogs, SysUtils;

var s, dest: string;
    f, g: file of char;
    ch: char;
    i: longword;
begin
  s := paramstr(1) + '.tex';
  if not fileexists(s) then
  begin
    Application.MessageBox(PChar('Não existe o arquivo ' + s), 'Atenção', mb_iconexclamation);
    exit;
  end;

  dest := paramstr(2) + '.tex';
  if fileexists(dest) then
    if Application.MessageBox(PChar('Realmente substituir o arquivo ' + dest + '?'), 'Confirmação',
        mb_iconquestion + mb_yesno) <> idYes then
      exit;

  assignfile(f, s);
  filemode := fmOpenRead;
  reset(f);
  s := '';
  while not eof(f) do
  begin
    read(f, ch);
    s := s + ch;
  end;
  CloseFile(f);

  s := StringReplace(s, '%\includegraphic', '\includegraphic', [rfReplaceAll]);
  AssignFile(g, dest);
  FileMode := fmOpenReadWrite;
  rewrite(g);
  for i := 1 to length(s) do
    write(g, s[i]);
  CloseFile(g);

  WinExec(PChar('pdflatex ' + dest), sw_maximize);
end.
