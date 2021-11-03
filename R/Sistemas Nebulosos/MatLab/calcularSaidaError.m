function [Result, ResultOmega, Resultz, Resultys] = calcularSaidaError(X, nVariaveis, nGaussianas, nPontos, c, sigma, p, q)
  
		Result = SaidaError;
		ResultOmega = zeros(nGaussianas);
		Resultz = zeros(nGaussianas);
		Resultys = zeros(nPontos);
		ysd = zeros(nPontos);
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
				tmp = ResultOmega(j) * Resultz(j);
				ysn += tmp;
				ysd(k) += ResultOmega(j);
			end;

			Resultys(k) = ysn / ysd(k);
		end;
		Result.denom = ysd(1);
end;

