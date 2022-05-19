% Simulates the Cord system in dvCord.m by performing numerical integration
% using the algorithm implemented in rkCord.m 

% LAA 15/8/18

clear; close all

numerator = 1;
denominator = [1 0.2 0.8];

t = 1:1:100;
h = dimpulse(numerator,denominator,100);

figure(1)
plot(t,h);
set(gca,'FontSize',18)
xlabel('k')
ylabel('h')

