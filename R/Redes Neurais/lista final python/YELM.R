YELM <- function(xin,Z,W,par){

  n<-dim(xin)[2] # recebe as colunas
  
  if (par==1){
    xin<-cbind(1,xin)
  }
  
  H <- tanh(xin %*% Z)
  Yhat <- H %*% W
  return(Yhat)  
}