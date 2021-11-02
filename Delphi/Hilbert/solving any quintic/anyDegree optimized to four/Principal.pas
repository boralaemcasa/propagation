unit Principal;

interface

uses
  Windows, DB, DBAccess, PgAccess, MemDS, ExtCtrls, StdCtrls, Controls,
  Classes, Dialogs, Forms, Grids, DBGrids;

type
  TFormPrincipal = class(TForm)
    Timer: TTimer;
    Panel1: TPanel;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton; btnMoreThan4: TButton;
    edN: TEdit;
    Panel2: TPanel;
    MemoY: TMemo;
    MemoX: TMemo;
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btnMoreThan4Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
  public
    procedure processar(n: integer);
    procedure processar2(n: integer);
    procedure processar3(n: integer);
    procedure processarN(n: integer);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses SNum, Poly2D, Poly, SysUtils, Messages, DataModulo;

function FindWindowByTitle(WindowTitle: string): Hwnd;
var
  NextHandle: Hwnd;
  NextTitle: array[0..260] of char;
begin
  // Get the first window
  NextHandle := GetWindow(Application.Handle, GW_HWNDFIRST);
  while NextHandle > 0 do
  begin
    // retrieve its text
    GetWindowText(NextHandle, NextTitle, 255);
    if Pos(WindowTitle, StrPas(NextTitle)) <> 0 then
    begin
      Result := NextHandle;
      Exit;
    end
    else
      // Get the next window
      NextHandle := GetWindow(NextHandle, GW_HWNDNEXT);
  end;
  Result := 0;
end;

procedure TFormPrincipal.processar(n: integer);
var
  i: integer;
  s, ni, nj: string;
  p: TPoly;
begin
  dm.qryResetMaster.paramByName('L').asString := 'm%n' + inttostr(N);
  dm.qryResetMaster.ExecSQL;
  p := TPoly.Create(n + 2);
  memoX.Lines.LoadFromFile(inttostr(n) + '.txt');
  for i := 0 to memoX.lines.count - 1 do
  begin
    s := memoX.lines[i];
    if copy(s, 1, 1) = 'i' then
      ni := copy(s, 5, length(s))
    else if copy(s, 1, 1) = 'j' then
      nj := copy(s, 5, length(s))
    else if s <> '' then
      p.AddToDisk('m' + ni + 'n' + inttostr(n), s);

    caption := '(I) ' + inttostr(i) + '/' + inttostr(memoX.lines.count) + ' = ' +
      inttostr(i * 100 div memoX.lines.count) + ' %';
    application.processMessages;
  end;
  p.free(false);
end;

procedure TFormPrincipal.processar2(n: integer);
var
  i, j, max: integer;
  q: array of TPoly;
begin
{
  dm.qryMinPower.paramByName('L').asString := 'm%n' + inttostr(n);
  dm.qryMinPower.paramByName('J').asString := Soma(inttostr(n), '2');
  dm.qryMinPower.Open;

  if dm.qryMinPower.FieldByName('m').AsInteger > 0 then
  begin
    dm.qryPowerUp.paramByName('p').asString := dm.qryMinPower.fieldByName('m').AsString;
    dm.qryPowerUp.paramByName('L').asString := 'm%n' + inttostr(n);
    dm.qryPowerUp.paramByName('J').asString := Soma(inttostr(n), '2');
    dm.qryPowerUp.ExecSQL;
  end;

  dm.qryMinPower.Close;
}
  max := 0;
  SetLength(q, n + 2);
  for i := 0 to n do
  begin
    q[i] := TPoly.Create(n + 2);
    q[i].mywho := 'm' + inttostr(i) + 'n' + inttostr(n);

    dm.qryMaxPower.ParamByName('w').AsString := q[i].mywho;
    dm.qryMaxPower.Open;
    q[i].max := dm.qryMaxPower.fieldByName('m').AsInteger;
    dm.qryMaxPower.Close;

    if q[i].max > max then
      max := q[i].max;
  end;

  memoX.clear;
  memoY.clear;

  for j := 0 to max do
    for i := 0 to n do
    begin
      //memoX.lines.add('i = ' + inttostr(i) + #13#10'j = ' + inttostr(j) + #13#10#13#10 + q[i].coefxInDisk(inttostr(j), false) + #13#10);
      memoY.lines.add('i = ' + inttostr(i) + #13#10'j = ' + inttostr(j) + #13#10#13#10 + q[i].coefxInDisk(inttostr(j), true) + #13#10);
    end;

  //memoX.Lines.SaveToFile(inttostr(n) + '.txt');
  memoY.Lines.SaveToFile(inttostr(n) + ' readme.txt');

  for i := 0 to n do
    q[i].free(false);
end;

procedure TFormPrincipal.btn2Click(Sender: TObject);
var a, doisa, b, b2, c, M, soma, ss: string;
  beta1, beta2: array[0..100] of string;
  i: integer;
  frac: SFrac;
begin
  if fileExists('2.txt') then
  begin
    processar(2);
    exit;
  end;
  a := '1';
  b := '5';
  c := '1/100';
  M := FracAbs(a);
  if FracCompare(FracAbs(b), M) > 0 then
    M := FracAbs(b);
  if FracCompare(FracAbs(c), M) > 0 then
    M := FracAbs(c);
  M := '1'; //FracAdd(M, '1')

//divida pelo máximo mais um
  a := FracDiv(a, M);
  b := FracDiv(b, M);
  c := FracDiv(c, M);
  doisa := FracMul('2', a);
  b2 := FracMul(b, b);

//derive 1 vez: ax^2 + bx + s = 0
//             2ax x' + b x' + 1 = 0
//              x' = -1/(2ax + b)

// m_1 x' + m_2 x + m_3 = 0

// -m_1/(2ax + b) + m_2 x + m_3 = 0

// -m_1 + m_2 x(2ax + b) + m_3(2ax + b) = 0

// ax^2 = - bx - s
// -m_1 + 2 m_2 (- bx - s) + b m_2 x + 2a m_3 x + b m_3 = 0

// x^0: - m_1 - 2 s m_2 + b m_3 = 0
// x^1: - 2 b m_2 + b m_2 + 2a m_3 = 0 ==> m_3 = b m_2 / (2a)
// x^0: - m_1 - 2 s m_2 + b^2 m_2 / (2a) = 0
//        m_1 = (b^2 - 4as)/(2a) m_2

//  m_2 := 2a;
//  m_1 := b^2 - 4as;
//  m_3 := b;

//  x(s) = y(s) - b/(2a)

  beta1[0] := '0';
  beta2[0] := FracOposto(FracDiv(b, a));

//  x(s) = b_0 + b_1 s + b_2 s^2 + ...

// (b^2 - 4as) \sum_0 (i + 1) b_{i + 1} s^i + 2a \sum_0 b_i s^i + b = 0

// \sum_0 [(i + 1) b^2 b_{i + 1} + 2a b_i] s^i - \sum_1 (i + 1) 4a b_i s^i + b = 0

// s^0: b^2 b_1 + 2ab_0 + b = 0

// b_1 = (- b - 2 a b_0) / b^2

  beta1[1] := FracOposto(FracDiv(FracAdd(b, FracMul(doisa, beta1[0])), b2));
  beta2[1] := FracOposto(FracDiv(FracAdd(b, FracMul(doisa, beta2[0])), b2));

// s^i: (i + 1) b^2 b_{i + 1} + 2ab_i - (i + 1) 4ab_i = 0

// b_{i + 1} = (4i + 2)/(i + 1) ab_i / b^2

  for i := 1 to 99 do
  begin
    ss := inttostr(4 * i + 2) + '/' + inttostr(i + 1);
    beta1[i + 1] := FracMul(ss, FracDiv(FracMul(a, beta1[i]), b2));
    beta2[i + 1] := FracMul(ss, FracDiv(FracMul(a, beta2[i]), b2));
  end;

  soma := beta1[0];
  ss := '1';
  for i := 1 to 100 do
  begin
    ss := FracMul(c, ss);
    soma := FracAdd(soma, FracMul(beta1[i], ss));
  end;
  frac := Str2Frac(soma);
  showmessage(DivideDizima(frac.n, frac.d, 20));

  soma := beta2[0];
  ss := '1';
  for i := 1 to 100 do
  begin
    ss := FracMul(c, ss);
    soma := FracAdd(soma, FracMul(beta2[i], ss));
  end;
  frac := Str2Frac(soma);
  showmessage(DivideDizima(frac.n, frac.d, 20));
end;

procedure TFormPrincipal.btn3Click(Sender: TObject);
var a, b, b2, b3, c, c2, c3, c4, d, M, all, bll, cll, dll, ii, al, aa, str: string;
  beta: array[0..50] of string;
  i, j: integer;
  p1, p2, p3, p4, px, jj, bl, dl, gl, bb, E, dd, k, L: TPoly2D;

  procedure f(var p: TPoly2D; n: integer);
  begin
    if p.degx < n then exit;

    px.SetDegree(n, 3);
    px.a[n - 1, 0] := FracOposto(FracMul(FracDiv(b, a), p.a[n, 0]));
    px.a[n - 2, 0] := FracOposto(FracMul(FracDiv(c, a), p.a[n, 0]));
    px.a[n - 3, 1] := FracMul(FracDiv('-1', a), p.a[n, 0]);
    px.a[n, 0] := FracOposto(p.a[n, 0]);
    if (p.degy > 0) and (p.a[n, 1] <> '0') then
    begin
      px.a[n - 1, 1] := FracOposto(FracMul(FracDiv(b, a), p.a[n, 1]));
      px.a[n - 2, 1] := FracOposto(FracMul(FracDiv(c, a), p.a[n, 1]));
      px.a[n - 3, 2] := FracMul(FracDiv('-1', a), p.a[n, 1]);
      px.a[n, 1] := FracOposto(p.a[n, 1]);
    end;
    if (p.degy > 1) and (p.a[n, 2] <> '0') then
    begin
      px.a[n - 1, 2] := FracOposto(FracMul(FracDiv(b, a), p.a[n, 2]));
      px.a[n - 2, 2] := FracOposto(FracMul(FracDiv(c, a), p.a[n, 2]));
      px.a[n - 3, 3] := FracMul(FracDiv('-1', a), p.a[n, 2]);
      px.a[n, 2] := FracOposto(p.a[n, 2]);
    end;
    p := p.Sum(px);
  end;

begin
  a := '1';
  b := '9';
  c := '26';
  d := '24';
  M := FracAbs(a);
  if FracCompare(FracAbs(b), M) > 0 then
    M := FracAbs(b);
  if FracCompare(FracAbs(c), M) > 0 then
    M := FracAbs(c);
  if FracCompare(FracAbs(d), M) > 0 then
    M := FracAbs(d);
  M := '1'; // FracAdd(M, '1');

//divida pelo máximo mais um
  a := FracDiv(a, M);
  b := FracDiv(b, M);
  c := FracDiv(c, M);
  d := FracDiv(d, M);
  b2 := FracMul(b, b);
  b3 := FracMul(b2, b);
  c2 := FracMul(c, c);
  c3 := FracMul(c2, c);
  c4 := FracMul(c3, c);

//derive 2 vezes: ax^3 + bx^2 + cx + s = 0
//               (3ax^2 + 2bx + c) x' + 1 = 0
//                x' = -1/(3ax^2 + 2bx + c)

//                (6ax x' + 2b x') x' + (3ax^2 + 2bx + c) x'' = 0
//                x'' = - (x')^2 (6ax + 2b)/(3ax^2 + 2bx + c)
//                x'' = - (6ax + 2b)/(3ax^2 + 2bx + c)^3

// m_1 x'' + m_2 x' + m_3 x + m_4 = 0

// - (6ax + 2b)/(3ax^2 + 2bx + c)^3 m_1 - m_2/(3ax^2 + 2bx + c) + m_3 x + m_4 = 0

// - (6ax + 2b) m_1 - (9 a^2 x^4 + 12 a b x^3 + 6 a c x^2 + 4 b^2 x^2 + 4 b c x + c^2) m_2
// + 27 a^3 m_3 x^7 + 27 a^3 m_4 x^6 + 54 a^2 b m_3 x^6 + 54 a^2 b m_4 x^5 + 27 a^2 c m_3 x^5
// + 27 a^2 c m_4 x^4 + 36 a b^2 m_3 x^5 + 36 a b^2 m_4 x^4 + 36 a b c m_3 x^4 + 36 a b c m_4 x^3
// + 9 a c^2 m_3 x^3 + 9 a c^2 m_4 x^2 + 8 b^3 m_3 x^4 + 8 b^3 m_4 x^3 + 12 b^2 c m_3 x^3
// + 12 b^2 c m_4 x^2 + 6 b c^2 m_3 x^2 + 6 b c^2 m_4 x + c^3 m_3 x + c^3 m_4 = 0

  px := TPoly2D.Create;
  px.setDegree(1, 0);
  px.a[1, 0] := '1';

  p1 := TPoly2D.Create;
  p1.setDegree(1, 0);
  p1.a[0, 0] := FracMul('-2', b);
  p1.a[1, 0] := FracMul('-6', a);

  p4 := TPoly2D.Create;
  p4.setDegree(2, 0);
  p4.a[0, 0] := c;
  p4.a[1, 0] := FracMul('2', b);
  p4.a[2, 0] := FracMul('3', a);
  p2 := p4.Multiply(p4);

  p4 := p4.Multiply(p2);
  p3 := p4.Multiply(px);
  p2 := p2.TimesConstant('-1');

// ax^3 = - bx^2 - cx - s

//  p3.a[7] {x^7 := - b/a x^6 - c/a x^5 - s/a x^4}

  f(p2, 4);
  f(p2, 3);

  f(p3, 7);
  f(p3, 6);
  f(p3, 5);
  f(p3, 4);
  f(p3, 3);

  f(p4, 6);
  f(p4, 5);
  f(p4, 4);
  f(p4, 3);

// x^0: m_1 A  + m_2 (B + Cs)   + m_3 Ds                 + m_4 (E + Fs + Gs^2) = 0
// x^1: m_1 A' + m_2 (B' + C's) + m_3 (D' + E's + F's^2) + m_4 (G' + H's) = 0
// x^2: m_1 0  + m_2 A''        + m_3 (B'' + C''s)       + m_4 D'' = 0

// (3) => m_4 = - m_2 I - m_3 (J + Ks)
// m_1 A  + m_2 (B + Cs - I((E + Fs + Gs^2))) + m_3 [Ds - (J + Ks) (E + Fs + Gs^2)] = 0
// m_1 A' + m_2 (B' + C's - I((G' + H's)))    + m_3 (D' + E's + F's^2 - (J + Ks) (G' + H's)) = 0

  all := p2.a[2, 0];
  bll := p3.a[2, 0];
  cll := p3.a[2, 1];
  dll := p4.a[2, 0];
  ii := FracDiv(all, dll);

  jj := TPoly2D.Create;
  jj.SetDegree(0, 1);
  jj.a[0, 0] := bll;
  jj.a[0, 1] := cll;
  jj := jj.TimesConstant(FracDiv('1', dll));

  gl := TPoly2D.Create;
  gl.SetDegree(0, 1);
  gl.a[0, 0] := p4.a[1, 0];
  gl.a[0, 1] := p4.a[1, 1];

  al := p1.a[0, 0];
  bl := TPoly2D.Create;
  bl.SetDegree(0, 1);
  bl.a[0, 0] := p2.a[1, 0];
  bl.a[0, 1] := p2.a[1, 1];
  bl := gl.timesConstant(FracOposto(ii)).sum(bl);

  dl := TPoly2D.Create;
  dl.setDegree(0, 2);
  dl.a[0, 0] := p3.a[1, 0];
  dl.a[0, 1] := p3.a[1, 1];
  dl.a[0, 2] := p3.a[1, 2];

  dl := jj.Multiply(gl).TimesConstant('-1').sum(dl);

// (2) ==> m_1 = - m_2 (b'/a') - m_3 (d'/a')
// (1) ==> m_1 aa  + m_2 (bb) + m_3 (dd) = 0

  E := TPoly2D.Create;
  E.setDegree(0, 2);
  E.a[0, 0] := p4.a[0, 0];
  E.a[0, 1] := p4.a[0, 1];
  E.a[0, 2] := p4.a[0, 2];

  aa := p1.a[0, 0];
  bb := TPoly2D.Create;
  bb.SetDegree(0, 1);
  bb.a[0, 0] := p2.a[0, 0];
  bb.a[0, 1] := p2.a[0, 1];
  bb := E.timesConstant(FracOposto(ii)).sum(bb);

  dd := jj.TimesConstant('-1').Multiply(E);
  dd.a[0, 1] := FracAdd(dd.a[0, 1], p3.a[0, 1]);

// m_3 (dd - aa d'/a') = m_2 [aa b'/a' - bb]

  aa := FracDiv(aa, al);
  dd := dl.TimesConstant(FracOposto(aa)).Sum(dd);

  bl := bl.TimesConstant(aa).Sum(bb.TimesConstant('-1'));
  memoX.lines.add('m_3 =');
  for i := bl.degx downto 0 do
    for j := bl.degy downto 0 do
    begin
      str := bl.a[i, j] + '*x^' + inttostr(i) + '*s^' + inttostr(j);
      if FracCompare(bl.a[i, j], '0') > 0 then
        memoX.Lines.Add('+' + str)
      else if FracCompare(bl.a[i, j], '0') < 0 then
        memoX.Lines.Add(str);
    end;

  memoX.lines.add('m_2 =');
  for i := dd.degx downto 0 do
    for j := dd.degy downto 0 do
    begin
      str := dd.a[i, j] + '*x^' + inttostr(i) + '*s^' + inttostr(j);
      if FracCompare(dd.a[i, j], '0') > 0 then
        memoX.Lines.Add('+' + str)
      else if FracCompare(dd.a[i, j], '0') < 0 then
        memoX.Lines.Add(str);
    end;

//  m_3 = b'/dd m_2
//  m_1 = - m_2 b'/a'[1 + d'/dd] = m_2 k/dd

  k := dd.Sum(dl).TimesConstant(FracDiv('-1', al)).Multiply(bl);

// m_4 = - m_2 [ii + b'/dd J] = m_2 L/dd

  L := dd.TimesConstant(ii).sum(bl.Multiply(jj)).TimesConstant('-1');

// M := [k, dd, b', L]

//incrível gambiarra empírica: onde foi que eu errei?
  k := k.timesConstant('-1');

  memoX.lines.add('m_1 =');
  for i := k.degx downto 0 do
    for j := k.degy downto 0 do
    begin
      str := k.a[i, j] + '*x^' + inttostr(i) + '*s^' + inttostr(j);
      if FracCompare(k.a[i, j], '0') > 0 then
        memoX.Lines.Add('+' + str)
      else if FracCompare(k.a[i, j], '0') < 0 then
        memoX.Lines.Add(str);
    end;

  memoX.lines.add('m_4 =');
  for i := L.degx downto 0 do
    for j := L.degy downto 0 do
    begin
      str := L.a[i, j] + '*x^' + inttostr(i) + '*s^' + inttostr(j);
      if FracCompare(L.a[i, j], '0') > 0 then
        memoX.Lines.Add('+' + str)
      else if FracCompare(L.a[i, j], '0') < 0 then
        memoX.Lines.Add(str);
    end;

// x(s) = b_0 + b_1 s + ...

// m_1^5 \sum_0 (i + 2) (i + 1) b_{i + 2} s^i + m_2^3 \sum_0 (i + 1) b_{i + 1} s^i + m_3^2 \sum_0 b_i s^i + m_4^2 = 0
// o maior grau de m_1 aparece em i >= 5

//   m15 (i - 3)(i - 4) b_{i - 3}
// + m14 (i - 2)(i - 3) b_{i - 2}
// + m13 (i - 1)(i - 2) b_{i - 1}  + m23 (i - 2) b_{i - 2}
// + m12 i      (i - 1) b_i        + m22 (i - 1) b_{i - 1}  + m32 b_{i - 2}  + 0 m42
// + m11 (i + 1)i       b_{i + 1}  + m21 i       b_i        + m31 b_{i - 1}  + 0 m41
// + m10 (i + 2)(i + 1) b_{i + 2}  + m20 (i + 1) b_{i + 1}  + m30 b_i        + 0 m40 = 0

// A_0 b_{i + 2} = A_1 b_{i + 1} + ... + A_5 b_{i - 3}
// precisamos fixar b_0 ... b_6

// ax^3 + bx^2 + cx = 0 ==> x(0) = 0 ou x(0) = -b \pm sqrt(delta) / (2a)
// x^2 + 9x + 26 = 0 ==> x = - 9/2 \pm i/2 sqrt 23

  beta[0] := '0';

//                x' = -1/(3ax^2 + 2bx + c)

  beta[1] := FracDiv('-1', c);

//                x'' = - (6ax + 2b)/(3ax^2 + 2bx + c)^3

  beta[2] := FracMul(FracPower(beta[1], '3'), FracMul('2', b));

// (3ax^2 + 2bx + c)^3 x'' + 6ax + 2b = 0
// 3 (3ax^2 + 2bx + c)^2 (6ax + 2b) x' x'' + (3ax^2 + 2bx + c)^3 x''' + 6ax' = 0
// 3 (6ax + 2b)^2/(3ax^2 + 2bx + c)^2 + (3ax^2 + 2bx + c)^3 x''' - 6a /(3ax^2 + 2bx + c)  = 0
// (3ax^2 + 2bx + c)^5 x''' + 3 (6ax + 2b)^2 - 6a (3ax^2 + 2bx + c) = 0

  beta[3] := FracAdd(FracMul(beta[2], FracDiv(FracMul('6', b), c2)),
    FracDiv(a, c4)); // -2b/c^3 * 6b/c^2 + a/c^4

// i = 0
// m10 2 b_2 + m20 b_1 + m30 b_0 + m40 = 0
// b_2 = (- m20 b_1 - m30 b_0 - m40)/m10 = f(1, 0, k)

// i = 1
// m11 2 b_2  + m21 b_1 + m31 b_0  + m41 + m10 6 b_3  + m20 2 b_2 + m30 b_1 = 0
// b_3 = f(2, 1, 0, k)

// i = 2
// m12 2 b_2  + m22 b_1 + m32 b_0 + m42 + m11 6 b_3  + m21 2 b_2 + m31 b_1
// + m10 12 b_4 + m20 3 b_3 + m30 b_2 = 0
// b_4 = f(3, 2, 1, 0, k)

// i = 3
// m13 2 b_2 + m23 b_1 + m12 6 b_3  + m22 2 b_2  + m32 b_1
// + m11 12 b_4 + m21 3 b_3 + m31 b_2 + m10 20 b_5 + m20 4 b_4  + m30 b_3 = 0
// b_5 = f(4, 3, 2, 1)

// i = 4
// m14 2 b_2 + m13 6 b_3 + m23 2 b_2 + m12 12 b_4 + m22 3 b_3 + m32 b_2
// + m11 20 b_5 + m21 4 b_4 + m31 b_3 + m10 30 b_6 + m20 5 b_5 + m30 b_4 = 0
// b_6 = f(5, 4, 3, 2)

// i >= 5
// b_{i + 2} = f(i + 1, i, i - 1, i - 2, i - 3)

// x = -2
// s = 24
  memoX.Lines.Add(k.Eval('-2', '24'));
  memoX.Lines.Add(dd.Eval('-2', '24'));
  memoX.Lines.Add(bl.Eval('-2', '24'));
  memoX.Lines.Add(L.Eval('-2', '24'));


  p1.free; p2.free; p3.free; p4.free; px.free;
  jj.free; bl.free; dl.free; gl.free; bb.free; E.free; dd.free; k.free; L.free;
end;

procedure TFormPrincipal.btn4Click(Sender: TObject);
var a, b, c, d, e, M: string;
begin
  if fileExists('4.txt') then
  begin
    processar(4);
    exit;
  end;
  a := '1';
  b := '17';
  c := '101';
  d := '247';
  e := '210';
  M := FracAbs(a);
  if FracCompare(FracAbs(b), M) > 0 then
    M := FracAbs(b);
  if FracCompare(FracAbs(c), M) > 0 then
    M := FracAbs(c);
  if FracCompare(FracAbs(d), M) > 0 then
    M := FracAbs(d);
  M := '1'; // FracAdd(M, '1');

//divida pelo máximo mais um
  a := FracDiv(a, M);
  b := FracDiv(b, M);
  c := FracDiv(c, M);
  d := FracDiv(d, M);
  e := FracDiv(e, M);

//derive 3 vezes: ax^4 + bx^3 + cx^2 + dx + s = 0
//               (4ax^3 + 3bx^2 + 2cx + d) x' + 1 = 0
//                x' = -1/(4ax^3 + 3bx^2 + 2cx + d)

//               (12ax^2 + 6bx + 2c) (x')^2 + (4ax^3 + 3bx^2 + 2cx + d) x'' = 0
//                x'' = - (x')^2 (12ax^2 + 6bx + 2c)/(4ax^3 + 3bx^2 + 2cx + d)
//                x'' = - (12ax^2 + 6bx + 2c)/(4ax^3 + 3bx^2 + 2cx + d)^3

// (4ax^3 + 3bx^2 + 2cx + d)^3 x'' + 12ax^2 + 6bx + 2c = 0
// 3 (4ax^3 + 3bx^2 + 2cx + d)^2 (12ax^2 + 6bx + 2c) x' x'' + (4ax^3 + 3bx^2 + 2cx + d)^3 x''' + (24ax + 6b) x' = 0
// 3 (12ax^2 + 6bx + 2c)^2/(4ax^3 + 3bx^2 + 2cx + d)^2 + (4ax^3 + 3bx^2 + 2cx + d)^3 x''' - (24ax + 6b)/(4ax^3 + 3bx^2 + 2cx + d) = 0
// (4ax^3 + 3bx^2 + 2cx + d)^5 x''' + 3 (12ax^2 + 6bx + 2c)^2 - (24ax + 6b)(4ax^3 + 3bx^2 + 2cx + d) = 0
// x''' = [(24ax + 6b)(4ax^3 + 3bx^2 + 2cx + d) - 3 (12ax^2 + 6bx + 2c)^2]/(4ax^3 + 3bx^2 + 2cx + d)^5

// m_1 x''' + m_2 x'' + m_3 x' + m_4 x + m_5 = 0

// plug in x' and let x as it is

// reduction: ax^4 = - bx^3 - cx^2 - dx - s

// x^0: m_1 A     + m_2 B    + m_3 C    + m_4 D    + m_5 E    = 0
// x^1: m_1 A'    + m_2 B'   + m_3 C'   + m_4 D'   + m_5 E'   = 0
// x^2: m_1 A''   + m_2 A''  + m_3 C''  + m_4 D''  + m_5 E''  = 0
// x^3: m_1 A'''  + m_2 A''' + m_3 C''' + m_4 D''' + m_5 E''' = 0

// M := [k, dd, b', L, u]

// x(s) = b_0 + b_1 s + ...

//   m_1 \sum_0 (i + 3)(i + 2) (i + 1) b_{i + 3} s^i
// + m_2 \sum_0 (i + 2)(i + 1) b_{i + 2} s^i + m_3 \sum_0 (i + 1) b_{i + 1} s^i
// + m_4 \sum_0 b_i s^i + m_5 = 0

// determine BETA
end;

procedure TFormPrincipal.btnMoreThan4Click(Sender: TObject);
var
  p, plinha, plinha2: TPoly;
  q, qq: array of TPoly;
  temp: array[1..3] of TPoly;
  i, j, max: integer;
  n, s: string;
  hw, hb: THandle;
begin
  if fileExists('4.txt') then
  begin
    //processarN(4);
    //exit;
  end;
  n := edn.Text;
  while fileexists(n + '.txt') do
    n := Soma(n, '1');

  edN.Text := n;

//derive n - 1 vezes: a_n x^n + ... + a_1 x + s = p + s = 0
//                    p' x' + 1 = 0
//                    x' = -1/p'

// p'' (x')^2 + p' x''  = 0
// p'' + (p')^3 x'' = 0
// x'' = - p'' /(p')^3
// q_2 = - p''

// i >= 2
// x^(i) = q_i / (p')^{2i - 1}
// (p')^{2i - 1} x^(i) - q_i = 0
// (2i - 1) (p')^{2i - 2} x' x^(i) + (p')^{2i - 1} x^(i + 1) - q_i' = 0
// - (2i - 1) q_i / (p')^2 + (p')^{2i - 1} x^(i + 1) - q_i' = 0
// - (2i - 1) q_i + (p')^{2i + 1} x^(i + 1) - q_i' (p')^2 = 0
// x^(i + 1) = [q_i' (p')^2 + (2i - 1) q_i] / (p')^{2i + 1}

// q_{i + 1} = q_i' (p')^2 + (2i - 1) q_i

  SetLength(q, strtoint(n) + 1);
  SetLength(qq, strtoint(n) + 1);

  p := TPoly.Create(strtoint(n) + 2); // x_1 = x, x_2 = s, x_3 = a_1, ..., x_{n + 2} = a_n
  for i := 1 to strtoint(n) do
    p.AddToDisk('p', '1.' + inttostr(i) + nTimesStr(inttostr(i), '.0') + '.1');
  p.mywho := 'p';

  plinha := p.DerivateToDisk('pL');
  temp[1] := plinha.derivateToDisk('T1');
  q[2] := temp[1].timesConstantToDisk('q2', '-1');
  temp[1].free(false);

  plinha2 := plinha.MultiplyToDisk('pL2', plinha, memoX);

// p(x) + s = 0 ==> a_n x^n = - s - Q
  temp[1] := p.TimesConstantToDisk('PP', '-1');
  temp[1].AddToDisk('PP', '-1.0.1'); // -s
  temp[1].AddToDisk('PP', '1.' + n + nTimesStr(n, '.0') + '.1'); // x^n a_n
  p.free(false);
  p := temp[1];

  plinha2.DiskReduce('pL2', n, p, memoX);

  for i := 2 to strtoint(n) - 2 do
  begin
    s := Subtrai(Multiplica('2', inttostr(i)), '1');
    memoY.Lines.Add('temp1 := derivar q[' + inttostr(i) + ']');
    temp[1] := q[i].DerivateToDisk('T2');

    memoY.Lines.Add('temp3 := vezes constante ' + s);
    temp[3] := q[i].TimesConstantToDisk('T3', s);

    memoY.Lines.Add('disk ' + inttostr(i + 1) + ' := multiplicar por p''^2');
    temp[2] := plinha2.MultiplyToDisk('q' + inttostr(i + 1), temp[1], memoX);

    memoY.Lines.Add('q[' + inttostr(i + 1) + '] := sum [to disk] temp 3');
    q[i + 1] := temp[2].SumToDisk('q' + inttostr(i + 1), temp[3]);
    temp[3].free(false);
    temp[2].free(false);
    temp[1].free(false);

    dm.qryResetMaster.paramByName('L').asString := 'm%n' + n;
    dm.qryResetMaster.ExecSQL;

    q[i + 1].DiskReduce('q' + inttostr(i + 1), n, p, memoX);
  end;

// \sum m_i x^(i) + m_n = 0
// \sum_1^{n-1} m_i q_i (p')^{2n - 2 - 2i} + (m_0 x + m_n) (p')^{2n - 3} = 0

  q[0] := TPoly.Create(strtoint(n) + 2);
  q[0].AddToDisk('q0', '1.1'); // x
  q[0].mywho := 'q0';

  q[1] := TPoly.Create(strtoint(n) + 2);
  q[1].AddToDisk('q1', '-1'); // -1
  q[1].mywho := 'q1';

  if n = '2' then
  begin
    dm.qry2.sql.add('delete');
    dm.qry2.sql.add('from poly');
    dm.qry2.sql.add('where who = ''q2''');
    dm.qry2.sql.add('   or who like ''m%n' + n + '''');
    dm.qry2.ExecSQL;
  end
  else if n = '3' then
  begin
    dm.qryResetMaster.paramByName('L').asString := 'm%n' + n;
    dm.qryResetMaster.ExecSQL;
  end;

  q[strtoint(n)] := TPoly.Create(strtoint(n) + 2);
  q[strtoint(n)].AddToDisk('q' + n, '1'); // 1
  q[strtoint(n)].mywho := 'q' + n;

  qq[strtoint(n) - 1] := q[strtoint(n)].TimesConstantToDisk('qq' + Subtrai(n, '1'),
    '1');

  for i := strtoint(n) - 2 downto 1 do
  begin
    memoY.Lines.Add('qq[' + inttostr(i) + '] := multiplicar por p''^2');
    qq[i] := qq[i + 1].MultiplyToDisk('qq' + inttostr(i), plinha2, memoX);
    qq[i].DiskReduce('qq' + inttostr(i), n, p, memoX);
  end;

  memoY.Lines.Add('qq[0] := multiplicar por p''');
  qq[0] := qq[1].MultiplyToDisk('qq0', plinha, memoX);
  qq[0].DiskReduce('qq0', n, p, memoX);
  qq[strtoint(n)] := qq[0];

  max := 0;
  for i := 0 to strtoint(n) do
  begin
    memoY.Lines.Add('temp1 := multiplicar por qq[' + inttostr(i) + ']');
    temp[1] := q[i].MultiplyToDisk('m' + inttostr(i) + 'n' + n, qq[i], memoX);
    q[i].free(false);
    q[i] := temp[1];
    q[i].DiskReduce('m' + inttostr(i) + 'n' + n, n, p, memoX);
    j := q[i].max;
    if j > max then
      max := j;
  end;

  if not fileExists('cancelar.txt') then
  begin
    if dm.qryMinPower.tag <> strtoint(n) + 2 then
    begin
      dm.qryMinPower.sql.Clear;
      dm.qryMinPower.sql.Add('select -min(p' + soma(n, '2') + ') m');
      dm.qryMinPower.sql.Add('from poly');
      dm.qryMinPower.sql.Add('where who like :L');
      dm.qryminPower.tag := strtoint(n) + 2;
    end;
    dm.qryMinPower.paramByName('L').asString := 'm%n' + n;
    dm.qryMinPower.Open;
    if dm.qryMinPower.FieldByName('m').AsInteger > 0 then
    begin
      if dm.qryPowerUp.tag <> strtoint(n) + 2 then
      begin
        dm.qryPowerUp.sql.clear;
        dm.qryPowerUp.sql.add('update poly');
        dm.qryPowerUp.sql.add('set p' + Soma(n, '2') + ' = p' + Soma(n, '2') + ' + :P');
        dm.qryPowerUp.sql.add('where who like :L');
        dm.qryPowerUp.tag := strtoint(n) + 2;
      end;

      dm.qryPowerUp.ParamByName('p').AsString := dm.qryMinPower.fieldByName('m').AsString;
      dm.qryPowerUp.ParamByName('L').AsString := 'm%n' + n;
      dm.qryPowerUp.ExecSQL;
    end;

    dm.qryMinPower.Close;

    memoX.clear;
    memoY.clear;

    for j := 0 to max do
      for i := 0 to strtoint(n) do
      begin
        memoX.lines.add('i = ' + inttostr(i) + #13#10'j = ' + inttostr(j) + #13#10#13#10 + q[i].coefxInDisk(inttostr(j), false) + #13#10);
        memoY.lines.add('i = ' + inttostr(i) + #13#10'j = ' + inttostr(j) + #13#10#13#10 + q[i].coefxInDisk(inttostr(j), true) + #13#10);
      end;

    memoX.Lines.SaveToFile(n + '.txt');
    memoY.Lines.SaveToFile(n + ' readme.txt');

    if n = '3' then
      processar3(3);

    if fileExists('shutdown.txt') then
      //WinExec(PChar('cmd.exe /c shutdown -t 5 -s'), WM_SHOWWINDOW)
    else
      //WinExec(PChar(Application.ExeName + ' ' + Soma(n, '1')), WM_SHOWWINDOW);
      sleep(100);

    hw := FindWindowByTitle('Devart PgDAC');
    if hw <> 0 then
    begin
      hb := FindWindowEx(hw, 0, 'Button', nil);
      PostMessage(hb, WM_KEYDOWN, VK_SPACE, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(100);
      PostMessage(hb, WM_KEYUP, VK_SPACE, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(100);
      PostMessage(hb, WM_KEYDOWN, VK_SPACE, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(100);
      PostMessage(hb, WM_KEYUP, VK_SPACE, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(100);
    end;
  end;
  dm.conn.Disconnect;
  close;

// Am = 0 : sistema linear de linhas: max <= n - 1 downto 0 e incógnitas m_0 ... m_n

// q0.c0 q1.c0 q2.c0 q3.c0
// q0.c1 q1.c1 q2.c1 q3.c1
// q0.c2 q1.c2   0   q3.c2

// pivotear o mais simples: 3.2

// P P P 0 (4) = (1) * q3.c2 - (6) * q3.c0
// Q Q Q 0 (5) = (2) * q3.c2 - (6) * q3.c1
// F F 0 1 (6) = (3) div q3.c2

// dos Q's quem é o mais curto?

  for i := 0 to strtoint(n) - 1 do
  begin
    q[i].free(false);
    qq[i].free(false);
  end;
  q[strtoint(n)].free(false);

  p.free(false);
  plinha.free(false);
  plinha2.free(false);
end;

procedure TFormPrincipal.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := false;
  edn.Enabled := false;
  btn2.Hide;
  btn3.Hide;
  btn4.Hide;
  btnMoreThan4.hide;

  dm.conn.Server := 'localhost';
  dm.conn.username := 'postgres';
  dm.conn.password := 'g0dg0d';
  dm.conn.Connect;

  dm.qryDelAllMaster.ExecSQL;

  if paramcount = 1 then
    edN.Text := paramstr(1);

  processarN(4);
  //deleteFile('3.txt');
  //btnMoreThan4.Click;
end;

procedure TFormPrincipal.processar3(n: integer);
var
  i, j: integer;
  a: array[0..3, 0..2] of TPoly;
  p, b0, b3, m0, m3, u1, u2, u3, u4, u5, u6: TPoly;
  m: array[0..3] of TPoly;
begin
{
  for i := 0 to 3 do
  begin
    m[i] := TPoly.Create(5);
    m[i].mywho := 'm' + inttostr(i) + 'n3sol';
  end;

  memoY.clear;

  for i := 0 to 3 do
  begin
    m[i].DiskSimplify(memoX);
    memoY.lines.add('i = ' + inttostr(i) + #13#10#13#10 + m[i].coefxInDisk('0', true) + #13#10);
  end;

  //memoX.Lines.SaveToFile(inttostr(n) + '.txt');
  memoY.Lines.SaveToFile(inttostr(n) + ' ODE.txt');
  exit;
}
  dm.qryResetMaster.paramByName('L').asString := 'mi%';
  dm.qryResetMaster.ExecSQL;
  dm.qryResetMaster.paramByName('L').asString := 'm%n' + inttostr(N) + 'sol';
  dm.qryResetMaster.ExecSQL;

// extrair Ai0j0 ... Ai3j2

  for i := 0 to 3 do
    for j := 0 to 2 do
    begin
      dm.qryExtractMaster.parambyname('origem').AsString := 'm' + inttostr(i) + 'n3';
      dm.qryExtractMaster.paramByName('who').AsString := 'mi' + inttostr(i) + 'j' + inttostr(j);
      dm.qryExtractMaster.paramByName('p').AsInteger := j;
      dm.qryExtractMaster.ExecSQL;
      a[i, j] := TPoly.Create(5);
      a[i, j].mywho := 'mi' + inttostr(i) + 'j' + inttostr(j);
      dm.qryMaxI.ParamByName('w').AsString := 'mi' + intToStr(i) + 'j' + intToStr(j);
      dm.qryMaxI.Open;
      a[i, j].list.text := dm.qryMaxI.fieldByName('m').AsString;
      dm.qryMaxI.Close;
    end;

// a12 m1 = a02 m0 + a32 m3

// a01 m0 + a11 m1 + a21 m2 + a31 m3 = 0
// a01 a12 m0 + a02 a11 m0 + a32 a11 m3 + a12 a21 m2 + a12 a31 m3 = 0
// b0 m0 + b3 m3 = a12 a21 m2
// b0 = - a01 a12 - a02 a11
// b3 = - a32 a11 - a12 a31

  U1 := TPoly.Create(5);
  U1 := a[0, 1].MultiplyToDisk('U1', a[1, 2], memoX);
  U2 := TPoly.Create(5);
  U2 := a[0, 2].MultiplyToDisk('U2', a[1, 1], memoX);
  U3 := TPoly.Create(5);
  U3 := U1.sumToDisk('U1', U2);
  b0 := TPoly.Create(5);
  b0 := U3.TimesConstantToDisk('b0', '-1');
  U1.free(false);
  U2.free(false);
  U3.free(false);

  U1 := TPoly.Create(5);
  U1 := a[3, 2].MultiplyToDisk('U3', a[1, 1], memoX);
  U2 := TPoly.Create(5);
  U2 := a[1, 2].MultiplyToDisk('U4', a[3, 1], memoX);
  U3 := TPoly.Create(5);
  U3 := U1.sumToDisk('U3', U2);
  b3 := TPoly.Create(5);
  b3 := U3.TimesConstantToDisk('b3', '-1');
  U1.free(false);
  U2.free(false);
  U3.free(false);

// a00 m0 + a10 m1 + a20 m2 + a30 m3 = 0
// a00 a12 a21 m0 + a10 a21 (a02 m0 + a32 m3) + a20 (b0 m0 + b3 m3) + a12 a21 a30 m3 = 0
// c0 m0 + c3 m3 = 0
// m3 = - c0 = - a00 a12 a21 - a02 a10 a21 - a20 b0
// m0 = c3   = a32 a10 a21 + a12 a21 a30 + a20 b3

  p := TPoly.Create(5);
  p := a[2, 1].MultiplyToDisk('UP', a[1, 2], memoX);
  U1 := TPoly.Create(5);
  U1 := p.MultiplyToDisk('U5', a[0, 0], memoX);

  U2 := TPoly.Create(5);
  U2 := a[0, 2].MultiplyToDisk('U6', a[1, 0], memoX);
  U3 := TPoly.Create(5);
  U3 := U2.MultiplyToDisk('U7', a[2, 1], memoX);

  U4 := TPoly.Create(5);
  U4 := a[2, 0].MultiplyToDisk('U8', b0, memoX);

  U5 := TPoly.Create(5);
  U5 := U1.sumToDisk('U5', U3);
  U6 := TPoly.Create(5);
  U6 := U5.sumToDisk('U5', U4);
  m3 := TPoly.Create(5);
  m3 := U6.TimesConstantToDisk('uu3', '-1');
  U1.free(false);
  U2.free(false);
  U3.free(false);
  U4.free(false);
  U5.free(false);
  U6.free(false);

  U1 := TPoly.Create(5);
  U1 := a[3, 2].MultiplyToDisk('U9', a[1, 0], memoX);
  U2 := TPoly.Create(5);
  U2 := U1.MultiplyToDisk('uu0', a[2, 1], memoX);

  U3 := TPoly.Create(5);
  U3 := p.MultiplyToDisk('U10', a[3, 0], memoX);

  U4 := TPoly.Create(5);
  U4 := a[2, 0].MultiplyToDisk('U11', b3, memoX);

  U5 := TPoly.Create(5);
  U5 := U2.sumToDisk('uu0', U3);
  m0 := TPoly.Create(5);
  m0 := U5.sumToDisk('uu0', U4);

  U1.free(false);
  U2.free(false);
  U3.free(false);
  U4.free(false);
  U5.free(false);

// m2 := b0 m0 + b3 m3
// m1 := a21 (a02 m0 + a32 m3)
// m0 := a12 a21 m0
// m3 := a12 a21 m3

  U1 := TPoly.Create(5);
  U1 := b0.MultiplyToDisk('m2n3sol', m0, memoX);
  U2 := TPoly.Create(5);
  U2 := b3.MultiplyToDisk('U12', m3, memoX);
  for i := 0 to 3 do
    m[i] := TPoly.Create(5);
  m[2] := U1.sumToDisk('m2n3sol', U2);
  U1.free(false);
  U2.free(false);

  U1 := TPoly.Create(5);
  U1 := a[2, 1].MultiplyToDisk('U13', a[0, 2], memoX);
  U2 := TPoly.Create(5);
  U2 := U1.MultiplyToDisk('m1n3sol', m0, memoX);

  U3 := TPoly.Create(5);
  U3 := a[2, 1].MultiplyToDisk('U14', a[3, 2], memoX);
  U4 := TPoly.Create(5);
  U4 := U3.MultiplyToDisk('U15', m3, memoX);
  m[1] := U2.sumToDisk('m1n3sol', U4);
  U1.free(false);
  U2.free(false);
  U3.free(false);
  U4.free(false);

  m[0] := p.MultiplyToDisk('m0n3sol', m0, memoX);
  m[3] := p.MultiplyToDisk('m3n3sol', m3, memoX);

  memoY.clear;

  for i := 0 to 3 do
  begin
    m[i].DiskSimplify(memoX);
    memoY.lines.add('i = ' + inttostr(i) + #13#10#13#10 + m[i].coefxInDisk('0', true) + #13#10);
  end;

  //memoX.Lines.SaveToFile(inttostr(n) + '.txt');
  memoY.Lines.SaveToFile(inttostr(n) + ' ODE.txt');

  for i := 0 to 3 do
    for j := 0 to 2 do
      a[i, j].free(false);

  for i := 0 to 3 do
    m[i].free(false);
  p.free(false); b0.free(false); b3.free(false);
  m0.free(false); m3.free(false);
end;

procedure TFormPrincipal.processarN(n: integer);
var
  i, j, k, max, minimo, count: integer;
  a: array of array of TPoly;
  m: array of TPoly;
  simples: array of integer;
  p1, p2, p3, p4, mj, mk: TPoly;
  u, s: string;
begin
  if n < 4 then
    exit;

  if n > 4 then
    exit;

  u := '1'; // polinomio temporário 'U1'

  dm.qryResetMaster.paramByName('L').asString := 'mi%';
  dm.qryResetMaster.ExecSQL;
  dm.qryResetMaster.paramByName('L').asString := 'm%n' + inttostr(N) + 'sol';
  dm.qryResetMaster.ExecSQL;

  SetLength(a, N + 1, N);
  SetLength(m, N + 1);
  SetLength(simples, N + 1);

// extrair Ai0j0 ... Ai3j2
  for i := 0 to N do
    for j := 0 to N - 1 do
    begin
      dm.qryExtractMaster.parambyname('origem').AsString := 'm' + inttostr(i) + 'n' + inttostr(N);
      dm.qryExtractMaster.paramByName('who').AsString := 'mi' + inttostr(i) + 'j' + inttostr(j);
      dm.qryExtractMaster.paramByName('p').AsInteger := j;
      dm.qryExtractMaster.ExecSQL;
      a[i, j] := TPoly.Create(N + 2);
      a[i, j].mywho := 'mi' + inttostr(i) + 'j' + inttostr(j);
      dm.qryMaxI.ParamByName('w').AsString := 'mi' + intToStr(i) + 'j' + intToStr(j);
      dm.qryMaxI.Open;
      a[i, j].list.text := dm.qryMaxI.fieldByName('m').AsString;
      dm.qryMaxI.Close;
    end;

// a12 m1 = a02 m0 + a32 m3

  max := N - 1;
  repeat
    minimo := 1 shl 30; // 2 ^ 30
    for i := 0 to N do
    begin
      dm.qryCounter.ParamByName('who').AsString := a[i, max].mywho;
      dm.qryCounter.Open;
      count := dm.qryCounter.fieldByName('c').AsInteger;
      dm.qryCounter.Close;
      memoy.Lines.Add('count = ' + inttostr(count));
      application.ProcessMessages;
      if (count > 0) and (count < minimo) then
      begin
        minimo := count;
        simples[N - max] := i;
        memoy.Lines.Add('minimo = ' + inttostr(minimo) + ' from ' + a[i,max].mywho);
        application.ProcessMessages;
      end;
    end;

    memoy.Lines.Add('simples ' + inttostr(N - max) + ' = ' + inttostr(simples[N - max]));
    application.ProcessMessages;

    for j := 0 to N - 1 do
    begin
      i := simples[N - max];
      if j <> max then
      begin
        for k := 0 to N do
          if k <> i then
          begin
            memoy.Lines.Add('max = ' + inttostr(max) + ', j = ' + inttostr(j) + ', k = ' + inttostr(k));
            application.processMessages;
            p1 := a[k, j].MultiplyToDisk('U' + u, a[i, max], memoX);
            u := Soma(u, '1');
            p1.DiskSimplify(memoX);
            p2 := a[i, j].MultiplyToDisk('U' + u, a[max, j], memoX);
            u := Soma(u, '1');
            p2.DiskSimplify(memoX);
            p3 := p2.TimesConstantToDisk('U' + u, '-1');
            u := Soma(u, '1');
            p4 := p1.SumToDisk(p1.mywho, p3);
            a[k, j].free(false);
            a[k, j] := p4;
            a[k, j].DiskSimplify(memoX);
            p1.free(false);
            p2.free(false);
            p3.free(false);
          end;

        dm.qryResetMaster.paramByName('L').asString := 'mi' + inttostr(i) + 'j' + inttostr(j);
        dm.qryResetMaster.ExecSQL;
        a[i, j].free(false);
        a[i, j] := TPoly.Create(N + 2);
        a[i, j].mywho := 'mi' + inttostr(i) + 'j' + inttostr(j);
        a[i, j].list.Text := '0';
      end;
    end;

    dec(max);
  until max = 0;

//agora vamos calcular os emmys
  j := -1;
  for i := 0 to N do
    if not a[i, 0].IsZero(false) then
      if j = -1 then
        j := i // sobrou 1
      else
      begin
        k := i; // sobraram 2
        break;
      end;

  memoY.Lines.add('');
  memoY.Lines.add('[begin]');
  memoY.Lines.add('');

  memoY.Lines.add('m' + inttostr(j) + ' over 1');
  application.ProcessMessages;
  s := 'm' + intToStr(j) + 'n' + intToStr(N) + 'sol';
  mj := a[k, 0].TimesConstantToDisk(s, '1');
  s := 'm' + intToStr(k) + 'n' + intToStr(N) + 'sol';
  memoY.Lines.add('m' + inttostr(k) + ' over 1');
  application.ProcessMessages;
  mk := a[j, 0].TimesConstantToDisk(s, '-1');
  u := Soma(u, '1');

  for i := 1 to N - 1 do
  begin
    p1 := a[j, N - i].MultiplyToDisk('U' + u, mj, memoX);
    u := Soma(u, '1');
    p1.DiskSimplify(memoX);
    p2 := a[k, N - i].MultiplyToDisk('U' + u, mk, memoX);
    u := Soma(u, '1');
    p2.DiskSimplify(memoX);
    p3 := p1.SumToDisk(p1.mywho, p2);
    p3.DiskSimplify(memoX);
    s := 'm' + intToStr(simples[i]) + 'n' + intToStr(N) + 'sol';
    m[simples[i]] := p3.TimesConstantToDisk(s, '-1');
    p1.free(false);
    p2.free(false);
    p3.free(false);
    memoY.Lines.add('m' + inttostr(simples[i]) + ' over ' + a[simples[N - i], i].mywho);
    application.ProcessMessages;
{
    for L := 1 to N - 1 do
      if (L <> i) and (simples[i] <> j) and (simples[i] <> k) then
      begin
        if (L = N - 1) and (i = N - 2) then
          s := 'm' + intToStr(simples[i]) + 'n' + intToStr(N) + 'sol'
        else
        begin
          s := 'U' + u;
          u := Soma(u, '1');
        end;
        p1 := m[simples[i]].MultiplyToDisk(s, a[simples[N - L], L], memoX);
        p1.DiskSimplify(memoX);
        m[simples[i]].free(false);
        m[simples[i]] := p1;
      end;
}
  end;
{
  for L := 2 to N - 1 do
  begin
    p1 := a[simples[N - 1], 1].MultiplyToDisk('U' + u, a[simples[N - L], L], memoX);
    u := Soma(u, '1');
    p1.DiskSimplify(memoX);
    a[simples[N - 1], 1].free(false);
    a[simples[N - 1], 1] := p1;
  end;

  m[j] := a[simples[N - 1], 1].MultiplyToDisk('m' + intToStr(j) + 'n' + intToStr(N) + 'sol', mj, memoX);
  m[j].DiskSimplify(memoX);
  m[k] := a[simples[N - 1], 1].MultiplyToDisk('m' + intToStr(k) + 'n' + intToStr(N) + 'sol', mk, memoX);
  m[k].DiskSimplify(memoX);
}

  memoY.Lines.add('');
  memoY.Lines.add('[end]');
  memoY.Lines.add('');
  application.ProcessMessages;

  for i := 0 to N do
    memoY.lines.add('i = ' + inttostr(i) + #13#10#13#10 + m[i].coefxInDisk('0', true) + #13#10);

  memoY.Lines.SaveToFile(inttostr(n) + ' ODE.txt');

  for i := 0 to N do
    for j := 0 to N - 1 do
      a[i, j].free(false);

  for i := 0 to N do
    m[i].free(false);

  mj.free(false);
  mk.free(false);
end;

end.

