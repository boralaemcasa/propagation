setwd("V:\\sem backup\\_redes neurais 2021 prova até julho 27\\lista 8")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
source('treinaRBF.R')
source('YRBF.R')
library('RSNNS')

tudo <- as.matrix(read.csv('heart.dat', sep=" ", header=FALSE))
linhas <- 270
colunas <- 13
xtudo <- matrix(0,ncol=colunas,nrow=linhas)
ytudo <- matrix(0,ncol=1,nrow=linhas)
for (i in 1:linhas)
  for (j in 1:13){
    xtudo[i,j] <- as.double(tudo[i,j])
  if (tudo[i,14] == 1)
    ytudo[i] <- 1
  else
    ytudo[i] <- -1
}

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

for (j in 1:colunas) {
  maxx <- max(xtudo[,j])
  minx <- min(xtudo[,j])
  for (i in 1:linhas)
    xtudo[i,j] <- (xtudo[i,j] - minx) / (maxx - minx)
}

  xyall <- splitForTrainingAndTest(xtudo, ytudo, ratio=0.1)
  xin <- xyall$inputsTrain
  yin <- xyall$targetsTrain
  xinteste <- xyall$inputsTest
  yinteste <- xyall$targetsTest

acur_trein <- matrix(0, ncol=1, nrow=8)
acuracia <- matrix(0, ncol=1, nrow=8)
for (tempo in 1:8) {
  p <- tempo * 8
  print("t")
  print(p)

	modRBF <- treinaRBF(xin,yin,p)

	Yhat_train <- YRBF(xin, modRBF)
	for (i in 1:length(Yhat_train))
	  Yhat_train[i] <- Yhat_train[i]/abs(Yhat_train[i])

	e_teste <- sum((yin - Yhat_train)^2)/4
	print(e_teste) # e_train

  acur_trein[tempo] <- 100 - e_teste / length(yin) * 100

  Yhat_teste <- YRBF(xinteste, modRBF)
  for (i in 1:length(Yhat_teste))
    Yhat_teste[i] <- Yhat_teste[i]/abs(Yhat_teste[i])
  e_teste <- sum((yinteste - Yhat_teste)^2)/4

  acuracia[tempo] <- 100 - e_teste / length(yinteste) * 100
}

max(acuracia)
plot(acur_trein)
plot(acuracia)
mean(acuracia)
sd(acuracia)
