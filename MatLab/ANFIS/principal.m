close all;
clear all;
clc;

nGaussianas = 11;
nProblema = 1;

%%% Parábola
if nProblema == 1
    disp('Parábola');
    nVariaveis = 1;
    xit = -2;
    xft = 2;
    delta = 4/500;
    xt=(xit:delta:xft)' ;
    ydt = xt.^2;
    xv = (xit:delta/2:xft)';
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

disp(min(xt));
disp(max(xt));

[ape, c, q, p, sigma, ys, trainError] = calcularAPE(xt, xv, ydt, ydv, nVariaveis, nGaussianas);
fprintf("trainError = %f; ape = %f\n", trainError(end), ape);

plot(xv,ydv,xv,ys);

figure
index = (1:1:length(ys))';
plot(index,ydv,index,ys);

figure
plot(trainError);

c
p
q
sigma
