% Simulates the Cord system in dvCord.m by performing numerical integration
% using the algorithm implemented in rkCord.m 

% LAA 15/8/18

clear; close all

c = 1;
n = 20;
ini = 1;
t0=5; % initial time
tf=200; % final time
% integration interval
h=0.1;
t=t0:h:tf; % time vector


% initial conditions
y=[0 0];

% input
u = ini + c*theta(t - n);
for k = 2:9
    u = u + c * theta(t - k*n);
end

figure(1)
plot(t,u);
set(gca,'FontSize',18)
xlabel('time')
ylabel('u')

for k=2:length(t)
    y(k) = rkCord(y(k-1),u(k),h,t(k),@dvCord2);
end

figure(2)
plot(t,y);
set(gca,'FontSize',18)
xlabel('time')
ylabel('y')
