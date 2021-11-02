program Zerar;
uses forms, dialogs, sysutils, windows;
var f: file of longint;
    s: string;
    L: longint;
begin
  if paramcount <> 1 then exit;
  s := paramstr(1);
  if not FileExists(s) then exit;
  if Application.MessageBox(pchar('Zerar ' + s + '?'), 'Confirmação',
      MB_YESNO + MB_ICONQUESTION) <> idyes then
    exit;
  AssignFile(f, s);
  rewrite(f);
  L := 0;
  repeat
  {$I-}
    write(f, L);
  {$I+}
  until ioresult <> 0;
  closefile(f);
end.
