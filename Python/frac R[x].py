from mpmath import *
import numpy as np
import numpy.core.numeric as NX
from numpy.linalg import eigvals

class TAlgebraicFraction:
   def __init__(self, n, d):
      self.n = np.poly1d(n)
      self.d = np.poly1d(d)
   def toString(self):
      return "(" + toString(self.n) + ")/(" + toString(self.d) + ")"
   def add(self, f):
      res = TAlgebraicFraction(self.n * f.d + self.d * f.n, self.d * f.d)
      k = 1/res.d.coef[0]
      res.n, res.d = res.n * k, res.d * k
      return res
   def opposite(self):
      return TAlgebraicFraction(-self.n, self.d)
   def inverse(self):
      return TAlgebraicFraction(self.d, self.n)
   def sub(self, f):
      return self.add(f.opposite())
   def mul(self, f):
      return TAlgebraicFraction(self.n * f.n, self.d * f.d)
   def div(self, f):
      return TAlgebraicFraction(self.n * f.d, self.d * f.n)
   def dilat(self, k):
      return TAlgebraicFraction(self.n * k, self.d)
   def eval(f, x):
      return f.n(x)/f.d(x)

   def abs(self):
      if isZero(self.n):
         return 0
      fn, fd = isxn(self.n), isxn(self.d)
      if fn and fd:
         return 1
      max = 0
      if not fn:
         coefs = self.n.coef
         for i, a in enumerate(coefs):
            k = mp.fabs(a)
            if k > max:
               max = k
      if not fd:
         coefs = self.d.coef
         for i, a in enumerate(coefs):
            k = mp.fabs(a)
            if k > max:
               max = k
      return max

   def simplify(res):
      for k in range (0, len(res.n)):
         if not isfinite(res.n.coef[k]):
            return res
      for k in range (0, len(res.d)):
         if not isfinite(res.d.coef[k]):
            return res
      k = 1/res.d.coef[0]
      res.n, res.d = res.n * k, res.d * k
      lista, cn, cd = list(), complexRoots(res.n), complexRoots(res.d)
      for r in cn:
         for r2 in cd:
            if mp.fabs(r - r2) < 1e-5:
               if not contains(lista, r):
                  lista.append(r)
      for r in lista:
         p = np.poly1d([1, -r])
         while (True): # multiplicity
            q1, r1 = complexPolyDiv(res.n, p)
            q2, r2 = complexPolyDiv(res.d, p)
            if (not isZero(r1)) or (not isZero(r2)):
               break
            res.n, res.d = q1, q2
      return res

   def isZero(self):
      return isZero(self.n)

   def atan(self): # integral from 0 to T of Id/(Id + M^2) dM around i and -i
      root, soma = complexRoots(self.n - self.d), 0
      root = root[0]
      T = TAlgebraicFraction(self.n, self.d).simplify()
      n = len(T.n)
      um = TAlgebraicFraction([1], [1]) # the "1" polynomial
      q, r = T.n / np.poly1d([1, 0])
      intz = TAlgebraicFraction([0], [1]) # the "0" polynomial
      if T.add(um.dilat(j)).isZero() or T.sub(um.dilat(j)).isZero(): # 0, \pm 1, 0, 0
         return um.dilat(1e100) # infty
      normal = True
      if isZero(T.d - np.poly1d([1])):
         p = r.coef[0]
         if isZero(q) and (r == np.poly1d(p)): # T is 0-degree/1
            if (mp.fabs(mp.im(p)) > 1) and (mp.fabs(mp.re(p)) < 1e-9):
               normal = False # int_0^2i = int_0^1 + int_1^2i = pi/4 + int_1^T
      h = 2e-2
      ti = h
      if normal:
         zd = TAlgebraicFraction(T.n, T.d)
      else:
         zd = T.sub(um)
      while ti <= 1:
         if normal:
            #ti = 0 => zi = 0
            #ti = 1 => zi = T
            zi = T.dilat(ti)
         else:
            #ti = 0 => zi = 1
            #ti = 1 => zi = p*j = T
            zi = um.dilat((p*j - 1) * ti + 1)
         termo = um.add(zi.mul(zi)).inverse().mul(zd).dilat(h)
         intz, soma = intz.add(termo), soma + termo.eval(root)
         ti = ti + h
      if not normal:
         intz = intz.add(um.dilat(mp.pi()/4))
      #intz = intz.simplify()
      print("atan 1 =", soma, "// root =", root, "\n")
      return intz

   def sin(p):
      # sin p = p - p^3/3! + p^5/5! - p^7/7! + ...
      res = TAlgebraicFraction([0], [1]) # the "0" polynomial
      s = 1
      xx = p
      fat = 1
      for i in range (1, 100):
         termo = xx.dilat(s/fat)
         res = res.add(termo)
         if termo.abs() < 1e-5:
            break
         s = - s
         xx = xx.mul(p).mul(p)
         fat = fat * (2 * i) * (2 * i + 1)
      return res.simplify()

   def cos(p):
      # cos p = 1 - p^2/2! + p^4/4! - p^6/6! + ...
      res = TAlgebraicFraction([0], [1]) # the "0" polynomial
      s = 1
      xx = TAlgebraicFraction([1, 0], [1]) # the "x" polynomial
      fat = 1
      for i in range (1, 100):
         termo = xx.dilat(s/fat)
         res = res.add(termo)
         if termo.abs() < 1e-5:
            break
         s = - s
         xx = xx.mul(p).mul(p)
         fat = fat * (2 * i - 1) * (2 * i)
      return res.simplify()

   def tan(p):
      return p.sin().div(p.cos())

   # throwing idea 1: https://twitter.com/mathspiritual/status/1395410181073293313
   # t = 1 => |p(x) - 1| < 1
   def pow(p, r, t=0):
      if mp.fabs(r - my_round(mp.re(r))) > 1e-9:
         powxt = TAlgebraicFraction([1], [1]) # the "1" polynomial
         xt = p.sub(TAlgebraicFraction([t], [1])) # p(x) - t
         coef = power(t, r)
         res = TAlgebraicFraction([coef], [1]) # the "coef" polynomial
         for i in range (1, 30):
            powxt = powxt.mul(xt)
            coef = coef * (r - i) / t / i
            termo = powxt.dilat(coef)
            res = res.add(termo)
            if termo.abs() < 1e-5:
               break
         return res.simplify()

      r = mp.re(r)
      if r < 0:
         r = -r
         p = p.inverse()
      res = TAlgebraicFraction([1], [1]) # the "1" polynomial
      for i in range (1, my_int(r + 1)):
         res = res.mul(p)
      return res.simplify()

   def exp(p):
      # exp p = 1 + p + p^2/2! + p^3/3! + p^4/4! + ...
      res = TAlgebraicFraction([0], [1]) # the "0" polynomial
      xx = TAlgebraicFraction([1], [1]) # the "1" polynomial
      fat = 1
      for i in range (1, 100):
         termo = xx.dilat(1/fat)
         res = res.add(termo)
         norma = termo.abs()
         if (norma < 1e-5) or (norma > 1e10):
            break
         xx = xx.mul(p)
         fat = fat * i
      return res.simplify()

   def ln(self): # integral from Id to T of M^(-1) dM
      T = TAlgebraicFraction(self.n, self.d).simplify()
      um = TAlgebraicFraction([1], [1]) # the "1" polynomial
      q, r = T.n / np.poly1d([1, 0])
      intz = TAlgebraicFraction([0], [1]) # the "0" polynomial
      if isZero(T.n):
         return um.dilat(1e100) # infty
      normal = True
      if isZero(T.d - np.poly1d([1])):
         p = r.coef[0]
         if isZero(q) and (r == np.poly1d(p)): # T is 0-degree/1
            if (mp.fabs(mp.im(p)) < 1e-9) and (mp.fabs(mp.re(p)) < 1e-9):
               normal = False # ln (-2) = j * pi + ln 2
               T = T.opposite()
      h = 2e-2
      ti = h
      zd = T.sub(um)
      while ti <= 1:
         #ti = 0 => zi = 1
         #ti = 1 => zi = T
         zi = T.sub(um).dilat(ti).add(um)
         termo = zi.inverse().mul(zd).dilat(h)
         intz = intz.add(termo)
         ti = ti + h
      if not normal:
         intz = intz.add(um.dilat(mp.pi()*j))
      intz = intz.simplify()
      return intz

   def sqrt(p):
      return p.pow(0.5, 7)

   # throwing idea 2: https://twitter.com/mathspiritual/status/1398399242289307648
   # |p(x) - a/c| < min {|a/c - 1| , |a/c + 1|}
   def acos(p, a, c=1):
      x = a/c
      theta = mp.acos(x)
      z = mp.sin(theta) # == b/c
      b = c * z
      res = TAlgebraicFraction([theta], [1]) # the "theta" polynomial
      xt = p.sub(TAlgebraicFraction([x], [1])) # p(x) - a/c
      powxt = TAlgebraicFraction([1], [1]) # the "1" polynomial
      deriv = matrix([[0, 0], [1, 0]]) # p(z, x) = z
      degree = 1
      for k in range (1, 30):
         powxt = powxt.mul(xt)
         coef = evaluate(deriv, degree, z, x)
         termo = powxt.dilat(-coef)
         res = res.add(termo)
         if termo.abs() < 1e-5:
            break
         deriv = transform(deriv, degree)
         degree = degree + 2
      return res.simplify()

def evaluate(T, degree, z, x):
   soma = 0
   for i in range (0, degree + 1):
      for k in range (0, degree + 1):
         if T[i,k]:
            soma = soma + T[i,k] / power(z, i) * power(x, k)
   return soma

def transform(T, degree):
   R = mp.zeros(degree + 3, degree + 3)
   for i in range (0, degree + 1):
      for k in range (0, degree + 1):
         if T[i,k]:
            if k:
               R[i, k - 1] += T[i, k] * k
            R[i + 2, k + 1] += T[i, k] * i
   return R

def complexRoots(p):
    """
    Return the roots of a polynomial with coefficients given in p.

    The values in the rank-1 array `p` are coefficients of a polynomial.
    If the length of `p` is n+1 then the polynomial is described by::

      p[0] * x**n + p[1] * x**(n-1) + ... + p[n-1]*x + p[n]

    Parameters
    ----------
    p : array_like
        Rank-1 array of polynomial coefficients.

    Returns
    -------
    out : ndarray
        An array containing the roots of the polynomial.

    Raises
    ------
    ValueError
        When `p` cannot be converted to a rank-1 array.

    See also
    --------
    poly : Find the coefficients of a polynomial with a given sequence
           of roots.
    polyval : Compute polynomial values.
    polyfit : Least squares polynomial fit.
    poly1d : A one-dimensional polynomial class.

    Notes
    -----
    The algorithm relies on computing the eigenvalues of the
    companion matrix [1]_.

    References
    ----------
    .. [1] R. A. Horn & C. R. Johnson, *Matrix Analysis*.  Cambridge, UK:
        Cambridge University Press, 1999, pp. 146-7.

    Examples
    --------
    >>> coeff = [3.2, 2, 1]
    >>> np.roots(coeff)
    array([-0.3125+0.46351241j, -0.3125-0.46351241j])

    """
    # If input is scalar, this makes it an array
    p = np.atleast_1d(p)
    if p.ndim != 1:
        raise ValueError("Input must be a rank-1 array.")

    # find non-zero array entries
    non_zero = NX.nonzero(NX.ravel(p))[0]

    # Return an empty array if polynomial is all zeros
    if len(non_zero) == 0:
        return NX.array([])

    # find the number of trailing zeros -- this is the number of roots at 0.
    trailing_zeros = len(p) - non_zero[-1] - 1

    # strip leading and trailing zeros
    p = p[int(non_zero[0]):int(non_zero[-1])+1]

    # casting: if incoming array isn't floating point, make it floating point.
    if not issubclass(p.dtype.type, (NX.floating, NX.complexfloating)):
        p = p.astype(complex) #*** just changed this and adjust imports

    N = len(p)
    if N > 1:
        # build companion matrix and find its eigenvalues (the roots)
        A = np.diag(NX.ones((N-2,), NX.complexfloating), -1)
        A[0,:] = -p[1:] / p[0]
        roots = eigvals(A)
    else:
        roots = NX.array([])

    # tack any zeros onto the back of the array
    roots = np.hstack((roots, NX.zeros(trailing_zeros, roots.dtype)))
    return roots

def complexPolyDiv(u, v): #*** exchanged to complex too.
    """
    Returns the quotient and remainder of polynomial division.

    The input arrays are the coefficients (including any coefficients
    equal to zero) of the "numerator" (dividend) and "denominator"
    (divisor) polynomials, respectively.

    Parameters
    ----------
    u : array_like or poly1d
        Dividend polynomial's coefficients.

    v : array_like or poly1d
        Divisor polynomial's coefficients.

    Returns
    -------
    q : ndarray
        Coefficients, including those equal to zero, of the quotient.
    r : ndarray
        Coefficients, including those equal to zero, of the remainder.

    See Also
    --------
    poly, polyadd, polyder, polydiv, polyfit, polyint, polymul, polysub
    polyval

    Notes
    -----
    Both `u` and `v` must be 0-d or 1-d (ndim = 0 or 1), but `u.ndim` need
    not equal `v.ndim`. In other words, all four possible combinations -
    ``u.ndim = v.ndim = 0``, ``u.ndim = v.ndim = 1``,
    ``u.ndim = 1, v.ndim = 0``, and ``u.ndim = 0, v.ndim = 1`` - work.

    Examples
    --------
    .. math:: \\frac{3x^2 + 5x + 2}{2x + 1} = 1.5x + 1.75, remainder 0.25

    >>> x = np.array([3.0, 5.0, 2.0])
    >>> y = np.array([2.0, 1.0])
    >>> np.polydiv(x, y)
    (array([1.5 , 1.75]), array([0.25]))

    """
    truepoly = (isinstance(u, np.poly1d) or isinstance(u, np.poly1d))
    u = np.atleast_1d(u) + 0.0
    v = np.atleast_1d(v) + 0.0
    # w has the common type
    w = u[0] + v[0]
    m = len(u) - 1
    n = len(v) - 1
    scale = 1. / v[0]
    q = NX.zeros((max(m - n + 1, 1),), complex)
    r = u.astype(complex)
    for k in range(0, m-n+1):
        d = scale * r[k]
        q[k] = d
        r[k:k+n+1] -= d*v
    while NX.allclose(r[0], 0, rtol=1e-14) and (r.shape[-1] > 1):
        r = r[1:]
    if truepoly:
        return np.poly1d(q), np.poly1d(r)
    return q, r

def isZero(p):
   coefs = p.coef
   for i, a in enumerate(coefs):
      if mp.fabs(a) > 1e-9:
         return False
   return True

def isxn(p):
   p.coef[0] -= 1
   flag = isZero(p)
   p.coef[0] += 1
   return flag

def contains(lista, x):
   for cadaUm in lista:
      if cadaUm == x:
         return True
   return False

def toString(p):
    coefs = p.coef  # List of coefficient, sorted by increasing degrees
    res = ""  # The resulting string
    lista1, lista2 = list(), list()
    for i, a in enumerate(coefs):
       lista1.append(a)
       lista2.insert(0, i)
    for k in range (0, len(lista1)):
        a, i = complex(lista1[k]), lista2[k]
        if (mp.fabs(mp.im(a)) < 1e-9) and (mp.fabs(mp.re(a) - my_round(mp.re(a))) < 1e-9):  # Remove the trailing .0
            a = int(mp.re(a))
        if i == 0:  # First coefficient, no need for x
            if (mp.fabs(mp.im(a)) < 1e-9) and (mp.re(a) < 0):
                res += " - {b}".format(b=-a)
            elif mp.fabs(a) > 1e-9:
                res += " + {a}".format(a=a)
            # a = 0 is not displayed
        elif i == 1:  # Second coefficient, only x and not x**i
            if a == 1:  # a = 1 does not need to be displayed
                res += " + x"
            elif a == -1:
                res += " - x"
            elif mp.re(a) < 0:
                res += " - {b}*x".format(b=-mp.re(a))
            elif mp.fabs(a) > 1e-9:
                res += " + {a}*x".format(a=a)
        else:
            if a == 1:
                res += " + x^{i}".format(i=i)
            elif a == -1:
                res += " - x^{i}".format(i=i)
            elif mp.re(a) < 0:
                res += " - {b}*x^{i}".format(b=-mp.re(a), i=i)
            elif mp.fabs(a) > 1e-9:
                res += " + {a}*x^{i}".format(a=a, i=i)
    if lista1[0] > 0:
       return res[3:]
    return res[1:]

def power(x, y):
   if x == 0:
      return 0
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

def demo(p):
   print("p =", p.toString())
   print("|p| =", p.abs())
   print("1/p =", p.inverse().toString())
   print("p^2 =", p.pow(2).toString())
   print("sqrt p =", p.sqrt().toString())
   print("exp p =", p.exp().toString())
   print("ln p =", p.ln().toString())
   print("sin p =", p.sin().toString())
   print("cos p =", p.cos().toString())
   print("tan p =", p.tan().toString())
   print("arctan p =", p.atan().toString())
   print("")
   print("arccos p =", p.acos(12, 13).toString())
   print("")
   return

mp.dps = 15
f = TAlgebraicFraction([2, 0, 2], [1, j])
f.n, f.d = f.n * [1, j], f.d * [1, j]
g = f.simplify()
print(f.toString(), "=", g.toString(), "\n")
g = TAlgebraicFraction([1, 0], [1])
demo(g)
g = g.inverse()
demo(g)
g = TAlgebraicFraction([0.2, 0.3], [0.5, 0.7])
demo(g)

# Release 0.1 from 2021/May/17th
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# out of charity, there is no salvation at all.
# with charity, there is evolution.

