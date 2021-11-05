dist <- function(x, y) { sqrt((x[1] - y[1])^2 + (x[2] - y[2])^2) }

kmeans2 <- function(k, M, linhas) {
  centro <- matrix(0,ncol=2,nrow=k)
  for (i in 1:k) {
    a <- sample(1:linhas, 1)
    centro[i,1] <- M[a,1]
    centro[i,2] <- M[a,2]
  }

	distancia <- matrix(0,k)
  novoCentro <- matrix(0,ncol=2,nrow=k)

  while (TRUE) {
	  for (i in 1:linhas) {
	    for (j in 1:k)
	      distancia[j] <- dist(M[i,], centro[j,])
	    M[i,3] <- 1
	    min <- distancia[1]
	    for (j in 2:k)
	      if (distancia[j] < min) {
	        M[i,3] <- j
	        min <- distancia[j]
	      }
	  }

	  for (j in 1:k) {
	    sx <- 0
	    sy <- 0
	    contador <- 0
	    for (i in 1:linhas)
	      if (M[i, 3] == j) {
	        sx <- sx + M[i,1]
	        sy <- sy + M[i,2]
	        contador <- contador + 1
	      }
	    novoCentro[j,1] <- sx / contador
	    novoCentro[j,2] <- sy / contador
	  }

    flag <- TRUE
    for (j in 1:k)
  	  if (novoCentro[j] != centro[j])
	      flag <- FALSE

    if (flag)
      return(M)

    centro <- novoCentro
  }
}

treinaRBF <- function (xin, yin, p) {

  pdfnvar <- function(x,m,K,n) {1/sqrt((2*pi)^n * (det(K)))*exp(-0.5*(t(x - m)%*%(solve(K))%*%(x-m)))}

  N <- dim(xin)[1]
  n <- dim(xin)[2]

  xin <- as.matrix(xin)
  yin <- as.matrix(yin)

  xclust <- kmeans(xin, p)

  m <- as.matrix(xclust$centers)

  covlist <- list()

  for (i in 1:p) {
    ici <- which (xclust$cluster == i)
    xci <- xin[ici,]
    covi <- cov(as.matrix(xci))
    covlist[[i]] <- covi
  }

  H <- matrix(nrow = N, ncol = p)
  for (j in 1:N) {
    for (i in 1:p) {
      mi <- m[i,]
      covi <- covlist[[i]]
      H[j, i] <- pdfnvar(xin[j,], mi, covi, n)

    }
  }

  Haug <- cbind(1, H)
  W <- (solve(t(Haug) %*% Haug) %*% t(Haug)) %*% yin

  return (list (m, covlist, W, H))
}
