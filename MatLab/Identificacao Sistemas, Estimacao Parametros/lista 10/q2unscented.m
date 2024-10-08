close all;
clear all;
clc;

%G = 6.673e-11;
G = 1;
m1 = 1;
x1 = [0 0];
v1 = [0 0];
m2 = 1;
x2 = [1 0];
v2 = [0 1];

t0=0; % initial time
tf = 5; % final time
% integration interval
h=tf/10000;
t=t0:h:tf; % time vector


% initial conditions
x = [x1(1); x1(2); v1(1); v1(2); x2(1); x2(2); v2(1); v2(2)];
y = [x(5,:) - x(1,:); x(6,:) - x(2,:)];

% input
u = 293 + 50 * theta(t - 2.5*3600) - 50 * theta(t - 7.5*3600);

n = length(t);
sw = 0;
sv = 0;
sw = 5e-7;
sv = 5e-7;
v = randn(2,n);
w = randn(8,n);
v = v - mean(v);
v = v./std(v) * sqrt(sv);
w = w - mean(w);
w = w./std(w) * sqrt(sw);
Upsilon=eye(8);

figure(1)
set(gca,'FontSize',18)
xlabel('x_2')
ylabel('y_2')
hold on;
for k=2:n
    x(:,k) = rkCord(x(:,k-1),u(k),h,t(k),G,m1,m2,@dvCord1) + Upsilon * w(:, k);
    y(:,k) = [x(5,k) - x(1,k); x(6,k) - x(2,k)] + v(:, k);
    if mod(k, 50) == 0
        plot(x(1,k), x(2,k), '.', 'Color', 'b');
        plot(x(5,k), x(6,k), '.', 'Color', 'r');
        drawnow;
    end
end
hold off;

figure(2)
plot(y(1,:), y(2,:));
set(gca,'FontSize',18)
xlabel('x_2 - x_1');
ylabel('y_2 - y_1');

figure(3)
plot(t, x(1,:), t, x(5,:));
set(gca,'FontSize',18)
xlabel('t')
ylabel('x_1, x_2')

figure(4)
plot(t, x(2,:), t, x(6,:));
set(gca,'FontSize',18)
xlabel('t')
ylabel('y_1, y_2')

hat_x_me = [x1(1); x1(2); v1(1); v1(2); x2(1); x2(2); v2(1); v2(2)];
P_ma=1e2*eye(8);
Upsilonm=eye(8);
Q=eye(8)*10;
Hm = [-1 0 0 0 1 0 0 0; 0 -1 0 0 0 1 0 0];
R = eye(2);

[hat_x_ma,traco] = UKF2(hat_x_me, y,u,8,2,n,Hm,h,G,m1,m2,t);

n = 10000;
figure(5)
plot(1:n,x(1,1:n),'k',1:n,hat_x_ma(1,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_1^+')
xlabel('k')

figure(6)
plot(1:n,x(2,1:n),'k',1:n,hat_x_ma(2,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_2^+')
xlabel('k')

figure(7)
plot(1:n,x(3,1:n),'k',1:n,hat_x_ma(3,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_3^+')
xlabel('k')

figure(8)
plot(1:n,x(4,1:n),'k',1:n,hat_x_ma(4,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_4^+')
xlabel('k')

figure(9)
plot(1:n,x(5,1:n),'k',1:n,hat_x_ma(5,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_5^+')
xlabel('k')

figure(10)
plot(1:n,x(6,1:n),'k',1:n,hat_x_ma(6,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_6^+')
xlabel('k')

figure(11)
plot(1:n,x(7,1:n),'k',1:n,hat_x_ma(7,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_7^+')
xlabel('k')

figure(12)
plot(1:n,x(8,1:n),'k',1:n,hat_x_ma(8,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_8^+')
xlabel('k')

figure(13)
plot(log10(traco(1:n)))
set(gca,'FontSize',16)
xlabel('k')
ylabel('tr(P)')
