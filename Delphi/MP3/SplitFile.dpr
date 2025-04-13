program SplitFile;

uses Dialogs, SysUtils;

var
  f,g: file of byte;
  splits: longint;
  i,j: integer;
  b: byte;

begin
  filemode := 0;
  splits := 5 * 961536; // 5 min
  //assignfile(f, 'H:\salvar\Dream Dance vol' + paramstr(1) + '.mp3');
  assignfile(f, 'H:\backup do youtube\Retrospectiva 2022 — de 15 de Dezembro até 02 de Fevereiro de 2023.mp3');
  reset(f);
  for i := 1 to 1 do // fileSize(f) div splits + 1 do
  begin
    //assignfile(g, 'H:\salvar\Dream Dance vol' + paramstr(1) + ' part ' + inttostr(i) + '.mp3');
    assignfile(g, 'C:\temptemp\R part ' + inttostr(i) + '.mp3');
    rewrite(g);
    for j := 1 to splits do
    begin
      read(f, b);
      write(g, b);
      if eof(f) then
         break;
    end;
    closefile(g);
  end;
  closefile(f);
end.
