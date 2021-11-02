unit Principal;

interface

uses
  Forms, Controls, StdCtrls, Classes, Graphics, Types, SysUtils, Dialogs,
  ExtCtrls;

type
  TFormPrincipal = class(TForm)
    img: TImage;
    TimerInit: TTimer;
    Panel: TPanel;
    rgSentido: TRadioGroup;
    btnOK: TButton;
    rgEixo: TRadioGroup;
    rgPosicao: TRadioGroup;
    cbEixos: TCheckBox;
    cbPintar: TCheckBox;
    cbNumerar: TCheckBox;
    cbDistanciar: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerInitTimer(Sender: TObject);
    procedure cbEixosClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure cbDistanciarClick(Sender: TObject);
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
    x,y: real;
    procedure SetXY(newX, newY: real);
  end;

  Txyz = object
  public
    x,y,z: real;
    procedure SetXYZ(newX, newY, newZ: real);
    function projecao: Txy;
  end;

  TCubo = array[1..27] of record
                            v: array[1..8] of Txyz;
                          end;

var // globais
  cubo, cubo2: TCubo;
  cor: array[1..6] of TColor;
  ordem: array[1..27] of byte; // qual cubo está na posiçao 1..27?
  anel: array[0..2, 0..2, 0..8] of ^byte;
  unitario: array[1..3] of Txy;

//só pra inicializar 1 única vez
  ScreenTopLeft: record
                   x,y: integer;
                 end;
  BottomLeft, TopRight: Txy;
  tempFile: string;

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
function DentroFace(N, P, A, B, C, D: byte): boolean;
var pLinha, aLinha, bLinha, cLinha, dLinha: Txy;
    m, k, y1, y2: real;
begin
  pLinha := cubo[N].v[p].projecao;
  aLinha := cubo[N].v[a].projecao;
  bLinha := cubo[N].v[b].projecao;
  cLinha := cubo[N].v[c].projecao;
  dLinha := cubo[N].v[d].projecao;

  if aLinha.x > bLinha.x then
  begin
    Result := DentroFace(N, P, B, C, D, A);
    exit;
  end;

  if aLinha.x > dLinha.x then // D < A <= B
  begin
    Result := DentroFace(N, P, D, C, B, A);
    exit;
  end;

  if bLinha.x > dLinha.x then // A <= D < B
  begin
    Result := DentroFace(N, P, A, D, C, B);
    exit;
  end;

  if (pLinha.x <= aLinha.x) or (pLinha.x >= cLinha.x) then
  begin
    Result := false;
    exit;
  end;

  if pLinha.x <= bLinha.x then // A < P <= B: entre AB e AD
  begin
    reta(aLinha, bLinha, m, k);
    y1 := m * pLinha.x + k;
    reta(aLinha, dLinha, m, k);
    y2 := m * pLinha.x + k;
  end
  else if pLinha.x <= dLinha.x then // B < P <= D: entre BC e AD
  begin
    reta(bLinha, cLinha, m, k);
    y1 := m * pLinha.x + k;
    reta(aLinha, dLinha, m, k);
    y2 := m * pLinha.x + k;
  end
  else begin // D < P < C: entre BC e CD
    reta(bLinha, cLinha, m, k);
    y1 := m * pLinha.x + k;
    reta(cLinha, dLinha, m, k);
    y2 := m * pLinha.x + k;
  end;

  if (y1 < pLinha.y) and (pLinha.y < y2) then
    result := true
  else if (y2 < pLinha.y) and (pLinha.y < y1) then
    result := true
  else result := false;
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

function media(a,b: Txyz): Txyz;
begin
  result.x := (a.x + b.x) / 2;
  result.y := (a.y + b.y) / 2;
  result.z := (a.z + b.z) / 2;
end;

procedure ZerarCubos;
var N, i: byte;
begin
  unitario[1].SetXY(1, -1);
  unitario[2].SetXY(1, 1);
  unitario[3].SetXY(0, 1);

  for i := 1 to 27 do
    ordem[i] := i;

  cubo[1].v[1].SetXYZ(-1/3,-1/3,-1);
  cubo[1].v[2].SetXYZ(-1/3,-1  ,-1);
  cubo[1].v[3].SetXYZ(-1  ,-1  ,-1);
  cubo[1].v[4].SetXYZ(-1  ,-1/3,-1);

  cubo[2].v[1].SetXYZ( 1/3,-1/3,-1);
  cubo[2].v[2].SetXYZ( 1/3,-1  ,-1);
  cubo[2].v[3].SetXYZ(-1/3,-1  ,-1);
  cubo[2].v[4].SetXYZ(-1/3,-1/3,-1);

  cubo[3].v[1].SetXYZ(1  ,-1/3,-1);
  cubo[3].v[2].SetXYZ(1  ,-1  ,-1);
  cubo[3].v[3].SetXYZ(1/3,-1  ,-1);
  cubo[3].v[4].SetXYZ(1/3,-1/3,-1);

  cubo[4].v[1].SetXYZ(-1/3, 1/3,-1);
  cubo[4].v[2].SetXYZ(-1/3,-1/3,-1);
  cubo[4].v[3].SetXYZ(-1  ,-1/3,-1);
  cubo[4].v[4].SetXYZ(-1  , 1/3,-1);

  cubo[5].v[1].SetXYZ( 1/3, 1/3,-1);
  cubo[5].v[2].SetXYZ( 1/3,-1/3,-1);
  cubo[5].v[3].SetXYZ(-1/3,-1/3,-1);
  cubo[5].v[4].SetXYZ(-1/3, 1/3,-1);

  cubo[6].v[1].SetXYZ(1  , 1/3,-1);
  cubo[6].v[2].SetXYZ(1  ,-1/3,-1);
  cubo[6].v[3].SetXYZ(1/3,-1/3,-1);
  cubo[6].v[4].SetXYZ(1/3, 1/3,-1);

  cubo[7].v[1].SetXYZ(-1/3, 1  ,-1);
  cubo[7].v[2].SetXYZ(-1/3, 1/3,-1);
  cubo[7].v[3].SetXYZ(-1  , 1/3,-1);
  cubo[7].v[4].SetXYZ(-1  , 1  ,-1);

  cubo[8].v[1].SetXYZ( 1/3, 1  ,-1);
  cubo[8].v[2].SetXYZ( 1/3, 1/3,-1);
  cubo[8].v[3].SetXYZ(-1/3, 1/3,-1);
  cubo[8].v[4].SetXYZ(-1/3, 1  ,-1);

  cubo[9].v[1].SetXYZ(1  , 1  ,-1);
  cubo[9].v[2].SetXYZ(1  , 1/3,-1);
  cubo[9].v[3].SetXYZ(1/3, 1/3,-1);
  cubo[9].v[4].SetXYZ(1/3, 1  ,-1);

//vértices 5 a 8
  for N := 1 to 9 do
    for i := 1 to 4 do
      cubo[N].v[i + 4].SetXYZ(cubo[N].v[i].x, cubo[N].v[i].y, -1/3);

//cubos 10 a 18
  for N := 10 to 18 do
  begin
    cubo[N] := cubo[N - 9];
    for i := 1 to 4 do
      cubo[N].v[i].z := -1/3;
    for i := 5 to 8 do
      cubo[N].v[i].z := 1/3;
  end;

//cubos 19 a 27
  for N := 19 to 27 do
  begin
    cubo[N] := cubo[N - 18];
    for i := 1 to 4 do
      cubo[N].v[i].z := 1/3;
    for i := 5 to 8 do
      cubo[N].v[i].z := 1;
  end;

  cubo2[1].v[1].SetXYZ(-0.6,-0.6,-1);
  cubo2[1].v[2].SetXYZ(-0.6,-1  ,-1);
  cubo2[1].v[3].SetXYZ(-1  ,-1  ,-1);
  cubo2[1].v[4].SetXYZ(-1  ,-0.6,-1);

  cubo2[2].v[1].SetXYZ( 0.2,-0.6,-1);
  cubo2[2].v[2].SetXYZ( 0.2,-1  ,-1);
  cubo2[2].v[3].SetXYZ(-0.2,-1  ,-1);
  cubo2[2].v[4].SetXYZ(-0.2,-0.6,-1);

  cubo2[3].v[1].SetXYZ(1  ,-0.6,-1);
  cubo2[3].v[2].SetXYZ(1  ,-1  ,-1);
  cubo2[3].v[3].SetXYZ(0.6,-1  ,-1);
  cubo2[3].v[4].SetXYZ(0.6,-0.6,-1);

  cubo2[4].v[1].SetXYZ(-0.6, 0.2,-1);
  cubo2[4].v[2].SetXYZ(-0.6,-0.2,-1);
  cubo2[4].v[3].SetXYZ(-1  ,-0.2,-1);
  cubo2[4].v[4].SetXYZ(-1  , 0.2,-1);

  cubo2[5].v[1].SetXYZ( 0.2, 0.2,-1);
  cubo2[5].v[2].SetXYZ( 0.2,-0.2,-1);
  cubo2[5].v[3].SetXYZ(-0.2,-0.2,-1);
  cubo2[5].v[4].SetXYZ(-0.2, 0.2,-1);

  cubo2[6].v[1].SetXYZ(1  , 0.2,-1);
  cubo2[6].v[2].SetXYZ(1  ,-0.2,-1);
  cubo2[6].v[3].SetXYZ(0.6,-0.2,-1);
  cubo2[6].v[4].SetXYZ(0.6, 0.2,-1);

  cubo2[7].v[1].SetXYZ(-0.6, 1  ,-1);
  cubo2[7].v[2].SetXYZ(-0.6, 0.6,-1);
  cubo2[7].v[3].SetXYZ(-1  , 0.6,-1);
  cubo2[7].v[4].SetXYZ(-1  , 1  ,-1);

  cubo2[8].v[1].SetXYZ( 0.2, 1  ,-1);
  cubo2[8].v[2].SetXYZ( 0.2, 0.6,-1);
  cubo2[8].v[3].SetXYZ(-0.2, 0.6,-1);
  cubo2[8].v[4].SetXYZ(-0.2, 1  ,-1);

  cubo2[9].v[1].SetXYZ(1  , 1  ,-1);
  cubo2[9].v[2].SetXYZ(1  , 0.6,-1);
  cubo2[9].v[3].SetXYZ(0.6, 0.6,-1);
  cubo2[9].v[4].SetXYZ(0.6, 1  ,-1);

//vértices 5 a 8
  for N := 1 to 9 do
    for i := 1 to 4 do
      cubo2[N].v[i + 4].SetXYZ(cubo2[N].v[i].x, cubo2[N].v[i].y, -0.6);

//cubos 10 a 18
  for N := 10 to 18 do
  begin
    cubo2[N] := cubo2[N - 9];
    for i := 1 to 4 do
      cubo2[N].v[i].z := -0.2;
    for i := 5 to 8 do
      cubo2[N].v[i].z := 0.2;
  end;

//cubos 19 a 27
  for N := 19 to 27 do
  begin
    cubo2[N] := cubo2[N - 18];
    for i := 1 to 4 do
      cubo2[N].v[i].z := 0.6;
    for i := 5 to 8 do
      cubo2[N].v[i].z := 1;
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
    '0': begin
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

Function PosX(a: real): integer; // 2D
begin
  result := ScreenTopLeft.x + round( (a - BottomLeft.x) * Qx )
end;

Function PosY(b: real): integer; // 2D
begin
  result := ScreenTopLeft.y + round( (TopRight.y - b) * Qy )
end;

var bmp: TBitmap;
    N: byte;

// plota as linhas da face, preenchendo ou nao
procedure Face(a, b, c, d: byte; cor: TColor; fill: boolean = true);
var pLinha: array[1..4] of Txy;
    i, j: integer;
const qtde = 100; //*** colocar em funçao de ABC e pixels. SLOW! SLOW! SLOW! SLOW!
begin
  bmp.canvas.Pen.Color := cor;
  pLinha[1] := cubo[N].v[a].projecao;
  //bmp.Canvas.MoveTo(posx(pLinha[1].x), posy(pLinha[1].y));
  pLinha[2] := cubo[N].v[b].projecao;
  //bmp.Canvas.LineTo(posx(pLinha[2].x), posy(pLinha[2].y));
  pLinha[3] := cubo[N].v[c].projecao;
  //bmp.Canvas.LineTo(posx(pLinha[3].x), posy(pLinha[3].y));
  pLinha[4] := cubo[N].v[d].projecao;
  //bmp.Canvas.LineTo(posx(pLinha[4].x), posy(pLinha[4].y));
  //bmp.Canvas.LineTo(posx(pLinha[1].x), posy(pLinha[1].y));
  if fill then
//  begin
    //pLinha := media(cubo[N].v[a], cubo[N].v[c]).projecao;
    //bmp.Canvas.Brush.Color := cor;
    //bmp.Canvas.FloodFill(posx(pLinha.x), posy(pLinha.y), cor, fsBorder);
    for i := 0 to qtde do
      for j := 0 to qtde do
      begin
      //plotar C := A + (B - A)/qtde i + (D - A)/qtde j;
        pLinha[3].x := pLinha[1].x + i/qtde * (pLinha[2].x - pLinha[1].x)
                                   + j/qtde * (pLinha[4].x - pLinha[1].x);
        pLinha[3].y := pLinha[1].y + i/qtde * (pLinha[2].y - pLinha[1].y)
                                   + j/qtde * (pLinha[4].y - pLinha[1].y);
        //PontoXY
        bmp.canvas.Pixels[PosX(pLinha[3].x), PosY(pLinha[3].y)] := cor;
      end;
//  end;
end;

procedure Eixos3D;
var p: Txyz;
    pLinha: Txy;
begin
  bmp.Canvas.Pen.Color := clFuchsia;
  p.SetXYZ(3,0,0);
  pLinha := p.projecao;
  bmp.Canvas.MoveTo(posx(pLinha.x), posy(pLinha.y));
  p.x := 0;
  pLinha := p.projecao;
  bmp.Canvas.LineTo(posx(pLinha.x), posy(pLinha.y)); //x
  p.y := 3;
  pLinha := p.projecao;
  bmp.Canvas.LineTo(posx(pLinha.x), posy(pLinha.y)); //y
  p.y := 0;
  pLinha := p.projecao;
  bmp.Canvas.MoveTo(posx(pLinha.x), posy(pLinha.y));
  p.z := 3;
  pLinha := p.projecao;
  bmp.Canvas.LineTo(posx(pLinha.x), posy(pLinha.y)); //z

  p.SetXYZ(2, 0, 0);
  pLinha := p.projecao;
  bmp.Canvas.TextOut(posx(pLinha.x), posy(pLinha.y), 'x');
  p.SetXYZ(0, 2, 0);
  pLinha := p.projecao;
  bmp.Canvas.TextOut(posx(pLinha.x), posy(pLinha.y), 'y');
  p.SetXYZ(0, 0, 3);
  pLinha := p.projecao;
  bmp.Canvas.TextOut(posx(pLinha.x), posy(pLinha.y), 'z');
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

  bmp := TBitmap.Create;
  bmp.Width := width;
  bmp.Height := height;

//preencher o fundo de cinza
  bmp.Canvas.Brush.Color := clBtnFace;
  bmp.Canvas.FloodFill(posx(0), posy(0), clBtnFace, fsBorder);
{
  h(A) > h(B) ==> A na frente de B
  h(P) = det(p.x, p.y, p.z, unitario[1].x, unitario[2].x, unitario[3].x, unitario[1].y, unitario[2].y, unitario[3].y)

  Fonte da Fórmula: Existe uma reta que se reduz à origem.
  x(1,-1) + y(1,1) + z(0,1) = (0,0)
  alfa:  x + y = 0        perpendicular wx = (ix, jx, kx)
  beta: -x + y + z = 0    perpendicular wy = (iy, jy, ky)
  alfa inter beta = r // v diretor // wx vec wy
  v = (1,-1,2)
  r: (x,y,z) = lambda v
  Planos normais gama: x - y + 2z = h
  P = (x0,y0,z0) pertence gama ==> h = P . v = det(P, wx, wy)
}
  
  //calcule o h de todos os vértices 27 * 8
  //pegue os 27 mínimos e ordene
  //*** na verdade eu deveria pegar as 27 * 3 faces e ordenar
  for N := 1 to 27 do
  begin
    for i := 1 to 8 do
      detCubo[N].h[i] := det(cubo[N].v[i].x, cubo[N].v[i].y, cubo[N].v[i].z,
							 unitario[1].x, unitario[2].x, unitario[3].x, unitario[1].y, unitario[2].y, unitario[3].y);
	
    detCubo[N].plotou := false;
    detCubo[N].hmin := detCubo[N].h[1];
    for i := 2 to 8 do
      if detCubo[N].h[i] < detCubo[N].hmin then
        detCubo[N].hmin := detCubo[N].h[i];
  end;

  for k := 1 to 27 do
  begin
  //N := mínimo dos hmin nao plotados
    N := 1;
    while detCubo[N].plotou do
      inc(N);

    for i := N + 1 to 27 do
      if not detCubo[i].plotou then
        if detCubo[i].hmin < detCubo[N].hmin then
          N := i;

  	detCubo[N].plotou := true; // vai plotar agora

    if not cbPintar.Checked then
    begin
    //mostrar todas as arestas
      Face(1,2,3,4, clBlack, false); //ABCD
      Face(5,6,7,8, clBlack, false); //EFGH
      Face(1,2,6,5, clBlack, false); //ABFE
      Face(3,4,8,7, clBlack, false); //CDHG
    end;

  //mostrar quais vértices estao dentro de quais faces
    s := '';
    for i := 5 to 8 do
      if DentroFace(N, i, 1,2,3,4) then
        s := s + char(i + 64) + ' in ABCD; ';
    for i := 1 to 4 do
      if DentroFace(N, i, 5,6,7,8) then
        s := s + char(i + 64) + ' in EFGH; ';
    for i := 3 to 4 do
      if DentroFace(N, i, 1,2,6,5) then
        s := s + char(i + 64) + ' in ABFE; ';
    for i := 7 to 8 do
      if DentroFace(N, i, 1,2,6,5) then
        s := s + char(i + 64) + ' in ABFE; ';
    if DentroFace(N, 1, 2,3,7,6) then
      s := s + 'A in BCGF; ';
    for i := 4 to 5 do
      if DentroFace(N, i, 2,3,7,6) then
        s := s + char(i + 64) + ' in BCGF; ';
    if DentroFace(N, 8, 2,3,7,6) then
      s := s + 'H in BCGF; ';
    for i := 1 to 2 do
      if DentroFace(N, i, 3,4,8,7) then
        s := s + char(i + 64) + ' in CDHG; ';
    for i := 5 to 6 do
      if DentroFace(N, i, 3,4,8,7) then
        s := s + char(i + 64) + ' in CDHG; ';
    for i := 2 to 3 do
      if DentroFace(N, i, 1,4,8,5) then
        s := s + char(i + 64) + ' in ADHE; ';
    for i := 6 to 7 do
      if DentroFace(N, i, 1,4,8,5) then
        s := s + char(i + 64) + ' in ADHE; ';

    bmp.Canvas.Font.Name := 'FixedSys';
    s := copy(s, 1, length(s) - 2) + '.';

    if cbPintar.Checked then
    begin
    //dentre os q estao dentro, oq tem o menor z é o escondido
      i := byte(s[1]) - 64;
      if cubo[N].v[byte(s[12]) - 64].z < cubo[N].v[i].z then
        i := byte(s[12]) - 64;

      if not (i in [1,2,3,4]) then
        Face(1,2,3,4, cor[1]);    //ABCD
      if not (i in [5,6,7,8]) then
        Face(5,6,7,8, cor[2]);    //EFGH
      if not (i in [1,4,8,5]) then
        Face(1,4,8,5, cor[3]);    //ADHE
      if not (i in [2,3,7,6]) then
        Face(2,3,7,6, cor[4]);    //BCGF
      if not (i in [3,4,8,7]) then
        Face(3,4,8,7, cor[5]);    //CDHG
      if not (i in [1,2,6,5]) then
        Face(1,2,6,5, cor[6]);    //ABFE
    end;

    bmp.Canvas.Brush.Color := clBtnFace;

  //numerar cubos
    if cbNumerar.Checked then
    begin
      oLinha := media(cubo[N].v[1], cubo[N].v[7]).Projecao;
      bmp.Canvas.TextOut(posx(oLinha.x), posy(oLinha.y), inttostr(N));

      for j := 0 to 2 do
        for i := 0 to 8 do
          bmp.Canvas.TextOut(25 * i, 72 + 13 * j, IntToStr(anel[0, j, i]^));
      for j := 0 to 2 do
        for i := 0 to 8 do
          bmp.Canvas.TextOut(25 * i, 72 + 13 * (3 + j), IntToStr(anel[1, j, i]^));
      for j := 0 to 2 do
        for i := 0 to 8 do
          bmp.Canvas.TextOut(25 * i, 72 + 13 * (6 + j), IntToStr(anel[2, j, i]^));
    end;
  end;

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

procedure TFormPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
var f: TextFile;
    i: byte;
begin
  AssignFile(f, ExtractFilePath(Application.ExeName) + 'CuboChines.ini');
  rewrite(f);
  writeln(f, '[Cores]');
  for i := 1 to 6 do
    writeln(f, cor[i]);
  writeln(f);
  writeln(f, '[CheckBoxes]');
  writeln(f, byte(cbEixos.checked));
  writeln(f, byte(cbPintar.checked));
  writeln(f, byte(cbNumerar.checked));
  writeln(f);
  writeln(f, '[RadioGroups]');
  writeln(f, rgEixo.ItemIndex);
  writeln(f, rgPosicao.ItemIndex);
  writeln(f, rgSentido.ItemIndex);
  CloseFile(f);
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var f: TextFile;
    i: byte;
    s: string;
begin
  s := ExtractFilePath(Application.ExeName) + 'CuboChines.ini';
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
  readln(f, i);
  cbPintar.checked := (i > 0);
  readln(f, i);
  cbNumerar.checked := (i > 0);
  readln(f);
  readln(f);
  readln(f, i);
  rgEixo.ItemIndex := i;
  readln(f, i);
  rgPosicao.ItemIndex := i;
  readln(f, i);
  rgSentido.ItemIndex := i;
  CloseFile(f);
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

//somente 1 vez na inicializaçao
procedure ZerarAneis;
var i: byte;
begin
//os cubos vao mudar de posiçao neste sentido:
  anel[0,0,0] := @ordem[13]; // esses 0 ficam parados no meio
  anel[0,0,1] := @ordem[1];
  anel[0,0,2] := @ordem[4];
  anel[0,0,3] := @ordem[7];
  anel[0,0,4] := @ordem[16];
  anel[0,0,5] := @ordem[25];
  anel[0,0,6] := @ordem[22];
  anel[0,0,7] := @ordem[19];
  anel[0,0,8] := @ordem[10];
  for i := 0 to 8 do
  begin
    anel[0, 1, i] := pointer(integer(anel[0, 0, i]) + 1);
    anel[0, 2, i] := pointer(integer(anel[0, 0, i]) + 2);
  end;
  anel[1,0,0] := @ordem[11];
  anel[1,0,1] := @ordem[1];
  anel[1,0,2] := @ordem[2];
  anel[1,0,3] := @ordem[3];
  anel[1,0,4] := @ordem[12];
  anel[1,0,5] := @ordem[21];
  anel[1,0,6] := @ordem[20];
  anel[1,0,7] := @ordem[19];
  anel[1,0,8] := @ordem[10];
  for i := 0 to 8 do
  begin
    anel[1, 1, i] := pointer(integer(anel[1, 0, i]) + 3);
    anel[1, 2, i] := pointer(integer(anel[1, 0, i]) + 6);
  end;
  anel[2,0,0] := @ordem[5];
  anel[2,0,1] := @ordem[1];
  anel[2,0,2] := @ordem[2];
  anel[2,0,3] := @ordem[3];
  anel[2,0,4] := @ordem[6];
  anel[2,0,5] := @ordem[9];
  anel[2,0,6] := @ordem[8];
  anel[2,0,7] := @ordem[7];
  anel[2,0,8] := @ordem[4];
  for i := 0 to 8 do
  begin
    anel[2, 1, i] := pointer(integer(anel[2, 0, i]) + 9);
    anel[2, 2, i] := pointer(integer(anel[2, 0, i]) + 18);
  end;
end;

procedure TFormPrincipal.btnOKClick(Sender: TObject);
var i, j, k, N: byte;
    theta: real;
begin
  Panel.Hide;
  theta := pi/18;
  if rgSentido.ItemIndex = 1 then // negativo
    theta := -theta;

  for j := 1 to 9 do // girar 9 vezes
  begin
    for k := 0 to 8 do
    begin
      N := anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, k]^;

    //girar o cubo N
      for i := 1 to 8 do
      begin
        case rgEixo.ItemIndex of
          0: RotacaoX(cubo[N].v[i], theta);
          1: RotacaoY(cubo[N].v[i], theta);
          2: RotacaoZ(cubo[N].v[i], theta);
        end;
        case rgEixo.ItemIndex of
          0: RotacaoX(cubo2[N].v[i], theta);
          1: RotacaoY(cubo2[N].v[i], theta);
          2: RotacaoZ(cubo2[N].v[i], theta);
        end;
      end;
    end;
    MostrarCubos;
  end;

//"girar" o anel 2 posiçoes
  if rgSentido.ItemIndex = 0 then // positivo
    begin
      j := anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, 7]^;
      k := anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, 8]^;
      for i := 8 downto 3 do
        anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, i]^ := anel[rgEixo.ItemIndex,
                               rgPosicao.ItemIndex, i - 2]^;
      anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, 1]^ := j;
      anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, 2]^ := k;
    end
  else
    begin
      j := anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, 1]^;
      k := anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, 2]^;
      for i := 1 to 6 do
        anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, i]^ := anel[rgEixo.ItemIndex,
                               rgPosicao.ItemIndex, i + 2]^;
      anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, 7]^ := j;
      anel[rgEixo.ItemIndex, rgPosicao.ItemIndex, 8]^ := k;
    end;

  Panel.Show;
  if cbNumerar.Checked then // mostrar novos números
    MostrarCubos;
end;

procedure TFormPrincipal.cbDistanciarClick(Sender: TObject);
var cuboTemp: TCubo;
begin
  Panel.Hide;
  cuboTemp := cubo2;
  cubo2 := cubo;
  cubo := cuboTemp;
  MostrarCubos;
  Panel.Show;
end;

initialization
  ZerarAneis;
  ZerarCubos;

  ScreenTopLeft.x := 0;
  ScreenTopLeft.y := 0;
  BottomLeft.x := -5;
  BottomLeft.y := -4;
  TopRight.x := 5;
  TopRight.y := 4;

//faces opostas
  cor[1] := clWhite;  //ABCD
  cor[2] := clYellow; //EFGH

  cor[3] := clGreen;  //ABFE
  cor[4] := clBlue;   //BCGF

  cor[5] := clPurple; //CDHG
  cor[6] := clRed;    //ADHE

  tempFile := ExtractFilePath(Application.ExeName) + 'CuboChines_temp.bmp';
end.