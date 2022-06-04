close all;
clear all;
clc;

n = 20;

for k = 1:200
    nu = randn(1,n);
    nu = nu/std(nu);
    nu = nu - mean(nu);

    C = cov(nu' * nu);
    R = abs(eig(C));
    m = min(R);
    M = max(R);
    cond(k) = m/M;

    e = nu(1);
    for k = 2:n
        e(k) = 0.8 * nu(k - 1) + nu(k);
    end

    C2 = cov(e' * e);
    R2 = abs(eig(C2));
    m2 = min(R2);
    M2 = max(R2);
    cond2(k) = m2/M2;
end;

cond = mean(cond);
cond2 = mean(cond2);
cond/cond2
