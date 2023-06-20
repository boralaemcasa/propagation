function [m, cols, V] = fsPCA(nVariaveis, xt, ydt, constContribGlobal, h)
    constPCA = 0.90;
    global St;
    global St2;
    xt = duplo(xt);
    nVariaveis = size(xt, 2);
    St = St + xt;
    Mt = St/h; % mean(xt,1)

	for i = 1:nVariaveis
		for j = i:nVariaveis
			St2(i,j) = St2(i,j) + xt(:,i) * xt(:,j);
		end
		for j = 1:i-1
			St2(i,j) = St2(j,i);
		end
	end
        
    if h == 1
        m = nVariaveis;
        cols = 1:m;
        V = eye(nVariaveis);
        return;
    end
    Mt2 = St2/h;

	% C = cov(xt)
	for i = 1:nVariaveis
		for j = i:nVariaveis
			C(i,j) = Mt2(i,j) - Mt(i) * Mt(j);
		end
		for j = 1:i-1
			C(i,j) = C(j,i);
		end
	end
%     [V,D] = qdwheig(C,[],0);
%     d = diag(D);
    [V,d] = eig(C,'vector');
    d = d/sum(d);
    d = sort(d, 'desc');
    m = min(find(cumsum(d) >= constPCA));
    V = real(V(:,end-m+1:end));
    cols = 1:m;
end