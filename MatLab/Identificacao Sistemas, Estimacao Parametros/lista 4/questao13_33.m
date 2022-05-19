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

% ARX
% Ay = Bu + nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)

z2 = y(1:20)';
for k = 21:length(y)
    z2(k) = - theta(1) * z2(k-1) - theta(2) * z2(k-2) + theta(3) * u(k - 19) + theta(4) * u(k - 20);
end

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


