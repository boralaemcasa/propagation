close all;
clear all;
clc;

n = 1000;
t2 = 1:1:n; % time vector

% input
u = prbs(n,12,1);
u = u - mean(u);
u = 2 * u;

figure(5);
plot(t2, u);
set(gca,'FontSize',18)
xlabel('k')
ylabel('u');

writematrix(u, 'u.csv');

% ARMAX
% Ay = Bu + C nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + c(1) nu(k) +
% c(2) nu(k - 1)
fprintf("ARMAX\n");
tic
Theta = [];
rep = 1;
while size(Theta, 1) < 200
    nu = randn(1,n);
    nu = nu/std(nu) * sqrt(0.1);

    theta = [1.5 -0.7 1 0.5 0.8];

    if rep == 1
        figure(6);
        plot(t2, nu);
        set(gca,'FontSize',18)
        xlabel('k')
        ylabel('\nu');
    end

    y = [0 0];
    for k = 3:n
        y(k) = theta(1) * y(k-1) + theta(2) * y(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2) + nu(k) + theta(5) * nu(k - 1);
    end
    
    if rep == 1
        figure(7);
        plot(t2, y);
        set(gca,'FontSize',18)
        xlabel('k')
        ylabel('y');
    end
    
    Psi = [];
    for k = 3:n
        Psi = [Psi; y(k-1) y(k-2) u(k - 1) u(k - 2)];
    end
    
    lambda=1;%0.99;
    
    % Algoritmo recursivo MQ
%    P=eye(4)*10^6;
%    teta = zeros(4,2);
%     for k=3:n
%        psi_k=[y(k-1); y(k-2); u(k - 1); u(k - 2)];
%        K_k = (P*psi_k)/(psi_k'*P*psi_k+lambda);
%        teta(:,k)=teta(:,k-1)+K_k*(y(k)-psi_k'*teta(:,k-1));
%        P=(P-(P*psi_k*psi_k'*P)/(psi_k'*P*psi_k+lambda))/lambda;
%     end;
    
    % Algoritmo recursivo EMQ
%     P=eye(5)*10^6;
%     teta = zeros(5,2);
%     csi_k = 0;
%     for k=3:n
%        psi_k=[y(k-1); y(k-2); u(k - 1); u(k - 2); csi_k];
%        K_k = (P*psi_k)/(psi_k'*P*psi_k+lambda);
%        teta(:,k)=teta(:,k-1)+K_k*(y(k)-psi_k'*teta(:,k-1));
%        P=(P-(P*psi_k*psi_k'*P)/(psi_k'*P*psi_k+lambda))/lambda;
%        csi_k = y(k) - psi_k'*teta(:,k);
%     end;
    
    % VI
%     M_k=1e6 * eye(5);
%     teta = zeros(5,2);
%     ypf = [0 0];
%     csi_k = 0;
%     for k=3:n
%        psi_k=[y(k-1); y(k-2); u(k - 1); u(k - 2); csi_k];
%        z_k = [ypf(k - 2); ypf(k - 1); u(k - 2); u(k - 1); u(k)];
%        M_k = M_k - M_k * z_k * inv(1 + psi_k'*M_k*z_k) * psi_k'*M_k;
%        K_k = M_k * z_k;
%        teta(:,k)=teta(:,k-1)+K_k*(y(k)-psi_k'*teta(:,k-1));
%        csi_k = y(k) - psi_k'*teta(:,k);
%        ypf(k) = psi_k' * teta(:,k);
%     end;
    
    %Aproximação Estocástica
    P=eye(5)*10^6;
    teta = zeros(5,2);
    csi_k = 0;
    alpha = 0.99;
    C = 0.25;
    for k=3:n
       psi_k=[y(k-1); y(k-2); u(k - 1); u(k - 2); csi_k];
       gamma_k = C * k^(-alpha);
       K_k = gamma_k * psi_k;
       teta(:,k)=teta(:,k-1)+K_k*(y(k)-psi_k'*teta(:,k-1));
       csi_k = y(k) - psi_k'*teta(:,k);
    end;

    if rep == 1        
        t = 1:1000;
        figure(1);
        plot(t, teta(1,:));
        set(gca,'FontSize',18)
        xlabel('k')
        ylabel('\theta(1)');

        figure(2);
        plot(t, teta(2,:));
        set(gca,'FontSize',18)
        xlabel('k')
        ylabel('\theta(2)');

        figure(3);
        plot(t, teta(3,:));
        set(gca,'FontSize',18)
        xlabel('k')
        ylabel('\theta(3)');

        figure(4);
        plot(t, teta(4,:));
        set(gca,'FontSize',18)
        xlabel('k')
        ylabel('\theta(4)');
        
        figure(13);
        plot(t, teta(5,:));
        set(gca,'FontSize',18)
        xlabel('k')
        ylabel('\theta(5)');
    end
    
    if ~isnan(teta(:,end))
        Theta = [Theta ; teta(:,end)'];
        rep = rep + 1;
    end
end
toc

for k = 1:5
    fprintf("Polarização yu = %.8f\n", theta(k) - mean(Theta(:,k)))
    fprintf("Variância yu = %.8f\n", var(Theta(:,k)))
end

figure(8)
histogram(Theta(:,1));
set(gca,'FontSize',18)
xlabel('\theta(1)')
ylabel('Freq yu');

figure(9)
histogram(Theta(:,2));
set(gca,'FontSize',18)
xlabel('\theta(2)')
ylabel('Freq yu');

figure(10)
histogram(Theta(:,3));
set(gca,'FontSize',18)
xlabel('\theta(3)')
ylabel('Freq yu');

figure(11)
histogram(Theta(:,4));
set(gca,'FontSize',18)
xlabel('\theta(4)')
ylabel('Freq yu');

figure(12)
histogram(Theta(:,5));
set(gca,'FontSize',18)
xlabel('\theta(5)')
ylabel('Freq yu');
