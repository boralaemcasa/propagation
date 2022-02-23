function [ResultOmega, Resultz, Resultys] = calcularSaidaError(X, nVariaveis, nGaussianas, c, sigma, p, q)
    nPontos = length(X(:,1));
	ResultOmega = zeros(nGaussianas,1);
	Resultz = zeros(nGaussianas,1);
	Resultys = zeros(1,nPontos);
	ysd = zeros(nPontos,1);
	tmp = 0;
    ysn = 0;
	for k = 1:nPontos
		ysn = 0;
		ysd(k) = 0;
		for j = 1:nGaussianas
			ResultOmega(j) = 1.0;
			Resultz(j) = q(j);
			for v = 1:nVariaveis
				tmp = gauss(X(k, v), c(j, v), sigma(j, v));
				ResultOmega(j) = ResultOmega(j) * tmp;
				tmp = p(j, v) * X(k, v);
				Resultz(j) = Resultz(j) + tmp;
			end;
            if ResultOmega(j) == 0
                ResultOmega(j) = 1;
            end
			tmp = ResultOmega(j) * Resultz(j);
			ysn = ysn + tmp;
			ysd(k) = ysd(k) + ResultOmega(j);
		end;

		Resultys(1,k) = ysn / ysd(k);
	end;
end
