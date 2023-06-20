function [i, K] = metodoPLSbetaOnline(nVariaveis, xt, ydt, h, constContribGlobal)
    global RSE; %bpls
    for ell = 1:size(ydt,1)
        y = ydt;
        X = xt;
        constContrib = constContribGlobal/nVariaveis;
        for K = 1:nVariaveis
            w = ydt(ell)' * xt(ell,:) / (ydt(ell)' * ydt(ell));
            w = w' / norm(w);
            t = X * w / (w' * w);
            p = t' * X / (t' * t);
            if sum(isnan(p)) > 0
                break;
            end
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

        RSE(:,ell) = RSE(:,ell) + W * pinv(P' * W) * pinv(T' * T) * T' * ydt   ;
        % yhat = xt(h,:) * RSE;
        % xi = ydt(h) - yhat;
        % sum(xi.^2)
    end
    bpls = RSE/h; 
    bpls = mean(bpls, 2);
    contribuicao = abs(bpls);
    cols = 1:nVariaveis;
    if h > 1
        contribuicao = contribuicao/sum(contribuicao); % ou sobre o max
        for i = 1:nVariaveis
            if contribuicao(i) <= constContrib
                cols(i) = 0;
            end
        end		
    end
    K = notnull(cols);
    i = size(K,2);
end