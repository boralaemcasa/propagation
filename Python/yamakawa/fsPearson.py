import numpy as np
from mpmath import *
import fsYamakawa

def incrementar(x,n,N):
    y = np.copy(x)
    y[0,n] = y[0,n] + 1
    while True:
        if np.sum(y >= N) == 0:
            return y
        j = np.min(np.where(y[0,:] >= N))
        y[0,j-1] = y[0,j-1] + 1
        y[0,j:] = y[0,j-1]

def cperm(x):
    w = 1
    v = ''
    s = int(np.max(x) + 1)
    for j in range(0,s):
        t = np.sum(x == j)
        if t >= 2:
            v = v + str(t) + '!'
            w = w/mp.factorial(t)
    if len(v) > 0:
        v = 'vezes 1/(' + v + ')'
    return v, w
    
class TfsPearson:
    def __init__(self, nVariaveis, nSamples=1):
        n = nVariaveis + 2
        self.St = np.zeros((nSamples,n))
        self.St2 = np.zeros((n,n,nSamples))
        self.C = np.zeros((n,n,nSamples))
        self.R1 = np.zeros((nSamples,nVariaveis))
        self.R2 = np.zeros((nSamples,nVariaveis))
        self.constContribGlobal = 0.70
        self.nVariaveis = nVariaveis
        self.nSamples = nSamples
        self.h = 1e-4

    def fsPearson(self, xtp, ydt, h, returnContrib=False):
        if returnContrib:
            self.__init__(self.nVariaveis, self.nSamples)
        constContrib = self.constContribGlobal/self.nVariaveis
        xt = np.hstack((xtp, ydt, ydt**2))
        n = np.shape(xt)[1]
        self.St = self.St + xt
        Mt = self.St/h # mean(xt,1)

        for k in range(0, self.nSamples):
            for i in range(0,n):
                for j in range(i,n):
                    self.St2[i,j,k] = self.St2[i,j,k] + xt[k,i] * xt[k,j]
                for j in range(0,i):
                    self.St2[i,j,k] = self.St2[j,i,k]
            
        cols = np.arange(0,self.nVariaveis)
        if h == 1:
            return cols
        Mt2 = self.St2/h
        # C = cov(xt)
        for k in range(0,self.nSamples):
            for i in range(0,n):
                for j in range(i,n):
                    self.C[i,j,k] = Mt2[i,j,k] - Mt[k,i] * Mt[k,j]
                for j in range(0,i):
                    self.C[i,j,k] = self.C[j,i,k]

        for k in range(0,self.nSamples):
            for i in range(0,self.nVariaveis):
                self.R1[k,i] = self.C[i,n-2,k]
                denom = self.C[i,i,k] * self.C[n-2,n-2,k]
                if denom < 0:
                    print(i, denom)
                if denom != 0:
                    self.R1[k,i] = self.R1[k,i]/np.sqrt(denom)
                self.R2[k,i] = self.C[i,n-1,k]
                denom = self.C[i,i,k] * self.C[n-1,n-1,k]
                if denom < 0:
                    print(i, denom)
                if denom != 0:
                    self.R2[k,i] = self.R2[k,i]/np.sqrt(denom)
        contribuicao = np.max((abs(self.R1),abs(self.R2)),0)
        contribuicao = np.mean(contribuicao, 0)
        contribuicao = contribuicao/sum(contribuicao)
        if returnContrib:
            return contribuicao[0]
        for i in range(0,self.nVariaveis):
            if contribuicao[i] <= constContrib:
                cols[i] = -1
        return cols

    def fun(self, x):
        xy = np.reshape(x, (self.nSamples, self.nVariaveis+1))
        xt = xy[:,:-1]
        ydt = xy[:,-1:]
        #return mp.sin(np.sum(xy[0,:]))
        return self.fsPearson(xt, ydt, self.nSamples, True)
        #return fsYamakawa.metodoYamakawaOtimo(self.nVariaveis, xt, ydt, 0.9, 1)

    def partial(self, x0, vars):
        if vars[0,0] == -1:
            #v = 'f(x)'
            w = self.fun(x0)
            p = 1 # (x - x0)**0
            return w, p
        s = np.shape(vars)[1]
        E = mp.eye(np.shape(x0)[1])
        k = 0
        #v = 'x - he_' + str(vars[0,k])
        w = x0 - self.h * E[int(vars[0,k]),:]
        z = 1
        #v = np.hstack((v, 'x + he_' + str(vars[0,k])))
        w = np.vstack((w, x0 + self.h * E[vars[0,k],:]))
        z = np.hstack((z, 0))
        for k in range(1,s):
            #v2 = []
            #for kk in range(0, np.shape(v)[0]):
            #    v2 = np.hstack((v2, v[kk] + ' - he_' + str(vars[0,k])))
            #for kk in range(0, np.shape(v)[0]):
            #    v2 = np.hstack((v2, v[kk] + ' + he_' + str(vars[0,k])))
            #v = np.copy(v2)
            w = np.vstack((w - self.h * E[int(vars[0,k]),:], w + self.h * E[int(vars[0,k]),:]))
            z = np.hstack((z + 1, z))
        n = np.shape(z)[0]
        #v2 = []
        for j in range(0,n):
            if z[j] % 2 == 0:
                letra = '+'
            else:
                letra = '-'
            #v2 = np.hstack((v2, str(letra) + 'f(' + v[j] + ')'))
            w[j,0] = self.fun(w[j,:])
            if letra == '-':
                w[j,0] = - w[j,0]
        #v = np.hstack((v2, 'sobre (2h)^' + str(s)))
        w = sum(w[:,0]) * mp.exp(-s * mp.log(2*self.h))
        p = 1
        #for kk in range(0, s):
        #    p = p * np.prod(x[0,int(vars[0,kk])] - x0[0,int(vars[0,kk])])
        return w, p

    def getTaylor(self,x0, x, maxg):
        n = self.nVariaveis+1
        w, p = self.partial(x0, matrix([[-1]]))
        IDX = np.array([[-1]]).reshape((1,1))
        for j in range(1, maxg+1):
            idx = np.reshape(mp.zeros(1,j), ((1,j)))
            while True:
                if np.shape(IDX)[1] < np.shape(idx)[1]:
                    IDX = np.hstack((IDX, -np.ones((np.shape(IDX)[0],1))))
                IDX = np.vstack((IDX, idx))
                b, P = self.partial(x0, idx)
                #v = np.hstack((v, a))
                c, d = cperm(idx)
                #v = np.hstack((v, c))
                w = np.hstack((w, b * d)) # * p
                print(w[-1], '*(x-x0)', idx + 1)
                p = np.hstack((p, P))
                if np.sum(idx == n-1) == j:
                    break
                idx = incrementar(idx,j-1,n)
        return w, IDX

    def calcTaylor(self, P0, P, w, idx, wref):
        flagMenor = True
        X = np.reshape(P, (self.nSamples, self.nVariaveis+1))
        x0 = np.reshape(P0, (self.nSamples, self.nVariaveis+1))
        what = mp.zeros(self.nSamples, 1)
        erro = mp.zeros(self.nSamples, 1)
        r = np.shape(w)[0]
        for ii in range(0, self.nSamples):
            for jj in range(0,r):
                vars = idx[jj]
                s = np.shape(vars)[0]
                p = 1
                for kk in range(0, s):
                    v = int(vars[kk])
                    if v >= 0:
                        p = p * np.prod(X[ii,v] - x0[ii,v])
                what[ii] = what[ii] + w[jj] * p
            erro[ii] = abs((wref - what[ii])/wref) * 100
            if flagMenor:
                flagMenor = erro[ii] < 20
                #if not flagMenor: return False
        e = np.array(erro)
        ee = np.where(e >= 20)[0]
        print("what min =", np.min(what), "what max =", np.max(what))
        print("#(Erro >= 20) =", ee.shape)
        return flagMenor

    def fsPearsonTaylor(self, xt, ydt):
        mp.dps = 20
        x0 = np.copy(xt)
        y0 = np.ones((self.nSamples,1)) * (np.max(ydt[:,0]) - np.min(ydt[:,0]))/2
        for i in range(0,self.nVariaveis):
            x0[:,i] = (np.max(xt[:,i]) - np.min(xt[:,i]))/2
        x0 = np.reshape(np.hstack((x0, y0)), (1, self.nSamples * (self.nVariaveis+1)))
        X = np.reshape(np.hstack((xt, ydt)), (1, self.nSamples * (self.nVariaveis+1)))
        wref = self.fun(X)
        h = 0.1 * np.random.rand(X.shape[0], X.shape[1])
        for i in range(2,3):
            w, idx = self.getTaylor(X - h, X, i)
            if self.calcTaylor(X - h, X, w, idx, wref):
                break
        return
    
