function [n, cols, V] = fs2ContribSemLoopMax(nVariaveis, xt, ydt, constTheta, h)
	global P2;
	global theta;
	global vartheta;
	global RSE;
	global saida;
	x = 1:nVariaveis;
	s = size(x,2);
    constTheta = 0.10; % 10% do máximo
	
	for i = 1:2
		[theta(:,i), P2(:,:,i), RSE(i)] = regressores2(s, nVariaveis, xt(i,:), ydt(i), P2(:,:,i), theta(:,i), RSE(i));
	end
    if h > 1
        contribuicao = abs(theta);
		contribuicao = mean(contribuicao, 2);
        contribuicao = contribuicao/max(contribuicao);
        for i = 1:s
            if contribuicao(i) <= constTheta
                x(i) = 0;
            end
        end		
    end
    
    cols = notnull(x);
    n = size(cols,2);
    V = [];
end