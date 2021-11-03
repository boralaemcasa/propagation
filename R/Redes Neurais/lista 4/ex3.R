setwd("C:\\Users\\cu_do_bispo\\Documents\\data sept 02 ex4 redes neurais\\entregar em 2 setembro 4")
rm(list=ls())
library('plot3D')
source('trainperceptron.R')
source('yperceptron.R')

data("iris")
dados <- iris
tudo <- as.matrix(iris)

xc1 <- matrix(0, 50, 4)
xc2 <- matrix(0, 100, 4)
for (i in 1:50) {
  for (j in 1:4)
    xc1[i,j] <- as.double(tudo[i,j])
}
for (i in 1:100) {
  for (j in 1:4)
    xc2[i,j] <- as.double(tudo[i + 50,j])
}

trein1 <- 0.7 * 50
trein2 <- 0.7 * 100

acuracia <- matrix(-1, 100, 1)
for (k in 1:100) {

print("k = ")
print(k)

amostra1 <- sample.int(50, size=50)
amostra2 <- sample.int(100, size=100)

xin <- matrix(0, trein1 + trein2, 4)
yd <- matrix(0, trein1 + trein2, 1)
for (i in 1:trein1) {
  for (j in 1:4)
    xin[i,j] <- xc1[amostra1[i],j]
}
for (i in 1:trein2) {
  for (j in 1:4)
    xin[i + trein1,j] <- xc2[amostra2[i],j]
  yd[i + trein1] <- 1
}

tol <- 1e-3
maxepocas <- 100
eta <- 0.1
par <- 1
res <- trainperceptron(xin,yd,eta,tol,maxepocas,par)
w <- res[[1]]

acertos <- 0
teste1 <- 0.3 * 50
teste2 <- 0.3 * 100
xx <- matrix(0, teste1 + teste2, 4)
yy <- matrix(-1, teste1 + teste2, 1)
for (i in 1:teste1) {
  for (j in 1:4)
    xx[i, j] <- xc1[amostra1[i + trein1],j]
  yy[i] <- yperceptron(xx[i,], w, 1)
  if (yy[i] == 0)
    acertos <- acertos + 1  
  else {
    print("x = ")
    print(xx[i,])
    print("Esperado = 0, Calculado = ")
    print(yy[i])
  }    
}

for (i in 1:teste2) {
  for (j in 1:4)
    xx[i + teste1 , j] <- xc2[amostra2[i + trein2],j]
  yy[i + teste1] <- yperceptron(xx[i + teste1,], w, 1)
  if (yy[i + teste1] == 1)
    acertos <- acertos + 1  
  else {
    print("x = ")
    print(xx[i + teste1,])
    print("Esperado = 1, Calculado = ")
    print(yy[i + teste1])
  }    
}

acuracia[k] <- 100 * acertos / (teste1 + teste2)

}

x <- seq(1,100,1)

plot(x,acuracia,col = 'blue', xlim = c(0,101), ylim = c(95,101), xlab = '', ylab = '')

var(acuracia)

