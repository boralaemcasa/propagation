setwd("V:\\sem backup\\_1 OTIMIZACAO MULTIOBJETIVO\\_tc\\s ini")
rm(list=ls())

dist <- function(x, y) { 
   return(sqrt((x[1] - y[1])^2 + (x[2] - y[2])^2)) 
}

dim1 <- 17
dim2 <- 500
maxnfe <- 1
N <- dim2 - dim1 + 1
folders <- 5

pontos <- array(0, dim=c(maxnfe, 3, N, folders))
for (L in 1:folders) {
   for (dimini in dim1:dim2) {
      depth <- dimini - dim1 + 1
      mat <- as.matrix(read.csv(paste("S", L, "\\valorDist", toString(dimini), ".csv", sep=""), sep=",", header=FALSE))
      if (dimini <= 14)
         pontos[,,depth,L] <- as.double(mat[2:(maxnfe+1),2:4])
      else
         pontos[1,,depth,L] <- as.double(mat[2:4,2])
   }
}

for (i in 1:maxnfe)
   for (j in 1:N) {
      m <- min(pontos[i,2,j,])
      for (k in 1:L)
         if (pontos[i,2,j,k] == m)
            break
      pontos[i,2,j,1] <- pontos[i,2,j,k]
   }

for (depth in maxnfe:maxnfe) {
   ponto <- cbind(pontos[depth,1,,1], pontos[depth,2,,1], 0, 0)
   ponto[,3] <- ponto[,1]/max(ponto[,1])
   ponto[,4] <- ponto[,2]/max(ponto[,2])
   print(ponto)
   for (i in 1:N)
     for (j in 1:N)
         if ((ponto[i,3] < ponto[j,3]) && (ponto[i,4] < ponto[j,4])) 
            ponto[j,] <- ponto[1,] # eu sei que o 1 pertence aos dominantes
   write.csv(unique(ponto), file="pareto500.csv")
   ponto <- unique(ponto[,3:4])
}

write.csv(t(pontos[maxnfe, , , 1]), file="valorFinal.csv")

xinf <- 2403
x <- seq(xinf, maxnfe, 1)
Delta <- Delta[xinf:maxnfe]
y1 <- min(Delta) - 0.002
y2 <- max(Delta) + 0.002
plot(x,Delta,type='l',col='blue',xlim=c(xinf,maxnfe),ylim = c(y1,y2),xlab='Época',ylab='Delta')

xinf <- 1514
x <- seq(xinf, maxnfe, 1)
HV <- HV[xinf:maxnfe]
y1 <- min(HV) - 0.0002
y2 <- max(HV) + 0.0002
plot(x,HV,type='l',col='blue',xlim=c(xinf,maxnfe),ylim = c(y1,y2),xlab='Época',ylab='HV')

###

m <- 500 - 17 + 1
ponto <- as.matrix(read.csv("valorFinal.csv", sep=",", header=TRUE)) 
ponto <- cbind(ponto[,2:4], 0)
ponto[,3] <- ponto[,1]/max(ponto[,1])
ponto[,4] <- ponto[,2]/max(ponto[,2])
plot(ponto[,3],ponto[,4],col='red',xlim=c(0,1),ylim = c(0,1),xlab='x',ylab='y')

for (i in 1:m)
    for (j in 1:m)
        if ((ponto[i,3] < ponto[j,3]) && (ponto[i,4] < ponto[j,4])) 
            ponto[j,] <- ponto[1,] # eu sei que o 1 pertence aos dominantes

print(unique(ponto[,1:2]))
ponto <- unique(ponto[,3:4])
par(new=T)
plot(ponto[,1],ponto[,2],col='blue',xlim=c(0,1),ylim = c(0,1),xlab='x',ylab='y')

