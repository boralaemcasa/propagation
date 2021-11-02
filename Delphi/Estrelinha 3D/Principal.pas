(************************************
		Cubo - form principal
		www.freewebs.com/claudino
		vinicius_alvorecer@yahoo.com.br
 ************************************)
unit Principal;

interface

uses
  Forms, Controls, StdCtrls, Classes, Graphics, Types, SysUtils, Dialogs,
  ExtCtrls;

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

type
  TFormPrincipal = class(TForm)
    img: TImage;
    TimerInit: TTimer;
    cbEixos: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerInitTimer(Sender: TObject);
    procedure cbEixosClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    function intersect(a, b, c, d: Txyz): Txyz;
  public
    procedure MostrarCubo;
    procedure Girar(eixo: char; plus: boolean = true);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses Cores;

{$R *.DFM}

var
//só pra inicializar 1 única vez
  ScreenTopLeft: record
                   x,y: integer;
                 end;
  BottomLeft, TopRight: Txy;
  unitario: array[1..3] of Txy;
  tempFile: string;
  cor: array[1..6] of TColor;

procedure RotacaoX(var p: Txyz; theta: real);
var pLinha: Txyz;
begin
  pLinha.x := p.x;
  pLinha.y := p.y * cos(theta) - p.z * sin(theta);
  pLinha.z := p.y * sin(theta) + p.z * cos(theta);
  p := pLinha;
end;

procedure RotacaoY(var p: Txyz; theta: real);
var pLinha: Txyz;
begin
  pLinha.x := p.x * cos(theta) - p.z * sin(theta);
  pLinha.y := p.y;
  pLinha.z := p.x * sin(theta) + p.z * cos(theta);
  p := pLinha;
end;

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

function Txyz.Projecao: Txy;
begin
  Result.x := self.x * unitario[1].x + self.y * unitario[2].x + self.z * unitario[3].x;
  Result.y := self.x * unitario[1].y + self.y * unitario[2].y + self.z * unitario[3].y;
end;

function media(a,b: Txyz): Txyz;
begin
  result.x := (a.x + b.x) / 2;
  result.y := (a.y + b.y) / 2;
  result.z := (a.z + b.z) / 2;
end;

procedure ZerarAngulos;
begin
  unitario[1].SetXY(1, -1);
  unitario[2].SetXY(1, 1);
  unitario[3].SetXY(0, 1);
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

  MostrarCubo;
end;

procedure TFormPrincipal.FormKeyPress(Sender: TObject; var Key: Char);
var i: byte;
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
    '1': for i := 1 to 9 do
           Girar('X');
    '2': for i := 1 to 9 do
           Girar('Y');
    '3': for i := 1 to 9 do
           Girar('Z');
    'Z': begin
           ZerarAngulos;
           MostrarCubo;
         end;
    'C': begin
           Application.CreateForm(TFormCores, FormCores);
           FormCores.Panel1.Color := cor[1];
           FormCores.Panel2.Color := cor[2];
           FormCores.Panel3.Color := cor[3];
           FormCores.Panel4.Color := cor[4];
           FormCores.Panel5.Color := cor[5];
           FormCores.Panel6.Color := cor[6];
           if FormCores.ShowModal = mrOK then
           begin
             cor[1] := FormCores.Panel1.Color;
             cor[2] := FormCores.Panel2.Color;
             cor[3] := FormCores.Panel3.Color;
             cor[4] := FormCores.Panel4.Color;
             cor[5] := FormCores.Panel5.Color;
             cor[6] := FormCores.Panel6.Color;
             FormCores.Free;
             MostrarCubo;
           end
           else FormCores.Free;
         end;
  end;
end;

procedure TFormPrincipal.MostrarCubo;

var Qx, Qy: real;

Function PosX(a: real): integer; overload;
begin
  result := ScreenTopLeft.x + round( (a - BottomLeft.x) * Qx )
end;

Function PosY(b: real): integer; overload;
begin
  result := ScreenTopLeft.y + round( (TopRight.y - b) * Qy )
end;

Function PosX(p: Txyz): integer; overload;
begin
  result := PosX(p.x * unitario[1].x + p.y * unitario[2].x + p.z * unitario[3].x);
end;

Function PosY(p: Txyz): integer; overload;
begin
  result := PosY(p.x * unitario[1].y + p.y * unitario[2].y + p.z * unitario[3].y);
end;

var
  bmp: TBitmap;
  x, razao: real;

procedure Eixos3D;

Procedure PontoXY(x, y: real; cor: TColor);
begin
  if (BottomLeft.x <= x) and (x <= TopRight.x) and (BottomLeft.y <= y) and (y <= TopRight.y) then
    bmp.canvas.Pixels[PosX(x), PosY(y)] := cor;
end;

Procedure PontoXYZ(x, y, z: real; cor: TColor);
begin
  PontoXY(x * unitario[1].x + y * unitario[2].x + z * unitario[3].x,
          x * unitario[1].y + y * unitario[2].y + z * unitario[3].y, cor);
end;

begin
  x := 0;
  while x < 3 do
  begin
    PontoXYZ(x, 0, 0, clFuchsia);
    PontoXYZ(0, x, 0, clFuchsia);
    PontoXYZ(0, 0, x, clFuchsia);
    x := x + razao;
  end;
end;

var
  ScreenBottomRight: record
                       x,y: integer;
                     end;
  //i: byte;
  s: string;
  a, b, c, d, e, f, g, h, i, j, k, l, m, n: Txyz;

  procedure estrela(raio: real; color: TColor; z: real);
  var a2, b2, c2, d2, e2, f2, g2, h2, i2, j2, k2, l2, m2, n2: Txy;
  begin
  bmp.canvas.pen.color := color;
  raio := raio / 7 * 1.5;
  z := raio;

  a.SetXYZ(raio * cos(pi/2), raio * sin(pi/2), z);
  b.SetXYZ(raio * cos(11*pi/14), raio * sin(11*pi/14), z);
  c.SetXYZ(raio * cos(15*pi/14), raio * sin(15*pi/14), z);
  d.SetXYZ(raio * cos(19*pi/14), raio * sin(19*pi/14), z);
  e.SetXYZ(raio * cos(23*pi/14), raio * sin(23*pi/14), z);
  f.SetXYZ(raio * cos(27*pi/14), raio * sin(27*pi/14), z);
  g.SetXYZ(raio * cos(3*pi/14), raio * sin(3*pi/14), z);

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

  a2 := a.projecao;
  b2 := b.projecao;
  c2 := c.projecao;
  d2 := d.projecao;
  e2 := e.projecao;
  f2 := f.projecao;
  g2 := g.projecao;
  h2 := h.projecao;
  i2 := i.projecao;
  j2 := j.projecao;
  k2 := k.projecao;
  l2 := l.projecao;
  m2 := m.projecao;
  n2 := n.projecao;
  bmp.canvas.moveto(posx(a2.x), posy(a2.y));
  bmp.canvas.lineto(posx(h2.x), posy(h2.y));

  bmp.canvas.lineto(posx(b2.x), posy(b2.y));
  bmp.canvas.lineto(posx(i2.x), posy(i2.y));

  bmp.canvas.lineto(posx(c2.x), posy(c2.y));
  bmp.canvas.lineto(posx(j2.x), posy(j2.y));

  bmp.canvas.lineto(posx(d2.x), posy(d2.y));
  bmp.canvas.lineto(posx(k2.x), posy(k2.y));

  bmp.canvas.lineto(posx(e2.x), posy(e2.y));
  bmp.canvas.lineto(posx(l2.x), posy(l2.y));

  bmp.canvas.lineto(posx(f2.x), posy(f2.y));
  bmp.canvas.lineto(posx(m2.x), posy(m2.y));

  bmp.canvas.lineto(posx(g2.x), posy(g2.y));
  bmp.canvas.lineto(posx(n2.x), posy(n2.y));

  bmp.canvas.lineto(posx(a2.x), posy(a2.y));
  end;

begin
  ScreenBottomRight.x := width;
  ScreenBottomRight.y := height;
  Qx := (ScreenBottomRight.x - ScreenTopLeft.x) / (TopRight.x - BottomLeft.x);
  Qy := (ScreenBottomRight.y - ScreenTopLeft.y) / (TopRight.y - BottomLeft.y);
  if Qx > Qy
    then razao := 1/Qx/10
    else razao := 1/Qy/10;  // utilize razao para incrementar

  bmp := TBitmap.Create;
  bmp.Width := width;
  bmp.Height := height;

//preencher o fundo de cinza
  bmp.Canvas.Brush.Color := clBtnFace;
  bmp.Canvas.FloodFill(posx(0), posy(0), clBtnFace, fsBorder);

  x := razao;
  while x <= 1 do
  begin
  Estrela(x, clRed, 0);
  x := x + razao;
  end;

  x := 1 + razao;
  while x <= 2 do
  begin
  Estrela(x, $00208FFF, 0);
  x := x + razao;
  end;

  x := 2 + razao;
  while x <= 3 do
  begin
  Estrela(x, clYellow, 0);
  x := x + razao;
  end;



  x := 3 + razao;
  while x <= 4 do
  begin
  Estrela(x, clGreen, 0);
  x := x + razao;
  end;

  x := 4 + razao;
  while x <= 5 do
  begin
  Estrela(x, clAqua, 0);
  x := x + razao;
  end;

  x := 5 + razao;
  while x <= 6 do
  begin
  Estrela(x, clBlue, 0);
  x := x + razao;
  end;

  x := 6 + razao;
  while x <= 7 do
  begin
  Estrela(x, clWhite, 0);
  x := x + razao;
  end;

  Estrela(7, clFuchsia, 0);

  if cbEixos.Checked then
    Eixos3D;

  bmp.SaveToFile(tempFile);
  bmp.free;
  img.Picture.LoadFromFile(tempFile);
  img.Refresh;
end;

procedure TFormPrincipal.TimerInitTimer(Sender: TObject);
begin
  TimerInit.Enabled := false;
  MostrarCubo;
end;

procedure TFormPrincipal.cbEixosClick(Sender: TObject);
begin
  MostrarCubo;
end;

procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  MostrarCubo;
end;

procedure TFormPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
var f: TextFile;
    i: byte;
begin
  AssignFile(f, ExtractFilePath(Application.ExeName) + 'cubo.ini');
  rewrite(f);
  writeln(f, '[Cores]');
  for i := 1 to 6 do
    writeln(f, cor[i]);
  writeln(f);
  writeln(f, '[CheckBoxes]');
  writeln(f, byte(cbEixos.checked));
  CloseFile(f);
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var f: TextFile;
    i: byte;
    s: string;
begin
  s := ExtractFilePath(Application.ExeName) + 'cubo.ini';
  if not FileExists(s) then
    exit;

  AssignFile(f, s);
  reset(f);
  readln(f);
  for i := 1 to 6 do
    readln(f, cor[i]);
  readln(f);
  readln(f);
  readln(f, i);
  cbEixos.checked := (i > 0);
  CloseFile(f);
end;

function TFormPrincipal.intersect(a,b,c,d: Txyz): Txyz;
var e: txyz;
    numerador, denominador: real;
begin
  numerador := (c.y - d.y) / (d.x - c.x) * c.x +
               (b.y - a.y) / (b.x - a.x) * a.x + c.y - a.y;
  denominador := (b.y - a.y) / (b.x - a.x) + (c.y - d.y) / (d.x - c.x);
  e.x := numerador / denominador;
  e.y := (b.y - a.y) / (b.x - a.x) * e.x +
         (a.y - b.y) / (b.x - a.x) * a.x + a.y;
  e.z := a.z;
  result := e;
end;


initialization
  ZerarAngulos;

  ScreenTopLeft.x := 0;
  ScreenTopLeft.y := 0;
  BottomLeft.x := -5;
  BottomLeft.y := -4;
  TopRight.x := 5;
  TopRight.y := 4;
  unitario[1].SetXY(1, -1);
  unitario[2].SetXY(1, 1);
  unitario[3].SetXY(0, 1);

//faces opostas
  cor[1] := clWhite;  //ABCD
  cor[2] := clYellow; //EFGH

  cor[3] := clGreen;  //ABFE
  cor[4] := clBlue;   //BCGF

  cor[5] := clPurple; //CDHG
  cor[6] := clRed;    //ADHE

  tempFile := ExtractFilePath(Application.ExeName) + 'cubo_temp.bmp';
end.
