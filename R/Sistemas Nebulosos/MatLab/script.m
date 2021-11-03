clear
clc
load fcmdata.dat
X = fcmdata;
% Número de centros
c = 3;
% Parâmetro de Fuzzyficação
m = 2;
% Torelância
epsilon = 10^-4;

[n,p] = size(X);

% Inicialização Aleatória
K = rand(c,p);

% Inicialização Substrativa
r_a = 0.5;
K = subclust(X,r_a);

% Cmeans
[K,U] = fcmeans(X,K,m,epsilon);

% Cmeans MATLAB
[K1,U1] = fcm(X,c,[m,NaN,epsilon,false]);

% Plotagem
plot_fuzzy(X,K,m)
plot_fuzzy(X,K1,m)