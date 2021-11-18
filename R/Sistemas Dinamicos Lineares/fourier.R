rm(list = ls())
gc()

source("V:\\sem backup\\_4 anal sist dinamicos lineares\\lista 1\\util.R")

##########

os coeficientes da representacao em serie de Fourier dos seguintes sinais:

x(t) = sum k = -infty to infty, a(k) exp(j * k * omega0 * t)

a(k) = 1/T0 * integral(0, T0, x(t) * exp(-j*k*omega0*t) dt)

sinc(u) = sin(pi*u)/pi/u

# no wolfram alpha, sinc(x) = sin(x)/x

N = T = 2*pi/omega0

sum 1 .. N: a(k) exp(j * k * omega0 * n)

ou translada de k .. k + N
com a(k) = a(k + N)

a(k) = 1/T0 * sum(1, N, x[n] * exp(-j*k*omega0*n) )

Escalonamento

x1 = x(alpha * t) = sum k = -infty to infty, a(k) exp(j * k * (alpha * omega0) * t)
omega1 = alpha * omega0
T1 = 2*pi/omega1 = 2*pi/alpha/omega0 = T0/alpha
a(k) é o mesmo

# a(k) = 1/T0 * integrate x(t) * exp(-i*k*w*t) dt from 0 to T0

# a(k) = 1/N * sum x[n] * exp(-i*k*w*n), n=1 to N

DISCRETO

1)

x(n) = sin(4*pi/21*n) + cos(10*pi/21*n)

N = 21

x(n) = sum 1 .. 21: a(k) exp(j * k * 2*pi/21 * n)

# a(k) = 1/21 * sum (sin(4*pi/21*n) + cos(10*pi/21*n)) * exp(-i*k*2*pi/21*n), n=1 to 21

#########

a <- function(k, T0, x) {
   soma <- 0
   for (n in 1:T0)
      soma <- soma + 1/T0 * x(n) * exp(-j*k*2*pi/T0*n)
   return(soma)
}

recoverx <- function(n, T0, x) {
   soma <- 0
   for (k in 1:T0)
      soma <- soma + a(k, T0, x) * exp(j * k * 2*pi/T0 * n)
   return(soma)
}

x <- function(n) {
   return(sin(4*pi/21*n) + cos(10*pi/21*n))
}

for (k in -10:10)
   if (abs(a(k, 21, x)) > 1e-9)
      print(paste(k, " ", a(k, 21, x)))

for (n in -10:10)
   print(paste(n, " ", x(n) - recoverx(n, 21, x)))

######

2)

x(n) = sum 1 .. N: (1 + cos(pi/2*k)) exp(j * k * w * n)

f <- function(k) {
   return (1 + cos(pi/2*k))
}

x <- function(n) {
   soma <- 0
   for (k in 1:4)
      soma <- soma + f(k) * exp(j * k * 2*pi/4 * n)
   return(soma - 4*cos(pi/4*n)^2)
}

dev.off()
grafico_discreto(x, -10, 10, -2, 5, 'blue')

######

3)

x(n) = sum 1 .. 24: a(k) exp(j * k * w * n)

x <- function(n) {
   return(1 + sin(pi/12 * n + 3*pi/8))
}

for (k in -10:10)
   if (abs(a(k,24, x)) > 1e-9)
      print(paste(k, " ", a(k,24, x)))

for (n in -10:10)
   print(paste(n, " ", x(n) - recoverx(n, 24, x)))

print(a(1,24,x) - exp(j*3*pi/8)/2/j)
print(a(-1,24,x) + exp(-j*3*pi/8)/2/j)

######

4)

x(n) = - exp(-i*3*pi/8)/2/i* exp(-i * 2*pi/24 * n) + 1 + exp(i*3*pi/8)/2/i * exp(i * 2*pi/24 * n)
     = cos(pi/8 - (pi n)/12) + 1

######

2)

x(n) = sum 4 .. 12: a(k) exp(j * k * 2 * pi/9 * n)

mod a_k = de -5 a 3, 4 a 12
a_4 = 0 
a_5 = 0
a_6 = 1 exp(j * 2 pi/3) exp(j * 6 * 2 * pi/9 * n)
a_7 = 2 exp(j * pi/3) exp(j * 7 * 2 * pi/9 * n)
a_8 = 0
a_9 = -1 exp(j * 9 * 2 * pi/9 * n)
a_10 = 0
a_11 = 2 exp(-j * pi/3) exp(j * 11 * 2 * pi/9 * n)
a_12 = 1 exp(-j * 2 pi/3) exp(j * 12 * 2 * pi/9 * n)

x <- function(n) {
a_6 <- exp(j * 2 * pi/3)* exp(j * 6 * 2 * pi/9 * n)
a_7 <- 2 * exp(j * pi/3)* exp(j * 7 * 2 * pi/9 * n)
a_9 <- - exp(j * 9 * 2 * pi/9 * n)
a_11 <- 2* exp(-j * pi/3)* exp(j * 11 * 2 * pi/9 * n)
a_12 <- exp(-j * 2 * pi/3)* exp(j * 12 * 2 * pi/9 * n)
   return(a_6 + a_7 + a_9 + a_11 + a_12 - y(n))
}

y <- function(n) {
   return( 2*cos(6*pi*n/9 - 2*pi/3) + 4 * cos(4*pi*n/9 - pi/3) - 1 )
}

for (n in -10:10)
   print(paste(n, " ", x(n)))
   
####

x <- function(n) {
   n <- n %% 4
   if (n == 0)
      return (-1)
   if (n == 1)
      return (1)
   if (n == 2)
      return (0)
   return (2)
}

for (k in -10:10)
   if (abs(a(k,4, x)) > 1e-9)
      print(paste(k, " ", a(k,4, x)))

for (n in -10:10)
   print(paste(n, " ", x(n) - recoverx(n, 24, x)))

