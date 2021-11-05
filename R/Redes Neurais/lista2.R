x <- seq(-1,1,by = 0.1)
y <- seq(-1,1,by = 0.1)
create_grid <- expand.grid(x,y)
N <- length(create_grid$Var1)

circle <- function(x,y) {
  return(sqrt(x^2 + y^2))
}

raio <- 0.6

classe = 1*(circle(create_grid$Var1, create_grid$Var2) > raio)

par(new=F)
for (i in 1:N) {
  if (classe[i]==1){
    plot(create_grid$Var1[i], create_grid$Var2[i], col = 'red', xlim = c(-1.1,1.1),ylim = c(-1.1,1.1),xlab = '' , ylab= '' )
  } else {
    plot(create_grid$Var1[i], create_grid$Var2[i], col = 'blue', xlim = c(-1.1,1.1),ylim = c(-1.1,1.1),xlab = '' , ylab= '' )
  }
 par(new=T)
}

 xrange<-seq(-0.1, 1.5, 0.01)
 yrange<-1*(xrange > 0.6)
 par(new=F)
 plot(xrange,yrange,type = 'l',col='black',xlim=c(-0.1, 1.5),ylim = c(-3.5, 3.5),xlab='x',ylab='Classe(x)')


z <- complex(real = create_grid$Var1, imaginary = create_grid$Var2)

par(new=T)
for (i in 1:N) {
  if (classe[i]==1){
    plot(Mod(z[i]), Arg(z[i]), col = 'red', xlim = c(-0.1,1.5),ylim = c(-3.5,3.5),xlab = '' , ylab= '' )
  } else {
    plot(Mod(z[i]), Arg(z[i]), col = 'blue', xlim = c(-0.1,1.5),ylim = c(-3.5,3.5),xlab = '' , ylab= '' )
  }
 par(new=T)
}

################

 library('polynom')
 library('corpcor')

coeficientes <- function(amostra, degp) {
  namostra <- length(amostra[,1])
  y <- matrix(0, namostra, 1)
  h <- matrix(1, namostra, degp + 1)
  for (i in 1:namostra) {
    y[i] <- amostra[i,2]
    h[i, degp] <- amostra[i,1]
    for (j in 1:(degp - 1)) {
      h[i, degp - j] <- h[i, degp - j + 1] * amostra[i,1]
    }
  }

  hplus <- pseudoinverse(h)
  w <- hplus %*% y

  res <- matrix(0, degp + 1, 1)
  for (i in 1:(degp + 1)) {
    res[i] <- w[degp + 2 - i]
  }
  p <- as.polynomial(res)
  return(p)
}

x <- seq(-15,10,by = 0.1)
y <- seq(-15,10,by = 0.1)
N <- length(x)
for (i in 1:N) {
  y[i] = x[i] * x[i]/2 + 3 * x[i] + 10  + dnorm(x[i], 0, 4)
}

for (degp in 1:8) {
	namostra <- 20
	amostra <- matrix(0, namostra, 2)
	for (i in 1:namostra) {
	  j <- sample(1:N, 1)
	  amostra[i,1] <- x[j]
	  amostra[i,2] <- y[j]
	}
  p <- coeficientes(amostra, degp)

  par(new=F)
  plot(x, y, col = 'blue', xlim = c(-15,10),ylim = c(0, 100),xlab = '' , ylab= '' )
  par(new=T)
  plot(x, as.function(p)(x), col = 'red', xlim = c(-15,10),ylim = c(0, 100),xlab = '' , ylab= '' )
  par(new=T)
  dev.new()
}

for (degp in 1:8) {
	namostra <- 100
	amostra <- matrix(0, namostra, 2)
	for (i in 1:namostra) {
	  j <- sample(1:N, 1)
	  amostra[i,1] <- x[j]
	  amostra[i,2] <- y[j]
	}
  p <- coeficientes(amostra, degp)

  par(new=F)
  plot(x, y, col = 'blue', xlim = c(-15,10),ylim = c(0, 100),xlab = '' , ylab= '' )
  par(new=T)
  plot(x, as.function(p)(x), col = 'red', xlim = c(-15,10),ylim = c(0, 100),xlab = '' , ylab= '' )
  par(new=T)
  dev.new()
}

