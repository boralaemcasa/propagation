close all;
clear all;
clc;

t2=1:1:500; % time vector

% input
u=prbs(500,6,1);
u=u-0.5;
 
num = [1 0.5];
den = [1 -1.5 0.7];

figure(1)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('k')
ylabel('u')

y = dlsim(num, den, u)';
yi = dimpulse(num, den, 41);

figure(2)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y')

e = 0.05 * std(y) * randn(1,length(t2));

ye = y + e;

figure(3)
plot(t2,ye);
set(gca,'FontSize',18)
xlabel('k')
ylabel('ye')

figure(4)
[t,ryu,l,B]=myccf([ye' u'],40,0,1,'k');
set(gca,'FontSize',18)
xlabel('k')
ylabel('ryu')

figure(5)
[t,ruu,l,B]=myccf([u' u'],80,1,1,'k');
set(gca,'FontSize',18)
xlabel('k')
ylabel('ruu')

% sem assumir que Ruu eh diagonal
Ruu=B*ruu(41:end)';
for i=1:40
    Ruu=[Ruu B*ruu(41-i:end-i)'];
end
h=inv(Ruu)*ryu';

figure(6)
plot(1:41, yi, 1:41, h)
set(gca,'FontSize',18)
xlabel('k')
ylabel('h')
