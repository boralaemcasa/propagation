setwd("V:\\sem backup\\_redes neurais 2021 prova até julho 27\\lista 7\\entregar 7")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
source('treinaRBF.R')
source('YRBF.R')


v<-mlbench.2dnormals(200)
plot(v, xlim = c(-4,4), ylim = c(-3,3))

xin <- v$x
yin <- as.integer(v$classes)
for (i in 1:200)
  if (yin[i] == 2)
    yin[i] <- -1
p <- 5
modRBF <- treinaRBF(xin,yin,p)

Yhat_train <- YRBF(xin, modRBF)
for (i in 1:200)
  Yhat_train[i] <- Yhat_train[i]/abs(Yhat_train[i])

e_train <- sum((yin - Yhat_train)^2)/4
print(e_train)

seqi <- seq(-4,4,0.05)
seqj <- seq(-3,3,0.05)
M <- matrix(0, nrow=length(seqi), ncol=length(seqj))

ci <- 0
for (i in seqi) {
  ci <- ci + 1
  cj <- 0
  for (j in seqj) {
    cj <- cj + 1
    x <- t(as.matrix(c(i,j)))
    z <- YRBF(x, modRBF)
    M[ci, cj] <- z/abs(z)
  }
}

par(new=T)
contour(seqi, seqj, M, xlim = c(-4,4), ylim = c(-3,3), xlab = '', ylab = '')

persp3D(seqi, seqj, M, counter=T, theta = 55, phi = 30, r = 40, d = 0.1, expand = 0.5,
        ltheta = 90, lphi = 180, shade = 0.4, ticktype = "detailed", nticks = 5)
        
================

#v<-mlbench.xor(100)
#v<-mlbench.circle(100)
v<-mlbench.spirals(100, sd=0.05)
plot(v, xlim = c(-1,1), ylim = c(-1,1))

xin <- v$x
yin <- as.integer(v$classes)
for (i in 1:100)
  if (yin[i] == 2)
    yin[i] <- -1
p <- 20
modRBF <- treinaRBF(xin,yin,p)

Yhat_train <- YRBF(xin, modRBF)
for (i in 1:100)
  Yhat_train[i] <- Yhat_train[i]/abs(Yhat_train[i])

e_train <- sum((yin - Yhat_train)^2)/4
print(e_train)

seqi <- seq(-1,1,0.05)
seqj <- seq(-1,1,0.05)
M <- matrix(0, nrow=length(seqi), ncol=length(seqj))

ci <- 0
for (i in seqi) {
  ci <- ci + 1
  cj <- 0
  for (j in seqj) {
    cj <- cj + 1
    x <- t(as.matrix(c(i,j)))
    z <- YRBF(x, modRBF)
    M[ci, cj] <- z/abs(z)
  }
}

par(new=T)
contour(seqi, seqj, M, xlim = c(-1,1), ylim = c(-1,1), xlab = '', ylab = '')

persp3D(seqi, seqj, M, counter=T, theta = 55, phi = 30, r = 40, d = 0.1, expand = 0.5,
        ltheta = 90, lphi = 180, shade = 0.4, ticktype = "detailed", nticks = 5)
        
================

xin<-matrix(runif(100, -15, 15),ncol=1)
yin<-matrix(5.8 * sin(xin - 0.5) + rnorm(100, 0, 0.05),ncol=1)
modRBF<-treinaRBF(xin,yin,2)
xrange<-matrix(runif(50, -15, 15),ncol=1)
yhat_teste<-YRBF(xrange,modRBF)
for (i in 1:50) {
   plot(xin[i],yin[i],col='blue',xlim=c(-15,15),ylim=c(-1,1), xlab = '', ylab = '')
   par(new=T)
}
for (i in 1:50) {
   par(new=T)
   plot(xrange[i],yhat_teste[i],col='red',xlim=c(-15,15),ylim=c(-1,1), xlab = '', ylab = '')
}

m1 <- 7.881469
m2 <- -8.033118

xin <- 3.7
5.8 * sin(xin - 0.5)
w1 * exp(- (xin - m1)^2) + w2 * exp(- (xin - m2)^2) 
================

12
https://www.youtube.com/watch?v=2l0LMj5xj3w&list=PL9LlC0pBeCU8HLXTho9AvE-LTM58TwuaP&index=2

13
https://www.youtube.com/watch?v=toJGRN624t4&list=PL9LlC0pBeCU8HLXTho9AvE-LTM58TwuaP&index=3

14
https://www.youtube.com/watch?v=ppKloUVgG34&list=PL9LlC0pBeCU8HLXTho9AvE-LTM58TwuaP&index=4

15
https://www.youtube.com/watch?v=TXpESAnVHWU&list=PL9LlC0pBeCU8HLXTho9AvE-LTM58TwuaP&index=5

16
https://www.youtube.com/watch?v=1nUD6kdvWgQ&list=PL9LlC0pBeCU8HLXTho9AvE-LTM58TwuaP&index=6

17
https://www.youtube.com/watch?v=4Yw2ormVyvw&list=PL9LlC0pBeCU8HLXTho9AvE-LTM58TwuaP&index=7

18

19
