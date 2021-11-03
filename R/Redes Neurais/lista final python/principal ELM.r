setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
library('RSNNS')
source('treinaELM.R')
source('YELM.R')

xtrein <- as.matrix(read.csv("validSemColunaZero.csv", sep=",", header=TRUE))
n <- length(xtrein[,1])
xtrein <- xtrein[,2:75]
xtrein2 <- matrix(0, nrow=n, ncol=2849)
for (i in 1:n) {
   for (j in 1:74) {
      xtrein2[i,j] <- xtrein[i,j]
      xtrein2[i,j+74] <- xtrein[i,j]^2
   }
   j <- 2*74 + 1
   for (u in 1:73)
      for (v in (u + 1):74) {
         xtrein2[i,j] <- xtrein[i,u] * xtrein[i,v]
         j <- j + 1
      }    
}
write.csv(xtrein2, file="validGrau2.csv")

xtrein <- as.matrix(read.csv("trainSemColunaZero.csv", sep=",", header=TRUE))
n <- length(xtrein[,1])
xtrein <- xtrein[,2:75]
xtrein2 <- matrix(0, nrow=n, ncol=2849)
for (i in 1:n) {
   for (j in 1:74) {
      xtrein2[i,j] <- xtrein[i,j]
      xtrein2[i,j+74] <- xtrein[i,j]^2
   }
   j <- 2*74 + 1
   for (u in 1:73)
      for (v in (u + 1):74) {
         xtrein2[i,j] <- xtrein[i,u] * xtrein[i,v]
         j <- j + 1
      }    
}
write.csv(xtrein2, file="trainGrau2.csv")

xtrein <- as.matrix(read.csv("trainReduzido.csv", sep=",", header=TRUE))
n <- length(xtrein[,1])
s <- sample(n)
xtrein <- xtrein[,2]
xtrein2 <- as.matrix(read.csv("trainGrau2.csv", sep=",", header=TRUE))
xtudo <- matrix(0, nrow=n, ncol=2849)
ytudo <- matrix(0, nrow=n, ncol=1)
for (i in 1:n) {
  xtudo[i,] <- xtrein2[s[i],2:2850]
  ytudo[i] <- xtrein[s[i]]
}
length(xtudo[1,])
length(ytudo)
for (i in 1:n) {
  if (ytudo[i] != 1)
    ytudo[i] <- -1
  else ytudo[i] <- 1
}

#xyall <- splitForTrainingAndTest(xtudo, ytudo, ratio=0.9)
#xin <- xyall$inputsTest
#yin <- xyall$targetsTest
#xinteste <- xyall$inputsTrain
#yinteste <- xyall$targetsTrain
#validar <- TRUE

xin <- xtudo
yin <- ytudo
xinteste <- as.matrix(read.csv("validGrau2.csv", sep=",", header=TRUE))
xinteste <- xinteste[,2:2850]
validar <- FALSE

fim <- 1
acur_trein <- matrix(0, ncol=1, nrow=fim)
acuracia <- matrix(0, ncol=1, nrow=fim)
for (tempo in 1:fim) {
  p <- 2849
  par <- 1
  res <- treinaELM(xin,yin,p,par)
  W <- res[[1]]
  H <- res[[2]]
  Z <- res[[3]]
  Yhat <- YELM(xin, Z, W, par)
  e_teste <- sum((yin - Yhat)^2)/4

  acur_trein[tempo] <- 100 - e_teste / length(yin) * 100

  Yhat_teste <- YELM(xinteste, Z, W, par)
  if (validar) {
    e_teste <- sum((yinteste - Yhat_teste)^2)/4
    acuracia[tempo] <- 100 - e_teste / length(yinteste) * 100
  }
  print(tempo)
}
n <- length(Yhat_teste[,1])
#for (i in 1:n)
#  if (Yhat_teste[i] < 0)
#    Yhat_teste[i] <- 0

write.csv(Yhat_teste, file="valid_ELM_1.csv")

MostraImagem <- function( x )
{
rotate <- function(x) t( apply(x, 2, rev) )

img <- t(matrix( x, nrow=28 ))
cor <- rev( gray(50:1/50) )
image( rotate( img ), col=cor )
}

MostraImagem( xtudo[9000,] )
xtrein[9000,2]

