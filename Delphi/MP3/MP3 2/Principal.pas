unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  f, g: textFile;
  s, novo: string;
  i: integer;
begin
  i := 0;
  filemode := 0;
  assignfile(f, 'i:\lista.m3u');
  reset(f);
  assignfile(g, 'i:\saida.txt');
  rewrite(g);
  while not eof(f) do
  begin
    readln(f, s);
    novo := stringReplace(s, 'I:\_to hd backup\whole\', 'G:\whole\', [rfreplaceall]);
    ForceDirectories(ExtractFilePath(novo));
    copyfile(PChar(s), PChar(novo), true);
    //deleteFile(s);
    writeln(g, s);
    inc(i);
    caption := inttostr(i);
    application.processMessages;
  end;
  closefile(f);
  closefile(g);
  close;
end;

end.
