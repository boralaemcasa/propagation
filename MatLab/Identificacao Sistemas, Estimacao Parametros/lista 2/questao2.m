close all;
clear all;
clc;

t2=1:1:500; % time vector

% input
u = randn(1,length(t2));
 
num = [1 0.5];
den = [1 -1.5 0.7];

figure(1)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('k')
ylabel('u')

y = dlsim(num, den, u)';

figure(2)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y')

figure(3)
[t,ruy,l,B]=myccf([u' y'],40,1,1,'k');
set(gca,'FontSize',18)
xlabel('k')
ylabel('ruy')

figure(4)
[t,ryu,l,B]=myccf([y' u'],40,1,1,'k');
set(gca,'FontSize',18)
xlabel('k')
ylabel('ryu')

% a estrutura da função myccf retorna valores positivos à direita quando a
% saída é a primeira coluna e a entrada é a segunda coluna.

load boxjenk.dat

u = boxjenk(:,1)';
y = boxjenk(:,2)';

figure(5)
[t,ruy,l,B]=myccf([u' y'],40,1,1,'k');
set(gca,'FontSize',18)
xlabel('k')
ylabel('r12')

figure(6)
[t,ryu,l,B]=myccf([y' u'],40,1,1,'k');
set(gca,'FontSize',18)
xlabel('k')
ylabel('r21')

% u = boxjenk(:,1)' é a entrada
% y = boxjenk(:,2)' é a saída

