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
    function intersect(a, b, c, d: Txy): Txy;
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

function TFormPrincipal.intersect(a,b,c,d: Txy): Txy;
var e: txy;
    numerador, denominador: real;
begin
  numerador := (c.y - d.y) / (d.x - c.x) * c.x +
               (b.y - a.y) / (b.x - a.x) * a.x + c.y - a.y;
  denominador := (b.y - a.y) / (b.x - a.x) + (c.y - d.y) / (d.x - c.x);
  e.x := numerador / denominador;
  e.y := (b.y - a.y) / (b.x - a.x) * e.x +
         (a.y - b.y) / (b.x - a.x) * a.x + a.y;
  result := e;
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
  BottomLeft, TopRight, a, b, c, d, e, f, g, h, i, j, k, l, m, n: Txy;
  razao,
    Qx, Qy, x: real;

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

  procedure estrela(raio: real; color: TColor);
  begin
  canvas.pen.color := color;

  a.SetXY(raio * cos(pi/2), raio * sin(pi/2));
  b.SetXY(raio * cos(11*pi/14), raio * sin(11*pi/14));
  c.SetXY(raio * cos(15*pi/14), raio * sin(15*pi/14));
  d.SetXY(raio * cos(19*pi/14), raio * sin(19*pi/14));
  e.SetXY(raio * cos(23*pi/14), raio * sin(23*pi/14));
  f.SetXY(raio * cos(27*pi/14), raio * sin(27*pi/14));
  g.SetXY(raio * cos(3*pi/14), raio * sin(3*pi/14));

  //AD inter BF = H
  h := intersect(a, d, b, f);
  //BE inter CG = I
  i := intersect(b, e, c, g);
  //CF inter AD = J
  j := intersect(c, f, a, d);
  //DG inter BE = K
  k  := intersect(d, g, b, e);
  //CF inter AE = L
  l  := intersect(c, f, a, e);
  //DG inter BF = M
  m  := intersect(d, g, b, f);  
  //CG inter AE = N
  n  := intersect(c, g, a, e);

  canvas.moveto(posx(a.x), posy(a.y));
  canvas.lineto(posx(h.x), posy(h.y));

  canvas.lineto(posx(b.x), posy(b.y));
  canvas.lineto(posx(i.x), posy(i.y));

  canvas.lineto(posx(c.x), posy(c.y));
  canvas.lineto(posx(j.x), posy(j.y));

  canvas.lineto(posx(d.x), posy(d.y));
  canvas.lineto(posx(k.x), posy(k.y));

  canvas.lineto(posx(e.x), posy(e.y));
  canvas.lineto(posx(l.x), posy(l.y));

  canvas.lineto(posx(f.x), posy(f.y));
  canvas.lineto(posx(m.x), posy(m.y));

  canvas.lineto(posx(g.x), posy(g.y));
  canvas.lineto(posx(n.x), posy(n.y));
  
  canvas.lineto(posx(a.x), posy(a.y));
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

  canvas.brush.color := clBlue;
  razao := razao / 100;
  x := razao;
  while x <= 1 do
  begin
  Estrela(x, clRed);
  x := x + razao;
  end;

  x := 1 + razao;
  while x <= 2 do
  begin
  Estrela(x, $00208FFF);
  x := x + razao;
  end;

  x := 2 + razao;
  while x <= 3 do
  begin
  Estrela(x, clYellow);
  x := x + razao;
  end;



  x := 3 + razao;
  while x <= 4 do
  begin
  Estrela(x, clGreen);
  x := x + razao;
  end;

  x := 4 + razao;
  while x <= 5 do
  begin
  Estrela(x, clAqua);
  x := x + razao;
  end;

  x := 5 + razao;
  while x <= 6 do
  begin
  Estrela(x, clBlue);
  x := x + razao;
  end;

  Estrela(7, clFuchsia);
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
  btnDefault.Click;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var n, j: integer;
begin
  zoom := 7.0 * 4 / 3 + 0.1;
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

