close all;
clear all;
clc;

alpha = 0.1;
nEpocas = 20;
nGaussianas = 11;
nProblema = 5;
expMinusInfty = 1e-50;

%%% Parábola
if nProblema == 1
    disp('Parábola');
    nVariaveis = 1;
    xit = -2;
    xft = 2;
    delta = 4/500;
    xt=(xit:delta:xft)' ;
    ydt = xt.^2;
    xv = (xit+delta/2:delta:xft-delta/2)';
    ydv = xv.^2;
end

%%% R3 = Sistema Estático Multivariável
if nProblema == 2
    disp('R3 = Sistema Estático Multivariável');
    nVariaveis = 3;
    xt = zeros(216,3);
    n = 1;
    for i = 1:6;
        for j = 1:6;
            for k = 1:6;
               xt(n,:) = [i j k];
               n = n + 1;
            end
        end
    end
    ydt = (1 + xt(:,1).^0.5 + xt(:,2).^-1 + xt(:,3).^-1.5).^2;
    xv = zeros(125,3);
    n = 1;
    for i = 1.5:5.5;
        for j = 1.5:5.5;
            for k = 1.5:5.5;
               xv(n,:) = [i j k];
               n = n + 1;
            end
        end
    end
    ydv = (1 + xv(:,1).^0.5 + xv(:,2).^-1 + xv(:,3).^-1.5).^2;
end

%%% Sistema Dinâmico
if nProblema == 3
    disp('Sistema Dinâmico');
    nVariaveis = 5;

    size = 5000;
    xt = zeros(size,5);
    ydt = zeros(size,1);
    yhat = zeros(size+3,1);
    a = -1;
    b = 1;
    u = a + (b-a).*rand(size+2,1);
    yhat(1) = a + (b-a)*rand;
    yhat(2) = a + (b-a)*rand;
    yhat(3) = a + (b-a)*rand;
    for k = 3:(size+2);
      yhat(k+1) = g(yhat(k), yhat(k-1), yhat(k-2), u(k), u(k-1));
      ydt(k-2) = yhat(k+1);
      xt(k-2,:) = [yhat(k) yhat(k-1) yhat(k-2) u(k) u(k-1)];
    end

    xv = zeros(size,5);
    ydv = zeros(size,1);
    yhat = zeros(size+3,1);
    u = a + (b-a).*rand(size+2,1);
    yhat(1) = a + (b-a)*rand;
    yhat(2) = a + (b-a)*rand;
    yhat(3) = a + (b-a)*rand;
    for k = 3:(size+2);
      yhat(k+1) = g(yhat(k), yhat(k-1), yhat(k-2), u(k), u(k-1));
      ydv(k-2) = yhat(k+1);
      xv(k-2,:) = [yhat(k) yhat(k-1) yhat(k-2) u(k) u(k-1)];
    end
end

%%% Previsão de Séries Temporais
if nProblema == 4
    disp('Previsão de Séries Temporais');
    nVariaveis = 4;
    load mgdata.dat

    xt = zeros(500,4);
    ydt = zeros(500,1);
    t = 118;
    for n = 1:500;
       xt(n,:) = [mgdata(t-18+1, 2) mgdata(t-12+1, 2) mgdata(t-6+1, 2) mgdata(t+1, 2)];
       ydt(n) = mgdata(t+6+1, 2);
       t = t + 1;
    end

    xv = zeros(500,4);
    ydv = zeros(500,1);
    for n = 1:500;
       xv(n,:) = [mgdata(t-18+1, 2) mgdata(t-12+1, 2) mgdata(t-6+1, 2) mgdata(t+1, 2)];
       ydv(n) = mgdata(t+6+1, 2);
       t = t + 1;
    end
end

%%% Regressão — archive.ics.uci.edu
if nProblema == 5
	nGaussianas = 7;
    expMinusInfty = 1e-9;
    disp('Regressão — archive.ics.uci.edu');
    nVariaveis = 8;
    arq = csvread('nrg.csv');

    ycol = 9; % 9 or 10
    xt = zeros(77,8);
    ydt = zeros(77,1);
    xv = zeros(768-77,8);
    ydv = zeros(768-77,1);
    i = 1;
    j = 1;
    for n = 1:768;
       if mod(n,10) == 1;
          xt(j,:) = arq(n,1:8);
          ydt(j) = arq(n,ycol);
          j = j + 1;
       else
          xv(i,:) = arq(n,1:8);
          ydv(i) = arq(n,ycol);
          i = i + 1;
       end
    end
end

erro(1:8) = AverageError;
ys = zeros(8, length(xv(:,1)));
trainError = zeros(nEpocas, 8);
c = zeros(nGaussianas, nVariaveis, 8);
q = zeros(nGaussianas, 8);
p = zeros(nGaussianas, nVariaveis, 8);
sigma = zeros(nGaussianas, nVariaveis, 8);

i = 1;
[erro(i), c(:,:,i), q(:,i), p(:,:,i), sigma(:,:,i), ys(i,:), trainError(:,i)] = calcularAPE(alpha, nEpocas, xt, xv, ydt, ydv, nVariaveis, nGaussianas, expMinusInfty, false, false, false);
fprintf("i = %d; trainError = %f; ape = %f\n", i, trainError(nEpocas,i), erro(i).ape);

i = 2;
[erro(i), c(:,:,i), q(:,i), p(:,:,i), sigma(:,:,i), ys(i,:), trainError(:,i)] = calcularAPE(alpha, nEpocas, xt, xv, ydt, ydv, nVariaveis, nGaussianas, expMinusInfty, false, false, true);
fprintf("i = %d; trainError = %f; ape = %f\n", i, trainError(nEpocas,i), erro(i).ape);

i = 3;
[erro(i), c(:,:,i), q(:,i), p(:,:,i), sigma(:,:,i), ys(i,:), trainError(:,i)] = calcularAPE(alpha, nEpocas, xt, xv, ydt, ydv, nVariaveis, nGaussianas, expMinusInfty, false, true, false);
fprintf("i = %d; trainError = %f; ape = %f\n", i, trainError(nEpocas,i), erro(i).ape);

i = 4;
[erro(i), c(:,:,i), q(:,i), p(:,:,i), sigma(:,:,i), ys(i,:), trainError(:,i)] = calcularAPE(alpha, nEpocas, xt, xv, ydt, ydv, nVariaveis, nGaussianas, expMinusInfty, false, true, true);
fprintf("i = %d; trainError = %f; ape = %f\n", i, trainError(nEpocas,i), erro(i).ape);

i = 5;
[erro(i), c(:,:,i), q(:,i), p(:,:,i), sigma(:,:,i), ys(i,:), trainError(:,i)] = calcularAPE(alpha, nEpocas, xt, xv, ydt, ydv, nVariaveis, nGaussianas, expMinusInfty, true, false, false);
fprintf("i = %d; trainError = %f; ape = %f\n", i, trainError(nEpocas,i), erro(i).ape);

i = 6;
[erro(i), c(:,:,i), q(:,i), p(:,:,i), sigma(:,:,i), ys(i,:), trainError(:,i)] = calcularAPE(alpha, nEpocas, xt, xv, ydt, ydv, nVariaveis, nGaussianas, expMinusInfty, true, false, true);
fprintf("i = %d; trainError = %f; ape = %f\n", i, trainError(nEpocas,i), erro(i).ape);

i = 7;
[erro(i), c(:,:,i), q(:,i), p(:,:,i), sigma(:,:,i), ys(i,:), trainError(:,i)] = calcularAPE(alpha, nEpocas, xt, xv, ydt, ydv, nVariaveis, nGaussianas, expMinusInfty, true, true, false);
fprintf("i = %d; trainError = %f; ape = %f\n", i, trainError(nEpocas,i), erro(i).ape);

i = 8;
[erro(i), c(:,:,i), q(:,i), p(:,:,i), sigma(:,:,i), ys(i,:), trainError(:,i)] = calcularAPE(alpha, nEpocas, xt, xv, ydt, ydv, nVariaveis, nGaussianas, expMinusInfty, true, true, true);
fprintf("i = %d; trainError = %f; ape = %f\n", i, trainError(nEpocas,i), erro(i).ape);

i = 1;
while (i < 8) && (erro(i).ape == round(erro(i).ape)) 
	i = i + 1;
end;
for j = (i + 1):8
	if erro(j).ape ~= round(erro(j).ape)
		if erro(j).ape < erro(i).ape
				i = j;
		end;
	end;
end;

i

if nVariaveis == 1
    plot(xv,ydv,xv,ys(i,:));
else
    index = (1:1:length(ys(i,:)))';
    plot(index,ydv,index,ys(i,:));
end;

%figure
%plot(trainError(:,i));

c(:,:,i)
sigma(:,:,i)
p(:,:,i)
q(:,i)

fprintf("i = %d; trainError = %f; ape = %f\n", i, trainError(nEpocas,i), erro(i).ape);
