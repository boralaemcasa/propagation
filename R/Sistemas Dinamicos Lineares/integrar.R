DX <- 0.01

derivative <- function(f, x, h) {
   return ((f(x + h) - f(x))/h)
}
                
integrar <- function(x1, x2, f, dx) {
   t <- x1 + dx
   soma <- 0
   while (t <= x2) {
      soma <- soma + f(t) * dx
      t <- t + dx
   }
   return (soma)
}

integrar_param3 <- function(x1, x2, f, dx, param2, param3) {
   t <- x1 + dx
   soma <- 0
   while (t <= x2) {
      soma <- soma + f(t, param2, param3) * dx
      t <- t + dx
   }
   return (soma)
}

impropria_lim2 <- function(g, lim2) {
   x <- 0
   n <- 1
   a <- 1   
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
      if (hh <= lim2)
         soma <- soma + prod * g(hh)

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

impropria_lim2_param3 <- function(g, lim2, param2, param3) {
   x <- 0
   n <- 1
   a <- 1   
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
      if (hh <= lim2)
         soma <- soma + prod * g(hh, param2, param3)

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

impropria_param3 <- function(g, param2, param3) {
   x <- 0
   n <- 1
   a <- 1   
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
      soma <- soma + prod * g(hh, param2, param3)

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

u <- function(t) {
   if (t >= 0)
      return (1)
   return (0)
}

delta <- function(t) {
   if (abs(t) < 1e-9)
      return (1)
   return (0)
}

