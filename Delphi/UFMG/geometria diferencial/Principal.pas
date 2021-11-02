unit Principal;

interface

uses
  Forms, Controls, StdCtrls, Classes, Graphics, Types, SysUtils, Dialogs,
  ExtCtrls;

type
  TFormPrincipal = class(TForm)
    TimerInit: TTimer;
    Lista: TListBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerInitTimer(Sender: TObject);
    procedure cbEixosClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListaClick(Sender: TObject);
  private
  public
    procedure ZerarUnitarios;
    procedure Mostrar;
    procedure Girar(eixo: char; plus: boolean = true);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses StdConvs;

{$R *.DFM}

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
    function projecao: Txy;
  end;

var // globais
  unitario: array[1..3] of Txy;

//só pra inicializar 1 única vez
  ScreenTopLeft: record
                   x,y: integer;
                 end;
  BottomLeft, TopRight: Txy;

// y = ax + b
procedure reta(p1, p2: Txy; var a, b: real);
begin
  a := (p2.y - p1.y) / (p2.x - p1.x);
  b := (p2.x * p1.y - p1.x * p2.y) / (p2.x - p1.x);
end;

function det(a, b, c, p, q, r, x, y, z: real): real;
begin
  result := a * (q * z - r * y) - b * (p * z - r * x) + c * (p * y - q * x);
end;

// em torno de i
procedure RotacaoX(var p: Txyz; theta: real);
var pLinha: Txyz;
begin
  pLinha.x := p.x;
  pLinha.y := p.y * cos(theta) - p.z * sin(theta);
  pLinha.z := p.y * sin(theta) + p.z * cos(theta);
  p := pLinha;
end;

// em torno de j
procedure RotacaoY(var p: Txyz; theta: real);
var pLinha: Txyz;
begin
  pLinha.x := p.x * cos(theta) - p.z * sin(theta);
  pLinha.y := p.y;
  pLinha.z := p.x * sin(theta) + p.z * cos(theta);
  p := pLinha;
end;

// em torno de k
procedure RotacaoZ(var p: Txyz; theta: real);
var pLinha: Txyz;
begin
  pLinha.x := p.x * cos(theta) - p.y * sin(theta);
  pLinha.y := p.x * sin(theta) + p.y * cos(theta);
  pLinha.z := p.z;
  p := pLinha;
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

// projeta no plano xy da tela
function Txyz.Projecao: Txy;
begin
  Result.x := x * unitario[1].x + y * unitario[2].x + z * unitario[3].x;
  Result.y := x * unitario[1].y + y * unitario[2].y + z * unitario[3].y;
end;

procedure TFormPrincipal.ZerarUnitarios;
begin
  if Lista.itemIndex = 0 then // faixa de moebius
  begin
    unitario[1].SetXY(2/3, -2/3);
    unitario[2].SetXY(2/3, 2/3);
    unitario[3].SetXY(0, 2/3);
  end
  else
  begin
    unitario[1].SetXY(1, -1);
    unitario[2].SetXY(1, 1);
    unitario[3].SetXY(0, 1);
  end;
end;

procedure TFormPrincipal.Girar(eixo: char; plus: boolean = true);
var theta: real;
    e: array[1..3] of Txyz;
    eLinha: array[1..3] of Txy;
    i: byte;
begin
  theta := pi/18;
  if not plus then
    theta := -theta;

//girar os eixos
  e[1].SetXYZ(1,0,0);
  e[2].SetXYZ(0,1,0);
  e[3].SetXYZ(0,0,1);
  for i := 1 to 3 do
  begin
    case eixo of
      'X': RotacaoX(e[i], theta);
      'Y': RotacaoY(e[i], theta);
      'Z': RotacaoZ(e[i], theta);
    end;

    eLinha[i] := e[i].projecao;
  end;

//só posso mudar os unitários depois
  for i := 1 to 3 do
    unitario[i] := eLinha[i];

  Mostrar;
end;

procedure TFormPrincipal.FormKeyPress(Sender: TObject; var Key: Char);
begin
  key := upcase(key);
  case key of
    #27: close;
    'Q': Girar('X');
    'A': Girar('X', false);
    'W': Girar('Y');
    'S': Girar('Y', false);
    'E': Girar('Z');
    'D': Girar('Z', false);
    '0': begin
           ZerarUnitarios;
           Mostrar;
         end;
  end;
  key := #0;
end;

procedure TFormPrincipal.Mostrar;

var Qx, Qy: real;

Function PosX(a: real): integer; // 2D
begin
  result := ScreenTopLeft.x + round( (a - BottomLeft.x) * Qx )
end;

Function PosY(b: real): integer; // 2D
begin
  result := ScreenTopLeft.y + round( (TopRight.y - b) * Qy )
end;

var N: byte;

procedure Eixos3D;
var p: Txyz;
    pLinha: Txy;
    t, u, v, R, a, b, c: real;
begin
  Refresh;
  Canvas.Pen.Color := clFuchsia;
  p.SetXYZ(3,0,0);
  pLinha := p.projecao;
  Canvas.MoveTo(posx(pLinha.x), posy(pLinha.y));
  p.x := 0;
  pLinha := p.projecao;
  Canvas.LineTo(posx(pLinha.x), posy(pLinha.y)); //x
  p.y := 3;
  pLinha := p.projecao;
  Canvas.LineTo(posx(pLinha.x), posy(pLinha.y)); //y
  p.y := 0;
  pLinha := p.projecao;
  Canvas.MoveTo(posx(pLinha.x), posy(pLinha.y));
  p.z := 3;
  pLinha := p.projecao;
  Canvas.LineTo(posx(pLinha.x), posy(pLinha.y)); //z

  p.SetXYZ(2, 0, 0);
  pLinha := p.projecao;
  Canvas.TextOut(posx(pLinha.x), posy(pLinha.y), 'x');
  p.SetXYZ(0, 2, 0);
  pLinha := p.projecao;
  Canvas.TextOut(posx(pLinha.x), posy(pLinha.y), 'y');
  p.SetXYZ(0, 0, 3);
  pLinha := p.projecao;
  Canvas.TextOut(posx(pLinha.x), posy(pLinha.y), 'z');

  if lista.ItemIndex = 0 then
  begin
    R := 2;

    u := 0;
    while u < 4 * pi do
    begin
      v := -1;
      while v < 1 do
      begin
        p.x := (R + v * cos(u/2)) * cos(u);
        p.y := (R + v * cos(u/2)) * sin(u);
        p.z := v * sin(u/2);
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        v := v + 1/Qx;
      end;

      u := u + pi/50;
    end;

    u := 0;
    while u < 4 * pi do
    begin
      v := -1;
      while v < 1 do
      begin
        p.x := (R + v * cos(u/2)) * cos(u);
        p.y := (R + v * cos(u/2)) * sin(u);
        p.z := v * sin(u/2);
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        v := v + 0.1;
      end;

      u := u + 1/Qx;
    end;
  end
  else if lista.itemIndex = 1 then // esfera
  begin
    R := 1.7;

    u := 0;
    while u < 2 * pi do
    begin
      v := -pi/2;
      while v < pi/2 do
      begin
        p.x := R * cos(v) * cos(u);
        p.y := R * cos(v) * sin(u);
        p.z := R * sin(v);
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        v := v + 0.25/Qx;
      end;

      u := u + pi/10;
    end;

    u := 0;
    while u < 2 * pi do
    begin
      v := -pi/2;
      while v < pi/2 do
      begin
        p.x := R * cos(v) * cos(u);
        p.y := R * cos(v) * sin(u);
        p.z := R * sin(v);
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        v := v + pi/10;
      end;

      u := u + 0.25/Qx;
    end;
  end
  else if lista.itemIndex = 2 then // elipsoide
  begin
    a := 1.7;
    b := 1.7 / 2;
    c := 1.7 * 2/3;

    u := 0;
    while u < 2 * pi do
    begin
      v := -pi/2;
      while v < pi/2 do
      begin
        p.x := a * cos(v) * cos(u);
        p.y := b * cos(v) * sin(u);
        p.z := c * sin(v);
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        v := v + 0.25/Qx;
      end;

      u := u + pi/10;
    end;

    u := 0;
    while u < 2 * pi do
    begin
      v := -pi/2;
      while v < pi/2 do
      begin
        p.x := a * cos(v) * cos(u);
        p.y := b * cos(v) * sin(u);
        p.z := c * sin(v);
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        v := v + pi/10;
      end;

      u := u + 0.25/Qx;
    end;
  end
  else if lista.itemIndex = 3 then // paraboloide eliptico
  begin
    a := 2;
    b := 3;

    u := -1.5;
    while u <= 1.5 do
    begin
      v := -1.5;
      while v <= 1.5 do
      begin
        p.x := u;
        p.y := v;
        p.z := sqr(u)/sqr(a) + sqr(v)/sqr(b);
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        v := v + 0.5/Qx;
      end;

      u := u + 0.1;
    end;

    u := -1.5;
    while u <= 1.5 do
    begin
      v := -1.5;
      while v <= 1.5 do
      begin
        p.x := u;
        p.y := v;
        p.z := sqr(u)/sqr(a) + sqr(v)/sqr(b);
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        v := v + 0.1;
      end;

      u := u + 0.5/Qx;
    end;
  end
  else if lista.itemIndex = 4 then // paraboloide hiperbolico
  begin
    a := 2;
    b := 3;

    u := -1.5;
    while u <= 1.5 do
    begin
      v := -1.5;
      while v <= 1.5 do
      begin
        p.x := u;
        p.y := v;
        p.z := sqr(u)/sqr(a) - sqr(v)/sqr(b);
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        v := v + 0.5/Qx;
      end;

      u := u + 0.1;
    end;

    u := -1.5;
    while u <= 1.5 do
    begin
      v := -1.5;
      while v <= 1.5 do
      begin
        p.x := u;
        p.y := v;
        p.z := sqr(u)/sqr(a) - sqr(v)/sqr(b);
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        v := v + 0.1;
      end;

      u := u + 0.5/Qx;
    end;
  end
  else if lista.itemIndex = 5 then // hiperboloide de uma folha
  begin
    a := 1.7;
    b := 1.7 / 2;
    c := 1.7 * 2/3;

    u := 0;
    while u < 2 * pi do
    begin
      v := -0.7;
      while v <= 0.7 do
      begin
        p.x := a * sqrt(1 + sqr(v)/sqr(c)) * cos(u);
        p.y := b * sqrt(1 + sqr(v)/sqr(c)) * sin(u);
        p.z := v;
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        v := v + 0.25/Qx;
      end;

      u := u + pi/10;
    end;

    u := 0;
    while u < 2 * pi do
    begin
      v := -0.7;
      while v <= 0.7 do
      begin
        p.x := a * sqrt(1 + sqr(v)/sqr(c)) * cos(u);
        p.y := b * sqrt(1 + sqr(v)/sqr(c)) * sin(u);
        p.z := v;
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        v := v + 0.2;
      end;

      u := u + 0.25/Qx;
    end;
  end
  else if lista.itemIndex = 6 then // paraboloide eliptico
  begin
    a := 2;
    b := 3;
    c := 1;

    u := -1.25;
    while u <= 1.25 do
    begin
      v := -1.25;
      while v <= 1.25 do
      begin
        p.x := u;
        p.y := v;
        p.z := c * sqrt(1 + sqr(u)/sqr(a) + sqr(v)/sqr(b) );
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        v := v + 0.5/Qx;
      end;

      u := u + 0.1;
    end;

    u := -1.25;
    while u <= 1.25 do
    begin
      v := -1.25;
      while v <= 1.25 do
      begin
        p.x := u;
        p.y := v;
        p.z := c * sqrt(1 + sqr(u)/sqr(a) + sqr(v)/sqr(b) );
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        v := v + 0.1;
      end;

      u := u + 0.5/Qx;
    end;
    c := -1;

    u := -1.25;
    while u <= 1.25 do
    begin
      v := -1.25;
      while v <= 1.25 do
      begin
        p.x := u;
        p.y := v;
        p.z := c * sqrt(1 + sqr(u)/sqr(a) + sqr(v)/sqr(b) );
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        v := v + 0.5/Qx;
      end;

      u := u + 0.1;
    end;

    u := -1.25;
    while u <= 1.25 do
    begin
      v := -1.25;
      while v <= 1.25 do
      begin
        p.x := u;
        p.y := v;
        p.z := c * sqrt(1 + sqr(u)/sqr(a) + sqr(v)/sqr(b) );
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        v := v + 0.1;
      end;

      u := u + 0.5/Qx;
    end;
  end
  else if lista.itemIndex = 7 then // cilindro
  begin
    R := 1.7;

    u := 0;
    while u < 2 * pi do
    begin
      v := -1;
      while v < 1 do
      begin
        p.x := R * cos(u);
        p.y := R * sin(u);
        p.z := v;
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        v := v + 0.25/Qx;
      end;

      u := u + pi/10;
    end;

    u := 0;
    while u < 2 * pi do
    begin
      v := -1;
      while v < 1 do
      begin
        p.x := R * cos(u);
        p.y := R * sin(u);
        p.z := v;
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        v := v + 0.2;
      end;

      u := u + 0.25/Qx;
    end;
  end
  else if lista.itemIndex = 8 then // cone
  begin
    a := 1.4;
    b := 1.4;

    u := 0;
    while u < 2 * pi do
    begin
      v := -1;
      while v < 1 do
      begin
        p.x := a*v * cos(u);
        p.y := a*v * sin(u);
        p.z := b*v;
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        v := v + 0.25/Qx;
      end;

      u := u + pi/10;
    end;

    u := 0;
    while u < 2 * pi do
    begin
      v := -1;
      while v < 1 do
      begin
        p.x := a*v * cos(u);
        p.y := a*v * sin(u);
        p.z := b*v;
        pLinha := p.projecao;
        canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        v := v + 0.2;
      end;

      u := u + 0.25/Qx;
    end;
  end
  else if lista.itemIndex = 9 then // superficie minima de Scherk
  begin
    a := 2;

    u := -1.5;
    while u <= 1.5 do
    begin
      v := -1.5;
      while v <= 1.5 do
      begin
        p.x := u;
        p.y := v;
        p.z := cos(a*u)/cos(a*v);
        if p.z > 0 then
        begin
          p.z := 1/a * ln(p.z);
          pLinha := p.projecao;
          canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlue;
        end;
        v := v + 0.05/Qx;
      end;

      u := u + 0.1;
    end;

    u := -1.5;
    while u <= 1.5 do
    begin
      v := -1.5;
      while v <= 1.5 do
      begin
        p.x := u;
        p.y := v;
        p.z := cos(a*u)/cos(a*v);
        if p.z > 0 then
        begin
          p.z := 1/a * ln(p.z);
          pLinha := p.projecao;
          canvas.Pixels[PosX(pLinha.x), PosY(pLinha.y)] := clBlack;
        end;
        v := v + 0.1;
      end;

      u := u + 0.05/Qx;
    end;
  end
end;

var
  ScreenBottomRight: record
                       x,y: integer;
                     end;
  i,j,k: byte;
  s: string;
  oLinha: Txy; // O = centro do cubo
  detCubo: array[1..27] of record
                         h: array[1..8] of real;
                         hmin: real;
                         plotou: boolean;
                       end;

begin
  ScreenBottomRight.x := width;
  ScreenBottomRight.y := height;
  Qx := (ScreenBottomRight.x - ScreenTopLeft.x) / (TopRight.x - BottomLeft.x);
  Qy := (ScreenBottomRight.y - ScreenTopLeft.y) / (TopRight.y - BottomLeft.y);

  Eixos3D;
end;

procedure TFormPrincipal.TimerInitTimer(Sender: TObject);
begin
  TimerInit.Enabled := false;
  Lista.ItemIndex := 0;
  ZerarUnitarios;
  Mostrar;
end;

procedure TFormPrincipal.cbEixosClick(Sender: TObject);
begin
  Mostrar;
end;

procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  Mostrar;
end;

procedure TFormPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: byte;
begin
  case key of
  //F1
    112: for i := 1 to 9 do
           Girar('X');
  //F2
    113: for i := 1 to 9 do
           Girar('Y');
  //F3
    114: for i := 1 to 9 do
           Girar('Z');
  end;
end;

procedure TFormPrincipal.ListaClick(Sender: TObject);
begin
  ZerarUnitarios;
  Mostrar;
end;

initialization
  ScreenTopLeft.x := 0;
  ScreenTopLeft.y := 0;
  BottomLeft.x := -5;
  BottomLeft.y := -4;
  TopRight.x := 5;
  TopRight.y := 4;
end.
