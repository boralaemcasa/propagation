close all;
clear all;
clc;

n = 1000;
t = 1:1:n;

Phi=[0.8 -0.4 0.2;0 0.3 -0.5;0 0 0.5];
Gama=[0 0; 0 -0.5 ;0.5 0];
Upsilon=eye(3);
H=[0.5 0.5 0; 0 0 1];

q=0;
r=0;
Phim0=[0.8+q*randn(1,1) -0.4 0.2;0 0.3+q*randn(1,1) -0.5;0 0 0.5+q*randn(1,1)];
Gamam0=[0 0+q*randn(1,1);0 -0.5+q*randn(1,1);0.5+q*randn(1,1) 0];

theta = [Phim0(1,1); Gamam0(3,1)];

nu = randn(1,n);
nu = nu - mean(nu);
nu = nu/std(nu);

% w = ruído de processo
% cov w = sw I

% v = ruído de medição
% cov v = sv I

% b
sw = 0.2;
sv = 0.05;

Theta = [];
for rep = 1:1
    v = randn(2,n);
    w = randn(3,n);
    v = v - mean(v);
    v = v./std(v) * sqrt(sv);
    w = w - mean(w);
    w = w./std(w) * sqrt(sw);

    u = [0; 0];
    for k = 2:n
        u(1, k) = 0.5 * u(1, k - 1) + nu(k);
        u(2, k) = 0.9 * nu(k - 1) + nu(k);
    end;

    x = zeros(3,1);
    y = zeros(2,1);
    for k = 1:n-1
        x(:,k + 1) = Phi * x(:,k) + Gama * u(:, k) + Upsilon * w(:, k);
        y(:,k + 1) = H * x(:, k) + v(:, k);
    end;

    if rep == 1
        figure(1)
        plot(t, y(1,:));
        set(gca,'FontSize',16)
        ylabel('y_1')
        xlabel('k')

        figure(2)
        plot(t, y(2,:));
        set(gca,'FontSize',16)
        ylabel('y_2')
        xlabel('k')
    end
    
    Phim = Phi;
    Phim = [Phim zeros(3,2)];
    Phim = [Phim ; zeros(2,5)];
    Phim(4,4) = 1;
    Phim(5,5) = 1; % antes era 3x3, agora 5x5 colada na identidade

    Gamam = Gama;
    Gamam = [Gamam zeros(3,3)];
    Gamam = [Gamam ; zeros(2,5)]; % antes era 3x2, agora 5x5

    Hm = H;

    u = [u; zeros(3, n)]; % antes era 2xn, agora 5xn

    Upsilonm=(1+q)*eye(5);

    [hat_x_ma,traco] = UKF(y,u,5,2,n,Phim,Gamam,Hm);
end

figure(3)
plot(log10(traco(1:50)))
set(gca,'FontSize',16)
xlabel('k')
ylabel('tr(P)')

figure(4)
plot(1:n,x(1,1:n),'k',1:n,hat_x_ma(1,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_1^+')
xlabel('k')

figure(5)
plot(1:n,x(2,1:n),'k',1:n,hat_x_ma(2,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_2^+')
xlabel('k')

figure(6)
plot(1:n,x(3,1:n),'k',1:n,hat_x_ma(3,1:n),'b--');
set(gca,'FontSize',16)
ylabel('x_3^+')
xlabel('k')

figure(7)
plot(1:n,hat_x_ma(4,1:n),'b--');
axis([0 n -1 1]);
set(gca,'FontSize',16)
ylabel('x_4^+')
xlabel('k')

figure(8)
plot(1:n,hat_x_ma(5,1:n),'b--');
axis([0 n -1 1]);
set(gca,'FontSize',16)
ylabel('x_5^+')
xlabel('k')

hat_x_ma(4,end)

hat_x_ma(5,end)


