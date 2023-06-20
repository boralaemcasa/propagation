function [P2, theta, vartheta, RSE, saida] = fsContribYamakawaInit(nVariaveis, X, sfun)
	P2 = [];
	theta = [];
	vartheta = [];
	RSE = 0;
	saida = [];
    if sfun == "fsContribYamakawa"
        global xit;
        global xft;
        xit = zeros(nVariaveis,1);
        xft = zeros(nVariaveis,1);
        for i = 1:nVariaveis
           xit(i) = min(X(:,i));
           xft(i) = max(X(:,i));
        end
    end
end