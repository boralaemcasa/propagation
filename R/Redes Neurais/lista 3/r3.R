x <- as.matrix(read.table('V:\\sem backup\\_redes neurais 2021 16 julho max 1 h 40 min\\lista 3\\Exercício 3 (enunciado + codigo + dados)\\ex1_x') )
y <- as.matrix(read.table('V:\\sem backup\\_redes neurais 2021 16 julho max 1 h 40 min\\lista 3\\Exercício 3 (enunciado + codigo + dados)\\ex1_y') )
t <- as.matrix(read.table('V:\\sem backup\\_redes neurais 2021 16 julho max 1 h 40 min\\lista 3\\Exercício 3 (enunciado + codigo + dados)\\ex1_t') )

par(new=F)
plot(t, x, col = 'blue', xlim = c(-0.1, 6.1),ylim = c(-1.1,1.1),xlab = '' , ylab= '' )
par(new=T)
plot(t, y, col = 'red', xlim = c(-0.1, 6.1),ylim = c(-1.1,1.1),xlab = '' , ylab= '' )

tol <- 1e-3
maxepocas <- 100
eta <- 0.1
par <- 1
amostra <- c(1:4,6:7,9:11,13,16:17,19:20)
xin <- as.matrix(x[amostra])
yd <- as.matrix(y[amostra])
res <- trainadaline(xin,yd,eta,tol,maxepocas,par)
z <- res[[1]][1] + res[[1]][2] * x

par(new=F)
plot(t, y, col = 'black', xlim = c(-0.1, 6.1),ylim = c(-1.1,1.1),xlab = '' , ylab= '' )
par(new=T)
plot(t, z, col = 'green', xlim = c(-0.1, 6.1),ylim = c(-1.1,1.1),xlab = '' , ylab= '' )

teste <- z - y
teste <- teste[c(5,8,12,14,15,18)]
e <- norm(as.matrix(teste))
e * e/length(teste)

################

x <- as.matrix(read.table('C:\\Users\\cu_do_bispo\\Documents\\data 26 ago 3 redes neurais\\entregar 3\\x') )
y <- as.matrix(read.table('C:\\Users\\cu_do_bispo\\Documents\\data 26 ago 3 redes neurais\\entregar 3\\y') )
t <- as.matrix(read.table('C:\\Users\\cu_do_bispo\\Documents\\data 26 ago 3 redes neurais\\entregar 3\\t') )

cores <- rainbow(4)

par(new=F)
plot(t, x[,1], col = cores[1], xlim = c(-0.1, 6.1),ylim = c(-1.6,1.6),xlab = '' , ylab= '' )
par(new=T)
plot(t, x[,2], col = cores[2], xlim = c(-0.1, 6.1),ylim = c(-1.6,1.6),xlab = '' , ylab= '' )
par(new=T)
plot(t, x[,3], col = cores[3], xlim = c(-0.1, 6.1),ylim = c(-1.6,1.6),xlab = '' , ylab= '' )
dev.new()
plot(t, y, col = cores[4], xlim = c(-0.1, 6.1),ylim = c(-2,10),xlab = '' , ylab= '' )

tol <- 1e-3
maxepocas <- 100
eta <- 0.1
par <- 1
amostra <- c(1,3,5:9,11:13,15:17,20)
xin <- as.matrix(x[amostra,])
yd <- as.matrix(y[amostra])
res <- trainadaline(xin,yd,eta,tol,maxepocas,par)
z <- res[[1]][1] + res[[1]][2] * x[,1] + res[[1]][3] * x[,2] + res[[1]][4] * x[,3]

par(new=F)
plot(t, y, col = 'black', xlim = c(-0.1, 6.1),ylim = c(-2,10),xlab = '' , ylab= '' )
par(new=T)
plot(t, z, col = 'green', xlim = c(-0.1, 6.1),ylim = c(-2,10),xlab = '' , ylab= '' )


teste <- z - y
teste <- teste[c(2,4,10,14,18,19)]
e <- norm(as.matrix(teste))
e * e/length(teste)
