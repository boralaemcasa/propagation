function [t] = WFG9t(y, k)
    t = WFG9tj(y, 1, k);
    t = WFG9tj(t, 2, k); % = t2(y = t1)
    t = WFG9tj(t, 3, k); % = t3(y = t2)
end