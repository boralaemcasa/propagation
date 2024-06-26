setwd("V:\\sem backup\\_1 OTIMIZACAO MULTIOBJETIVO\\_tc")
rm(list=ls())

sz <- 500
upper <- 800
maxc <- 150
dsup <- 85
possib <- 100

initialSol <- function(dimini, dimx) {
   clientes <- as.matrix(read.csv("clientes.csv", sep=",", header=FALSE))
   clientes <- cbind(clientes, 0) # 4a coluna := N
   x <- matrix(0, dimx, 1) # ponto inicial do espaco
   x[dimx] <- dimini
   N <- dimini
   jx <- 1e69
   while (jx > 0.5e69) {
      atendidos <- sample(1:sz, 0.95 * sz)
      posicao <- kmeans(N, clientes[atendidos,], 0.95 * sz, 4)
      for (i in 1:N) {
         x[i] <- posicao[i,1]
         x[i + N] <- posicao[i,2]
      }
      ret <- fobj(x,clientes,dimini,dimx)
      jx <- ret[[1]]
   }
   return(list(x,clientes))
}

initialT <- function(x,clientes,sigma,nfe,dimini,dimx,maxnfe2) {
   N   <- maxnfe2  # n�mero de testes
   tau <- 0.20     # taxa de aceita��o inicial
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
       print(paste(dimini, "initialt k =", k))
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
   f <- 1e69
   f1 <- f
   f2 <- f
   f3 <- f
   N <- x[dimx]
   posicao <- matrix(0, N, 3)
   for (i in 1:N) {
      posicao[i,1] <- x[i]
      posicao[i,2] <- x[i + N]
   }

   # >= 95% * 500 = 475 t�m suas demandas integralmente atendidas?
   naoAtendidas <- 0
   atend <- matrix(0, sz, N)
   for (i in 1:sz) {
     clientes[i,4] <- 0
     for (j in 1:N)
        atend[i,j] <- dist(clientes[i,], posicao[j,])
     m <- min(atend[i,])
     # Um cliente pode ser atendido <=> d < 85 metros.
	 if (m >= dsup)
        naoAtendidas <- naoAtendidas + 1
	 else {
        # atender. preencher 4a coluna.
        for (j in 1:N)
	       if (atend[i,j] == m)
		      break
        clientes[i,4] <- j
	 }
   }

   if (naoAtendidas < 0.05 * sz) {
         # Cada ponto tem capacidade de 150 Mbps. Foi excedida?
         excesso <- 1
         somaDistancia <- 0
         for (j in 1:N)
            posicao[j,3] <- 0
         for (i in 1:sz) {
            j <- clientes[i,4]
            if (j > 0) {
               posicao[j,3] <- posicao[j,3] + clientes[i,3]
               somaDistancia <- somaDistancia + atend[i,j]
            }
         }
         for (j in 1:N)
            if (posicao[j,3] > maxc)
               excesso <- excesso + posicao[j,3] - maxc

         f1 <- N
         f2 <- somaDistancia
         f3 <- excesso
         f <- f2 * f3
   }
   
   for (i in 1:sz)
      x[2 * dimini + i] <- clientes[i,4]
   return(list(f, f1, f2, f3, x))
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

SAreal <- function(dim1, dim2, maxnfe, maxnfe2, diretorio) {
   index <- 0
   dimx <- 2 * dim2 + sz + 1
   ddim <- dim2 - dim1 + 1
   # Desvio padr�o inicial da vizinhan�a
   sigma <- 1 # 0.25
   xbest <- matrix(0, dimx)
   xout <- matrix(0, dimx, maxnfe) 
   pontos <- array(0, dim=c(maxnfe, 3, ddim))
   
   len1 <- dimx # len x
   len2 <- 1    # len jx
   for (dimini in dim1:dim2) {
      print(paste("dim", dimini))
      depth <- dimini - dim1 + 1
   
      # Contador de est�gios do m�todo
      k <- 0
      
      # Contador do n�mero de avalia��es de f(.)
      nfe <- 1 
      
      # Gera solu��o inicial
      ret <- initialSol(dimini,dimx)
      x <- ret[[1]]
      clientes <- ret[[2]]
      
      obj  <- fobj(x,clientes,dimini,dimx)
      for (index in 1:nfe) {
         pontos[index,1,depth] <- obj[[2]]
         pontos[index,2,depth] <- obj[[3]]
         pontos[index,3,depth] <- obj[[4]]
         xout[,index] <- x
      }

      write.csv(pontos[,,depth], file=paste("S", toString(diretorio), "\\valorDist", toString(dimini), ".csv", sep=""))
      write.csv(xout, file=paste("S", toString(diretorio), "\\posicaoDist", toString(dimini), ".csv", sep=""))
   }

   return(pontos)
}

principal <- function(dim1, dim2, maxnfe, maxnfe2) {
   pontos <- SAreal(dim1, dim2, maxnfe, maxnfe2)
   #dim1 <- 15
   #dim2 <- 36
   #maxnfe <- 5000
   N <- dim2 - dim1 + 1

   #pontos <- array(0, dim=c(maxnfe, 3, N))
   #for (dimini in dim1:dim2) {
   #   depth <- dimini - dim1 + 1
   #   mat <- as.matrix(read.csv(paste("S1\\valorDist", toString(dimini), ".csv", sep=""), sep=",", header=FALSE))
   #   pontos[,,depth] <- as.double(mat[2:(maxnfe+1),2:4])
   #}
   #for (dimini in dim1:dim2) {
   #   depth <- dimini - dim1 + 1
   #   for (i in 2:maxnfe)
   #      if (pontos[i,1,depth] == 0) {
   #         pontos[i,1,depth] <- pontos[i-1,1,depth]
   #         pontos[i,2,depth] <- pontos[i-1,2,depth]
   #         pontos[i,3,depth] <- pontos[i-1,3,depth]
   #      }
   #}

   x <- seq(1, maxnfe, 1)
   Delta <- matrix(0, maxnfe)
   HV <- matrix(0, maxnfe)
   
   for (depth in 1:maxnfe) {
      ponto <- cbind(pontos[depth,1,], pontos[depth,2,], 0, 0)
      ponto[,3] <- ponto[,1]/max(ponto[,1])
      ponto[,4] <- ponto[,2]/max(ponto[,2])
      #print(ponto)
      for (i in 1:N)
         for (j in 1:N)
            if ((ponto[i,3] < ponto[j,3]) && (ponto[i,4] < ponto[j,4])) 
               ponto[j,] <- ponto[1,] # eu sei que o 1 pertence aos dominantes

      print(unique(ponto))
      ponto <- unique(ponto[,3:4])

      m <- length(ponto[,1]) - 1
      if (m == 0)
        Delta[depth] <- 0
      else {
         d = matrix(0, m)
         for (i in 1:m)
           d[i] <- dist(ponto[i,], ponto[i + 1,])
         avgd <- sum(d)/m
         m <- m * avgd
         if (m == 0)
           m <- 1
         Delta[depth] <- sum(abs(d - avgd))/m
      }

      m <- length(ponto[,1])
      ref <- ponto[m,]
      ref[2] <- ponto[1,2]
      ref <- 1.1 * ref

      A = matrix(0, m)
      A[1] <- (ref[1] - ponto[1,1]) * (ref[2] - ponto[1,2])
      if (m >= 2)
      for (i in 2:m)
        A[i] <- (ref[1] - ponto[i,1]) * (ponto[i - 1,2] - ponto[i,2])
      HV[depth] <- sum(A)
   }

   write.csv(Delta, file="delta.csv")
   write.csv(HV, file="hv.csv")
   y1 <- min(Delta,HV) - 0.002
   y2 <- max(Delta,HV) + 0.002
   plot(x,Delta,type='l',col='blue',xlim=c(0,maxnfe),ylim = c(y1,y2),xlab='x',ylab='y')
   par(new=T)
   plot(x,HV,type='l',col='red',xlim=c(0,maxnfe),ylim = c(y1,y2),xlab='x',ylab='y')
}

#principal(33, 34, 3, 2)

#principal(37, 47, 5000, 100)

for (dimensao in 39:500)
   for (i in 1:5)
      pontos <- SAreal(dimensao, dimensao, 1, 1, i)

