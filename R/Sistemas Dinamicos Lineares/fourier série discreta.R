rm(list = ls())
gc()

source("V:\\sem backup\\_4 anal sist dinamicos lineares\\lista 1\\util.R")

########## SÉRIE DE FOURIER DISCRETA

Reduce[exp(i*pi*x) = -1, Integers]

##########################

N = T0 = 2*pi/omega0

x(n) = sum k = 1 to N, a(k) exp(j * k * omega0 * n)

ou translada de k .. k + N
com a(k) = a(k + N)

# a(k) = 1/T0 * sum n=1 to T0, x[n] * exp(-i*k*w*n)

##########################

Linearidade

1) z(n) = A x(n) + B y(n)
   c_k = A a_k + B b_k

Deslocamento no tempo

2) y(n) = x(n - n0)
   b_k = exp(- j * k * omega0 * n0) * a_k

Deslocamento na frequência

3) y(n) = exp(j*M*omega0*n)
   b_k = a_[k - M]

Conjugação

4) y(n) = conjugate(x(n))
   b_k = conjugate(a(-k))

Reflexão no tempo

5) y(n) = x(-n)
   b_k = a(-k)

Escalonamento

6) y(n) = x(n/m), se n for múltiplo de m > 0
   y(n) = 0,      se n não for múltiplo de m
   b_k = 1/m * a_k
   omega1 = omega0/m
   T1 = 2*pi/omega1 = 2*pi/omega0*m = T0 * m

Convolução

7) z(t) = x(n) ** y(n) = sum k=-infty to infty, x[k] y[n - k]
   c_k = T0 * a_k b_k

Multiplicação / Modulação

8) z(n) = x(n) y(n)
   c_k = a_k ** b_k = sum L=1 to T0, a[L] b[k - L]

Diferença no tempo

9) y(n) = x(n) - x(n - 1)
   b_k = (1 - exp(-j*k*omega0)) * a_k

Diferenciação na frequência

10) \emptyset

Soma

11) y(n) = sum k = -infty to n, x(k)
    b_k = 1/(1 - exp(-j*k*omega0)) * a_k

Sinais reais e pares

12) x(n) real e par
    a_k real e par

Sinais reais e ímpares

13) x(n) real e ímpar
    a_k puramente imaginário e ímpar

Relações de Parseval

14) 1/T0 * sum n = 1 to T0, abs(x(n))^2 = sum k = 1 to T0, abs(a(k))^2

Dualidade

15) \emptyset

##########################

1)

x(n) = sin(4*pi/21*n) + cos(10*pi/21*n)

N = 21

x(n) = sum 1 .. 21: a(k) exp(j * k * 2*pi/21 * n)

# a(k) = 1/21 * sum n=1 to 21, (sin(4*pi/21*n) + cos(10*pi/21*n)) * exp(-i*k*2*pi/21*n)

##########################

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

for (n in -10:10) {
   y <- x(n) - recoverx(n, 21, x)
   if (abs(y) < 1e-9)
      y <- 0
   print(paste(n, " ", y))
}

##########################

2)

x(n) = sum k = 1 to T0, (1 + cos(pi/2*k)) exp(j * k * w * n)

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

# Reduce[e^((i pi n)/2) + e^((3 i pi n)/2) + 2 e^(2 i pi n) == 4*cos(pi/4*n)^2, n, Integers]

##########################

3)

x(n) = sum k = 1 to 24, a(k) exp(j * k * w * n)

x <- function(n) {
   return(1 + sin(pi/12 * n + 3*pi/8))
}

for (k in 0:24)
   if (abs(a(k,24, x)) > 1e-9)
      print(paste(k, " ", a(k,24, x)))

for (n in -24:24) {
   y <- x(n) - recoverx(n, 24, x)
   if (abs(y) < 1e-9)
      y <- 0
   print(paste(n, " ", y))
}

print(a(1,24,x) - exp(j*3*pi/8)/2/j)
print(a(-1,24,x) + exp(-j*3*pi/8)/2/j)
print(a(0,24,x) - 1)

##########################

4)

x(n) = - exp(-i*3*pi/8)/2/i* exp(-i * 2*pi/24 * n) + 1 + exp(i*3*pi/8)/2/i * exp(i * 2*pi/24 * n)
     = cos(pi/8 - (pi n)/12) + 1

##########################

2)

x(n) = sum k = 4 to 12, a(k) exp(j * k * 2 * pi/9 * n)

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

for (n in -10:10) {
   z <- x(n)
   if (abs(z) < 1e-9)
      z <- 0
   print(paste(n, " ", z))
}

##########################

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

for (k in 0:4)
   if (abs(a(k,4, x)) > 1e-9)
      print(paste(k, " ", a(k,4, x)))

for (n in -10:10) {
   y <- x(n) - recoverx(n, 4, x)
   if (abs(y) < 1e-9)
      y <- 0
   print(paste(n, " ", y))
}

##########################

1a) x(n) = sin(2 pi n/7 + pi/6) + exp(i pi n/5)

    T0 = 70
    a(7) = 1
    a(10) = 0.25 - 0.433013 i
    a(60) = conjugate(a(10))

x <- function(n) {
   return(sin(2*pi*n/7 + pi/6) + exp(j*pi*n/5))
}

for (k in 0:70)
   if (abs(a(k, 70, x)) > 1e-9)
      print(paste(k, " ", a(k, 70, x)))

for (n in -70:70) {
   y <- x(n) - recoverx(n, 70, x)
   if (abs(y) < 1e-9)
      y <- 0
   print(paste(n, " ", y))
}

1b) x(n) = cos^2(pi n/5)

    T0 = 10
    a(-2) = 0.25
    a(0) = 0.5
    a(2) = 0.25

x <- function(n) {
   return(cos(pi*n/5)^2)
}

for (k in 0:10)
   if (abs(a(k, 10, x)) > 1e-9)
      print(paste(k, " ", a(k, 10, x)))

for (n in -10:10) {
   y <- x(n) - recoverx(n, 10, x)
   if (abs(y) < 1e-9)
      y <- 0
   print(paste(n, " ", y))
}

1c) x(n) = sum k = -infty to infty, p(n - k*C)
    p(n) = - delta(n + 1) + 2 delta(n) - delta(n - 1)
    C > 2

    T0 = C
    a(k) = 1/C * (- exp(i*k*2 pi/C) + 2 - exp(-i*k*2 pi/C))
         = 4 sin^2(pi k/C)/C = (2 - 2 cos(2 pi k/C))/C

1d) x(n) = sum k = -infty to infty, q(n - k*3)
    q(n) = p(n) - p(-n)
    p(n) = 2 delta(n + 1) - delta(n) + delta(n - 1)

    - p(-n) = - 2 delta(n - 1) + delta(n) - delta(n + 1)
    q(n) = delta(n + 1) - delta(n - 1)
    T0 = 3
    a(k) = 1/3 * (exp(i*k*2 pi/3) - exp(-i*k*2 pi/3))
         = 2/3 i sin(2 pi k/3)
    a(1) = i/sqrt(3)
    a(2) = -a(1)

x <- function(n) {
   n <- n %% 3
   return(delta(n - 2) - delta(n - 1))
}

dev.off()
grafico_discreto(x, -10, 10, -1.1, 1.1, 'blue')

for (k in 0:4)
   if (abs(a(k, 3, x)) > 1e-9)
      print(paste(k, " ", a(k, 3, x)))

for (n in -10:10) {
   y <- x(n) - recoverx(n, 3, x)
   if (abs(y) < 1e-9)
      y <- 0
   print(paste(n, " ", y))
}

4) result = y = abs(x(0))^2 + abs(x(1))^2 + abs(x(2))^2
   T0 = 3
   a_k = 1 + cos(k * 2 pi/3)

   x(n) = sum k = 1 to 3, (1 + cos(k * 2 pi/3)) exp(i k * 2 pi/3 * n)
   x(0) = sum k = 1 to 3, (1 + cos(k * 2 pi/3)) = 3
   x(1) = sum k = 1 to 3, (1 + cos(k * 2 pi/3)) exp(i k * 2 pi/3) = 3/2
   x(2) = sum k = 1 to 3, (1 + cos(k * 2 pi/3)) exp(i k * 2 pi/3 * 2) = 3/2
   y = 9 + 9/4 + 9/4 = 27/2
