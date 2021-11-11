rm(list = ls())
gc()

source("V:\\sem backup\\_4 anal sist dinamicos lineares\\lista 1\\util.R")

################################################

ex2 <- function(t) {
   if (t == -2)
      return (-1)
   if (t == -1)
      return (1)
   if (t == 0)
      return (2)
   if (t == 1)
      return (-2)
   if (t == 2)
      return (1)
   return (0)
}

 dev.off()

 # Mx2 = Mx1 + N
 Mx1 <- -10
 Mx2 <- 10
 My1 <- -3
 My2 <- 3
 N <- Mx2 - Mx1
 x <- matrix(0, N)
 y <- matrix(0, N)
 z1 <- matrix(0, N)
 z2 <- matrix(0, N)
 z3 <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = Mx1
    t <- i + Mx1 - 1
    x[i] <- t
    y[i] <- ex2(t)
    z1[i] <- ex2(-t)
    z2[i] <- ex2(t - 1)
    z3[i] <- ex2(t + 3)
    #plotar(x[i], y[i], Mx1, Mx2, My1, My2, 'green')
    plotar(x[i], z3[i], Mx1, Mx2, My1, My2, 'blue')
    #plotar(x[i], z2[i], Mx1, Mx2, My1, My2, 'red')
 }

ex3 <- function(n) {
   return (delta(n + 1) - delta(n) + u(n - 1) - u(n - 2))
}

 dev.off()

 # Mx2 = Mx1 + N
 Mx1 <- 0
 Mx2 <- 5
 My1 <- -2
 My2 <- 2
 N <- Mx2 - Mx1
 x <- matrix(0, N)
 y <- matrix(0, N)
 z <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = Mx1
    t <- i + Mx1 - 1
    x[i] <- t
    y[i] <- ex3(t)
    z[i] <- ex3(4 - 2*t)
    plotar(x[i], z[i], Mx1, Mx2, My1, My2, 'blue')
    #plotar(x[i], z[i], Mx1, Mx2, My1, My2, 'green')
 }

# escreva... \therefore y[n] = - delta[n - 2]

####################### agora de R em R

ex4 <- function(t) {
   if (t >= 2)
      return (0)
   if ((1 <= t) && (t < 2))
      return (2 - t)
   if ((0 <= t) && (t < 1))
      return (2)
   if ((-1 <= t) && (t < 0))
      return (1)
   if ((-2 <= t) && (t < -1))
      return (t + 1)
   return (0)
}
   
 dev.off()
 Mx1 <- -2
 Mx2 <- 2
 My1 <- -4
 My2 <- 4
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
    # t <- 1
    y[i] <- ex4(t)
    z1[i] <- ex4(2*t + 1)
    z2[i] <- ex4(t - 1)
    z3[i] <- ex4(2 - t)
    z4[i] <- ex4(2*t + 1)
    z5[i] <- (ex4(t) + ex4(-t)) * u(t)
 }
 plot(x,z1,type = 'l',col='blue',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
 par(new=T)
 plot(x,z5,type = 'l',col='green',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')

 par(new=T)
 plot(x,z2,type = 'l',col='red',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
 
##################################################
ex12

G <- function(t, T) {
   return (u(t + T/2) - u(t - T/2))
}

p <- function(t) {
   return (G(t - 0.5, 1) + (t - 1) * G(t - 1.5, 1) 
         - G(t - 3.5, 1) + (3 - t) * G(t - 2.5, 1))
}

 dev.off()
 Mx1 <- -1
 Mx2 <- 6
 My1 <- -1.1
 My2 <- 2.1
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 z1 <- matrix(0, N)
 z2 <- matrix(0, N)
 z3 <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = Mx1, t(N) = Mx2
    t <- (Mx2 - Mx1)/(N - 1) * (i - 1) + Mx1 
    x[i] <- t
    y[i] <- p(t)
    z1[i] <- p(4 - t)
    z2[i] <- derivative(p, t, 1e-9)
    z3[i] <- u(t - 3) - u(t - 4) - u(t) + u(t - 1) + (u(t - 1) - u(t - 2)) * (t - 1) + (u(t - 2) - u(t - 3)) * (3 - t)
 }
 plot(x,y,type = 'l',col='blue',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
 par(new=T)
 plot(x,z2,type = 'l',col='green',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
 par(new=T)
 plot(x,z2,type = 'l',col='red',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
 
