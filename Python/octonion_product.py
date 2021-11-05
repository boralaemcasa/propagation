# https://pbs.twimg.com/media/Eul7nMjXcAQJoTX?format=png&name=small
# https://pbs.twimg.com/media/EuiHYmsXEAItKk8?format=png&name=900x900

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

def demo(n, M):
   u = mp.zeros(n, 1)
   v = mp.zeros(n, 1)
   w = mp.zeros(n, 1)
   for i in range (0, n):
     u[i] = random.randrange(120)/10
     if random.randrange(2) == 0:
        u[i] = - u[i]
     v[i] = random.randrange(120)/10
     if random.randrange(2) == 0:
        v[i] = - v[i]
     w[i] = random.randrange(120)/10
     if random.randrange(2) == 0:
        w[i] = - w[i]
   print("")
   print("n =", n)
   print("u =", u.T)
   print("v =", v.T)
   print("w =", w.T)
   z1 = product(u, v, M, n)
   print("uv =", z1.T)
   z1 = product(z1, w, M, n)
   z2 = product(u, product(v, w, M, n), M, n)
   z3 = z2 - z1
   print("(uv)w - u(vw) =", z3.T)
   print("")
   print("|u| =", fabs_oct(n, u))
   print("1/u =", transpose(inverse_oct(n, u)))
   print("u^2 =", transpose(pow_oct(M, n, u, 2)))
   print("sqrt u =", transpose(sqrt_oct(M, n, u)))
   print("exp u =", transpose(exp_oct(M, n, u)))
   print("ln u =", transpose(ln_oct(M, n, u)))
   print("sin u =", transpose(sin_oct(M, n, u)))
   print("cos u =", transpose(cos_oct(M, n, u)))
   print("tan u =", transpose(tan_oct(M, n, u)))
   print("arctan u =", transpose(arctan_oct(M, n, u)))
   print("arccos u =", transpose(arccos_oct(M, n, u)))
   return

def arctan_oct(M, n, x): # integral from 0 to T of Id/(Id + M^2) dM around i and -i
   T = mp.zeros(n, 1)
   for i in range (0, n):
      T[i] = x[i]
   tmp = T[1]
   T[1] = 0
   intz = mp.zeros(n, 1)
   if isZero(T, n, 1e-9) and (mp.fabs(tmp) - 1 < 1e-9): # 0, \pm 1, 0, 0
      return 1e100 * ID(n) # infty
   normal = True
   if isZero(T, n, 1e-9) and (mp.fabs(tmp) > 1): # 0, k, 0, 0
      normal = False # int_0^2i = int_0^1 + int_1^2i = pi/4 + int_1^T
   T[1] = tmp
   h = 2e-2
   ti = h
   zd = mp.zeros(n, 1)
   if normal:
      for i in range (0, n):
         zd[i] = T[i]
   else:
      zd[0] = -1
      zd[1] = T[1] # (- 1, q, 0, 0)
   while ti <= 1:
      if normal:
         #ti = 0 => zi = (0, 0, 0, 0)
         #ti = 1 => zi = (p, q, r, s)
         zi = ti * T
      else:
         #ti = 0 => zi = (1, 0, 0, 0)
         #ti = 1 => zi = (0, q, 0, 0)
         zi = mp.zeros(n, 1)
         zi[0] = 1 - ti
         zi[1] = T[1] * ti
      intz = intz + h * product(inverse_oct(n, ID(n) + pow_oct(M, n, zi, 2)), zd, M, n)
      ti = ti + h
   if not normal:
      intz = intz + mp.pi()/4 * ID(n)
   ti = fabs_oct(n, tan_oct(M, n, intz) - x)
   T[0] = intz[0]
   for i in range (1, n):
      T[i] = - intz[i]
   if fabs_oct(n, tan_oct(M, n, T) - x) < ti:
      return T
   return intz

def sin_oct(M, n, x):
   # sin x = x - x^3/3! + x^5/5! - x^7/7! + ...
   res = 0
   s = 1
   xx = x
   fat = 1
   for i in range (1, 100):
      termo = s/fat * xx
      res = res + termo
      if fabs_oct(n, termo) < 1e-5:
         break
      s = - s
      xx = product(product(xx, x, M, n), x, M, n)
      fat = fat * (2 * i) * (2 * i + 1)
   return res

def cos_oct(M, n, x):
   # cos x = 1 - x^2/2! + x^4/4! - x^6/6! + ...
   res = 0
   s = 1
   xx = ID(n)
   fat = 1
   for i in range (1, 100):
      termo = s/fat * xx
      res = res + termo
      if fabs_oct(n, termo) < 1e-5:
         break
      s = - s
      xx = product(product(xx, x, M, n), x, M, n)
      fat = fat * (2 * i - 1) * (2 * i)
   return res

def tan_oct(M, n, x):
   return product(sin_oct(M, n, x), inverse_oct(n, cos_oct(M, n, x)), M, n)

def pow_oct(M, n, x, y):
   y = mp.re(y)
   if mp.fabs(y - my_round(y)) > 1e-9:
      return exp_oct(M, n, product(c_to_h(y, n), ln_oct(M, n, x), M, n))

   if y < 0:
      y = -y
      x = inverse_oct(n, x)
   res = ID(n)
   for i in range (1, my_int(y + 1)):
      res = product(res, x, M, n)
   return res

def exp_oct(M, n, x):
   # exp x = 1 + x + x^2/2! + x^3/3! + x^4/4! + ...
   res = 0
   xx = ID(n)
   fat = 1
   for i in range (1, 100):
      termo = 1/fat * xx
      res = res + termo
      if fabs_oct(n, termo) < 1e-5:
         break
      xx = product(xx, x, M, n)
      fat = fat * i
   return res

def ln_oct(M, n, x): # integral from Id to T of M^(-1) dM
   T = mp.zeros(n, 1)
   for i in range (0, n):
      T[i] = x[i]
   intz = mp.zeros(n, 1)
   if isZero(T, n, 1e-9):
      return 1e100 * ID(n) # infty
   tmp = T[0]
   T[0] = 0
   normal = True
   if isZero(T, n, 1e-9) and (tmp < 0): # k, 0, 0, 0
      normal = False # ln (-2) = j * pi + ln 2
      T[0] = - tmp
   else:
      T[0] = tmp
   h = 2e-2
   ti = h
   zd = mp.zeros(n, 1)
   for i in range (1, n):
      zd[i] = T[i]
   zd[0] = T[0] - 1
   while ti <= 1:
      #ti = 0 => zi = (1, 0, 0, 0)
      #ti = 1 => zi = (p, q, r, s)
      zi = ti * T
      zi[0] = (T[0] - 1) * ti + 1
      intz = intz + h * product(inverse_oct(n, zi), zd, M, n)
      ti = ti + h
   if not normal:
      T = mp.zeros(n, 1)
      T[1] = mp.pi()
      intz = intz + T
   return intz

def arccos_oct(M, n, T):
   X = arctan_oct(M, n, product(sqrt_oct(M, n, ID(n) - pow_oct(M, n, T, 2)), inverse_oct(n, T), M, n))
   if isZero(cos_oct(M, n, X) - T, n, 1e-4):
      return X
   return X + mp.pi() * ID(n)

def sqrt_oct(M, n, x):
   return pow_oct(M, n, x, 0.5)

def inverse_oct(n, z):
   # 1/z = bar(z) / |z|^2
   bar = mp.zeros(n, 1)
   bar[0] = z[0]
   r = power(z[0], 2)
   for i in range (1, n):
      bar[i] = - z[i]
      r = r + power(z[i], 2)
   return bar/r

def fabs_oct(n, z):
   r = 0
   for i in range (0, n):
      r = r + power(z[i], 2)
   return mp.sqrt(r)

def isZero(x, n, delta):
   for i in range (0, n):
      if mp.fabs(x[i]) > delta:
         return False
   return True

def c_to_h(z, n):
   res = mp.zeros(n, 1)
   res[0] = mp.re(z)
   res[1] = mp.im(z)
   return res

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

def my_new_octonion(a, b, c, d, e, f, g, h):
   T = mp.zeros(8, 8)
   T[0, 0], T[0, 1], T[0, 2], T[0, 3], T[0, 4], T[0, 5], T[0, 6], T[0, 7] = a,   -b,  -c,  -d,   -e,   -f,  -g,   -h
   T[1, 0], T[1, 1], T[1, 2], T[1, 3], T[1, 4], T[1, 5], T[1, 6], T[1, 7] = b,    a,  -d,   c,   -f,    e,   h,   -g
   T[2, 0], T[2, 1], T[2, 2], T[2, 3], T[2, 4], T[2, 5], T[2, 6], T[2, 7] = c,    d,   a,  -b,   -g,   -h,   e,    f
   T[3, 0], T[3, 1], T[3, 2], T[3, 3], T[3, 4], T[3, 5], T[3, 6], T[3, 7] = d,   -c,   b,   a,   -h,    g,  -f,    e
   T[4, 0], T[4, 1], T[4, 2], T[4, 3], T[4, 4], T[4, 5], T[4, 6], T[4, 7] = e,    f,   g,   h,    a,   -b,  -c,   -d
   T[5, 0], T[5, 1], T[5, 2], T[5, 3], T[5, 4], T[5, 5], T[5, 6], T[5, 7] = f,   -e,   h,  -g,    b,    a,   d,   -c
   T[6, 0], T[6, 1], T[6, 2], T[6, 3], T[6, 4], T[6, 5], T[6, 6], T[6, 7] = g,   -h,  -e,   f,    c,   -d,   a,    b
   T[7, 0], T[7, 1], T[7, 2], T[7, 3], T[7, 4], T[7, 5], T[7, 6], T[7, 7] = h,    g,  -f,  -e,    d,    c,  -b,    a
   return T

def my_new_sedenion(a, b, c, d, e, f, g, h, i, j, k, L, m, n, o, p):
   T = mp.zeros(16, 16)
   T[0,0], T[0,1], T[0,2], T[0,3], T[0,4], T[0,5], T[0,6], T[0,7], T[0,8], T[0,9], T[0,10], T[0,11], T[0,12], T[0,13], T[0,14], T[0,15]  =   a,  -b,  -c,  -d,  -e,  -f,  -g,  -h,  -i,  -j,   -k,  -L,  -m,  -n,  -o,  -p
   T[1,0], T[1,1], T[1,2], T[1,3], T[1,4], T[1,5], T[1,6], T[1,7], T[1,8], T[1,9], T[1,10], T[1,11], T[1,12], T[1,13], T[1,14], T[1,15]  =   b,   a,  -d,   c,  -f,   e,   h,  -g,  -j,   i,    L,  -k,   n,  -m,  -p,   o
   T[2,0], T[2,1], T[2,2], T[2,3], T[2,4], T[2,5], T[2,6], T[2,7], T[2,8], T[2,9], T[2,10], T[2,11], T[2,12], T[2,13], T[2,14], T[2,15]  =   c,   d,   a,  -b,  -g,  -h,   e,   f,  -k,  -L,    i,   j,   o,   p,  -m,  -n
   T[3,0], T[3,1], T[3,2], T[3,3], T[3,4], T[3,5], T[3,6], T[3,7], T[3,8], T[3,9], T[3,10], T[3,11], T[3,12], T[3,13], T[3,14], T[3,15]  =   d,  -c,   b,   a,  -h,   g,  -f,   e,  -L,   k,   -j,   i,   p,  -o,   n,  -m
   T[4,0], T[4,1], T[4,2], T[4,3], T[4,4], T[4,5], T[4,6], T[4,7], T[4,8], T[4,9], T[4,10], T[4,11], T[4,12], T[4,13], T[4,14], T[4,15]  =   e,   f,   g,   h,   a,  -b,  -c,  -d,  -m,  -n,   -o,  -p,   i,   j,   k,   L
   T[5,0], T[5,1], T[5,2], T[5,3], T[5,4], T[5,5], T[5,6], T[5,7], T[5,8], T[5,9], T[5,10], T[5,11], T[5,12], T[5,13], T[5,14], T[5,15]  =   f,  -e,   h,  -g,   b,   a,   d,  -c,  -n,   m,   -p,   o,  -j,   i,  -L,   k
   T[6,0], T[6,1], T[6,2], T[6,3], T[6,4], T[6,5], T[6,6], T[6,7], T[6,8], T[6,9], T[6,10], T[6,11], T[6,12], T[6,13], T[6,14], T[6,15]  =   g,  -h,  -e,   f,   c,  -d,   a,   b,  -o,   p,    m,  -n,  -k,   L,   i,  -j
   T[7,0], T[7,1], T[7,2], T[7,3], T[7,4], T[7,5], T[7,6], T[7,7], T[7,8], T[7,9], T[7,10], T[7,11], T[7,12], T[7,13], T[7,14], T[7,15]  =   h,   g,  -f,  -e,  -d,   c,  -b,   a,  -p,  -o,    n,   m,  -L,  -k,   j,   i
   T[8,0], T[8,1], T[8,2], T[8,3], T[8,4], T[8,5], T[8,6], T[8,7], T[8,8], T[8,9], T[8,10], T[8,11], T[8,12], T[8,13], T[8,14], T[8,15]  =   i,   j,   k,   L,   m,   n,   o,   p,   a,  -b,   -c,  -d,  -e,  -f,  -g,  -h
   T[9,0], T[9,1], T[9,2], T[9,3], T[9,4], T[9,5], T[9,6], T[9,7], T[9,8], T[9,9], T[9,10], T[9,11], T[9,12], T[9,13], T[9,14], T[9,15]  =   j,  -i,   L,  -k,   n,  -m,  -p,   o,   b,   a,    d,  -c,   f,  -e,  -h,   g
   T[10,0],T[10,1],T[10,2],T[10,3],T[10,4],T[10,5],T[10,6],T[10,7],T[10,8],T[10,9],T[10,10],T[10,11],T[10,12],T[10,13],T[10,14],T[10,15] =   k,  -L,  -i,   j,   o,   p,  -m,  -n,   c,  -d,    a,   b,   g,   h,  -e,  -f
   T[11,0],T[11,1],T[11,2],T[11,3],T[11,4],T[11,5],T[11,6],T[11,7],T[11,8],T[11,9],T[11,10],T[11,11],T[11,12],T[11,13],T[11,14],T[11,15] =   L,   k,  -j,  -i,   p,  -o,   n,  -m,   d,   c,   -b,   a,   h,  -g,   f,  -e
   T[12,0],T[12,1],T[12,2],T[12,3],T[12,4],T[12,5],T[12,6],T[12,7],T[12,8],T[12,9],T[12,10],T[12,11],T[12,12],T[12,13],T[12,14],T[12,15] =   m,  -n,  -o,  -p,  -i,   j,   k,   L,   e,  -f,   -g,  -h,   a,   b,   c,   d
   T[13,0],T[13,1],T[13,2],T[13,3],T[13,4],T[13,5],T[13,6],T[13,7],T[13,8],T[13,9],T[13,10],T[13,11],T[13,12],T[13,13],T[13,14],T[13,15] =   n,   m,  -p,   o,  -j,  -i,  -L,   k,   f,   e,   -h,   g,  -b,   a,  -d,   c
   T[14,0],T[14,1],T[14,2],T[14,3],T[14,4],T[14,5],T[14,6],T[14,7],T[14,8],T[14,9],T[14,10],T[14,11],T[14,12],T[14,13],T[14,14],T[14,15] =   o,   p,   m,  -n,  -k,   L,  -i,  -j,   g,   h,    e,  -f,  -c,   d,   a,  -b
   T[15,0],T[15,1],T[15,2],T[15,3],T[15,4],T[15,5],T[15,6],T[15,7],T[15,8],T[15,9],T[15,10],T[15,11],T[15,12],T[15,13],T[15,14],T[15,15] =   p,  -o,   n,   m,  -L,  -k,   j,  -i,   h,  -g,    f,   e,  -d,  -c,   b,   a
   return T

mp.dps = 10
n = 2
M = np.zeros((n, n, n))
M[0, 0, 0], M[1, 1, 0], M[0, 1, 1], M[1, 0, 1] = 1, -1, 1, 1
# (a + bi)(x + yi) = (ab - xy, ay + bx) = ((a,b)^T M_1 (x,y), (a,b)^T M_2 (x,y))
demo(n, M)

n = 4
M = np.zeros((n, n, n))
M[0, 0, 0], M[1, 1, 0], M[2, 2, 0], M[3, 3, 0] = 1, -1, -1, -1
M[0, 1, 1], M[1, 0, 1], M[2, 3, 1], M[3, 2, 1] = 1,  1,  1, -1
M[0, 2, 2], M[1, 3, 2], M[2, 0, 2], M[3, 1, 2] = 1, -1,  1,  1
M[0, 3, 3], M[1, 2, 3], M[2, 1, 3], M[3, 0, 3] = 1,  1, -1,  1
# (a + bi + cj + dk)(x + yi + zj + wk) = ax - by - cz - dw + i(ay + bx + cw - dz)
#                                   + j(az - bw + cx + dy) + k(aw + bz - cy + dx)
demo(n, M)

n = 8
M = np.zeros((n, n, n))
M[0,0,0], M[1,1,0], M[2,2,0], M[3,3,0], M[4,4,0], M[5,5,0], M[6,6,0], M[7,7,0] =  1, -1, -1, -1, -1, -1, -1, -1
M[0,1,1], M[1,0,1], M[2,3,1], M[3,2,1], M[4,5,1], M[5,4,1], M[6,7,1], M[7,6,1] =  1,  1,  1, -1,  1, -1, -1,  1
M[0,2,2], M[1,3,2], M[2,0,2], M[3,1,2], M[4,6,2], M[5,7,2], M[6,4,2], M[7,5,2] =  1, -1,  1,  1,  1,  1, -1, -1
M[0,3,3], M[1,2,3], M[2,1,3], M[3,0,3], M[4,7,3], M[5,6,3], M[6,5,3], M[7,4,3] =  1,  1, -1,  1,  1, -1,  1, -1
M[0,4,4], M[1,5,4], M[2,6,4], M[3,7,4], M[4,0,4], M[5,1,4], M[6,2,4], M[7,3,4] =  1, -1, -1, -1,  1,  1,  1,  1
M[0,5,5], M[1,4,5], M[2,7,5], M[3,6,5], M[4,1,5], M[5,0,5], M[6,3,5], M[7,2,5] =  1,  1, -1,  1, -1,  1, -1,  1
M[0,6,6], M[1,7,6], M[2,4,6], M[3,5,6], M[4,2,6], M[5,3,6], M[6,0,6], M[7,1,6] =  1,  1,  1, -1, -1,  1,  1, -1
M[0,7,7], M[1,6,7], M[2,5,7], M[3,4,7], M[4,3,7], M[5,2,7], M[6,1,7], M[7,0,7] =  1, -1,  1,  1, -1, -1,  1,  1
# (a_0 e_0 + ... + a_7 e_7)(x_0 e_0 + ... + x_7 e_7) =
#    e_0 (a_0 x_0 - a_1 x_1 - a_2 x_2 - a_3 x_3 - a_4 x_4 - a_5 x_5 - a_6 x_6 - a_7 x_7)
#  + e_1 (a_0 x_1 + a_1 x_0 - a_2 x_3 + a_3 x_2 - a_4 x_5 + a_5 x_4 + a_6 x_7 - a_7 x_6)
#  + e_2 (a_0 x_2 + a_1 x_3 + a_2 x_0 - a_3 x_1 - a_4 x_6 - a_5 x_7 + a_6 x_4 + a_7 x_5)
#  + e_3 (a_0 x_3 - a_1 x_2 + a_2 x_1 + a_3 x_0 - a_4 x_7 + a_5 x_6 - a_6 x_5 + a_7 x_4)
#  + e_4 (a_0 x_4 + a_1 x_5 + a_2 x_6 + a_3 x_7 + a_4 x_0 - a_5 x_1 - a_6 x_2 - a_7 x_3)
#  + e_5 (a_0 x_5 - a_1 x_4 + a_2 x_7 - a_3 x_6 + a_4 x_1 + a_5 x_0 + a_6 x_3 - a_7 x_2)
#  + e_6 (a_0 x_6 - a_1 x_7 - a_2 x_4 + a_3 x_5 + a_4 x_2 - a_5 x_3 + a_6 x_0 + a_7 x_1)
#  + e_7 (a_0 x_7 + a_1 x_6 - a_2 x_5 - a_3 x_4 + a_4 x_3 + a_5 x_2 - a_6 x_1 + a_7 x_0)

demo(n, M)

#if:   x1 = 2a_1 h                       a1 = 1    x1 = 4
#      x2 = 2a_2 h                       a2 = 3    x2 = 12
#      x3 = 2a_3 h                       a3 = 5    x3 = 20
#      x4 = 2a_4 h                       a4 = 7    x4 = 28
#      x5 = 2a_5 h                       a5 = 11   x5 = 44
#      x6 = 2a_6 h                       a6 = 13   x6 = 52
#      x7 = 2a_7 h                       a7 = 17   x7 = 68
#      x8 = a1^2 + ... + a7^2 - h^2      h = 2     x8 = 1 + 9 + 25 + 49 + 121 + 169 + 289 - 4 = 663 - 4 = 659
#      y = a1^2 + ... + a7^2 + h^2                  y = 1 + 9 + 25 + 49 + 121 + 169 + 289 + 4 = 663 + 4 = 667
#then: x1^2 + ... + x8^2 == y^2

T = mp.zeros(n, n)
Id = mp.zeros(n, n)
v = matrix([4,12,20,28,44,52,68,659])
for k in range (0, n):
   e = mp.zeros(n, 1)
   e[k] = 1 # canonical
   w = product(v, e, M, n)
   for i in range (0, n):
      T[i, k] = w[i]
      if i == k:
         Id[i, k] = 1
print("Ortogonal:")
print(T)
print("Good product. T * Transpose = k * Id:")
print(T * T.T - 444889 * Id)

n = 16
M = np.zeros((n, n, n))                                                                                                                                                      #  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15
M[0,0,0],  M[1,1,0],  M[2,2,0],  M[3,3,0],  M[4,4,0],  M[5,5,0],  M[6,6,0],  M[7,7,0],  M[8,8,0], M[9,9,0], M[10,10,0],M[11,11,0],M[12,12,0],M[13,13,0],M[14,14,0],M[15,15,0] = 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
M[0,1,1],  M[1,0,1],  M[2,3,1],  M[3,2,1],  M[4,5,1],  M[5,4,1],  M[6,7,1],  M[7,6,1],  M[8,9,1], M[9,8,1], M[10,11,1],M[11,10,1],M[12,13,1],M[13,12,1],M[14,15,1],M[15,14,1] = 1,+1,+1,-1,+1,-1,-1,+1,+1,-1,-1,+1,-1,+1,+1,-1
M[0,2,2],  M[1,3,2],  M[2,0,2],  M[3,1,2],  M[4,6,2],  M[5,7,2],  M[6,4,2],  M[7,5,2],  M[8,10,2],M[9,11,2],M[10,8,2], M[11,9,2], M[12,14,2],M[13,15,2],M[14,12,2],M[15,13,2] = 1,-1,+1,+1,+1,+1,-1,-1,+1,+1,-1,-1,-1,-1,+1,+1
M[0,3,3],  M[1,2,3],  M[2,1,3],  M[3,0,3],  M[4,7,3],  M[5,6,3],  M[6,5,3],  M[7,4,3],  M[8,11,3],M[9,10,3],M[10,9,3], M[11,8,3], M[12,15,3],M[13,14,3],M[14,13,3],M[15,12,3] = 1,+1,-1,+1,+1,-1,+1,-1,+1,-1,+1,-1,-1,+1,-1,+1
M[0,4,4],  M[1,5,4],  M[2,6,4],  M[3,7,4],  M[4,0,4],  M[5,1,4],  M[6,2,4],  M[7,3,4],  M[8,12,4],M[9,13,4],M[10,14,4],M[11,15,4],M[12,8,4], M[13,9,4], M[14,10,4],M[15,11,4] = 1,-1,-1,-1,+1,+1,+1,+1,+1,+1,+1,+1,-1,-1,-1,-1
M[0,5,5],  M[1,4,5],  M[2,7,5],  M[3,6,5],  M[4,1,5],  M[5,0,5],  M[6,3,5],  M[7,2,5],  M[8,13,5],M[9,12,5],M[10,15,5],M[11,14,5],M[12,9,5], M[13,8,5], M[14,11,5],M[15,10,5] = 1,+1,-1,+1,-1,+1,-1,+1,+1,-1,+1,-1,+1,-1,+1,-1
M[0,6,6],  M[1,7,6],  M[2,4,6],  M[3,5,6],  M[4,2,6],  M[5,3,6],  M[6,0,6],  M[7,1,6],  M[8,14,6],M[9,15,6],M[10,12,6],M[11,13,6],M[12,10,6],M[13,11,6],M[14,8,6], M[15,9,6]  = 1,+1,+1,-1,-1,+1,+1,-1,+1,-1,-1,+1,+1,-1,-1,+1
M[0,7,7],  M[1,6,7],  M[2,5,7],  M[3,4,7],  M[4,3,7],  M[5,2,7],  M[6,1,7],  M[7,0,7],  M[8,15,7],M[9,14,7],M[10,13,7],M[11,12,7],M[12,11,7],M[13,10,7],M[14,9,7], M[15,8,7]  = 1,-1,+1,-1,-1,-1,+1,+1,+1,+1,-1,-1,+1,+1,-1,-1
M[0,8,8],  M[1,9,8],  M[2,10,8], M[3,11,8], M[4,12,8], M[5,13,8], M[6,14,8], M[7,15,8], M[8,0,8], M[9,1,8], M[10,2,8], M[11,3,8], M[12,4,8], M[13,5,8], M[14,6,8], M[15,7,8]  = 1,-1,-1,-1,-1,-1,-1,-1,+1,+1,+1,+1,+1,+1,+1,+1
M[0,9,9],  M[1,8,9],  M[2,11,9], M[3,10,9], M[4,13,9], M[5,12,9], M[6,15,9], M[7,14,9], M[8,1,9], M[9,0,9], M[10,3,9], M[11,2,9], M[12,5,9], M[13,4,9], M[14,7,9], M[15,6,9]  = 1,+1,-1,+1,-1,+1,+1,-1,-1,+1,-1,+1,-1,+1,+1,-1
M[0,10,10],M[1,11,10],M[2,8,10], M[3,9,10], M[4,14,10],M[5,15,10],M[6,12,10],M[7,13,10],M[8,2,10],M[9,3,10],M[10,0,10],M[11,1,10],M[12,6,10],M[13,7,10],M[14,4,10],M[15,5,10] = 1,+1,+1,-1,-1,-1,+1,+1,-1,+1,+1,-1,-1,-1,+1,+1
M[0,11,11],M[1,10,11],M[2,9,11], M[3,8,11], M[4,15,11],M[5,14,11],M[6,13,11],M[7,12,11],M[8,3,11],M[9,2,11],M[10,1,11],M[11,0,11],M[12,7,11],M[13,6,11],M[14,5,11],M[15,4,11] = 1,-1,+1,+1,-1,+1,-1,+1,-1,-1,+1,+1,-1,+1,-1,+1
M[0,12,12],M[1,13,12],M[2,14,12],M[3,15,12],M[4,8,12], M[5,9,12], M[6,10,12],M[7,11,12],M[8,4,12],M[9,5,12],M[10,6,12],M[11,7,12],M[12,0,12],M[13,1,12],M[14,2,12],M[15,3,12] = 1,+1,+1,+1,+1,-1,-1,-1,-1,+1,+1,+1,+1,-1,-1,-1
M[0,13,13],M[1,12,13],M[2,15,13],M[3,14,13],M[4,9,13], M[5,8,13], M[6,11,13],M[7,10,13],M[8,5,13],M[9,4,13],M[10,7,13],M[11,6,13],M[12,1,13],M[13,0,13],M[14,3,13],M[15,2,13] = 1,-1,+1,-1,+1,+1,+1,-1,-1,-1,+1,-1,+1,+1,+1,-1
M[0,14,14],M[1,15,14],M[2,12,14],M[3,13,14],M[4,10,14],M[5,11,14],M[6,8,14], M[7,9,14], M[8,6,14],M[9,7,14],M[10,4,14],M[11,5,14],M[12,2,14],M[13,3,14],M[14,0,14],M[15,1,14] = 1,-1,-1,+1,+1,-1,+1,+1,-1,-1,-1,+1,+1,-1,+1,+1
M[0,15,15],M[1,14,15],M[2,13,15],M[3,12,15],M[4,11,15],M[5,10,15],M[6,9,15], M[7,8,15], M[8,7,15],M[9,6,15],M[10,5,15],M[11,4,15],M[12,3,15],M[13,2,15],M[14,1,15],M[15,0,15] = 1,+1,-1,-1,+1,+1,-1,+1,-1,+1,-1,-1,+1,+1,-1,+1
# (a_0 e_0 + ... + a_15 e_15)(x_0 e_0 + ... + x_15 e_15) =
#    e_0  (a_0 x_0 - a_1 x_1 - a_2 x_2 - a_3 x_3 - a_4 x_4 - a_5 x_5 - a_6 x_6 - a_7 x_7 - a_8 x_8 - a_9 x_9 - a_10 x_10- a_11 x_11- a_12 x_12- a_13 x_13- a_14 x_14- a_15 x_15)
#  + e_1  (a_0 x_1 + a_1 x_0 - a_2 x_3 + a_3 x_2 - a_4 x_5 + a_5 x_4 + a_6 x_7 - a_7 x_6 - a_8 x_9 + a_9 x_8 + a_10 x_11- a_11 x_10+ a_12 x_13- a_13 x_12- a_14 x_15+ a_15 x_14)
#  + e_2  (a_0 x_2 + a_1 x_3 + a_2 x_0 - a_3 x_1 - a_4 x_6 - a_5 x_7 + a_6 x_4 + a_7 x_5 - a_8 x_10- a_9 x_11+ a_10 x_8 + a_11 x_9 + a_12 x_14+ a_13 x_15- a_14 x_12- a_15 x_13)
#  + e_3  (a_0 x_3 - a_1 x_2 + a_2 x_1 + a_3 x_0 - a_4 x_7 + a_5 x_6 - a_6 x_5 + a_7 x_4 - a_8 x_11+ a_9 x_10- a_10 x_9 + a_11 x_8 + a_12 x_15- a_13 x_14+ a_14 x_13- a_15 x_12)
#  + e_4  (a_0 x_4 + a_1 x_5 + a_2 x_6 + a_3 x_7 + a_4 x_0 - a_5 x_1 - a_6 x_2 - a_7 x_3 - a_8 x_12- a_9 x_13- a_10 x_14- a_11 x_15+ a_12 x_8 + a_13 x_9 + a_14 x_10+ a_15 x_11)
#  + e_5  (a_0 x_5 - a_1 x_4 + a_2 x_7 - a_3 x_6 + a_4 x_1 + a_5 x_0 + a_6 x_3 - a_7 x_2 - a_8 x_13+ a_9 x_12- a_10 x_15+ a_11 x_14- a_12 x_9 + a_13 x_8 - a_14 x_11+ a_15 x_10)
#  + e_6  (a_0 x_6 - a_1 x_7 - a_2 x_4 + a_3 x_5 + a_4 x_2 - a_5 x_3 + a_6 x_0 + a_7 x_1 - a_8 x_14+ a_9 x_15+ a_10 x_12- a_11 x_13- a_12 x_10+ a_13 x_11+ a_14 x_8 - a_15 x_9 )
#  + e_7  (a_0 x_7 + a_1 x_6 - a_2 x_5 - a_3 x_4 + a_4 x_3 + a_5 x_2 - a_6 x_1 + a_7 x_0 - a_8 x_15- a_9 x_14+ a_10 x_13+ a_11 x_12- a_12 x_11- a_13 x_10+ a_14 x_9 + a_15 x_8 )
#  + e_8  (a_0 x_8 + a_1 x_9 + a_2 x_10+ a_3 x_11+ a_4 x_12+ a_5 x_13+ a_6 x_14+ a_7 x_15+ a_8 x_0 - a_9 x_1 - a_10 x_2 - a_11 x_3 - a_12 x_4 - a_13 x_5 - a_14 x_6 - a_15 x_7 )
#  + e_9  (a_0 x_9 - a_1 x_8 + a_2 x_11- a_3 x_10+ a_4 x_13- a_5 x_12- a_6 x_15+ a_7 x_14+ a_8 x_1 + a_9 x_0 + a_10 x_3 - a_11 x_2 + a_12 x_5 - a_13 x_4 - a_14 x_7 + a_15 x_6 )
#  + e_10 (a_0 x_10- a_1 x_11- a_2 x_8 + a_3 x_9 + a_4 x_14+ a_5 x_15- a_6 x_12- a_7 x_13+ a_8 x_2 - a_9 x_3 + a_10 x_0 + a_11 x_1 + a_12 x_6 + a_13 x_7 - a_14 x_4 - a_15 x_5 )
#  + e_11 (a_0 x_11+ a_1 x_10- a_2 x_9 - a_3 x_8 + a_4 x_15- a_5 x_14+ a_6 x_13- a_7 x_12+ a_8 x_3 + a_9 x_2 - a_10 x_1 + a_11 x_0 + a_12 x_7 - a_13 x_6 + a_14 x_5 - a_15 x_4 )
#  + e_12 (a_0 x_12- a_1 x_13- a_2 x_14- a_3 x_15- a_4 x_8 + a_5 x_9 + a_6 x_10+ a_7 x_11+ a_8 x_4 - a_9 x_5 - a_10 x_6 - a_11 x_7 + a_12 x_0 + a_13 x_1 + a_14 x_2 + a_15 x_3 )
#  + e_13 (a_0 x_13+ a_1 x_12- a_2 x_15+ a_3 x_14- a_4 x_9 - a_5 x_8 - a_6 x_11+ a_7 x_10+ a_8 x_5 + a_9 x_4 - a_10 x_7 + a_11 x_6 - a_12 x_1 + a_13 x_0 - a_14 x_3 + a_15 x_2 )
#  + e_14 (a_0 x_14+ a_1 x_15+ a_2 x_12- a_3 x_13- a_4 x_10+ a_5 x_11- a_6 x_8 - a_7 x_9 + a_8 x_6 + a_9 x_7 + a_10 x_4 - a_11 x_5 - a_12 x_2 + a_13 x_3 + a_14 x_0 - a_15 x_1 )
#  + e_15 (a_0 x_15- a_1 x_14+ a_2 x_13+ a_3 x_12- a_4 x_11- a_5 x_10+ a_6 x_9 - a_7 x_8 + a_8 x_7 - a_9 x_6 + a_10 x_5 + a_11 x_4 - a_12 x_3 - a_13 x_2 + a_14 x_1 + a_15 x_0 )

demo(n, M)

#if:   x1  = 2a_1 h                        a1  = 1     x1 = 4
#      x2  = 2a_2 h                        a2  = 2     x2 = 8
#      x3  = 2a_3 h                        a3  = 3     x3 = 12
#      x4  = 2a_4 h                        a4  = 4     x4 = 16
#      x5  = 2a_5 h                        a5  = 5     x5 = 20
#      x6  = 2a_6 h                        a6  = 6     x6 = 24
#      x7  = 2a_7 h                        a7  = 7     x7 = 28
#      x8  = 2a_8 h                        a8  = 8     x7 = 32
#      x9  = 2a_9 h                        a9  = 9     x8 = 36
#      x10 = 2a_10 h                       a10 = 10    x9 = 40
#      x11 = 2a_11 h                       a11 = 11   x10 = 44
#      x12 = 2a_12 h                       a12 = 12   x11 = 48
#      x13 = 2a_13 h                       a13 = 13   x12 = 52
#      x14 = 2a_14 h                       a14 = 14   x13 = 56
#      x15 = 2a_15 h                       a15 = 15   x14 = 60
#      x16 = a1^2 + ... + a15^2 - h^2        h = 2    x15 = 1 + 4 + 9 + 16 + 25 + 36 + 49 + 64 + 81 + 100 + 121 + 144 + 169 + 196 + 225 - 4 = 1240 - 4 = 1236
#      y = a1^2 + ... + a15^2 + h^2                     y = 1240 + 4 = 1244
#then: x1^2 + ... + x16^2 == y^2

T = mp.zeros(n, n)
Id = mp.zeros(n, n)
v = matrix([4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 1236])
for k in range (0, n):
   e = mp.zeros(n, 1)
   e[k] = 1 # canonical
   w = product(v, e, M, n)
   for i in range (0, n):
      T[i, k] = w[i]
      if i == k:
         Id[i, k] = 1
print("Ortogonal:")
print(T)
print("Bad product. T * Transpose != k * Id:")
print(T * T.T - 130576329 * Id)

n = 32 # 'Show must go on!

# Release 0.1 from 2021/Fev/21
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.
