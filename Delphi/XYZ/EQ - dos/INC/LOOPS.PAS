const prF: real = 0.0001;
var frac: real;

{$F+}
procedure Build;
begin
  leva( cos(x), sin(frac * x + pi/2) )
end;
{$F-}

procedure tela;
var i: shortint;
begin
  SetTextStyle(1, 0,1);  SetUserCharSize(1,2,1,2);
  valores('00 cc a0 VVVV', -1.5,7.5, -3,3);
  for i := -1 to 7 do
    mostra(both, i,0, 0,0);
  frac := 3/2;  funcao(Build, 0,2*pi, prF, direta);

  valores('00 cc a0 VVVV', -4.5,4.5, -3,3);
  frac := 3/4;  funcao(Build, 0,4*pi, prF, direta);

  valores('00 cc a0 VVVV', -7.5,1.5, -3,3);
  frac := 6/5;  funcao(Build, 0,5*pi, prF, direta)
end;