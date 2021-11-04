# https://pbs.twimg.com/media/EvyslJ3WgAUPO1C?format=jpg&name=large

from mpmath import *

def log10(x):
   return 1 + mp.re(mp.ln(x)/mp.ln(10))

def power(x, y):
   if x == 0:
      return 0
   if (y / 2 == mp.floor(y / 2)) and (mp.im(x) == 0) and (mp.re(x) < 0):
      return mp.exp(y * mp.ln(-x))
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

def sgn(x):
   if x > 0:
      return 1
   elif x < 0:
      return -1
   return 0

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
   yant = 1e100
   while mp.fabs(y) > erro:
      #print(xi, xf, "f", f(x1, t) - c, f(x2, t) - c)
      x = fdiv(xi + xf, 2)
      y = sigma * (f(x, t) - c)
      if y > 0:
         xf = x
      else:
         xi = x
   return x
   
# tetration
def f(x, t):
   return tration(x, t, 4)
   
# tetration(x, 1/n)
def tetration_inverse(x, n, x1, x2):
   return newton_method(f, x, x1, x2, n, 1e-13)

def tration(x, y, n):
   #print("tration", x, y, n)
   if n == 1:
      return x + y
   if n == 2:
      return x * y
   if n == 3:
      #if log10(y) > 1000:
      #   return 0
      return power(x, y)
      
   if x == 0:
      return 0
   if y == 1:
      return x
   res = 1
   for i in range (0, my_int(y)):
      res = tration(x, res, n - 1)
   return res

def reduce_fraction(x, y):
   m = gcd(my_int(x), my_int(y))
   return my_int(x/m), my_int(y/m)

def gcd(x, y):
   x, y = mp.fabs(x), mp.fabs(y)
   if x < y:
      r = x
      x = y
      y = r
   while(y):
      r = x % y
      x = y
      y = r
   if x == 0:
      return 1
   return x

# 2^2 = 2^2^(2^0) = 2 # (2 + 0)
# 2^2^2 = 2^2^(2^1) = 2 # (2 + 1)
# 2 # (2 + 1/3) = 2^2^(2^a) = 2^2^b
# 2 # (2 + 2/3) = 2^2^b^b
# 2 # (2 + 3/3) = 2^2^b^b^b
# 2^a = b; b = 2 # (1/3) <=> b^b^b = 2^1
# 2^a = b; b = 2 # 0 = 1 => a = 0
# 2^a = b; b = 2 # 1 = 2 => a = 1

def tetration_fraction(x, pp, qq, erro, errLim):
   p, q = reduce_fraction(pp, qq)
   a = my_int(mp.floor(x))
   b = tetration_inverse(x, q, 0, erro)
   print(b)
   infty = 100
   b = tration(b, p - a * q, 4)
   print(b)
   L = tetration_inverse(x, infty, 0, errLim)
   b = ((x - 1) * b + x * (1 - L)) / (x - L)
   print(b)
   for i in range (0, a):
      b = power(x, b)
   return b

def mult(v, x, n):
   k = my_int(x/2)
   res = mp.zeros(k, 1)
   for i in range (0, k):
      res[i] = tration(v[2 * i], v[2 * i + 1], n)
   return res
   
# n >= 1 + log_2 rows
def inner(M, cols, rows, nn):
   x, v, n = cols * rows, mp.zeros(cols * rows, 1), nn

   # mount vector from matrix:
   # (v_1, ..., v_j) (v_j + 1, ..., v_2j)
   #   +i
   # j = cols ; i = 0, 1, ..., rows/2 - 1
   k = 0
   for i in range (0, my_int(rows/2)):
      for j in range (0, cols):
         v[k] = M[2*i, j]
         k = k + 1
         v[k] = M[2*i + 1, j]
         k = k + 1
   print(v.T)
   
   if (n < 1 + mp.ln(rows)/mp.ln(2)):
      return v
   while (x > cols) and (n > 1):
      v = mult(v, x, n)
      x = my_int(x/2)
      n = n - 1
      print(x, n)
   if n > 0:
      res = v[0]
      for i in range (1, x):
         res = tration(res, v[i], n)
      v = mp.zeros(1, 1)
      v[0] = res      
   return v

def demo(t, k, x1, x2):
   x = tetration_inverse(t, k, x1, x2)
   y = 1
   n = 0
   for i in range (0, k):
      y = power(x, y)
      n = n + 1
      if mp.fabs(t - y) < 1e-20:
         break
   print(x, "#", n, "=", y)
   print("_________________")

mp.dps = 30
# power 2 by 2, product 2 by 2, sum 3 by 3
print(inner(mp.matrix([[0.1, 0.2, 0.3], [0.4, 0.5, 0.6], [0.7, 0.8, 0.9], [1.0, 1.1, 1.2]]), 3, 4, 3))
# tetration 2 by 2, power 2 by 2, product 3 by 3
print(inner(mp.matrix([[0.1, 0.2, 0.3], [0.4, 0.5, 0.6], [0.7, 0.8, 0.9], [1.0, 1.1, 1.2]]), 3, 4, 4))
mp.dps = 100
x = tetration_fraction(22/7, 22, 7, 1.5, 1.4455)
print("a = 22/7 # 22/7 =", x)
print("_________________")
y = tetration_fraction(333/106, 333, 106, 1.4455, 1.4455)
print("b = 3.1415 # 3.1415 =", y)
print("_________________")
print("b/a = ", y/x)
print("_________________")
demo(3, 100, 0, 1.4455)
demo(0.594, 4, 0.25, 0.255)

# b # 7 = 22/7
# b =        1.4984678885302856
# f(b) = L = 1,0669294648419162
# 22/7 # 22/7 = (22/7)^(22/7)^(22/7)^f(b)
# 22/7 # 22/7 = (22/7)^(22/7)^3.39320667664248747
# 22/7 # 22/7 = (22/7)^48.69958851164365
# 22/7 # 22/7 = 16576.978112419164596e+20

# Release 0.1 from 2021/Apr/3rd
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# out of charity, there is no salvation at all.
# with charity, there is evolution.