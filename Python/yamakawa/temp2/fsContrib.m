function [n, cols, V] = fsContrib(nVariaveis, xt, ydt, constContribGlobal, h)
    constMaxThetas = 700;
	global P2;
	global theta;
	global vartheta;
	global RSE;
	global saida;
    x = 1:nVariaveis;
    for ell = 1:nVariaveis
        item = notnull(x);
        s = size(item,2);
        constContrib = constContribGlobal/s;
        Psi = xt(item);

        flag = false;
        for lk = 1:size(vartheta,1)
            if equalcolumns(x, vartheta(lk,:))
                flag = true;
                break;
            end
        end
        if ~flag
            lk = lk + 1;
            if lk == constMaxThetas
                [a,lk] = min(RSE(2:end));
                lk = lk + 1;
            end
        end
        vartheta(lk,:) = x;
        theta(:,lk) = zeros(nVariaveis,1);
        P2(:,:,lk) = zeros(nVariaveis,nVariaveis);
        RSE(lk) = 0;

        [theta(:,lk), P2(:,:,lk), RSE(lk)] = regressores2(s, nVariaveis, Psi, ydt, P2(:,:,lk), theta(:,lk), RSE(lk));
        Theta = theta(1:s,lk);
        contribuicao = abs(Theta);
        contribuicao = contribuicao/sum(contribuicao);
        [a, b] = min(contribuicao);
        if a > constContrib | h == 1
            if sum(saida(:,2) == lk) == 0
                saida = [saida ; s, lk];
            end
            break;
        end
        item(b) = 0;
        x = item;
        while size(x,2) < nVariaveis
            x = [x 0];
        end
        if h == 1
            break;
        end
    end
    C = [];
    for i = 1:nVariaveis
        z = saida(find(saida(:,1) == i),2);
        [a,b] = min(RSE(z));
        C = [C; a,z(b)];
    end
    [a,b] = min(C(:,1));
    x = vartheta(C(b,2),:);
    cols = notnull(x);
    n = size(cols,2);
    V = [];
end