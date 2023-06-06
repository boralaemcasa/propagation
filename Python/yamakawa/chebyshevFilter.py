from mpmath import *

def power(x, y):
   if (y / 2 == mp.floor(y / 2)) and (mp.im(x) == 0) and (mp.re(x) < 0):
      return mp.exp(y * mp.ln(-x))
   else:
      return mp.exp(y * mp.ln(x))

def my_round(x):
   y = mp.fabs(x)
   if mp.fabs(y - mp.floor(y)) < 0.5:
      return mp.sign(x) * mp.floor(y)
   else:
      return mp.sign(x) * mp.ceil(y)

def my_int(x):
   y = int(my_round(x))
   return y

def fatorial(x):
   result = 1
   while x > 1:
     result = result * x
     x = x - 1
   return result

def chebyshev(n):
   print("cos (", n, "t ) =")
   fim = my_int(mp.ceil(my_int(n + 1)/2))
   sinal = 1
   p = n
   a = n - 1
   for i in range (0, fim):
      termo = power(2, p - 1) * n * fatorial(a) / fatorial(i) / fatorial(p)
      if sinal > 0:
         s = "+"
      else:
         s = "-"
      print(s, my_int(termo), "* cos^{", p, "} t")
      sinal = - sinal
      p = p - 2
      a = a - 1
   return

def binom(n, p):
   result = 1
   for i in range(0, p):
      result = result * (n - i) / (i + 1)
   return result

def multcos(p, x):
   a = x
   b = mp.sqrt(1 - x*x)
   soma, sinal = 0, 1
   fim = my_int(p * 2) + 1
   k = 0
   while True:
      y = binom(p, 2 * k)
      if p >= 1:
         if k > p:
            break
      elif mp.fabs(y) < 1e-4:
         break
      termo = mp.re(fmul(fmul(y, power(a, p - 2*k)), fmul(sinal, power(b, 2*k))))
      soma = soma + termo
      sinal = - sinal
      k = k + 1
   print("cos(", p, "arccos", x, ") =", soma)

def multsin(p, x):
   a = mp.sqrt(1 - x*x)
   b = x
   soma, sinal = 0, 1
   fim = my_int(p * 2) + 1
   k = 0
   while True:
      y = binom(p, 2 * k + 1)
      if p >= 1:
         if k > p:
            break
      elif mp.fabs(y) < 1e-4:
         break
      termo = mp.re(fmul(fmul(y, power(a, p - 2*k - 1)), fmul(sinal, power(b, 2*k + 1))))
      soma = soma + termo
      sinal = - sinal
      k = k + 1
   print("sin(", p, "arcsin", x, ") =", soma)

def multtan(p, x):
   flag = (p < 0)
   if flag:
      p = -p
   a = mp.sqrt(0.5)
   b = a * x
   lamb, mu, sinal = 0, 0, 1
   fim = my_int(p * 2) + 1
   k = 0
   anterior = -mp.inf
   while True:
      y = binom(p, 2 * k)
      if p >= 1:
         if k > p:
            break
      elif mp.fabs(y) < 1e-4:
         break
      dL = mp.re(fmul(fmul(y, power(a, p - 2*k)), fmul(sinal, power(b, 2*k))))
      dM = mp.re(fmul(fmul(binom(p, 2*k + 1), power(a, p - 2*k - 1)), fmul(sinal, power(b, 2*k + 1))))
      lamb = lamb + dL
      mu = mu + dM
      atual = mu/lamb
      if mp.fabs(atual - anterior) < 0.005:
         break
      anterior = atual
      sinal = - sinal
      k = k + 1
   if flag:
      mu = -mu
   print("k =", k, "arctan(tan(", p, "arctan", x, ")) =", mp.atan(atual))
   return mp.atan(atual)

def multcot(p, x):
   b = mp.sqrt(0.5)
   a = b * x
   lamb, mu, sinal = 0, 0, 1
   fim = my_int(p * 2) + 1
   k = 0
   while True:
      y = binom(p, 2 * k)
      if p >= 1:
         if k > p:
            break
      elif mp.fabs(y) < 1e-4:
         break
      lamb = lamb + mp.re(fmul(fmul(y, power(a, p - 2*k)), fmul(sinal, power(b, 2*k))))
      mu = mu + mp.re(fmul(fmul(binom(p, 2*k + 1), power(a, p - 2*k - 1)), fmul(sinal, power(b, 2*k + 1))))
      sinal = - sinal
      k = k + 1
   print("cot(", p, "arccot", x, ") =", lamb/mu)

def multsec(p, x):
   a = 1/x
   b = mp.sqrt(x*x - 1)/x
   soma, sinal = 0, 1
   fim = my_int(p * 2) + 1
   k = 0
   while True:
      y = binom(p, 2 * k)
      if p >= 1:
         if k > p:
            break
      elif mp.fabs(y) < 1e-4:
         break
      termo = mp.re(fmul(fmul(y, power(a, p - 2*k)), fmul(sinal, power(b, 2*k))))
      soma = soma + termo
      sinal = - sinal
      k = k + 1
   print("sec(", p, "arcsec", x, ") =", 1/soma)

def multcossec(p, x):
   a = mp.sqrt(x*x - 1)/x
   b = 1/x
   soma, sinal = 0, 1
   fim = my_int(p * 2) + 1
   k = 0
   while True:
      y = binom(p, 2 * k + 1)
      if p >= 1:
         if k > p:
            break
      elif mp.fabs(y) < 1e-4:
         break
      termo = mp.re(fmul(fmul(y, power(a, p - 2*k - 1)), fmul(sinal, power(b, 2*k + 1))))
      soma = soma + termo
      sinal = - sinal
      k = k + 1
   print("cossec(", p, "arccossec", x, ") =", 1/soma)

mp.dps = 15
ini = mp.tan(0.1)
import matplotlib.pyplot as plt
import numpy as np
rangt = np.arange(1e-4, 40*mp.pi, 1)
rangy = np.copy(rangt)
APE = np.copy(rangt)
MSE = np.copy(rangt)
s = np.shape(rangt)[0]
for i in range(0,s):
    rangy[i] = 10*multtan(rangt[i], ini) # IS THIS A FILTER?
    temp = my_round((rangy[i] - rangt[i])/mp.pi)
    rangy[i] -= temp*mp.pi
    APE[i] = abs((rangt[i] - rangy[i])/rangt[i]) * 100
    MSE[i] = (rangt[i] - rangy[i])**2/rangt[i]
plt.plot(rangt, APE)
plt.figure()
plt.plot(rangt, MSE)
plt.figure()
plt.plot(rangt, rangy, 'red', rangt, rangt, 'blue')
plt.show()

# Release 0.1 from 2023/June/06
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.
