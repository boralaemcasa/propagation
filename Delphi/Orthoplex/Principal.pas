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

  Txyzw = record
    x, y, z, w: real;
  end;

type
  TFormPrincipal = class(TForm)
    TimerInit: TTimer;
    Panel: TPanel;
    cbEixos: TCheckBox;
    cb12A: TCheckBox;
    cb20: TCheckBox;
    cb12B: TCheckBox;
    Memo: TMemo;
    procedure TimerInitTimer(Sender: TObject);
    procedure cbEixosClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EditR1Change(Sender: TObject);
    procedure EditNKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  public
    Lado: real;
    Vertice: array[1..8] of Txyzw;
    procedure MostrarCubos;
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

function dist(p1, p2: Txyzw): real;
begin
  result := sqr(p1.x - p2.x) + sqr(p1.y - p2.y) + sqr(p1.z - p2.z) + sqr(p1.w - p2.w);
  result := sqrt(result);
end;

function norma(p1: Txyzw): real;
begin
  result := sqr(p1.x) + sqr(p1.y) + sqr(p1.z) + sqr(p1.w);
  result := sqrt(result);
end;

function det(a, b, c, p, q, r, x, y, z: real): real;
begin
  result := a * (q * z - r * y) - b * (p * z - r * x) + c * (p * y - q * x);
end;

// será q P está dentro do paralelogramo ABCD? (Cubo N)

// em torno de i

procedure Txy.SetXY(newX, newY: real);
begin
  x := newX;
  y := newY;
end;

procedure SetXYZW(var v: Txyzw; newX, newY, newZ, newW: real);
begin
  v.x := newX;
  v.y := newY;
  v.z := newZ;
  v.w := newW;
end;
{
function media(a, b: Txyzw): Txyzw; overload;
begin
  result.x := (a.x + b.x) / 2;
  result.y := (a.y + b.y) / 2;
  result.z := (a.z + b.z) / 2;
  result.w := (a.w + b.w) / 2;
end;

function media(a, b, c: Txyzw): Txyzw; overload;
begin
  result.x := (a.x + b.x + c.x ) / 3;
  result.y := (a.y + b.y + c.y ) / 3;
  result.z := (a.z + b.z + c.z ) / 3;
  result.w := (a.w + b.w + c.w ) / 3;
end;
}

procedure ZerarCubos;
begin
  unitario[1].SetXY(1, -1);
  unitario[2].SetXY(1, 1);
  unitario[3].SetXY(0, 1);
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

var
  ScreenBottomRight: record
    x, y: integer;
  end;

begin
  ScreenBottomRight.x := width;
  ScreenBottomRight.y := height;
  Qx := (ScreenBottomRight.x - ScreenTopLeft.x) / (TopRight.x - BottomLeft.x);
  Qy := (ScreenBottomRight.y - ScreenTopLeft.y) / (TopRight.y - BottomLeft.y);
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

procedure TFormPrincipal.EditR1Change(Sender: TObject);
begin
  MostrarCubos;
end;

procedure TFormPrincipal.EditNKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',',','-']) then
  begin
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

function produtointerno(a, b: txyzw): real;
begin
  result := a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
end;

var
  conta0, contaMeio, contaOutros, contaCentros: integer;
  centro: array[1..24] of Txyzw;

function angulo(a, b, c: Txyzw): string;
var d, e: Txyzw;
begin
  d.x := b.x - a.x;
  d.y := b.y - a.y;
  d.z := b.z - a.z;
  d.w := b.w - a.w;
  e.x := c.x - a.x;
  e.y := c.y - a.y;
  e.z := c.z - a.z;
  e.w := c.w - a.w;
  result := floattostr(produtoInterno(d, e) / (norma(d) * norma(e)));
  if result = '0' then
    inc(conta0)
  else if result = '0,5' then
    inc(contaMeio)
  else if result = '0,707106781186548' then
    inc(contaOutros)
  else
    showmessage(result);
end;

function angulos3(a, b, c: Txyzw): string;
begin
  result := angulo(a, b, c) + ' ' +
            angulo(b, c, a) + ' ' +
            angulo(c, a, b);
end;

function angulos4(a, b, c, d: Txyzw): string;
begin
  //conta0 := 0;
  result := angulo(a, b, c);
  result := result + ' ' + angulo(b, c, d);
  result := result + ' ' + angulo(c, d, a);
  result := result + ' ' + angulo(d, a, b);
  result := inttostr(conta0);
end;

function angulos16(a1, b1, c1, d1, e1, f1, g1, h1,
                   a2, b2, c2, d2, e2, f2, g2, h2: Txyzw): string;
var
  v: array[1..16] of txyzw;
  i, j, k, L: integer;
begin
  conta0 := 0;
  v[1] := a1;
  v[2] := b1;
  v[3] := c1;
  v[4] := d1;
  v[5] := e1;
  v[6] := f1;
  v[7] := g1;
  v[8] := h1;
  v[9] := a2;
  v[10] := b2;
  v[11] := c2;
  v[12] := d2;
  v[13] := e2;
  v[14] := f2;
  v[15] := g2;
  v[16] := h2;

  for i := 1 to 13 do
    for j := i + 1 to 14 do
      for k := j + 1 to 15 do
        for L := k + 1 to 16 do
          //if conta0 <= 24 * 4 then
            angulos4(v[i], v[j], v[k], v[L]);

  result := inttostr(conta0);
  while length(result) < 4 do
    result := '0' + result;
end;

function floattostry(x: real): string;
begin
  result := floattostr(x);
  while length(result) < 20 do
    result := ' ' + result;
end;

function soma16(a1, b1, c1, d1, e1, f1, g1, h1,
                   a2, b2, c2, d2, e2, f2, g2, h2: Txyzw): string;
var
  v: array[1..16] of txyzw;
  i, j, k, L: integer;
begin
  conta0 := 0;
  v[1] := a1;
  v[2] := b1;
  v[3] := c1;
  v[4] := d1;
  v[5] := e1;
  v[6] := f1;
  v[7] := g1;
  v[8] := h1;
  v[9] := a2;
  v[10] := b2;
  v[11] := c2;
  v[12] := d2;
  v[13] := e2;
  v[14] := f2;
  v[15] := g2;
  v[16] := h2;

  for i := 2 to 16 do
  begin
    v[1].x := v[1].x + v[i].x;
    v[1].y := v[1].y + v[i].y;
    v[1].z := v[1].z + v[i].z;
    v[1].w := v[1].w + v[i].w;
  end;

  result := floattostr(v[1].x) + ' ; ' + floattostr(v[1].y) + ' ; ' + floattostr(v[1].z) + ' ; ' + floattostr(v[1].w);

  if abs(v[1].x) < 1e-3 then
    if abs(v[1].y) < 1e-3 then
      if abs(v[1].z) < 1e-3 then
        if abs(v[1].w) < 1e-3 then
          result := '0';
end;

function IsItACube(a1, b1, c1, d1, e1, f1, g1, h1,
                   a2, b2, c2, d2, e2, f2, g2, h2: Txyzw): string;
var
  v: array[1..16] of txyzw;
  i, j, k: integer;
  s, sn: string;
begin
  v[1] := a1;
  v[2] := b1;
  v[3] := c1;
  v[4] := d1;
  v[5] := e1;
  v[6] := f1;
  v[7] := g1;
  v[8] := h1;
  v[9] := a2;
  v[10] := b2;
  v[11] := c2;
  v[12] := d2;
  v[13] := e2;
  v[14] := f2;
  v[15] := g2;
  v[16] := h2;

  conta0 := 0;
  contaMeio := 0;
  contaOutros := 0;
  contaCentros := 0;
  for i := 1 to 15 do
    for j := i + 1 to 16 do
    begin
      s := floattostr(dist(v[i], v[j]));
      if s = '0,235702260395516' then
        inc(conta0)
      else if s = '0,333333333333333' then
        inc(contameio)
      else if s = '0,166666666666667' then
        inc(contacentros)
      else // 0,288675134594813
        inc(contaoutros);
    end;

  sn := '';
  s := ']' + inttostr(conta0) + ';' + inttostr(contameio) + ';' + inttostr(contacentros) + ';'
    + inttostr(contaoutros);
  k := pos(s, FormPrincipal.memo.text);
  if k = 0 then
    FormPrincipal.Memo.Lines.Add('[1' + s)
  else
  begin
    s := formprincipal.memo.text;
    repeat
      dec(k);
    until s[k - 1] = '[';

    repeat
      sn := sn + s[k];
      delete(s, k, 1);
    until s[k] = ']'; 
    sn := inttostr(strtoint(sn) + 1);
    insert(sn, s, k);
    formprincipal.memo.text := s;
  end;
  result := '0';
end;

function media(a, b, c, d: Txyzw): string;
var
  v: array[1..6] of Txyzw;
  i, j, k, p, q: integer;
begin
  result := '';
  v[1] := a;
  v[2] := b;
  v[3] := c;
  v[4] := d;
  //v[5] := e;
  //v[6] := f;
  p := 0;
  q := 0;
  for i := 1 to 3 do
    for j := i + 1 to 4 do
    begin
      if abs(dist(v[i], v[j]) - 1) < 1e-3 then
        inc(p)
      else if abs(dist(v[i], v[j]) - sqrt(2)) < 1e-3 then
        inc(q)
      else
        showmessage(floattostr(dist(v[i], v[j])));

      //result := result + #13#10 + inttostr(i) + ' ; ' + inttostr(j) + ' ; ' + floattostr(dist(v[i], v[j]));
    end;

  conta0 := 0;
  contaMeio := 0;
  contaOutros := 0;

  for i := 1 to 2 do
    for j := i + 1 to 3 do
      for k := j + 1 to 4 do
        formPrincipal.memo.lines.add(angulos3(v[i], v[j], v[k]));

  formPrincipal.memo.lines.add('');

  a.x := (a.x + b.x + c.x + d.x) / 4;
  a.y := (a.y + b.y + c.y + d.y) / 4;
  a.z := (a.z + b.z + c.z + d.z) / 4;
  a.w := (a.w + b.w + c.w + d.w) / 4;
  result := result {+ #13#10} + floattostry(a.x) + ' ; ' + floattostry(a.y) + ' ; ' + floattostry(a.z) + ' ; ' + floattostry(a.w) + ' ; ' + inttostr(p) + ' ; ' + inttostr(q) + ' ; ' + inttostr(conta0) + ' ; ' + inttostr(contaMeio) + ' ; ' + inttostr(contaOutros);
  if norma(a) > 0 then
  begin
    inc(contaCentros);
    centro[contaCentros] := a;
  end;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var
  arq: textfile;
  diag: real;
  i1, i2, i3, i4, i5, i6, i7, i8,
  i9, i10, i11, i12, i13, i14, i15, i16: integer;
  s: string;
begin
  diag := 1/sqrt(2);
  SetXYZW(vertice[1], - diag, 0, 0, 0);
  SetXYZW(vertice[2], + diag, 0, 0, 0);
  SetXYZW(vertice[3], 0, - diag, 0, 0);
  SetXYZW(vertice[4], 0, + diag, 0, 0);
  SetXYZW(vertice[5], 0, 0, - diag, 0);
  SetXYZW(vertice[6], 0, 0, + diag, 0);
  SetXYZW(vertice[7], 0, 0, 0, - diag);
  SetXYZW(vertice[8], 0, 0, 0, + diag);
  contacentros := 0;

  assignfile(arq, 'temp20_faces.txt');
  rewrite(arq);
  for i1 := 1 to 5 do
    for i2 := i1 + 1 to 6 do
      for i3 := i2 + 1 to 7 do
        for i4 := i3 + 1 to 8 do
          //for i5 := i4 + 1 to 7 do
            //for i6 := i5 + 1 to 8 do
              writeln(arq, char(i1 + 65), ', ', char(i2 + 65), ', ', char(i3 + 65),
                     ', ', char(i4 + 65), ', ', //char(i5 + 65), ', ', char(i6 + 65),
                     ', ', Media(vertice[i1], vertice[i2], vertice[i3], vertice[i4]));

  writeln(arq);

  closefile(arq);

  exit;
  showmessage(memo.lines.text);
  memo.Clear;
  for i1 := 1 to 9 do
    for i2 := i1 + 1 to 10 do
      for i3 := i2 + 1 to 11 do
        for i4 := i3 + 1 to 12 do
  for i5 := i4 + 1 to 13 do
    for i6 := i5 + 1 to 14 do
      for i7 := i6 + 1 to 15 do
        for i8 := i7 + 1 to 16 do
  for i9 := i8 + 1 to 17 do
    for i10 := i9 + 1 to 18 do
      for i11 := i10 + 1 to 19 do
        for i12 := i11 + 1 to 20 do
  for i13 := i12 + 1 to 21 do
    for i14 := i13 + 1 to 22 do
      for i15 := i14 + 1 to 23 do
        for i16 := i15 + 1 to 24 do
        begin
          s := IsItACube(
              centro[i1], centro[i2], centro[i3], centro[i4],
              centro[i5], centro[i6], centro[i7], centro[i8],
              centro[i9], centro[i10], centro[i11], centro[i12],
              centro[i13], centro[i14], centro[i15], centro[i16]
              );

          if s = '1' then
          formPrincipal.memo.lines.add(
            inttostr(i1) + ';' + inttostr(i2) + ';' + inttostr(i3) + ';' + inttostr(i4) + ';' +
            inttostr(i5) + ';' + inttostr(i6) + ';' + inttostr(i7) + ';' + inttostr(i8) + ';' +
            inttostr(i9) + ';' + inttostr(i10) + ';' + inttostr(i11) + ';' + inttostr(i12) + ';' +
            inttostr(i13) + ';' + inttostr(i14) + ';' + inttostr(i15) + ';' + inttostr(i16)

              );
          //if conta0 <> 24 * 4 then
          //  formprincipal.memo.lines.Delete(memo.lines.count - 1);
        end;

  formPrincipal.memo.lines.add('');
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

