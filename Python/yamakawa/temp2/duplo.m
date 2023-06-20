function [xt] = duplo(xt)
    n = size(xt, 2);
    y = [];
    for i = 1:n
        for j = i+1:n
            y = [y xt(:,i) .* xt(:,j)];
        end
    end
    xt = [xt, xt.^2, y];
end