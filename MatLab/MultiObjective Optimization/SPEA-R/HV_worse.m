function [y] = HV_worse(a, b)
    if a > b
        x = a;
        a = b;
        b = x;
    end
    if b < 2
        y = b; % a < b < 2
    else
        y = 2; % a < b > 2; 
    end
end