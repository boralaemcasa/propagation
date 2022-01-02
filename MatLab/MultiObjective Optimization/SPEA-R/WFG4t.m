function [t] = WFG4t(y, k)
    t = WFG4tj(y, 1, k);
    t = WFG4tj(t, 2, k); % = t2(y = t1)
end