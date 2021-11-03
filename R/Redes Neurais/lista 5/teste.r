setwd("V:\\sem backup\\semestre 20201\\redes neurais\\entregar 9 set")
rm(list=ls())
library('plot3D')
source('trainperceptron.R')
source('yperceptron.R')

nc <- 12
xin <- matrix(0, nc, 2)
xin[2,1] <- 0
xin[2,2] <- 1
xin[3,1] <- 0
xin[3,2] <- 2
xin[4,1] <- 1
xin[4,2] <- 0
xin[5,1] <- 1
xin[5,2] <- 1
xin[6,1] <- 1
xin[6,2] <- 2
xin[7,1] <- 2
xin[7,2] <- 0
xin[8,1] <- 2
xin[8,2] <- 1
xin[9,1] <- 2
xin[9,2] <- 2
xin[10,1] <- 3
xin[10,2] <- 0
xin[11,1] <- 3
xin[11,2] <- 1
xin[12,1] <- 3
xin[12,2] <- 2


tol <- 1e-3
maxepocas <- 100
eta <- 0.1
par <- 1

yd <- matrix(1, nc, 1)
yd[c(1,2,3,6)] <- 0
res <- trainperceptron(xin,yd,eta,tol,maxepocas,par)
w1 <- res[[1]]

yd <- matrix(0, nc, 1)
yd[c(1,2,3,4,5)] <- 1
res <- trainperceptron(xin,yd,eta,tol,maxepocas,par)
w2 <- res[[1]]

yd <- matrix(1, nc, 1)
yd[c(1,4,7,10)] <- 0
res <- trainperceptron(xin,yd,eta,tol,maxepocas,par)
w3 <- res[[1]]

yd <- matrix(0, nc, 1)
yd[12] <- 1
res <- trainperceptron(xin,yd,eta,tol,maxepocas,par)
w4 <- res[[1]]

seqi <- seq(-1,4,0.1)
seqj <- seq(-1,4,0.1)
M <- matrix(0, nrow=length(seqi), ncol=length(seqj))

ci <- 0
for (i in seqi) {
  ci <- ci + 1
  cj <- 0
  for (j in seqj) {
    cj <- cj + 1
    x <- c(i,j)
    M[ci,cj] <- min(yperceptron(x, w1, 1) * yperceptron(x, w2, 1) * yperceptron(x, w3, 1) + yperceptron(x, w4, 1), 1)
  }
}

par(new=F)
for (i in 1:12) {
  y <- min(yperceptron(xin[i,], w1, 1) * yperceptron(xin[i,], w2, 1) * yperceptron(xin[i,], w3, 1) + yperceptron(xin[i,], w4, 1), 1)
  if (y == 0) color <- "blue" else color <- "red"
  plot(xin[i,1],xin[i,2],col = color, xlim = c(-1,4), ylim = c(-1,4), xlab = 'x_1', ylab = 'x_2')
  par(new=T)
}
contour(seqi, seqj, M, xlim = c(-1,4), ylim = c(-1,4), xlab = '', ylab = '')

persp3D(seqi, seqj, M, counter=T, theta = 55, phi = 30, r = 40, d = 0.1, expand = 0.5,
        ltheta = 90, lphi = 180, shade = 0.4, ticktype = "detailed", nticks = 5)
        
  