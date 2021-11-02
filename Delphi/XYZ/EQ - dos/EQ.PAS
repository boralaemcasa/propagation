{ Resolver a cores:       ÿ
  .janela em mostra(wait) ÿ
                          }
uses graph, GMono, dos;
var OldInt9: pointer;
    dim: array[1..2] of record x,y: integer end;
    aviso: boolean;
    x1, x2, y1, y2,
    x, final,
    Qx, Qy: real;

{$I EQ.INC}

Function PosX(a: real): integer;
begin
  posX := dim[1].x + round( (a - x1) * Qx )
end;

Function PosY(b: real): integer;
begin
  posY := dim[1].y + round( (y2 - b) * Qy )
end;

Procedure leva(a,b: real);
begin
  if entre(x1, a, x2) and entre(y1, b, y2) then
    PutPixel(posX(a), posY(b), CorEq)
end;

Procedure valores(show: str13;  m,n, p,q: real);
var casas: byte;  erro: integer;
begin
  if cancel.act then exit;
  if (m >= n) or (p >= q) then
    begin
      CloseGraph;
      write('Erro nas coordenadas');
      SetIntVec($9, OldInt9);
      readln;
      halt(1)
    end;
  if show[7] = '0'            {aviso}
    then aviso := false
    else aviso := true;
  val(show[8], casas, erro);  {casas}
  if show[4] = '1' then       {C1}
    begin
      circle(   dim[1].x + 2, dim[1].y + 2, 2);
      FloodFill(dim[1].x + 2, dim[1].y + 2, CorTexto);
      SetTextJustify(0,2);
      OutTextXY(dim[1].x + 3, dim[1].y + 3, coord(m,q, casas))
    end;
  if show[5] = '1' then       {C2}
    begin
      circle(   dim[2].x - 2, dim[2].y - 2, 2);
      FloodFill(dim[2].x - 2, dim[2].y - 2, CorTexto);
      SetTextJustify(2,0);
      OutTextXY(dim[2].x - 3, dim[2].y - 3, coord(n,p, casas))
    end;
  x1 := m;  x2 := n;  Qx := (dim[2].x - dim[1].x) / (x2 - x1);
  y1 := p;  y2 := q;  Qy := (dim[2].y - dim[1].y) / (y2 - y1);

  q := dim[1].y + y2 * Qy;  {ordenada de Ox}
  p := dim[1].x - x1 * Qx;  {abscissa de Oy}
  SetTextJustify(2,2);
  if show[1] <> '0' then  {eixo X}
    line( dim[1].x, round(q),  dim[2].x, round(q) );
  if show[2] <> '0' then  {eixo Y}
    line( round(p), dim[1].y,  round(p), dim[2].y );
  if show[10] = '1' then   {V1}
    OutTextXY( dim[2].x - 3, round(q) + 3, cadeia(x2,casas) );
  if show[11] = '1' then   {V2}
    OutTextXY( round(p) - 3, dim[1].y + 3, cadeia(y2,casas) );
  if show[12] = '1' then   {V3}
    begin
      SetTextJustify(0,2);
      OutTextXY( dim[1].x + 3, round(q) + 3, cadeia(x1,casas) )
    end;
  if show[13] = '1' then   {V4}
    begin
      SetTextJustify(2,0);
      OutTextXY(round(p) - 3, dim[2].y - 3, cadeia(y1,casas) )
    end;
  if aviso then
    begin
      SetTextJustify(2,2);
      OutTextXY(dim[2].x - 3,dim[1].y + 3, msg)
    end
end;

Procedure mostra(oq: byte; a,b: real; c,pos: byte);
var i,j: integer;
begin
  i := posX(a);  j := posY(b);
  if (not entre(0, i, dim[2].x)) and (not entre(0, j, dim[2].y))
    then exit;
  circle(i,j, 3);
  if pos <> 0 then
    begin
      Case pos of
          4: SetTextJustify(0,2);
          3: SetTextJustify(2,2);
          2: SetTextJustify(2,0);
        else SetTextJustify(0,0)
      End;
      if (pos = 2) or (pos = 3)
        then dec(i,3)
        else inc(i,3);
      if (pos = 3) or (pos = 4)
        then inc(j,3)
        else dec(j,3);
      Case oq of
        valX: OutTextXY(i,j, '(x = ' + cadeia(a,c) + ')');
        valY: OutTextXY(i,j, '(y = ' + cadeia(b,c) + ')');
        wait: begin  {p.enq., Both + tek + apaga}
                cancel.hab := false;
                OutTextXY(i,j, coord(a,b,c));
                tek;
                SetColor(CorFundo);
                OutTextXY(i,j, coord(a,b,c));
                SetColor(CorTexto);
                SoltaTecla;
                cancel.hab := true
              end
        else OutTextXY(i,j, coord(a,b,c))
      End
    end
end;

Procedure funcao(rotina: TRotina; lim1,lim2: real;  var h: real; direct: shortInt);
begin
  if cancel.act then exit;
  Case direct of
    1: begin
         x := Lim1;
         final := Lim2;
         while x < Lim2 do
           begin
             rotina;
             x := x + h
           end
       end;
   -1: begin
         x := Lim2;
         final := Lim1;
         while x > Lim1 do
           begin
             rotina;
             x := x - h
           end
       end;
    0: begin
         final := 0;
         while Lim1 < Lim2 do
           begin
             x := Lim1;  rotina;
             x := Lim2;  rotina;
             Lim1 := Lim1 + h;
             Lim2 := Lim2 - h
           end
       end
  End
end;

{$I trabalho.PAS}

BEGIN
  GrInit;
  dim[2].x := MaxX;  dim[2].y := MaxY;
  GetIntVec($9, OldInt9);

  SetIntVec($9, @Teclado);
  Tela;
  SetIntVec($9, OldInt9);

  if aviso then
    begin
      SetTextJustify(2,2);
      SetColor(CorFundo);  OutTextXY(dim[2].x - 3, dim[1].y + 3, msg);
      SetColor(CorTexto);  MoveTo(   dim[2].x - 3, dim[1].y + 3)
    end;
  if cancel.act then
    begin
      if aviso then OutText('Cancelado.');
      Qx := 0;
      repeat  Qx := Qx - 0.5  until Qx < -5000;  {pequeno delay}
      CloseGraph
    end
  else
    begin
      if aviso then OutText('OK.');
      tek
    end
END.