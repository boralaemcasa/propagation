close all;
clear all;
clc;

n = 1000;
u = readmatrix('u.csv');
y = readmatrix('yarx.csv');

% y(k) = [-y(k-1) -y(k-2) u(k - 1) u(k - 2)] * theta;

X = [];
for k = 3:n
    X = [X; -y(k-1) -y(k-2) u(k - 1) u(k - 2)];
end

theta = pinv(X) * y(3:n)';

z = X * theta;
z = [0 0 z'];
J = norm(z - y)^2;

y = readmatrix('yarmax.csv');

% y(k) = [-y(k-1) -y(k-2) u(k - 1) u(k - 2)] * theta;

X = [];
for k = 3:n
    X = [X; -y(k-1) -y(k-2) u(k - 1) u(k - 2)];
end

theta2 = pinv(X) * y(3:n)';

z = X * theta2;
z = [0 0 z'];
J2 = norm(z - y)^2;

y = readmatrix('yes.csv');

% y(k) = [-y(k-1) -y(k-2) u(k - 1) u(k - 2)] * theta;

X = [];
for k = 3:n
    X = [X; -y(k-1) -y(k-2) u(k - 1) u(k - 2)];
end

theta3 = pinv(X) * y(3:n)';

z = X * theta3;
z = [0 0 z'];
J3 = norm(z - y)^2;
