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
  L, xa, xan, xad, c2, c6, c10, s2, s6, s10: double;

begin
  s2 := sin(2 * pi / 7);
  c2 := cos(2 * pi / 7);
  c6 := cos(6 * pi / 7);
  s6 := sin(6 * pi / 7);
  c10 := cos(10 * pi / 7);
  s10 := sin(10 * pi / 7);
  xan := s2 * (c10 - c2) * (c6 - 1)
       - c2 * (c6 - 1) * (s10 - s2)
       + s6 * (c10 - c2);
  xad := s6 * (c10 - c2)
       - (s10 - s2) * (c6 - 1);
  xa := xan / xad;
  L := (1 - xa) / (1 - c6) * sqrt(2 - 2 * c6);
  showmessage(floattostr(L));
end;

end.
