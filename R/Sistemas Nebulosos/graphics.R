
 M <- 7
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 z <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = 0.001, t(N) = M
    t <- (M - 0.001)/(N - 1) * (i - 1) + 0.001
    x[i] <- t
    if ((1 <= t) && (t <= 3))
       y[i] <- -1/2 + t/2
    else if ((3 <= t) && (t <= 5))
       y[i] <- 5/2 - t/2
    # z[i] <- 1 - y[i] # Zadeh
    # z[i] <- (1 - y[i]^3)^(1/3) # Yager, w = 3
    z[i] <- (1 - y[i])/(1 + 3 * y[i]) # Sugeno, s = 3
 }
 plot(x,y,type = 'l',col='blue',xlim=c(-0.1,M),ylim = c(-0.1,1.1),xlab='x',ylab='y')
 par(new=T)
 plot(x,z,type = 'l',col='red',xlim=c(-0.1,M),ylim = c(-0.1,1.1),xlab='x',ylab='y')

###############################################

 M <- 7
 N <- 1000
 x <- matrix(0, N)
 y <- matrix(0, N)
 z <- matrix(0, N)
 w <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = 0.001, t(N) = M
    t <- (M - 0.001)/(N - 1) * (i - 1) + 0.001
    x[i] <- t
    if ((1 <= t) && (t <= 3))
       y[i] <- -1/2 + t/2
    else if ((3 <= t) && (t <= 5))
       y[i] <- 5/2 - t/2
    if ((2 <= t) && (t <= 4))
       z[i] <- -1 + t/2
    else if ((4 <= t) && (t <= 6))
       z[i] <- 3 - t/2
    # w[i] <- max(y[i], z[i]) # S max
    # w[i] <- y[i] + z[i] - y[i] * z[i] # S probabilistica
    # w[i] <- min(1, y[i] + z[i]) # S limitada
    # if (z[i] == 0)
    #    w[i] <- y[i]
    # else if (y[i] == 0)
    #    w[i] <- z[i]
    # else
    #    w[i] <- 1 # drástica

    # w[i] <- min(y[i], z[i]) # T min
    # w[i] <- y[i] * z[i] # T(a, b) = ab
    # w[i] <- max(0, y[i] + z[i] - 1) # T limitada
    if (z[i] == 1)
       w[i] <- y[i]
    else if (y[i] == 1)
       w[i] <- z[i]
    else
       w[i] <- 0 # drástica

 }
 plot(x,y,type = 'l',col='blue',xlim=c(-0.1,M),ylim = c(-0.1,1.1),xlab='x',ylab='y')
 par(new=T)
 plot(x,z,type = 'l',col='red',xlim=c(-0.1,M),ylim = c(-0.1,1.1),xlab='x',ylab='y')
 par(new=T)
 plot(x,w,type = 'l',col='green',xlim=c(-0.1,M),ylim = c(-0.1,1.1),xlab='x',ylab='y')

###############################################

require(lattice)
g <- expand.grid(x = seq(0,1,0.05), y = seq(0,1,0.05), gr = 1:2)
for (i in 1:length(g$x))
   g$z[i] <- max(g$x[i], g$y[i])
wireframe(z ~ x * y, data = g, groups = gr,
          scales = list(arrows = FALSE),
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 30, x = -60))

###############################################

require(lattice)
g <- expand.grid(x = seq(0,1,0.05), y = seq(0,1,0.05), gr = 1:2)
for (i in 1:length(g$x))
   g$z[i] <- g$x[i] + g$y[i] - g$x[i] * g$y[i]
wireframe(z ~ x * y, data = g, groups = gr,
          scales = list(arrows = FALSE),
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 30, x = -60))

###############################################

require(lattice)
g <- expand.grid(x = seq(0,1,0.05), y = seq(0,1,0.05), gr = 1:2)
for (i in 1:length(g$x))
   g$z[i] <- min(1, g$x[i] + g$y[i])
wireframe(z ~ x * y, data = g, groups = gr,
          scales = list(arrows = FALSE),
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 30, x = -60))

###############################################

require(lattice)
g <- expand.grid(x = seq(0,1,0.05), y = seq(0,1,0.05), gr = 1:2)
for (i in 1:length(g$x)) {
   if (g$y[i] == 0.0)
      g$z[i] <- g$x[i]
   else if (g$x[i] == 0.0)
      g$z[i] <- g$y[i]
   else
      g$z[i] <- 1
}
wireframe(z ~ x * y, data = g, groups = gr,
          scales = list(arrows = FALSE),
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 30, x = -60))

###############################################

require(lattice)
g <- expand.grid(x = seq(0,1,0.05), y = seq(0,1,0.05), gr = 1:2)
for (i in 1:length(g$x))
   g$z[i] <- min(g$x[i], g$y[i])
wireframe(z ~ x * y, data = g, groups = gr,
          scales = list(arrows = FALSE),
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 30, x = -60))

###############################################

require(lattice)
g <- expand.grid(x = seq(0,1,0.05), y = seq(0,1,0.05), gr = 1:2)
for (i in 1:length(g$x))
   g$z[i] <- g$x[i] * g$y[i]
wireframe(z ~ x * y, data = g, groups = gr,
          scales = list(arrows = FALSE),
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 30, x = -60))

###############################################

require(lattice)
g <- expand.grid(x = seq(0,1,0.05), y = seq(0,1,0.05), gr = 1:2)
for (i in 1:length(g$x))
   g$z[i] <- max(0, g$x[i] + g$y[i] - 1)
wireframe(z ~ x * y, data = g, groups = gr,
          scales = list(arrows = FALSE),
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 30, x = -60))

###############################################

require(lattice)
g <- expand.grid(x = seq(0,1,0.05), y = seq(0,1,0.05), gr = 1:2)
for (i in 1:length(g$x)) {
   if (g$y[i] == 1.0)
      g$z[i] <- g$x[i]
   else if (g$x[i] == 1.0)
      g$z[i] <- g$y[i]
   else
      g$z[i] <- 0
}
wireframe(z ~ x * y, data = g, groups = gr,
          scales = list(arrows = FALSE),
          drape = TRUE, colorkey = TRUE,
          screen = list(z = 30, x = -60))
