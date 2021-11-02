const prF: real = 0.0075;

{$F+}
procedure Build;
var y: real;
begin
  y := sin(x);
  if y <> 0 then
    leva( x/y, cos(x) )
end;
{$F-}

procedure tela;
begin
  SetTextStyle(2, 0,6);

  valores('XY CC an VVVV', -20*pi,20*pi, -1.5,1.5);
  funcao(Build, -20*pi, 2*pi, prF, direta)
end;