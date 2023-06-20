function [i, K] = metodoPLS_VIPOnline(nVariaveis, xt, ydt, h)
    global RSE; % vip
    for ell = 1:size(ydt,1)
        y = ydt(ell);
        X = xt(ell,:);
        T = [];
        P = [];
        W = [];
        for K = 1:nVariaveis
            w = ydt(ell)' * xt(ell,:) / (ydt(ell)' * ydt(ell));
            w = w' / norm(w);
            t = X * w / (w' * w);
            p = t' * X / (t' * t);
            t = t * norm(p);
            w = w * norm(p);
            p = p' / norm(p);
            b(K) = y' * t / (t' * t);
            T(:,K) = t;
            P(:,K) = p;
            W(:,K) = w;
            y = y - b(K) * t;
            X = X - t * p';
        end
        % xi = ydt(1:h) - T * b';
        % sum(xi.^2)
        soma = zeros(1,nVariaveis);
        denom = 0;
        for K = 1:nVariaveis
            for i = 1:nVariaveis
                soma(i) = soma(i) + b(K)^2 * T(:,K)' * T(:,K) * (W(i,K) / norm(W(:,K)))^2;
            end
            denom = denom + b(K)^2 * T(:,K)' * T(:,K);
        end
        RSE(ell,:) = RSE(ell,:) + sqrt(nVariaveis * soma / denom);
    end
	vip = RSE/h;
    vip = mean(vip,1);
	K = 1:nVariaveis;
    if h > 1
        for i = 1:nVariaveis
            if vip(i) <= 1
                K(i) = 0;
            end
        end
    end
	a = notnull(K);
	i = size(a,2);
end