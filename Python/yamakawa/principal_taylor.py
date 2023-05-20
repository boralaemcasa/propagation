import numpy as np
from mpmath import *

def f(x):
    return mp.sin(sum(matrix(x)))

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
    
def partial(fun, x0, x, vars,h):
    if vars[0,0] == -1:
        v = 'f(x)'
        w = f(x0)
        return v, w
    s = np.shape(vars)[1]
    E = mp.eye(np.shape(x0)[1])
    k = 0
    v = 'x - he_' + str(vars[0,k])
    w = x0 - h * E[int(vars[0,k]),:]
    z = 1
    v = np.hstack((v, 'x + he_' + str(vars[0,k])))
    w = np.vstack((w, x0 + h * E[vars[0,k],:]))
    z = np.hstack((z, 0))
    for k in range(1,s):
        v2 = []
        for kk in range(0, np.shape(v)[0]):
            v2 = np.hstack((v2, v[kk] + ' - he_' + str(vars[0,k])))
        for kk in range(0, np.shape(v)[0]):
            v2 = np.hstack((v2, v[kk] + ' + he_' + str(vars[0,k])))
        v = np.copy(v2)
        w = np.vstack((w - h * E[int(vars[0,k]),:], w + h * E[int(vars[0,k]),:]))
        z = np.hstack((z + 1, z))
    n = np.shape(v)[0]
    v2 = []
    for j in range(0,n):
        if z[j] % 2 == 0:
            letra = '+'
        else:
            letra = '-'
        v2 = np.hstack((v2, str(letra) + 'f(' + v[j] + ')'))
        w[j,0] = fun(w[j,:])
        if letra == '-':
            w[j,0] = - w[j,0]
    v = np.hstack((v2, 'sobre (2h)^' + str(s)))
    w = sum(w[:,0]) * mp.exp(-s * mp.log(2*h))
    p = 1
    for kk in range(0, s):
        p = p * np.prod(x[0,int(vars[0,kk])] - x0[0,int(vars[0,kk])])
    print(w, '*', p)
    w = w * p
    return v, w

def taylor(fun, x0, x, maxg,h):
    n = np.shape(x0)[1]
    v, w = partial(fun, x0, x, matrix([[-1]]),h)
    for j in range(1, maxg+1):
        idx = np.reshape(mp.zeros(1,j), ((1,j)))
        while True:
            a, b = partial(fun, x0, x, idx,h)
            v = np.hstack((v, a))
            c, d = cperm(idx)
            v = np.hstack((v, c))
            w = np.hstack((w, b * d))
            if np.sum(idx == n-1) == j:
                break
            idx = incrementar(idx,j-1,n)
    return sum(w)

mp.dps = 20
h = 1e-4
# x0 = np.reshape(matrix([[0]]), (1,1))
# x = np.reshape(matrix([[mp.pi/6]]), (1,1))
# print(taylor(f, x0, x, 6, h))

x0 = np.reshape([[0,0,0]], (1,3))
x = np.reshape([[mp.pi/12, mp.pi/24, mp.pi/24]], (1,3))
print(taylor(f, x0, x, 6, h))
