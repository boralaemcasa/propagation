j <- complex(imaginary = 1)
DX <- 0.01

derivative <- function(f, x, h) {
   return ((f(x + h) - f(x))/h)
}
                
# integral do delta sai errada

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
   if (t >= -0.1)
      return (1)
   return (0)
}

DELTA_WIDTH <- 0.1

delta <- function(t) {
   if (abs(t) < DELTA_WIDTH)
      return (1)
   return (0)
}

delta2 <- function(t) {
   return (delta(t - 2))
}

grafico_discreto <- function(f, Mx1, Mx2, My1, My2, color) {
 N <- Mx2 - Mx1
 x <- matrix(0, N)
 y <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = Mx1
    t <- i + Mx1 - 1
    x[i] <- t
    y[i] <- f(t)
    plotar(x[i], y[i], Mx1, Mx2, My1, My2, color)
 }
}

grafico <- function(f, Mx1, Mx2, My1, My2, color, N) {
 x <- matrix(0, N)
 y <- matrix(0, N)
 for (i in 1:N) {
    # t(1) = Mx1, t(N) = Mx2
    t <- (Mx2 - Mx1)/(N - 1) * (i - 1) + Mx1 
    x[i] <- t
    y[i] <- f(t)
 }
 plot(x,y,type = 'l',col=color,xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
 par(new=T)
}

hum <- function(t) {
   return (1)
}

impropria <- function(g) {
   return(convolution(hum, g, 0))
}

bibo <- function(h) {
	 norma <- function(t) {
		  return(abs(h(t)))
	 }

   return(impropria(norma))
}

bibo_discreto <- function(f, infty) {
  soma <- 0
  for (i in -infty:infty)
     soma <- soma + abs(f(i))
  return (soma)
}

convolution_discrete <- function(f, g, x, infty) {
   soma <- 0
   for (k in -infty:infty) {
      soma <- soma + f(x - k) * g(k)
   }
   return (soma)
}

segmento <- function(x1, y1, x2, y2, color, p1, p2) {
 N <- 1000
 x <- matrix(0, N + 1)
 y <- matrix(0, N + 1)
 for (i in 1:(N + 1)) {
    x[i] <- x1 + (x2 - x1) * (i - 1)/N
    y[i] <- y1 + (y2 - y1) * (i - 1)/N
 }
 plot(x,y,type = 'l',col=color,xlim=p1,ylim=p2,xlab='x',ylab='y')
 par(new=T)
}

plotar <- function(x, y, Mx1, Mx2, My1, My2, color) {
   segmento(x, 0, x, y, color, c(Mx1,Mx2), c(My1,My2))
}

# https://twitter.com/mathspiritual/status/1371110143807610883 
convolution <- function(f, g, x) {
   return (convolution_matrix(f, g, x, 1, 1)) # de R em R, dx = 0.01
}

# n <- dim Dom ; a <- dim Im
convolution_matrix <- function(f, g, x, n, a) { 
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
      ff <- f(x - hh)
      soma <- soma + prod * t(ff) %*% g(hh)

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

resposta_discreta <- function(y, n, infty) {
   # y = F(x)
   # return F(delta) : N -> N
   return(y(n, delta, infty))
}

resposta <- function(y, t) {
   # y = F(x)
   # return F(delta) : R -> R  
   return(y(t, delta))
}

resposta_discreta_invtempo <- function(y, n, infty) {
   # y = F(x)
   # return F(delta) : N -> N
   return(y(n, delta2, infty))
}

resposta_invtempo <- function(y, t) {
   # y = F(x)
   # return F(delta) : R -> R  
   return(y(t, delta2))
}

linear_discreta <- function(y, n, infty) {
   x1 <- function(t) {
      return(abs(sin(t)))
   }
   x2 <- function(t) {
      if (abs(t) < 0.1)
         return ((t + 1) * cos(t) + 1)
      return(cos(1/t))
   }
   x3 <- function(t) {
      return(x1(t) + x2(t))
   }
   y1 <- y(n, x1, infty) # y1 = F(x1)
   y2 <- y(n, x2, infty) # y2 = F(x2)
   y3 <- y(n, x3, infty) # y3 = F(x1 + x2) = y1 + y2
   return(y3 - y1 - y2)
}

linear <- function(y, t) {
   x1 <- function(t) {
      return(abs(sin(t)))
   }
   x2 <- function(t) {
      if (abs(t) < 0.1)
         return ((t + 1) * cos(t) + 1)
      return(cos(1/t))
   }
   x3 <- function(t) {
      return(x1(t) + x2(t))
   }
   y1 <- y(t, x1) # y1 = F(x1)
   y2 <- y(t, x2) # y2 = F(x2)
   y3 <- y(t, x3) # y3 = F(x1 + x2) = y1 + y2
   return(y3 - y1 - y2)
}

