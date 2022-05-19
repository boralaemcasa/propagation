close all;
clear all;
clc;

n = 1000;
t2 = 1:1:n; % time vector

% input
u = prbs(n,12,1);
u = u - mean(u);
u = 2 * u;
 
figure(1)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('k')
ylabel('u')
writematrix(u, 'u.csv');

nu = sqrt(0.1) * randn(1,n);

figure(2)
plot(t2,nu);
set(gca,'FontSize',18)
xlabel('k')
ylabel('nu')

% ARX
% Ay = Bu + nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)
theta = [-1.5 0.7 1 0.5];

y = [0 0];
for k = 3:n
    y(k) = - theta(1) * y(k-1) - theta(2) * y(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2) + nu(k);
end

figure(3)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y ARX')
writematrix(y, 'yarx.csv');

% ARMAX
% Ay = Bu + C nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + c(1) nu(k) +
% c(2) nu(k - 1)
theta = [-1.5 0.7 1 0.5 1 0.8];

y = [0 0];
for k = 3:n
    y(k) = - theta(1) * y(k-1) - theta(2) * y(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2) + theta(5) * nu(k) + theta(6) * nu(k - 1);
end

figure(4)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y ARMAX')
writematrix(y, 'yarmax.csv');

% Erro na saída
% Fw = Bu ; y = w + nu
% w(k) + a1 w(k-1) + a2 w(k-2) = b1 u(k - 1) + b2 u(k - 2)
theta = [-1.5 0.7 1 0.5];

w = [0 0];
for k = 3:n
    w(k) = - theta(1) * w(k-1) - theta(2) * w(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2);
end
y = w + nu;

figure(5)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y E.S.')
writematrix(y, 'yes.csv');
