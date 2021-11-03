setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())
xin <- as.matrix(read.csv("validacao.csv", sep=",", header=TRUE))
xin <- xin[,1]
xin <- cbind(xin, 0)
n <- length(xin[,1])
y <- as.matrix(read.csv("valid_ELM_1.csv", sep=",", header=TRUE))
for (i in 1:n)
   xin[i,2] <- y[i,2]
xin <- cbind(xin, 0)
y <- as.matrix(read.csv("valid_ELM_5.csv", sep=",", header=TRUE))
for (i in 1:n)
   xin[i,3] <- y[i,2]
xin <- cbind(xin, 0)
y <- as.matrix(read.csv("valid_ELM_6.csv", sep=",", header=TRUE))
for (i in 1:n)
   xin[i,4] <- y[i,2]
xin <- cbind(xin, 0)
y <- as.matrix(read.csv("valid_ELM_7.csv", sep=",", header=TRUE))
for (i in 1:n)
   xin[i,5] <- y[i,2]
xin <- cbind(xin, 0)
y <- as.matrix(read.csv("valid_MLP_1.csv", sep=",", header=TRUE))
for (i in 1:n)
   xin[i,6] <- y[i,2]
xin <- cbind(xin, 0)
y <- as.matrix(read.csv("valid_MLP_5.csv", sep=",", header=TRUE))
for (i in 1:n)
   xin[i,7] <- y[i,2]
xin <- cbind(xin, 0)
y <- as.matrix(read.csv("valid_MLP_6.csv", sep=",", header=TRUE))
for (i in 1:n)
   xin[i,8] <- y[i,2]
xin <- cbind(xin, 0)
y <- as.matrix(read.csv("valid_MLP_7.csv", sep=",", header=TRUE))
for (i in 1:n)
   xin[i,9] <- y[i,2]

erro <- function(z) {
   if (z < -1)
      return (z + 2 * (- z - 1)) # -1.1 => - 1.1 + 2 * 0.1 = -0.9
   else if (z > 1)
      return (z - 2 * (z - 1))   #  1.1 => 1.1 - 2 * 0.1 = 0.9
   else
      return (z)
}

xin <- cbind(xin, 0)
for (i in 1:n) {
   a <- erro(xin[i,2])
   b <- erro(xin[i,3])
   c <- erro(xin[i,4])
   d <- erro(xin[i,5])
   x1 <- max(a, b, c, d)
   if (x1 == a)
      xin[i,10] <- 1
   else if (x1 == b)
      xin[i,10] <- 5
   else if (x1 == c)
      xin[i,10] <- 6
   else if (x1 == d)
      xin[i,10] <- 7
}
contador1 <- 0
contador2 <- 0
contador3 <- 0
xin <- cbind(xin, 0)
for (i in 1:n) {
   a <- erro(xin[i,6])
   b <- erro(xin[i,7])
   c <- erro(xin[i,8])
   d <- erro(xin[i,9])
   x1 <- max(a, b, c, d)
   if (x1 == a)
      xin[i,11] <- 1
   else if (x1 == b)
      xin[i,11] <- 5
   else if (x1 == c)
      xin[i,11] <- 6
   else if (x1 == d)
      xin[i,11] <- 7
      
   if (xin[i,10] != xin[i,11])
     contador1 <- contador1 + 1
}
write.csv(xin, file="saida.csv")

y <- xin[,1]
y <- cbind(y, 0)
for (i in 1:n) {
   a <- erro(xin[i,2])
   b <- erro(xin[i,6])
   x1 <- max(a, b)
   a <- erro(xin[i,3])
   b <- erro(xin[i,7])
   x5 <- max(a, b)
   a <- erro(xin[i,4])
   b <- erro(xin[i,8])
   x6 <- max(a, b)
   a <- erro(xin[i,5])
   b <- erro(xin[i,9])
   x7 <- max(a, b)
   d <- max(x1, x5, x6, x7)
   if (d == x1)
      y[i,2] <- 1
   else if (d == x5)
      y[i,2] <- 5
   else if (d == x6)
      y[i,2] <- 6
   else if (d == x7)
      y[i,2] <- 7
   if (xin[i,10] != y[i,2])
     contador2 <- contador2 + 1
   if (y[i,2] != xin[i,11])
     contador3 <- contador3 + 1
}
write.csv(y, file="saida2.csv")
print(contador1)
print(contador2)
print(contador3)

