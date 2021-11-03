setwd("V:\\sem backup\\_redes neurais 2021\\lista final")
rm(list=ls())
library('corpcor')

xtrain <- as.matrix(read.csv("trainReduzido.csv", sep=",", header=TRUE))
B <- xtrain[,1]
Minv <- as.matrix(read.csv("grau17.csv", sep=",", header=FALSE))
length(Minv[,1])
length(Minv[1,])

P <- Minv %*% B
MInv <- 0
write.csv(P, file="param17.csv")

M <- matrix(0, nrow=13017, ncol=13017)
for (i in 1:13017) {
   for (j in 1:784) {
      M[i,j] <- xtrain[i,j+1]
      for (k in 2:16)
         M[i, (k-1)*784 + j] <- M[i, j]^k
   }
   for (j in 1:473)
      M[i, 16*784 + j] <- M[i, j]^17
}
A <- M %*% P - B
M <- 0
write.csv(A, file="diferenca.csv")
