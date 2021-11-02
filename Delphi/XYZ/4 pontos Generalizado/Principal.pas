unit Principal;

interface

uses
  Forms, Controls, StdCtrls, Classes, Graphics, SysUtils, Dialogs,
  ExtCtrls, Menus;

type
  Txy = object
  public
    x, y: real;
    procedure SetXY(newX, newY: real);
  end;

const nTermos = 200;

type
  TFormPrincipal = class(TForm)
    PopupMenu1: TPopupMenu;
    ZoomIn1: TMenuItem;
    ZoomOut1: TMenuItem;
    Close1: TMenuItem;
    Panel1: TPanel;
    lbStatus: TLabel;
    btnDefault: TButton;
    ResetZoom1: TMenuItem;
    procedure btnDefaultClick(Sender: TObject);
    procedure ClearScreen1Click(Sender: TObject);
    procedure ZoomIn1Click(Sender: TObject);
    procedure ZoomOut1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure ResetZoom1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function f(x: real): real;
  public
    zoom, a0, C: double;
    alpha: array[0..nTermos + 1] of real;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.DFM}

uses windows;

function pow(a, b: real): real;
begin
  result := exp(b * ln(a));
end;

procedure Txy.SetXY(newX, newY: real);
begin
  x := newX;
  y := newY;
end;

function TFormPrincipal.f(x: real): real;
var soma, pot_a, pot_x: real;
    n: integer;
begin
  soma := a0 + C * x / a0;
  pot_a := a0;
  pot_x := x;
  for n := 2 to nTermos do
  begin
    pot_a := pot_a * a0 * a0;
    pot_x := pot_x * x;
    soma := soma + alpha[n] / pot_a * pot_x;
  end;
  f := soma;
end;

procedure TFormPrincipal.btnDefaultClick(Sender: TObject);

  procedure line(x1, y1, x2, y2: integer);
  begin
    Canvas.MoveTo(x1, y1);
    Canvas.LineTo(x2, y2);
  end;

var ScreenTopLeft, ScreenBottomRight: record
    x, y: integer;
  end;
  BottomLeft, TopRight: Txy;
  razao,
    Qx, Qy,
    x: real;

  function PosX(a: real): integer; overload;
  begin
    result := ScreenTopLeft.x + round((a - BottomLeft.x) * Qx)
  end;

  function PosY(b: real): integer; overload;
  begin
    result := ScreenTopLeft.y + round((TopRight.y - b) * Qy)
  end;

  function InvPosX(p: real): real;
  begin
    result := (p - ScreenTopLeft.x) / Qx + BottomLeft.x
  end;

  function InvPosY(p: real): real;
  begin
    result := (ScreenTopLeft.y - p) / Qy + TopRight.y
  end;

  procedure PontoXY(x, y: real; cor: TColor);
  begin
    if (BottomLeft.x <= x) and (x <= TopRight.x) and (BottomLeft.y <= y) and (y <= TopRight.y) then
      canvas.Pixels[PosX(x), PosY(y)] := cor;
  end;

  procedure PontoPolar(r, theta: real; cor: TColor);
  begin
    PontoXY(r * cos(theta), r * sin(theta), cor);
  end;

  procedure Marca(x, y: real; raio: byte; cor: TColor = clblue);
  var r: TRect;
  begin
    r.Left := PosX(x) - raio;
    r.Top := PosY(y) - raio;
    r.Right := r.left + 2 * raio;
    r.Bottom := r.Top + 2 * raio;
    canvas.brush.color := cor;
    Canvas.FillRect(r);
  end;

begin
  refresh;
  ScreenTopLeft.x := 0;
  ScreenTopLeft.y := 0;
  ScreenBottomRight.x := ClientWidth;
  ScreenBottomRight.y := ClientHeight;
  razao := ScreenBottomRight.y / ScreenBottomRight.x; // multiplique por y para círculos
  BottomLeft.x := -zoom;
  BottomLeft.y := -zoom * 3 / 4;
  TopRight.x := zoom;
  TopRight.y := zoom * 3 / 4;
  Qx := (ScreenBottomRight.x - ScreenTopLeft.x) / (TopRight.x - BottomLeft.x);
  Qy := (ScreenBottomRight.y - ScreenTopLeft.y) / (TopRight.y - BottomLeft.y);
  if Qx > Qy
    then razao := 1 / Qx
  else razao := 1 / Qy; // utilize razao para incrementar
  lbStatus.Caption := Format('Inf.esq. = (%0.2f; %0.2f); Sup.dir. = (%0.2f; %0.2f)', [BottomLeft.x, BottomLeft.y, TopRight.x, TopRight.y]);
  Application.ProcessMessages;

  canvas.pen.color := clBlack;
  canvas.brush.color := clBlue;
  x := ScreenTopLeft.y + TopRight.y * Qy; // ordenada de Ox
  line(ScreenTopLeft.x, round(x), ScreenBottomRight.x, round(x));
  x := ScreenTopLeft.x - BottomLeft.x * Qx; // abscissa de Oy
  line(round(x), ScreenTopLeft.y, round(x), ScreenBottomRight.y);

  Marca(1,0,3);
  Marca(2,0,3);
  Marca(3,0,3);
  Marca(4,0,3);
  Marca(5,0,3);
  Marca(6,0,3);
  Marca(7,0,3);
  Marca(8,0,3);
  Marca(9,0,3);
  Marca(0,1,3);
  Marca(0,2,3);
  Marca(0,3,3);

  x := BottomLeft.x;
  while x < TopRight.x do
  begin
    PontoXY(x, f(x), clBlue);
    x := x + 1/Qx/10;
  end;
end;

procedure TFormPrincipal.ClearScreen1Click(Sender: TObject);
begin
  Refresh;
end;

procedure TFormPrincipal.ZoomIn1Click(Sender: TObject);
begin
  zoom := zoom / 2;
  btnDefault.Click;
end;

procedure TFormPrincipal.ZoomOut1Click(Sender: TObject);
begin
  zoom := zoom * 2;
  btnDefault.Click;
end;

procedure TFormPrincipal.Close1Click(Sender: TObject);
begin
  close;
end;

procedure TFormPrincipal.ResetZoom1Click(Sender: TObject);
begin
  zoom := 5.0;
  btnDefault.Click;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var n, j: integer;
begin
  zoom := 5.0;
  // y'y = -2C ==> y = a0 + x/a0 + ...
  C := -0.5;
  a0 := 3;
  // y = sgn(a0) sqrt(-4Cx + a0^2)
  // x \in (-p,p), p = a0^2/|4C|
  // a0 = B ==> y(A) = sqrt(Delta) = sgn B sqrt(B² - 4AC)

  alpha[0] := 1;
  alpha[1] := C;
  for n := 1 to 100 do
  begin
    alpha[2*n] := - sqr(alpha[n])/2;
    for j := 1 to n - 1 do
      alpha[2*n] := alpha[2*n] - alpha[j] * alpha[2 * n - j];
    alpha[2*n + 1] := - alpha[1] * alpha[2*n];
    for j := 1 to n - 1 do
      alpha[2*n + 1] := alpha[2*n + 1] - alpha[j + 1] * alpha[2*n - j];
  end;
end;

end.

