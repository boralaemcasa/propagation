const prF: real = 0.0001;

{$F+}
procedure Ros1;
var y: real;
begin
  y := sin(x);
  if y <> 0 then
    leva( x / y, 1 / y )
end;

procedure Ros2;
var y: real;
begin
  y := sin(x);
  leva(x * y, y)
end;
{$F-}

procedure tela;
begin
  SetTextStyle(2, 0,6);

  valores('XY CC an VVVV', -4*pi, 4*pi, -2.5, 2.5);
  funcao(Ros1, X1, X2, prF, direta);
  CorEq := 12;
  funcao(Ros2, X1, X2, prF, direta)
end;