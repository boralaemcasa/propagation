import numpy as np

def regressores2(n, total, Psi, y, P, theta, RSE):
    lambd = 1 #0.99
    theta = theta[0:n]
    if np.linalg.norm(theta) == 0:
        P = np.eye(n)*1e6
    else:
        P = P[0:n,0:n]
    psi_k = Psi.T
    K_k = np.matmul(P,psi_k)/(np.matmul(psi_k.T, np.matmul(P, psi_k))+lambd)
    K_k = np.reshape(K_k, (n, 1))
    theta = theta + np.matmul(K_k, (y - np.matmul(psi_k.T, theta)))
    P = (P - np.matmul(P, np.matmul(psi_k, np.matmul(psi_k.T, P))))/(np.matmul(psi_k.T, np.matmul(P, psi_k)) + lambd)/lambd
    csi_k = y - np.matmul(psi_k.T, theta)
    RSE = RSE + csi_k**2
    #theta = theta(0:n,end)
    theta = np.vstack((theta, np.zeros((total-n,1))))
    P = np.vstack((P, np.zeros((total-n,n))))
    P = np.hstack((P, np.zeros((total,total-n))))
    return theta, P, RSE

def metodoContrib(nVariaveis, xt, ydt, constPCA):
    P2 = np.zeros((nVariaveis,nVariaveis))
    theta = np.zeros((nVariaveis,1))
    RSE = 0
    for linha in range(0, np.shape(ydt)[0]):
        Psi = xt[linha:linha+1,:]
        theta, P2, RSE = regressores2(nVariaveis, nVariaveis, Psi, ydt[linha], P2, theta, RSE)

    T = abs(theta.reshape(nVariaveis))
    T = T/np.sum(T)
    idx = np.argsort(T, 0)
    idx = idx[::-1]
    x = T[idx]
    m = np.min(np.where(np.cumsum(x) > constPCA))
    cols = idx[0:m]
    return cols

def metodoContrib2(nVariaveis, xt, ydt, xt2, ydt2, constPCA):
    P2 = np.zeros((nVariaveis,nVariaveis))
    theta = np.zeros((nVariaveis,1))
    RSE = 0
    P22 = np.zeros((nVariaveis,nVariaveis))
    theta2 = np.zeros((nVariaveis,1))
    RSE2 = 0
    for linha in range(0, np.shape(ydt)[0]):
        theta, P2, RSE = regressores2(nVariaveis, nVariaveis, xt[linha:linha+1,:], ydt[linha], P2, theta, RSE)
        theta2, P22, RSE2 = regressores2(nVariaveis, nVariaveis, xt2[linha:linha+1,:], ydt2[linha], P22, theta2, RSE2)

    T = abs(theta.reshape(nVariaveis))
    T2 = abs(theta2.reshape(nVariaveis))
    T = (T + T2)/2
    T = T/np.sum(T)
    idx = np.argsort(T, 0)
    idx = idx[::-1]
    x = T[idx]
    m = np.min(np.where(np.cumsum(x) > constPCA))
    cols = idx[0:m]
    return cols

