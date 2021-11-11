rm(list = ls())
gc()

source("V:\\sem backup\\_4 anal sist dinamicos lineares\\lista 1\\util.R")

#############################

f <- function(t) {
   return (u(t - 8) - u(t - 11))
}

g <- function(t) {
   return (u(t) - u(t - 2))
}

 dev.off()

 # Mx2 = Mx1 + N
 Mx1 <- 5
 Mx2 <- 15
 My1 <- -1
 My2 <- 3
 N <- Mx2 - Mx1
 x <- matrix(0, N)
 y <- matrix(0, N)
 z <- matrix(0, N)
 w <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = Mx1
    t <- i + Mx1 - 1
    x[i] <- t
    y[i] <- f(t)
    z[i] <- g(t)
    w[i] <- convolution_discrete(f, g, t, 1000)
    #plotar(x[i], y[i], Mx1, Mx2, My1, My2, 'blue')
    #plotar(x[i], z[i], Mx1, Mx2, My1, My2, 'green')
    plotar(x[i], w[i], Mx1, Mx2, My1, My2, 'red')
 }

convolution_discrete(f, g, 5, 1000)

###############################################

f <- function(t) {
   return (exp(-t) * u(t))
}

g <- function(t) {
   return (u(t+3) - u(t))
}

ff <- function(t) {
   if (t < -3)
      return (0)
   if (t >= 0)
      return (exp(-t) - exp(- t - 3))
   return (1 - exp(-t - 3))
}

 dev.off()
 Mx1 <- -4
 Mx2 <- 4
 My1 <- -1
 My2 <- 1.1
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 z <- matrix(0, N)
 w <- matrix(0, N)
 ww <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = Mx1, t(N) = Mx2
    t <- (Mx2 - Mx1)/(N - 1) * (i - 1) + Mx1 
    x[i] <- t
    y[i] <- f(t)
    z[i] <- g(t)
    w[i] <- convolution(f, g, t)
    ww[i] <- ff(t) - 0.1
 }
 plot(x,y,type = 'l',col='blue',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
 par(new=T)
 plot(x,z,type = 'l',col='green',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
 par(new=T)
 plot(x,w,type = 'l',col='red',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')

 par(new=T)
 plot(x,ww,type = 'l',col='blue',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')

convolution(f, g, 2)

###############################################

cbind(c(1,2,3),c(4,5,6)) # duas colunas
rbind(c(1,2,3),c(4,5,6)) # duas linhas

G <- function(x) {
   y <- exp(- x[1]*x[1] - x[2]*x[2])
   return (rbind(c(y,y,y),c(y,y,y)))
}

H <- function(x) {
   y <- exp(- x[1]*x[1] - x[2]*x[2])
   return (as.matrix(c(y, y)))
}

# z = exp(-x^2 - y^2)
# convolucao de z com z = pi

convolution_matrix(G, H, as.matrix(c(0, 0)), 2, 3)

###############################################

f <- function(n) {
   n <- -n
   return ((3*n - 1)^2)
}

g <- function(n) {
   return (delta(2*n + 3))
}

ex14a <- convolution_discrete(f, g, 0, 1000)

###

f <- function(t) {
   t <- -t
   return ((3*t - 1)^2)
}

g <- function(t) {
   return (delta(t + 1))
}

ex14b <- convolution(f, g, 0)

###

f <- function(t) {
   t <- -t
   return ((3*t - 1)^2)
}

g <- function(t) {
   return (delta(2*t + 2))
}

ex14c <- convolution(f, g, 0)

###

f <- function(t) {
   t <- -t
   return ((3*t - 1)^2)
}

g <- function(t) {
   return (delta(2*t - 2))
}

ex14d <- convolution(f, g, 0)

###

f <- function(t) {
   t <- -t
   return (delta(2*t - 3))
}

g <- function(t) {
   return (sin(pi*t))
}

ex14e <- convolution(f, g, 0)

###

f <- function(x) {
   x <- -x
   return (exp(x - 1) * cos( pi/2 * (x - 5) ))
}

g <- function(x) {
   return (delta(x - 3))
}

ex14f <- convolution(f, g, 0)

################################
ex15

f <- function(n) {
   return (u(n) - u(n - 1) - u(n - 2) + u(n - 3))
}

g <- function(n) {
   return (u(n - 1) - u(n - 2))
}

h <- function(n) {
   return (convolution_discrete(f, g, n, 1000))
}

#convolution_discrete(f, g, 0, 1000)

dev.off()
grafico_discreto(f, -10, 10, -2, 5, 'blue')
grafico_discreto(g, -10, 10, -2, 5, 'green')
dev.off()
grafico_discreto(h, -10, 10, -2, 5, 'blue')

################################
ex16

f <- function(n) {
   return (u(n + 1) - u(n - 2))
}

g <- function(n) {
   return (u(n) - u(n - 2))
}

h <- function(n) {
   return (convolution_discrete(f, g, n, 1000))
}

#convolution_discrete(f, g, 0, 1000)

dev.off()
grafico_discreto(f, -10, 10, -2, 5, 'blue')
grafico_discreto(g, -10, 10, -2, 5, 'green')
dev.off()
grafico_discreto(h, -10, 10, -2, 5, 'blue')

################################
ex17

x1 <- function(t) {
   return (u(t))
}

x2 <- function(t) {
   return (- u(t) + 2*u(t - 1) - u(t - 2))
}

h <- function(t) {
   return (u(t + 1) - 2 * u(t) + u(t - 1))
}

h1 <- function(t) {
   return (convolution(x1, h, t))
}

h2 <- function(t) {
   return (convolution(x2, h, t))
}

#convolution(x1, h, 0)
#convolution(x2, h, 0)

dev.off()
grafico(x1, -10, 10, -2, 5, 'blue', 1000)
grafico(h, -10, 10, -2, 5, 'green', 1000)
dev.off()
grafico(h1, -2, 2, -2, 2, 'blue', 1000)

dev.off()
grafico(x2, -10, 10, -2, 5, 'blue', 1000)
grafico(h, -10, 10, -2, 5, 'green', 1000)
dev.off()
grafico(h2, -4, 6, -2, 3, 'blue', 1000)


################################
ex19

f <- function(t) {
   return (- delta(t + 1) + 2*delta(t) - delta(t - 1))
}

g <- function(t) {
  return (impropria_lim2(f, t))
}

h <- function(t) {
   return (convolution(f, g, t))
}

#convolution(f, g, 0)

dev.off()
grafico(f, -4, 4, -2.5, 2.5, 'blue', 1000)
dev.off()
grafico(g, -3, 3, -1, 1, 'blue', 1000)
dev.off()
grafico(h, -4, 6, -0.15, 0.15, 'blue', 100)

# expresse g(t) como soma ponderada de degraus.
# g(t) = -u[-1 + t] + 2 u[t] - u[1 + t]

################################
ex21a

alpha != beta

alpha <- 0.5
beta <- 1.5

f <- function(t) {
   return (exp(- alpha*t) * u(t))
}

g <- function(t) {
   return (exp(- beta*t) * u(t))
}

h1 <- function(y) {
   a <- 4
   b <- 2
   return (-(((exp(-(a * y)) - exp(-(b * y))) * u(y))/(a - b)))
}

h2 <- function(x) {
   return (x * u(x)/exp(2* x))
}

#convolution(f, g, 0)

dev.off()
grafico(h1, -4, 4, -0.5, 0.5, 'blue', 1000)
grafico(h2, -4, 4, -0.5, 0.5, 'green', 1000)


################################
ex21b

f <- function(t) {
   return (u(t) - 2*u(t - 2) + u(t - 5))
}

g <- function(t) {
   return (exp(2*t) * u(1 - t))
}

h <- function(y) {
   return (u (1/4 * exp(2 * y) * (3 - 2 * y) - 1/2 * exp(2*y - 4) * (7 - 2*y) + 1/4 * exp(2*(y - 5))*(13 - 2*y)))
}

#convolution(f, g, 0)

dev.off()
grafico(h, -10, 10, -1, 2, 'blue', 1000)
   
################
ex22

Sabendo h = F(delta), queremos saber se F é bibo estável.

ha <- function(n) {
   return (abs(n * cos(pi/4 * n) * u(n)))
}

hb <- function(n) {
   return (3^n * u(-n + 10))
}

j <- complex(imaginary = 1)

hc <- function(t) {
   return (exp(t*(2*j - 1)) * u(t))
}

hd <- function(t) {
   return (exp(-t) * cos(2*t) * u(t))
}

bibo_discreto(ha, 1000)
bibo_discreto(hb, 1000)
bibo(hc)
bibo(hd)

dev.off()
grafico_discreto(ha, -10, 30, -20, 20, 'blue')
dev.off()
grafico_discreto(hb, -10, 30, -20, 3^10, 'blue')
dev.off()
grafico(hc, -10, 10, -1, 2, 'blue', 1000)
dev.off()
grafico(hd, -10, 10, -1, 2, 'blue', 1000)

################
ex23

Sabendo h = F(delta), queremos saber se F é A) causal; B) bibo estável. 

ha <- function(n) {
   return (0.2^n * u(n))
}

hb <- function(n) {
   return (0.8^n * u(n + 2))
}

hc <- function(n) {
   return (5^n * u(3 - n))
}

hd <- function(n) {
   return (abs((-0.5)^n + 1.01^n * u(n - 1)))
}

he <- function(t) {
   return (exp(-4*t) * u(t - 2))
}

hf <- function(t) {
   return (exp(-6*t) * u(3 - t))
}

hg <- function(t) {
   return (exp(-2*t) * u(t + 50))
}

hh <- function(t) {
   return (t * exp(-t) * u(t))
}

dev.off()
grafico_discreto(ha, -10, 10, -10, 10, 'blue')
dev.off()
grafico_discreto(hb, -10, 10, -10, 10, 'blue')
dev.off()
grafico_discreto(hc, -10, 10, -10, 10, 'blue')
dev.off()
grafico_discreto(hd, -10, 10, -10, 10, 'blue')
dev.off()
grafico(he, -10, 10, -5e-4, 5e-4, 'blue', 1000)
dev.off()
grafico(hf, -10, 10, -1, 20, 'blue', 1000)
dev.off()
grafico(hg, -10, 10, -10, 10, 'blue', 1000)
dev.off()
grafico(hh, -10, 10, -0.5, 0.5, 'blue', 1000)

bibo_discreto(ha, 1000)
bibo_discreto(hb, 1000)
bibo_discreto(hc, 1000)
bibo_discreto(hd, 1000)
bibo(he)
bibo(hf)
bibo(hg)
bibo(hh)

################################
ex24 discreto

f <- function(t) {
   return (u(t) - u(t - 4))
}

g <- function(t) {
   return (u(t - 2) - u(t - 7) + u(t - 11) - u(t - 16))
}

h <- function(n) {
   return (convolution_discrete(f, g, n, 1000))
}

#convolution_discrete(f, g, 0, 1000)

dev.off()
grafico_discreto(f, -10, 20, -10, 10, 'blue')
grafico_discreto(g, -10, 20, -10, 10, 'green')
dev.off()
grafico_discreto(h, -5, 30, -10, 10, 'blue')
   
################################
ex28

A) x[n] ** h1[n] ** (h2[n] + h3[n]) = y[n]
  
   \therefore h[n] = h1[n] ** (h2[n] + h3[n])
   
B)

f <- function(n) {
   return (0.5^n * u(n + 2))
}

g <- function(n) {
   return (delta(n) + u(n - 1))
}

h <- function(n) {
   return (convolution_discrete(f, g, n, 1000))
}

#convolution_discrete(f, g, 0, 1000)

grafico_discreto(f)
grafico_discreto(g)
grafico_discreto(h)
   
################################
ex29

f <- function(t) {
   return (3 * u(t - 2))
}

g <- function(t) {
   return (u(t + 1) - u(t) - 0.5 * (u(t - 2) - u(t - 4)))
}

h <- function(y) {
   return (3 (-0.5 ((y - 4) u(y - 4) - (y - 6) u(y - 6)) - (y - 2) u(y - 2) + (y - 1) u(y - 1)))
}

#convolution(f, g, 0)

grafico(h)
   
################################
ex30

Sigma1 = h1 ** h5 + h4
Sigma2 = h1 ** h2 + Sigma1 ** h3 = h
     h = h1 ** h2 + (h1 ** h5 + h4) ** h3
     h = h1 ** h2 + h1 ** h3 ** h5 + h3 ** h4
    