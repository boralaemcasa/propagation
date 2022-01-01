function [y] = HV_worse(a, b, ref)
    if a > b
        x = a;
        a = b;
        b = x;
    end
    if b < ref
        y = b; % a < b < 2
    else
        y = ref; % a < b > 2; 
    end
end