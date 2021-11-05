from mpmath import *
import random

def sgn(x):
   if x > 0:
      return 1
   elif x < 0:
      return -1
   return 0

def spherical2unitary(n, v):
   w = mp.zeros(n + 1, 1)
   for i in range (0, n + 1):
      w[i] = 1

   for j in range (0, n):
      k = n - j
      for i in range (0, k):
         w[i] = w[i] * mp.cos(v[i] * pi/180)
      w[k] = w[k] * mp.sin(v[k - 1] * pi/180)

   return w

def sphericalMatrix(n, width, M):
   w = mp.zeros(n + 1, width)
   for i in range (0, n + 1):
      for j in range (0, width):
         w[i, j] = 1

   for col in range (0, width):
      for j in range (0, n):
         k = n - j
         for i in range (0, k):
            w[i, col] = w[i, col] * mp.cos(M[i, col] * pi/180)
         w[k, col] = w[k, col] * mp.sin(M[k - 1, col] * pi/180)

   return w

def norm2sphere(beta, pp, d, qq, a, b, c):
   p = sphericalMatrix(a - 1, a, pp)
   w = sphericalMatrix(b - 1, b * c, qq)
   q = mp.zeros(b * c, b * c)
   for k in range (0, b):
      ii = power(k + 1, 2) - 1
      for j in range (0, b * c):
         q[ii, j] = w[k, j]

   erro, dif = norm2(beta, p, d, q, a, b, c)
   return erro, dif, p, q

def norm2(beta, p, d, q, a, b, c):
   aux = mp.zeros(a + b * c, 1)
   for i in range (0, a):
      for j in range (0, a):
         aux[i] = aux[i] + mp.power(p[j, i], 2)
      aux[i] = aux[i] * power(aux[i] - 1, 2)

   for k in range (0, b):
      ii = power(k + 1, 2) - 1
      for j in range (0, b * c):
         aux[j + a] = aux[j + a] + mp.power(q[ii, j], 2)
      aux[k + a] = aux[k + a] * (aux[k + a] - 1)

   dif = mp.zeros(a, b * c)

   for i in range (0, a):
      for j in range (0, b * c):
         dif[i, j] = - beta[i, j]
         for k in range (0, a):
            # T_{ij} = d_i * q[ii, j]
            # if j = 0, ii = 0, if j = 1, ii = 2^2 - 1, if j = 2, ii = 3^2 - 1
            # ii(j) = (j + 1)^2 - 1
            ii = my_int(power(k + 1, 2) - 1)
            dif[i, j] = dif[i, j] + p[i, k] * d[k] * q[ii, j]

   erro = 0
   for i in range (0, a):
      for j in range (0, b * c):
         erro = erro + power(dif[i, j], 2)

   for i in range (0, a + b * c):
      erro = erro + aux[i]
   return erro, dif

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

def f1(beta, a, b, c):
   if (a > b) or (b > c):
      return 0, 0, 0, 0, 0

   print("# Free Variables =", a * a, "+", a, "+", b * c * b, "-", a * b * c, "=", a * a + a + b * c * b - a * b * c, "times <u, v> = 0")
   print("# Columns =", a, "+", b * c, "=", a + b * c)

   p = mp.zeros(a, a)
   d = mp.zeros(a, 1)
   q = mp.zeros(b * c, b * c)

   # - beta + p * d * q = 0
   # gradient descent method
   h = 32
   erro2 = 1e100
   contador = 0

   while erro2 > 20000:
      for i in range (0, a):
         for j in range (0, a):
            p[i, j] = random.randrange(120)/100
            if random.randrange(2) == 0:
               p[i, j] = - p[i, j]

      for i in range (0, a):
         d[i] = random.randrange(120)/100
         if random.randrange(2) == 0:
            d[i] = - d[i]

      for k in range (0, b):
         ii = power(k + 1, 2) - 1
         for j in range (0, b * c):
            q[ii, j] = random.randrange(120)/100
            if random.randrange(2) == 0:
               q[ii, j] = - q[ii, j]

      #q[0, 6], q[0, 7], q[0, 8] =  1, 1, 1
      #q[3, 6], q[3, 7], q[3, 8] =  1, 1, 1
      #q[8, 6], q[8, 7], q[8, 8] =  1, 1, 1

      #q[0, 9], q[0, 10], q[0, 11] =  1, 1, 1
      #q[3, 9], q[3, 10], q[3, 11] =  1, 1, 1
      #q[8, 9], q[8, 10], q[8, 11] =  1, 1, 1

      erro2, dif = norm2(beta, p, d, q, a, b, c)
   erroAnt = 1e100

   for epoca in range(0, 2000):
      erro2, dif = norm2(beta, p, d, q, a, b, c)
      if epoca % 10 == 0:
         print("Epoch =", epoca, "Error =", erro2, "h =", h)
      if erro2 < 0.01:
         break

      #if erro(p - h) < erro(p + h) then walk left, else walk right
      for i in range (0, a):
         for j in range (0, a):
            p[i, j] = p[i, j] - h
            erro1, dif = norm2(beta, p, d, q, a, b, c)
            p[i, j] = p[i, j] + 2*h
            erro3, dif = norm2(beta, p, d, q, a, b, c)
            if (erro1 <= erro2) and (erro2 <= erro3):
               p[i, j] = p[i, j] - 2*h
               erro2 = erro1
            elif (erro2 <= erro1) and (erro2 <= erro3):
               p[i, j] = p[i, j] - h
            else:
               erro2 = erro3

      #if erro(d - h) < erro(d + h) then walk left, else walk right
      for i in range (0, a):
         d[i] = d[i] - h
         erro1, dif = norm2(beta, p, d, q, a, b, c)
         d[i] = d[i] + 2*h
         erro3, dif = norm2(beta, p, d, q, a, b, c)
         if (erro1 <= erro2) and (erro2 <= erro3):
            d[i] = d[i] - 2*h
            erro2 = erro1
         elif (erro2 <= erro1) and (erro2 <= erro3):
            d[i] = d[i] - h
         else:
            erro2 = erro3

      #if erro(q - h) < erro(q + h) then walk left, else walk right
      for k in range (0, b):
         ii = power(k + 1, 2) - 1
         for j in range (0, b * c):
            q[ii, j] = q[ii, j] - h
            erro1, dif = norm2(beta, p, d, q, a, b, c)
            q[ii, j] = q[ii, j] + 2*h
            erro3, dif = norm2(beta, p, d, q, a, b, c)
            if (erro1 <= erro2) and (erro2 <= erro3):
               q[ii, j] = q[ii, j] - 2*h
               erro2 = erro1
            elif (erro2 <= erro1) and (erro2 <= erro3):
               q[ii, j] = q[ii, j] - h
            else:
               erro2 = erro3

      #q[0, 6], q[0, 7], q[0, 8] =  1, 1, 1
      #q[3, 6], q[3, 7], q[3, 8] =  1, 1, 1
      #q[8, 6], q[8, 7], q[8, 8] =  1, 1, 1

      #q[0, 9], q[0, 10], q[0, 11] =  1, 1, 1
      #q[3, 9], q[3, 10], q[3, 11] =  1, 1, 1
      #q[8, 9], q[8, 10], q[8, 11] =  1, 1, 1

      #print("dif =", mp.fabs(erro2 - erroAnt))
      if mp.fabs(erro2 - erroAnt) < 1e-20:
         contador = contador + 1
         if contador > 0: # funny. should be 1.
            h = h * 0.9
         if h < 1e-4:
            break
      else:
         contador = 0

      erroAnt = erro2
   return erro2, p, d, q, dif

def f2(beta, a, b, c):
   if (a > b) or (b > c):
      return 0, 0, 0, 0, 0

   aa = a - 1
   bb = b - 1

   print("# Free Variables =", a * aa, "+", a, "+", b * c * bb, "-", a * b * c, "=", a * aa + a + b * c * bb - a * b * c, "times <u, v> = 0")
   print("# Columns =", a, "+", b * c, "=", a + b * c)

   pp = mp.zeros(aa, a)
   d = mp.zeros(a, 1)
   qq = mp.zeros(bb, b * c)

   # - beta + p * d * q = 0
   # gradient descent method
   h = 32
   erro2 = 1e100
   contador = 0

   while erro2 > 2560:
      for j in range (0, a):
         pp[0, j] = random.randrange(361)
         for i in range (1, aa):
            pp[i, j] = random.randrange(181) - 90

      for i in range (0, a):
         d[i] = random.randrange(120)/100
         if random.randrange(2) == 0:
            d[i] = - d[i]

      for j in range (0, b * c):
         qq[0, j] = random.randrange(361)
         for i in range (1, bb):
            qq[i, j] = random.randrange(181) - 90

      erro2, dif, p, q = norm2sphere(beta, pp, d, qq, a, b, c)
   erroAnt = 1e100

   for epoca in range(0, 2000):
      erro2, dif, p, q = norm2sphere(beta, pp, d, qq, a, b, c)
      if epoca % 10 == 0:
         print("Epoch =", epoca, "Error =", erro2, "h =", h)
      if erro2 < 0.01:
         break

      #if erro(pp - h) < erro(pp + h) then walk left, else walk right
      for i in range (0, aa):
         for j in range (0, a):
            pp[i, j] = pp[i, j] - h
            erro1, dif, p, q = norm2sphere(beta, pp, d, qq, a, b, c)
            pp[i, j] = pp[i, j] + 2*h
            erro3, dif, p, q = norm2sphere(beta, pp, d, qq, a, b, c)
            if (erro1 <= erro2) and (erro2 <= erro3):
               pp[i, j] = pp[i, j] - 2*h
               erro2 = erro1
            elif (erro2 <= erro1) and (erro2 <= erro3):
               pp[i, j] = pp[i, j] - h
            else:
               erro2 = erro3

      #if erro(d - h) < erro(d + h) then walk left, else walk right
      for i in range (0, a):
         d[i] = d[i] - h
         erro1, dif, p, q = norm2sphere(beta, pp, d, qq, a, b, c)
         d[i] = d[i] + 2*h
         erro3, dif, p, q = norm2sphere(beta, pp, d, qq, a, b, c)
         if (erro1 <= erro2) and (erro2 <= erro3):
            d[i] = d[i] - 2*h
            erro2 = erro1
         elif (erro2 <= erro1) and (erro2 <= erro3):
            d[i] = d[i] - h
         else:
            erro2 = erro3

      #if erro(qq - h) < erro(qq + h) then walk left, else walk right
      for i in range (0, bb):
         for j in range (0, b * c):
            erro1, dif, p, q = norm2sphere(beta, pp, d, qq, a, b, c)
            qq[i, j] = qq[i, j] + 2*h
            erro3, dif, p, q = norm2sphere(beta, pp, d, qq, a, b, c)
            if (erro1 <= erro2) and (erro2 <= erro3):
               qq[i, j] = qq[i, j] - 2*h
               erro2 = erro1
            elif (erro2 <= erro1) and (erro2 <= erro3):
               qq[i, j] = qq[i, j] - h
            else:
               erro2 = erro3

      #print("dif =", mp.fabs(erro2 - erroAnt))
      if mp.fabs(erro2 - erroAnt) < 1e-20:
         contador = contador + 1
         if contador > 0: # funny. should be 1.
            h = h * 0.9
         if h < 1e-4:
            break
      else:
         contador = 0

      erroAnt = erro2
   return erro2, p, d, q, dif

def f3(beta, a, b, c):
   if (a > b) or (b > c):
      return 0, 0, 0, 0, 0

   print("# Free Variables =", a * a, "+", a, "+", b * c * b, "-", a * b * c, "=", a * a + a + b * c * b - a * b * c, "times <u, v> = 0")
   print("# Columns =", a, "+", b * c, "=", a + b * c)

   p = mp.zeros(a, a)
   d = mp.zeros(a, 1)
   q = mp.zeros(b * c, b * c)

   # - beta + p * d * q = 0
   # gradient descent method
   h = 32
   erro2 = 1e100
   contador = 0

   while erro2 > 2560:
      for i in range (0, a):
         for j in range (0, a):
            p[i, j] = random.randrange(120)/100
            if random.randrange(2) == 0:
               p[i, j] = - p[i, j]

      for i in range (0, a):
         d[i] = random.randrange(120)/100
         if random.randrange(2) == 0:
            d[i] = - d[i]

      for k in range (0, b):
         ii = power(k + 1, 2) - 1
         for j in range (0, b * c):
            q[ii, j] = random.randrange(120)/100
            if random.randrange(2) == 0:
               q[ii, j] = - q[ii, j]

      erro2, dif = norm2(beta, p, d, q, a, b, c)
   erroAnt = 1e100

   for epoca in range(0, 1000):
      erro2, dif = norm2(beta, p, d, q, a, b, c)
      print("Epoch =", epoca, "Error =", erro2, "h =", h)
      if erro2 < 0.01:
         break

      for i in range (0, a):
         for j in range (0, a):
            grad = sgn(dnorm2dpij(beta, p, d, q, a, b, c, i, j))
            p[i, j] = p[i, j] - h * grad
            erro1, dif = norm2(beta, p, d, q, a, b, c)
            if erro1 <= erro2:
               erro2 = erro1
            else:
               p[i, j] = p[i, j] + h * grad

      for i in range (0, a):
         grad = sgn(dnorm2ddi(beta, p, d, q, a, b, c, i))
         d[i] = d[i] - h * grad
         erro1, dif = norm2(beta, p, d, q, a, b, c)
         if erro1 <= erro2:
            erro2 = erro1
         else:
            d[i] = d[i] + h * grad

      for k in range (0, b):
         ii = power(k + 1, 2) - 1
         for j in range (0, b * c):
            grad = sgn(dnorm2dqiij(beta, p, d, q, a, b, c, ii, j))
            q[ii, j] = q[ii, j] - h * grad
            erro1, dif = norm2(beta, p, d, q, a, b, c)
            if erro1 <= erro2:
               erro2 = erro1
            else:
               q[ii, j] = q[ii, j] + h * grad

      #print("dif =", mp.fabs(erro2 - erroAnt))
      if mp.fabs(erro2 - erroAnt) < 1e-20:
         contador = contador + 1
         if contador > 0: # funny. should be 1.
            h = h * 0.9
         if h < 1e-4:
            break
      else:
         contador = 0

      erroAnt = erro2
   return erro2, p, d, q, dif

def f4(beta, a, b, c):
   if (a > b) or (b > c):
      return 0, 0, 0, 0, 0

   print("# Free Variables =", a * a, "+", a, "+", b * c * b, "-", a * b * c, "=", a * a + a + b * c * b - a * b * c, "times <u, v> = 0")
   print("# Columns =", a, "+", b * c, "=", a + b * c)

   p = mp.zeros(a, a)
   d = mp.zeros(a, 1)
   q = mp.zeros(b * c, b * c)
   gradp = mp.zeros(a, a)
   gradd = mp.zeros(a, 1)
   gradq = mp.zeros(b * c, b * c)

   # - beta + p * d * q = 0
   # gradient descent method
   h = 0.01
   erro = mp.zeros(101, 1)
   contador = 0

   erro[0] = 1e100
   while erro[0] > 2560:
      for i in range (0, a):
         for j in range (0, a):
            p[i, j] = random.randrange(120)/100
            if random.randrange(2) == 0:
               p[i, j] = - p[i, j]

      for i in range (0, a):
         d[i] = random.randrange(120)/100
         if random.randrange(2) == 0:
            d[i] = - d[i]

      for k in range (0, b):
         ii = power(k + 1, 2) - 1
         for j in range (0, b * c):
            q[ii, j] = random.randrange(120)/100
            if random.randrange(2) == 0:
               q[ii, j] = - q[ii, j]

      erro[0], dif = norm2(beta, p, d, q, a, b, c)

   for i in range (0, a):
      for j in range (0, a):
         gradp[i, j] = dnorm2dpij(beta, p, d, q, a, b, c, i, j)

   for i in range (0, a):
      gradd[i] = dnorm2ddi(beta, p, d, q, a, b, c, i)

   for k in range (0, b):
      ii = power(k + 1, 2) - 1
      for j in range (0, b * c):
         gradq[ii, j] = dnorm2dqiij(beta, p, d, q, a, b, c, ii, j)

   epmin = -1
   min = 1e100
   for epoca2 in range (0, 50):
      for epoca in range(0, 101):
         dx = (epoca - 50) * h
         p2 = p + dx * gradp
         d2 = d + dx * gradd
         q2 = q + dx * gradq

         erro[epoca], dif = norm2(beta, p2, d2, q2, a, b, c)

         #print("Epoch =", epoca, "Error =", erro[epoca])
         if erro[epoca] < 0.01:
            return erro[epoca], p2, d2, q2, dif

         if erro[epoca] < min:
            min, epmin = erro[epoca], epoca

      epoca = epmin
      dx = (epoca - 50) * h
      for i in range (0, a):
         for j in range (0, a):
            p2[i, j] = p[i, j] + dx * gradp[i, j]
      for i in range (0, a):
         d2[i] = d[i] + dx * gradd[i]
      for k in range (0, b):
         ii = power(k + 1, 2) - 1
         for j in range (0, b * c):
            q2[ii, j] = q[ii, j] + dx * gradq[ii, j]

      erro[epoca], dif = norm2(beta, p2, d2, q2, a, b, c)
      print("Epmin =", epmin, "Error =", erro[epoca])

      p, d, q = p2, d2, q2
      h = h / 50

   return erro[epoca], p, d, q, dif

def dnorm2dpij(beta, p, d, q, a, b, c, I, j):
   erro = p[j, I] # d (x^4 - x^2)^2 = 2(x^4 - x^2)(4x^3 - 2x) = 4x^3 (x^2 - 1)(2x^2 - 1)
   erro = 4 * power(erro, 3) * (power(erro, 2) - 1) * (2 * power(erro, 2) - 1)

   dif = mp.zeros(a, 1)
   soma = mp.zeros(a, 1)

   for i in range (0, a):
      dif[i] = - beta[i, j]
      for k in range (0, a):
         # T_{ij} = d_i * q[ii, j]
         # if j = 0, ii = 0, if j = 1, ii = 2^2 - 1, if j = 2, ii = 3^2 - 1
         # ii(j) = (j + 1)^2 - 1
         ii = my_int(power(k + 1, 2) - 1)
         dif[i] = dif[i] + p[i, k] * d[k] * q[ii, j]
         if k == j:
            soma[i] = soma[i] + d[k] * q[ii, j]

   #erro = 0
   for i in range (0, a):
      erro = erro + 2 * dif[i] * soma[i]

   return mp.re(erro)

def dnorm2ddi(beta, p, d, q, a, b, c, I):
   dif = mp.zeros(a, b * c)
   soma = mp.zeros(a, b * c)

   for i in range (0, a):
      for j in range (0, b * c):
         dif[i, j] = - beta[i, j]
         for k in range (0, a):
            # T_{ij} = d_i * q[ii, j]
            # if j = 0, ii = 0, if j = 1, ii = 2^2 - 1, if j = 2, ii = 3^2 - 1
            # ii(j) = (j + 1)^2 - 1
            ii = my_int(power(k + 1, 2) - 1)
            dif[i, j] = dif[i, j] + p[i, k] * d[k] * q[ii, j]
            if k == I:
               soma[i, j] = soma[i, j] + p[i, k] * q[ii, j]

   erro = 0
   for i in range (0, a):
      for j in range (0, b * c):
         erro = erro + 2 * dif[i, j] * soma[i, j]

   return mp.re(erro)

def dnorm2dqiij(beta, p, d, q, a, b, c, II, j):
   erro = q[II, j] # d (x^4 - x^2)^2 = 2(x^4 - x^2)(4x^3 - 2x) = 4x^3 (x^2 - 1)(2x^2 - 1)
   erro = 4 * power(erro, 3) * (power(erro, 2) - 1) * (2 * power(erro, 2) - 1)

   dif = mp.zeros(a, 1)
   soma = mp.zeros(a, 1)

   for i in range (0, a):
      dif[i] = - beta[i, j]
      for k in range (0, a):
         # T_{ij} = d_i * q[ii, j]
         # if j = 0, ii = 0, if j = 1, ii = 2^2 - 1, if j = 2, ii = 3^2 - 1
         # ii(j) = (j + 1)^2 - 1
         ii = my_int(power(k + 1, 2) - 1)
         dif[i] = dif[i] + p[i, k] * d[k] * q[ii, j]
         if k == II:
            soma[i] = soma[i] + d[k] * q[ii, j]

   #erro = 0
   for i in range (0, a):
      erro = erro + 2 * dif[i] * soma[i]

   return mp.re(erro)

mp.dps = 50
for n in range (2, 5):
   v = mp.zeros(n, 1)
   v[0] = random.randrange(361)
   for i in range (1, n):
      v[i] = random.randrange(181) - 90
   print("n =", n, "v =")
   print(v)
   w = spherical2unitary(n, v)
   print("n =", n, "w =")
   print(w)

beta = mp.zeros(2, 12)

beta[0, 0], beta[0, 1], beta[0, 2] =    3,   4,   7
beta[1, 0], beta[1, 1], beta[1, 2] =   13,  17,  19

beta[0, 3], beta[0,  4], beta[0,  5] =  11, 10,   1
beta[1, 3], beta[1,  4], beta[1,  5] =   2, 23,  29

beta[0, 6], beta[0, 7], beta[0, 8] =    5, 4.4, 7.6
beta[1, 6], beta[1, 7], beta[1, 8] =    1, 1.9, 1.8

beta[0, 9], beta[0, 10], beta[0, 11] = 1.1,   0, 1.2
beta[1, 9], beta[1, 10], beta[1, 11] = 2.3, 5.2, 9.2

erro, p, d, q, dif = f1(beta, 2, 3, 4)
print("__________")
print("p =", p)
print("__________")
print("d =", d)
print("__________")
print("q =", q)
print("__________")
print("dif =", dif)

#Error < 3.4203858187146388729098282200679374481395157448578
#__________
#p = [-0.84248822714162497314605015930055742501281201839447  -0.41250361929384850388086158901046474056784063577652]
#    [ 0.14092733224536337088839133002693415619432926177979   -1.2048835241653212801277161858592990029137581586838]
#__________
#d = [-26.680063177470165832957937901426248572533950209618]
#    [-20.210654596475593436540052483252338788588531315327]
#__________
#q = [-0.059518671448330728868114647411857731640338897705078   -0.07530052187084814319800729620624224480707198381424    0.020679318018510889354288906361034605652093887329102     0.43416071745339690577530911141934666375163942575455   0.090266285627675617135590169226588841411285102367401    -0.3757812578873184292810316620148114452604204416275     0.19473285133736071943200141021179661038331687450409    0.15917591302938308237685527402049956435803323984146     0.29460342825559765987664118114253142266534268856049    0.01433076188463201436351646123057435033842921257019  -0.073258876090129835569053629029667717986740171909332   -0.081812786393790985252361114277164233499206602573395]
#    [                                                   0.0                                                     0.0                                                      0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0                                                     0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0]
#    [                                                   0.0                                                     0.0                                                      0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0                                                     0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0]
#    [  0.52371843618963284227446619567558627750258892774582    0.68531165547147357332974371146860903536435216665268     0.78438144434622076011515146021224609285127371549606     0.14882388779919572714682818315168333356268703937531     0.9563055715324349746742083056005867547355592250824      1.130088245027440019795095249577343565761111676693     0.07021786546480803057473929484899599628988653421402    0.10124067496791012629731021377210709033533930778503     0.11800601843943110680346109120364417321979999542236   0.095487225593287515697238365675048044067807495594025    0.20148495227443058343957948963520721008535474538803     0.36477496990292923584320305963046848773956298828125]
#    [                                                   0.0                                                     0.0                                                      0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0                                                     0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0]
#    [                                                   0.0                                                     0.0                                                      0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0                                                     0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0]
#    [                                                   0.0                                                     0.0                                                      0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0                                                     0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0]
#    [                                                   0.0                                                     0.0                                                      0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0                                                     0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0]
#    [0.0015076505203001442506627327588830667082220315933228  0.0014897574018081201699392757120676833437755703926086  -0.0014879201218094394859603468717068608384579420089722  -0.0016570651459028185731314763984300952870398759841919  0.0016537862850221846447440476879364723572507500648499  -0.001506398650986782647431816428706952137872576713562  -0.0015059411023642752663898036757927911821752786636353  0.0016559764781475926759268801902180712204426527023315  -0.0016711465928242463796493666450260207056999206542969  -0.001508519430005331521393863170033000642433762550354  0.0014879247919938236657810826102377177448943257331848  -0.0016676271814887854566533675892969768028706312179565]
#    [                                                   0.0                                                     0.0                                                      0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0                                                     0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0]
#    [                                                   0.0                                                     0.0                                                      0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0                                                     0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0]
#    [                                                   0.0                                                     0.0                                                      0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0                                                     0.0                                                      0.0                                                     0.0                                                     0.0                                                      0.0]
#__________
#dif = [ 0.028384714112463185557253204052978074666722053736343   0.020843501102619419477580127675808018056411873023769  0.0041853819389699391352698388800240177098259814255046  -0.00035205479789386130261116268607372383213684857273823  0.0016621036529160269115574793229506448006451940412756  -0.025165777917196113495629333051244597179401204311587  -0.037461132281912210696333870556554076329347092905691   0.021939015342208083590005249580162670413066830360471  0.0058019652541049273236022885474018372904337341635008   0.018195654399529513022393621057682475182252564134201   0.033087054153157565669783593554599731277414946862441   0.0021590245681731439493459187833079874863483090593179]
#      [-0.022891258909219834196638487895569283757595084024398  -0.028517475632124178221758778583172245036167629141935   0.023099564686755417503730180370857633830156469359891   -0.0083400129701363850296152941250920390191086393458707   -0.05193620415803576842364476492047907079523417463955  -0.067754562410867373255800750559121616716381254690975  -0.022276530207796160575539699572604961398121733204785  -0.033132743395520869437119564266721402079576598583886  -0.034072440930961962696388670440342437288130736380895  -0.028627233471329665542426125866738272981061299684185  -0.018092539664695233221621692449563876014641725575966  -0.0095758917222564030012764725741752438165285495355116]

# Release 0.1 from 2021/Fev/17
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.
