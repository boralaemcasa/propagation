function [t] = WFG2t(y, k)
    t = WFG2tj(y, 1, k);
    t = WFG2tj(t, 2, k); % = t2(y = t1)
    t = WFG2tj(t, 3, k); % = t3(y = t2)
end