setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())

xtrain <- as.matrix(read.csv("trainReduzido.csv", sep=",", header=TRUE))
ytrain <- xtrain[,2]
xtrain2 <- as.matrix(read.csv("trainSemColunaZero.csv", sep=",", header=TRUE))
xtrain <- xtrain2[,2:75]
length(xtrain[,1])
length(xtrain[1,])
length(ytrain)
xvalid <- as.matrix(read.csv("validSemColunaZero.csv", sep=",", header=TRUE))
xvalid <- xvalid[,2:75]
length(xvalid [,1])
length(xvalid [1,])

dist <- function(x, y, nc) { 
   soma <- 0
   for (i in 1:nc)
      soma <- soma + (x[i] - y[i])^2
   return(sqrt(soma)) 
}

kmeans <- function(k, M, linhas, index) {
   nc <- index - 1
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
totalM <- matrix(0,ncol=75,nrow=n)
for (i in 1:n) {
   for (j in 1:74)
      totalM[i,j] <- xtrain[i,j]
   totalM[i,75] <- ytrain[i]
}
totalM <- cbind(totalM, 0)

nn <- 4
colunas <- 75
nx <- 74
colunay <- 75
final <- 76
acuracia <- matrix(0,nrow=10, ncol=nn)
nnn <- 20
totalM <- kmeans(nnn, totalM, n, final)
#for (i in 1:n)
#   if (totalM[i,785] > 1)
#      totalM[i,785] <- totalM[i,785] - 3  #567 <- 234
write.csv(totalM, file="kmeans20.csv")
