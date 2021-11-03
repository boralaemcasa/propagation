setwd("V:\\sem backup\\_teoria da decisao R solve")
rm(list=ls())

initialSol <- function() {
   m = 10 #agentes
   n = 50 #tarefas
   recurso <- as.matrix(read.csv("a.csv", sep=",", header=FALSE))    # m x n
   capacidade <- as.matrix(read.csv("b.csv", sep=",", header=FALSE)) # m x 1
   custo <- as.matrix(read.csv("c.csv", sep=",", header=FALSE))      # m x n
   
   agente <- sample(1:10, 50, TRUE) # ponto inicial do espaço
   x <- agente
   return(list(x,custo,capacidade,recurso,n,m))
}

initialT <- function(x,custo,capacidade,recurso,nfe,m,n,w) {
   N   <- 100      # número de testes
   tau <- 0.20     # taxa de aceitação inicial
   X   <- matrix(0,N,m)
   jX  <- matrix(0,N,1)
   
   ret  <- fobj(x,recurso,custo,capacidade,w)
   jx <- ret[[1]]
   nfe <- nfe + 1
   X[1,] <- x
   jX[1]  <- jx
   
   i <- 0
   DeltaE <- matrix(0, nrow=N, ncol=1)
   for (k in 2:N) {
       X[k,] <- neighbor(x,recurso,capacidade,0)
       ret  <- fobj(X[k,],recurso,custo,capacidade,w)
       jX[k] <- ret[[1]]
       nfe <- nfe + 1 
       
       DE <- jX[k] - jx
       if (DE > 0) {
           i <- i + 1
           DeltaE[i] <- DE
       }
   }
   
   
   jx <- min(jX)
   jmin <- which.min(jX)
   x  <- X[jmin,]
   
   DeltaEM <- sum(DeltaE)/i
   to <- - DeltaEM/log(tau)
   return(list(to,x,jx,nfe))
}

fobj <- function(agente,recurso,custo,capacidade,w) {
   custoTotal <- 0
   for (j in 1:50)
      custoTotal <- custoTotal + custo[agente[j], j]

   ocupacao <- matrix(0, nrow=10)   
   for (j in 1:50)
      ocupacao[agente[j]] <- ocupacao[agente[j]] + recurso[agente[j], j]
   equilibrio <- max(ocupacao) - min(ocupacao)

   excesso <- 1
   for (i in 1:10) {
      x <- ocupacao[i] - capacidade[i]
      if (x > 0)
         excesso <- excesso + x
   }
   f1 <- custoTotal
   f2 <- equilibrio
   f3 <- excesso
   if (w == 0)
      w <- 0.001
   f = w * f1 * f3 + (1 - w) * f2
   return(list(f, f1, f2, f3))
}

neighbor <- function(x,recurso,capacidade,pp) {
   agente <- x # ponto inicial do espaço
   
   #vizinhança.perturbar
   j <- sample(1:50, 1)
   while (TRUE) {
      k <- sample(1:10, 1)
      if (k != agente[j])
         break
   }
   agente[j] <- k
         
   return(agente)
}

SAdiscreto <- function(w) {
   # Contador de estágios do método
   k <- 0
   
   # Contador do número de avaliações de f(.)
   nfe <- 0 
   
   # Gera solução inicial
   ret <- initialSol()
   x <- ret[[1]]
   custo <- ret[[2]]
   capacidade <- ret[[3]]
   recurso <- ret[[4]]
   n <- ret[[5]]
   m <- ret[[6]]
   
   # Define temperatura inicial
   ret <- initialT(x,custo,capacidade,recurso,nfe,n,m,w)
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
   
   memory <- matrix(0, nrow=5000, ncol=(len1 + len2))
   
   # Armazena a solução corrente
   memory[1,1:len1] <- t(xbest)
   memory[1,(len1+1):(len1+len2)] <- jxbest
   index <- 2
   
   # Critério de parada do algoritmo
   numEstagiosEstagnados <- 0
   
   # Critério de parada
   while ((numEstagiosEstagnados <= 10) && (nfe < 5000)) {
         
      # Critérios para mudança de temperatura
      numAceites <- 0
      numTentativas <- 0
         
      # Fitness da solução submetida ao estágio k
      fevalin <- jxbest
      pp <- 32
   
      while ((numAceites < 12*n) && (numTentativas < 100*n) && (nfe < 5000)) {
         
         # Gera uma solução na vizinhança de x
         y <- neighbor(x,recurso,capacidade,pp)
         pp <- pp / 1.1
         retObj  <- fobj(y,recurso,custo,capacidade,w)
         jy <- retObj[[1]]
         nfe <- nfe + 1      
         
         # Atualiza solução 
         DeltaE <- (jy - jx)
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
               
      # Atualiza a temperatura
      T <- 0.5*T
      
      # Avalia critério de estagnação
      if (jxbest < fevalin)
         numEstagiosEstagnados <- 0
      else
         numEstagiosEstagnados <- numEstagiosEstagnados + 1      
      
      # Avalia critério de reinicialização da temperatura
      if (T < 1e-1)     
         T <- to
         
      # Atualiza contador de estágios de temperatura
      k <- k + 1
   }

   return(list(xbest, obj, x))
}

fetch <- function(x,recurso,capacidade,custo,w) {
   capacidade <- cbind(capacidade, 0)
   penalidade <- 1000
   agente <- x[1:50] # ponto inicial do espaço
   agenteold <- agente
   while (penalidade >= 0) {
   
      for (contador in 1:200) {
         #vizinhança.perturbar
         j <- sample(1:50, 1)
         while (TRUE) {
            k <- sample(1:10, 1)
            if (k != agente[j])
               break
         }
         undoj <- j
         undoa <- agente[j]
         agente[j] <- k
   
         for (i in 1:10)
            capacidade[i, 2] <- 0
         for (j in 1:50)
            capacidade[agente[j], 2] <- capacidade[agente[j], 2] + recurso[agente[j], j]
         equilibrio <- max(capacidade[, 2]) - min(capacidade[, 2])
         
         flag = TRUE
         for (i in 1:10)
            if (capacidade[i, 2] > capacidade[i, 1] + penalidade) {
               flag = FALSE
               break
            }
         
         if (flag)
            break
            
         #vizinhança.desperturbar
         agente[undoj] <- undoa 
      }
      if (contador < 200)
         penalidade <- penalidade - 0.1
      else {
         agente <- agenteold
         penalidade <- 1000
      }
   }
   ret  <- fobj(agente,recurso,custo,capacidade,w)
   jx <- ret[[1]]
   agente <- cbind(t(agente), jx)
   return(t(agente))
}

principal <- function(N) {
   saida <- matrix(0, nrow=N, ncol=50)
   ponto <- matrix(0, nrow=N, ncol=5)
   for (i in 1:N) {
      print(i)
      ret <- SAdiscreto((i - 1)/N)
      saida[i,] <- ret[[1]]
      obj <- ret[[2]]
      ponto[i,1] <- obj[[2]]
      ponto[i,2] <- obj[[3]]
      ponto[i,3] <- obj[[4]]
   }
   
   v <- as.matrix(read.csv("valorCusto.csv", sep=",", header=TRUE)) 
   vc <- v[1,2]
   v <- as.matrix(read.csv("valorEquilibrio.csv", sep=",", header=TRUE)) 
   ve <- v[1,2]
     
   ponto[,4] <- ponto[,1]/max(ponto[,1])
   ponto[,5] <- ponto[,2]/max(ponto[,2])
   plot(ponto[,4],ponto[,5],col='black',xlim=c(0,1),ylim = c(0,1),xlab='x',ylab='y')
   j <- min(ponto[,1])
   print(j)
   i <- which.min(ponto[,1])
   if (j < vc) {
      write.csv(j, file="valorCusto.csv")
      write.csv(saida[i,], file="agenteCusto.csv")
   }
   j <- min(ponto[,2])
   print(j)
   i <- which.min(ponto[,2])
   if (j < ve) {
      write.csv(j, file="valorEquilibrio.csv")
      write.csv(saida[i,], file="agenteEquilibrio.csv")
   }
}

for (i in 6:51)
   principal(i)
