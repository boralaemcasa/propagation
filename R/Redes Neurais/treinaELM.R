treinaELM <- function(xin,yin,p,par){

  n<-dim(xin)[2] # recebe as colunas

  if (par==1){
    xin<-cbind(1,xin)
    Z <- replicate(p, runif((n+1), -0.5, 0.5))
  }
  else{
    Z <- replicate(p, runif(n, -0.5, 0.5))
  }

  H <- tanh(xin %*% Z)

  W <- pseudoinverse(H) %*% yin

  retlist<-list(W,H,Z)
  return(retlist)
}
