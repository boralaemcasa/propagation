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

for i = 1:nProblemas
    for j = 1:nExecucoes
        for k = 1:3
            igd(i,j,k) = str2double(A{i,j,k});
            if isnan(igd(i,j,k))
                igd(i,j,k) = Inf;
            end
            hv(i,j,k) = str2double(B{i,j,k});
            if isnan(hv(i,j,k))
                hv(i,j,k) = -Inf;
            end
        end
    end
    for j = 1:2
        dimensao(i,j) = str2double(C{i,j});
    end
end

for i = 188:nProblemas
    if dimensao(i,2) >= 4
        for j = 1:nExecucoes
            Alg = MOEADDE();
            f = str2func(problem{i});
            Pro = f('M', 5);
            Alg.Solve(Pro);
            igd(i,j,3) = IGD(Alg.result{end},Pro.optimum);
            hv(i,j,3) = HV(Alg.result{end},Pro.optimum);
            if isnan(igd(i,j,3))
                igd(i,j,3) = Inf;
            end
            if isnan(hv(i,j,3))
                hv(i,j,3) = -Inf;
            end
        end
    end
end

writematrix(igd, "igd.csv");
writematrix(hv, "hv.csv");
IGD = mean(igd, 2);
HV = mean(hv, 2);

IGD(178:180,1,3) = Inf;
IGD(182,1,3) = Inf;
IGD(184:185,1,3) = Inf;
IGD(187,1,3) = Inf;
%IGD(189,1,3) = Inf;
%IGD(241,1,3) = Inf;

HV(178:180,1,3) = -Inf;
HV(182,1,3) = -Inf;
HV(184:185,1,3) = -Inf;
HV(187,1,3) = -Inf;
%HV(189,1,3) = -Inf;
%HV(241,1,3) = -Inf;

for i = 1:nProblemas
	[x,winner(i,1)] = min(IGD(i,1,:));
	[x,winner(i,2)] = max(HV(i,1,:));
    if sum(isinf(IGD(i,1,:))) > 0
        winner(i,1) = 0;
    end
    if sum(isinf(HV(i,1,:))) > 0
        winner(i,2) = 0;
    end
    if IGD(i,1,1) == IGD(i,1,2) & IGD(i,1,2) == IGD(i,1,3)
        winner(i,1) = -1;
    end
    if HV(i,1,1) == HV(i,1,2) & HV(i,1,2) == HV(i,1,3)
        winner(i,2) = -1;
    end
end
writematrix(winner, "winner.csv");
winner

writematrix(IGD, "igdmean.csv");
writematrix(HV, "hvmean.csv");

%%%%%%%%%%

for i = 1:nProblemas
    if sum(isinf(igd(i,:,3))) < nExecucoes
        for j = 1:nExecucoes
            while isinf(igd(i,j,3))
                Alg = MOEADDE();
                f = str2func(problem{i});
                Pro = f('M', 5);
                Alg.Solve(Pro);
                igd(i,j,3) = IGD(Alg.result{end},Pro.optimum);
                hv(i,j,3) = HV(Alg.result{end},Pro.optimum); 
                if isnan(igd(i,j,3))
                    igd(i,j,3) = Inf;
                end
                if isnan(hv(i,j,3))
                    hv(i,j,3) = -Inf;
                end
            end
        end
    end
end

for i = 1:nProblemas
    if sum(isinf(hv(i,:,3))) < nExecucoes
        for j = 1:nExecucoes
            while isinf(hv(i,j,3))
                Alg = MOEADDE();
                f = str2func(problem{i});
                Pro = f('M', 5);
                Alg.Solve(Pro);
                igd(i,j,3) = IGD(Alg.result{end},Pro.optimum);
                hv(i,j,3) = HV(Alg.result{end},Pro.optimum); 
                if isnan(igd(i,j,3))
                    igd(i,j,3) = Inf;
                end
                if isnan(hv(i,j,3))
                    hv(i,j,3) = -Inf;
                end
            end
        end
    end
end

for i = 1:nProblemas
    for j = 1:nExecucoes
        if isnan(igd(i,j,3))
            igd(i,j,3) = Inf;
        end
        if isnan(hv(i,j,3))
            hv(i,j,3) = -Inf;
        end
    end
end

%%%%%%%%%%

resultado = readmatrix("resultado.csv", opts);
for i = 1:1
    fprintf("$%s$ & %s & %s & %s & %s & %s & $%s$ & %s & %s & %s & $%s$ \\\\\n\\hline\n", resultado{i,2}, resultado{i,3}, resultado{i,4}, resultado{i,5}, resultado{i,6}, resultado{i,7}, resultado{i,8}, resultado{i,9}, resultado{i,10}, resultado{i,11}, resultado{i,12});
end
for i = 1:nProblemas + 1
    if str2double(resultado{i,4}) >= 4
        fprintf("$%s$ & %s & %s & %s & %s & %s & $%s$ & %s & %s & %s & $%s$ \\\\\n\\hline\n", resultado{i,2}, resultado{i,3}, resultado{i,4}, resultado{i,5}, resultado{i,6}, resultado{i,7}, resultado{i,8}, resultado{i,9}, resultado{i,10}, resultado{i,11}, resultado{i,12});
    end
end


