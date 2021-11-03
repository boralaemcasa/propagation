function [obj, objq, objp, objsigma, objSaidays] = calcularAPE(alpha, nEpocas, nPontosT, nPontosV, xt, xv, ydt, ydv, nVariaveis, nGaussianas,	xit, xft, normalizar, limitar, copiar)
    
    resultDefined = false;
    apeAnt = 1e100;
		tmp = Interval;
		dq(nGaussianas) = Interval;
		dp(nGaussianas, nVariaveis) = Interval;
		dc(nGaussianas, nVariaveis) = Interval;
		dsigma(nGaussianas, nVariaveis) = Interval;

		obj = AverageInterval;
    Result = AverageInterval  ;  
		obj.alpha = Interval;
    obj.alpha = alpha;
		objq(nGaussianas) = Interval;
		objp(nGaussianas, nVariaveis) = Interval;
		objc(nGaussianas, nVariaveis) = Interval;
		objsigma(nGaussianas, nVariaveis) = Interval;
		tmp.min = (xft.min - xit.min) / (nGaussianas - 1.0);
		tmp.max = (xft.max - xit.max) / (nGaussianas - 1.0);
		for k = 1:nGaussianas
			objq(k) = Interval;
      objq(k).min = rand;
			objq(k).max = objq(k).min;
			for v = 1:nVariaveis
				objp(k, v) = Interval;
        objp(k, v).min = rand;
				objp(k, v).max = objp(k, v).min;
				interval = interval_timesConstant(tmp, k);
				objc(k, v) = interval_plus(xit, interval);
				objsigma(k, v) = interval_timesConstant(tmp, 0.5 / sqrt(2.0 * log(2.0)));
			end;
		end;

		##obj.saida = null;
		dysdyj = Interval;
    dyjdpij = Interval;
		for obj.epocas = 1:nEpocas
      disp('epoca');
      obj.epocas
  		shuffle = (1:1:nPontosT);
			for k = 1:1000 ## mil embaralhadas
				j = mod(round(rand * 1000000.0), nPontosT) + 1;
				v = mod(round(rand * 1000000.0), nPontosT) + 1;
				t = shuffle(v);
				shuffle(v) = shuffle(j);
				shuffle(j) = t;
			end;

			for k = 1:nPontosT
			  if mod(k, 10) == 0
          k
        end;
				[obj.saida, objSaidaOmega, objSaidaz, objSaidays] = calcularSaidaInterval(xt(shuffle(k)), nVariaveis, nGaussianas, 1, objc, objsigma, objp, objq);
				max = 0.0;
				for j = 1:nGaussianas
					dysdwj = interval_minus(objSaidaz(j), objSaidays(1));
					dysdwj = interval_over(dysdwj, obj.saida.denom);
					dysdyj = objSaidaOmega(j);
					dedys = interval_minus(objSaidays(1), ydt(shuffle(k)));
					if normalizar
              dedys.min /= abs(dedys.min);
						dedys.max /= abs(dedys.max);
					end ;
					for v = 1:nVariaveis
						sq = interval_square(objsigma(j, v));
						cub = interval_cube(objsigma(j, v));
						difx = interval_minus(xt(shuffle(k), v), objc(j, v));
						interval = interval_times(objSaidaOmega(j), difx);
						dwjdcij = interval_over(interval, sq);
						difx = interval_square(difx);
						dwjdsij = interval_over(interval, cub);
						dyjdpij = xt(shuffle(k), v);

						tmp = interval_times(dedys, dysdwj);
						dc(j, v) = interval_times(tmp, dwjdcij);
						tmp.min = interval_avg(dc(j, v));
						if tmp.min > max
							max = tmp.min;
            end;

						tmp = interval_times(dedys, dysdwj);
						dsigma(j, v) = interval_times(tmp, dwjdsij);
						tmp.min = interval_avg(dsigma(j, v));
						if tmp.min > max
							max = tmp.min;
            end;

						tmp = interval_times(dedys, dysdyj);
						dp(j, v) = interval_times(tmp, dyjdpij);
						tmp.min = interval_avg(dp(j, v));
						if tmp.min > max
							max = tmp.min;
            end;
					end; ##v
					dq(j) = interval_times(dedys, dysdyj);
					tmp.min = interval_avg(dq(j));
					if tmp.min > max
						max = tmp.min;
          end;
				end; ##j
        
				if limitar && (max > 100.0)
					alpha = interval_timesConstant(alpha, 0.01);
        end;
				for j = 1:nGaussianas
					for v = 1:nVariaveis
						tmp = interval_times(alpha, dc(j, v));
						objc(j, v) = interval_minus(objc(j, v), tmp);
						tmp = interval_times(alpha, dsigma(j, v));
						objsigma(j, v) = interval_minus(objsigma(j, v), tmp);
						tmp = interval_times(alpha, dp(j, v));
						objp(j, v) = interval_minus(objp(j, v), tmp);
					end; ##v
					tmp = interval_times(alpha, dq(j));
					objq(j) = interval_minus(objq(j), tmp);
				end; ##j
			end; ##k
			if copiar
				[obj.saida, objSaidaOmega, objSaidaz, objSaidays] = calcularSaidaInterval(xv, nVariaveis, nGaussianas, nPontosV, objc, objsigma, objp,	objq);
				obj.ape = 0.0;
				for v = 1:nPontosV
					tmp.max = interval_avg(objSaidays(v));
					if tmp.max ~= 0.0
						tmp.min = (tmp.max - interval_avg(ydv(v))) / tmp.max;
						obj.ape += abs(tmp.min);
					end;
				end ;
				obj.ape /= nPontosV / 100.0;
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
			end; ##copiar
		end;

		if copiar && resultDefined
			obj = result;
			objq = resultq;
			objp = resultp;
			objsigma = resultsigma;
    end;
		[obj.saida, objSaidaOmega, objSaidaz, objSaidays] = calcularSaidaInterval(xv, nVariaveis, nGaussianas, nPontosV, objc, objsigma, objp, objq);
		obj.ape = 0.0;
		for k = 1:nPontosV
			tmp.max = interval_avg(objSaidays(k));
			if tmp.max ~= 0.0
				tmp.min = (tmp.max - interval_avg(ydv(k))) / tmp.max;
				obj.ape += abs(tmp.min);
			end;
		end; ##k
		obj.ape /= nPontosV / 100.0;
    disp('obj.ape');
		obj.ape
end;

