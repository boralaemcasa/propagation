function [y] = HV_exclusive(p, k, ref)
    L = HV_limitset(p, k, ref);
    NDS = L(FastCar_NDSort(L,1)==1,:);
    y = HV_inclusive(p(k,:), ref) - HV_referenced(NDS, ref);
end
