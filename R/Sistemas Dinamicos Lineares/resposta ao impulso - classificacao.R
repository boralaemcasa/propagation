rm(list = ls())
gc()

source("V:\\sem backup\\_4 anal sist dinamicos lineares\\lista 1\\util.R")

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

f <- function(n) {
   return(resposta_discreta(ex9a, n, 1000))
}
G <- function(n) {
   return(resposta_discreta_invtempo(ex9a, n, 1000))
}
H <- function(n) {
   return(linear_discreta(ex9a, n, 1000))
}
dev.off()
grafico_discreto(H, -5, 20, -2, 2, 'blue')
dev.off()
grafico_discreto(f, -5, 20, -2, 20, 'blue')
grafico_discreto(G, -5, 20, -2, 20, 'green')
bibo_discreto(f, 1000)

# sum (n - k) * delta(k) * step(n - k), k=-infty to infinity

resposta_discreta(ex9a, 2, 1000)

f <- function(n) {
   return(resposta_discreta(ex9b, n, 1000))
}
G <- function(n) {
   return(resposta_discreta_invtempo(ex9b, n, 1000))
}
H <- function(n) {
   return(linear_discreta(ex9b, n, 1000))
}
dev.off()
grafico_discreto(H, -5, 20, -2, 2, 'blue')
dev.off()
grafico_discreto(f, -5, 20, -2, 20, 'blue')
grafico_discreto(G, -5, 20, -2, 20, 'green')
bibo_discreto(f, 1000)

resposta_discreta(ex9b, 2, 1000)

g <- function(tau, t, x) {
   return (x(tau) * exp(- t + tau) * u(t - tau))
}

ex9c <- function(t, x) {
  return(impropria_param3(g, t, x))
}

f <- function(t) {
   return(resposta(ex9c, t))
}
G <- function(t) {
   return(resposta_invtempo(ex9c, t))
}
H <- function(t) {
   return(linear(ex9c, t))
}
dev.off()
grafico(H, -5, 20, -0.1, 0.2, 'blue', 1000)
dev.off()
grafico(f, -5, 20, -0.1, 0.2, 'blue', 1000)
grafico(G, -5, 20, -0.1, 0.2, 'green', 1000)

bibo(f)

resposta(ex9c, 2)
impropria_param3(g, 2, delta)
g(2, 3, delta)

A é causal? Sim
B é causal? Sim
C é causal? Sim

##################################################

ex10a <- function(t, x) {
   return (exp(-abs(t)) * x(t))
}

f <- function(t) {
   return(resposta(ex10a, t))
}
G <- function(t) {
   return(resposta_invtempo(ex10a, t))
}
H <- function(t) {
   return(linear(ex10a, t))
}
dev.off()
grafico(H, -7, 7, -2, 2, 'blue', 1000)
dev.off()
grafico(f, -1, 7, -2, 2, 'blue', 1000)
grafico(G, -1, 7, -2, 2, 'green', 1000)

bibo(f)

resposta(ex10a, 2)

ex10b <- function(t, x) {
   return (cos(3*t) * x(t)^2)
}

f <- function(t) {
   return(resposta(ex10b, t))
}
G <- function(t) {
   return(resposta_invtempo(ex10b, t))
}
H <- function(t) {
   return(linear(ex10b, t))
}
dev.off()
grafico(H, -5, 7, -2, 2, 'blue', 1000)
dev.off()
grafico(f, -5, 7, -2, 2, 'blue', 1000)
grafico(G, -5, 7, -2, 2, 'green', 1000)
bibo(f)

resposta(ex10b, 2)

ex10c <- function(t, x) {
   if (t >= 0)
      return (x(t) + x(t - 3))
   return (0)
}

f <- function(t) {
   return(resposta(ex10c, t))
}
G <- function(t) {
   return(resposta_invtempo(ex10c, t))
}
H <- function(t) {
   return(linear(ex10c, t))
}
dev.off()
grafico(H, -5, 7, -0.2, 2, 'blue', 1000)
dev.off()
grafico(f, -5, 7, -0.2, 2, 'blue', 1000)
grafico(G, -5, 7, -0.2, 2, 'green', 1000)
bibo(f)

resposta(ex10c, 2)

ex10d <- function(t, x) {
   return(impropria_lim2(x, 2*t))
}

f <- function(t) {
   return(resposta(ex10d, t))
}
G <- function(t) {
   return(resposta_invtempo(ex10d, t))
}
H <- function(t) {
   return(linear(ex10d, t))
}
dev.off()
grafico(H, -5, 7, -0.2, 0.5, 'blue', 1000)
dev.off()
grafico(f, -5, 7, -0.2, 0.5, 'blue', 1000)
grafico(G, -5, 7, -0.2, 0.5, 'green', 1000)
bibo(f)

resposta(ex10d, 2)

DELTA_WIDTH <- 0.01

ex10e <- function(t, x) {
   return (x(t/4))
}

f <- function(t) {
   return(resposta(ex10e, t))
}
G <- function(t) {
   return(resposta_invtempo(ex10e, t))
}
H <- function(t) {
   return(linear(ex10e, t))
}
dev.off()
grafico(H, -10, 10, -0.2, 2, 'blue', 1000)
dev.off()
grafico(f, -10, 10, -0.2, 2, 'blue', 1000)
grafico(G, -10, 10, -0.2, 2, 'green', 1000)
bibo(f)

DELTA_WIDTH <- 0.1

resposta(ex10e, 2)

ex10k <- function(t, x) {
   return (exp(-abs(t)) * x(t))
}

f <- function(t) {
   return(resposta(ex10k, t))
}
G <- function(t) {
   return(resposta_invtempo(ex10k, t))
}
H <- function(t) {
   return(linear(ex10k, t))
}
dev.off()
grafico(H, -10, 10, -0.2, 2, 'blue', 1000)
dev.off()
grafico(f, -10, 10, -0.2, 2, 'blue', 1000)
grafico(G, -10, 10, -0.2, 2, 'green', 1000)
bibo(f)

resposta(ex10k, 2)

g <- function(tau, t, x) {
   return (tau * u(tau) * x(t - tau))
}

ex10L <- function(t, x) {
  return(impropria_param3(g, t, x))
}

f <- function(t) {
   return(resposta(ex10L, t))
}
G <- function(t) {
   return(resposta_invtempo(ex10L, t))
}
H <- function(t) {
   return(linear(ex10L, t))
}
dev.off()
grafico(H, -1, 10, -0.2, 2, 'blue', 1000)
dev.off()
grafico(f, -1, 10, -0.2, 2, 'blue', 1000)
grafico(G, -1, 10, -0.2, 2, 'green', 1000)
bibo(f)

resposta(ex10L, 2)

A é causal? Sim
A tem memória? Sim

B é causal? Sim
B tem memória? Nao

C é causal? Sim
C tem memória? Sim

D é causal? Sim
D tem memória? Sim

E é causal? Sim
E tem memória? Nao

K é causal? Sim
K tem memória? Nao

L é causal? Sim
L tem memória? Sim

ex10f <- function(n, x, infty) {
   return (x(-n))
}

f <- function(n) {
   return(resposta_discreta(ex10f, n, 1000))
}
G <- function(n) {
   return(resposta_discreta_invtempo(ex10f, n, 1000))
}
H <- function(n) {
   return(linear_discreta(ex10f, n, 1000))
}
dev.off()
grafico_discreto(H, -10, 10, -2, 2, 'blue')
dev.off()
grafico_discreto(f, -10, 10, -2, 2, 'blue')
grafico_discreto(G, -10, 10, -2, 2, 'green')
bibo_discreto(f, 1000)

resposta_discreta(ex10f, 2, 1000)

ex10g <- function(n, x, infty) {
   return (x(n - 3) - 2*x(n - 8))
}

f <- function(n) {
   return(resposta_discreta(ex10g, n, 1000))
}
G <- function(n) {
   return(resposta_discreta_invtempo(ex10g, n, 1000))
}
H <- function(n) {
   return(linear_discreta(ex10g, n, 1000))
}
dev.off()
grafico_discreto(H, -10, 20, -2, 2, 'blue')
dev.off()
grafico_discreto(f, -10, 20, -2.5, 2, 'blue')
grafico_discreto(G, -10, 20, -2.5, 2, 'green')
bibo_discreto(f, 1000)

resposta_discreta(ex10g, 2, 1000)

ex10h <- function(n, x, infty) {
   return (n^2 * x(n))
}

f <- function(n) {
   return(resposta_discreta(ex10h, n, 1000))
}
G <- function(n) {
   return(resposta_discreta_invtempo(ex10h, n, 1000))
}
H <- function(n) {
   return(linear_discreta(ex10h, n, 1000))
}
dev.off()
grafico_discreto(H, -10, 10, -2, 2, 'blue')
dev.off()
grafico_discreto(f, -10, 10, -2, 2, 'blue')
grafico_discreto(G, -10, 10, -2, 2, 'green')
bibo_discreto(f, 1000)

resposta_discreta(ex10h, 2, 1000)

ex10i <- function(n, x, infty) {
   return (sin(x(n)))
}

f <- function(n) {
   return(resposta_discreta(ex10i, n, 1000))
}
G <- function(n) {
   return(resposta_discreta_invtempo(ex10i, n, 1000))
}
H <- function(n) {
   return(linear_discreta(ex10i, n, 1000))
}
dev.off()
grafico_discreto(H, -1, 3, -2, 2, 'blue')
dev.off()
grafico_discreto(f, -1, 3, -2, 2, 'blue')
grafico_discreto(G, -1, 3, -2, 2, 'green')
bibo_discreto(f, 1000)

resposta_discreta(ex10i, 2, 1000)

ex10j <- function(n, x, infty) {
   return (2^(1 - n) * x(n - 1) + 2^(-n) * x(n))
}

f <- function(n) {
   return(resposta_discreta(ex10j, n, 1000))
}
G <- function(n) {
   return(resposta_discreta_invtempo(ex10j, n, 1000))
}
H <- function(n) {
   return(linear_discreta(ex10j, n, 1000))
}
dev.off()
grafico_discreto(H, -10, 10, -2, 2, 'blue')
dev.off()
grafico_discreto(f, -10, 10, -2, 2, 'blue')
grafico_discreto(G, -10, 10, -2, 2, 'green')
bibo_discreto(f, 1000)

resposta_discreta(ex10j, 2, 1000)

F é causal? Sim
F tem memória? Nao

G é causal? Sim
G tem memória? Sim

H é causal? Sim
H tem memória? Nao

I é causal? Sim
I tem memória? Nao

J é causal? Sim
J tem memória? Sim

##################################################

ex11 <- function(n, x, infty) {
   soma <- 0
   for (k in -infty:infty) {
      termo <- x(k) * u(n - k)
      if (abs(termo) > 1e-5)
         termo <- termo * exp(-n + k)
      soma <- soma + termo
   }
   return(soma)
}

f <- function(n) {
   return(resposta_discreta(ex11, n, 1000))
}
G <- function(n) {
   return(resposta_discreta_invtempo(ex11, n, 1000))
}
dev.off()
grafico_discreto(f, -10, 10, -0.2, 1.2, 'blue')
grafico_discreto(G, -10, 10, -0.2, 1.2, 'green')
bibo_discreto(f, 1000)

J é causal? Sim

##################################################

g <- function(tau, t, x) {
   return ((t - tau) * x(tau))
}

ex18 <- function(t, x) {
   return (integrar_param3(t - 1, t + 1, g, 0.01, t, x))
}

#resposta(ex18, 2)

h <- function(t) {
   return (resposta(ex18, t))
}
G <- function(t) {
   return(resposta_invtempo(ex18, t))
}
H <- function(t) {
   return(linear(ex18, t))
}
dev.off()
grafico(H, -7, 7, -0.2, 0.2, 'blue', 1000)
dev.off()
grafico(h, -7, 7, -0.2, 0.2, 'blue', 1000)
grafico(G, -7, 7, -0.2, 0.2, 'green', 1000)
bibo(h)

h é causal? Nao

x1 <- function(t) {
   return (delta(t) - delta(t - 1))
}

x2 <- function(t) {
   return (u(t) - u(t - 1))
}

h1 <- function(t) {
   return (convolution(x1, h, t))
}

h2 <- function(t) {
   return (convolution(x2, h, t))
}

dev.off()
grafico(x1, -10, 10, -1.5, 1.5, 'blue', 1000)
grafico(h, -10, 10, -1.5, 1.5, 'green', 1000)
dev.off()
grafico(h1, -4, 4, -0.08, 0.08, 'blue', 250)

dev.off()
grafico(x2, -10, 10, -1.5, 1.5, 'blue', 1000)
grafico(h, -10, 10, -1.5, 1.5, 'green', 1000)
dev.off()
grafico(h2, -4, 4, -0.15, 0.15, 'blue', 250)

##################################################

g <- function(tau, t, x) {
   return (exp(- t - tau) * x(tau - 2))
}

ex20 <- function(t, x) {
   return (impropria_lim2_param3(g, t, t, x))
}

f <- function(t) {
   return (resposta(ex20, t))
}
dev.off()
grafico(f, -10, 10, -1.5, 1.5, 'blue', 1000)

resposta(ex20, 2)


