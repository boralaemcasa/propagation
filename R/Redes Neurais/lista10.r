setwd("V:\\sem backup\\_redes neurais 2021\\lista 10")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
library('RSNNS')

sech2 <- function(u) {
   return (cosh(u)^-2)
}

MSE <- matrix(nrow = 5, ncol = 1)
for (iteracao in 1:5) {
   p <- 3
   Z <- matrix(runif(2*p - 2) - 0.5, nrow = 2, ncol = p - 1)
   W <- matrix(runif(p) - 0.5, nrow = p, ncol = 1)
   
   xtrain <- seq(from = 0, to = 2 * pi, by = 0.15)
   xtrain <- xtrain + (runif(length(xtrain)) - 0.5)/5
   xatual <- matrix(nrow = 2, ncol = 1)
   ytrain <- sin(xtrain)
   ytrain <- ytrain + (runif(length(ytrain)) - 0.5)/5
   xtest <- seq(from = 0, to = 2 * pi, by = 0.01)
   ytest <- sin(xtest)

   tol <- 0.01
   eta <- 0.01
   maxepocas <- 3000
   nepocas <- 0
   eepoca <- tol + 1
   N <- length(xtrain)
   evec <- matrix(nrow = maxepocas, ncol = 1)
   
   while ((nepocas < maxepocas) && (eepoca > tol)) {
      ei2 <- 0
      # sequencia aleatoria de trainamento
      xseq <- sample(N)
      for (i in 1:N) {
         #amostra dado da sequencia aleatoria
         irand <- xseq[i]
         
         xatual[1,1] <- xtrain[irand]
         xatual[2,1] <- 1
         
         yatual <- ytrain[irand]
         
         U <- t(xatual) %*% Z # xatual eh 2x1 e Z eh 2x(p-1)
         H <- tanh(U)
         Haug <- cbind(H, 1) # Haug eh 1xp
         
         O <- Haug %*% W
         yhat <- tanh(O)
         
         e <- yatual - yhat
         flinhaO <- sech2(O)
         dO <- e * flinhaO           # .*
         Wminus <- W[-3,]            # retirar polarizacao
         ehidden <- dO %*% t(Wminus) # dO eh 1x1, W eh px1, ehidden eh 1x(p - 1)
          
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

   if (iteracao == 5)
      plot(xtest,ytest,type = 'l',col='red',xlim=c(-0.1,6.3),ylim = c(-1.1,1.1),xlab='x',ylab='y')
   
   ei2 <- 0
   N <- length(ytest)
   for (i in 1:N) {
      xatual[1,1] <- xtest[i]
      xatual[2,1] <- 1
      yatual <- ytest[i]
      U <- t(xatual) %*% Z # xatual eh 2x1 e Z eh 2x2
      H <- tanh(U)
      Haug <- cbind(H, 1) # Haug eh 1x3
      O <- Haug %*% W
      yhat <- tanh(O)
      e <- yatual - yhat
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

