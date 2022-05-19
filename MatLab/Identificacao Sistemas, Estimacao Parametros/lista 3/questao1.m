close all;
clear all;
clc;

n = 100;
x = 12 * rand(1,n) - 6;
x = sort(x);
theta = [-2 0.7 1.5];
y = theta(3) * x.^2 + theta(2) * x + theta(1);

figure(1)
plot(x,y);
set(gca,'FontSize',18)
xlabel('x')
ylabel('y')

e = 0.10 * std(y) * randn(1,n);

ye = y + e;

figure(2)
plot(x,ye);
set(gca,'FontSize',18)
xlabel('x')
ylabel('ye')

X = ones(n,3);
X(:,2) = x';
X(:,3) = (x.^2)';

theta = pinv(X) * ye';

x2 = x;
y2 = theta(3) * x.^2 + theta(2) * x + theta(1);
theta2 = theta;

n = 1000;
x = 12 * rand(1,n) - 6;
x = sort(x);
theta = [-2 0.7 1.5];
y = theta(3) * x.^2 + theta(2) * x + theta(1);

figure(3)
plot(x,y);
set(gca,'FontSize',18)
xlabel('x')
ylabel('y')

e = 0.10 * std(y) * randn(1,n);

ye = y + e;

figure(4)
plot(x,ye);
set(gca,'FontSize',18)
xlabel('x')
ylabel('ye')

X = ones(n,3);
X(:,2) = x';
X(:,3) = (x.^2)';

theta = pinv(X) * ye';

x3 = x;
y3 = theta(3) * x.^2 + theta(2) * x + theta(1);
theta3 = theta;

% figure(5)
% plot(x2,y2,x3,y3);
% set(gca,'FontSize',18)
% xlabel('x')
% ylabel('ye')

n = 100;
x = 12 * rand(1,n) - 6;
x = sort(x);
theta = [-2 0.7 1.5];
y = theta(3) * x.^2 + theta(2) * x + theta(1);

figure(5)
plot(x,y);
set(gca,'FontSize',18)
xlabel('x')
ylabel('y')

e = 0.10 * std(x) * randn(1,n);

xe = x + e;

figure(6)
plot(xe,y,'.');
set(gca,'FontSize',18)
xlabel('xe')
ylabel('y')

X = ones(n,3);
X(:,2) = xe';
X(:,3) = (xe.^2)';

theta = pinv(X) * y';

x4 = x;
y4 = theta(3) * x.^2 + theta(2) * x + theta(1);
theta4 = theta;

figure(7)
plot(x2,y2,x3,y3,x4,y4);
set(gca,'FontSize',18)
xlabel('xe')
ylabel('y')
theta = [-2 0.7 1.5];
