unit Principal;

interface

uses
  Forms, Controls, StdCtrls, Classes, Graphics, Types, SysUtils, Dialogs,
  ExtCtrls;

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
    function Projection: Txy;
    function Opposite(other: Txyz): boolean;
  end;

  TIsometry = record
    t: array[1..9] of real;
    v: array[1..3] of real;
  end;

type
  TFormPrincipal = class(TForm)
    TimerInit: TTimer;
    Panel: TPanel;
    cbAxis: TCheckBox;
    cb6: TCheckBox;
    cb20: TCheckBox;
    cb12B: TCheckBox;
    cb4: TCheckBox;
    cb8: TCheckBox;
    cb12a: TCheckBox;
    Memo: TMemo;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerInitTimer(Sender: TObject);
    procedure cbAxisClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditR1Change(Sender: TObject);
    procedure EditNKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure MemoDblClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  public
    Side: real;
    A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T: TXYZ;
    Tetrahedra, Tetrahedra2: array[1..4] of Txyz;
    Octahedra, Octahedra2: array[1..6] of Txyz;
    Cube, Cube2: array[1..8] of Txyz;
    Dodecahedra, Dodecahedra2: array[1..20] of Txyz;
    Icosahedra, Icosahedra2: array[1..12] of Txyz;
    procedure ShowPolyhedra;
    procedure Rotation(axis: char; plus: boolean = true);
    procedure TetrahedraGroup;
    procedure OctahedraGroup;
    procedure CubeGroup;
    procedure IcosahedraGroup;
    procedure DodecahedraGroup;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses StdConvs;

{$R *.DFM}

var // globais
  unitary: array[1..3] of Txy;

//só pra inicializar 1 única vez
  ScreenTopLeft: record
    x, y: integer;
  end;
  BottomLeft, TopRight: Txy;

// y = ax + b

procedure straightLine(p1, p2: Txy; var a, b: real);
begin
  a := (p2.y - p1.y) / (p2.x - p1.x);
  b := (p2.x * p1.y - p1.x * p2.y) / (p2.x - p1.x);
end;

function dist(p1, p2: Txyz): real;
begin
  result := sqr(p1.x - p2.x) + sqr(p1.y - p2.y) + sqr(p1.z - p2.z);
  result := sqrt(result);
end;

function norm(p1: Txyz): real;
begin
  result := sqr(p1.x) + sqr(p1.y) + sqr(p1.z);
  result := sqrt(result);
end;

function det(a, b, c, p, q, r, x, y, z: real): real;
begin
  result := a * (q * z - r * y) - b * (p * z - r * x) + c * (p * y - q * x);
end;

// será q P está dentro do paralelogramo ABCD? (Cubo N)

// em torno de i

procedure RotateX(var p: Txyz; theta: real);
var pLine: Txyz;
begin
  pLine.x := p.x;
  pLine.y := p.y * cos(theta) - p.z * sin(theta);
  pLine.z := p.y * sin(theta) + p.z * cos(theta);
  p := pLine;
end;

// em torno de j

procedure RotateY(var p: Txyz; theta: real);
var pLine: Txyz;
begin
  pLine.x := p.x * cos(theta) - p.z * sin(theta);
  pLine.y := p.y;
  pLine.z := p.x * sin(theta) + p.z * cos(theta);
  p := pLine;
end;

// em torno de k

procedure RotateZ(var p: Txyz; theta: real);
var pLine: Txyz;
begin
  pLine.x := p.x * cos(theta) - p.y * sin(theta);
  pLine.y := p.x * sin(theta) + p.y * cos(theta);
  pLine.z := p.z;
  p := pLine;
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

function Txyz.Projection: Txy;
begin
  Result.x := x * unitary[1].x + y * unitary[2].x + z * unitary[3].x;
  Result.y := x * unitary[1].y + y * unitary[2].y + z * unitary[3].y;
end;

function Txyz.Opposite(other: Txyz): boolean;
begin
  other.x := x + other.x;
  other.y := y + other.y;
  other.z := z + other.z;
  Result := (abs(other.x) < 0.1) and (abs(other.y) < 0.1) and (abs(other.z) < 0.1);
end;

function average(a, b: Txyz): Txyz; overload;
begin
  result.x := (a.x + b.x) / 2;
  result.y := (a.y + b.y) / 2;
  result.z := (a.z + b.z) / 2;
end;

function average(a, b, c: Txyz): Txyz; overload;
begin
  result.x := (a.x + b.x + c.x) / 3;
  result.y := (a.y + b.y + c.y) / 3;
  result.z := (a.z + b.z + c.z) / 3;
end;

function average(a, b, c, d, e: Txyz): Txyz; overload;
begin
  result.x := (a.x + b.x + c.x + d.x + e.x) / 5;
  result.y := (a.y + b.y + c.y + d.y + e.y) / 5;
  result.z := (a.z + b.z + c.z + d.z + e.z) / 5;
end;

procedure ZeroUnitary;
begin
  unitary[1].SetXY(1, -1);
  unitary[2].SetXY(1, 1);
  unitary[3].SetXY(0, 1);
end;

procedure TFormPrincipal.Rotation(axis: char; plus: boolean = true);
var theta: real;
  e: array[1..3] of Txyz;
  eLine: array[1..3] of Txy;
  i: byte;
begin
  theta := pi / 18;
  if not plus then
    theta := -theta;

//Rotation os eixos
  e[1].SetXYZ(1, 0, 0);
  e[2].SetXYZ(0, 1, 0);
  e[3].SetXYZ(0, 0, 1);
  for i := 1 to 3 do
  begin
    case axis of
      'X': RotateX(e[i], theta);
      'Y': RotateY(e[i], theta);
      'Z': RotateZ(e[i], theta);
    end;

    eLine[i] := e[i].Projection;
  end;

//só posso mudar os unitários depois
  for i := 1 to 3 do
    unitary[i] := eLine[i];

  ShowPolyhedra;
end;

procedure TFormPrincipal.FormKeyPress(Sender: TObject; var Key: Char);
begin
  key := upcase(key);
  case key of
    #27: close;
    'Q': Rotation('X');
    'A': Rotation('X', false);
    'W': Rotation('Y');
    'S': Rotation('Y', false);
    'E': Rotation('Z');
    'D': Rotation('Z', false);
    'Z': begin
        ZeroUnitary;
        ShowPolyhedra;
      end;
  end;
end;

procedure TFormPrincipal.ShowPolyhedra;

var Qx, Qy: real;
  ratio: real;

  function PosX(a: real): integer; overload; // 2D
  begin
    result := ScreenTopLeft.x + round((a - BottomLeft.x) * Qx)
  end;

  function PosY(b: real): integer; overload; // 2D
  begin
    result := ScreenTopLeft.y + round((TopRight.y - b) * Qy)
  end;

  function PosX(p: Txyz): integer; overload;
  begin
    result := PosX(p.x * unitary[1].x + p.y * unitary[2].x + p.z * unitary[3].x);
  end;

  function PosY(p: Txyz): integer; overload;
  begin
    result := PosY(p.x * unitary[1].y + p.y * unitary[2].y + p.z * unitary[3].y);
  end;

  procedure PointXY(x, y: real; cor: TColor);
  begin
    if (BottomLeft.x <= x) and (x <= TopRight.x) and (BottomLeft.y <= y)
      and (y <= TopRight.y) then
      canvas.Pixels[PosX(x), PosY(y)] := cor;
  end;

  procedure PointXYZ(x, y, z: real; cor: TColor);
  begin
    PointXY(x * unitary[1].x + y * unitary[2].x + z * unitary[3].x,
      x * unitary[1].y + y * unitary[2].y + z * unitary[3].y, cor);
  end;

  procedure circle2d;
  var t: real;
  begin
    t := 0;
    while t < 2 * pi do
    begin
      Pointxy(cos(t), sin(t), clblue);
      t := t + 0.01;
    end;
  end;

  procedure spiral2d;
  var t: real;
  begin
    t := 0;
    while t < 20 * pi do
    begin
      Pointxy(t / 20 * cos(t), t / 20 * sin(t), clblue);
      t := t + 0.01;
    end;
  end;

  procedure spiral3d;
  var t: real;
  begin
    t := 0;
    while t < 20 * pi do
    begin
      Pointxyz(t / 20 * cos(t), t / 20 * sin(t), t / 20, clblue);
      t := t + 0.01;
    end;
  end;

  procedure circle3d;
  var t: real;
  begin
    t := 0;
    while t < 2 * pi do
    begin
      Pointxyz(cos(t), sin(t), 0, clblue);
      t := t + 0.01;
    end;
  end;

  procedure Axis3D;
  var pLine: Txy;
    p2: Txyz;
    ratio, lat, long: double;
    ii, jj: integer;
    arq: textFile;
  begin
    Refresh;
    if cbAxis.Checked then
    begin
      Canvas.Pen.Color := clFuchsia;
      p2.SetXYZ(3, 0, 0);
      pLine := p2.Projection;
      Canvas.MoveTo(posx(pLine.x), posy(pLine.y));
      p2.x := 0;
      pLine := p2.Projection;
      Canvas.LineTo(posx(pLine.x), posy(pLine.y)); //x
      p2.y := 3;
      pLine := p2.Projection;
      Canvas.LineTo(posx(pLine.x), posy(pLine.y)); //y
      p2.y := 0;
      pLine := p2.Projection;
      Canvas.MoveTo(posx(pLine.x), posy(pLine.y));
      p2.z := 3;
      pLine := p2.Projection;
      Canvas.LineTo(posx(pLine.x), posy(pLine.y)); //z

      p2.SetXYZ(2, 0, 0);
      pLine := p2.Projection;
      Canvas.TextOut(posx(pLine.x), posy(pLine.y), 'x');
      p2.SetXYZ(0, 2, 0);
      pLine := p2.Projection;
      Canvas.TextOut(posx(pLine.x), posy(pLine.y), 'y');
      p2.SetXYZ(0, 0, 3);
      pLine := p2.Projection;
      Canvas.TextOut(posx(pLine.x), posy(pLine.y), 'z');
    end;

    if Qx > Qy
      then ratio := 1 / Qx
    else ratio := 1 / Qy; // utilize ratio para incrementar

    //circle2d;
    //spiral2d;
    //circle3d;
    //spiral3d;
    //exit;

    if cb4.checked then
    begin
      Canvas.Pen.Color := clblue;
      Canvas.MoveTo(posx(tetrahedra[1]), posy(tetrahedra[1]));
      Canvas.LineTo(posx(tetrahedra[2]), posy(tetrahedra[2]));
      Canvas.LineTo(posx(tetrahedra[3]), posy(tetrahedra[3]));
      Canvas.LineTo(posx(tetrahedra[4]), posy(tetrahedra[4]));
      Canvas.LineTo(posx(tetrahedra[2]), posy(tetrahedra[2]));
      Canvas.MoveTo(posx(tetrahedra[1]), posy(tetrahedra[1]));
      Canvas.LineTo(posx(tetrahedra[3]), posy(tetrahedra[3]));
      Canvas.MoveTo(posx(tetrahedra[1]), posy(tetrahedra[1]));
      Canvas.LineTo(posx(tetrahedra[4]), posy(tetrahedra[4]));
      TetrahedraGroup;
    end;

    if cb6.checked then
    begin
      Canvas.Pen.Color := clblue;
      Canvas.MoveTo(posx(cube[1]), posy(cube[1]));
      Canvas.LineTo(posx(cube[2]), posy(cube[2]));
      Canvas.LineTo(posx(cube[3]), posy(cube[3]));
      Canvas.LineTo(posx(cube[4]), posy(cube[4]));
      Canvas.LineTo(posx(cube[1]), posy(cube[1]));
      Canvas.LineTo(posx(cube[5]), posy(cube[5]));
      Canvas.LineTo(posx(cube[6]), posy(cube[6]));
      Canvas.LineTo(posx(cube[7]), posy(cube[7]));
      Canvas.LineTo(posx(cube[8]), posy(cube[8]));
      Canvas.LineTo(posx(cube[5]), posy(cube[5]));
      Canvas.MoveTo(posx(cube[2]), posy(cube[2]));
      Canvas.LineTo(posx(cube[6]), posy(cube[6]));
      Canvas.MoveTo(posx(cube[3]), posy(cube[3]));
      Canvas.LineTo(posx(cube[7]), posy(cube[7]));
      Canvas.MoveTo(posx(cube[4]), posy(cube[4]));
      Canvas.LineTo(posx(cube[8]), posy(cube[8]));
      CubeGroup;
    end;

    if cb8.checked then
    begin
      Canvas.Pen.Color := clblue;
      Canvas.MoveTo(posx(octahedra[1]), posy(octahedra[1]));
      Canvas.LineTo(posx(octahedra[2]), posy(octahedra[2]));
      Canvas.LineTo(posx(octahedra[3]), posy(octahedra[3]));
      Canvas.LineTo(posx(octahedra[4]), posy(octahedra[4]));
      Canvas.LineTo(posx(octahedra[5]), posy(octahedra[5]));
      Canvas.LineTo(posx(octahedra[2]), posy(octahedra[2]));
      Canvas.MoveTo(posx(octahedra[1]), posy(octahedra[1]));
      Canvas.LineTo(posx(octahedra[3]), posy(octahedra[3]));
      Canvas.LineTo(posx(octahedra[6]), posy(octahedra[6]));
      Canvas.MoveTo(posx(octahedra[1]), posy(octahedra[1]));
      Canvas.LineTo(posx(octahedra[4]), posy(octahedra[4]));
      Canvas.LineTo(posx(octahedra[6]), posy(octahedra[6]));
      Canvas.MoveTo(posx(octahedra[1]), posy(octahedra[1]));
      Canvas.LineTo(posx(octahedra[5]), posy(octahedra[5]));
      Canvas.LineTo(posx(octahedra[6]), posy(octahedra[6]));
      Canvas.LineTo(posx(octahedra[2]), posy(octahedra[2]));
      octahedraGroup;
    end;

    if cb12A.checked then
    begin
      Canvas.Pen.Color := clblue;
      Canvas.MoveTo(posx(A), posy(A));
      Canvas.LineTo(posx(K), posy(K));
      Canvas.MoveTo(posx(A), posy(A));
      Canvas.LineTo(posx(O), posy(O));
      Canvas.MoveTo(posx(A), posy(A));
      Canvas.LineTo(posx(S), posy(S));

      Canvas.MoveTo(posx(B), posy(B));
      Canvas.LineTo(posx(I), posy(I));
      Canvas.MoveTo(posx(B), posy(B));
      Canvas.LineTo(posx(P), posy(P));
      Canvas.MoveTo(posx(B), posy(B));
      Canvas.LineTo(posx(S), posy(S));

      Canvas.MoveTo(posx(C), posy(C));
      Canvas.LineTo(posx(K), posy(K));
      Canvas.MoveTo(posx(C), posy(C));
      Canvas.LineTo(posx(M), posy(M));
      Canvas.MoveTo(posx(C), posy(C));
      Canvas.LineTo(posx(T), posy(T));

      Canvas.MoveTo(posx(D), posy(D));
      Canvas.LineTo(posx(I), posy(I));
      Canvas.MoveTo(posx(D), posy(D));
      Canvas.LineTo(posx(N), posy(N));
      Canvas.MoveTo(posx(D), posy(D));
      Canvas.LineTo(posx(T), posy(T));

      Canvas.MoveTo(posx(E), posy(E));
      Canvas.LineTo(posx(L), posy(L));
      Canvas.MoveTo(posx(E), posy(E));
      Canvas.LineTo(posx(O), posy(O));
      Canvas.MoveTo(posx(E), posy(E));
      Canvas.LineTo(posx(Q), posy(Q));

      Canvas.MoveTo(posx(F), posy(F));
      Canvas.LineTo(posx(J), posy(J));
      Canvas.MoveTo(posx(F), posy(F));
      Canvas.LineTo(posx(P), posy(P));
      Canvas.MoveTo(posx(F), posy(F));
      Canvas.LineTo(posx(Q), posy(Q));

      Canvas.MoveTo(posx(G), posy(G));
      Canvas.LineTo(posx(L), posy(L));
      Canvas.MoveTo(posx(G), posy(G));
      Canvas.LineTo(posx(M), posy(M));
      Canvas.MoveTo(posx(G), posy(G));
      Canvas.LineTo(posx(R), posy(R));

      Canvas.MoveTo(posx(H), posy(H));
      Canvas.LineTo(posx(J), posy(J));
      Canvas.MoveTo(posx(H), posy(H));
      Canvas.LineTo(posx(N), posy(N));
      Canvas.MoveTo(posx(H), posy(H));
      Canvas.LineTo(posx(R), posy(R));

      Canvas.MoveTo(posx(J), posy(J));
      Canvas.LineTo(posx(I), posy(I));
      Canvas.MoveTo(posx(K), posy(K));
      Canvas.LineTo(posx(L), posy(L));
      Canvas.MoveTo(posx(M), posy(M));
      Canvas.LineTo(posx(N), posy(N));

      Canvas.MoveTo(posx(O), posy(O));
      Canvas.LineTo(posx(P), posy(P));
      Canvas.MoveTo(posx(Q), posy(Q));
      Canvas.LineTo(posx(R), posy(R));
      Canvas.MoveTo(posx(S), posy(S));
      Canvas.LineTo(posx(T), posy(T));
    end;

    if cb20.checked then
    begin
      assignfile(arq, 'temp20_arestas.txt');
      rewrite(arq);
      Canvas.Pen.Color := clRed;
      for ii := 1 to 11 do
        for jj := ii + 1 to 12 do
          if dist(Icosahedra[ii], Icosahedra[jj]) = dist(Icosahedra[1],
            Icosahedra[2]) then
          begin
            Canvas.MoveTo(posx(Icosahedra[ii]), posy(Icosahedra[ii]));
            Canvas.LineTo(posx(Icosahedra[jj]), posy(Icosahedra[jj]));
            writeln(arq, ii, ', ', jj);
          end;
      closefile(arq);
      IcosahedraGroup;
    end;

    if cb12B.checked then
    begin
      assignfile(arq, 'temp12B.txt');
      rewrite(arq);
      Canvas.Pen.Color := clBlack;
      for ii := 1 to 19 do
        for jj := ii + 1 to 20 do
          if abs(dist(Dodecahedra[ii], Dodecahedra[jj]) - dist(Dodecahedra[1],
            Dodecahedra[2])) < 1E-1 then
          begin
            Canvas.MoveTo(posx(Dodecahedra[ii]), posy(Dodecahedra[ii]));
            Canvas.LineTo(posx(Dodecahedra[jj]), posy(Dodecahedra[jj]));
            writeln(arq, ii, ', ', jj);
          end;
      closefile(arq);
      DodecahedraGroup;
    end;
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

  Axis3D;
end;

procedure TFormPrincipal.TimerInitTimer(Sender: TObject);
begin
  TimerInit.Enabled := false;
  ShowPolyhedra;
end;

procedure TFormPrincipal.cbAxisClick(Sender: TObject);
begin
  ShowPolyhedra;
end;

procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  ShowPolyhedra;
end;

procedure TFormPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: byte;
begin
  case key of
  //F1
    112: for i := 1 to 9 do
        Rotation('X');
  //F2
    113: for i := 1 to 9 do
        Rotation('Y');
  //F3
    114: for i := 1 to 9 do
        Rotation('Z');
  end;
end;

procedure TFormPrincipal.EditR1Change(Sender: TObject);
begin
  ShowPolyhedra;
end;

procedure TFormPrincipal.EditNKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', ',', '-']) then
  begin
    FormKeyPress(sender, key);
    key := #0;
  end;
end;

procedure ordenar;
var f: textfile;
  s: string;
  ch: char;
  list: tstringlist;
begin
  list := tstringlist.create;
  ASSIGNFILE(F, 'TEMP12.TXT');
  reset(f);
  while not eof(f) do
  begin
    readln(f, s);
    if s[1] > s[2] then
    begin
      ch := s[2];
      s[2] := s[1];
      s[1] := ch;
    end;
    list.Add(s);
  end;
  closefile(f);
  list.Sort;
  list.SaveToFile('TEMP12.TXT');
  list.Free;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var
  arq: textfile;
  diag, x, height: real;
  ii, jj, kk, LL: integer;
begin
  Side := 2;
  tetrahedra[1].SetXYZ(0, 0, 0);
  tetrahedra[2].SetXYZ(Side, 0, 0);
  tetrahedra[3].SetXYZ(Side / 2.0, Side * sqrt(3) / 2.0, 0);
  tetrahedra[4].SetXYZ(Side / 2.0, Side * sqrt(3) / 6.0, Side * sqrt(6) / 3.0);

  cube[1].SetXYZ(-1, -1, -1);
  cube[2].SetXYZ(+1, -1, -1);
  cube[3].SetXYZ(+1, +1, -1);
  cube[4].SetXYZ(-1, +1, -1);
  cube[5].SetXYZ(-1, -1, +1);
  cube[6].SetXYZ(+1, -1, +1);
  cube[7].SetXYZ(+1, +1, +1);
  cube[8].SetXYZ(-1, +1, +1);

  octahedra[1].SetXYZ(0, 0, sqrt(2)); // 1^2 + 1^2 + z^2 = 4
  octahedra[2].SetXYZ(-1, -1, 0);
  octahedra[3].SetXYZ(+1, -1, 0);
  octahedra[4].SetXYZ(+1, +1, 0);
  octahedra[5].SetXYZ(-1, +1, 0);
  octahedra[6].SetXYZ(0, 0, -sqrt(2));

  Side := 1.4;
  diag := (1 + sqrt(5)) * Side / 2;
  x := (diag - Side) / 2;
  height := Side / 2;
  A.SetXYZ(-diag / 2, -diag / 2, -diag / 2);
  B.SetXYZ(-diag / 2, -diag / 2, +diag / 2);
  C.SetXYZ(-diag / 2, +diag / 2, -diag / 2);
  D.SetXYZ(-diag / 2, +diag / 2, +diag / 2);
  E.SetXYZ(+diag / 2, -diag / 2, -diag / 2);
  F.SetXYZ(+diag / 2, -diag / 2, +diag / 2);
  G.SetXYZ(+diag / 2, +diag / 2, -diag / 2);
  H.SetXYZ(+diag / 2, +diag / 2, +diag / 2);
  // Z +
  I.SetXYZ(-diag / 2 + x, 0, diag / 2 + height);
  J.SetXYZ(+diag / 2 - x, 0, diag / 2 + height);
  // Z -
  K.SetXYZ(-diag / 2 + x, 0, -diag / 2 - height);
  L.SetXYZ(+diag / 2 - x, 0, -diag / 2 - height);
  // Y +
  M.SetXYZ(0, diag / 2 + height, -diag / 2 + x);
  N.SetXYZ(0, diag / 2 + height, +diag / 2 - x);
  // Y -
  O.SetXYZ(0, -diag / 2 - height, -diag / 2 + x);
  P.SetXYZ(0, -diag / 2 - height, +diag / 2 - x);
  // X +
  Q.SetXYZ(diag / 2 + height, -diag / 2 + x, 0);
  R.SetXYZ(diag / 2 + height, +diag / 2 - x, 0);
  // X -
  S.SetXYZ(-diag / 2 - height, -diag / 2 + x, 0);
  T.SetXYZ(-diag / 2 - height, +diag / 2 - x, 0);


  Icosahedra[1] := average(I, J, H, N, D); // IJHND Z+ 1
  Icosahedra[2] := average(I, J, F, P, B); // IJFPB Z+ 2
  Icosahedra[3] := average(M, N, H, R, G); // MNHRG Y+ 1
  Icosahedra[4] := average(M, N, D, T, C); // MNDTC Y+ 2
  Icosahedra[5] := average(Q, R, H, J, F); // QRHJF X+ 1
  Icosahedra[6] := average(Q, R, G, L, E); // QRGLE X+ 2
  Icosahedra[7] := average(K, L, E, O, A); // KLEOA Z- 1
  Icosahedra[8] := average(K, L, G, M, C); // KLGMC Z- 2
  Icosahedra[9] := average(O, P, B, S, A); // OPBSA Y- 1
  Icosahedra[10] := average(O, P, F, Q, E); // OPFQE Y- 2
  Icosahedra[11] := average(S, T, D, I, B); // STDIB X- 1
  Icosahedra[12] := average(S, T, C, K, A); // STCKA X- 2

  assignfile(arq, 'temp20_faces.txt');
  rewrite(arq);
  LL := 1;
  for ii := 1 to 10 do
    for jj := ii + 1 to 11 do
      for kk := jj + 1 to 12 do
        if dist(Icosahedra[ii], Icosahedra[jj]) = dist(Icosahedra[1],
          Icosahedra[2]) then
          if dist(Icosahedra[ii], Icosahedra[kk]) = dist(Icosahedra[1],
            Icosahedra[2]) then
            if dist(Icosahedra[jj], Icosahedra[kk]) = dist(Icosahedra[1],
              Icosahedra[2]) then
              if LL <= 20 then
              begin
                Dodecahedra[LL] := average(Icosahedra[ii], Icosahedra[jj],
                  Icosahedra[kk]);
                inc(LL);
                writeln(arq, ii, ', ', jj, ', ', kk);
              end;

  writeln(arq);
  for ii := 1 to 19 do
    for jj := ii + 1 to 20 do
      writeln(arq, 'dist ', ii, ', ', jj, ', ', floattostr(dist(Dodecahedra[ii],
        Dodecahedra[jj])));
  closefile(arq);

  assignfile(arq, 'temp12.txt');
  rewrite(arq);
  // IJHND Z+ 1
  writeln(arq, 'IJ = ', floattostr(dist(I, J)));
  writeln(arq, 'JH = ', floattostr(dist(J, H)));
  writeln(arq, 'HN = ', floattostr(dist(H, N)));
  writeln(arq, 'ND = ', floattostr(dist(N, D)));
  writeln(arq, 'DI = ', floattostr(dist(D, I))); //5
  // IJFPB Z+ 2
  writeln(arq, 'JF = ', floattostr(dist(J, F)));
  writeln(arq, 'FP = ', floattostr(dist(F, P)));
  writeln(arq, 'PB = ', floattostr(dist(P, B)));
  writeln(arq, 'BI = ', floattostr(dist(B, I))); //9

  // MNHRG Y+ 1
  writeln(arq, 'MN = ', floattostr(dist(M, N)));
  writeln(arq, 'HR = ', floattostr(dist(H, R)));
  writeln(arq, 'RG = ', floattostr(dist(R, G)));
  writeln(arq, 'GM = ', floattostr(dist(G, M))); //13
  // MNDTC Y+ 2
  writeln(arq, 'DT = ', floattostr(dist(D, T)));
  writeln(arq, 'TC = ', floattostr(dist(T, C)));
  writeln(arq, 'CM = ', floattostr(dist(C, M))); //16

  // QRHJF X+ 1
  writeln(arq, 'QR = ', floattostr(dist(Q, R)));
  writeln(arq, 'FQ = ', floattostr(dist(F, Q))); //18
  // QRGLE X+ 2
  writeln(arq, 'GL = ', floattostr(dist(G, L)));
  writeln(arq, 'LE = ', floattostr(dist(L, E)));
  writeln(arq, 'EQ = ', floattostr(dist(E, Q))); //21

  // KLEOA Z- 1
  writeln(arq, 'KL = ', floattostr(dist(K, L)));
  writeln(arq, 'EO = ', floattostr(dist(E, O)));
  writeln(arq, 'OA = ', floattostr(dist(O, A)));
  writeln(arq, 'AK = ', floattostr(dist(A, K))); //25
  // KLGMC Z- 2
  writeln(arq, 'CK = ', floattostr(dist(C, K))); //26

  // OPBSA Y- 1
  writeln(arq, 'OP = ', floattostr(dist(O, P)));
  writeln(arq, 'BS = ', floattostr(dist(B, S)));
  writeln(arq, 'SA = ', floattostr(dist(S, A))); //29
  // OPFQE Y- 2

  // STDIB X- 1
  writeln(arq, 'ST = ', floattostr(dist(S, T))); //30
  // STCKA X- 2

  writeln(arq, 'norm(A) = ', floattostr(norm(A))); //30
  writeln(arq, 'norm(B) = ', floattostr(norm(B))); //30
  writeln(arq, 'norm(C) = ', floattostr(norm(C))); //30
  writeln(arq, 'norm(D) = ', floattostr(norm(D))); //30
  writeln(arq, 'norm(E) = ', floattostr(norm(E))); //30
  writeln(arq, 'norm(F) = ', floattostr(norm(F))); //30
  writeln(arq, 'norm(G) = ', floattostr(norm(G))); //30
  writeln(arq, 'norm(H) = ', floattostr(norm(H))); //30
  writeln(arq, 'norm(I) = ', floattostr(norm(I))); //30
  writeln(arq, 'norm(J) = ', floattostr(norm(J))); //30
  writeln(arq, 'norm(K) = ', floattostr(norm(K))); //30
  writeln(arq, 'norm(L) = ', floattostr(norm(L))); //30
  writeln(arq, 'norm(M) = ', floattostr(norm(M))); //30
  writeln(arq, 'norm(N) = ', floattostr(norm(N))); //30
  writeln(arq, 'norm(O) = ', floattostr(norm(O))); //30
  writeln(arq, 'norm(P) = ', floattostr(norm(P))); //30
  writeln(arq, 'norm(Q) = ', floattostr(norm(Q))); //30
  writeln(arq, 'norm(R) = ', floattostr(norm(R))); //30
  writeln(arq, 'norm(S) = ', floattostr(norm(S))); //30
  writeln(arq, 'norm(T) = ', floattostr(norm(T))); //30

  closefile(arq);
  Ordenar;
end;

procedure TFormPrincipal.TetrahedraGroup;
var
  iso: TIsometry;
  i, j, k, L, m, counter: byte;
  detM: real;
begin
  counter := 0;
  memo.clear;
  for i := 1 to 4 do
    for j := 1 to 4 do
      if j <> i then
        for k := 1 to 4 do
          if k <> i then
            if k <> j then
              for L := 1 to 4 do
                if L <> i then
                  if L <> j then
                    if L <> k then
                    begin
                      Tetrahedra2[1] := Tetrahedra[i];
                      Tetrahedra2[2] := Tetrahedra[j];
                      Tetrahedra2[3] := Tetrahedra[k];
                      Tetrahedra2[4] := Tetrahedra[L];
                      detM := det(tetrahedra[1].x - tetrahedra[4].x, tetrahedra[1].y - tetrahedra[4].y, tetrahedra[1].z - tetrahedra[4].z,
                        tetrahedra[2].x - tetrahedra[4].x, tetrahedra[2].y - tetrahedra[4].y, tetrahedra[2].z - tetrahedra[4].z,
                        tetrahedra[3].x - tetrahedra[4].x, tetrahedra[3].y - tetrahedra[4].y, tetrahedra[3].z - tetrahedra[4].z);
                      iso.t[1] := det(tetrahedra2[1].x - tetrahedra2[4].x, tetrahedra[1].y - tetrahedra[4].y, tetrahedra[1].z - tetrahedra[4].z,
                        tetrahedra2[2].x - tetrahedra2[4].x, tetrahedra[2].y - tetrahedra[4].y, tetrahedra[2].z - tetrahedra[4].z,
                        tetrahedra2[3].x - tetrahedra2[4].x, tetrahedra[3].y - tetrahedra[4].y, tetrahedra[3].z - tetrahedra[4].z) / DetM;
                      iso.t[2] := det(tetrahedra[1].x - tetrahedra[4].x, tetrahedra2[1].x - tetrahedra2[4].x, tetrahedra[1].z - tetrahedra[4].z,
                        tetrahedra[2].x - tetrahedra[4].x, tetrahedra2[2].x - tetrahedra2[4].x, tetrahedra[2].z - tetrahedra[4].z,
                        tetrahedra[3].x - tetrahedra[4].x, tetrahedra2[3].x - tetrahedra2[4].x, tetrahedra[3].z - tetrahedra[4].z) / DetM;
                      iso.t[3] := det(tetrahedra[1].x - tetrahedra[4].x, tetrahedra[1].y - tetrahedra[4].y, tetrahedra2[1].x - tetrahedra2[4].x,
                        tetrahedra[2].x - tetrahedra[4].x, tetrahedra[2].y - tetrahedra[4].y, tetrahedra2[2].x - tetrahedra2[4].x,
                        tetrahedra[3].x - tetrahedra[4].x, tetrahedra[3].y - tetrahedra[4].y, tetrahedra2[3].x - tetrahedra2[4].x) / DetM;
                      iso.t[4] := det(tetrahedra2[1].y - tetrahedra2[4].y, tetrahedra[1].y - tetrahedra[4].y, tetrahedra[1].z - tetrahedra[4].z,
                        tetrahedra2[2].y - tetrahedra2[4].y, tetrahedra[2].y - tetrahedra[4].y, tetrahedra[2].z - tetrahedra[4].z,
                        tetrahedra2[3].y - tetrahedra2[4].y, tetrahedra[3].y - tetrahedra[4].y, tetrahedra[3].z - tetrahedra[4].z) / DetM;
                      iso.t[5] := det(tetrahedra[1].x - tetrahedra[4].x, tetrahedra2[1].y - tetrahedra2[4].y, tetrahedra[1].z - tetrahedra[4].z,
                        tetrahedra[2].x - tetrahedra[4].x, tetrahedra2[2].y - tetrahedra2[4].y, tetrahedra[2].z - tetrahedra[4].z,
                        tetrahedra[3].x - tetrahedra[4].x, tetrahedra2[3].y - tetrahedra2[4].y, tetrahedra[3].z - tetrahedra[4].z) / DetM;
                      iso.t[6] := det(tetrahedra[1].x - tetrahedra[4].x, tetrahedra[1].y - tetrahedra[4].y, tetrahedra2[1].y - tetrahedra2[4].y,
                        tetrahedra[2].x - tetrahedra[4].x, tetrahedra[2].y - tetrahedra[4].y, tetrahedra2[2].y - tetrahedra2[4].y,
                        tetrahedra[3].x - tetrahedra[4].x, tetrahedra[3].y - tetrahedra[4].y, tetrahedra2[3].y - tetrahedra2[4].y) / DetM;
                      iso.t[7] := det(tetrahedra2[1].z - tetrahedra2[4].z, tetrahedra[1].y - tetrahedra[4].y, tetrahedra[1].z - tetrahedra[4].z,
                        tetrahedra2[2].z - tetrahedra2[4].z, tetrahedra[2].y - tetrahedra[4].y, tetrahedra[2].z - tetrahedra[4].z,
                        tetrahedra2[3].z - tetrahedra2[4].z, tetrahedra[3].y - tetrahedra[4].y, tetrahedra[3].z - tetrahedra[4].z) / DetM;
                      iso.t[8] := det(tetrahedra[1].x - tetrahedra[4].x, tetrahedra2[1].z - tetrahedra2[4].z, tetrahedra[1].z - tetrahedra[4].z,
                        tetrahedra[2].x - tetrahedra[4].x, tetrahedra2[2].z - tetrahedra2[4].z, tetrahedra[2].z - tetrahedra[4].z,
                        tetrahedra[3].x - tetrahedra[4].x, tetrahedra2[3].z - tetrahedra2[4].z, tetrahedra[3].z - tetrahedra[4].z) / DetM;
                      iso.t[9] := det(tetrahedra[1].x - tetrahedra[4].x, tetrahedra[1].y - tetrahedra[4].y, tetrahedra2[1].z - tetrahedra2[4].z,
                        tetrahedra[2].x - tetrahedra[4].x, tetrahedra[2].y - tetrahedra[4].y, tetrahedra2[2].z - tetrahedra2[4].z,
                        tetrahedra[3].x - tetrahedra[4].x, tetrahedra[3].y - tetrahedra[4].y, tetrahedra2[3].z - tetrahedra2[4].z) / DetM;
                      iso.v[1] := tetrahedra2[4].x - tetrahedra[4].x * iso.t[1] - tetrahedra[4].y * iso.t[2] - tetrahedra[4].z * iso.t[3];
                      iso.v[2] := tetrahedra2[4].y - tetrahedra[4].x * iso.t[4] - tetrahedra[4].y * iso.t[5] - tetrahedra[4].z * iso.t[6];
                      iso.v[3] := tetrahedra2[4].z - tetrahedra[4].x * iso.t[7] - tetrahedra[4].y * iso.t[8] - tetrahedra[4].z * iso.t[9];
                      memo.Lines.Add(inttostr(i) + inttostr(j) + inttostr(k) + inttostr(L) + ' [' +
                        inttostr(counter) + ']');
                      for m := 1 to 9 do
                        memo.lines.add('iso.t[' + inttostr(m) + '] = ' + floattostr(iso.t[m]));
                      for m := 1 to 3 do
                        memo.lines.add('iso.v[' + inttostr(m) + '] = ' + floattostr(iso.v[m]));
                      memo.lines.add('');
                      inc(counter);
                    end;

  memo.Hint := memo.Text;
  memo.Show;
end;

procedure TFormPrincipal.CubeGroup;
var
  iso: TIsometry;
  i, j, k, L, m, counter: byte;
  detM: real;
begin
  counter := 0;
  memo.clear;
  for i := 1 to 8 do
    for j := 1 to 8 do
      if abs(dist(cube[i], cube[j]) - 2) < 0.1 then
        for k := 1 to 8 do
          if abs(dist(cube[i], cube[k]) - 2) < 0.1 then
            if j <> k then
              for L := 1 to 8 do
                if abs(dist(cube[i], cube[L]) - 2) < 0.1 then
                  if L <> j then
                    if L <> k then
                    begin
                      Cube2[1] := Cube[i];
                      Cube2[2] := Cube[j];
                      Cube2[4] := Cube[k];
                      Cube2[5] := Cube[L];
                      detM := det(Cube[1].x - Cube[5].x, Cube[1].y - Cube[5].y, Cube[1].z - Cube[5].z,
                        Cube[2].x - Cube[5].x, Cube[2].y - Cube[5].y, Cube[2].z - Cube[5].z,
                        Cube[4].x - Cube[5].x, Cube[4].y - Cube[5].y, Cube[4].z - Cube[5].z);
                      iso.t[1] := det(Cube2[1].x - Cube2[5].x, Cube[1].y - Cube[5].y, Cube[1].z - Cube[5].z,
                        Cube2[2].x - Cube2[5].x, Cube[2].y - Cube[5].y, Cube[2].z - Cube[5].z,
                        Cube2[4].x - Cube2[5].x, Cube[4].y - Cube[5].y, Cube[4].z - Cube[5].z) / DetM;
                      iso.t[2] := det(Cube[1].x - Cube[5].x, Cube2[1].x - Cube2[5].x, Cube[1].z - Cube[5].z,
                        Cube[2].x - Cube[5].x, Cube2[2].x - Cube2[5].x, Cube[2].z - Cube[5].z,
                        Cube[4].x - Cube[5].x, Cube2[4].x - Cube2[5].x, Cube[4].z - Cube[5].z) / DetM;
                      iso.t[3] := det(Cube[1].x - Cube[5].x, Cube[1].y - Cube[5].y, Cube2[1].x - Cube2[5].x,
                        Cube[2].x - Cube[5].x, Cube[2].y - Cube[5].y, Cube2[2].x - Cube2[5].x,
                        Cube[4].x - Cube[5].x, Cube[4].y - Cube[5].y, Cube2[4].x - Cube2[5].x) / DetM;
                      iso.t[4] := det(Cube2[1].y - Cube2[5].y, Cube[1].y - Cube[5].y, Cube[1].z - Cube[5].z,
                        Cube2[2].y - Cube2[5].y, Cube[2].y - Cube[5].y, Cube[2].z - Cube[5].z,
                        Cube2[4].y - Cube2[5].y, Cube[4].y - Cube[5].y, Cube[4].z - Cube[5].z) / DetM;
                      iso.t[5] := det(Cube[1].x - Cube[5].x, Cube2[1].y - Cube2[5].y, Cube[1].z - Cube[5].z,
                        Cube[2].x - Cube[5].x, Cube2[2].y - Cube2[5].y, Cube[2].z - Cube[5].z,
                        Cube[4].x - Cube[5].x, Cube2[4].y - Cube2[5].y, Cube[4].z - Cube[5].z) / DetM;
                      iso.t[6] := det(Cube[1].x - Cube[5].x, Cube[1].y - Cube[5].y, Cube2[1].y - Cube2[5].y,
                        Cube[2].x - Cube[5].x, Cube[2].y - Cube[5].y, Cube2[2].y - Cube2[5].y,
                        Cube[4].x - Cube[5].x, Cube[4].y - Cube[5].y, Cube2[4].y - Cube2[5].y) / DetM;
                      iso.t[7] := det(Cube2[1].z - Cube2[5].z, Cube[1].y - Cube[5].y, Cube[1].z - Cube[5].z,
                        Cube2[2].z - Cube2[5].z, Cube[2].y - Cube[5].y, Cube[2].z - Cube[5].z,
                        Cube2[4].z - Cube2[5].z, Cube[4].y - Cube[5].y, Cube[4].z - Cube[5].z) / DetM;
                      iso.t[8] := det(Cube[1].x - Cube[5].x, Cube2[1].z - Cube2[5].z, Cube[1].z - Cube[5].z,
                        Cube[2].x - Cube[5].x, Cube2[2].z - Cube2[5].z, Cube[2].z - Cube[5].z,
                        Cube[4].x - Cube[5].x, Cube2[4].z - Cube2[5].z, Cube[4].z - Cube[5].z) / DetM;
                      iso.t[9] := det(Cube[1].x - Cube[5].x, Cube[1].y - Cube[5].y, Cube2[1].z - Cube2[5].z,
                        Cube[2].x - Cube[5].x, Cube[2].y - Cube[5].y, Cube2[2].z - Cube2[5].z,
                        Cube[4].x - Cube[5].x, Cube[4].y - Cube[5].y, Cube2[4].z - Cube2[5].z) / DetM;
                      iso.v[1] := Cube2[5].x - Cube[5].x * iso.t[1] - Cube[5].y * iso.t[2] - Cube[5].z * iso.t[4];
                      iso.v[2] := Cube2[5].y - Cube[5].x * iso.t[5] - Cube[5].y * iso.t[5] - Cube[5].z * iso.t[6];
                      iso.v[3] := Cube2[5].z - Cube[5].x * iso.t[7] - Cube[5].y * iso.t[8] - Cube[5].z * iso.t[9];
                      memo.Lines.Add(inttostr(i) + inttostr(j) + inttostr(k) + inttostr(L) + ' [' +
                        inttostr(counter) + ']');
                      for m := 1 to 9 do
                        memo.lines.add('iso.t[' + inttostr(m) + '] = ' + floattostr(iso.t[m]));
                      for m := 1 to 3 do
                        memo.lines.add('iso.v[' + inttostr(m) + '] = ' + floattostr(iso.v[m]));
                      memo.lines.add('');
                      inc(counter);
                    end;

  memo.Hint := memo.Text;
  memo.Show;
end;

procedure TFormPrincipal.OctahedraGroup;
var
  iso: TIsometry;
  i, j, k, L, m, counter: byte;
  detM: real;
begin
  counter := 0;
  memo.clear;
  for i := 1 to 6 do
    for j := 1 to 6 do
      if j <> i then
        if not octahedra[i].opposite(octahedra[j]) then
          for k := 1 to 6 do
            if k <> i then
              if k <> j then
                if abs(dist(octahedra[j], octahedra[k]) - 2) < 0.1 then
                  if not octahedra[i].opposite(octahedra[k]) then
                    for L := 1 to 6 do
                      if L <> i then
                        if L <> j then
                          if L <> k then
                            if not octahedra[i].opposite(octahedra[L]) then
                              if abs(dist(octahedra[k], octahedra[L]) - 2) < 0.1 then
                              begin
                                octahedra2[1] := octahedra[i];
                                octahedra2[2] := octahedra[j];
                                octahedra2[3] := octahedra[k];
                                octahedra2[4] := octahedra[L];
                                detM := det(octahedra[1].x - octahedra[4].x, octahedra[1].y - octahedra[4].y, octahedra[1].z - octahedra[4].z,
                                  octahedra[2].x - octahedra[4].x, octahedra[2].y - octahedra[4].y, octahedra[2].z - octahedra[4].z,
                                  octahedra[3].x - octahedra[4].x, octahedra[3].y - octahedra[4].y, octahedra[3].z - octahedra[4].z);
                                iso.t[1] := det(octahedra2[1].x - octahedra2[4].x, octahedra[1].y - octahedra[4].y, octahedra[1].z - octahedra[4].z,
                                  octahedra2[2].x - octahedra2[4].x, octahedra[2].y - octahedra[4].y, octahedra[2].z - octahedra[4].z,
                                  octahedra2[3].x - octahedra2[4].x, octahedra[3].y - octahedra[4].y, octahedra[3].z - octahedra[4].z) / DetM;
                                iso.t[2] := det(octahedra[1].x - octahedra[4].x, octahedra2[1].x - octahedra2[4].x, octahedra[1].z - octahedra[4].z,
                                  octahedra[2].x - octahedra[4].x, octahedra2[2].x - octahedra2[4].x, octahedra[2].z - octahedra[4].z,
                                  octahedra[3].x - octahedra[4].x, octahedra2[3].x - octahedra2[4].x, octahedra[3].z - octahedra[4].z) / DetM;
                                iso.t[3] := det(octahedra[1].x - octahedra[4].x, octahedra[1].y - octahedra[4].y, octahedra2[1].x - octahedra2[4].x,
                                  octahedra[2].x - octahedra[4].x, octahedra[2].y - octahedra[4].y, octahedra2[2].x - octahedra2[4].x,
                                  octahedra[3].x - octahedra[4].x, octahedra[3].y - octahedra[4].y, octahedra2[3].x - octahedra2[4].x) / DetM;
                                iso.t[4] := det(octahedra2[1].y - octahedra2[4].y, octahedra[1].y - octahedra[4].y, octahedra[1].z - octahedra[4].z,
                                  octahedra2[2].y - octahedra2[4].y, octahedra[2].y - octahedra[4].y, octahedra[2].z - octahedra[4].z,
                                  octahedra2[3].y - octahedra2[4].y, octahedra[3].y - octahedra[4].y, octahedra[3].z - octahedra[4].z) / DetM;
                                iso.t[5] := det(octahedra[1].x - octahedra[4].x, octahedra2[1].y - octahedra2[4].y, octahedra[1].z - octahedra[4].z,
                                  octahedra[2].x - octahedra[4].x, octahedra2[2].y - octahedra2[4].y, octahedra[2].z - octahedra[4].z,
                                  octahedra[3].x - octahedra[4].x, octahedra2[3].y - octahedra2[4].y, octahedra[3].z - octahedra[4].z) / DetM;
                                iso.t[6] := det(octahedra[1].x - octahedra[4].x, octahedra[1].y - octahedra[4].y, octahedra2[1].y - octahedra2[4].y,
                                  octahedra[2].x - octahedra[4].x, octahedra[2].y - octahedra[4].y, octahedra2[2].y - octahedra2[4].y,
                                  octahedra[3].x - octahedra[4].x, octahedra[3].y - octahedra[4].y, octahedra2[3].y - octahedra2[4].y) / DetM;
                                iso.t[7] := det(octahedra2[1].z - octahedra2[4].z, octahedra[1].y - octahedra[4].y, octahedra[1].z - octahedra[4].z,
                                  octahedra2[2].z - octahedra2[4].z, octahedra[2].y - octahedra[4].y, octahedra[2].z - octahedra[4].z,
                                  octahedra2[3].z - octahedra2[4].z, octahedra[3].y - octahedra[4].y, octahedra[3].z - octahedra[4].z) / DetM;
                                iso.t[8] := det(octahedra[1].x - octahedra[4].x, octahedra2[1].z - octahedra2[4].z, octahedra[1].z - octahedra[4].z,
                                  octahedra[2].x - octahedra[4].x, octahedra2[2].z - octahedra2[4].z, octahedra[2].z - octahedra[4].z,
                                  octahedra[3].x - octahedra[4].x, octahedra2[3].z - octahedra2[4].z, octahedra[3].z - octahedra[4].z) / DetM;
                                iso.t[9] := det(octahedra[1].x - octahedra[4].x, octahedra[1].y - octahedra[4].y, octahedra2[1].z - octahedra2[4].z,
                                  octahedra[2].x - octahedra[4].x, octahedra[2].y - octahedra[4].y, octahedra2[2].z - octahedra2[4].z,
                                  octahedra[3].x - octahedra[4].x, octahedra[3].y - octahedra[4].y, octahedra2[3].z - octahedra2[4].z) / DetM;
                                iso.v[1] := octahedra2[4].x - octahedra[4].x * iso.t[1] - octahedra[4].y * iso.t[2] - octahedra[4].z * iso.t[3];
                                iso.v[2] := octahedra2[4].y - octahedra[4].x * iso.t[4] - octahedra[4].y * iso.t[5] - octahedra[4].z * iso.t[6];
                                iso.v[3] := octahedra2[4].z - octahedra[4].x * iso.t[7] - octahedra[4].y * iso.t[8] - octahedra[4].z * iso.t[9];
                                memo.Lines.Add(inttostr(i) + inttostr(j) + inttostr(k) + inttostr(L) + ' [' +
                                  inttostr(counter) + ']');
                                for m := 1 to 9 do
                                  memo.lines.add('iso.t[' + inttostr(m) + '] = ' + floattostr(iso.t[m]));
                                for m := 1 to 3 do
                                  memo.lines.add('iso.v[' + inttostr(m) + '] = ' + floattostr(iso.v[m]));
                                memo.lines.add('');
                                inc(counter);
                              end;

  memo.Hint := memo.Text;
  memo.Show;
end;

procedure TFormPrincipal.IcosahedraGroup;
var
  iso: TIsometry;
  i, j, k, L, m, counter: byte;
  detM: real;
begin
  Side := dist(icosahedra[1], icosahedra[2]);
  counter := 0;
  memo.clear;
  for i := 1 to 12 do
    for j := 1 to 12 do
      if j <> i then
        if abs(dist(icosahedra[i], icosahedra[j]) - side) < 0.1 then
          for k := 1 to 12 do
            if k <> i then
              if k <> j then
                if abs(dist(icosahedra[i], icosahedra[k]) - side) < 0.1 then
                  for L := 1 to 12 do
                    if L <> i then
                      if L <> j then
                        if L <> k then
                          if abs(dist(icosahedra[i], icosahedra[L]) - side) < 0.1 then
                            if abs(dist(icosahedra[j], icosahedra[k]) - dist(icosahedra[k], icosahedra[L])) < 0.1 then
                              if abs(dist(icosahedra[L], icosahedra[j]) - side) > 0.1 then
                              begin
                                icosahedra2[1] := icosahedra[i];
                                icosahedra2[2] := icosahedra[j];
                                icosahedra2[3] := icosahedra[k];
                                icosahedra2[4] := icosahedra[L];
                                detM := det(icosahedra[1].x - icosahedra[4].x, icosahedra[1].y - icosahedra[4].y, icosahedra[1].z - icosahedra[4].z,
                                  icosahedra[2].x - icosahedra[4].x, icosahedra[2].y - icosahedra[4].y, icosahedra[2].z - icosahedra[4].z,
                                  icosahedra[3].x - icosahedra[4].x, icosahedra[3].y - icosahedra[4].y, icosahedra[3].z - icosahedra[4].z);
                                iso.t[1] := det(icosahedra2[1].x - icosahedra2[4].x, icosahedra[1].y - icosahedra[4].y, icosahedra[1].z - icosahedra[4].z,
                                  icosahedra2[2].x - icosahedra2[4].x, icosahedra[2].y - icosahedra[4].y, icosahedra[2].z - icosahedra[4].z,
                                  icosahedra2[3].x - icosahedra2[4].x, icosahedra[3].y - icosahedra[4].y, icosahedra[3].z - icosahedra[4].z) / DetM;
                                iso.t[2] := det(icosahedra[1].x - icosahedra[4].x, icosahedra2[1].x - icosahedra2[4].x, icosahedra[1].z - icosahedra[4].z,
                                  icosahedra[2].x - icosahedra[4].x, icosahedra2[2].x - icosahedra2[4].x, icosahedra[2].z - icosahedra[4].z,
                                  icosahedra[3].x - icosahedra[4].x, icosahedra2[3].x - icosahedra2[4].x, icosahedra[3].z - icosahedra[4].z) / DetM;
                                iso.t[3] := det(icosahedra[1].x - icosahedra[4].x, icosahedra[1].y - icosahedra[4].y, icosahedra2[1].x - icosahedra2[4].x,
                                  icosahedra[2].x - icosahedra[4].x, icosahedra[2].y - icosahedra[4].y, icosahedra2[2].x - icosahedra2[4].x,
                                  icosahedra[3].x - icosahedra[4].x, icosahedra[3].y - icosahedra[4].y, icosahedra2[3].x - icosahedra2[4].x) / DetM;
                                iso.t[4] := det(icosahedra2[1].y - icosahedra2[4].y, icosahedra[1].y - icosahedra[4].y, icosahedra[1].z - icosahedra[4].z,
                                  icosahedra2[2].y - icosahedra2[4].y, icosahedra[2].y - icosahedra[4].y, icosahedra[2].z - icosahedra[4].z,
                                  icosahedra2[3].y - icosahedra2[4].y, icosahedra[3].y - icosahedra[4].y, icosahedra[3].z - icosahedra[4].z) / DetM;
                                iso.t[5] := det(icosahedra[1].x - icosahedra[4].x, icosahedra2[1].y - icosahedra2[4].y, icosahedra[1].z - icosahedra[4].z,
                                  icosahedra[2].x - icosahedra[4].x, icosahedra2[2].y - icosahedra2[4].y, icosahedra[2].z - icosahedra[4].z,
                                  icosahedra[3].x - icosahedra[4].x, icosahedra2[3].y - icosahedra2[4].y, icosahedra[3].z - icosahedra[4].z) / DetM;
                                iso.t[6] := det(icosahedra[1].x - icosahedra[4].x, icosahedra[1].y - icosahedra[4].y, icosahedra2[1].y - icosahedra2[4].y,
                                  icosahedra[2].x - icosahedra[4].x, icosahedra[2].y - icosahedra[4].y, icosahedra2[2].y - icosahedra2[4].y,
                                  icosahedra[3].x - icosahedra[4].x, icosahedra[3].y - icosahedra[4].y, icosahedra2[3].y - icosahedra2[4].y) / DetM;
                                iso.t[7] := det(icosahedra2[1].z - icosahedra2[4].z, icosahedra[1].y - icosahedra[4].y, icosahedra[1].z - icosahedra[4].z,
                                  icosahedra2[2].z - icosahedra2[4].z, icosahedra[2].y - icosahedra[4].y, icosahedra[2].z - icosahedra[4].z,
                                  icosahedra2[3].z - icosahedra2[4].z, icosahedra[3].y - icosahedra[4].y, icosahedra[3].z - icosahedra[4].z) / DetM;
                                iso.t[8] := det(icosahedra[1].x - icosahedra[4].x, icosahedra2[1].z - icosahedra2[4].z, icosahedra[1].z - icosahedra[4].z,
                                  icosahedra[2].x - icosahedra[4].x, icosahedra2[2].z - icosahedra2[4].z, icosahedra[2].z - icosahedra[4].z,
                                  icosahedra[3].x - icosahedra[4].x, icosahedra2[3].z - icosahedra2[4].z, icosahedra[3].z - icosahedra[4].z) / DetM;
                                iso.t[9] := det(icosahedra[1].x - icosahedra[4].x, icosahedra[1].y - icosahedra[4].y, icosahedra2[1].z - icosahedra2[4].z,
                                  icosahedra[2].x - icosahedra[4].x, icosahedra[2].y - icosahedra[4].y, icosahedra2[2].z - icosahedra2[4].z,
                                  icosahedra[3].x - icosahedra[4].x, icosahedra[3].y - icosahedra[4].y, icosahedra2[3].z - icosahedra2[4].z) / DetM;
                                iso.v[1] := icosahedra2[4].x - icosahedra[4].x * iso.t[1] - icosahedra[4].y * iso.t[2] - icosahedra[4].z * iso.t[3];
                                iso.v[2] := icosahedra2[4].y - icosahedra[4].x * iso.t[4] - icosahedra[4].y * iso.t[5] - icosahedra[4].z * iso.t[6];
                                iso.v[3] := icosahedra2[4].z - icosahedra[4].x * iso.t[7] - icosahedra[4].y * iso.t[8] - icosahedra[4].z * iso.t[9];
                                memo.Lines.Add(inttostr(i) + ',' + inttostr(j) + ',' + inttostr(k) + ',' + inttostr(L) + ' [' +
                                  inttostr(counter) + ']');
                                for m := 1 to 9 do
                                  memo.lines.add('iso.t[' + inttostr(m) + '] = ' + floattostr(iso.t[m]));
                                for m := 1 to 3 do
                                  memo.lines.add('iso.v[' + inttostr(m) + '] = ' + floattostr(iso.v[m]));
                                memo.lines.add('');
                                inc(counter);
                              end;

  memo.Hint := memo.Text;
  memo.Show;
end;

procedure TFormPrincipal.DodecahedraGroup;
var
  iso: TIsometry;
  i, j, k, L, m, counter: byte;
  detM: real;
begin
  Side := dist(dodecahedra[1], dodecahedra[2]);
  counter := 0;
  memo.clear;
  for i := 1 to 20 do
    for j := 1 to 20 do
      if j <> i then
        if abs(dist(dodecahedra[i], dodecahedra[j]) - side) < 0.1 then
          for k := 1 to 20 do
            if k <> i then
              if k <> j then
                if abs(dist(dodecahedra[i], dodecahedra[k]) - side) < 0.1 then
                  for L := 1 to 20 do
                    if L <> i then
                      if L <> j then
                        if L <> k then
                          if abs(dist(dodecahedra[i], dodecahedra[L]) - side) < 0.1 then
                          begin
                            //Caption := inttostr(i) + ',' + inttostr(j) + ',' + inttostr(k) + ',' + inttostr(L) + ' [' +
                            //  inttostr(counter) + ']';
                            dodecahedra2[1] := dodecahedra[i];
                            dodecahedra2[2] := dodecahedra[j];
                            dodecahedra2[3] := dodecahedra[k];
                            dodecahedra2[4] := dodecahedra[L];
                            detM := det(dodecahedra[1].x - dodecahedra[4].x, dodecahedra[1].y - dodecahedra[4].y, dodecahedra[1].z - dodecahedra[4].z,
                              dodecahedra[2].x - dodecahedra[4].x, dodecahedra[2].y - dodecahedra[4].y, dodecahedra[2].z - dodecahedra[4].z,
                              dodecahedra[3].x - dodecahedra[4].x, dodecahedra[3].y - dodecahedra[4].y, dodecahedra[3].z - dodecahedra[4].z);
                            iso.t[1] := det(dodecahedra2[1].x - dodecahedra2[4].x, dodecahedra[1].y - dodecahedra[4].y, dodecahedra[1].z - dodecahedra[4].z,
                              dodecahedra2[2].x - dodecahedra2[4].x, dodecahedra[2].y - dodecahedra[4].y, dodecahedra[2].z - dodecahedra[4].z,
                              dodecahedra2[3].x - dodecahedra2[4].x, dodecahedra[3].y - dodecahedra[4].y, dodecahedra[3].z - dodecahedra[4].z) / DetM;
                            iso.t[2] := det(dodecahedra[1].x - dodecahedra[4].x, dodecahedra2[1].x - dodecahedra2[4].x, dodecahedra[1].z - dodecahedra[4].z,
                              dodecahedra[2].x - dodecahedra[4].x, dodecahedra2[2].x - dodecahedra2[4].x, dodecahedra[2].z - dodecahedra[4].z,
                              dodecahedra[3].x - dodecahedra[4].x, dodecahedra2[3].x - dodecahedra2[4].x, dodecahedra[3].z - dodecahedra[4].z) / DetM;
                            iso.t[3] := det(dodecahedra[1].x - dodecahedra[4].x, dodecahedra[1].y - dodecahedra[4].y, dodecahedra2[1].x - dodecahedra2[4].x,
                              dodecahedra[2].x - dodecahedra[4].x, dodecahedra[2].y - dodecahedra[4].y, dodecahedra2[2].x - dodecahedra2[4].x,
                              dodecahedra[3].x - dodecahedra[4].x, dodecahedra[3].y - dodecahedra[4].y, dodecahedra2[3].x - dodecahedra2[4].x) / DetM;
                            iso.t[4] := det(dodecahedra2[1].y - dodecahedra2[4].y, dodecahedra[1].y - dodecahedra[4].y, dodecahedra[1].z - dodecahedra[4].z,
                              dodecahedra2[2].y - dodecahedra2[4].y, dodecahedra[2].y - dodecahedra[4].y, dodecahedra[2].z - dodecahedra[4].z,
                              dodecahedra2[3].y - dodecahedra2[4].y, dodecahedra[3].y - dodecahedra[4].y, dodecahedra[3].z - dodecahedra[4].z) / DetM;
                            iso.t[5] := det(dodecahedra[1].x - dodecahedra[4].x, dodecahedra2[1].y - dodecahedra2[4].y, dodecahedra[1].z - dodecahedra[4].z,
                              dodecahedra[2].x - dodecahedra[4].x, dodecahedra2[2].y - dodecahedra2[4].y, dodecahedra[2].z - dodecahedra[4].z,
                              dodecahedra[3].x - dodecahedra[4].x, dodecahedra2[3].y - dodecahedra2[4].y, dodecahedra[3].z - dodecahedra[4].z) / DetM;
                            iso.t[6] := det(dodecahedra[1].x - dodecahedra[4].x, dodecahedra[1].y - dodecahedra[4].y, dodecahedra2[1].y - dodecahedra2[4].y,
                              dodecahedra[2].x - dodecahedra[4].x, dodecahedra[2].y - dodecahedra[4].y, dodecahedra2[2].y - dodecahedra2[4].y,
                              dodecahedra[3].x - dodecahedra[4].x, dodecahedra[3].y - dodecahedra[4].y, dodecahedra2[3].y - dodecahedra2[4].y) / DetM;
                            iso.t[7] := det(dodecahedra2[1].z - dodecahedra2[4].z, dodecahedra[1].y - dodecahedra[4].y, dodecahedra[1].z - dodecahedra[4].z,
                              dodecahedra2[2].z - dodecahedra2[4].z, dodecahedra[2].y - dodecahedra[4].y, dodecahedra[2].z - dodecahedra[4].z,
                              dodecahedra2[3].z - dodecahedra2[4].z, dodecahedra[3].y - dodecahedra[4].y, dodecahedra[3].z - dodecahedra[4].z) / DetM;
                            iso.t[8] := det(dodecahedra[1].x - dodecahedra[4].x, dodecahedra2[1].z - dodecahedra2[4].z, dodecahedra[1].z - dodecahedra[4].z,
                              dodecahedra[2].x - dodecahedra[4].x, dodecahedra2[2].z - dodecahedra2[4].z, dodecahedra[2].z - dodecahedra[4].z,
                              dodecahedra[3].x - dodecahedra[4].x, dodecahedra2[3].z - dodecahedra2[4].z, dodecahedra[3].z - dodecahedra[4].z) / DetM;
                            iso.t[9] := det(dodecahedra[1].x - dodecahedra[4].x, dodecahedra[1].y - dodecahedra[4].y, dodecahedra2[1].z - dodecahedra2[4].z,
                              dodecahedra[2].x - dodecahedra[4].x, dodecahedra[2].y - dodecahedra[4].y, dodecahedra2[2].z - dodecahedra2[4].z,
                              dodecahedra[3].x - dodecahedra[4].x, dodecahedra[3].y - dodecahedra[4].y, dodecahedra2[3].z - dodecahedra2[4].z) / DetM;
                            iso.v[1] := dodecahedra2[4].x - dodecahedra[4].x * iso.t[1] - dodecahedra[4].y * iso.t[2] - dodecahedra[4].z * iso.t[3];
                            iso.v[2] := dodecahedra2[4].y - dodecahedra[4].x * iso.t[4] - dodecahedra[4].y * iso.t[5] - dodecahedra[4].z * iso.t[6];
                            iso.v[3] := dodecahedra2[4].z - dodecahedra[4].x * iso.t[7] - dodecahedra[4].y * iso.t[8] - dodecahedra[4].z * iso.t[9];
                            memo.Lines.Add(inttostr(i) + ',' + inttostr(j) + ',' + inttostr(k) + ',' + inttostr(L) + ' [' +
                              inttostr(counter) + ']');
                            for m := 1 to 9 do
                              memo.lines.add('iso.t[' + inttostr(m) + '] = ' + floattostr(iso.t[m]));
                            for m := 1 to 3 do
                              memo.lines.add('iso.v[' + inttostr(m) + '] = ' + floattostr(iso.v[m]));
                            memo.lines.add('');
                            inc(counter);
                          end;

  memo.Hint := memo.Text;
  memo.Show;
end;

procedure TFormPrincipal.MemoDblClick(Sender: TObject);
begin
  memo.Hide;
end;

procedure TFormPrincipal.FormDblClick(Sender: TObject);
begin
  Memo.Show;
  Memo.Hint := memo.Text;
end;

initialization
  ZeroUnitary;

  ScreenTopLeft.x := 0;
  ScreenTopLeft.y := 0;
  BottomLeft.x := -5;
  BottomLeft.y := -4;
  TopRight.x := 5;
  TopRight.y := 4;
end.

