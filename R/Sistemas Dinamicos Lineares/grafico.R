rm(list = ls())
gc()

#teste

 dev.off()
 Mx <- 10
 My <- 6
 N <- 20
 x <- matrix(0, N)
 y <- matrix(0, N)
 y[-8 + 11] <- -2
 y[-7 + 11] <- -2
 y[-6 + 11] <- -2
 y[-5 + 11] <- -1
 y[-3 + 11] <-  1
 y[-2 + 11] <-  2
 y[-1 + 11] <-  3
 y[ 0 + 11] <-  4
 y[ 1 + 11] <-  5
 y[ 2 + 11] <-  6
 y[ 3 + 11] <-  4
 y[ 4 + 11] <-  2
 z <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = -10, t(N) = 10
    t <- i - 11
    x[i] <- t
    z[i] <- y[i] * cos(pi/2 * t)
 }
 plot(x,y,type = 'l',col='blue',xlim=c(-Mx,Mx),ylim = c(-My,My),xlab='x',ylab='y')
 par(new=T)
 plot(x,z,type = 'l',col='red',xlim=c(-Mx,Mx),ylim = c(-My,My),xlab='x',ylab='y')

###############################################

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

t <- 1

    x[i] <- t
    y[i] <- ex2(t)
    z1[i] <- ex2(-t)
    z2[i] <- ex2(t - 1)
    z3[i] <- ex2(t + 3)
    print z_i

ex3 <- function(n) {
   return (delta(n + 1) - delta(n) + u(n - 1) - u(n - 2))
}

t <- 1

    x[i] <- t
    y[i] <- ex3(t)
    z[i] <- ex3(4 - 2*t)
    print z

# escreva

####################### agora de R em R

ex4 <- function(t) {
   if ((-2 <= t) && (t < -1))
      return (t + 1)
   if ((-1 <= t) && (t < 0))
      return (1)
   if ((0 <= t) && (t < 1))
      return (2)
   if ((1 <= t) && (t < 2))
      return (2 - t)
   return (0)
}

 dev.off()
 Mx1 <- -4
 Mx2 <- 4
 My1 <- -1
 My2 <- 1.1
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
    z1[i] <- ex4(-t)
    z2[i] <- ex4(t - 1)
    z3[i] <- ex4(2 - t)
    z4[i] <- ex4(2*t + 1)
    z5[i] <- (ex4(t) + ex4(-t)) * u(t)
 }
 plot(x,y,type = 'l',col='blue',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
 par(new=T)
 plot(x,z1,type = 'l',col='green',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
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

t <- 1

    x[i] <- t
    y[i] <- p(t)
    z1[i] <- p(4 - t)
    z2[i] <- derivative(p, t, 1e-9)
    plot z1
    plot z2

