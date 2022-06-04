close all;
clear all;
clc;

c = 0;
sigma = 1;
x = -4:0.1:4;
y = gaussmf(x, [sigma c]);
z = gaussmf(x, [sigma/5 c+0.1]);

figure(1)
plot(x,y,x,z);
xlabel('theta')
ylabel('PMF')
legend('gaussmf(1,0)','gaussmf(1/5, 1.1)')

