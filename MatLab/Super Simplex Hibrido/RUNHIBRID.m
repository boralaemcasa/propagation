function [RETORNO] = RUNHIBRID(ndim, gap, passo)
  for i = 1:size(gap)
    for j = 1:size(passo)
      RUNHIBRID2(2,gap(i),passo(j));
    end
  end
end