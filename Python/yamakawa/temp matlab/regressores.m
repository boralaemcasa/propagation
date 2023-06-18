function theta = regressores(Psi, y, flagEMQ)
    if ~flagEMQ
        theta = pinv(Psi) * y;
    else
        % Algoritmo recursivo EMQ
        lambda = 1; %0.99;
        [m, n] = size(Psi);
        P = eye(n+1)*10^6;
        theta = zeros(n+1,1);
        csi_k = 0;
        for k = 2:m+1
           psi_k = [Psi(k-1,:), csi_k]';
           K_k = (P*psi_k)/(psi_k'*P*psi_k+lambda);
           theta(:,k)=theta(:,k-1)+K_k*(y(k-1)-psi_k'*theta(:,k-1));
           P=(P-(P*psi_k*psi_k'*P)/(psi_k'*P*psi_k+lambda))/lambda;
           csi_k = y(k-1) - psi_k'*theta(:,k);
        end;
        theta = theta(1:n,end);
    end
end