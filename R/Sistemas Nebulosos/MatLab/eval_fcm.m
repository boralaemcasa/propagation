function [x,y,Z,f] = eval_fcm(h,M,m)
%% Define axis

x = linspace(0,1, 200);
y = linspace(0,1, 200);

% x = linspace(min(min(h(:,1)),min(M(:,1))), max(max(h(:,1)),max(M(:,1))), 200);
% y = linspace(min(min(h(:,2)),min(M(:,2))), max(max(h(:,2)),max(M(:,2))), 200);

%% Algorithm

n = size(x,2);
for i = 1:size(x,2)
    h((i-1)*n+(1:n),:) = [x', y(i)*ones(200,1)];
end

f(size(h,1)) = 0;
c = size(M,1);
D=zeros(c,length(h(:,1)));
U=zeros(c,length(h(:,1)));
Up=zeros(c,length(h(:,1)));
Uc=zeros(c,length(h(:,1)));
Uf=zeros(c,length(h(:,1)));
Mk=zeros(c,length(h(1,:)));
p=zeros(c,length(h(:,1)));
a=zeros(c,1);

for i=1:c
    for j = 1:length(h(:,1))  
    D(i,j) = [(norm(M(i,:)-h(j,:)))^2];
    end
end 

for i=1:c
    for j=1:length(h(:,1)) 
        for l= 1:c 
            if D(i,j)==0
            U(i,j)=1;                        
            a(j,:)=j; 
            elseif D(l,j)==0          
            U(i,j)=0;                                                                      
            a(j,:)=j;           
            end                                       
        end
    end
end          

for i=1:c
    for j=setdiff(1:max(size(h(:,1))), a(:,1)') 
        for l= 1:c             
            Uf(i,j)=Uf(i,j)+((D(l,j))/D(i,j)).^(1/(1-m)); 
            U(i,j)=1/Uf(i,j);          
        end
    end      
end

for i=1:size(h,1)
    f(i) = max(U(:,i));
end

Z = reshape(f,[size(x,2),size(x,2)]);
end