function [p, q] = calcularPQ(X, Y, nVariaveis, nGaussianas, c, sigma)
    nPontos = length(X(:,1));
	omega = ones(nGaussianas,1);
	q = zeros(nGaussianas, 1);
	p = zeros(nGaussianas, nVariaveis);
	for k = 1:nPontos
		for j = 1:nGaussianas
			for v = 1:nVariaveis
				tmp = gauss(X(k, v), c(j, v), sigma(j, v));
				omega(j) = omega(j) * tmp;
			end;
		end;
        Y(k) = Y(k) * sum(omega);
        i = 1;
		for j = 1:nGaussianas
			for v = 1:nVariaveis
				A(k, i) = omega(j) * X(k, v);
				i = i + 1;
			end;
		end;
        for j = 1:nGaussianas
            A(k, i) = omega(j);
            i = i + 1;
        end;
	end;
    x = lsqr(A, Y);
    i = 1;
    for j = 1:nGaussianas
        for v = 1:nVariaveis
            p(j, v) = x(i);
            i = i + 1;
        end;
    end;
    for j = 1:nGaussianas
        q(j) = x(i);
        i = i + 1;
    end;
end
