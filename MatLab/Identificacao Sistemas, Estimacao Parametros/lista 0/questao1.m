% Simulates the Cord system in dvCord.m by performing numerical integration
% using the algorithm implemented in rkCord.m 

% LAA 15/8/18

clear; close all


t0=0; % initial time
tf=10*3600; % final time
% integration interval
h=0.1; % 10h * 60min/h * 60s/min = 36000s = 1/2.7778e-05 s
t=t0:h:tf; % time vector


% initial conditions
y=[293 0];

% input
u = 293 + 50 * theta(t - 2.5*3600) - 50 * theta(t - 7.5*3600);

figure(1)
plot(t/3600,u);
set(gca,'FontSize',18)
xlabel('time')
ylabel('u')

for k=2:length(t)
    y(k) = rkCord(y(k-1),u(k),h,t(k),@dvCord1); % y(k-1) + h*dvCord(y(k-1),u(k),t);
end

figure(2)
plot(t/3600,y);
set(gca,'FontSize',18)
xlabel('time')
ylabel('y')

t0=0; % initial time
tf=10; % final time
h = 2.7778e-03; % 10 s / 60 s/min / 60 min/h = 2.7778e-03 h
t2=t0:h:tf; % time vector

% initialization
z=293;
a = 3.27e-2;
b = 1;
c = 8.51e-5;
d = 1.98e-11;
e = 1.98e-11;

% input
u = 293 + 50 * theta(t2 - 2.5) - 50 * theta(t2 - 7.5);

for k=2:length(t2)
    z(k) = a + b * z(k - 1) - c * u(k - 1) - d * z(k - 1)^4 + e * u(k - 1)^4; 
end

figure(3)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('time')
ylabel('u')

figure(4)
plot(t2,z);
set(gca,'FontSize',18)
xlabel('time')
ylabel('y')

figure(5)
plot(t/3600,y,t2,z);
set(gca,'FontSize',18)
xlabel('time')
ylabel('y')
