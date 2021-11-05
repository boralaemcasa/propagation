rm(list = ls())
gc()

source("V:\\sem backup\\_4 anal sist dinamicos lineares\\lista 1\\integrar.R")

convolution_discrete <- function(f, g, x, infty) {
   soma <- 0
   for (k in -infty:infty) {
      soma <- soma + f(x - k) * g(k)
   }
   return (soma)
}

segmento <- function(x1, y1, x2, y2, color, p1, p2) {
 N <- 1000
 x <- matrix(0, N + 1)
 y <- matrix(0, N + 1)
 for (i in 1:(N + 1)) {
    x[i] <- x1 + (x2 - x1) * (i - 1)/N
    y[i] <- y1 + (y2 - y1) * (i - 1)/N
 }
 plot(x,y,type = 'l',col=color,xlim=p1,ylim=p2,xlab='x',ylab='y')
 par(new=T)
}

plotar <- function(x, y, Mx1, Mx2, My1, My2, color) {
   segmento(x, 0, x, y, color, c(Mx1,Mx2), c(My1,My2))
}

# https://twitter.com/mathspiritual/status/1371110143807610883
convolution <- function(f, g, x) {
   return (convolution_matrix(f, g, x, 1, 1)) # de R em R, dx = 0.01
}

# n <- dim Dom ; a <- dim Im
convolution_matrix <- function(f, g, x, n, a) {
   m <- 100
   mm <- (2 * m - 1)^n
   dV <- m^(-n)
   soma <- matrix(0, a)
   v <- matrix(0, n)
   for (j in 1:n)
      v[j] <- -m + 1
   hh <- matrix(0, n)
   for (i in 1:mm) {
      u <- 1/m * v
      prod <- dV
      for (j in 1:n) {
         hh[j] <- u[j]/(1 - abs(u[j]))
         prod <- prod * (1 - abs(u[j]))^(-2)
      }
      ff <- f(x - hh)
      soma <- soma + prod * t(ff) %*% g(hh)

      v[n] <- v[n] + 1
      j <- 0
      while (v[n - j] >= m) {
         v[n - j] <- -m + 1
         v[n - j - 1] <- v[n - j - 1] + 1
         j <- j + 1
         if (n == j)
            break
      }
   }
   return (soma)
}

#############################

f <- function(t) {
   return (u(t) - u(t - 10))
}

g <- function(t) {
   return (u(t - 2) - u(t - 7))
}

 dev.off()

 # Mx2 = Mx1 + N
 Mx1 <- -2
 Mx2 <- 20
 My1 <- -1
 My2 <- 6
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

#convolution_discrete(f, g, 0, 1000)

    x[i] <- t
    y[i] <- f(t)
    z[i] <- g(t)
    w[i] <- convolution_discrete(f, g, t, 1000)

################################
ex16

f <- function(n) {
   return (u(n + 1) - u(n - 2))
}

g <- function(n) {
   return (u(n) - u(n - 2))
}

#convolution_discrete(f, g, 0, 1000)

    x[i] <- t
    y[i] <- f(t)
    z[i] <- g(t)
    w[i] <- convolution_discrete(f, g, t, 1000)


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

#convolution(x1, h, 0)
#convolution(x2, h, 0)


    x[i] <- t
    y[i] <- x1(t)
    z[i] <- h(t)
    w[i] <- convolution(x1, h, t)

    x[i] <- t
    y[i] <- x2(t)
    z[i] <- h(t)
    w[i] <- convolution(x2, h, t)

################################
ex19

f <- function(t) {
   return (- delta(t + 1) + 2*delta(t) - delta(t - 1))
}

g <- function(t) {
  return (impropria_lim2(f, t))
}

#convolution(f, g, 0)

    x[i] <- t
    y[i] <- f(t)
    z[i] <- g(t)
    w[i] <- convolution(f, g, t)

# expresse g(t) como soma ponderada de degraus.

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

#convolution(f, g, 0)

    x[i] <- t
    y[i] <- f(t)
    z[i] <- g(t)
    w1[i] <- convolution(f, g, t)
    w2[i] <- convolution(f, f, t)


################################
ex21b

f <- function(t) {
   return (u(t) - 2*u(t - 2) + u(t - 5))
}

g <- function(t) {
   return (exp(2*t) * u(1 - t))
}

#convolution(f, g, 0)

    x[i] <- t
    y[i] <- f(t)
    z[i] <- g(t)
    w[i] <- convolution(f, g, t)


################
ex22

Sabendo h = F(delta), queremos saber se F é bibo estável.

ha <- function(n) {
   return (n * cos(pi/4 * n) * u(n))
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

ha(2)
hb(2)
hc(2)
hd(2)

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
   return ((-0.5)^n + 1.01^n * u(n - 1))
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

ha(2)
hb(2)
hc(2)
hd(2)
he(2)
hf(2)
hg(2)
hh(2)


################################
ex24 discreto

f <- function(t) {
   return (u(t) - u(t - 4))
}

g <- function(t) {
   return (u(t - 2) - u(t - 7) + u(t - 11) - u(t - 16))
}

#convolution_discrete(f, g, 0, 1000)

    x[i] <- t
    y[i] <- f(t)
    z[i] <- g(t)
    w[i] <- convolution_discrete(f, g, t, 1000)

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

#convolution_discrete(f, g, 0, 1000)

    x[i] <- t
    y[i] <- f(t)
    z[i] <- g(t)
    w[i] <- convolution_discrete(f, g, t, 1000)

################################
ex29

f <- function(t) {
   return (3 * u(t - 2))
}

g <- function(t) {
   return (u(t + 1) - u(t) - 0.5 * (u(t - 2) - u(t - 4)))
}

#convolution(f, g, 0)

    x[i] <- t
    y[i] <- f(t)
    z[i] <- g(t)
    w[i] <- convolution(f, g, t)

################################
ex30

Sigma1 = h1 ** h5 + h4
Sigma2 = h1 ** h2 + Sigma1 ** h3 = h
     h = h1 ** h2 + (h1 ** h5 + h4) ** h3
     h = h1 ** h2 + h1 ** h3 ** h5 + h3 ** h4

