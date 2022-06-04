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

c1 = 0.3;
c2 = -0.6;

c1 = 1.5;
c2 = -0.7;

for rep = 1:200
    nu = randn(1,n);
    nu = nu/std(nu);
    nu = nu - mean(nu);

    % ARX
    % Ay = Bu + nu
    % y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + nu(k)
    theta = [1.5 -0.7 0.5 c1 c2];

    y = [0 0];
    for k = 3:n
        y(k) = theta(1) * y(k-1) + theta(2) * y(k-2) + theta(3) * u(k - 1) + theta(4) * nu(k - 1) + theta(5) * nu(k - 2) + nu(k);
    end

    Psi = [];
    for k = 3:n
        Psi = [Psi; y(k-1) y(k-2) u(k - 1)];
    end

    Theta(rep,:) = pinv(Psi) * y(3:n)';
    polarizacao = [];

    xi=y(3:n)' - Psi * Theta(rep,:)';
    xi = [0; xi];
    for k=1:1000 % numero de iteracoes precisa ser suficiente para convergencia
    	PsiE = [Psi xi(2:n-1) xi(1:n-2)];
    	ThetaE(rep,:) = pinv(PsiE) * y(3:n)';
        polarizacao(k,:) = theta - mean(ThetaE(:,1:5),1);
        if k >= 2
            if norm(polarizacao(k,:) - polarizacao(k-1,:)) < 1e-9
                break;
            end
        end
    	xi = [0; 0; y(3:n)' - PsiE * ThetaE(rep,:)'];
    end
end
for k = 1:5
    fprintf("Polarização = %.8f\n", theta(k) - mean(ThetaE(:,k)))
    fprintf("Variância = %.8f\n", var(ThetaE(:,k)))
end

figure(1)
histogram(ThetaE(:,1));
set(gca,'FontSize',18)
xlabel('\theta(1)')
ylabel('Freq EMQ');

figure(2)
histogram(ThetaE(:,2));
set(gca,'FontSize',18)
xlabel('\theta(2)')
ylabel('Freq EMQ');

figure(3)
histogram(ThetaE(:,3));
set(gca,'FontSize',18)
xlabel('\theta(3)')
ylabel('Freq EMQ');

figure(4)
histogram(ThetaE(:,4));
set(gca,'FontSize',18)
xlabel('\theta(4)')
ylabel('Freq EMQ');

figure(5)
histogram(ThetaE(:,5));
set(gca,'FontSize',18)
xlabel('\theta(5)')
ylabel('Freq EMQ');

w=logspace(-4,4);
% polinomio C
c1=-mean(ThetaE(:,4));
c2=-mean(ThetaE(:,5));
Cw=1+c1*exp(j.*w)+c2*exp(j*2.*w);

figure(6)
set(gca,'FontSize',18)
semilogx(w,real(1./Cw),'k',w,0.5*ones(size(w)),'k--');
axis([1e-4 1e4 0.45 1.05])
xlabel('\omega')
ylabel('Re[1/C(e^{j\omega} )]');