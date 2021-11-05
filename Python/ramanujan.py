# https://pbs.twimg.com/media/Ew8aapRXIAYuuAP?format=png&name=medium
# https://pbs.twimg.com/media/Ew8qUljXIAEwqC-?format=jpg&name=medium

from mpmath import *

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

def binom(n, p):
   if (mp.im(p) == 0) and (mp.re(n) < mp.re(p)):
      return 0
   result = 1
   for i in range(0, p):
      result = result * (n - i) / (i + 1)
   return result

def fatorial(x):
   result = 1
   while x > 1:
     result = result * x
     x = x - 1
   return result

# Directly from his lost notebook part 5
def ramanujan(a, q, n):
   prod = 1
   for k in range (0, n):
      prod = prod * (1 - a * power(q, k))
   return prod

def ramanujanv(v, q, n, count):
   prod = 1
   for i in range (0, count):
      prod = prod * ramanujan(v[i], q, n)
   return prod

def f0(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + power(q, n * n) / ramanujan(-q, q, n)
   return soma

def phi0(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + ramanujan(-q, q * q, n) * power(q, n * n)
   return soma

def psi0(q, infty):
   soma = 0
   for n in range (1, infty + 1):
      soma = soma + ramanujan(-q, q, n - 1) * power(q, n * (n + 1)/2)
   return soma

def F0(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + power(q, 2 * n * n) / ramanujan(q, q * q, n)
   return soma

def chi0(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      qn = power(q, n)
      soma = soma + qn / ramanujan(qn * q, q, n)
   return soma

def tilchi0(q, infty):
   soma = 1
   for n in range (0, infty + 1):
      soma = soma + power(q, 2 * n + 1) / ramanujan(power(q, n + 1), q, n + 1)
   return soma

def phi(p, infty):
   q = - p
   return ramanujan(q, q, infty) / ramanujan(-q, q, infty)

def psi(q, infty):
   q2 = q * q
   return ramanujan(q2, q2, infty) / ramanujan(q, q2, infty)

def Phi(q, infty):
   soma = -1
   for n in range (0, infty + 1):
      q4 = power(q, 4)
      q5 = q4 * q
      soma = soma + power(q5, n * n) / ramanujan(q, q5, n + 1) / ramanujan(q4, q5, n)
   return soma

def Psi(q, infty):
   soma = -1
   for n in range (0, infty + 1):
      q2 = q * q
      q3 = q2 * q
      q5 = q3 * q2
      soma = soma + power(q5, n * n) / ramanujan(q2, q5, n + 1) / ramanujan(q3, q5, n)
   return soma

def f1(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + power(q, n * n + n) / ramanujan(-q, q, n)
   return soma

def phi1(q, infty):
   soma = 0
   for n in range (1, infty + 1):
      soma = soma + ramanujan(-q, q * q, n - 1) * power(q, n * n)
   return soma

def psi1(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + ramanujan(-q, q, n) * power(q, n * (n + 1)/2)
   return soma

def F1(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      q2 = q * q
      soma = soma + power(q2, n * (n + 1)) / ramanujan(q, q2, n + 1)
   return soma

def chi1(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      qn = power(q, n)
      soma = soma + qn / ramanujan(qn * q, q, n + 1)
   return soma

def G(q, infty):
   q4 = power(q, 4)
   q5 = q4 * q
   return 1/ramanujan(q, q5, infty)/ramanujan(q4, q5, infty)

def H(q, infty):
   q2 = q * q
   q3 = q2 * q
   q5 = q3 * q2
   return 1/ramanujan(q2, q5, infty)/ramanujan(q3, q5, infty)

def A(q, infty):
   q5, g = power(q, 5), G(q, infty)
   return g * g * ramanujan(q5, q5, infty) / H(q, infty)

def D(q, infty):
   q5, h = power(q, 5), H(q, infty)
   return h * h * ramanujan(q5, q5, infty) / G(q, infty)

def f(a, b, infty):
   ab = a * b
   return ramanujanv([-a, -b, ab], ab, infty, 3)

def Jacobi(a, b, infty):
   soma = 1
   for n in range (1, infty + 1):
      soma = (soma + power(a,  n * ( n + 1)/2) * power(b,  n * ( n - 1)/2)
                   + power(a, -n * (-n + 1)/2) * power(b, -n * (-n - 1)/2))
   return soma

def Euler(q, infty):
   soma = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma = soma + sinal * power(q, n * (3 * n - 1)/2) + sinal * power(q, - n * (- 3 * n - 1)/2)
      sinal = - sinal
   return soma

def M1(q, infty):
   return chi0(q, infty) - 2 - 3 * Phi(q, infty) + A(q, infty)

def M2(q, infty):
   #original F0(q, infty) - 1 - Phi(q, infty) - q * psi(power(q, 5), infty) * H(q * q, infty)
   return F0(q, infty) - 1 - Phi(q, infty) + q * psi(power(q, 5), infty) * H(q * q, infty)

def M3(q, infty):
   q2, q5 = q * q, power(q, 5)
   #original phi0(-q, infty) - Phi(q, infty) - ramanujan(q5, q5, infty) * G(q2, infty) * H(q, infty) / H(q2, infty)
   return phi0(-q, infty) + Phi(q, infty) - ramanujan(q5, q5, infty) * G(q2, infty) * H(q, infty) / H(q2, infty)

def M4(q, infty):
   return psi0(q, infty) - Phi(q * q, infty) - q * H(q, infty) * f(- power(q, 9), - q, infty)

def M5(q, infty):
   return f0(q, infty) + 2 * Phi(q * q, infty) - phi(- power(q, 5), infty) * G(q, infty)

def M6(q, infty):
   return q * chi1(q, infty) - 3 * Psi(q, infty) - q * D(q, infty)

def M7(q, infty):
   return q * F1(q, infty) - Psi(q, infty) - q * psi(power(q, 5), infty) * G(q * q, infty)

def M8(q, infty):
   q2, q5 = q * q, power(q, 5)
   return - phi1(- q, infty) + Psi(q, infty) - q * ramanujan(q5, q5, infty) * G(q, infty) * H(q2, infty) / G(q2, infty)

def M9(q, infty):
   q2, q7 = q * q, power(q, 7)
   q3 = q2 * q
   return psi1(q, infty) - Psi(q2, infty)/q - G(q, infty) * f(- q7, - q3, infty)

def M10(q, infty):
   return f1(q, infty) + 2 * Psi(q * q, infty)/q - phi(- power(q, 5), infty) * H(q, infty)

def eq341(q, infty):
   return psi1(q, infty) - phi1(- q * q, infty)/q - phi(q, infty) * H(- q, infty)

def eq342(q, infty):
   return f1(q, infty) + 2 * q * F1(q * q, infty) - phi(q, infty) * H(- q, infty)

def eq343(q, infty):
   return f1(q, infty) + 2/q * phi1(- q * q, infty) - phi(- q, infty) * H(q, infty)

def eq344(q, infty):
   q2 = q * q
   q4 = q2 * q2
   return psi1(q, infty) - q * F1(q2, infty) - psi(q2, infty) * G(q4, infty)

def eq345(q, infty):
   return psi0(q, infty) + phi0(- q * q, infty) - phi(q, infty) * G(- q, infty)

def eq346(q, infty):
   return f0(q, infty) + 2 * F0(q * q, infty) - 2 - phi(q, infty) * G(- q, infty)

def eq347(q, infty):
   return f0(q, infty) - 2 * phi0(- q * q, infty) + phi(- q, infty) * G(q, infty)

def eq348(q, infty):
   q2 = q * q
   q4 = q2 * q2
   return psi0(q, infty) - F0(q2, infty) + 1 - q * psi(q2, infty) * H(q4, infty)

def eq349(q, infty):
   return chi0(q, infty) + phi0(-q, infty) - 2 * F0(q, infty)

def eq3410(q, infty):
   return chi0(q, infty) - tilchi0(q, infty)

def eq3411(q, infty):
   return chi1(q, infty) - phi1(- q, infty)/q - 2 * F1(q, infty)

def W1(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + power(q, n) / ramanujan(q, q, n) / ramanujan(q, q * q, n)
   return soma

def eq3412(q, infty):
   return W1(q, infty) - phi0(-q, infty)/phi(-q, infty)

def W2(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + power(q, n + 1) / ramanujan(q, q, n) / ramanujan(q, q * q, n + 1)
   return soma

def eq3413(q, infty):
   return W2(q, infty) + phi1(-q, infty)/phi(-q, infty)

def W3(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + power(q, 2 * n + 1) / ramanujan(q, q, n) / ramanujan(q, q * q, n + 1)
   return soma

def eq3414(q, infty):
   return W3(q, infty) - (1 - phi0(-q, infty))/phi(-q, infty)

def V1(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      q2 = q * q
      soma = soma + ramanujan(-q, q2, n) * power(q, 2 * n + 1) / ramanujan(q2, q2, 2 * n)
   return soma

def eq354(q, infty):
   return V1(q, infty) - q * psi1(- q, infty) / psi(- q, infty)

def V2(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      q2 = q * q
      soma = soma + ramanujan(-q, q2, n + 1) * power(q, 2 * n + 1) / ramanujan(q2, q2, 2 * n + 1)
   return soma

def eq355(q, infty):
   return V2(q, infty) + psi0(-q, infty) / psi(- q, infty)

def V3(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      q2 = q * q
      soma = soma + ramanujan(-q, q2, n) * power(q, 4 * n + 2) / ramanujan(q2, q2, 2 * n)
   return soma

def eq356(q, infty):
   return V3(q, infty) - q * q * (1 + psi0(-q, infty)) / psi(- q, infty)

def bracket(a, q, n):
   return ramanujan(a, q, n) * ramanujan(q/a, q, n)

def bracketv(v, q, n, count):
   prod = 1
   for i in range (0, count):
      prod = prod * bracket(v[i], q, n)
   return prod

def eq451(q, infty):
   q2, q16 = q * q, power(q, 16)
   q6 = q2 * q2 * q2
   y, z1, z2 = ramanujan(q2, q2, infty), bracket(- q6, q16, infty), bracket(- q2, q16, infty)
   return 1/ramanujan(q, q, infty) - ramanujan(q16, q16, infty) / y / y * (z1 + q * z2)

def HH(a, b, c, q, infty):
   return bracketv([a * b, b * c, c * a], q, infty, 3) * ramanujan(q, q, infty) / bracketv([a, b, c, a * b * c], q, infty, 4)

def eq454(q, a, b, c, d, infty):
   q2 = q * q
   return HH(a, b, c, q2, infty) - HH(a, b, d, q2, infty) - HH(c, 1/d, a * b * d, q2, infty)

def eq455(q, a, b, infty):
   q2 = q * q
   return HH(a, a, q/a, q2, infty) + HH(b, b, q/b, q2, infty) - 2 * HH(a, q/a, b, q2, infty)

def eq456(q, a, b, infty):
   q2 = q * q
   return HH(a, a, q/a, q2, infty) - HH(b, b, q/b, q2, infty) - 2 * HH(a, q/a, b/q, q2, infty)

def eq531(q, infty):
   return M5(q, infty) - 2 * M3(q * q, infty)

def eq532(q, infty):
   return M5(q, infty) + 2 * M2(q * q, infty)

def eq533(q, infty):
   return M4(-q, infty) + M3(q * q, infty)

def eq534(q, infty):
   q2 = q * q
   return M1(q2, infty) + 3 * M3(q2, infty)

def eq539(q, infty):
   return q * M10(q, infty) - 2 * M8(q * q, infty)

def eq5310(q, infty):
   return q * M10(q, infty) + 2 * M7(q * q, infty)

def eq5311(q, infty):
   return q * M9(q, infty) + M8(q, infty)

def eq5312(q, infty):
   return M6(q, infty) + 3 * M8(q, infty)

def sg(n):
   if n >= 0:
      return 1
   return -1

def sigma_rs(q, r, s, n):
   t = r + s
   return sg(r) * power(-1, (r - s)/2) * power(q, r * s + 3/8 * t * t + n * t/4)

def Sigma(q, n, infty):
   soma = sigma_rs(q, 0, 0, n)
   for r in range (2, infty + 1):
      if r % 2 == 0:
         soma = soma + sigma_rs(q, r, 0, n)
   for s in range (2, infty + 1):
      if s % 2 == 0:
         soma = soma + sigma_rs(q, 0, s, n)
   for r in range (1, infty + 1):
      for s in range (1, infty + 1):
         if (r - s) % 2 == 0:
            soma = soma + sigma_rs(q, r, s, n) + sigma_rs(q, -r, -s, n)
   return soma

def eq613(q, infty):
   return ramanujan(q, q, infty) * f0(q, infty) - Sigma(q, 1, infty)

def eq614(q, infty):
   return ramanujan(q, q, infty) * f1(q, infty) - Sigma(q, 3, infty)

def Sigma2(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      for k in range (-n, n + 1):
         soma = soma + power(-1, k) * (1 - power(q, 4 * n + 2)) * power(q, n * (5 * n + 1)/2 - k * k)
   return soma

def eq621(q, infty):
   return Sigma(q, 1, infty) - Sigma2(q, infty)

def Sigma3(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      for k in range (-n, n + 1):
         soma = soma + power(-1, k) * (1 - power(q, 2 * n + 1)) * power(q, n * (5 * n + 3)/2 - k * k)
   return soma

def eq622(q, infty):
   return Sigma(q, 3, infty) - Sigma3(q, infty)

def lemma631(q, x, infty):
   x2, q2 = x * x, q * q
   x3 = x2 * x
   return f(- q * x3, - q2/x3, infty) + x * f(-x3 * q2, -q/x3, infty) - f(-q, -q2, infty) * f(-x2, -q/x2, infty)/f(-x, -q/x, infty)

def lemma632(q, x, y, infty):
   xy, q2 = x * y, q * q
   return f(-x, -q/x, infty) * f(-y, -q/y, infty) - f(xy, q2/xy, infty) * f(q * y/x, q * x/y, infty) + x * f(q * xy, q/xy, infty) * f(y/x, q2 * x/y, infty)

def lemma633(q, x, y, infty):
   xy = x * y
   return f(x, q/x, infty) * f(-y, -q/y, infty) - f(-x, -q/x, infty) * f(y, q/y, infty) - 2 * x * f(-y/x, -q*q*x/y, infty) * f(-q*xy, -q/xy, infty)

# |q| < |x| < 1
def lemma634(q, x, y, infty):
   infty = 3 * infty
   soma = 1/(1 - y)
   for r in range (1, infty + 1):
      soma = soma + power(x, r)/(1 - y * power(q, r)) + 1/power(x, r)/(1 - y / power(q, r))
   z, xy = f(-q, -q * q, infty), x * y
   return z * z * z * f(-xy, -q/xy, infty) / f(-x, -q/x, infty) / f(-y, -q/y, infty) - soma

def tau_rs(q, x, y, r, s):
   return sg(r) * power(x, r) * power(y, s) * power(q, r * s)

def tau2_rs(q, x, y, r, s):
   x2, y2, q4 = x * x, y * y, power(q, 4)
   return sg(r) * power(x2, r) * power(y2, s) * power(q4, r * s)

def tau3_rs(q, x, y, r, s):
   q2, x2, y2 = q * q, x * x, y * y
   q2x2, q2y2, q4 = q2 * x2, q2 * y2, q2 * q2
   return sg(r) * power(q2x2, r) * power(q2y2, s) * power(q4, r * s)

def lemma635(q, x, y, infty):
   infty = 2 * infty
   soma = tau_rs(q, x, y, 0, 0)
   for r in range (1, infty + 1):
      soma = soma + tau_rs(q, x, y, r, 0)
   for s in range (1, infty + 1):
      soma = soma + tau_rs(q, x, y, 0, s)
   for r in range (1, infty + 1):
      for s in range (1, infty + 1):
         soma = soma + tau_rs(q, x, y, r, s) + tau_rs(q, x, y, -r, -s)
   z, xy = f(-q, -q * q, infty), x * y
   prod = z * z * z * f(-xy, -q/xy, infty) / f(-x, -q/x, infty) / f(-y, -q/y, infty) - soma
   #original: soma - prod = 0
   return soma + prod

#*** I don't know what's going on here.
def lemma636(q, x, y, infty):
   infty = 2 * infty
   soma = tau_rs(q, x, y, 0, 0)
   for r in range (2, infty + 1):
      if r % 2 == 0:
         soma = soma + tau_rs(q, x, y, r, 0)
   for s in range (2, infty + 1):
      if s % 2 == 0:
         soma = soma + tau_rs(q, x, y, 0, s)
   for r in range (1, infty + 1):
      for s in range (1, infty + 1):
         if (r - s) % 2 == 0:
            soma = soma + tau_rs(q, x, y, r, s) + tau_rs(q, x, y, -r, -s)
   #xy, x2, y2, q2 = x * y, x * x, y * y, q * q
   #x2y2 = x2 * y2
   #prod1 = (phi(-q2, infty) * f(-q*xy, -q/xy, infty) * f(q*x/y, q*y/x, infty) * f(-x2y2, - q2 * q2/x2y2, infty)
   #         / f(-x2, -q2/x2, infty) / f(-y2, -q2/y2, infty))
   #original: soma - prod1
   z, xy = f(-q, -q * q, infty), x * y
   prod2 = z * z * z * f(-xy, -q/xy, infty) / f(-x, -q/x, infty) / f(-y, -q/y, infty) - soma
   return soma + prod2

def eq6411(q, x, infty):
   soma1 = 0
   for n in range (0, infty + 1):
      soma1 = soma1 + power(q, n * n) / ramanujan(x, q, n + 1) / ramanujan(q/x, q, n)
   soma2 = 1/(1 - x)
   sinal = -1
   for n in range (1, infty + 1):
      soma2 = (soma2 + sinal * power(q, 3 * n * (n + 1)/2) / (1 - x * power(q, n))
                     + sinal * power(q, -3 * n * (-n + 1)/2) / (1 - x * power(q, -n)))
      sinal = - sinal
   return 1/x * (-1 + soma1) - 1/ramanujan(q, q, infty) * soma2

def Omega(q, c, w, infty):
   soma = 1
   for n in range (1, infty + 1):
      soma = (soma + power(c*w, n) * power(q, n * (n - 1)/2)
                   + power(c*w, -n) * power(q, -n * (-n - 1)/2))
   return soma

def eq721(q, n, infty):
   w = mp.root(1, 3, n)
   q3 = q * q * q
   return Omega(q, -1, w, infty) - (1 - w) * ramanujan(q3, q3, infty)

def eq722(q, n, infty):
   w = mp.root(1, 3, n)
   q3 = q * q * q
   q6 = q3 * q3
   return Omega(q, 1, w, infty) - (1 + w) * phi(-q, infty) * ramanujan(q6, q6, infty) / ramanujan(q3, q3, infty)

def eq723(q, m, infty):
   w = mp.root(1, 3, m)
   soma1 = 1
   sinal = -1
   q2 = q * q
   wqq = w * q2
   wwqq = wqq * w
   for n in range (1, infty + 1):
      qn = power(q, n)
      soma1 = (soma1 + sinal * power(wqq, n * (n - 1)/2) * qn
                     + sinal * power(wqq, -n * (-n - 1)/2) / qn)
      sinal = - sinal
   soma2 = 1
   sinal = -1
   for n in range (1, infty + 1):
      qn = power(q, n)
      soma2 = (soma2 + sinal * power(wwqq, n * (n - 1)/2) * qn
                     + sinal * power(wwqq, -n * (-n - 1)/2) / qn)
      sinal = - sinal
   q15, q3 = power(q, 15), q2 * q
   q5, q18 = q3 * q2, q15 * q3
   q6 = q5 * q
   z = ramanujan(q6, q6, infty)
   return (soma1 * soma2 - z * z * z * ramanujanv([q, q5, q6], q6, infty, 3)
           / ramanujan(q2, q2, infty) / ramanujanv([q3, q15, q18], q18, infty, 3))

def eq726(q, n, x, z, infty):
   xn, qn, xz = power(x, n), power(q, n), x * z
   xnz, y, w = xn * z, ramanujan(q, q, infty), ramanujan(qn, qn, infty)
   soma = 0
   for k in range (0, n):
      qkz, qnk = power(q, k) * z, power(q, n - k)
      soma = (soma + power(x, k) * ramanujanv([xn * qkz, qnk/xnz, qn], qn, infty, 3)
              / ramanujanv([qkz, qnk/z, qn], qn, infty, 3))
   return (y * y * y * ramanujanv([xz, q/xz, q], q, infty, 3) * ramanujanv([xn, qn/xn, qn], qn, infty, 3)
           / (w * w * w * ramanujanv([x, q/x, q], q, infty, 3) * ramanujanv([z, q/z, q], q, infty, 3)) - soma)

def eq7211(q, n, x, infty):
   qn2 = power(q, n * n)
   soma = 0
   sinal = 1
   for k in range (0, n):
      z = power(-1, n + 1) * power(x, n)
      soma = (soma + sinal * power(x, k) * power(q, k * (k - 1)/ 2)
              * ramanujanv([z * power(q, n * (n - 1)/2 + k * n),
                1/z * power(q, n * (n + 1)/2 - k * n), qn2], qn2, infty, 3))
      sinal = - sinal
   return ramanujanv([x, q/x, q], q, infty, 3) - soma

def eq7214(q, infty):
   q3 = q * q * q
   q9 = q3 * q3 * q3
   q15, q18 = q9 * q3 * q3, q9 * q9
   return ramanujanv([q9, q9, q18], q18, infty, 3) - 2 * q * ramanujanv([q3, q15, q18], q18, infty, 3) - phi(-q, infty)

def eq7215(q, infty):
   q3 = q * q * q
   q6 = q3 * q3
   q9 = q3 * q6
   return (2 * ramanujanv([-q3, -q6, q9], q9, infty, 3) + q * ramanujanv([-1, -q9, q9], q9, infty, 3)
           - ramanujanv([-1, -q, q], q, infty, 3))

def eq7216(q, infty):
   q2 = q * q
   q3 = q2 * q
   q5, q6 = q2 * q3, q3 * q3
   q9 = q6 * q3
   q15, q18 = q9 * q6, q9 * q9
   return (ramanujanv([q9, q9, q18], q18, infty, 3) + q * ramanujanv([q3, q15, q18], q18, infty, 3)
           - ramanujan(q2, q2, infty) * ramanujan(q6, q6, infty) / ramanujanv([q, q5, q6], q6, infty, 3))

def eq7217(q, infty):
   q2 = q * q
   q3 = q2 * q
   q5, q6 = q2 * q3, q3 * q3
   q9 = q6 * q3
   q15, q18 = q9 * q6, q9 * q9
   z, w = ramanujanv([q, q, q2], q2, infty, 3), ramanujanv([q9, q9, q18], q18, infty, 3)
   t = ramanujan(q6, q6, infty)
   return (z * z + 3 * w * w - 4 * t * t * t * ramanujanv([q, q5, q6], q6, infty, 3)
           / ramanujan(q2, q2, infty) / ramanujanv([q3, q15, q18], q18, infty, 3))

def phi6(q, infty):
   soma = 0
   sinal = 1
   for n in range (0, infty + 1):
      soma = soma + sinal * ramanujan(q, q * q, n) * power(q, n * n) / ramanujan(-q, q, 2*n)
      sinal = - sinal
   return soma

# 7.3.16
def Sn(q, n):
   if n >= 0:
      ini = -n
      fim = n + 1
      prod = 1
   else:
      ini = n
      fim = -n
      prod = -1
   soma = 0
   sinal = power(-1, ini)
   for k in range (ini, fim):
      soma = soma + sinal * power(q, - k * k)
      sinal = - sinal
   return prod * soma

#*** 1 not zero 0.5, 1.3
def eq7320(q, infty):
   infty = 2 * infty
   soma = 1
   sinal = -1
   neg = 0
   for n in range (1, infty + 1):
      soma = soma + sinal * power(q, 3 * n * n + n) * Sn(q, n)
      neg = neg + sinal * power(q, 3 * n * n - n) * Sn(q, -n)
      sinal = - sinal
   prod = psi(q, infty) * phi6(q, infty)
   return prod - soma - neg

def psi6(q, infty):
   soma = 0
   sinal = 1
   for n in range (0, infty + 1):
      z = n + 1
      soma = soma + sinal * ramanujan(q, q * q, n) * power(q, z * z) / ramanujan(-q, q, 2*n + 1)
      sinal = - sinal
   return soma

#*** 2 not zero 2.2
def eq7321(q, infty):
   infty = 2 * infty
   soma = 0
   sinal = 1
   for n in range (0, infty + 1):
      soma = soma + sinal * power(q, 3 * n * n + 3 * n + 1) * Sn(q, n) + sinal * power(q, 3 * n * n - 3 * n + 1) * Sn(q, -n)
      sinal = - sinal
   return psi(q, infty) * psi6(q, infty) - soma

def rho6(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + ramanujan(-q, q, n) * power(q, binom(n + 1, 2)) / ramanujan(q, q*q, n + 1)
   return soma

#*** 3 not zero 3.8, 1.9
def eq7322(q, infty):
   infty = 2 * infty
   soma = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma = soma + sinal * power(q, 3 * n * (n + 1)/2) * Sn(q, n) + sinal * power(q, -3 * n * (-n + 1)/2) * Sn(q, -n)
      sinal = - sinal
   return phi(-q, infty) * rho6(q, infty) - soma

def sigma6(q, infty):
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + ramanujan(-q, q, n) * power(q, binom(n + 2, 2)) / ramanujan(q, q*q, n + 1)
   return soma

#*** 4 not zero 5.4, 3.4
def eq7323(q, infty):
   infty = 2 * infty
   soma = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma = soma + sinal * power(q, (n + 1) * (3 * n + 2)/2) * Sn(q, n) + sinal * power(q, (-n + 1) * (-3 * n + 2)/2) * Sn(q, -n)
      sinal = - sinal
   return phi(-q, infty) * sigma6(q, infty) - soma

def lambda6(q, infty):
   soma = 0
   sinal = 1
   for n in range (0, infty + 1):
      soma = soma + sinal * ramanujan(q, q * q, n) * power(q, n) / ramanujan(-q, q, n)
      sinal = - sinal
   return soma

#*** 5 not zero 10.1, 6.3
def eq7324(q, infty):
   infty = 2 * infty
   soma = 0
   sinal = 1
   for n in range (0, infty + 1):
      soma = soma + sinal * power(q, 3 * n * (n + 1)/2) * Sn(q, n) + sinal * power(q, -3 * n * (-n + 1)/2) * Sn(q, -n)
      sinal = - sinal
   return psi(q, infty) * lambda6(q, infty) - soma

#*** 6 not zero 3.2, 1.7
def eq7325(q, infty):
   infty = 2 * infty
   soma = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma = soma + sinal * power(q, n * (3 * n + 1)/2) * Sn(q, n) + sinal * power(q, -n * (-3 * n + 1)/2)* Sn(q, -n)
      sinal = - sinal
   return 2 * psi(q, infty) * mu6(q, infty) - soma

def gamma6(q, infty):
   q3 = q * q * q
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + power(q, n * n) / ramanujan(q3, q3, n)
   return soma

#*** 7 not zero 9e-2, 0.3
def eq7326(q, infty):
   infty = 2 * infty
   soma = 1/3
   sinal = -1
   for n in range (1, infty + 1):
      qn = power(q, n)
      qn2 = qn * qn
      soma = (soma + sinal * power(qn, (3 * n + 1)/2) / (1 + qn + qn2)
              + sinal * power(1/qn, (-3 * n + 1)/2) / (1 + 1/qn + 1/qn2))
      sinal = - sinal
   prod = ramanujan(q, q, infty) * gamma6(q, infty)
   return prod - 3 * soma

def ipsilon_rs(q, r, s, n):
   return sg(r) * power(-1, r) * power(q, r * s + binom(r + s + n, 2))

def Ipsilon(q, n, infty):
   soma = ipsilon_rs(q, 0, 0, n)
   for r in range (1, infty + 1):
      soma = soma + ipsilon_rs(q, r, 0, n)
   for s in range (1, infty + 1):
      soma = soma + ipsilon_rs(q, 0, s, n)
   for r in range (1, infty + 1):
      for s in range (1, infty + 1):
         soma = soma + ipsilon_rs(q, r, s, n) + ipsilon_rs(q, -r, -s, n)
   return soma

#*** 8 not zero 0.5, 0.6
def eq741(q, infty):
   infty = 2 * infty
   return psi(q, infty) * phi6(q, infty) - Ipsilon(q, 1, infty)

#*** 9 not zero 0.9, 1.8
def eq742(q, infty):
   infty = 2 * infty
   return 2 * psi(q, infty) * psi6(q, infty) - Ipsilon(q, 2, infty)

def eq7433(q, infty):
   soma1 = q/(1 + q)
   for n in range (1, infty + 1):
      soma1 = (soma1 + power(q, (2*n + 1)*(3*n + 1))/(1 + power(q, 3 * n + 1))
               + power(q, (-2*n + 1)*(-3*n + 1))/(1 + power(q, -3 * n + 1)))
   soma2 = 0
   for n in range (1, infty + 1):
      qn = power(q, n)
      soma2 = soma2 + power(qn, 6*n + 1)/(1 - qn + qn * qn)
   return ramanujan(q, q, infty) * phi6(q, infty) - 1 + 2 * soma1 - 2 * soma2

#*** 10 not zero (0), (-0.0287893590657443 + 0.005316296734866j)
def eq7434(q, infty):
   infty = 2 * infty
   q2 = q * q
   q3 = q2 * q
   soma = 1/2
   for n in range (1, infty + 1):
      qn = power(q, n)
      q3n = qn * qn * qn
      soma = (soma + power(qn, (3*n + 1)/2) / (1 + q3n)
              + power(1/qn, (-3*n + 1)/2) / (1 + 1/q3n))
   return ramanujanv([-q, -q2, q3], q3, infty, 3) * phi6(q, infty) - 2 * soma

def eq7435(q, infty):
   q3 = q * q * q
   soma = 1/(1 + q)
   for n in range (1, infty + 1):
      q3n = power(q3, n)
      soma = (soma + power(q3n, (n + 1)/2) / (1 + q3n * q)
              + power(1/q3n, (-n + 1)/2) / (1 + 1/q3n * q))
   return psi(q3, infty) * phi6(q, infty) - soma

def eq7436(q, infty):
   q2 = q * q
   q3 = q2 * q
   soma = q/(1 + q)
   for n in range (1, infty + 1):
      soma = (soma + power(q, (n + 1)*(3*n + 2)/2) / (1 + power(q, 3*n + 1))
              + power(q, (-n + 1)*(-3*n + 2)/2) / (1 + power(q, -3*n + 1)))
   return ramanujanv([-q, -q2, q3], q3, infty, 3) * psi6(q, infty) - soma

def eq7444(q, infty):
   w = mp.exp(2*mp.pi()*j/3)
   w2, q3 = w * w, q * q * q
   q6 = q3 * q3
   q9, z, t = q3 * q6, ramanujan(q6, q6, infty), psi(q3, infty)
   return (psi6(w * q, infty) - psi6(w2 * q, infty))/q/(w - w2) - psi(q, infty) * psi(q9, infty) * z * z / t / t / t

def eq7445(q, infty):
   q3 = q * q * q
   q6 = q3 * q3
   q9, z = q3 * q6, ramanujan(q6, q6, infty)
   return phi6(q9, infty) - psi6(q, infty) - psi6(q9, infty)/q3 - psi(q3, infty) * z * z / psi(q, infty) / psi(q9, infty)

def eq751(q, infty):
   q2, q5 = q * q, power(q, 5)
   q6, z = q5 * q, ramanujan(-q, q2, infty)
   return psi6(q2, infty)/q + rho6(q, infty) - z * z * ramanujanv([-q, -q5, q6], q6, infty, 3)

def eq752(q, infty):
   q2 = q * q
   q3 = q2 * q
   q6, z = q3 * q3, ramanujan(-q, q2, infty)
   return phi6(q2, infty) + 2 * sigma6(q, infty) - z * z * ramanujanv([-q3, -q3, q6], q6, infty, 3)

def Phi6(q, infty):
   q2 = q * q
   soma = 0
   for n in range (0, infty + 1):
      z = ramanujan(q, q2, n + 1)
      soma = soma + ramanujan(-q, q, n) * power(q, n + 1) / z / z
   return soma

#*** 11 not zero 1e-3
def eq753(q, infty):
   infty = 100
   q3, z = q * q * q, psi(q, infty)
   return rho6(q, infty) - 2/q * Phi6(q3, infty) - z * z / phi(- q3, infty)

def mu6(q, infty):
   q2 = q * q
   soma = 0
   sinal = 1
   for n in range (0, infty + 1):
      soma = soma + sinal * ramanujan(q, q2, n) / ramanujan(-q, q, n)
      sinal = - sinal
   return soma

#*** 12 not zero 3, 0.7
def eq7517(q, infty):
   q2 = q * q
   q3 = q2 * q
   q6, z = q3 * q3, ramanujan(-q, q2, infty)
   return 2 * phi6(q2, infty) - 2 * mu6(-q, infty) - z * z * ramanujanv([-q3, -q3, q6], q6, infty, 3)

def eq7518(q, infty):
   q2, q5 = q * q, power(q, 5)
   q6, z = q5 * q, ramanujan(-q, q2, infty)
   return 2/q * psi6(q2, infty) + lambda6(-q, infty) - z * z * ramanujanv([-q, -q5, q6], q6, infty, 3)

#*** 13 not zero 0.6
def eq7529(q, infty):
   q2 = q * q
   q3, z = q2 * q, phi(-q, infty)
   return 2 * gamma6(q, infty) - 3 * phi6(q, infty) + z * z / ramanujanv([-q, -q2, q3], q3, infty, 3)

#*** 14 not zero 0.3
def eq761(q, infty):
   q3 = q * q * q
   q6 = q3 * q3
   soma = 1
   sinal = -1
   for n in range (1, infty + 1):
      w = ramanujan(-q3, q3, n)
      soma = soma + sinal * ramanujan(q3, q6, n) / w / w
      sinal = - sinal
   z = phi(-q, infty)
   return soma - 2 * psi6(q, infty) - z * z / 2 / psi(q3, infty)

#*** 15 not zero 1.8, 0.8
def eq764(q, infty):
   q2 = q * q
   soma1 = 0
   for n in range (1, infty + 1):
      qn = power(q, n)
      soma1 = soma1 + ramanujan(-q, q, 2*n - 1) * qn / ramanujan(q, q2, n)
   soma2 = 0
   for n in range (1, infty + 1):
      q2n = power(q2, n)
      soma2 = soma2 + n/3 * q2n / (1 - q2n)
   return phi6(q, infty) + 2 * soma1 - 1/ramanujan(q, q, infty) * (1 + 6 * soma2)

def B0(n, z):
   return ramanujan(z*q, q, n) / ramanujan(q, q, 2*n)

def A0(n, z):
   soma = 0
   for k in range (0, n + 1):
      nk = n - k
      soma = (soma + ramanujan(power(q, nk + 1), q, 2*k) * power(-1, nk) * power(q, binom(nk, 2))
              * B0(k, z))
   return soma

def eq823(q, n, z, infty):
   return (A0(n, z) + z * power(q, n) * A0(n - 1, z) - z * power(q, 3*n - 3) * A0(n - 2, z)
           - power(q, 4 * n - 7) * A0(n - 3, z))

def B1(n, z):
   if n == 0:
      return 0
   return ramanujan(z*q, q, n - 1) / ramanujan(q, q, 2*n - 1)

def A1(n, z):
   soma = 0
   for k in range (1, n + 1):
      nk = n - k
      soma = (soma + ramanujan(power(q, nk + 1), q, 2*k - 1) * power(-1, nk) * power(q, binom(nk, 2))
              * B1(k, z))
   return soma

def eq8210(q, n, z, infty):
   return (A1(n, z) + z * power(q, n - 1) * A1(n - 1, z) - z * power(q, 3*n - 5) * A1(n - 2, z)
           - z * power(q, 4*n - 9) * A1(n - 3, z))

def B2(n, z):
   return ramanujan(z*q, q, n) / ramanujan(q, q, 2*n + 1)

def A2(n, z):
   soma = 0
   for k in range (1, n + 1):
      nk = n - k
      soma = (soma + ramanujan(power(q, nk + 1), q, 2*k) * power(-1, nk) * power(q, binom(nk, 2))
              * B2(k, z))
   return (1 - power(q, 2*n + 1)) * soma

def eq8213(q, n, z, infty):
   return (A2(n, z) + z * power(q, n) * A2(n - 1, z) - power(q, 2*n + 1) * (1 + z * power(q, n - 2))
           * A2(n - 2, z) - power(q, 3*n - 1) * (z + power(q, n - 2)) * A2(n - 3, z)
           + z * power(q, 5*n - 8) * A2(n - 4, z))

def S(n, q):
   soma = 0
   for k in range (-n, n + 1):
      soma = soma + power(q, - k*k)
   return soma

def T(n, q):
   soma = 0
   for k in range (0, n + 1):
      soma = soma + power(q, - k*k - k)
   return soma

def eq8216(q, n, infty):
   u = 3 * n * n
   return A0(2 * n, 1) - 2 * power(q, u) * T(n - 1, q) + power(q, u - n) * S(n - 1, q)

def eq8217(q, n, infty):
   u = 3 * n * n
   return A0(2 * n - 1, 1) + power(q, u - 3*n + 1) * S(n - 1, q) - 2 * power(q, u - 4*n + 1) * T(n - 2, q)

def eq8220(q, n, infty):
   return A1(2*n, 1) + q * power(q, 3*n*n - 2*n) * T(n - 1, q)

def eq8221(q, n, infty):
   return A1(2*n + 1, 1) - q * power(q, 3*n*n + n) * S(n, q)

def eq8224(q, n, infty):
   u = 3 * n * n
   return A2(2*n, 1) - 2 * power(q, u + 2*n) * T(n, q) - power(q, u + n) * S(n - 1, q)

def eq8225(q, n, infty):
   u = 3 * n * n
   return A2(2*n - 1, 1) + power(q, u - n) * S(n, q) + 2 * power(q, u - 2*n) * T(n - 2, q)

def phi10(q, infty):
   q2 = q * q
   soma = 0
   for n in range (0, infty + 1):
      soma = soma + power(q, binom(n + 1, 2)) / ramanujan(q, q2, n + 1)
   return soma

def eq831(q, infty):
   soma1 = 0
   for n in range (0, infty + 1):
      soma1 = soma1 + power(q, 5*n*n + 2*n) * (1 - power(q, 6*n + 3)) * S(n, q)
   soma2 = 0
   for n in range (0, infty + 1):
      soma2 = soma2 + power(q, 5*n*n + 7*n + 2) * (1 - power(q, 6*n + 6)) * T(n, q)
   return phi10(q, infty) - 1/phi(-q, infty) * (soma1 - 2 * soma2)

def psi10(q, infty):
   q2 = q * q
   soma = 0
   for n in range (1, infty + 1):
      soma = soma + power(q, binom(n + 1, 2)) / ramanujan(q, q2, n)
   return soma

def eq833(q, infty):
   soma1 = 0
   for n in range (0, infty + 1):
      soma1 = soma1 + power(q, 5*n*n + 4*n + 1) * (1 - power(q, 2*n + 1)) * S(n, q)
   soma2 = 0
   for n in range (0, infty + 1):
      soma2 = soma2 + power(q, 5*n*n + 9*n + 4) * (1 - power(q, 2*n + 2)) * T(n, q)
   return psi10(q, infty) - 1/phi(-q, infty) * (soma1 - 2 * soma2)

def X10(q, infty):
   soma = 0
   sinal = 1
   for n in range (0, infty + 1):
      soma = soma + sinal * power(q, n * n) / ramanujan(-q, q, 2*n)
      sinal = - sinal
   return soma

def eq836(q, infty):
   q2 = q * q
   soma1 = 0
   for n in range (0, infty + 1):
      soma1 = soma1 + power(q, 10*n*n + 2*n) * (1 - power(q, 16*n + 8)) * S(n, q2)
   soma2 = 0
   for n in range (0, infty + 1):
      soma2 = soma2 + power(q, 10*n*n + 12*n + 3) * (1 - power(q, 16*n + 16)) * T(n, q2)
   return X10(q, infty) - 1/psi(q, infty) * (soma1 + 2 * soma2)

def chi10(q, infty):
   soma = 0
   sinal = 1
   for n in range (1, infty + 1):
      soma = soma + sinal * power(q, n * n) / ramanujan(-q, q, 2*n - 1)
      sinal = - sinal
   return soma

def eq838(q, infty):
   soma1 = 0
   for n in range (0, infty + 1):
      for k in range (0, n + 1):
         soma1 = soma1 + power(q, 10*n*n + 16*n + 6 - 2*k*k - 2*k) * (1 - power(q, 8*n + 8))
   soma2 = 0
   for n in range (0, infty + 1):
      for k in range (-n, n + 1):
         soma2 = soma2 + power(q, 10*n*n + 6*n + 1 - 2*k*k) * (1 - power(q, 8*n + 4))
   return chi10(q, infty) - 1/psi(q, infty) * (2 * soma1 + soma2)

def eq839_rs(q, r, s):
   t = r + s
   return sg(r) * power(-1, t) * power(q, t*t + r * s + t)

def eq839(q, infty):
   soma = eq839_rs(q, 0, 0)
   for r in range (1, infty + 1):
      soma = soma + eq839_rs(q, r, 0)
   for s in range (1, infty + 1):
      soma = soma + eq839_rs(q, 0, s)
   for r in range (1, infty + 1):
      for s in range (1, infty + 1):
         soma = soma + eq839_rs(q, r, s) + eq839_rs(q, -r, -s)
   return phi10(q, infty) - 1/phi(-q, infty) * soma

def eq8312_rs(q, r, s):
   t = r + s
   return sg(r) * power(-1, t + 1) * power(q, t*t + r * s + 3 * t + 2)

def eq8312(q, infty):
   soma = eq8312_rs(q, 0, 0)
   for r in range (1, infty + 1):
      soma = soma + eq8312_rs(q, r, 0)
   for s in range (1, infty + 1):
      soma = soma + eq8312_rs(q, 0, s)
   for r in range (1, infty + 1):
      for s in range (1, infty + 1):
         soma = soma + eq8312_rs(q, r, s) + eq8312_rs(q, -r, -s)
   return psi10(q, infty) - 1/phi(-q, infty) * soma

def eq8313_rs(q, r, s):
   t = r + s
   return sg(r) * power(q, 2*t*t + 2 * r * s + 3 * t + 1)

def eq8313(q, infty):
   soma = eq8313_rs(q, 0, 0)
   for r in range (1, infty + 1):
      soma = soma + eq8313_rs(q, r, 0)
   for s in range (1, infty + 1):
      soma = soma + eq8313_rs(q, 0, s)
   for r in range (1, infty + 1):
      for s in range (1, infty + 1):
         soma = soma + eq8313_rs(q, r, s) + eq8313_rs(q, -r, -s)
   return chi10(q, infty) - 1/psi(q, infty) * soma

def eq8322_rs(q, r, s):
   t = r + s
   return sg(r) * power(q, 2*t*t + 2 * r * s + t)

def eq8322(q, infty):
   soma = eq8322_rs(q, 0, 0)
   for r in range (1, infty + 1):
      soma = soma + eq8322_rs(q, r, 0)
   for s in range (1, infty + 1):
      soma = soma + eq8322_rs(q, 0, s)
   for r in range (1, infty + 1):
      for s in range (1, infty + 1):
         soma = soma + eq8322_rs(q, r, s) + eq8322_rs(q, -r, -s)
   return X10(q, infty) - 1/psi(q, infty) * soma

def eq841(q, m, infty):
   w = mp.root(1, 3, m)
   soma1 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma1 = soma1 + sinal * power(q, n*n/3) * 2
      sinal = - sinal
   soma2 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma2 = soma2 + sinal * power(q, n*(5*n + 3)/2) + sinal * power(q, -n*(-5*n + 3)/2)
      sinal = - sinal
   soma3 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma3 = soma3 + sinal * power(q, n*n) * 2
      sinal = - sinal
   w2, q2, qt = w * w, q * q, power(q, 1/3)
   q3 = q2 * q
   return (qt * qt * phi10(q3, infty) - 1/(w - w2) * (psi10(w * qt, infty) - psi10(w2 * qt, infty))
           + qt * soma1 * soma2 / ramanujan(q, q2, infty) / soma3)

def eq842(q, m, infty):
   w = mp.root(1, 3, m)
   soma1 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma1 = soma1 + sinal * power(q, n*n/3) * 2
      sinal = - sinal
   soma2 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma2 = soma2 + sinal * power(q, n*(5*n + 1)/2) + sinal * power(q, -n*(-5*n + 1)/2)
      sinal = - sinal
   soma3 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma3 = soma3 + sinal * power(q, n*n) * 2
      sinal = - sinal
   w2, q2, qt = w * w, q * q, power(q, 1/3)
   q3 = q2 * q
   return (1/qt / qt * psi10(q3, infty) + 1/(w - w2) * (w * phi10(w * qt, infty) - w2 * phi10(w2 * qt, infty))
           - soma1 * soma2 / ramanujan(q, q2, infty) / soma3)

#*** 16 not zero
def eq843(q, m, infty):
   w = mp.root(1, 3, m)
   soma1 = 1
   for n in range (1, infty + 1):
      soma1 = soma1 + power(q, n*(n + 1)/6) + power(q, -n*(-n + 1)/6)
   soma2 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma2 = soma2 + sinal * power(q, n*(5*n + 1)) + sinal * power(q, -n*(-5*n + 1))
      sinal = - sinal
   soma3 = 1
   for n in range (1, infty + 1):
      soma3 = soma3 + power(q, n*(n + 1)) + power(q, -n*(-n + 1))
   w2, q2, qt = w * w, q * q, power(q, 1/3)
   q3 = q2 * q
   return (X10(q3, infty) - 1/(w - w2) * (w * chi10(w * qt, infty) - w2 * chi10(w2 * qt, infty))
           - soma1 * soma2 / ramanujan(-q, q2, infty) / soma3)

#*** 17 not zero 0.1, 0.8
def eq844(q, m, infty):
   w = mp.root(1, 3, m)
   soma1 = 1
   for n in range (1, infty + 1):
      soma1 = soma1 + power(q, n*(n + 1)/6) + power(q, -n*(-n + 1)/6)
   soma2 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma2 = soma2 + sinal * power(q, n*(5*n + 3)) + sinal * power(q, -n*(-5*n + 3))
      sinal = - sinal
   soma3 = 1
   for n in range (1, infty + 1):
      soma3 = soma3 + power(q, n*(n + 1)/2) + power(q, -n*(-n + 1)/2)
   w2, q2, qt = w * w, q * q, power(q, 1/3)
   q3 = q2 * q
   return (chi10(q3, infty) + qt * qt/(w - w2) * (X10(w * qt, infty) - X10(w2 * qt, infty))
           + q * soma1 * soma2 / ramanujan(-q, q2, infty) / soma3)

def rho(r, s):
   if (r >= 0) and (s >= 0):
      return 1
   if (r < 0) and (s < 0):
      return -1
   return 0

def eq847_rs(q, k, L, r, s):
   return (rho(r, s) * power(-1, k + L + r + s) * power(q,
           (k*k + L*L + r*r + 3*r*s + s*s + 3*r + 3*s + 1)/3))

#*** 18 not zero 2.6, 3
def eq847(q, infty):
   soma1 = 0
   for k in range (0, infty + 1):
      for r in range (0, infty + 1):
         if (k - r) % 3 != 0:
            for L in range (0, infty + 1):
               for s in range (0, infty + 1):
                  if (L - s) % 3 != 0:
                     soma1 = soma1 + eq847_rs(q,  k,  L,  r,  s)
                     if (r != 0) and (s != 0):
                        soma1 = soma1 + eq847_rs(q,  k,  L, -r, -s)
                     if L != 0:
                        soma1 = soma1 + eq847_rs(q,  k, -L,  r,  s)
                     if (L != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq847_rs(q,  k, -L, -r, -s)
                     if (k != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq847_rs(q, -k,  L, -r, -s)
                     if k != 0:
                        soma1 = soma1 + eq847_rs(q, -k,  L,  r,  s)
                     if (k != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq847_rs(q, -k,  L, -r, -s)
                     if (k != 0) and (L != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq847_rs(q, -k, -L, -r, -s)
   soma2 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma2 = soma2 + sinal * power(q, n * (5*n + 3)/2) + sinal * power(q, -n * (-5*n + 3)/2)
      sinal = - sinal
   z = phi(-q, infty)
   return soma1 + ramanujan(q, q, infty) * z * z * soma2

def eq8419_rs(q, k, L, r, s):
   return (rho(r, s) * power(-1, k + L + r + s) * power(q,
           (k*k + L*L + r*r + 3*r*s + s*s + r + s)/3))

#*** 19 not zero 1.6, 6
def eq8419(q, infty):
   soma1 = 0
   for k in range (0, infty + 1):
      for r in range (0, infty + 1):
         if (k - r + 1) % 3 != 0:
            for L in range (0, infty + 1):
               for s in range (0, infty + 1):
                  if (L - s + 1) % 3 != 0:
                     soma1 = soma1 + eq8419_rs(q, k, L, r, s)
                     if (r != 0) and (s != 0):
                        soma1 = soma1 + eq8419_rs(q,  k,  L, -r, -s)
                     if L != 0:
                        soma1 = soma1 + eq8419_rs(q,  k, -L,  r,  s)
                     if (L != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8419_rs(q,  k, -L, -r, -s)
                     if (k != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8419_rs(q, -k,  L, -r, -s)
                     if k != 0:
                        soma1 = soma1 + eq8419_rs(q, -k,  L,  r,  s)
                     if (k != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8419_rs(q, -k,  L, -r, -s)
                     if (k != 0) and (L != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8419_rs(q, -k, -L, -r, -s)
   soma2 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma2 = soma2 + sinal * power(q, n * (5*n + 1)/2) + sinal * power(q, -n * (-5*n + 1)/2)
      sinal = - sinal
   z = phi(-q, infty)
   return soma1 - ramanujan(q, q, infty) * z * z * soma2

def eq8422_rs(q, k, L, r, s):
   return (rho(r, s) * power(q, (k*(k+1)/2 + L*(L+1)/2 + 2*r*r + 6*r*s + 2*s*s + 3*r + 3*s)/3))

#*** 20 not zero 0.69, 3
def eq8422(q, infty):
   soma1 = 0
   for k in range (0, infty + 1):
      for r in range (0, infty + 1):
         if (k - 1 - r) % 3 != 0:
            for L in range (0, infty + 1):
               for s in range (0, infty + 1):
                  if (L - 1 - s) % 3 != 0:
                     soma1 = soma1 + eq8422_rs(q, k, L, r, s)
                     if s != 0:
                        soma1 = soma1 + eq8422_rs(q,  k,  L,  r, -s)
                     if r != 0:
                        soma1 = soma1 + eq8422_rs(q,  k,  L, -r,  s)
                     if (r != 0) and (s != 0):
                        soma1 = soma1 + eq8422_rs(q,  k,  L, -r, -s)
                     if L != 0:
                        soma1 = soma1 + eq8422_rs(q,  k, -L,  r,  s)
                     if (L != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8422_rs(q,  k, -L, -r, -s)
                     if (L != 0) and (r != 0):
                        soma1 = soma1 + eq8422_rs(q,  k, -L, -r,  s)
                     if (L != 0) and (s != 0):
                        soma1 = soma1 + eq8422_rs(q,  k, -L,  r, -s)
                     if (k != 0) and (r != 0):
                        soma1 = soma1 + eq8422_rs(q, -k,  L, -r,  s)
                     if (k != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8422_rs(q, -k,  L, -r, -s)
                     if k != 0:
                        soma1 = soma1 + eq8422_rs(q, -k,  L,  r,  s)
                     if (k != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8422_rs(q, -k,  L, -r, -s)
                     if (k != 0) and (r != 0):
                        soma1 = soma1 + eq8422_rs(q, -k, -L, -r,  s)
                     if (k != 0) and (L != 0) and (s != 0):
                        soma1 = soma1 + eq8422_rs(q, -k, -L,  r, -s)
                     if (k != 0) and (L != 0) and (r != 0):
                        soma1 = soma1 + eq8422_rs(q, -k, -L, -r,  s)
                     if (k != 0) and (L != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8422_rs(q, -k, -L, -r, -s)
   soma2 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma2 = soma2 + sinal * power(q, 5*n*n + n) + sinal * power(q, 5*n*n - n)
      sinal = - sinal
   z, q2 = psi(q, infty), q * q
   return soma1 - 4 * ramanujan(q2, q2, infty) * z * z * soma2

def eq8425_rs(q, k, L, r, s):
   return (rho(r, s) * power(q, (k*(k+1)/2 + L*(L+1)/2 + 2*r*r + 6*r*s + 2*s*s + r + s - 2)/3))

#*** 21 not zero 30, 2.2
def eq8425(q, infty):
   soma1 = 0
   for k in range (0, infty + 1):
      for r in range (0, infty + 1):
         if (k - 1 - r - 1) % 3 != 0:
            for L in range (0, infty + 1):
               for s in range (0, infty + 1):
                  if (L - 1 - s - 1) % 3 != 0:
                     soma1 = soma1 + eq8425_rs(q, k, L, r, s)
                     if s != 0:
                        soma1 = soma1 + eq8425_rs(q,  k,  L,  r, -s)
                     if r != 0:
                        soma1 = soma1 + eq8425_rs(q,  k,  L, -r,  s)
                     if (r != 0) and (s != 0):
                        soma1 = soma1 + eq8425_rs(q,  k,  L, -r, -s)
                     if L != 0:
                        soma1 = soma1 + eq8425_rs(q,  k, -L,  r,  s)
                     if (L != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8425_rs(q,  k, -L, -r, -s)
                     if (L != 0) and (r != 0):
                        soma1 = soma1 + eq8425_rs(q,  k, -L, -r,  s)
                     if (L != 0) and (s != 0):
                        soma1 = soma1 + eq8425_rs(q,  k, -L,  r, -s)
                     if (k != 0) and (r != 0):
                        soma1 = soma1 + eq8425_rs(q, -k,  L, -r,  s)
                     if (k != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8425_rs(q, -k,  L, -r, -s)
                     if k != 0:
                        soma1 = soma1 + eq8425_rs(q, -k,  L,  r,  s)
                     if (k != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8425_rs(q, -k,  L, -r, -s)
                     if (k != 0) and (r != 0):
                        soma1 = soma1 + eq8425_rs(q, -k, -L, -r,  s)
                     if (k != 0) and (L != 0) and (s != 0):
                        soma1 = soma1 + eq8425_rs(q, -k, -L,  r, -s)
                     if (k != 0) and (L != 0) and (r != 0):
                        soma1 = soma1 + eq8425_rs(q, -k, -L, -r,  s)
                     if (k != 0) and (L != 0) and (r != 0) and (s != 0):
                        soma1 = soma1 + eq8425_rs(q, -k, -L, -r, -s)
   soma2 = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma2 = soma2 + sinal * power(q, 5*n*n + 3*n) + sinal * power(q, 5*n*n - 3*n)
      sinal = - sinal
   z, q2 = psi(q, infty), q * q
   return soma1 - 4 * ramanujan(q2, q2, infty) * z * z * soma2

def Theta(z, q, infty):
   return ramanujanv([q, z, q/z], q, infty, 3)

def eq852_rs(qt, k, L, x):
   return power(-1, k + L) * power(qt, k*k + L*L) * power(x, L)

#*** 22 not zero 282, 185
def eq852(q, x, infty):
   q2, qt = q * q, power(q, 1/3)
   soma = 0
   for k in range (0, infty + 1):
      for L in range (0, infty + 1):
         if (k - L) % 3 != 0:
            soma = soma + eq852_rs(qt,  k,  L, x)
            if L != 0:
               soma = soma + eq852_rs(qt,  k, -L, x)
            if k != 0:
               soma = soma + eq852_rs(qt, -k,  L, x)
            if (k != 0) and (L != 0):
               soma = soma + eq852_rs(qt, -k, -L, x)
   return soma + 1/x * qt * ramanujan(q, q, infty) / ramanujan(q2, q2, infty) * Theta(x, q2, infty) * Theta(x, q, infty)

def eq853_rs(qt, k, L, x):
   return power(qt, k*(k+1)/2 + 2*L*L) * power(x, L)

#*** 23 not zero 170, 14
def eq853(q, x, infty):
   q2, xq, qt = q * q, x * q, power(q, 1/3)
   xq2, q4 = x * q2, q2 * q2
   soma = 0
   for k in range (0, infty + 1):
      for L in range (0, infty + 1):
         if (k - 1 - L) % 3 != 0:
            soma = soma + eq853_rs(qt, k, L, x)
            if L != 0:
               soma = soma + eq853_rs(qt,  k, -L, x)
            if k != 0:
               soma = soma + eq853_rs(qt, -k,  L, x)
            if (k != 0) and (L != 0):
               soma = soma + eq853_rs(qt, -k, -L, x)
   return soma + 2 * ramanujan(q2, q2, infty) / ramanujan(q, q, infty) * Theta(xq, q2, infty) * Theta(-xq2, q4, infty)

def a1(q, infty):
   q2 = q * q
   q4 = q2 * q2
   q5, q6, q8 = q4 * q, q4 * q2, q4 * q4
   q10 = q5 * q5
   return -q * ramanujan(q5, q5, infty) * ramanujan(q10, q10, infty) * f(-q2, -q8, infty) / f(-q, -q4, infty) / f(-q4, -q6, infty)

def a2(q, infty):
   q2 = q * q
   q3, q4 = q2 * q, q2 * q2
   q5, q6, q8 = q4 * q, q3 * q3, q4 * q4
   q10 = q5 * q5
   return ramanujan(q5, q5, infty) * ramanujan(q10, q10, infty) * f(-q4, -q6, infty) / f(-q2, -q3, infty) / f(-q2, -q8, infty)

#*** 24 not zero 9e-2, 0.25
def eq925(q, infty):
   q2 = q * q
   q3, q4 = q2 * q, q2 * q2
   q5 = q4 * q
   q10 = q5 * q5
   q15, q20 = q10 * q5, q10 * q10
   q30, q40 = q15 * q15, q20 * q20
   z = ramanujan(q10, q10, infty)
   return ( - a1(q2, infty) * f(-q2, -q3, infty) + a2(q2, infty) * q2 * f(-q, -q4, infty) - q2 * z * z * z * f(-q5, -q15, infty)
           * f(-q10, -q30, infty) / ramanujan(q20, q20, infty) / ramanujan(q40, q40, infty) / f(q5, q5, infty) )

def DD(q, z, infty):
   z2, q2, w, t = z * z, q * q, ramanujan(q, q, infty), f(-z, -q/z, infty)
   return z2 * w * w * f(-z2, -q/z2, infty) * f(-z, -q2/z, infty) / ramanujan(q, q2, infty) / t / t

def eq933(q, z, infty):
   return DD(q, 1/z, infty) - power(z, -5) * DD(q, z, infty)

def eq934(q, z, infty):
   return DD(q, z * q * q, infty) + power(z, -5) * DD(q, z, infty)

def LL(q, z, infty):
   soma = q * power(z, 5)/(1 - z*q)
   sinal = -1
   for n in range (1, infty + 1):
      soma = (soma + sinal * power(q, 5 * n * (n + 1) + 1) * power(z, 5*n + 5)
              / (1 - z * power(q, 2*n + 1))
              + sinal * power(q, -5 * n * (-n + 1) + 1) * power(z, -5*n + 5)
              / (1 - z * power(q, -2*n + 1)))
      sinal = - sinal
   return soma

def MM(q, z, infty):
   soma = q/(1 - q/z)
   sinal = -1
   for n in range (1, infty + 1):
      soma = (soma + sinal * power(q, 5 * n * (n + 1) + 1) / power(z, 5*n)
              / (1 - power(q, 2*n + 1)/z)
              + sinal * power(q, -5 * n * (-n + 1) + 1) * power(z, 5*n)
              / (1 - power(q, -2*n + 1)/z))
      sinal = - sinal
   return soma

def eq9420(q, z, infty):
   z2, q2 = z * z, q * q
   z3, z4, q4 = z2 * z, z2 * z2, q2 * q2
   z5, q6, q8 = z4 * z, q4 * q2, q4 * q4
   return (- DD(q, z, infty) + psi10(q, infty) * (z * f(-z5 * q2, -q8/z5, infty) + z4 * f(-z5 * q8, -q2/z5, infty))
           + phi10(q, infty) * (z2 * f(-z5 * q4, -q6/z5, infty) + z3 * f(-z5 * q6, -q4/z5, infty)) - LL(q, z, infty) - MM(q, z, infty))

def AA(z, x, q, infty):
   q2, zx, w = q * q, z * x, ramanujan(q, q, infty)
   return w * w * w * f(-zx, -q/zx, infty) * f(-z, -q2/z, infty) / phi(-q, infty) / f(-x, -q/x, infty) / f(-z, -q/z, infty)

def hh(x, q, infty):
   soma = 1/(1 - x)
   sinal = -1
   for n in range (1, infty + 1):
      qn = power(q, n)
      soma = (soma + sinal * power(qn, n + 1) / (1 - qn * x)
              + sinal * power(1/qn, -n + 1) / (1 - 1/qn * x))
      sinal = - sinal
   return 1/phi(-q, infty) * soma

def QQ(z, x, q, infty):
   soma1 = x*z/(1 - q*z)
   sinal = -1
   for n in range (1, infty + 1):
      soma1 = (soma1 + sinal * power(q, n * (n + 1)) * power(x, 2*n + 1) * power(z, n + 1)
               / (1 - power(q, 2*n + 1) * z)
               + sinal * power(q, -n * (-n + 1)) * power(x, -2*n + 1) * power(z, -n + 1)
               / (1 - power(q, -2*n + 1) * z))
      sinal = - sinal
   soma2 = q/x/z/(1 - q/z)
   sinal = -1
   for n in range (1, infty + 1):
      soma2 = (soma2 + sinal * power(q, n * (n + 3) + 1) / power(x, 2*n + 1) / power(z, n + 1)
               / (1 - power(q, 2*n + 1) / z)
               + sinal * power(q, -n * (-n + 3) + 1) / power(x, -2*n + 1) / power(z, -n + 1)
               / (1 - power(q, -2*n + 1) / z))
      sinal = - sinal
   return - 0.5 * (soma1 + soma2)

def eq966(q, x, z, infty):
   x2, q2 = x * x, q * q
   return - AA(z, x, q, infty) + f(-x2 * z, -q2/x2/z, infty) * hh(x, q, infty) + QQ(z, x, q, infty)

def am(m, q, infty):
   q2 = q * q
   q3, q4 = q2 * q, q2 * q2
   q5, q6, q8 = q4 * q, q3 * q3, q4 * q4
   q10 = q5 * q5
   if (m == 1) or (m == 4):
      return (- q * ramanujan(q5, q5, infty) * ramanujan(q10, q10, infty) * f(-q2, -q8, infty)
              / f(-q, -q4, infty) / f(-q4, -q6, infty))
   return (ramanujan(q5, q5, infty) * ramanujan(q10, q10, infty) * f(-q4, -q6, infty)
           / f(-q2, -q3, infty) / f(-q2, -q8, infty))

def GM(m, z, q, infty):
   z5, q10, q2m = power(z, 5), power(q, 10), power(q, 2*m)
   return am(m, z, infty) * power(z, m) * f(-z5 * q2m, -1/z5 * q10/q2m, infty)

#*** 25 not zero 203117, 21163
def eq9615(q, z, m, infty):
   q2, z5 = q * q, power(z, 5)
   return GM(m, z * q2, q, infty) + GM(m, z, q, infty)/z5

#*** 26 not zero 3e206, 6e174
def eq9616(q, z, m, infty):
   z5 = power(z, 5)
   return GM(m, 1/z, q, infty) - GM(5 - m, z, q, infty)/z5

def HM(m, z, q, infty):
   z5, q5 = power(z, 5), power(q, 5)
   z10, q10 = z5 * z5, q5 * q5
   q20 = q10 * q10
   if m == 0:
      w = ramanujan(q5, q5, infty)
      return (- q * w * w * w * f(z5 * q5, q5/z5, infty) * f(-1/z10, -q20/z10, infty)
              / ramanujan(q10, q10, infty) / ramanujan(q20, q20, infty) / f(-z5, -q5/z5, infty))
   return 2 * q * power(z, m) * AA(z5, power(q, m), q5, infty)

def eq9617(q, z, m, infty):
   q2, z5 = q * q, power(z, 5)
   return HM(m, z * q2, q, infty) + HM(m, z, q, infty)/z5

def eq9618(q, z, m, infty):
   z5 = power(z, 5)
   return HM(m, 1/z, q, infty) - HM(5 - m, z, q, infty)/z5

#*** 27 not zero 0.01, 0.4
def eq9619(q, k, infty):
   soma = 0
   for m in range (1, 5):
      soma = soma + HM(m, - power(q, k), q, infty)
   return soma

def eq971(q, z, infty):
   z5, q2, q5 = power(z, 5), q * q, power(q, 5)
   q8 = q5 * q2 * q
   return (- psi10(q, infty) + a1(q, infty)) * f(-z5 * q2, -q8/z5, infty) + 2 * q * AA(z5, q, q5, infty) - 2 * q * QQ(z5, q, q5, infty)

def eq974(q, infty):
   return - psi10(q, infty) + a1(q, infty) + 2 * q * hh(q, power(q, 5), infty)

def eq975(q, z, infty):
   z5, q2 = power(z, 5), q * q
   q4 = q2 * q2
   q5, q6 = q4 * q, q4 * q2
   return (- phi10(q, infty) + a2(q, infty)) * f(-z5 * q4, -q6/z5, infty) + 2 * q * AA(z5, q2, q5, infty) - 2 * q * QQ(z5, q2, q5, infty)

def eq978(q, infty):
   return - phi10(q, infty) + a2(q, infty) + 2 * q * hh(q * q, power(q, 5), infty)

def bm(m, q, infty):
   q2 = q * q
   q3, q4 = q2 * q, q2 * q2
   q5 = q3 * q2
   q10 = q5 * q5
   if (m == 1) or (m == 4):
      q8 = q4 * q4
      prod = (ramanujan(q5, q5, infty) * ramanujan(q10, q10, infty) * f(-q2, -q3, infty)
              / f(-q, -q4, infty) / f(-q2, -q8, infty))
      if m == 1:
         return - prod
      return prod
   q6 = q3 * q3
   prod = (ramanujan(q5, q5, infty) * ramanujan(q10, q10, infty) * f(-q, -q4, infty)
              / f(-q2, -q3, infty) / f(-q4, -q6, infty))
   if m == 2:
      return - prod
   return prod

def eq1021(q, infty):
   q2 = q * q
   q3, q4 = q2 * q, q2 * q2
   q5 = q3 * q2
   q10 = q5 * q5
   z = ramanujan(q10, q10, infty)
   return (- bm(1, q, infty) * q * f(-q2, q3, infty) + bm(2, q, infty) * q2 * f(q, -q4, infty) - 2 * q * z * z * z * psi(-q5, infty) * phi(q5, infty)
           / psi(q5, infty) / phi(-q5, infty) / f(1, q10, infty))

def eq1022(q, infty):
   q4 = power(q, 4)
   q5, q8 = q4 * q, q4 * q4
   q10, q12, q16 = q5 * q5, q4 * q8, q8 * q8
   z = ramanujan(q10, q10, infty)
   return (2 * bm(1, q, infty) * f(-q4, -q16, infty) - 2 * bm(2, q, infty) * f(-q8, -q12, infty) + 2 * q * z * z * z * phi(-q10, infty) * f(1, q10, infty)
           / psi(q5, infty) / phi(-q5, infty) / phi(q5, infty))

def EE(q, z, infty):
   q2 = q * q
   q3, q4 = q2 * q, q2 * q2
   return (z * f(-z, -q2/z, infty) * f(z/q, q2/z, infty) * f(z, q4/z, infty)
           / f(-z/q, -q3/z, infty))

def eq1032(q, z, infty):
   return EE(q, 1/z, infty) + EE(q, z, infty)/power(z, 5)

def eq1033(q, z, infty):
   return EE(q, z * power(q, 4), infty) - EE(q, z, infty)/power(z, 5)

def LL1(q, z, infty):
   z5, q2 = power(z, 5), q * q
   q3 = q2 * q
   soma1 = q * z5/(1 - q*z)
   for n in range (1, infty + 1):
      soma1 = (soma1 + power(q, 10*n*(n + 1) + 1) * power(z, 5*n + 5) / (1 - power(q, 4*n + 1) * z)
                 + power(q, -10*n*(-n + 1) + 1) * power(z, -5*n + 5) / (1 - power(q, -4*n + 1) * z))
   soma2 = q * z5/(1 - q3*z)
   for n in range (1, infty + 1):
      soma2 = (soma2 + power(q, 10*n*(n + 1) + 1) * power(z, 5*n + 5) / (1 - power(q, 4*n + 3) * z)
                 + power(q, -10*n*(-n + 1) + 1) * power(z, -5*n + 5) / (1 - power(q, -4*n + 3) * z))
   return soma1 + soma2

def MM1(q, z, infty):
   z5, q2 = power(z, 5), q * q
   q3 = q2 * q
   soma1 = q/(1 - q/z)
   for n in range (1, infty + 1):
      soma1 = (soma1 + power(q, 10*n*(n + 1) + 1) / power(z5, n) / (1 - power(q, 4*n + 1) / z)
                  + power(q, -10*n*(-n + 1) + 1) * power(z5, n) / (1 - power(q, -4*n + 1) / z))
   soma2 = q/(1 - q3/z)
   for n in range (1, infty + 1):
      soma2 = (soma2 + power(q, 10*n*(n + 1) + 1) / power(z5, n) / (1 - power(q, 4*n + 3) / z)
                  + power(q, -10*n*(-n + 1) + 1) * power(z5, n) / (1 - power(q, -4*n + 3) / z))
   return soma1 + soma2

def VV1(q, z, infty):
   return EE(q, z, infty) - LL1(q, z, infty) + MM1(q, z, infty)

def eq1049(q, z, infty):
   return VV1(q, 1/z, infty) + VV1(q, z, infty)/power(z, 5)

def eq10410(q, z, infty):
   p1, p2 = VV1(q, z * power(q, 4), infty), VV1(q, z, infty)/power(z, 5)
   return p1 - p2

def S10(q, infty):
   return 1/q * (2 - chi10(q, infty))

def eq10421(q, z, infty):
   q4, z2 = power(q, 4), z * z
   q8, z3, z4 = q4 * q4, z2 * z, z2 * z2
   q12, q16, z5 = q8 * q4, q8 * q8, z4 * z
   return (- EE(q, z, infty) + (X10(q, infty) - 2) * (z * f(z5 * q4, q16/z5, infty) - z4 * f(z5 * q16, q4/z5, infty))
           + (S10(q, infty) - 2/q) * (z2 * f(z5 * q8, q12/z5, infty) - z3 * f(z5 * q12, q8/z5, infty)) + LL1(q, z, infty) - MM1(q, z, infty))

def B(z, x, q, infty):
   q2, x2 = q  * q, x * x
   q3, q4 = q2 * q, q2 * q2
   w = ramanujan(q2, q2, infty)
   return (w * w * w * f(-z*x2/q, -q3/z/x2, infty) * f(z, q4/z, infty) / psi(q, infty)
           / x / f(-x2, -q2/x2, infty) / f(-z/q, -q3/z, infty))

def kk(x, q, infty):
   x2, q2 = x * x, q * q
   soma = 1/(1 - x2)
   for n in range (1, infty + 1):
      soma = soma + power(q, n * (2 * n + 1)) / (1 - power(q2, n) * x2)
   return 1/psi(q, infty)/x * soma

def PP(z, x, q, infty):
   q2, x3 = q * q, x * x * x
   q3 = q2 * q
   soma1 = x*z/(1 - q*z)
   for n in range (1, infty + 1):
      soma1 = (soma1 + power(q2, n*(n + 1)) * power(x, 4*n + 1) * power(z, n + 1) / (1 - power(q, 4*n + 1) * z)
                + power(q2, -n*(-n + 1)) * power(x, -4*n + 1) * power(z, -n + 1) / (1 - power(q, -4*n + 1) * z))
   soma2 = x3*z/(1 - q3*z)
   for n in range (1, infty + 1):
      soma2 = (soma2 + power(q2, n*(n + 1)) * power(x, 4*n + 3) * power(z, n + 1) / (1 - power(q, 4*n + 3) * z)
                + power(q2, -n*(-n + 1)) * power(x, -4*n + 3) * power(z, -n + 1) / (1 - power(q, -4*n + 3) * z))
   soma3 = q/x/z/(1 - q/z)
   for n in range (1, infty + 1):
      soma3 = (soma3 + power(q, 2*n*(n + 3) + 1) / power(x, 4*n + 1) / power(z, n + 1) / (1 - power(q, 4*n + 1) / z)
                + power(q, -2*n*(-n + 3) + 1) / power(x, -4*n + 1) / power(z, -n + 1) / (1 - power(q, -4*n + 1) / z))
   soma4 = q3/x3/z/(1 - q3/z)
   for n in range (1, infty + 1):
      soma4 = (soma4 + power(q, 2*n*(n + 3) + 3) / power(x, 4*n + 3) / power(z, n + 1) / (1 - power(q, 4*n + 3) / z)
                + power(q, -2*n*(-n + 3) + 3) / power(x, -4*n + 3) / power(z, -n + 1) / (1 - power(q, -4*n + 3) / z))
   return 0.5 * (soma1 + soma2 - soma3 - soma4)

#*** 28 not zero 115307, 46077302
def eq1068(q, x, z, infty):
   x4, q4 = power(x, 4), power(q, 4)
   return - B(z, x, q, infty) + f(z * x4, q4/z/x4, infty) * (kk(x, q, infty) - 1/x) + PP(z, x, q, infty)

def II(m, z, q, infty):
   z5, zm, q4m, q20 = power(z, 5), power(z, m), power(q, 4*m), power(q, 20)
   return bm(m, q, infty) * zm * f(z5 * q4m, 1/z5 * q20 / q4m, infty)

def JJ(m, z, q, infty):
   z5, q5 = power(z, 5), power(q, 5)
   if m == 0:
      q6, q10 = q5 * q, q5 * q5
      q15 = q10 * q5
      q30, w = q15 * q15, ramanujan(q10, q10, infty)
      return (2 * q6 * w * w * w * f(z5/q10, q30/z5, infty) * f(-z5, -q10/z5, infty)
              / psi(q5, infty) / phi(-q5, infty) / f(-z5/q5, -q15/z5, infty))
   return 2 * q * power(z, m) * B(z5, power(q, m), q5, infty)

def eq10647(q, z, infty):
   soma1 = 0
   for m in range (1, 5):
      soma1 = soma1 + II(m, z, q, infty)
   soma2 = 0
   for m in range (0, 5):
      soma2 = soma2 + JJ(m, z, q, infty)
   return - EE(q, z, infty) + soma1 + soma2

def lemma1064(q, z, m, infty):
   q4, z5 = power(q, 4), power(z, 5)
   return II(m, z * q4, q, infty) - II(m, z, q, infty)/z5

def lemma1065(q, z, m, infty):
   z5 = power(z, 5)
   return II(m, 1/z, q, infty) + II(5 - m, z, q, infty)/z5

def eq1071(q, z, infty):
   z5, q4, q16 = power(z, 5), power(q, 4), power(q, 16)
   q5 = q4 * q
   return (- X10(q, infty) + 2 + bm(1, q, infty)) * f(z5 * q4, q16/z5, infty) + 2 * q * B(z5, q, q5, infty) - 2 * q * PP(z5, q, q5, infty)

#*** 29 not zero 2e-4
def eq1074(q, infty):
   return X10(q, infty) - bm(1, q, infty) - 2 * q * kk(q, power(q, 5), infty)

def eq1075(q, z, infty):
   z5, q2, q5 = power(z, 5), q * q, power(q, 5)
   q8 = q5 * q2 * q
   q12 = q8 * q2 * q2
   return (- chi10(q, infty) - q * bm(2, q, infty)) * f(z5 * q8, q12/z5, infty) - 2 * q2 * B(z5, q2, q5, infty) + 2 * q2 * PP(z5, q2, q5, infty)

#*** 30 not zero 7e-4, 9e-4
def eq1078(q, infty):
   q2 = q * q
   return - chi10(q, infty) + 2 - q * bm(2, q, infty) - 2 * q2 * kk(q2, power(q, 5), infty)

def hq(q, infty):
   soma = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma = soma + sinal * power(q, n * (5 * n + 3)/2) + sinal * power(q, -n * (-5 * n + 3)/2)
      sinal = - sinal
   return soma

#*** 31 not zero 3, 0.4
def eq1111(q, infty):
   q2 = q * q
   q4 = q2 * q2
   q8 = q4 * q4
   p1, p2, p3, p4 = phi10(q, infty), psi10(-q4, infty)/q, chi10(q8, infty)/q2, phi(q, infty) * hq(-q2, infty)/psi(-q, infty)
   return p1 - p2 + p3 - p4

def gg(q, infty):
   soma = 1
   sinal = -1
   for n in range (1, infty + 1):
      soma = soma + sinal * power(q, n * (5 * n + 1)/2) + sinal * power(q, -n * (-5 * n + 1)/2)
      sinal = - sinal
   return soma

#*** 32 not zero 0.5, 3.8
def eq1113(q, infty):
   q2 = q * q
   q4 = q2 * q2
   q8 = q4 * q4
   p1, p2, p3, p4 = psi10(q, infty), q * phi10(-q4, infty), X10(q8, infty)/q2, phi(q, infty) * gg(-q2, infty)/psi(-q, infty)
   return p1 + p2 + p3 - p4

def J(x, q, infty):
   return f(-x, -q/x, infty)

def eq1121(q, x, y, infty):
   q2, xy, qy = q * q, x * y, q * y
   qxy = q * xy
   return - J(x, q, infty) * J(y, q, infty) + J(-xy, q2, infty) * J(-qy/x, q2, infty) - x * J(-qxy, q2, infty) * J(-y/x, q2, infty)

def eq1123(q, x, y, infty):
   q2 = q * q
   return J(-x, q, infty) * J(y, q, infty) - J(x, q, infty) * J(-y, q, infty) - 2 * x * J(y/x, q2, infty) * J(q*x*y, q2, infty)

def m(x, q, z, infty):
   soma = 1/(1 - x * z)
   sinal = -1
   for r in range (1, infty + 1):
      qr = power(q, r)
      soma = (soma + sinal * power(qr, (r + 1)/2) * power(z, r) / (1 - x * z * qr)
                + sinal * power(1/qr, (-r + 1)/2) / power(z, r) / (1 - x * z / qr))
      sinal = - sinal
   return -z/J(z, q, infty) * soma

#*** 33 not zero 0.9, (0)
def eq1131(q, x, z, infty):
   return m(x, q, z, infty) - m(x, q, q*z, infty)

def eq1132(q, x, z, infty):
   return x * m(x, q, z, infty) - m(1/x, q, 1/z, infty)

#*** 34 not zero 0.4, (0)
def eq1133(q, x, z, infty):
   return m(x, q, z, infty) - m(x, q, 1/x/z, infty)

#*** 35 not zero 0.1, (0)
def eq1136(q, x, z0, z1, infty):
   xz0, w = x * z0, ramanujan(q, q, infty)
   return (m(x, q, z1, infty) - m(x, q, z0, infty) - z0 * w * w * w * J(z1/z0, q, infty) * J(xz0 * z1, q, infty)
           / J(z0, q, infty) / J(z1, q, infty) / J(xz0, q, infty) / J(x*z1, q, infty))

#*** 36 not zero 0.02, (0)
def eq11311(q, x, infty):
   return x * hh(x, q, infty) + m(q/x/x, q*q, x, infty)

#*** 37 not zero 0.6, (0)
def eq11316(q, x, z, infty):
   return m(q*x, q, z, infty) - 1 + x * m(x, q, z, infty)

#*** 38 not zero 0.4, 0.3
def eq11319(q, x, infty):
   x2, q4 = x * x, power(q, 4)
   x4, w = x2 * x2, 1/q/x2
   p1, p2, p3 = x * kk(x, q, infty), m(-q*x4, q4, -w, infty), x2/q * m(-x4/q, q4, -w, infty)
   return - p1 + p2 + p3

#*** 39 not zero 0.6, 41
def eq11321(q, x, z, zz, infty):
   q2 = q * q
   q3, q4, z2, x2 = q2 * q, q2 * q2, z * z, x * x
   x2z2, x2zz = x2 * z2, x2 * zz
   w, x2z2zz = ramanujan(q4, q4, infty), x2z2 * zz
   k = 0
   q2k = 1 # power(q, 2 * k)
   soma1 = (- m(x, q, z, infty) - power(-1, k) * m(-x, q, z, infty) + 2 * power(-x/q, k) * m(-q/q2k * x2, q4, zz, infty)
            - 2 * power(x, k) * power(z, k + 1) * w * w * w / J(z, q, infty) / J(zz, q4, infty)
            * (J(-q2k/q3 * z2/zz, q4, infty) * J(x2z2zz, q4, infty) / J(-x2zz/q/q2k, q4, infty)
               / J(x2z2, q4, infty) - z * power(q, 1 + k) * J(-q2k/q*z2/zz, q4, infty)
               * J(q2 * x2z2zz, q4, infty) / J(-x2zz/q/q2k, q4, infty) / J(q2 * x2z2, q4, infty)))
   k = 1
   q2k = q * q # power(q, 2 * k)
   soma2 = (- m(x, q, z, infty) - power(-1, k) * m(-x, q, z, infty) + 2 * power(-x/q, k) * m(-q/q2k * x2, q4, zz, infty)
            - 2 * power(x, k) * power(z, k + 1) * w * w * w / J(z, q, infty) / J(zz, q4, infty)
            * (J(-q2k/q3 * z2/zz, q4, infty) * J(x2z2zz, q4, infty) / J(-x2zz/q/q2k, q4, infty)
               / J(x2z2, q4, infty) - z * power(q, 1 + k) * J(-q2k/q*z2/zz, q4, infty)
               * J(q2 * x2z2zz, q4, infty) / J(-x2zz/q/q2k, q4, infty) / J(q2 * x2z2, q4, infty)))
   return soma1 + soma2

#*** 40 not zero 1, 0.3
def eq11330(q, x, infty):
   x2, q2, z = x * x, q * q, ramanujan(q, q, infty)
   w = ramanujan(q2, q2, infty)
   p1, p2, p3 = x * kk(x, q, infty), m(-x2, q, 1/x2, infty), power(z, 4)/2/w/w/J(x2, q, infty)
   return - p1 + p2 + p3

def DDD(x, q, z, zz, infty):
   x2, q4 = x * x, power(q, 4)
   return m(x, q, z, infty) - m(-q*x2, q4, zz, infty) + x/q * m(-x2/q, q4, zz, infty)

#*** 41 not zero 0.2, 1
def eq11332(q, infty):
   q3, q8 = q * q * q, power(q, 8)
   q6, q10 = q3 * q3, q8 * q * q
   q20, q14 = q10 * q10, q10 * q3 * q
   q40, z = q20 * q20, ramanujan(q20, q20, infty)
   return (DDD(q3, q10, q6, 1/q8, infty) + z * z * z * J(-q14, q20, infty) * J(q20, q40, infty) / J(q, q10, infty)
           / J(q8, q40, infty) / J(-q8, q20, infty) / J(q6, q20, infty))

#*** 42 not zero 1.2, 0.3
def eq11333(q, infty):
   q3 = q * q * q
   q4, q6 = q3 * q, q3 * q3
   q7, q8, q10 = q6 * q, q4 * q4, q6 * q4
   q18, q20 = q10 * q8, q10 * q10
   q40, z = q20 * q20, ramanujan(q20, q20, infty)
   return (DDD(q3, q10, q4, q8, infty) + q * z * z * z * J(-q18, q20, infty) * J(q20, q40, infty) / J(q7, q10, infty)
           / J(q8, q40, infty) / J(-q4, q20, infty) / J(q6, q20, infty))

#*** 43 not zero 1.2, 0.3
def eq11336(q, infty):
   q6 = power(q, 6)
   q8, q12 = q6 * q * q, q6 * q6
   q9, q24 = q8 * q, q12 * q12
   q10 = q9 * q
   q18, q20 = q10 * q8, q10 * q10
   q40, z = q20 * q20, ramanujan(q20, q20, infty)
   return (DDD(q, q10, q8, 1/q24, infty) + q * z * z * z * J(-q6, q20, infty) * J(q20, q40, infty) / J(q9, q10, infty)
           / J(q24, q40, infty) / J(-q12, q20, infty) / J(q18, q20, infty))

def eq11337(q, infty):
   q2 = q * q
   q3, q4 = q2 * q, q2 * q2
   q10 = q4 * q4 * q2
   q16, q20 = q10 * q4 * q2, q10 * q10
   q40, z = q20 * q20, ramanujan(q20, q20, infty)
   return (DDD(q, q10, q2, 1/q16, infty) + q2 * z * z * z * J(-q2, q20, infty) * J(q20, q40, infty) / J(q3, q10, infty)
           / J(q16, q40, infty) / J(-q4, q20, infty) / J(q2, q20, infty))

#*** 44 not zero 0.4, (0)
def lemma1139(q, x, z, zz, infty):
   x2, q2, z2, xz = x * x, q * q, z * z, x * z
   qx2, q4, w = q * x2, q2 * q2, ramanujan(q2, q2, infty)
   return (- m(x, q, z, infty) + m(-qx2, q4, zz, infty) - x/q * m(-x2/q, q4, zz, infty)
           + zz * w * w * w / J(xz, q, infty) / J(zz, q4, infty)
           * (J(-qx2*z*zz, q2, infty) * J(z2/zz, q4, infty) / J(-qx2*zz, q2, infty)
              / J(z, q2, infty) - xz * J(-q2*x2*z*zz, q2, infty)
              * J(q2 * z2/zz, q4, infty) / J(-qx2*zz, q2, infty) / J(z*q, q2, infty)))

def eq1141(q, infty):
   q10 = power(q, 10)
   return q * phi10(q, infty) + m(q, q10, q, infty) + m(q, q10, q * q, infty)

def eq1144(q, infty):
   q3, q10 = q * q * q, power(q, 10)
   return psi10(q, infty) + m(q3, q10, q, infty) + m(q3, q10, q3, infty)

def eq1147(q, infty):
   q2 = q * q
   q4 = q2 * q2
   q5 = q4 * q
   return -X10(q, infty) + m(-q2, q5, q, infty) + m(-q2, q5, q4, infty)

def eq1149(q, infty):
   q2 = q * q
   q4 = q2 * q2
   q5 = q4 * q
   z = phi(-q5, infty)
   return m(-q, q5, q4, infty) - m(-q, q5, q2, infty) - z * z / 2 / J(q4, q5, infty)

def eq11411(q, infty):
   q2 = q * q
   q3 = q2 * q
   q5 = q3 * q2
   return -chi10(q, infty) + m(-q, q5, q2, infty) + m(-q, q5, q3, infty)

def integralOverR(f, n, C, D):
   m = 10
   mm = 2 * m - 1
   dV = 1/m
   soma = 0
   hh = 0
   for v in range (-m + 1, m):
      u = 1/m * v
      hh = u/(1 - mp.fabs(u))
      soma = soma + dV * mp.power(1 - mp.fabs(u), -2) * f(hh, n, C, D)
   return soma

def integrated_f(x, n, C, D):
   if x < 0:
      return 0
   return mp.exp(- mp.pi() * n * x * x) / (mp.cosh(C * x) + D)

#*** 45 not zero 0.02
def eq1213(q, n, infty):
   pn, pon = mp.pi() * n, mp.pi() / n
   A = mp.sqrt((5 + mp.sqrt(5))/2)
   B = (1 + mp.sqrt(5))/2/mp.sqrt(n)
   C = 2 * mp.pi() / mp.sqrt(5)
   D = (1 + mp.sqrt(5))/4
   return (integralOverR(integrated_f, n, C, D) + 1/mp.sqrt(n) * mp.exp(pon/5) * psi10(- mp.exp(-pon), infty)
           - A * mp.exp(- pn/5) * phi10(- mp.exp(- pn), infty) + B * mp.exp(- pon/5) * phi10(- mp.exp(-pon), infty))

#*** 46 not zero 0.06
def eq1214(q, n, infty):
   pn, pon = mp.pi() * n, mp.pi() / n
   A = mp.sqrt((5 - mp.sqrt(5))/2)
   B = (-1 + mp.sqrt(5))/2/mp.sqrt(n)
   C = 2 * mp.pi() / mp.sqrt(5)
   D = (1 - mp.sqrt(5))/4
   return (integralOverR(integrated_f, n, C, D) + 1/mp.sqrt(n) * mp.exp(pon/5) * psi10(- mp.exp(-pon), infty)
           + A * mp.exp(pn/5) * psi10(- mp.exp(- pn), infty) - B * mp.exp(- pon/5) * phi10(- mp.exp(-pon), infty))

#ab = cd
def eq1221(a, b, c, infty):
   d = a * b / c
   return f(a, b, infty) * f(c, d, infty) + f(-a, -b, infty) * f(-c, -d, infty) - 2 * f(a*c, b*d, infty) * f(a*d, b*c, infty)

#ab = cd
def eq1222(a, b, c, infty):
   d = a * b / c
   return f(a, b, infty) * f(c, d, infty) - f(-a, -b, infty) * f(-c, -d, infty) - 2 * a * f(b/c, a*c*c*d, infty) * f(b/d, a*c*d*d, infty)

def eq1223(q, a, b, c, d, infty):
   ab, ac, ad, bc, bd, cd, dq = a * b, a * c, a * d, b * c, b * d, c * d, d * q
   return (a * f(-ab, -q/ab, infty) * f(-b/a, -a*q/b, infty) * f(-cd, -q/cd, infty) * f(-c/d, -dq/c, infty)
           + b * f(-bc, -q/bc, infty) * f(-c/b, -b*q/c, infty) * f(-ad, -q/ad, infty) * f(-a/d, -dq/a, infty)
           + c * f(-ac, -q/ac, infty) * f(-a/c, -c*q/a, infty) * f(-bd, -q/bd, infty) * f(-b/d, -dq/b, infty))

def eq1227(q, infty):
   q2 = q * q
   q3, q4 = q2 * q, q2 * q2
   q5, q6, q7, q8 = q3 * q2, q3 * q3, q4 * q3, q4 * q4
   q9, q10 = q8 * q, q5 * q5
   z = ramanujan(-q5, -q5, infty) * ramanujan(q10, q10, infty) / f(q5, q5, infty)
   return (ramanujan(-q5, -q5, infty) * ramanujan(q10, q10, infty) * f(-q4, -q6, infty)
           / f(-q2, q3, infty) / f(-q2, -q8, infty) - 2 * q * z * z / f(-q4, -q6, infty)
           - f(-q, -q9, infty) * f(q3, q7, infty) * f(q4, q6, infty) / f(-q4, -q6, infty) / f(q, q9, infty))

def eq12212(q, infty):
   q2 = q * q
   q3, q4 = q2 * q, q2 * q2
   q5, q6, q7, q8 = q3 * q2, q3 * q3, q4 * q3, q4 * q4
   q9, q10 = q8 * q, q5 * q5
   z = ramanujan(-q5, -q5, infty) * ramanujan(q10, q10, infty) / f(q5, q5, infty)
   return (- ramanujan(-q5, -q5, infty) * ramanujan(q10, q10, infty) * f(-q2, -q8, infty)
           / f(q, -q4, infty) / f(-q4, -q6, infty) + 2 * z * z / f(-q2, -q8, infty)
           - f(-q3, -q7, infty) * f(q, q9, infty) * f(q2, q8, infty) / f(-q2, -q8, infty) / f(q3, q7, infty))

def eq12216(q, infty):
   q3 = q * q * q
   q4 = q3 * q
   q5, q8 = q4 * q, q4 * q4
   q12, q16 = q8 * q4, q8 * q8
   q15, q25, q35 = q12 * q3, q16 * q8 * q, q16 * q16 * q3
   q45 = q25 * q16 * q4
   return (f(-q15, -q35, infty) * f(q25, q25, infty) + q3 * f(-q5, -q45, infty) * f(q25, q25, infty)
           + f(-q25, -q25, infty) * f(q15, q35, infty) - q4 * f(-q5, -q45, infty) * f(q15, q35, infty)
           - q3 * f(-q25, -q25, infty) * f(q5, q45, infty) - q4 * f(-q15, -q35, infty) * f(q5, q45, infty)
           - 2 * f(-q4, -q16, infty) * f(-q8, -q12, infty))

# To do: Check out many other equations and lemmas.

def etan(n, z, infty):
   qn = mp.exp(2 * mp.pi() * j * z * n)
   return power(qn, 1/24) * ramanujan(qn, qn, infty)

def P2(t):
   frac = t - mp.floor(t)
   return frac * frac  - frac + 1/6

def eta(n, m, z, infty):
   qm, qn = power(q, m), power(q, n)
   return mp.exp(0.5 * P2(m/n) * n) * f(-qm, -qn/qm, infty) / ramanujan(qn, qn, infty)

def eq12225(q, z, infty):
   e10 = etan(10, z, infty)
   e10_1 = eta(10, 1, z, infty)
   e10_2 = eta(10, 2, z, infty)
   e10_3 = eta(10, 3, z, infty)
   e100_20 = eta(100, 20, z, infty)
   e100_30 = eta(100, 30, z, infty)
   e100_40 = eta(100, 40, z, infty)
   e100_50 = eta(100, 50, z, infty)
   e20_2 = eta(20, 2, z, infty)
   e20_4 = eta(20, 4, z, infty)
   e20_8 = eta(20, 8, z, infty)
   e50_5 = eta(50, 5, z, infty)
   e50_10 = eta(50, 10, z, infty)
   e50_15 = eta(50, 15, z, infty)
   e50_20 = eta(50, 20, z, infty)
   e50_25 = eta(50, 25, z, infty)
   return (power(etan(50, z, infty), 18) * power(e10_2, 4) * e10_3 * e20_2 * e20_4 * e100_50
           * (-e50_5 * e50_10 * e50_10 * e50_15 * e50_25 * e100_40
             + e50_5 * e50_10 * e50_15 * e50_20 * e50_25 * e100_40
             - e50_15 * e50_15 * e50_20 * e50_20 * e50_25 * e100_20
             + 2 * e50_5 * e50_15 * e50_20 * e50_20 * e50_25 * e100_40
             - 2 * e50_5 * e50_5 * e50_20 * e50_25 * e100_30 * e100_40 * e100_40
             + e50_5 * e50_5 * e50_15 * e50_20 * e100_40 * e100_40 * e100_50)
           - e10 * e10 * power(etan(100, z, infty), 16) * e10_1 * e10_1 * power(e10_2, 4)
             * e20_8 * e20_8 * e50_10 * e50_15 * e50_20 * e50_20 * e50_25 * power(e100_50, 9))

def eq12227(q, z, infty):
   e10 = etan(10, z, infty)
   e10_1 = eta(10, 1, z, infty)
   e10_2 = eta(10, 3, z, infty)
   e10_3 = eta(10, 3, z, infty)
   e100_10 = eta(100, 20, z, infty)
   e100_20 = eta(100, 20, z, infty)
   e100_40 = eta(100, 40, z, infty)
   e100_50 = eta(100, 50, z, infty)
   e20_4 = eta(20, 4, z, infty)
   e20_6 = eta(20, 6, z, infty)
   e20_8 = eta(20, 8, z, infty)
   e50_5 = eta(50, 5, z, infty)
   e50_10 = eta(50, 10, z, infty)
   e50_15 = eta(50, 15, z, infty)
   e50_20 = eta(50, 20, z, infty)
   e50_25 = eta(50, 25, z, infty)
   w16 = power(e10_2, 16)
   return (power(etan(50, z, infty), 18) * e10_1 * w16 * e20_6 * e20_8 * e100_50
           * (e50_5 * e50_10 * e50_15 * e50_20 * e50_25 * e100_20
              + e50_5 * e50_15 * e50_20 * e50_20 * e50_25 * e100_20
              - e50_5 * e50_5 * e50_10 * e50_10 * e50_25 * e100_40
              - 2 * e50_5 * e50_10 * e50_10 * e50_15 * e50_25 * e100_20
              - 2 * e50_10 * e50_15 * e50_15 * e50_25 * e100_10 * e100_20 * e100_20
              + e50_5 * e50_10 * e50_15 * e50_15 * e100_20 * e100_20 * e100_50)
           - e10 * e10 * power(etan(100, z, infty), 16) * w16 * e10_3 * e10_3 * e20_4
             * e50_5 * e50_10 * e50_10 * e50_20 * e50_25 * power(e100_50, 9))

def eq12229(q, z, infty):
   e100 = etan(100, z, infty)
   e100_20 = eta(100, 20, z, infty)
   e100_25 = eta(100, 25, z, infty)
   e100_40 = eta(100, 40, z, infty)
   e100_50 = eta(100, 50, z, infty)
   e20 = etan(20, z, infty)
   e20_5 = eta(20, 5, z, infty)
   e25 = etan(25, z, infty)
   e25_5 = eta(25, 5, z, infty)
   e25_10 = eta(25, 10, z, infty)
   e5 = etan(5, z, infty)
   e5_1 = eta(5, 1, z, infty)
   e50_5 = eta(50, 5, z, infty)
   e50_10 = eta(50, 10, z, infty)
   e50_15 = eta(50, 15, z, infty)
   e50_20 = eta(50, 20, z, infty)
   e6_1 = eta(6, 1, z, infty)
   return (e5 * e5 * e100 * e100 * e5_1**10 * e6_1**3
           * (e50_5 * e50_10**3 * e100_40 * e100_50
            + e50_15 * e50_20**3 * e100_20 * e100_50
            - 3 * power(e50_10 * e50_20 * e100_25, 2))
           - e6_1**3 * e5_1**10 * power(e20 * e25 * e20_5 * e25_5 * e25_10 * e50_10 * e50_20, 2))

def eq12231(q, z, infty):
   e10 = etan(10, z, infty)
   e10_1 = eta(10, 1, z, infty)
   e10_2 = eta(10, 2, z, infty)
   e10_3 = eta(10, 3, z, infty)
   e100_10 = eta(100, 10, z, infty)
   e100_30 = eta(100, 30, z, infty)
   e100_50 = eta(100, 50, z, infty)
   e20 = etan(20, z, infty)
   e20_2 = eta(20, 2, z, infty)
   e20_4 = eta(20, 4, z, infty)
   e20_8 = eta(20, 8, z, infty)
   e4 = etan(4, z, infty)
   e50 = etan(50, z, infty)
   e50_5 = eta(50, 5, z, infty)
   e50_15 = eta(50, 15, z, infty)
   e50_25 = eta(50, 25, z, infty)
   return (e4 * e4 * e50 * e50 * e10_2 * e10_2 * e10_2 * e10_3 * e20_2
           * (e50_5 * e50_15 * e50_25 * e100_50
              + e50_5 * e50_15 * e50_25 * e100_30
              - e50_5 * e50_15 * e50_25 * e100_10
              - e50_5 * e50_5 * e50_15 * e100_50
              - e50_5 * e50_25 * e50_25 * e100_30
              + 2 * e50_5 * e50_5 * e50_25 * e100_30
              - e50_15 * e50_15 * e50_25 * e100_10)
           - e10 * e10 * e20 * e20 * power(e10_1 * e10_2 * e20_4 * e20_8, 3) * e50_5 * e50_15 * e50_25)

def eq12233(q, z, infty):
   e10 = etan(10, z, infty)
   e10p7 = power(e10, 7)
   e10p8 = e10p7 * e10
   e10_1 = eta(10, 1, z, infty)
   e10_1p3 = e10_1 * e10_1 * e10_1
   e10_3 = eta(10, 3, z, infty)
   e10_3p3 = e10_3 * e10_3 * e10_3
   e10_4 = eta(10, 4, z, infty)
   e100 = etan(100, z, infty)
   e100_10 = eta(100, 10, z, infty)
   e100_20 = eta(100, 20, z, infty)
   e100_30 = eta(100, 30, z, infty)
   e100_40 = eta(100, 40, z, infty)
   e100_50 = eta(100, 50, z, infty)
   e20 = etan(20, z, infty)
   e20p2 = e20 * e20
   e20p3 = e20p2 * e20
   e20p10 = power(e20, 10)
   e20_2 = eta(20, 2, z, infty)
   e20_4 = eta(20, 4, z, infty)
   e20_4p2 = e20_4 * e20_4
   e20_5 = eta(20, 5, z, infty)
   e20_5p2 = e20_5 * e20_5
   e20_6 = eta(20, 6, z, infty)
   e20_8 = eta(20, 8, z, infty)
   e20_8p2 = e20_8 * e20_8
   e20_10 = eta(20, 10, z, infty)
   e20_10p3 = e20_10 * e20_10 * e20_10
   e200_50 = eta(200, 50, z, infty)
   e200_100 = eta(200, 100, z, infty)
   e40_10 = eta(40, 10, z, infty)
   e50 = etan(50, z, infty)
   e50p2 = e50 * e50
   e50_5 = eta(50, 5, z, infty)
   e50_10 = eta(50, 10, z, infty)
   e50_10p2 = e50_10 * e50_10
   e50_15 = eta(50, 15, z, infty)
   e50_20 = eta(50, 20, z, infty)
   e50_20p2 = e50_20 * e50_20
   e50_25 = eta(50, 25, z, infty)
   return (e10p8 * e20p3 * e50 * e10_1 * e10_4 * e20_4 * e20_8p2 * e50_5 * e50_15 * e50_25 * e200_50 * e200_100
           * (e10_1 * e20_10 * e100_40
              - 4 * e10_3 * e20_2 * e50_10 * e100_40
              + e10_1 * e20_10 * e50_20 * e100_20
              + 6 * e10_3 * e20_2 * e50_20 * e100_20)
           - 4 * e10_1 * e10_4 * e20_4 * e20_8p2 * e40_10 * e50_5 * e50_10 * e50_15 * e50_20 * e50_25 * e200_100
           * (e10p7 * e20p2 * e50p2 * e100 * e10_1 * e50_10p2 * e50_20p2
              + e10 * e20p10 * e100 * e10_3 * e20_2 * e20_10p3)
           - (e10p8 * e20p3 * e50 * e50_5 * e50_10 * e50_15 * e50_20 * e100_50 * e200_50 * e200_100
              * (e10_1p3 * e20_6 * e20_8p2 * e20_10
                 - 4 * e10_1 * e10_3 * e10_4 * e20_2 * e20_5p2 * e20_8
                 - e10_3p3 * e20_2 * e20_4p2 * e20_10)
              + e10p8 * e20p3 * e50 * e50_5 * e50_10 * e50_20 * e50_25 * e100_30 * e200_50 * e200_100
              * (2 * e10_1p3 * e20_6 * e20_8p2 * e20_10
                 + 2 * e10_1 * e10_3 * e10_4 * e20_2 * e20_5p2 * e20_8
                 + 3 * e10_3p3 * e20_2 * e20_4p2 * e20_10)
              - e10p8 * e20p3 * e50 * e50_10 * e50_15 * e50_20 * e50_25 * e100_10 * e200_50 * e200_100
              * (3 * e10_1p3 * e20_6 * e20_8p2 * e20_10
                 - 2 * e10_1 * e10_3 * e10_4 * e20_2 * e20_5p2 * e20_8
                 + 2 * e10_3p3 * e20_2 * e20_4p2 * e20_10)))

#*** eta eta eta
def eq12235(q, infty):
   return 0

def eq12237(q, infty):
   return 0

def eq12238(q, infty):
   return 0

def eq12239(q, infty):
   return 0

def eq12240(q, infty):
   return 0

def eq12242(q, infty):
   return 0

def eq12243(q, infty):
   return 0

def theorem1251(q, infty):
   return 0

def myprint(a, b, c, d):
   s = ""
   if mp.fabs(b) > 1e-7:
      s = s + a + " " + str(b) + " "
   else:
      s = s + a + " 0 "
   if mp.fabs(d) > 1e-7:
      s = s + c + " " + str(d)
   elif c != "":
      s = s + c + " 0"
   print(s)
   return

def demo(q, a, b, c, d, n, infty):
   print("_______________")
   print("q =", q)
   print("Euler", ramanujan(q, q, infty), "=", Euler(q, infty))
   myprint("eq847",     eq847(q, my_int(infty/4)),    "eq8419",  eq8419(q, my_int(infty/4)))
   return
   myprint("M1",        M1(q, infty),                 "M2",      M2(q, infty))
   myprint("M3",        M3(q, infty),                 "M4",      M4(q, infty))
   myprint("M5",        M5(q, infty),                 "M6",      M6(q, infty))
   myprint("M7",        M7(q, infty),                 "M8",      M8(q, infty))
   myprint("M9",        M9(q, infty),                 "M10",     M10(q, infty))
   myprint("eq341",     eq341(q, infty),              "eq342",   eq342(q, infty))
   myprint("eq343",     eq343(q, infty),              "eq344",   eq344(q, infty))
   myprint("eq345",     eq345(q, infty),              "eq346",   eq346(q, infty))
   myprint("eq347",     eq347(q, infty),              "eq348",   eq348(q, infty))
   myprint("eq349",     eq349(q, infty),              "eq3410",  eq3410(q, infty))
   myprint("eq3411",    eq3411(q, infty),             "eq3412",  eq3412(q, infty))
   myprint("eq3413",    eq3413(q, infty),             "eq3414",  eq3414(q, infty))
   myprint("eq354",     eq354(q, infty),              "eq355",   eq355(q, infty))
   myprint("eq356",     eq356(q, infty), "", 0)
   myprint("eq451",     eq451(q, infty),              "eq454",   eq454(q, a, b, c, d, infty))
   myprint("eq455",     eq455(q, a, b, infty),        "eq456",   eq456(q, a, b, infty))
   myprint("eq531",     eq531(q, infty),              "eq532",   eq532(q, infty))
   myprint("eq533",     eq533(q, infty),              "eq534",   eq534(q, infty))
   myprint("eq539",     eq539(q, infty),              "eq5310",  eq5310(q, infty))
   myprint("eq5311",    eq5311(q, infty),             "eq5312",  eq5312(q, infty))
   myprint("eq613",     eq613(q, infty),              "eq614",   eq614(q, infty))
   myprint("eq621",     eq621(q, infty),              "eq622",   eq622(q, infty))
   myprint("lemma631",  lemma631(q, a, infty),        "lemma632", lemma632(q, a, b, infty))
   myprint("lemma633",  lemma633(q, a, b, infty),     "lemma634", lemma634(q, a, b, infty))
   myprint("lemma635",  lemma635(q, a, b, infty),     "lemma636", lemma636(q, a, b, infty))
   myprint("eq6411",    eq6411(q, a, infty), "", 0)
   myprint("eq721",     eq721(q, 1, infty),           "eq722",   eq722(q, 2, infty))
   myprint("eq723",     eq723(q, 1, infty),           "eq726",   eq726(q, n, a, n, infty))
   myprint("eq7211",    eq7211(q, n, a, infty),       "eq7214",  eq7214(q, infty))
   myprint("eq7215",    eq7215(q, infty),             "eq7216",  eq7216(q, infty))
   myprint("eq7217",    eq7217(q, infty),             "eq7320",  eq7320(q, infty))
   myprint("eq7321",    eq7321(q, infty),             "eq7322",  eq7322(q, infty))
   myprint("eq7323",    eq7323(q, infty),             "eq7324",  eq7324(q, infty))
   myprint("eq7325",    eq7325(q, infty),             "eq7326",  eq7326(q, infty))
   myprint("eq741",     eq741(q, infty),              "eq742",   eq742(q, infty))
   myprint("eq7433",    eq7433(q, infty),             "eq7434",  eq7434(q, infty))
   myprint("eq7435",    eq7435(q, infty),             "eq7436",  eq7436(q, infty))
   myprint("eq7444",    eq7444(q, infty),             "eq7445",  eq7445(q, infty))
   myprint("eq751",     eq751(q, infty),              "eq752",   eq752(q, infty))
   myprint("eq753",     eq753(q, infty),              "eq7517",  eq7517(q, infty))
   myprint("eq7518",    eq7518(q, infty),             "eq7529",  eq7529(q, infty))
   myprint("eq761",     eq761(q, infty),              "eq764",   eq764(q, infty))
   myprint("eq823",     eq823(q, n, a, infty),        "eq8210",  eq8210(q, n, a, infty))
   myprint("eq8213",    eq8213(q, n, a, infty),       "eq8216",  eq8216(q, n, infty))
   myprint("eq8217",    eq8217(q, n, infty),          "eq8220",  eq8220(q, n, infty))
   myprint("eq8221",    eq8221(q, n, infty),          "eq8224",  eq8224(q, n, infty))
   myprint("eq8225",    eq8225(q, n, infty), "", 0)
   myprint("eq831",     eq831(q, infty),              "eq833",   eq833(q, infty))
   myprint("eq836",     eq836(q, infty),              "eq838",   eq838(q, infty))
   myprint("eq839",     eq839(q, infty),              "eq8312",  eq8312(q, infty))
   myprint("eq8313",    eq8313(q, infty),             "eq8322",  eq8322(q, infty))
   myprint("eq841",     eq841(q, 1, infty),           "eq842",   eq842(q, 2, infty))
   myprint("eq843",     eq843(q, 1, infty),           "eq844",   eq844(q, 2, infty))
   myprint("eq847",     eq847(q, my_int(infty/4)),    "eq8419",  eq8419(q, my_int(infty/4)))
   myprint("eq8422",    eq8422(q, my_int(infty/4)),   "eq8425",  eq8425(q, my_int(infty/4)))
   myprint("eq852",     eq852(q, a, my_int(infty/2)), "eq853",   eq853(q, a, my_int(infty/2)))
   myprint("eq925",     eq925(q, infty),              "eq933",   eq933(q, a, infty))
   myprint("eq934",     eq934(q, a, infty),           "eq9420",  eq9420(q, a, infty))
   myprint("eq966",     eq966(q, a, b, infty),        "eq9615",  eq9615(q, a, 1, infty))
   myprint("eq9616",    eq9616(q, a, 2, infty),       "eq9617",  eq9617(q, a, 3, infty))
   myprint("eq9618",    eq9618(q, a, 4, infty),       "eq9619",  eq9619(q, n, infty))
   myprint("eq971",     eq971(q, a, infty),           "eq974",   eq974(q, infty))
   myprint("eq975",     eq975(q, a, infty),           "eq978",   eq978(q, infty))
   myprint("eq1021",    eq1021(q, infty),             "eq1022",  eq1022(q, infty))
   myprint("eq1032",    eq1032(q, a, infty),          "eq1033",  eq1033(q, a, infty))
   myprint("eq1049",    eq1049(q, a, infty), "", 0)
   myprint("eq10410",   eq10410(q, a, infty),         "eq10421", eq10421(q, a, infty))
   myprint("eq1068",    eq1068(q, a, b, infty),       "eq10647", eq10647(q, a, infty))
   myprint("lemma1064", lemma1064(q, a, 2, infty),    "lemma1065", lemma1065(q, a, 3, infty))
   myprint("eq1071",    eq1071(q, a, infty),          "eq1074",  eq1074(q, infty))
   myprint("eq1075",    eq1075(q, a, infty),          "eq1078",  eq1078(q, infty))
   myprint("eq1111",    eq1111(q, infty),             "eq1113",  eq1113(q, infty))
   myprint("eq1121",    eq1121(q, a, b, infty),       "eq1123",  eq1123(q, a, b, infty))
   myprint("eq1131",    eq1131(q, a, b, infty),       "eq1132",  eq1132(q, a, b, infty))
   myprint("eq1133",    eq1133(q, a, b, infty),       "eq1136",  eq1136(q, a, b, c, infty))
   myprint("eq11311",   eq11311(q, a, infty),         "eq11316", eq11316(q, a, b, infty))
   myprint("eq11319",   eq11319(q, a, infty),         "eq11321", eq11321(q, a, b, c, infty))
   myprint("eq11330",   eq11330(q, a, infty),         "eq11332", eq11332(q, infty))
   myprint("eq11333",   eq11333(q, infty),            "eq11336", eq11336(q, infty))
   myprint("eq11337",   eq11337(q, infty),            "lemma1139", lemma1139(q, a, b, c, infty))
   myprint("eq1141",    eq1141(q, infty),             "eq1144",  eq1144(q, infty))
   myprint("eq1147",    eq1147(q, infty),             "eq1149",  eq1149(q, infty))
   myprint("eq11411",   eq11411(q, infty),            "eq1213",  eq1213(q, n, infty))
   myprint("eq1214",    eq1214(q, n, infty),          "eq1221",  eq1221(q, a, b, infty))
   myprint("eq1222",    eq1222(q, a, b, infty),    "eq1223",  eq1223(q, a, b, c, d, infty))
   myprint("eq1227",    eq1227(q, infty),             "eq12212", eq12212(q, infty))
   myprint("eq12216",   eq12216(q, infty),            "eq12225", eq12225(q, a, infty))
   myprint("eq12227",   eq12227(q, a, infty),         "eq12229", eq12229(q, a, infty))
   myprint("eq12231",   eq12231(q, a, infty),         "eq12233", eq12233(q, a, infty))
   return
   myprint("eq12235",   eq12235(q, infty),            "eq12237", eq12237(q, infty))
   myprint("eq12238",   eq12238(q, infty),            "eq12239", eq12239(q, infty))
   myprint("eq12240",   eq12240(q, infty),            "eq12242", eq12242(q, infty))
   myprint("eq12243",   eq12243(q, infty),            "theorem1251", theorem1251(q, infty))
   return

mp.dps = 15
#Funny definition: Infinity is an integer witch we pass as a parameter.
infty = 1000
q = 0.5
b = 0.1
print("Jacobi", f(q, b, infty), Jacobi(q, b, infty))
infty = 40
demo(0.5, 0.6, 0.2, 0.3, 0.4, 7, infty)
demo(-0.3 + 0.4 * j, 0.6 + 0.6 * j, 0.2 + 0.2 * j, 0.3 + 0.3 * j, 0.4 + 0.4 * j, 6, infty)

# Release 0.1 from 2021/Mar/27
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.
