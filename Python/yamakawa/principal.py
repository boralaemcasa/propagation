import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split, GridSearchCV

def normalize(array, min, max):
    """
    Normalize data
    :param array:
    :param min:
    :param max:
    :return:
    """
    return [(x - min) / (max - min) for x in array]

def load_deathvalleyavg(normalized=1, n=12):
    xls = pd.ExcelFile("DeathValleyAvg.xls")
    sheetx = xls.parse(0)

    # Preparing x
    x = []
    for index, row in sheetx.iterrows():
        x = x + row[1:].tolist()
    xavg = np.zeros((n, len(x) - n - 1))

    # Preparing y
    yavg = []
    for i in range(0, len(x) - n - 1):
        for j in range(0, n):
            xavg[j][i] = x[i + j]
        yavg.insert(i, x[i + j + 1])

    if normalized:
        min_v = min(yavg)
        max_v = max(yavg)
        xavg = normalize(array=xavg, min=min_v, max=max_v)
        yavg = normalize(array=yavg, min=min_v, max=max_v)

    axis_1 = len(yavg)
    axis_2 = len(xavg)

    x = []
    y = []

    for i in range(0, axis_1):
        x.insert(i, [])
        for j in range(0, axis_2):
            x[i].insert(j, xavg[j][i])
        y.append(yavg[i])

    return np.array(x), np.array(y)

X, y = load_deathvalleyavg()
#X = np.arange(-2,2,0.01).reshape(400,1)
#y = X**2

xt, xv, ydt, ydv = train_test_split(X, y, test_size = 0.3)
nVariaveis = np.shape(xt)[1]

constPCA = 0.90
constMaxEpocas = 20
constNFuncPertinencia = 10
constEpsilon = 0.05

import fsYamakawa
K = fsYamakawa.metodoYamakawa(nVariaveis, xt, ydt, constPCA)
print("colunas", K)
xt = xt[:,K]
xv = xv[:,K]
nVariaveis = np.shape(xt)[1]

xit = np.zeros(nVariaveis)
xft = np.zeros(nVariaveis)
for i in range(0,nVariaveis):
    xit[i] = np.min(X[:,i])
    xft[i] = np.max(X[:,i])

h = 0
gamma = 0
winf = 0
wsup = 0
alpha = 0
xa = 0
out_fis,trainError,incertTrein,xit, xft, gamma, winf, wsup, alpha, xa = fsYamakawa.anfis_yamakawa(xt, ydt, xit, xft, constMaxEpocas, constNFuncPertinencia, constEpsilon,h,gamma,winf,wsup,alpha,xa)
ys, muinf, musup = fsYamakawa.evalfis_yamakawa(out_fis,xv)
nPontos = np.shape(xv)[0]
vinf = ydv - ys[:,0]
vinf = np.sqrt(np.sum(vinf**2) / nPontos)
vsup = ydv - ys[:,1]
vsup = np.sqrt(np.sum(vsup**2) / nPontos)
validError = np.mean((vinf, vsup))
incertValid = abs(vinf - vsup)
print("V error", validError, "incerteza", incertValid)
