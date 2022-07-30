close all;
clear all;
clc;

n = 1000;
t2 = 1:1:n; % time vector

% input
u = rand(1,n);
u = u - mean(u);
u = u/std(u);
u = u * 0.3;

nu = randn(1,n);
nu = nu - mean(nu);
nu = nu/std(nu) * 0.2;

y = [0 0];
for k = 3:n
    y(k) = 1.5 * y(k - 1) - 0.7 * y(k-2) + 0.5 * u(k-1) + nu(k);
end

figure(1)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('k')
ylabel('u');

figure(2)
plot(t2,nu);
set(gca,'FontSize',18)
xlabel('k')
ylabel('\nu');

figure(3)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y');

Y = y(2:n)';
Psi = [y(1:n-1)' u(1:n-1)'];
teta = pinv(Psi)*Y;
xi = Y - Psi*teta;

m = mean(xi);
m2 = mean(u);
lag = 80;
c1 = xi;
l=ones(lag+1)*1.96/sqrt(length(c1)); 
t = 0:1:lag;
for tau = 0:lag
    rxixi(tau+1) = 0;
    ruxi(tau+1) = 0;
    for k = tau+1:n-1
        rxixi(tau+1) = rxixi(tau+1) + (xi(k) - m) * (xi(k-tau) - m);
        ruxi(tau+1) = ruxi(tau+1) + (u(k) - m2) * (xi(k-tau) - m);
    end
end

rxixi = rxixi/lag;
ruxi = ruxi/lag;

figure(4)
plot(t,rxixi,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{\xi\xi}');

figure(5)
plot(t,ruxi,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{u\xi}');

Y = y(3:n)';
Psi = [y(2:n-1)' u(2:n-1)' y(1:n-2)'];
teta2 = pinv(Psi)*Y;
xi = Y - Psi*teta2;

m = mean(xi);
m2 = mean(u);
lag = 80;
c1 = xi;
l=ones(lag+1)*1.96/sqrt(length(c1)); 
t = 0:1:lag;
for tau = 0:lag
    rxixi(tau+1) = 0;
    ruxi(tau+1) = 0;
    for k = tau+1:n-2
        rxixi(tau+1) = rxixi(tau+1) + (xi(k) - m) * (xi(k-tau) - m);
        ruxi(tau+1) = ruxi(tau+1) + (u(k) - m2) * (xi(k-tau) - m);
    end
end

figure(6)
plot(t,rxixi,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{\xi\xi}');

figure(7)
plot(t,ruxi,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{u\xi}');