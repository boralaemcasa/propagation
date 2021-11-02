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

  TArray = array[0..100] of real;

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
    Memo: TMemo;
    procedure btnDefaultClick(Sender: TObject);
    procedure ClearScreen1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
  private
    function L: real;
    function partial(i: integer): real;
    function SomaDeQuadrados: real;
  public
    a0, C: double;
    alpha: array[0..nTermos + 1] of real;
    y: TArray;
    n: integer;
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
  BottomLeft.x := 0;
  BottomLeft.y := -2.1;
  TopRight.x := 1.1;
  TopRight.y := 2.1;
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

  x := 0;
  while x <= n do
  begin
    Marca(x/n, y[round(x)], 3, clblue);
    x := x + 1;
  end;
end;

procedure TFormPrincipal.ClearScreen1Click(Sender: TObject);
begin
  Refresh;
end;

procedure TFormPrincipal.Close1Click(Sender: TObject);
begin
  close;
end;

function TFormPrincipal.L: real;
var i: integer;
begin
  Result := 0;
  for i := 0 to n - 1 do
    Result := Result + sqrt( 1/(n*n) + sqr(y[i+1] - y[i]) );
end;

function TFormPrincipal.partial(i: integer): real;
begin
  Result := (y[i] - y[i-1]) / sqrt( 1/(n*n) + sqr(y[i] - y[i-1]) )
          + (y[i] - y[i+1]) / sqrt( 1/(n*n) + sqr(y[i] - y[i+1]) );
end;

function TFormPrincipal.SomaDeQuadrados: real;
var i: integer;
begin
  Result := 0;
  for i := 1 to n - 1 do
    Result := Result + y[i];
  Result := sqr(Result - n);

  for i := 1 to n - 1 do
    Result := Result + sqr( partial(i) - y[n+1]/n );
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
  procedure Executar(i: integer);
  var
    min: TArray;
    dx: real;
    flag: boolean;
    j: integer;
  begin
    n := i;
    dx := 1/5;
    min[n + 2] := 100;

    y[n] := 0;

    for i := 1 to n - 2 do
      y[i] := 0;

    y[n - 1] := n;
    for i := 1 to n - 2 do
      y[n-1] := y[n-1] - y[i];

    y[n + 1] := 0;

    flag := true;
    for i := 1 to n - 2 do
      flag := flag and (y[i] < 4);

    j := 1;
    while flag and (y[n + 1] < 4) do
    begin
    {
      showmessage(floattostr(y[1]) + #13#10 +
                  floattostr(y[2]) + #13#10 +
                  floattostr(y[3]) + #13#10 +
                  floattostr(y[4]) + #13#10 +
                  floattostr(y[5]) + #13#10 +
                  floattostr(y[6]) + #13#10 +
                  floattostr(y[7]));
    }                  

      y[n + 2] := SomaDeQuadrados;
      if y[n + 2] < min[n + 2] then
        min := y;

      y[j] := y[j] + dx;

      y[n - 1] := n;
      for i := 1 to n - 2 do
        y[n-1] := y[n-1] - y[i];

    //carry
      repeat
        if y[j] >= 4 then
        begin
          if j = n - 2 then
            inc(j, 3)
          else
            inc(j);
          y[j] := y[j] + dx;
        end;
      until (y[j] < 4) or (y[n + 1] >= 4);

      for i := 1 to j - 1 do
        y[i] := 0;

      j := 1;

      y[n - 1] := n;
      for i := 1 to n - 2 do
        y[n-1] := y[n-1] - y[i];

      flag := true;
      for i := 1 to n - 2 do
        flag := flag and (y[i] < 4);
    end;

    y := min;

    memo.lines.add('');
    memo.lines.add('n = ' + inttostr(n));
    for i := 1 to n - 1 do
      memo.lines.add('y' + inttostr(i) + ' = ' + floattostr(y[i]));
    memo.lines.add('lambda = ' + floattostr(y[n + 1]));
    memo.lines.add('modulo = ' + floattostr(y[n + 2]));
    for i := 1 to n - 1 do
      memo.lines.add('partial' + inttostr(i) + ' = ' + floattostr(partial(i) - y[n+1]/n));
    memo.lines.add('L = ' + floattostr(L));
  end;

begin
  n := 2;
  y[0] := 0;
  y[1] := 2;
  y[2] := 0;
  memo.lines.add('n = ' + inttostr(n));
  memo.lines.add('L = ' + floattostr(L));

//encontrar y[1], y[2], y[3], lambda = y[n + 1] tais que:
{
  flag := y[1] + y[2] + y[3] = n;
  flag := partial(1) = y[n+1]/n;
  flag := partial(2) = y[n+1]/n;
  flag := partial(3) = y[n+1]/n;
}

  Executar(10);
end;

procedure TFormPrincipal.Panel1DblClick(Sender: TObject);
begin
  memo.height := 500;
  Panel1.Height := 500;
end;

end.

