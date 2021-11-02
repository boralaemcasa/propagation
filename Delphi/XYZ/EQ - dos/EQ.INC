{ Arquivo parte de EQ.PAS ÿ
  Cont‚m: ÿ               ÿ
  .Types                  ÿ
  .Constantes             ÿ
  FUNCTION CADEIA         ÿ
  FUNCTION COORD          ÿ
  FUNCTION IGUAL          ÿ
  PROCEDURE NOVAFUNCAO    ÿ
  PROCEDURE SETAREAGRAFICAÿ
  PROCEDURE SETCORES      ÿ
  PROCEDURE SOLTATECLA    ÿ
  PROCEDURE TECLADO       ÿ
  PROCEDURE TEK           }
type TRotina = Procedure;
       str13 = string[13];

const direta =  1;  valX = 0;  both = 2;
      centra =  0;  valY = 1;  wait = 3;
      invert = -1;
         msg = 'Montando gr ficos...';
       press = 'Pressione qualquer tecla para continuar';
      CorTexto: integer = 15;
      CorFundo: integer = 1;
      CorEq   : integer = 14;

      cancel: record
        hab, act: boolean  {inicia habilitado e nao cancelado}
      end = (hab: true; act: false);


Function cadeia(var valor: real;  casas: byte): string;
var s: string;
begin
  str(valor:0:casas, s);
  cadeia := s
end;

Function coord(p,q: real; c: byte): string;
begin
  coord := '(' + cadeia(p,c) + ', ' + cadeia(q,c) + ')'
end;

Function igual(v1,v2, erro: real): boolean;
begin
  igual := ( abs(v1 - v2) <= erro )
end;

Procedure teclado;  interrupt;
begin
  if cancel.hab then
    begin
      x := final;
      cancel.act := true
    end;
  Inline($9C/               { pushf }
         $FF/$1E/OldInt9)   { call far ptr [OldInt9] }
end;

Procedure tek;  assembler;
asm
  @Keyp: mov ah, 1
         mov DL, 1
         int 16h
         jnz @RKey   { if keypressed then readkey }
         xor DL, DL  { else, fim do While }
  @RKey: xor ah,ah
         int 16h
         cmp DL, 1   { dentro do WHILE ? }
         jz @Keyp    { se for, repita }
end;

Procedure SoltaTecla; {D  um tempo para o usu rio soltar a tecla}
var i: longint;
begin
  for i := 0 to 10000000 do
end;

Procedure SetCores(texto, fundo: word);
begin
  CorTexto := texto;  CorFundo := fundo;
  SetColor(CorTexto);  SetBkColor(CorFundo);
end;

Procedure NovaFuncao(limpa: WordBool);
begin
  if cancel.act
    then exit
    else cancel.hab := false;
  SetTextJustify(2,2);
  SetColor(CorFundo);  OutTextXY(dim[2].x-3,dim[1].y+3, msg);
  SetColor(CorTexto);  OutTextXY(maxx-3,0, press);
  tek;
  if not limpa then
    begin
      SetColor(CorFundo);  OutTextXY(dim[2].x,0, press);
      SetColor(CorTexto)
    end
  else ClearDevice;
  SoltaTecla;
  cancel.hab := true
end;

Procedure SetAreaGrafica(m,n,p,q: integer; mold: boolean);
begin
  if (m < 0) or (n < 0) or (p > MaxX) or (q > MaxY) then exit;
  dim[1].x := m;  dim[1].y := n;
  dim[2].x := p;  dim[2].y := q;
  if mold then
    moldura(dim[1].x,dim[1].y, dim[2].x,dim[2].y)
end;