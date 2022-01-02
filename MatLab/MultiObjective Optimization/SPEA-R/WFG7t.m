function [t] = WFG7t(y, k)
    t = WFG7tj(y, 1, k);
    t = WFG7tj(t, 2, k); % = t2(y = t1)
    t = WFG7tj(t, 3, k); % = t3(y = t2)
end