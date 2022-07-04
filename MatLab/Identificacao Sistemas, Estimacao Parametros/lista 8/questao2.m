close all;
clear all;
clc;

% carregar dados
load f0707.dat;

% fator de dizimação a ser usado
fd=1;

% período de amostragem em segundos
Ts=fd*70;

% referir os dados ao ponto de operação em que foi feito o teste
[a b]=size(f0707);
u=f0707(1:fd:a,1);
y=f0707(1:fd:a,2);

teta = zeros(2, 1);
ini = 20;
u = u(ini:end);
y = y(ini:end);
ini = 2;

a=size(teta,1);
b = length(y);
figure(1)
plot(Ts:Ts:(b-2*ini+2)*Ts,u(ini-1:b-ini),'k-');
set(gca,'FontSize',18)
xlabel('tempo (s)');
ylabel('razão cíclica (%)');
axis([0 15000 2 14])

figure(2)
plot(Ts:Ts:(b-2*ini+2)*Ts,y(ini-1:b-ini),'k-');
set(gca,'FontSize',18)
xlabel('tempo (s)');
ylabel('temperatura (%)');
axis([0 15000 25 60])

u = u - u(1);
y = y - y(1);
s = '';

ini=2;

% fator de esquecimento
lambda=1;%0.99;

% Algoritmo recursivo MQ
P=eye(2)*10^6;
teta = zeros(2,ini-1);
for k=ini:length(y)
   psi_k=[y(k-1); u(k - 1)];
   K_k = (P*psi_k)/(psi_k'*P*psi_k+lambda);
   teta(:,k)=teta(:,k-1)+K_k*(y(k)-psi_k'*teta(:,k-1));
   P=(P-(P*psi_k*psi_k'*P)/(psi_k'*P*psi_k+lambda))/lambda;
end;

%Aproximação Estocástica
% P=eye(2)*10^6;
% teta = zeros(3,ini-1);
% csi_k = 0;
% alpha = 0.99;
% C = 0.05;
% s = strcat(', C=', num2str(C, 3));
% for k=ini:length(y)
%    psi_k=[y(k-1); u(k - 1); csi_k];
%    gamma_k = C * k^(-alpha);
%    K_k = gamma_k * psi_k;
%    teta(:,k)=teta(:,k-1)+K_k*(y(k)-psi_k'*teta(:,k-1));
%    csi_k = y(k) - psi_k'*teta(:,k);
% end;

%VI modificado
% M_k = 1e6 * eye(3);
% D = 1e-6 * eye(3);
% teta = zeros(3,ini-1);
% ypf = zeros(1,ini-1);
% csi_k = 0;
% for k=ini:length(y)
%    psi_k=[y(k-1); u(k - 1); csi_k];
%    z_k = [ypf(k - 1); u(k - 1); u(k)];
%    M_k = M_k + D;
%    M_k = M_k - M_k * z_k * inv(1 + psi_k'*M_k*z_k) * psi_k'*M_k;
%    K_k = M_k * z_k;
%    teta(:,k)=teta(:,k-1)+K_k*(y(k)-psi_k'*teta(:,k-1));
%    csi_k = y(k) - psi_k'*teta(:,k);
%    ypf(k) = psi_k' * teta(:,k);
% end;

[a b]=size(teta);

% constante de tempo e ganho
for k=1:b   
   tau(k)=-Ts/(teta(1,k)-1);
   ganho(k)=tau(k)*teta(2,k)/Ts;
end;

figure(3)
plot(Ts:Ts:(b-2*ini+2)*Ts,tau(ini-1:b-ini),'k-');
set(gca,'FontSize',18)
xlabel('tempo (s)');
ylabel(strcat('constante de tempo (s)', s));
axis([0 15000 400 1400]);

figure(4)
plot(Ts:Ts:(b-2*ini+2)*Ts,ganho(ini-1:b-ini),'k-');
set(gca,'FontSize',18)
xlabel('tempo (s)');
ylabel(strcat('ganho', s));
axis([0 15000 2 3]);

% b-2*ini+2 = 214
tau([110,214])
ganho([110,214])
