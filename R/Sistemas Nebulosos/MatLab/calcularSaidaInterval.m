function [Result, ResultOmega, Resultz, Resultys] = calcularSaidaInterval(X, nVariaveis, nGaussianas, nPontos, c, sigma, p, q)

		Result = SaidaInterval;
		ResultOmega(nGaussianas) = Interval;
		Resultz(nGaussianas) = Interval;
		Resultys(nPontos) = Interval;
		ysd(nPontos) = Interval;
		tmp = Interval;
    ysn = Interval;
		for k = 1:nPontos
			ysn.min = 0;
      ysn.max = 0;
			ysd(k) = Interval;
			ysd(k).min = 0;
      ysd(k).max = 0;
			for j = 1:nGaussianas
				ResultOmega(j) = Interval;
        ResultOmega(j).min = 1.0;
        ResultOmega(j).max = 1.0;
				Resultz(j) = q(j);
				for v = 1:nVariaveis
					tmp = interval_gauss(X(k, v), c(j, v), sigma(j, v));
					ResultOmega(j) = interval_times(ResultOmega(j), tmp);
					tmp = interval_times(p(j, v), X(k, v));
					Resultz(j) = interval_plus(Resultz(j), tmp);
				end;
				tmp = interval_times(ResultOmega(j), Resultz(j));
				ysn = interval_plus(ysn, tmp);
				ysd(k) = interval_plus(ysd(k), ResultOmega(j));
			end;

			Resultys(k) = interval_over(ysn, ysd(k));
		end;
		Result.denom = ysd(1);
end;

