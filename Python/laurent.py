from mpmath import *

def power(x, y):
   if x == 0:
      return 0
   if (y / 2 == mp.floor(y / 2)) and (mp.im(x) == 0) and (mp.re(x) < 0):
      return mp.exp(y * mp.ln(-x))
   return mp.exp(y * mp.ln(x))

def an(f, n, a, r):
   h = 1e-2/2
   t = 0
   soma = 0
   while t < 2 * mp.pi():
      z = a + r * mp.cos(t) + j * r * mp.sin(t)
      dzdt = -r * mp.sin(t) + j * r * mp.cos(t)
      soma = soma + f(z) / power(z - a, n + 1) * dzdt * h
      t = t + h
   q = 1/(2 * mp.pi() * j)
   return q * soma

def f(z):
   return 1/z/(z - 0.1)/(z - 0.2)

def g(z):
   return z.conjugate()

def demo(f, a, r):
   infty = 20
   z = a + r
   holo = an(f, 0, a, r)
   pow = 1
   princ = 0
   # print("n = 0 a_n =", holo)
   for n in range (1, infty + 1):
      t1 = an(f, n, a, r)
      t2 = an(f, -n, a, r)
      # print("n =", n, "a_n =", t1, "a_{-n} =", t2)
      pow = pow * r # (z - a)
      holo = holo + t1 * pow
      princ = princ + t2 / pow
   print("z =", z, "f(z) =", f(z), "Laurent =", holo + princ)
   print("    Principal =", princ, "Holomorphic =", holo)

mp.dps = 15

# f is an example of "holes" at z = 0, z = 0.1 and z = 0.2

demo(f, 0, 0.08)
demo(f, 0.1, 0.05)
demo(f, 2, 1.1)

# g is a detour in the Matrix.
# When I integrated exp(ia)/exp(ib) * exp(ic) * i
# using fundamental theorem of Calculus, every a_n = 0, then L diverges.
# Except if only if exp(iS) = exp(0) = 1.
# Numerically, a_n != 0, and L converges to g.
# This is the same for h(z) = z^n, n integer.

demo(g, 0, 3 + 4*j)

# Release 0.1 from 2021/Mar/29
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.
