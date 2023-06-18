function [theta, P, RSE] = regressores2(n, total, Psi, y, P, theta, RSE)
    % Algoritmo recursivo EMQ
    lambda = 1; %0.99;
    theta = theta(1:n);
    if norm(theta) == 0
        P = eye(n)*10^6;
    else
        P = P(1:n,1:n);
    end
    psi_k = Psi';
    K_k = (P*psi_k)/(psi_k'*P*psi_k+lambda);
    theta =theta + K_k * (y - psi_k' * theta);
    P = (P - (P * psi_k * psi_k' * P)/(psi_k' * P * psi_k + lambda))/lambda;
    csi_k = y - psi_k' * theta;
    RSE = RSE + csi_k^2;
    theta = theta(1:n,end);
    theta = [theta; zeros(total-n,1)];
    P = [P ; zeros(total-n,n)];
    P = [P zeros(total,total-n)]; 
end