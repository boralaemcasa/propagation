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

x1_reta <- seq(6/100, 6, 6/100)
x2_reta <- -x1_reta + 6
par(new=T)
plot(x1_reta, x2_reta, type = 'l', col = 'orange', xlim = c(0,6), ylim = c(0,6), xlab = '', ylab = '')

xin <- matrix(0, nc * 2, 2)
yd <- matrix(0, nc * 2, 1)
for (i in 1:nc) {
  xin[i,1] <- xc1[i,1]
  xin[i,2] <- xc1[i,2]
  xin[i + nc,1] <- xc2[i,1]
  xin[i + nc,2] <- xc2[i,2]
  yd[i + nc] <- 1
}


tol <- 1e-3
maxepocas <- 100
eta <- 0.1
par <- 1
res <- trainperceptron(xin,yd,eta,tol,maxepocas,par)
w <- res[[1]]


seqi <- seq(0,6,0.1)
seqj <- seq(0,6,0.1)
M <- matrix(0, nrow=length(seqi), ncol=length(seqj))

ci <- 0
for (i in seqi) {
  ci <- ci + 1
  cj <- 0
  for (j in seqj) {
    cj <- cj + 1
    x <- c(i,j)
    M[ci, cj] <- yperceptron(x, w, 1)
  }
}

plot(xc1[,1],xc1[,2],col = 'red', xlim = c(0,6), ylim = c(0,6), xlab = 'x_1', ylab = 'x_2')
par(new=T)
plot(xc2[,1],xc2[,2],col = 'blue', xlim = c(0,6), ylim = c(0,6), xlab = '', ylab = '')
par(new=T)
contour(seqi, seqj, M, xlim = c(0,6), ylim = c(0,6), xlab = '', ylab = '')

persp3D(seqi, seqj, M, counter=T, theta = 55, phi = 30, r = 40, d = 0.1, expand = 0.5,
        ltheta = 90, lphi = 180, shade = 0.4, ticktype = "detailed", nticks = 5)


