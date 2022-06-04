close all;
clear all;
clc;

n = 1000;
t2 = 1:1:n; % time vector

% input
u = prbs(n,12,1);
u = u - mean(u);
u = 2 * u;

writematrix(u, 'u.csv');

fprintf("ARX\n");
for rep = 1:200
    nu = sqrt(0.1) * randn(1,n);

    % ARX
    % Ay = Bu + nu
    % y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)
    theta = [1.5 -0.7 1 0.5];

    y = [0 0];
    for k = 3:n
        y(k) = theta(1) * y(k-1) + theta(2) * y(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2) + nu(k);
    end

    X = [];
    for k = 3:n
        X = [X; y(k-1) y(k-2) u(k - 1) u(k - 2)];
    end

    Theta(rep,:) = pinv(X) * y(3:n)';

    z = X * Theta(rep,:)';
    z = [0 0 z'];
    J(rep) = norm(z - y)^2;
end
for k = 1:4
    fprintf("Polarização = %.8f\n", theta(k) - mean(Theta(:,k)))
    fprintf("Variância = %.8f\n", var(Theta(:,k)))
end

% ARMAX
% Ay = Bu + C nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + c(1) nu(k) +
% c(2) nu(k - 1)
fprintf("ARMAX\n");
for rep = 1:200
    nu = sqrt(0.1) * randn(1,n);

    theta = [1.5 -0.7 1 0.5 1 0.8];

    y = [0 0];
    for k = 3:n
        y(k) = theta(1) * y(k-1) + theta(2) * y(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2) + theta(5) * nu(k) + theta(6) * nu(k - 1);
    end
    
    Theta(rep,:) = pinv(X) * y(3:n)';

    z = X * Theta(rep,:)';
    z = [0 0 z'];
    J(rep) = norm(z - y)^2;
end
for k = 1:4
    fprintf("Polarização = %.8f\n", theta(k) - mean(Theta(:,k)))
    fprintf("Variância = %.8f\n", var(Theta(:,k)))
end

% Erro na saída
% Fw = Bu ; y = w + nu
% w(k) + a1 w(k-1) + a2 w(k-2) = b1 u(k - 1) + b2 u(k - 2)
fprintf("OEM\n");
for rep = 1:200
    nu = sqrt(0.1) * randn(1,n);

    theta = [1.5 -0.7 1 0.5];

    w = [0 0];
    for k = 3:n
        w(k) = theta(1) * w(k-1) + theta(2) * w(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2);
    end
    y = w + nu;

    Theta(rep,:) = pinv(X) * y(3:n)';

    z = X * Theta(rep,:)';
    z = [0 0 z'];
    J(rep) = norm(z - y)^2;
end
for k = 1:4
    fprintf("Polarização = %.8f\n", theta(k) - mean(Theta(:,k)))
    fprintf("Variância = %.8f\n", var(Theta(:,k)))
end
