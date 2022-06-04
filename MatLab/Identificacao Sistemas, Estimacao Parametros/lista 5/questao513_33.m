close all;
clear all;
clc;

load bfg33.dat

t=bfg33(:,1);
U=bfg33(:,2);
Y=bfg33(:,3);

Delta_Y=mean(Y(end-15:end))-mean(Y(1:29));
% variacao da entrada
Delta_U=mean(U(end-15:end))-mean(U(1:29));
tt=t(29:end)-t(29);

% fazendo todos os ajuste, lembrando de retirar o offset tem-se
u=(U(29:end)-mean(U(1:29)))/Delta_Y;
y=(Y(29:end)-mean(Y(1:29)))/Delta_Y;

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
for k = 21:length(y)
    X = [X; -y(k-1) -y(k-2) u(k - 19) u(k - 20)];
end

theta = pinv(X) * y(21:end);

z = X * theta;
z = [y(1:20)' z'];
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

z2 = y(1:20)';
for k = 21:length(y)
    z2(k) = - theta2(1) * z2(k-1) - theta2(2) * z2(k-2) + theta2(3) * u(k - 19) + theta2(4) * u(k - 20);
end

z2(21:end) = z2(21:end) / z2(end);

figure(4)
plot(tt,y,tt,z2)
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

%%%%%%%

%h1(s) = 1.338 exp(-1.9 s) / (3.406 s + 1) / (1.053 s + 1)

tau1 = 3.406;
tau2 = 1.053;
taud = 1.9;

sys=tf(1.338,conv([tau1 1],[tau2 1]));
ym=lsim(sys,ones(length(tt),1)*Delta_U,tt)/Delta_Y;

figure(5)
plot(tt,y,'k',tt+taud,ym);
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

z3 = y(1:20)';
for k = 21:length(y)
    z3(k) = - theta3(1) * z3(k-1) - theta3(2) * z3(k-2) + theta3(3) * u(k - 19) + theta3(4) * u(k - 20);
end

z3(21:end) = z3(21:end) / z3(end);

figure(6)
plot(tt,y,tt,z3)
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

[Am,Su,Up,Cov] = mvregress(Psi,y(21:end),'varformat','full');

for rep = 1:200
    Theta4(rep,:) = mvnrnd(theta,Cov(1:4,1:4),1);
end
theta4 = mean(Theta4);

% ARX
% Ay = Bu + nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)

z4 = y(1:20)';
for k = 21:length(y)
    z4(k) = - theta4(1) * z4(k-1) - theta4(2) * z4(k-2) + theta4(3) * u(k - 19) + theta3(4) * u(k - 20);
end

z4(21:end) = z4(21:end) / z4(end);

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


