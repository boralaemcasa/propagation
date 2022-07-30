function [x_hat,traco] = UKF2(xini,y,u,s,m,N,H,h,G,m1,m2,t)
    na = s+s+m; % dimensão do vetor de estados aumentado
    alpha = 1;
    beta = 2;
    kappa = 0;
    lambda = (alpha^2)*(kappa + na) - na;
    x_hat = zeros(na,N);
    x_hat(1:8,1) = xini;
    y_hat = zeros(m,N);
    Q = eye(s)*10;
    R = eye(m);
    P = eye(s)*1e2;
    
    Pa = zeros(na,na);
    for i = 1:s
        Pa(i,i) = P(i,i);
        Pa(s+i,s+i) = Q(i,i);
    end
    for i = 1:m
        Pa(2*s+i,2*s+i) = R(i,i);
    end
    
    w_m = eye(2*na+1)./(2*(na+lambda));
    w_m(1,1) = lambda/(na+lambda);
    w_c = ones(2*na+1)./(2*(na+lambda));
    w_c(1) = lambda/(na+lambda) + 1 - alpha^2 + beta;
    
    traco = [];
    for LLL = 1:N-1
        k = LLL + 1;
        % criar pontos sigma
        X = zeros(na,2*na+1);
        X(:,1) = x_hat(:,k-1);
        aux = sqrt(na + lambda)*chol(Pa);
        for ii = 1:na
            i = ii + 1;
            X(:,i) = x_hat(:,k-1) + aux(:,i-1);
            X(:,i+na) = x_hat(:,k-1) - aux(:,i-1);
        end
        % propagation
        X = fF2(X,s,h,G,m1,m2,t);
        for i = 1:2*na+1
            Y(:,i) = H * X(1:8,i) + eye(2) * X(na-1:na,i); 
        end
        
        for i = 1:2*na+1
            x_hat(:,k) = x_hat(:,k) + X(:,i)*w_m(i,i);
            y_hat(:,k) = y_hat(:,k) + Y(:,i)*w_m(i,i);
        end
        
        P = zeros(s,s);
        Pyy = zeros(m,m);
        Pxy = zeros(s,m);
        %covariances
        for i = 1:2*na+1
            xx = X(1:s,i)-x_hat(1:s,k);
            yy = Y(:,i)-y_hat(:,k);
            P   = P + w_c(i)*xx*xx';
            Pyy = Pyy + w_c(i)*yy*yy';
            Pxy = Pxy + w_c(i)*xx*yy';
        end
        Ka = Pxy * inv(Pyy);
        x_hat(1:s,k) = x_hat(1:s,k) + Ka * (y(:,k) - y_hat(:,k));
        P = P - Ka * Pyy * Ka';
        Pa(1:s,1:s) = P;
        traco = [traco trace(P)];
        end