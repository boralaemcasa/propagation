unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormPrincipal = class(TForm)
    Timer1: TTimer;
    ColorDialog: TColorDialog;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    cor: TColor;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses Displays;

procedure TFormPrincipal.Timer1Timer(Sender: TObject);

const dist = 30;
       top = 10;

procedure circulo(x, y: integer);
begin
  canvas.Ellipse(x, y, x + 10, y + 10);
  canvas.FloodFill(x+5, y+5, cor, fsBorder);
end;

var s: string;
    alt, larg: integer;
begin
  refresh;
  alt := (height - 47) div 2; // 50
  larg := (width - 196) div 6; // 50

  canvas.Brush.Color := cor;
  canvas.Pen.Color := cor;
  s := TimeToStr(Time);
  Application.Title := s;
  circulo(10 + 2*larg + 2*dist - dist div 2, top + alt div 2);
  circulo(10 + 2*larg + 2*dist - dist div 2, top + alt + alt div 2);
  circulo(10 + 4*larg + 4*dist - dist div 2 + 5, top + alt div 2);
  circulo(10 + 4*larg + 4*dist - dist div 2 + 5, top + alt + alt div 2);
  display(self, clBtnFace, cor, byte(s[1]) - 48, larg, alt, 10, top); // #48 = '0'
  display(self, clBtnFace, cor, byte(s[2]) - 48, larg, alt, 10 + larg + dist, top);
  display(self, clBtnFace, cor, byte(s[4]) - 48, larg, alt, 10 + 2*larg + 2*dist + 5, top);
  display(self, clBtnFace, cor, byte(s[5]) - 48, larg, alt, 10 + 3*larg + 3*dist + 5, top);
  display(self, clBtnFace, cor, byte(s[7]) - 48, larg, alt, 10 + 4*larg + 4*dist + 10, top);
  display(self, clBtnFace, cor, byte(s[8]) - 48, larg, alt, 10 + 5*larg + 5*dist + 10, top);
end;

procedure TFormPrincipal.FormClick(Sender: TObject);
begin
  ColorDialog.Execute;
  cor := ColorDialog.Color;
end;

end.
