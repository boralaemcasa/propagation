library('polynom')
p <- as.polynomial(c(0,7.4,1.8))
q <- as.polynomial(c(1,1/0.860716))
r <- as.polynomial(c(0.414937,0.389284,1))
a <- p/q/r
p <- p %% (q*r)
# p/q/r = A/q + (Bx + C)/r
# A r + (Bx + C) q = p
m <- matrix(0, 3, 3)
b <- matrix(0, 3)
m[1,1] <- r[1]
m[1,2] <- 0
m[1,3] <- q[1]
b[1] <- p[1]
m[2,1] <- r[2]
m[2,2] <- q[1]
m[2,3] <- q[2]
b[2] <- p[2]
m[3,1] <- r[3]
m[3,2] <- q[2]
m[3,3] <- 0
b[3] <- p[3]
b <- solve(m) %*% b
print(b)
s <- as.polynomial(c(b[3], b[2]))
b[1] * r + s * q - p

#######

polymul <- function(a, b) {
  p <- dim(a)[1] # 1 + 2x + 5x^2
  q <- dim(b)[1] # 3 + 4x
  r <- p + q - 1
  x <- matrix(0, r)
  for (i in 1:r)
    for (j in 1:i)
      if ((j <= p) && (i - j + 1 <= q)) {
        x[i] <- x[i] + a[j] * b[i - j + 1]
        #print(paste(i, j, a[j] * b[i - j + 1]))
      }
  return(x)
}

polysum <- function(a, b) {
  p <- dim(a)[1] # 1 + 2x + 5x^2
  q <- dim(b)[1] # 3 + 4x
  r <- max(p, q)
  x <- matrix(0, r)
  for (i in 1:r) {
    if (i <= p)
      x[i] <- x[i] + a[i]
    if (i <= q)
      x[i] <- x[i] + b[i]
  }
  return(x)
}

j <- complex(imaginary = 1)
p <- as.matrix(c(100/4,300/4))
q1 <- as.matrix(c(1/8 + j * sqrt(15)/8,1))
q2 <- as.matrix(c(1/8 - j * sqrt(15)/8,1))
a <- matrix(0, 2)
a
p
q1
q2
# p/(q1 q2) = A/q1 + B/q2
# A q2 + B q1 = p
m <- matrix(0, 2, 2)
b <- matrix(0, 2)
for (i in 1:2) {
m[i,1] <- q2[i]
m[i,2] <- q1[i]
b[i] <- p[i]
}
#det(m)
b <- solve(m) %*% b
#b <- b * det(m)
print(paste(b[1], b[2]))
print(paste(b[1]/(1/8 + j * sqrt(15)/8), b[2]/(1/8 - j * sqrt(15)/8)))

# p/q1/q2 = (a + (b[1] * r1 + b[2] * r2 + b[3] * r3)/q1/q2)
p - (b[1] * q2 + b[2] * q1)
polymul(q1, q2)

###

j <- complex(imaginary = 1)
p <- as.matrix(c(-8,0,6))
q1 <- as.matrix(c(- 2.93114246375354, 1))
q2 <- as.matrix(c(0.46557123187677 + 1.58510398503090 * j, 1))
q3 <- as.matrix(c(0.46557123187677 - 1.58510398503090 * j, 1))
a <- matrix(0, 3)
#a <- p/q1/q2/q3
#p <- p %% (q1*q2*q3)
#a <- a * 20160
#p <- p * 20160
a
p
q1
q2
q3
# p/(q1 q2 q3) = A/q1 + B/q2 + C/q3
# A q2 q3 + B q1 q3 + C q1 q2 = p
# A r1 + B r2 + C r3 = p
r1 <- polymul(q2, q3)
r2 <- polymul(q1, q3)
r3 <- polymul(q1, q2)
m <- matrix(0, 3, 3)
b <- matrix(0, 3)
for (i in 1:3) {
m[i,1] <- r1[i]
m[i,2] <- r2[i]
m[i,3] <- r3[i]
b[i] <- p[i]
}
#det(m)
b <- solve(m) %*% b
#b <- b * det(m)
print(paste(b[1], b[2], b[3]))
print(paste(b[1]/q1[1], b[2]/q2[1], b[3]/q3[1]))
print(paste(1/q1[1], 1/q2[1], 1/q3[1]))

p <- as.matrix(c(0,7.4,1.8))
q1 <- as.matrix(c(1,1/0.860716))
q2 <- as.matrix(c(1,0.194642 + 0.614045 * j))
q3 <- as.matrix(c(1,0.194642 - 0.614045 * j))
# p/q1/q2/q3 = (a + (b[1] * r1 + b[2] * r2 + b[3] * r3)/q1/q2/q3)
polysum(- polymul(polymul(polymul(q1, q2), q3), a), p - (b[1] * r1 + b[2] * r2 + b[3] * r3))

#######

x <- as.polynomial(c(0,1))
p <- as.polynomial(c(0,1.8,7.4))
q <- as.polynomial(c(2.8,3.5,2.1,1))
p
q
for (i in 0:4) {
   a <- p/q
   p <- p %% q
   if (length(a) == 1)
      print(paste(a, "x^(", -i, ")"))
   else print(a)
   p <- p * x
}

