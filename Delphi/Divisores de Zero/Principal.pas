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
  public
    zoom: double;
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

function max(a, b: real): real;
begin
  if a >= b then
    result := a
  else
    result := b;
end;

procedure Txy.SetXY(newX, newY: real);
begin
  x := newX;
  y := newY;
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
    x, y, epsilon: real;

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

  x := -1;
  while x < 1.1 do
  begin
    y := -1;
    while y < 1.1 do
    begin
      epsilon := 1;
      if abs(x * y * y - y * ( 2 * x * y + epsilon / 10.0 * (10.0 * x * x + y * y) * sqrt(10) ) - 10.0 * x * x  * x) < 1e-3 then
        pontoxy(x, y, clblue);

      epsilon := -1;
      if abs(x * y * y - y * ( 2 * x * y + epsilon / 10.0 * (10.0 * x * x + y * y) * sqrt(10) ) - 10.0 * x * x  * x) < 1e-3 then
        pontoxy(x, y, clred);

      y := y + 1/Qy/10;
    end;

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
  zoom := 2.0;
  btnDefault.Click;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var n, j: integer;
begin
  zoom := 2.0;
end;

end.

