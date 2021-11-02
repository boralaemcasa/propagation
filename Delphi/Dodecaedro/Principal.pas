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
    function projecao: Txy;
  end;

type
  TFormPrincipal = class(TForm)
    TimerInit: TTimer;
    Panel: TPanel;
    cbEixos: TCheckBox;
    cb12A: TCheckBox;
    cb20: TCheckBox;
    cb12B: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerInitTimer(Sender: TObject);
    procedure cbEixosClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditR1Change(Sender: TObject);
    procedure EditNKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  public
    Lado: real;
    A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T: TXYZ;
    Vertice20Edro: array[1..12] of Txyz;
    Vertice12Edro: array[1..20] of Txyz;
    procedure MostrarCubos;
    procedure Girar(eixo: char; plus: boolean = true);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses StdConvs;

{$R *.DFM}

var // globais
  unitario: array[1..3] of Txy;

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

function dist(p1, p2: Txyz): real;
begin
  result := sqr(p1.x - p2.x) + sqr(p1.y - p2.y) + sqr(p1.z - p2.z);
  result := sqrt(result);
end;

function norma(p1: Txyz): real;
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

function media(a, b: Txyz): Txyz; overload;
begin
  result.x := (a.x + b.x) / 2;
  result.y := (a.y + b.y) / 2;
  result.z := (a.z + b.z) / 2;
end;

function media(a, b, c: Txyz): Txyz; overload;
begin
  result.x := (a.x + b.x + c.x ) / 3;
  result.y := (a.y + b.y + c.y ) / 3;
  result.z := (a.z + b.z + c.z ) / 3;
end;

function media(a, b, c, d, e: Txyz): Txyz; overload;
begin
  result.x := (a.x + b.x + c.x + d.x + e.x) / 5;
  result.y := (a.y + b.y + c.y + d.y + e.y) / 5;
  result.z := (a.z + b.z + c.z + d.z + e.z) / 5;
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
  end;
end;

procedure TFormPrincipal.MostrarCubos;

var Qx, Qy: real;
    razao: real;

  function PosX(a: real): integer; overload; // 2D
  begin
    result := ScreenTopLeft.x + round((a - BottomLeft.x) * Qx)
  end;

  function PosY(b: real): integer; overload; // 2D
  begin
    result := ScreenTopLeft.y + round((TopRight.y - b) * Qy)
  end;

  Function PosX(p: Txyz): integer; overload;
  begin
    result := PosX(p.x * unitario[1].x + p.y * unitario[2].x + p.z * unitario[3].x);
  end;

  Function PosY(p: Txyz): integer; overload;
  begin
    result := PosY(p.x * unitario[1].y + p.y * unitario[2].y + p.z * unitario[3].y);
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
  var pLinha: Txy;
    p2: Txyz;
    razao, lat, long: double;
    ii, jj: integer;
    arq: textFile;
  begin
    Refresh;
    if cbEixos.Checked then
    begin
      Canvas.Pen.Color := clFuchsia;
      p2.SetXYZ(3, 0, 0);
      pLinha := p2.projecao;
      Canvas.MoveTo(posx(pLinha.x), posy(pLinha.y));
      p2.x := 0;
      pLinha := p2.projecao;
      Canvas.LineTo(posx(pLinha.x), posy(pLinha.y)); //x
      p2.y := 3;
      pLinha := p2.projecao;
      Canvas.LineTo(posx(pLinha.x), posy(pLinha.y)); //y
      p2.y := 0;
      pLinha := p2.projecao;
      Canvas.MoveTo(posx(pLinha.x), posy(pLinha.y));
      p2.z := 3;
      pLinha := p2.projecao;
      Canvas.LineTo(posx(pLinha.x), posy(pLinha.y)); //z

      p2.SetXYZ(2, 0, 0);
      pLinha := p2.projecao;
      Canvas.TextOut(posx(pLinha.x), posy(pLinha.y), 'x');
      p2.SetXYZ(0, 2, 0);
      pLinha := p2.projecao;
      Canvas.TextOut(posx(pLinha.x), posy(pLinha.y), 'y');
      p2.SetXYZ(0, 0, 3);
      pLinha := p2.projecao;
      Canvas.TextOut(posx(pLinha.x), posy(pLinha.y), 'z');
    end;

    if Qx > Qy
      then razao := 1 / Qx
    else razao := 1 / Qy; // utilize razao para incrementar

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

  canvas.TextOut(posx(A), posy(A), 'A');
  canvas.TextOut(posx(B), posy(B), 'B');
  canvas.TextOut(posx(C), posy(C), 'C');
  canvas.TextOut(posx(D), posy(D), 'D');
  canvas.TextOut(posx(E), posy(E), 'E');
  canvas.TextOut(posx(F), posy(F), 'F');
  canvas.TextOut(posx(G), posy(G), 'G');
  canvas.TextOut(posx(H), posy(H), 'H');
  canvas.TextOut(posx(I), posy(I), 'I');
  canvas.TextOut(posx(J), posy(J), 'J');
  canvas.TextOut(posx(K), posy(K), 'K');
  canvas.TextOut(posx(L), posy(L), 'L');
  canvas.TextOut(posx(M), posy(M), 'M');
  canvas.TextOut(posx(N), posy(N), 'N');
  canvas.TextOut(posx(O), posy(O), 'O');
  canvas.TextOut(posx(P), posy(P), 'P');
  canvas.TextOut(posx(Q), posy(Q), 'Q');
  canvas.TextOut(posx(R), posy(R), 'R');
  canvas.TextOut(posx(S), posy(S), 'S');
  canvas.TextOut(posx(T), posy(T), 'T');
  end;

  if cb20.checked then
  begin
    assignfile(arq, 'temp20_arestas.txt');
    rewrite(arq);
    Canvas.Pen.Color := clRed;
    for ii := 1 to 11 do
      for jj := ii + 1 to 12 do
        if dist(vertice20edro[ii], vertice20edro[jj]) = dist(vertice20edro[1], vertice20edro[2]) then
        begin
          Canvas.MoveTo(posx(vertice20edro[ii]), posy(vertice20edro[ii]));
          Canvas.LineTo(posx(vertice20edro[jj]), posy(vertice20edro[jj]));
          writeln(arq, ii, ', ', jj);
        end;
    closefile(arq);
  end;

  if cb12B.checked then
  begin
    assignfile(arq, 'temp12B.txt');
    rewrite(arq);
    Canvas.Pen.Color := clBlack;
    for ii := 1 to 19 do
      for jj := ii + 1 to 20 do
        if abs(dist(vertice12edro[ii], vertice12edro[jj]) - dist(vertice12edro[1], vertice12edro[2])) < 1e-1 then
        begin
          Canvas.MoveTo(posx(vertice12edro[ii]), posy(vertice12Edro[ii]));
          Canvas.LineTo(posx(vertice12edro[jj]), posy(vertice12edro[jj]));
          writeln(arq, ii, ', ', jj);
        end;
    closefile(arq);
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
  Lado := 1.4;
  diag := (1 + sqrt(5)) * Lado / 2;
  x := (diag - Lado) / 2;
  height := Lado / 2;
  A.SetXYZ(- diag/2, - diag/2, - diag/2);
  B.SetXYZ(- diag/2, - diag/2, + diag/2);
  C.SetXYZ(- diag/2, + diag/2, - diag/2);
  D.SetXYZ(- diag/2, + diag/2, + diag/2);
  E.SetXYZ(+ diag/2, - diag/2, - diag/2);
  F.SetXYZ(+ diag/2, - diag/2, + diag/2);
  G.SetXYZ(+ diag/2, + diag/2, - diag/2);
  H.SetXYZ(+ diag/2, + diag/2, + diag/2);
  // Z +
  I.SetXYZ(- diag/2 + x, 0, diag/2 + height);
  J.SetXYZ(+ diag/2 - x, 0, diag/2 + height);
  // Z -
  K.SetXYZ(- diag/2 + x, 0, - diag/2 - height);
  L.SetXYZ(+ diag/2 - x, 0, - diag/2 - height);
  // Y +
  M.SetXYZ(0, diag/2 + height, - diag/2 + x);
  N.SetXYZ(0, diag/2 + height, + diag/2 - x);
  // Y -
  O.SetXYZ(0, - diag/2 - height, - diag/2 + x);
  P.SetXYZ(0, - diag/2 - height, + diag/2 - x);
  // X +
  Q.SetXYZ(diag/2 + height, - diag/2 + x, 0);
  R.SetXYZ(diag/2 + height, + diag/2 - x, 0);
  // X -
  S.SetXYZ(- diag/2 - height, - diag/2 + x, 0);
  T.SetXYZ(- diag/2 - height, + diag/2 - x, 0);


  Vertice20Edro[1]  := Media(I, J, H, N, D);  // IJHND Z+ 1
  vertice20Edro[2]  := Media(I, J, F, P, B);  // IJFPB Z+ 2
  vertice20Edro[3]  := Media(M, N, H, R, G);  // MNHRG Y+ 1
  vertice20Edro[4]  := Media(M, N, D, T, C);  // MNDTC Y+ 2
  vertice20Edro[5]  := Media(Q, R, H, J, F);  // QRHJF X+ 1
  vertice20Edro[6]  := Media(Q, R, G, L, E);  // QRGLE X+ 2
  vertice20Edro[7]  := Media(K, L, E, O, A);  // KLEOA Z- 1
  vertice20Edro[8]  := Media(K, L, G, M, C);  // KLGMC Z- 2
  vertice20Edro[9]  := Media(O, P, B, S, A);  // OPBSA Y- 1
  vertice20Edro[10] := Media(O, P, F, Q, E);  // OPFQE Y- 2
  vertice20Edro[11] := Media(S, T, D, I, B);  // STDIB X- 1
  vertice20Edro[12] := Media(S, T, C, K, A);  // STCKA X- 2

  assignfile(arq, 'temp20_faces.txt');
  rewrite(arq);
  LL := 1;
  for ii := 1 to 10 do
    for jj := ii + 1 to 11 do
      for kk := jj + 1 to 12 do
        if dist(vertice20edro[ii], vertice20edro[jj]) = dist(vertice20edro[1], vertice20edro[2]) then
          if dist(vertice20edro[ii], vertice20edro[kk]) = dist(vertice20edro[1], vertice20edro[2]) then
          if dist(vertice20edro[jj], vertice20edro[kk]) = dist(vertice20edro[1], vertice20edro[2]) then
            if LL <= 20 then
            begin
              Vertice12Edro[LL] := Media(vertice20edro[ii], vertice20edro[jj], vertice20Edro[kk]);
              inc(LL);
              writeln(arq, ii, ', ', jj, ', ', kk);
            end;

  writeln(arq);
  for ii := 1 to 19 do
    for jj := ii + 1 to 20 do
       writeln(arq, 'dist ', ii, ', ', jj, ', ', floattostr(dist(vertice12edro[ii], vertice12edro[jj])));
  closefile(arq);

  assignfile(arq, 'temp12.txt');
  rewrite(arq);
  // IJHND Z+ 1
  writeln(arq, 'IJ = ', floattostr(dist(I,J)));
  writeln(arq, 'JH = ', floattostr(dist(J,H)));
  writeln(arq, 'HN = ', floattostr(dist(H,N)));
  writeln(arq, 'ND = ', floattostr(dist(N,D)));
  writeln(arq, 'DI = ', floattostr(dist(D,I))); //5
  // IJFPB Z+ 2
  writeln(arq, 'JF = ', floattostr(dist(J,F)));
  writeln(arq, 'FP = ', floattostr(dist(F,P)));
  writeln(arq, 'PB = ', floattostr(dist(P,B)));
  writeln(arq, 'BI = ', floattostr(dist(B,I))); //9

  // MNHRG Y+ 1
  writeln(arq, 'MN = ', floattostr(dist(M,N)));
  writeln(arq, 'HR = ', floattostr(dist(H,R)));
  writeln(arq, 'RG = ', floattostr(dist(R,G)));
  writeln(arq, 'GM = ', floattostr(dist(G,M))); //13
  // MNDTC Y+ 2
  writeln(arq, 'DT = ', floattostr(dist(D,T)));
  writeln(arq, 'TC = ', floattostr(dist(T,C)));
  writeln(arq, 'CM = ', floattostr(dist(C,M))); //16

  // QRHJF X+ 1
  writeln(arq, 'QR = ', floattostr(dist(Q,R)));
  writeln(arq, 'FQ = ', floattostr(dist(F,Q))); //18
  // QRGLE X+ 2
  writeln(arq, 'GL = ', floattostr(dist(G,L)));
  writeln(arq, 'LE = ', floattostr(dist(L,E)));
  writeln(arq, 'EQ = ', floattostr(dist(E,Q))); //21

  // KLEOA Z- 1
  writeln(arq, 'KL = ', floattostr(dist(K,L)));
  writeln(arq, 'EO = ', floattostr(dist(E,O)));
  writeln(arq, 'OA = ', floattostr(dist(O,A)));
  writeln(arq, 'AK = ', floattostr(dist(A,K))); //25
  // KLGMC Z- 2
  writeln(arq, 'CK = ', floattostr(dist(C,K))); //26

  // OPBSA Y- 1
  writeln(arq, 'OP = ', floattostr(dist(O,P)));
  writeln(arq, 'BS = ', floattostr(dist(B,S)));
  writeln(arq, 'SA = ', floattostr(dist(S,A))); //29
  // OPFQE Y- 2

  // STDIB X- 1
  writeln(arq, 'ST = ', floattostr(dist(S,T))); //30
  // STCKA X- 2

  writeln(arq, 'Norma(A) = ', floattostr(Norma(A))); //30
  writeln(arq, 'Norma(B) = ', floattostr(Norma(B))); //30
  writeln(arq, 'Norma(C) = ', floattostr(Norma(C))); //30
  writeln(arq, 'Norma(D) = ', floattostr(Norma(D))); //30
  writeln(arq, 'Norma(E) = ', floattostr(Norma(E))); //30
  writeln(arq, 'Norma(F) = ', floattostr(Norma(F))); //30
  writeln(arq, 'Norma(G) = ', floattostr(Norma(G))); //30
  writeln(arq, 'Norma(H) = ', floattostr(Norma(H))); //30
  writeln(arq, 'Norma(I) = ', floattostr(Norma(I))); //30
  writeln(arq, 'Norma(J) = ', floattostr(Norma(J))); //30
  writeln(arq, 'Norma(K) = ', floattostr(Norma(K))); //30
  writeln(arq, 'Norma(L) = ', floattostr(Norma(L))); //30
  writeln(arq, 'Norma(M) = ', floattostr(Norma(M))); //30
  writeln(arq, 'Norma(N) = ', floattostr(Norma(N))); //30
  writeln(arq, 'Norma(O) = ', floattostr(Norma(O))); //30
  writeln(arq, 'Norma(P) = ', floattostr(Norma(P))); //30
  writeln(arq, 'Norma(Q) = ', floattostr(Norma(Q))); //30
  writeln(arq, 'Norma(R) = ', floattostr(Norma(R))); //30
  writeln(arq, 'Norma(S) = ', floattostr(Norma(S))); //30
  writeln(arq, 'Norma(T) = ', floattostr(Norma(T))); //30

  closefile(arq);
  Ordenar;
end;

initialization
  ZerarCubos;

  ScreenTopLeft.x := 0;
  ScreenTopLeft.y := 0;
  BottomLeft.x := -5;
  BottomLeft.y := -4;
  TopRight.x := 5;
  TopRight.y := 4;

end.

