setwd("V:\\sem backup\\_1 OTIMIZACAO MULTIOBJETIVO\\_tc")
rm(list=ls())

dist <- function(x, y) { 
   return(sqrt((x[1] - y[1])^2 + (x[2] - y[2])^2)) 
}

dim1 <- 15
dim2 <- 36
maxnfe <- 5000
N <- dim2 - dim1 + 1

pontos <- array(0, dim=c(maxnfe, 3, N, 5))
for (L in 1:5) {
   for (dimini in dim1:dim2) {
      depth <- dimini - dim1 + 1
      mat <- as.matrix(read.csv(paste("S", L, "\\valorDist", toString(dimini), ".csv", sep=""), sep=",", header=FALSE))
      pontos[,,depth,L] <- as.double(mat[2:(maxnfe+1),2:4])
   }
   for (dimini in dim1:dim2) {
      depth <- dimini - dim1 + 1
      for (i in 2:maxnfe)
         if (pontos[i,1,depth,L] == 0) {
            pontos[i,1,depth,L] <- pontos[i-1,1,depth,L]
            pontos[i,2,depth,L] <- pontos[i-1,2,depth,L]
            pontos[i,3,depth,L] <- pontos[i-1,3,depth,L]
         }
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

Delta <- matrix(0, maxnfe)
HV <- matrix(0, maxnfe)
   
for (depth in 1:maxnfe) {
   ponto <- cbind(pontos[depth,1,,1], pontos[depth,2,,1], 0, 0)
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

m <- 36 - 15
ponto <- as.matrix(read.csv("valorFinal.csv", sep=",", header=TRUE)) 
ponto <- cbind(ponto[,2:4], 0)
ponto[,3] <- ponto[,1]/max(ponto[,1])
ponto[,4] <- ponto[,2]/max(ponto[,2])
plot(ponto[,3],ponto[,4],col='red',xlim=c(0,1),ylim = c(0,1),xlab='x',ylab='y')

for (i in 1:m)
    for (j in 1:m)
        if ((ponto[i,3] < ponto[j,3]) && (ponto[i,4] < ponto[j,4])) 
            ponto[j,] <- ponto[1,] # eu sei que o 1 pertence aos dominantes

ponto <- unique(ponto[,3:4])
par(new=T)
plot(ponto[,1],ponto[,2],col='blue',xlim=c(0,1),ylim = c(0,1),xlab='x',ylab='y')

