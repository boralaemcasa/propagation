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

segmento <- function(x1, y1, x2, y2, color, p1, p2) {
 N <- 1000
 x <- matrix(0, N + 1)
 y <- matrix(0, N + 1)
 for (i in 1:(N + 1)) {
    x[i] <- x1 + (x2 - x1) * (i - 1)/N
    y[i] <- y1 + (y2 - y1) * (i - 1)/N
 }
 par(new=T)
 plot(x,y,type = 'l',col=color,xlim=p1,ylim=p2,xlab='x',ylab='y')
}

circulo( 0,  0, 1, 'blue', c(-1.2,1.2), c(-1.2,1.2))
circulo( 1,  0, 0.04, 'blue', c(-1.2,1.2), c(-1.2,1.2))
circulo(-1,  0, 0.04, 'blue', c(-1.2,1.2), c(-1.2,1.2))
circulo( 0,  1, 0.04, 'blue', c(-1.2,1.2), c(-1.2,1.2))
circulo( 0, -1, 0.04, 'blue', c(-1.2,1.2), c(-1.2,1.2))

###############################################

circulo(0, 0, 1, 'blue')
circulo(1/2, sqrt(3)/2, 0.04, 'blue')
circulo(1/2, 0, 0.04, 'blue')
circulo(0, sqrt(3)/2, 0.04, 'blue')
segmento(0, 0, 1, sqrt(3), 'blue')
segmento(0, 0, 1/2, 0, 'blue')
segmento(0, 0, 0, sqrt(3)/2, 'blue')

###############################################

 M <- 6
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = 0.001, t(N) = M
    t <- (M - 0.001)/(N - 1) * (i - 1) + 0.001 
    x[i] <- t
    y[i] <- 1/t
 }
 par(new=T)
 plot(x,y,type = 'l',col='blue',xlim=c(-1,M),ylim = c(-1,M),xlab='x',ylab='y')

segmento(1, 0, 2, 0, 'blue', c(-1,M), c(-1,M))
segmento(2, 0, 2, 1/2, 'blue', c(-1,M), c(-1,M))
segmento(1, 0, 1, 1, 'blue', c(-1,M), c(-1,M))

###############################################
limiar <- function(x, theta) {
   if (x >= theta)
      return(1)
   return(0)
}

 M <- 2.1
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 z <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = -M, t(N) = M
    t <- 2*M/(N - 1) * (i - 1) - M
    x[i] <- t
    y[i] <- tanh(-1 * t)
 }
 #par(new=T)
 plot(x,y,type = 'l',col='blue',xlim=c(-M,M),ylim = c(-M,M),xlab='x',ylab='y')

###############################################

require(lattice)
g <- expand.grid(x = seq(-3,3,0.1), y = seq(-3,3,0.1), gr = 1:2)
g$z <- exp( - g$x^2 - g$y^2)
wireframe(z ~ x * y, data = g, groups = gr,
          scales = list(arrows = FALSE),
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 30, x = -60))

###############################################

M <- 3
require(lattice)
g <- expand.grid(x = seq(-M,M,0.1), y = seq(-M,M,0.1), gr = 1:2)
g$z <- g$x^2 - 2*g$y^2
wireframe(z ~ x * y, data = g, groups = gr,
          scales = list(arrows = FALSE),
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 30, x = -60))

###############################################

 k <- 4
 M <- pi
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = 0.001, t(N) = M
    t <- 2*M/(N - 1) * (i - 1) -M 
    x[i] <- t
    y[i] <- cos(k*t)
 }
 par(new=T)
 plot(x,y,type = 'l',col='blue',xlim=c(-M,M),ylim = c(-1.2,1.2),xlab='x',ylab='y')



###############################################

 M <- 3
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 z <- matrix(0, N)
 zero <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = 0.001, t(N) = M
    t <- 2*M/(N - 1) * (i - 1) -M 
    x[i] <- t
    y[i] <- sinh(t)
    z[i] <- cosh(t)
 }
 par(new=T)
 plot(x,y,type = 'l',col='blue',xlim=c(-M,M),ylim = c(-3*M,3*M),xlab='x',ylab='y')
 par(new=T)
 plot(x,z,type = 'l',col='blue',xlim=c(-M,M),ylim = c(-3*M,3*M),xlab='x',ylab='y')
 par(new=T)
 plot(x,zero,type = 'l',col='black',xlim=c(-M,M),ylim = c(-3*M,3*M),xlab='x',ylab='y')
 par(new=T)
 plot(zero,y,type = 'l',col='black',xlim=c(-M,M),ylim = c(-3*M,3*M),xlab='x',ylab='y')


###############################################

 M <- 0.1
 max <- M
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 zero <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = 0.001, t(N) = M
    t <- 2*M/(N - 1) * (i - 1) -M 
    x[i] <- t
    y[i] <- t*cos(1/t)
 }
 par(new=T)
 plot(x,y,type = 'l',col='blue',xlim=c(-M,M),ylim = c(-max,max),xlab='x',ylab='y')
 par(new=T)
 plot(x,zero,type = 'l',col='black',xlim=c(-M,M),ylim = c(-max,max),xlab='x',ylab='y')
 par(new=T)
 plot(zero,y,type = 'l',col='black',xlim=c(-M,M),ylim = c(-max,max),xlab='x',ylab='y')


###############################################

 M <- 3
 max <- M
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 z <- matrix(0, N)
 zero <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = 0.001, t(N) = M
    x[i] <- 2*M/(N - 1) * (i - 1) -M 
    if (x[i] < -2)
       t <- 2*M/(N - 1) * (i - 1) -M + 1
    else if ((x[i] > -1) && (x[i] <= 1))
       t <- 2*M/(N - 1) * (i - 1) -M 
    else if (x[i] > 2)
       t <- 2*M/(N - 1) * (i - 1) -M - 1
    else if (x[i] > 1)
       t <- 1
    else
       t <- -1
    y[i] <- t^5/5 - 2* t^3/3 + t
    z[i] <- - y[i]
 }
 par(new=T)
 plot(x,y,type = 'l',col='blue',xlim=c(-M,M),ylim = c(-max,max),xlab='x',ylab='y')
 par(new=T)
 plot(x,z,type = 'l',col='red',xlim=c(-M,M),ylim = c(-max,max),xlab='x',ylab='y')
 par(new=T)
 plot(x,zero,type = 'l',col='black',xlim=c(-M,M),ylim = c(-max,max),xlab='x',ylab='y')
 par(new=T)
 plot(zero,y,type = 'l',col='black',xlim=c(-M,M),ylim = c(-max,max),xlab='x',ylab='y')

###############################################

