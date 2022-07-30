close all;
clear all;
clc;

n = 1000;
t2 = 1:1:n; % time vector

y = 0.5;
for k = 2:n
    y(k) = 3.99 * (y(k-1) - y(k-1)^2);
end

figure(1)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y');

m = mean(y);
m2 = mean(y.^2);
lag = 80;
c1 = y;
l=ones(lag+1)*1.96/sqrt(length(c1)); 
t = 0:1:lag;
for tau = 0:lag
    ryy(tau+1) = 0;
    ryy2(tau+1) = 0;
    ry2y2(tau+1) = 0;
    for k = tau+1:n
        ryy(tau+1) = ryy(tau+1) + (y(k) - m) * (y(k-tau) - m);
        ryy2(tau+1) = ryy2(tau+1) + (y(k) - m) * (y(k-tau)^2 - m^2);
        ry2y2(tau+1) = ry2y2(tau+1) + (y(k)^2 - m2) * (y(k-tau)^2 - m2);
    end
end

ryy = ryy/lag;
ryy2 = ryy2/lag;
ry2y2 = ry2y2/lag;

figure(2)
plot(t,ryy,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{yy}');

figure(3)
plot(t,ryy2,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{yy^2}');

figure(4)
plot(t,ry2y2,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.'); 
set(gca,'FontSize',18)
xlabel('k');
ylabel('r_{y^2y^2}');
