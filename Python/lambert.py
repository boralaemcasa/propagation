# https://pbs.twimg.com/media/Evt2ufqWgAEU_wS?format=jpg&name=large
# https://pbs.twimg.com/media/Evt8t0nWQAEmtYO?format=png&name=large

# https://www.dropbox.com/s/vv6qgj16hgk1sch/Solving%20Any%20Quintic.pdf?dl=0

from mpmath import *
import numpy as np

# All we have to do is to incorporate n dimensioned W's like this:
def lambertw_incorporated(ctx, z, k=0):
    z = ctx.convert(z)
    k = int(k)
    if not ctx.isnormal(z):
        return _lambertw_special(ctx, z, k)
    prec = ctx.prec
    ctx.prec += 20 + ctx.mag(k or 1)
    wp = ctx.prec
    tol = wp - 5
    w, done = _lambertw_series(ctx, z, k, tol)
    if not done:
        # Use Halley iteration to solve w*exp(w) = z
        two = ctx.mpf(2)
        for i in xrange(100):
            ew = ctx.exp(w)
            wew = w*ew
            wewz = wew-z
            wn = w - wewz/(wew+ew-(w+two)*wewz/(two*w+two))
            if ctx.mag(wn-w) <= ctx.mag(wn) - tol:
                w = wn
                break
            else:
                w = wn
        if i == 100:
            ctx.warn("Lambert W iteration failed to converge for z = %s" % z)
    ctx.prec = prec
    return +w

def _lambertw_special_incorporated(ctx, z, k):
    # W(0,0) = 0; all other branches are singular
    if not z:
        if not k:
            return z
        return ctx.ninf + z
    if z == ctx.inf:
        if k == 0:
            return z
        else:
            return z + 2*k*ctx.pi*ctx.j
    if z == ctx.ninf:
        return (-z) + (2*k+1)*ctx.pi*ctx.j
    # Some kind of nan or complex inf/nan?
    return ctx.ln(z)

def _lambertw_series_incorporated(ctx, z, k, tol):
    """
    Return rough approximation for W_k(z) from an asymptotic series,
    sufficiently accurate for the Halley iteration to converge to
    the correct value.
    """
    magz = ctx.mag(z)
    if (-10 < magz < 900) and (-1000 < k < 1000):
        # Near the branch point at -1/e
        if magz < 1 and abs(z+0.36787944117144) < 0.05:
            if k == 0 or (k == -1 and ctx._im(z) >= 0) or \
                         (k == 1  and ctx._im(z) < 0):
                delta = ctx.sum_accurately(lambda: [z, ctx.exp(-1)])
                cancellation = -ctx.mag(delta)
                ctx.prec += cancellation
                # Use series given in Corless et al.
                p = ctx.sqrt(2*(ctx.e*z+1))
                ctx.prec -= cancellation
                u = {0:ctx.mpf(-1), 1:ctx.mpf(1)}
                a = {0:ctx.mpf(2), 1:ctx.mpf(-1)}
                if k != 0:
                    p = -p
                s = ctx.zero
                # The series converges, so we could use it directly, but unless
                # *extremely* close, it is better to just use the first few
                # terms to get a good approximation for the iteration
                for l in xrange(max(2,cancellation)):
                    if l not in u:
                        a[l] = ctx.fsum(u[j]*u[l+1-j] for j in xrange(2,l))
                        u[l] = (l-1)*(u[l-2]/2+a[l-2]/4)/(l+1)-a[l]/2-u[l-1]/(l+1)
                    term = u[l] * p**l
                    s += term
                    if ctx.mag(term) < -tol:
                        return s, True
                    l += 1
                ctx.prec += cancellation//2
                return s, False
        if k == 0 or k == -1:
            return _lambertw_approx_hybrid(z, k), False
    if k == 0:
        if magz < -1:
            return z*(1-z), False
        L1 = ctx.ln(z)
        L2 = ctx.ln(L1)
    elif k == -1 and (not ctx._im(z)) and (-0.36787944117144 < ctx._re(z) < 0):
        L1 = ctx.ln(-z)
        return L1 - ctx.ln(-L1), False
    else:
        # This holds both as z -> 0 and z -> inf.
        # Relative error is O(1/log(z)).
        L1 = ctx.ln(z) + 2j*ctx.pi*k
        L2 = ctx.ln(L1)
    return L1 - L2 + L2/L1 + L2*(L2-2)/(2*L1**2), False

def _lambertw_approx_hybrid_incorporated(z, k):
    imag_sign = 0
    if hasattr(z, "imag"):
        x = float(z.real)
        y = z.imag
        if y:
            imag_sign = (-1) ** (y < 0)
        y = float(y)
    else:
        x = float(z)
        y = 0.0
        imag_sign = 0
    # hack to work regardless of whether Python supports -0.0
    if not y:
        y = 0.0
    z = complex(x,y)
    if k == 0:
        if -4.0 < y < 4.0 and -1.0 < x < 2.5:
            if imag_sign:
                # Taylor series in upper/lower half-plane
                if y > 1.00: return (0.876+0.645j) + (0.118-0.174j)*(z-(0.75+2.5j))
                if y > 0.25: return (0.505+0.204j) + (0.375-0.132j)*(z-(0.75+0.5j))
                if y < -1.00: return (0.876-0.645j) + (0.118+0.174j)*(z-(0.75-2.5j))
                if y < -0.25: return (0.505-0.204j) + (0.375+0.132j)*(z-(0.75-0.5j))
            # Taylor series near -1
            if x < -0.5:
                if imag_sign >= 0:
                    return (-0.318+1.34j) + (-0.697-0.593j)*(z+1)
                else:
                    return (-0.318-1.34j) + (-0.697+0.593j)*(z+1)
            # return real type
            r = -0.367879441171442
            if (not imag_sign) and x > r:
                z = x
            # Singularity near -1/e
            if x < -0.2:
                return -1 + 2.33164398159712*(z-r)**0.5 - 1.81218788563936*(z-r)
            # Taylor series near 0
            if x < 0.5: return z
            # Simple linear approximation
            return 0.2 + 0.3*z
        if (not imag_sign) and x > 0.0:
            L1 = math.log(x); L2 = math.log(L1)
        else:
            L1 = cmath.log(z); L2 = cmath.log(L1)
    elif k == -1:
        # return real type
        r = -0.367879441171442
        if (not imag_sign) and r < x < 0.0:
            z = x
        if (imag_sign >= 0) and y < 0.1 and -0.6 < x < -0.2:
            return -1 - 2.33164398159712*(z-r)**0.5 - 1.81218788563936*(z-r)
        if (not imag_sign) and -0.2 <= x < 0.0:
            L1 = math.log(-x)
            return L1 - math.log(-L1)
        else:
            if imag_sign == -1 and (not y) and x < 0.0:
                L1 = cmath.log(z) - 3.1415926535897932j
            else:
                L1 = cmath.log(z) - 6.2831853071795865j
            L2 = cmath.log(L1)
    return L1 - L2 + L2/L1 + L2*(L2-2)/(2*L1**2)

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
   
def g(x, t):
   c, a0, r1, r2 = t[0], t[1], t[2], t[3]
   return mp.exp(-c * x) - a0 * (x - r1) * (x - r2)
   
def superw(c, a0, r1, r2):
   for x1 in range (0, 100):
      y = newton_method(g, 0, x1, x1 + 1, [c, a0, r1, r2], 1e-13)
      if mp.fabs(g(y, [c, a0, r1, r2])) < 1e-9:
         return y
      y = newton_method(g, 0, -x1 - 1, -x1, [c, a0, r1, r2], 1e-13)
      if mp.fabs(g(y, [c, a0, r1, r2])) < 1e-9:
         return y
   return 0
   
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
   if x == 0:
      return 0
   if (y / 2 == mp.floor(y / 2)) and (mp.im(x) == 0) and (mp.re(x) < 0):
      return mp.exp(y * mp.ln(-x))
   return mp.exp(y * mp.ln(x))
      
# z = ln z, trigonometric
def F(x, c):
   res = mp.zeros(2, 1)
   r, t = x[0], x[1]
   res[0] = r * mp.cos(t) - mp.ln(r)
   res[1] = r * mp.sin(t) - t
   return res
   
def dF(x, c):
   J = mp.zeros(2, 2)
   r, t = x[0], x[1]
   J[0,0] = mp.cos(t) - 1/r   # du\dx
   J[0,1] = - r * mp.sin(t)   # du\dy
   J[1,0] = mp.sin(t)         # dv\dx
   J[1,1] = r * mp.cos(t) - 1 # dv\dy
   return J
   
def ddF(x, c):
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
   
# exp(-cx - cyj) = a0 * (x - r1 + yj) * (x - r2 + yj)
#   exp(-cx) cos(cy) = a0 * (x - r1)(x - r2) - y^2
# - exp(-cx) sin(cy) = a0 * (2x - r1 - r2)y

# - cx - cyj = ln a0 + ln(x - r1 + yj) + ln(x - r2 + yj) + 2 k pi j
# - cx = ln a0 + Re ln(x - r1 + yj) + Re ln(x - r2 + yj)
# - cy = Im ln(x - r1 + yj) + Im ln(x - r2 + yj) + 2 k pi
# ln (A + Bj) = ln (rho e^(j theta)) = ln rho + j theta
# - cx = ln a0 + ln rho1 + ln rho2
# - cy = theta1 + theta2 + 2 k pi

def G(x, t):
   c, a0, r1, r2 = t[0], t[1], t[2], t[3]
   res = mp.zeros(2, 1)
   X, Y = x[0], x[1]
   res[0] = mp.exp(-c * X) * mp.cos(c * Y) - a0 * (X - r1) * (X - r2) + Y * Y
   res[1] = - mp.exp(-c * X) * mp.sin(c * Y) - a0 * (2 * X - r1 - r2) * Y
   return res
   
def dG(x, t):
   c, a0, r1, r2 = t[0], t[1], t[2], t[3]
   J = mp.zeros(2, 2)
   X, Y = x[0], x[1]
   J[0,0] = -c * mp.exp(-c * X) * mp.cos(c * Y) - a0 * (X - r1) - a0 * (X - r2) # du\dx
   J[0,1] = c * mp.exp(-c * X) * mp.cos(c * Y) + 2 * Y                          # du\dy
   J[1,0] = c * mp.exp(-c * X) * mp.sin(c * Y) - a0 * 2 * Y                     # dv\dx
   J[1,1] = - c * mp.exp(-c * X) * mp.sin(c * Y) - a0 * (2 * X - r1 - r2)       # dv\dy
   return J
   
def ddG(x, t):
   c, a0, r1, r2 = t[0], t[1], t[2], t[3]
   J = np.zeros((2, 2, 2), dtype=complex)
   X, Y = x[0], x[1]
   J[0,0,0] = c * c * mp.exp(-c * X) * mp.cos(c * Y) - a0 * 2 # ddu\dx\dx
   J[0,0,1] = -c * c * mp.exp(-c * X) * mp.cos(c * Y)         # ddu\dx\dy
   J[0,1,1] = c * c * mp.exp(-c * X) * mp.cos(c * Y) + 2      # ddu\dy\dy
   J[1,0,0] = - c * c * mp.exp(-c * X) * mp.sin(c * Y)        # ddv\dx\dx
   J[1,0,1] = c * c * mp.exp(-c * X) * mp.sin(c * Y) - a0 * 2 # ddv\dx\dy
   J[1,1,1] = - c * c * mp.exp(-c * X) * mp.sin(c * Y)        # ddv\dy\dy
   for i in range (0, 2):
      for j in range (0, 2):
         for k in range (i + 1, 2):
            J[i, k, j] = J[i, j, k]
   return J
   
def contains(lista, x):
   for cadaUm in lista:
      if cadaUm == x:
         return True
   return False

def hessian_method(n, a, f, df, ddf, x0, c, erro):
   xk = x0
   zant = 1e100
   for epocas in range (0, 100):
      y = f(xk, c)
      z = 0.5 * mp.norm(y)
      # print("z =", xk.T, "error =", z)
      if z > 1e10:
         return mp.zeros(n, 1)
      if mp.norm(z - zant) < erro:
         return xk
      zant = z
      J = df(xk, c)
      m = ddf(xk, c)
      g = mp.zeros(n, 1)
      for i in range (0, n):
         for k in range (0, a):
            g[i] = g[i] + y[k] * J[k, i]
      H = mp.zeros(n, n)
      for i in range (0, n):
         for k in range (0, n):
            for u in range (0, a):
               H[i, k] = H[i, k] + J[u, k] * J[u, i] + y[u] * m[u, i, k]
      xk = xk - mp.inverse(H) * g
   return mp.zeros(n, 1)

def demo():
   p = [2, 3, 5, 7]
   print("")
   print("Below, Newton with inverse Hessian (exp z = z):")
   print("")
   for i in range (5, 20):
      for k in range (40, 41):
         kk = k/10 + 0.05
         w = hessian_method(2, 2, F, dF, ddF, mp.matrix([i/10, kk]), p, 1e-13)
         r, t = w[0], w[1]
         z = round(mp.re(r * mp.cos(t)), 13) + j * round(mp.re(r * mp.sin(t)), 13)
         zz = z - mp.ln(z)
         if mp.fabs(mp.re(zz)) < 1e-5:
            zz = my_int(mp.im(zz)/mp.pi()) 
            s = str(my_int(mp.fabs(zz/2))) + " re = " + str(i/10) + " im = " + str(round(kk, 2)) + " kk = " + str(z) + " => z - ln z = " + str(zz) + " j pi"
            print(s)

def demo2():
   c = 2
   a0 = 3
   r1 = 5
   r2 = 7
   print("")
   print("Below, exp(-cx) = a0(x - r1)(x - r2):")
   print("")
   # e^{-cx} = a0(x - r1)(x - r2)
   x = superw(c, a0, r1, r2)
   print("x =", x, "error =", g(x, [c, a0, r1, r2]))

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

demo()
demo2()

print("")
print("Below, Newton with inverse Hessian (second degree):")
print("")
p = [2, 3, 5, 7]
c = 2
a0 = 3
r1 = 5
r2 = 7
for i in range (-5, 6):
   for k in range (-5, 6):
      w = hessian_method(2, 2, G, dG, ddG, mp.matrix([i, k]), p, 1e-13)
      x, y = w[0], w[1]
      z = x + j * y
      zz = mp.exp(-c * z) - a0 * (z - r1) * (z - r2)
      if mp.fabs(zz) < 1e-5:
         print(z, "error =", zz)

#Several minutes running later:

#0 re = 0.5 im = 0.45 kk = (0.3181315052048 - 1.3372357014307j) => z - ln z = 0 j pi
#1 re = 0.6 im = 0.75 kk = (2.0622777295983 + 7.5886311784725j) => z - ln z = 2 j pi
#2 re = 10.2 im = 0.45 kk = (2.6531919740387 + 13.9492083345332j) => z - ln z = 4 j pi
#3 re = 0.7 im = 0.75 kk = (3.0202397081645 - 20.2724576416152j) => z - ln z = -6 j pi
#4 re = 12.1 im = 0.45 kk = (3.2877686115441 - 26.5804714993591j) => z - ln z = -8 j pi
#5 re = 10.9 im = 1.15 kk = (3.4985152121541 - 32.8807214800689j) => z - ln z = -10 j pi
#6 re = 17.5 im = 0.65 kk = (3.6724500687099 + 39.1764400217352j) => z - ln z = 12 j pi
#7 re = 16.5 im = 0.45 kk = (3.8205543078138 + 45.4692654037108j) => z - ln z = 14 j pi
#8 re = 13.2 im = 0.75 kk = (3.9495227424225 - 51.7601220040207j) => z - ln z = -16 j pi
#9 re = 17.4 im = 0.45 kk = (4.0637417027917 + 58.0495734344775j) => z - ln z = 18 j pi
#10 re = 13.8 im = 1.25 kk = (4.1662424475288 - 64.337984120359j) => z - ln z = -20 j pi
#11 re = 2.0 im = 0.75 kk = (4.2592078559395 + 70.6256008021372j) => z - ln z = 22 j pi
#12 re = 17.6 im = 0.45 kk = (4.3442623028351 + 76.9125968597817j) => z - ln z = 24 j pi
#13 re = 39.6 im = 0.65 kk = (4.4226473672785 + 83.1990979088433j) => z - ln z = 26 j pi
#14 re = 40.2 im = 1.35 kk = (4.4953334317188 + 89.4851973238445j) => z - ln z = 28 j pi
#15 re = 40.8 im = 1.35 kk = (4.5630933498257 + 95.7709660450474j) => z - ln z = 30 j pi
#16 re = 1.9 im = 0.75 kk = (4.6265526777914 + 102.056458991569j) => z - ln z = 32 j pi
#17 re = 19.7 im = 0.75 kk = (4.6862248854575 - 108.341719381382j) => z - ln z = -34 j pi
#18 re = 62.1 im = 0.15 kk = (4.7425366350667 - 114.626781717147j) => z - ln z = -36 j pi
#19 re = 30.3 im = 0.25 kk = (4.7958463114377 + 120.911673896945j) => z - ln z = 38 j pi
#20 re = 92.2 im = 1.25 kk = (4.8464578566842 - 127.19641873639j) => z - ln z = -40 j pi
#21 re = 39.2 im = 0.75 kk = (4.8946312688213 - 133.481035085885j) => z - ln z = -42 j pi
#22 re = 52.0 im = 0.15 kk = (4.9405906854563 - 139.765538663849j) => z - ln z = -44 j pi
#23 re = 29.5 im = 1.45 kk = (4.9845306899913 - 146.049942687068j) => z - ln z = -46 j pi
#24 re = 58.9 im = 1.15 kk = (5.0266212897327 - 152.334258353796j) => z - ln z = -48 j pi
#25 re = 19.4 im = 1.25 kk = (5.0670118879889 - 158.618495218401j) => z - ln z = -50 j pi
#26 re = 40.1 im = 1.35 kk = (5.1058344847344 + 164.902661485054j) => z - ln z = 52 j pi
#27 re = 13.5 im = 0.75 kk = (5.14320627891 + 171.186764240249j) => z - ln z = 54 j pi
#29 re = 14.1 im = 1.25 kk = (5.2140046793064 + 183.75480305247j) => z - ln z = 58 j pi
#30 re = 14.9 im = 0.85 kk = (5.2476090981392 - 190.038749193653j) => z - ln z = -60 j pi
#32 re = 23.6 im = 1.45 kk = (5.3116092833442 + 202.606515780842j) => z - ln z = 64 j pi
#35 re = 99.3 im = 0.75 kk = (5.4005297630794 - 221.45790065126j) => z - ln z = -70 j pi
#42 re = 26.3 im = 1.15 kk = (5.5816232481528 + 265.443554793146j) => z - ln z = 84 j pi
#51 re = 30.5 im = 0.25 kk = (5.7746977853616 + 321.995314810311j) => z - ln z = 102 j pi
#59 re = 19.0 im = 0.75 kk = (5.9197265547233 - 372.262828782391j) => z - ln z = -118 j pi
#60 re = 37.5 im = 0.65 kk = (5.9364611669913 - 378.54623378111j) => z - ln z = -120 j pi
#64 re = 66.3 im = 0.55 kk = (6.0007324427421 + 403.679792000959j) => z - ln z = 128 j pi
#124 re = 20.9 im = 0.35 kk = (6.6601981939101 + 780.677243315799j) => z - ln z = 248 j pi
#125 re = 17.6 im = 0.55 kk = (6.6682139372522 + 786.96048654869j) => z - ln z = 250 j pi
#145 re = 6.9 im = 0.35 kk = (6.8163531700994 + 912.625197055396j) => z - ln z = 290 j pi
#148 re = 13.4 im = 0.75 kk = (6.836796159971 + 931.474882167529j) => z - ln z = 296 j pi
#152 re = 69.0 im = 1.05 kk = (6.8634192108204 + 956.607788393833j) => z - ln z = 304 j pi
#180 re = 40.0 im = 1.35 kk = (7.0322356372086 + 1132.53794242736j) => z - ln z = 360 j pi
#197 re = 37.5 im = 0.55 kk = (7.1223609019712 - 1239.35255506439j) => z - ln z = -394 j pi
#222 re = 23.5 im = 1.45 kk = (7.241689673457 + 1396.43274871794j) => z - ln z = 444 j pi
#761 re = 76.2 im = 1.25 kk = (8.4728400848484 + 4783.07304367047j) => z - ln z = 1522 j pi
#1627 re = 39.0 im = 0.75 kk = (9.2325241356085 - 10224.3123881112j) => z - ln z = -3254 j pi
#1808 re = 51.1 im = 1.05 kk = (9.3379921458869 - 11361.5690098148j) => z - ln z = -3616 j pi

# Release 0.1 from 2021/Apr/3rd
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# out of charity, there is no salvation at all.
# with charity, there is evolution.
