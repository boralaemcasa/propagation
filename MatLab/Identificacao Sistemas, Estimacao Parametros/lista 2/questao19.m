close all;
clear all;
clc;

load prbsa02.dat

prbsa02 = prbsa02(1:2952,:);
t = prbsa02(:,1)';
u = prbsa02(:,2)';
ye = prbsa02(:,3)';

u = u - mean(u);
ye = ye - mean(ye);

figure(1)
plot(t,u)
set(gca,'FontSize',18)
xlabel('t')
ylabel('u')

figure(2)
plot(t,ye)
set(gca,'FontSize',18)
xlabel('t')
ylabel('y')

figure(3)
[t,ryu,l,B]=myccf([ye' u'],40,0,1,'k');
set(gca,'FontSize',18)
xlabel('k')
ylabel('ryu')

figure(4)
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

t = prbsa02(:,1)';

figure(5)
plot(t(1:40), h(1:40))
set(gca,'FontSize',18)
xlabel('t')
ylabel('h')
