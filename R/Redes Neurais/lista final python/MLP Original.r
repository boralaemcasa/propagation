setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
library('RSNNS')

sech2 <- function(u) {
   return (cosh(u)^-2)
}

niteracoes <- 1
MSE <- matrix(nrow = niteracoes, ncol = 1)
for (iteracao in 1:niteracoes) {
   p <- 3
   dimx <- 3
   dimy <- 2
   Z <- matrix(runif(dimx*p - dimx) - 0.5, nrow = dimx, ncol = p - 1)
   W <- matrix(runif(p) - 0.5, nrow = p, ncol = dimy)

   xtrain <- seq(from = 0, to = 2 * pi, by = 0.15)
   xtrain <- xtrain + (runif(length(xtrain)) - 0.5)/5
   ytrain <- sin(xtrain)
   xtrain <- cbind(xtrain, 0)
   xtrain2 <- seq(from = 0, to = 2 * pi, by = 0.15)
   xtrain2 <- xtrain2 + (runif(length(xtrain)) - 0.5)/5
   ytrain2 <- cos(xtrain2)
   xatual <- matrix(nrow = dimx, ncol = 1)
   yatual <- matrix(nrow = dimy, ncol = 1)
   ytrain <- cbind(ytrain, 0)
   N <- length(xtrain[,1])
   for (i in 1:N) {
      xtrain[i,2] <- xtrain2[i]
      ytrain[i,2] <- ytrain2[i]
   }
   xtest <- seq(from = 0, to = 2 * pi, by = 0.01)
   ytest <- sin(xtest)
   xtest <- cbind(xtest, 0)
   xtest2 <- seq(from = 0, to = 2 * pi, by = 0.01)
   ytest2 <- cos(xtest)
   ytest <- cbind(ytest, 0)
   ntest <- length(xtest[,1])
   for (i in 1:ntest) {
      xtest[i,2] <- xtest2[i]
      ytest[i,2] <- ytest2[i]
   }

   tol <- 0.01
   eta <- 0.01
   maxepocas <- 3000
   nepocas <- 0
   eepoca <- tol + 1
   evec <- matrix(nrow = maxepocas, ncol = 1)

   while ((nepocas < maxepocas) && (eepoca > tol)) {
      ei2 <- 0
      # sequencia aleatoria de trainamento
      xseq <- sample(N)
      for (i in 1:N) {
         #amostra dado da sequencia aleatoria
         irand <- xseq[i]

         xatual[1:(dimx-1),1] <- xtrain[irand,]
         xatual[dimx,1] <- 1

         yatual <- ytrain[irand,]

         U <- t(xatual) %*% Z # xatual eh dimx x 1 e Z eh dimx x (p-1)
         H <- tanh(U)
         Haug <- cbind(H, 1) # Haug eh 1xp

         O <- t(Haug %*% W) # 1xp x p x dimy
         yhat <- tanh(O)    # dimy x 1

         e <- yatual - yhat
         flinhaO <- sech2(O)
         dO <- t(e * flinhaO)        # .*
         Wminus <- W[-p,]            # retirar polarizacao
         ehidden <- dO %*% t(Wminus) # dO eh dimy x 1, W eh p x dimy, ehidden eh 1x(p - 1)

         flinhaU <- sech2(U)
         dU <- ehidden * flinhaU     # .*

         W <- W + eta * (t(Haug) %*% dO)
         Z <- Z + eta * (xatual %*% dU)
         ei2 <- ei2 + (e %*% t(e))
      }
      nepocas <- nepocas + 1
      evec[nepocas] <- ei2/N
      eepoca <- evec[nepocas]
   }
}
   if (iteracao == 5)
      plot(xtest,ytest,type = 'l',col='red',xlim=c(-0.1,6.3),ylim = c(-1.1,1.1),xlab='x',ylab='y')

   ei2 <- 0
   N <- length(ytest[,1])
   for (i in 1:N) {
      xatual[1:(dimx-1),1] <- xtest[i,]
      xatual[dimx,1] <- 1
      yatual <- ytest[i,]
      U <- t(xatual) %*% Z
      H <- tanh(U)
      Haug <- cbind(H, 1)
      O <- t(Haug %*% W)
      yhat <- tanh(O)
      e <- t(yatual - yhat)
      ei2 <- ei2 + (e %*% t(e))
      if (iteracao == 5) {
         par(new=T)
         plot(xatual[1,1],yhat,col='blue',xlim=c(-0.1,6.3),ylim = c(-1.1,1.1),xlab='x',ylab='y')
      }
   }
   MSE[iteracao] <- ei2/N
}

#plot(evec[1:nepocas], type = 'l')
#par(new=T)

mean(MSE)
sd(MSE)

