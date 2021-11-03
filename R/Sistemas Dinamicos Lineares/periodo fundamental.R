periodo <- function(f) {
   return (f(2))
}

periodo_discreto <- function(f) {
   return (f(2))
}

ex26 <- function(nn) {
   # 0123 |-> 1
   # 4567 |-> -1
   n <- nn %% 8
   if (n <= 3)
      return (1)
   return (-1)
}

periodo_discreto(ex26)

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

periodo(ex27a)
periodo(ex27b)
periodo(ex27c)

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

periodo_discreto(ex27d)
periodo_discreto(ex27e)
periodo_discreto(ex27f)
periodo_discreto(ex27g)

