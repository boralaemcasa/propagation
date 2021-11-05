setwd("V:\\sem backup\\_sistemas nebulosos 2021 02 agosto\\pela frente")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')

dist <- function(x, y, nc) {
   soma <- 0
   for (i in 1:nc)
      soma <- soma + (x[i] - y[i])^2
   return(sqrt(soma))
}

kmeans <- function(k, M, linhas, index) {
   nc <- index - 2
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
            distancia[j] <- dist(M[i,], centro[j,], nc)
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
         for (ell in 1:nc)
            novoCentro[j,ell] <- novoCentro[j,ell] / contador
      }
      flag <- TRUE
      for (j in 1:k)
         for (ell in 1:nc)
            if (novoCentro[j,ell] != centro[j,ell])
               flag <- FALSE
      if (flag)
         return(M)
      centro <- novoCentro
   }
}

fcmeans <- function(c, X, n, m, epsilon) {
   #c <- nclus
   #X <- totalM
   #m <- 2
   #epsilon <- 0.1

   p <- length(X[1,]) # colunas
   dE <- 1

   K <- matrix(0, nrow=c, ncol=p)
   for (i in 1:c) {
      a <- sample(1:n, 1)
      for (j in 1:p)
         K[i,j] <- X[a,j] + 0.1
   }

   while (dE > epsilon) {
      Uaux <- matrix(0, nrow=c, ncol=n)
      U <- matrix(0, nrow=c, ncol=n)
      D <- matrix(0, nrow=c, ncol=n)
      aux <- matrix(0, nrow=c, ncol=p)
      aux2 <- matrix(0, nrow=c, ncol=p)

      Ka <- K
      for (i in 1:c)
         for (j in 1:n)
            D[i,j] <- dist(X[j,1:p], K[i,], p)
      for (i in 1:c)
         for (j in 1:n) {
            for (k in 1:c)
               Uaux[i,j] <- Uaux[i,j] + (D[i,j]/D[k,j])^(2/(m - 1))
            U[i,j] <- 1/Uaux[i,j]
         }
      for (i in 1:c) {
         for (j in 1:n)
            for (k in 1:p) {
               aux[i,k] <- aux[i,k] + U[i,j]^m * X[j,k]
               aux2[i,k] <- aux2[i,k] + U[i,j]^m
            }
         K[i,] <- aux[i,]/aux2[i,]
      }
      dE <- norm(K - Ka)
      print(dE)
   }

   U <- t(U)
   v <- matrix(1, nrow=n, ncol=1)
   for (i in 1:n) {
      maximo <- U[i,1]
      for (j in 2:c)
         if (U[i,j] > maximo) {
            maximo <- U[i,j]
            v[i] <- j
         }
   }
   return(list(K, U, v))
}

xin <- as.matrix(read.csv("x.csv", sep=",", header=FALSE))
yin <- as.matrix(read.csv("y.csv", sep=",", header=FALSE))
for (i in 1:n) {
   if (yin[i] < 0) {
      yin[i] <- 2
      cor = "blue"
   }
   else cor = "red"
   plot(xin[i,1], xin[i,2], col=cor, xlim = c(-1,1), ylim = c(-1,1))
   par(new=T)
}
n <- length(yin)
nclus <- 2
m <- 2
toler <- 0.1
res <- fcmeans(nclus, xin, n, m, toler)
K <- res[[1]]
U <- res[[2]]
v <- res[[3]]
output <- matrix(0, n, 5)
acertos <- 0
for (i in 1:n) {
   for (j in 1:2)
      output[i,j] <- xin[i,j]
   output[i,3] <- yin[i]
   output[i,4] <- 3 - v[i]
   output[i,5] <- yin[i] - (3 - v[i])
   if (output[i,5] == 0)
      acertos <- acertos + 1
}
print(acertos)
for (i in 1:n) {
   if (3 - v[i] == 2) {
      cor = "blue"
   }
   else cor = "red"
   plot(xin[i,1], xin[i,2], col=cor, xlim = c(-1,1), ylim = c(-1,1))
   par(new=T)
}

#=====================

data("iris")
dados <- iris
tudo <- as.matrix(iris)
xin <- matrix(0, 150, 4)
yin <- matrix(0, 150, 1)
for (i in 1:150) {
  for (j in 1:4)
    xin[i,j] <- as.double(tudo[i,j])
  if (i <= 50)
    yin[i] <- 1
  else if (i <= 100)
    yin[i] <- 2
  else yin[i] <- 3
}

n <- length(yin)
nclus <- 3
m <- 2
toler <- 0.1
res <- fcmeans(nclus, xin, n, m, toler)
K <- res[[1]]
U <- res[[2]]
v <- res[[3]]
output <- matrix(0, n, 7)
acertos <- 0
for (i in 1:n) {
   for (j in 1:4)
      output[i,j] <- xin[i,j]
   output[i,5] <- yin[i]
   output[i,6] <- v[i]
   output[i,7] <- yin[i] - v[i]
   if (output[i,7] == 0)
      acertos <- acertos + 1
}
print(acertos)

#================

data("iris")
dados <- iris
tudo <- as.matrix(iris)
xin <- matrix(0, 150, 4)
yin <- matrix(0, 150, 1)
for (i in 1:150) {
  for (j in 1:4)
    xin[i,j] <- as.double(tudo[i,j])
  if (i <= 50)
    yin[i] <- 1
  else yin[i] <- 2
}

n <- length(yin)
nclus <- 2
m <- 2
toler <- 0.1
res <- fcmeans(nclus, xin, n, m, toler)
K <- res[[1]]
U <- res[[2]]
v <- res[[3]]
output <- matrix(0, n, 7)
acertos <- 0
for (i in 1:n) {
   for (j in 1:4)
      output[i,j] <- xin[i,j]
   output[i,5] <- yin[i]
   output[i,6] <- v[i]
   output[i,7] <- yin[i] - v[i]
   if (output[i,7] == 0)
      acertos <- acertos + 1
}
print(acertos)

