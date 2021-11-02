const prF: real = 0.0002;

{$F+}
procedure Build;
var y: real;
begin
  y := tg(x);
  leva(x - y, x + y)
end;
{$F-}

procedure tela;
begin
  SetTextStyle(2, 0,6);

  valores('XY CC an VVVV', -5*pi,5*pi, -5*pi,5*pi);
  funcao(Build, X1, X2, prF, direta);

end;