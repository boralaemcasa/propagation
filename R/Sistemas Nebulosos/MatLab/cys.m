function [ys,y,w,b]=cys(x,n,m,np,c,s,p,q)

for k=1:np
    a=0;b=0;
    for j=1:m
        w(j)=1;
        y(j)=q(j);
        for i=1:n
            w(j)=w(j)*exp(-0.5 * ((x(k,i)-c(i,j))/s(i,j))^2);
            y(j)=y(j) + p(i,j)*x(k,i);
        end
        a=a+w(j)*y(j);
        b=b+w(j);
    end
    ys(k)=a/b;
end

As vídeo-aulas no curso do professor Yaser Abu-Mostafa estão disponíveis com legendas em português:

https://work.caltech.edu/telecourse.html

Por enquanto, são recomendadas as aulas de 1 a 5.