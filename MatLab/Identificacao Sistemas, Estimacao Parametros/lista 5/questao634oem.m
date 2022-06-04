close all;
clear all;
clc;

n = 500;
t2 = 1:1:n; % time vector

% input
u = readmatrix('u518.csv');

for rep = 1:200
    nu = randn(1,n);
    nu = 0.05 * 4.29480726/std(nu) * nu;

    % ARX
    % Ay = Bu + nu
    % y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)
    theta = [1.5 -0.7 0.5];

    w = [0 0];
    for k = 3:n
        w(k) = theta(1) * w(k-1) + theta(2) * w(k-2) + theta(3) * u(k - 1);
    end
    y = w + nu;

    X = [];
    for k = 3:n
        X = [X; y(k-1) y(k-2) u(k - 1)];
    end

    Theta(rep,:) = pinv(X) * y(3:n)';

    z = X * Theta(rep,:)';
    z = [0 0 z'];
    J(rep) = norm(z - y)^2;
end
figure(1)
histogram(Theta(:,1));
set(gca,'FontSize',18)
xlabel('theta 1')

figure(2)
histogram(Theta(:,2));
set(gca,'FontSize',18)
xlabel('theta 2')

figure(3)
histogram(Theta(:,3));
set(gca,'FontSize',18)
xlabel('theta 3')
