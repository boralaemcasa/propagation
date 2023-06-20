function [P2, theta, vartheta, RSE, saida] = fsPCAInit(nVariaveis, X, sfun)
	P2 = zeros(nVariaveis,nVariaveis,1);
	theta = zeros(nVariaveis,1);
	vartheta = zeros(1,nVariaveis);
	RSE = 0;
	saida = [0 -1];
    global St;
    global St2;
    n = 2 * nVariaveis + nchoosek(nVariaveis,2);
%     n = nVariaveis;
    St = zeros(1,n);
    St2 = zeros(n,n);
end