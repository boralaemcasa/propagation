% Simulates the Cord system in dvCord.m by performing numerical integration
% using the algorithm implemented in rkCord.m 

% LAA 15/8/18

clear; close all

t0=0; % initial time
tf=2.5; % final time

h = 10/60/60; % 10 s / 60 s/min / 60 min/h = 2.7778e-03 h
t=t0:h:tf; % time vector
N = length(t);

% initialization
z=293;
a = 3.27e-2;
b = 1;
c = 8.51e-5;
d = 1.98e-11;
e = 1.98e-11;

% input
u = 293 + 50 * theta(t - 2.5) - 50 * theta(t - 7.5);

for k=2:length(t)
    z(k) = a + b * z(k - 1) - c * u(k - 1) - d * z(k - 1)^4 + e * u(k - 1)^4; 
end

figure(1)
plot(t,u);
set(gca,'FontSize',18)
xlabel('time')
ylabel('u')

parts = 10;
h=10/60/60/parts; % 10 s / 60 s/min / 60 min/h = 2.7778e-03 h

% initial conditions
t = 0;
y = 293;

% input
z = zeros(parts+1,1);
k = 2;
for k = 2:N
    %y(k) = rkCord(y(k-1),u(k),h,t(k));
    
    z(1) = y(k - 1);
    for i = 2:parts+1
        u = 293 + 50 * theta(t - 2.5) - 50 * theta(t - 7.5);
        z(i) = z(i-1) + h*dvCord(z(i-1),u,t);
        t = t + h;
    end
    y(k) = z(end);
    k = k + 1;
end

h = 10/60/60; % 10 s / 60 s/min / 60 min/h = 2.7778e-03 h
t=t0:h:tf; % time vector

figure(2)
plot(t,y);
set(gca,'FontSize',18)
xlabel('time')
ylabel('y')

% t = [t; y]';
% writematrix(t, "q1.csv");



