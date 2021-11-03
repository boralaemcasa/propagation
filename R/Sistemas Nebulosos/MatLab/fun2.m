function y = fun(X, K, figura)

%------------------------------------------------------------------------
% Algoritmo K-Means

m = 8; % fórmula de u's e de centroid's         

% step 1: randomly assign a cluster to each one of the patterns
n = size(X,1);
if n >= K
U = zeros(n,K);    % partition matrix
idx = zeros(n,1);
centroids = zeros(K,2);

for j = 1:1
for i = 1:1
  a = randi(n);
  %centroids(i,1) = X(a,1);
  %centroids(i,2) = X(a,2);
  centroids(1,1) = 2.5;
  centroids(1,2) = 4;
  centroids(2,1) = 3;
  centroids(2,2) = 3.5;
  centroids(3,1) = 3.5;
  centroids(3,2) = 4.5;
  centroids(4,1) = 4;
  centroids(4,2) = 5;
end
    xdata = centroids(:,1);
    ydata = centroids(:,2);
    pause(1);
    figure(1);
    h = plot(xdata, ydata, 'ko', 'LineWidth', 2, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 10);
    set(h,'YDataSource','ydata')
    set(h,'XDataSource','xdata')
    %refreshdata
end


    U = zeros(n,K);
    for i = 1:n,
      for j = 1:K,
        x = X(i,1) - centroids(j, 1);
        y = X(i,2) - centroids(j, 2);
        quadrado = (x*x + y*y)^m;
        soma = 0;
        for t = 1:K,
          x = X(i,1) - centroids(t, 1);
          y = X(i,2) - centroids(t, 2);
          soma = soma + (x*x + y*y)^m;
        end      
        U(i, j) = quadrado / soma; %^(2/(1-m));
      end    
    end 

% calculating the objective function 
W = zeros(K,1);
for j = 1:K,
   indexes = find(idx==j);
   Clusj = X(indexes,:);
   soma = 0;
   for li1 = 1:(length(indexes)),
     for li2 = (li1+1):(length(indexes)),
         d1 = (Clusj(li1,1) - Clusj(li2,1))^2;
         d2 = (Clusj(li1,2) - Clusj(li2,2))^2;
         soma = soma + sqrt(d1 + d2);
     end
   end
   W(j) = (1/length(indexes)) * soma; % pdist calculates the n(n-1)/2 distances among all patterns in the Cluster K
end
J(1) = sum(W);

changes = true;
oldIdx = idx;
iter = 1;
while (changes)    % iterate until the cluster assignments stop changing
    
    % computing the initial centroids
    novoCentro = zeros(K,2);
    for j = 1:K,
        soma = 0;
        somax = 0;
        somay = 0;
        for i = 1:n,
          soma = soma + U(i,j)^m;
          somax = somax + U(i,j)^m * X(i,1);
          somay = somay + U(i,j)^m * X(i,2);
        end        
        novoCentro(j,:) = [somax/soma,somay/soma];
    end;
    % ploting the new centroids
    xdata = novoCentro(:,1);
    ydata = novoCentro(:,2);
    pause(1)
    h = plot(xdata, ydata, 'ko', 'LineWidth', 2, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 10);
    set(h,'YDataSource','ydata')
    set(h,'XDataSource','xdata')
    %refreshdata
    
    % assign each pattern to the cluster whose centroid is closest 
    U = zeros(n,K);
    for i = 1:n,
      for j = 1:K,
        x = X(i,1) - novoCentro(j, 1);
        y = X(i,2) - novoCentro(j, 2);
        quadrado = (x*x + y*y)^m;
        soma = 0;
        for t = 1:K,
          x = X(i,1) - novoCentro(t, 1);
          y = X(i,2) - novoCentro(t, 2);
          soma = soma + (x*x + y*y)^m;
        end      
        U(i, j) = quadrado / soma; %)^(2/(1-m));
      end    
    end
    
   for i = 1:n,
     pattern = X(i,:);
     smallDistance = inf;
     for j = 1:K,
        gc = centroids(j,:);
        distance = sum((pattern-gc).^2);  % squared Euclidian distance from pattern to each centroid  
        if (distance < smallDistance),
            smallDistance = distance;
            smallIndex = j;
        end
      end
      %U(i,smallIndex) = 1;
      idx(i) = smallIndex;
    end
    

    % calculating the objective function 
    clus = unique(idx);
    c = length(clus);
    W = zeros(c,1);
    for j = 1:c,
       indexes = find(idx==clus(j));
       Clusj = X(indexes,:);
      soma = 0;
       for li1 = 1:(length(indexes)),
         for li2 = (li1+1):(length(indexes)),
             d1 = (Clusj(li1,1) - Clusj(li2,1))^2;
             d2 = (Clusj(li1,2) - Clusj(li2,2))^2;
             soma = soma + sqrt(d1 + d2);
         end
       end

       W(j) = 1/length(indexes) * soma; % pdist calculates the n(n-1)/2 distances among all patterns in the Cluster K
    end
    iter = iter + 1;
    J(iter) = sum(W);
    
    % verifying the stop criteria
    igual = 1;
    for i = 1:K
      flag = 0;
      for j = 1:K
        if abs(centroids(i,1) - novoCentro(j,1)) < 0.001
          if abs(centroids(i,2) - novoCentro(j,2)) < 0.001
            flag = 1;
          end
        end
      end
      if flag == 0
        igual = 0;
      end
    end
    
    
    if igual == 1
        changes = false;
    else
        oldIdx = idx;
        centroids = novoCentro;
    end;
    
end;

% ploting the final clustering resulting from K-Means
clus = unique(idx);
colors = {'b.', 'r.', 'c.', 'm.', 'y.', 'k.'};
for i = 1:length(clus),
    
    indexes = find(idx==clus(i));
    plot(X(indexes,1), X(indexes,2), colors{i});
    
end

% ploting the objective function as a function of the number of iterations
figure(figura);
hold on;
plot(1:iter, J(1:iter), 'b--', 'LineWidth', 2);
grid on;
end

  y = X;
end
