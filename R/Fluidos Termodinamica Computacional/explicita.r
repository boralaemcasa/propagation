a <- matrix(0, 7, 7)
b <- matrix(0, 7)
qq <- matrix(0, 22555)
xx <- matrix(0, 22555)

t <- 85 + 273
ti <- 20 + 273
tinf <- 20 + 273
c <- c(t,t,t,t,t,t,t)
alfa <- 1.5e-6
rho <- 2.4
cc <- 790 # 0.79 J/g /deg C
k <- rho * cc / alfa

q <- 5
h <- 15
x <- 0.5
y <- 0.75
t <- 0.01 # ???
c <- t(c)
c <- t(c)
soma <- 0
for (N in 1:1000000) {
xx[N] <- N
qq[N] <- qq[N] + k * 0.5 * x / y * (ti - c[1])
qq[N] <- qq[N] + k * x / y * (ti - c[2])
qq[N] <- qq[N] + k * x / y * (ti - c[3])
qq[N] <- qq[N] + k * 0.5 * x / y * (ti - c[4])
qq[N] <- qq[N] + q * 2 * x * y
qq[N] <- qq[N] + h * 0.5 * y * (tinf - c[3])
qq[N] <- qq[N] + h * 0.5 * x * (tinf - c[3])
qq[N] <- qq[N] + h * 0.5 * x * (tinf - c[4])
qq[N] <- qq[N] + h * 0.5 * y * (tinf - c[7])
soma <- soma + qq[N]

a[1,1] <- (- alfa * y / x - alfa * x / y) * t/0.5/x/y + 1 # T5
# t <= 57692.32
a[1,2] <- alfa * y / x * t/0.5/x/y # T6
a[1,3] <- 0 # T7
a[1,4] <- 0 # T8
a[1,5] <- alfa * 0.5 * x / y * t/0.5/x/y # T9
a[1,6] <- 0 # T10
a[1,7] <- 0 # T11
b[1] <- alfa * 0.5 * x / y * ti * t/0.5/x/y

a[2,1] <- alfa * y / x * t/x/y # T5
a[2,2] <- (- 2 * alfa * y / x - 2 * alfa * x / y) * t/x/y + 1 # T6
a[2,3] <- alfa * y / x * t/x/y # T7
a[2,4] <- 0 # T8
a[2,5] <- 0 # T9
a[2,6] <- alfa * x / y * t/x/y # T10
a[2,7] <- 0 # T11
b[2] <- alfa * x / y * ti * t/x/y

a[3,1] <- 0 # T5
a[3,2] <- alfa * y / x * t/0.75/x/y # T6
a[3,3] <- (- 1.5 * alfa * y / x - h/alfa/k * 0.5 * y - alfa * 1.5 * x / y - h/alfa/k * 0.5 * x) * t/0.75/x/y + 1 # T7
a[3,4] <- alfa * 0.5 * y / x * t/0.75/x/y # T8
a[3,5] <- 0 # T9
a[3,6] <- 0 # T10
a[3,7] <- alfa * 0.5 * x / y * t/0.75/x/y # T11
b[3] <- (h/alfa/k * 0.5 * y + h/alfa/k * 0.5 * x * tinf + alfa * x / y * ti) * t/0.75/x/y

a[4,1] <- 0 # T5
a[4,2] <- 0 # T6
a[4,3] <- alfa * 0.5 * y / x * t/0.25/x/y # T7
a[4,4] <- (- alfa * 0.5 * y / x - h/alfa/k * 0.5 * x - alfa * 0.5 * x / y) * t/0.25/x/y + 1 # T8
a[4,5] <- 0 # T9
a[4,6] <- 0 # T10
a[4,7] <- 0 # T11
b[4] <- (h/alfa/k * 0.5 * x * tinf + alfa * 0.5 * x / y * ti) * t/0.25/x/y

a[5,1] <- alfa * 0.5 * x / y * t/0.25/x/y # T5
a[5,2] <- 0 # T6
a[5,3] <- 0 # T7
a[5,4] <- 0 # T8
a[5,5] <- (- alfa * 0.5 * y / x - alfa * 0.5 * x / y) * t/0.25/x/y + 1 # T9
a[5,6] <- alfa * 0.5 * y / x * t/0.25/x/y # T10
a[5,7] <- 0 # T11
b[5] <- q/alfa/k * 0.25 * x * y * t/0.25/x/y

a[6,1] <- 0 # T5
a[6,2] <- alfa * x / y * t/0.5/x/y # T6
a[6,3] <- 0 # T7
a[6,4] <- 0 # T8
a[6,5] <- alfa * 0.5 * y / x * t/0.5/x/y # T9
a[6,6] <- (- alfa * y / x - alfa * x / y) * t/0.5/x/y + 1 # T10
a[6,7] <- alfa * 0.5 * y / x * t/0.5/x/y # T11
b[6] <- q/alfa/k * 0.5 * x * y * t/0.5/x/y

a[7,1] <- 0 # T5
a[7,2] <- 0 # T6
a[7,3] <- alfa * 0.5 * x / y * t/0.25/x/y # T7
a[7,4] <- 0 # T8
a[7,5] <- 0 # T9
a[7,6] <- alfa * 0.5 * y / x * t/0.25/x/y # T10
a[7,7] <- (- alfa * 0.5 * y / x - h/alfa/k * 0.5 * y - alfa * 0.5 * x / y) * t/0.25/x/y + 1 # T11
b[7] <- (h/alfa/k * 0.5 * y * tinf + q/alfa/k * 0.25 * x * y) * t/0.25/x/y

c1 <- a %*% c + b

if (norm(c - c1) < 1e-3)
  break
c <- c1
}
t(c - 273)
N
print(paste("T_5 = ", c[1]
, "; T_6 =", c[2]
, "; T_7 =", c[3]
, "; T_8 =", c[4]
, "; T_9 =", c[5]
, "; T_{10} =", c[6]
, "; T_{11} =", c[7]))

soma
soma2
qq1 <- qq
 Mx1 <- 0
 Mx2 <- 22555
 My1 <- min(qq[1:N])
 My2 <- max(qq[1:N])
 par(new=T)
 plot(xx[1:N],qq[1:N],type = 'l',col='red',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='100 t (s)',ylab='Q (W)')
