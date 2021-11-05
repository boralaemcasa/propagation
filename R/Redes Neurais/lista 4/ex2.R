setwd("C:\\Users\\cu_do_bispo\\Documents\\data sept 02 ex4 redes neurais\\entregar em 2 setembro 4")
rm(list=ls())
library('plot3D')
source('trainperceptron.R')
source('yperceptron.R')
s1 <- 0.4
s2 <- 0.4
nc <- 200
xc1 <- matrix(rnorm(nc*2), ncol=2)*s1 + t(matrix(c(2,2),ncol=nc, nrow=2))
xc2 <- matrix(rnorm(nc*2), ncol=2)*s2 + t(matrix(c(4,4),ncol=nc, nrow=2))
plot(xc1[,1],xc1[,2],col = 'red', xlim = c(0,6), ylim = c(0,6), xlab = 'x_1', ylab = 'x_2')
par(new=T)
plot(xc2[,1],xc2[,2],col = 'blue', xlim = c(0,6), ylim = c(0,6), xlab = '', ylab = '')

trein <- 0.7 * nc
amostra1 <- sample.int(nc, size=nc)
amostra2 <- sample.int(nc, size=nc)

xin <- matrix(0, trein * 2, 2)
yd <- matrix(0, trein * 2, 1)
for (i in 1:trein) {
  xin[i,1] <- xc1[amostra1[i],1]
  xin[i,2] <- xc1[amostra1[i],2]
  xin[i + trein,1] <- xc2[amostra2[i],1]
  xin[i + trein,2] <- xc2[amostra2[i],2]
  yd[i + trein] <- 1
}



tol <- 1e-3
maxepocas <- 100
eta <- 0.1
par <- 1
res <- trainperceptron(xin,yd,eta,tol,maxepocas,par)
w <- res[[1]]

acertos <- 0
teste <- 0.3 * nc
xx <- matrix(0, teste * 2, 2)
yy <- matrix(-1, teste * 2, 1)
for (i in 1:teste) {
  xx[i,1] <- xc1[amostra1[trein + i],1]
  xx[i,2] <- xc1[amostra1[trein + i],2]
  xx[i + teste,1] <- xc2[amostra2[trein + i],1]
  xx[i + teste,2] <- xc2[amostra2[trein + i],2]
  yy[i] <- yperceptron(xx[i,], w, 1)
  yy[i + teste] <- yperceptron(xx[i + teste,], w, 1)
  if (yy[i] == 0)
    acertos <- acertos + 1
  if (yy[i + teste] == 1)
    acertos <- acertos + 1
}

acuracia <- 100 * acertos / (2 * teste)


