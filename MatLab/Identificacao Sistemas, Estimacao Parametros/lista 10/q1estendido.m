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
for rep = 1:200
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
        y(:,k + 1) = H * x(:, k + 1) + v(:, k);
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
    %% filtragem de Kalman






    % equacoes do filtro
    % nomenclatura
    % hat_x_me => x chapeu menos (media da distribuicao a priori)
    % P_me => P menos (covariancia da distribuicao a priori)
    % hat_x_ma => x chapeu mais (media da distribuicao a posteriori)
    % P_ma => P mais (covariancia da distribuicao a posteriori)
    % Phim, Gamam e Hm sao as matrizes do modelo implementado no filtro.
    % Usaremos valores levemente diferentes de Phi, Gama e H para representar
    % erros de modelagem. O modelo permanece constante ao longo do experimento,
    % pois o sistema eh invariante no tempo.

    epsilon = 0.1;
    Q=diag([10,10,10,epsilon,epsilon]); % inibir Q em relação a theta
    R=eye(2)*sv;
    Phim=Phim0;
    Gamam=Gamam0;
    Upsilonm=(1+q)*eye(5);
    Hm=[0.5 0.5 0; 0 0 1];

    Phim = [Phim zeros(3,2)];
    Phim = [Phim ; zeros(2,5)];
    Phim(4,4) = 1;
    Phim(5,5) = 1; % antes era 3x3, agora 5x5 colada na identidade

    Gamam = [Gamam zeros(3,3)];
    Gamam = [Gamam ; zeros(2,5)]; % antes era 3x2, agora 5x5

    Hm = [Hm zeros(2,2)]; % antes era 2x3, agora 2x5

    u = [u; zeros(3, n)]; % antes era 2xn, agora 5xn

    Phi=[0.8 -0.4 0.2;0 0.3 -0.5;0 0 0.5];
    Gama=[0 0; 0 -0.5 ;0.5 0];
    Upsilon=eye(3);
    H=[0.5 0.5 0; 0 0 1];

    % inicializacao
    hat_x_ma(:,1)=[0;0;0;0;0];
    P_ma=diag([1e2,1e2,1e2,1e2,1e2]);

    % Equacoes de (9.34)
    for k=1:n-1
        Phim(1,1) = hat_x_ma(4,k);
        Gamam(3,1) = hat_x_ma(5,k);
        Df = Phim;
        Df(1,4) = hat_x_ma(1,k);
        Df(3,5) = u(1,k);
        hat_x_me(:,k+1) = Phim*hat_x_ma(:,k)+Gamam*u(:,k);
        P_me = Df * P_ma * Df' + Upsilonm*Q*Upsilonm';
        K=P_me*Hm'*inv(Hm*P_me*Hm'+R);
        % inovacao 
        eta(:,k+1)=y(:,k+1)-Hm*hat_x_me(:,k+1);
        hat_x_ma(:,k+1)=hat_x_me(:,k+1)+K*eta(:,k+1);
        P_ma=P_me-K*Hm*P_me;
        % traco de P_ma
        traco(k)=trace(P_ma);
    end

    if rep == 1
        figure(3)
        plot(eta(1,:))
        set(gca,'FontSize',16)
        ylabel('\eta_1')

        figure(4)
        plot(eta(2,:))
        set(gca,'FontSize',16)
        ylabel('\eta_2')

        figure(5)
        plot(log10(traco(1:50)))
        set(gca,'FontSize',16)
        xlabel('k')
        ylabel('tr(P)')


        figure(6)
        plot(1:n,x(1,1:n),'k',1:n,hat_x_ma(1,1:n),'b--');
        set(gca,'FontSize',16)
        ylabel('x_1^+')
        xlabel('k')

        figure(7)
        plot(1:n,x(2,1:n),'k',1:n,hat_x_ma(2,1:n),'b--');
        set(gca,'FontSize',16)
        ylabel('x_2^+')
        xlabel('k')

        figure(8)
        plot(1:n,x(3,1:n),'k',1:n,hat_x_ma(3,1:n),'b--');
        set(gca,'FontSize',16)
        ylabel('x_3^+')
        xlabel('k')

        figure(9)
        plot(1:n,hat_x_ma(4,1:n),'b--');
        axis([0 n -1 1]);
        set(gca,'FontSize',16)
        ylabel('x_4^+')
        xlabel('k')

        figure(10)
        plot(1:n,hat_x_ma(5,1:n),'b--');
        axis([0 n -1 1]);
        set(gca,'FontSize',16)
        ylabel('x_5^+')
        xlabel('k')
    end

    Theta = [Theta ; hat_x_ma(4:5,end)'];
end

theta = [0.8; 0.5];

for k = 1:2
    fprintf("Polarização yu = %.8f\n", theta(k) - mean(Theta(:,k)))
    fprintf("Variância yu = %.8f\n", var(Theta(:,k)))
end

figure(11)
histogram(Theta(:,1));
set(gca,'FontSize',18)
xlabel('\theta(1)')
ylabel('Frequência');

figure(12)
histogram(Theta(:,2));
set(gca,'FontSize',18)
xlabel('\theta(2)')
ylabel('Frequência');

theta

Theta(1,:)
