rm(list = ls())
gc()

source("V:\\sem backup\\_4 anal sist dinamicos lineares\\lista 1\\util.R")

   pp <- function(x, t) {
      return (0.5 * (x(t) + x(-t)))
   }

parte_par <- function(x, disc, Mx1, Mx2, My1, My2, color) {
   pp2 <- function(t) {
      return (0.5 * (x(t) + x(-t)))
   }

   if (disc)
      grafico_discreto(pp2, Mx1, Mx2, My1, My2, color)
   else
      grafico(pp2, Mx1, Mx2, My1, My2, color, 1000)
}

pi1 <- function(x, t) {
   return (0.5 * (x(t) - x(-t)))
}

parte_impar <- function(x, disc, Mx1, Mx2, My1, My2, color) {
   pi2 <- function(t) {
      return (0.5 * (x(t) - x(-t)))
	 }

   if (disc)
      grafico_discreto(pi2, Mx1, Mx2, My1, My2, color)
   else
      grafico(pi2, Mx1, Mx2, My1, My2, color, 1000)
}

##########################

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

dev.off()
grafico_discreto(ex13a, -10, 10, -2, 2, 'blue')
dev.off()
parte_par(ex13a, T, -10, 10, -2, 2, 'blue')
dev.off()
parte_impar(ex13a, T, -10, 10, -2, 2, 'blue')

dev.off()
grafico_discreto(ex13b, -10, 10, -1, 3.1, 'blue')
dev.off()
parte_par(ex13b, T, -10, 10,  -1, 3.1, 'blue')
dev.off()
parte_impar(ex13b, T, -10, 10,  -1, 3.1, 'blue')

pp(ex13a, 1)
pi1(ex13a, 1)

pp(ex13b, 1)
pi1(ex13b, 1)

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

dev.off()
grafico(ex25a, -10, 10, -2, 2, 'blue', 1000)
dev.off()
parte_par(ex25a, F, -10, 10, -2, 2, 'blue')
dev.off()
parte_impar(ex25a, F, -10, 10, -2, 2, 'blue')

dev.off()
grafico(ex25b, -10, 10, -2, 20, 'blue', 1000)
dev.off()
parte_par(ex25b, F, -10, 10, -2, 20, 'blue')
dev.off()
parte_impar(ex25b, F, -10, 10, -20, 20, 'blue')

dev.off()
grafico(ex25c, -10, 10, -200, 200, 'blue', 1000)
dev.off()
parte_par(ex25c, F, -10, 10, -200, 200, 'blue')
dev.off()
parte_impar(ex25c, F, -10, 10, -200, 200, 'blue')

dev.off()
grafico(ex25d, -10, 10, -200, 200, 'blue', 1000)
dev.off()
parte_par(ex25d, F, -10, 10, -2, 2, 'blue')
dev.off()
parte_impar(ex25d, F, -10, 10, -200, 200, 'blue')

pp(ex25a, 1)
pi1(ex25a, 1)

pp(ex25b, 1)
pi1(ex25b, 1)

pp(ex25c, 1)
pi1(ex25c, 1)

pp(ex25d, 1)
pi1(ex25d, 1)

