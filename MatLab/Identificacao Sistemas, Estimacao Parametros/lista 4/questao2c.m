close all;
clear all;
clc;

load prbsa02.dat

prbsa02 = prbsa02(1476:2940,:);

t=prbsa02(:,1);
U=prbsa02(:,2);
Y=prbsa02(:,3);

tt=t(1:end)-t(1);

u=U-mean(U);
%y=Y-mean(Y);
%por que não funciona se tirar a média?
y=Y;

X = [];
for k = 4:length(y)
    X = [X; -y(k-1) -y(k-2) -y(k-3) u(k - 1) u(k - 2) u(k - 3)];
end

theta = pinv(X) * y(4:end);

z = X * theta;
z = [y(1:3)' z'];
J = norm(z - y)^2;

% ARX
% Ay = Bu + nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)

z2 = y(1:3)';
for k = 4:length(y)
    z2(k) = - theta(1) * z2(k-1) - theta(2) * z2(k-2) - theta(3) * z2(k-3) + theta(4) * u(k - 1) + theta(5) * u(k - 2) + theta(6) * u(k - 3);
end

figure(1)
plot(tt,y,tt,z2-mean(z2)+mean(y)) %z2 + constante conhecida
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

%por que começar com y? o que h2 significa?
h2 = [y(1) y(2) y(3)];
u = 0 * u;
u(1) = 1;
for k = 4:length(y)
    h2(k) = - theta(1) * h2(k-1) - theta(2) * h2(k-2) - theta(3) * h2(k-3) + theta(4) * u(k - 1) + theta(5) * u(k - 2) + theta(6) * u(k - 3);
end

h2 = h2 - mean(h2);

figure(2)
plot(tt(1:40),h2(1:40))
set(gca,'FontSize',18)
xlabel('t')
ylabel('h2')

u=U-mean(U);
c = conv(h2,u');

figure(3)
plot(tt,y,tt,-c(end-length(tt)+1:end)+mean(y)) % a constante é conhecida. por que funciona o oposto da convolução?
set(gca,'FontSize',18)
xlabel('t')
ylabel('h2 conv u')
