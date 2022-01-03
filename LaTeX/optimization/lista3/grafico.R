rm(list = ls())
gc()

#gráfico

f <- function(x) {
   #return (0.65 - 0.75/(1 + x^2) - 0.65 * x * atan(1/x))
   return (-0.5/sqrt(1 + x^2) + sqrt(1 + x^2) * ( 1 - 0.5/(1 + x^2) ) - x)
}
   
 dev.off()
 Mx1 <- 0
 Mx2 <- 3
 My1 <- -0.32
 My2 <- 0
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 z1 <- matrix(0, N)
 z2 <- matrix(0, N)
 z3 <- matrix(0, N)
 z4 <- matrix(0, N)
 z5 <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = Mx1, t(N) = Mx2
    t <- (Mx2 - Mx1)/(N - 1) * (i - 1) + Mx1 
    x[i] <- t
    y[i] <- f(t)
 }
 plot(x,y,type = 'l',col='blue',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='f(x)')
 min(y)
 for (i in 1:N)
    if (y[i] == min(y))
       print(x[i])

##################################################

#contorno

 library('plot3D')

 dev.off()
 Mx1 <- -5
 Mx2 <- 5
 My1 <- -3
 My2 <- 6
 delta <- 0.1
 x <- seq(Mx1, Mx2, delta)
 y <- seq(My1, My2, delta)
 M <- matrix(0,nrow=length(x),ncol=length(y))
 for (i in 1:length(x))
   for (j in 1:length(y))
      M[i,j]<- (x[i] + 2*y[j] - 7)^2 + (2*x[i] + y[j] - 5)^2

 min(M)
 for (i in 1:length(x))
   for (j in 1:length(y))
     if (M[i,j] == min(M)) {
        print(x[i])
        print(y[j])
     }

 contour2D(M,x,y,colkey = NULL,zlim=c(0,20)) 

##################################################

#contorno

 library('plot3D')

 dev.off()
 Mx1 <- -4
 Mx2 <- 4
 My1 <- -3
 My2 <- 6
 delta <- 0.1
 x <- seq(Mx1, Mx2, delta)
 y <- seq(My1, My2, delta)
 M <- matrix(0,nrow=length(x),ncol=length(y))
 for (i in 1:length(x))
   for (j in 1:length(y))
      M[i,j]<- (2*y[j] + 2*x[i]^2)^2 + (1 - x[i])^2

 min(M)
 for (i in 1:length(x))
   for (j in 1:length(y))
     if (M[i,j] == min(M)) {
        print(x[i])
        print(y[j])
     }

 contour2D(M,x,y,colkey = NULL,zlim=c(0,20)) 

##################################################

#Newton

x <- -1.2
y <- 1.0 
for (i in 1:4){
g <- matrix(0, 2, 1)
g[1] <- -400*x*(y - x^2) - 2*(1 - x)
g[2] <- 200*(y - x^2)
print(g)
H <- matrix(200, 2, 2)
H[1,1] <- -400*(y - 3*x^2) + 2
H[1,2] <- -400*x
H[2,1] <- -400*x
print(H)
v <- rbind(x, y) - solve(H) %*% g
x <- v[1]
y <- v[2]
print(x)
print(y)
print("obj")
print(100*(y - x^2)^2 +(1 - x)^2)
}

##################################################

#Newton

x <- 1
y <- 2 
for (i in 1:4){
g <- matrix(0, 2, 1)
g[1] <- 4*x
g[2] <- 2*y
print(g)
H <- matrix(0, 2, 2)
H[1,1] <- 4
H[2,2] <- 2
print(H)
v <- rbind(x, y) - solve(H) %*% g
x <- v[1]
y <- v[2]
print(x)
print(y)
print("obj")
print(2*x^2 + y^2)
}

##################################################

#Newton

x <- 2
y <- -1
z <- 1 
for (i in 1:4){
g <- matrix(0, 3, 1)
g[1] <- 2*x
g[2] <- 6*y
g[3] <- 12*z
print(g)
H <- matrix(0, 3, 3)
H[1,1] <- 2
H[2,2] <- 6
H[3,3] <- 12
print(H)
v <- rbind(x, y, z) - solve(H) %*% g
x <- v[1]
y <- v[2]
z <- v[3]
print(x)
print(y)
print(z)
print("obj")
print(x^2 + 3* y^2 + 6* z^2)
}

##################################################

#gradientes

h <- function(x,y) {
  return(100*(y - x^2)^2 +(1 - x)^2)
}

x <- 0.5
y <- 0.5
dx <- 0.0001
dy <- 0.0001
v2 <- matrix(0, 2)
v3 <- matrix(0, 2)
v4 <- matrix(0, 2)
v2[1] <- (h(x + dx,y) - h(x - dx,y))/2/dx
v2[2] <- (h(x,y + dy) - h(x,y - dy))/2/dy
v3[1] <- (h(x + dx,y) - h(x,y))/dx
v3[2] <- (h(x,y + dy) - h(x,y))/dy
v4[1] <- (h(x,y) - h(x - dx,y))/dx
v4[2] <- (h(x,y) - h(x,y - dy))/dy
#diferença centrada
v2
#diferença progressiva
v3
#diferença regressiva
v4
#números positivos
v3 - v2
#números negativos
v4 - v2
#erro percentual
100 * (v3 - v2)/v2
100 * (v4 - v2)/v2

##################################################

#busca exaustiva

f <- function(x) {
   return (0.65 - 0.75/(1 + x^2) - 0.65 * x * atan(1/x))
   #return (-0.5/sqrt(1 + x^2) + sqrt(1 + x^2) * ( 1 - 0.5/(1 + x^2) ) - x)
}

exato <- -0.3100204 # -0.300283   
N <- 4 # 3
n <- N + 2
a0 <- 0
b0 <- 3
for (epoca in 1:100) {
 print(epoca)
 v <- seq(a0, b0, (b0 - a0)/(N + 1))
 fv <- f(v)
 fim <- n
 m <- min(fv)
 acuracia <- 100 * abs((m - exato)/exato)
  if (acuracia <= 5)
    break
 for (i in 1:n)
    if (fv[i] == m) {
       fim <- 1
       while ((i + fim <= n) & (fv[i + fim] == min(fv)))
          fim <- fim + 1
       if ((i + fim > n) | (fv[i + fim] != min(fv)))
          fim <- fim - 1
       fim <- fim + i
       if (i == fim) {
          i <- max(i - 1, 1)
          fim <- min(fim + 1, n)
       }
       break
    }
  a0 <- v[i]
  b0 <- v[fim]
}
a0
b0
m
acuracia

##################################################

#busca dicotômica

f <- function(x) {
   #return (0.65 - 0.75/(1 + x^2) - 0.65 * x * atan(1/x))
   return (-0.5/sqrt(1 + x^2) + sqrt(1 + x^2) * ( 1 - 0.5/(1 + x^2) ) - x)
}

exato <- -0.300283 # -0.3100204   
n <- 4
a0 <- 0
b0 <- 3
delta <- 0.0001
v <- matrix(0, 4)
for (epoca in 1:100) {
 print(epoca)
 v[1] <- a0
 v[2] <- (a0 + b0)/2 - delta/2
 v[3] <- (a0 + b0)/2 + delta/2
 v[4] <- b0
 fv <- f(v)
 fim <- n
 m <- min(fv)
 for (i in 1:n)
    if (fv[i] == m) {
       fim <- 1
       while ((i + fim <= n) & (fv[i + fim] == min(fv)))
          fim <- fim + 1
       if ((i + fim > n) | (fv[i + fim] != min(fv)))
          fim <- fim - 1
       fim <- fim + i
       if (i == fim) {
          i <- max(i - 1, 1)
          fim <- min(fim + 1, n)
       }
       break
    }
  a0 <- v[i]
  b0 <- v[fim]
  m <- f((a0 + b0)/2)
  acuracia <- 100 * abs((m - exato)/exato)
  if (acuracia <= 5)
     break
}
a0
b0
m
acuracia
