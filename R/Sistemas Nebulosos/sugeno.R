rm(list=ls())
library('plot3D')
library('mlbench')

circulo <- function(x0, y0, raio, color, p1, p2) {
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 for (i in 1:N) {
    # 2 pi / N = t / i
    t <- 2 * pi / N * i
    x[i] <- x0 + raio * cos(t)
    y[i] <- y0 + raio * sin(t)
 }
 par(new=T)
 plot(x,y,type = 'l',col=color,xlim=p1,ylim=p2,xlab='x',ylab='y')
}

 M <- 2
 N <- 1000
 x <- matrix(0, N)
 mu1 <- matrix(0, N)
 mu2 <- matrix(0, N)
 mu3 <- matrix(0, N)
 mu4 <- matrix(0, N)
 mu5 <- matrix(0, N)
 a1 <- matrix(0, N)
 a2 <- matrix(0, N)
 a3 <- matrix(0, N)
 a4 <- matrix(0, N)
 z <- matrix(0, N)
 ys <- matrix(0, N)
 yd <- matrix(0, N)
 soma <- 0
 for (i in 1:N) {
    # t(1) = -M, t(N) = M
    t <- 2*M/(N - 1) * (i - 1) - M
    x[i] <- t
    if (t <= -1)
       mu1[i] <- -t - 1  # (-2,1) a (-1,0)
    if ((-2 < t) && (t <= -1))
       mu2[i] <- t + 2  # (-2,0) a (-1,1)
    else if ((-1 < t) && (t <= 0))
       mu2[i] <- -t  # (-1,1) a (0,0)
    if ((-1 < t) && (t <= 0))
       mu3[i] <- t + 1  # (-1,0) a (0,1)
    else if ((0 < t) && (t <= 1))
       mu3[i] <- -t + 1  # (0,1) a (1,0)
    if ((0 < t) && (t <= 1))
       mu4[i] <- t  # (0,0) a (1,1)
    else if ((1 < t) && (t <= 2))
       mu4[i] <- -t + 2  # (1,1) a (2,0)
    if (t >= 1)
       mu5[i] <- t - 1  # (1,0) a (2,1)
    if (t <= -1)
       a1[i] <- -4*t - 4  # (-2,4) a (-1,0)
    if ((-2 < t) && (t <= -1))
       a2[i] <- t + 2  # (-2,0) a (-1,1)
    else if ((-1 < t) && (t <= 0))
       a2[i] <- -t  # (-1,1) a (0,0)
    if ((0 < t) && (t <= 1))
       a3[i] <- t  # (0,0) a (1,1)
    else if ((1 < t) && (t <= 2))
       a3[i] <- -t + 2  # (1,1) a (2,0)
    if (t >= 1)
       a4[i] <- 4*t - 4  # (1,0) a (2,4)
    ys[i] <- a1[i] * mu1[i] + a2[i] * mu2[i] + a3[i] * mu4[i] + a4[i] * mu5[i]
    yd[i] <- t*t
    soma <- soma + (ys[i] - yd[i])^2
 }

 soma <- soma/N * 100
 soma
 
 M <- 2
 M1 <- -0.25
 M2 <- 4.25
 plot(x,yd,type = 'l',col='blue',xlim=c(-M,M),ylim = c(M1,M2),xlab='x',ylab='y')
 par(new=T)
 plot(x,ys,type = 'l',col='red',xlim=c(-M,M),ylim = c(M1,M2),xlab='x',ylab='y')
 par(new=T)
 plot(x,z,type = 'l',col='black',xlim=c(-M,M),ylim = c(M1,M2),xlab='x',ylab='y')
 par(new=T)
 plot(z,x,type = 'l',col='black',xlim=c(-M,M),ylim = c(M1,M2),xlab='x',ylab='y')

