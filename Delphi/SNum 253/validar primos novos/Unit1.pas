unit Unit1;

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
var f: file of longword;
    p1, p2: longword;
begin
  fileMode := 0;
  assignFile(f, 'H:\_não deletar\2016 08 24\Produtorio\primos novos.dat');
  reset(f);
  p1 := 2;
  while not eof(f) do
  begin
    read(f, p2);
    if p1 > p2 then
      showmessage(inttostr(p1) + ' > ' + inttostr(p2));
    p1 := p2;
  end;
  closefile(f);
  showmessage('end');
end;

end.
