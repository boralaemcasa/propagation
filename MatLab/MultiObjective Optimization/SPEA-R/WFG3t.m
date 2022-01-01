function [t] = WFG3t(y, k)
    t = WFG3tj(y, 1, k);
    t = WFG3tj(t, 2, k); % = t2(y = t1)
    t = WFG3tj(t, 3, k); % = t3(y = t2)
end