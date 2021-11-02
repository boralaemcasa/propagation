unit calc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    A: TEdit;
    B: TEdit;
    BtnSoma: TButton;
    BtnSubtrai: TButton;
    BtnMultiplica: TButton;
    BtnDivide: TButton;
    BtnValida: TButton;
    BtnCompara: TButton;
    BtnOposto: TButton;
    BtnReduz: TButton;
    procedure BtnSomaClick(Sender: TObject);
    procedure BtnSubtraiClick(Sender: TObject);
    procedure BtnMultiplicaClick(Sender: TObject);
    procedure BtnDivideClick(Sender: TObject);
    procedure BtnValidaClick(Sender: TObject);
    procedure BtnComparaClick(Sender: TObject);
    procedure BtnOpostoClick(Sender: TObject);
    procedure BtnReduzClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses snum;
{$R *.DFM}

procedure TForm1.BtnSomaClick(Sender: TObject);
begin
  a.Text := fracAdd(a.text, b.text);
end;

procedure TForm1.BtnSubtraiClick(Sender: TObject);
begin
  a.Text := fracSub(a.text, b.text);
end;

procedure TForm1.BtnMultiplicaClick(Sender: TObject);
begin
  a.Text := multiplica(a.text, b.text);
end;

procedure TForm1.BtnDivideClick(Sender: TObject);
begin
  a.Text := fracDiv(a.text, b.text);
end;

procedure TForm1.BtnValidaClick(Sender: TObject);
begin
  a.Text := FracValida(a.text);
  //b.Text := FracValida(b.text);
end;

procedure TForm1.BtnComparaClick(Sender: TObject);
begin
  a.text := inttostr(FracCompare(a.text, b.text));
end;

procedure TForm1.BtnOpostoClick(Sender: TObject);
begin
  a.text := FracOposto(a.text);
end;

procedure TForm1.BtnReduzClick(Sender: TObject);
var s: string;
begin
  s := a.text;
  FracReduz(s);
  a.text := s;
end;

end.
