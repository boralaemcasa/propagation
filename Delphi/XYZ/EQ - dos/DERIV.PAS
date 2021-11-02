const prF: real = 0.01;
      prD: real = 0.025;
       x0: real = 0;

function f(x: real): real;  begin  f := eleva(2, x)             end;
function d(x: real): real;  begin  d := eleva(2, x) * ln(2)     end;

{$F+}
procedure Build;
begin
  leva(x, f(x))
end;

procedure Deriv;
begin
  leva( x, d(x0) * (x - x0) + f(x0) )
end;
{$F-}

procedure tangente(ponto: real);
begin
  x0 := ponto;
  mostra(both, x0, f(x0), 1, 2);
  funcao(Deriv, X1, X2, prD, direta)
end;

procedure tela;
begin
  SetTextStyle(2, 0,6);

  valores('XY CC an VVVV', -5,5, -10,10);
    funcao(Build, X1, X2, prF, direta);
  tangente(-1);  tangente(1)
end;