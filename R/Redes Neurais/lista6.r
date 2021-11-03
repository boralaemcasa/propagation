setwd("V:\\sem backup\\_redes neurais 2021 11 julho\\lista 6\\entreguei 6")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
library('RSNNS')
source('treinaELM.R')
source('YELM.R')


tudo <- as.matrix(read.csv('wdbc.data'))
linhas <- 568
colunas <- 30
xtudo <- matrix(0,ncol=colunas,nrow=linhas)
ytudo <- matrix(0,ncol=1,nrow=linhas)
for (i in 1:linhas) {
  for (j in 3:32)
    xtudo[i,j-2] <- as.double(tudo[i,j])
  if (tudo[i,2] == "B")
    ytudo[i] <- 1
  else
    ytudo[i] <- -1
}

  xyall <- splitForTrainingAndTest(xtudo, ytudo, ratio=0.1)
  xin <- xyall$inputsTrain
  yin <- xyall$targetsTrain
  xinteste <- xyall$inputsTest
  yinteste <- xyall$targetsTest

acur_trein <- matrix(0, ncol=1, nrow=50)
acuracia <- matrix(0, ncol=1, nrow=50)
for (tempo in 1:50) {
  p <- tempo * 6
  par <- 1
  res <- treinaELM(xin,yin,p,par)
  W <- res[[1]]
  H <- res[[2]]
  Z <- res[[3]]
  Yhat <- YELM(xin, Z, W, par)
  e_teste <- sum((yin - Yhat)^2)/4

  acur_trein[tempo] <- 100 - e_teste / length(yin) * 100

  Yhat_teste <- YELM(xinteste, Z, W, par)
  e_teste <- sum((yinteste - Yhat_teste)^2)/4

  acuracia[tempo] <- 100 - e_teste / length(yinteste) * 100
  print(tempo)
}

max(acuracia)
plot(acur_trein)
plot(acuracia)
mean(acuracia)
sd(acuracia)

======

tudo <- as.matrix(read.csv('heart.dat', sep=" ", header=FALSE))
linhas <- 270
colunas <- 13
xtudo <- matrix(0,ncol=colunas,nrow=linhas)
ytudo <- matrix(0,ncol=1,nrow=linhas)
for (i in 1:linhas) {
  for (j in 1:13)
    xtudo[i,j] <- as.double(tudo[i,j])
  if (tudo[i,14] == 1)
    ytudo[i] <- 1
  else
    ytudo[i] <- -1
}

  xyall <- splitForTrainingAndTest(xtudo, ytudo, ratio=0.1)
  xin <- xyall$inputsTrain
  yin <- xyall$targetsTrain
  xinteste <- xyall$inputsTest
  yinteste <- xyall$targetsTest

acur_trein <- matrix(0, ncol=1, nrow=50)
acuracia <- matrix(0, ncol=1, nrow=50)
for (tempo in 1:50) {
  p <- tempo * 11
  par <- 1
  res <- treinaELM(xin,yin,p,par)
  W <- res[[1]]
  H <- res[[2]]
  Z <- res[[3]]
  Yhat <- YELM(xin, Z, W, par)
  e_teste <- sum((yin - Yhat)^2)/4

  acur_trein[tempo] <- 100 - e_teste / length(yin) * 100

  Yhat_teste <- YELM(xinteste, Z, W, par)
  e_teste <- sum((yinteste - Yhat_teste)^2)/4

  acuracia[tempo] <- 100 - e_teste / length(yinteste) * 100
  print(tempo)
}

max(acuracia)
plot(acur_trein)
plot(acuracia)
mean(acuracia)
sd(acuracia)

