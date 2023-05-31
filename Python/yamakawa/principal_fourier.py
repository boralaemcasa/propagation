import matplotlib.pyplot as plt
import numpy as np
from mpmath import *
j = mp.sqrt(-1)

def fun(x):
    return np.sum(x)

def fourierSum(a, x1, x2, t, nVars):
    maxk = np.shape(a)[0]
    w = x2 - x1
    w[np.where(w != 0)] = 2 * np.pi / w
    k = 0
    if nVars == 1:
        soma = a[k]
        for k in range(1, maxk):
            soma = soma + a[k] * mp.exp(j * k * w[0] * t[0]) + np.conj(a[k]) * mp.exp(-j * k * w[0] * t[0])
    else: #2
        soma = 0
        maxk = (maxk - 1)//2
        for k in range (-maxk, maxk-1):
            for ell in range (-maxk, maxk-1):
                soma = soma + a[k + maxk, ell + maxk] * mp.exp(j * k * w[0] * t[0]) * mp.exp(j * ell * w[1] * t[1])
    return soma

def incrementar(x,n,N,dx,xi):
    y = np.copy(x)
    y[0,n-1] = y[0,n-1] + dx
    while True:
        flag1 = False
        flagTodas = True
        for k in range(0,n):
            if y[0,k] <= N[k]:
                flagTodas = False
                break
        for k in range(0,n):
            if y[0,k] > N[k]:
                flag1 = True
                break
        if k == 0 and y[0,k] > N[k]:
            return 2, y
        if (not flag1) or flagTodas:
            return 1, y
        y[0,k-1] = y[0,k-1] + dx
        y[0,k:] = xi[k:] + dx
    return y

def fourier(f, x, w, k):
    y = f(x)
    for ell in range(0, np.shape(x)[1]):
        y = y * mp.exp(-j * k[ell] * w[ell] * x[0,ell])
    return y

def fourierIntegral(xip, xfp, f, kp, dx, nVars):
   xi = xip[0:nVars]
   xf = xfp[0:nVars]
   k = kp[0:nVars]
   T = xf - xi
   w = 2*np.pi / T
   t = xi + dx * np.ones((1, nVars))
   soma = 0
   flag = 1
   while flag == 1:
      soma = soma + fourier(f, t, w, k) * dx**nVars
      flag, t = incrementar(t, nVars, xf, dx, xi)
   return soma/np.prod(T)

mp.dps = 20
nVars = 2
maxk = 4+1 
k = np.array([1,1])
xi = -np.pi * k
xf = np.pi * k
dx = 0.25 #1e-2
if nVars == 1:
    a = mp.zeros(maxk,1)
    for k in range(0, maxk):
        print("k =", k)
        a[k,0] = fourierIntegral(xi, xf, fun, [k,0], dx, nVars)
    print(a)
else: #2    
    a = np.zeros((2*maxk+1,2*maxk+1), dtype=mpc)
    for k in range(-maxk, maxk+1):
        for ell in range(-maxk, maxk+1):
            print("k =", k, "ell =", ell)
            a[k + maxk, ell + maxk] = fourierIntegral(xi, xf, fun, [k,ell], dx, nVars)
rangt = np.arange(xi[0], xf[0], (xf[0]-xi[0])/50)
contador = 0
if nVars == 1:
    rangy = mp.zeros(1,50)
    for t1 in range(0, 50):
        rangy[t1] = np.real(fourierSum(a, xi, xf, [rangt[t1], 0], nVars))
    plt.figure(figsize=(20,5))
    rangt = np.array(rangt, dtype=np.float64)
    rangy = np.array(rangy, dtype=np.float64)
    #rang2 = 2 * np.ones((50))
    plt.plot(rangt, rangy, 'red', rangt, rangt, 'blue')
    plt.title("Fourier 1D")
    plt.xlabel("x")
    plt.ylabel(r"y")
    plt.show()
    #plt.axis([0, s, 0, m1])
    
else: #2
    rangy = mp.zeros(50,50)
    A = np.zeros((2500), dtype=mpf)
    B = np.copy(A)
    C = np.copy(A)
    D = np.copy(A)
    for t1 in range(1, 50):
        for t2 in range(0, 50):
            rangy[t1,t2] = np.real(fourierSum(a, xi, xf, [rangt[t1], rangt[t2]], nVars))
            A[contador] = rangt[t1]
            B[contador] = rangt[t2]
            C[contador] = rangy[t1, t2]
            D[contador] = fun([rangt[t1], rangt[t2]])
            contador = contador + 1
    A = np.array(A, dtype=np.float64)
    B = np.array(B, dtype=np.float64)
    C = np.array(C, dtype=np.float64)
    D = np.array(D, dtype=np.float64)
    ax = plt.axes(projection='3d')
    ax.plot3D(A, B, C, 'red')
    ax.plot3D(A, B, D, 'blue')
    plt.show()
