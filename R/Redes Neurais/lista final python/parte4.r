setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())
z <- as.matrix(read.csv("saida_python.csv", sep=",", header=TRUE))
xin <- as.matrix(read.csv("saida_estado_arte.csv", sep=",", header=TRUE))
n <- length(xin[,1])
contador1 <- 0
contador2 <- 0
contador3 <- 0
for (i in 1:n) {
   if (xin[i,2] == 0)
      contador1 <- contador1 + 1
   if (xin[i,2] != z[i,2])
      if (z[i,2] == 0)
         contador3 <- contador3 + 1
      else contador2 <- contador2 + 1
}
contador1
contador2
contador3

#299 -> 104 zeros + 237 duplos onde nao tinha ; 195 ok
#299/4000 = 7.475 % no ELM
#341/4000 = 8.525 % no MLP

