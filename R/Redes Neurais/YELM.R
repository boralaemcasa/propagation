YELM <- function(xin,Z,W,par){

  xin <- matrix(0, nrow = 1, ncol = 2)
  xin[1,1] <- -3.1
  xin[1,2] <- 3.3

  xin<-cbind(1,xin)

  Z <- matrix(0, nrow = 3, ncol = 3)
  Z[1,1] <- -0.2
  Z[1,2] <- -0.6
  Z[1,3] <- -0.1
  Z[2,1] <- -0.5
  Z[2,2] <- 0.3
  Z[2,3] <- -0.8
  Z[3,1] <- -0.9
  Z[3,2] <- 0.2
  Z[3,3] <- 1

  W <- matrix(0, nrow = 4, ncol = 1)
  W[1] <- -0.4
  W[2] <- 0.4
  W[3] <- -1.8
  W[4] <- 1.8

  H <- tanh(xin %*% Z)
  H <- cbind(1,H)

  Yhat <- sign(H %*% W)
  return(Yhat)
}
