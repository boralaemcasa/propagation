G <- function(x) { exp(- x[1]^2 - x[2]^2) }

y <- function (x, m, w, b) {
  w[1] * G(x - m[1,]) + w[2] * G(x - m[2,]) + b
}

  w <- matrix(0, nrow = 1, ncol = 2)
  w[1,1] <- 3.4213
  w[1,2] <- -3.4213

  b <- 1.9054 

  m <- matrix(0, nrow = 2, ncol = 2)
  m[1,1] <- 1
  m[1,2] <- 1
  m[2,1] <- 0
  m[2,2] <- 0
  
  xin <- matrix(0, nrow = 1, ncol = 2)
  xin[1,1] <- 1
  xin[1,2] <- 1
  y(xin, m, w, b)
  xin[1,1] <- 0
  xin[1,2] <- 1
  y(xin, m, w, b)
  xin[1,1] <- 0
  xin[1,2] <- 0
  y(xin, m, w, b)
  xin[1,1] <- 1
  xin[1,2] <- 0
  y(xin, m, w, b)


YRBF <- function (xin, modRBF) {

  xin <- matrix(0, nrow = 1, ncol = 2)
  xin[1,1] <- 4.7
  xin[1,2] <- 6.5
    
  m <- matrix(0, nrow = 2, ncol = 2)
  m[1,1] <- 2
  m[1,2] <- 2
  m[2,1] <- 4
  m[2,2] <- 4
  
  W <- matrix(0, nrow = 3, ncol = 1)
  W[1] <- 9.8
  W[2] <- 4.3
  W[3] <- 1.6
  
  xin <- as.matrix(xin)
  
  H <- matrix(nrow = 1, ncol = 2)
  for (j in 1:1) {
    for (i in 1:2) {
      mi <- m[i,]
      H[j, i] <- v(xin[j,], mi)
      
    }
  }
  
  Haug <- cbind(1, H)
  Yhat <- Haug %*% W
  return (Yhat)
}

