function [m, cols, V] = fsPearson(nVariaveis, xt, ydt, constContribGlobal, h)
    V = [];
    constPCA = 0.90;
    global St;
    global St2;
    constContrib = constContribGlobal/nVariaveis;
    xt = [xt, ydt, ydt^2];
    n = size(xt, 2);
    St = St + xt;
    Mt = St/h; % mean(xt,1)

	for i = 1:n
		for j = i:n
			St2(i,j) = St2(i,j) + xt(:,i) * xt(:,j);
		end
		for j = 1:i-1
			St2(i,j) = St2(j,i);
		end
	end
        
    if h == 1
        m = nVariaveis;
        cols = 1:m;
        return;
    end
    Mt2 = St2/h;

	% C = cov(xt)
	for i = 1:n
		for j = i:n
			C(i,j) = Mt2(i,j) - Mt(i) * Mt(j);
		end
		for j = 1:i-1
			C(i,j) = C(j,i);
		end
	end

	cols = 1:nVariaveis;
	for i = 1:nVariaveis
		R1(i) = C(i,n-1);
        denom = C(i,i) * C(n-1,n-1);
        if denom ~= 0
    		R1(i) = R1(i)/sqrt(denom);
        end
		R2(i) = C(i,n);
        denom = C(i,i) * C(n,n);
        if denom ~= 0
    		R2(i) = R2(i)/sqrt(denom);
        end
	end
	contribuicao = max(abs(R1),abs(R2));
    contribuicao = contribuicao/sum(contribuicao);
	for i = 1:nVariaveis
		if contribuicao(i) <= constContrib
			cols(i) = 0;
		end
	end		
    cols = notnull(cols);
	m = size(cols,2);
end