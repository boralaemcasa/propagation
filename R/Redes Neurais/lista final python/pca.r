setwd("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
library('RSNNS')
source('treinaELM.R')
source('YELM.R')

xtrain <- as.matrix(read.csv("trainReduzido.csv", sep=",", header=TRUE))
xtrain <- cbind(xtrain, 0)
wdbc <- xtrain[,3:786]
for (i in 1:784)
   if (wdbc[,i] != xtrain[,787])
      print(i)
subset <- c(155
, 156
, 157
, 183
, 184
, 185
, 210
, 211
, 212
, 213
, 238
, 239
, 240
, 241
, 266
, 267
, 268
, 269
, 294
, 295
, 296
, 297
, 322
, 323
, 324
, 325
, 350
, 351
, 352
, 353
, 378
, 379
, 380
, 381
, 406
, 407
, 408
, 409
, 434
, 435
, 436
, 437
, 462
, 463
, 464
, 465
, 490
, 491
, 492
, 493
, 518
, 519
, 520
, 521
, 546
, 547
, 548
, 549
, 574
, 575
, 576
, 577
, 602
, 603
, 604
, 630
, 631
, 632
, 658
, 659
, 660
, 686
, 687
, 688)
wdbc <- wdbc[,subset]
write.csv(wdbc, file="trainSemColunaZero.csv")

xvalid <- as.matrix(read.csv("validacao.csv", sep=",", header=TRUE))
xvalid <- xvalid[,2:785]
xvalid <- xvalid[,subset]
write.csv(xvalid, file="validSemColunaZero.csv")

wdbc.pr <- prcomp(wdbc, center = TRUE, scale = TRUE)
summary(wdbc.pr)

screeplot(wdbc.pr, type = "l", npcs = 25, main = "first 20 PCs")

cumpro <- cumsum(wdbc.pr$sdev^2 / sum(wdbc.pr$sdev^2))
plot(cumpro[0:25])
