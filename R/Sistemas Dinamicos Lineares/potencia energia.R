hum <- function(t) {
   return (1)
}

potencia <- function(f, infty) {
   g <- function(t) {
      return (abs(f(t)))
   }
   return (1/(2*infty) * convolution(hum, g, 0))
}

potencia_discreta <- function(f, infty) {
  soma <- 0
  for (i in -infty:infty)
     soma <- soma + abs(f(i))
  return (1/(2*infty + 1) * soma)
}

energia <- function(f, infty) {
   h <- function(t) {
      return (abs(f(t))^2)
   }
   return (convolution(hum, h, 0))
}

energia_discreta <- function(f, infty) {
  soma <- 0
  for (i in -infty:infty)
     soma <- soma + abs(f(i))^2
  return (soma)
}

ex1a <- function(t) {
   return (exp(-2*t)*u(t))
}

j <- complex(imaginary = 1)

ex1b <- function(t) {
   return (exp(j * (2*t + pi/4)))
}

ex1c <- function(t) {
   return (cos(t))
}

potencia(ex1a, 1000)
potencia(ex1b, 1000)
potencia(ex1c, 1000)

energia(ex1a, 1000)
energia(ex1b, 1000)
energia(ex1c, 1000)

ex1d <- function(t) {
   return (0.5^t * u(t))
}

ex1e <- function(t) {
   return (exp(j * (pi/2*t + pi/8)))
}

ex1f <- function(t) {
   return (cos(pi/4*t))
}

potencia_discreta(ex1d, 1000)
potencia_discreta(ex1e, 1000)
potencia_discreta(ex1f, 1000)

energia_discreta(ex1d, 1000)
energia_discreta(ex1e, 1000)
energia_discreta(ex1f, 1000)

ex5 <- function(t) {
   if (t > 0)
      return (6*exp(-t/2))
   if (t >= 1)
      return (6)
   return (0)
}

potencia(ex5, 1000)
energia(ex5, 1000)

