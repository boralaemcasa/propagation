# Your Spirit Guide is at: https://drive.google.com/file/d/1hDxdYpy1mXMhKBnLHHCVO9n-lTJ2_v8j/view?usp=sharing
# Dividing [bi]quaternion by complex is not working. I need a better def powm(T, z)...

from mpmath import *
import numpy as np
import random

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

def my_acosm(T, M, n):
   if n == 4:
      X = my_atan_quaternion(mp.sqrtm(ID(n) - mp.powm(T, 2)) * mp.inverse(T))
      if mp.norm(cosm(X) - T) < 1e-9:
         return X
   else:
      X = arctan_oct(M, n, product(sqrt_oct(M, n, ID(n) - pow_oct(M, n, T, 2)), inverse_oct(n, T), M, n))
      if isZero(cos_oct(M, n, X) - T, n, 1e-4):
         return X
   return X + mp.pi() * ID(n)

def get_matrix_octonion():
   M = np.zeros((8, 8, 8))
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
   return M

def get_matrix_sedenion():
   M = np.zeros((16, 16, 16))                                                                                                                                                      #  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15
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

def my_new_quaternion(a, b, c, d):
   T = mp.zeros(4, 4)
   T[0, 0], T[0, 1], T[0, 2], T[0, 3] = a, -b, -c, -d
   T[1, 0], T[1, 1], T[1, 2], T[1, 3] = b,  a, -d,  c
   T[2, 0], T[2, 1], T[2, 2], T[2, 3] = c,  d,  a, -b
   T[3, 0], T[3, 1], T[3, 2], T[3, 3] = d, -c,  b,  a
   return T

def ID(n):
   if n == 4:
      M = mp.zeros(n, n)
      for i in range (0, n):
         M[i, i] = 1
   else:
      M = mp.zeros(n, 1)
      M[0] = 1
   return M

def c_to_h(z, n):
   if n == 4:
      return my_new_quaternion(mp.re(z), mp.im(z), 0, 0)
   elif n == 8:
      return matrix([mp.re(z), mp.im(z), 0, 0, 0, 0, 0, 0])
   return matrix([mp.re(z), mp.im(z), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])

def my_tanm(T):
   return mp.sinm(T) * mp.inverse(mp.cosm(T))

def quaternion_split(T):
   return T[0,0], T[1,0], T[2,0], T[3,0]

def my_atan_quaternion(T): # integral from 0 to T of Id/(Id + M^2) dM around i and -i
   intz = mp.zeros(4, 4)
   p, q, r, s = quaternion_split(T)
   if (mp.fabs(s) < 1e-9) and (mp.fabs(r) < 1e-9) and (mp.fabs(q) - 1 < 1e-9) and (mp.fabs(p) < 1e-9): # 0, \pm 1, 0, 0
      return 1e100 * ID(n) # infty
   normal = True
   if (mp.fabs(s) < 1e-9) and (mp.fabs(r) < 1e-9) and (mp.fabs(q) > 1) and (mp.fabs(p) < 1e-9): # 0, k, 0, 0
      normal = False # int_0^2i = int_0^1 + int_1^2i = pi/4 + int_1^T
   h = 2e-4
   ti = h
   if normal:
      zd = T
   else:
      zd = my_new_quaternion(- 1, q, 0, 0)
   while ti <= 1:
      if normal:
         #ti = 0 => zi = (0, 0, 0, 0)
         #ti = 1 => zi = (p, q, r, s)
         zi = my_new_quaternion(p * ti, q * ti, r * ti, s * ti)
      else:
         #ti = 0 => zi = (1, 0, 0, 0)
         #ti = 1 => zi = (0, q, 0, 0)
         zi = my_new_quaternion(1 - ti, q * ti, 0, 0)
      intz = intz + mp.inverse(ID(4) + mp.powm(zi, 2)) * zd * h
      ti = ti + h
   if not normal:
      intz = intz + mp.pi()/4 * ID(4)
   return intz

def binom(n, p):
   if (mp.im(p) == 0) and (mp.re(n) < mp.re(p)):
      return 0
   result = 1
   for i in range(0, p):
      result = result * (n - i) / (i + 1)
   return result

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

def gcd(x, y):
   if x < y:
      x, y = y, x
   while(y):
      x, y = y, x % y
   return x

def reduce_fraction(x, y):
   m = gcd(int(x), int(y))
   return int(x/m), int(y/m)

def detect_sqrt(original, repetition = 1e-6, remainder = 1e-9):
   vec = mp.zeros(10240, 1)
   restos = mp.zeros(10240, 1)
   s = original
   fixed = 0
   flag = False
   for counter in range(0, 10240):
      f = mp.floor(s)
      vec[counter] = f
      s = mp.fsub(s, f)
      restos[counter] = s
      if mp.fabs(s) < remainder:
         s = 0
         flag = True
         if (vec[0] == vec[counter]) and (counter > 0):
            counter = counter - 1
         break
      for i in range(0, counter):
         dif = mp.fabs(restos[i] - s)
         if dif < repetition:
            flag = True
            if (i == 0) and (vec[0] == vec[counter]):
               fixed = 0
               counter = counter - 1
            else:
               fixed = i + 1
            #print("dif =", dif)
            break
      if flag:
         break
      s = mp.fdiv(1, s)
   i = counter
   w = mp.zeros(i + 1, 1)
   for j in range(0, i + 1):
      w[j] = vec[j]
   mid = counter - fixed + 1
   if mid > 1:
      if s == 0:
         #if vec[i - 1] != 0:
            #if counter == 1:
               #print("x =", my_int(vec[i-1]), "+ 1/", my_int(vec[i]))
            #else:
               #print("a_1 =", my_int(vec[i-1]), "+ 1/", my_int(vec[i]))
         mid = mid - 1
         i = i - 1
      #else:
         #print("a_1 =", my_int(vec[i]), "+ 1/x")
      for j in range(2, mid):
         i = i - 1
         #print("a_", j, "=", my_int(vec[i]), "+ 1/a_", j - 1)
      #if mid > 1:
         #print("x =", my_int(vec[fixed]), "+ 1/a_", mid - 1)
   #elif s != 0:
      #print("x =", my_int(vec[fixed]), "+ 1/x")
   j = mid
   i = fixed - 1
   #if i == 0:
      #print("y =", my_int(vec[i]), "+ 1/x")
   #elif i != -1:
      #print("a_", j, "=", my_int(vec[i]), "+ 1/x")
      #while (i > 1):
         #i = i - 1
         #j = j + 1
         #print("a_", j, "=", my_int(vec[i]), "+ 1/a_", j - 1)
      #print("y =", my_int(vec[0]), "+ 1/a_", j)

   if s == 0:
      i = counter
      a = vec[i]
      b = 1      # a over 1
      while i > 0:
         i = i - 1
         a, b = b, a
         a = a + b * vec[i]
      #print("x =", my_int(a), "/", my_int(b))
   else:
      i = counter
      a = vec[i]
      b = 1 # ax + 1
      c = 1 # over
      d = 0 # 1x + 0
      # print(a, "x +", b, "//", c, "x +", d)
      while i > fixed:
         i = i - 1
         a, b, c, d = c, d, a, b
         a = mp.fadd(a, mp.fmul(c, vec[i]))
         b = mp.fadd(b, mp.fmul(d, vec[i]))
         # print(a, "x +", b, "//", c, "x +", d)
      #print(my_int(c), "x^2 +", my_int(d - a), "x +", my_int(-b), "= 0") # x (cx + d) = ax + b
      j, a, b, c, d = mp.fadd(power(d - a, 2), mp.fmul(4, mp.fmul(c, b))), a - d, 1, 2*c, 0
      #print("x_1 = (", my_int(a), "+", my_int(b), "sqrt(", my_int(j), "))/(", my_int(c), "+", my_int(d), "sqrt(", my_int(j), "))")
      #print("x_2 = (", my_int(a), "-", my_int(b), "sqrt(", my_int(j), "))/(", my_int(c), "+", my_int(d), "sqrt(", my_int(j), "))")
      while i > 0:
         i = i - 1
         a, b, c, d = c, d, a, b
         a = mp.fadd(a, mp.fmul(c, vec[i]))
         b = mp.fadd(b, mp.fmul(d, vec[i]))
      #if fixed != 0:
         #print("y_1 = (", my_int(a), "+", my_int(b), "sqrt(", my_int(j), "))/(", my_int(c), "+", my_int(d), "sqrt(", my_int(j), "))")
         #print("y_2 = (", my_int(a), "-", my_int(b), "sqrt(", my_int(j), "))/(", my_int(c), "-", my_int(d), "sqrt(", my_int(j), "))")
   if (fixed > 100) or (counter > 100):
      flag = False
   return flag, 1, 1, 1, 1 # a/b + c sqrt(j)

def round_rad(argumento, p):
   return round_deg(argumento/mp.pi() * 180, p)

def round_deg(argumento, p):
   theta = argumento* mp.pi() /180
   if comentar:
      print("theta = ", theta)
   v = mp.tan(theta)
   if comentar:
      print("v = ", v)
   a = p - 1 + p* power(v, 2)
   if comentar:
      print("a = ", a)
   c = power(binom(p,2), 2) + 2 * binom(p,4) + 2 * p * binom(p,3) * power(v, 2)
   if comentar:
      print("c = ", c)
   d = binom(p,2) * power(a, 2) - c
   if comentar:
      print("d = ", d)
   b = 2 * mp.sqrt(d/p)
   if b == 0:
      return
   if comentar:
      print("b = ", b)
   for k in range(2, 3):
      m = mp.tan(theta/p + k * 2 * mp.pi() /p)
      if comentar:
         print("m = ", m)
      tmp = (power(m, 2) - a)/b
      if comentar:
         print("tmp = ", tmp)
      if mp.fabs(tmp) <= 1:
         varphi = p * mp.acos(tmp)
         tau = mp.tan(varphi)
         if comentar:
            print("tau = ", tau)
         r = power(b/2, p)
         if comentar:
            print("r = ", r)
         aa = r * mp.cos(varphi)
         bb = r * mp.sin(varphi)
         cc = my_int(power(b, 2)/4)
         # print(aa, "^2 + ", bb, "^2 = ", cc, "^", p)
         aa2 = power(aa, 2)
         if comentar:
            print("aa2 = ", aa2)
         bb2 = power(bb, 2)
         if comentar:
            print("bb2 = ", bb2)
         f = my_round(aa2)
         g = my_round(bb2)
         h = my_round(power(cc, p))
         dif = mp.fabs(f + g - h)
         if dif < 1e-9:
            # print(int(f), "+", int(g), "=", cc, "^", p)
            angle = argumento + k * 360
            b2 = my_round(power(b, 2))
            threea = my_round(3*a)
            if (mp.fabs(m) < 1e50) and (b2 < 1e50):
               dif = mp.fabs(mp.cos (p * mp.acos( (power(mp.tan (angle/p * mp.pi()/180), 2) - a
                                    )/b
                                  )
                            )) - mp.sqrt(f/h)
               if mp.fabs(dif) < 1e-9:
                  if comentar:
                     if dif != 0:
                        print("debug precision = 1E", int(log(mp.fabs(dif))/log(10)))
                     else:
                        print("debug precision = 0")
                  alfa, beta = reduce_fraction(g, f)
                  gamma = power(alfa + beta, 1/p)
                  if mp.fabs(gamma - my_round(gamma)) > 1e-9:
                     beta, gamma = int(f), h
                     gamma = my_int(power(gamma, 1/p))
                  else:
                     gamma = my_int(gamma)
                  delta, epsilon = reduce_fraction(angle, p)
                  zeta = mp.sqrt(beta)
                  pp = p/2
                  if mp.fabs(pp - my_round(pp)) < 1e-9:
                     pp = int(pp)
                  if mp.sign(aa) > 0:
                     if mp.fabs(b - my_round(b)) < 1e-9:
                        if mp.fabs(zeta - my_round(zeta)) < 1e-9:
                           beta = int(zeta)
                           if epsilon == 1:
                              if gamma == 1:
                                 if mp.fabs(a - my_round(a)) < 1e-9:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))-", beta)
                              else:
                                 if mp.fabs(a - my_round(a)) < 1e-9:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))-", beta, "/", gamma, "^", pp)
                                 else:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/", int(b), "))-", beta, "/", gamma, "^", pp)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/", int(b), "))-", beta, "/", gamma, "^", pp)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/", int(b), "))-", beta, "/", gamma, "^", pp)
                        else:
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))-sqrt(", beta, "/", gamma, "^", p, ")")
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/", int(b), "))-sqrt(", beta, "/", gamma, "^", p, ")")
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/", int(b), "))-sqrt(", beta, "/", gamma, "^", p, ")")
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/", int(b), "))-sqrt(", beta, "/", gamma, "^", p, ")")
                     else:
                        if mp.fabs(zeta - my_round(zeta)) < 1e-9:
                           beta = int(zeta)
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))-", beta, "/", gamma, "^", pp)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))-", beta, "/", gamma, "^", pp)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))-", beta, "/", gamma, "^", pp)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))-", beta, "/", gamma, "^", pp)
                        else:
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))-sqrt(", beta, "/", gamma, "^", p, ")")
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))-sqrt(", beta, "/", gamma, "^", p, ")")
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))-sqrt(", beta, "/", gamma, "^", p, ")")
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))-sqrt(", beta, "/", gamma, "^", p, ")")
                  else:
                     if mp.fabs(b - my_round(b)) < 1e-9:
                        if mp.fabs(zeta - my_round(zeta)) < 1e-9:
                           beta = int(zeta)
                           if epsilon == 1:
                              if gamma == 1:
                                 if mp.fabs(a - my_round(a)) < 1e-9:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))+", beta)
                              else:
                                 if mp.fabs(a - my_round(a)) < 1e-9:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))+", beta, "/", gamma, "^", pp)
                                 else:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/", int(b), "))+", beta, "/", gamma, "^", pp)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/", int(b), "))+", beta, "/", gamma, "^", pp)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/", int(b), "))+", beta, "/", gamma, "^", pp)
                        else:
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))+sqrt(", beta, "/", gamma, "^", p, ")")
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/", int(b), "))+sqrt(", beta, "/", gamma, "^", p, ")")
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/", int(b), "))+sqrt(", beta, "/", gamma, "^", p, ")")
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/", int(b), "))+sqrt(", beta, "/", gamma, "^", p, ")")
                     else:
                        if mp.fabs(zeta - my_round(zeta)) < 1e-9:
                           beta = int(zeta)
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))+", beta, "/", gamma, "^", pp)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))+", beta, "/", gamma, "^", pp)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))+", beta, "/", gamma, "^", pp)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))+", beta, "/", gamma, "^", pp)
                        else:
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))+sqrt(", beta, "/", gamma, "^", p, ")")
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))+sqrt(", beta, "/", gamma, "^", p, ")")
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))+sqrt(", beta, "/", gamma, "^", p, ")")
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))+sqrt(", beta, "/", gamma, "^", p, ")")

def detect_sqrt_deg(argumento, p):
   theta = argumento* mp.pi() /180
   if comentar:
      print("theta = ", theta)
   v = mp.tan(theta)
   if comentar:
      print("v = ", v)
   a = p - 1 + p* power(v, 2)
   a2 = power(a, 2)
   if comentar:
      print("a = ", a)
   c = power(binom(p,2), 2) + 2 * binom(p,4) + 2 * p * binom(p,3) * power(v, 2)
   if comentar:
      print("c = ", c)
   d = binom(p,2) * a2 - c
   if comentar:
      print("d = ", d)
   b = 2 * mp.sqrt(d/p)
   if b == 0:
      return
   if comentar:
      print("b = ", b)
   for k in range(0, p):
      m = mp.tan(theta/p + k * 2* mp.pi() /p)
      if comentar:
         print("m = ", m)
      tmp = (power(m, 2) - a)/b
      if comentar:
         print("tmp = ", tmp)
      if mp.fabs(tmp) <= 1:
         varphi = p * mp.acos(tmp)
         tau = mp.tan(varphi)
         if comentar:
            print("tau = ", tau)
         r = power(b/2, p)
         if comentar:
            print("r = ", r)
         aa = r * mp.cos(varphi)
         if comentar:
            print("aa = ", aa)
         bb = r * mp.sin(varphi)
         if comentar:
            print("bb = ", bb)
         b2 = power(b, 2)
         cc = b2/4
         # print(aa, "^2 + ", bb, "^2 = ", cc, "^", p)
         f = power(aa, 2)
         g = power(bb, 2)
         h = power(cc, p)
         fflag, fa, fb, fj = detect_sqrt(aa)
         gflag, ga, gb, gj = detect_sqrt(g)
         ccflag, cca, ccb, ccj = detect_sqrt(cc)
         dif = mp.fabs(f + g - h)
         if (dif < 1e-9) and fflag and gflag and ccflag:
            # print(int(f), "+", int(g), "=", cc, "^", p)
            angle = argumento + k * 360
            a2flag, a2a, a2b, a2j = detect_sqrt(a)
            if (mp.fabs(m) < 1e50) and (b2 < 1e50) and a2flag:
               dif = mp.fabs(mp.cos (p * mp.acos( (power(mp.tan (angle/p * mp.pi()/180), 2) - a
                                    )/b
                                  )
                            )) - mp.sqrt(f/h)
               if mp.fabs(dif) < 1e-9:
                  if comentar:
                     if dif != 0:
                        print("debug precision = 1E", int(log(mp.fabs(dif))/log(10)))
                     else:
                        print("debug precision = 0")
                  #alfa, beta = g, f
                  #gamma = cc
                  delta, epsilon = reduce_fraction(angle, p)
                  pp = p/2
                  if mp.fabs(pp - my_round(pp)) < 1e-9:
                     pp = int(pp)
                  print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-(",
                        a2a, "+", a2b, "*sqrt(", a2j, ")))/(2*sqrt(", cca, "+", ccb, "*sqrt(", ccj,
                        ")))))-(", fa, "+", fb, "*sqrt(", fj, "))/(", cca, "+", ccb, "*sqrt(", ccj, "))^", pp)

def dont_round_rad(argumento, p):
   return dont_round_deg(argumento/mp.pi() * 180, p)

def dont_round_deg(argumento, p):
   theta = argumento* mp.pi() /180
   if comentar:
      print("theta = ", theta)
   v = mp.tan(theta)
   if comentar:
      print("v = ", v)
   a = p - 1 + p* power(v, 2)
   if comentar:
      print("a = ", a)
   c = power(binom(p,2), 2) + 2 * binom(p,4) + 2 * p * binom(p,3) * power(v, 2)
   if comentar:
      print("c = ", c)
   d = binom(p,2) * power(a, 2) - c
   if comentar:
      print("d = ", d)
   b = 2 * mp.sqrt(d/p)
   if b == 0:
      return
   if comentar:
      print("b = ", b)
   if (mp.im(p) != 0) or (p != my_round(p)):
      pp = 1
   else:
      pp = p
   for k in range(0, pp):
      m = mp.tan(theta/p + k * 2* mp.pi() /p)
      if comentar:
         print("m = ", m)
      tmp = (power(m, 2) - a)/b
      if comentar:
         print("tmp = ", tmp)
      if (mp.fabs(tmp) <= 1) or (mp.im(tmp) != 0) or (mp.im(p) != 0) or (mp.im(argumento) != 0):
         varphi = p * mp.acos(tmp)
         tau = mp.tan(varphi)
         if comentar:
            print("tau = ", tau)
         r = power(b/2, p)
         if comentar:
            print("r = ", r)
         aa = r * mp.cos(varphi)
         if comentar:
            print("aa = ", aa)
         bb = r * mp.sin(varphi)
         if comentar:
            print("bb = ", bb)
         cc = power(b, 2)/4
         # print(aa, "^2 + ", bb, "^2 = ", cc, "^", p)
         f = power(aa, 2)
         g = power(bb, 2)
         h = power(cc, p)
         dif = mp.fabs(f + g - h)
         if dif < 1e-9:
            # print(f, "+", g, "=", cc, "^", p)
            angle = argumento + k * 360
            b2 = power(b, 2)
            if (mp.fabs(m) < 1e50) and (mp.fabs(b2) < 1e50):
               dif = mp.cos (p * mp.acos( (power(mp.tan (angle/p * mp.pi()/180), 2) - a
                                    )/b
                                  )
                            ) - aa/r
               if (mp.fabs(dif) < 1e-9): # and (mp.fabs(aa - my_round(aa)) < 1e-9):
                  if comentar:
                     if dif != 0:
                        print("debug precision = 1E", int(log(mp.fabs(dif))/log(10)))
                     else:
                        print("debug precision = 0")
                  print("    delta =", angle/p)
                  print("    m := delta*pi/180 =", angle/p*mp.pi()/180)
                  print("    a =", a)
                  print("    b =", b)
                  print("    Re z^2 =", aa*aa)
                  print("    Im z^2 =", bb*bb)
                  print("    gamma =", power(aa*aa + bb*bb, 1/p))
                  print("    Mod z =", r)
                  print("    cos Arg z =", aa/r, "= [fraction] beta/gamma^p sometimes")
                  print("    sin Arg z =", bb/r)
                  print("    tan Arg z =", bb/aa)
                  print("==> cos(", p, "* arccos((m^2-a)/b)) = cos Arg z")
                  for ii in range (0, p):
                     ee = mp.atan(mp.sqrt(a + 2 * mp.re(mp.root(aa + j * bb, p, ii)))) / pi * 180
                     if mp.fabs(ee * p - my_round(ee * p)) < 1e-9:
                        print(ii, ee)

def dont_round_deg_m(argumento, p, n):
   p, pz = c_to_h(p, n), p
   theta = argumento* mp.pi() /180
   if comentar:
      print("theta = ", theta)
   v = my_tanm(theta)
   if comentar:
      print("v = ", v)
   a = p - ID(n) + p* mp.powm(v, 2)
   if comentar:
      print("a = ", a)
   c = c_to_h(power(binom(pz,2), 2) + 2 * binom(pz,4), n) + p * c_to_h(2 * binom(pz,3), n) * mp.powm(v, 2)
   if comentar:
      print("c = ", c)
   d = c_to_h(binom(pz,2), n) * mp.powm(a, 2) - c
   if comentar:
      print("d = ", d)
   b = 2 * mp.sqrtm(d*mp.inverse(p))
   if mp.det(b) == 0:
      return
   if comentar:
      print("b = ", b)
   if (mp.im(pz) != 0) or (pz != my_round(pz)):
      pp = 1
   else:
      pp = pz
   for k in range(0, pp):
      m = my_tanm(theta*mp.inverse(p) + k * 2* mp.pi() * mp.inverse(p))
      if comentar:
         print("m = ", m)
      tmp = (mp.powm(m, 2) - a)*mp.inverse(b)
      if comentar:
         print("tmp = ", tmp)
      varphi = p * my_acosm(tmp, n, 0)
      tau = my_tanm(varphi)
      if comentar:
         print("tau = ", tau)
      r = mp.powm(b/2, pz)
      if comentar:
         print("r = ", r)
      aa = r * mp.cosm(varphi)
      if comentar:
         print("aa = ", aa)
      bb = r * mp.sinm(varphi)
      if comentar:
         print("bb = ", bb)
      cc = mp.powm(b, 2)/4
      # print(aa, "^2 + ", bb, "^2 = ", cc, "^", p)
      angle = argumento + k * 360 * ID(n)
      b2 = mp.powm(b, 2)
      if (mp.norm(m) < 1e50) and (mp.norm(b2) < 1e50):
         dif = mp.cosm (p * my_acosm( (mp.powm(my_tanm (angle*mp.inverse(p) * mp.pi()/180), 2) - a
                              )* mp.inverse(b)
                            , n, 0)
                      ) - mp.inverse(r) * aa
         if mp.norm(dif) < 1e-9:
            if comentar:
               print("debug precision = ", dif)
            mp.dps = 10
            print("    delta =", angle*mp.inverse(p))
            print("    m := delta*pi/180 =", angle*mp.inverse(p)*mp.pi()/180)
            print("    a =", a)
            print("    b =", b)
            print("    Re z =", aa)
            print("    Im z =", bb)
            print("    Mod z =", r)
            print("    cos Arg z =", mp.cosm(varphi), "= [fraction] beta/gamma^p sometimes")
            print("    sin Arg z =", mp.sinm(varphi))
            print("    tan Arg z =", tau)
            print("==> cos(", p, "* arccos((m^2-a)/b)) = cos Arg z")

def dont_round_deg_oct(argumento, p, M, n):
   p, pz = c_to_h(p, n), p
   theta = argumento* mp.pi() /180
   if comentar:
      print("theta = ", theta)
   v = tan_oct(M, n, theta)
   if comentar:
      print("v = ", v)
   a = p - ID(n) + product(p, pow_oct(M, n, v, 2), M, n)
   if comentar:
      print("a = ", a)
   c = c_to_h(power(binom(pz,2), 2) + 2 * binom(pz,4), n) + product(product(p, c_to_h(2 * binom(pz,3), n), M, n), pow_oct(M, n, v, 2), M, n)
   if comentar:
      print("c = ", c)
   d = product(c_to_h(binom(pz,2), n), pow_oct(M, n, a, 2), M, n) - c
   if comentar:
      print("d = ", d)
   b = 2 * sqrt_oct(M, n, product(d, inverse_oct(n, p), M, n))
   if isZero(b, n, 1e-9):
      return
   if comentar:
      print("b = ", b)
   if (mp.im(pz) != 0) or (pz != my_round(pz)):
      pp = 1
   else:
      pp = pz
   for k in range(0, pp):
      m = tan_oct(M, n, product(theta, inverse_oct(n, p), M, n) + k * 2 * mp.pi() * inverse_oct(n, p))
      if comentar:
         print("m = ", m)
      tmp = product(pow_oct(M, n, m, 2) - a, inverse_oct(n, b), M, n)
      if comentar:
         print("tmp = ", tmp)
      varphi = product(p, my_acosm(tmp, M, n), M, n)
      tau = tan_oct(M, n, varphi)
      if comentar:
         print("tau = ", tau)
      r = pow_oct(M, n, b/2, pz)
      if comentar:
         print("r = ", r)
      aa = product(r, cos_oct(M, n, varphi), M, n)
      if comentar:
         print("aa = ", aa)
      bb = product(r, sin_oct(M, n, varphi), M, n)
      if comentar:
         print("bb = ", bb)
      cc = pow_oct(M, n, b, 2)/4
      # print(aa, "^2 + ", bb, "^2 = ", cc, "^", p)
      angle = argumento + k * 360 * ID(n)
      b2 = pow_oct(M, n, b, 2)
      if (mp.norm(m) < 1e50) and (mp.norm(b2) < 1e50):
         dif = cos_oct(M, n, product(p, my_acosm( product(pow_oct(M, n, tan_oct(M, n, product(angle, inverse_oct(n, p), M, n) * mp.pi()/180), 2) - a
                              , inverse_oct(n, b), M, n)
                            , M, n), M, n)
                      ) - product(inverse_oct(n, r), aa, M, n)
         if mp.norm(dif) < 1e-9:
            if comentar:
               print("debug precision = ", dif)
            mp.dps = 10
            print("    delta =", product(angle, inverse_oct(n, p), M, n))
            print("    m := delta*pi/180 =", product(angle, inverse_oct(n, p), M, n) * mp.pi()/180)
            print("    a =", a)
            print("    b =", b)
            print("    Re z =", aa)
            print("    Im z =", bb)
            print("    Mod z =", r)
            print("    cos Arg z =", cos_oct(M, n, varphi), "= [fraction] beta/gamma^p sometimes")
            print("    sin Arg z =", sin_oct(M, n, varphi))
            print("    tan Arg z =", tau)
            print("==> cos(", p, "* arccos((m^2-a)/b)) = cos Arg z")

comentar = False
mp.dps = 200
for third in range(1, 121):
   round_deg(3*third, 7)
