program P3;

uses
  Forms, windows, sysutils;

{$R *.res}

var i: longint;
begin
  i := 1;
  repeat
    try
      CopyFile('f:\bad blocks\v.txt', pchar('f:\bad blocks\' + inttostr(i) + '.txt'), true);
    except
      break;
    end;
    inc(i);
  until false;
  Application.MessageBox('kbo', 'info', MB_ICONERROR);
end.
