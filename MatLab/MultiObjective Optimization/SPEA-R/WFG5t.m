function [t] = WFG5t(y, k)
    t = WFG5tj(y, 1, k);
    t = WFG5tj(t, 2, k); % = t2(y = t1)
end