program Project1;

uses
  Forms, windows;

{$R *.res}

var f: file of char;
    ch: char;
begin
  ch := 'V';
  assignfile(f, 'f:\encher.txt');
  rewrite(f);
  repeat
    {$I-}
    write(f, ch);
    {$I+}
  until ioresult <> 0;
  CloseFile(f);
  Application.MessageBox('kbo', 'info', MB_ICONERROR);
end.
