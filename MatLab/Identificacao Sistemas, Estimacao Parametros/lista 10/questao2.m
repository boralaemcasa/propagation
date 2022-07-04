close all;
clear all;
clc;

%G = 6.673e-11;
G = 1;
m1 = 1;
x1 = [0 0];
v1 = [0 0];
m2 = 1;
x2 = [1 0];
v2 = [0 1];

t0=0; % initial time
tf = 5; % final time
% integration interval
h=tf/10000;
t=t0:h:tf; % time vector


% initial conditions
y=[x1(1); x1(2); v1(1); v1(2); x2(1); x2(2); v2(1); v2(2)];

% input
u = 293 + 50 * theta(t - 2.5*3600) - 50 * theta(t - 7.5*3600);

% figure(1)
% plot(t,u);
% set(gca,'FontSize',18)
% xlabel('time')
% ylabel('u')

figure(1)
set(gca,'FontSize',18)
xlabel('x_2')
ylabel('y_2')
hold on;
for k=2:length(t)
    y(:,k) = rkCord(y(:,k-1),u(k),h,t(k),G,m1,m2,@dvCord1); % y(k-1) + h*dvCord(y(k-1),u(k),t);
    %y(:,k) = y(:,k-1) + h*dvCord2(y(:,k-1),u(k),t,G,m1,m2);
    if mod(k, 50) == 0
        plot(y(1,k), y(2,k), '.', 'Color', 'b');
        plot(y(5,k), y(6,k), '.', 'Color', 'r');
        drawnow;
    end
end
hold off;

figure(2)
plot(y(5,:) - y(1,:), y(6,:) - y(2,:));
set(gca,'FontSize',18)
xlabel('x_2 - x_1');
ylabel('y_2 - y_1');

figure(3)
plot(t, y(5,:), t, y(6,:));
set(gca,'FontSize',18)
xlabel('t')
ylabel('x_2, y_2')

% t0=0; % initial time
% tf=10; % final time
% h = 2.7778e-03; % 10 s / 60 s/min / 60 min/h = 2.7778e-03 h
% t2=t0:h:tf; % time vector
% 
% % initialization
% z=293;
% a = 3.27e-2;
% b = 1;
% c = 8.51e-5;
% d = 1.98e-11;
% e = 1.98e-11;
% 
% % input
% u = 293 + 50 * theta(t2 - 2.5) - 50 * theta(t2 - 7.5);
% 
% for k=2:length(t2)
%     z(k) = a + b * z(k - 1) - c * u(k - 1) - d * z(k - 1)^4 + e * u(k - 1)^4; 
% end
% 
% figure(3)
% plot(t2,u);
% set(gca,'FontSize',18)
% xlabel('time')
% ylabel('u')
% 
% figure(4)
% plot(t2,z);
% set(gca,'FontSize',18)
% xlabel('time')
% ylabel('y')
% 
% figure(5)
% plot(t/3600,y,t2,z);
% set(gca,'FontSize',18)
% xlabel('time')
% ylabel('y')
% 
