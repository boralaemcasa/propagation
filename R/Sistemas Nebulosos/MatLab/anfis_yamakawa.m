function [out,error] = anfis_yamakawa(x, yd, xit, xft, nEpocas, nFuncPertinencia)
   error = zeros(nEpocas,1);

   nVariaveis = length(xft);
   nPontos = length(x);
   out = ClassOutFis;
   out.xit = xit;
   out.nFuncPertinencia = nFuncPertinencia;
   out.gamma = zeros(nVariaveis, 1);

	for v = 1:nVariaveis;
	  out.gamma(v) = (xft(v) - xit(v))/(nFuncPertinencia - 1);
	end

	out.w = zeros(nVariaveis, nFuncPertinencia);
	for v = 1:nVariaveis;
	  for j = 1:nFuncPertinencia;
	    out.w(v,j) = 1;
	  end
	end
   
% aqui começa calcular ape

		for epoca = 1:nEpocas
      disp('epoca');
      epoca
      
			for k = 1:nPontos
			  if mod(k, 10) == 0
          k
        end
				
          if (k == 1)
            alpha = 0.0;
          end
        % aqui começa calcular saída error
        yst(k) = 0.0;
        for v = 1:nVariaveis
          jj(v) = floor((x(k,v) - xit(v))/out.gamma(v)) + 1;
          if (jj(v) > nFuncPertinencia - 1)
            jj(v) = nFuncPertinencia - 1;
          end
          xa = xit(v) + (jj(v)-2)*out.gamma(v);
          mujj(v) = 1/out.gamma(v) * (xa + 2*out.gamma(v) - x(k,v)); %% inclinaçao negativa
          yst(k) = yst(k) + mujj(v) * out.w(v,jj(v)) + (1 - mujj(v)) * out.w(v,jj(v)+1); 
          if (k == 1)
            alpha = alpha + mujj(v)^2 + (1 - mujj(v))^2;
          end
        end
        
        if (k == 1)
          alpha = 1/alpha;
        end
      
      %método do gradiente vezes alpha
  			for v = 1:nVariaveis
					out.w(v, jj(v))   = out.w(v, jj(v)) - alpha * (yst(k) - yd(k)) * mujj(v);
					out.w(v, jj(v)+1) = out.w(v, jj(v)+1) - alpha * (yst(k) - yd(k)) * (1 - mujj(v));
				end %%v 
      end %%k	
      
      error(epoca) = rms(yd(k) - yst(k));		
		end %%epoca
end