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
    Memo: TMemo;
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
    razao,
    Qx, Qy,
    x, y, z: real;
    unitario: array[1..3] of Txy;

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

Procedure Marca(x, y: real; raio: byte);
var r: TRect;
begin
   r.Left := PosX(x) - raio;
   r.Top := PosY(y) - raio;
   r.Right := r.left + 2 * raio;
   r.Bottom := r.Top + 2 * raio;
   Canvas.FillRect(r);
end;

var k: integer;

begin
   Refresh;
   btnDefault.Enabled := false;

   ScreenTopLeft.x := 0;
   ScreenTopLeft.y := 0;
   ScreenBottomRight.x := 804;
   ScreenBottomRight.y := 535;
   razao := ScreenBottomRight.y / ScreenBottomRight.x; // multiplique por y para círculos
   BottomLeft.x := -1;
   BottomLeft.y := -20;
   TopRight.x := 20;
   TopRight.y := 20;
   Qx := (ScreenBottomRight.x - ScreenTopLeft.x) / (TopRight.x - BottomLeft.x);
   Qy := (ScreenBottomRight.y - ScreenTopLeft.y) / (TopRight.y - BottomLeft.y);
   if Qx > Qy
     then razao := 1/Qx
     else razao := 1/Qy;  // utilize razao para incrementar
   lbStatus.Caption := Format('Inf.esq. = (%0.2f; %0.2f); Sup.dir. = (%0.2f; %0.2f)', [BottomLeft.x, BottomLeft.y, TopRight.x, TopRight.y]);
   Application.ProcessMessages;

  unitario[1].SetXY(1, -1);
  unitario[2].SetXY(1, 1);
  unitario[3].SetXY(0, 1);


   canvas.pen.color := clBlack;
   canvas.brush.color := clBlue;
   x := ScreenTopLeft.y + TopRight.y * Qy;  // ordenada de Ox
   line( ScreenTopLeft.x, round(x),  ScreenBottomRight.x, round(x) );
   x := ScreenTopLeft.x - BottomLeft.x * Qx;  // abscissa de Oy
   line( round(x), ScreenTopLeft.y,  round(x), ScreenBottomRight.y );

   x := 0.1;
   while x <= topright.x do
   begin
     y := bottomleft.y;
     while y < topright.y do
     begin
       canvas.Brush.color := clblue;
       k := -1;
       if abs(x*cos(y) - ln(x)) < 0.1 then
         if abs(x*sin(y) - y - 2 * k * pi) < 0.1 then
         begin
           memo.lines.add(floattostr(x) + #9 + floattostr(y));
           marca(x,y, 3);
         end;
       {
       canvas.Brush.color := clred;
       k := -1;
       if abs(exp(x - 2*k*y*pi) * cos(y + 2*k*y*pi) - x) < 1 then
         if abs(exp(x - 2*k*y*pi) * sin(y + 2*k*y*pi) - y) < 1 then
           marca(x,y, 3);

       canvas.Brush.color := clblack;
       k := 0;
       if abs(exp(x - 2*k*y*pi) * cos(y + 2*k*y*pi) - x) < 1 then
         if abs(exp(x - 2*k*y*pi) * sin(y + 2*k*y*pi) - y) < 1 then
           marca(x,y, 3);
       }
       y := y + 1/qy;
     end;

     x := x + 1/qx;
   end;

   showmessage('done');
   memo.Show;
   exit;
// eixos 3D
   x := 0;
   while x < 3 do
   begin
     PontoXYZ(x, 0, 0, clBlack);
     PontoXYZ(0, x, 0, clBlack);
     PontoXYZ(0, 0, x, clBlack);
     x := x + razao;
   end;

// esfera
   x := -1;
   while x < 1 do
   begin
     y := -1;
     while y < 1 do
     begin
       z := 1 - x*x - y*y;
       if z >= 0 then
       begin
         PontoXYZ(x, y,  sqrt(z), clBlue);
         PontoXYZ(x, y, -sqrt(z), clBlue);
       end;
       y := y + razao;
     end;

     x := x + razao;
   end;

   btnDefault.Enabled := true;
end;

procedure TFormPrincipal.btnFecharClick(Sender: TObject);
begin
   close;
end;

end.
