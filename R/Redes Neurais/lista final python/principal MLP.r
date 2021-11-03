setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
library('RSNNS')

sech2 <- function(u) {
   return (cosh(u)^-2)
}

xtrein <- as.matrix(read.csv("trainReduzido.csv", sep=",", header=TRUE))
xtrein <- xtrein[,2]
xtrein2 <- as.matrix(read.csv("trainGrau2.csv", sep=",", header=TRUE))
N <- length(xtrein)
s <- sample(N)
xtudo <- matrix(0, nrow=N, ncol=2849)
ytudo <- matrix(0, nrow=N, ncol=1)
for (i in 1:N) {
  xtudo[i,] <- xtrein2[s[i],2:2850]
  if (xtrein[s[i]] != 1)
    ytudo[i] <- -1
  else ytudo[i] <- 1
}

xyall <- splitForTrainingAndTest(xtudo, ytudo, ratio=0.1)
xtrain <- xyall$inputsTest
ytrain <- xyall$targetsTest
xtest <- xyall$inputsTrain
ytest <- xyall$targetsTrain
validar <- TRUE

xtrain <- xtudo
ytrain <- ytudo
xtest <- as.matrix(read.csv("validGrau2.csv", sep=",", header=TRUE))
xtest <- xtest[,2:2850]
ytest <- matrix(0, nrow=length(xtest[,1]), ncol=1)
validar <- FALSE

niteracoes <- 1
MSE <- matrix(nrow = niteracoes, ncol = 1)
for (iteracao in 1:niteracoes) {
   p <- 2850
   dimx <- 2850
   dimy <- 1
   Z <- matrix(runif(dimx*p - dimx) - 0.5, nrow = dimx, ncol = p - 1)
   W <- matrix(runif(p) - 0.5, nrow = p, ncol = dimy)
   
   xatual <- matrix(nrow = dimx, ncol = 1)
   yatual <- matrix(nrow = dimy, ncol = 1)
   tol <- 0.01
   eta <- 0.01
   maxepocas <- 4
   nepocas <- 0
   eepoca <- tol + 1
   evec <- matrix(nrow = maxepocas, ncol = 1)
   N <- length(xtrain[,1])
   minimo <- 1e9
   
   while ((nepocas < maxepocas) && (eepoca > tol)) {
      ei2 <- 0
      erros <- 0
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
         yhat <- yhat/abs(yhat)
         
         e <- yatual - yhat
         if (yatual != yhat)
            erros <- erros + 1
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
      evec[nepocas] <- erros # ei2/N
      eepoca <- evec[nepocas]
      if (evec[nepocas] < minimo) {
         Wmin <- W
         Zmin <- Z
         minimo <- evec[nepocas]
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
      U <- t(xatual) %*% Zmin
      H <- tanh(U)
      Haug <- cbind(H, 1)
      O <- t(Haug %*% Wmin)
      yhat <- tanh(O)
      #yhat <- yhat/abs(yhat)
      if (validar) {
         e <- t(yatual - yhat)
         ei2 <- ei2 + (e %*% t(e))
      }
      else ytest[i,] <- yhat
      if (iteracao == 5) {
         par(new=T)
         plot(xatual[1,1],yhat,col='blue',xlim=c(-0.1,6.3),ylim = c(-1.1,1.1),xlab='x',ylab='y')
      }
   }
   MSE[iteracao] <- ei2/N
   
#   for (i in 1:N)
#      if (ytest[i] < 0)
#         ytest[i] <- 0

   write.csv(ytest, file="valid_MLP_1.csv")
}

#plot(evec[1:nepocas], type = 'l')     
#par(new=T)

minimo

##########

setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
library('RSNNS')

sech2 <- function(u) {
   return (cosh(u)^-2)
}

xtrein <- as.matrix(read.csv("trainReduzido.csv", sep=",", header=TRUE))
xtrein <- xtrein[,2]
xtrein2 <- as.matrix(read.csv("trainGrau2.csv", sep=",", header=TRUE))
N <- length(xtrein)
s <- sample(N)
xtudo <- matrix(0, nrow=N, ncol=2849)
ytudo <- matrix(0, nrow=N, ncol=1)
for (i in 1:N) {
  xtudo[i,] <- xtrein2[s[i],2:2850]
  if (xtrein[s[i]] != 5)
    ytudo[i] <- -1
  else ytudo[i] <- 1
}

xyall <- splitForTrainingAndTest(xtudo, ytudo, ratio=0.1)
xtrain <- xyall$inputsTest
ytrain <- xyall$targetsTest
xtest <- xyall$inputsTrain
ytest <- xyall$targetsTrain
validar <- TRUE

xtrain <- xtudo
ytrain <- ytudo
xtest <- as.matrix(read.csv("validGrau2.csv", sep=",", header=TRUE))
xtest <- xtest[,2:2850]
ytest <- matrix(0, nrow=length(xtest[,1]), ncol=1)
validar <- FALSE

niteracoes <- 1
MSE <- matrix(nrow = niteracoes, ncol = 1)
for (iteracao in 1:niteracoes) {
   p <- 2850
   dimx <- 2850
   dimy <- 1
   Z <- matrix(runif(dimx*p - dimx) - 0.5, nrow = dimx, ncol = p - 1)
   W <- matrix(runif(p) - 0.5, nrow = p, ncol = dimy)
   
   xatual <- matrix(nrow = dimx, ncol = 1)
   yatual <- matrix(nrow = dimy, ncol = 1)
   tol <- 0.01
   eta <- 0.01
   maxepocas <- 4
   nepocas <- 0
   eepoca <- tol + 1
   evec <- matrix(nrow = maxepocas, ncol = 1)
   N <- length(xtrain[,1])
   minimo <- 1e9
   
   while ((nepocas < maxepocas) && (eepoca > tol)) {
      ei2 <- 0
      erros <- 0
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
         yhat <- yhat/abs(yhat)
         
         e <- yatual - yhat
         if (yatual != yhat)
            erros <- erros + 1
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
      evec[nepocas] <- erros # ei2/N
      eepoca <- evec[nepocas]
      if (evec[nepocas] < minimo) {
         Wmin <- W
         Zmin <- Z
         minimo <- evec[nepocas]
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
      U <- t(xatual) %*% Zmin
      H <- tanh(U)
      Haug <- cbind(H, 1)
      O <- t(Haug %*% Wmin)
      yhat <- tanh(O)
      #yhat <- yhat/abs(yhat)
      if (validar) {
         e <- t(yatual - yhat)
         ei2 <- ei2 + (e %*% t(e))
      }
      else ytest[i,] <- yhat
      if (iteracao == 5) {
         par(new=T)
         plot(xatual[1,1],yhat,col='blue',xlim=c(-0.1,6.3),ylim = c(-1.1,1.1),xlab='x',ylab='y')
      }
   }
   MSE[iteracao] <- ei2/N
   
#   for (i in 1:N)
#      if (ytest[i] < 0)
#         ytest[i] <- 0

   write.csv(ytest, file="valid_MLP_5.csv")
}

#plot(evec[1:nepocas], type = 'l')     
#par(new=T)

minimo

##########

setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
library('RSNNS')

sech2 <- function(u) {
   return (cosh(u)^-2)
}

xtrein <- as.matrix(read.csv("trainReduzido.csv", sep=",", header=TRUE))
xtrein <- xtrein[,2]
xtrein2 <- as.matrix(read.csv("trainGrau2.csv", sep=",", header=TRUE))
N <- length(xtrein)
s <- sample(N)
xtudo <- matrix(0, nrow=N, ncol=2849)
ytudo <- matrix(0, nrow=N, ncol=1)
for (i in 1:N) {
  xtudo[i,] <- xtrein2[s[i],2:2850]
  if (xtrein[s[i]] != 6)
    ytudo[i] <- -1
  else ytudo[i] <- 1
}

xyall <- splitForTrainingAndTest(xtudo, ytudo, ratio=0.1)
xtrain <- xyall$inputsTest
ytrain <- xyall$targetsTest
xtest <- xyall$inputsTrain
ytest <- xyall$targetsTrain
validar <- TRUE

xtrain <- xtudo
ytrain <- ytudo
xtest <- as.matrix(read.csv("validGrau2.csv", sep=",", header=TRUE))
xtest <- xtest[,2:2850]
ytest <- matrix(0, nrow=length(xtest[,1]), ncol=1)
validar <- FALSE

niteracoes <- 1
MSE <- matrix(nrow = niteracoes, ncol = 1)
for (iteracao in 1:niteracoes) {
   p <- 2850
   dimx <- 2850
   dimy <- 1
   Z <- matrix(runif(dimx*p - dimx) - 0.5, nrow = dimx, ncol = p - 1)
   W <- matrix(runif(p) - 0.5, nrow = p, ncol = dimy)
   
   xatual <- matrix(nrow = dimx, ncol = 1)
   yatual <- matrix(nrow = dimy, ncol = 1)
   tol <- 0.01
   eta <- 0.01
   maxepocas <- 4
   nepocas <- 0
   eepoca <- tol + 1
   evec <- matrix(nrow = maxepocas, ncol = 1)
   N <- length(xtrain[,1])
   minimo <- 1e9
   
   while ((nepocas < maxepocas) && (eepoca > tol)) {
      ei2 <- 0
      erros <- 0
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
         yhat <- yhat/abs(yhat)
         
         e <- yatual - yhat
         if (yatual != yhat)
            erros <- erros + 1
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
      evec[nepocas] <- erros # ei2/N
      eepoca <- evec[nepocas]
      if (evec[nepocas] < minimo) {
         Wmin <- W
         Zmin <- Z
         minimo <- evec[nepocas]
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
      U <- t(xatual) %*% Zmin
      H <- tanh(U)
      Haug <- cbind(H, 1)
      O <- t(Haug %*% Wmin)
      yhat <- tanh(O)
      #yhat <- yhat/abs(yhat)
      if (validar) {
         e <- t(yatual - yhat)
         ei2 <- ei2 + (e %*% t(e))
      }
      else ytest[i,] <- yhat
      if (iteracao == 5) {
         par(new=T)
         plot(xatual[1,1],yhat,col='blue',xlim=c(-0.1,6.3),ylim = c(-1.1,1.1),xlab='x',ylab='y')
      }
   }
   MSE[iteracao] <- ei2/N
   
#   for (i in 1:N)
#      if (ytest[i] < 0)
#         ytest[i] <- 0

   write.csv(ytest, file="valid_MLP_6.csv")
}

#plot(evec[1:nepocas], type = 'l')     
#par(new=T)

minimo

##########

setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
library('RSNNS')

sech2 <- function(u) {
   return (cosh(u)^-2)
}

xtrein <- as.matrix(read.csv("trainReduzido.csv", sep=",", header=TRUE))
xtrein <- xtrein[,2]
xtrein2 <- as.matrix(read.csv("trainGrau2.csv", sep=",", header=TRUE))
N <- length(xtrein)
s <- sample(N)
xtudo <- matrix(0, nrow=N, ncol=2849)
ytudo <- matrix(0, nrow=N, ncol=1)
for (i in 1:N) {
  xtudo[i,] <- xtrein2[s[i],2:2850]
  if (xtrein[s[i]] != 7)
    ytudo[i] <- -1
  else ytudo[i] <- 1
}

xyall <- splitForTrainingAndTest(xtudo, ytudo, ratio=0.1)
xtrain <- xyall$inputsTest
ytrain <- xyall$targetsTest
xtest <- xyall$inputsTrain
ytest <- xyall$targetsTrain
validar <- TRUE

xtrain <- xtudo
ytrain <- ytudo
xtest <- as.matrix(read.csv("validGrau2.csv", sep=",", header=TRUE))
xtest <- xtest[,2:2850]
ytest <- matrix(0, nrow=length(xtest[,1]), ncol=1)
validar <- FALSE

niteracoes <- 1
MSE <- matrix(nrow = niteracoes, ncol = 1)
for (iteracao in 1:niteracoes) {
   p <- 2850
   dimx <- 2850
   dimy <- 1
   Z <- matrix(runif(dimx*p - dimx) - 0.5, nrow = dimx, ncol = p - 1)
   W <- matrix(runif(p) - 0.5, nrow = p, ncol = dimy)
   
   xatual <- matrix(nrow = dimx, ncol = 1)
   yatual <- matrix(nrow = dimy, ncol = 1)
   tol <- 0.01
   eta <- 0.01
   maxepocas <- 4
   nepocas <- 0
   eepoca <- tol + 1
   evec <- matrix(nrow = maxepocas, ncol = 1)
   N <- length(xtrain[,1])
   minimo <- 1e9
   
   while ((nepocas < maxepocas) && (eepoca > tol)) {
      ei2 <- 0
      erros <- 0
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
         yhat <- yhat/abs(yhat)
         
         e <- yatual - yhat
         if (yatual != yhat)
            erros <- erros + 1
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
      evec[nepocas] <- erros # ei2/N
      eepoca <- evec[nepocas]
      if (evec[nepocas] < minimo) {
         Wmin <- W
         Zmin <- Z
         minimo <- evec[nepocas]
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
      U <- t(xatual) %*% Zmin
      H <- tanh(U)
      Haug <- cbind(H, 1)
      O <- t(Haug %*% Wmin)
      yhat <- tanh(O)
      #yhat <- yhat/abs(yhat)
      if (validar) {
         e <- t(yatual - yhat)
         ei2 <- ei2 + (e %*% t(e))
      }
      else ytest[i,] <- yhat
      if (iteracao == 5) {
         par(new=T)
         plot(xatual[1,1],yhat,col='blue',xlim=c(-0.1,6.3),ylim = c(-1.1,1.1),xlab='x',ylab='y')
      }
   }
   MSE[iteracao] <- ei2/N
   
#   for (i in 1:N)
#      if (ytest[i] < 0)
#         ytest[i] <- 0

   write.csv(ytest, file="valid_MLP_7.csv")
}

#plot(evec[1:nepocas], type = 'l')     
#par(new=T)

minimo

