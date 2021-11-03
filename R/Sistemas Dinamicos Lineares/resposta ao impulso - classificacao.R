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

ex9a <- function(n, x, infty) { # forall x
   soma <- 0
   for (k in -infty:infty)
      soma <- soma + (n - k) * x(k) * u(n - k)
   return (soma)
}

ex9b <- function(n, x, infty) { # forall x
   soma <- 0
   for (k in -infty:infty)
      soma <- soma + (k - 1) * x(n - k) * u(k - 1)
   return (soma)
}

resposta_discreta(ex9a, 2, 1000)
resposta_discreta(ex9b, 2, 1000)

g <- function(tau, t, x) {
   return (x(tau) * exp(- t + tau) * u(t - tau))
}

ex9c <- function(t, x) {
  return(impropria_param3(g, t, x))
}

resposta(ex9c, 2)

A é linear?
A é invariante no tempo?
A é causal?
A é bibo estável?

B é linear?
B é invariante no tempo?
B é causal?
B é bibo estável?

C é linear?
C é invariante no tempo?
C é causal?
C é bibo estável?

##################################################

ex10a <- function(t, x) {
   return (x(t - 3) + x(2 - t))
}

resposta(ex10a, 2)

ex10b <- function(t, x) {
   return (cos(3*t) * x(t)^2)
}

resposta(ex10b, 2)

ex10c <- function(t, x) {
   if (t >= 0)
      return (x(t) + x(t - 3))
   return (0)
}

resposta(ex10c, 2)

ex10d <- function(t, x) {
   return(impropria_lim2(x, 2*t))
}

resposta(ex10d, 2)

ex10e <- function(t, x) {
   return (x(t/4))
}

resposta(ex10e, 2)

ex10k <- function(t, x) {
   return (exp(-abs(t)) * x(t))
}

resposta(ex10k, 2)

g <- function(tau, t, x) {
   return (tau * u(tau) * x(t - tau))
}

ex10L <- function(t, x) {
  return(impropria_param3(g, t, x))
}

resposta(ex10L, 2)

A é linear?
A é causal?
A é invariante no tempo?
A tem memória?
A é bibo estável?

B é linear?
B é causal?
B é invariante no tempo?
B tem memória?
B é bibo estável?

C é linear?
C é causal?
C é invariante no tempo?
C tem memória?
C é bibo estável?

D é linear?
D é causal?
D é invariante no tempo?
D tem memória?
D é bibo estável?

E é linear?
E é causal?
E é invariante no tempo?
E tem memória?
E é bibo estável?

K é linear?
K é causal?
K é invariante no tempo?
K tem memória?
K é bibo estável?

L é linear?
L é causal?
L é invariante no tempo?
L tem memória?
L é bibo estável?

ex10f <- function(n, x, infty) {
   return (x(-n))
}

resposta_discreta(ex10f, 2, 1000)

ex10g <- function(n, x, infty) {
   return (x(n - 3) - 2*x(n - 8))
}

resposta_discreta(ex10g, 2, 1000)

ex10h <- function(n, x, infty) {
   return (n^2 * x(n))
}

resposta_discreta(ex10h, 2, 1000)

ex10i <- function(n, x, infty) {
   return (sin(x(n)))
}

resposta_discreta(ex10i, 2, 1000)

ex10j <- function(n, x, infty) {
   return (2^(1 - n) * x(n - 1) + 2^(-n) * x(n))
}

resposta_discreta(ex10j, 2, 1000)

F é linear?
F é causal?
F é invariante no tempo?
F tem memória?
F é bibo estável?

G é linear?
G é causal?
G é invariante no tempo?
G tem memória?
G é bibo estável?

H é linear?
H é causal?
H é invariante no tempo?
H tem memória?
H é bibo estável?

I é linear?
I é causal?
I é invariante no tempo?
I tem memória?
I é bibo estável?

J é linear?
J é causal?
J é invariante no tempo?
J tem memória?
J é bibo estável?

##################################################

ex11 <- function(n, x, infty) {
   soma <- 0
   for (k in -infty:infty)
      soma <- soma + x(k) * exp(-n + k) * u(n - k)
   return(soma)
}

resposta_discreta(ex11, 2, 700)

J é causal?
J é bibo estável?

##################################################

f <- function(tau, t, x) {
   return ((t - tau) * x(tau))
}

ex18 <- function(t, x) {
   return (integrar_param3(t - 1, t + 1, f, 0.01, t, x))
}

resposta(ex18, 2)

h <- function(t) {
   return (resposta(ex18, t))
}

h é linear?
h é invariante no tempo?
h é causal?

x1 <- function(t) {
   return (delta(t) - delta(t - 1))
}

x2 <- function(t) {
   return (u(t) - u(t - 1))
}

t <- 1

    x[i] <- t
    y[i] <- x1(t)
    z[i] <- h(t)
    w[i] <- convolution(x1, h, t)

    x[i] <- t
    y[i] <- x2(t)
    z[i] <- h(t)
    w[i] <- convolution(x2, h, t)

##################################################

g <- function(tau, t, x) {
   return (exp(- t - tau) * x(tau - 2))
}

ex20 <- function(t, x) {
   return (impropria_lim2_param3(g, t, t, x))
}

resposta(ex20, 2)


