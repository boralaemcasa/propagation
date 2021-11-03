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
var g: file of longword;
    p: longword;
begin
  fileMode := 0;
  assignFile(g, 'H:\_não deletar\2016 08 24\Produtorio\primos novos.dat');
  reset(g);
  seek(g, 756730 - 1);
  read(g, p);
  showmessage(inttostr(p));
  closefile(g);
end;

end.
