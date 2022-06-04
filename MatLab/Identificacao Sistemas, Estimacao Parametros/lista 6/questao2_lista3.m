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

% ARMAX
% Ay = Bu + C nu
% y(k) + a1 y(k-1) + a2 y(k-2) = b1 u(k - 1) + b2 u(k - 2) + c(1) nu(k) +
% c(2) nu(k - 1)
fprintf("ARMAX\n");
for rep = 1:200
    nu = sqrt(0.1) * randn(1,n);

    theta = [1.5 -0.7 1 0.5 0.8];

    y = [0 0];
    for k = 3:n
        y(k) = theta(1) * y(k-1) + theta(2) * y(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2) + nu(k) + theta(5) * nu(k - 1);
    end
    
    Psi = [];
    for k = 3:n
        Psi = [Psi; y(k-1) y(k-2) u(k - 1) u(k - 2)];
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
            if norm(polarizacao(k,:) - polarizacao(k-1,:)) < 1e-4
                break;
            end
        end
    	xi = [0; 0; y(3:n)' - PsiE * ThetaE(rep,:)'];
    end
end
for k = 1:4
    fprintf("Polarização = %.8f\n", theta(k) - mean(ThetaE(:,k)))
    fprintf("Variância = %.8f\n", var(ThetaE(:,k)))
end

figure(1)
histogram(Theta(:,1));
set(gca,'FontSize',18)
xlabel('\theta(1)')
ylabel('Freq MQ');

figure(2)
histogram(ThetaE(:,1));
set(gca,'FontSize',18)
xlabel('\theta(1)')
ylabel('Freq EMQ');

figure(3)
histogram(Theta(:,2));
set(gca,'FontSize',18)
xlabel('\theta(2)')
ylabel('Freq MQ');

figure(4)
histogram(ThetaE(:,2));
set(gca,'FontSize',18)
xlabel('\theta(2)')
ylabel('Freq EMQ');

figure(5)
histogram(Theta(:,3));
set(gca,'FontSize',18)
xlabel('\theta(3)')
ylabel('Freq MQ');

figure(6)
histogram(ThetaE(:,3));
set(gca,'FontSize',18)
xlabel('\theta(3)')
ylabel('Freq EMQ');

figure(7)
histogram(Theta(:,4));
set(gca,'FontSize',18)
xlabel('\theta(4)')
ylabel('Freq MQ');

figure(8)
histogram(ThetaE(:,4));
set(gca,'FontSize',18)
xlabel('\theta(4)')
ylabel('Freq EMQ');

w=0:0.1:pi;
% polinomio C
c1=mean(ThetaE(:,5));
c2=mean(ThetaE(:,6));
Cw=1+c1*exp(j.*w)+c2*exp(j*2.*w);

figure(9)
set(gca,'FontSize',18)
plot(w,real(1./Cw),'k',w,0.5*ones(size(w)),'k--');
axis([0 pi 0.4 0.8])
xlabel('\omega')
ylabel('Re[1/C(e^{j\omega} )]');

% Erro na saída
% Fw = Bu ; y = w + nu
% w(k) + a1 w(k-1) + a2 w(k-2) = b1 u(k - 1) + b2 u(k - 2)
fprintf("OEM\n");
for rep = 1:200
    nu = sqrt(0.1) * randn(1,n);

    theta = [1.5 -0.7 1 0.5];

    w = [0 0];
    for k = 3:n
        w(k) = theta(1) * w(k-1) + theta(2) * w(k-2) + theta(3) * u(k - 1) + theta(4) * u(k - 2);
    end
    y = w + nu;

    Psi = [];
    for k = 3:n
        Psi = [Psi; y(k-1) y(k-2) u(k - 1) u(k - 2)];
    end

    Theta(rep,:) = pinv(Psi) * y(3:n)';
    polarizacao = [];

    xi=y(3:n)' - Psi * Theta(rep,:)';
    xi = [0; xi];
    for k=1:1000 % numero de iteracoes precisa ser suficiente para convergencia
    	PsiE = [Psi xi(2:n-1) xi(1:n-2)];
    	ThetaE(rep,:) = pinv(PsiE) * y(3:n)';
        polarizacao(k,:) = theta - mean(ThetaE(:,1:4),1);
        if k >= 2
            if norm(polarizacao(k,:) - polarizacao(k-1,:)) < 1e-5
                break;
            end
        end
    	xi = [0; 0; y(3:n)' - PsiE * ThetaE(rep,:)'];
    end
end
for k = 1:4
    fprintf("Polarização = %.8f\n", theta(k) - mean(ThetaE(:,k)))
    fprintf("Variância = %.8f\n", var(ThetaE(:,k)))
end

figure(1)
histogram(Theta(:,1));
set(gca,'FontSize',18)
xlabel('\theta(1)')
ylabel('Freq MQ');

figure(2)
histogram(ThetaE(:,1));
set(gca,'FontSize',18)
xlabel('\theta(1)')
ylabel('Freq EMQ');

figure(3)
histogram(Theta(:,2));
set(gca,'FontSize',18)
xlabel('\theta(2)')
ylabel('Freq MQ');

figure(4)
histogram(ThetaE(:,2));
set(gca,'FontSize',18)
xlabel('\theta(2)')
ylabel('Freq EMQ');

figure(5)
histogram(Theta(:,3));
set(gca,'FontSize',18)
xlabel('\theta(3)')
ylabel('Freq MQ');

figure(6)
histogram(ThetaE(:,3));
set(gca,'FontSize',18)
xlabel('\theta(3)')
ylabel('Freq EMQ');

figure(7)
histogram(Theta(:,4));
set(gca,'FontSize',18)
xlabel('\theta(4)')
ylabel('Freq MQ');

figure(8)
histogram(ThetaE(:,4));
set(gca,'FontSize',18)
xlabel('\theta(4)')
ylabel('Freq EMQ');

w=0:0.1:pi;
% polinomio C
c1=mean(ThetaE(:,5));
c2=mean(ThetaE(:,6));
Cw=1+c1*exp(j.*w)+c2*exp(j*2.*w);

figure(9)
set(gca,'FontSize',18)
plot(w,real(1./Cw),'k',w,0.5*ones(size(w)),'k--');
xlabel('\omega')
ylabel('Re[1/C(e^{j\omega} )]');
axis([0 pi 0.4 1.1])
