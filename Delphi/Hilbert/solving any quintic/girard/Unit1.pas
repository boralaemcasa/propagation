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

function c(angle: double): double;
begin
  angle := angle * pi / 180;
  result := cos(angle);
end;

procedure TForm1.Button1Click(Sender: TObject);
var x: double;
begin
  x := - c(20) + c(40) + c(80);
  showmessage(floattostr(8*x));
end;

end.
