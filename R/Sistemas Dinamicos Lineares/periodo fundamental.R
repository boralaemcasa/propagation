# período discreto é gráfico

ex26 <- function(nn) {
   # 0123 |-> 1
   # 4567 |-> -1
   n <- nn %% 8
   if (n <= 3)
      return (1)
   return (-1)
}

# T = 8
# omega = 2 pi / T = pi/4

############################

ex27a <- function(t) {
   return (cos(2*pi*t)^2)
}

ex27b <- function(t) {
   return (sin(2*t)^3)
}

ex27c <- function(t) {
   return (exp(-2*t) * cos(2*pi*t))
}

ex27d <- function(n) {
   return ((-1)^n)
}

ex27e <- function(n) {
   return ((-1)^(n^2))
}

ex27f <- function(n) {
   return (cos(2*n))
}

ex27g <- function(n) {
   return (cos(2*pi*n))
}

dev.off()
grafico_discreto(ex27d, -10, 10, -10, 10, 'blue')
dev.off()
grafico_discreto(ex27e, -10, 10, -10, 10, 'blue')
dev.off()
grafico_discreto(ex27f, -10, 10, -3, 3, 'blue')
dev.off()
grafico_discreto(ex27g, -10, 10, -10, 10, 'blue')


