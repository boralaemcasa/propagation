function ysv = evalfis_yamakawa(out, xv)
    nPontosV = length(xv);
    nVariaveis = length(out.xit);
    ysv = zeros(nPontosV, 1);

    for k = 1:nPontosV;
        ysv(k) = 0.0;
        for v = 1:nVariaveis;
          jj(v) = floor((xv(k,v) - out.xit(v))/out.gamma(v)) + 1;
          if (jj(v) > out.nFuncPertinencia - 1);
            jj(v) = out.nFuncPertinencia - 1;
          elseif jj(v) < 1;
             jj(v) = 1;
          end
          xa = out.xit(v) + (jj(v)-2)*out.gamma(v);
          mujj(v) = 1/out.gamma(v) * (xa + 2*out.gamma(v) - xv(k,v)); %% inclinaçao negativa
          ysv(k) = ysv(k) + mujj(v) * out.w(v,jj(v)) + (1 - mujj(v)) * out.w(v,jj(v)+1); 
        end
    end

end