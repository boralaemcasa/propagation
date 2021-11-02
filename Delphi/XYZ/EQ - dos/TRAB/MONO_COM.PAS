const prF: real = 0.0015;
      VMax = 110;

procedure Build; far;
begin
  leva(x, abs(VMax * sin(x)))
end;

procedure tela;
begin
  CorEq := 15;
  SetCores(1, 7);
  SetTextStyle(2, 0,6);

  valores('XY CC a1 0101', -2*pi,2*pi, -200,200);
  funcao(Build, X1, X2, prF, direta)
end;