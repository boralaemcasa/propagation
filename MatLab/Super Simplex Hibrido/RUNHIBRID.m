function [RETORNO] = RUNHIBRID(ndim, gap, passo, separar)
  for i = 1:size(gap)
    for j = 1:size(passo)
      RUNHIBRID2(ndim,gap(i),passo(j), separar);
    end
  end
end