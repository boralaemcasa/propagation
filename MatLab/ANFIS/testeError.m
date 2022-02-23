function [error, g] = testeError(x)
    g = 0;
    global nG;
    global nV;
    global X;
    global Y;
    nPontos = length(X(:,1));
    i = 1;
    for j = 1:nG
		for v = 1:nV
            c(j,v) = x(i);
            i = i + 1;
        end
    end
    dc = 0 * c;
    for j = 1:nG
		for v = 1:nV
            sigma(j,v) = x(i);
            i = i + 1;
        end
    end
    dsigma = 0 * sigma;
    for j = 1:nG
		for v = 1:nV
            p(j,v) = x(i);
            i = i + 1;
        end
    end
    dp = 0 * p;
    for j = 1:nG
		q(j) = x(i);
        i = i + 1;
    end
    dq = 0 * q;
	ResultOmega = zeros(nG,1);
	Resultz = zeros(nG,1);
	Resultys = zeros(1,nPontos);
	ysd = zeros(nPontos,1);
	tmp = 0;
    ysn = 0;
    error = 0;
	for k = 1:nPontos
		ysn = 0;
		ysd(k) = 0;
		for j = 1:nG
			ResultOmega(j) = 1.0;
			Resultz(j) = q(j);
			for v = 1:nV
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
        error = error + 0.5 * (Y(k) - Resultys(1,k))^2;
    end
end

