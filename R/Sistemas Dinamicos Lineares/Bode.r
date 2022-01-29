x(t) = exp(jwt)
y(t) = exp(jwt) H(jw)
H(jw) é resposta em frequência. Tem módulo e argumento: resposta em módulo ou magnitude e fase

x(n) = exp(jwn)
y(n) = exp(jwn) H(exp(jw))
H(exp(jw)) é resposta em frequência.

Magnitude em db = 20 log abs(H(jw))

H(jw) = K
DB = constante = 20 log abs(K)
Fase = constante = 0 grau ou 180 graus

H(jw) = 1/j/w (polo)
DB = 20 log abs(1/j/w) = reta com inclinação de -20 db/dec
Fase = constante = -90 graus

H(jw) = jw (zero)
DB = 20 log abs(jw) = reta com inclinação de +20 db/dec
Fase = constante = +90 graus

H3(jw) = jw/a1 + 1
DB = zero até w = a1, reta com inclinação de +20 db/dec em w > a1
Fase = zero até w = a1/10, 45 graus em w = a1, 90 graus em w >= 10 a1

H4(jw) = 1/(jw/b1 + 1)
DB = zero até w = b1, reta com inclinação de -20 db/dec em w > b1
Fase = zero até w = b1/10, -45 graus em w = b1, -90 graus em w >= 10 b1

p. 107

Filtro passa-baixa = LPF:
H(jw) = 1 = G, se abs(w) <= w_c
H(jw) = 0, caso contrário
X_f(jw) = H(jw) X(jw)
h(t) = G w_c sin(w_c t)/pi/w_c/t = G w_c/pi sinc(w_c t/pi)

Filtro passa-faixa = BPF:
H(jw) = 1, se w_c1 <= abs(w) <= w_c2
H(jw) = 0, caso contrário

Filtro passa alta = HPF:
H(jw) = 1, se abs(w) >= w_c
H(jw) = 0, caso contrário

Amostragem com trem de impulsos
x_s(t) = x(t) delta(t)
x_s(t) delta(t - n T) = x(n T) delta(t - n T)
Sinal amostrado
x_p(t) = sum n = -infty to infty, x(n T) delta(t - n T)
p(t) = sum n = -infty to infty, delta(t - n T)
x_p(t) = x(t) p(t)
Espectro de frequência
X_p(jw) = 1/2/pi integrate X(j theta) P(jw - theta) dtheta from -infty to infty
P(jw) = 2 pi/T sum k=-infty to infty, delta(w - k w_s) ; w_s = 2 pi/T
X_p(jw) = 1/T sum k=-infty to infty, X(j(w - k w_s))
O sinal X(jw) é filtrado de -w_m <= w <= +w_m
X_p(jw) é replicado: k w_s - w_m <= w <= k w_s + w_m

Filtro ideal
multiplicar por p(t), depois por filtro passa baixa H(jw)
x_r(t) = x_p(t) ** h(t) = sum n=-infty to infty, x(n T) h(t - n T)

Não ideal: substituir h(t) por função pulso ou triangular

Seja x(t) um sinal de banda limitada com X(jw) = 0 para abs(w) > w_m.
Então x(t) é determinado unicamente por suas amostras x(n T), n \in Z
se w_s > 2 w_m
2 w_m = Taxa de Nyquist
w_s/2 = Frequência de Nyquist

p. 95

###

j <- complex(imaginary=1)

H <- function(s) {
   #return (20 * s * (s + 100)/(s + 2)/(s + 10))
   #return (1/(s + 0.1)/(s + 1)/(s + 10))
   #return ((s + 1)/(s + 0.1)/(s + 10))
   #return (0.1*(s + 1)/s/(s + 0.1)/(s + 10))
   #return (0.1*(s - 1)/s/(s + 0.1)/(s + 10))
   #return (0.5/(s + 0.5))
   #return (100/(s + 1))
   #return ((s + 20)/(s + 1)/(s + 7)/(s + 50))
   #return (1000*(s/0.1 + 1)/(s/1 + 1)/(1 + 2* s/10 + (s/10)^2))
   #return (100000*(s/0.1 + 1)/(s/0.01 + 1)/(s/100 + 1)/(1 + 2*0.2* s/1000 + (s/1000)^2))
   #return (1000/(1 + 2*0.2* s/1000 + (s/1000)^2))
   #return (1000 * (s/100 + 1)/s/(s/1 + 1)/(1 + 2* s/10 + (s/10)^2))
   #return (10*(s/100 + 1)/(s/1 + 1)/(1 + 2* s/1000 + (s/1000)^2))
   #return (100*(s/0.1 + 1)/s/(s/1 + 1)/(1 + 2* s/10 + (s/10)^2))
   #return (10*(s/100 + 1)/(s + 1)/(1 + 2*0.2* s/10 + (s/10)^2))
   #return (((s/10^2.8 + 1)/s/(s/10 + 1)/(1 + 2*0.2* s/1000 + (s/1000)^2))^(100/160))
   #return (10*(s/0.1 + 1)/(s/1 + 1)/(1 + 2*0.2* s/10 + (s/10)^2))
   #return (10/s/(1 + 2 * s/100 + (s/100)^2))
   #return (1000/(1 + 2* s/1000 + (s/1000)^2))
   #return (10*(s/100 + 1)/s/(s/1 + 1)/(1 + 2*0.2*s/1000 + (s/1000)^2)) #1
   #return (1000/(1 + 2*s/10 + (s/10)^2)) #2
   #return (1000/s/(1 + 2*s/1000 + (s/1000)^2)) #3
   #return (1000*(s/100 + 1)/s/(s/1 + 1)/(1 + 2*s/1000 + (s/1000)^2)) #4
   #return (1000*(s/100 + 1)/(s/1 + 1)/(1 + 2*0.2*s/1000 + (s/1000)^2)) #5
   #return (1000*(s/100 + 1)/s/(s/1 + 1)/(1 + 2*s/10 + (s/10)^2)) #6
   return (1000*(s/0.1 + 1)/(s/100 + 1)/(1 + 2*0.2*s/1000 + (s/1000)^2)) #7
}

H2 <- function(s) {
   return (0.5/(s + 0.5) * exp(-2*s))
}

log10 <- function(x) {
   return(log(x)/log(10))
}

xmin <- -2
xmax <- 4
z <- seq(xmin, xmax, 0.1)
w <- 10^z
x <- H(j * w)
y1 <- 20 * log10(abs(x))
y2 <- Arg(x)/pi * 180
for (i in 1:length(z))
   if (y2[i] > 0)
      y2[i] <- y2[i] - 360

ymin <- min(y1)
ymax <- max(y1)
plot(z,y1,type='l',col='blue',xlim=c(xmin,xmax),ylim = c(ymin,ymax),xlab='x',ylab='y')

ymin <- min(y2)
ymax <- max(y2)
plot(z,y2,type='l',col='blue',xlim=c(xmin,xmax),ylim = c(ymin,ymax),xlab='x',ylab='y')

x <- H2(j * w)
y1 <- 20 * log10(abs(x))
y2 <- Arg(x)/pi * 180
for (i in 1:length(z))
   if (y2[i] > 90)
      y2[i] <- y2[i] - 360

for (i in 1:length(z))
   if (y2[i] < -200)
      y2[i] <- y2[i] + 360

par(new=T)
plot(z,y2,type='l',col='red',xlim=c(xmin,xmax),ylim = c(ymin,ymax),xlab='x',ylab='y')

20 * log10(abs(H(j * 10^seq(xmin, xmax, 1))))

###

 -3, -2,    -1,     0,     1,   2,   3
 60, 40,    20,   -20,   -40, -80,-120
-20,-20,   -20,   -40,   -20, -40, -40
  0,  0,   -20,   +20,   -20,   0,

Em w = 0.1, -20 => 1/(jw/0.1 + 1)
Em w =   1, +20 => jw/1 + 1
Em w =  10, -20 => 1/(jw/10 + 1)
Na origem, 20 log H(j1) = 20 log K = -20 => K = 0.1

###

 -3, -2,    -1,     0,     1,   2,   3
 60, 40,    20,   -20,   -40, -80,-120
-20,-20,   -20,   -40,   -20, -40, -40
  0,  0,   -20,   +20,   -20,   0,

Fase não mínima = zero no semiplano direito. além disso, polo instável = todos têm derivada crescente.
Ganho = abs(H(jw))

###

Na origem, 20 log H(j1) = 20 log K = 40 => K = 100
Em w = 1, -20 => 1/(jw/1 + 1)

###

Na origem, 20 log H(j1) = 20 log K = 60 => K = 1000
Em w = 10, -20 => 1/(jw/10 + 1)
H(s) = 1000/(s/10 + 1)
x(t) = 134 u(t) => X(s) = 134/s
lim s H(s) X(s) as s->0 = 134000/(0/10 + 1) = 134000

###

Na origem, 20 log H(j1) = 20 log K = 40 => K = 100
Em w = 10, -20 => 1/(jw/10 + 1)
H(s) = 100/(s/10 + 1)
x(t) = 134 u(t) => X(s) = 134/s
lim s H(s) X(s) as s->0 = 13400/(0/10 + 1) = 13400

###

Na origem, 20 log H(j1) = 20 log K = 40 => K = 100
Em w = 1000, -20 => 1/(jw/1000 + 1)
H(s) = 100/(s/1000 + 1)

###

Na origem, 20 log H(j1) = 20 log K = 20 => K = 10
Em w = 100, -20 => 1/(jw/100 + 1)
H(s) = 10/(s/100 + 1)
x(t) = 134 u(t) => X(s) = 134/s
lim s H(s) X(s) as s->0 = 1340/(0/100 + 1) = 1340

### H(s) = Ka(s/z + 1)/s/(s/p + 1)/(s^2/w^2 + 2cs/w + 1)

-2, -1,  0,  1,  2
60, 60, 80, 80, 40
 0,  0, 20,  0,-40
 0, 20,-20,-40

-2,    -1,         0,             1
 x, x + y, x + y + z, x + y + z + w
 0,     y,         z,             w
 y, z - y,     w - z,

Na origem, 20 log H(j1) = 20 log K = 80  => K = 10000
Em w = 0.1, +20 => jw/0.1 + 1
Em w = 1,   -20 => 1/(jw/1 + 1)
Em w = 10,  -40 => 1/(1 + 2z jw/10 + (jw/10)^2)
H(s) = 10000(s/0.1 + 1)/(s/1 + 1)/(1 + 2z s/10 + (s/10)^2)
H(j) = 10000(0.01 i/0.1 + 1)/(0.01 i/1 + 1)/(1 + 2z 0.01 i/10 + (0.01 i/10)^2)
Funcionou com K/10, zeta = 1

###

 -2, -1,  0,  1,  2,  3,  4
100, 80, 80, 80, 80, 60,  0
  0,-20,  0,  0,  0,-20,-60
-20,+20,  0,  0,-20,-40,

Na origem, 20 log H(j1) = 20 log K = 80  => K = 10000
Em w = 0.01, -20 => 1/(jw/0.01 + 1)
Em w = 0.1,  +20 => jw/0.1 + 1
Em w = 100,  -20 => 1/(jw/100 + 1)
Em w = 1000, -40 => 1/(1 + 2*z* jw/1000 + (jw/1000)^2)
H(s) = 100000*(s/0.1 + 1)/(s/0.01 + 1)/(s/100 + 1)/(1 + 2*0.2* s/1000 + (s/1000)^2)
Funcionou com 10K, zeta = 0.2

###

  1,  2,  3,  4
 60, 60, 60, 20
  0,  0,  0,-40
  0,  0,-40,

Na origem, 20 log H(j1) = 20 log K = 60  => K = 1000
Em w = 1000, -40 => 1/(1 + 2*z* jw/1000 + (jw/1000)^2)
H(s) = 1000/(1 + 2*0.2* s/1000 + (s/1000)^2)
Como achar zeta?

###

 -1,  0,  1,  2,   3
 90, 50,-10,-110,-190 para encaixar
-20,-40,-60,-100, -80
-20,-20,-40, +20,

Na origem, 20 log H(j1) = 20 log K = 50 => K = 10^2.5
Em w = 0.1, -20 => 1/(jw/0.1 + 1)
Em w = 10,  -40 => 1/(1 + 2*z* jw/10 + (jw/10)^2)
Em w = 100, +20 => jw/100 + 1
H(s) = 1000 * (s/100 + 1)/s/(s/1 + 1)/(1 + 2* s/10 + (s/10)^2)

###

 -1,  0,  1,  2,   3,   4
 20, 20,  0,-20, -20, -60
  0,  0,-20,-20,   0, -40
  0,-20,  0,+20, -40,

Na origem, 20 log H(j1) = 20 log K = 20 => K = 10
Em w = 1,    -20 => 1/(jw/1 + 1)
Em w = 100,  +20 => jw/100 + 1
Em w = 1000, -40 => 1/(1 + 2*z* jw/10 + (jw/10)^2)
H(s) = 10*(s/100 + 1)/(s/1 + 1)/(1 + 2* s/1000 + (s/1000)^2)

###

 -2, -1,  0,  1,   2
 60, 40, 40, 20, -40
-20,-20,  0,-20, -60
  0,+20,-20,-40,

Na origem, 20 log H(j1) = 20 log K = 40 => K = 100
Em w = 0.1, +20 => jw/0.1 + 1
Em w = 1,   -20 => 1/(jw/1 + 1)
Em w = 10,  -40 => 1/(1 + 2*z* jw/10 + (jw/10)^2)
H(s) = 100*(s/0.1 + 1)/s/(s/1 + 1)/(1 + 2* s/10 + (s/10)^2)

###

 -1,  0,  1,  2,   3
 20, 20,  0,-60,-100
      0,-20,-60, -40
    -20,-40,+20,

Na origem, 20 log H(j1) = 20 log K = 0 => K = 1
Em w = 1,   -20 => 1/(jw/1 + 1)
Em w = 10,  -40 => 1/(1 + 2*z* jw/10 + (jw/10)^2)
Em w = 100, +20 => jw/100 + 1
H(s) = (s/100 + 1)/(s + 1)/(1 + 2*0.2* s/10 + (s/10)^2)
Funcionou com 10K

### ex12 sem gabarito

  1,  2, 2.8,   3,   4
  0,-20, -40, -40, -80
  0,-20, -20,   0, -40
-20,  0, +20, -40,

Na origem, 20 log H(j1) = 20 log K = 20 => K = 10
Em w = 10,     -20 => 1/(jw/10 + 1)
Em w = 10^2.8, +20 => jw/10^2.8 + 1
Em w = 1000,   -40 => 1/(1 + 2*z* jw/1000 + (jw/1000)^2)
H(s) = ((s/10^2.8 + 1)/s/(s/10 + 1)/(1 + 2*0.2* s/1000 + (s/1000)^2))^(100/160)

###

 -2, -1,  0,  1,   2
 20, 20, 40, 40,   0
   ,  0, 20,  0, -40
  0, 20,-20,-40,

Na origem, 20 log H(j1) = 20 log K = 40 => K = 100
Em w = 0.1, +20 => jw/0.1 + 1
Em w = 1,   -20 => 1/(jw/1 + 1)
Em w = 10,  -40 => 1/(1 + 2*z* jw/10 + (jw/10)^2)
H(s) = 10*(s/0.1 + 1)/(s/1 + 1)/(1 + 2*0.2* s/10 + (s/10)^2)
Funcionou com K/10

###

  0,   1,   2,    3
 20,   0, -60, -120
-40, -20, -60,  -60
-20, -40,   0,

Na origem, 20 log H(j1) = 20 log K = 20 => K = 10
Em w = 10,-40 => 1/(1 + 2*z* jw/10 + (jw/10)^2)
H(s) = 10/s/(1 + 2 * s/10 + (s/10)^2)

###

 1,  2,  3,  4
60, 60, 60, 20
     0,  0,-40
     0,-40,

Na origem, 20 log H(j1) = 20 log K = 60 => K = 1000
Em w = 1000,-40 => 1/(1 + 2*z* jw/1000 + (jw/1000)^2)
H(s) = 1000/(1 + 2* s/1000 + (s/1000)^2)

### Teste 21

(1) -1,   0,   1,   2,   3,    4
    40,  20, -20, -60, -80, -140
   -20, -20, -40, -40, -20,  -60
     0, -20,   0, +20, -40,

Na origem, 20 log H(j1) = 20 log K = 20 => K = 10
Em w = 1,    -20 => 1/(jw/1 + 1)
Em w = 100,  +20 => jw/100 + 1
Em w = 1000, -40 => 1/(1 + 2*z* jw/1000 + (jw/1000)^2)
H(s) = 10*(s/100 + 1)/s/(s/1 + 1)/(1 + 2*0.2*s/1000 + (s/1000)^2)

###

(2) 0,  1,  2,   3
   60, 60, 20, -20
    0,  0,-40, -40
    0,-40,  0,

Na origem, 20 log H(j1) = 20 log K = 60 => K = 1000
Em w = 10, -40 => 1/(1 + 2*z* jw/10 + (jw/10)^2)
H(s) = 1000/(1 + 2*s/10 + (s/10)^2)

###

(3) 1,  2,  3,   4
   40, 20,  0, -60
  -20,-20,-20, -60
    0,  0,-40,

Na origem, 20 log H(j1) = 20 log K = 60 => K = 1000
Em w = 1000, -40 => 1/(1 + 2*z* jw/1000 + (jw/1000)^2)
H(s) = 1000/s/(1 + 2*s/1000 + (s/1000)^2)

###

(4) -1,  0,  1,   2,   3,    4
    80, 60, 20, -20, -40, -100
   -20,-20,-40, -40, -20,  -60
     0,-20,  0, +20, -40,

Na origem, 20 log H(j1) = 20 log K = 60 => K = 1000
Em w = 1,    -20 => 1/(jw/1 + 1)
Em w = 100,  +20 => jw/100 + 1
Em w = 1000, -40 => 1/(1 + 2*z* jw/1000 + (jw/1000)^2)
H(s) = 1000*(s/100 + 1)/s/(s/1 + 1)/(1 + 2*s/1000 + (s/1000)^2)

###

(5) -1,  0,  1,  2,  3,   4
    60, 60, 40, 20, 20, -20
     0,  0,-20,-20,  0, -40
     0,-20,  0,+20,-40,

Na origem, 20 log H(j1) = 20 log K = 60 => K = 1000
Em w = 1,    -20 => 1/(jw/1 + 1)
Em w = 100,  +20 => jw/100 + 1
Em w = 1000, -40 => 1/(1 + 2*z* jw/1000 + (jw/1000)^2)
H(s) = 1000*(s/100 + 1)/(s/1 + 1)/(1 + 2*0.2*s/1000 + (s/1000)^2)

###

(6) -1,  0,  1,   2,   3
    80, 60, 20, -60,-120
   -20,-20,-40, -80, -60
     0,-20,-40, +20, 

Na origem, 20 log H(j1) = 20 log K = 60 => K = 1000
Em w = 1,   -20 => 1/(jw/1 + 1)
Em w = 10,  -40 => 1/(1 + 2*z* jw/10 + (jw/10)^2)
Em w = 100, +20 => jw/100 + 1
H(s) = 1000*(s/100 + 1)/s/(s/1 + 1)/(1 + 2*s/10 + (s/10)^2)

###

(7) -2, -1,  0,   1,   2,   3,  4
    60, 60, 80, 100, 120, 120, 80
     0,  0, 20,  20,  20,   0,-40
     0,+20,  0,   0, -20, -40,

Na origem, 20 log H(j1) = 20 log K = 80 => K = 10000
Em w = 0.1,  +20 => jw/0.1 + 1
Em w = 100,  -20 => 1/(jw/100 + 1)
Em w = 1000, -40 => 1/(1 + 2*z* jw/1000 + (jw/1000)^2)
H(s) = 10000*(s/0.1 + 1)/(s/100 + 1)/(1 + 2*0.2*s/1000 + (s/1000)^2)
Funcionou com K/10

### Teste 22

x(t) = A cos(w0 t)
     = 72.97 cos(0.1 t)
y(t) = A abs(H(j w0)) cos(w0 t + arg H(j w0))
     = 72.97 abs(H(j 0.1)) cos(0.1 t + arg H(j 0.1))

Em w = 0.1, 20 log H(j 0.1) = 0 => abs H(j 0.1) = 1, arg = 270º
y(t) = 72.97 cos(0.1 t + 270º)

###

x(t) = 43.25 cos(100 t)
y(t) = 43.25 abs(H(j 100)) cos(100 t + arg H(j 100))

Em w = 100, 20 log H(j 100) = 20 => abs H(j 0.1) = 10, arg = 45º
y(t) = 432.5 cos(100 t + 45º)

###

x(t) = 72.97 cos(t)
y(t) = 72.97 abs(H(j 1)) cos(1 t + arg H(j 1))

Em w = 1, 20 log H(j 1) = -40 => abs H(j 0.1) = 0.01, arg = 180º
y(t) = 0.7297 cos(1 t + 180º)

###

x(t) = 38.87 cos(10 t)
y(t) = 38.87 abs(H(j 10)) cos(10 t + arg H(j 10))

Em w = 10, 20 log H(j 10) = 0 => abs H(j 10) = 1, arg = 225º
y(t) = 38.87 cos(10 t + 225º)

###

x(t) = 81.9 cos(t)
y(t) = 81.9 abs(H(j 1)) cos(1 t + arg H(j 1))

Em w = 1, 20 log H(j 1) = 20 => abs H(j 0.1) = 10, arg = 270º
y(t) = 819 cos(1 t + 270º)

###

x(t) = 53.15 cos(0.1 t)
y(t) = 53.15 abs(H(j 0.1)) cos(0.1 t + arg H(j 0.1))

Em w = 0.1, 20 log H(j 0.1) = 0 => abs H(j 0.1) = 1, arg = 270º
y(t) = 72.97 cos(0.1 t + 270º)

###

G(s) = (-3s + 1)/(s + 2)/(s + 3)

Fase mínima? Não. s = 1/3
Ganho em estado estacionário = abs((-3i*0 + 1)/(i*0 + 2)/(i*0 + 3)) = 1/6

H(s) = (s + 16)/(s + 1)/(s + 4)

Fase mínima? Sim. s = -16
Ganho em estado estacionário = 16/1/4 = 4

### Teste 24

m(t) = 58.9 sin(33.14 t) cos(7.22 t)
M(jw) = 0, abs(w) > w_m

m(t) = 14.725 i e^(-25.92 i t) - 14.725 i e^(25.92 i t) + 14.725 i e^(-40.36 i t) - 14.725 i e^(40.36 i t)

x(t) = exp(i*A*t)
X(jw) = 2 pi delta(w - A)

M(jw) = 14.725 i * 2 pi delta(w + 25.92) - 14.725 i * 2 pi delta(w - 25.92) + 14.725 i * 2 pi delta(w + 40.36) - 14.725 i * 2 pi delta(w - 40.36)
w_m = 40.36

w_s > 2 w_m = 80.72

###

M(jw) = 0, abs(w) > 14 = w_m
p(t) = sum n = -infty to infty, delta(t - n/7)
m*(t) = m(t) p(t)
H(jw) = G, abs(w) < wc
H(jw) = 0, caso contrário
h(t) ** m*(t) = m(t)

14 pi = w_s > 2 w_m = 28

P(jw) = 14 pi sum k=-infty to infty, delta(w - 14 pi k)
M*(jw) = 7 sum k=-infty to infty, M(j(w - 14 pi k))
O sinal M(jw) é filtrado de -w_m <= w <= +w_m
M*(jw) é replicado: 14 pi k - w_m <= w <= 14 pi k + w_m

H(jw) = G u(w - wc) - G u(w + wc)

m(t) = sin(14t)
M(jw) = i pi delta(w + 14) - i pi delta(w - 14)

Pela multiplicação,
M*(jw) = 1/2/pi M(jw) ** P(jw) = 7 i pi [delta(w + 14) - delta(w - 14)] ** sum k=-infty to infty, delta(w - k w_s)
       = 7 i pi sum k=-infty to infty, delta(-14 pi k + w + 14) - delta(14 pi k - w + 14)

Pela convolução,
M(jw) = H(jw) M*(jw) = 7 G i pi sum k=-infty to infty, delta(-14 pi k + w + 14) - delta(14 pi k - w + 14), se abs(w) < wc
      = 0, se abs(w) >= wc

i pi = 7 G i pi => G = 1/7 = 0,14285714285714285714285714285714
14 < wc < 14 pi - 14 = 29,982297150257105338477007365913

###

m(t) = 33.4 cos^2(2.05 t)
M(jw) = 0, abs(w) > w_m
w_s = 2 pi/T > 2 w_m => T < pi/w_m

m(t) = 16.7 + 8.35 e^(-4.1 i t) + 8.35 e^(4.1 i t)
M(jw) = 16.7 * 2 pi delta(w) + 8.35 * 2 pi delta(w + 4.1) + 8.35 * 2 pi delta(w - 4.1)
T < pi/4.1 = 0,76624211063165688742991302031207

###

Um filtro passa-baixa ideal pode ser usado como um interpolador ideal e não-causal.
Um segurador de ordem zero pode ser usado como um interpolador não-ideal e causal.
Um filtro passa-baixa ideal pode ser usado como um interpolador não-ideal e não-causal.

###

M(jw) = 0, abs(w) > 18 = w_m
p(t) = sum n = -infty to infty, delta(t - n/9)
m*(t) = m(t) p(t)
H(jw) = G, abs(w) < wc
H(jw) = 0, caso contrário
h(t) ** m*(t) = m(t)

i pi = 9 G i pi => G = 1/9 = 0,111...
18 < wc < 18 pi - 18 = 38,548667764616278292327580899031

###

m(t) = 74.4 cos^2(87.04 t)
M(jw) = 0, abs(w) > w_m
w_s = 2 pi/T > 2 w_m => T < pi/w_m

m(t) = 37.2 + 18.6 e^(-174.08 i t) + 18.6 e^(174.08 i t)
M(jw) = 37.2 delta(w) + 18.6 delta(w + 174.08) + 18.6 delta(w - 174.08)
T < pi/174.08 = 0,01804683279865460270256573634696

###

m(t) = 22 sin(38.93 t) cos(11.44 t)
M(jw) = 0, abs(w) > w_m
w_s = 2 pi/T > 2 w_m => T < pi/w_m

m(t) = 11/2 i e^(-27.49 i t) - 11/2 i e^(27.49 i t) + 11/2 i e^(-50.37 i t) - 11/2 i e^(50.37 i t)
T < pi/50.37 = 0,06237031275739117011043564390072

###

m(t) = 67.1 cos^2(53.6 t)
M(jw) = 0, abs(w) > w_m

m(t) = 33.55 + 16.775 e^(-107.2 i t) + 16.775 e^(107.2 i t)
w_s > 2 w_m = 2 * 107.2 = 214.4

###

m(t) = 62 cos^2(51.72 t)
M(jw) = 0, abs(w) > w_m
w_s = 2 pi/T > 2 w_m => T < pi/w_m

m(t) = 31/2 e^(-103.44 i t) + 31/2 e^(103.44 i t) + 31
T < pi/103.44 = 0,03037115867739552628057466534493

###

G(t, T) = u(t + T/2) - u(t - T/2)
p(t) = (5 - t^2) G(t + 2.5, 5) + (t - 5) G(t - 2.5, 5)
x(t) = sum k=-infty to infty, p(t - 11k)
Determinar a_0 de Fourier de x(t).

p(t) = (5 - t^2) (u(t + 2.5 + 2.5) - u(t + 2.5 - 2.5)) + (t - 5) (u(t - 2.5 + 2.5) - u(t - 2.5 - 2.5))
T0 = 11
a(0) = 1/11 integrate x(t) dt from 0 to 11
     = 1/11 integrate (5 - t^2) dt from -5 to 0 + 1/11 integrate (t - 5) dt from 0 to 5
     = -50/33 - 25/22 = -175/66 = -2.65151...

###

y(n + 1) + 5 y(n) = 14 x(n)
x(n) = 2^n u(n)
y(0) = 9
Determinar y(n).

- y(0) z + z Y(z) + 5 Y(z) = 14 X(z)
- 9 z + z Y(z) + 5 Y(z) = 14/(1 - 2/z)
Y(z) = (14v/(1 - 2v) + 9)/(1 + 5v) 
     = 7/(1 + 5 v) + 2/(1 - 2 v)
y(n) = 7 (-5)^n u(n) + 2^(n + 1) u(n)

###

x(t) = 1/t sin(1.3 pi t) + cos(6.7 pi t)
     = 1/2/t i e^(-4.08407 i t) - 1/2/t i e^(4.08407 i t) + 1/2 e^(-21.0487 i t) + 1/2 e^(21.0487 i t)
T < pi/21.0487 = 0.149253524

