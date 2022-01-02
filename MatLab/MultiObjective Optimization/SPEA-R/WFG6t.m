function [t] = WFG6t(y, k)
    t = WFG6tj(y, 1, k);
    t = WFG6tj(t, 2, k); % = t2(y = t1)
end