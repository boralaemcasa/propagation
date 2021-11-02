const prF: real = 0.000025;
      prE: real = 0.000075;
      auto = -1;
      def = 'Poligonos Regulares';

var  a,  b,
     o,  c,
    o0, c0,
     theta: real;

{$F+}
procedure Build;
var y: real;
begin
  y := a*x + b;
  if (c < c0) and (c < x) and (x < c0) or (c > c0) and (c0 < x) and (x < c) then
    leva( x, y )
end;

procedure eixos;
var k: real;
begin
  k := tg(theta);
  leva( x, k *x );
  leva( x, -x/k )
end;

{$F-}

procedure poligono(lados: byte;  AngRadIni: real;  DrawEixos: boolean);
begin
  if AngRadIni = Auto
    then Theta := pi / (2*lados)
    else Theta := AngRadIni;
  if DrawEixos and (AngRadIni <> 0) and (AngRadIni <> pi/2) then
    funcao(eixos, X1, X2, prE, direta);
  while theta < 2*pi do
    begin
      c0 := cos(theta);
      o0 := sin(theta);
       c := cos(theta + 2*pi/lados);
       o := sin(theta + 2*pi/lados);
      a := (o - o0)/(c - c0);
      b := o0 - c0*a;
      funcao(Build, -1, 1, prF, direta);
      theta := theta + 2*pi/lados
    end
end;

procedure tela;
begin
  SetTextStyle(1, 0,1);  SetUserCharSize(1,2,1,2);
  valores('00 cc 01 VVVV', -1.5, 1.5, -1, 1);
  poligono(3, pi/12, false);
  poligono(6, pi/12, false)
end;