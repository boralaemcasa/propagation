setwd("V:\\sem backup\\_1 OTIMIZACAO MULTIOBJETIVO\\_tc")
rm(list=ls())

sz <- 500
upper <- 800
maxc <- 150
dsup <- 85

initialSol <- function(dimini, dimx) {
   clientes <- as.matrix(read.csv("clientes.csv", sep=",", header=FALSE))
   clientes <- cbind(clientes, 0) # 4a coluna := N
   x <- matrix(0, dimx, 1) # ponto inicial do espaço
   x[dimx] <- dimini
   N <- dimini
   jx <- 1e69
   while (jx > 0.5e69) {
      posicao <- kmeans(N, clientes, sz, 4)
      for (i in 1:N) {
         x[i] <- posicao[i,1]
         x[i + N] <- posicao[i,2]
      }
      ret <- fobj(x,clientes,dimini,dimx)
      jx <- ret[[1]]
   }
   return(list(x,clientes))
}

initialT <- function(x,clientes,sigma,nfe,dimini,dimx) {
   N   <- 100      # número de testes
   tau <- 0.20     # taxa de aceitação inicial
   X   <- matrix(0,N,dimx)
   jX  <- matrix(0,N,1)
   
   ret  <- fobj(x,clientes,dimini,dimx)
   jx <- ret[[1]]
   x <- ret[[5]]
   nfe <- nfe + 1
   X[1,] <- x
   jX[1]  <- jx
   xbest <- x
   jxbest <- jx
   
   i <- 0
   DeltaE <- matrix(0, nrow=N, ncol=1)
   for (k in 2:N) {
       X[k,] <- neighbor(xbest,clientes,sigma,dimini,dimx)
       ret  <- fobj(X[k,],clientes,dimini,dimx)
       jX[k] <- ret[[1]]
       X[k,] <- ret[[5]]
       nfe <- nfe + 1 

       if (jX[k] < jxbest) {
          xbest <- X[k,]
          jxbest <- jX[k]
       }
       DE <- jX[k] - jx
       #if (DE > 0.5e69)
       #   DE <- 0
       if (DE > 0) {
           i <- i + 1
           DeltaE[i] <- DE
       }
   }
   
   jx <- min(jX)
   jmin <- which.min(jX)
   x  <- X[jmin,]
   DeltaEM <- sum(DeltaE)
   if (i > 0)
      DeltaEM <- DeltaEM/i
   to <- - DeltaEM/log(tau)
   return(list(to,x,jx,nfe))
}

dist <- function(x, y) { 
   return(sqrt((x[1] - y[1])^2 + (x[2] - y[2])^2)) 
}

kmeans <- function(k, M, linhas, index) {
   nc <- 2
   centro <- matrix(0,ncol=nc,nrow=k)
   for (i in 1:k) {
      a <- sample(1:linhas, 1)
      for (j in 1:nc)
         centro[i,j] <- M[a,j]
   }
   distancia <- matrix(0,k)
   novoCentro <- matrix(0,ncol=nc,nrow=k)
   while (TRUE) {
      for (i in 1:linhas) {
         for (j in 1:k)
            distancia[j] <- dist(M[i,], centro[j,])
         M[i,index] <- 1
         min <- distancia[1]
         for (j in 2:k)
            if (distancia[j] < min) {
               M[i,index] <- j
               min <- distancia[j]
            }
      }
      for (j in 1:k) {
         for (ell in 1:nc)
            novoCentro[j,ell] <- 0
         contador <- 0
         for (i in 1:linhas)
            if (M[i, index] == j) {
               for (ell in 1:nc)
                  novoCentro[j,ell] <- novoCentro[j,ell] + M[i,ell]
               contador <- contador + 1
            }
         if (contador != 0)
            for (ell in 1:nc)
               novoCentro[j,ell] <- novoCentro[j,ell] / contador
      }
      flag <- TRUE
      for (j in 1:k)
         for (ell in 1:nc)
            if (novoCentro[j,ell] != centro[j,ell])
               flag <- FALSE
      if (flag)
         return(novoCentro)
      centro <- novoCentro
   }
}

fobj <- function(x,clientes,dimini,dimx) {
   #clientes <- as.matrix(read.csv("clientes.csv", sep=",", header=FALSE))
   #clientes <- cbind(clientes, 0) # 4a coluna := N
   minimo <- 1e69
   min1 <- minimo
   min2 <- minimo
   min3 <- minimo
   N <- x[dimx]
   posicao <- matrix(0, N, 3)
   for (i in 1:N) {
      posicao[i,1] <- x[i]
      posicao[i,2] <- x[i + N]
   }

   # Um cliente pode ser atendido <=> d < 85 metros. Gerar possibilidades.
   atend <- matrix(0, sz, N)
   for (i in 1:sz)
     for (j in 1:N)
        if (dist(clientes[i,], posicao[j,]) < dsup)
           atend[i,j] <- 1

   # >= 95% * 500 = 475 têm suas demandas integralmente atendidas?
   naoAtendidas <- 0
   for (i in 1:sz)
      if (sum(atend[i,]) < 1)
         naoAtendidas <- naoAtendidas + 1

   if (naoAtendidas < 0.05 * sz) {
      # atender. preencher 4a coluna com a próxima possibilidade.
      ultima <- F
      while (! ultima) {
         ultima <- T
         for (i in 1:sz) {
            clientes[i,4] <- 0
            for (j in 1:N)
               if (atend[i,j] > 0.5) {
                  clientes[i,4] <- j
                  if (sum(atend[i,]) > 1) {
                     ultima <- F
                     atend[i,j] <- 0
                  }
                  break
               }
         }
         # Cada ponto tem capacidade de 150 Mbps. Foi excedida?
         excesso <- 1
         somaDistancia <- 0
         for (j in 1:N)
            posicao[j,3] <- 0
         for (i in 1:sz) {
            j <- clientes[i,4]
            if (j > 0) {
               posicao[j,3] <- posicao[j,3] + clientes[i,3]
               somaDistancia <- somaDistancia + dist(clientes[i,], posicao[j,])
            }
         }
         for (j in 1:N)
            if (posicao[j,3] > maxc)
               excesso <- excesso + posicao[j,3] - maxc

         f1 <- N
         f2 <- somaDistancia
         f3 <- excesso
         f <- f2 * f3
         if (f < minimo) {
            minimo <- f
            min1 <- f1
            min2 <- f2
            min3 <- f3
         }

         # é a última possibilidade?
      }
   }
   
   for (i in 1:sz)
      x[2 * dimini + i] <- clientes[i,4]
   return(list(minimo, min1, min2, min3, x))
}

neighbor <- function(x,clientes,sigma,dimini,dimx) {
   jx <- 1e69
   while (jx > 0.5e69) {
      #if (runif(1, 0, 1) < 0.5) { # ou L - 1
      #   y <- x
      #   N <- x[dimx] - 1
      #   posicao <- kmeans(N, clientes, sz, 4)
      #   for (i in 1:N) {
      #      y[i] <- posicao[i,1]
      #      y[i + N] <- posicao[i,2]
      #   }
      #   y[dimx] <- N
      #}
      #else { # ou L
         N <- 2 * x[dimx]
         D <- matrix(0, dimx, 1)
         for (i in 1:N)
            D[i] <- runif(1, -1, 1)
         delta <- sigma * D

         y <- x + delta
         for (i in 1:N) {
            if (y[i] < 0) 
               y[i] <- 0
            else if (y[i] > upper)
               y[i] <- upper
         } 
      #}
      ret <- fobj(y,clientes,dimini,dimx)
      jx <- ret[[1]]
   }
   
   return(y)
}

SAreal <- function(dimini,dimx,maxnfe) {
   # Contador de estágios do método
   k <- 0
   
   # Contador do número de avaliações de f(.)
   nfe <- 0 
   
   # Desvio padrão inicial da vizinhança
   sigma <- 1 # 0.25
   
   # Gera solução inicial
   ret <- initialSol(dimini,dimx)
   x <- ret[[1]]
   clientes <- ret[[2]]
   
   # Define temperatura inicial
   ret <- initialT(x,clientes,sigma,nfe,dimini,dimx)
   to <- ret[[1]]
   x <- ret[[2]]
   jx <- ret[[3]]
   nfe <- ret[[4]]
   T <- to
   
   # Armazena melhor solução encontrada
   xbest  <- x
   jxbest <- jx
   len1 <- length(xbest)
   len2 <- length(jxbest)
   obj  <- fobj(x,clientes,dimini,dimx)

   memory <- matrix(0, nrow=maxnfe, ncol=(len1 + len2))
   
   # Armazena a solução corrente
   memory[1,1:len1] <- t(xbest)
   memory[1,(len1+1):(len1+len2)] <- jxbest
   index <- 2
   
   # Critério de parada do algoritmo
   numEstagiosEstagnados <- 0
   
   # Critério de parada
   while ((numEstagiosEstagnados <= 10) && (nfe < maxnfe)) {
      print(paste("nfe1", nfe))   
      print(paste("numEstagiosEstagnados ", numEstagiosEstagnados ))   
      # Critérios para mudança de temperatura
      numAceites <- 0
      numTentativas <- 0
         
      # Fitness da solução submetida ao estágio k
      fevalin <- jxbest
   
      while ((numAceites < 12*dimx) && (numTentativas < 100*dimx) && (nfe < maxnfe)) {
         print(paste("nfe2", nfe))   
         print(paste("numAceites", numAceites))   
         print(paste("numTentativas", numTentativas))   
         
         # Gera uma solução na vizinhança de x
         y <- neighbor(xbest,clientes,sigma,dimini,dimx)
         retObj  <- fobj(y,clientes,dimini,dimx)
         jy <- retObj[[1]]
         y <- retObj[[5]]
         nfe <- nfe + 1      
         
         # Atualiza solução 
         DeltaE <- jy - jx
         if ((DeltaE <= 0) || (runif(1, 0, 1) <= exp(-DeltaE/T))) {
            x  <- y
            jx <- jy         
            numAceites <- numAceites + 1
            
            # Atualiza melhor solução encontrada
            if (jx < jxbest) {
               xbest  <- x
               jxbest <- jx 
               obj <- retObj
            }     
         }
         numTentativas <- numTentativas + 1   
         
         # Armazena a solução corrente
         memory[index,1:len1] <- t(x)
         memory[index,(len1+1):(len1+len2)] <- jx
         index <- index + 1
      }
               
      # Atualiza o desvio padrão da vizinhança  
      # A <- numAceites/numTentativas
      #if (A > 0.20),
      #  sigma = 1*sigma;
      #else if (A < 0.05)
      #   sigma = 1*sigma;
    
      # Atualiza a temperatura
      T <- 0.9*T
      
      # Avalia critério de estagnação
      if (jxbest < fevalin)
         numEstagiosEstagnados <- 0
      else
         numEstagiosEstagnados <- numEstagiosEstagnados + 1      
      
      # Avalia critério de reinicialização da temperatura
      if (T < 0.1)     
         T <- to
         
      # Atualiza contador de estágios de temperatura
      k <- k + 1
   }

   return(list(xbest, obj))
}

principal <- function(dimini, maxnfe) {
   print(dimini)
   dimx <- 2 * dimini + sz + 1
   m <- 1
   saida <- matrix(0, nrow=m, ncol=dimx)
   ponto <- matrix(0, nrow=m, ncol=5)
   for (i in 1:m) {
      ret <- SAreal(dimini, dimx, maxnfe)
      saida[i,] <- ret[[1]]
      obj <- ret[[2]]
      ponto[i,1] <- obj[[2]]
      ponto[i,2] <- obj[[3]]
      ponto[i,3] <- obj[[4]]
   }
   
   #vc <- 1e69
   #if (file.exists("valorN.csv")) {
   #   v <- as.matrix(read.csv("valorN.csv", sep=",", header=TRUE)) 
   #   vc <- v[1,2]
   #}
   ve <- 1e69
   s <- paste("valorDist", toString(dimini), ".csv", sep="")
   if (file.exists(s)) {
      v <- as.matrix(read.csv(s, sep=",", header=TRUE)) 
      ve <- v[2,2]
   }
     
   ponto[,4] <- ponto[,1]/max(ponto[,1])
   ponto[,5] <- ponto[,2]/max(ponto[,2])
   plot(ponto[,4],ponto[,5],col='blue',xlim=c(0,1),ylim = c(0,1),xlab='x',ylab='y')
   #j <- min(ponto[,1])
   #print(j)
   #i <- which.min(ponto[,1])
   #if (j < vc) {
   #   write.csv(ponto[i,], file="valorN.csv")
   #   write.csv(saida[i,], file="posicaoN.csv")
   #}
   j <- min(ponto[,2])
   print(j)
   i <- which.min(ponto[,2])
   if (j < ve) {
      write.csv(ponto[i,], file=s)
      write.csv(saida[i,], file=paste("posicaoDist", toString(dimini), ".csv", sep=""))
   }
}

principal(34, 10)

for (i in 17:33)
   principal(i, 5000)
principal(35, 5000)
principal(36, 5000)
principal(34, 5000)
principal(16, 5000)

 Mx1 <- 0
 Mx2 <- upper
 My1 <- 0
 My2 <- upper
 dev.off()
 for(i in 1:N) {
   plot(posicao[i,1],posicao[i,2],type = 'b', pch=1, col='blue',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
   par(new=T)
 }
 for(i in 1:sz) {
   plot(clientes[i,1],clientes[i,2],type = 'b', pch=1, col='blue',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
   par(new=T)
 }

m <- 36 - 15
ponto <- matrix(0, nrow=m, ncol=4)
for (i in 1:m) {
   s <- paste("valorDist", toString(i + 15), ".csv", sep="")
   v <- as.matrix(read.csv(s, sep=",", header=TRUE)) 
   v <- t(v)
   ponto[i,1] <- v[2,5000]
   ponto[i,2] <- v[3,5000]
}
ponto[,3] <- ponto[,1]/max(ponto[,1])
ponto[,4] <- ponto[,2]/max(ponto[,2])
plot(ponto[,3],ponto[,4],col='red',xlim=c(0,1),ylim = c(0,1),xlab='x',ylab='y')

for (i in 1:m)
    for (j in 1:m)
        if ((ponto[i,3] < ponto[j,3]) && (ponto[i,4] < ponto[j,4])) 
            ponto[j,] <- ponto[1,] # eu sei que o 1 pertence aos dominantes

ponto <- unique(ponto[,3:4])
par(new=T)
plot(ponto[,1],ponto[,2],col='blue',xlim=c(0,1),ylim = c(0,1),xlab='x',ylab='y')

d = matrix(0, 4)
for (i in 1:4)
   d[i] <- dist(ponto[i,], ponto[i + 1,])
avgd <- sum(d)/4
Delta <- sum(abs(d - avgd))/4/avgd
Delta

ref <- ponto[5,]
ref[2] <- ponto[1,2]
ref <- 1.1 * ref

A = matrix(0, 5)
A[1] <- (ref[1] - ponto[1,1]) * (ref[2] - ponto[1,2])
for (i in 2:5)
   A[i] <- (ref[1] - ponto[i,1]) * (ponto[i - 1,2] - ponto[i,2])
HV <- sum(A)
HV

x <- seq(1, 97, 1)
Delta <- as.matrix(read.csv("delta.csv", sep=",", header=TRUE)) 
Delta <- Delta[,2]
HV <- as.matrix(read.csv("hv.csv", sep=",", header=TRUE)) 
HV <- HV[,2]
y1 <- min(Delta) - 0.002
y2 <- max(Delta) + 0.002
plot(x,Delta,type='l',col='blue',xlim=c(0,97),ylim = c(y1,y2),xlab='x',ylab='y')

y1 <- min(HV) - 0.002
y2 <- max(HV) + 0.002
plot(x,HV,type='l',col='blue',xlim=c(0,97),ylim = c(y1,y2),xlab='x',ylab='y')
