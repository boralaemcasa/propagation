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

const nTermos = 1000;

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
    function g(x: real): real;
    function h(x: real): real;
  public
    a, b, c: array[0..nTermos + 1] of real;
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
var soma, pot_x: real;
  n: integer;
begin
  soma := a[0] + a[1] * x;
  pot_x := x;
  for n := 2 to nTermos do
  begin
    pot_x := pot_x * x;
    soma := soma + a[n] * pot_x;
  end;
  f := soma;
end;

function TFormPrincipal.g(x: real): real;
var soma, pot_x: real;
  n: integer;
begin
  soma := b[0] + b[1] * x;
  pot_x := x;
  for n := 2 to nTermos do
  begin
    pot_x := pot_x * x;
    soma := soma + b[n] * pot_x;
  end;
  g := soma;
end;

function TFormPrincipal.h(x: real): real;
var soma, pot_x: real;
  n: integer;
begin
  soma := c[0] + c[1] * x;
  pot_x := x;
  for n := 2 to nTermos do
  begin
    pot_x := pot_x * x;
    soma := soma + c[n] * pot_x;
  end;
  h := soma;
end;

function arccos(x: real): real;
begin
try
  if x < 0 then
    arccos := pi + arctan(sqrt(1 - x * x) / x)
  else
    arccos := arctan(sqrt(1 - x * x) / x);
    except
      arccos := 0;
    end;
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
    x, y: real;

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
  BottomLeft.x := -1.1;
  BottomLeft.y := 0.4;
  TopRight.x := 1.1;
  TopRight.y := 1.1;
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

  Marca(1, 0, 3);
  Marca(2, 0, 3);
  Marca(3, 0, 3);
  Marca(4, 0, 3);
  Marca(5, 0, 3);
  Marca(6, 0, 3);
  Marca(7, 0, 3);
  Marca(8, 0, 3);
  Marca(9, 0, 3);
  Marca(0, 1, 3);
  Marca(0, 2, 3);
  Marca(0, 3, 3);

  x := -1;
  while x <= 1 do
  begin
    PontoXY(x, cos(1/3 * arccos(x)), clRed);
    PontoXY(x, f(x), clBlue); // ok
    PontoXY(x, 1 + abs(cos(1/3 * arccos(x)) - f(x)), clBlack);
    //PontoXY(x, g(x), clGreen);
    //PontoXY(x, h(x), clBlack);
    x := x + 1 / Qx / 10;
  end;
end;

procedure TFormPrincipal.ClearScreen1Click(Sender: TObject);
begin
  Refresh;
end;

procedure TFormPrincipal.ZoomIn1Click(Sender: TObject);
begin
  btnDefault.Click;
end;

procedure TFormPrincipal.ZoomOut1Click(Sender: TObject);
begin
  btnDefault.Click;
end;

procedure TFormPrincipal.Close1Click(Sender: TObject);
begin
  close;
end;

procedure TFormPrincipal.ResetZoom1Click(Sender: TObject);
begin
  btnDefault.Click;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var n, t: integer;
begin
//CALCULANDO C
  a[0] := 0;
  a[1] := -1 / 3;

  for n := 2 to nTermos do
  begin
    if n mod 3 = 0 then
      a[n] := 4 * a[n div 3] * a[n div 3] * a[n div 3] // cubo de cada termo
    else
      a[n] := 0;
  //soluções de 2i + j = n  ==> (i,j) = (t, n - 2t)
  //2i + j = 6 ==> 2 * 0 + 6, 2 * 1 + 4, 2 * 2 + 2, 2 * 3 + 0
    for t := 1 to n div 2 do
      if 3 * t <> n then
        a[n] := a[n] + 12 * a[t] * a[t] * a[n - 2 * t];

    a[n] := a[n] / (3 - 12 * a[0] * a[0]);
  end;

  c := a;

//CALCULANDO B
  a[0] := -sqrt(3) / 2;
  a[1] := 1 / 6;

  for n := 2 to nTermos do
  begin
    if n mod 3 = 0 then
      a[n] := 4 * a[n div 3] * a[n div 3] * a[n div 3] // cubo de cada termo
    else
      a[n] := 0;
  //soluções de 2i + j = n  ==> (i,j) = (t, n - 2t)
  //2i + j = 6 ==> 2 * 0 + 6, 2 * 1 + 4, 2 * 2 + 2, 2 * 3 + 0
    for t := 1 to n div 2 do
      if 3 * t <> n then
        a[n] := a[n] + 12 * a[t] * a[t] * a[n - 2 * t];

    a[n] := a[n] / (3 - 12 * a[0] * a[0]);
  end;

  b := a;

//CALCULANDO A
  a[0] := +sqrt(3) / 2;
  a[1] := 1 / 6;

  for n := 2 to nTermos do
  begin
    if n mod 3 = 0 then
      a[n] := 4 * a[n div 3] * a[n div 3] * a[n div 3] // cubo de cada termo
    else
      a[n] := 0;
  //soluções de 2i + j = n  ==> (i,j) = (t, n - 2t)
  //2i + j = 6 ==> 2 * 0 + 6, 2 * 1 + 4, 2 * 2 + 2, 2 * 3 + 0
    for t := 1 to n div 2 do
      if 3 * t <> n then
        a[n] := a[n] + 12 * a[t] * a[t] * a[n - 2 * t];

    a[n] := a[n] / (3 - 12 * a[0] * a[0]);
  end;
end;

end.

