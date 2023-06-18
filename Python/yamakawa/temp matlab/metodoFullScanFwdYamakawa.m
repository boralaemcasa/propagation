function [i, x] = metodoFullScanFwd(nVariaveis, xt, ydt, constTheta, constMaxEpocas, constNFuncPertinencia, constEpsilon, constSlope, flagEMQ)
    antes = [];
    depois = [];
    AICdepois = [];
    K = [0]; % tem um sum abaixo
    KL = 0;
    Ka = 0;
    for ell = 1:nVariaveis % para cada quantidade de colunas:
        Knovo = [];
        for m = 1:size(K,1) % para cada um dos m itens:
            item = K(m,:);

            if sum(item ~= 0) == 0
                opcoes = [1:nVariaveis]';
            else
                x = item;
                % AIC das colunas x                    
                Psi = xt(:,notnull(x));
                theta = regressores(Psi, ydt, flagEMQ);
                xi = ydt - Psi*theta;
                [N, Q] = size(Psi);
                SQR = sum(xi.^2);
                AIC(1) = 1 + log(2*pi) + log(SQR/N) + 2 * Q/N;

                opcoes = [];
                candidato = [];
                ini = max(item) + 1; % ordem crescente
                for i = ini:nVariaveis
                    if sum(item == i) == 0
                        candidato = [candidato; i];
                    end
                end
                for i = 1:size(candidato,1)
                    item(ell) = candidato(i); % add column 2 item

                    % se o AIC aumentar, não será mais opção
                    x = item;
                    % AIC das colunas x                    
                    Psi = xt(:,notnull(x));
                    theta = regressores(Psi, ydt, flagEMQ);
                    xi = ydt - Psi*theta;
                    [N, Q] = size(Psi);
                    SQR = sum(xi.^2);
                    AIC(2) = 1 + log(2*pi) + log(SQR/N) + 2 * Q/N;
                    if AIC(2) - AIC(1) <= constSlope
                        opcoes = [opcoes; item]; % cada item com suas opções
                    end
                end
            end
            if size(opcoes,1) == 0
               item(ell) = 0;
               opcoes = item;
            end
            Knovo = [Knovo; opcoes]; % juntar todas as opções
        end
        % agora temos que voltar pro for de adicionar uma coluna a cada opção 
        K = Knovo;

        m = 1;
        while m <= size(K,1)
           % eliminar repetições, fwd
           if m < size(K,1)
               i = m + 1;
               while i <= size(K,1)
                  if equalcolumns(K(m,:), K(i,:))
                     K(i,:) = [];
                  else
                     i = i + 1;
                  end
               end
           end

           % andar para trás
           item = notnull(K(m,:));
           flag = false; % contas armazenadas? não.
           for i = 1:size(antes,1)
               if equalcolumns(item, antes(i,:))
                   flag = true; % sim.
                   item = notnull(depois(i,:));
                   while size(item,2) < ell
                       item = [item 0];
                   end
                   K(m,:) = item;
                   break;
               end
           end
           if ~flag
               Psi = xt(:,item);
               theta = regressores(Psi, ydt, flagEMQ);
               theta = theta./max(theta);
               i = 1;
               for i = 1:size(theta,1)
                   if abs(theta(i)) < constTheta
                       item(i) = 0;
                   end
               end
               while size(item,2) < ell
                   item = [item 0];
               end

               a = K(m,:);
               b = item;
               K(m,:) = item;
               while size(a,2) < nVariaveis
                   a = [a, 0];
                   b = [b, 0];
               end

               antes = [antes; a];
               depois = [depois; b];
           end

           % eliminar repetições, bwd
           i = 1;
           while i < m
              if equalcolumns(K(m,:), K(i,:))
                 K(m,:) = [];
                 m = m - 1;
                 break;
              else
                 i = i + 1;
              end
           end

           m = m + 1;
        end
        a = size(antes,1);
        b = size(K,1);
        fprintf("ell = %d, K = %d, antes = %d\n", ell, b, a);
        if b == KL & a == Ka
            break; % interromper se K estabilizar
        end
        KL = b;
        Ka = a;
    end

    erro = [];
    for m = 1:size(K,1)
        x = K(m,:);

        % erro das colunas x                    
        Psi = xt(:,notnull(x));
        nv = size(Psi,2);
        xit = zeros(nv,1);
        xft = zeros(nv,1);
        for i = 1:nv
           xit(i) = min(Psi(:,i));
           xft(i) = max(Psi(:,i));
        end
        [out_fis,t] = anfis_yamakawa(Psi, ydt, xit, xft, constMaxEpocas, constNFuncPertinencia, constEpsilon);
        erro(m) = t(end);
    end
    % dentre todas de 1 variável, escolha o mínimo em função de 1.
    sz = sum(K ~= 0, 2);
    x = [];
    y = [];
    z = [];
    for i = 1:nVariaveis
        f = find(sz' == i);
        if size(f,2) ~= 0
            [a, b] = min(erro(f));
            x = [x i];
            y = [y erro(f(b))];
            z = [z f(b)];
        end
    end
    % plot(x, y) % não há \/értice
    [a, b] = min(y);
    x = K(z(b),:);
    while size(x,2) < nVariaveis
        x = [x 0];
    end
    if size(x,1) == 0
        i = 0;
        x = 0;
    else
        item = notnull(x);
        i = size(item,2);
    end
end