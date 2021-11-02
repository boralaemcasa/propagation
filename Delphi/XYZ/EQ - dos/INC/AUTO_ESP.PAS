const prF: real = 0.0001;

{$F+}
procedure Build;
begin
  leva( x * sin(x), cos(x) )
end;
{$F-}

procedure tela;
begin
  SetTextStyle(2, 0,6);

  valores('XY CC an VVVV', -10*pi,10*pi, -1,1);
  funcao(Build, 0, x2, prF, direta)
end;