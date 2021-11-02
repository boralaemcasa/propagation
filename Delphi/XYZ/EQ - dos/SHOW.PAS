const pr: real = 0.00025;
      mensagem: array [1..9] of string =
       (' 1. Refra‡ao',
        ' 2. Onda senoidal amortecida',
        ' 3. Um quadrado a partir de elipses',
        ' 4. Fun‡ao Corda',
        ' 5. Zoom',
        ' 6. Fun‡ao do Cora‡ao Ä em todo o dom¡nio R ela s¢ vai e volta deste modo',
        ' 7. Fun‡ao Tesoura',
        ' 8. A tesoura ‚ parte de uma ros cea',
        ' 9. Espiral cosseno-sˆnica ÄÄ pressione qualquer tecla para finalizar'
       );
var a,b: byte;
    l1,l2: real;

{$F+}
procedure Refracao;
begin
  if x < 0
    then leva(x, -4 * x)
    else leva(x, -8 * x)
end;

procedure Senoide;
begin
  leva( x, sin(x)/x )
end;

procedure BuildElipse;
begin
  leva( cos(x), sin(x + l1) )
end;

procedure Corda;
begin
  leva( x, - sin(x) - x);
  leva( x,   sin(x) - x);
  leva( x,   cos(x) - x);
  leva( x, - cos(x) - x)
end;

procedure Coracao;
begin
  leva( cos(x), -sin(4/3*x + pi/2) )
end;

procedure Tesoura;
var y: real;
begin
  y := sin(x);
  leva(x * y, y)
end;

procedure BuildEspiral;
begin
  leva( a*cos(x), b*sin(x) )
end;
{$F-}

procedure espiral;

procedure func;
begin
  funcao(BuildEspiral, l1,l2, pr, direta);
  l1 := l1 + 0.5*pi;  l2 := l2 + 0.5*pi;
  if pr > 0.0005 then
    pr := pr - 0.000025
end;

begin
  a := 1;  b := 1;
  l1 := 0;  l2 := 0.5*pi;
  pr := 0.0025;
  repeat
                 func;
     inc(a);     func;
     inc(b, 2);  func;
     inc(a);     func;
     inc(b)
  until cancel.act
end;

procedure elipses;
begin
  l1 := 0.5*pi;
  pr := 0.001;
  while l1 <= 1.5*pi do
    begin
       funcao(BuildElipse, -pi, pi, pr, direta);
       l1 := l1 + 0.1
    end
end;

procedure tela;
begin
  SetTextStyle(2, 0,6);

(* Tela 1 *)
  valores('XY cc a1 0000', -1,1, -8,4);
  setTextJustify(0,0);  outTextXY(0, MaxY-3, mensagem[1]);
  funcao(Refracao, x1, x2, pr, direta);

(* Tela 2 *)
  cancel.act := false;  NovaFuncao(true);
  valores('XY cc a0 0000', 0,20*pi, -1,1);
  setTextJustify(0,0);  outTextXY(0, MaxY-3, mensagem[2]);
  pr := 0.0025;  funcao(Senoide, 0.001, x2, pr, direta);

(* Tela 3 *)
  cancel.act := false;  NovaFuncao(false);
  valores('00 cc a0 0000', -1.5, 1.5, -1, 1);
  ClearDevice;
  setTextJustify(0,0);  outTextXY(0, MaxY-3, mensagem[3]);
  Elipses;

(* Tela 4 *)
  cancel.act := false;  NovaFuncao(true);
  valores('XY cc a0 0000', -5*pi,5*pi, -5*pi,5*pi);
  setTextJustify(0,0);  outTextXY(0, MaxY - 3, mensagem[4]);
  pr := 0.005;  funcao(Corda, x1, x2, pr, direta);

(* Tela 5 *)
  cancel.act := false;  NovaFuncao(true);
  SetAreaGrafica(0,0, Maxx div 2, MaxY div 3, true);
  valores('00 00 00 0000', -2*pi,2*pi, -2*pi,2*pi);
  setTextJustify(0,0);  outTextXY(0, MaxY - 3, mensagem[5]);
  pr := 0.004;  funcao(Corda, x1, x2, pr, direta);

  SetAreaGrafica(Maxx div 4,MaxY div 3, 3 * Maxx div 4,2 * MaxY div 3, true);
  valores('00 00 00 0000', -pi,pi, -pi,pi);
  pr := 0.002;  funcao(Corda, x1, x2, pr, direta);

  SetAreaGrafica(Maxx div 2, 2 * MaxY div 3, Maxx, MaxY, true);
  valores('00 00 00 0000', -pi/2,pi/2, -pi/2,pi/2);
  pr := 0.001;  funcao(Corda, x1, x2, pr, direta);

(* Tela 6 *)
  cancel.act := false;  NovaFuncao(true);
  SetAreaGrafica(0,0,MaxX,MaxY, false);
  valores('XY cc a0 0000', -1.5,1.5, -1,1);
  setTextJustify(0,0);  outTextXY(0, MaxY - 3, mensagem[6]);
  pr := 0.00025;  funcao(Coracao, 0,3*pi, pr, direta);

(* Tela 7 *)
  cancel.act := false;  NovaFuncao(true);
  valores('00 cc an 0000', -2*pi,2*pi, -1.5,1.5);
  setTextJustify(0,0);  outTextXY(0, MaxY - 3, mensagem[7]);
  pr := 0.0005;  funcao(Tesoura, x1, x2, pr, direta);

(* Tela 8 *)
  cancel.act := false;  NovaFuncao(true);
  valores('00 cc an 0000', -8*pi,8*pi, -1.5,1.5);
  setTextJustify(0,0);  outTextXY(0, MaxY - 3, mensagem[8]);
  pr := 0.0005;  funcao(Tesoura, x1, x2, pr, direta);

(* Tela 9 *)
  cancel.act := false;  NovaFuncao(true);
  valores('0Y cc 00 0000', -25, 25, -125, 125);
  setTextJustify(0,0);  outTextXY(0, MaxY - 3, mensagem[9]);
  Espiral
end;