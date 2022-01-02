function [t] = WFG1t(y, k)
    t = WFG1tj(y, 1, k);
    t = WFG1tj(t, 2, k); % = t2(y = t1)
    t = WFG1tj(t, 3, k); % = t3(y = t2)
    t = WFG1tj(t, 4, k); % = t4(y = t3)
end