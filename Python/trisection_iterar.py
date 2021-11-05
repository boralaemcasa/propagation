# Your Spirit Guide is at: https://drive.google.com/file/d/1hDxdYpy1mXMhKBnLHHCVO9n-lTJ2_v8j/view?usp=sharing

from mpmath import *
import sys

def log10(x):
   return 1 + mp.re(mp.ln(x)/mp.ln(10))

def simplify(p, q, flagp, flagq, leftplus, ptimes, qtimes):
   # from: p/q (00); p/sqrt(q) (01); sqrt(p)/q (10); sqrt(p)/sqrt(q) (11)
   # shall return: str(a) + "* sqrt(" + str(b) + ")/(" + str(u) + "* sqrt(" + str(v) + "))"

   b, v = 1, 1
   sinalp = sgn(p)*sgn(ptimes)
   if (not flagp) and (not flagq):
      u, v = mp.fabs(p * ptimes), mp.fabs(q * qtimes)
   elif flagp and (not flagq):
      u, v = mp.fabs(p * ptimes), mp.fabs(q * q * qtimes * qtimes)
   elif (not flagp) and flagq:
      u, v = mp.fabs(p * p * ptimes * ptimes), mp.fabs(q * qtimes)
   else:
      u, v = mp.fabs(p * ptimes), mp.fabs(q * qtimes)

   sinalq = sgn(q)*sgn(qtimes)
   if sinalq < 0:
      sinalp = -sinalp

   u, v = reduce_fraction(u, v)
   if (not flagp) and (not flagq):
      a, b, u, v = u, 1, v, 1
   elif flagp and (not flagq):
      a, b, u, v = u, 1, 1, v
   elif (not flagp) and flagq:
      a, b, u, v = 1, u, v, 1
   else:
      a, b, u, v = 1, u, 1, v

   if (a == 0) or (u == 0):
      s = "0"
   else:
      if sinalp < 0:
         s = "-"
      elif leftplus:
         s = "+"
      else:
         s = ""

      if (a == 1) and (b == 1):
         s = s + "1"
      elif a != 1:
         s = s + str(a)
         if b != 1:
           s = s + "*"

      if b != 1:
         s = s + "sqrt(" + str(b) + ")"

      if (u != 1) or (v != 1):
         s = s + "/"

      if u != 1:
         if v != 1:
            s = s + "("
         s = s + str(u)
         if v != 1:
            s = s + "*"

      if v != 1:
         s = s + "sqrt(" + str(v) + ")"
         if u != 1:
            s = s + ")"

   return s, sinalp * a, b, u, v

def nextPrime(s):
   if s == 2:
      return 3

   s = s + 2
   if s <= 7:
      return s

   while (True):
      if isPrime(s):
         return s
      s = s + 2

def isPrime(s):
   d = s % 2
   if d == 0:
      return False

   primo = 3
   while (True):
      if primo * primo > s:
         return True
      d = s % primo
      if d == 0:
         return False
      else:
         primo = primo + 2

def sgn(x):
   if x > 0:
      return 1
   elif x < 0:
      return -1
   return 0

def imprimir(item, tau, argumento, k, p, pp, sqalfa, alfa, beta, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw):
   if mp.fabs(c - my_round(c)) < 1e-9:
      c = my_int(c)
   else:
      c = my_str(3*c) + "/3"

   if mp.fabs(bb - my_round(bb)) < 1e-9:
      if mp.fabs(sqalfa - my_round(sqalfa)) < 1e-9:
         if tau > 0:
            print(item, "insert into trisection values ('", argumento, "*pi/180',", quoted(k), ",", quoted(p), ", 'arctan(", sqalfa, "/", beta,
               ")', '", iota, "/", gamma, "^", pp, "', '", sqalfa, "/", beta, "',", quoted(my_int(aa)), ",", quoted(my_int(bb)), ",", quoted(round(rew, 10)), ",", quoted(round(imw, 10)), ",", quoted(my_int(a)), ", 'sqrt(", b2, ")', '", c, "',", quoted(my_int(d)), ",", quoted(round(m, 10)), ",", quoted(round(v, 10)), ");");
         else:
            print(item, "insert into trisection values ('", argumento, "*pi/180',", quoted(k), ",", quoted(p), ", '2*pi-arctan(", sqalfa, "/", beta,
               ")', '", iota, "/", gamma, "^", pp, "', '", sqalfa, "/", beta, "',", quoted(my_int(aa)), ",", quoted(my_int(bb)), ",", quoted(round(rew, 10)), ",", quoted(round(imw, 10)), ",", quoted(my_int(a)), ", 'sqrt(", b2, ")', '", c, "',", quoted(my_int(d)), ",", quoted(round(m, 10)), ",", quoted(round(v, 10)), ");");
      else:
         if tau > 0:
            print(item, "insert into trisection values ('", argumento, "*pi/180',", quoted(k), ",", quoted(p), ", 'arctan(sqrt(", alfa, ")/", beta,
               ")', '", iota, "/", gamma, "^", pp, "', 'sqrt(", alfa, ")/", beta, "',", quoted(my_int(aa)), ",", quoted(my_int(bb)), ",", quoted(round(rew, 10)), ",", quoted(round(imw, 10)), ",", quoted(my_int(a)), ", 'sqrt(", b2, ")', '", c, "',", quoted(my_int(d)), ",", quoted(round(m, 10)), ",", quoted(round(v, 10)), ");");
         else:
            print(item, "insert into trisection values ('", argumento, "*pi/180',", quoted(k), ",", quoted(p), ", '2*pi-arctan(sqrt(", alfa, ")/", beta,
               ")', '", iota, "/", gamma, "^", pp, "', 'sqrt(", alfa, ")/", beta, "',", quoted(my_int(aa)), ",", quoted(my_int(bb)), ",", quoted(round(rew, 10)), ",", quoted(round(imw, 10)), ",", quoted(my_int(a)), ", 'sqrt(", b2, ")', '", c, "',", quoted(my_int(d)), ",", quoted(round(m, 10)), ",", quoted(round(v, 10)), ");");
   else:
      if mp.fabs(sqalfa - my_round(sqalfa)) < 1e-9:
         if tau > 0:
            print(item, "insert into trisection values ('", argumento, "*pi/180',", quoted(k), ",", quoted(p), ", 'arctan(", sqalfa, "/", beta,
               ")', '", iota, "/", gamma, "^", pp, "', '", sqalfa, "/", beta, "',", quoted(my_int(aa)), ", 'sqrt(", my_int(bb2), ")',", quoted(round(rew, 10)), ",", quoted(round(imw, 10)), ",", quoted(my_int(a)), ", 'sqrt(", b2, ")', '", c, "',", quoted(my_int(d)), ",", quoted(round(m, 10)), ",", quoted(round(v, 10)), ");");
         else:
            print(item, "insert into trisection values ('", argumento, "*pi/180',", quoted(k), ",", quoted(p), ", '2*pi-arctan(", sqalfa, "/", beta,
               ")', '", iota, "/", gamma, "^", pp, "', '", sqalfa, "/", beta, "',", quoted(my_int(aa)), ", 'sqrt(", my_int(bb2), ")',", quoted(round(rew, 10)), ",", quoted(round(imw, 10)), ",", quoted(my_int(a)), ", 'sqrt(", b2, ")', '", c, "',", quoted(my_int(d)), ",", quoted(round(m, 10)), ",", quoted(round(v, 10)), ");");
      else:
         if tau > 0:
            print(item, "insert into trisection values ('", argumento, "*pi/180',", quoted(k), ",", quoted(p), ", 'arctan(sqrt(", alfa, ")/", beta,
               ")', '", iota, "/", gamma, "^", pp, "', 'sqrt(", alfa, ")/", beta, "',", quoted(my_int(aa)), ", 'sqrt(", my_int(bb2), ")',", quoted(round(rew, 10)), ",", quoted(round(imw, 10)), ",", quoted(my_int(a)), ", 'sqrt(", b2, ")', '", c, "',", quoted(my_int(d)), ",", quoted(round(m, 10)), ",", quoted(round(v, 10)), ");");
         else:
            print(item, "insert into trisection values ('", argumento, "*pi/180',", quoted(k), ",", quoted(p), ", '2*pi-arctan(sqrt(", alfa, ")/", beta,
               ")', '", iota, "/", gamma, "^", pp, "', 'sqrt(", alfa, ")/", beta, "',", quoted(my_int(aa)), ", 'sqrt(", my_int(bb2), ")',", quoted(round(rew, 10)), ",", quoted(round(imw, 10)), ",", quoted(my_int(a)), ", 'sqrt(", b2, ")', '", c, "',", quoted(my_int(d)), ",", quoted(round(m, 10)), ",", quoted(round(v, 10)), ");");
   return

def imprimir2(item, tau, argumento, k, p, pp, sqalfa, alfa, beta, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw):
   print("update trisection set c =", quoted(my_int(c)), "where theta = '", argumento, "*pi/180' and k =", k, "and p =", quoted(p), ";")
   return

def imprimir3(item, tau, argumento, k, p, pp, sqalfa, alfa, beta, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw):
   if mp.fabs(rew - my_round(rew)) < 1e-9:
      if mp.fabs(imw - my_round(imw)) > 1e-9:
         X = power(imw, 2)
         X = "'sqrt(" + my_str(X) + ")'"
         print("update trisection set imw = ", X, " where theta = '", argumento, "*pi/180' and k =", k, "and p =", quoted(p), ";")
   return

def imprimir4(item, tau, argumento, k, p, pp, sqalfa, alfa, beta, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw):
   if mp.fabs(rew - my_round(rew)) > 1e-9:
      X = 2 * rew
      if mp.fabs(X - my_round(X)) < 1e-9:
         X = "'" + my_str(X) + "/2'"
         print("update trisection set rew = ", X, " where theta = '", argumento, "*pi/180' and k =", k, "and p =", quoted(p), ";")
   return

def quoted(x):
   return "'" + str(x) + "'"

def spaced(x):
   return " " + str(x)

def binom(n, p):
   if (mp.im(p) == 0) and (mp.re(n) < mp.re(p)):
      return 0
   result = 1
   for i in range(0, p):
      result = result * (n - i) / (i + 1)
   return result

def power(x, y):
   if mp.fabs(x) < 1e-9:
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

def my_str(x):
   y = int(my_round(x))
   return str(y)

def signed_str(x):
   y = int(my_round(x))
   if y > 0:
      return "+" + str(y)
   return str(y)

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

def gcd_vec(v, n):
   result = gcd(my_int(v[0]), my_int(v[1]))
   if result == 1:
      return 1
   for k in range(2, n):
      result = gcd(result, my_int(v[k]))
      if result == 1:
         return 1
   return result

def reduce_fraction(x, y):
   m = gcd(my_int(x), my_int(y))
   return my_int(x/m), my_int(y/m)

def round_rad(argumento, p):
   return round_deg(argumento/mp.pi() * 180, p)

def round_deg(argumento, p, lista):
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
      return lista
   if comentar:
      print("b = ", b)
   for k in range(0, p):
      m = mp.tan(theta/p + k * 2* mp.pi() /p)
      if comentar:
         print("m = ", m)
      rew = (power(m, 2) - a)/2
      tmp = rew * 2/b
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
         cc = my_int(power(b, 2)/4)
         # print(aa, "^2 + ", bb, "^2 = ", cc, "^", p)
         aa2 = power(aa, 2)
         bb2 = power(bb, 2)
         f = my_round(aa2)
         g = my_round(bb2)
         h = my_round(power(cc, p))
         dif = mp.fabs(f + g - h)
         if dif < 1e-9:
            # print(my_int(f), "+", my_int(g), "=", cc, "^", p)
            angle = argumento + k * 360
            b2 = my_round(power(b, 2))
            threea = my_round(3*a)
            if (mp.fabs(m) < 1e50) and (b2 < 1e50):
               if mp.fabs(h) < 1e-9:
                  dif = 100
               else:
                  dif = mp.fabs(mp.cos (p * mp.acos( (power(mp.tan (angle/p * mp.pi()/180), 2) - a
                                    )/b
                                  )
                            )) - mp.sqrt(f/h)
               if mp.fabs(dif) < 1e-9:
                  if comentar:
                     if dif != 0:
                        print("debug precision = 1E", my_int(log10(mp.fabs(dif))))
                     else:
                        print("debug precision = 0")
                  alfa, beta = reduce_fraction(g, f)
                  gamma = power(alfa + beta, 1/p)
                  if mp.fabs(gamma - my_round(gamma)) > 1e-9:
                     alfa, beta, gamma = my_int(g), my_int(f), h
                     gamma = my_int(power(gamma, 1/p))
                  else:
                     gamma = my_int(gamma)
                  sqalfa = mp.sqrt(alfa)
                  imw = mp.sqrt(b2/4 - power(rew, 2))
                  delta, epsilon = reduce_fraction(angle, p)
                  zeta = mp.sqrt(beta)
                  pp = p/2
                  BETA = beta
                  iota = BETA
                  if mp.fabs(pp - my_round(pp)) < 1e-9:
                     pp = my_int(pp)
                  if mp.sign(aa) > 0:
                     if mp.fabs(b - my_round(b)) < 1e-9:
                        if mp.fabs(zeta - my_round(zeta)) < 1e-9:
                           beta = my_int(zeta)
                           BETA = beta
                           iota = BETA
                           if epsilon == 1:
                              if gamma == 1:
                                 if mp.fabs(a - my_round(a)) < 1e-9:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))-", beta)
                                    #imprimir(1, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 if mp.fabs(a - my_round(a)) < 1e-9:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))-", beta, "/", gamma, "^", pp)
                                    #imprimir(2, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                                 else:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/", int(b), "))-", beta, "/", gamma, "^", pp)
                                    #imprimir(3, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/", int(b), "))-", beta, "/", gamma, "^", pp)
                                 #testar(4, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/", int(b), "))-", beta, "/", gamma, "^", pp)
                                 #testar(5, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                        else:
                           BETA = "sqrt(" + str(beta) + ")"
                           iota = BETA
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))-sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(6, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/", int(b), "))-sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(7, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/", int(b), "))-sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(8, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/", int(b), "))-sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(9, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                     else:
                        if mp.fabs(zeta - my_round(zeta)) < 1e-9:
                           beta = int(zeta)
                           BETA = beta
                           iota = BETA
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))-", beta, "/", gamma, "^", pp)
                                 #imprimir(10, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))-", beta, "/", gamma, "^", pp)
                                 #imprimir(11, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))-", beta, "/", gamma, "^", pp)
                                 #imprimir(12, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))-", beta, "/", gamma, "^", pp)
                                 #imprimir(13, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                        else:
                           BETA = "sqrt(" + str(beta) + ")"
                           iota = BETA
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))-sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(14, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))-sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(15, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))-sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(16, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))-sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(17, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                  else:
                     if mp.fabs(b - my_round(b)) < 1e-9:
                        if mp.fabs(zeta - my_round(zeta)) < 1e-9:
                           beta = int(zeta)
                           BETA = str(beta)
                           iota = "-" + BETA
                           if epsilon == 1:
                              if gamma == 1:
                                 if mp.fabs(a - my_round(a)) < 1e-9:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))+", beta)
                                    #testar(18, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 if mp.fabs(a - my_round(a)) < 1e-9:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))+", beta, "/", gamma, "^", pp)
                                    #imprimir(19, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                                 else:
                                    print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/", int(b), "))+", beta, "/", gamma, "^", pp)
                                    #testar(20, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/", int(b), "))+", beta, "/", gamma, "^", pp)
                                 #testar(21, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/", int(b), "))+", beta, "/", gamma, "^", pp)
                                 #testar(22, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                        else:
                           BETA = "sqrt(" + str(beta) + ")"
                           iota = "-" + BETA
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/", int(b), "))+sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(23, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/", int(b), "))+sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(24, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/", int(b), "))+sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(25, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/", int(b), "))+sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(26, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                     else:
                        if mp.fabs(zeta - my_round(zeta)) < 1e-9:
                           beta = int(zeta)
                           BETA = str(beta)
                           iota = "-" + BETA
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))+", beta, "/", gamma, "^", pp)
                                 #imprimir(27, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))+", beta, "/", gamma, "^", pp)
                                 #imprimir(28, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))+", beta, "/", gamma, "^", pp)
                                 #imprimir(29, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))+", beta, "/", gamma, "^", pp)
                                 #imprimir(30, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                        else:
                           BETA = "sqrt(" + str(beta) + ")"
                           iota = "-" + BETA
                           if epsilon == 1:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))+sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(31, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))+sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(32, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                           else:
                              if mp.fabs(a - my_round(a)) < 1e-9:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", my_int(a), ")/sqrt(", int(b2), ")))+sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(33, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                              else:
                                 print("cos(", p, "* arccos((tan^2(", delta, "/", epsilon, "*pi/180)-", int(threea), "/3)/sqrt(", int(b2), ")))+sqrt(", beta, "/", gamma, "^", p, ")")
                                 #imprimir(34, tau, argumento, k, p, pp, sqalfa, alfa, BETA, gamma, iota, a, aa, b2, bb, bb2, c, d, m, v, rew, imw)
                  iterar(p, varphi, tau, alfa, power(beta, 2), 2 * rew, power(imw, 2), lista)
   return lista

def iterar(p, argz, tau, vn, vd, drew, sqimw, lista):
   if mp.fabs(vn - my_round(vn)) < 1e-9:
      if (mp.fabs(vd - my_round(vd)) < 1e-9) and (mp.fabs(vd) > 1e-9):
         if mp.fabs(drew - my_round(drew)) < 1e-9:
            if mp.fabs(sqimw - my_round(sqimw)) < 1e-9:
               while argz > 2 * mp.pi():
                  argz = argz - 2 * mp.pi()
               s = "Candidato =" + spaced(my_int(vn)) + spaced(my_int(vd)) + spaced(my_int(drew)) + spaced(my_int(sqimw)) + spaced(round(argz, 10))
               if not contains(lista, s):
                  lista.append(s)
                  print(s)
                  #(3) x = 1 => x = 2/11 => x = fraction
                  #          theta += pi => argz = 2*pi - argz
                  #(3) x = 1 => x = 11/2 => x = fraction
                  #          theta += pi => argz = 2*pi - argz => quaternary tree

                  theta = argz
                  if mp.fabs(p/2 - my_round(p/2)) < 1e-9:
                     fim = 2 # even
                  else:
                     fim = 1 # odd
                  for k in range(0, fim):
                     v = tau
                     avd = my_int((p - 1) * vd + p* vn)
                     vd = my_int(vd)
                     cvd = my_int((power(binom(p,2), 2) + 2 * binom(p,4)) * vd + 2 * p * binom(p,3) * vn)
                     dvdvd = my_int(binom(p,2) * power(avd, 2) - cvd * vd)
                     sbn, sbd = my_int(4 * dvdvd), my_int(vd * vd * p)
                     b = mp.sqrt(sbn/sbd)
                     if k < 1e-9:
                        mS, aa, bb, cc, dd = simplify(4* sqimw, drew, True, False, False, 1, 1)
                        m = (2* mp.sqrt(sqimw))/drew
                        rewA, rewB = my_int(4*sqimw*vd - avd*drew*drew), my_int(2*vd*drew*drew)
                     else:
                        mS, aa, bb, cc, dd = simplify(-drew, 4* sqimw, False, True, False, 1, 1)
                        m = -drew/(2* mp.sqrt(sqimw))
                        rewA = my_int(mp.fmul(mp.fmul(drew, drew), vd) - mp.fmul(mp.fmul(avd, sqimw), 4))
                        rewB = my_int(mp.fmul(mp.fmul(8, vd), sqimw))

                     rewS, aa, bb, cc, dd = simplify(rewA, rewB, False, False, False, 1, 1)
                     rew = rewA/rewB
                     imwA, imwB = sbn*rewB*rewB - 4*sbd*rewA*rewA, 4*sbd*rewB*rewB
                     imwS, aa, bb, cc, dd = simplify(imwA, 4*sbd, True, True, False, 1, mp.fabs(rewB))
                     # imw = mp.sqrt(imwA/imwB)
                     imw2 = imwA/imwB
                     # wN = rewA*sqrt(imwB) + j * rewB*sqrt(imwA)
                     # wD = rewB*sqrt(imwB)
                     # zN = power(wN, p)
                     wnS, aa, bb, cc, dd = simplify(imwB, 1, True, False, False, rewA, 1)
                     wnS, ee, ff, cc, dd = simplify(imwA, 1, True, False, False, rewB, 1)
                     # (a sqrt(2) + bi sqrt(3))^4 = c + di sqrt(6)
                     # (a sqrt(2) + bi sqrt(3))^5 = c sqrt(2) + di sqrt(3)
                     soma = 0
                     for index in range (0, p + 1):
                        half1 = my_int(mp.floor(index/2))
                        half2 = my_int(mp.floor((p - index)/2))
                        termo = binom(p, index) * power(aa, index) * power(ee*j, p - index) * power(bb, half1) * power(ff, half2)
                        soma = soma + termo
                     q = p/2
                     if mp.fabs(q - my_round(q)) < 1e-9:
                        q = my_int(q)
                     if fim == 2:
                        wnS, aa, ee, cc, dd = simplify(bb*ff, 1, True, False, False, mp.im(soma), 1)
                        rezS = (my_str(mp.re(soma)) + "/(" + str(rewB) + "^"
                                + str(p) + "*" + str(imwB) + "^" + str(q) + ")")
                        imzS = (wnS + "/(" + str(rewB) + "^"
                                + str(p) + "*" + str(imwB) + "^" + str(q) + ")")
                        #rez = re(soma) / (rewB^p * imwB^q)
                        #imz = im(soma)*sqrt(bb*ff) / (rewB^p * imwB^q)
                        #tanargz = im(soma)*sqrt(bb*ff) / re(soma)
                        vn, vd = im(soma)*sqrt(bb*ff), re(soma)
                        tanS, aa, bb, cc, dd = simplify(bb*ff, re(soma), True, False, False, im(soma), 1)
                        #r = (b/2)^p = 1/2^p * (sbn/sbd)^(p/2)
                        #*** cosargz = re(soma) * 2^p * sbd^(p/2)/ (rewB^p * imwB^q * sbn^(p/2))
                        cosS = (my_str(mp.re(soma)) + "*" + str(2) + "^" + str(p)
                                + "*" + str(sbd) + "^" + str(q) + "/(" + str(rewB) + "^"
                                + str(p) + "*" + str(imwB) + "^" + str(q) + "*" + str(sbn) + "^" + str(q) + ")")
                     else:
                        rezS, aa, bb, cc, dd = simplify(bb, 1, True, False, False, mp.re(soma), 1)
                        cosS = rezS
                        imzS, aa, bb, cc, dd = simplify(ff, 1, True, False, False, mp.im(soma), 1)
                        rezS = (rezS + "/(" + str(rewB) + "^"
                               + str(p) + "*" + str(imwB) + "^" + str(q) + ")")
                        imzS = (imzS + "/(" + str(rewB) + "^"
                               + str(p) + "*" + str(imwB) + "^" + str(q) + ")")
                        #rez = re(soma)*sqrt(bb) / (rewB^p * imwB^q)
                        #imz = im(soma)*sqrt(ff) / (rewB^p * imwB^q)
                        #tanargz = im(soma)*sqrt(ff) / [re(soma)*sqrt(bb)]
                        vn, vd = im(soma)*sqrt(ff), re(soma)*sqrt(bb)
                        tanS, aa, bb, cc, dd = simplify(ff, bb, True, True, False, im(soma), re(soma))
                        #r = (b/2)^p = 1/2^p * (sbn/sbd)^(p/2)
                        #*** cosargz = re(soma)*sqrt(bb) * 2^p * sbd^(p/2) / (rewB^p * imwB^q * sbn^(p/2))
                        cosS = (cosS + "*" + str(2) + "^" + str(p)
                                + "*" + str(sbd) + "^" + str(q) + "/(" + str(rewB) + "^"
                                + str(p) + "*" + str(imwB) + "^" + str(q) + "*" + str(sbn) + "^" + str(q) + ")")

                     argz = p * mp.acos(rew * 2/b)
                     tanargz = mp.tan(argz)
                     cosargz = mp.cos(argz)
                     if mp.re(cosargz) > 0:
                        argzS = "arctan(" + tanS + ")"
                        thetaS = argzS
                        if k == 1:
                           thetaS = argzS + " + pi/2"
                     else:
                        argzS = "2*pi - arctan(" + tanS + ")"
                        thetaS = argzS
                        if k == 1:
                           thetaS = "3*pi/2 - arctan(" + tanS + ")"

                     #else: neither k = 0, neither k = p/2, neither p = 2*k
                        #Y = mp.tan(k * mp.pi()/p)
                        #s1, aa, bb, cc, dd = simplify(4 * sqimw, 1, True, False, True)
                        #s2, aa, bb, cc, dd = simplify(-4 * sqimw, 1, True, False, True)
                        #mS = "(" + my_str(drew) + "*t" + s1 + ")/(" + my_str(drew) + s2 + "*t)"
                        #mA, mB, mC, mD = Y*drew, my_int(4 * sqimw), my_int(drew), 4*Y*Y * sqimw
                        #s1, mE, mF, cc, dd = simplify(sqimw, 1, True, False, False)
                        #m = (mA + mp.sqrt(mB))/(mC - mp.sqrt(mD))
                        #rewA = (4 * sqimw*vd - drew*drew*avd)
                        #rewB = mF
                        #rewC = (4*drew*vd*mE)
                        #rewD = (drew*drew*vd - 4 * sqimw*avd)
                        #rewE = (2*drew*drew*vd)
                        #rewF = (- 8*drew*vd*mE)
                        #rewG = (8*sqimw*vd)
                        #gr = gcd_vec([rewA, rewC, rewD, rewE, rewF, rewG], 6)
                        #print("gr =", gr)
                        #rewA, rewC, rewD, rewE, rewF, rewG = rewA/gr, rewC/gr, rewD/gr, rewE/gr, rewF/gr, rewG/gr
                        #rewP = rewA + Y*mp.sqrt(rewB)*rewC + mp.fabs(Y)*mp.sqrt(rewB)*rewC + Y*Y*rewD
                        #rewQ = rewE + mp.fabs(Y)*mp.sqrt(rewB)*rewF + Y*Y*rewG
                        #rew = rewP/rewQ
                        #s1, aa, bb, cc, dd = simplify(rewB*rewC*rewC, 1, True, False, True)
                        #s2, aa, bb, cc, dd = simplify(rewB*rewF*rewF, 1, True, False, True)
                        #rewS = ("(" + my_str(rewA) + s1 + "*t" + s1 + "*|t|" + signed_str(rewD)
                        #        + "*t^2)/(" + my_str(rewE) + s2 + "*|t|" + signed_str(rewG) + "*t^2)")

                        #ALPHA = sbn*rewE**2 - 4*sbd*rewA**2
                        #         - 8*sbd**rewA*Y*mp.sqrt(rewB)*rewC
                        #         + Y**2*(sbn*rewB*rewF**2+ 2*sbn*rewE*rewG - 8*sbd**rewB*rewC**2 - 8*sbd*rewA*rewD)
                        #         + Y**3*(- 8*sbd*mp.sqrt(rewB)*rewC*rewD)
                        #         + Y**4*(sbn*rewG**2 - 4*sbd*rewD**2)
                        #         + mp.fabs(Y)*(2*sbn*rewE*mp.sqrt(rewB)*rewF - 8*sbd**rewA*mp.sqrt(rewB)*rewC
                        #                     - Y*4*sbd*2*mp.sqrt(rewB)*rewC*mp.sqrt(rewB)*rewC
                        #                     + Y*Y*(2*sbn*mp.sqrt(rewB)*rewF*rewG - 8*sbd*mp.sqrt(rewB)*rewC*rewD))

                        #imw = 1/mp.sqrt(4*sbd) * mp.sqrt(ALPHA)/mp.abs(rewQ)
                        #Looking at this expression, I quit. I would need tan(2*pi/p) exactly.

                        #imw = mp.sqrt(sbn/(4*sbd) - power(rew, 2))
                        #imwS = imw
                        #w = (a + b*j)/c
                        #z = power(w, p)
                        #rez = mp.re(z)
                        #imz = mp.im(z)
                        #tanargz = imz/rez
                        #r = power(b/2, p)
                        #cosargz = rez/r
                        #if cosargz > 0 then argz = arctan(tanargz) else argz = 2*pi - arctan(tanargz)
                     #print("theta =", theta)
                     #print("K =", my_int(k * p/2))
                     #print("P =", p)
                     #print("argz =", argzS)
                     #print("cosargz =", cosS)
                     #print("tanargz =", tanS)
                     #print("rez =", rezS)
                     #print("imz =", imzS)
                     #print("rew =", rewS)
                     #print("imw =", imwS)
                     aS, aa, bb, cc, dd = simplify(avd, vd, False, False, False, 1, 1)
                     #print("A =", aS)
                     bS, aa, bb, cc, dd = simplify(sbn, sbd, True, True, False, 1, 1)
                     #print("B =", bS)
                     cS, aa, bb, cc, dd = simplify(cvd, vd, False, False, False, 1, 1)
                     #print("C =", cS)
                     dS, aa, bb, cc, dd = simplify(dvdvd, vd*vd, False, False, False, 1, 1)
                     #print("D =", dS) # length(D) too long!
                     #print("M =", mS)
                     #print("V =", v)
                     print("insert into trisection values (", quoted(thetaS), ",\n", quoted(my_int(k * p/2)),
                          ",\n", quoted(p), ",\n", quoted(argzS), ",\n", quoted(cosS), ",\n", quoted(tanS),
                          ",\n", quoted(rezS), ",\n", quoted(imzS), ",\n", quoted(rewS),
                          ",\n", quoted(imwS), ",\n", quoted(aS), ",\n", quoted(bS),
                          ",\n", quoted(cS), ", '', ", quoted(mS),
                          ",\n", quoted(round(v, 10)), ");")
                     iterar(p, argz, tanargz, vn, vd, 2 * rew, imw2, lista)

                     # cos(p * arccos((m^2-a)/b)) = cos Arg z
                     # cos( 4 * arccos((67/9-2070975/14161)/((2888 sqrt(3056899))/14161))) = -456091835600233840361/15979994185801738856562

   return lista

def contains(lista, x):
   for cadaUm in lista:
      if cadaUm == x:
         return True
   return False

#create table TRISECTION (
#  theta character varying(255) not null,   -- '45*pi/180'
#  K integer not null,                      -- '1'
#  P character varying(255) not null,       -- '3'
#  argz character varying(400) not null,    -- 'arctan(2/11)'
#  cosargz character varying(255) not null, -- '11/5^1.5'
#  tanargz character varying(400) not null, -- '2/11'
#  rez character varying(255) not null,     -- '88'
#  imz character varying(255) not null,     -- '16'
#  rew character varying(255) not null,     -- '1+2*sqrt(3)' = (m^2 - a)/2
#  imw character varying(255) not null,     -- '2-sqrt(3)' = sqrt(b^2/4 - rew^2)
#  A character varying(255) not null,       -- '5' = p - 1 + pv^2
#  B character varying(255) not null,       -- '4*sqrt(5)' = 2 * sqrt(d/p)
#  C character varying(255) not null,       -- '15' = (p,2)^2 + 2*(p,4) + 2*p*(p,3)*v^2
#  D character varying(255) not null,       -- '60' = (p,2)*a^2 - c
#  M character varying(255) not null,       -- '2+sqrt(3)' = tan 75\degree = tan 45+30
#  V character varying(255) not null,       -- '1'
#  primary key (theta, K, P));

comentar = False
lista = list()
#for ratio in range (3, 30):
#   print("py trisection_iterar_py.txt", ratio, ">", ratio, ".txt")
ratio = my_int(sys.argv[1])
mp.dps = 1300 * ratio
for third in range(1, 121):
   round_deg(3*third, ratio, lista)
