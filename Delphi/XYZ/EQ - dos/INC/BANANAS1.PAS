const prF: real = 0.0001;

{$F+}
procedure Build;
var y: real;
begin
  y := sin(x);
  if y <> 0 then
    leva(x/y,y)
end;
{$F-}

procedure tela;
begin
  SetTextStyle(2, 0,6);

  valores('XY CC an VVVV', -10*pi,10*pi, -1,1);
  funcao(Build, x1, x2, prF, direta)
end;