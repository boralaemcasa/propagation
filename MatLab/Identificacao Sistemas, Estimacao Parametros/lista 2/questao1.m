close all;
clear all;
clc;

t2=1:1:500; % time vector

% input
nu = randn(1,length(t2));

figure(1)
plot(t2,nu);
set(gca,'FontSize',18)
xlabel('k')
ylabel('nu')

u = [0 0 0];

for k=4:length(t2)
   u(k) = 0.9 * nu(k - 1) + 0.8 * nu(k - 2) + 0.7 * nu(k - 3) + nu(k);
end

figure(2)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('k')
ylabel('u')

figure(3)
[t,ruu,l,B]=myccf([u' u'],80,0,1,'k');
set(gca,'FontSize',18)
xlabel('k')
ylabel('ruu')

figure(4)
[t,rnunu,l,B]=myccf([nu' nu'],80,0,1,'k');
set(gca,'FontSize',18)
xlabel('k')
ylabel('r nu nu')

figure(5)
[t,runu,l,B]=myccf([u' nu'],80,1,1,'k');
set(gca,'FontSize',18)
xlabel('k')
ylabel('ru nu')


