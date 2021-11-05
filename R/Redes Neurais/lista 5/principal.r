setwd("V:\\sem backup\\semestre 20201\\redes neurais\\entregar 9 set")
rm(list=ls())
library('corpcor')
library('mlbench')
library('plot3D')
source('treinaELM.R')
source('YELM.R')


v<-mlbench.2dnormals(200)
plot(v, xlim = c(-4,4), ylim = c(-3,3))

xin <- v$x
yin <- as.integer(v$classes)
for (i in 1:200)
  if (yin[i] == 2)
    yin[i] <- -1
p <- 30
par <- 1
res <- treinaELM(xin,yin,p,par)
W <- res[[1]]
H <- res[[2]]
Z <- res[[3]]

Yhat_train <- YELM(xin, Z, W, par)
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
    M[ci, cj] <- YELM(x, Z, W, par)
  }
}

par(new=T)
contour(seqi, seqj, M, xlim = c(-4,4), ylim = c(-3,3), xlab = '', ylab = '')

persp3D(seqi, seqj, M, counter=T, theta = 55, phi = 30, r = 40, d = 0.1, expand = 0.5,
        ltheta = 90, lphi = 180, shade = 0.4, ticktype = "detailed", nticks = 5)


================

v<-mlbench.xor(100)
plot(v, xlim = c(-1,1), ylim = c(-1,1))

xin <- v$x
yin <- as.integer(v$classes)
for (i in 1:100)
  if (yin[i] == 2)
    yin[i] <- -1
p <- 30
par <- 1
res <- treinaELM(xin,yin,p,par)
W <- res[[1]]
H <- res[[2]]
Z <- res[[3]]

Yhat_train <- YELM(xin, Z, W, par)
e_train <- sum((yin - Yhat_train)^2)/4
print(e_train)

seqi <- seq(-1,1,0.025)
seqj <- seq(-1,1,0.025)
M <- matrix(0, nrow=length(seqi), ncol=length(seqj))

ci <- 0
for (i in seqi) {
  ci <- ci + 1
  cj <- 0
  for (j in seqj) {
    cj <- cj + 1
    x <- t(as.matrix(c(i,j)))
    print(x)
    M[ci, cj] <- YELM(x, Z, W, par)
  }
}

par(new=T)
contour(seqi, seqj, M, xlim = c(-1,1), ylim = c(-1,1), xlab = '', ylab = '')

persp3D(seqi, seqj, M, counter=T, theta = 55, phi = 30, r = 40, d = 0.1, expand = 0.5,
        ltheta = 90, lphi = 180, shade = 0.4, ticktype = "detailed", nticks = 5)


================

v<-mlbench.circle(100)
plot(v, xlim = c(-1,1), ylim = c(-1,1))

xin <- v$x
yin <- as.integer(v$classes)
for (i in 1:100)
  if (yin[i] == 2)
    yin[i] <- -1
p <- 30
par <- 1
res <- treinaELM(xin,yin,p,par)
W <- res[[1]]
H <- res[[2]]
Z <- res[[3]]

Yhat_train <- YELM(xin, Z, W, par)
e_train <- sum((yin - Yhat_train)^2)/4
print(e_train)

seqi <- seq(-1,1,0.025)
seqj <- seq(-1,1,0.025)
M <- matrix(0, nrow=length(seqi), ncol=length(seqj))

ci <- 0
for (i in seqi) {
  ci <- ci + 1
  cj <- 0
  for (j in seqj) {
    cj <- cj + 1
    x <- t(as.matrix(c(i,j)))
    print(x)
    M[ci, cj] <- YELM(x, Z, W, par)
  }
}

par(new=T)
contour(seqi, seqj, M, xlim = c(-1,1), ylim = c(-1,1), xlab = '', ylab = '')

persp3D(seqi, seqj, M, counter=T, theta = 55, phi = 30, r = 40, d = 0.1, expand = 0.5,
        ltheta = 90, lphi = 180, shade = 0.4, ticktype = "detailed", nticks = 5)

================

v<-mlbench.spirals(100, sd=0.05)
plot(v, xlim = c(-1,1), ylim = c(-1,1))

xin <- v$x
yin <- as.integer(v$classes)
for (i in 1:100)
  if (yin[i] == 2)
    yin[i] <- -1
p <- 30
par <- 1
res <- treinaELM(xin,yin,p,par)
W <- res[[1]]
H <- res[[2]]
Z <- res[[3]]

Yhat_train <- YELM(xin, Z, W, par)
e_train <- sum((yin - Yhat_train)^2)/4
print(e_train)

seqi <- seq(-1,1,0.025)
seqj <- seq(-1,1,0.025)
M <- matrix(0, nrow=length(seqi), ncol=length(seqj))

ci <- 0
for (i in seqi) {
  ci <- ci + 1
  cj <- 0
  for (j in seqj) {
    cj <- cj + 1
    x <- t(as.matrix(c(i,j)))
    print(x)
    M[ci, cj] <- YELM(x, Z, W, par)
  }
}

par(new=T)
contour(seqi, seqj, M, xlim = c(-1,1), ylim = c(-1,1), xlab = '', ylab = '')

persp3D(seqi, seqj, M, counter=T, theta = 55, phi = 30, r = 40, d = 0.1, expand = 0.5,
        ltheta = 90, lphi = 180, shade = 0.4, ticktype = "detailed", nticks = 5)


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
