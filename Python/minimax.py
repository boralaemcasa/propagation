# https://pbs.twimg.com/media/EuxkVOaXEAA90ob?format=png&name=900x900
# https://pbs.twimg.com/media/Eu1wYJGXMAIQG_O?format=png&name=900x900

from mpmath import *
import random
import numpy as np

def power(x, y):
   if (y / 2 == mp.floor(y / 2)) and (mp.im(x) == 0) and (mp.re(x) < 0):
      return mp.exp(y * mp.ln(-x))
   else:
      return mp.exp(y * mp.ln(x))

def ID(n):
   M = mp.zeros(n, 1)
   M[0] = 1
   return M

def product(x, y, M, n):
   res = mp.zeros(n, 1)
   for k in range (0, n):
      z = mp.zeros(n, n)
      for i in range (0, n):
         for j in range (0, n):
            z[i, j] = M[i, j, k]
      p = x.T * z * y
      res[k] = p[0]
   return res

def minimax(x, y, M, n, Tnorm, Snorm):
   res = mp.zeros(n, 1)
   for k in range (0, n):
      first = True
      z = mp.zeros(n, n)
      for i in range (0, n):
         for j in range (0, n):
            z[i, j] = M[i, j, k]
      p = z * y
      t = mp.zeros(n, 1)
      for i in range (0, n):
         inibir = True
         for j in range (0, n):
            if mp.fabs(z[i, j]) > 1e-9:
               inibir = False
               break
         if not inibir:
            t[i] = Tnorm(x[i], p[i])
            if first:
               res[k] = t[i]
               first = False
            else:
               res[k] = Snorm(res[k], t[i])
   return res

def matrixMinimax(x, y, a, b, c, Tnorm, Snorm):
   res = mp.zeros(a, c)
   for i in range (0, a):
      for j in range (0, c):
         first = True
         for k in range (0, b):
            t = Tnorm(x[i, k], y[k, j])
            if first:
               res[i, j] = t
               first = False
            else:
               res[i, j] = Snorm(res[i, j], t)
   return res

def pertinencia(x):
   if x >= 1:
      return 1
   if x <= 0:
      return 0
   return x

def Tmin(x, y):
   if x <= y:
      return x
   return y

def Talg(x, y):
   a, b = pertinencia(x), pertinencia(y)
   return a * b

def Tbound(x, y):
   a, b = pertinencia(x), pertinencia(y)
   return Smax(0, a + b - 1)

def Tdrastic(x, y):
   a, b = pertinencia(x), pertinencia(y)
   if mp.fabs(b - 1) < 1e-9:
      return a
   if mp.fabs(a - 1) < 1e-9:
      return b
   return 0

def Smax(x, y):
   if x <= y:
      return y
   return x

def Salg(x, y):
   a, b = pertinencia(x), pertinencia(y)
   return a + b - a * b

def Sbound(x, y):
   a, b = pertinencia(x), pertinencia(y)
   return Tmin(1, a + b)

def Sdrastic(x, y):
   a, b = pertinencia(x), pertinencia(y)
   if mp.fabs(b) < 1e-9:
      return a
   if mp.fabs(a) < 1e-9:
      return b
   return 1

def demo(n, M, Tnorm, Snorm):
   u = mp.zeros(n, 1)
   v = mp.zeros(n, 1)
   w = mp.zeros(n, 1)
   for i in range (0, n):
      u[i] = random.randrange(1000)/1000
      v[i] = random.randrange(1000)/1000
      w[i] = random.randrange(1000)/1000
   print("")
   print("n =", n)
   print("u =", u.T)
   print("v =", v.T)
   print("w =", w.T)
   z1 = minimax(u, v, M, n, Tnorm, Snorm)
   print("uv =", z1.T)
   z1 = minimax(z1, w, M, n, Tnorm, Snorm)
   z2 = minimax(u, minimax(v, w, M, n, Tnorm, Snorm), M, n, Tnorm, Snorm)
   z3 = z2 - z1
   print("(uv)w - u(vw) =", z3.T)
   a = random.randrange(8) + 1
   b = random.randrange(8) + 1
   c = random.randrange(8) + 1
   x = mp.zeros(a, b)
   y = mp.zeros(b, c)
   for i in range (0, a):
      for j in range (0, b):
         x[i, j] = random.randrange(1000)/1000
   for i in range (0, b):
      for j in range (0, c):
         y[i, j] = random.randrange(1000)/1000
   z = matrixMinimax(x, y, a, b, c, Tnorm, Snorm)
   print("x =", x)
   print("y =", y)
   print("xy =", z)
   return

def isZero(x, n, delta):
   for i in range (0, n):
      if mp.fabs(x[i]) > delta:
         return False
   return True

def transpose(x):
   return x.T

def my_round(x):
   y = mp.fabs(x)
   if mp.fabs(y - mp.floor(y)) < 0.5:
      return mp.sign(x) * mp.floor(y)
   else:
      return mp.sign(x) * mp.ceil(y)

def my_int(x):
   y = int(my_round(x))
   return y

mp.dps = 10
n = 4
M = np.zeros((n, n, n))
M[0, 0, 0], M[1, 2, 0] = 1, 1
M[0, 1, 1], M[1, 3, 1] = 1, 1
M[2, 0, 2], M[3, 2, 2] = 1, 1
M[2, 1, 3], M[3, 3, 3] = 1, 1
# (a, b) (x, y) = (ax + bz, ay + bw)
# (c, d) (z, w)   (cx + dz, cy + dw)
print("")
print("minimax")
demo(n, M, Tmin, Smax)
print("")
print("algebraic")
demo(n, M, Talg, Salg)
print("")
print("bounded")
demo(n, M, Tbound, Sbound)
print("")
print("drastic")
demo(n, M, Tdrastic, Sdrastic)

n = 9
M = np.zeros((n, n, n))
M[0, 0, 0], M[1, 3, 0], M[2, 6, 0] = 1, 1, 1
M[0, 1, 1], M[1, 4, 1], M[2, 7, 1] = 1, 1, 1
M[0, 2, 2], M[1, 5, 2], M[2, 8, 2] = 1, 1, 1
M[3, 0, 3], M[4, 3, 3], M[5, 6, 3] = 1, 1, 1
M[3, 1, 4], M[4, 4, 4], M[5, 7, 4] = 1, 1, 1
M[3, 2, 5], M[4, 5, 5], M[5, 8, 5] = 1, 1, 1
M[6, 0, 6], M[7, 3, 6], M[8, 6, 6] = 1, 1, 1
M[6, 1, 7], M[7, 4, 7], M[8, 7, 7] = 1, 1, 1
M[6, 2, 8], M[7, 5, 8], M[8, 8, 8] = 1, 1, 1
print("")
print("minimax")
demo(n, M, Tmin, Smax)
print("")
print("algebraic")
demo(n, M, Talg, Salg)
print("")
print("bounded")
demo(n, M, Tbound, Sbound)
print("")
print("drastic")
demo(n, M, Tdrastic, Sdrastic)

# Release 0.1 from 2021/Fev/22
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.
