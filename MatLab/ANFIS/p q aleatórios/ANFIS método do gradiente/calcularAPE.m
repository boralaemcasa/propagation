function [obj, objc, objq, objp, objsigma, objSaidays, error] = calcularAPE(alpha, nEpocas, xt, xv, ydt, ydv, nVariaveis, nGaussianas, expMinusInfty, normalizar, limitar, copiar)
    error = zeros(nEpocas,1);
    nPontosT = length(xt(:,1));
    nPontosV = length(xv(:,1));
    resultDefined = false;
    apeAnt = 1e100;
	dq = zeros(nGaussianas,1);
	dp = zeros(nGaussianas, nVariaveis);
	dc = zeros(nGaussianas, nVariaveis);
	dsigma = zeros(nGaussianas, nVariaveis);

	obj = AverageError;
    Result = AverageError;  
    obj.alpha = alpha;
	objq = zeros(nGaussianas,1);
	objp = zeros(nGaussianas, nVariaveis);
	objc = zeros(nGaussianas, nVariaveis);
	objsigma = zeros(nGaussianas, nVariaveis);
	for v = 1:nVariaveis
        m = min(-xt(:,v)); % - max
        tmp(v) = (-m - min(xt(:,v))) / (nGaussianas - 1.0);
    end
	for k = 1:nGaussianas
		objq(k) = rand;
		for v = 1:nVariaveis
			objp(k, v) = rand;
			interval = tmp(v) * k;
			objc(k, v) = min(xt(:,v)) + interval;
			objsigma(k, v) = tmp(v) * (0.5 / sqrt(2.0 * log(2.0)));
		end;
	end;

	%obj.saida = null;
	dysdyj = 0;
    dyjdpij = 0;
	for epocas = 1:nEpocas
        obj.epocas = epocas;
		%disp('epoca');
		%obj.epocas
		shuffle = (1:1:nPontosT);
		for k = 1:1000 % mil embaralhadas
			j = mod(round(rand * 1000000.0), nPontosT) + 1;
			v = mod(round(rand * 1000000.0), nPontosT) + 1;
			t = shuffle(v);
			shuffle(v) = shuffle(j);
			shuffle(j) = t;
		end;

		for k = 1:nPontosT
			%if mod(k, 10) == 0
			%	k
			%end;
			[obj.saida, objSaidaOmega, objSaidaz, objSaidays(1,k)] = calcularSaidaError(xt(shuffle(k),:), nVariaveis, nGaussianas, expMinusInfty, objc, objsigma, objp, objq);
			max = 0.0;
			for j = 1:nGaussianas
				dysdwj = objSaidaz(j) - objSaidays(1,k);
				dysdwj = dysdwj/obj.saida.denom;
				dysdyj = objSaidaOmega(j);
				dedys = objSaidays(1,k) - ydt(shuffle(k));
				if normalizar
					dedys = dedys/abs(dedys);
				end ;
				for v = 1:nVariaveis
					sq = square(objsigma(j, v));
					cub = cube(objsigma(j, v));
					difx = xt(shuffle(k), v) - objc(j, v);
					interval = objSaidaOmega(j) * difx;
					dwjdcij = interval / sq;
					difx = square(difx);
					dwjdsij = interval / cub;
					dyjdpij = xt(shuffle(k), v);

					tmp = dedys * dysdwj;
					dc(j, v) = tmp * dwjdcij;
					tmp = dc(j, v);
					if tmp > max
						max = tmp;
					end;

					tmp = dedys * dysdwj;
					dsigma(j, v) = tmp * dwjdsij;
					tmp = dsigma(j, v);
					if tmp > max
						max = tmp;
					end;

					tmp = dedys * dysdyj;
					dp(j, v) = tmp * dyjdpij;
					tmp = dp(j, v);
					if tmp > max
						max = tmp;
					end;
				end; %v
				dq(j) = dedys * dysdyj;
				tmp = dq(j);
				if tmp > max
					max = tmp;
				end;
			end; %j
			
			if limitar && (max > 100.0)
				alpha = alpha * 0.01;
			end;
			for j = 1:nGaussianas
				for v = 1:nVariaveis
					tmp = alpha * dc(j, v);
					objc(j, v) = objc(j, v) - tmp;
					tmp = alpha * dsigma(j, v);
					objsigma(j, v) = objsigma(j, v) - tmp;
					tmp = alpha * dp(j, v);
					objp(j, v) = objp(j, v) - tmp;
				end; %v
				tmp = alpha * dq(j);
				objq(j) = objq(j) - tmp;
			end; %j
            error(epocas) = error(epocas) + 0.5 * (ydt(k) - objSaidays(1,k))^2;
		end; %k

		if copiar
            objSaidays = zeros(1,nPontosV);
			[obj.saida, objSaidaOmega, objSaidaz, objSaidays(1,:)] = calcularSaidaError(xv, nVariaveis, nGaussianas, expMinusInfty, objc, objsigma, objp,	objq);
			obj.ape = 0.0;
			for v = 1:nPontosV
				tmp = objSaidays(1,v);
				if tmp ~= 0.0
					tmp = (tmp - ydv(v)) / tmp;
					obj.ape = obj.ape + abs(tmp);
				end;
			end ;
			obj.ape = obj.ape / nPontosV * 100.0;
			if (obj.ape ~= round(obj.ape)) && (obj.ape < apeAnt) | (obj.epocas ==0)
			  resultDefined = true;
				result = obj;
				resultq = objq;
				resultp = objp;
				resultsigma = objsigma;
				apeAnt = obj.ape;
			else if resultDefined
				obj = result;
				objq = resultq;
				objp = resultp;
				objsigma = resultsigma;
			end;
		end; %copiar
	end;

		if copiar && resultDefined
			obj = result;
			objq = resultq;
			objp = resultp;
			objsigma = resultsigma;
    end; %epocas
	
	[obj.saida, objSaidaOmega, objSaidaz, objSaidays] = calcularSaidaError(xv, nVariaveis, nGaussianas, expMinusInfty, objc, objsigma, objp, objq);
	obj.ape = 0.0;
	for k = 1:nPontosV
		tmp = objSaidays(1,k);
		if tmp ~= 0.0
			tmp = (tmp - ydv(k)) / tmp;
			obj.ape = obj.ape + abs(tmp);
		end;
	end; %k
	obj.ape = obj.ape / nPontosV * 100.0;
    %disp('obj.ape');
	%obj.ape
end;
