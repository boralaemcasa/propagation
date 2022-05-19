% Simulates the Cord system in dvCord.m by performing numerical integration
% using the algorithm implemented in rkCord.m 

% LAA 15/8/18

clear; close all

t2=1:1:500; % time vector

% initialization
z=[0.6 0.5];

% input
u = readmatrix("u.csv")';
 
num = [0.1701 0.1208];
den = [1 -1 0.2725];
%y = dlsim(num, den, u)';
sys = tf(num, den,-1);
sys = ss(sys);
obs = inv(obsv(sys));
y = [0.6 0.5];
x0 = obs * [y(1) - sys.D * u(1) ; y(2) - sys.C * sys.B * u(1) - sys.D * u(2)];
y = lsim(sys,u,[],x0)';

for k=3:length(t2)
   z(k) = z(k - 1) - 0.275 * z(k - 2) + 0.1701 * u(k - 1) + 0.1208 * u(k - 2);
end

figure(1)
plot(t2,z);
set(gca,'FontSize',18)
xlabel('k')
ylabel('z')

figure(2)
w = z - y;
plot(t2(1:end),w(1:end));
set(gca,'FontSize',18)
xlabel('k')
ylabel('z - y')

e = 0.05 * std(z) * randn(length(t2),1);

for k=3:length(t2)
   z(k) = z(k - 1) - 0.275 * z(k - 2) + 0.1701 * u(k - 1) + 0.1208 * u(k - 2) + e(k);
end

figure(3)
plot(t2,e);
set(gca,'FontSize',18)
xlabel('k')
ylabel('e')

figure(4)
plot(t2,z);
set(gca,'FontSize',18)
xlabel('k')
ylabel('w')

figure(5)
w = z - y;
plot(t2(1:end),w(1:end));
set(gca,'FontSize',18)
xlabel('k')
ylabel('w - y')


