close all;
clear all;
clc;

##y = gauss(4.7, 5, 0.5)

alpha = 0.1;

nEpocas = 2;
stept = 0.2;

xit = -6.3;

xft = 6.3;

nPontosT = round( (xft - xit) / stept + 1.0);
nPontosV = nPontosT;

xt = zeros(nPontosT, 1);
tmp = xit;
for i = 1:nPontosT
  xt(i) = tmp;
  tmp += stept;
end;

xv = xt;

ydt = zeros(nPontosT);
tmp = xit;
for i = 1:nPontosT
  ydt(i) = abs(xt(i));
end;

ydv = ydt;
nVariaveis = 1;
nGaussianas = 5;

erro(1:8) = AverageError;

[erro(1), q1, p1, sigma1, ys1] = calcularAPE(alpha, nEpocas, nPontosT, nPontosV, xt, xv, ydt, ydv, nVariaveis, nGaussianas, xit, xft, false, false, false);
[erro(2), q2, p2, sigma2, ys2] = calcularAPE(alpha, nEpocas, nPontosT, nPontosV, xt, xv, ydt, ydv, nVariaveis, nGaussianas, xit, xft, false, false, true);
[erro(3), q3, p3, sigma3, ys3] = calcularAPE(alpha, nEpocas, nPontosT, nPontosV, xt, xv, ydt, ydv, nVariaveis, nGaussianas, xit, xft, false, true, false);
[erro(4), q4, p4, sigma4, ys4] = calcularAPE(alpha, nEpocas, nPontosT, nPontosV, xt, xv, ydt, ydv, nVariaveis, nGaussianas, xit, xft, false, true, true);
[erro(5), q5, p5, sigma5, ys5] = calcularAPE(alpha, nEpocas, nPontosT, nPontosV, xt, xv, ydt, ydv, nVariaveis, nGaussianas, xit, xft, true, false, false);
[erro(6), q6, p6, sigma6, ys6] = calcularAPE(alpha, nEpocas, nPontosT, nPontosV, xt, xv, ydt, ydv, nVariaveis, nGaussianas, xit, xft, true, false, true);
[erro(7), q7, p7, sigma7, ys7] = calcularAPE(alpha, nEpocas, nPontosT, nPontosV, xt, xv, ydt, ydv, nVariaveis, nGaussianas, xit, xft, true, true, false);
[erro(8), q8, p8, sigma8, ys8] = calcularAPE(alpha, nEpocas, nPontosT, nPontosV, xt, xv, ydt, ydv, nVariaveis, nGaussianas, xit, xft, true, true, true);

		i = 1;
		while (i < 8) && (erro(i).ape == round(erro(i).ape))
			i++;
    end;
		for j = (i + 1):8
			if erro(j).ape != round(erro(j).ape)
				if erro(j).ape < erro(i).ape
						i = j;
        end;
      end;
    end;

disp('Resposta');
i

x = (1:1:nPontosT);
y = x;
z = x;
for i = 1:nPontosT
  x(i) = xt(i);
  y(i) = ydt(i);
  z(i) = ys4(i);
end;

plot(x, y);
