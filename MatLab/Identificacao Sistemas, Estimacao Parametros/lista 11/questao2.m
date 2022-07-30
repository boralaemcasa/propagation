close all;
clear all;
clc;

n = 1000;
t2 = 1:1:n; % time vector

% input
u = rand(1,n);
u = u - mean(u);
u = u/std(u);
u = u * 0.3;
u = u';

w = rand(n,1)*0.1 - 0.05;
y = zeros(n,1);
for k = 2:n  % Simulacao do modelo 
    y(k) = 0.5*y(k-1) + u(k-1) + w(k);
end
Y = y(5:n);
Psi = y(4:n-1);
teta = inv(Psi'*Psi)*Psi'*Y;
xi = Y - Psi*teta;
AIC(1) = length(xi)*log(var(xi))+2*length(teta);

Psi = [Psi u(4:n-1)];
teta = inv(Psi'*Psi)*Psi'*Y;
xi = Y - Psi*teta;
AIC(2) = length(xi)*log(var(xi))+2*length(teta);

Psi = [Psi y(3:n-2)];
teta = inv(Psi'*Psi)*Psi'*Y;
xi = Y - Psi*teta;
AIC(3) = length(xi)*log(var(xi))+2*length(teta);

Psi = [Psi u(3:n-2)];
teta = inv(Psi'*Psi)*Psi'*Y;
xi = Y - Psi*teta;
AIC(4) = length(xi)*log(var(xi))+2*length(teta);

Psi = [Psi y(2:n-3)];
teta = inv(Psi'*Psi)*Psi'*Y;
xi = Y - Psi*teta;
AIC(5) = length(xi)*log(var(xi))+2*length(teta);

figure(1)
plot(t2,w);
set(gca,'FontSize',18)
xlabel('k')
ylabel('\nu');

figure(2)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y');

figure(3);
plot(AIC);

figure(4)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('k')
ylabel('u');