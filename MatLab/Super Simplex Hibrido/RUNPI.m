function [RETORNO] = RUNPI(ndim, gap, passo)
  for i = 1:size(gap)
    for j = 1:size(passo)
      RUNPI2(ndim,gap(i),passo(j));
    end
  end
end