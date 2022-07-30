close all;
clear all;
clc;

n = 1000;
t2 = 1:1:n; % time vector

nu = randn(1,n);
nu = nu - mean(nu);
nu = nu/std(nu) * 0.02;

y = 0.5;
for k = 2:n
    y(k) = 3 * (y(k-1) - y(k-1)^2) + nu(k);
end

figure(1)
plot(t2,nu);
set(gca,'FontSize',18)
xlabel('k')
ylabel('\nu');

figure(2)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y');

Y = y(2:n)';
Psi = y(1:n-1)';
teta = pinv(Psi)*Y;
xi = Y - Psi*teta;

m = mean(xi);
m2 = mean(xi.^2);
lag = 80;
c1 = xi;
l=ones(lag+1)*1.96/sqrt(length(c1)); 
t = 0:1:lag;
for tau = 0:lag
    rxixi(tau+1) = 0;
    rxixi2(tau+1) = 0;
    rxi2xi2(tau+1) = 0;
    for k = tau+1:n-1
        rxixi(tau+1) = rxixi(tau+1) + (xi(k) - m) * (xi(k-tau) - m);
        rxixi2(tau+1) = rxixi2(tau+1) + (xi(k) - m) * (xi(k-tau)^2 - m^2);
        rxi2xi2(tau+1) = rxi2xi2(tau+1) + (xi(k)^2 - m2) * (xi(k-tau)^2 - m2);
    end
end

rxixi = rxixi/lag;
rxixi2 = rxixi2/lag;
rxi2xi2 = rxi2xi2/lag;

figure(3)
plot(t,rxixi,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{\xi\xi}');

figure(4)
plot(t,rxixi2,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{\xi\xi^2}');

figure(5)
plot(t,rxi2xi2,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{\xi^2\xi^2}');

Y = y(2:n)';
Psi = [y(1:n-1)' (y(1:n-1).^2)'];
teta2 = pinv(Psi)*Y;
xi = Y - Psi*teta2;

m = mean(xi);
m2 = mean(xi.^2);
lag = 80;
c1 = xi;
l=ones(lag+1)*1.96/sqrt(length(c1)); 
t = 0:1:lag;
for tau = 0:lag
    rxixi(tau+1) = 0;
    rxixi2(tau+1) = 0;
    rxi2xi2(tau+1) = 0;
    for k = tau+1:n-1
        rxixi(tau+1) = rxixi(tau+1) + (xi(k) - m) * (xi(k-tau) - m);
        rxixi2(tau+1) = rxixi2(tau+1) + (xi(k) - m) * (xi(k-tau)^2 - m^2);
        rxi2xi2(tau+1) = rxi2xi2(tau+1) + (xi(k)^2 - m2) * (xi(k-tau)^2 - m2);
    end
end

figure(6)
plot(t,rxixi,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{\xi\xi}');

figure(7)
plot(t,rxixi2,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{\xi\xi^2}');

figure(8)
plot(t,rxi2xi2,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{\xi^2\xi^2}');
