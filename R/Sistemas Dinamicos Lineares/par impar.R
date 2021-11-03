parte_par <- function(x, t) {
   return (0.5 * (x(t) + x(-t)))
}

parte_impar <- function(x, t) {
   return (0.5 * (x(t) - x(-t)))
}

ex13a <- function(n) {
   if (n >= 0)
      return(1)
   return(-1)
}

ex13b <- function(n) {
   if (n == -2)
      return(1)
   if (n == -1)
      return(2)
   if (n == 0)
      return(3)
   if (n == 7)
      return(1)
   return(0)
}

    x[i] <- t
    y[i] <- ex13a(t)
    z1[i] <- parte_par(ex13a, t)
    z2[i] <- parte_impar(ex13a, t)
    plot z1
    plot z2

    x[i] <- t
    y[i] <- ex13b(t)
    z1[i] <- parte_par(ex13b, t)
    z2[i] <- parte_impar(ex13b, t)
    plot z1
    plot z2

parte_par(ex13a, 1)
parte_impar(ex13a, 1)

parte_par(ex13b, 1)
parte_impar(ex13b, 1)

################################

ex25a <- function(t) {
   return (cos(t) + sin(t) + sin(t)*cos(t))
}

ex25b <- function(t) {
   return (1 + t + 3*t*t + 5*t^3 + 9*t^4)
}

ex25c <- function(t) {
   return (1 + t*cos(t) + t*t*sin(t) + t^3 * sin(t) * cos(t))
}

ex25d <- function(t) {
   return ((1 + t^3) * cos(10*t)^3)
}

    x[i] <- t
    y[i] <- ex25a(t)
    z1[i] <- parte_par(ex25a, t)
    z2[i] <- parte_impar(ex25a, t)
    plot z1
    plot z2

    x[i] <- t
    y[i] <- ex25b(t)
    z1[i] <- parte_par(ex25b, t)
    z2[i] <- parte_impar(ex25b, t)
    plot z1
    plot z2

    x[i] <- t
    y[i] <- ex25c(t)
    z1[i] <- parte_par(ex25c, t)
    z2[i] <- parte_impar(ex25c, t)
    plot z1
    plot z2

    x[i] <- t
    y[i] <- ex25d(t)
    z1[i] <- parte_par(ex25d, t)
    z2[i] <- parte_impar(ex25d, t)
    plot z1
    plot z2

parte_par(ex25a, 1)
parte_impar(ex25a, 1)

parte_par(ex25b, 1)
parte_impar(ex25b, 1)

parte_par(ex25c, 1)
parte_impar(ex25c, 1)

parte_par(ex25d, 1)
parte_impar(ex25d, 1)

