function [m, cols, V] = fs2Pearson(nVariaveis, xt, ydt, constContribGlobal, h)
    V = [];
    constPCA = 0.90;
    global St;
    global St2;
    constContrib = constContribGlobal/nVariaveis;
    xt = [xt, ydt, ydt.^2];
    n = size(xt, 2);
    St = St + xt;
    Mt = St/h; % mean(xt,1)

    for k = 1:2
        for i = 1:n
            for j = i:n
                St2(i,j,k) = St2(i,j,k) + xt(k,i) .* xt(k,j);
            end
            for j = 1:i-1
                St2(i,j,k) = St2(j,i,k);
            end
        end
    end
        
    if h == 1
        m = nVariaveis;
        cols = 1:m;
        return;
    end
    Mt2 = St2/h;

	% C = cov(xt)
    for k = 1:2
        for i = 1:n
            for j = i:n
                C(i,j,k) = Mt2(i,j,k) - Mt(k,i) * Mt(k,j);
            end
            for j = 1:i-1
                C(i,j,k) = C(j,i,k);
            end
        end
    end

	cols = 1:nVariaveis;
    for k = 1:2
        for i = 1:nVariaveis
            R1(k,i) = C(i,n-1,k);
            denom = C(i,i,k) * C(n-1,n-1,k);
            if denom ~= 0
                R1(k,i) = R1(k,i)/sqrt(denom);
            end
            R2(k,i) = C(i,n,k);
            denom = C(i,i,k) * C(n,n,k);
            if denom ~= 0
                R2(k,i) = R2(k,i)/sqrt(denom);
            end
        end
    end
	contribuicao = max(abs(R1),abs(R2));
    contribuicao = mean(contribuicao, 1);
    contribuicao = contribuicao/sum(contribuicao);
	for i = 1:nVariaveis
		if contribuicao(i) <= constContrib
			cols(i) = 0;
		end
	end		
    cols = notnull(cols);
	m = size(cols,2);
end