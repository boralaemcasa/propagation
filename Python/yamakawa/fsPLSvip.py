import numpy as np

class TfsPLSvip:
    def __init__(self, nVariaveis, nSamples=1):
        self.RSE = np.zeros((nSamples,nVariaveis))
        self.nVariaveis = nVariaveis
        self.nSamples = nSamples
        self.nRuns = np.zeros(nSamples)

    def fsPLSvip(self, xt, ydt, h, nr=0):
        b = np.zeros(self.nVariaveis)
        y = ydt
        X = xt
        P = np.zeros((self.nVariaveis,0))
        W = np.zeros((self.nVariaveis,0))
        for K in range(0, self.nVariaveis):
            yy = np.matmul(ydt.T, ydt)
            w = np.matmul(ydt.T, xt) / yy
            w = w.reshape(1,self.nVariaveis)
            w = w.T / np.linalg.norm(w)
            t = np.matmul(X, w) / np.matmul(w.T, w)
            tt = np.matmul(t.T, t)
            if tt == 0:
                return
            p = np.matmul(t.T, X) / tt
            pp = np.linalg.norm(p)
            if pp == 0:
                return
            t = t * pp
            w = w * pp
            p = p.T / pp
            b[K] = np.matmul(y.T, t) / np.matmul(t.T, t)
            if K == 0:
                T = np.copy(t)
            else:
                T = np.hstack((T, t))
            P = np.hstack((P, p))
            W = np.hstack((W, w))
            y = y - b[K] * t
            X = X - np.matmul(t, p.T)
        # xi = ydt(1:h) - T * b'
        # sum(xi.^2)
        soma = np.zeros(self.nVariaveis)
        denom = 0
        for K in range(0, T.shape[1]):
            for i in range(0, self.nVariaveis):
                soma[i] = soma[i] + b[K]**2 * np.matmul(T[:,K].T, T[:,K]) * (W[i,K] / np.linalg.norm(W[:,K]))**2
            denom = denom + b[K]**2 * np.matmul(T[:,K].T, T[:,K])
        self.RSE[nr] = self.RSE[nr] + np.sqrt(self.nVariaveis * soma / denom)
        self.nRuns[nr] = self.nRuns[nr] + 1

    def fsPLSvip2(self, xt, ydt, xt2, ydt2, h):
        self.fsPLSvip(xt, ydt, h, 0)
        self.fsPLSvip(xt2, ydt2, h, 1)

    def ranking(self):    
        vip = self.RSE[0]/self.nRuns[0]
        if self.nSamples > 1:
            vip2 = self.RSE[1]/self.nRuns[1]
            vip = (vip + vip2)/2
        idx = np.argsort(vip, 0)
        idx = idx[::-1]
        x = vip[idx]
        m = np.min(np.where(x <= 1))
        cols = idx[0:m]
        return cols
