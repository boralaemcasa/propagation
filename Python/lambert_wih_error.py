# https://pbs.twimg.com/media/Evt2ufqWgAEU_wS?format=jpg&name=large
# https://pbs.twimg.com/media/Evt8t0nWQAEmtYO?format=png&name=large

# https://www.dropbox.com/s/vv6qgj16hgk1sch/Solving%20Any%20Quintic.pdf?dl=0

from mpmath import *
import numpy as np
from sympy import Matrix

# f(x, t) = c
def newton_method(f, c, x1, x2, t, erro):
   x, y, y2 = x1, f(x1, t) - c, f(x2, t) - c
   if y == 0:
      return x1
   if y2 == 0:
      return x2
   sigma = -sgn(y)
   if sigma == -sgn(y2):
      return x1
   xi, xf = x1, x2
   while mp.fabs(y) > erro:
      x = (xi + xf)/2
      y = sigma * (f(x, t) - c)
      #print(x, "f", y)
      if mp.re(y) > 0:
         xf = x
      else:
         xi = x
   return x
   
def f(x, t):
   return power(x, t) * mp.exp(x)
   
def extendedw(xx, n):
   for x1 in range (0, 100):
      y = newton_method(f, xx, x1, x1 + 1, n, 1e-13)
      if mp.fabs(f(y, n) - xx) < 1e-9:
         return y
      y = newton_method(f, xx, -x1 - 1, -x1, n, 1e-13)
      if mp.fabs(f(y, n) - xx) < 1e-9:
         return y
   return 0
   
def g(x, c, a0, r1, r2):
   return mp.exp(-c * x) - a0 * (x - r1) * (x - r2)
   
def superw(c, a0, r1, r2):
   for x1 in range (0, 100):
      y = super_newton(g, c, a0, r1, r2, x1, x1 + 1, 1e-13)
      if mp.fabs(g(y, c, a0, r1, r2)) < 1e-9:
         return y
      y = super_newton(g, c, a0, r1, r2, -x1 - 1, -x1, 1e-13)
      if mp.fabs(g(y, c, a0, r1, r2)) < 1e-9:
         return y
   return 0
   
# f(x, c, a0, r1, r2) = 0
def super_newton(f, c, a0, r1, r2, x1, x2, erro):
   x, y, y2 = x1, f(x1, c, a0, r1, r2), f(x2, c, a0, r1, r2)
   if y == 0:
      return x1
   if y2 == 0:
      return x2
   sigma = -sgn(y)
   if sigma == -sgn(y2):
      return x1
   xi, xf = x1, x2
   while mp.fabs(y) > erro:
      x = (xi + xf)/2
      y = sigma * f(x, c, a0, r1, r2)
      #print(x, "f", y)
      if mp.re(y) > 0:
         xf = x
      else:
         xi = x
   return x
   
def my_round(x):
   y = mp.fabs(x)
   if mp.fabs(y - mp.floor(y)) < 0.5:
      return mp.sign(x) * mp.floor(y)
   else:
      return mp.sign(x) * mp.ceil(y)

def my_int(x):
   y = int(my_round(x))
   return y

def sgn(xx):
   x = mp.re(xx)
   if x > 0:
      return 1
   elif x < 0:
      return -1
   return 0

def power(x, y):
   if (y / 2 == mp.floor(y / 2)) and (mp.im(x) == 0) and (mp.re(x) < 0):
      return mp.exp(y * mp.ln(-x))
   else:
      return mp.exp(y * mp.ln(x))
      
# z = ln z, trigonometric
def F(x):
   res = mp.zeros(2, 1)
   r, t = x[0], x[1]
   res[0] = r * mp.cos(t) - mp.ln(r)
   res[1] = r * mp.sin(t) - t
   return res
   
def dF(x):
   J = mp.zeros(2, 2)
   r, t = x[0], x[1]
   J[0,0] = mp.cos(t) - 1/r   # du\dx
   J[0,1] = - r * mp.sin(t)   # du\dy
   J[1,0] = mp.sin(t)         # dv\dx
   J[1,1] = r * mp.cos(t) - 1 # dv\dy
   return J
   
def ddF(x):
   J = np.zeros((2, 2, 2), dtype=complex)
   r, t = x[0], x[1]
   J[0,0,0] = power(r, -2)    # ddu\dx\dx
   J[0,0,1] = - mp.sin(t)     # ddu\dx\dy
   J[0,1,1] = - r * mp.cos(t) # ddu\dy\dy
   J[1,0,0] = 0               # ddv\dx\dx
   J[1,0,1] = mp.cos(t)       # ddv\dx\dy
   J[1,1,1] = - r * mp.sin(t) # ddv\dy\dy
   for i in range (0, 2):
      for j in range (0, 2):
         for k in range (i + 1, 2):
            J[i, k, j] = J[i, j, k]
   return J
   
def method(n, a, f, df, ddf, x0, erro):
   xk = x0
   zant = 1e100
   B = mp.zeros(n, n)
   for epoch in range (0, n):
      y = f(xk)
      z = 0.5 * mp.norm(y)
      print("z =", xk.T, "error =", z)
      zant = z
      J = df(xk)
      m = ddf(xk)
      g = mp.zeros(n, 1)
      for i in range (0, n):
         for k in range (0, a):
            g[i] = g[i] + y[k] * J[k, i]
      H = mp.zeros(n, n)
      for i in range (0, n):
         for k in range (0, n):
            for u in range (0, a):
               H[i, k] = H[i, k] + J[u, k] * J[u, i] + y[u] * m[u, i, k]
      
      # H = V * D * mp.inverse(V)
      H = Matrix(H)
      V, D = H.jordan_form()

      if epoch == 0:
         # we want all (n - 1) vectors B perp C = D * V * g [n x 1]. Gram-Schmidt completes the Basis.
         c = D * V * g
         for i in range (0, n):
            B[i, 0] = c[i]
            for k in range (1, n):
               if k == i:
                  B[i, k] = 1 # we will have a problem if g = r e_k, 2 <= k <= n
         B = schmidt(B, n)
      Be = mp.zeros(n, 1)
      for i in range (0, n):
         Be[i] = B[i, epoch]
      w = mp.inverse(H) * mp.inverse(V) * Be
      alfa = 0.01         
      while (True):
         xk = xk - alfa * w
         y = f(xk)
         z = 0.5 * mp.norm(y)
         print("epoch =", epoch, "alfa =", alfa, "z =", xk.T, "error loop =", z)
         if z > zant:
            xk = xk + 2 * alfa * w
            alfa = alfa/100
            if alfa < 1e-12:
               zant = z
               break
         zant = z
      alfa = 0.1         
      while (True):
         xk = xk + alfa * w
         y = f(xk)
         z = 0.5 * mp.norm(y)
         print("epoch =", epoch, "alfa =", alfa, "z =", xk.T, "error loop =", z)
         if z > zant:
            xk = xk - 2 * alfa * w
            alfa = alfa/100
            if alfa < 1e-12:
               zant = z
               break
            else:
               y = f(xk)
               z = 0.5 * mp.norm(y)
         zant = z
   return xk

def schmidt(V, n):
   Delta = mp.zeros(n, n)
   W = mp.zeros(n, n)

   for k in range (0, n):
      for i  in range (0, n):
         W[i, k] = V[i, k]
         for j in range (0, k):
            W[i, k] = W[i, k] - Delta[j, k] * W[i, j]

      # norma da coluna W[k]
      Delta[k, k] = W[0, k] * W[0, k]
      for i in range (1, n):
         Delta[k, k] = Delta[k, k] + W[i, k] * W[i, k]
      Delta[k, k] = mp.sqrt(Delta[k, k])

      for i in range (0, n):
         W[i, k] = W[i, k] / Delta[k, k]

      if k < n - 1:
         for i in range (0, k + 1):
            # Delta[i][k + 1] = produtoInterno(V, k + 1, W, i, n);
            Delta[i, k + 1] = V[0, k + 1] * W[0, i]
            for j in range (1, n):
               Delta[i, k + 1] = Delta[i, k + 1] + V[j, k + 1] * W[j, i]

   # neste momento V = Delta * W
   # Delta triangular
   # W ortogonal
   return W

# solution of exercise 11.1
# e^{xt} = ax + b, for any t, a, b

# here, a = f(t, z), b = g(t, z)

print("Lambert W first degree:")
print("")
mp.dps = 15
z = 1/2 - mp.sqrt(3)/2*j
t = 1
a = 1/mp.im(z) * mp.sin(mp.im(z) * t) * mp.exp(mp.re(z) * t)
b = 1/mp.im(z) * (- mp.re(z) * mp.sin(mp.im(z) * t) + mp.im(z) * mp.cos(mp.im(z) * t)) * mp.exp(mp.re(z) * t)
y = - t/(a * mp.exp(b*t/a))
for k in range(-11, 11):
   x = 1/(a*t) * (-a * mp.lambertw(y, k) - b*t)
   print(k, ":", x, "error =", mp.exp(x * t) - a * x - b)

# k = 0  ==> x = Re z - j abs Im z
# k = -1 ==> x = Re z + j abs Im z

# solution of defiance 5
# e^{xt} = ax^2 + bx + c = d^x

print("")
print("Lambert W Second Degree:")
print("")
r = [-2, -3, -4]
d = 5
M = mp.zeros(3, 3)
M[0,0], M[0,1], M[0,2] =  r[1]*r[2]*(r[1] - r[2]),      -r[0]*r[2]*(r[0] - r[2]),    r[0]*r[1]*(r[0] - r[1])
M[1,0], M[1,1], M[1,2] =  -(r[1] + r[2])*(r[1] - r[2]), (r[0] + r[2])*(r[0] - r[2]), -(r[0] + r[1])*(r[0] - r[1])
M[2,0], M[2,1], M[2,2] =  2*(r[1] - r[2]),              -2*(r[0] - r[2]),            2*(r[0] - r[1])
M = 1/(r[0] - r[1])/(r[0] - r[2])/(r[1] - r[2]) * M

t = mp.ln(d)
a = 1/2 * (M[2,0] * mp.exp(r[0] * t) + M[2,1] * mp.exp(r[1] * t) + M[2,2] * mp.exp(r[2] * t)) # f_3/2
b = M[1,0] * mp.exp(r[0] * t) + M[1,1] * mp.exp(r[1] * t) + M[1,2] * mp.exp(r[2] * t) # f_2
c = M[0,0] * mp.exp(r[0] * t) + M[0,1] * mp.exp(r[1] * t) + M[0,2] * mp.exp(r[2] * t) # f_1
print("a =", a)
print("b =", b)
print("c =", c)
print("d =", d)
for i in range (0, 3):
   y = a * r[i] * r[i] + b * r[i] + c - power(d, r[i])
   print("x =", r[i], "ax^2 + bx + c - d^x =", y)

print("")
print("I have found (a, b, c) from [r] with t fixed. Now find the inverse [r_1, r_2, r_3] = f(a, b, c).")
print("Exercise. Solve ax^2 + bx + c = d^x.")

print("")
print("If Lambert W n-th degree existed:")
print("")
# (ax + b)^n = e^{xt}
n = 2
a = 3
b = 5
t = 7
y = power(-t/a, n) * mp.exp(-b*t/a)

x = 1/(a*t) * (-a * extendedw(y, n) - b*t)
print("x =", x, "error =", power(a * x + b, n) - mp.exp(x * t))

print("")
print("Below, almost never converges to zero:")
print("")
w = method(2, 2, F, dF, ddF, mp.matrix([2, 1]), 1e-13)
r, t = w[0], w[1]
z = r * mp.cos(t) + j * r * mp.sin(t)
print("z - ln z =", z - mp.ln(z))

print("")
print("Below, exp(-cx) = a0(x - r1)(x - r2):")
print("")
# e^{-cx} = a0(x - r1)(x - r2)
c = 2
a0 = 3
r1 = 5
r2 = 7
x = superw(c, a0, r1, r2)
print("x =", x, "error =", g(x, c, a0, r1, r2))

# Release 0.1 from 2021/Mar/10th
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# out of charity, there is no salvation at all.
# with charity, there is evolution.
