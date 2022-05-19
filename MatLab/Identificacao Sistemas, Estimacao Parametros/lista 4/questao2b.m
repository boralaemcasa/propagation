% close all;
% clear all;
% clc;

load prbsa02.dat

prbsa02 = prbsa02(1476:2940,:);

t=prbsa02(:,1);
U=prbsa02(:,2);
Y=prbsa02(:,3);

tt=t(1:end)-t(1);

% fazendo todos os ajuste, lembrando de retirar o offset tem-se
u=U-mean(U);
y=Y-mean(Y);
Delta_Y=y(end);
Delta_U=1;
u = u/Delta_Y;
y = y/Delta_Y;

figure(6)
plot(tt,u)
set(gca,'FontSize',18)
xlabel('t')
ylabel('u')

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

figure(7)
plot(tt,y,tt,z2)
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

figure(8)
plot(tt,z2)
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

h2 = [y(1) y(2)];
u = 0 * u;
u(1) = 1;
for k = 3:length(y)
    h2(k) = - theta(1) * h2(k-1) - theta(2) * h2(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2);
end

figure(9)
plot(tt(1:40),h1(1:40),tt(1:40),h2(1:40))
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

