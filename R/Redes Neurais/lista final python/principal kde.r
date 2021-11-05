setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())

xvalid <- as.matrix(read.csv("validacao.csv", sep=",", header=TRUE))
output <- xvalid[,1]
output <- cbind(output, 0)
xvalid <- as.matrix(read.csv("validSemColunaZero.csv", sep=",", header=TRUE))
xvalid <- xvalid[,2:75]
nValid <- length(xvalid [,1])
length(xvalid [1,])

pdfnvar <- function(x,m,K,n) {1/sqrt((2*pi)^n * (det(K)))*exp(-0.5*(t(x - m)%*%(solve(K))%*%(x-m)))}

p <- function(j, n, v) {
  h <- 1.06 * sd(v) / n^0.2
  soma <- 0
  for (i in 1:n)
    soma <- soma + 1/h * 1/sqrt(2*pi) * exp(-0.5 * ((v(j) - v(i))/h)^2 )

  return (1/n * soma)
}

p2 <- function(v, n, M) {
  h1 <- 1.06 * sd(teste[,1]) / n^0.2
  h2 <- 1.06 * sd(teste[,2]) / n^0.2
  soma <- 0
  for (i in 1:n)
    soma <- soma + 1/h1 * 1/sqrt(2*pi) * exp(-0.5 * ((v[1] - M[i,1])/h1)^2 ) * 1/h2 * 1/sqrt(2*pi) * exp(-0.5 * ((v[2] - M[i,2])/h2)^2 )

  return (1/n * soma)
}

n <- 13017
nn <- 4
colunas <- 75
nx <- 74
colunay <- 75
final <- 76
acuracia <- matrix(0,nrow=10, ncol=nn)
nnn <- 20
totalM <- as.matrix(read.csv("kmeans20.csv", sep=",", header=TRUE))
totalM <- totalM[,2:77]
#totalM[,75]
for (i in 1:n) {
   for (j in 1:74)
      totalM[i,j] <- totalM[i,j] + 1
   if (totalM[i,75] > 1)
      totalM[i,75] <- totalM[i,75] - 3  #567 <- 234
}
pedaco <- matrix(0, nrow=1302, ncol=final)
j <- 1
for (i in 1:n)
   if (i %% 10 == 1) {
      pedaco[j,] <- totalM[i,]
      j <- j + 1
   }
totalM <- pedaco
n <- 1302

for (classe in 1:1) { #nn
   #classe <- 3
   offset <- 0
   for (kk in 1:1) { #10 calcular acuracia[kk] da classe
      #kk <- 1
      cccc <- matrix(0,nrow=nn)
      xc <- array(0, c(n,colunas,nn))

      for (i in 1:n) {
         jj <- totalM[i, colunay]
         cccc[jj] <- cccc[jj] + 1
         for (j in 1:colunas)
            xc[cccc[jj], j, jj] <- totalM[i, j]
      }

      testeN <- trunc(cccc[classe] * 0.1)
      if (cccc[classe] %% 10 != 0)
         if (kk %% 2 == 0)
            testeN <- testeN + 1
      if (offset + testeN > cccc[classe])
         testeN <- cccc[classe] - offset
      teste <- matrix(0,nrow=testeN,ncol=nx)
      trein <- matrix(0,nrow=cccc[classe]-testeN,ncol=final)
      c <- 1
      t <- 1
      for (i in 1:n)
         if (totalM[i, colunay] == classe) {
            flag <- 0
            if ((c > offset) & (c - offset <= testeN)) {
               for (j in 1:nx)
                  teste[c - offset, j] <- totalM[i, j]
                flag <- 1
             }
              if (flag == 0) {
                if (t <= cccc[classe] - testeN)
                   for (j in 1:final)
                       trein[t, j] <- totalM[i, j]
                   t <- t + 1
             }
             c <- c + 1
         }

      cc <- matrix(0,nrow=nnn)
      yc <- array(0, c(n,nx,nnn))
      for (jj in 1:nnn)
         for (i in 1:n) {
            if (totalM[i, final] == jj)
               cc[jj] <- cc[jj] + 1
            for (j in 1:nx)
               yc[cc[jj], j, jj] <- totalM[i, j]
         }

      media <- matrix(0,nrow=nnn,ncol=nx)
      maxk <- matrix(0,nrow=testeN)
      for (jj in 1:nnn) {
         contador <- 0
         for (j in 1:n)
            if (totalM[j, final] == jj) {
               for (ell in 1:nx)
                  media[jj,ell] <- media[jj,ell] + totalM[j,ell]
               contador <- contador + 1
            }
         for (ell in 1:nx)
            media[jj,ell] <- media[jj,ell] / contador
      }

      p <- matrix(0,nrow=testeN,ncol=nnn)
      for (jj in 1:nnn) {
         K <- cov(yc[,,jj])
         for (i in 1:nx)
            K[i,i] <- K[i,i] + 1e-9
         for (i in 1:testeN)
            p[i,jj] <- pdfnvar(teste[i,], media[jj,], K, nx) * cc[jj]
      }

      flag <- matrix(0,nrow=nnn)
      for (i in 1:n)
         if (totalM[i,colunay] == classe) {
            jj <- totalM[i,final]
            flag[jj] <- flag[jj] + 1
         }

      acertos <- 0
      for (i in 1:testeN) {
         denomm <- 0
         numeradorr <- 0
         for (jj in 1:nnn)
            if (flag[jj] > 0)
               numeradorr <- numeradorr + p[i,jj]
            else
               denomm <- denomm + p[i,jj]

         if (denomm == 0)
            acertos <- acertos + 1
         else {
            f <- numeradorr / denomm
            if (f >= 1)
               acertos <- acertos + 1
         }
      }

      acuracia[kk,classe] <- acertos * 100 / testeN
      offset <- offset + testeN

      if (kk == 1) { # so falta trocar pelo maximo da acuracia[coluna classe]
         for (i in 1:nValid) {
            #i <- 1
            pp <- matrix(0,nrow=nnn,ncol=1)
            x <- xvalid [i,]
            for (jj in 1:nnn)
               pp[jj] <- pdfnvar(x, media[jj,], K, nx) * cc[jj]

            denom <- 0
            numerador <- 0
            for (jj in 1:nnn)
               if (flag[jj] > 0)
                  numerador <- numerador + pp[jj]
               else
                  denom <- denom + pp[jj]

            if (denom == 0)
               output[i,2] <- classe
            else {
               f <- numerador / denom
               if (f >= 1)
                  output[i,2] <- classe
            }
         }
      }
   }
}

