function y = fun(x,a,b)

g = @(x) exp(1./((x-a).*(x-b))) ;

 y = quadgk(g,a,x);
 if (x <= a)
     y = 0
 elseif (x >= b)
     y = quadgk(g,a,b);
 end
end

