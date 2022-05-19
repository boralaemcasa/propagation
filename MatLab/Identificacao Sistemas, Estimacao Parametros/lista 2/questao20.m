close all;
clear all;
clc;

t2 = 0:1:20000; % time vector
impulso = zeros(1,length(t2));
impulso(1) = 1;

num = 1;
den = [1000 1];

% Y(s)/U(s) = 1/(1000s + 1)
% 1000 s Y(s) + Y(s) = U(s)
% 1000 y'(t) + y(t) = u(t)
% y'(t) = (u(t) - y(t))/1000

sys = tf(num, den);
h = lsim(sys,impulso,t2);

figure(1)
plot(t2(1:4000),h(1:4000));
set(gca,'FontSize',18)
xlabel('t')
ylabel('h')

u = prbs(length(t2),6,1);
u = u - 0.5;
 
figure(2)
plot(t2(1:500),u(1:500));
set(gca,'FontSize',18)
xlabel('t')
ylabel('u1')

y = lsim(sys,u,t2);

figure(3)
plot(t2(1:500),y(1:500));
set(gca,'FontSize',18)
xlabel('t')
ylabel('y1')

u = prbs(length(t2),6,100);
u = u - 0.5;
 
figure(4)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('t')
ylabel('u100')

y = lsim(sys,u,t2);

figure(5)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('t')
ylabel('y100')

u = prbs(length(t2),6,1000);
u = u - 0.5;
 
figure(6)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('t')
ylabel('u1000')

y = lsim(sys,u,t2);

figure(7)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('t')
ylabel('y1000')

u = prbs(length(t2),6,10000);
u = u - 0.5;
 
figure(8)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('t')
ylabel('u10000')

y = lsim(sys,u,t2);

figure(9)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('t')
ylabel('y10000')






