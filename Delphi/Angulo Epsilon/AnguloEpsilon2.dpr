program AnguloEpsilon2;

{$APPTYPE CONSOLE}

uses
  SysUtils, SNum;

var k, n, theta, theta2, epsilon, T, q, r, minimo, dividendo: string;
    f: textfile;

const pi = '3.1415926535897932384626433832795';
      doisPi = '6.283185307179586476925286766559';
      ALGARISMOS = 30;

begin
  assignfile(f, 'saida.txt');
  if not fileexists('saida.txt') then
  begin
    rewrite(f);
    closefile(f);
  end;

  //T := '1.7320508075688772935274463415059'; // sqrt 3
  T := FloatMultiplica(pi, pi);
  T := FloatMultiplica('2', T);
  while SNumCompare(T, doispi) > 0 do
    T := FloatSubtrai(T, doispi);
  minimo := doispi;
  minimo := '0.000000000011016815';

  repeat
    N := '100000000000000000000';
    //writeln('N: ', N);
    epsilon := DivideDizima(pi, N, ALGARISMOS);
    k := '0';
    theta := '0';
    theta2 := '0';

    write('k/10^6 : ');
    readln(k);
	write('Dividendo : ');
	readln(dividendo);
    k := k + '000000';
    theta := FloatMultiplica(k, T);
    theta := FloatSubtrai(theta, FloatMultiplica(FloatTrunc(DivideDizima(theta, doispi, 0)), doispi));

    theta2 := Oposto(theta);
    theta2 := FloatSubtrai(theta2, FloatMultiplica(FloatTrunc(DivideDizima(theta2, doispi, 0)), doispi));
    theta2 := FloatSoma(theta2, doispi);

    repeat
      k := Soma(k, '1');
      Divide(k, dividendo, q, r);
      if r = '0' then
      begin
        write(k, #13);
      end;
      divide(k, '1000000', q, r);
      if r = '0' then
      begin
        append(f);
        writeln(f, k, ' processado');
        closefile(f);
      end;
      theta := FloatSoma(theta, T);
      while SNumCompare(theta, doispi) > 0 do
        theta := FloatSubtrai(theta, doispi);
      if theta < minimo then
      begin
        minimo := theta;
        writeln('uhu ', k, ' min = ', minimo);

        append(f);
        writeln(f, 'uhu ', k, ' min = ', minimo);
        closefile(f);
        if theta < epsilon then
        begin
          readln;
          break;
        end;
      end;

      theta2 := FloatSubtrai(theta2, T);
      while SNumCompare(theta2, '0') < 0 do
        theta2 := FloatSoma(theta2, doispi);
      if theta2 < minimo then
      begin
        minimo := theta2;
        writeln('uhu -', k, ' min = ', minimo);

        append(f);
        writeln(f, 'uhu -', k, ' min = ', minimo);
        closefile(f);
        if theta2 < epsilon then
        begin
          readln;
          break;
        end;
      end;

    until SNumCompare(k, '0') < 0;
    N := '1';
  until N = '1';
end.
