unit Principal;

interface

uses
  Forms, Controls, StdCtrls, Classes, Graphics, Types, SysUtils, Dialogs,
  ExtCtrls;

type
  TFormPrincipal = class(TForm)
    TimerInit: TTimer;
    Panel: TPanel;
    cbEixos: TCheckBox;
    EditR1: TLabeledEdit;
    Editr2: TLabeledEdit;
    EditN: TLabeledEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerInitTimer(Sender: TObject);
    procedure cbEixosClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditR1Change(Sender: TObject);
    procedure EditNKeyPress(Sender: TObject; var Key: Char);
  public
    procedure MostrarCubos;
    procedure Girar(eixo: char; plus: boolean = true);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses Cores, StdConvs;

{$R *.DFM}

type
  Txy = object
  public
    x, y: real;
    procedure SetXY(newX, newY: real);
  end;

  Txyz = object
  public
    x, y, z: real;
    procedure SetXYZ(newX, newY, newZ: real);
    function projecao: Txy;
  end;

var // globais
  unitario: array[1..3] of Txy;
  cor: array[1..6] of TColor;

//só pra inicializar 1 única vez
  ScreenTopLeft: record
    x, y: integer;
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

// será q P está dentro do paralelogramo ABCD? (Cubo N)

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

function media(a, b: Txyz): Txyz;
begin
  result.x := (a.x + b.x) / 2;
  result.y := (a.y + b.y) / 2;
  result.z := (a.z + b.z) / 2;
end;

procedure ZerarCubos;
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
  theta := pi / 18;
  if not plus then
    theta := -theta;

//girar os eixos
  e[1].SetXYZ(1, 0, 0);
  e[2].SetXYZ(0, 1, 0);
  e[3].SetXYZ(0, 0, 1);
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

  MostrarCubos;
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
    'Z': begin
        ZerarCubos;
        MostrarCubos;
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
          MostrarCubos;
        end
        else FormCores.Free;
      end;
  end;
end;

procedure TFormPrincipal.MostrarCubos;

var Qx, Qy: real;
    razao: real;
    x, y, z, fi, R1, r2, n, f, soma: real;

  function PosX(a: real): integer; // 2D
  begin
    result := ScreenTopLeft.x + round((a - BottomLeft.x) * Qx)
  end;

  function PosY(b: real): integer; // 2D
  begin
    result := ScreenTopLeft.y + round((TopRight.y - b) * Qy)
  end;

  procedure PontoXY(x, y: real; cor: TColor);
  begin
    if (BottomLeft.x <= x) and (x <= TopRight.x) and (BottomLeft.y <= y) and (y <= TopRight.y) then
      canvas.Pixels[PosX(x), PosY(y)] := cor;
  end;

  procedure PontoXYZ(x, y, z: real; cor: TColor);
  begin
    PontoXY(x * unitario[1].x + y * unitario[2].x + z * unitario[3].x,
      x * unitario[1].y + y * unitario[2].y + z * unitario[3].y, cor);
  end;

  procedure Eixos3D;
  var p: Txyz;
    pLinha: Txy;
    t, razao, lat, long: double;
  const r = 1;
  begin
    Refresh;
    if cbEixos.Checked then
    begin
      Canvas.Pen.Color := clFuchsia;
      p.SetXYZ(3, 0, 0);
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
    end;

    if Qx > Qy
      then razao := 1 / Qx
    else razao := 1 / Qy; // utilize razao para incrementar

   try
     R1 := StrToFloat(EditR1.text);
     r2 := StrToFloat(Editr2.text);
     n := StrToFloat(EditN.text);
   except
     exit;
   end;

// espiral
   fi := 0;
   razao := razao / 50;
   while fi < 2*pi do
   begin
     x := (R1 + r2 * cos(n * fi)) * cos(fi);
     y := r2 * sin(n * fi);
     z := (R1 + r2 * cos(n * fi)) * sin(fi);
     PontoXYZ(x, y, z, clBlue);
     fi := fi + razao;
   end;

   if cbEixos.Checked then
   begin
     fi := 0;
     razao := 1e-6;
     soma := 0;
     while fi < 2*pi do
     begin
       x := (R1 + r2 * cos(n * fi)) * cos(fi);
       y := r2 * sin(n * fi);
       z := (R1 + r2 * cos(n * fi)) * sin(fi);
       f := sqrt(sqr(n * r2) + sqr(R1 + r2 * cos(n * fi)));
     //integral f d fi de zero a 2 pi
       soma := soma + f * razao;
       fi := fi + razao;
     end;
     showmessage('Comprimento = ' + floattostr(soma));
   end
end;

var
  ScreenBottomRight: record
    x, y: integer;
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
  MostrarCubos;
end;

procedure TFormPrincipal.cbEixosClick(Sender: TObject);
begin
  MostrarCubos;
end;

procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  MostrarCubos;
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

procedure TFormPrincipal.EditR1Change(Sender: TObject);
begin
  MostrarCubos;
end;

procedure TFormPrincipal.EditNKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',',','-']) then
  begin
    FormKeyPress(sender, key);
    key := #0;
  end;
end;

initialization
  ZerarCubos;

  ScreenTopLeft.x := 0;
  ScreenTopLeft.y := 0;
  BottomLeft.x := -5;
  BottomLeft.y := -4;
  TopRight.x := 5;
  TopRight.y := 4;

//faces opostas
  cor[1] := clWhite; //ABCD
  cor[2] := clYellow; //EFGH

  cor[3] := clGreen; //ABFE
  cor[4] := clBlue; //BCGF

  cor[5] := clPurple; //CDHG
  cor[6] := clRed; //ADHE
end.

