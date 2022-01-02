function [t] = WFG8t(y, k)
    t = WFG8tj(y, 1, k);
    t = WFG8tj(t, 2, k); % = t2(y = t1)
    t = WFG8tj(t, 3, k); % = t3(y = t2)
end