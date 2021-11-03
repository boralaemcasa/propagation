rm(list=ls())
library('plot3D')
library('mlbench')

dist <- function(x, y) { sqrt((x[1] - y[1])^2 + (x[2] - y[2])^2) }

kmeans <- function(k, M, linhas, index) {
   centro <- matrix(0,ncol=2,nrow=k)
   for (i in 1:k) {
      a <- sample(1:linhas, 1)
      centro[i,1] <- M[a,1]
      centro[i,2] <- M[a,2]
   }
   distancia <- matrix(0,k)
   novoCentro <- matrix(0,ncol=2,nrow=k)
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
         sx <- 0
         sy <- 0
         contador <- 0
         for (i in 1:linhas)
            if (M[i, index] == j) {
               sx <- sx + M[i,1]
               sy <- sy + M[i,2]
               contador <- contador + 1
            }
         novoCentro[j,1] <- sx / contador
         novoCentro[j,2] <- sy / contador
      }
      flag <- TRUE
      for (j in 1:k)
         if ((novoCentro[j,1] != centro[j,1]) | (novoCentro[j,2] != centro[j,2]))
            flag <- FALSE
      if (flag)
         return(M)
      centro <- novoCentro
   }
}

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

n <- 1000
totalM <- matrix(0,ncol=4,nrow=n)
for (i in 1:250)
  totalM[i,] <- c(rnorm(1) * 0.4 + 2, rnorm(1) * 0.4 + 2, 1, 0)
for (i in 251:500)
  totalM[i,] <- c(rnorm(1) * 0.4 + 4, rnorm(1) * 0.4 + 2, 2, 0)
for (i in 501:750)
  totalM[i,] <- c(rnorm(1) * 0.4 + 4, rnorm(1) * 0.4 + 4, 3, 0)
for (i in 751:1000)
  totalM[i,] <- c(rnorm(1) * 0.4 + 2, rnorm(1) * 0.4 + 4, 4, 0)

nn <- 4
linhas <- 1000
colunas <- 3
final <- 4
acuracia <- matrix(0,nrow=10, ncol=nn)
nnn <- 20
totalM <- kmeans(nnn, totalM, linhas, 4)
  
seqi<-seq(0 + 0.06,6,0.06)
seqj<-seq(0 + 0.06,6,0.06)
M1 <- matrix(0,nrow=length(seqi),ncol=length(seqj))
numerador <- matrix(0,nrow=length(seqi),ncol=length(seqj))
denom <- matrix(0,nrow=length(seqi),ncol=length(seqj))

for (classe in 1:nn) {
   #classe <- 1
   offset <- 0
   for (kk in 1:10) { #calcular acuracia[kk] da classe
      #kk <- 1
      cccc <- matrix(0,nrow=nn)
      xc <- array(0, c(n,colunas,nn))
  
      for (i in 1:linhas) {
         jj <- totalM[i, 3]
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
      teste <- matrix(0,nrow=testeN,ncol=2)
      trein <- matrix(0,nrow=cccc[classe]-testeN,ncol=4)
      c <- 1
      t <- 1
      for (i in 1:linhas)
         if (totalM[i, 3] == classe) {
            flag <- 0
            if ((c > offset) & (c - offset <= testeN)) {
               for (j in 1:2)
                  teste[c - offset, j] <- totalM[i, j]
                flag <- 1
             }
              if (flag == 0) {
                if (t <= cccc[classe] - testeN)
                   for (j in 1:4)
                       trein[t, j] <- totalM[i, j]
                   t <- t + 1
             }
             c <- c + 1
         }

      cc <- matrix(0,nrow=nnn)
      yc <- array(0, c(n,2,nnn))
      for (jj in 1:nnn)
         for (i in 1:n) {
            if (totalM[i, 4] == jj)
               cc[jj] <- cc[jj] + 1
            for (j in 1:2)
               yc[cc[jj], j, jj] <- totalM[i, j]
         }

      media <- matrix(0,nrow=nnn,ncol=2)
      maxk <- matrix(0,nrow=testeN)
      for (jj in 1:nnn) {
         somax <- 0
         somay <- 0
         contador <- 0
         for (j in 1:linhas) 
            if (totalM[j, 4] == jj) {
               somax <- somax + totalM[j,1]
               somay <- somay + totalM[j,2]
               contador <- contador + 1
            }
         media[jj,1] <- somax / contador
         media[jj,2] <- somay / contador
      }

      p <- matrix(0,nrow=testeN,ncol=nnn)
      for (jj in 1:nnn) {
         K <- cov(yc[,,jj])
         for (i in 1:testeN)
            p[i,jj] <- pdfnvar(teste[i,], media[jj,], K, 2) * cc[jj]
      }

      flag <- matrix(0,nrow=nnn)
      for (i in 1:n)
         if (totalM[i,3] == classe) {
            jj <- totalM[i,4]
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

      if (kk == 3) { # so falta trocar pelo maximo da acuracia[coluna classe]
         ci<-0
         for (i in seqi) {
            ci<-ci+1
            cj<-0
            for(j in seqj) {
               cj<-cj+1 

               pp <- matrix(0,nrow=nnn,ncol=2)
               x <- matrix(0,nrow=2)
               x[1] <- i
               x[2] <- j
               for (jj in 1:nnn)
                  pp[jj] <- pdfnvar(x, media[jj,], K, 2) * cc[jj]
       
               denom[ci,cj] <- 0 
               numerador[ci,cj] <- 0
               for (jj in 1:nnn)
                  if (flag[jj] > 0)
                     numerador[ci,cj] <- numerador[ci,cj] + pp[jj]
                  else
                     denom[ci,cj] <- denom[ci,cj] + pp[jj]

               if (denom[ci,cj] == 0)
                  M1[ci,cj] <- classe
               else {
                  f <- numerador[ci,cj] / denom[ci,cj]
                  if (f >= 1)
                     M1[ci,cj] <- classe
               }
            }
         }
      }
   }
}
persp3D(seqi,seqj,M1,counter=T,theta = 55, phi = 30, r = 40, d = 0.1, expand = 0.25, ltheta = 90, lphi = 180, shade = 0.4, ticktype = "detailed", nticks=5)

cores <- rainbow(nn)
for (ci in 1:100)
  for (cj in 1:100) {
    plot(seqi[ci],seqj[cj],col = cores[M1[ci,cj]], xlim = c(0,6),ylim = c(0,6),xlab = '' , ylab= '' )
    par(new=T)
  }


par(new=T)
contour2D(M1,seqi,seqj,colkey = NULL) 

acuracia

mean(acuracia[,1])
mean(acuracia[,2])
sd(acuracia[,1])
sd(acuracia[,2])

