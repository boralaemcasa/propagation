clc
clear

%[decs,objs,cons] = platemo('algorithm',@GA,'problem',@SOP_F1,'N',50);

nExecucoes = 5;

opts = delimitedTextImportOptions;
problem = readmatrix("problems.csv", opts);
nProblemas = length(problem);

A = readmatrix("igd1.csv", opts);
A = reshape(A, nProblemas, nExecucoes, 3);
B = readmatrix("hv1.csv", opts);
B = reshape(B, nProblemas, nExecucoes, 3);
C = readmatrix("dimensao.csv", opts);

igd = zeros(nProblemas, nExecucoes, 3);
hv = zeros(nProblemas, nExecucoes, 3);
winner = ones(nProblemas, 2);
dimensao = zeros(nProblemas, 2);

for i = 1:nProblemas
    for j = 1:nExecucoes
        for k = 1:2
            igd(i,j,k) = str2double(A{i,j,k});
            hv(i,j,k) = str2double(B{i,j,k});
        end
    end
    for j = 1:2
        dimensao(i,j) = str2double(C{i,j});
    end
end

for i = 1:nProblemas
    if dimensao(i,2) >= 4
        if sum(isnan(igd(i,:,1))) < nExecucoes
            for j = 1:nExecucoes
                while isnan(igd(i,j,1))
                    Alg = SPEAR();
                    f = str2func(problem{i});
                    Pro = f('M', 5);
                    Alg.Solve(Pro);
                    igd(i,j,1) = IGD(Alg.result{end},Pro.optimum);
					if isnan(igd(i,j,1))
						igd(i,j,1) = Inf;
					end
                    hv(i,j,1) = HV(Alg.result{end},Pro.optimum);            
					if isnan(hv(i,j,1))
						hv(i,j,1) = -Inf;
					end
                end
            end
        end
        if sum(isnan(hv(i,:,1))) < nExecucoes
            for j = 1:nExecucoes
                while isnan(hv(i,j,1))
                    Alg = SPEAR();
                    f = str2func(problem{i});
                    Pro = f('M', 5);
                    Alg.Solve(Pro);
                    igd(i,j,1) = IGD(Alg.result{end},Pro.optimum);
					if isnan(igd(i,j,1))
						igd(i,j,1) = Inf;
					end
                    hv(i,j,1) = HV(Alg.result{end},Pro.optimum);            
					if isnan(hv(i,j,1))
						hv(i,j,1) = -Inf;
					end
                end
            end
        end
    end
end

for i = 1:nProblemas
    if dimensao(i,2) >= 4
        if sum(isnan(igd(i,:,2))) < nExecucoes
            for j = 1:nExecucoes
                while isnan(igd(i,j,2))
                    Alg = NSGAIII();
                    f = str2func(problem{i});
                    Pro = f('M', 5);
                    Alg.Solve(Pro);
                    igd(i,j,2) = IGD(Alg.result{end},Pro.optimum);
					if isnan(igd(i,j,2))
						igd(i,j,2) = Inf;
					end
                    hv(i,j,2) = HV(Alg.result{end},Pro.optimum);            
					if isnan(hv(i,j,2))
						hv(i,j,2) = -Inf;
					end
                end
            end
        end
        if sum(isnan(hv(i,:,2))) < nExecucoes
            for j = 1:nExecucoes
                while isnan(hv(i,j,2))
                    Alg = NSGAIII();
                    f = str2func(problem{i});
                    Pro = f('M', 5);
                    Alg.Solve(Pro);
                    igd(i,j,2) = IGD(Alg.result{end},Pro.optimum);
					if isnan(igd(i,j,2))
						igd(i,j,2) = Inf;
					end
                    hv(i,j,2) = HV(Alg.result{end},Pro.optimum);            
					if isnan(hv(i,j,2))
						hv(i,j,2) = -Inf;
					end
                end
            end
        end
    end
end

writematrix(igd, "igd.csv");
writematrix(hv, "hv.csv");

%%%%%%%%%%

dimensao = zeros(nProblemas, 2);

for i = 1:nProblemas
    f = str2func(problem{i});
    Pro = f();
    dimensao(i,1) = Pro.D;
    dimensao(i,2) = Pro.M;
end
writematrix(dimensao, "dimensao.csv");

%%%%%%%%%%

resultado = readmatrix("resultado.csv", opts);
for i = 1:nProblemas + 1
    fprintf("$%s$ & %s & %s & %s & %s & $%s$ & %s & %s & $%s$ \\\\\n\\hline\n", resultado{i,2}, resultado{i,3}, resultado{i,4}, resultado{i,5}, resultado{i,6}, resultado{i,7}, resultado{i,8}, resultado{i,9}, resultado{i,10});
end
