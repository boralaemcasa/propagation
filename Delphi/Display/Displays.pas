unit Displays;

interface

uses Forms, Graphics;

Procedure Display(form: TForm; corOff, corOn: TColor; numb: byte; larg,alt,col,li: integer);

implementation

type bbol = 0..1;

Procedure Display(form: TForm; corOff, corOn: TColor; numb: byte; larg,alt,col,li: integer);
const filamento: array[0..9, 'a'..'g'] of bbol =
{0}   ( (1,1,1,1,1,1,0),
{1}     (0,1,1,0,0,0,0),
{2}     (1,1,0,1,1,0,1),
{3}     (1,1,1,1,0,0,1),
{4}     (0,1,1,0,0,1,1),
{5}     (1,0,1,1,0,1,1),
{6}     (1,0,1,1,1,1,1),
{7}     (1,1,1,0,0,1,0),
{8}     (1,1,1,1,1,1,1),
{9}     (1,1,1,1,0,1,1));

function GetColor: TColor;
begin
  result := form.Canvas.Pen.Color;
end;

procedure SetColor(nova: TColor);
begin
  form.Canvas.Pen.Color := nova;
end;

procedure line(x1, y1, x2, y2: integer);
begin
  form.Canvas.MoveTo(x1, y1);
  form.Canvas.LineTo(x2, y2);
end;

var aux: byte;
begin
  aux := GetColor;
  if boolean(filamento[numb, 'a'])
    then setcolor(corOn)
    else setcolor(corOff);
  line(col+3,   li, col+2+larg-1, li);
  line(col+4, li+1, col+2+larg-2, li+1);
  line(col+5, li+2, col+2+larg-3, li+2);
  line(col+6, li+3, col+2+larg-4, li+3);
  line(col+7, li+4, col+2+larg-5, li+4);
  if boolean(filamento[numb, 'b'])
    then setcolor(corOn)
    else setcolor(corOff);
  line(  col+larg, li+5,   col+larg, li+alt-4);
  line(col+1+larg, li+4, col+1+larg, li+alt-3);
  line(col+2+larg, li+3, col+2+larg, li+alt-2);
  line(col+3+larg, li+2, col+3+larg, li+alt-3);
  line(col+4+larg, li+1, col+4+larg, li+alt-4);
  if boolean(filamento[numb, 'c'])
    then setcolor(corOn)
    else setcolor(corOff);
  line(  col+larg, li+alt+4,   col+larg, li + 2*alt-5);
  line(col+1+larg, li+alt+3, col+1+larg, li + 2*alt-4);
  line(col+2+larg, li+alt+2, col+2+larg, li + 2*alt-3);
  line(col+3+larg, li+alt+3, col+3+larg, li + 2*alt-2);
  line(col+4+larg, li+alt+4, col+4+larg, li + 2*alt-1);
  if boolean(filamento[numb, 'd'])
    then setcolor(corOn)
    else setcolor(corOff);
  line(col+7, li + 2*alt-4, col+2+larg-5, li + 2*alt-4);
  line(col+6, li + 2*alt-3, col+2+larg-4, li + 2*alt-3);
  line(col+5, li + 2*alt-2, col+2+larg-3, li + 2*alt-2);
  line(col+4, li + 2*alt-1, col+2+larg-2, li + 2*alt-1);
  line(col+3,   li + 2*alt, col+2+larg-1, li + 2*alt);
  if boolean(filamento[numb, 'e'])
    then setcolor(corOn)
    else setcolor(corOff);
  line(  col, li+alt+4,   col, li + 2*alt-1);
  line(col+1, li+alt+3, col+1, li + 2*alt-2);
  line(col+2, li+alt+2, col+2, li + 2*alt-3);
  line(col+3, li+alt+3, col+3, li + 2*alt-4);
  line(col+4, li+alt+4, col+4, li + 2*alt-5);
  if boolean(filamento[numb, 'f'])
    then setcolor(corOn)
    else setcolor(corOff);
  line(  col, li+1,   col, li+alt-4);
  line(col+1, li+2, col+1, li+alt-3);
  line(col+2, li+3, col+2, li+alt-2);
  line(col+3, li+4, col+3, li+alt-3);
  line(col+4, li+5, col+4, li+alt-4);
  if boolean(filamento[numb, 'g'])
    then setcolor(corOn)
    else setcolor(corOff);
  line(col+7, li+alt-2, col+larg-3, li+alt-2);
  line(col+6, li+alt-1, col+larg-2, li+alt-1);
  line(col+5,   li+alt, col+larg-1, li+alt);
  line(col+6, li+alt+1, col+larg-2, li+alt+1);
  line(col+7, li+alt+2, col+larg-3, li+alt+2);

  setcolor(aux)
end;

end.
