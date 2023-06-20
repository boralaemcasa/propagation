function [P2, theta, vartheta, RSE, saida] = fs2PearsonInit(nVariaveis, X, sfun)
	P2 = zeros(nVariaveis,nVariaveis,1);
	theta = zeros(nVariaveis,1);
	vartheta = zeros(1,nVariaveis);
	RSE = 0;
	saida = [0 -1];
    global St;
    global St2;
    n = nVariaveis + 2;
    St = zeros(2,n);
    St2 = zeros(n,n,2);
end