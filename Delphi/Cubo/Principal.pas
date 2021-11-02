unit Principal;

interface

uses
  Forms, Controls, StdCtrls, Classes, Graphics, Types, SysUtils, Dialogs,
  ExtCtrls;

type
  TFormPrincipal = class(TForm)
    img: TImage;
    TimerInit: TTimer;
    cbVertices: TCheckBox;
    cbEixos: TCheckBox;
    cbPintar: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerInitTimer(Sender: TObject);
    procedure cbEixosClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  public
    procedure MostrarCubo;
    procedure Girar(eixo: char; plus: boolean = true);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses Cores;

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

var
  vertice: array[1..8] of Txyz;
//só pra inicializar 1 única vez
  ScreenTopLeft: record
                   x,y: integer;
                 end;
  BottomLeft, TopRight: Txy;
  unitario: array[1..3] of Txy;
  tempFile: string;
  cor: array[1..6] of TColor;

procedure reta(p1, p2: Txy; var a, b: real);
begin
  a := (p2.y - p1.y) / (p2.x - p1.x);
  b := (p2.x * p1.y - p1.x * p2.y) / (p2.x - p1.x);
end;

// será q P está dentro do paralelogramo ABCD?
function DentroFace(P, A, B, C, D: byte): boolean;
var pLinha, aLinha, bLinha, cLinha, dLinha: Txy;
    m, k, y1, y2: real;
begin
  pLinha := vertice[p].projecao;
  aLinha := vertice[a].projecao;
  bLinha := vertice[b].projecao;
  cLinha := vertice[c].projecao;
  dLinha := vertice[d].projecao;

  if aLinha.x > bLinha.x then
  begin
    Result := DentroFace(P, B, C, D, A);
    exit;
  end;

  if aLinha.x > dLinha.x then // D < A <= B
  begin
    Result := DentroFace(P, D, C, B, A);
    exit;
  end;

  if bLinha.x > dLinha.x then // A <= D < B
  begin
    Result := DentroFace(P, A, D, C, B);
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
  vertice[1].SetXYZ( 1, 1,-1);
  vertice[2].SetXYZ( 1,-1,-1);
  vertice[3].SetXYZ(-1,-1,-1);
  vertice[4].SetXYZ(-1, 1,-1);
  vertice[5].SetXYZ( 1, 1, 1);
  vertice[6].SetXYZ( 1,-1, 1);
  vertice[7].SetXYZ(-1,-1, 1);
  vertice[8].SetXYZ(-1, 1, 1);
end;

procedure TFormPrincipal.Girar(eixo: char; plus: boolean = true);
var i: byte;
    theta: real;
begin
  theta := pi/18;
  if not plus then
    theta := -theta;
  for i := 1 to 8 do
    case eixo of
      'X': RotacaoX(vertice[i], theta);
      'Y': RotacaoY(vertice[i], theta);
      'Z': RotacaoZ(vertice[i], theta);
    end;
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

var bmp: TBitmap;

procedure Face(a, b, c, d: byte; cor: TColor; fill: boolean = true);
var p: Txyz;
begin
  bmp.canvas.Pen.Color := cor;
  bmp.Canvas.MoveTo(posx(vertice[a]), posy(vertice[a]));
  bmp.Canvas.LineTo(posx(vertice[b]), posy(vertice[b]));
  bmp.Canvas.LineTo(posx(vertice[c]), posy(vertice[c]));
  bmp.Canvas.LineTo(posx(vertice[d]), posy(vertice[d]));
  bmp.Canvas.LineTo(posx(vertice[a]), posy(vertice[a]));
  if fill then
  begin
    p := media(vertice[a], vertice[c]);
    bmp.Canvas.Brush.Color := cor;
    bmp.Canvas.FloodFill(posx(p), posy(p), cor, fsBorder);
  end;
end;

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

var x, razao: real;
begin
  if Qx > Qy
    then razao := 1/Qx
    else razao := 1/Qy;  // utilize razao para incrementar

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
  i: byte;
  s: string;

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
    if DentroFace(i, 1,2,3,4) then
      s := s + char(i + 64) + ' in ABCD; ';
  for i := 1 to 4 do
    if DentroFace(i, 5,6,7,8) then
      s := s + char(i + 64) + ' in EFGH; ';
  for i := 3 to 4 do
    if DentroFace(i, 1,2,6,5) then
      s := s + char(i + 64) + ' in ABFE; ';
  for i := 7 to 8 do
    if DentroFace(i, 1,2,6,5) then
      s := s + char(i + 64) + ' in ABFE; ';
  if DentroFace(1, 2,3,7,6) then
    s := s + 'A in BCGF; ';
  for i := 4 to 5 do
    if DentroFace(i, 2,3,7,6) then
      s := s + char(i + 64) + ' in BCGF; ';
  if DentroFace(8, 2,3,7,6) then
    s := s + 'H in BCGF; ';
  for i := 1 to 2 do
    if DentroFace(i, 3,4,8,7) then
      s := s + char(i + 64) + ' in CDHG; ';
  for i := 5 to 6 do
    if DentroFace(i, 3,4,8,7) then
      s := s + char(i + 64) + ' in CDHG; ';
  for i := 2 to 3 do
    if DentroFace(i, 1,4,8,5) then
      s := s + char(i + 64) + ' in ADHE; ';
  for i := 6 to 7 do
    if DentroFace(i, 1,4,8,5) then
      s := s + char(i + 64) + ' in ADHE; ';

  s := copy(s, 1, length(s) - 2) + '.';
  if cbVertices.Checked then
  begin
    bmp.Canvas.Brush.Color := clBtnFace;
    bmp.Canvas.Font.Name := 'FixedSys';
    bmp.Canvas.TextOut(100,0, s);
  end;

  if cbPintar.Checked then
  begin
  //dentre os q estao dentro, oq tem o menor z é o escondido
    i := byte(s[1]) - 64;
    if vertice[byte(s[12]) - 64].z < vertice[i].z then
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

//mostrar vértices
  if cbVertices.Checked then
  begin
    bmp.Canvas.Pen.Color := clBlack;
    bmp.Canvas.Brush.Color := clBtnFace;
    for i := 1 to 8 do
      bmp.Canvas.TextOut(posx(vertice[i]), posy(vertice[i]), char(i + 64));
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
  writeln(f, byte(cbVertices.checked));
  writeln(f, byte(cbEixos.checked));
  writeln(f, byte(cbPintar.checked));
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
  cbVertices.checked := (i > 0);
  readln(f, i);
  cbEixos.checked := (i > 0);
  readln(f, i);
  cbPintar.checked := (i > 0);
  CloseFile(f);
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
