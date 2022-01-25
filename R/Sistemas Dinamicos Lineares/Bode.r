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
H(jw) = 1, se abs(w) <= w_c
H(jw) = 0, caso contrário

Filtro passa-faixa = BPF:
H(jw) = 1, se w_c1 <= abs(w) <= w_c2
H(jw) = 0, caso contrário

Filtro passa alta = HPF:
H(jw) = 1, se abs(w) >= w_c
H(jw) = 0, caso contrário

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
   return (1000/(1 + 2* s/1000 + (s/1000)^2))
}

H2 <- function(s) {
   return (0.5/(s + 0.5) * exp(-2*s))
}

log10 <- function(x) {
   return(log(x)/log(10))
}

z <- seq(-3, 4, 0.1)
w <- 10^z
x <- H(j * w)
y1 <- 20 * log10(abs(x))
y2 <- Arg(x)/pi * 180
for (i in 1:length(z))
   if (y2[i] > 0)
      y2[i] <- y2[i] - 360

xmin <- 0
xmax <- 4
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
  
Fase não mínima = zero no semiplano direito.

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

###

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

Descrever figuras.

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

