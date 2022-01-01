function [y] = HV_exclusive(p, k)
    L = HV_limitset(p, k);
    NDS = L(FastCar_NDSort(L,1)==1,:);
    y = HV_inclusive(p(k,:)) - HV_referenced(NDS);
end
