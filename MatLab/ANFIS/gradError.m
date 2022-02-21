function [d, g] = gradError(x)
    g = 0;
    global a;
    nPontos = int64(a(1));
    nGaussianas = int64(a(2));
    nVariaveis = a(3);
    i = 1;
    for j = 1:nGaussianas
		for v = 1:nVariaveis
            c(j,v) = x(i);
            i = i + 1;
        end
    end
    dc = 0 * c;
    for j = 1:nGaussianas
		for v = 1:nVariaveis
            sigma(j,v) = x(i);
            i = i + 1;
        end
    end
    dsigma = 0 * sigma;
    for j = 1:nGaussianas
		for v = 1:nVariaveis
            p(j,v) = x(i);
            i = i + 1;
        end
    end
    dp = 0 * p;
    for j = 1:nGaussianas
		q(j) = x(i);
        i = i + 1;
    end
    dq = 0 * q;
    i = 4;
    for j = 1:nPontos
        for v = 1:nVariaveis
        	X(j,v) = a(i);
            i = i + 1;
        end
    end
    for j = 1:nPontos
		ydt(j) = a(i);
        i = i + 1;
    end
    
	ResultOmega = zeros(nGaussianas,1);
	Resultz = zeros(nGaussianas,1);
	Resultys = zeros(1,nPontos);
	ysd = zeros(nPontos,1);
	tmp = 0;
    ysn = 0;
    error = 0;
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
			ysn = ysn + tmp;
			ysd(k) = ysd(k) + ResultOmega(j);
		end;

		Resultys(1,k) = ysn / ysd(k);
        error = error + (ydt(k) - Resultys(1,k))^2;

        for j = 1:nGaussianas
            dysdwj = Resultz(j) - Resultys(1,k);
            dysdwj = dysdwj/ysd(k);
            dysdyj = ResultOmega(j);
            dedys = Resultys(1,k) - ydt(k);
    %         if normalizar
    %             dedys = dedys/abs(dedys);
    %         end ;
            for v = 1:nVariaveis
                sq = sigma(j, v)^2;
                cub = sigma(j, v)^3;
                difx = X(k, v) - c(j, v);
                interval = ResultOmega(j) * difx;
                dwjdcij = interval / sq;
                difx = difx^2;
                dwjdsij = interval / cub;
                dyjdpij = X(k, v);

                tmp = dedys * dysdwj;
                dc(j, v) = dc(j,v) + tmp * dwjdcij;
                
                tmp = dedys * dysdwj;
                dsigma(j, v) = dsigma(j, v) + tmp * dwjdsij;
                
                tmp = dedys * dysdyj;
                dp(j, v) = dp(j, v) + tmp * dyjdpij;
            end; %v
            dq(j) = dq(j) + dedys * dysdyj;
        end; %j

        d = 0;
        i = 1;
        for j = 1:nGaussianas
            for v = 1:nVariaveis
                d(i) = dc(j,v);
                i = i + 1;
            end
        end
        for j = 1:nGaussianas
            for v = 1:nVariaveis
                d(i) = dsigma(j,v);
                i = i + 1;
            end
        end
        for j = 1:nGaussianas
            for v = 1:nVariaveis
                d(i) = dp(j,v);
                i = i + 1;
            end
        end
        for j = 1:nGaussianas
            d(i) = dq(j);
            i = i + 1;
        end
    end
end
