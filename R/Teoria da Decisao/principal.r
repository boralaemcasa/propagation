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
   jx <- 1e69
   while (jx > 0.5e69) {
      N <- dimini
      posicao <- kmeans(N, clientes, sz, 4)
      for (i in 1:N) {
         x[i] <- posicao[i,1]
         x[i + N] <- posicao[i,2]
      }

         N <- x[dimx]
         atend <- matrix(0, sz, N)
         for (i in 1:sz)
            for (j in 1:N)
               if (dist(clientes[i,], posicao[j,]) < dsup)
                  atend[i,j] <- 1

		 for (i in 1:sz) {
		    soma <- sum(atend[i,])
			if (soma == 0)
			   x[2 * dimini + i] <- 0
			else {
			   while (T) {
			      j <- sample(1:N, 1)
				  if (atend[i,j] > 0.5)
				     break
			   }
			   x[2 * dimini + i] <- j
			}   
		 }

      ret <- fobj(x,clientes,dimini,dimx)
      jx <- ret[[1]]
      print("loop")
   }
   return(list(x,clientes))
}

initialT <- function(x,clientes,sigma,nfe,dimini,dimx,maxnfe2) {
   N   <- maxnfe2  # número de testes
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

   # >= 95% * 500 = 475 têm suas demandas integralmente atendidas?
   naoAtendidas <- 0
   for (i in 1:sz)
      if (x[2*dimini + i] < 1)
         naoAtendidas <- naoAtendidas + 1

   if (naoAtendidas < 0.05 * sz) {
      # Cada ponto tem capacidade de 150 Mbps. Foi excedida?
      excesso <- 1
      somaDistancia <- 0
      for (j in 1:N)
         posicao[j,3] <- 0
      for (i in 1:sz) {
         j <- x[2*dimini + i]
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
   }
   
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

         N <- x[dimx]
         posicao <- matrix(0, N, 3)
         for (i in 1:N) {
            posicao[i,1] <- y[i]
            posicao[i,2] <- y[i + N]
         }
         atend <- matrix(0, sz, N)
         for (i in 1:sz)
            for (j in 1:N)
               if (dist(clientes[i,], posicao[j,]) < dsup)
                  atend[i,j] <- 1

		 for (i in 1:sz) {
		    soma <- sum(atend[i,])
			if (soma == 0)
			   y[2 * dimini + i] <- 0
			else {
			   while (T) {
			      j <- sample(1:N, 1)
				  if (atend[i,j] > 0.5)
				     break
			   }
			   y[2 * dimini + i] <- j
			}   
		 }
      #}
      ret <- fobj(y,clientes,dimini,dimx)
      jx <- ret[[1]]
   }
   
   return(y)
}

SAreal <- function(dim1, dim2, maxnfe, maxnfe2) {
	index <- 0
	dimx <- 2 * dim2 + sz + 1
	ddim <- dim2 - dim1 + 1
	# Desvio padrão inicial da vizinhança
	sigma <- 1 # 0.25
	xbest <- array(0, dim=c(maxnfe, dimx, ddim))
	jxbest <- matrix(0, ddim)
	x <- matrix(0, dimx, ddim)
	y <- matrix(0, dimx, ddim)
	to <- matrix(0, ddim)
	jx <- matrix(0, ddim)
	jy <- matrix(0, ddim)
	T <- matrix(0, ddim)
	numAceites <- matrix(0, ddim)
	numTentativas <- matrix(0, ddim)
	fevalin <- matrix(0, ddim)

	# Contador do número de avaliações de f(.)
	nfe <- matrix(0, ddim)
	contador <- matrix(0, ddim)
	index <- matrix(0, ddim)

	ponto <- array(0, dim=c(maxnfe, 3, ddim))
	pareto <- array(0, dim=c(maxnfe, 2, ddim))
	len1 <- dimx # len x
	len2 <- 1    # len jx
   
	# Contador de estágios do método
	k <- 0

	# Gera solução inicial
	for (dimini in dim1:dim2) {
		depth <- dimini - dim1 + 1
		print(paste(dimini, "initialsol"))
		ret <- initialSol(dimini,dimx)
		x[,depth] <- ret[[1]]
		clientes <- ret[[2]]

		# Define temperatura inicial
		print(paste(dimini, "initialt"))
		ret <- initialT(x[,depth],clientes,sigma,nfe[depth],dimini,dimx,maxnfe2)
		print(paste(dimini, "next"))
		to[depth] <- ret[[1]]
		x[,depth] <- ret[[2]]
		jx[depth] <- ret[[3]]
		nfe[depth] <- ret[[4]]
		T[depth] <- to[depth]

		# Armazena melhor solução encontrada
		xbest[1,,depth]  <- x[,depth]
		jxbest[depth] <- jx[depth]
		obj  <- fobj(x[,depth],clientes,dimini,dimx)
		ponto[1,1,depth] <- obj[[2]]
		ponto[1,2,depth] <- obj[[3]]
		ponto[1,3,depth] <- obj[[4]]

		# Armazena a solução corrente
		pareto[1,1,depth] <- obj[[2]]
		pareto[1,2,depth] <- obj[[3]]
		index[depth] <- 2
	}
	  
	contador <- 2

	# Critério de parada do algoritmo
	numEstagiosEstagnados <- matrix(0, ddim)

	# Critério de parada
	for (dimini in dim1:dim2) {
            print(paste("nfe", t(nfe)))
		depth <- dimini - dim1 + 1
		while (nfe[depth] <= maxnfe) {
			if ((numEstagiosEstagnados[depth] <= 10) && (nfe[depth] <= maxnfe)) {
		 
				# Critérios para mudança de temperatura
				numAceites[depth] <- 0
				numTentativas[depth] <- 0

				# Fitness da solução submetida ao estágio k
				fevalin[depth] <- jxbest[depth]

				while (nfe[depth] <= maxnfe) {
					for (dimini2 in dim1:dim2) {
						depth <- dimini2 - dim1 + 1
						if ((numAceites[depth] < 12*dimx) && (numTentativas[depth] < 100*dimx) && (nfe[depth] <= maxnfe)) {
							# Gera uma solução na vizinhança de x
							y[,depth] <- neighbor(xbest[contador-1,,depth],clientes,sigma,dimini2,dimx)
							retObj  <- fobj(y[,depth],clientes,dimini2,dimx)
							jy[depth] <- retObj[[1]]
							y[,depth] <- retObj[[5]]
							nfe[depth] <- nfe[depth] + 1 

							# Atualiza solução 
							DeltaE <- jy[depth] - jx[depth]
							if ((DeltaE <= 0) || (runif(1, 0, 1) <= exp(-DeltaE/T[depth]))) {
								x[,depth]  <- y[,depth]
								jx[depth] <- jy[depth]         
								numAceites[depth] <- numAceites[depth] + 1

								# Atualiza melhor solução encontrada
								if (jx[depth] < jxbest[depth]) {
									xbest[contador,,]  <- x
									jxbest[depth] <- jx[depth] 
									obj <- retObj
									ponto[contador,1,depth] <- retObj[[2]]
									ponto[contador,2,depth] <- retObj[[3]]
									ponto[contador,3,depth] <- retObj[[4]]
									contador <- contador + 1
								}     
							}
							numTentativas[depth] <- numTentativas[depth] + 1   
						}
						pareto[index[depth],1,depth] <- ponto[contador-1,1,depth]
						pareto[index[depth],2,depth] <- ponto[contador-1,2,depth]
						index[depth] <- index[depth] + 1
					}
				}
			}
		}
               
		# Atualiza o desvio padrão da vizinhança  
		# A <- numAceites/numTentativas
		#if (A > 0.20),
		#  sigma = 1*sigma;
		#else if (A < 0.05)
		#   sigma = 1*sigma;

		# Atualiza a temperatura
		for (dimini in dim1:dim2) {
			depth <- dimini - dim1 + 1
			T[depth] <- 0.9*T[depth]

			# Avalia critério de estagnação
			if (jxbest[depth] < fevalin[depth])
				numEstagiosEstagnados[depth] <- 0
			else
				numEstagiosEstagnados[depth] <- numEstagiosEstagnados[depth] + 1      

			# Avalia critério de reinicialização da temperatura
			if (T[depth] < 0.1)     
				T[depth] <- to[depth]
		}
			   
		# Atualiza contador de estágios de temperatura
		k <- k + 1
	}
	    
	for (k in 1:ddim)	
		for (j in 1:2)
			for (i in 2:maxnfe) 
				if (pareto[i,j,k] == 0)
					pareto[i,j,k] <- pareto[i-1,j,k]

	for (k in 1:ddim)	
		for (j in 1:3)
			for (i in 2:(contador - 1)) 
				if (ponto[i,j,k] == 0)
					ponto[i,j,k] <- ponto[i-1,j,k]

	for (dimini in dim1:dim2) {
		depth <- dimini - dim1 + 1
		write.csv(t(ponto[,,depth]), file=paste("valorDist", toString(dimini), ".csv", sep=""))
		write.csv(t(xbest[,,depth]), file=paste("posicaoDist", toString(dimini), ".csv", sep=""))
	}

	return(list(pareto, contador - 1))
}

principal <- function(dim1, dim2, maxnfe, maxnfe2) {
   v <- SAreal(dim1, dim2, maxnfe, maxnfe2)
   pontos <- v[[1]]
   maxnfe <- v[[2]]
   N <- dim2 - dim1 + 1
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
   plot(x,Delta,type='b',col='blue',xlim=c(0,maxnfe),ylim = c(y1,y2),xlab='x',ylab='y')
   par(new=T)
   plot(x,HV,type='b',col='red',xlim=c(0,maxnfe),ylim = c(y1,y2),xlab='x',ylab='y')
}

#x <- seq(1, 2125, 1)
#Delta <- as.matrix(read.csv("delta.csv", sep=",", header=TRUE)) 
#Delta <- Delta[,2]
#HV <- as.matrix(read.csv("hv.csv", sep=",", header=TRUE)) 
#HV <- HV[,2]
#y1 <- min(Delta) - 0.002
#y2 <- max(Delta) + 0.002
#plot(x,Delta,type='l',col='blue',xlim=c(0,2125),ylim = c(y1,y2),xlab='x',ylab='y')

#y1 <- min(HV) - 0.002
#y2 <- max(HV) + 0.002
#plot(x,HV,type='l',col='blue',xlim=c(0,2125),ylim = c(y1,y2),xlab='x',ylab='y')

#principal(33, 34, 10, 2)

principal(16, 36, 5000, 100)
