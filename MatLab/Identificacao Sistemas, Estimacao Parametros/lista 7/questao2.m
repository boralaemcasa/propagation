% o código vai além do relatório.
% win10 está com timestamps dando pau.
close all;
clear all;
clc;

n = 1000;
t2 = 1:1:n; % time vector

% input
u = prbs(n,12,1);
u = u - mean(u);
u = 2 * u;

writematrix(u, 'u.csv');

%w(k) = y(k) + theta(4) y(k - 1) - \nu(k)
%z(k) = theta(3) u(k) + theta(4) u(k - 1)
%w(k) - theta(1) w(k - 1) - theta(2) w(k - 2) = theta(3) z(k - 1) + theta(4) z(k - 2)
for rep = 1:200
    nu = sqrt(0.1) * randn(1,n);

    theta = [1.5 -0.7 1 0.5];

    e = 0;
    for k = 2:n
        e(k) = 0.5 * e(k - 1) + nu(k);
    end
    y = [0 0];
    for k = 3:n
        y(k) = theta(1) * y(k - 1) + theta(2) * y(k - 2) + theta(3) * u(k - 1) + theta(4) * u(k - 2) + e(k);
    end
    
    Psi = [];
    for k = 3:n
        Psi = [Psi; y(k-1) y(k-2) u(k - 1) u(k - 2)];
    end

    V = y(3:n)';
    Theta(rep,:) = pinv(Psi) * V;
    
    % monta matriz de instrumentos 
    y1pf = Psi * Theta(rep,:)';
    Z2 = [y1pf(2:997) y1pf(1:996) u(2:997)' u(1:996)'];
	Z= [u(1:996)' u(2:997)' u(3:998)' u(4:999)'];

    ThetaE(rep,:) = inv(Z'*Psi(2:997,:))*Z'*V(2:997);  
    ThetaE2(rep,:) = inv(Z2'*Psi(2:997,:))*Z2'*V(2:997);  
end
for k = 1:4
    fprintf("Polarização yu = %.8f\n", theta(k) - mean(ThetaE(:,k)))
    fprintf("Variância yu = %.8f\n", var(ThetaE(:,k)))
end
for k = 1:4
    fprintf("Polarização uu = %.8f\n", theta(k) - mean(ThetaE2(:,k)))
    fprintf("Variância uu = %.8f\n", var(ThetaE2(:,k)))
end

figure(1)
histogram(ThetaE(:,1));
set(gca,'FontSize',18)
xlabel('\theta(1)')
ylabel('Freq yu');

figure(3)
histogram(ThetaE(:,2));
set(gca,'FontSize',18)
xlabel('\theta(2)')
ylabel('Freq yu');

figure(5)
histogram(ThetaE(:,3));
set(gca,'FontSize',18)
xlabel('\theta(3)')
ylabel('Freq yu');

figure(7)
histogram(ThetaE(:,4));
set(gca,'FontSize',18)
xlabel('\theta(4)')
ylabel('Freq yu');
