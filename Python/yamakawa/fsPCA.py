import numpy as np

def duplo(x):
    y = np.hstack((x, x**2))
    return y

class TfsPCA:
    def __init__(self, nVariaveis):
        n = 2 * nVariaveis
        self.St = np.zeros((1,n))
        self.St2 = np.zeros((n,n))
        self.C = np.zeros((n,n))
        self.constPCA = 0.90
        self.nVariaveis = nVariaveis

    def fsPCA(self, xt, ydt, h):
        xt = duplo(xt)
        n = np.shape(xt)[1]
        self.St = self.St + xt
        Mt = self.St/h # mean(xt,1)

        for i in range(0,n):
            for j in range(i,n):
                self.St2[i,j] = self.St2[i,j] + xt[:,i] * xt[:,j]
            for j in range(0,i):
                self.St2[i,j] = self.St2[j,i]
            
        cols = np.arange(0,self.nVariaveis)
        if h == 1:
            return cols
        Mt2 = self.St2/h
        # C = cov(xt)
        for i in range(0,n):
            for j in range(i,n):
                self.C[i,j] = Mt2[i,j] - Mt[:,i] * Mt[:,j]
            for j in range(0,i):
                self.C[i,j] = self.C[j,i]

        d, V = np.linalg.eig(self.C)
        d = d/sum(d)
        idx = np.argsort(d, 0)
        idx = idx[::-1]
        x = d[idx]
        m = np.min(np.where(np.cumsum(x) > self.constPCA))
        cols = idx[0:m]
        return cols
