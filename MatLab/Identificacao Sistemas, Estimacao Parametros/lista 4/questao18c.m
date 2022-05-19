close all;
clear all;
clc;

n = 500;
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

nu = randn(1,n);
nu = 0.05 * 4.29480726/std(nu) * nu;
fprintf("%.8f", std(nu) - 0.05 * 4.29480726);

figure(2)
plot(t2,nu);
set(gca,'FontSize',18)
xlabel('k')
ylabel('e')

% ARX
% Ay = Bu + nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)
theta = [1.5 -0.7 1 0.5];

y = [0 0];
for k = 3:n
    y(k) = theta(1) * y(k-1) + theta(2) * y(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2) + nu(k);
end
writematrix(y, 'y.csv');

figure(2)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y')

X = [];
for k = 5:8
    X = [X; y(k-1) y(k-2) u(k - 1) u(k - 2)];
end

theta = pinv(X) * y(5:8)';

z = X * theta;
J = norm(z - y(5:8)')^2;

%%%%%%%

X2 = [];
for k = 205:208
    X2 = [X2; y(k-1) y(k-2) u(k - 1) u(k - 2)];
end

theta2 = pinv(X2) * y(205:208)';

z2 = X2 * theta2;
J2 = norm(z2 - y(205:208)')^2;

