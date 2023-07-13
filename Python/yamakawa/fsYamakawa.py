import numpy as np

class TTemp:
    def setXit(self, xit):
        self.xit = xit
    
def anfis_yamakawa(x, yd, xitp, xftp, nEpocas, nFuncPertinencia, constEpsilon, h, gammap, winfp, wsupp, alphap, xap):
    xit = np.copy(xitp)
    xft = np.copy(xftp)
    gamma = np.copy(gammap)
    winf = np.copy(winfp)
    wsup = np.copy(wsupp)
    xa = np.copy(xap)
    error = np.zeros(nEpocas)
    incerteza = np.zeros(nEpocas)
    minError = np.inf
    nPontos, nVariaveis = np.shape(x)
    out = TTemp
    if h == 0:
        out.xit = xit
    out.nFuncPertinencia = nFuncPertinencia
    out.epsilon = constEpsilon
    if nVariaveis == 0:
        out.yConst = np.mean(yd)

    if h == 0:
        out.gamma = np.zeros(nVariaveis)
        for v in range(0, nVariaveis):
            out.gamma[v] = (xft[v] - xit[v])/(nFuncPertinencia - 1)
            if out.gamma[v] == 0:
                out.gamma[v] = 1

        out.winf = np.ones((nVariaveis, nFuncPertinencia))
        out.wsup = np.ones((nVariaveis, nFuncPertinencia))
        gamma = out.gamma
        winf = out.winf
        wsup = out.wsup
    else:
        out.gamma = gamma
        out.winf = winf
        out.wsup = wsup

    xa = np.zeros(nVariaveis)
    ystinf = np.zeros(nPontos)
    ystsup = np.zeros(nPontos)
    jj = np.zeros(nVariaveis, int)
    mujj = np.zeros(nVariaveis)
    mujjinf = np.zeros(nVariaveis)
    mujjsup = np.zeros(nVariaveis)
    for epoca in range(0, nEpocas):
        for k in range(0, nPontos):
            alpha = 0.0
            ystinf[k] = 0.0
            ystsup[k] = 0.0
            for v in range(0, nVariaveis):
                jj[v] = np.floor((x[k,v] - xit[v])/out.gamma[v]) + 1
                if jj[v] > nFuncPertinencia - 1:
                    jj[v] = nFuncPertinencia - 1
                elif jj[v] < 1:
                    jj[v] = 1
                xa = xit[v] + (jj[v]-1)*out.gamma[v]
                mujj[v] = 1/out.gamma[v] * (xa[v] - x[k,v]) + 1
                mujjinf[v] = np.max((mujj[v] - out.epsilon, 0))
                mujjsup[v] = np.min((mujj[v] + out.epsilon, 1))
                ystinf[k] = ystinf[k] + mujjinf[v] * out.winf[v,jj[v]-1] + (1 - mujjinf[v]) * out.winf[v,jj[v]]
                ystsup[k] = ystsup[k] + mujjsup[v] * out.wsup[v,jj[v]-1] + (1 - mujjsup[v]) * out.wsup[v,jj[v]] 
                alpha = alpha + mujj[v]**2 + (1 - mujj[v])**2
                
            alpha = 1/alpha

            for v in range(0, nVariaveis):
                out.winf[v,jj[v]-1] = out.winf[v,jj[v]-1] - alpha * (ystinf[k] - yd[k]) * mujjinf[v]
                out.wsup[v,jj[v]-1] = out.wsup[v,jj[v]-1] - alpha * (ystsup[k] - yd[k]) * mujjsup[v]
                out.winf[v,jj[v]] = out.winf[v,jj[v]] - alpha * (ystinf[k] - yd[k]) * (1 - mujjinf[v])
                out.wsup[v,jj[v]] = out.wsup[v,jj[v]] - alpha * (ystsup[k] - yd[k]) * (1 - mujjsup[v])

        if nVariaveis == 0:
            e = 0
            incert = 0
        else:
            einf = yd - ystinf
            einf = np.sqrt(np.sum(einf**2) / nPontos)
            esup = yd - ystsup
            esup = np.sqrt(np.sum(esup**2) / nPontos)
            e = np.mean((einf, esup))
            incert = abs(einf - esup)
        error[epoca] = e
        incerteza[epoca] = incert
        if e < minError:
            outmin = out
            minError = e
    return outmin, error, incerteza, xit, xft, gamma, winf, wsup, alpha, xa

def evalfis_yamakawa(out, x):
    nPontosV, nVariaveis = np.shape(x)
    jj = np.zeros(nVariaveis, int)
    mujj = np.zeros(nVariaveis)
    mujjinf = np.zeros(nVariaveis)
    mujjsup = np.zeros(nVariaveis)
    if nVariaveis == 0:
        ysv = out.yConst * np.ones((nPontosV, 1))
        ysv = np.hstack((ysv, ysv))
    else:
        ysv = np.zeros((nPontosV, 2))
        for k in range(0, nPontosV):
            ysv[k,:] = [0.0, 0.0]
            for v in range(0, nVariaveis):
                jj[v] = np.floor((x[k,v] - out.xit[v])/out.gamma[v]) + 1
                if jj[v] > out.nFuncPertinencia - 1:
                    jj[v] = out.nFuncPertinencia - 1
                elif jj[v] < 1:
                    jj[v] = 1
                xa = out.xit[v] + (jj[v]-1)*out.gamma[v]
                mujj[v] = 1/out.gamma[v] * (xa - x[k,v]) + 1
                mujjinf[v] = np.max((mujj[v] - out.epsilon, 0))
                mujjsup[v] = np.min((mujj[v] + out.epsilon, 1))
                ysv[k,0] = ysv[k,0] + mujjinf[v] * out.winf[v,jj[v]-1] + (1 - mujjinf[v]) * out.winf[v,jj[v]]
                ysv[k,1] = ysv[k,1] + mujjsup[v] * out.wsup[v,jj[v]-1] + (1 - mujjsup[v]) * out.wsup[v,jj[v]] 
    return ysv, mujjinf, mujjsup

def metodoYamakawa(nVariaveis, xt, ydt, constPCA, batelada=0):
    H, s = np.shape(xt)

    constNFuncPertinencia = 10
    constEpsilon = 0.05
    
    contribuicaoinf = np.zeros((nVariaveis,constNFuncPertinencia))
    contribuicaosup = np.zeros((nVariaveis,constNFuncPertinencia))
    totalinf = np.zeros(nVariaveis)
    totalsup = np.zeros(nVariaveis)
    gamma1=0 
    winf1=0 
    wsup1=0 
    alpha1=0 
    xa1=0
    xit = np.zeros(nVariaveis)
    xft = np.zeros(nVariaveis)
    for i in range(0,nVariaveis):
        xit[i] = np.min(xt[:,i])
        xft[i] = np.max(xt[:,i])
    if batelada == 0:
        for h in range(0,H):
            out_fis1, E1, I1, xit, xft, gamma1, winf1, wsup1, alpha1, xa1 = anfis_yamakawa(xt[h:h+1,:], ydt[h:h+1], xit, xft, 1, constNFuncPertinencia, constEpsilon, h, gamma1, winf1, wsup1, alpha1, xa1)
    else:
        out_fis1, E1, I1, xit, xft, gamma1, winf1, wsup1, alpha1, xa1 = anfis_yamakawa(xt, ydt, xit, xft, 1, constNFuncPertinencia, constEpsilon, 0, gamma1, winf1, wsup1, alpha1, xa1)
        h = 1

    cols = np.arange(0,nVariaveis)
    if h > 0:
        pesoinf = abs(out_fis1.winf)
        pesosup = abs(out_fis1.wsup)
        for i in range(0,constNFuncPertinencia):
            totalinf[i] = np.sum(pesoinf[:,i])
            totalsup[i] = np.sum(pesosup[:,i])
            contribuicaoinf[:,i] = pesoinf[:,i] / totalinf[i]
            contribuicaosup[:,i] = pesosup[:,i] / totalsup[i]
        contribuicaoi = np.mean(contribuicaoinf,1)
        contribuicaos = np.mean(contribuicaosup,1)
        T = np.mean((contribuicaoi, contribuicaos), 0)
        incerteza = abs(contribuicaos - contribuicaoi)
        idx = np.argsort(T, 0)
        idx = idx[::-1]
        x = T[idx]
        m = np.min(np.where(np.cumsum(x) > constPCA))
        cols = idx[0:m]
    
    return cols

def metodoYamakawa2(nVariaveis, xt, ydt, constPCA, batelada=0):
    H, s = np.shape(xt)

    constNFuncPertinencia = 10
    constEpsilon = 0.05
    
    contribuicaoinf = np.zeros((nVariaveis,constNFuncPertinencia))
    contribuicaosup = np.zeros((nVariaveis,constNFuncPertinencia))
    totalinf = np.zeros(nVariaveis)
    totalsup = np.zeros(nVariaveis)
    gamma1=0 
    winf1=0 
    wsup1=0 
    alpha1=0 
    xa1=0
    gamma2=0 
    winf2=0 
    wsup2=0 
    alpha2=0 
    xa2=0
    xit = np.zeros(nVariaveis)
    xft = np.zeros(nVariaveis)
    for i in range(0,nVariaveis):
        xit[i] = np.min(xt[:,i])
        xft[i] = np.max(xt[:,i])
    if batelada == 0:
        for h in range(0,H):
            out_fis1, E1, I1, xit, xft, gamma1, winf1, wsup1, alpha1, xa1 = anfis_yamakawa(xt[h:h+1,:]*0.95, ydt[h:h+1]*0.95, xit, xft, 1, constNFuncPertinencia, constEpsilon, h, gamma1, winf1, wsup1, alpha1, xa1)
            out_fis2, E2, I2, xit, xft, gamma2, winf2, wsup2, alpha2, xa2 = anfis_yamakawa(xt[h:h+1,:]*1.05, ydt[h:h+1]*1.05, xit, xft, 1, constNFuncPertinencia, constEpsilon, h, gamma2, winf2, wsup2, alpha2, xa2)
    else:
        out_fis1, E1, I1, xit, xft, gamma1, winf1, wsup1, alpha1, xa1 = anfis_yamakawa(xt*0.95, ydt*0.95, xit, xft, 1, constNFuncPertinencia, constEpsilon, 0, gamma1, winf1, wsup1, alpha1, xa1)
        out_fis2, E2, I2, xit, xft, gamma2, winf2, wsup2, alpha2, xa2 = anfis_yamakawa(xt*1.05, ydt*1.05, xit, xft, 1, constNFuncPertinencia, constEpsilon, 0, gamma2, winf2, wsup2, alpha2, xa2)
        h = 1

    cols = np.arange(0,nVariaveis)
    if h > 0:
        pesoinf = abs((out_fis1.winf + out_fis2.winf)/2)
        pesosup = abs((out_fis1.wsup + out_fis2.wsup)/2)
        for i in range(0,constNFuncPertinencia):
            totalinf[i] = np.sum(pesoinf[:,i])
            totalsup[i] = np.sum(pesosup[:,i])
            contribuicaoinf[:,i] = pesoinf[:,i] / totalinf[i]
            contribuicaosup[:,i] = pesosup[:,i] / totalsup[i]
        contribuicaoi = np.mean(contribuicaoinf,1)
        contribuicaos = np.mean(contribuicaosup,1)
        T = np.mean((contribuicaoi, contribuicaos), 0)
        incerteza = abs(contribuicaos - contribuicaoi)
        idx = np.argsort(T, 0)
        idx = idx[::-1]
        x = T[idx]
        m = np.min(np.where(np.cumsum(x) > constPCA))
        cols = idx[0:m]
    
    return cols

def metodoYamakawaOtimo(nVariaveis, xt, ydtp, constPCA, batelada=0):
    ydt = np.copy(ydtp)
    H, s = np.shape(xt)
    constNFuncPertinencia = 10

    xit = np.zeros(nVariaveis)
    xft = np.zeros(nVariaveis)
    for i in range(0,nVariaveis):
        xit[i] = np.min(xt[:,i])
        xft[i] = np.max(xt[:,i])
    
    gamma = np.zeros(nVariaveis)
    for v in range(0, nVariaveis):
        gamma[v] = (xft[v] - xit[v])/(constNFuncPertinencia - 1)
        if gamma[v] == 0:
            gamma[v] = 1
    
    jj = np.zeros(nVariaveis, int)
    A = np.zeros((H, s * constNFuncPertinencia))
    for h in range(0, H):
        M = np.zeros((nVariaveis, constNFuncPertinencia))
        mujj = np.zeros(nVariaveis)
        for v in range(0,nVariaveis):
            jj[v] = np.floor((xt[h,v] - xit[v])/gamma[v]) + 1
            if jj[v] > constNFuncPertinencia - 1:
                jj[v] = constNFuncPertinencia - 1
            elif jj[v] < 1:
                jj[v] = 1
            xa = xit[v] + (jj[v]-1)*gamma[v]
            mujj[v] = 1/gamma[v] * (xa - xt[h,v]) + 1
            M[v,jj[v]-1] = mujj[v]
            M[v,jj[v]] = 1 - mujj[v]
        A[h,:] = M.reshape(1, s * constNFuncPertinencia)

    wt = np.asmatrix(np.linalg.pinv(A))
    ydt = np.asmatrix(ydt.reshape(H, 1))
    wt = wt * ydt
    peso = np.asmatrix(abs(wt.reshape(s, constNFuncPertinencia)))
    
    contribuicao = np.asmatrix(np.zeros((s, constNFuncPertinencia)))
    for i in range(0, constNFuncPertinencia):
        total = np.sum(peso[:,i])
        contribuicao[:,i] = peso[:,i] / total
    T = np.asmatrix(np.mean(contribuicao,1))
    idx = np.argsort(T, 0)
    idx = idx[::-1]
    x = T[idx].reshape(nVariaveis)
    wher = np.where(np.cumsum(x) > constPCA)
    m = np.min(wher[1])
    cols = np.zeros(m, int)
    for i in range(0,m):
        cols[i] = idx[i,0]
    return cols

def anfis_yamakawaOtimo(xt, ydtp, constNFuncPertinencia):
    ydt = np.copy(ydtp)
    H, nVariaveis = np.shape(xt)
    constNFuncPertinencia = 10

    xit = np.zeros(nVariaveis)
    xft = np.zeros(nVariaveis)
    for i in range(0,nVariaveis):
        xit[i] = np.min(xt[:,i])
        xft[i] = np.max(xt[:,i])
    
    gamma = np.zeros(nVariaveis)
    for v in range(0, nVariaveis):
        gamma[v] = (xft[v] - xit[v])/(constNFuncPertinencia - 1)
        if gamma[v] == 0:
            gamma[v] = 1
    
    jj = np.zeros(nVariaveis, int)
    A = np.zeros((H, nVariaveis * constNFuncPertinencia))
    for h in range(0, H):
        M = np.zeros((nVariaveis, constNFuncPertinencia))
        mujj = np.zeros(nVariaveis)
        for v in range(0,nVariaveis):
            jj[v] = np.floor((xt[h,v] - xit[v])/gamma[v]) + 1
            if jj[v] > constNFuncPertinencia - 1:
                jj[v] = constNFuncPertinencia - 1
            elif jj[v] < 1:
                jj[v] = 1
            xa = xit[v] + (jj[v]-1)*gamma[v]
            mujj[v] = 1/gamma[v] * (xa - xt[h,v]) + 1
            M[v,jj[v]-1] = mujj[v]
            M[v,jj[v]] = 1 - mujj[v]
        A[h,:] = M.reshape(1, nVariaveis * constNFuncPertinencia)

    wt = np.asmatrix(np.linalg.pinv(A))
    ydt = np.asmatrix(ydt.reshape(H, 1))
    wt = wt * ydt
    wt = wt.reshape(nVariaveis, constNFuncPertinencia)
    out = TTemp
    out.xit = xit
    out.nFuncPertinencia = constNFuncPertinencia
    out.epsilon = 0
    out.gamma = gamma
    if nVariaveis == 0:
       out.yConst = np.mean(ydt)
    out.winf = np.copy(wt)
    out.wsup = np.copy(wt)
    
    incert = 0
    ys, mu1, mu2 = evalfis_yamakawa(out, xt)
    ysavg = (ys[:,0] + ys[:,1])/2
    error = np.zeros(H)
    for i in range(0,H):
        error[i] = abs((ydt[i] - ysavg[i])/ydt[i]) * 100
    
    return out, error, incert
