const prF: real = 0.0005;

{$F+}
procedure Sobe;
var y: real;
begin
  y := sin(x);
  leva(x + y, x - y)
end;

procedure Desce;
var y: real;
begin
  y := sin(x);
  leva(y - x, x + y)
end;
{$F-}

procedure tela;
begin
  SetTextStyle(2, 0,6);

  valores('XY CC an VVVV', -10*pi,10*pi, -10*pi,10*pi);
  funcao( Sobe, X1, X2, prF, direta);
  funcao(Desce, X1, X2, prF, invert)
end;