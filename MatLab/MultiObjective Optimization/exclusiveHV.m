function [y] = exclusiveHV(p, k)
    L = limitset(p, k);
    NDS = L(NDSort(L,1)==1,:);
    y = inclusiveHV(p(k,:)) - hypervolume(NDS);
end
