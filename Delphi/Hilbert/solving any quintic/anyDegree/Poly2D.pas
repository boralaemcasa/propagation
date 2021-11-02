unit Poly2D;

interface

type
  TPoly2D = class
  public
    degx, degy: word;
    a: array of array of string;
    procedure SetDegree(x, y: word);
    function Sum(p: TPoly2D): TPoly2D;
    function Multiply(p: TPoly2D): TPoly2D;
    function TimesConstant(k: string): TPoly2D;
    function Eval(x, y: string): string;
    procedure Zero;
    function CoefY(n: word): TPoly2D;
  end;

implementation

uses SNum;

procedure TPoly2D.SetDegree(x, y: word);
begin
  degx := x;
  degy := y;
  SetLength(a, degx + 1, degy + 1);
  zero;
end;

function TPoly2D.Multiply(p: TPoly2D): TPoly2D;
var i, j, i2, j2: word;
begin
  result := TPoly2D.Create;
  result.SetDegree(degx + p.degx, degy + p.degy);
  for i := 0 to degx do
    for j := 0 to degy do
      for i2 := 0 to p.degx do
        for j2 := 0 to p.degy do
          result.a[i + i2, j + j2] := FracAdd(result.a[i + i2, j + j2], FracMul(a[i, j], p.a[i2, j2]));
end;

procedure TPoly2D.zero;
var i, j: word;
begin
  for i := 0 to degx do
    for j := 0 to degy do
      a[i, j] := '0';
end;

function TPoly2D.Sum(p: TPoly2D): TPoly2D;
var
  i, j, maxx, maxy: word;
  pp, q: TPoly2D;
begin
  maxx := degx;
  if p.degx > maxx then
    maxx := p.degx;
  maxy := degy;
  if p.degy > maxy then
    maxy := p.degy;

  pp := TPoly2D.Create;
  q := TPoly2D.Create;
  pp.SetDegree(maxx, maxy);
  q.setDegree(maxx, maxy);

  for i := 0 to p.degx do
    for j := 0 to p.degy do
      pp.a[i, j] := p.a[i, j];

  for i := 0 to degx do
    for j := 0 to degy do
      q.a[i, j] := a[i, j];

  for i := 0 to maxx do
    for j := 0 to maxy do
      q.a[i, j] := FracAdd(q.a[i, j], pp.a[i, j]);

  maxx := 0;
  maxy := 0;
  for i := 0 to q.degx do
    for j := 0 to q.degy do
      if q.a[i, j] <> '0' then
      begin
        if i > maxx then
          maxx := i;
        if j > maxy then
          maxy := j;
      end;

  result := TPoly2D.Create;
  result.SetDegree(maxx, maxy);
  for i := 0 to maxx do
    for j := 0 to maxy do
      result.a[i, j] := q.a[i, j];

  pp.free;
  q.free;
end;

function TPoly2D.TimesConstant(k: string): TPoly2D;
var i, j: word;
begin
  result := TPoly2D.Create;
  result.SetDegree(degx, degy);
  for i := 0 to degx do
    for j := 0 to degy do
      result.a[i, j] := FracMul(k, a[i, j]);
end;

function TPoly2D.Eval(x, y: string): string;
var
  i, j: word;
  xx, yy: string;
begin
  result := '0';
  xx := '1';
  for i := 0 to degx do
  begin
    yy := '1';
    for j := 0 to degy do
    begin
      result := FracAdd(result, FracMul(FracMul(a[i, j], xx), yy));
      yy := FracMul(yy, y);
    end;

    xx := FracMul(xx, x);
  end;
end;

function TPoly2D.CoefY(n: word): TPoly2D;
var i: word;
begin
  if n > degy then
    i := 0
  else
    i := degx;
  while (i > 0) and (a[i, n] = '0') do
    dec(i);
  result := TPoly2D.Create;
  result.SetDegree(i, 0);
  if n <= degy then
    for i := 0 to result.degx do
      result.a[i, 0] := a[i, n];
end;

end.
