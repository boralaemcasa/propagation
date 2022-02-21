function [objape, objc, objq, objp, objsigma, objSaidays, error] = calcularAPE(xt, xv, ydt, ydv, nVariaveis, nGaussianas)
    nPontosT = length(xt(:,1));
    nPontosV = length(xv(:,1));

	objq = zeros(nGaussianas,1);
	objp = zeros(nGaussianas, nVariaveis);
	objc = zeros(nGaussianas, nVariaveis);
	objsigma = zeros(nGaussianas, nVariaveis);
	for v = 1:nVariaveis
        tmp(v) = (- min(-xt(:,v)) - min(xt(:,v))) / (nGaussianas - 1.0);
    end
	for k = 1:nGaussianas
		objq(k) = 2*rand - 1;
		for v = 1:nVariaveis
			objp(k, v) = 2*rand - 1;
			interval = tmp(v) * k;
			objc(k, v) = min(xt(:,v)) + interval;
			objsigma(k, v) = tmp(v) * (0.5 / sqrt(2.0 * log(2.0)));
		end;
	end;

    global a;
    a = nPontosT;
    a(2) = nGaussianas;
    a(3) = nVariaveis;
    lb = 0;
    ub = 0;
    x0 = 0;
    i = 1;
    for j = 1:nGaussianas
		for v = 1:nVariaveis
            x0(i) = objc(j,v);
            %lb(i) = LB(1);
            %ub(i) = UB(1);
            i = i + 1;
        end
    end
    for j = 1:nGaussianas
		for v = 1:nVariaveis
            x0(i) = objsigma(j,v);
            %lb(i) = LB(2);
            %ub(i) = UB(2);
            i = i + 1;
        end
    end
    for j = 1:nGaussianas
		for v = 1:nVariaveis
            x0(i) = objp(j,v);
            %lb(i) = LB(3);
            %ub(i) = UB(3);
            i = i + 1;
        end
    end
    for j = 1:nGaussianas
		x0(i) = objq(j);
        %lb(i) = LB(4);
        %ub(i) = UB(4);
        i = i + 1;
    end
    i = 4;
    for j = 1:nPontosT
        for v = 1:nVariaveis
        	a(i) = xt(j,v);
            i = i + 1;
        end
    end
    for j = 1:nPontosT
		a(i) = ydt(j);
        i = i + 1;
    end
    
%     A = [];
%     b = [];
%     Aeq = [];
%     beq = [];
%     lb = [];
%     ub = [];
%     options = optimoptions('fmincon');
%     options.MaxFunctionEvaluations = 500;
%     x = fmincon(@testeError,x0,A,b,Aeq,beq,lb,ub,[],options);

    options.Display='iter';
    options.MaxIter= 50;
    options.TolFun = 5e-5;
    options.TolX   = 1e-3;
    options.ComplexStep     = 'on';
    options.DerivativeCheck = 'on';
    [xopt,fopt] = sqp_MODIF(@testeError,x0,options,[],[],@gradError);% complex step
    
    j = size(xopt,2);
    for i = 1:size(xopt,2)
        error(i) = testeError(xopt(:,j));
        j = j - 1;
    end
    x = xopt(:,1);
    i = 1;
    for j = 1:nGaussianas
		for v = 1:nVariaveis
            objc(j,v) = x(i);
            i = i + 1;
        end
    end
    for j = 1:nGaussianas
		for v = 1:nVariaveis
            objsigma(j,v) = x(i);
            i = i + 1;
        end
    end
    for j = 1:nGaussianas
		for v = 1:nVariaveis
            objp(j,v) = x(i);
            i = i + 1;
        end
    end
    for j = 1:nGaussianas
		objq(j) = x(i);
        i = i + 1;
    end
    
	[objSaidaOmega, objSaidaz, objSaidays] = calcularSaidaError(xv, nVariaveis, nGaussianas, objc, objsigma, objp, objq);
	objape = 0.0;
	for k = 1:nPontosV
		tmp = objSaidays(1,k);
		if tmp ~= 0.0
			tmp = (tmp - ydv(k)) / tmp;
			objape = objape + abs(tmp);
		end;
	end; %k
	objape = objape / nPontosV * 100.0;
end

