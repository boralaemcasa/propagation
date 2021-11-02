const prF: real = 0.015;

procedure Build; far;
begin
  *leva(x,x)
end;

procedure tela;
begin
  SetCores(CorTexto, CorFundo);
  SetTextStyle(2, 0,6);

  *valores('XY CC an VVVV', -10,10, -10,10);
  funcao(Build, X1, X2, prF, direta);

  *NovaFuncao;
end;