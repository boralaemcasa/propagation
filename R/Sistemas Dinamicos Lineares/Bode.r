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

Descrever figuras.

###

j <- complex(imaginary=1)

H <- function(s) {
   #return (20 * s * (s + 100)/(s + 2)/(s + 10))
   #return (1/(s + 0.1)/(s + 1)/(s + 10))
   return ((s + 1)/(s + 0.1)/(s + 10))
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
   if (y2[i] > 90)
      y2[i] <- y2[i] - 360

xmin <- -3
xmax <- 4
ymin <- min(y1)
ymax <- max(y1)
plot(z,y1,type='l',col='blue',xlim=c(xmin,xmax),ylim = c(ymin,ymax),xlab='x',ylab='y')

ymin <- min(y2)
ymax <- max(y2)
plot(z,y2,type='l',col='blue',xlim=c(xmin,xmax),ylim = c(ymin,ymax),xlab='x',ylab='y')

###

Primeiramente, o cara quer que eu trace a derivada a olho nu. Dado o gráfico.

Dadas as assíntotas, recuperar H(s) e plotar em cima.

