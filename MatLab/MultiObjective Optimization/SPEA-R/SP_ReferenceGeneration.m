function [x, N] = SP_ReferenceGeneration(N,M,K)
    if M >= 3
        B = eye(M, M);
		C = 1/M * ones(1, M);
		D = ones(M, K, M);
        x = ones(M*K + (M - 1)*K, M);
        index = 1;
		for i = 1:M
			for r = 1:K
				D(i, r, :) = C + r/K * (B(i,:) - C);
                x(index, :) = D(i, r, :);
                index = index + 1;
			end
        end
		for i = 1:M-1
			for r = 1:K
				for t = 1:r
                    x(index,:) = D(i, r, :) + t/r * (D(i + 1, r, :) - D(i, r, :));
                    index = index + 1;
                end
			end
        end
        N = size(x, 1);
    else 
        % dividir [0,1] em N pontos
        x = (0:1/N:1)';
        if M == 2
            % dividir [0,1]^2 em N pontos (beta, 1 - beta) por Das, Dennis
            x = [x, 1 - x];
        end
    end
end