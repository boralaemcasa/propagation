clc
clear

%[decs,objs,cons] = platemo('algorithm',@GA,'problem',@SOP_F1,'N',50);

nExecucoes = 5;

opts = delimitedTextImportOptions;
problem = readmatrix("problems.csv", opts);
nProblemas = length(problem);

% A = readmatrix("igd1.csv", opts);
% A = reshape(A, nProblemas, nExecucoes, 6);
% B = readmatrix("hv1.csv", opts);
% B = reshape(B, nProblemas, nExecucoes, 6);
C = readmatrix("dimensao.csv", opts);

igd = zeros(nProblemas, nExecucoes, 3);
hv = zeros(nProblemas, nExecucoes, 3);
winner = ones(nProblemas, 2);
dimensao = zeros(nProblemas, 2);

for i = 1:nProblemas
    for j = 1:2
        dimensao(i,j) = str2double(C{i,j});
    end
end

for i = 1:nProblemas
    if dimensao(i,2) >= 4
        for j = 1:nExecucoes
            Alg = SPEAR();
            f = str2func(problem{i});
            Pro = f('M', 5);
            if Pro.M >= 4
                Alg.Solve(Pro);
                igd(i,j,1) = IGD(Alg.result{end},Pro.optimum);
				if isnan(igd(i,j,1))
					igd(i,j,1) = Inf;
				end
                hv(i,j,1) = HV(Alg.result{end},Pro.optimum);
				if isnan(hv(i,j,1))
					hv(i,j,1) = -Inf;
				end

                Alg = NSGAIII();
                Alg.Solve(Pro);
                igd(i,j,2) = IGD(Alg.result{end},Pro.optimum);
				if isnan(igd(i,j,2))
					igd(i,j,2) = Inf;
				end
                hv(i,j,2) = HV(Alg.result{end},Pro.optimum);
				if isnan(hv(i,j,2))
					hv(i,j,2) = -Inf;
				end
                dimensao(i,1) = Pro.D;
                dimensao(i,2) = Pro.M;
            else
                igd(i,j,1) = -2;
                hv(i,j,1) = -2;
                igd(i,j,2) = -2;
                hv(i,j,2) = -2;
            end
        end
    end
end

writematrix(igd, "igd.csv");
writematrix(hv, "hv.csv");
%writematrix(dimensao, "dimensao.csv");

