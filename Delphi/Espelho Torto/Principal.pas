unit Principal;

interface

uses
  Forms, Controls, StdCtrls, Classes, Graphics, SysUtils, Dialogs,
  ExtCtrls;

type
  TFormPrincipal = class(TForm)
    btnDefault: TButton;
    btnFechar: TButton;
    lbStatus: TLabel;
    procedure btnDefaultClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.DFM}

uses Windows;

type
  Txy = object
  public
    x,y: real;
    procedure SetXY(newX, newY: real);
  end;

  Txyz = object
  public
    x,y,z: real;
    procedure SetXYZ(newX, newY, newZ: real);
  end;

function pow(a, b: real): real;
begin
  result := exp(b * ln(a));
end;

procedure RotacaoZ(var p: Txyz; theta: real);
var plinha: Txyz;
begin
  plinha.x := p.x * cos(theta) - p.y * sin(theta);
  plinha.y := p.x * sin(theta) + p.y * cos(theta);
  plinha.z := p.z;
  p := plinha;
end;

procedure Txy.SetXY(newX, newY: real);
begin
  x := newX;
  y := newY;
end;

procedure Txyz.SetXYZ(newX, newY, newZ: real);
begin
  x := newX;
  y := newY;
  z := newZ;
end;

procedure TFormPrincipal.btnDefaultClick(Sender: TObject);

procedure line(x1, y1, x2, y2: integer);
begin
   Canvas.MoveTo(x1, y1);
   Canvas.LineTo(x2, y2);
end;

var ScreenTopLeft, ScreenBottomRight: record
                           x,y: integer;
                        end;
    BottomLeft, TopRight: Txy;
    razao, dist,
    Qx, Qy,
    x, y, z, a, b, m: real;
    unitario: array[1..3] of Txy;
    i: integer;

Function PosX(a: real): integer; overload;
begin
  result := ScreenTopLeft.x + round( (a - BottomLeft.x) * Qx )
end;

Function PosY(b: real): integer; overload;
begin
  result := ScreenTopLeft.y + round( (TopRight.y - b) * Qy )
end;

Procedure PontoXY(x, y: real; cor: TColor);
begin
   if (BottomLeft.x <= x) and (x <= TopRight.x) and (BottomLeft.y <= y) and (y <= TopRight.y) then
      canvas.Pixels[PosX(x), PosY(y)] := cor;
end;

Procedure PontoPolar(r, theta: real; cor: TColor);
begin
   PontoXY(r * cos(theta), r * sin(theta), cor);
end;

Procedure PontoXYZ(x, y, z: real; cor: TColor);
begin
  PontoXY(x * unitario[1].x + y * unitario[2].x + z * unitario[3].x,
          x * unitario[1].y + y * unitario[2].y + z * unitario[3].y, cor);
end;

Function PosX(p: Txyz): integer; overload;
begin
  result := PosX(p.x * unitario[1].x + p.y * unitario[2].x + p.z * unitario[3].x);
end;

Function PosY(p: Txyz): integer; overload;
begin
  result := PosY(p.x * unitario[1].y + p.y * unitario[2].y + p.z * unitario[3].y);
end;

Procedure Marca(x, y: real; raio: byte; i: integer);
var r: TRect;
begin
   r.Left := PosX(x) - raio;
   r.Top := PosY(y) - raio;
   r.Right := r.left + 2 * raio;
   r.Bottom := r.Top + 2 * raio;
   canvas.brush.Color := clblue;
   Canvas.FillRect(r);
   canvas.brush.Color := clwhite;
   canvas.TextOut(r.Right, r.Bottom, inttostr(i));
   showmessage(floattostr(x) + #13#10 + floattostr(y))
end;

procedure F(var x: real; a: real);
begin
  x := - 2 * x - 2 * a;
end;

procedure G(var x, y: real; m, b: real);
var lambda: real;
begin
  lambda := abs(m * (x - b) - y) * 2.0 / (1.0 + m * m);
  x := x + lambda * m;
  y := y - lambda;
end;

begin
   Refresh;
   btnDefault.Enabled := false;

   ScreenTopLeft.x := 0;
   ScreenTopLeft.y := 0;
   ScreenBottomRight.x := 1000;
   ScreenBottomRight.y := 670;
   razao := ScreenBottomRight.y / ScreenBottomRight.x; // multiplique por y para círculos
   BottomLeft.x := -10;
   BottomLeft.y := -10;
   TopRight.x := 10;
   TopRight.y := 10;
   Qx := (ScreenBottomRight.x - ScreenTopLeft.x) / (TopRight.x - BottomLeft.x);
   Qy := (ScreenBottomRight.y - ScreenTopLeft.y) / (TopRight.y - BottomLeft.y);
   if Qx > Qy
     then razao := 1/Qx
     else razao := 1/Qy;  // utilize razao para incrementar
   lbStatus.Caption := Format('Inf.esq. = (%0.2f; %0.2f); Sup.dir. = (%0.2f; %0.2f)', [BottomLeft.x, BottomLeft.y, TopRight.x, TopRight.y]);
   Application.ProcessMessages;

  dist := 4;
  unitario[1].SetXY(1/dist, -1/dist);
  unitario[2].SetXY(1/dist, 1/dist);
  unitario[3].SetXY(0, 1/dist);

   x := ScreenTopLeft.y + TopRight.y * Qy;  // ordenada de Ox
   line( ScreenTopLeft.x, round(x),  ScreenBottomRight.x, round(x) );
   x := ScreenTopLeft.x - BottomLeft.x * Qx;  // abscissa de Oy
   line( round(x), ScreenTopLeft.y,  round(x), ScreenBottomRight.y );

   a := -0.01;
   b := 0.02;
   m := 3;
   x := 0;
   y := 0;
   Marca(x, y, 3, 0);
   for i := 1 to 20 do
   begin
     F(x, a);
     Marca(x, a, 3, i);
     G(x, y, m, b);
     Marca(x, y, 3, i);
   end;
   btnDefault.Enabled := true;
end;

procedure TFormPrincipal.btnFecharClick(Sender: TObject);
begin
   close;
end;

end.
