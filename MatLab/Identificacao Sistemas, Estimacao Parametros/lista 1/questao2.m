% Simulates the Cord system in dvCord.m by performing numerical integration
% using the algorithm implemented in rkCord.m 

% LAA 15/8/18

clear; close all

t2=1:1:500; % time vector


% input
u = 0.5 + randn(length(t2),1);
 
num = [0.1701 0.1208];
den = [1 -1 0.2725];

figure(1)
plot(t2,u);
set(gca,'FontSize',18)
xlabel('k')
ylabel('u')

%y = dlsim(num, den, u)';
sys = tf(num, den,-1);
sys = ss(sys);
obs = inv(obsv(sys));
y = [0.6 0.5];
x0 = obs * [y(1) - sys.D * u(1) ; y(2) - sys.C * sys.B * u(1) - sys.D * u(2) ];
y = lsim(sys,u,[],x0)';

figure(2)
plot(t2,y);
set(gca,'FontSize',18)
xlabel('k')
ylabel('y')

writematrix(u, "u.csv");
