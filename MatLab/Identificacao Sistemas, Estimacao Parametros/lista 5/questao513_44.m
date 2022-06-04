close all;
clear all;
clc;

load bfg44.dat

t=bfg44(:,1);
U=bfg44(:,2);
Y=bfg44(:,3);

Delta_Y=abs(mean(Y(end-15:end))-min(Y(1:1)));
% variacao da entrada
Delta_U=mean(U(end-15:end))-mean(U(1:1));
tt=t(1:end)-t(1);

% fazendo todos os ajuste, lembrando de retirar o offset tem-se
u=(U(1:end)-mean(U(1:1)))/Delta_Y;
y=(Y(1:end)-mean(Y(1:1)))/Delta_Y;

figure(1)
plot(t,U)
set(gca,'FontSize',18)
xlabel('t')
ylabel('u')

figure(2)
plot(t,Y)
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

figure(3)
plot(tt,u)
set(gca,'FontSize',18)
xlabel('t')
ylabel('u')

% y(k) = [-y(k-1) -y(k-2) u(k - 1) u(k - 2)] * theta;

X = [];
for k = 34:length(y)
    X = [X; -y(k-1) -y(k-2) u(k - 32) u(k - 33)];
end

theta = pinv(X) * y(34:end);

z = X * theta;
z = [y(1:33)' z'];
J = norm(z - y)^2;

Psi = X;
csi = y - z';
Cov = diag(inv(Psi' * Psi) * var(csi));

for rep = 1:200
    Theta2(rep,:) = mvnrnd(theta,Cov',1);
end
theta2 = mean(Theta2);

% ARX
% Ay = Bu + nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)

z2 = y(1:33)';
for k = 34:length(y)
    z2(k) = - theta(1) * z2(k-1) - theta(2) * z2(k-2) + theta(3) * u(k - 32) + theta(4) * u(k - 33);
end

z2(34:end) = z2(34:end) / abs(z2(end));

figure(4)
plot(tt,y,tt,z2)
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

%%%%%%%

%h2(s) = 0.0182 exp(-4.7 s) / (s^2 + as + b)

a = 2 * 0.4 * 0.228;
b = 0.052;
taud = 4.7;

sys=tf(0.0182,[1 a b]);
ym=lsim(sys,ones(length(tt),1)*Delta_U,tt)/Delta_Y;

figure(5)
plot(tt,y,tt+taud,ym);
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

Cov = inv(Psi' * Psi) * var(csi);

for rep = 1:200
    Theta3(rep,:) = mvnrnd(theta,Cov,1);
end
theta3 = mean(Theta3);

% ARX
% Ay = Bu + nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)

z3 = y(1:33)';
for k = 34:length(y)
    z3(k) = - theta3(1) * z3(k-1) - theta3(2) * z3(k-2) + theta3(3) * u(k - 32) + theta3(4) * u(k - 33);
end

z3(34:end) = z3(34:end) / abs(z3(end));

figure(6)
plot(tt,y,tt,z3)
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

[Am,Su,Up,Cov] = mvregress(Psi,y(34:end),'varformat','full');

for rep = 1:200
    Theta4(rep,:) = mvnrnd(theta,Cov(1:4,1:4),1);
end
theta4 = mean(Theta4);

% ARX
% Ay = Bu + nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)

z4 = y(1:33)';
for k = 34:length(y)
    z4(k) = - theta4(1) * z4(k-1) - theta4(2) * z4(k-2) + theta4(3) * u(k - 32) + theta3(4) * u(k - 33);
end

z4(34:end) = z4(34:end) / abs(z4(end));

figure(7)
plot(tt,y,tt,z4)
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

figure(8)
histogram(Theta2(:,1));
set(gca,'FontSize',18)
xlabel('theta 1')

figure(9)
histogram(Theta3(:,1));
set(gca,'FontSize',18)
xlabel('theta 1')

figure(10)
histogram(Theta4(:,1));
set(gca,'FontSize',18)
xlabel('theta 1')

figure(11)
histogram(Theta2(:,2));
set(gca,'FontSize',18)
xlabel('theta 2')

figure(12)
histogram(Theta3(:,2));
set(gca,'FontSize',18)
xlabel('theta 2')

figure(13)
histogram(Theta4(:,2));
set(gca,'FontSize',18)
xlabel('theta 2')

figure(14)
histogram(Theta2(:,3));
set(gca,'FontSize',18)
xlabel('theta 3')

figure(15)
histogram(Theta3(:,3));
set(gca,'FontSize',18)
xlabel('theta 3')

figure(16)
histogram(Theta4(:,3));
set(gca,'FontSize',18)
xlabel('theta 3')

figure(17)
histogram(Theta2(:,4));
set(gca,'FontSize',18)
xlabel('theta 4')

figure(18)
histogram(Theta3(:,4));
set(gca,'FontSize',18)
xlabel('theta 4')

figure(19)
histogram(Theta4(:,4));
set(gca,'FontSize',18)
xlabel('theta 4')


