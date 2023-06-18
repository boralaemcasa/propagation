function [flag] = equalcolumns(x, y)
    a = sort(notnull(x));
    b = sort(notnull(y));
    c = size(a,2);
    if c ~= size(b,2)
        flag = false;
        return;
    end
    flag = sum(a == b) == c;
end