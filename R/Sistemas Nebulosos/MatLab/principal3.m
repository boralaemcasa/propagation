close all;
clear all;
clc;

alpha = 0.1;

nEpocas = 10;

nVariaveis = 3;
nFuncPertinencia = 5;

stept = 1;

xit(1) = 1;
xft(1) = 6;

xit(2) = 1;
xft(2) = 6;

xit(3) = 1;
xft(3) = 6;

k=1;
xt =[];
for x1=1:6
    for x2=1:6
        for x3=1:6
            xt (k,:)=[x1 x2 x3];
            ydt (k)=(1+x1^0.5 + x2^(-1) + x3^(-1.5))^2;
            k=k+1;
        end

    end

end

nPontosT=length(ydt);

k=1;
xv =[];
for x1=1.5:5.5
    for x2=1.5:5.5
        for x3=1.5:5.5
            xv(k,:)=[x1 x2 x3];
            ydv(k)=(1+x1^0.5 + x2^(-1) + x3^(-1.5))^2;
            k=k+1;
        end

    end

end

stepv = 1;

xiv(1) = 1.5;
xfv(1) = 5.5;

xiv(2) = 1.5;
xfv(2) = 5.5;

xiv(3) = 1.5;
xfv(3) = 5.5;

nPontosV = round( (xfv(1) - xiv(1)) / stepv + 1.0)^3;

for v = 1:nVariaveis
  gamma(v) = (xft(v) - xit(v))/(nFuncPertinencia - 1);
end

w = zeros(nVariaveis, nFuncPertinencia);
for v = 1:nVariaveis
  for j = 1:nFuncPertinencia
    w(v,j) = 1;
  end
end

% aqui começa calcular ape

		for epoca = 1:nEpocas
      disp('epoca');
      epoca


			for k = 1:nPontosT
			  if mod(k, 10) == 0
          k
        end

          if (k == 1)
            alpha = 0.0;
          end
        % aqui começa calcular saída error
        yst(k) = 0.0;
        for v = 1:nVariaveis
          jj(v) = floor((xt(k,v) - xit(v))/gamma(v)) + 1;
          if (jj(v) > nFuncPertinencia - 1)
            jj(v) = nFuncPertinencia - 1;
          end
          xa = xit(v) + (jj(v)-2)*gamma(v);
          mujj(v) = 1/gamma(v) * (xa + 2*gamma(v) - xt(k,v)); %% inclinaçao negativa
          yst(k) = yst(k) + mujj(v) * w(v,jj(v)) + (1 - mujj(v)) * w(v,jj(v)+1);
          if (k == 1)
            alpha = alpha + mujj(v)^2 + (1 - mujj(v))^2;
          end
        end

        if (k == 1)
          alpha = 1/alpha;
        end

      %método do gradiente vezes alpha
  			for v = 1:nVariaveis
					w(v, jj(v))   = w(v, jj(v)) - alpha * (yst(k) - ydt(k)) * mujj(v);
					w(v, jj(v)+1) = w(v, jj(v)+1) - alpha * (yst(k) - ydt(k)) * (1 - mujj(v));
				end %%v
      end %%k
		end %%epoca

plot(ydt);
hold on;
plot(yst);

		%calcular saída error de validaçao

    for k = 1:nPontosV
        ysv(k) = 0.0;
        for v = 1:nVariaveis
          jj(v) = floor((xv(k,v) - xit(v))/gamma(v)) + 1;
          if (jj(v) > nFuncPertinencia - 1)
            jj(v) = nFuncPertinencia - 1;
          end
          xa = xit(v) + (jj(v)-2)*gamma(v);
          mujj(v) = 1/gamma(v) * (xa + 2*gamma(v) - xv(k,v)); %% inclinaçao negativa
          ysv(k) = ysv(k) + mujj(v) * w(v,jj(v)) + (1 - mujj(v)) * w(v,jj(v)+1);
        end
    end

figure
plot(ydv);
hold on;
plot(ysv);
