function [n, cols, V] = fs2ContribYamakawa(nVariaveis, xt, ydt, constContribGlobal, h)
	global P2;
	global theta;
	global vartheta;
	global RSE;
	global saida;
	x = 1:nVariaveis;
    P2 = [xt];
    theta = [ydt];
	s = size(x,2);
	constContrib = constContribGlobal/s;

    constNFuncPertinencia = 10;
    constEpsilon = 0.05;
	
	%[theta, P2, RSE] = regressores2(s, nVariaveis, xt, ydt, P2, theta, RSE);
    contribuicaoinf = [];
    contribuicaosup = [];
    totalinf = zeros(nVariaveis, 1);
    totalsup = zeros(nVariaveis, 1);
    for i = 1:2
        out_fis(i) = anfis_yamakawa(P2(i,:), theta(i), constNFuncPertinencia, constEpsilon, h, i);
    end
    if h > 1
        for i = 1:2
            pinf(:,:,i) = abs(out_fis(i).winf);
            psup(:,:,i) = abs(out_fis(i).wsup);
        end
        pesoinf = mean(pinf,3);
        pesosup = mean(psup,3);
        for i=1:constNFuncPertinencia
            totalinf(i) = sum(pesoinf(:,i));
            totalsup(i) = sum(pesosup(:,i));
            contribuicaoinf(:,i) = pesoinf(:,i) / totalinf(i);
            contribuicaosup(:,i) = pesosup(:,i) / totalsup(i);
        end
        contribuicaoinf = mean(contribuicaoinf,2);
        contribuicaosup = mean(contribuicaosup,2);
        contribuicao = mean([contribuicaoinf, contribuicaosup], 2);
        incerteza = abs(contribuicaosup - contribuicaoinf);
        for i = 1:s
            if contribuicao(i) <= constContrib
                x(i) = 0;
            end
        end		
    end
    
    cols = notnull(x);
    n = size(cols,2);
    V = [];
end