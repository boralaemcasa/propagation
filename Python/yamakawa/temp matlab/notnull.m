function [y] = notnull(x)
    y = [];
    for i = 1:size(x,2)
        if x(i) ~= 0
            y = [y, x(i)];
        end
    end
end
