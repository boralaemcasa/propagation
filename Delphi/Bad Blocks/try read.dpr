program P2;

uses
  Forms, windows, SYSUTILS, dialogs;

{$R *.res}

var f: file of char;
    ch: char;
    I,j: LONGINT;
begin
  for j := 1200 {0} to 1910 do
  begin
    //showmessage(inttostr(j));
    assignfile(f, 'f:\bad blocks\' + inttostr(j) + '.txt');
    reSeT(f);
    I := 0;
    repeat
      READ(f, ch);
      IF CH <> 'V' THEN
      begin
        Application.MessageBox(PCHAR(INTTOSTR(j) + '.txt'#13'byte = ' + inttostr(byte(ch))), 'info', MB_ICONERROR);
        break;
      end;
      INC(I);
    until EOF(F);
    CloseFile(f);
  end;
  Application.MessageBox('kbo', 'info', MB_ICONERROR);
end.
