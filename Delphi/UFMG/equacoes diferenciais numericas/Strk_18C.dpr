program Strk_18C;

{$APPTYPE CONSOLE}

uses
  SysUtils;

// dados iniciais:
// u(t_ini, x) = 1 - |x|, se -1 <= x <= 1
//             = 0, caso contrário
// dados de fronteira:
// u(t, x_ini) = 0
function u(t, x: double): double;
begin
  Result := 0;
  if abs(t - 0) < 1e-14 then
    if abs(x) <= 1 then
      Result := 1 - abs(x);
end;

const
  x_ini = -2; t_ini = 0;
  x_fim = 3;  t_fim = 2.4;
  a = 1;

//equação 1.1.2
function sol(t, x: double): double;
begin
  Result := u(0, x - a * t);
end;

var // mais global que o Jô Soares
  v: array[0..1, 0..1000] of double; // usage: v[0, m] embaixo, v[1, m] em cima
  g: TextFile;
  h: double;
  inutil: boolean;

// cada esquema é útil ou inútil?
// é inútil se abs( v_m^n ) > 5 , para quaisquer m, n.
procedure ArmazenarV(t, x: integer; valor: double);
begin
  v[t,x] := valor;
  if abs(valor) > 5 then
  begin
    write(g, '*** INÚTIL ; h = ', h, ' ; ');
    inutil := true;
  end;
end;

procedure Strik(prefixo: string; lambda: double);
var
  f: TextFile;
  x_m, t_n, k, error, errorAnt: double; // k double?
  m: integer;
begin
// u(t, x) tal que u_t + a u_x = 0 ; 1.1.1 a = 1
// v_m_n = v(t_n, x_m)

  assignfile(g, prefixo + 'A.txt');
  rewrite(g);
  assignfile(f, prefixo + 'B.txt');
  rewrite(f);
  writeln(f, 'h ; v(0, 0.6) ; error ; error ratio');
  h := 1/5;
  errorAnt := 1;

  repeat // loop sobre h
    h := h/2; // h = 1/10 ; h = 1/20 ; h = 1/40
    writeln(g, 'h = ', h);
    k := lambda * h; //lambda := k/h

    t_n := t_ini;
    m := 0;
    writeln(g, 't_n ; x_m ; v(t_n, x_m) ; error');
    inutil := false;
    repeat // loop sobre x
      x_m := x_ini + h * m;
      ArmazenarV(0, m, u(t_ini, x_m));
      error := abs(sol(t_ini, x_m) - v[0, m]);
      inc(m);
      writeln(g, t_n, ' ; ', x_m, ' ; ', v[0, m], ' ; ', error);
    until x_m >= x_fim;

 // para BCD, x_M = 3, v_M_{n + 1} = v_{M - 1}_{n + 1}
    ArmazenarV(0, m, v[0, m - 1]); // a fórmula abaixo utiliza v[0, M + 1]

    repeat // loop sobre t
      t_n := t_n + k; // t_n = nk ???
      m := 0;
	    ArmazenarV(1, m, u(t_n, x_ini));
      repeat // loop sobre x
        inc(m);
        x_m := x_ini + h * m;

     // Lax Friedrichs (c1) 1.3.5 com lambda = 0.8 // (v_m_{n + 1} - 1/2 (v_{m + 1}_n + v_{m - 1}_n))/k + a/(2 * h) * (v_{m + 1}_n - v_{m - 1}_n) = 0
     // a fórmula abaixo foi deduzida em Strik131.doc
        ArmazenarV(1, m, ((h - a * k) * v[0, m + 1] + (h + a * k) * v[0, m - 1])/(2 * h) );
        error := abs(sol(t_n, x_m) - v[1, m]);
        writeln(g, t_n, ' ; ', x_m, ' ; ', v[1, m], ' ; ', error);

        if (abs(x_m - 0) < 0.02) and (abs(t_n - 0.6) < 0.02) then
        begin
          writeln(f, h, ' ; ', v[1, m], ' ; ', error, ' ; ', error / errorAnt);
          errorAnt := error;
        end;
      until x_m >= x_fim;

      inc(m);
   // para BCD, x_M = 3, v_M_{n + 1} = v_{M - 1}_{n + 1}
      ArmazenarV(1, m, v[1, m - 1]); // a fórmula acima utiliza v[0, M + 1]

	    for m := 0 to 1000 do
	      v[0, m] := v[1, m];
    until t_n >= t_fim;

    if not inutil then
      writeln(g, '*** ÚTIL PARA O VALOR DE h = ', h);
  until abs(h - 1/80) < 1e-4;

  closefile(g);
  closeFile(f);

// plotar

// o que você notou do "blow-up time" para os inúteis quando o "mesh size" decresce?
// existe um padrão para essas soluções?
end;

begin
  Strik('STR18C1', 0.8);
  Strik('STR18C2', 1.6); // Lax Friedrichs (c2) 1.3.5 com lambda = 1.6
  write('O sistema gerou 4 arquivos.');
  readln;
end.
