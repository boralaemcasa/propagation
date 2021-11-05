treinaELM <- function(xin,yin,p,par){

  n<-dim(xin)[2] # recebe as colunas

  if (par==1){
    xin<-cbind(1,xin)
    Z <- replicate(p, runif((n+1), -0.5, 0.5)) # (n+1) x p
  }
  else{
    Z <- replicate(p, runif(n, -0.5, 0.5))     # n x p
  }

  H <- tanh(xin %*% Z)                         # L x c x c x p = L x p
  W <- pseudoinverse(H) %*% yin                # p x 1

  retlist<-list(W,H,Z)
  return(retlist)
}
