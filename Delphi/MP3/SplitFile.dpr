program SplitFile;

uses Dialogs, SysUtils;

procedure processar(nomearq: string);
var
  f,g: file of byte;
  splits: longint;
  i,j: integer;
  b: byte;

begin
  filemode := 0;
  splits := 5 * 961536; // 5 min
  assignfile(f, nomearq + '.mp3');
  reset(f);
  for i := 1 to fileSize(f) div splits + 1 do
  begin
    assignfile(g, nomearq + ' part ' + inttostr(i) + '.mp3');
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
end;

begin
   processar('H:\musics\espiritas\Casimiro Cunha\selecoes 1 cunha split\Kevin_Kern_Our_selections');
   processar('H:\musics\espiritas\Casimiro Cunha\selecoes 1 cunha split\Pachelbel - Forest Garden');
end.
