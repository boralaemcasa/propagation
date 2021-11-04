# Your Spirit Guide is at: https://drive.google.com/file/d/1hDxdYpy1mXMhKBnLHHCVO9n-lTJ2_v8j/view?usp=sharing
#
# starting with n = 5, we want induction, then for all natural n.
#
# Now, let's follow the release with appendix from sci hub
#
# [http://www.emba.uvm.edu/~ddummit/quintics/quintics.html]

from mpmath import *

def discriminant(a, b, c, d, e):
   return (power(a, 5) *power(e, 3)                 -192 *power(a, 4) *b *d *power(e, 2)
           -128 *power(a, 4) *power(c, 2) *power(e, 2)     +144 *power(a, 4) *c *power(d, 2) *e
           -27 *power(a, 4) *power(d, 4)            +144 *power(a, 3) *power(b, 2) *c *power(e, 2)
           -6 *power(a, 3) *power(b, 2) *power(d, 2) *e    -80 *power(a, 3) *b *power(c, 2) *d *e
           +18 *power(a, 3) *b *c *power(d, 3)      -1600 *power(a, 3) *b *power(e, 3)
           +16 *power(a, 3) *power(c, 4) *e         -4 *power(a, 3) *power(c, 3) *power(d, 2)
           +160 *power(a, 3) *c *d*power(e, 2)      -36 *power(a, 3) *power(d, 3) *e
           -27 *power(a, 2) *power(b, 4) *power(e, 2)      +18 *power(a, 2) *power(b, 3) *c *d *e
           -4 *power(a, 2) *power(b, 3) *power(d, 3)       -4 *power(a, 2) *power(b, 2) *power(c, 3) *e
           +power(a, 2) *power(b, 2) *power(c, 2) *power(d, 2)    +1020 *power(a, 2) *power(b, 2) *d *power(e, 2)
           +560 *power(a, 2) *b *power(c, 2) *power(e, 2)  -746 *power(a, 2) *b *c *power(d, 2) *e
           +144 *power(a, 2) *b *power(d, 4)        +24 *power(a, 2) *power(c, 3) *d *e
           -6 *power(a, 2) *power(c, 2) *power(d, 3)       +2000 *power(a, 2) *c *power(e, 3)
           -50 *power(a, 2) *power(d, 2) *power(e, 2)      -630 *a *power(b, 3) *c *power(e, 2)
           +24 *a *power(b, 3) *power(d, 2) *e      +356 *a *power(b, 2) *power(c, 2) *d *e
           -80 *a *power(b, 2) *c*power(d, 3)       +2250 *a *power(b, 2) *power(e, 3)
           -72 *a *b *power(c, 4) *e         +18 *a *b *power(c, 3) *power(d, 2)
           -2050 *a *b *c *d *power(e, 2)    +160 *a *b *power(d, 3) *e
           -900 *a *power(c, 3) *power(e, 2)        +1020*a *power(c, 2) *power(d, 2) *e
           -192 *a *c *power(d, 4)           -2500 *a *d *power(e, 3)
           +108 *power(b, 5) *power(e, 2)           -72 *power(b, 4) *c *d *e
           +16 *power(b, 4) *power(d, 3)            +16 *power(b, 3) *power(c, 3) *e
           -4 *power(b, 3) *power(c, 2)*power(d, 2)        -900 *power(b, 3) *d *power(e, 2)
           +825 *power(b, 2) *power(c, 2) *power(e, 2)     +560 *power(b, 2) *c *power(d, 2) *e
           -128 *power(b, 2) *power(d, 4)           -630 *b *power(c, 3) *d *e
           +144 *b *power(c, 2) *power(d, 3)        -3750 *b*c *power(e, 3)
           +2000 *b *power(d, 2) *power(e, 2)       +108 *power(c, 5) *e
           -27 *power(c, 4) *power(d, 2)            +2250 *power(c, 2) *d *power(e, 2)
           -1600 *c *power(d, 3) *e          +256 *power(d, 5)           +3125 *power(e, 4)) # from math.stack.exchange


def power(x, y):
   if (y / 2 == mp.floor(y / 2)) and (mp.im(x) == 0) and (mp.re(x) < 0):
      return mp.exp(y * mp.ln(-x))
   else:
      return mp.exp(y * mp.ln(x))

def eq_solve(A5, A4, A3, A2, A1, A0):    # A5 x**5 + A4 x**4 + A3 x**3 + A2 x**2 + A1 x + A0 = 0
   if A5 == 0:
      print("Degenerated")
      return False

   if A4 != 0:
      a, b, c, d, e, f = A5, A4, A3, A2, A1, A0
      translation = -b/(5*a) # x = y - b/(5a) from [https://en.wikipedia.org/wiki/Quintic_function]
      p = (5*a*c - 2*power(b,2))/(5*power(a,2))
      q = (25*power(a,2)*d - 15*a*b*c + 4*power(b,3))/(25*power(a,3))
      r = (125*power(a,3)*e - 50*power(a,2)*b*d + 15*a*power(b,2)*c - 3*power(b,4))/(125*power(a,4))
      s = (3125*power(a,4)*f - 625*power(a,3)*b*e + 125*power(a,2)*power(b,2)*d - 25*a*power(b,3)*c + 4*power(b,5))/(3125*power(a,5))
      print("p =", p)
      print("q =", q)
      print("r =", r)
      print("s =", s)
   else:
      translation = 0
      p, q, r, s = A3, A2, A1, A0

   # f20(x) = x**6 + b5 x**5 + ... + b0
   b5 = my_int(8*r)
   b4 = my_int(2*p*power(q, 2) - 6*power(p, 2)*r + 40*power(r, 2) - 50*q*s)
   b3 = my_int(-2*power(q, 4) + 21*p*power(q, 2)*r - 40*power(p, 2)*power(r, 2) + 160*power(r, 3) - 15*power(p, 2)*q*s - 400*q*r*s + 125*p*power(s, 2))
   b2 = my_int(power(p, 2)*power(q, 4) - 6*power(p, 3)*power(q, 2)*r - 8*power(q, 4)*r + 9*power(p, 4)*power(r, 2) + 76*p*power(q, 2)*power(r, 2) - 136*power(p, 2)*power(r, 3) + 400*power(r, 4)
         - 50*p*power(q, 3)*s + 90*power(p, 2)*q*r*s - 1400*q*power(r, 2)*s + 625*power(q, 2)*power(s, 2) + 500*p*r*power(s, 2))
   b1 = my_int(-2*p*power(q, 6) + 19*power(p, 2)*power(q, 4)*r - 51*power(p, 3)*power(q, 2)*power(r, 2) + 3*power(q, 4)*power(r, 2) + 32*power(p, 4)*power(r, 3) + 76*p*power(q, 2)*power(r, 3)
         - 256*power(p, 2)*power(r, 4) + 512*power(r, 5) - 31*power(p, 3)*power(q, 3)*s - 58*power(q, 5)*s + 117*power(p, 4)*q*r*s + 105*p*power(q, 3)*r*s
         + 260*power(p, 2)*q*power(r, 2)*s - 2400*q*power(r, 3)*s - 108*power(p, 5)*power(s, 2) - 325*power(p, 2)*power(q, 2)*power(s, 2)
         + 525*power(p, 3)*r*power(s, 2) + 2750*power(q, 2)*r*power(s, 2) - 500*p*power(r, 2)*power(s, 2) + 625*p*q*power(s, 3) - 3125*power(s, 4))
   b0 = my_int(power(q, 8) - 13*p*power(q, 6)*r + power(p, 5)*power(q, 2)*power(r, 2) + 65*power(p, 2)*power(q, 4)*power(r, 2) - 4*power(p, 6)*power(r, 3) - 128*power(p, 3)*power(q, 2)*power(r, 3)
         + 17*power(q, 4)*power(r, 3) + 48*power(p, 4)*power(r, 4) - 16*p*power(q, 2)*power(r, 4) - 192*power(p, 2)*power(r, 5) + 256*power(r, 6) - 4*power(p, 5)*power(q, 3)*s
         - 12*power(p, 2)*power(q, 5)*s + 18*power(p, 6)*q*r*s + 12*power(p, 3)*power(q, 3)*r*s - 124*power(q, 5)*r*s + 196*power(p, 4)*q*power(r, 2)*s
         + 590*p*power(q, 3)*power(r, 2)*s - 160*power(p, 2)*q*power(r, 3)*s - 1600*q*power(r, 4)*s - 27*power(p, 7)*power(s, 2) - 150*power(p, 4)*power(q, 2)*power(s, 2)
         - 125*p*power(q, 4)*power(s, 2) - 99*power(p, 5)*r*power(s, 2) - 725*power(p, 2)*power(q, 2)*r*power(s, 2) + 1200*power(p, 3)*power(r, 2)*power(s, 2)
         + 3250*power(q, 2)*power(r, 2)*power(s, 2) - 2000*p*power(r, 3)*power(s, 2) - 1250*p*q*r*power(s, 3) + 3125*power(p, 2)*power(s, 4) - 9375*r*power(s, 4))
   print("x**6 +", b5, "x**5 +", b4, "x**4 +", b3, "x**3 +", b2, "x**2 +", b1, "x +", b0, "= 0")
   L, flag, root = divisors(b0, b1, b2, b3, b4, b5)
   print(flag, root, L)
   if not flag:
      return False
   D = discriminant(0, p, q, r, s)
   delta = mp.sqrt(D)
   print("delta =", delta)

   F = (4 *power(p, 6) *power(q, 6)  +  59 *power(p, 3) *power(q, 8)  +  216 *power(q, 10)  -
        36 *power(p, 7) *power(q, 4) *r  -  623 *power(p, 4) *power(q, 6) *r  -
        2610 *p *power(q, 8) *r  +  81 *power(p, 8) *power(q, 2) *power(r, 2)  +  2015 *power(p, 5) *power(q, 4) *power(r, 2)  +
        10825 *power(p, 2) *power(q, 6) *power(r, 2)  -    1800 *power(p, 6) *power(q, 2) *power(r, 3)  -
        17500 *power(p, 3) *power(q, 4) *power(r, 3)  +  625 *power(q, 6) *power(r, 3)  +
        10000 *power(p, 4) *power(q, 2) *power(r, 4)  +    108 *power(p, 8) *power(q, 3) *s  +
        1584 *power(p, 5) *power(q, 5) *s  +  5700 *power(p, 2) *power(q, 7) *s  -  486 *power(p, 9) *q *r *s  -
        9720 *power(p, 6) *power(q, 3) *r *s  -  45050 *power(p, 3) *power(q, 5) *r *s  -
        9000 *power(q, 7) *r *s  +    10800 *power(p, 7) *q *power(r, 2) *s  +
        92500 *power(p, 4) *power(q, 3) *power(r, 2) *s  +  32500 *p *power(q, 5) *power(r, 2) *s  -
        60000 *power(p, 5) *q *power(r, 3) *s  -  50000 *power(p, 2) *power(q, 3) *power(r, 3) *s  +
        729 *power(p, 10) *power(s, 2)  +    12150 *power(p, 7) *power(q, 2) *power(s, 2)  +
        60000 *power(p, 4) *power(q, 4) *power(s, 2)  +  93750 *p *power(q, 6) *power(s, 2)  -
        18225 *power(p, 8) *r *power(s, 2)  -  175500 *power(p, 5) *power(q, 2) *r *power(s, 2)  -
        478125 *power(p, 2) *power(q, 4) *r *power(s, 2)  +    135000 *power(p, 6) *power(r, 2) *power(s, 2)  +
        850000 *power(p, 3) *power(q, 2) *power(r, 2) *power(s, 2)  +  15625 *power(q, 4) *power(r, 2) *power(s, 2)  -
        250000 *power(p, 4) *power(r, 3) *power(s, 2)  +  225000 *power(p, 3) *power(q, 3) *power(s, 3)  +
        175000 *power(q, 5) *power(s, 3)  -    1012500 *power(p, 4) *q *r *power(s, 3)  -
        1187500 *p *power(q, 3) *r *power(s, 3)  +  1250000 *power(p, 2) *q *power(r, 2) *power(s, 3)  +
        928125 *power(p, 5) *power(s, 4)  +  1875000 *power(p, 2) *power(q, 2) *power(s, 4)  -
        2812500 *power(p, 3) *r *power(s, 4)  -   390625 *power(q, 2) *r *power(s, 4)  -
        9765625 *power(s, 6))

   b10 = -(100 *power(p, 7) *power(q, 7)  +  2175 *power(p, 4) *power(q, 9)  +  10500 *p *power(q, 11)  -
        1100 *power(p, 8) *power(q, 5) *r  -    27975 *power(p, 5) *power(q, 7) *r  -
        152950 *power(p, 2) *power(q, 9) *r  +  4125 *power(p, 9) *power(q, 3) *power(r, 2)  +
        128875 *power(p, 6) *power(q, 5) *power(r, 2)  +  830525 *power(p, 3) *power(q, 7) *power(r, 2)  -
        59450 *power(q, 9) *power(r, 2)  -  5400 *power(p, 10) *q *power(r, 3)  -
        243800 *power(p, 7) *power(q, 3) *power(r, 3)  -  2082650 *power(p, 4) *power(q, 5) *power(r, 3)  +
        333925 *p *power(q, 7) *power(r, 3)  +    139200 *power(p, 8) *q *power(r, 4)  +
        2406000 *power(p, 5) *power(q, 3) *power(r, 4)  +  122600 *power(p, 2) *power(q, 5) *power(r, 4)  -
        1254400 *power(p, 6) *q *power(r, 5)  -  3776000 *power(p, 3) *power(q, 3) *power(r, 5)  -
        1832000 *power(q, 5) *power(r, 5)  +    4736000 *power(p, 4) *q *power(r, 6)  +
        6720000 *p *power(q, 3) *power(r, 6)  -  6400000 *power(p, 2) *q *power(r, 7)  +
        900 *power(p, 9) *power(q, 4) *s  +  37400 *power(p, 6) *power(q, 6) *s  +
        281625 *power(p, 3) *power(q, 8) *s  +  435000 *power(q, 10) *s  -
        6750 *power(p, 10) *power(q, 2) *r *s  -  322300 *power(p, 7) *power(q, 4) *r *s  -
        2718575 *power(p, 4) *power(q, 6) *r *s  -    4214250 *p *power(q, 8) *r *s  +
        16200 *power(p, 11) *power(r, 2) *s  +  859275 *power(p, 8) *power(q, 2) *power(r, 2) *s  +
        8925475 *power(p, 5) *power(q, 4) *power(r, 2) *s  +  14427875 *power(p, 2) *power(q, 6) *power(r, 2) *s  -
        453600 *power(p, 9) *power(r, 3) *s  -    10038400 *power(p, 6) *power(q, 2) *power(r, 3) *s  -
        17397500 *power(p, 3) *power(q, 4) *power(r, 3) *s  +  11333125 *power(q, 6) *power(r, 3) *s  +
        4451200 *power(p, 7) *power(r, 4) *s  +  15850000 *power(p, 4) *power(q, 2) *power(r, 4) *s  -
        34000000 *p *power(q, 4) *power(r, 4) *s  -    17984000 *power(p, 5) *power(r, 5) *s  +
        10000000 *power(p, 2) *power(q, 2) *power(r, 5) *s  +  25600000 *power(p, 3) *power(r, 6) *s  +
        8000000 *power(q, 2) *power(r, 6) *s  -  6075 *power(p, 11) *q *power(s, 2)  +
        83250 *power(p, 8) *power(q, 3) *power(s, 2)  +    1282500 *power(p, 5) *power(q, 5) *power(s, 2)  +
        2862500 *power(p, 2) *power(q, 7) *power(s, 2)  -  724275 *power(p, 9) *q *r *power(s, 2)  -
        9807250 *power(p, 6) *power(q, 3) *r *power(s, 2)  -  28374375 *power(p, 3) *power(q, 5) *r *power(s, 2)  -
        22212500 *power(q, 7) *r *power(s, 2)  +   8982000 *power(p, 7) *q *power(r, 2) *power(s, 2)  +
        39600000 *power(p, 4) *power(q, 3) *power(r, 2) *power(s, 2)  +
        61746875 *p *power(q, 5) *power(r, 2) *power(s, 2)  +  1010000 *power(p, 5) *q *power(r, 3) *power(s, 2)  +
        1000000 *power(p, 2) *power(q, 3) *power(r, 3) *power(s, 2)  -  78000000 *power(p, 3) *q *power(r, 4) *power(s, 2)  -
        30000000 *power(q, 3) *power(r, 4) *power(s, 2)  -  80000000 *p *q *power(r, 5) *power(s, 2)  +
        759375 *power(p, 10) *power(s, 3)  +   9787500 *power(p, 7) *power(q, 2) *power(s, 3)  +
        39062500 *power(p, 4) *power(q, 4) *power(s, 3)  +  52343750 *p *power(q, 6) *power(s, 3)  -
        12301875 *power(p, 8) *r *power(s, 3)  -  98175000 *power(p, 5) *power(q, 2) *r *power(s, 3)  -
        225078125 *power(p, 2) *power(q, 4) *r *power(s, 3)  +   54900000 *power(p, 6) *power(r, 2) *power(s, 3)  +
        310000000 *power(p, 3) *power(q, 2) *power(r, 2) *power(s, 3)  +  7890625 *power(q, 4) *power(r, 2) *power(s, 3)  -
        51250000 *power(p, 4) *power(r, 3) *power(s, 3)  +  420000000 *p *power(q, 2) *power(r, 3) *power(s, 3)  -
        110000000 *power(p, 2) *power(r, 4) *power(s, 3)  +    200000000 *power(r, 5) *power(s, 3)  -
        2109375 *power(p, 6) *q *power(s, 4)  +  21093750 *power(p, 3) *power(q, 3) *power(s, 4)  +
        89843750 *power(q, 5) *power(s, 4)  -  182343750 *power(p, 4) *q *r *power(s, 4)  -
        733203125 *p *power(q, 3) *r *power(s, 4)  +    196875000 *power(p, 2) *q *power(r, 2) *power(s, 4)  -
        1125000000 *q *power(r, 3) *power(s, 4)  +  158203125 *power(p, 5) *power(s, 5)  +
        566406250 *power(p, 2) *power(q, 2) *power(s, 5)  -  101562500 *power(p, 3) *r *power(s, 5)  +
        1669921875 *power(q, 2) *r *power(s, 5)  -    1250000000 *p *power(r, 2) *power(s, 5)  +
        1220703125 *p *q *power(s, 6)  -  6103515625 *power(s, 7))

   b11 = -(-1000 *power(p, 5) *power(q, 7)  -  7250 *power(p, 2) *power(q, 9)  +  10800 *power(p, 6) *power(q, 5) *r  +
        96900 *power(p, 3) *power(q, 7) *r  +   52500 *power(q, 9) *r  -
        37400 *power(p, 7) *power(q, 3) *power(r, 2)  -  470850 *power(p, 4) *power(q, 5) *power(r, 2)  -
        640600 *p *power(q, 7) *power(r, 2)  +    39600 *power(p, 8) *q *power(r, 3)  +
        983600 *power(p, 5) *power(q, 3) *power(r, 3)  +  2848100 *power(p, 2) *power(q, 5) *power(r, 3)  -
        814400 *power(p, 6) *q *power(r, 4)  -  6076000 *power(p, 3) *power(q, 3) *power(r, 4)  -
        2308000 *power(q, 5) *power(r, 4)  +    5024000 *power(p, 4) *q *power(r, 5)  +
        9680000 *p *power(q, 3) *power(r, 5)  -  9600000 *power(p, 2) *q *power(r, 6)  -
        13800 *power(p, 7) *power(q, 4) *s  -  94650 *power(p, 4) *power(q, 6) *s  +
        26500 *p *power(q, 8) *s  +  86400 *power(p, 8) *power(q, 2) *r *s  +
        816500 *power(p, 5) *power(q, 4) *r *s  +  257500 *power(p, 2) *power(q, 6) *r *s  -
        91800 *power(p, 9) *power(r, 2) *s  -    1853700 *power(p, 6) *power(q, 2) *power(r, 2) *s  -
        630000 *power(p, 3) *power(q, 4) *power(r, 2) *s  +  8971250 *power(q, 6) *power(r, 2) *s  +
        2071200 *power(p, 7) *power(r, 3) *s  +  7240000 *power(p, 4) *power(q, 2) *power(r, 3) *s  -
        29375000 *p *power(q, 4) *power(r, 3) *s  -    14416000 *power(p, 5) *power(r, 4) *s  +
        5200000 *power(p, 2) *power(q, 2) *power(r, 4) *s  +  30400000 *power(p, 3) *power(r, 5) *s  +
        12000000 *power(q, 2) *power(r, 5) *s  -  64800 *power(p, 9) *q *power(s, 2)  -
        567000 *power(p, 6) *power(q, 3) *power(s, 2)  -    1655000 *power(p, 3) *power(q, 5) *power(s, 2)  -
        6987500 *power(q, 7) *power(s, 2)  -  337500 *power(p, 7) *q *r *power(s, 2)  -
        8462500 *power(p, 4) *power(q, 3) *r *power(s, 2)  +  5812500 *p *power(q, 5) *r *power(s, 2)  +
        24930000 *power(p, 5) *q *power(r, 2) *power(s, 2)  +
        69125000 *power(p, 2) *power(q, 3) *power(r, 2) *power(s, 2)  -  103500000 *power(p, 3) *q *power(r, 3) *power(s, 2)  -
        30000000 *power(q, 3) *power(r, 3) *power(s, 2)  -  90000000 *p *q *power(r, 4) *power(s, 2)  +
        708750 *power(p, 8) *power(s, 3)  +    5400000 *power(p, 5) *power(q, 2) *power(s, 3)  -
        8906250 *power(p, 2) *power(q, 4) *power(s, 3)  -  18562500 *power(p, 6) *r *power(s, 3)  +
        625000 *power(p, 3) *power(q, 2) *r *power(s, 3)  -  29687500 *power(q, 4) *r *power(s, 3)  +
        75000000 *power(p, 4) *power(r, 2) *power(s, 3)  +    416250000 *p *power(q, 2) *power(r, 2) *power(s, 3)  -
        60000000 *power(p, 2) *power(r, 3) *power(s, 3)  +  300000000 *power(r, 4) *power(s, 3)  -
        71718750 *power(p, 4) *q *power(s, 4)  -  189062500 *p *power(q, 3) *power(s, 4)  -
        210937500 *power(p, 2) *q *r *power(s, 4)  -    1187500000 *q *power(r, 2) *power(s, 4)  +
        187500000 *power(p, 3) *power(s, 5)  +  800781250 *power(q, 2) *power(s, 5)  +
        390625000 *p *r *power(s, 5))

   b12 = -(500 *power(p, 6) *power(q, 5)  +  6350 *power(p, 3) *power(q, 7)  +  19800 *power(q, 9)  -
        3750 *power(p, 7) *power(q, 3) *r  -  65100 *power(p, 4) *power(q, 5) *r  -
        264950 *p *power(q, 7) *r  +  6750 *power(p, 8) *q *power(r, 2)  +
        209050 *power(p, 5) *power(q, 3) *power(r, 2)  +    1217250 *power(p, 2) *power(q, 5) *power(r, 2)  -
        219000 *power(p, 6) *q *power(r, 3)  -  2510000 *power(p, 3) *power(q, 3) *power(r, 3)  -
        1098500 *power(q, 5) *power(r, 3)  +  2068000 *power(p, 4) *q *power(r, 4)  +
        5060000 *p *power(q, 3) *power(r, 4)  -    5200000 *power(p, 2) *q *power(r, 5)  +
        6750 *power(p, 8) *power(q, 2) *s  +  96350 *power(p, 5) *power(q, 4) *s  +
        346000 *power(p, 2) *power(q, 6) *s  -  20250 *power(p, 9) *r *s  -
        459900 *power(p, 6) *power(q, 2) *r *s  -    1828750 *power(p, 3) *power(q, 4) *r *s  +
        2930000 *power(q, 6) *r *s  +  594000 *power(p, 7) *power(r, 2) *s  +
        4301250 *power(p, 4) *power(q, 2) *power(r, 2) *s  -  10906250 *p *power(q, 4) *power(r, 2) *s  -
        5252000 *power(p, 5) *power(r, 3) *s  +   1450000 *power(p, 2) *power(q, 2) *power(r, 3) *s  +
        12800000 *power(p, 3) *power(r, 4) *s  +  6500000 *power(q, 2) *power(r, 4) *s  -
        74250 *power(p, 7) *q *power(s, 2)  -  1418750 *power(p, 4) *power(q, 3) *power(s, 2)  -
        5956250 *p *power(q, 5) *power(s, 2)  +   4297500 *power(p, 5) *q *r *power(s, 2)  +
        29906250 *power(p, 2) *power(q, 3) *r *power(s, 2)  -  31500000 *power(p, 3) *q *power(r, 2) *power(s, 2)  -
        12500000 *power(q, 3) *power(r, 2) *power(s, 2)  -  35000000 *p *q *power(r, 3) *power(s, 2)  -
        1350000 *power(p, 6) *power(s, 3)  -   6093750 *power(p, 3) *power(q, 2) *power(s, 3)  -
        17500000 *power(q, 4) *power(s, 3)  +  7031250 *power(p, 4) *r *power(s, 3)  +
        127812500 *p *power(q, 2) *r *power(s, 3)  -  18750000 *power(p, 2) *power(r, 2) *power(s, 3)  +
        162500000 *power(r, 3) *power(s, 3)  -   107812500 *power(p, 2) *q *power(s, 4)  -
        460937500 *q *r *power(s, 4)  +  214843750 *p *power(s, 5))

   b13 = -(-1950 *power(p, 4) *power(q, 5)  -  14100 *p *power(q, 7)  +  14350 *power(p, 5) *power(q, 3) *r  +
        125600 *power(p, 2) *power(q, 5) *r  -    27900 *power(p, 6) *q *power(r, 2)  -
        402250 *power(p, 3) *power(q, 3) *power(r, 2)  -  288250 *power(q, 5) *power(r, 2)  +
        436000 *power(p, 4) *q *power(r, 3)  +    1345000 *p *power(q, 3) *power(r, 3)  -
        1400000 *power(p, 2) *q *power(r, 4)  -  9450 *power(p, 6) *power(q, 2) *s  +
        1250 *power(p, 3) *power(q, 4) *s  +    465000 *power(q, 6) *s  +
        49950 *power(p, 7) *r *s  +  302500 *power(p, 4) *power(q, 2) *r *s  -
        1718750 *p *power(q, 4) *r *s  -    834000 *power(p, 5) *power(r, 2) *s  -
        437500 *power(p, 2) *power(q, 2) *power(r, 2) *s  +  3100000 *power(p, 3) *power(r, 3) *s  +
        1750000 *power(q, 2) *power(r, 3) *s  +  292500 *power(p, 5) *q *power(s, 2)  +
        1937500 *power(p, 2) *power(q, 3) *power(s, 2)  -    3343750 *power(p, 3) *q *r *power(s, 2)  -
        1875000 *power(q, 3) *r *power(s, 2)  -  8125000 *p *q *power(r, 2) *power(s, 2)  +
        1406250 *power(p, 4) *power(s, 3)  +  12343750 *p *power(q, 2) *power(s, 3)  -
        5312500 *power(p, 2) *r *power(s, 3)  +    43750000 *power(r, 2) *power(s, 3)  -
        74218750 *q *power(s, 4))

   b14 = -(300 *power(p, 5) *power(q, 3)  +  2150 *power(p, 2) *power(q, 5)  -  1350 *power(p, 6) *q *r  -
        21500 *power(p, 3) *power(q, 3) *r  -  61500 *power(q, 5) *r  +
        42000 *power(p, 4) *q *power(r, 2)  +  290000 *p *power(q, 3) *power(r, 2)  -
        300000 *power(p, 2) *q *power(r, 3)  +  4050 *power(p, 7) *s  +
        45000 *power(p, 4) *power(q, 2) *s  +  125000 *p *power(q, 4) *s  -
        108000 *power(p, 5) *r *s  -    643750 *power(p, 2) *power(q, 2) *r *s  +
        700000 *power(p, 3) *power(r, 2) *s  +  375000 *power(q, 2) *power(r, 2) *s  +
        93750 *power(p, 3) *q *power(s, 2)  +  312500 *power(q, 3) *power(s, 2)  -
        1875000 *p *q *r *power(s, 2)  +   1406250 *power(p, 2) *power(s, 3)  +
        9375000 *r *power(s, 3))

   b15 = -(-1250 *power(p, 3) *power(q, 3)  -  9000 *power(q, 5)  +  4500 *power(p, 4) *q *r  +
        46250 *p *power(q, 3) *r  -  50000 *power(p, 2) *q *power(r, 2)  -   6750 *power(p, 5) *s  -
        43750 *power(p, 2) *power(q, 2) *s  +  75000 *power(p, 3) *r *s  +
        62500 *power(q, 2) *r *s  -    156250 *p *q *power(s, 2)  +  1562500 *power(s, 3))

   b20 = (200 *power(p, 6) *power(q, 11)  -  250 *power(p, 3) *power(q, 13)  -  10800 *power(q, 15)  -
        3900 *power(p, 7) *power(q, 9) *r  -  3325 *power(p, 4) *power(q, 11) *r  +
        181800 *p *power(q, 13) *r  +  26950 *power(p, 8) *power(q, 7) *power(r, 2)  +
        69625 *power(p, 5) *power(q, 9) *power(r, 2)  -    1214450 *power(p, 2) *power(q, 11) *power(r, 2)  -
        78725 *power(p, 9) *power(q, 5) *power(r, 3)  -  368675 *power(p, 6) *power(q, 7) *power(r, 3)  +
        4166325 *power(p, 3) *power(q, 9) *power(r, 3)  +  1131100 *power(q, 11) *power(r, 3)  +
        73400 *power(p, 10) *power(q, 3) *power(r, 4)  +    661950 *power(p, 7) *power(q, 5) *power(r, 4)  -
        9151950 *power(p, 4) *power(q, 7) *power(r, 4)  -  16633075 *p *power(q, 9) *power(r, 4)  +
        36000 *power(p, 11) *q *power(r, 5)  +  135600 *power(p, 8) *power(q, 3) *power(r, 5)  +
        17321400 *power(p, 5) *power(q, 5) *power(r, 5)  +    85338300 *power(p, 2) *power(q, 7) *power(r, 5)  -
        832000 *power(p, 9) *q *power(r, 6)  -  21379200 *power(p, 6) *power(q, 3) *power(r, 6)  -
        176044000 *power(p, 3) *power(q, 5) *power(r, 6)  -  1410000 *power(q, 7) *power(r, 6)  +
        6528000 *power(p, 7) *q *power(r, 7)  +    129664000 *power(p, 4) *power(q, 3) *power(r, 7)  +
        47344000 *p *power(q, 5) *power(r, 7)  -  21504000 *power(p, 5) *q *power(r, 8)  -
        115200000 *power(p, 2) *power(q, 3) *power(r, 8)  +  25600000 *power(p, 3) *q *power(r, 9)  +
        64000000 *power(q, 3) *power(r, 9)  +    15700 *power(p, 8) *power(q, 8) *s  +
        120525 *power(p, 5) *power(q, 10) *s  +  113250 *power(p, 2) *power(q, 12) *s  -
        196900 *power(p, 9) *power(q, 6) *r *s  -  1776925 *power(p, 6) *power(q, 8) *r *s  -
        3062475 *power(p, 3) *power(q, 10) *r *s  -    4153500 *power(q, 12) *r *s  +
        857925 *power(p, 10) *power(q, 4) *power(r, 2) *s  +  10562775 *power(p, 7) *power(q, 6) *power(r, 2) *s  +
        34866250 *power(p, 4) *power(q, 8) *power(r, 2) *s  +  73486750 *p *power(q, 10) *power(r, 2) *s  -
        1333800 *power(p, 11) *power(q, 2) *power(r, 3) *s  -  29212625 *power(p, 8) *power(q, 4) *power(r, 3) *s  -
        168729675 *power(p, 5) *power(q, 6) *power(r, 3) *s  -
        427230750 *power(p, 2) *power(q, 8) *power(r, 3) *s  +  108000 *power(p, 12) *power(r, 4) *s  +
        30384200 *power(p, 9) *power(q, 2) *power(r, 4) *s  +  324535100 *power(p, 6) *power(q, 4) *power(r, 4) *s  +
        952666750 *power(p, 3) *power(q, 6) *power(r, 4) *s  -  38076875 *power(q, 8) *power(r, 4) *s  -
        4296000 *power(p, 10) *power(r, 5) *s  -    213606400 *power(p, 7) *power(q, 2) *power(r, 5) *s  -
        842060000 *power(p, 4) *power(q, 4) *power(r, 5) *s  -    95285000 *p *power(q, 6) *power(r, 5) *s  +
        61184000 *power(p, 8) *power(r, 6) *s  +  567520000 *power(p, 5) *power(q, 2) *power(r, 6) *s  +
        547000000 *power(p, 2) *power(q, 4) *power(r, 6) *s  -  390912000 *power(p, 6) *power(r, 7) *s  -
        812800000 *power(p, 3) *power(q, 2) *power(r, 7) *s  -  924000000 *power(q, 4) *power(r, 7) *s  +
        1152000000 *power(p, 4) *power(r, 8) *s  +    800000000 *p *power(q, 2) *power(r, 8) *s  -
        1280000000 *power(p, 2) *power(r, 9) *s  +  141750 *power(p, 10) *power(q, 5) *power(s, 2)  -
        31500 *power(p, 7) *power(q, 7) *power(s, 2)  -  11325000 *power(p, 4) *power(q, 9) *power(s, 2)  -
        31687500 *p *power(q, 11) *power(s, 2)  -    1293975 *power(p, 11) *power(q, 3) *r *power(s, 2)  -
        4803800 *power(p, 8) *power(q, 5) *r *power(s, 2)  +    71398250 *power(p, 5) *power(q, 7) *r *power(s, 2)  +
        227625000 *power(p, 2) *power(q, 9) *r *power(s, 2)  +
        3256200 *power(p, 12) *q *power(r, 2) *power(s, 2)  +  43870125 *power(p, 9) *power(q, 3) *power(r, 2) *power(s, 2)  +
        64581500 *power(p, 6) *power(q, 5) *power(r, 2) *power(s, 2)  +
        56090625 *power(p, 3) *power(q, 7) *power(r, 2) *power(s, 2)  +   260218750 *power(q, 9) *power(r, 2) *power(s, 2)  -
        74610000 *power(p, 10) *q *power(r, 3) *power(s, 2)  -
        662186500 *power(p, 7) *power(q, 3) *power(r, 3) *power(s, 2)  -
        1987747500 *power(p, 4) *power(q, 5) *power(r, 3) *power(s, 2)  -
        811928125 *p *power(q, 7) *power(r, 3) *power(s, 2)  +  471286000 *power(p, 8) *q *power(r, 4) *power(s, 2)  +
        2106040000 *power(p, 5) *power(q, 3) *power(r, 4) *power(s, 2)  +
        792687500 *power(p, 2) *power(q, 5) *power(r, 4) *power(s, 2)  -
        135120000 *power(p, 6) *q *power(r, 5) *power(s, 2)  +  2479000000 *power(p, 3) *power(q, 3) *power(r, 5) *power(s, 2)  +
        5242250000 *power(q, 5) *power(r, 5) *power(s, 2)  -
        6400000000 *power(p, 4) *q *power(r, 6) *power(s, 2)  -
        8620000000 *p *power(q, 3) *power(r, 6) *power(s, 2)  +  13280000000 *power(p, 2) *q *power(r, 7) *power(s, 2)  +
        1600000000 *q *power(r, 8) *power(s, 2)  +  273375 *power(p, 12) *power(q, 2) *power(s, 3)  -
        13612500 *power(p, 9) *power(q, 4) *power(s, 3)  -    177250000 *power(p, 6) *power(q, 6) *power(s, 3)  -
        511015625 *power(p, 3) *power(q, 8) *power(s, 3)  -  320937500 *power(q, 10) *power(s, 3)  -
        2770200 *power(p, 13) *r *power(s, 3)  +  12595500 *power(p, 10) *power(q, 2) *r *power(s, 3)  +
        543950000 *power(p, 7) *power(q, 4) *r *power(s, 3)  +
        1612281250 *power(p, 4) *power(q, 6) *r *power(s, 3)  +  968125000 *p *power(q, 8) *r *power(s, 3)  +
        77031000 *power(p, 11) *power(r, 2) *power(s, 3)  +  373218750 *power(p, 8) *power(q, 2) *power(r, 2) *power(s, 3)  +
        1839765625 *power(p, 5) *power(q, 4) *power(r, 2) *power(s, 3)  +
        1818515625 *power(p, 2) *power(q, 6) *power(r, 2) *power(s, 3)  -
        776745000 *power(p, 9) *power(r, 3) *power(s, 3)  -  6861075000 *power(p, 6) *power(q, 2) *power(r, 3) *power(s, 3)  -
        20014531250 *power(p, 3) *power(q, 4) *power(r, 3) *power(s, 3)  -
        13747812500 *power(q, 6) *power(r, 3) *power(s, 3)  +    3768000000 *power(p, 7) *power(r, 4) *power(s, 3)  +
        35365000000 *power(p, 4) *power(q, 2) *power(r, 4) *power(s, 3)  +
        34441875000 *p *power(q, 4) *power(r, 4) *power(s, 3)  -  9628000000 *power(p, 5) *power(r, 5) *power(s, 3)  -
        63230000000 *power(p, 2) *power(q, 2) *power(r, 5) *power(s, 3)  +
        13600000000 *power(p, 3) *power(r, 6) *power(s, 3)  -    15000000000 *power(q, 2) *power(r, 6) *power(s, 3)  -
        10400000000 *p *power(r, 7) *power(s, 3)  -  45562500 *power(p, 11) *q *power(s, 4)  -
        525937500 *power(p, 8) *power(q, 3) *power(s, 4)  -  1364218750 *power(p, 5) *power(q, 5) *power(s, 4)  -
        1382812500 *power(p, 2) *power(q, 7) *power(s, 4)  +  572062500 *power(p, 9) *q *r *power(s, 4)  +
        2473515625 *power(p, 6) *power(q, 3) *r *power(s, 4)  +  13192187500 *power(p, 3) *power(q, 5) *r *power(s, 4)  +
        12703125000 *power(q, 7) *r *power(s, 4)  -
        451406250 *power(p, 7) *q *power(r, 2) *power(s, 4)  -
        18153906250 *power(p, 4) *power(q, 3) *power(r, 2) *power(s, 4)  -
        36908203125 *p *power(q, 5) *power(r, 2) *power(s, 4)  -
        9069375000 *power(p, 5) *q *power(r, 3) *power(s, 4)  +
        79957812500 *power(p, 2) *power(q, 3) *power(r, 3) *power(s, 4)  +
        5512500000 *power(p, 3) *q *power(r, 4) *power(s, 4)  +  50656250000 *power(q, 3) *power(r, 4) *power(s, 4)  +
        74750000000 *p *q *power(r, 5) *power(s, 4)  +  56953125 *power(p, 10) *power(s, 5)  +
        1381640625 *power(p, 7) *power(q, 2) *power(s, 5)  -    781250000 *power(p, 4) *power(q, 4) *power(s, 5)  +
        878906250 *p *power(q, 6) *power(s, 5)  -  2655703125 *power(p, 8) *r *power(s, 5)  -
        3223046875 *power(p, 5) *power(q, 2) *r *power(s, 5)  -  35117187500 *power(p, 2) *power(q, 4) *r *power(s, 5)  +
        26573437500 *power(p, 6) *power(r, 2) *power(s, 5)  +
        14785156250 *power(p, 3) *power(q, 2) *power(r, 2) *power(s, 5)  -
        52050781250 *power(q, 4) *power(r, 2) *power(s, 5)  -  103062500000 *power(p, 4) *power(r, 3) *power(s, 5)  -
        281796875000 *p *power(q, 2) *power(r, 3) *power(s, 5)  +
        146875000000 *power(p, 2) *power(r, 4) *power(s, 5)  -    37500000000 *power(r, 5) *power(s, 5)  -
        8789062500 *power(p, 6) *q *power(s, 6)  -  3906250000 *power(p, 3) *power(q, 3) *power(s, 6)  +
        1464843750 *power(q, 5) *power(s, 6)  +  102929687500 *power(p, 4) *q *r *power(s, 6)  +
        297119140625 *p *power(q, 3) *r *power(s, 6)  -  217773437500 *power(p, 2) *q *power(r, 2) *power(s, 6)  +
        167968750000 *q *power(r, 3) *power(s, 6)  +  10986328125 *power(p, 5) *power(s, 7)  +
        98876953125 *power(p, 2) *power(q, 2) *power(s, 7)  -    188964843750 *power(p, 3) *r *power(s, 7)  -
        278320312500 *power(q, 2) *r *power(s, 7)  +    517578125000 *p *power(r, 2) *power(s, 7)  -
        610351562500 *p *q *power(s, 8)  +  762939453125 *power(s, 9))

   b21 = (-200 *power(p, 7) *power(q, 9)  +  1850 *power(p, 4) *power(q, 11)  +  21600 *p *power(q, 13)  +
        3200 *power(p, 8) *power(q, 7) *r  -    19200 *power(p, 5) *power(q, 9) *r  -
        316350 *power(p, 2) *power(q, 11) *r  -  19050 *power(p, 9) *power(q, 5) *power(r, 2)  +
        37400 *power(p, 6) *power(q, 7) *power(r, 2)  +  1759250 *power(p, 3) *power(q, 9) *power(r, 2)  +
        440100 *power(q, 11) *power(r, 2)  +    48750 *power(p, 10) *power(q, 3) *power(r, 3)  +
        190200 *power(p, 7) *power(q, 5) *power(r, 3)  -  4604200 *power(p, 4) *power(q, 7) *power(r, 3)  -
        6072800 *p *power(q, 9) *power(r, 3)  -  43200 *power(p, 11) *q *power(r, 4)  -
        834500 *power(p, 8) *power(q, 3) *power(r, 4)  +    4916000 *power(p, 5) *power(q, 5) *power(r, 4)  +
        27926850 *power(p, 2) *power(q, 7) *power(r, 4)  +  969600 *power(p, 9) *q *power(r, 5)  +
        2467200 *power(p, 6) *power(q, 3) *power(r, 5)  -  45393200 *power(p, 3) *power(q, 5) *power(r, 5)  -
        5399500 *power(q, 7) *power(r, 5)  -    7283200 *power(p, 7) *q *power(r, 6)  +
        10536000 *power(p, 4) *power(q, 3) *power(r, 6)  +  41656000 *p *power(q, 5) *power(r, 6)  +
        22784000 *power(p, 5) *q *power(r, 7)  -  35200000 *power(p, 2) *power(q, 3) *power(r, 7)  -
        25600000 *power(p, 3) *q *power(r, 8)  +    96000000 *power(q, 3) *power(r, 8)  -
        3000 *power(p, 9) *power(q, 6) *s  +  40400 *power(p, 6) *power(q, 8) *s  +
        136550 *power(p, 3) *power(q, 10) *s  -  1647000 *power(q, 12) *s  +
        40500 *power(p, 10) *power(q, 4) *r *s  -    173600 *power(p, 7) *power(q, 6) *r *s  -
        126500 *power(p, 4) *power(q, 8) *r *s  +  23969250 *p *power(q, 10) *r *s  -
        153900 *power(p, 11) *power(q, 2) *power(r, 2) *s  -  486150 *power(p, 8) *power(q, 4) *power(r, 2) *s  -
        4115800 *power(p, 5) *power(q, 6) *power(r, 2) *s  -    112653250 *power(p, 2) *power(q, 8) *power(r, 2) *s  +
        129600 *power(p, 12) *power(r, 3) *s  +  2683350 *power(p, 9) *power(q, 2) *power(r, 3) *s  +
        10906650 *power(p, 6) *power(q, 4) *power(r, 3) *s  +  187289500 *power(p, 3) *power(q, 6) *power(r, 3) *s  +
        44098750 *power(q, 8) *power(r, 3) *s  -    4384800 *power(p, 10) *power(r, 4) *s  -
        35660800 *power(p, 7) *power(q, 2) *power(r, 4) *s  -  175420000 *power(p, 4) *power(q, 4) *power(r, 4) *s  -
        426538750 *p *power(q, 6) *power(r, 4) *s  +  60857600 *power(p, 8) *power(r, 5) *s  +
        349436000 *power(p, 5) *power(q, 2) *power(r, 5) *s  +
        900600000 *power(p, 2) *power(q, 4) *power(r, 5) *s  -  429568000 *power(p, 6) *power(r, 6) *s  -
        1511200000 *power(p, 3) *power(q, 2) *power(r, 6) *s  -  1286000000 *power(q, 4) *power(r, 6) *s  +
        1472000000 *power(p, 4) *power(r, 7) *s  +    1440000000 *p *power(q, 2) *power(r, 7) *s  -
        1920000000 *power(p, 2) *power(r, 8) *s  -  36450 *power(p, 11) *power(q, 3) *power(s, 2)  -
        188100 *power(p, 8) *power(q, 5) *power(s, 2)  -  5504750 *power(p, 5) *power(q, 7) *power(s, 2)  -
        37968750 *power(p, 2) *power(q, 9) *power(s, 2)  +    255150 *power(p, 12) *q *r *power(s, 2)  +
        2754000 *power(p, 9) *power(q, 3) *r *power(s, 2)  +  49196500 *power(p, 6) *power(q, 5) *r *power(s, 2)  +
        323587500 *power(p, 3) *power(q, 7) *r *power(s, 2)  -  83250000 *power(q, 9) *r *power(s, 2)  -
        465750 *power(p, 10) *q *power(r, 2) *power(s, 2)  -
        31881500 *power(p, 7) *power(q, 3) *power(r, 2) *power(s, 2)  -  415585000 *power(p, 4) *power(q, 5) *power(r, 2) *power(s, 2)  +
        1054775000 *p *power(q, 7) *power(r, 2) *power(s, 2)  -
        96823500 *power(p, 8) *q *power(r, 3) *power(s, 2)  -
        701490000 *power(p, 5) *power(q, 3) *power(r, 3) *power(s, 2)  -
        2953531250 *power(p, 2) *power(q, 5) *power(r, 3) *power(s, 2)  +
        1454560000 *power(p, 6) *q *power(r, 4) *power(s, 2)  +  7670500000 *power(p, 3) *power(q, 3) *power(r, 4) *power(s, 2)  +
        5661062500 *power(q, 5) *power(r, 4) *power(s, 2)  -
        7785000000 *power(p, 4) *q *power(r, 5) *power(s, 2)  -
        9450000000 *p *power(q, 3) *power(r, 5) *power(s, 2)  +  14000000000 *power(p, 2) *q *power(r, 6) *power(s, 2)  +
        2400000000 *q *power(r, 7) *power(s, 2)  -  437400 *power(p, 13) *power(s, 3)  -
        10145250 *power(p, 10) *power(q, 2) *power(s, 3)  -    121912500 *power(p, 7) *power(q, 4) *power(s, 3)  -
        576531250 *power(p, 4) *power(q, 6) *power(s, 3)  -  528593750 *p *power(q, 8) *power(s, 3)  +
        12939750 *power(p, 11) *r *power(s, 3)  +  313368750 *power(p, 8) *power(q, 2) *r *power(s, 3)  +
        2171812500 *power(p, 5) *power(q, 4) *r *power(s, 3)  +  2381718750 *power(p, 2) *power(q, 6) *r *power(s, 3)  -
        124638750 *power(p, 9) *power(r, 2) *power(s, 3)  -
        3001575000 *power(p, 6) *power(q, 2) *power(r, 2) *power(s, 3)  -
        12259375000 *power(p, 3) *power(q, 4) *power(r, 2) *power(s, 3)  -  9985312500 *power(q, 6) *power(r, 2) *power(s, 3)  +
        384000000 *power(p, 7) *power(r, 3) *power(s, 3)  +
        13997500000 *power(p, 4) *power(q, 2) *power(r, 3) *power(s, 3)  +
        20749531250 *p *power(q, 4) *power(r, 3) *power(s, 3)  -  553500000 *power(p, 5) *power(r, 4) *power(s, 3)  -
        41835000000 *power(p, 2) *power(q, 2) *power(r, 4) *power(s, 3)  +
        5420000000 *power(p, 3) *power(r, 5) *power(s, 3)  -    16300000000 *power(q, 2) *power(r, 5) *power(s, 3)  -
        17600000000 *p *power(r, 6) *power(s, 3)  -  7593750 *power(p, 9) *q *power(s, 4)  +
        289218750 *power(p, 6) *power(q, 3) *power(s, 4)  +  3591406250 *power(p, 3) *power(q, 5) *power(s, 4)  +
        5992187500 *power(q, 7) *power(s, 4)  +    658125000 *power(p, 7) *q *r *power(s, 4)  -
        269531250 *power(p, 4) *power(q, 3) *r *power(s, 4)  -
        15882812500 *p *power(q, 5) *r *power(s, 4)  -  4785000000 *power(p, 5) *q *power(r, 2) *power(s, 4)  +
        54375781250 *power(p, 2) *power(q, 3) *power(r, 2) *power(s, 4)  -
        5668750000 *power(p, 3) *q *power(r, 3) *power(s, 4)  +
        35867187500 *power(q, 3) *power(r, 3) *power(s, 4)  +  113875000000 *p *q *power(r, 4) *power(s, 4)  -
        544218750 *power(p, 8) *power(s, 5)  -    5407031250 *power(p, 5) *power(q, 2) *power(s, 5)  -
        14277343750 *power(p, 2) *power(q, 4) *power(s, 5)  +    5421093750 *power(p, 6) *r *power(s, 5)  -
        24941406250 *power(p, 3) *power(q, 2) *r *power(s, 5)  -
        25488281250 *power(q, 4) *r *power(s, 5)  -  11500000000 *power(p, 4) *power(r, 2) *power(s, 5)  -
        231894531250 *p *power(q, 2) *power(r, 2) *power(s, 5)  -  6250000000 *power(p, 2) *power(r, 3) *power(s, 5)  -
        43750000000 *power(r, 4) *power(s, 5)  +  35449218750 *power(p, 4) *q *power(s, 6)  +
        137695312500 *p *power(q, 3) *power(s, 6)  +    34667968750 *power(p, 2) *q *r *power(s, 6)  +
        202148437500 *q *power(r, 2) *power(s, 6)  -  33691406250 *power(p, 3) *power(s, 7)  -
        214843750000 *power(q, 2) *power(s, 7)  -  31738281250 *p *r *power(s, 7))

   b22 = (-800 *power(p, 5) *power(q, 9)  -  5400 *power(p, 2) *power(q, 11)  +  5800 *power(p, 6) *power(q, 7) *r  +
        48750 *power(p, 3) *power(q, 9) *r  +    16200 *power(q, 11) *r  -
        3000 *power(p, 7) *power(q, 5) *power(r, 2)  -  108350 *power(p, 4) *power(q, 7) *power(r, 2)  -
        263250 *p *power(q, 9) *power(r, 2)  -    60700 *power(p, 8) *power(q, 3) *power(r, 3)  -
        386250 *power(p, 5) *power(q, 5) *power(r, 3)  +  253100 *power(p, 2) *power(q, 7) *power(r, 3)  +
        127800 *power(p, 9) *q *power(r, 4)  +  2326700 *power(p, 6) *power(q, 3) *power(r, 4)  +
        6565550 *power(p, 3) *power(q, 5) *power(r, 4)  -    705750 *power(q, 7) *power(r, 4)  -
        2903200 *power(p, 7) *q *power(r, 5)  -  21218000 *power(p, 4) *power(q, 3) *power(r, 5)  +
        1057000 *p *power(q, 5) *power(r, 5)  +  20368000 *power(p, 5) *q *power(r, 6)  +
        33000000 *power(p, 2) *power(q, 3) *power(r, 6)  -    43200000 *power(p, 3) *q *power(r, 7)  +
        52000000 *power(q, 3) *power(r, 7)  +  6200 *power(p, 7) *power(q, 6) *s  +
        188250 *power(p, 4) *power(q, 8) *s  +  931500 *p *power(q, 10) *s  -
        73800 *power(p, 8) *power(q, 4) *r *s  -    1466850 *power(p, 5) *power(q, 6) *r *s  -
        6894000 *power(p, 2) *power(q, 8) *r *s  +  315900 *power(p, 9) *power(q, 2) *power(r, 2) *s  +
        4547000 *power(p, 6) *power(q, 4) *power(r, 2) *s  +  20362500 *power(p, 3) *power(q, 6) *power(r, 2) *s  +
        15018750 *power(q, 8) *power(r, 2) *s  -    653400 *power(p, 10) *power(r, 3) *s  -
        13897550 *power(p, 7) *power(q, 2) *power(r, 3) *s  -  76757500 *power(p, 4) *power(q, 4) *power(r, 3) *s  -
        124207500 *p *power(q, 6) *power(r, 3) *s  +  18567600 *power(p, 8) *power(r, 4) *s  +
        175911000 *power(p, 5) *power(q, 2) *power(r, 4) *s  +
        253787500 *power(p, 2) *power(q, 4) *power(r, 4) *s  -  183816000 *power(p, 6) *power(r, 5) *s  -
        706900000 *power(p, 3) *power(q, 2) *power(r, 5) *s  -  665750000 *power(q, 4) *power(r, 5) *s  +
        740000000 *power(p, 4) *power(r, 6) *s  +    890000000 *p *power(q, 2) *power(r, 6) *s  -
        1040000000 *power(p, 2) *power(r, 7) *s  -  763000 *power(p, 6) *power(q, 5) *power(s, 2)  -
        12375000 *power(p, 3) *power(q, 7) *power(s, 2)  -  40500000 *power(q, 9) *power(s, 2)  +
        364500 *power(p, 10) *q *r *power(s, 2)  +    15537000 *power(p, 7) *power(q, 3) *r *power(s, 2)  +
        154392500 *power(p, 4) *power(q, 5) *r *power(s, 2)  +    372206250 *p *power(q, 7) *r *power(s, 2)  -
        25481250 *power(p, 8) *q *power(r, 2) *power(s, 2)  -
        386300000 *power(p, 5) *power(q, 3) *power(r, 2) *power(s, 2)  -  996343750 *power(p, 2) *power(q, 5) *power(r, 2) *power(s, 2)  +
        459872500 *power(p, 6) *q *power(r, 3) *power(s, 2)  +
        2943937500 *power(p, 3) *power(q, 3) *power(r, 3) *power(s, 2)  +
        2437781250 *power(q, 5) *power(r, 3) *power(s, 2)  -  2883750000 *power(p, 4) *q *power(r, 4) *power(s, 2)  -
        4343750000 *p *power(q, 3) *power(r, 4) *power(s, 2)  +
        5495000000 *power(p, 2) *q *power(r, 5) *power(s, 2)  +   1300000000 *q *power(r, 6) *power(s, 2)  -
        364500 *power(p, 11) *power(s, 3)  -  13668750 *power(p, 8) *power(q, 2) *power(s, 3)  -
        113406250 *power(p, 5) *power(q, 4) *power(s, 3)  -  159062500 *power(p, 2) *power(q, 6) *power(s, 3)  +
        13972500 *power(p, 9) *r *power(s, 3)  +    61537500 *power(p, 6) *power(q, 2) *r *power(s, 3)  -
        1622656250 *power(p, 3) *power(q, 4) *r *power(s, 3)  -    2720625000 *power(q, 6) *r *power(s, 3)  -
        201656250 *power(p, 7) *power(r, 2) *power(s, 3)  +
        1949687500 *power(p, 4) *power(q, 2) *power(r, 2) *power(s, 3)  +  4979687500 *p *power(q, 4) *power(r, 2) *power(s, 3)  +
        497125000 *power(p, 5) *power(r, 3) *power(s, 3)  -
        11150625000 *power(p, 2) *power(q, 2) *power(r, 3) *power(s, 3)  +
        2982500000 *power(p, 3) *power(r, 4) *power(s, 3)  -  6612500000 *power(q, 2) *power(r, 4) *power(s, 3)  -
        10450000000 *p *power(r, 5) *power(s, 3)  +  126562500 *power(p, 7) *q *power(s, 4)  +
        1443750000 *power(p, 4) *power(q, 3) *power(s, 4)  +    281250000 *p *power(q, 5) *power(s, 4)  -
        1648125000 *power(p, 5) *q *r *power(s, 4)  +
        11271093750 *power(p, 2) *power(q, 3) *r *power(s, 4)  -  4785156250 *power(p, 3) *q *power(r, 2) *power(s, 4)  +
        8808593750 *power(q, 3) *power(r, 2) *power(s, 4)  +
        52390625000 *p *q *power(r, 3) *power(s, 4)  -  611718750 *power(p, 6) *power(s, 5)  -
        13027343750 *power(p, 3) *power(q, 2) *power(s, 5)  -  1464843750 *power(q, 4) *power(s, 5)  +
        6492187500 *power(p, 4) *r *power(s, 5)  -    65351562500 *p *power(q, 2) *r *power(s, 5)  -
        13476562500 *power(p, 2) *power(r, 2) *power(s, 5)  -    24218750000 *power(r, 3) *power(s, 5)  +
        41992187500 *power(p, 2) *q *power(s, 6)  +  69824218750 *q *r *power(s, 6)  -
        34179687500 *p *power(s, 7))

   b23 = (-1000 *power(p, 6) *power(q, 7)  -  5150 *power(p, 3) *power(q, 9)  +  10800 *power(q, 11)  +
        11000 *power(p, 7) *power(q, 5) *r  +    66450 *power(p, 4) *power(q, 7) *r  -
        127800 *p *power(q, 9) *r  -  41250 *power(p, 8) *power(q, 3) *power(r, 2)  -
        368400 *power(p, 5) *power(q, 5) *power(r, 2)  +    204200 *power(p, 2) *power(q, 7) *power(r, 2)  +
        54000 *power(p, 9) *q *power(r, 3)  +  1040950 *power(p, 6) *power(q, 3) *power(r, 3)  +
        2096500 *power(p, 3) *power(q, 5) *power(r, 3)  +  200000 *power(q, 7) *power(r, 3)  -
        1140000 *power(p, 7) *q *power(r, 4)  -    7691000 *power(p, 4) *power(q, 3) *power(r, 4)  -
        2281000 *p *power(q, 5) *power(r, 4)  +  7296000 *power(p, 5) *q *power(r, 5)  +
        13300000 *power(p, 2) *power(q, 3) *power(r, 5)  -  14400000 *power(p, 3) *q *power(r, 6)  +
        14000000 *power(q, 3) *power(r, 6)  -   9000 *power(p, 8) *power(q, 4) *s  +
        52100 *power(p, 5) *power(q, 6) *s  +  710250 *power(p, 2) *power(q, 8) *s  +
        67500 *power(p, 9) *power(q, 2) *r *s  -  256100 *power(p, 6) *power(q, 4) *r *s  -
        5753000 *power(p, 3) *power(q, 6) *r *s  +    292500 *power(q, 8) *r *s  -
        162000 *power(p, 10) *power(r, 2) *s  -  1432350 *power(p, 7) *power(q, 2) *power(r, 2) *s  +
        5410000 *power(p, 4) *power(q, 4) *power(r, 2) *s  -  7408750 *p *power(q, 6) *power(r, 2) *s  +
        4401000 *power(p, 8) *power(r, 3) *s  +    24185000 *power(p, 5) *power(q, 2) *power(r, 3) *s  +
        20781250 *power(p, 2) *power(q, 4) *power(r, 3) *s  -  43012000 *power(p, 6) *power(r, 4) *s  -
        146300000 *power(p, 3) *power(q, 2) *power(r, 4) *s  -  165875000 *power(q, 4) *power(r, 4) *s  +
        182000000 *power(p, 4) *power(r, 5) *s  +    250000000 *p *power(q, 2) *power(r, 5) *s  -
        280000000 *power(p, 2) *power(r, 6) *s  +  60750 *power(p, 10) *q *power(s, 2)  +
        2414250 *power(p, 7) *power(q, 3) *power(s, 2)  +  15770000 *power(p, 4) *power(q, 5) *power(s, 2)  +
        15825000 *p *power(q, 7) *power(s, 2)  -    6021000 *power(p, 8) *q *r *power(s, 2)  -
        62252500 *power(p, 5) *power(q, 3) *r *power(s, 2)  -  74718750 *power(p, 2) *power(q, 5) *r *power(s, 2)  +
        90888750 *power(p, 6) *q *power(r, 2) *power(s, 2)  +
        471312500 *power(p, 3) *power(q, 3) *power(r, 2) *power(s, 2)  +
        525875000 *power(q, 5) *power(r, 2) *power(s, 2)  -  539375000 *power(p, 4) *q *power(r, 3) *power(s, 2)  -
        1030000000 *p *power(q, 3) *power(r, 3) *power(s, 2)  +
        1142500000 *power(p, 2) *q *power(r, 4) *power(s, 2)  +    350000000 *q *power(r, 5) *power(s, 2)  -
        303750 *power(p, 9) *power(s, 3)  -  35943750 *power(p, 6) *power(q, 2) *power(s, 3)  -
        331875000 *power(p, 3) *power(q, 4) *power(s, 3)  -  505937500 *power(q, 6) *power(s, 3)  +
        8437500 *power(p, 7) *r *power(s, 3)  +    530781250 *power(p, 4) *power(q, 2) *r *power(s, 3)  +
        1150312500 *p *power(q, 4) *r *power(s, 3)  -    154500000 *power(p, 5) *power(r, 2) *power(s, 3)  -
        2059062500 *power(p, 2) *power(q, 2) *power(r, 2) *power(s, 3)  +
        1150000000 *power(p, 3) *power(r, 3) *power(s, 3)  -  1343750000 *power(q, 2) *power(r, 3) *power(s, 3)  -
        2900000000 *p *power(r, 4) *power(s, 3)  +    30937500 *power(p, 5) *q *power(s, 4)  +
        1166406250 *power(p, 2) *power(q, 3) *power(s, 4)  -  1496875000 *power(p, 3) *q *r *power(s, 4)  +
        1296875000 *power(q, 3) *r *power(s, 4)  +  10640625000 *p *q *power(r, 2) *power(s, 4)  -
        281250000 *power(p, 4) *power(s, 5)  -    9746093750 *p *power(q, 2) *power(s, 5)  +
        1269531250 *power(p, 2) *r *power(s, 5)  -  7421875000 *power(r, 2) *power(s, 5)  +
        15625000000 *q *power(s, 6))

   b24 = (-1600 *power(p, 4) *power(q, 7)  -  10800 *p *power(q, 9)  +  9800 *power(p, 5) *power(q, 5) *r  +
        80550 *power(p, 2) *power(q, 7) *r  -   4600 *power(p, 6) *power(q, 3) *power(r, 2)  -
        112700 *power(p, 3) *power(q, 5) *power(r, 2)  +  40500 *power(q, 7) *power(r, 2)  -
        34200 *power(p, 7) *q *power(r, 3)  -   279500 *power(p, 4) *power(q, 3) *power(r, 3)  -
        665750 *p *power(q, 5) *power(r, 3)  +  632000 *power(p, 5) *q *power(r, 4)  +
        3200000 *power(p, 2) *power(q, 3) *power(r, 4)  -  2800000 *power(p, 3) *q *power(r, 5)  +
        3000000 *power(q, 3) *power(r, 5)  -   18600 *power(p, 6) *power(q, 4) *s  -
        51750 *power(p, 3) *power(q, 6) *s  +  405000 *power(q, 8) *s  +
        21600 *power(p, 7) *power(q, 2) *r *s  -   122500 *power(p, 4) *power(q, 4) *r *s  -
        2891250 *p *power(q, 6) *r *s  +  156600 *power(p, 8) *power(r, 2) *s  +
        1569750 *power(p, 5) *power(q, 2) *power(r, 2) *s  +  6943750 *power(p, 2) *power(q, 4) *power(r, 2) *s  -
        3774000 *power(p, 6) *power(r, 3) *s  -   27100000 *power(p, 3) *power(q, 2) *power(r, 3) *s  -
        30187500 *power(q, 4) *power(r, 3) *s  +  28000000 *power(p, 4) *power(r, 4) *s  +
        52500000 *p *power(q, 2) *power(r, 4) *s  -  60000000 *power(p, 2) *power(r, 5) *s  -
        81000 *power(p, 8) *q *power(s, 2)  -   240000 *power(p, 5) *power(q, 3) *power(s, 2)  +
        937500 *power(p, 2) *power(q, 5) *power(s, 2)  +  3273750 *power(p, 6) *q *r *power(s, 2)  +
        30406250 *power(p, 3) *power(q, 3) *r *power(s, 2)  +  55687500 *power(q, 5) *r *power(s, 2)  -
        42187500 *power(p, 4) *q *power(r, 2) *power(s, 2)  -   112812500 *p *power(q, 3) *power(r, 2) *power(s, 2)  +
        152500000 *power(p, 2) *q *power(r, 3) *power(s, 2)  +  75000000 *q *power(r, 4) *power(s, 2)  -
        4218750 *power(p, 4) *power(q, 2) *power(s, 3)  +  15156250 *p *power(q, 4) *power(s, 3)  +
        5906250 *power(p, 5) *r *power(s, 3)  -   206562500 *power(p, 2) *power(q, 2) *r *power(s, 3)  +
        107500000 *power(p, 3) *power(r, 2) *power(s, 3)  -   159375000 *power(q, 2) *power(r, 2) *power(s, 3)  -
        612500000 *p *power(r, 3) *power(s, 3)  +  135937500 *power(p, 3) *q *power(s, 4)  +
        46875000 *power(q, 3) *power(s, 4)  +  1175781250 *p *q *r *power(s, 4)  -
        292968750 *power(p, 2) *power(s, 5)  -   1367187500 *r *power(s, 5))

   b25 = (-800 *power(p, 5) *power(q, 5)  -  5400 *power(p, 2) *power(q, 7)  +  6000 *power(p, 6) *power(q, 3) *r  +
        51700 *power(p, 3) *power(q, 5) *r  +   27000 *power(q, 7) *r  -
        10800 *power(p, 7) *q *power(r, 2)  -  163250 *power(p, 4) *power(q, 3) *power(r, 2)  -
        285750 *p *power(q, 5) *power(r, 2)  +   192000 *power(p, 5) *q *power(r, 3)  +
        1000000 *power(p, 2) *power(q, 3) *power(r, 3)  -  800000 *power(p, 3) *q *power(r, 4)  +
        500000 *power(q, 3) *power(r, 4)  -  10800 *power(p, 7) *power(q, 2) *s  -
        57500 *power(p, 4) *power(q, 4) *s  +  67500 *p *power(q, 6) *s  +
        32400 *power(p, 8) *r *s  +  279000 *power(p, 5) *power(q, 2) *r *s  -
        131250 *power(p, 2) *power(q, 4) *r *s  -   729000 *power(p, 6) *power(r, 2) *s  -
        4100000 *power(p, 3) *power(q, 2) *power(r, 2) *s  -  5343750 *power(q, 4) *power(r, 2) *s  +
        5000000 *power(p, 4) *power(r, 3) *s  +  10000000 *p *power(q, 2) *power(r, 3) *s  -
        10000000 *power(p, 2) *power(r, 4) *s  +   641250 *power(p, 6) *q *power(s, 2)  +
        5812500 *power(p, 3) *power(q, 3) *power(s, 2)  +  10125000 *power(q, 5) *power(s, 2)  -
        7031250 *power(p, 4) *q *r *power(s, 2)  -  20625000 *p *power(q, 3) *r *power(s, 2)  +
        17500000 *power(p, 2) *q *power(r, 2) *power(s, 2)  +   12500000 *q *power(r, 3) *power(s, 2)  -
        843750 *power(p, 5) *power(s, 3)  -  19375000 *power(p, 2) *power(q, 2) *power(s, 3)  +
        30000000 *power(p, 3) *r *power(s, 3)  -  20312500 *power(q, 2) *r *power(s, 3)  -
        112500000 *p *power(r, 2) *power(s, 3)  +   183593750 *p *q *power(s, 4)  -
        292968750 *power(s, 5))

   b30 = (500 *power(p, 11) *power(q, 6)  +  9875 *power(p, 8) *power(q, 8)  +  42625 *power(p, 5) *power(q, 10)  -
        35000 *power(p, 2) *power(q, 12)  -   4500 *power(p, 12) *power(q, 4) *r  -
        108375 *power(p, 9) *power(q, 6) *r  -  516750 *power(p, 6) *power(q, 8) *r  +
        1110500 *power(p, 3) *power(q, 10) *r  +  2730000 *power(q, 12) *r  +
        10125 *power(p, 13) *power(q, 2) *power(r, 2)  +    358250 *power(p, 10) *power(q, 4) *power(r, 2)  +
        1908625 *power(p, 7) *power(q, 6) *power(r, 2)  -  11744250 *power(p, 4) *power(q, 8) *power(r, 2)  -
        43383250 *p *power(q, 10) *power(r, 2)  -  313875 *power(p, 11) *power(q, 2) *power(r, 3)  -
        2074875 *power(p, 8) *power(q, 4) *power(r, 3)  +    52094750 *power(p, 5) *power(q, 6) *power(r, 3)  +
        264567500 *power(p, 2) *power(q, 8) *power(r, 3)  +  796125 *power(p, 9) *power(q, 2) *power(r, 4)  -
        92486250 *power(p, 6) *power(q, 4) *power(r, 4)  -  757957500 *power(p, 3) *power(q, 6) *power(r, 4)  -
        29354375 *power(q, 8) *power(r, 4)  +    60970000 *power(p, 7) *power(q, 2) *power(r, 5)  +
        1112462500 *power(p, 4) *power(q, 4) *power(r, 5)  +  571094375 *p *power(q, 6) *power(r, 5)  -
        685290000 *power(p, 5) *power(q, 2) *power(r, 6)  -  2037800000 *power(p, 2) *power(q, 4) *power(r, 6)  +
        2279600000 *power(p, 3) *power(q, 2) *power(r, 7)  +    849000000 *power(q, 4) *power(r, 7)  -
        1480000000 *p *power(q, 2) *power(r, 8)  +  13500 *power(p, 13) *power(q, 3) *s  +
        363000 *power(p, 10) *power(q, 5) *s  +  2861250 *power(p, 7) *power(q, 7) *s  +
        8493750 *power(p, 4) *power(q, 9) *s  +    17031250 *p *power(q, 11) *s  -
        60750 *power(p, 14) *q *r *s  -  2319750 *power(p, 11) *power(q, 3) *r *s  -
        22674250 *power(p, 8) *power(q, 5) *r *s  -  74368750 *power(p, 5) *power(q, 7) *r *s  -
        170578125 *power(p, 2) *power(q, 9) *r *s  +   2760750 *power(p, 12) *q *power(r, 2) *s  +
        46719000 *power(p, 9) *power(q, 3) *power(r, 2) *s  +
        163356375 *power(p, 6) *power(q, 5) *power(r, 2) *s  +  360295625 *power(p, 3) *power(q, 7) *power(r, 2) *s  -
        195990625 *power(q, 9) *power(r, 2) *s  -  37341750 *power(p, 10) *q *power(r, 3) *s  -
        194739375 *power(p, 7) *power(q, 3) *power(r, 3) *s  -
        105463125 *power(p, 4) *power(q, 5) *power(r, 3) *s  -  415825000 *p *power(q, 7) *power(r, 3) *s  +
        90180000 *power(p, 8) *q *power(r, 4) *s  -    990552500 *power(p, 5) *power(q, 3) *power(r, 4) *s  +
        3519212500 *power(p, 2) *power(q, 5) *power(r, 4) *s  +
        1112220000 *power(p, 6) *q *power(r, 5) *s  -  4508750000 *power(p, 3) *power(q, 3) *power(r, 5) *s  -
        8159500000 *power(q, 5) *power(r, 5) *s  -  4356000000 *power(p, 4) *q *power(r, 6) *s  +
        14615000000 *p *power(q, 3) *power(r, 6) *s  -  2160000000 *power(p, 2) *q *power(r, 7) *s  +
        91125 *power(p, 15) *power(s, 2)  +    3290625 *power(p, 12) *power(q, 2) *power(s, 2)  +
        35100000 *power(p, 9) *power(q, 4) *power(s, 2)  +  175406250 *power(p, 6) *power(q, 6) *power(s, 2)  +
        629062500 *power(p, 3) *power(q, 8) *power(s, 2)  +  910937500 *power(q, 10) *power(s, 2)  -
        5710500 *power(p, 13) *r *power(s, 2)  -   100423125 *power(p, 10) *power(q, 2) *r *power(s, 2)  -
        604743750 *power(p, 7) *power(q, 4) *r *power(s, 2)  -
        2954843750 *power(p, 4) *power(q, 6) *r *power(s, 2)  -  4587578125 *p *power(q, 8) *r *power(s, 2)  +
        116194500 *power(p, 11) *power(r, 2) *power(s, 2)  +
        1280716250 *power(p, 8) *power(q, 2) *power(r, 2) *power(s, 2)  +
        7401190625 *power(p, 5) *power(q, 4) *power(r, 2) *power(s, 2)  +
        11619937500 *power(p, 2) *power(q, 6) *power(r, 2) *power(s, 2)  -
        952173125 *power(p, 9) *power(r, 3) *power(s, 2)  -  6519712500 *power(p, 6) *power(q, 2) *power(r, 3) *power(s, 2)  -
        10238593750 *power(p, 3) *power(q, 4) *power(r, 3) *power(s, 2)  +
        29984609375 *power(q, 6) *power(r, 3) *power(s, 2)  +    2558300000 *power(p, 7) *power(r, 4) *power(s, 2)  +
        16225000000 *power(p, 4) *power(q, 2) *power(r, 4) *power(s, 2)  -
        64994140625 *p *power(q, 4) *power(r, 4) *power(s, 2)  +  4202250000 *power(p, 5) *power(r, 5) *power(s, 2)  +
        46925000000 *power(p, 2) *power(q, 2) *power(r, 5) *power(s, 2)  -
        28950000000 *power(p, 3) *power(r, 6) *power(s, 2)  -    1000000000 *power(q, 2) *power(r, 6) *power(s, 2)  +
        37000000000 *p *power(r, 7) *power(s, 2)  -  48093750 *power(p, 11) *q *power(s, 3)  -
        673359375 *power(p, 8) *power(q, 3) *power(s, 3)  -  2170312500 *power(p, 5) *power(q, 5) *power(s, 3)  -
        2466796875 *power(p, 2) *power(q, 7) *power(s, 3)  +  647578125 *power(p, 9) *q *r *power(s, 3)  +
        597031250 *power(p, 6) *power(q, 3) *r *power(s, 3)  -  7542578125 *power(p, 3) *power(q, 5) *r *power(s, 3)  -
        41125000000 *power(q, 7) *r *power(s, 3)  -  2175828125 *power(p, 7) *q *power(r, 2) *power(s, 3)  -
        7101562500 *power(p, 4) *power(q, 3) *power(r, 2) *power(s, 3)  +
        100596875000 *p *power(q, 5) *power(r, 2) *power(s, 3)  -
        8984687500 *power(p, 5) *q *power(r, 3) *power(s, 3)  -
        120070312500 *power(p, 2) *power(q, 3) *power(r, 3) *power(s, 3)  +
        57343750000 *power(p, 3) *q *power(r, 4) *power(s, 3)  +  9500000000 *power(q, 3) *power(r, 4) *power(s, 3)  -
        342875000000 *p *q *power(r, 5) *power(s, 3)  +  400781250 *power(p, 10) *power(s, 4)  +
        8531250000 *power(p, 7) *power(q, 2) *power(s, 4)  +    34033203125 *power(p, 4) *power(q, 4) *power(s, 4)  +
        42724609375 *p *power(q, 6) *power(s, 4)  -  6289453125 *power(p, 8) *r *power(s, 4)  -
        24037109375 *power(p, 5) *power(q, 2) *r *power(s, 4)  -  62626953125 *power(p, 2) *power(q, 4) *r *power(s, 4)  +
        17299218750 *power(p, 6) *power(r, 2) *power(s, 4)  +
        108357421875 *power(p, 3) *power(q, 2) *power(r, 2) *power(s, 4)  -
        55380859375 *power(q, 4) *power(r, 2) *power(s, 4)  +  105648437500 *power(p, 4) *power(r, 3) *power(s, 4)  +
        1204228515625 *p *power(q, 2) *power(r, 3) *power(s, 4)  -
        365000000000 *power(p, 2) *power(r, 4) *power(s, 4)  +   184375000000 *power(r, 5) *power(s, 4)  -
        32080078125 *power(p, 6) *q *power(s, 5)  -  98144531250 *power(p, 3) *power(q, 3) *power(s, 5)  +
        93994140625 *power(q, 5) *power(s, 5)  -  178955078125 *power(p, 4) *q *r *power(s, 5)  -
        1299804687500 *p *power(q, 3) *r *power(s, 5)  +
        332421875000 *power(p, 2) *q *power(r, 2) *power(s, 5)  -
        1195312500000 *q *power(r, 3) *power(s, 5)  +  72021484375 *power(p, 5) *power(s, 6)  +
        323486328125 *power(p, 2) *power(q, 2) *power(s, 6)  +  682373046875 *power(p, 3) *r *power(s, 6)  +
        2447509765625 *power(q, 2) *r *power(s, 6)  -  3011474609375 *p *power(r, 2) *power(s, 6)  +
        3051757812500 *p *q *power(s, 7)  -  7629394531250 *power(s, 8))

   b31 = (1500 *power(p, 9) *power(q, 6)  +  69625 *power(p, 6) *power(q, 8)  +  590375 *power(p, 3) *power(q, 10)  +
        1035000 *power(q, 12)  -    13500 *power(p, 10) *power(q, 4) *r  -
        760625 *power(p, 7) *power(q, 6) *r  -  7904500 *power(p, 4) *power(q, 8) *r  -
        18169250 *p *power(q, 10) *r  +  30375 *power(p, 11) *power(q, 2) *power(r, 2)  +
        2628625 *power(p, 8) *power(q, 4) *power(r, 2)  +    37879000 *power(p, 5) *power(q, 6) *power(r, 2)  +
        121367500 *power(p, 2) *power(q, 8) *power(r, 2)  -  2699250 *power(p, 9) *power(q, 2) *power(r, 3)  -
        76776875 *power(p, 6) *power(q, 4) *power(r, 3)  -  403583125 *power(p, 3) *power(q, 6) *power(r, 3)  -
        78865625 *power(q, 8) *power(r, 3)  +    60907500 *power(p, 7) *power(q, 2) *power(r, 4)  +
        735291250 *power(p, 4) *power(q, 4) *power(r, 4)  +  781142500 *p *power(q, 6) *power(r, 4)  -
        558270000 *power(p, 5) *power(q, 2) *power(r, 5)  -  2150725000 *power(p, 2) *power(q, 4) *power(r, 5)  +
        2015400000 *power(p, 3) *power(q, 2) *power(r, 6)  +   1181000000 *power(q, 4) *power(r, 6)  -
        2220000000 *p *power(q, 2) *power(r, 7)  +  40500 *power(p, 11) *power(q, 3) *s  +
        1376500 *power(p, 8) *power(q, 5) *s  +  9953125 *power(p, 5) *power(q, 7) *s  +
        9765625 *power(p, 2) *power(q, 9) *s  -    182250 *power(p, 12) *q *r *s  -
        8859000 *power(p, 9) *power(q, 3) *r *s  -  82854500 *power(p, 6) *power(q, 5) *r *s  -
        71511250 *power(p, 3) *power(q, 7) *r *s  +  273631250 *power(q, 9) *r *s  +
        10233000 *power(p, 10) *q *power(r, 2) *s  +    179627500 *power(p, 7) *power(q, 3) *power(r, 2) *s  +
        25164375 *power(p, 4) *power(q, 5) *power(r, 2) *s  -
        2927290625 *p *power(q, 7) *power(r, 2) *s  -  171305000 *power(p, 8) *q *power(r, 3) *s  -
        544768750 *power(p, 5) *power(q, 3) *power(r, 3) *s  +
        7583437500 *power(p, 2) *power(q, 5) *power(r, 3) *s  +   1139860000 *power(p, 6) *q *power(r, 4) *s  -
        6489375000 *power(p, 3) *power(q, 3) *power(r, 4) *s  -
        9625375000 *power(q, 5) *power(r, 4) *s  -  1838000000 *power(p, 4) *q *power(r, 5) *s  +
        19835000000 *p *power(q, 3) *power(r, 5) *s  -  3240000000 *power(p, 2) *q *power(r, 6) *s  +
        273375 *power(p, 13) *power(s, 2)  +   9753750 *power(p, 10) *power(q, 2) *power(s, 2)  +
        82575000 *power(p, 7) *power(q, 4) *power(s, 2)  +  202265625 *power(p, 4) *power(q, 6) *power(s, 2)  +
        556093750 *p *power(q, 8) *power(s, 2)  -  11552625 *power(p, 11) *r *power(s, 2)  -
        115813125 *power(p, 8) *power(q, 2) *r *power(s, 2)  +
        630590625 *power(p, 5) *power(q, 4) *r *power(s, 2)  +  1347015625 *power(p, 2) *power(q, 6) *r *power(s, 2)  +
        157578750 *power(p, 9) *power(r, 2) *power(s, 2)  -
        689206250 *power(p, 6) *power(q, 2) *power(r, 2) *power(s, 2)  -
        4299609375 *power(p, 3) *power(q, 4) *power(r, 2) *power(s, 2)  +  23896171875 *power(q, 6) *power(r, 2) *power(s, 2)  -
        1022437500 *power(p, 7) *power(r, 3) *power(s, 2)  +
        6648125000 *power(p, 4) *power(q, 2) *power(r, 3) *power(s, 2)  -
        52895312500 *p *power(q, 4) *power(r, 3) *power(s, 2)  +  4401750000 *power(p, 5) *power(r, 4) *power(s, 2)  +
        26500000000 *power(p, 2) *power(q, 2) *power(r, 4) *power(s, 2)  -
        22125000000 *power(p, 3) *power(r, 5) *power(s, 2)  -    1500000000 *power(q, 2) *power(r, 5) *power(s, 2)  +
        55500000000 *p *power(r, 6) *power(s, 2)  -  137109375 *power(p, 9) *q *power(s, 3)  -
        1955937500 *power(p, 6) *power(q, 3) *power(s, 3)  -  6790234375 *power(p, 3) *power(q, 5) *power(s, 3)  -
        16996093750 *power(q, 7) *power(s, 3)  +   2146218750 *power(p, 7) *q *r *power(s, 3)  +
        6570312500 *power(p, 4) *power(q, 3) *r *power(s, 3)  +
        39918750000 *p *power(q, 5) *r *power(s, 3)  -  7673281250 *power(p, 5) *q *power(r, 2) *power(s, 3)  -
        52000000000 *power(p, 2) *power(q, 3) *power(r, 2) *power(s, 3)  +
        50796875000 *power(p, 3) *q *power(r, 3) *power(s, 3)  +
        18750000000 *power(q, 3) *power(r, 3) *power(s, 3)  -  399875000000 *p *q *power(r, 4) *power(s, 3)  +
        780468750 *power(p, 8) *power(s, 4)  +    14455078125 *power(p, 5) *power(q, 2) *power(s, 4)  +
        10048828125 *power(p, 2) *power(q, 4) *power(s, 4)  -    15113671875 *power(p, 6) *r *power(s, 4)  +
        39298828125 *power(p, 3) *power(q, 2) *r *power(s, 4)  -
        52138671875 *power(q, 4) *r *power(s, 4)  +  45964843750 *power(p, 4) *power(r, 2) *power(s, 4)  +
        914414062500 *p *power(q, 2) *power(r, 2) *power(s, 4)  +  1953125000 *power(p, 2) *power(r, 3) *power(s, 4)  +
        334375000000 *power(r, 4) *power(s, 4)  -  149169921875 *power(p, 4) *q *power(s, 5)  -
        459716796875 *p *power(q, 3) *power(s, 5)  -
        325585937500 *power(p, 2) *q *r *power(s, 5)  -  1462890625000 *q *power(r, 2) *power(s, 5)  +
        296630859375 *power(p, 3) *power(s, 6)  +  1324462890625 *power(q, 2) *power(s, 6)  +
        307617187500 *p *r *power(s, 6))

   b32 = (-20750 *power(p, 7) *power(q, 6)  -  290125 *power(p, 4) *power(q, 8)  -  993000 *p *power(q, 10)  +
        146125 *power(p, 8) *power(q, 4) *r  +    2721500 *power(p, 5) *power(q, 6) *r  +
        11833750 *power(p, 2) *power(q, 8) *r  -  237375 *power(p, 9) *power(q, 2) *power(r, 2)  -
        8167500 *power(p, 6) *power(q, 4) *power(r, 2)  -  54605625 *power(p, 3) *power(q, 6) *power(r, 2)  -
        23802500 *power(q, 8) *power(r, 2)  +    8927500 *power(p, 7) *power(q, 2) *power(r, 3)  +
        131184375 *power(p, 4) *power(q, 4) *power(r, 3)  +  254695000 *p *power(q, 6) *power(r, 3)  -
        121561250 *power(p, 5) *power(q, 2) *power(r, 4)  -  728003125 *power(p, 2) *power(q, 4) *power(r, 4)  +
        702550000 *power(p, 3) *power(q, 2) *power(r, 5)  +    597312500 *power(q, 4) *power(r, 5)  -
        1202500000 *p *power(q, 2) *power(r, 6)  -  194625 *power(p, 9) *power(q, 3) *s  -
        1568875 *power(p, 6) *power(q, 5) *s  +  9685625 *power(p, 3) *power(q, 7) *s  +
        74662500 *power(q, 9) *s  +    327375 *power(p, 10) *q *r *s  +
        1280000 *power(p, 7) *power(q, 3) *r *s  -  123703750 *power(p, 4) *power(q, 5) *r *s  -
        850121875 *p *power(q, 7) *r *s  -  7436250 *power(p, 8) *q *power(r, 2) *s  +
        164820000 *power(p, 5) *power(q, 3) *power(r, 2) *s  +
        2336659375 *power(p, 2) *power(q, 5) *power(r, 2) *s  +  32202500 *power(p, 6) *q *power(r, 3) *s  -
        2429765625 *power(p, 3) *power(q, 3) *power(r, 3) *s  -  4318609375 *power(q, 5) *power(r, 3) *s  +
        148000000 *power(p, 4) *q *power(r, 4) *s  +  9902812500 *p *power(q, 3) *power(r, 4) *s  -
        1755000000 *power(p, 2) *q *power(r, 5) *s  +  1154250 *power(p, 11) *power(s, 2)  +
        36821250 *power(p, 8) *power(q, 2) *power(s, 2)  +    372825000 *power(p, 5) *power(q, 4) *power(s, 2)  +
        1170921875 *power(p, 2) *power(q, 6) *power(s, 2)  -  38913750 *power(p, 9) *r *power(s, 2)  -
        797071875 *power(p, 6) *power(q, 2) *r *power(s, 2)  -  2848984375 *power(p, 3) *power(q, 4) *r *power(s, 2)  +
        7651406250 *power(q, 6) *r *power(s, 2)  +  415068750 *power(p, 7) *power(r, 2) *power(s, 2)  +
        3151328125 *power(p, 4) *power(q, 2) *power(r, 2) *power(s, 2)  -
        17696875000 *p *power(q, 4) *power(r, 2) *power(s, 2)  -
        725968750 *power(p, 5) *power(r, 3) *power(s, 2)  +  5295312500 *power(p, 2) *power(q, 2) *power(r, 3) *power(s, 2)  -
        8581250000 *power(p, 3) *power(r, 4) *power(s, 2)  -  812500000 *power(q, 2) *power(r, 4) *power(s, 2)  +
        30062500000 *p *power(r, 5) *power(s, 2)  -    110109375 *power(p, 7) *q *power(s, 3)  -
        1976562500 *power(p, 4) *power(q, 3) *power(s, 3)  -  6329296875 *p *power(q, 5) *power(s, 3)  +
        2256328125 *power(p, 5) *q *r *power(s, 3)  +  8554687500 *power(p, 2) *power(q, 3) *r *power(s, 3)  +
        12947265625 *power(p, 3) *q *power(r, 2) *power(s, 3)  +  7984375000 *power(q, 3) *power(r, 2) *power(s, 3)  -
        167039062500 *p *q *power(r, 3) *power(s, 3)  +  1181250000 *power(p, 6) *power(s, 4)  +
        17873046875 *power(p, 3) *power(q, 2) *power(s, 4)  -  20449218750 *power(q, 4) *power(s, 4)  -
        16265625000 *power(p, 4) *r *power(s, 4)  +    260869140625 *p *power(q, 2) *r *power(s, 4)  +
        21025390625 *power(p, 2) *power(r, 2) *power(s, 4)  +    207617187500 *power(r, 3) *power(s, 4)  -
        207177734375 *power(p, 2) *q *power(s, 5)  -  615478515625 *q *r *power(s, 5)  +
        301513671875 *p *power(s, 6))

   b33 = (53125 *power(p, 5) *power(q, 6)  +  425000 *power(p, 2) *power(q, 8)  -  394375 *power(p, 6) *power(q, 4) *r  -
        4301875 *power(p, 3) *power(q, 6) *r  -    3225000 *power(q, 8) *r  +
        851250 *power(p, 7) *power(q, 2) *power(r, 2)  +  16910625 *power(p, 4) *power(q, 4) *power(r, 2)  +
        44210000 *p *power(q, 6) *power(r, 2)  -  20474375 *power(p, 5) *power(q, 2) *power(r, 3)  -
        147190625 *power(p, 2) *power(q, 4) *power(r, 3)  +    163975000 *power(p, 3) *power(q, 2) *power(r, 4)  +
        156812500 *power(q, 4) *power(r, 4)  -  323750000 *p *power(q, 2) *power(r, 5)  -
        99375 *power(p, 7) *power(q, 3) *s  -  6395000 *power(p, 4) *power(q, 5) *s  -
        49243750 *p *power(q, 7) *s  -   1164375 *power(p, 8) *q *r *s  +
        4465625 *power(p, 5) *power(q, 3) *r *s  +  205546875 *power(p, 2) *power(q, 5) *r *s  +
        12163750 *power(p, 6) *q *power(r, 2) *s  -  315546875 *power(p, 3) *power(q, 3) *power(r, 2) *s  -
        946453125 *power(q, 5) *power(r, 2) *s  -   23500000 *power(p, 4) *q *power(r, 3) *s  +
        2313437500 *p *power(q, 3) *power(r, 3) *s  -  472500000 *power(p, 2) *q *power(r, 4) *s  +
        1316250 *power(p, 9) *power(s, 2)  +  22715625 *power(p, 6) *power(q, 2) *power(s, 2)  +
        206953125 *power(p, 3) *power(q, 4) *power(s, 2)  +   1220000000 *power(q, 6) *power(s, 2)  -
        20953125 *power(p, 7) *r *power(s, 2)  -  277656250 *power(p, 4) *power(q, 2) *r *power(s, 2)  -
        3317187500 *p *power(q, 4) *r *power(s, 2)  +  293734375 *power(p, 5) *power(r, 2) *power(s, 2)  +
        1351562500 *power(p, 2) *power(q, 2) *power(r, 2) *power(s, 2)  -  2278125000 *power(p, 3) *power(r, 3) *power(s, 2)  -
        218750000 *power(q, 2) *power(r, 3) *power(s, 2)  +  8093750000 *p *power(r, 4) *power(s, 2)  -
        9609375 *power(p, 5) *q *power(s, 3)  +   240234375 *power(p, 2) *power(q, 3) *power(s, 3)  +
        2310546875 *power(p, 3) *q *r *power(s, 3)  +  1171875000 *power(q, 3) *r *power(s, 3)  -
        33460937500 *p *q *power(r, 2) *power(s, 3)  +  2185546875 *power(p, 4) *power(s, 4)  +
        32578125000 *p *power(q, 2) *power(s, 4)  -   8544921875 *power(p, 2) *r *power(s, 4)  +
        58398437500 *power(r, 2) *power(s, 4)  -  114013671875 *q *power(s, 5))

   b34 = (-16250 *power(p, 6) *power(q, 4)  -  191875 *power(p, 3) *power(q, 6)  -  495000 *power(q, 8)  +
        73125 *power(p, 7) *power(q, 2) *r  +   1437500 *power(p, 4) *power(q, 4) *r  +
        5866250 *p *power(q, 6) *r  -  2043125 *power(p, 5) *power(q, 2) *power(r, 2)  -
        17218750 *power(p, 2) *power(q, 4) *power(r, 2)  +  19106250 *power(p, 3) *power(q, 2) *power(r, 3)  +
        34015625 *power(q, 4) *power(r, 3)  -   69375000 *p *power(q, 2) *power(r, 4)  -
        219375 *power(p, 8) *q *s  -  2846250 *power(p, 5) *power(q, 3) *s  -
        8021875 *power(p, 2) *power(q, 5) *s  +  3420000 *power(p, 6) *q *r *s  -
        1640625 *power(p, 3) *power(q, 3) *r *s  -    152468750 *power(q, 5) *r *s  +
        3062500 *power(p, 4) *q *power(r, 2) *s  +  381171875 *p *power(q, 3) *power(r, 2) *s  -
        101250000 *power(p, 2) *q *power(r, 3) *s  +  2784375 *power(p, 7) *power(s, 2)  +
        43515625 *power(p, 4) *power(q, 2) *power(s, 2)  +    115625000 *p *power(q, 4) *power(s, 2)  -
        48140625 *power(p, 5) *r *power(s, 2)  -  307421875 *power(p, 2) *power(q, 2) *r *power(s, 2)  -
        25781250 *power(p, 3) *power(r, 2) *power(s, 2)  -  46875000 *power(q, 2) *power(r, 2) *power(s, 2)  +
        1734375000 *p *power(r, 3) *power(s, 2)  -    128906250 *power(p, 3) *q *power(s, 3)  +
        339843750 *power(q, 3) *power(s, 3)  -  4583984375 *p *q *r *power(s, 3)  +
        2236328125 *power(p, 2) *power(s, 4)  +  12255859375 *r *power(s, 4))

   b35 = (31875 *power(p, 4) *power(q, 4)  +  255000 *p *power(q, 6)  -  82500 *power(p, 5) *power(q, 2) *r  -
        1106250 *power(p, 2) *power(q, 4) *r  +   1653125 *power(p, 3) *power(q, 2) *power(r, 2)  +
        5187500 *power(q, 4) *power(r, 2)  -  11562500 *p *power(q, 2) *power(r, 3)  -
        118125 *power(p, 6) *q *s  -  3593750 *power(p, 3) *power(q, 3) *s  -
        23812500 *power(q, 5) *s  +   4656250 *power(p, 4) *q *r *s  +
        67109375 *p *power(q, 3) *r *s  -  16875000 *power(p, 2) *q *power(r, 2) *s  -
        984375 *power(p, 5) *power(s, 2)  -  19531250 *power(p, 2) *power(q, 2) *power(s, 2)  -
        37890625 *power(p, 3) *r *power(s, 2)  -   7812500 *power(q, 2) *r *power(s, 2)  +
        289062500 *p *power(r, 2) *power(s, 2)  -  529296875 *p *q *power(s, 3)  +
        2343750000 *power(s, 4))

   b40 = (600 *power(p, 10) *power(q, 10)  +  13850 *power(p, 7) *power(q, 12)  +  106150 *power(p, 4) *power(q, 14)  +
        270000 *p *power(q, 16)  -   9300 *power(p, 11) *power(q, 8) *r  -
        234075 *power(p, 8) *power(q, 10) *r  -  1942825 *power(p, 5) *power(q, 12) *r  -
        5319900 *power(p, 2) *power(q, 14) *r  +  52050 *power(p, 12) *power(q, 6) *power(r, 2)  +
        1481025 *power(p, 9) *power(q, 8) *power(r, 2)  +   13594450 *power(p, 6) *power(q, 10) *power(r, 2)  +
        40062750 *power(p, 3) *power(q, 12) *power(r, 2)  -  3569400 *power(q, 14) *power(r, 2)  -
        122175 *power(p, 13) *power(q, 4) *power(r, 3)  -  4260350 *power(p, 10) *power(q, 6) *power(r, 3)  -
        45052375 *power(p, 7) *power(q, 8) *power(r, 3)  -   142634900 *power(p, 4) *power(q, 10) *power(r, 3)  +
        54186350 *p *power(q, 12) *power(r, 3)  +  97200 *power(p, 14) *power(q, 2) *power(r, 4)  +
        5284225 *power(p, 11) *power(q, 4) *power(r, 4)  +  70389525 *power(p, 8) *power(q, 6) *power(r, 4)  +
        232732850 *power(p, 5) *power(q, 8) *power(r, 4)  -   318849400 *power(p, 2) *power(q, 10) *power(r, 4)  -
        2046000 *power(p, 12) *power(q, 2) *power(r, 5)  -  43874125 *power(p, 9) *power(q, 4) *power(r, 5)  -
        107411850 *power(p, 6) *power(q, 6) *power(r, 5)  +  948310700 *power(p, 3) *power(q, 8) *power(r, 5)  -
        34763575 *power(q, 10) *power(r, 5)  +   5915600 *power(p, 10) *power(q, 2) *power(r, 6)  -
        115887800 *power(p, 7) *power(q, 4) *power(r, 6)  -  1649542400 *power(p, 4) *power(q, 6) *power(r, 6)  +
        224468875 *p *power(q, 8) *power(r, 6)  +  120252800 *power(p, 8) *power(q, 2) *power(r, 7)  +
        1779902000 *power(p, 5) *power(q, 4) *power(r, 7)  -   288250000 *power(p, 2) *power(q, 6) *power(r, 7)  -
        915200000 *power(p, 6) *power(q, 2) *power(r, 8)  -  1164000000 *power(p, 3) *power(q, 4) *power(r, 8)  -
        444200000 *power(q, 6) *power(r, 8)  +  2502400000 *power(p, 4) *power(q, 2) *power(r, 9)  +
        1984000000 *p *power(q, 4) *power(r, 9)  -   2880000000 *power(p, 2) *power(q, 2) *power(r, 10)  +
        20700 *power(p, 12) *power(q, 7) *s  +  551475 *power(p, 9) *power(q, 9) *s  +
        5194875 *power(p, 6) *power(q, 11) *s  +  18985000 *power(p, 3) *power(q, 13) *s  +
        16875000 *power(q, 15) *s  -    218700 *power(p, 13) *power(q, 5) *r *s  -
        6606475 *power(p, 10) *power(q, 7) *r *s  -  69770850 *power(p, 7) *power(q, 9) *r *s  -
        285325500 *power(p, 4) *power(q, 11) *r *s  -  292005000 *p *power(q, 13) *r *s  +
        694575 *power(p, 14) *power(q, 3) *power(r, 2) *s  +    26187750 *power(p, 11) *power(q, 5) *power(r, 2) *s  +
        328992825 *power(p, 8) *power(q, 7) *power(r, 2) *s  +
        1573292400 *power(p, 5) *power(q, 9) *power(r, 2) *s  +  1930043875 *power(p, 2) *power(q, 11) *power(r, 2) *s  -
        583200 *power(p, 15) *q *power(r, 3) *s  -  37263225 *power(p, 12) *power(q, 3) *power(r, 3) *s  -
        638579425 *power(p, 9) *power(q, 5) *power(r, 3) *s  -
        3920212225 *power(p, 6) *power(q, 7) *power(r, 3) *s  -
        6327336875 *power(p, 3) *power(q, 9) *power(r, 3) *s  +  440969375 *power(q, 11) *power(r, 3) *s  +
        13446000 *power(p, 13) *q *power(r, 4) *s  +  462330325 *power(p, 10) *power(q, 3) *power(r, 4) *s  +
        4509088275 *power(p, 7) *power(q, 5) *power(r, 4) *s  +
        11709795625 *power(p, 4) *power(q, 7) *power(r, 4) *s  -
        3579565625 *p *power(q, 9) *power(r, 4) *s  -  85033600 *power(p, 11) *q *power(r, 5) *s  -
        2136801600 *power(p, 8) *power(q, 3) *power(r, 5) *s  -
        12221575800 *power(p, 5) *power(q, 5) *power(r, 5) *s  +
        9431044375 *power(p, 2) *power(q, 7) *power(r, 5) *s  +  10643200 *power(p, 9) *q *power(r, 6) *s  +
        4565594000 *power(p, 6) *power(q, 3) *power(r, 6) *s  -
        1778590000 *power(p, 3) *power(q, 5) *power(r, 6) *s  +    4842175000 *power(q, 7) *power(r, 6) *s  +
        712320000 *power(p, 7) *q *power(r, 7) *s  -
        16182000000 *power(p, 4) *power(q, 3) *power(r, 7) *s  -  21918000000 *p *power(q, 5) *power(r, 7) *s  -
        742400000 *power(p, 5) *q *power(r, 8) *s  +
        31040000000 *power(p, 2) *power(q, 3) *power(r, 8) *s  +
        1280000000 *power(p, 3) *q *power(r, 9) *s  +  4800000000 *power(q, 3) *power(r, 9) *s  +
        230850 *power(p, 14) *power(q, 4) *power(s, 2)  +    7373250 *power(p, 11) *power(q, 6) *power(s, 2)  +
        85045625 *power(p, 8) *power(q, 8) *power(s, 2)  +  399140625 *power(p, 5) *power(q, 10) *power(s, 2)  +
        565031250 *power(p, 2) *power(q, 12) *power(s, 2)  -  1257525 *power(p, 15) *power(q, 2) *r *power(s, 2)  -
        52728975 *power(p, 12) *power(q, 4) *r *power(s, 2)  -  743466375 *power(p, 9) *power(q, 6) *r *power(s, 2)  -
        4144915000 *power(p, 6) *power(q, 8) *r *power(s, 2)  -
        7102690625 *power(p, 3) *power(q, 10) *r *power(s, 2)  -
        1389937500 *power(q, 12) *r *power(s, 2)  +  874800 *power(p, 16) *power(r, 2) *power(s, 2)  +
        89851275 *power(p, 13) *power(q, 2) *power(r, 2) *power(s, 2)  +
        1897236775 *power(p, 10) *power(q, 4) *power(r, 2) *power(s, 2)  +
        14144163000 *power(p, 7) *power(q, 6) *power(r, 2) *power(s, 2)  +
        31942921875 *power(p, 4) *power(q, 8) *power(r, 2) *power(s, 2)  +
        13305118750 *p *power(q, 10) *power(r, 2) *power(s, 2)  -  23004000 *power(p, 14) *power(r, 3) *power(s, 2)  -
        1450715475 *power(p, 11) *power(q, 2) *power(r, 3) *power(s, 2)  -
        19427105000 *power(p, 8) *power(q, 4) *power(r, 3) *power(s, 2)  -
        70634028750 *power(p, 5) *power(q, 6) *power(r, 3) *power(s, 2)  -
        47854218750 *power(p, 2) *power(q, 8) *power(r, 3) *power(s, 2)  +
        204710400 *power(p, 12) *power(r, 4) *power(s, 2)  +  10875135000 *power(p, 9) *power(q, 2) *power(r, 4) *power(s, 2)  +
        83618806250 *power(p, 6) *power(q, 4) *power(r, 4) *power(s, 2)  +
        62744500000 *power(p, 3) *power(q, 6) *power(r, 4) *power(s, 2)  -
        19806718750 *power(q, 8) *power(r, 4) *power(s, 2)  -  757094800 *power(p, 10) *power(r, 5) *power(s, 2)  -
        37718030000 *power(p, 7) *power(q, 2) *power(r, 5) *power(s, 2)  -
        22479500000 *power(p, 4) *power(q, 4) *power(r, 5) *power(s, 2)  +
        91556093750 *p *power(q, 6) *power(r, 5) *power(s, 2)  +  2306320000 *power(p, 8) *power(r, 6) *power(s, 2)  +
        55539600000 *power(p, 5) *power(q, 2) *power(r, 6) *power(s, 2)  -
        112851250000 *power(p, 2) *power(q, 4) *power(r, 6) *power(s, 2)  -
        10720000000 *power(p, 6) *power(r, 7) *power(s, 2)  -  64720000000 *power(p, 3) *power(q, 2) *power(r, 7) *power(s, 2)  -
        59925000000 *power(q, 4) *power(r, 7) *power(s, 2)  +
        28000000000 *power(p, 4) *power(r, 8) *power(s, 2)  +
        28000000000 *p *power(q, 2) *power(r, 8) *power(s, 2)  -  24000000000 *power(p, 2) *power(r, 9) *power(s, 2)  +
        820125 *power(p, 16) *q *power(s, 3)  +  36804375 *power(p, 13) *power(q, 3) *power(s, 3)  +
        552225000 *power(p, 10) *power(q, 5) *power(s, 3)  +    3357593750 *power(p, 7) *power(q, 7) *power(s, 3)  +
        7146562500 *power(p, 4) *power(q, 9) *power(s, 3)  +    3851562500 *p *power(q, 11) *power(s, 3)  -
        92400750 *power(p, 14) *q *r *power(s, 3)  -
        2350175625 *power(p, 11) *power(q, 3) *r *power(s, 3)  -  19470640625 *power(p, 8) *power(q, 5) *r *power(s, 3)  -
        52820593750 *power(p, 5) *power(q, 7) *r *power(s, 3)  -
        45447734375 *power(p, 2) *power(q, 9) *r *power(s, 3)  +
        1824363000 *power(p, 12) *q *power(r, 2) *power(s, 3)  +
        31435234375 *power(p, 9) *power(q, 3) *power(r, 2) *power(s, 3)  +
        141717537500 *power(p, 6) *power(q, 5) *power(r, 2) *power(s, 3)  +
        228370781250 *power(p, 3) *power(q, 7) *power(r, 2) *power(s, 3)  +
        34610078125 *power(q, 9) *power(r, 2) *power(s, 3)  -  17591825625 *power(p, 10) *q *power(r, 3) *power(s, 3)  -
        188927187500 *power(p, 7) *power(q, 3) *power(r, 3) *power(s, 3)  -
        502088984375 *power(p, 4) *power(q, 5) *power(r, 3) *power(s, 3)  -
        187849296875 *p *power(q, 7) *power(r, 3) *power(s, 3)  +
        75577750000 *power(p, 8) *q *power(r, 4) *power(s, 3)  +
        342800000000 *power(p, 5) *power(q, 3) *power(r, 4) *power(s, 3)  +
        295384296875 *power(p, 2) *power(q, 5) *power(r, 4) *power(s, 3)  -
        107681250000 *power(p, 6) *q *power(r, 5) *power(s, 3)  +
        53330000000 *power(p, 3) *power(q, 3) *power(r, 5) *power(s, 3)  +
        271586875000 *power(q, 5) *power(r, 5) *power(s, 3)  -  26410000000 *power(p, 4) *q *power(r, 6) *power(s, 3)  -
        188200000000 *p *power(q, 3) *power(r, 6) *power(s, 3)  +
        92000000000 *power(p, 2) *q *power(r, 7) *power(s, 3)  +
        120000000000 *q *power(r, 8) *power(s, 3)  +  47840625 *power(p, 15) *power(s, 4)  +
        1150453125 *power(p, 12) *power(q, 2) *power(s, 4)  +    9229453125 *power(p, 9) *power(q, 4) *power(s, 4)  +
        24954687500 *power(p, 6) *power(q, 6) *power(s, 4)  +
        22978515625 *power(p, 3) *power(q, 8) *power(s, 4)  +  1367187500 *power(q, 10) *power(s, 4)  -
        1193737500 *power(p, 13) *r *power(s, 4)  -
        20817843750 *power(p, 10) *power(q, 2) *r *power(s, 4)  -
        98640000000 *power(p, 7) *power(q, 4) *r *power(s, 4)  -
        225767187500 *power(p, 4) *power(q, 6) *r *power(s, 4)  -  74707031250 *p *power(q, 8) *r *power(s, 4)  +
        13431318750 *power(p, 11) *power(r, 2) *power(s, 4)  +
        188709843750 *power(p, 8) *power(q, 2) *power(r, 2) *power(s, 4)  +
        875157656250 *power(p, 5) *power(q, 4) *power(r, 2) *power(s, 4)  +
        593812890625 *power(p, 2) *power(q, 6) *power(r, 2) *power(s, 4)  -
        69869296875 *power(p, 9) *power(r, 3) *power(s, 4)  -  854811093750 *power(p, 6) *power(q, 2) *power(r, 3) *power(s, 4)  -
        1730658203125 *power(p, 3) *power(q, 4) *power(r, 3) *power(s, 4)  -
        570867187500 *power(q, 6) *power(r, 3) *power(s, 4)  +
        162075625000 *power(p, 7) *power(r, 4) *power(s, 4)  +
        1536375000000 *power(p, 4) *power(q, 2) *power(r, 4) *power(s, 4)  +
        765156250000 *p *power(q, 4) *power(r, 4) *power(s, 4)  -  165988750000 *power(p, 5) *power(r, 5) *power(s, 4)  -
        728968750000 *power(p, 2) *power(q, 2) *power(r, 5) *power(s, 4)  +
        121500000000 *power(p, 3) *power(r, 6) *power(s, 4)  -
        1039375000000 *power(q, 2) *power(r, 6) *power(s, 4)  -  100000000000 *p *power(r, 7) *power(s, 4)  -
        379687500 *power(p, 11) *q *power(s, 5)  -  11607421875 *power(p, 8) *power(q, 3) *power(s, 5)  -
        20830078125 *power(p, 5) *power(q, 5) *power(s, 5)  -  33691406250 *power(p, 2) *power(q, 7) *power(s, 5)  -
        41491406250 *power(p, 9) *q *r *power(s, 5)  -
        419054687500 *power(p, 6) *power(q, 3) *r *power(s, 5)  -
        129511718750 *power(p, 3) *power(q, 5) *r *power(s, 5)  +  311767578125 *power(q, 7) *r *power(s, 5)  +
        620116015625 *power(p, 7) *q *power(r, 2) *power(s, 5)  +
        1154687500000 *power(p, 4) *power(q, 3) *power(r, 2) *power(s, 5)  +
        36455078125 *p *power(q, 5) *power(r, 2) *power(s, 5)  -
        2265953125000 *power(p, 5) *q *power(r, 3) *power(s, 5)  -
        1509521484375 *power(p, 2) *power(q, 3) *power(r, 3) *power(s, 5)  +
        2530468750000 *power(p, 3) *q *power(r, 4) *power(s, 5)  +
        3259765625000 *power(q, 3) *power(r, 4) *power(s, 5)  +  93750000000 *p *q *power(r, 5) *power(s, 5)  +
        23730468750 *power(p, 10) *power(s, 6)  +  243603515625 *power(p, 7) *power(q, 2) *power(s, 6)  +
        341552734375 *power(p, 4) *power(q, 4) *power(s, 6)  -  12207031250 *p *power(q, 6) *power(s, 6)  -
        357099609375 *power(p, 8) *r *power(s, 6)  -
        298193359375 *power(p, 5) *power(q, 2) *r *power(s, 6)  +
        406738281250 *power(p, 2) *power(q, 4) *r *power(s, 6)  +  1615683593750 *power(p, 6) *power(r, 2) *power(s, 6)  +
        558593750000 *power(p, 3) *power(q, 2) *power(r, 2) *power(s, 6)  -
        2811035156250 *power(q, 4) *power(r, 2) *power(s, 6)  -
        2960937500000 *power(p, 4) *power(r, 3) *power(s, 6)  -
        3802246093750 *p *power(q, 2) *power(r, 3) *power(s, 6)  +
        2347656250000 *power(p, 2) *power(r, 4) *power(s, 6)  -  671875000000 *power(r, 5) *power(s, 6)  -
        651855468750 *power(p, 6) *q *power(s, 7)  -  1458740234375 *power(p, 3) *power(q, 3) *power(s, 7)  -
        152587890625 *power(q, 5) *power(s, 7)  +  1628417968750 *power(p, 4) *q *r *power(s, 7)  +
        3948974609375 *p *power(q, 3) *r *power(s, 7)  -
        916748046875 *power(p, 2) *q *power(r, 2) *power(s, 7)  +
        1611328125000 *q *power(r, 3) *power(s, 7)  +  640869140625 *power(p, 5) *power(s, 8)  +
        1068115234375 *power(p, 2) *power(q, 2) *power(s, 8)  -  2044677734375 *power(p, 3) *r *power(s, 8)  -
        3204345703125 *power(q, 2) *r *power(s, 8)  +  1739501953125 *p *power(r, 2) *power(s, 8))

   b41 = (-600 *power(p, 11) *power(q, 8)  -  14050 *power(p, 8) *power(q, 10)  -  109100 *power(p, 5) *power(q, 12)  -
        280800 *power(p, 2) *power(q, 14)  +    7200 *power(p, 12) *power(q, 6) *r  +
        188700 *power(p, 9) *power(q, 8) *r  +  1621725 *power(p, 6) *power(q, 10) *r  +
        4577075 *power(p, 3) *power(q, 12) *r  +  5400 *power(q, 14) *r  -
        28350 *power(p, 13) *power(q, 4) *power(r, 2)  -   910600 *power(p, 10) *power(q, 6) *power(r, 2)  -
        9237975 *power(p, 7) *power(q, 8) *power(r, 2)  -  30718900 *power(p, 4) *power(q, 10) *power(r, 2)  -
        5575950 *p *power(q, 12) *power(r, 2)  +  36450 *power(p, 14) *power(q, 2) *power(r, 3)  +
        1848125 *power(p, 11) *power(q, 4) *power(r, 3)  +    25137775 *power(p, 8) *power(q, 6) *power(r, 3)  +
        109591450 *power(p, 5) *power(q, 8) *power(r, 3)  +  70627650 *power(p, 2) *power(q, 10) *power(r, 3)  -
        1317150 *power(p, 12) *power(q, 2) *power(r, 4)  -  32857100 *power(p, 9) *power(q, 4) *power(r, 4)  -
        219125575 *power(p, 6) *power(q, 6) *power(r, 4)  -    327565875 *power(p, 3) *power(q, 8) *power(r, 4)  -
        13011875 *power(q, 10) *power(r, 4)  +  16484150 *power(p, 10) *power(q, 2) *power(r, 5)  +
        222242250 *power(p, 7) *power(q, 4) *power(r, 5)  +  642173750 *power(p, 4) *power(q, 6) *power(r, 5)  +
        101263750 *p *power(q, 8) *power(r, 5)  -    79345000 *power(p, 8) *power(q, 2) *power(r, 6)  -
        433180000 *power(p, 5) *power(q, 4) *power(r, 6)  -  93731250 *power(p, 2) *power(q, 6) *power(r, 6)  -
        74300000 *power(p, 6) *power(q, 2) *power(r, 7)  -  1057900000 *power(p, 3) *power(q, 4) *power(r, 7)  -
        591175000 *power(q, 6) *power(r, 7)  +    1891600000 *power(p, 4) *power(q, 2) *power(r, 8)  +
        2796000000 *p *power(q, 4) *power(r, 8)  -  4320000000 *power(p, 2) *power(q, 2) *power(r, 9)  -
        16200 *power(p, 13) *power(q, 5) *s  -  359500 *power(p, 10) *power(q, 7) *s  -
        2603825 *power(p, 7) *power(q, 9) *s  -    4590375 *power(p, 4) *power(q, 11) *s  +
        12352500 *p *power(q, 13) *s  +  121500 *power(p, 14) *power(q, 3) *r *s  +
        3227400 *power(p, 11) *power(q, 5) *r *s  +  27301725 *power(p, 8) *power(q, 7) *r *s  +
        59480975 *power(p, 5) *power(q, 9) *r *s  -    137308875 *power(p, 2) *power(q, 11) *r *s  -
        218700 *power(p, 15) *q *power(r, 2) *s  -  8903925 *power(p, 12) *power(q, 3) *power(r, 2) *s  -
        100918225 *power(p, 9) *power(q, 5) *power(r, 2) *s  -  325291300 *power(p, 6) *power(q, 7) *power(r, 2) *s  +
        365705000 *power(p, 3) *power(q, 9) *power(r, 2) *s  +  94342500 *power(q, 11) *power(r, 2) *s  +
        7632900 *power(p, 13) *q *power(r, 3) *s  +    162995400 *power(p, 10) *power(q, 3) *power(r, 3) *s  +
        974558975 *power(p, 7) *power(q, 5) *power(r, 3) *s  +
        930991250 *power(p, 4) *power(q, 7) *power(r, 3) *s  -  495368750 *p *power(q, 9) *power(r, 3) *s  -
        97344900 *power(p, 11) *q *power(r, 4) *s  -  1406739250 *power(p, 8) *power(q, 3) *power(r, 4) *s  -
        5572526250 *power(p, 5) *power(q, 5) *power(r, 4) *s  -
        1903987500 *power(p, 2) *power(q, 7) *power(r, 4) *s  +
        678550000 *power(p, 9) *q *power(r, 5) *s  +  8176215000 *power(p, 6) *power(q, 3) *power(r, 5) *s  +
        18082050000 *power(p, 3) *power(q, 5) *power(r, 5) *s  +  5435843750 *power(q, 7) *power(r, 5) *s  -
        2979800000 *power(p, 7) *q *power(r, 6) *s  -
        29163500000 *power(p, 4) *power(q, 3) *power(r, 6) *s  -
        27417500000 *p *power(q, 5) *power(r, 6) *s  +  6282400000 *power(p, 5) *q *power(r, 7) *s  +
        48690000000 *power(p, 2) *power(q, 3) *power(r, 7) *s  -
        2880000000 *power(p, 3) *q *power(r, 8) *s  +    7200000000 *power(q, 3) *power(r, 8) *s  -
        109350 *power(p, 15) *power(q, 2) *power(s, 2)  -  2405700 *power(p, 12) *power(q, 4) *power(s, 2)  -
        16125250 *power(p, 9) *power(q, 6) *power(s, 2)  -  4930000 *power(p, 6) *power(q, 8) *power(s, 2)  +
        201150000 *power(p, 3) *power(q, 10) *power(s, 2)  -    243000000 *power(q, 12) *power(s, 2)  +
        328050 *power(p, 16) *r *power(s, 2)  +  10552275 *power(p, 13) *power(q, 2) *r *power(s, 2)  +
        88019100 *power(p, 10) *power(q, 4) *r *power(s, 2)  -  4208625 *power(p, 7) *power(q, 6) *r *power(s, 2)  -
        1920390625 *power(p, 4) *power(q, 8) *r *power(s, 2)  +
        1759537500 *p *power(q, 10) *r *power(s, 2)  -    11955600 *power(p, 14) *power(r, 2) *power(s, 2)  -
        196375050 *power(p, 11) *power(q, 2) *power(r, 2) *power(s, 2)  -
        555196250 *power(p, 8) *power(q, 4) *power(r, 2) *power(s, 2)  +
        4213270000 *power(p, 5) *power(q, 6) *power(r, 2) *power(s, 2)  -
        157468750 *power(p, 2) *power(q, 8) *power(r, 2) *power(s, 2)  +  162656100 *power(p, 12) *power(r, 3) *power(s, 2)  +
        1880870000 *power(p, 9) *power(q, 2) *power(r, 3) *power(s, 2)  +
        753684375 *power(p, 6) *power(q, 4) *power(r, 3) *power(s, 2)  -
        25423062500 *power(p, 3) *power(q, 6) *power(r, 3) *power(s, 2)  -  14142031250 *power(q, 8) *power(r, 3) *power(s, 2)  -
        1251948750 *power(p, 10) *power(r, 4) *power(s, 2)  -
        12524475000 *power(p, 7) *power(q, 2) *power(r, 4) *power(s, 2)  +
        18067656250 *power(p, 4) *power(q, 4) *power(r, 4) *power(s, 2)  +
        60531875000 *p *power(q, 6) *power(r, 4) *power(s, 2)  +
        6827725000 *power(p, 8) *power(r, 5) *power(s, 2)  +  57157000000 *power(p, 5) *power(q, 2) *power(r, 5) *power(s, 2)  -
        75844531250 *power(p, 2) *power(q, 4) *power(r, 5) *power(s, 2)  -
        24452500000 *power(p, 6) *power(r, 6) *power(s, 2)  -
        144950000000 *power(p, 3) *power(q, 2) *power(r, 6) *power(s, 2)  -  82109375000 *power(q, 4) *power(r, 6) *power(s, 2)  +
        46950000000 *power(p, 4) *power(r, 7) *power(s, 2)  +
        60000000000 *p *power(q, 2) *power(r, 7) *power(s, 2)  -
        36000000000 *power(p, 2) *power(r, 8) *power(s, 2)  +  1549125 *power(p, 14) *q *power(s, 3)  +
        51873750 *power(p, 11) *power(q, 3) *power(s, 3)  +    599781250 *power(p, 8) *power(q, 5) *power(s, 3)  +
        2421156250 *power(p, 5) *power(q, 7) *power(s, 3)  -    1693515625 *power(p, 2) *power(q, 9) *power(s, 3)  -
        104884875 *power(p, 12) *q *r *power(s, 3)  -
        1937437500 *power(p, 9) *power(q, 3) *r *power(s, 3)  -  11461053125 *power(p, 6) *power(q, 5) *r *power(s, 3)  +
        10299375000 *power(p, 3) *power(q, 7) *r *power(s, 3)  +
        10551250000 *power(q, 9) *r *power(s, 3)  +
        1336263750 *power(p, 10) *q *power(r, 2) *power(s, 3)  +
        23737250000 *power(p, 7) *power(q, 3) *power(r, 2) *power(s, 3)  +
        57136718750 *power(p, 4) *power(q, 5) *power(r, 2) *power(s, 3)  -
        8288906250 *p *power(q, 7) *power(r, 2) *power(s, 3)  -
        10907218750 *power(p, 8) *q *power(r, 3) *power(s, 3)  -
        160615000000 *power(p, 5) *power(q, 3) *power(r, 3) *power(s, 3)  -
        111134687500 *power(p, 2) *power(q, 5) *power(r, 3) *power(s, 3)  +
        46743125000 *power(p, 6) *q *power(r, 4) *power(s, 3)  +
        570509375000 *power(p, 3) *power(q, 3) *power(r, 4) *power(s, 3)  +
        274839843750 *power(q, 5) *power(r, 4) *power(s, 3)  -
        73312500000 *power(p, 4) *q *power(r, 5) *power(s, 3)  -
        145437500000 *p *power(q, 3) *power(r, 5) *power(s, 3)  +
        8750000000 *power(p, 2) *q *power(r, 6) *power(s, 3)  +  180000000000 *q *power(r, 7) *power(s, 3)  +
        15946875 *power(p, 13) *power(s, 4)  +    1265625 *power(p, 10) *power(q, 2) *power(s, 4)  -
        3282343750 *power(p, 7) *power(q, 4) *power(s, 4)  -    38241406250 *power(p, 4) *power(q, 6) *power(s, 4)  -
        40136718750 *p *power(q, 8) *power(s, 4)  -  113146875 *power(p, 11) *r *power(s, 4)  -
        2302734375 *power(p, 8) *power(q, 2) *r *power(s, 4)  +  68450156250 *power(p, 5) *power(q, 4) *r *power(s, 4)  +
        177376562500 *power(p, 2) *power(q, 6) *r *power(s, 4)  +
        3164062500 *power(p, 9) *power(r, 2) *power(s, 4)  +
        14392890625 *power(p, 6) *power(q, 2) *power(r, 2) *power(s, 4)  -
        543781250000 *power(p, 3) *power(q, 4) *power(r, 2) *power(s, 4)  -
        319769531250 *power(q, 6) *power(r, 2) *power(s, 4)  -  21048281250 *power(p, 7) *power(r, 3) *power(s, 4)  -
        240687500000 *power(p, 4) *power(q, 2) *power(r, 3) *power(s, 4)  -
        228164062500 *p *power(q, 4) *power(r, 3) *power(s, 4)  +
        23062500000 *power(p, 5) *power(r, 4) *power(s, 4)  +  300410156250 *power(p, 2) *power(q, 2) *power(r, 4) *power(s, 4)  +
        93437500000 *power(p, 3) *power(r, 5) *power(s, 4)  -
        1141015625000 *power(q, 2) *power(r, 5) *power(s, 4)  -
        187500000000 *p *power(r, 6) *power(s, 4)  +  1761328125 *power(p, 9) *q *power(s, 5)  -
        3177734375 *power(p, 6) *power(q, 3) *power(s, 5)  +    60019531250 *power(p, 3) *power(q, 5) *power(s, 5)  +
        108398437500 *power(q, 7) *power(s, 5)  +    24106640625 *power(p, 7) *q *r *power(s, 5)  +
        429589843750 *power(p, 4) *power(q, 3) *r *power(s, 5)  +
        410371093750 *p *power(q, 5) *r *power(s, 5)  -  23582031250 *power(p, 5) *q *power(r, 2) *power(s, 5)  +
        202441406250 *power(p, 2) *power(q, 3) *power(r, 2) *power(s, 5)  -
        383203125000 *power(p, 3) *q *power(r, 3) *power(s, 5)  +
        2232910156250 *power(q, 3) *power(r, 3) *power(s, 5)  +  1500000000000 *p *q *power(r, 4) *power(s, 5)  -
        13710937500 *power(p, 8) *power(s, 6)  -  202832031250 *power(p, 5) *power(q, 2) *power(s, 6)  -
        531738281250 *power(p, 2) *power(q, 4) *power(s, 6)  +  73330078125 *power(p, 6) *r *power(s, 6)  -
        3906250000 *power(p, 3) *power(q, 2) *r *power(s, 6)  -
        1275878906250 *power(q, 4) *r *power(s, 6)  -
        121093750000 *power(p, 4) *power(r, 2) *power(s, 6)  -  3308593750000 *p *power(q, 2) *power(r, 2) *power(s, 6)  +
        18066406250 *power(p, 2) *power(r, 3) *power(s, 6)  -  244140625000 *power(r, 4) *power(s, 6)  +
        327148437500 *power(p, 4) *q *power(s, 7)  +  1672363281250 *p *power(q, 3) *power(s, 7)  +
        446777343750 *power(p, 2) *q *r *power(s, 7)  +
        1232910156250 *q *power(r, 2) *power(s, 7)  -    274658203125 *power(p, 3) *power(s, 8)  -
        1068115234375 *power(q, 2) *power(s, 8)  -  61035156250 *p *r *power(s, 8))

   b42 = (200 *power(p, 9) *power(q, 8)  +  7550 *power(p, 6) *power(q, 10)  +  78650 *power(p, 3) *power(q, 12)  +
        248400 *power(q, 14)  -    4800 *power(p, 10) *power(q, 6) *r  -
        164300 *power(p, 7) *power(q, 8) *r  -  1709575 *power(p, 4) *power(q, 10) *r  -
        5566500 *p *power(q, 12) *r  +  31050 *power(p, 11) *power(q, 4) *power(r, 2)  +
        1116175 *power(p, 8) *power(q, 6) *power(r, 2)  +    12674650 *power(p, 5) *power(q, 8) *power(r, 2)  +
        45333850 *power(p, 2) *power(q, 10) *power(r, 2)  -  60750 *power(p, 12) *power(q, 2) *power(r, 3)  -
        2872725 *power(p, 9) *power(q, 4) *power(r, 3)  -  40403050 *power(p, 6) *power(q, 6) *power(r, 3)  -
        173564375 *power(p, 3) *power(q, 8) *power(r, 3)  -    11242250 *power(q, 10) *power(r, 3)  +
        2174100 *power(p, 10) *power(q, 2) *power(r, 4)  +  54010000 *power(p, 7) *power(q, 4) *power(r, 4)  +
        331074875 *power(p, 4) *power(q, 6) *power(r, 4)  +  114173750 *p *power(q, 8) *power(r, 4)  -
        24858500 *power(p, 8) *power(q, 2) *power(r, 5)  -    300875000 *power(p, 5) *power(q, 4) *power(r, 5)  -
        319430625 *power(p, 2) *power(q, 6) *power(r, 5)  +  69810000 *power(p, 6) *power(q, 2) *power(r, 6)  -
        23900000 *power(p, 3) *power(q, 4) *power(r, 6)  -  294662500 *power(q, 6) *power(r, 6)  +
        524200000 *power(p, 4) *power(q, 2) *power(r, 7)  +    1432000000 *p *power(q, 4) *power(r, 7)  -
        2340000000 *power(p, 2) *power(q, 2) *power(r, 8)  +  5400 *power(p, 11) *power(q, 5) *s  +
        310400 *power(p, 8) *power(q, 7) *s  +  3591725 *power(p, 5) *power(q, 9) *s  +
        11556750 *power(p, 2) *power(q, 11) *s  -    105300 *power(p, 12) *power(q, 3) *r *s  -
        4234650 *power(p, 9) *power(q, 5) *r *s  -  49928875 *power(p, 6) *power(q, 7) *r *s  -
        174078125 *power(p, 3) *power(q, 9) *r *s  +  18000000 *power(q, 11) *r *s  +
        364500 *power(p, 13) *q *power(r, 2) *s  +    15763050 *power(p, 10) *power(q, 3) *power(r, 2) *s  +
        220187400 *power(p, 7) *power(q, 5) *power(r, 2) *s  +
        929609375 *power(p, 4) *power(q, 7) *power(r, 2) *s  -  43653125 *p *power(q, 9) *power(r, 2) *s  -
        13427100 *power(p, 11) *q *power(r, 3) *s  -   346066250 *power(p, 8) *power(q, 3) *power(r, 3) *s  -
        2287673375 *power(p, 5) *power(q, 5) *power(r, 3) *s  -
        1403903125 *power(p, 2) *power(q, 7) *power(r, 3) *s  +  184586000 *power(p, 9) *q *power(r, 4) *s  +
        2983460000 *power(p, 6) *power(q, 3) *power(r, 4) *s  +
        8725818750 *power(p, 3) *power(q, 5) *power(r, 4) *s  +    2527734375 *power(q, 7) *power(r, 4) *s  -
        1284480000 *power(p, 7) *q *power(r, 5) *s  -
        13138250000 *power(p, 4) *power(q, 3) *power(r, 5) *s  -  14001625000 *p *power(q, 5) *power(r, 5) *s  +
        4224800000 *power(p, 5) *q *power(r, 6) *s  +
        27460000000 *power(p, 2) *power(q, 3) *power(r, 6) *s  -
        3760000000 *power(p, 3) *q *power(r, 7) *s  +  3900000000 *power(q, 3) *power(r, 7) *s  +
        36450 *power(p, 13) *power(q, 2) *power(s, 2)  +    2765475 *power(p, 10) *power(q, 4) *power(s, 2)  +
        34027625 *power(p, 7) *power(q, 6) *power(s, 2)  +  97375000 *power(p, 4) *power(q, 8) *power(s, 2)  -
        88275000 *p *power(q, 10) *power(s, 2)  -  546750 *power(p, 14) *r *power(s, 2)  -
        21961125 *power(p, 11) *power(q, 2) *r *power(s, 2)  -
        273059375 *power(p, 8) *power(q, 4) *r *power(s, 2)  -  761562500 *power(p, 5) *power(q, 6) *r *power(s, 2)  +
        1869656250 *power(p, 2) *power(q, 8) *r *power(s, 2)  +  20545650 *power(p, 12) *power(r, 2) *power(s, 2)  +
        473934375 *power(p, 9) *power(q, 2) *power(r, 2) *power(s, 2)  +
        1758053125 *power(p, 6) *power(q, 4) *power(r, 2) *power(s, 2)  -
        8743359375 *power(p, 3) *power(q, 6) *power(r, 2) *power(s, 2)  -  4154375000 *power(q, 8) *power(r, 2) *power(s, 2)  -
        296559000 *power(p, 10) *power(r, 3) *power(s, 2)  -
        4065056250 *power(p, 7) *power(q, 2) *power(r, 3) *power(s, 2)  -
        186328125 *power(p, 4) *power(q, 4) *power(r, 3) *power(s, 2)  +  19419453125 *p *power(q, 6) *power(r, 3) *power(s, 2)  +
        2326262500 *power(p, 8) *power(r, 4) *power(s, 2)  +
        21189375000 *power(p, 5) *power(q, 2) *power(r, 4) *power(s, 2)  -
        26301953125 *power(p, 2) *power(q, 4) *power(r, 4) *power(s, 2)  -  10513250000 *power(p, 6) *power(r, 5) *power(s, 2)  -
        69937500000 *power(p, 3) *power(q, 2) *power(r, 5) *power(s, 2)  -
        42257812500 *power(q, 4) *power(r, 5) *power(s, 2)  +    23375000000 *power(p, 4) *power(r, 6) *power(s, 2)  +
        40750000000 *p *power(q, 2) *power(r, 6) *power(s, 2)  -
        19500000000 *power(p, 2) *power(r, 7) *power(s, 2)  +  4009500 *power(p, 12) *q *power(s, 3)  +
        36140625 *power(p, 9) *power(q, 3) *power(s, 3)  -    335459375 *power(p, 6) *power(q, 5) *power(s, 3)  -
        2695312500 *power(p, 3) *power(q, 7) *power(s, 3)  -  1486250000 *power(q, 9) *power(s, 3)  +
        102515625 *power(p, 10) *q *r *power(s, 3)  +  4006812500 *power(p, 7) *power(q, 3) *r *power(s, 3)  +
        27589609375 *power(p, 4) *power(q, 5) *r *power(s, 3)  +
        20195312500 *p *power(q, 7) *r *power(s, 3)  -
        2792812500 *power(p, 8) *q *power(r, 2) *power(s, 3)  -
        44115156250 *power(p, 5) *power(q, 3) *power(r, 2) *power(s, 3)  -
        72609453125 *power(p, 2) *power(q, 5) *power(r, 2) *power(s, 3)  +
        18752500000 *power(p, 6) *q *power(r, 3) *power(s, 3)  +
        218140625000 *power(p, 3) *power(q, 3) *power(r, 3) *power(s, 3)  +
        109940234375 *power(q, 5) *power(r, 3) *power(s, 3)  -
        21893750000 *power(p, 4) *q *power(r, 4) *power(s, 3)  -  65187500000 *p *power(q, 3) *power(r, 4) *power(s, 3)  -
        31000000000 *power(p, 2) *q *power(r, 5) *power(s, 3)  +
        97500000000 *q *power(r, 6) *power(s, 3)  -  86568750 *power(p, 11) *power(s, 4)  -
        1955390625 *power(p, 8) *power(q, 2) *power(s, 4)  -  8960781250 *power(p, 5) *power(q, 4) *power(s, 4)  -
        1357812500 *power(p, 2) *power(q, 6) *power(s, 4)  +  1657968750 *power(p, 9) *r *power(s, 4)  +
        10467187500 *power(p, 6) *power(q, 2) *r *power(s, 4)  -  55292968750 *power(p, 3) *power(q, 4) *r *power(s, 4)  -
        60683593750 *power(q, 6) *r *power(s, 4)  -  11473593750 *power(p, 7) *power(r, 2) *power(s, 4)  -
        123281250000 *power(p, 4) *power(q, 2) *power(r, 2) *power(s, 4)  -
        164912109375 *p *power(q, 4) *power(r, 2) *power(s, 4)  +
        13150000000 *power(p, 5) *power(r, 3) *power(s, 4)  +  190751953125 *power(p, 2) *power(q, 2) *power(r, 3) *power(s, 4)  +
        61875000000 *power(p, 3) *power(r, 4) *power(s, 4)  -
        467773437500 *power(q, 2) *power(r, 4) *power(s, 4)  -    118750000000 *p *power(r, 5) *power(s, 4)  +
        7583203125 *power(p, 7) *q *power(s, 5)  +    54638671875 *power(p, 4) *power(q, 3) *power(s, 5)  +
        39423828125 *p *power(q, 5) *power(s, 5)  +
        32392578125 *power(p, 5) *q *r *power(s, 5)  +  278515625000 *power(p, 2) *power(q, 3) *r *power(s, 5)  -
        298339843750 *power(p, 3) *q *power(r, 2) *power(s, 5)  +
        560791015625 *power(q, 3) *power(r, 2) *power(s, 5)  +
        720703125000 *p *q *power(r, 3) *power(s, 5)  -  19687500000 *power(p, 6) *power(s, 6)  -
        159667968750 *power(p, 3) *power(q, 2) *power(s, 6)  -  72265625000 *power(q, 4) *power(s, 6)  +
        116699218750 *power(p, 4) *r *power(s, 6)  -  924072265625 *p *power(q, 2) *r *power(s, 6)  -
        156005859375 *power(p, 2) *power(r, 2) *power(s, 6)  -  112304687500 *power(r, 3) *power(s, 6)  +
        349121093750 *power(p, 2) *q *power(s, 7)  +  396728515625 *q *r *power(s, 7)  -
        213623046875 *p *power(s, 8))

   b43 = (-600 *power(p, 10) *power(q, 6)  -  18450 *power(p, 7) *power(q, 8)  -  174000 *power(p, 4) *power(q, 10)  -
        518400 *p *power(q, 12)  +    5400 *power(p, 11) *power(q, 4) *r  +
        197550 *power(p, 8) *power(q, 6) *r  +  2147775 *power(p, 5) *power(q, 8) *r  +
        7219800 *power(p, 2) *power(q, 10) *r  -  12150 *power(p, 12) *power(q, 2) *power(r, 2)  -
        662200 *power(p, 9) *power(q, 4) *power(r, 2)  -    9274775 *power(p, 6) *power(q, 6) *power(r, 2)  -
        38330625 *power(p, 3) *power(q, 8) *power(r, 2)  -  5508000 *power(q, 10) *power(r, 2)  +
        656550 *power(p, 10) *power(q, 2) *power(r, 3)  +  16233750 *power(p, 7) *power(q, 4) *power(r, 3)  +
        97335875 *power(p, 4) *power(q, 6) *power(r, 3)  +    58271250 *p *power(q, 8) *power(r, 3)  -
        9845500 *power(p, 8) *power(q, 2) *power(r, 4)  -  119464375 *power(p, 5) *power(q, 4) *power(r, 4)  -
        194431875 *power(p, 2) *power(q, 6) *power(r, 4)  +  49465000 *power(p, 6) *power(q, 2) *power(r, 5)  +
        166000000 *power(p, 3) *power(q, 4) *power(r, 5)  -    80793750 *power(q, 6) *power(r, 5)  +
        54400000 *power(p, 4) *power(q, 2) *power(r, 6)  +  377750000 *p *power(q, 4) *power(r, 6)  -
        630000000 *power(p, 2) *power(q, 2) *power(r, 7)  -  16200 *power(p, 12) *power(q, 3) *s  -
        459300 *power(p, 9) *power(q, 5) *s  -    4207225 *power(p, 6) *power(q, 7) *s  -
        10827500 *power(p, 3) *power(q, 9) *s  +  13635000 *power(q, 11) *s  +
        72900 *power(p, 13) *q *r *s  +  2877300 *power(p, 10) *power(q, 3) *r *s  +
        33239700 *power(p, 7) *power(q, 5) *r *s  +    107080625 *power(p, 4) *power(q, 7) *r *s  -
        114975000 *p *power(q, 9) *r *s  -  3601800 *power(p, 11) *q *power(r, 2) *s  -
        75214375 *power(p, 8) *power(q, 3) *power(r, 2) *s  -  387073250 *power(p, 5) *power(q, 5) *power(r, 2) *s  +
        55540625 *power(p, 2) *power(q, 7) *power(r, 2) *s  +  53793000 *power(p, 9) *q *power(r, 3) *s  +
        687176875 *power(p, 6) *power(q, 3) *power(r, 3) *s  +
        1670018750 *power(p, 3) *power(q, 5) *power(r, 3) *s  +    665234375 *power(q, 7) *power(r, 3) *s  -
        391570000 *power(p, 7) *q *power(r, 4) *s  -  3420125000 *power(p, 4) *power(q, 3) *power(r, 4) *s  -
        3609625000 *p *power(q, 5) *power(r, 4) *s  +  1365600000 *power(p, 5) *q *power(r, 5) *s  +
        7236250000 *power(p, 2) *power(q, 3) *power(r, 5) *s  -
        1220000000 *power(p, 3) *q *power(r, 6) *s  +    1050000000 *power(q, 3) *power(r, 6) *s  -
        109350 *power(p, 14) *power(s, 2)  -  3065850 *power(p, 11) *power(q, 2) *power(s, 2)  -
        26908125 *power(p, 8) *power(q, 4) *power(s, 2)  -  44606875 *power(p, 5) *power(q, 6) *power(s, 2)  +
        269812500 *power(p, 2) *power(q, 8) *power(s, 2)  +    5200200 *power(p, 12) *r *power(s, 2)  +
        81826875 *power(p, 9) *power(q, 2) *r *power(s, 2)  +  155378125 *power(p, 6) *power(q, 4) *r *power(s, 2)  -
        1936203125 *power(p, 3) *power(q, 6) *r *power(s, 2)  -  998437500 *power(q, 8) *r *power(s, 2)  -
        77145750 *power(p, 10) *power(r, 2) *power(s, 2)  -
        745528125 *power(p, 7) *power(q, 2) *power(r, 2) *power(s, 2)  +  683437500 *power(p, 4) *power(q, 4) *power(r, 2) *power(s, 2)  +
        4083359375 *p *power(q, 6) *power(r, 2) *power(s, 2)  +  593287500 *power(p, 8) *power(r, 3) *power(s, 2)  +
        4799375000 *power(p, 5) *power(q, 2) *power(r, 3) *power(s, 2)  -
        4167578125 *power(p, 2) *power(q, 4) *power(r, 3) *power(s, 2)  -
        2731125000 *power(p, 6) *power(r, 4) *power(s, 2)  -  18668750000 *power(p, 3) *power(q, 2) *power(r, 4) *power(s, 2)  -
        10480468750 *power(q, 4) *power(r, 4) *power(s, 2)  +  6200000000 *power(p, 4) *power(r, 5) *power(s, 2)  +
        11750000000 *p *power(q, 2) *power(r, 5) *power(s, 2)  -
        5250000000 *power(p, 2) *power(r, 6) *power(s, 2)  +    26527500 *power(p, 10) *q *power(s, 3)  +
        526031250 *power(p, 7) *power(q, 3) *power(s, 3)  +  3160703125 *power(p, 4) *power(q, 5) *power(s, 3)  +
        2650312500 *p *power(q, 7) *power(s, 3)  -  448031250 *power(p, 8) *q *r *power(s, 3)  -
        6682968750 *power(p, 5) *power(q, 3) *r *power(s, 3)  -  11642812500 *power(p, 2) *power(q, 5) *r *power(s, 3)  +
        2553203125 *power(p, 6) *q *power(r, 2) *power(s, 3)  +
        37234375000 *power(p, 3) *power(q, 3) *power(r, 2) *power(s, 3)  +
        21871484375 *power(q, 5) *power(r, 2) *power(s, 3)  +  2803125000 *power(p, 4) *q *power(r, 3) *power(s, 3)  -
        10796875000 *p *power(q, 3) *power(r, 3) *power(s, 3)  -
        16656250000 *power(p, 2) *q *power(r, 4) *power(s, 3)  +
        26250000000 *q *power(r, 5) *power(s, 3)  -  75937500 *power(p, 9) *power(s, 4)  -
        704062500 *power(p, 6) *power(q, 2) *power(s, 4)  -    8363281250 *power(p, 3) *power(q, 4) *power(s, 4)  -
        10398437500 *power(q, 6) *power(s, 4)  +  197578125 *power(p, 7) *r *power(s, 4)  -
        16441406250 *power(p, 4) *power(q, 2) *r *power(s, 4)  -  24277343750 *p *power(q, 4) *r *power(s, 4)  -
        5716015625 *power(p, 5) *power(r, 2) *power(s, 4)  +
        31728515625 *power(p, 2) *power(q, 2) *power(r, 2) *power(s, 4)  +
        27031250000 *power(p, 3) *power(r, 3) *power(s, 4)  -  92285156250 *power(q, 2) *power(r, 3) *power(s, 4)  -
        33593750000 *p *power(r, 4) *power(s, 4)  +  10394531250 *power(p, 5) *q *power(s, 5)  +
        38037109375 *power(p, 2) *power(q, 3) *power(s, 5)  -  48144531250 *power(p, 3) *q *r *power(s, 5)  +
        74462890625 *power(q, 3) *r *power(s, 5)  +
        121093750000 *p *q *power(r, 2) *power(s, 5)  -  2197265625 *power(p, 4) *power(s, 6)  -
        92529296875 *p *power(q, 2) *power(s, 6)  +  15380859375 *power(p, 2) *r *power(s, 6)  -
        31738281250 *power(r, 2) *power(s, 6)  +    54931640625 *q *power(s, 7))

   b44 = (200 *power(p, 8) *power(q, 6)  +  2950 *power(p, 5) *power(q, 8)  +  10800 *power(p, 2) *power(q, 10)  -
        1800 *power(p, 9) *power(q, 4) *r  -    49650 *power(p, 6) *power(q, 6) *r  -
        403375 *power(p, 3) *power(q, 8) *r  -  999000 *power(q, 10) *r  +
        4050 *power(p, 10) *power(q, 2) *power(r, 2)  +    236625 *power(p, 7) *power(q, 4) *power(r, 2)  +
        3109500 *power(p, 4) *power(q, 6) *power(r, 2)  +  11463750 *p *power(q, 8) *power(r, 2)  -
        331500 *power(p, 8) *power(q, 2) *power(r, 3)  -  7818125 *power(p, 5) *power(q, 4) *power(r, 3)  -
        41411250 *power(p, 2) *power(q, 6) *power(r, 3)  +    4782500 *power(p, 6) *power(q, 2) *power(r, 4)  +
        47475000 *power(p, 3) *power(q, 4) *power(r, 4)  -  16728125 *power(q, 6) *power(r, 4)  -
        8700000 *power(p, 4) *power(q, 2) *power(r, 5)  +  81750000 *p *power(q, 4) *power(r, 5)  -
        135000000 *power(p, 2) *power(q, 2) *power(r, 6)  +    5400 *power(p, 10) *power(q, 3) *s  +
        144200 *power(p, 7) *power(q, 5) *s  +  939375 *power(p, 4) *power(q, 7) *s  +
        1012500 *p *power(q, 9) *s  -  24300 *power(p, 11) *q *r *s  -
        1169250 *power(p, 8) *power(q, 3) *r *s  -    14027250 *power(p, 5) *power(q, 5) *r *s  -
        44446875 *power(p, 2) *power(q, 7) *r *s  +  2011500 *power(p, 9) *q *power(r, 2) *s  +
        49330625 *power(p, 6) *power(q, 3) *power(r, 2) *s  +  272009375 *power(p, 3) *power(q, 5) *power(r, 2) *s  +
        104062500 *power(q, 7) *power(r, 2) *s  -    34660000 *power(p, 7) *q *power(r, 3) *s  -
        455062500 *power(p, 4) *power(q, 3) *power(r, 3) *s  -  625906250 *p *power(q, 5) *power(r, 3) *s  +
        210200000 *power(p, 5) *q *power(r, 4) *s  +  1298750000 *power(p, 2) *power(q, 3) *power(r, 4) *s  -
        240000000 *power(p, 3) *q *power(r, 5) *s  +  225000000 *power(q, 3) *power(r, 5) *s  +
        36450 *power(p, 12) *power(s, 2)  +    1231875 *power(p, 9) *power(q, 2) *power(s, 2)  +
        10712500 *power(p, 6) *power(q, 4) *power(s, 2)  +  21718750 *power(p, 3) *power(q, 6) *power(s, 2)  +
        16875000 *power(q, 8) *power(s, 2)  -  2814750 *power(p, 10) *r *power(s, 2)  -
        67612500 *power(p, 7) *power(q, 2) *r *power(s, 2)  -
        345156250 *power(p, 4) *power(q, 4) *r *power(s, 2)  -  283125000 *p *power(q, 6) *r *power(s, 2)  +
        51300000 *power(p, 8) *power(r, 2) *power(s, 2)  +    734531250 *power(p, 5) *power(q, 2) *power(r, 2) *power(s, 2)  +
        1267187500 *power(p, 2) *power(q, 4) *power(r, 2) *power(s, 2)  -
        384312500 *power(p, 6) *power(r, 3) *power(s, 2)  -  3912500000 *power(p, 3) *power(q, 2) *power(r, 3) *power(s, 2)  -
        1822265625 *power(q, 4) *power(r, 3) *power(s, 2)  +  1112500000 *power(p, 4) *power(r, 4) *power(s, 2)  +
        2437500000 *p *power(q, 2) *power(r, 4) *power(s, 2)  -  1125000000 *power(p, 2) *power(r, 5) *power(s, 2)  -
        72578125 *power(p, 5) *power(q, 3) *power(s, 3)  -  189296875 *power(p, 2) *power(q, 5) *power(s, 3)  +
        127265625 *power(p, 6) *q *r *power(s, 3)  +
        1415625000 *power(p, 3) *power(q, 3) *r *power(s, 3)  +  1229687500 *power(q, 5) *r *power(s, 3)  +
        1448437500 *power(p, 4) *q *power(r, 2) *power(s, 3)  +
        2218750000 *p *power(q, 3) *power(r, 2) *power(s, 3)  -
        4031250000 *power(p, 2) *q *power(r, 3) *power(s, 3)  +  5625000000 *q *power(r, 4) *power(s, 3)  -
        132890625 *power(p, 7) *power(s, 4)  -    529296875 *power(p, 4) *power(q, 2) *power(s, 4)  -
        175781250 *p *power(q, 4) *power(s, 4)  -  401953125 *power(p, 5) *r *power(s, 4)  -
        4482421875 *power(p, 2) *power(q, 2) *r *power(s, 4)  +  4140625000 *power(p, 3) *power(r, 2) *power(s, 4)  -
        10498046875 *power(q, 2) *power(r, 2) *power(s, 4)  -  7031250000 *p *power(r, 3) *power(s, 4)  +
        1220703125 *power(p, 3) *q *power(s, 5)  +    1953125000 *power(q, 3) *power(s, 5)  +
        14160156250 *p *q *r *power(s, 5)  -  1708984375 *power(p, 2) *power(s, 6)  -
        3662109375 *r *power(s, 6))

   b45 = (-4600 *power(p, 6) *power(q, 6)  -  67850 *power(p, 3) *power(q, 8)  -  248400 *power(q, 10)  +
        38900 *power(p, 7) *power(q, 4) *r  +    679575 *power(p, 4) *power(q, 6) *r  +
        2866500 *p *power(q, 8) *r  -  81900 *power(p, 8) *power(q, 2) *power(r, 2)  -
        2009750 *power(p, 5) *power(q, 4) *power(r, 2)  -  10783750 *power(p, 2) *power(q, 6) *power(r, 2)  +
        1478750 *power(p, 6) *power(q, 2) *power(r, 3)  +    14165625 *power(p, 3) *power(q, 4) *power(r, 3)  -
        2743750 *power(q, 6) *power(r, 3)  -  5450000 *power(p, 4) *power(q, 2) *power(r, 4)  +
        12687500 *p *power(q, 4) *power(r, 4)  -  22500000 *power(p, 2) *power(q, 2) *power(r, 5)  -
        101700 *power(p, 8) *power(q, 3) *s  -    1700975 *power(p, 5) *power(q, 5) *s  -
        7061250 *power(p, 2) *power(q, 7) *s  +  423900 *power(p, 9) *q *r *s  +
        9292375 *power(p, 6) *power(q, 3) *r *s  +  50438750 *power(p, 3) *power(q, 5) *r *s  +
        20475000 *power(q, 7) *r *s  -    7852500 *power(p, 7) *q *power(r, 2) *s  -
        87765625 *power(p, 4) *power(q, 3) *power(r, 2) *s  -  121609375 *p *power(q, 5) *power(r, 2) *s  +
        47700000 *power(p, 5) *q *power(r, 3) *s  +  264687500 *power(p, 2) *power(q, 3) *power(r, 3) *s  -
        65000000 *power(p, 3) *q *power(r, 4) *s  +    37500000 *power(q, 3) *power(r, 4) *s  -
        534600 *power(p, 10) *power(s, 2)  -  10344375 *power(p, 7) *power(q, 2) *power(s, 2)  -
        54859375 *power(p, 4) *power(q, 4) *power(s, 2)  -  40312500 *p *power(q, 6) *power(s, 2)  +
        10158750 *power(p, 8) *r *power(s, 2)  +    117778125 *power(p, 5) *power(q, 2) *r *power(s, 2)  +
        192421875 *power(p, 2) *power(q, 4) *r *power(s, 2)  -    70593750 *power(p, 6) *power(r, 2) *power(s, 2)  -
        685312500 *power(p, 3) *power(q, 2) *power(r, 2) *power(s, 2)  -
        334375000 *power(q, 4) *power(r, 2) *power(s, 2)  +  193750000 *power(p, 4) *power(r, 3) *power(s, 2)  +
        500000000 *p *power(q, 2) *power(r, 3) *power(s, 2)  -  187500000 *power(p, 2) *power(r, 4) *power(s, 2)  +
        8437500 *power(p, 6) *q *power(s, 3)  +    159218750 *power(p, 3) *power(q, 3) *power(s, 3)  +
        220625000 *power(q, 5) *power(s, 3)  +  353828125 *power(p, 4) *q *r *power(s, 3)  +
        412500000 *p *power(q, 3) *r *power(s, 3)  -  1023437500 *power(p, 2) *q *power(r, 2) *power(s, 3)  +
        937500000 *q *power(r, 3) *power(s, 3)  -    206015625 *power(p, 5) *power(s, 4)  -
        701171875 *power(p, 2) *power(q, 2) *power(s, 4)  +  998046875 *power(p, 3) *r *power(s, 4)  -
        1308593750 *power(q, 2) *r *power(s, 4)  -  1367187500 *p *power(r, 2) *power(s, 4)  +
        1708984375 *p *q *power(s, 5)  -    976562500 *power(s, 6))

   T1 = (b10 + b11 * root + b12 * power(root, 2) + b13 * power(root, 3) + b14 * power(root, 4) + b15 * power(root, 5)) / (2*F)
   T2 = (b20 + b21 * root + b22 * power(root, 2) + b23 * power(root, 3) + b24 * power(root, 4) + b25 * power(root, 5)) / (2*D*F)
   T3 = (b30 + b31 * root + b32 * power(root, 2) + b33 * power(root, 3) + b34 * power(root, 4) + b35 * power(root, 5)) / (2*F)
   T4 = (b40 + b41 * root + b42 * power(root, 2) + b43 * power(root, 3) + b44 * power(root, 4) + b45 * power(root, 5)) / (2*D*F)
   bb = T1 + T2 * delta
   cc = T3 + T4 * delta
   L1 = (- bb - mp.sqrt(bb*bb - 4*cc))/2
   L4 = (- bb + mp.sqrt(bb*bb - 4*cc))/2
   bb = T1 - T2 * delta
   cc = T3 - T4 * delta
   L2 = (- bb - mp.sqrt(bb*bb - 4*cc))/2
   L3 = (- bb + mp.sqrt(bb*bb - 4*cc))/2

   o0 = (-1600 *power(p, 10) *power(q, 10)  -  23600 *power(p, 7) *power(q, 12)  -  86400 *power(p, 4) *power(q, 14)  +
        24800 *power(p, 11) *power(q, 8) *r  +    419200 *power(p, 8) *power(q, 10) *r  +
        1850450 *power(p, 5) *power(q, 12) *r  +  896400 *power(p, 2) *power(q, 14) *r  -
        138800 *power(p, 12) *power(q, 6) *power(r, 2)  -  2921900 *power(p, 9) *power(q, 8) *power(r, 2)  -
        17295200 *power(p, 6) *power(q, 10) *power(r, 2)  -    27127750 *power(p, 3) *power(q, 12) *power(r, 2)  -
        26076600 *power(q, 14) *power(r, 2)  +  325800 *power(p, 13) *power(q, 4) *power(r, 3)  +
        9993850 *power(p, 10) *power(q, 6) *power(r, 3)  +  88010500 *power(p, 7) *power(q, 8) *power(r, 3)  +
        274047650 *power(p, 4) *power(q, 10) *power(r, 3)  +    410171400 *p *power(q, 12) *power(r, 3)  -
        259200 *power(p, 14) *power(q, 2) *power(r, 4)  -  17147100 *power(p, 11) *power(q, 4) *power(r, 4)  -
        254289150 *power(p, 8) *power(q, 6) *power(r, 4)  -  1318548225 *power(p, 5) *power(q, 8) *power(r, 4)  -
        2633598475 *power(p, 2) *power(q, 10) *power(r, 4)  +    12636000 *power(p, 12) *power(q, 2) *power(r, 5)  +
        388911000 *power(p, 9) *power(q, 4) *power(r, 5)  +  3269704725 *power(p, 6) *power(q, 6) *power(r, 5)  +
        8791192300 *power(p, 3) *power(q, 8) *power(r, 5)  +  93560575 *power(q, 10) *power(r, 5)  -
        228361600 *power(p, 10) *power(q, 2) *power(r, 6)  -    3951199200 *power(p, 7) *power(q, 4) *power(r, 6)  -
        16276981100 *power(p, 4) *power(q, 6) *power(r, 6)  -  1597227000 *p *power(q, 8) *power(r, 6)  +
        1947899200 *power(p, 8) *power(q, 2) *power(r, 7)  +  17037648000 *power(p, 5) *power(q, 4) *power(r, 7)  +
        8919740000 *power(p, 2) *power(q, 6) *power(r, 7)  -    7672160000 *power(p, 6) *power(q, 2) *power(r, 8)  -
        15496000000 *power(p, 3) *power(q, 4) *power(r, 8)  +  4224000000 *power(q, 6) *power(r, 8)  +
        9968000000 *power(p, 4) *power(q, 2) *power(r, 9)  -  8640000000 *p *power(q, 4) *power(r, 9)  +
        4800000000 *power(p, 2) *power(q, 2) *power(r, 10)  -    55200 *power(p, 12) *power(q, 7) *s  -
        685600 *power(p, 9) *power(q, 9) *s  +  1028250 *power(p, 6) *power(q, 11) *s  +
        37650000 *power(p, 3) *power(q, 13) *s  +  111375000 *power(q, 15) *s  +
        583200 *power(p, 13) *power(q, 5) *r *s  +    9075600 *power(p, 10) *power(q, 7) *r *s  -
        883150 *power(p, 7) *power(q, 9) *r *s  -  506830750 *power(p, 4) *power(q, 11) *r *s  -
        1793137500 *p *power(q, 13) *r *s  -  1852200 *power(p, 14) *power(q, 3) *power(r, 2) *s  -
        41435250 *power(p, 11) *power(q, 5) *power(r, 2) *s  -  80566700 *power(p, 8) *power(q, 7) *power(r, 2) *s  +
        2485673600 *power(p, 5) *power(q, 9) *power(r, 2) *s  +
        11442286125 *power(p, 2) *power(q, 11) *power(r, 2) *s  +
        1555200 *power(p, 15) *q *power(r, 3) *s  +  80846100 *power(p, 12) *power(q, 3) *power(r, 3) *s  +
        564906800 *power(p, 9) *power(q, 5) *power(r, 3) *s  -
        4493012400 *power(p, 6) *power(q, 7) *power(r, 3) *s  -
        35492391250 *power(p, 3) *power(q, 9) *power(r, 3) *s  -  789931875 *power(q, 11) *power(r, 3) *s  -
        71766000 *power(p, 13) *q *power(r, 4) *s  -  1551149200 *power(p, 10) *power(q, 3) *power(r, 4) *s  -
        1773437900 *power(p, 7) *power(q, 5) *power(r, 4) *s  +
        51957593125 *power(p, 4) *power(q, 7) *power(r, 4) *s  +
        14964765625 *p *power(q, 9) *power(r, 4) *s  +  1231569600 *power(p, 11) *q *power(r, 5) *s  +
        12042977600 *power(p, 8) *power(q, 3) *power(r, 5) *s  -
        27151011200 *power(p, 5) *power(q, 5) *power(r, 5) *s  -
        88080610000 *power(p, 2) *power(q, 7) *power(r, 5) *s  -  9912995200 *power(p, 9) *q *power(r, 6) *s  -
        29448104000 *power(p, 6) *power(q, 3) *power(r, 6) *s  +
        144954840000 *power(p, 3) *power(q, 5) *power(r, 6) *s  -
        44601300000 *power(q, 7) *power(r, 6) *s  +  35453760000 *power(p, 7) *q *power(r, 7) *s  -
        63264000000 *power(p, 4) *power(q, 3) *power(r, 7) *s  +
        60544000000 *p *power(q, 5) *power(r, 7) *s  -
        30048000000 *power(p, 5) *q *power(r, 8) *s  +  37040000000 *power(p, 2) *power(q, 3) *power(r, 8) *s  -
        60800000000 *power(p, 3) *q *power(r, 9) *s  -  48000000000 *power(q, 3) *power(r, 9) *s  -
        615600 *power(p, 14) *power(q, 4) *power(s, 2)  -    10524500 *power(p, 11) *power(q, 6) *power(s, 2)  -
        33831250 *power(p, 8) *power(q, 8) *power(s, 2)  +  222806250 *power(p, 5) *power(q, 10) *power(s, 2)  +
        1099687500 *power(p, 2) *power(q, 12) *power(s, 2)  +  3353400 *power(p, 15) *power(q, 2) *r *power(s, 2)  +
        74269350 *power(p, 12) *power(q, 4) *r *power(s, 2)  +  276445750 *power(p, 9) *power(q, 6) *r *power(s, 2)  -
        2618600000 *power(p, 6) *power(q, 8) *r *power(s, 2)  -
        14473243750 *power(p, 3) *power(q, 10) *r *power(s, 2)  +
        1383750000 *power(q, 12) *r *power(s, 2)  -  2332800 *power(p, 16) *power(r, 2) *power(s, 2)  -
        132750900 *power(p, 13) *power(q, 2) *power(r, 2) *power(s, 2)  -
        900775150 *power(p, 10) *power(q, 4) *power(r, 2) *power(s, 2)  +
        8249244500 *power(p, 7) *power(q, 6) *power(r, 2) *power(s, 2)  +
        59525796875 *power(p, 4) *power(q, 8) *power(r, 2) *power(s, 2)  -
        40292868750 *p *power(q, 10) *power(r, 2) *power(s, 2)  +  128304000 *power(p, 14) *power(r, 3) *power(s, 2)  +
        3160232100 *power(p, 11) *power(q, 2) *power(r, 3) *power(s, 2)  +
        8329580000 *power(p, 8) *power(q, 4) *power(r, 3) *power(s, 2)  -
        45558458750 *power(p, 5) *power(q, 6) *power(r, 3) *power(s, 2)  +
        297252890625 *power(p, 2) *power(q, 8) *power(r, 3) *power(s, 2)  -
        2769854400 *power(p, 12) *power(r, 4) *power(s, 2)  -  37065970000 *power(p, 9) *power(q, 2) *power(r, 4) *power(s, 2)  -
        90812546875 *power(p, 6) *power(q, 4) *power(r, 4) *power(s, 2)  -
        627902000000 *power(p, 3) *power(q, 6) *power(r, 4) *power(s, 2)  +
        181347421875 *power(q, 8) *power(r, 4) *power(s, 2)  +  30946932800 *power(p, 10) *power(r, 5) *power(s, 2)  +
        249954680000 *power(p, 7) *power(q, 2) *power(r, 5) *power(s, 2)  +
        802954812500 *power(p, 4) *power(q, 4) *power(r, 5) *power(s, 2)  -
        80900000000 *p *power(q, 6) *power(r, 5) *power(s, 2)  -  192137320000 *power(p, 8) *power(r, 6) *power(s, 2)  -
        932641600000 *power(p, 5) *power(q, 2) *power(r, 6) *power(s, 2)  -
        943242500000 *power(p, 2) *power(q, 4) *power(r, 6) *power(s, 2)  +
        658412000000 *power(p, 6) *power(r, 7) *power(s, 2)  +
        1930720000000 *power(p, 3) *power(q, 2) *power(r, 7) *power(s, 2)  +
        593800000000 *power(q, 4) *power(r, 7) *power(s, 2)  -  1162800000000 *power(p, 4) *power(r, 8) *power(s, 2)  -
        280000000000 *p *power(q, 2) *power(r, 8) *power(s, 2)  +
        840000000000 *power(p, 2) *power(r, 9) *power(s, 2)  -    2187000 *power(p, 16) *q *power(s, 3)  -
        47418750 *power(p, 13) *power(q, 3) *power(s, 3)  -  180618750 *power(p, 10) *power(q, 5) *power(s, 3)  +
        2231250000 *power(p, 7) *power(q, 7) *power(s, 3)  +  17857734375 *power(p, 4) *power(q, 9) *power(s, 3)  +
        29882812500 *p *power(q, 11) *power(s, 3)  +  24664500 *power(p, 14) *q *r *power(s, 3)  -
        853368750 *power(p, 11) *power(q, 3) *r *power(s, 3)  -
        25939693750 *power(p, 8) *power(q, 5) *r *power(s, 3)  -
        177541562500 *power(p, 5) *power(q, 7) *r *power(s, 3)  -
        297978828125 *power(p, 2) *power(q, 9) *r *power(s, 3)  -
        153468000 *power(p, 12) *q *power(r, 2) *power(s, 3)  +
        30188125000 *power(p, 9) *power(q, 3) *power(r, 2) *power(s, 3)  +
        344049821875 *power(p, 6) *power(q, 5) *power(r, 2) *power(s, 3)  +
        534026875000 *power(p, 3) *power(q, 7) *power(r, 2) *power(s, 3)  -
        340726484375 *power(q, 9) *power(r, 2) *power(s, 3)  -  9056190000 *power(p, 10) *q *power(r, 3) *power(s, 3)  -
        322314687500 *power(p, 7) *power(q, 3) *power(r, 3) *power(s, 3)  -
        769632109375 *power(p, 4) *power(q, 5) *power(r, 3) *power(s, 3)  -
        83276875000 *p *power(q, 7) *power(r, 3) *power(s, 3)  +
        164061000000 *power(p, 8) *q *power(r, 4) *power(s, 3)  +
        1381358750000 *power(p, 5) *power(q, 3) *power(r, 4) *power(s, 3)  +
        3088020000000 *power(p, 2) *power(q, 5) *power(r, 4) *power(s, 3)  -
        1267655000000 *power(p, 6) *q *power(r, 5) *power(s, 3)  -
        7642630000000 *power(p, 3) *power(q, 3) *power(r, 5) *power(s, 3)  -
        2759877500000 *power(q, 5) *power(r, 5) *power(s, 3)  +
        4597760000000 *power(p, 4) *q *power(r, 6) *power(s, 3)  +
        1846200000000 *p *power(q, 3) *power(r, 6) *power(s, 3)  -
        7006000000000 *power(p, 2) *q *power(r, 7) *power(s, 3)  -
        1200000000000 *q *power(r, 8) *power(s, 3)  +  18225000 *power(p, 15) *power(s, 4)  +
        1328906250 *power(p, 12) *power(q, 2) *power(s, 4)  +    24729140625 *power(p, 9) *power(q, 4) *power(s, 4)  +
        169467187500 *power(p, 6) *power(q, 6) *power(s, 4)  +
        413281250000 *power(p, 3) *power(q, 8) *power(s, 4)  +  223828125000 *power(q, 10) *power(s, 4)  +
        710775000 *power(p, 13) *r *power(s, 4)  -  18611015625 *power(p, 10) *power(q, 2) *r *power(s, 4)  -
        314344375000 *power(p, 7) *power(q, 4) *r *power(s, 4)  -
        828439843750 *power(p, 4) *power(q, 6) *r *power(s, 4)  +
        460937500000 *p *power(q, 8) *r *power(s, 4)  -  25674975000 *power(p, 11) *power(r, 2) *power(s, 4)  -
        52223515625 *power(p, 8) *power(q, 2) *power(r, 2) *power(s, 4)  -
        387160000000 *power(p, 5) *power(q, 4) *power(r, 2) *power(s, 4)  -
        4733680078125 *power(p, 2) *power(q, 6) *power(r, 2) *power(s, 4)  +
        343911875000 *power(p, 9) *power(r, 3) *power(s, 4)  +
        3328658359375 *power(p, 6) *power(q, 2) *power(r, 3) *power(s, 4)  +
        16532406250000 *power(p, 3) *power(q, 4) *power(r, 3) *power(s, 4)  +
        5980613281250 *power(q, 6) *power(r, 3) *power(s, 4)  -  2295497500000 *power(p, 7) *power(r, 4) *power(s, 4)  -
        14809820312500 *power(p, 4) *power(q, 2) *power(r, 4) *power(s, 4)  -
        6491406250000 *p *power(q, 4) *power(r, 4) *power(s, 4)  +
        7768470000000 *power(p, 5) *power(r, 5) *power(s, 4)  +
        34192562500000 *power(p, 2) *power(q, 2) *power(r, 5) *power(s, 4)  -
        11859000000000 *power(p, 3) *power(r, 6) *power(s, 4)  +  10530000000000 *power(q, 2) *power(r, 6) *power(s, 4)  +
        6000000000000 *p *power(r, 7) *power(s, 4)  +
        11453906250 *power(p, 11) *q *power(s, 5)  +    149765625000 *power(p, 8) *power(q, 3) *power(s, 5)  +
        545537109375 *power(p, 5) *power(q, 5) *power(s, 5)  +
        527343750000 *power(p, 2) *power(q, 7) *power(s, 5)  -  371313281250 *power(p, 9) *q *r *power(s, 5)  -
        3461455078125 *power(p, 6) *power(q, 3) *r *power(s, 5)  -
        7920878906250 *power(p, 3) *power(q, 5) *r *power(s, 5)  -
        4747314453125 *power(q, 7) *r *power(s, 5)  +  2417815625000 *power(p, 7) *q *power(r, 2) *power(s, 5)  +
        5465576171875 *power(p, 4) *power(q, 3) *power(r, 2) *power(s, 5)  +
        5937128906250 *p *power(q, 5) *power(r, 2) *power(s, 5)  -
        10661156250000 *power(p, 5) *q *power(r, 3) *power(s, 5)  -
        63574218750000 *power(p, 2) *power(q, 3) *power(r, 3) *power(s, 5)  +
        24059375000000 *power(p, 3) *q *power(r, 4) *power(s, 5)  -
        33023437500000 *power(q, 3) *power(r, 4) *power(s, 5)  -
        43125000000000 *p *q *power(r, 5) *power(s, 5)  +  94394531250 *power(p, 10) *power(s, 6)  +
        1097167968750 *power(p, 7) *power(q, 2) *power(s, 6)  +
        2829833984375 *power(p, 4) *power(q, 4) *power(s, 6)  -
        1525878906250 *p *power(q, 6) *power(s, 6)  +  2724609375 *power(p, 8) *r *power(s, 6)  +
        13998535156250 *power(p, 5) *power(q, 2) *r *power(s, 6)  +
        57094482421875 *power(p, 2) *power(q, 4) *r *power(s, 6)  -
        8512509765625 *power(p, 6) *power(r, 2) *power(s, 6)  -
        37941406250000 *power(p, 3) *power(q, 2) *power(r, 2) *power(s, 6)  +
        33191894531250 *power(q, 4) *power(r, 2) *power(s, 6)  +  50534179687500 *power(p, 4) *power(r, 3) *power(s, 6)  +
        156656250000000 *p *power(q, 2) *power(r, 3) *power(s, 6)  -
        85023437500000 *power(p, 2) *power(r, 4) *power(s, 6)  +
        10125000000000 *power(r, 5) *power(s, 6)  -  2717285156250 *power(p, 6) *q *power(s, 7)  -
        11352539062500 *power(p, 3) *power(q, 3) *power(s, 7)  -  2593994140625 *power(q, 5) *power(s, 7)  -
        47154541015625 *power(p, 4) *q *r *power(s, 7)  -
        160644531250000 *p *power(q, 3) *r *power(s, 7)  +
        142500000000000 *power(p, 2) *q *power(r, 2) *power(s, 7)  -
        26757812500000 *q *power(r, 3) *power(s, 7)  -    4364013671875 *power(p, 5) *power(s, 8)  -
        94604492187500 *power(p, 2) *power(q, 2) *power(s, 8)  +
        114379882812500 *power(p, 3) *r *power(s, 8)  +  51116943359375 *power(q, 2) *r *power(s, 8)  -
        346435546875000 *p *power(r, 2) *power(s, 8)  +
        476837158203125 *p *q *power(s, 9)  -    476837158203125 *power(s, 10))

   o1 = (1600 *power(p, 11) *power(q, 8)  +  20800 *power(p, 8) *power(q, 10)  +  45100 *power(p, 5) *power(q, 12)  -
        151200 *power(p, 2) *power(q, 14)  -    19200 *power(p, 12) *power(q, 6) *r  -
        293200 *power(p, 9) *power(q, 8) *r  -  794600 *power(p, 6) *power(q, 10) *r  +
        2634675 *power(p, 3) *power(q, 12) *r  +  2640600 *power(q, 14) *r  +
        75600 *power(p, 13) *power(q, 4) *power(r, 2)  +    1529100 *power(p, 10) *power(q, 6) *power(r, 2)  +
        6233350 *power(p, 7) *power(q, 8) *power(r, 2)  -  12013350 *power(p, 4) *power(q, 10) *power(r, 2)  -
        29069550 *p *power(q, 12) *power(r, 2)  -  97200 *power(p, 14) *power(q, 2) *power(r, 3)  -
        3562500 *power(p, 11) *power(q, 4) *power(r, 3)  -    26984900 *power(p, 8) *power(q, 6) *power(r, 3)  -
        15900325 *power(p, 5) *power(q, 8) *power(r, 3)  +  76267100 *power(p, 2) *power(q, 10) *power(r, 3)  +
        3272400 *power(p, 12) *power(q, 2) *power(r, 4)  +  59486850 *power(p, 9) *power(q, 4) *power(r, 4)  +
        221270075 *power(p, 6) *power(q, 6) *power(r, 4)  +    74065250 *power(p, 3) *power(q, 8) *power(r, 4)  -
        300564375 *power(q, 10) *power(r, 4)  -  45569400 *power(p, 10) *power(q, 2) *power(r, 5)  -
        438666000 *power(p, 7) *power(q, 4) *power(r, 5)  -  444821250 *power(p, 4) *power(q, 6) *power(r, 5)  +
        2448256250 *p *power(q, 8) *power(r, 5)  +    290640000 *power(p, 8) *power(q, 2) *power(r, 6)  +
        855850000 *power(p, 5) *power(q, 4) *power(r, 6)  -  5741875000 *power(p, 2) *power(q, 6) *power(r, 6)  -
        644000000 *power(p, 6) *power(q, 2) *power(r, 7)  +  5574000000 *power(p, 3) *power(q, 4) *power(r, 7)  +
        4643000000 *power(q, 6) *power(r, 7)  -    1696000000 *power(p, 4) *power(q, 2) *power(r, 8)  -
        12660000000 *p *power(q, 4) *power(r, 8)  +  7200000000 *power(p, 2) *power(q, 2) *power(r, 9)  +
        43200 *power(p, 13) *power(q, 5) *s  +  572000 *power(p, 10) *power(q, 7) *s  -
        59800 *power(p, 7) *power(q, 9) *s  -    24174625 *power(p, 4) *power(q, 11) *s  -
        74587500 *p *power(q, 13) *s  -  324000 *power(p, 14) *power(q, 3) *r *s  -
        5531400 *power(p, 11) *power(q, 5) *r *s  -  3712100 *power(p, 8) *power(q, 7) *r *s  +
        293009275 *power(p, 5) *power(q, 9) *r *s  +    1115548875 *power(p, 2) *power(q, 11) *r *s  +
        583200 *power(p, 15) *q *power(r, 2) *s  +    18343800 *power(p, 12) *power(q, 3) *power(r, 2) *s  +
        77911100 *power(p, 9) *power(q, 5) *power(r, 2) *s  -
        957488825 *power(p, 6) *power(q, 7) *power(r, 2) *s  -  5449661250 *power(p, 3) *power(q, 9) *power(r, 2) *s  +
        960120000 *power(q, 11) *power(r, 2) *s  -  23684400 *power(p, 13) *q *power(r, 3) *s  -
        373761900 *power(p, 10) *power(q, 3) *power(r, 3) *s  -  27944975 *power(p, 7) *power(q, 5) *power(r, 3) *s  +
        10375740625 *power(p, 4) *power(q, 7) *power(r, 3) *s  -
        4649093750 *p *power(q, 9) *power(r, 3) *s  +    395816400 *power(p, 11) *q *power(r, 4) *s  +
        2910968000 *power(p, 8) *power(q, 3) *power(r, 4) *s  -
        9126162500 *power(p, 5) *power(q, 5) *power(r, 4) *s  -  11696118750 *power(p, 2) *power(q, 7) *power(r, 4) *s  -
        3028640000 *power(p, 9) *q *power(r, 5) *s  -
        3251550000 *power(p, 6) *power(q, 3) *power(r, 5) *s  +
        47914250000 *power(p, 3) *power(q, 5) *power(r, 5) *s  -  30255625000 *power(q, 7) *power(r, 5) *s  +
        9304000000 *power(p, 7) *q *power(r, 6) *s  -
        42970000000 *power(p, 4) *power(q, 3) *power(r, 6) *s  +
        31475000000 *p *power(q, 5) *power(r, 6) *s  +  2176000000 *power(p, 5) *q *power(r, 7) *s  +
        62100000000 *power(p, 2) *power(q, 3) *power(r, 7) *s  -
        43200000000 *power(p, 3) *q *power(r, 8) *s  -    72000000000 *power(q, 3) *power(r, 8) *s  +
        291600 *power(p, 15) *power(q, 2) *power(s, 2)  +  2702700 *power(p, 12) *power(q, 4) *power(s, 2)  -
        38692250 *power(p, 9) *power(q, 6) *power(s, 2)  -  538903125 *power(p, 6) *power(q, 8) *power(s, 2)  -
        1613112500 *power(p, 3) *power(q, 10) *power(s, 2)  +    320625000 *power(q, 12) *power(s, 2)  -
        874800 *power(p, 16) *r *power(s, 2)  -  14166900 *power(p, 13) *power(q, 2) *r *power(s, 2)  +
        193284900 *power(p, 10) *power(q, 4) *r *power(s, 2)  +  3688520500 *power(p, 7) *power(q, 6) *r *power(s, 2)  +
        11613390625 *power(p, 4) *power(q, 8) *r *power(s, 2)  -
        15609881250 *p *power(q, 10) *r *power(s, 2)  +    44031600 *power(p, 14) *power(r, 2) *power(s, 2)  +
        482345550 *power(p, 11) *power(q, 2) *power(r, 2) *power(s, 2)  -
        2020881875 *power(p, 8) *power(q, 4) *power(r, 2) *power(s, 2)  -
        7407026250 *power(p, 5) *power(q, 6) *power(r, 2) *power(s, 2)  +
        136175750000 *power(p, 2) *power(q, 8) *power(r, 2) *power(s, 2)  -  1000884600 *power(p, 12) *power(r, 3) *power(s, 2)  -
        8888950000 *power(p, 9) *power(q, 2) *power(r, 3) *power(s, 2)  -
        30101703125 *power(p, 6) *power(q, 4) *power(r, 3) *power(s, 2)  -
        319761000000 *power(p, 3) *power(q, 6) *power(r, 3) *power(s, 2)  +  51519218750 *power(q, 8) *power(r, 3) *power(s, 2)  +
        12622395000 *power(p, 10) *power(r, 4) *power(s, 2)  +
        97032450000 *power(p, 7) *power(q, 2) *power(r, 4) *power(s, 2)  +
        469929218750 *power(p, 4) *power(q, 4) *power(r, 4) *power(s, 2)  +
        291342187500 *p *power(q, 6) *power(r, 4) *power(s, 2)  -
        96382000000 *power(p, 8) *power(r, 5) *power(s, 2)  -  598070000000 *power(p, 5) *power(q, 2) *power(r, 5) *power(s, 2)  -
        1165021875000 *power(p, 2) *power(q, 4) *power(r, 5) *power(s, 2)  +
        446500000000 *power(p, 6) *power(r, 6) *power(s, 2)  +
        1651500000000 *power(p, 3) *power(q, 2) *power(r, 6) *power(s, 2)  +
        789375000000 *power(q, 4) *power(r, 6) *power(s, 2)  -
        1152000000000 *power(p, 4) *power(r, 7) *power(s, 2)  -  600000000000 *p *power(q, 2) *power(r, 7) *power(s, 2)  +
        1260000000000 *power(p, 2) *power(r, 8) *power(s, 2)  -  24786000 *power(p, 14) *q *power(s, 3)  -
        660487500 *power(p, 11) *power(q, 3) *power(s, 3)  -  5886356250 *power(p, 8) *power(q, 5) *power(s, 3)  -
        18137187500 *power(p, 5) *power(q, 7) *power(s, 3)  -
        5120546875 *power(p, 2) *power(q, 9) *power(s, 3)  +    827658000 *power(p, 12) *q *r *power(s, 3)  +
        13343062500 *power(p, 9) *power(q, 3) *r *power(s, 3)  +
        39782068750 *power(p, 6) *power(q, 5) *r *power(s, 3)  -
        111288437500 *power(p, 3) *power(q, 7) *r *power(s, 3)  -
        15438750000 *power(q, 9) *r *power(s, 3)  -  14540782500 *power(p, 10) *q *power(r, 2) *power(s, 3)  -
        135889750000 *power(p, 7) *power(q, 3) *power(r, 2) *power(s, 3)  -
        176892578125 *power(p, 4) *power(q, 5) *power(r, 2) *power(s, 3)  -
        934462656250 *p *power(q, 7) *power(r, 2) *power(s, 3)  +
        171669250000 *power(p, 8) *q *power(r, 3) *power(s, 3)  +
        1164538125000 *power(p, 5) *power(q, 3) *power(r, 3) *power(s, 3)  +
        3192346406250 *power(p, 2) *power(q, 5) *power(r, 3) *power(s, 3)  -
        1295476250000 *power(p, 6) *q *power(r, 4) *power(s, 3)  -
        6540712500000 *power(p, 3) *power(q, 3) *power(r, 4) *power(s, 3)  -
        2957828125000 *power(q, 5) *power(r, 4) *power(s, 3)  +
        5366750000000 *power(p, 4) *q *power(r, 5) *power(s, 3)  +
        3165000000000 *p *power(q, 3) *power(r, 5) *power(s, 3)  -
        8862500000000 *power(p, 2) *q *power(r, 6) *power(s, 3)  -
        1800000000000 *q *power(r, 7) *power(s, 3)  +  236925000 *power(p, 13) *power(s, 4)  +
        8895234375 *power(p, 10) *power(q, 2) *power(s, 4)  +
        106180781250 *power(p, 7) *power(q, 4) *power(s, 4)  +  474221875000 *power(p, 4) *power(q, 6) *power(s, 4)  +
        616210937500 *p *power(q, 8) *power(s, 4)  -  6995868750 *power(p, 11) *r *power(s, 4)  -
        184190625000 *power(p, 8) *power(q, 2) *r *power(s, 4)  -
        1299254453125 *power(p, 5) *power(q, 4) *r *power(s, 4)  -
        2475458593750 *power(p, 2) *power(q, 6) *r *power(s, 4)  +  63049218750 *power(p, 9) *power(r, 2) *power(s, 4)  +
        1646791484375 *power(p, 6) *power(q, 2) *power(r, 2) *power(s, 4)  +
        9086886718750 *power(p, 3) *power(q, 4) *power(r, 2) *power(s, 4)  +
        4673421875000 *power(q, 6) *power(r, 2) *power(s, 4)  -  215665000000 *power(p, 7) *power(r, 3) *power(s, 4)  -
        7864589843750 *power(p, 4) *power(q, 2) *power(r, 3) *power(s, 4)  -
        5987890625000 *p *power(q, 4) *power(r, 3) *power(s, 4)  +
        594843750000 *power(p, 5) *power(r, 4) *power(s, 4)  +
        27791171875000 *power(p, 2) *power(q, 2) *power(r, 4) *power(s, 4)  -
        3881250000000 *power(p, 3) *power(r, 5) *power(s, 4)  +  12203125000000 *power(q, 2) *power(r, 5) *power(s, 4)  +
        10312500000000 *p *power(r, 6) *power(s, 4)  -
        34720312500 *power(p, 9) *q *power(s, 5)  -    545126953125 *power(p, 6) *power(q, 3) *power(s, 5)  -
        2176425781250 *power(p, 3) *power(q, 5) *power(s, 5)  -
        2792968750000 *power(q, 7) *power(s, 5)  -  1395703125 *power(p, 7) *q *r *power(s, 5)  -
        1957568359375 *power(p, 4) *power(q, 3) *r *power(s, 5)  +
        5122636718750 *p *power(q, 5) *r *power(s, 5)  +
        858210937500 *power(p, 5) *q *power(r, 2) *power(s, 5)  -
        42050097656250 *power(p, 2) *power(q, 3) *power(r, 2) *power(s, 5)  +
        7088281250000 *power(p, 3) *q *power(r, 3) *power(s, 5)  -
        25974609375000 *power(q, 3) *power(r, 3) *power(s, 5)  -
        69296875000000 *p *q *power(r, 4) *power(s, 5)  +  384697265625 *power(p, 8) *power(s, 6)  +
        6403320312500 *power(p, 5) *power(q, 2) *power(s, 6)  +
        16742675781250 *power(p, 2) *power(q, 4) *power(s, 6)  -
        3467080078125 *power(p, 6) *r *power(s, 6)  +  11009765625000 *power(p, 3) *power(q, 2) *r *power(s, 6)  +
        16451660156250 *power(q, 4) *r *power(s, 6)  +
        6979003906250 *power(p, 4) *power(r, 2) *power(s, 6)  +
        145403320312500 *p *power(q, 2) *power(r, 2) *power(s, 6)  +
        4076171875000 *power(p, 2) *power(r, 3) *power(s, 6)  +    22265625000000 *power(r, 4) *power(s, 6)  -
        21915283203125 *power(p, 4) *q *power(s, 7)  -
        86608886718750 *p *power(q, 3) *power(s, 7)  -  22785644531250 *power(p, 2) *q *r *power(s, 7)  -
        103466796875000 *q *power(r, 2) *power(s, 7)  +
        18798828125000 *power(p, 3) *power(s, 8)  +    106048583984375 *power(q, 2) *power(s, 8)  +
        17761230468750 *p *r *power(s, 8))

   o2 = (2800 *power(p, 9) *power(q, 8)  +  55700 *power(p, 6) *power(q, 10)  +  363600 *power(p, 3) *power(q, 12)  +
        777600 *power(q, 14)  -    27200 *power(p, 10) *power(q, 6) *r  -
        700200 *power(p, 7) *power(q, 8) *r  -  5726550 *power(p, 4) *power(q, 10) *r  -
        15066000 *p *power(q, 12) *r  +  74700 *power(p, 11) *power(q, 4) *power(r, 2)  +
        2859575 *power(p, 8) *power(q, 6) *power(r, 2)  +    31175725 *power(p, 5) *power(q, 8) *power(r, 2)  +
        103147650 *power(p, 2) *power(q, 10) *power(r, 2)  -  40500 *power(p, 12) *power(q, 2) *power(r, 3)  -
        4274400 *power(p, 9) *power(q, 4) *power(r, 3)  -  76065825 *power(p, 6) *power(q, 6) *power(r, 3)  -
        365623750 *power(p, 3) *power(q, 8) *power(r, 3)  -    132264000 *power(q, 10) *power(r, 3)  +
        2192400 *power(p, 10) *power(q, 2) *power(r, 4)  +  92562500 *power(p, 7) *power(q, 4) *power(r, 4)  +
        799193875 *power(p, 4) *power(q, 6) *power(r, 4)  +  1188193125 *p *power(q, 8) *power(r, 4)  -
        41231500 *power(p, 8) *power(q, 2) *power(r, 5)  -    914210000 *power(p, 5) *power(q, 4) *power(r, 5)  -
        3318853125 *power(p, 2) *power(q, 6) *power(r, 5)  +  398850000 *power(p, 6) *power(q, 2) *power(r, 6)  +
        3944000000 *power(p, 3) *power(q, 4) *power(r, 6)  +  2211312500 *power(q, 6) *power(r, 6)  -
        1817000000 *power(p, 4) *power(q, 2) *power(r, 7)  -    6720000000 *p *power(q, 4) *power(r, 7)  +
        3900000000 *power(p, 2) *power(q, 2) *power(r, 8)  +  75600 *power(p, 11) *power(q, 5) *s  +
        1823100 *power(p, 8) *power(q, 7) *s  +  14534150 *power(p, 5) *power(q, 9) *s  +
        38265750 *power(p, 2) *power(q, 11) *s  -    394200 *power(p, 12) *power(q, 3) *r *s  -
        11453850 *power(p, 9) *power(q, 5) *r *s  -  101213000 *power(p, 6) *power(q, 7) *r *s  -
        223565625 *power(p, 3) *power(q, 9) *r *s  +  415125000 *power(q, 11) *r *s  +
        243000 *power(p, 13) *q *power(r, 2) *s  +    13654575 *power(p, 10) *power(q, 3) *power(r, 2) *s  +
        163811725 *power(p, 7) *power(q, 5) *power(r, 2) *s  +
        173461250 *power(p, 4) *power(q, 7) *power(r, 2) *s  -  3008671875 *p *power(q, 9) *power(r, 2) *s  -
        2016900 *power(p, 11) *q *power(r, 3) *s  -  86576250 *power(p, 8) *power(q, 3) *power(r, 3) *s  -
        324146625 *power(p, 5) *power(q, 5) *power(r, 3) *s  +
        3378506250 *power(p, 2) *power(q, 7) *power(r, 3) *s  -    89211000 *power(p, 9) *q *power(r, 4) *s  -
        55207500 *power(p, 6) *power(q, 3) *power(r, 4) *s  +
        1493950000 *power(p, 3) *power(q, 5) *power(r, 4) *s  -  12573609375 *power(q, 7) *power(r, 4) *s  +
        1140100000 *power(p, 7) *q *power(r, 5) *s  +  42500000 *power(p, 4) *power(q, 3) *power(r, 5) *s  +
        21511250000 *p *power(q, 5) *power(r, 5) *s  -
        4058000000 *power(p, 5) *q *power(r, 6) *s  +
        6725000000 *power(p, 2) *power(q, 3) *power(r, 6) *s  -  1400000000 *power(p, 3) *q *power(r, 7) *s  -
        39000000000 *power(q, 3) *power(r, 7) *s  +  510300 *power(p, 13) *power(q, 2) *power(s, 2)  +
        4814775 *power(p, 10) *power(q, 4) *power(s, 2)  -    70265125 *power(p, 7) *power(q, 6) *power(s, 2)  -
        1016484375 *power(p, 4) *power(q, 8) *power(s, 2)  -  3221100000 *p *power(q, 10) *power(s, 2)  -
        364500 *power(p, 14) *r *power(s, 2)  +  30314250 *power(p, 11) *power(q, 2) *r *power(s, 2)  +
        1106765625 *power(p, 8) *power(q, 4) *r *power(s, 2)  +
        10984203125 *power(p, 5) *power(q, 6) *r *power(s, 2)  +  33905812500 *power(p, 2) *power(q, 8) *r *power(s, 2)  -
        37980900 *power(p, 12) *power(r, 2) *power(s, 2)  -
        2142905625 *power(p, 9) *power(q, 2) *power(r, 2) *power(s, 2)  -
        26896125000 *power(p, 6) *power(q, 4) *power(r, 2) *power(s, 2)  -
        95551328125 *power(p, 3) *power(q, 6) *power(r, 2) *power(s, 2)  +
        11320312500 *power(q, 8) *power(r, 2) *power(s, 2)  +  1743781500 *power(p, 10) *power(r, 3) *power(s, 2)  +
        35432262500 *power(p, 7) *power(q, 2) *power(r, 3) *power(s, 2)  +
        177855859375 *power(p, 4) *power(q, 4) *power(r, 3) *power(s, 2)  +
        121260546875 *p *power(q, 6) *power(r, 3) *power(s, 2)  -  25943162500 *power(p, 8) *power(r, 4) *power(s, 2)  -
        249165500000 *power(p, 5) *power(q, 2) *power(r, 4) *power(s, 2)  -
        461739453125 *power(p, 2) *power(q, 4) *power(r, 4) *power(s, 2)  +
        177823750000 *power(p, 6) *power(r, 5) *power(s, 2)  +
        726225000000 *power(p, 3) *power(q, 2) *power(r, 5) *power(s, 2)  +
        404195312500 *power(q, 4) *power(r, 5) *power(s, 2)  -  565875000000 *power(p, 4) *power(r, 6) *power(s, 2)  -
        407500000000 *p *power(q, 2) *power(r, 6) *power(s, 2)  +
        682500000000 *power(p, 2) *power(r, 7) *power(s, 2)  -    59140125 *power(p, 12) *q *power(s, 3)  -
        1290515625 *power(p, 9) *power(q, 3) *power(s, 3)  -  8785071875 *power(p, 6) *power(q, 5) *power(s, 3)  -
        15588281250 *power(p, 3) *power(q, 7) *power(s, 3)  +  17505000000 *power(q, 9) *power(s, 3)  +
        896062500 *power(p, 10) *q *r *power(s, 3)  +
        2589750000 *power(p, 7) *power(q, 3) *r *power(s, 3)  -  82700156250 *power(p, 4) *power(q, 5) *r *power(s, 3)  -
        347683593750 *p *power(q, 7) *r *power(s, 3)  +
        17022656250 *power(p, 8) *q *power(r, 2) *power(s, 3)  +
        320923593750 *power(p, 5) *power(q, 3) *power(r, 2) *power(s, 3)  +
        1042116875000 *power(p, 2) *power(q, 5) *power(r, 2) *power(s, 3)  -
        353262812500 *power(p, 6) *q *power(r, 3) *power(s, 3)  -
        2212664062500 *power(p, 3) *power(q, 3) *power(r, 3) *power(s, 3)  -
        1252408984375 *power(q, 5) *power(r, 3) *power(s, 3)  +
        1967362500000 *power(p, 4) *q *power(r, 4) *power(s, 3)  +
        1583343750000 *p *power(q, 3) *power(r, 4) *power(s, 3)  -
        3560625000000 *power(p, 2) *q *power(r, 5) *power(s, 3)  -
        975000000000 *q *power(r, 6) *power(s, 3)  +  462459375 *power(p, 11) *power(s, 4)  +
        14210859375 *power(p, 8) *power(q, 2) *power(s, 4)  +    99521718750 *power(p, 5) *power(q, 4) *power(s, 4)  +
        114955468750 *power(p, 2) *power(q, 6) *power(s, 4)  -
        17720859375 *power(p, 9) *r *power(s, 4)  -  100320703125 *power(p, 6) *power(q, 2) *r *power(s, 4)  +
        1021943359375 *power(p, 3) *power(q, 4) *r *power(s, 4)  +
        1193203125000 *power(q, 6) *r *power(s, 4)  +
        171371250000 *power(p, 7) *power(r, 2) *power(s, 4)  -
        1113390625000 *power(p, 4) *power(q, 2) *power(r, 2) *power(s, 4)  -
        1211474609375 *p *power(q, 4) *power(r, 2) *power(s, 4)  -  274056250000 *power(p, 5) *power(r, 3) *power(s, 4)  +
        8285166015625 *power(p, 2) *power(q, 2) *power(r, 3) *power(s, 4)  -
        2079375000000 *power(p, 3) *power(r, 4) *power(s, 4)  +
        5137304687500 *power(q, 2) *power(r, 4) *power(s, 4)  +  6187500000000 *p *power(r, 5) *power(s, 4)  -
        135675000000 *power(p, 7) *q *power(s, 5)  -  1275244140625 *power(p, 4) *power(q, 3) *power(s, 5)  -
        28388671875 *p *power(q, 5) *power(s, 5)  +
        1015166015625 *power(p, 5) *q *r *power(s, 5)  -
        10584423828125 *power(p, 2) *power(q, 3) *r *power(s, 5)  +
        3559570312500 *power(p, 3) *q *power(r, 2) *power(s, 5)  -
        6929931640625 *power(q, 3) *power(r, 2) *power(s, 5)  -  32304687500000 *p *q *power(r, 3) *power(s, 5)  +
        430576171875 *power(p, 6) *power(s, 6)  +  9397949218750 *power(p, 3) *power(q, 2) *power(s, 6)  +
        575195312500 *power(q, 4) *power(s, 6)  -  4086425781250 *power(p, 4) *r *power(s, 6)  +
        42183837890625 *p *power(q, 2) *r *power(s, 6)  +
        8156494140625 *power(p, 2) *power(r, 2) *power(s, 6)  +    12612304687500 *power(r, 3) *power(s, 6)  -
        25513916015625 *power(p, 2) *q *power(s, 7)  -
        37017822265625 *q *r *power(s, 7)  +  18981933593750 *p *power(s, 8))

   o3 = (1600 *power(p, 10) *power(q, 6)  +  9200 *power(p, 7) *power(q, 8)  -  126000 *power(p, 4) *power(q, 10)  -
        777600 *p *power(q, 12)  -    14400 *power(p, 11) *power(q, 4) *r  -
        119300 *power(p, 8) *power(q, 6) *r  +  1203225 *power(p, 5) *power(q, 8) *r  +
        9412200 *power(p, 2) *power(q, 10) *r  +  32400 *power(p, 12) *power(q, 2) *power(r, 2)  +
        417950 *power(p, 9) *power(q, 4) *power(r, 2)  -    4543725 *power(p, 6) *power(q, 6) *power(r, 2)  -
        49008125 *power(p, 3) *power(q, 8) *power(r, 2)  -  24192000 *power(q, 10) *power(r, 2)  -
        292050 *power(p, 10) *power(q, 2) *power(r, 3)  +  8760000 *power(p, 7) *power(q, 4) *power(r, 3)  +
        137506625 *power(p, 4) *power(q, 6) *power(r, 3)  +    225438750 *p *power(q, 8) *power(r, 3)  -
        4213250 *power(p, 8) *power(q, 2) *power(r, 4)  -  173595625 *power(p, 5) *power(q, 4) *power(r, 4)  -
        653003125 *power(p, 2) *power(q, 6) *power(r, 4)  +  82575000 *power(p, 6) *power(q, 2) *power(r, 5)  +
        838125000 *power(p, 3) *power(q, 4) *power(r, 5)  +    578562500 *power(q, 6) *power(r, 5)  -
        421500000 *power(p, 4) *power(q, 2) *power(r, 6)  -  1796250000 *p *power(q, 4) *power(r, 6)  +
        1050000000 *power(p, 2) *power(q, 2) *power(r, 7)  +  43200 *power(p, 12) *power(q, 3) *s  +
        807300 *power(p, 9) *power(q, 5) *s  +    5328225 *power(p, 6) *power(q, 7) *s  +
        16946250 *power(p, 3) *power(q, 9) *s  +  29565000 *power(q, 11) *s  -
        194400 *power(p, 13) *q *r *s  -  5505300 *power(p, 10) *power(q, 3) *r *s  -
        49886700 *power(p, 7) *power(q, 5) *r *s  -    178821875 *power(p, 4) *power(q, 7) *r *s  -
        222750000 *p *power(q, 9) *r *s  +  6814800 *power(p, 11) *q *power(r, 2) *s  +
        120525625 *power(p, 8) *power(q, 3) *power(r, 2) *s  +  526694500 *power(p, 5) *power(q, 5) *power(r, 2) *s  +
        84065625 *power(p, 2) *power(q, 7) *power(r, 2) *s  -  123670500 *power(p, 9) *q *power(r, 3) *s  -
        1106731875 *power(p, 6) *power(q, 3) *power(r, 3) *s  -
        669556250 *power(p, 3) *power(q, 5) *power(r, 3) *s  -    2869265625 *power(q, 7) *power(r, 3) *s  +
        1004350000 *power(p, 7) *q *power(r, 4) *s  +
        3384375000 *power(p, 4) *power(q, 3) *power(r, 4) *s  +  5665625000 *p *power(q, 5) *power(r, 4) *s  -
        3411000000 *power(p, 5) *q *power(r, 5) *s  -  418750000 *power(p, 2) *power(q, 3) *power(r, 5) *s  +
        1700000000 *power(p, 3) *q *power(r, 6) *s  -  10500000000 *power(q, 3) *power(r, 6) *s  +
        291600 *power(p, 14) *power(s, 2)  +    9829350 *power(p, 11) *power(q, 2) *power(s, 2)  +
        114151875 *power(p, 8) *power(q, 4) *power(s, 2)  +  522169375 *power(p, 5) *power(q, 6) *power(s, 2)  +
        716906250 *power(p, 2) *power(q, 8) *power(s, 2)  -  18625950 *power(p, 12) *r *power(s, 2)  -
        387703125 *power(p, 9) *power(q, 2) *r *power(s, 2)  -
        2056109375 *power(p, 6) *power(q, 4) *r *power(s, 2)  -  760203125 *power(p, 3) *power(q, 6) *r *power(s, 2)  +
        3071250000 *power(q, 8) *r *power(s, 2)  +  512419500 *power(p, 10) *power(r, 2) *power(s, 2)  +
        5859053125 *power(p, 7) *power(q, 2) *power(r, 2) *power(s, 2)  +
        12154062500 *power(p, 4) *power(q, 4) *power(r, 2) *power(s, 2)  +
        15931640625 *p *power(q, 6) *power(r, 2) *power(s, 2)  -  6598393750 *power(p, 8) *power(r, 3) *power(s, 2)  -
        43549625000 *power(p, 5) *power(q, 2) *power(r, 3) *power(s, 2)  -
        82011328125 *power(p, 2) *power(q, 4) *power(r, 3) *power(s, 2)  +
        43538125000 *power(p, 6) *power(r, 4) *power(s, 2)  +  160831250000 *power(p, 3) *power(q, 2) *power(r, 4) *power(s, 2)  +
        99070312500 *power(q, 4) *power(r, 4) *power(s, 2)  -
        141812500000 *power(p, 4) *power(r, 5) *power(s, 2)  -
        117500000000 *p *power(q, 2) *power(r, 5) *power(s, 2)  +  183750000000 *power(p, 2) *power(r, 6) *power(s, 2)  -
        154608750 *power(p, 10) *q *power(s, 3)  -  3309468750 *power(p, 7) *power(q, 3) *power(s, 3)  -
        20834140625 *power(p, 4) *power(q, 5) *power(s, 3)  -  34731562500 *p *power(q, 7) *power(s, 3)  +
        5970375000 *power(p, 8) *q *r *power(s, 3)  +
        68533281250 *power(p, 5) *power(q, 3) *r *power(s, 3)  +
        142698281250 *power(p, 2) *power(q, 5) *r *power(s, 3)  -
        74509140625 *power(p, 6) *q *power(r, 2) *power(s, 3)  -
        389148437500 *power(p, 3) *power(q, 3) *power(r, 2) *power(s, 3)  -
        270937890625 *power(q, 5) *power(r, 2) *power(s, 3)  +
        366696875000 *power(p, 4) *q *power(r, 3) *power(s, 3)  +
        400031250000 *p *power(q, 3) *power(r, 3) *power(s, 3)  -
        735156250000 *power(p, 2) *q *power(r, 4) *power(s, 3)  -  262500000000 *q *power(r, 5) *power(s, 3)  +
        371250000 *power(p, 9) *power(s, 4)  +  21315000000 *power(p, 6) *power(q, 2) *power(s, 4)  +
        179515625000 *power(p, 3) *power(q, 4) *power(s, 4)  +    238406250000 *power(q, 6) *power(s, 4)  -
        9071015625 *power(p, 7) *r *power(s, 4)  -
        268945312500 *power(p, 4) *power(q, 2) *r *power(s, 4)  -  379785156250 *p *power(q, 4) *r *power(s, 4)  +
        140262890625 *power(p, 5) *power(r, 2) *power(s, 4)  +
        1486259765625 *power(p, 2) *power(q, 2) *power(r, 2) *power(s, 4)  -
        806484375000 *power(p, 3) *power(r, 3) *power(s, 4)  +  1066210937500 *power(q, 2) *power(r, 3) *power(s, 4)  +
        1722656250000 *p *power(r, 4) *power(s, 4)  -  125648437500 *power(p, 5) *q *power(s, 5)  -
        1236279296875 *power(p, 2) *power(q, 3) *power(s, 5)  +
        1267871093750 *power(p, 3) *q *r *power(s, 5)  -
        1044677734375 *power(q, 3) *r *power(s, 5)  -  6630859375000 *p *q *power(r, 2) *power(s, 5)  +
        160888671875 *power(p, 4) *power(s, 6)  +  6352294921875 *p *power(q, 2) *power(s, 6)  -
        708740234375 *power(p, 2) *r *power(s, 6)  +  3901367187500 *power(r, 2) *power(s, 6)  -
        8050537109375 *q *power(s, 7))

   o4 = (2800 *power(p, 8) *power(q, 6)  +  41300 *power(p, 5) *power(q, 8)  +  151200 *power(p, 2) *power(q, 10)  -
        25200 *power(p, 9) *power(q, 4) *r  -    542600 *power(p, 6) *power(q, 6) *r  -
        3397875 *power(p, 3) *power(q, 8) *r  -  5751000 *power(q, 10) *r  +
        56700 *power(p, 10) *power(q, 2) *power(r, 2)  +  1972125 *power(p, 7) *power(q, 4) *power(r, 2)  +
        18624250 *power(p, 4) *power(q, 6) *power(r, 2)  +    50253750 *p *power(q, 8) *power(r, 2)  -
        1701000 *power(p, 8) *power(q, 2) *power(r, 3)  -  32630625 *power(p, 5) *power(q, 4) *power(r, 3)  -
        139868750 *power(p, 2) *power(q, 6) *power(r, 3)  +  18162500 *power(p, 6) *power(q, 2) *power(r, 4)  +
        177125000 *power(p, 3) *power(q, 4) *power(r, 4)  +    121734375 *power(q, 6) *power(r, 4)  -
        100500000 *power(p, 4) *power(q, 2) *power(r, 5)  -  386250000 *p *power(q, 4) *power(r, 5)  +
        225000000 *power(p, 2) *power(q, 2) *power(r, 6)  +  75600 *power(p, 10) *power(q, 3) *s  +
        1708800 *power(p, 7) *power(q, 5) *s  +    12836875 *power(p, 4) *power(q, 7) *s  +
        32062500 *p *power(q, 9) *s  -  340200 *power(p, 11) *q *r *s  -
        10185750 *power(p, 8) *power(q, 3) *r *s  -  97502750 *power(p, 5) *power(q, 5) *r *s  -
        301640625 *power(p, 2) *power(q, 7) *r *s  +    7168500 *power(p, 9) *q *power(r, 2) *s  +
        135960625 *power(p, 6) *power(q, 3) *power(r, 2) *s  +
        587471875 *power(p, 3) *power(q, 5) *power(r, 2) *s  -  384750000 *power(q, 7) *power(r, 2) *s  -
        29325000 *power(p, 7) *q *power(r, 3) *s  -    320625000 *power(p, 4) *power(q, 3) *power(r, 3) *s  +
        523437500 *p *power(q, 5) *power(r, 3) *s  -  42000000 *power(p, 5) *q *power(r, 4) *s  +
        343750000 *power(p, 2) *power(q, 3) *power(r, 4) *s  +  150000000 *power(p, 3) *q *power(r, 5) *s  -
        2250000000 *power(q, 3) *power(r, 5) *s  +    510300 *power(p, 12) *power(s, 2)  +
        12808125 *power(p, 9) *power(q, 2) *power(s, 2)  +  107062500 *power(p, 6) *power(q, 4) *power(s, 2)  +
        270312500 *power(p, 3) *power(q, 6) *power(s, 2)  -  168750000 *power(q, 8) *power(s, 2)  -
        2551500 *power(p, 10) *r *power(s, 2)  -    5062500 *power(p, 7) *power(q, 2) *r *power(s, 2)  +
        712343750 *power(p, 4) *power(q, 4) *r *power(s, 2)  +
        4788281250 *p *power(q, 6) *r *power(s, 2)  -  256837500 *power(p, 8) *power(r, 2) *power(s, 2)  -
        3574812500 *power(p, 5) *power(q, 2) *power(r, 2) *power(s, 2)  -
        14967968750 *power(p, 2) *power(q, 4) *power(r, 2) *power(s, 2)  +
        4040937500 *power(p, 6) *power(r, 3) *power(s, 2)  +  26400000000 *power(p, 3) *power(q, 2) *power(r, 3) *power(s, 2)  +
        17083984375 *power(q, 4) *power(r, 3) *power(s, 2)  -  21812500000 *power(p, 4) *power(r, 4) *power(s, 2)  -
        24375000000 *p *power(q, 2) *power(r, 4) *power(s, 2)  +
        39375000000 *power(p, 2) *power(r, 5) *power(s, 2)  -    127265625 *power(p, 5) *power(q, 3) *power(s, 3)  -
        680234375 *power(p, 2) *power(q, 5) *power(s, 3)  -  2048203125 *power(p, 6) *q *r *power(s, 3)  -
        18794531250 *power(p, 3) *power(q, 3) *r *power(s, 3)  -  25050000000 *power(q, 5) *r *power(s, 3)  +
        26621875000 *power(p, 4) *q *power(r, 2) *power(s, 3)  +
        37007812500 *p *power(q, 3) *power(r, 2) *power(s, 3)  -
        105468750000 *power(p, 2) *q *power(r, 3) *power(s, 3)  -  56250000000 *q *power(r, 4) *power(s, 3)  +
        1124296875 *power(p, 7) *power(s, 4)  +  9251953125 *power(p, 4) *power(q, 2) *power(s, 4)  -
        8007812500 *p *power(q, 4) *power(s, 4)  -    4004296875 *power(p, 5) *r *power(s, 4)  +
        179931640625 *power(p, 2) *power(q, 2) *r *power(s, 4)  -
        75703125000 *power(p, 3) *power(r, 2) *power(s, 4)  +  133447265625 *power(q, 2) *power(r, 2) *power(s, 4)  +
        363281250000 *p *power(r, 3) *power(s, 4)  -  91552734375 *power(p, 3) *q *power(s, 5)  -
        19531250000 *power(q, 3) *power(s, 5)  -    751953125000 *p *q *r *power(s, 5)  +
        157958984375 *power(p, 2) *power(s, 6)  +  748291015625 *r *power(s, 6))

   o5 = (-14400 *power(p, 6) *power(q, 6)  -  212400 *power(p, 3) *power(q, 8)  -  777600 *power(q, 10)  +
        92100 *power(p, 7) *power(q, 4) *r  +    1689675 *power(p, 4) *power(q, 6) *r  +
        7371000 *p *power(q, 8) *r  -  122850 *power(p, 8) *power(q, 2) *power(r, 2)  -
        3735250 *power(p, 5) *power(q, 4) *power(r, 2)  -  22432500 *power(p, 2) *power(q, 6) *power(r, 2)  +
        2298750 *power(p, 6) *power(q, 2) *power(r, 3)  +    29390625 *power(p, 3) *power(q, 4) *power(r, 3)  +
        18000000 *power(q, 6) *power(r, 3)  -  17750000 *power(p, 4) *power(q, 2) *power(r, 4)  -
        62812500 *p *power(q, 4) *power(r, 4)  +  37500000 *power(p, 2) *power(q, 2) *power(r, 5)  -
        51300 *power(p, 8) *power(q, 3) *s  -    768025 *power(p, 5) *power(q, 5) *s  -
        2801250 *power(p, 2) *power(q, 7) *s  -  275400 *power(p, 9) *q *r *s  -
        5479875 *power(p, 6) *power(q, 3) *r *s  -  35538750 *power(p, 3) *power(q, 5) *r *s  -
        68850000 *power(q, 7) *r *s  +    12757500 *power(p, 7) *q *power(r, 2) *s  +
        133640625 *power(p, 4) *power(q, 3) *power(r, 2) *s  +  222609375 *p *power(q, 5) *power(r, 2) *s  -
        108500000 *power(p, 5) *q *power(r, 3) *s  -  290312500 *power(p, 2) *power(q, 3) *power(r, 3) *s  +
        275000000 *power(p, 3) *q *power(r, 4) *s  -  375000000 *power(q, 3) *power(r, 4) *s  +
        1931850 *power(p, 10) *power(s, 2)  +    40213125 *power(p, 7) *power(q, 2) *power(s, 2)  +
        253921875 *power(p, 4) *power(q, 4) *power(s, 2)  +  464062500 *p *power(q, 6) *power(s, 2)  -
        71077500 *power(p, 8) *r *power(s, 2)  -  818746875 *power(p, 5) *power(q, 2) *r *power(s, 2)  -
        1882265625 *power(p, 2) *power(q, 4) *r *power(s, 2)  +  826031250 *power(p, 6) *power(r, 2) *power(s, 2)  +
        4369687500 *power(p, 3) *power(q, 2) *power(r, 2) *power(s, 2)  +
        3107812500 *power(q, 4) *power(r, 2) *power(s, 2)  -    3943750000 *power(p, 4) *power(r, 3) *power(s, 2)  -
        5000000000 *p *power(q, 2) *power(r, 3) *power(s, 2)  +
        6562500000 *power(p, 2) *power(r, 4) *power(s, 2)  -  295312500 *power(p, 6) *q *power(s, 3)  -
        2938906250 *power(p, 3) *power(q, 3) *power(s, 3)  -    4848750000 *power(q, 5) *power(s, 3)  +
        3791484375 *power(p, 4) *q *r *power(s, 3)  +  7556250000 *p *power(q, 3) *r *power(s, 3)  -
        11960937500 *power(p, 2) *q *power(r, 2) *power(s, 3)  -  9375000000 *q *power(r, 3) *power(s, 3)  +
        1668515625 *power(p, 5) *power(s, 4)  +    20447265625 *power(p, 2) *power(q, 2) *power(s, 4)  -
        21955078125 *power(p, 3) *r *power(s, 4)  +    18984375000 *power(q, 2) *r *power(s, 4)  +
        67382812500 *p *power(r, 2) *power(s, 4)  -  120849609375 *p *q *power(s, 5)  +
        157226562500 *power(s, 6))

   Oh = (o0 + o1 * root + o2 * power(root, 2) + o3 * power(root, 3) + o4 * power(root, 4) + o5 * power(root, 5)) / (D*F)
   if mp.fabs((L4 - L1) * (L2 - L3) - Oh * delta) < 1e-9:
      L1, L4 = L4, L1
   elif mp.fabs((L1 - L4) * (L3 - L2) - Oh * delta) < 1e-9:
      L2, L3 = L3, L2
   elif mp.fabs((L4 - L1) * (L3 - L2) - Oh * delta) < 1e-9:
      L1, L4 = L4, L1
      L2, L3 = L3, L2
   #print("L1 = ", L1)
   #print("L2 = ", L2)
   #print("L3 = ", L3)
   #print("L4 = ", L4)

   a0 = (-100 *power(p, 7) *power(q, 7)  -  2175 *power(p, 4) *power(q, 9)  -  10500 *p *power(q, 11)  +
        1100 *power(p, 8) *power(q, 5) *r  +    27975 *power(p, 5) *power(q, 7) *r  +
        152950 *power(p, 2) *power(q, 9) *r  -  4125 *power(p, 9) *power(q, 3) *power(r, 2)  -
        128875 *power(p, 6) *power(q, 5) *power(r, 2)  -  830525 *power(p, 3) *power(q, 7) *power(r, 2)  +
        59450 *power(q, 9) *power(r, 2)  +  5400 *power(p, 10) *q *power(r, 3)  +
        243800 *power(p, 7) *power(q, 3) *power(r, 3)  +  2082650 *power(p, 4) *power(q, 5) *power(r, 3)  -
        333925 *p *power(q, 7) *power(r, 3)  -    139200 *power(p, 8) *q *power(r, 4)  -
        2406000 *power(p, 5) *power(q, 3) *power(r, 4)  -  122600 *power(p, 2) *power(q, 5) *power(r, 4)  +
        1254400 *power(p, 6) *q *power(r, 5)  +  3776000 *power(p, 3) *power(q, 3) *power(r, 5)  +
        1832000 *power(q, 5) *power(r, 5)  -    4736000 *power(p, 4) *q *power(r, 6)  -
        6720000 *p *power(q, 3) *power(r, 6)  +  6400000 *power(p, 2) *q *power(r, 7)  -
        900 *power(p, 9) *power(q, 4) *s  -  37400 *power(p, 6) *power(q, 6) *s  -
        281625 *power(p, 3) *power(q, 8) *s  -  435000 *power(q, 10) *s  +
        6750 *power(p, 10) *power(q, 2) *r *s  +  322300 *power(p, 7) *power(q, 4) *r *s  +
        2718575 *power(p, 4) *power(q, 6) *r *s  +    4214250 *p *power(q, 8) *r *s  -
        16200 *power(p, 11) *power(r, 2) *s  -  859275 *power(p, 8) *power(q, 2) *power(r, 2) *s  -
        8925475 *power(p, 5) *power(q, 4) *power(r, 2) *s  -  14427875 *power(p, 2) *power(q, 6) *power(r, 2) *s  +
        453600 *power(p, 9) *power(r, 3) *s  +    10038400 *power(p, 6) *power(q, 2) *power(r, 3) *s  +
        17397500 *power(p, 3) *power(q, 4) *power(r, 3) *s  -  11333125 *power(q, 6) *power(r, 3) *s  -
        4451200 *power(p, 7) *power(r, 4) *s  -  15850000 *power(p, 4) *power(q, 2) *power(r, 4) *s  +
        34000000 *p *power(q, 4) *power(r, 4) *s  +    17984000 *power(p, 5) *power(r, 5) *s  -
        10000000 *power(p, 2) *power(q, 2) *power(r, 5) *s  -  25600000 *power(p, 3) *power(r, 6) *s  -
        8000000 *power(q, 2) *power(r, 6) *s  +  6075 *power(p, 11) *q *power(s, 2)  -
        83250 *power(p, 8) *power(q, 3) *power(s, 2)  -    1282500 *power(p, 5) *power(q, 5) *power(s, 2)  -
        2862500 *power(p, 2) *power(q, 7) *power(s, 2)  +  724275 *power(p, 9) *q *r *power(s, 2)  +
        9807250 *power(p, 6) *power(q, 3) *r *power(s, 2)  +  28374375 *power(p, 3) *power(q, 5) *r *power(s, 2)  +
        22212500 *power(q, 7) *r *power(s, 2)  -    8982000 *power(p, 7) *q *power(r, 2) *power(s, 2)  -
        39600000 *power(p, 4) *power(q, 3) *power(r, 2) *power(s, 2)  -
        61746875 *p *power(q, 5) *power(r, 2) *power(s, 2)  -  1010000 *power(p, 5) *q *power(r, 3) *power(s, 2)  -
        1000000 *power(p, 2) *power(q, 3) *power(r, 3) *power(s, 2)  +  78000000 *power(p, 3) *q *power(r, 4) *power(s, 2)  +
        30000000 *power(q, 3) *power(r, 4) *power(s, 2)  +  80000000 *p *q *power(r, 5) *power(s, 2)  -
        759375 *power(p, 10) *power(s, 3)  -    9787500 *power(p, 7) *power(q, 2) *power(s, 3)  -
        39062500 *power(p, 4) *power(q, 4) *power(s, 3)  -  52343750 *p *power(q, 6) *power(s, 3)  +
        12301875 *power(p, 8) *r *power(s, 3)  +  98175000 *power(p, 5) *power(q, 2) *r *power(s, 3)  +
        225078125 *power(p, 2) *power(q, 4) *r *power(s, 3)  -    54900000 *power(p, 6) *power(r, 2) *power(s, 3)  -
        310000000 *power(p, 3) *power(q, 2) *power(r, 2) *power(s, 3)  -  7890625 *power(q, 4) *power(r, 2) *power(s, 3)  +
        51250000 *power(p, 4) *power(r, 3) *power(s, 3)  -  420000000 *p *power(q, 2) *power(r, 3) *power(s, 3)  +
        110000000 *power(p, 2) *power(r, 4) *power(s, 3)  -    200000000 *power(r, 5) *power(s, 3)  +
        2109375 *power(p, 6) *q *power(s, 4)  -  21093750 *power(p, 3) *power(q, 3) *power(s, 4)  -
        89843750 *power(q, 5) *power(s, 4)  +  182343750 *power(p, 4) *q *r *power(s, 4)  +
        733203125 *p *power(q, 3) *r *power(s, 4)  -    196875000 *power(p, 2) *q *power(r, 2) *power(s, 4)  +
        1125000000 *q *power(r, 3) *power(s, 4)  -  158203125 *power(p, 5) *power(s, 5)  -
        566406250 *power(p, 2) *power(q, 2) *power(s, 5)  +  101562500 *power(p, 3) *r *power(s, 5)  -
        1669921875 *power(q, 2) *r *power(s, 5)  +    1250000000 *p *power(r, 2) *power(s, 5)  -
        1220703125 *p *q *power(s, 6)  +  6103515625 *power(s, 7))

   a1 = (1000 *power(p, 5) *power(q, 7)  +  7250 *power(p, 2) *power(q, 9)  -  10800 *power(p, 6) *power(q, 5) *r  -
        96900 *power(p, 3) *power(q, 7) *r  -    52500 *power(q, 9) *r  +
        37400 *power(p, 7) *power(q, 3) *power(r, 2)  +  470850 *power(p, 4) *power(q, 5) *power(r, 2)  +
        640600 *p *power(q, 7) *power(r, 2)  -    39600 *power(p, 8) *q *power(r, 3)  -
        983600 *power(p, 5) *power(q, 3) *power(r, 3)  -  2848100 *power(p, 2) *power(q, 5) *power(r, 3)  +
        814400 *power(p, 6) *q *power(r, 4)  +  6076000 *power(p, 3) *power(q, 3) *power(r, 4)  +
        2308000 *power(q, 5) *power(r, 4)  -    5024000 *power(p, 4) *q *power(r, 5)  -
        9680000 *p *power(q, 3) *power(r, 5)  +  9600000 *power(p, 2) *q *power(r, 6)  +
        13800 *power(p, 7) *power(q, 4) *s  +  94650 *power(p, 4) *power(q, 6) *s  -
        26500 *p *power(q, 8) *s  -  86400 *power(p, 8) *power(q, 2) *r *s  -
        816500 *power(p, 5) *power(q, 4) *r *s  -  257500 *power(p, 2) *power(q, 6) *r *s  +
        91800 *power(p, 9) *power(r, 2) *s  +    1853700 *power(p, 6) *power(q, 2) *power(r, 2) *s  +
        630000 *power(p, 3) *power(q, 4) *power(r, 2) *s  -  8971250 *power(q, 6) *power(r, 2) *s  -
        2071200 *power(p, 7) *power(r, 3) *s  -  7240000 *power(p, 4) *power(q, 2) *power(r, 3) *s  +
        29375000 *p *power(q, 4) *power(r, 3) *s  +    14416000 *power(p, 5) *power(r, 4) *s  -
        5200000 *power(p, 2) *power(q, 2) *power(r, 4) *s  -  30400000 *power(p, 3) *power(r, 5) *s  -
        12000000 *power(q, 2) *power(r, 5) *s  +  64800 *power(p, 9) *q *power(s, 2)  +
        567000 *power(p, 6) *power(q, 3) *power(s, 2)  +    1655000 *power(p, 3) *power(q, 5) *power(s, 2)  +
        6987500 *power(q, 7) *power(s, 2)  +  337500 *power(p, 7) *q *r *power(s, 2)  +
        8462500 *power(p, 4) *power(q, 3) *r *power(s, 2)  -  5812500 *p *power(q, 5) *r *power(s, 2)  -
        24930000 *power(p, 5) *q *power(r, 2) *power(s, 2)  -
        69125000 *power(p, 2) *power(q, 3) *power(r, 2) *power(s, 2)  +  103500000 *power(p, 3) *q *power(r, 3) *power(s, 2)  +
        30000000 *power(q, 3) *power(r, 3) *power(s, 2)  +  90000000 *p *q *power(r, 4) *power(s, 2)  -
        708750 *power(p, 8) *power(s, 3)  -    5400000 *power(p, 5) *power(q, 2) *power(s, 3)  +
        8906250 *power(p, 2) *power(q, 4) *power(s, 3)  +  18562500 *power(p, 6) *r *power(s, 3)  -
        625000 *power(p, 3) *power(q, 2) *r *power(s, 3)  +  29687500 *power(q, 4) *r *power(s, 3)  -
        75000000 *power(p, 4) *power(r, 2) *power(s, 3)  -    416250000 *p *power(q, 2) *power(r, 2) *power(s, 3)  +
        60000000 *power(p, 2) *power(r, 3) *power(s, 3)  -  300000000 *power(r, 4) *power(s, 3)  +
        71718750 *power(p, 4) *q *power(s, 4)  +  189062500 *p *power(q, 3) *power(s, 4)  +
        210937500 *power(p, 2) *q *r *power(s, 4)  +    1187500000 *q *power(r, 2) *power(s, 4)  -
        187500000 *power(p, 3) *power(s, 5)  -  800781250 *power(q, 2) *power(s, 5)  -
        390625000 *p *r *power(s, 5))

   a2 = (-500 *power(p, 6) *power(q, 5)  -  6350 *power(p, 3) *power(q, 7)  -  19800 *power(q, 9)  +
        3750 *power(p, 7) *power(q, 3) *r  +  65100 *power(p, 4) *power(q, 5) *r  +
        264950 *p *power(q, 7) *r  -  6750 *power(p, 8) *q *power(r, 2)  -
        209050 *power(p, 5) *power(q, 3) *power(r, 2)  -    1217250 *power(p, 2) *power(q, 5) *power(r, 2)  +
        219000 *power(p, 6) *q *power(r, 3)  +  2510000 *power(p, 3) *power(q, 3) *power(r, 3)  +
        1098500 *power(q, 5) *power(r, 3)  -  2068000 *power(p, 4) *q *power(r, 4)  -
        5060000 *p *power(q, 3) *power(r, 4)  +    5200000 *power(p, 2) *q *power(r, 5)  -
        6750 *power(p, 8) *power(q, 2) *s  -  96350 *power(p, 5) *power(q, 4) *s  -
        346000 *power(p, 2) *power(q, 6) *s  +  20250 *power(p, 9) *r *s  +
        459900 *power(p, 6) *power(q, 2) *r *s  +    1828750 *power(p, 3) *power(q, 4) *r *s  -
        2930000 *power(q, 6) *r *s  -  594000 *power(p, 7) *power(r, 2) *s  -
        4301250 *power(p, 4) *power(q, 2) *power(r, 2) *s  +  10906250 *p *power(q, 4) *power(r, 2) *s  +
        5252000 *power(p, 5) *power(r, 3) *s  -    1450000 *power(p, 2) *power(q, 2) *power(r, 3) *s  -
        12800000 *power(p, 3) *power(r, 4) *s  -  6500000 *power(q, 2) *power(r, 4) *s  +
        74250 *power(p, 7) *q *power(s, 2)  +  1418750 *power(p, 4) *power(q, 3) *power(s, 2)  +
        5956250 *p *power(q, 5) *power(s, 2)  -    4297500 *power(p, 5) *q *r *power(s, 2)  -
        29906250 *power(p, 2) *power(q, 3) *r *power(s, 2)  +  31500000 *power(p, 3) *q *power(r, 2) *power(s, 2)  +
        12500000 *power(q, 3) *power(r, 2) *power(s, 2)  +  35000000 *p *q *power(r, 3) *power(s, 2)  +
        1350000 *power(p, 6) *power(s, 3)  +    6093750 *power(p, 3) *power(q, 2) *power(s, 3)  +
        17500000 *power(q, 4) *power(s, 3)  -  7031250 *power(p, 4) *r *power(s, 3)  -
        127812500 *p *power(q, 2) *r *power(s, 3)  +  18750000 *power(p, 2) *power(r, 2) *power(s, 3)  -
        162500000 *power(r, 3) *power(s, 3)  +    107812500 *power(p, 2) *q *power(s, 4)  +
        460937500 *q *r *power(s, 4)  -  214843750 *p *power(s, 5))

   a3 = (1950 *power(p, 4) *power(q, 5)  +  14100 *p *power(q, 7)  -  14350 *power(p, 5) *power(q, 3) *r  -
        125600 *power(p, 2) *power(q, 5) *r  +    27900 *power(p, 6) *q *power(r, 2)  +
        402250 *power(p, 3) *power(q, 3) *power(r, 2)  +  288250 *power(q, 5) *power(r, 2)  -
        436000 *power(p, 4) *q *power(r, 3)  -    1345000 *p *power(q, 3) *power(r, 3)  +
        1400000 *power(p, 2) *q *power(r, 4)  +  9450 *power(p, 6) *power(q, 2) *s  -
        1250 *power(p, 3) *power(q, 4) *s  -    465000 *power(q, 6) *s  -
        49950 *power(p, 7) *r *s  -  302500 *power(p, 4) *power(q, 2) *r *s  +
        1718750 *p *power(q, 4) *r *s  +    834000 *power(p, 5) *power(r, 2) *s  +
        437500 *power(p, 2) *power(q, 2) *power(r, 2) *s  -  3100000 *power(p, 3) *power(r, 3) *s  -
        1750000 *power(q, 2) *power(r, 3) *s  -  292500 *power(p, 5) *q *power(s, 2)  -
        1937500 *power(p, 2) *power(q, 3) *power(s, 2)  +    3343750 *power(p, 3) *q *r *power(s, 2)  +
        1875000 *power(q, 3) *r *power(s, 2)  +  8125000 *p *q *power(r, 2) *power(s, 2)  -
        1406250 *power(p, 4) *power(s, 3)  -  12343750 *p *power(q, 2) *power(s, 3)  +
        5312500 *power(p, 2) *r *power(s, 3)  -    43750000 *power(r, 2) *power(s, 3)  +
        74218750 *q *power(s, 4))

   a4 = (-300 *power(p, 5) *power(q, 3)  -  2150 *power(p, 2) *power(q, 5)  +  1350 *power(p, 6) *q *r  +
        21500 *power(p, 3) *power(q, 3) *r  +  61500 *power(q, 5) *r  -
        42000 *power(p, 4) *q *power(r, 2)  -  290000 *p *power(q, 3) *power(r, 2)  +
        300000 *power(p, 2) *q *power(r, 3)  -  4050 *power(p, 7) *s  -
        45000 *power(p, 4) *power(q, 2) *s  -  125000 *p *power(q, 4) *s  +
        108000 *power(p, 5) *r *s  +    643750 *power(p, 2) *power(q, 2) *r *s  -
        700000 *power(p, 3) *power(r, 2) *s  -  375000 *power(q, 2) *power(r, 2) *s  -
        93750 *power(p, 3) *q *power(s, 2)  -  312500 *power(q, 3) *power(s, 2)  +
        1875000 *p *q *r *power(s, 2)  -    1406250 *power(p, 2) *power(s, 3)  -
        9375000 *r *power(s, 3))

   a5 = (1250 *power(p, 3) *power(q, 3)  +  9000 *power(q, 5)  -  4500 *power(p, 4) *q *r  -
        46250 *p *power(q, 3) *r  +  50000 *power(p, 2) *q *power(r, 2)  +
        6750 *power(p, 5) *s  +  43750 *power(p, 2) *power(q, 2) *s  -  75000 *power(p, 3) *r *s  -
        62500 *power(q, 2) *r *s  +    156250 *p *q *power(s, 2)  -  1562500 *power(s, 3))

   L0 = (a0 + a1 * root + a2 * power(root, 2) + a3 * power(root, 3) + a4 * power(root, 4) + a5 * power(root, 5)) / F
   #print("L0 = ", L0)

   zeta = mp.root(1, 5, 1)
   R1 = L0 + L1*zeta + L2*power(zeta, 2) + L3*power(zeta, 3) + L4* power(zeta, 4)
   R2 = L0 + L3*zeta + L1*power(zeta, 2) + L4*power(zeta, 3) + L2* power(zeta, 4)
   R3 = L0 + L2*zeta + L4*power(zeta, 2) + L1*power(zeta, 3) + L3* power(zeta, 4)
   R4 = L0 + L4*zeta + L3*power(zeta, 2) + L2*power(zeta, 3) + L1* power(zeta, 4)
   #print("R1 =", R1)
   #print("R2 =", R2)
   #print("R3 =", R3)
   #print("R4 =", R4)

   c0 = (-40 *power(p, 5) *power(q, 11)  -  270 *power(p, 2) *power(q, 13)  +  700 *power(p, 6) *power(q, 9) *r  +
        5165 *power(p, 3) *power(q, 11) *r  +  540 *power(q, 13) *r  -
        4230 *power(p, 7) *power(q, 7) *power(r, 2)  -  31845 *power(p, 4) *power(q, 9) *power(r, 2)  +
        20880 *p *power(q, 11) *power(r, 2)  +    9645 *power(p, 8) *power(q, 5) *power(r, 3)  +
        57615 *power(p, 5) *power(q, 7) *power(r, 3)  -  358255 *power(p, 2) *power(q, 9) *power(r, 3)  -
        1880 *power(p, 9) *power(q, 3) *power(r, 4)  +  114020 *power(p, 6) *power(q, 5) *power(r, 4)  +
        2012190 *power(p, 3) *power(q, 7) *power(r, 4)  -    26855 *power(q, 9) *power(r, 4)  -
        14400 *power(p, 10) *q *power(r, 5)  -  470400 *power(p, 7) *power(q, 3) *power(r, 5)  -
        5088640 *power(p, 4) *power(q, 5) *power(r, 5)  +  920 *p *power(q, 7) *power(r, 5)  +
        332800 *power(p, 8) *q *power(r, 6)  +    5797120 *power(p, 5) *power(q, 3) *power(r, 6)  +
        1608000 *power(p, 2) *power(q, 5) *power(r, 6)  -  2611200 *power(p, 6) *q *power(r, 7)  -
        7424000 *power(p, 3) *power(q, 3) *power(r, 7)  -  2323200 *power(q, 5) *power(r, 7)  +
        8601600 *power(p, 4) *q *power(r, 8)  +    9472000 *p *power(q, 3) *power(r, 8)  -
        10240000 *power(p, 2) *q *power(r, 9)  -  3060 *power(p, 7) *power(q, 8) *s  -
        39085 *power(p, 4) *power(q, 10) *s  -  132300 *p *power(q, 12) *s  +
        36580 *power(p, 8) *power(q, 6) *r *s  +    520185 *power(p, 5) *power(q, 8) *r *s  +
        1969860 *power(p, 2) *power(q, 10) *r *s  -  144045 *power(p, 9) *power(q, 4) *power(r, 2) *s  -
        2438425 *power(p, 6) *power(q, 6) *power(r, 2) *s  -  10809475 *power(p, 3) *power(q, 8) *power(r, 2) *s  +
        518850 *power(q, 10) *power(r, 2) *s  +    182520 *power(p, 10) *power(q, 2) *power(r, 3) *s  +
        4533930 *power(p, 7) *power(q, 4) *power(r, 3) *s  +  26196770 *power(p, 4) *power(q, 6) *power(r, 3) *s  -
        4542325 *p *power(q, 8) *power(r, 3) *s  +  21600 *power(p, 11) *power(r, 4) *s  -
        2208080 *power(p, 8) *power(q, 2) *power(r, 4) *s  -    24787960 *power(p, 5) *power(q, 4) *power(r, 4) *s  +
        10813900 *power(p, 2) *power(q, 6) *power(r, 4) *s  -  499200 *power(p, 9) *power(r, 5) *s  +
        3827840 *power(p, 6) *power(q, 2) *power(r, 5) *s  +  9596000 *power(p, 3) *power(q, 4) *power(r, 5) *s  +
        22662000 *power(q, 6) *power(r, 5) *s  +    3916800 *power(p, 7) *power(r, 6) *s  -
        29952000 *power(p, 4) *power(q, 2) *power(r, 6) *s  -  90800000 *p *power(q, 4) *power(r, 6) *s  -
        12902400 *power(p, 5) *power(r, 7) *s  +  87040000 *power(p, 2) *power(q, 2) *power(r, 7) *s  +
        15360000 *power(p, 3) *power(r, 8) *s  +    12800000 *power(q, 2) *power(r, 8) *s  -
        38070 *power(p, 9) *power(q, 5) *power(s, 2)  -  566700 *power(p, 6) *power(q, 7) *power(s, 2)  -
        2574375 *power(p, 3) *power(q, 9) *power(s, 2)  -  1822500 *power(q, 11) *power(s, 2)  +
        292815 *power(p, 10) *power(q, 3) *r *power(s, 2)  +    5170280 *power(p, 7) *power(q, 5) *r *power(s, 2)  +
        27918125 *power(p, 4) *power(q, 7) *r *power(s, 2)  +  21997500 *p *power(q, 9) *r *power(s, 2)  -
        573480 *power(p, 11) *q *power(r, 2) *power(s, 2)  -  14566350 *power(p, 8) *power(q, 3) *power(r, 2) *power(s, 2)  -
        104851575 *power(p, 5) *power(q, 5) *power(r, 2) *power(s, 2)  -
        96448750 *power(p, 2) *power(q, 7) *power(r, 2) *power(s, 2)  +
        11001240 *power(p, 9) *q *power(r, 3) *power(s, 2)  +  147798600 *power(p, 6) *power(q, 3) *power(r, 3) *power(s, 2)  +
        158632750 *power(p, 3) *power(q, 5) *power(r, 3) *power(s, 2)  -  78222500 *power(q, 7) *power(r, 3) *power(s, 2)  -
        62819200 *power(p, 7) *q *power(r, 4) *power(s, 2)  -
        136160000 *power(p, 4) *power(q, 3) *power(r, 4) *power(s, 2)  +
        317555000 *p *power(q, 5) *power(r, 4) *power(s, 2)  +  160224000 *power(p, 5) *q *power(r, 5) *power(s, 2)  -
        267600000 *power(p, 2) *power(q, 3) *power(r, 5) *power(s, 2)  -
        153600000 *power(p, 3) *q *power(r, 6) *power(s, 2)  -    120000000 *power(q, 3) *power(r, 6) *power(s, 2)  -
        32000000 *p *q *power(r, 7) *power(s, 2)  -  127575 *power(p, 11) *power(q, 2) *power(s, 3)  -
        2148750 *power(p, 8) *power(q, 4) *power(s, 3)  -  13652500 *power(p, 5) *power(q, 6) *power(s, 3)  -
        19531250 *power(p, 2) *power(q, 8) *power(s, 3)  +    495720 *power(p, 12) *r *power(s, 3)  +
        11856375 *power(p, 9) *power(q, 2) *r *power(s, 3)  +  107807500 *power(p, 6) *power(q, 4) *r *power(s, 3)  +
        222334375 *power(p, 3) *power(q, 6) *r *power(s, 3)  +  105062500 *power(q, 8) *r *power(s, 3)  -
        11566800 *power(p, 10) *power(r, 2) *power(s, 3)  -
        216787500 *power(p, 7) *power(q, 2) *power(r, 2) *power(s, 3)  -  633437500 *power(p, 4) *power(q, 4) *power(r, 2) *power(s, 3)  -
        504484375 *p *power(q, 6) *power(r, 2) *power(s, 3)  +  90918000 *power(p, 8) *power(r, 3) *power(s, 3)  +
        567080000 *power(p, 5) *power(q, 2) *power(r, 3) *power(s, 3)  +
        692937500 *power(p, 2) *power(q, 4) *power(r, 3) *power(s, 3)  -
        326640000 *power(p, 6) *power(r, 4) *power(s, 3)  -  339000000 *power(p, 3) *power(q, 2) *power(r, 4) *power(s, 3)  +
        369250000 *power(q, 4) *power(r, 4) *power(s, 3)  +  560000000 *power(p, 4) *power(r, 5) *power(s, 3)  +
        508000000 *p *power(q, 2) *power(r, 5) *power(s, 3)  -  480000000 *power(p, 2) *power(r, 6) *power(s, 3)  +
        320000000 *power(r, 7) *power(s, 3)  -    455625 *power(p, 10) *q *power(s, 4)  -
        27562500 *power(p, 7) *power(q, 3) *power(s, 4)  -  120593750 *power(p, 4) *power(q, 5) *power(s, 4)  -
        60312500 *p *power(q, 7) *power(s, 4)  +  110615625 *power(p, 8) *q *r *power(s, 4)  +
        662984375 *power(p, 5) *power(q, 3) *r *power(s, 4)  +
        528515625 *power(p, 2) *power(q, 5) *r *power(s, 4)  -  541687500 *power(p, 6) *q *power(r, 2) *power(s, 4)  -
        1262343750 *power(p, 3) *power(q, 3) *power(r, 2) *power(s, 4)  -  466406250 *power(q, 5) *power(r, 2) *power(s, 4)  +
        633000000 *power(p, 4) *q *power(r, 3) *power(s, 4)  -
        1264375000 *p *power(q, 3) *power(r, 3) *power(s, 4)  +
        1085000000 *power(p, 2) *q *power(r, 4) *power(s, 4)  -  2700000000 *q *power(r, 5) *power(s, 4)  -
        68343750 *power(p, 9) *power(s, 5)  -    478828125 *power(p, 6) *power(q, 2) *power(s, 5)  -
        355468750 *power(p, 3) *power(q, 4) *power(s, 5)  -  11718750 *power(q, 6) *power(s, 5)  +
        718031250 *power(p, 7) *r *power(s, 5)  +  1658593750 *power(p, 4) *power(q, 2) *r *power(s, 5)  +
        2212890625 *p *power(q, 4) *r *power(s, 5)  -  2855625000 *power(p, 5) *power(r, 2) *power(s, 5)  -
        4273437500 *power(p, 2) *power(q, 2) *power(r, 2) *power(s, 5)  +
        4537500000 *power(p, 3) *power(r, 3) *power(s, 5)  +    8031250000 *power(q, 2) *power(r, 3) *power(s, 5)  -
        1750000000 *p *power(r, 4) *power(s, 5)  +  1353515625 *power(p, 5) *q *power(s, 6)  +
        1562500000 *power(p, 2) *power(q, 3) *power(s, 6)  -  3964843750 *power(p, 3) *q *r *power(s, 6)  -
        7226562500 *power(q, 3) *r *power(s, 6)  +    1953125000 *p *q *power(r, 2) *power(s, 6)  -
        1757812500 *power(p, 4) *power(s, 7)  -  3173828125 *p *power(q, 2) *power(s, 7)  +
        6445312500 *power(p, 2) *r *power(s, 7)  -  3906250000 *power(r, 2) *power(s, 7)  +
        6103515625 *q *power(s, 8))

   c1 = (40 *power(p, 6) *power(q, 9)  +  110 *power(p, 3) *power(q, 11)  -  1080 *power(q, 13)  -
        560 *power(p, 7) *power(q, 7) *r  -  1780 *power(p, 4) *power(q, 9) *r  +
        17370 *p *power(q, 11) *r  +  2850 *power(p, 8) *power(q, 5) *power(r, 2)  +
        10520 *power(p, 5) *power(q, 7) *power(r, 2)  -    115910 *power(p, 2) *power(q, 9) *power(r, 2)  -
        6090 *power(p, 9) *power(q, 3) *power(r, 3)  -  25330 *power(p, 6) *power(q, 5) *power(r, 3)  +
        448740 *power(p, 3) *power(q, 7) *power(r, 3)  +  128230 *power(q, 9) *power(r, 3)  +
        4320 *power(p, 10) *q *power(r, 4)  +  16960 *power(p, 7) *power(q, 3) *power(r, 4)  -
        1143600 *power(p, 4) *power(q, 5) *power(r, 4)  -  1410310 *p *power(q, 7) *power(r, 4)  +
        3840 *power(p, 8) *q *power(r, 5)  +    1744480 *power(p, 5) *power(q, 3) *power(r, 5)  +
        5619520 *power(p, 2) *power(q, 5) *power(r, 5)  -  1198080 *power(p, 6) *q *power(r, 6)  -
        10579200 *power(p, 3) *power(q, 3) *power(r, 6)  -  2940800 *power(q, 5) *power(r, 6)  +
        8294400 *power(p, 4) *q *power(r, 7)  +    13568000 *p *power(q, 3) *power(r, 7)  -
        15360000 *power(p, 2) *q *power(r, 8)  +  840 *power(p, 8) *power(q, 6) *s  +
        7580 *power(p, 5) *power(q, 8) *s  +  24420 *power(p, 2) *power(q, 10) *s  -
        8100 *power(p, 9) *power(q, 4) *r *s  -    94100 *power(p, 6) *power(q, 6) *r *s  -
        473000 *power(p, 3) *power(q, 8) *r *s  -  473400 *power(q, 10) *r *s  +
        22680 *power(p, 10) *power(q, 2) *power(r, 2) *s  +  374370 *power(p, 7) *power(q, 4) *power(r, 2) *s  +
        2888020 *power(p, 4) *power(q, 6) *power(r, 2) *s  +    5561050 *p *power(q, 8) *power(r, 2) *s  -
        12960 *power(p, 11) *power(r, 3) *s  -  485820 *power(p, 8) *power(q, 2) *power(r, 3) *s  -
        6723440 *power(p, 5) *power(q, 4) *power(r, 3) *s  -  23561400 *power(p, 2) *power(q, 6) *power(r, 3) *s  +
        190080 *power(p, 9) *power(r, 4) *s  +    5894880 *power(p, 6) *power(q, 2) *power(r, 4) *s  +
        50882000 *power(p, 3) *power(q, 4) *power(r, 4) *s  +  22411500 *power(q, 6) *power(r, 4) *s  -
        258560 *power(p, 7) *power(r, 5) *s  -  46248000 *power(p, 4) *power(q, 2) *power(r, 5) *s  -
        103800000 *p *power(q, 4) *power(r, 5) *s  -    3737600 *power(p, 5) *power(r, 6) *s  +
        119680000 *power(p, 2) *power(q, 2) *power(r, 6) *s  +  10240000 *power(p, 3) *power(r, 7) *s  +
        19200000 *power(q, 2) *power(r, 7) *s  +  7290 *power(p, 10) *power(q, 3) *power(s, 2)  +
        117360 *power(p, 7) *power(q, 5) *power(s, 2)  +    691250 *power(p, 4) *power(q, 7) *power(s, 2)  -
        198750 *p *power(q, 9) *power(s, 2)  -  36450 *power(p, 11) *q *r *power(s, 2)  -
        854550 *power(p, 8) *power(q, 3) *r *power(s, 2)  -  7340700 *power(p, 5) *power(q, 5) *r *power(s, 2)  -
        2028750 *power(p, 2) *power(q, 7) *r *power(s, 2)  +    995490 *power(p, 9) *q *power(r, 2) *power(s, 2)  +
        18896600 *power(p, 6) *power(q, 3) *power(r, 2) *power(s, 2)  +
        5026500 *power(p, 3) *power(q, 5) *power(r, 2) *power(s, 2)  -  52272500 *power(q, 7) *power(r, 2) *power(s, 2)  -
        16636800 *power(p, 7) *q *power(r, 3) *power(s, 2)  -  43200000 *power(p, 4) *power(q, 3) *power(r, 3) *power(s, 2)  +
        223426250 *p *power(q, 5) *power(r, 3) *power(s, 2)  +  112068000 *power(p, 5) *q *power(r, 4) *power(s, 2)  -
        177000000 *power(p, 2) *power(q, 3) *power(r, 4) *power(s, 2)  -
        244000000 *power(p, 3) *q *power(r, 5) *power(s, 2)  -    156000000 *power(q, 3) *power(r, 5) *power(s, 2)  +
        43740 *power(p, 12) *power(s, 3)  +  1032750 *power(p, 9) *power(q, 2) *power(s, 3)  +
        8602500 *power(p, 6) *power(q, 4) *power(s, 3)  +  15606250 *power(p, 3) *power(q, 6) *power(s, 3)  +
        39625000 *power(q, 8) *power(s, 3)  -    1603800 *power(p, 10) *r *power(s, 3)  -
        26932500 *power(p, 7) *power(q, 2) *r *power(s, 3)  -  19562500 *power(p, 4) *power(q, 4) *r *power(s, 3)  -
        152000000 *p *power(q, 6) *r *power(s, 3)  +  25555500 *power(p, 8) *power(r, 2) *power(s, 3)  +
        16230000 *power(p, 5) *power(q, 2) *power(r, 2) *power(s, 3)  +
        42187500 *power(p, 2) *power(q, 4) *power(r, 2) *power(s, 3)  -    165660000 *power(p, 6) *power(r, 3) *power(s, 3)  +
        373500000 *power(p, 3) *power(q, 2) *power(r, 3) *power(s, 3)  +
        332937500 *power(q, 4) *power(r, 3) *power(s, 3)  +  465000000 *power(p, 4) *power(r, 4) *power(s, 3)  +
        586000000 *p *power(q, 2) *power(r, 4) *power(s, 3)  -  592000000 *power(p, 2) *power(r, 5) *power(s, 3)  +
        480000000 *power(r, 6) *power(s, 3)  -    1518750 *power(p, 8) *q *power(s, 4)  -
        62531250 *power(p, 5) *power(q, 3) *power(s, 4)  +  7656250 *power(p, 2) *power(q, 5) *power(s, 4)  +
        184781250 *power(p, 6) *q *r *power(s, 4)  -  15781250 *power(p, 3) *power(q, 3) *r *power(s, 4)  -
        135156250 *power(q, 5) *r *power(s, 4)  -    1148250000 *power(p, 4) *q *power(r, 2) *power(s, 4)  -
        2121406250 *p *power(q, 3) *power(r, 2) *power(s, 4)  +
        1990000000 *power(p, 2) *q *power(r, 3) *power(s, 4)  -  3150000000 *q *power(r, 4) *power(s, 4)  -
        2531250 *power(p, 7) *power(s, 5)  +    660937500 *power(p, 4) *power(q, 2) *power(s, 5)  +
        1339843750 *p *power(q, 4) *power(s, 5)  -  33750000 *power(p, 5) *r *power(s, 5)  -
        679687500 *power(p, 2) *power(q, 2) *r *power(s, 5)  +  6250000 *power(p, 3) *power(r, 2) *power(s, 5)  +
        6195312500 *power(q, 2) *power(r, 2) *power(s, 5)  +    1125000000 *p *power(r, 3) *power(s, 5)  -
        996093750 *power(p, 3) *q *power(s, 6)  -  3125000000 *power(q, 3) *power(s, 6)  -
        3222656250 *p *q *r *power(s, 6)  +  1171875000 *power(p, 2) *power(s, 7)  +
        976562500 *r *power(s, 7))

   c2 = (80 *power(p, 4) *power(q, 9)  +  540 *p *power(q, 11)  -  600 *power(p, 5) *power(q, 7) *r  -
        4770 *power(p, 2) *power(q, 9) *r  +  1230 *power(p, 6) *power(q, 5) *power(r, 2)  +
        20900 *power(p, 3) *power(q, 7) *power(r, 2)  +  47250 *power(q, 9) *power(r, 2)  -
        710 *power(p, 7) *power(q, 3) *power(r, 3)  -  84950 *power(p, 4) *power(q, 5) *power(r, 3)  -
        526310 *p *power(q, 7) *power(r, 3)  +  720 *power(p, 8) *q *power(r, 4)  +
        216280 *power(p, 5) *power(q, 3) *power(r, 4)  +    2068020 *power(p, 2) *power(q, 5) *power(r, 4)  -
        198080 *power(p, 6) *q *power(r, 5)  -  3703200 *power(p, 3) *power(q, 3) *power(r, 5)  -
        1423600 *power(q, 5) *power(r, 5)  +  2860800 *power(p, 4) *q *power(r, 6)  +
        7056000 *p *power(q, 3) *power(r, 6)  -    8320000 *power(p, 2) *q *power(r, 7)  -
        2720 *power(p, 6) *power(q, 6) *s  -  46350 *power(p, 3) *power(q, 8) *s  -  178200 *power(q, 10) *s  +
        25740 *power(p, 7) *power(q, 4) *r *s  +  489490 *power(p, 4) *power(q, 6) *r *s  +
        2152350 *p *power(q, 8) *r *s  -    61560 *power(p, 8) *power(q, 2) *power(r, 2) *s  -
        1568150 *power(p, 5) *power(q, 4) *power(r, 2) *s  -  9060500 *power(p, 2) *power(q, 6) *power(r, 2) *s  +
        24840 *power(p, 9) *power(r, 3) *s  +  1692380 *power(p, 6) *power(q, 2) *power(r, 3) *s  +
        18098250 *power(p, 3) *power(q, 4) *power(r, 3) *s  +    9387750 *power(q, 6) *power(r, 3) *s  -
        382560 *power(p, 7) *power(r, 4) *s  -  16818000 *power(p, 4) *power(q, 2) *power(r, 4) *s  -
        49325000 *p *power(q, 4) *power(r, 4) *s  +  1212800 *power(p, 5) *power(r, 5) *s  +
        64840000 *power(p, 2) *power(q, 2) *power(r, 5) *s  -    320000 *power(p, 3) *power(r, 6) *s  +
        10400000 *power(q, 2) *power(r, 6) *s  -  36450 *power(p, 8) *power(q, 3) *power(s, 2)  -
        588350 *power(p, 5) *power(q, 5) *power(s, 2)  -  2156250 *power(p, 2) *power(q, 7) *power(s, 2)  +
        123930 *power(p, 9) *q *r *power(s, 2)  +    2879700 *power(p, 6) *power(q, 3) *r *power(s, 2)  +
        12548000 *power(p, 3) *power(q, 5) *r *power(s, 2)  -  14445000 *power(q, 7) *r *power(s, 2)  -
        3233250 *power(p, 7) *q *power(r, 2) *power(s, 2)  -  28485000 *power(p, 4) *power(q, 3) *power(r, 2) *power(s, 2)  +
        72231250 *p *power(q, 5) *power(r, 2) *power(s, 2)  +  32093000 *power(p, 5) *q *power(r, 3) *power(s, 2)  -
        61275000 *power(p, 2) *power(q, 3) *power(r, 3) *power(s, 2)  -
        107500000 *power(p, 3) *q *power(r, 4) *power(s, 2)  -    78500000 *power(q, 3) *power(r, 4) *power(s, 2)  +
        22000000 *p *q *power(r, 5) *power(s, 2)  -  72900 *power(p, 10) *power(s, 3)  -
        1215000 *power(p, 7) *power(q, 2) *power(s, 3)  -  2937500 *power(p, 4) *power(q, 4) *power(s, 3)  +
        9156250 *p *power(q, 6) *power(s, 3)  +    2612250 *power(p, 8) *r *power(s, 3)  +
        16560000 *power(p, 5) *power(q, 2) *r *power(s, 3)  -  75468750 *power(p, 2) *power(q, 4) *r *power(s, 3)  -
        32737500 *power(p, 6) *power(r, 2) *power(s, 3)  +  169062500 *power(p, 3) *power(q, 2) *power(r, 2) *power(s, 3)  +
        121718750 *power(q, 4) *power(r, 2) *power(s, 3)  +  160250000 *power(p, 4) *power(r, 3) *power(s, 3)  +
        219750000 *p *power(q, 2) *power(r, 3) *power(s, 3)  -  317000000 *power(p, 2) *power(r, 4) *power(s, 3)  +
        260000000 *power(r, 5) *power(s, 3)  +    2531250 *power(p, 6) *q *power(s, 4)  +
        22500000 *power(p, 3) *power(q, 3) *power(s, 4)  +  39843750 *power(q, 5) *power(s, 4)  -
        266343750 *power(p, 4) *q *r *power(s, 4)  -  776406250 *p *power(q, 3) *r *power(s, 4)  +
        789062500 *power(p, 2) *q *power(r, 2) *power(s, 4)  -  1368750000 *q *power(r, 3) *power(s, 4)  +
        67500000 *power(p, 5) *power(s, 5)  +    441406250 *power(p, 2) *power(q, 2) *power(s, 5)  -
        311718750 *power(p, 3) *r *power(s, 5)  +  1785156250 *power(q, 2) *r *power(s, 5)  +
        546875000 *p *power(r, 2) *power(s, 5)  -  1269531250 *p *q *power(s, 6)  +
        488281250 *power(s, 7))

   c3 = (120 *power(p, 5) *power(q, 7)  +  810 *power(p, 2) *power(q, 9)  -  1280 *power(p, 6) *power(q, 5) *r  -
        9160 *power(p, 3) *power(q, 7) *r  +  3780 *power(q, 9) *r  +
        4530 *power(p, 7) *power(q, 3) *power(r, 2)  +  36640 *power(p, 4) *power(q, 5) *power(r, 2)  -
        45270 *p *power(q, 7) *power(r, 2)  -  5400 *power(p, 8) *q *power(r, 3)  -
        60920 *power(p, 5) *power(q, 3) *power(r, 3)  +  200050 *power(p, 2) *power(q, 5) *power(r, 3)  +
        31200 *power(p, 6) *q *power(r, 4)  -    476000 *power(p, 3) *power(q, 3) *power(r, 4)  -
        378200 *power(q, 5) *power(r, 4)  +  521600 *power(p, 4) *q *power(r, 5)  +
        1872000 *p *power(q, 3) *power(r, 5)  -  2240000 *power(p, 2) *q *power(r, 6)  +
        1440 *power(p, 7) *power(q, 4) *s  +    15310 *power(p, 4) *power(q, 6) *s  +
        59400 *p *power(q, 8) *s  -  9180 *power(p, 8) *power(q, 2) *r *s  -
        115240 *power(p, 5) *power(q, 4) *r *s  -  589650 *power(p, 2) *power(q, 6) *r *s  +
        16200 *power(p, 9) *power(r, 2) *s  +    316710 *power(p, 6) *power(q, 2) *power(r, 2) *s  +
        2547750 *power(p, 3) *power(q, 4) *power(r, 2) *s  +  2178000 *power(q, 6) *power(r, 2) *s  -
        259200 *power(p, 7) *power(r, 3) *s  -  4123000 *power(p, 4) *power(q, 2) *power(r, 3) *s  -
        11700000 *p *power(q, 4) *power(r, 3) *s  +    937600 *power(p, 5) *power(r, 4) *s  +
        16340000 *power(p, 2) *power(q, 2) *power(r, 4) *s  -  640000 *power(p, 3) *power(r, 5) *s  +
        2800000 *power(q, 2) *power(r, 5) *s  -  2430 *power(p, 9) *q *power(s, 2)  -
        54450 *power(p, 6) *power(q, 3) *power(s, 2)  -    285500 *power(p, 3) *power(q, 5) *power(s, 2)  -
        2767500 *power(q, 7) *power(s, 2)  +  43200 *power(p, 7) *q *r *power(s, 2)  -
        916250 *power(p, 4) *power(q, 3) *r *power(s, 2)  +  14482500 *p *power(q, 5) *r *power(s, 2)  +
        4806000 *power(p, 5) *q *power(r, 2) *power(s, 2)  -
        13212500 *power(p, 2) *power(q, 3) *power(r, 2) *power(s, 2)  -  25400000 *power(p, 3) *q *power(r, 3) *power(s, 2)  -
        18750000 *power(q, 3) *power(r, 3) *power(s, 2)  +  8000000 *p *q *power(r, 4) *power(s, 2)  +
        121500 *power(p, 8) *power(s, 3)  +    2058750 *power(p, 5) *power(q, 2) *power(s, 3)  -
        6656250 *power(p, 2) *power(q, 4) *power(s, 3)  -  6716250 *power(p, 6) *r *power(s, 3)  +
        24125000 *power(p, 3) *power(q, 2) *r *power(s, 3)  +  23875000 *power(q, 4) *r *power(s, 3)  +
        43125000 *power(p, 4) *power(r, 2) *power(s, 3)  +    45750000 *p *power(q, 2) *power(r, 2) *power(s, 3)  -
        87500000 *power(p, 2) *power(r, 3) *power(s, 3)  +  70000000 *power(r, 4) *power(s, 3)  -
        44437500 *power(p, 4) *q *power(s, 4)  -  107968750 *p *power(q, 3) *power(s, 4)  +
        159531250 *power(p, 2) *q *r *power(s, 4)  -    284375000 *q *power(r, 2) *power(s, 4)  +
        7031250 *power(p, 3) *power(s, 5)  +  265625000 *power(q, 2) *power(s, 5)  +
        31250000 *p *r *power(s, 5))

   c4 = (160 *power(p, 3) *power(q, 7)  +  1080 *power(q, 9)  -  1080 *power(p, 4) *power(q, 5) *r  -
        8730 *p *power(q, 7) *r  +  1510 *power(p, 5) *power(q, 3) *power(r, 2)  +
        20420 *power(p, 2) *power(q, 5) *power(r, 2)  +  720 *power(p, 6) *q *power(r, 3)  -
        23200 *power(p, 3) *power(q, 3) *power(r, 3)  -  79900 *power(q, 5) *power(r, 3)  +
        35200 *power(p, 4) *q *power(r, 4)  +  404000 *p *power(q, 3) *power(r, 4)  -
        480000 *power(p, 2) *q *power(r, 5)  +  960 *power(p, 5) *power(q, 4) *s  +
        2850 *power(p, 2) *power(q, 6) *s  +  540 *power(p, 6) *power(q, 2) *r *s  +
        63500 *power(p, 3) *power(q, 4) *r *s  +  319500 *power(q, 6) *r *s  -
        7560 *power(p, 7) *power(r, 2) *s  -  253500 *power(p, 4) *power(q, 2) *power(r, 2) *s  -
        1806250 *p *power(q, 4) *power(r, 2) *s  +    91200 *power(p, 5) *power(r, 3) *s  +
        2600000 *power(p, 2) *power(q, 2) *power(r, 3) *s  -  80000 *power(p, 3) *power(r, 4) *s  +
        600000 *power(q, 2) *power(r, 4) *s  -  4050 *power(p, 7) *q *power(s, 2)  -
        120000 *power(p, 4) *power(q, 3) *power(s, 2)  -    273750 *p *power(q, 5) *power(s, 2)  +
        425250 *power(p, 5) *q *r *power(s, 2)  +  2325000 *power(p, 2) *power(q, 3) *r *power(s, 2)  -
        5400000 *power(p, 3) *q *power(r, 2) *power(s, 2)  -  2875000 *power(q, 3) *power(r, 2) *power(s, 2)  +
        1500000 *p *q *power(r, 3) *power(s, 2)  -    303750 *power(p, 6) *power(s, 3)  -
        843750 *power(p, 3) *power(q, 2) *power(s, 3)  -  812500 *power(q, 4) *power(s, 3)  +
        5062500 *power(p, 4) *r *power(s, 3)  +  13312500 *p *power(q, 2) *r *power(s, 3)  -
        14500000 *power(p, 2) *power(r, 2) *power(s, 3)  +    15000000 *power(r, 3) *power(s, 3)  -
        3750000 *power(p, 2) *q *power(s, 4)  -  35937500 *q *r *power(s, 4)  +
        11718750 *p *power(s, 5))

   c5 = (80 *power(p, 4) *power(q, 5)  +  540 *p *power(q, 7)  -  600 *power(p, 5) *power(q, 3) *r  -
        4770 *power(p, 2) *power(q, 5) *r  +  1080 *power(p, 6) *q *power(r, 2)  +
        11200 *power(p, 3) *power(q, 3) *power(r, 2)  -  12150 *power(q, 5) *power(r, 2)  -
        4800 *power(p, 4) *q *power(r, 3)  +  64000 *p *power(q, 3) *power(r, 3)  -
        80000 *power(p, 2) *q *power(r, 4)  +  1080 *power(p, 6) *power(q, 2) *s  +
        13250 *power(p, 3) *power(q, 4) *s  +  54000 *power(q, 6) *s  -
        3240 *power(p, 7) *r *s  -  56250 *power(p, 4) *power(q, 2) *r *s  -
        337500 *p *power(q, 4) *r *s  +  43200 *power(p, 5) *power(r, 2) *s  +
        560000 *power(p, 2) *power(q, 2) *power(r, 2) *s  -  80000 *power(p, 3) *power(r, 3) *s  +
        100000 *power(q, 2) *power(r, 3) *s  +    6750 *power(p, 5) *q *power(s, 2)  +
        225000 *power(p, 2) *power(q, 3) *power(s, 2)  -  900000 *power(p, 3) *q *r *power(s, 2)  -
        562500 *power(q, 3) *r *power(s, 2)  +  500000 *p *q *power(r, 2) *power(s, 2)  +
        843750 *power(p, 4) *power(s, 3)  +    1937500 *p *power(q, 2) *power(s, 3)  -
        3000000 *power(p, 2) *r *power(s, 3)  +  2500000 *power(r, 2) *power(s, 3)  -  5468750 *q *power(s, 4))

   u = - 25*q/2
   v = (c0 + c1 * root + c2 * power(root, 2) + c3 * power(root, 3) + c4 * power(root, 4) + c5 * power(root, 5)) / (2*D*F) * delta * mp.sqrt(5)

   w = 1
   for i2 in range(0, 5):
      if mp.fabs(w) < 1e-9:
         break
      for k2 in range(0, 5):
         if mp.fabs(w) < 1e-9:
            break
         for i1 in range(0, 5):
            if mp.fabs(w) < 1e-9:
               break
            for k1 in range(0, 5):
               r1 = mp.root(R1, 5, i2)
               r4 = mp.root(R4, 5, k2)
               r2 = mp.root(R2, 5, i1)
               r3 = mp.root(R3, 5, k1)
               w = mp.fabs(r1*power(r2, 2) + r4*power(r3,2) - u - v) + mp.fabs(r3*power(r1,2) + r2*power(r4,2) - u + v)
               #print("i2 k2 i1 k1 w =", i2, k2, i1, k1, w)
               if mp.fabs(w) < 1e-9:
                  print("i2 k2 i1 k1 =", i2, k2, i1, k1)
                  break

   if mp.fabs(w) > 1e-9:
      r1 = mp.root(R1, 5, 0)
      r4 = mp.root(R4, 5, 0)
      r2 = mp.root(R2, 5, 0)
      r3 = mp.root(R3, 5, 0)

   x1 = translation + (r1               + r2               + r3               + r4)/5
   x2 = translation + (r1*power(zeta,4) + r2*power(zeta,3) + r3*power(zeta,2) + r4*zeta)/5
   x3 = translation + (r1*power(zeta,3) + r2*zeta          + r3*power(zeta,4) + r4*power(zeta,2))/5
   x4 = translation + (r1*power(zeta,2) + r2*power(zeta,4) + r3*zeta          + r4*power(zeta,3))/5
   x5 = translation + (r1*zeta          + r2*power(zeta,2) + r3*power(zeta,3) + r4*power(zeta,4))/5
   y1 = A5 * power(x1,5) + A4 * power(x1,4) + A3 * power(x1,3) + A2 * power(x1,2) + A1 *x1 + A0
   y2 = A5 * power(x2,5) + A4 * power(x2,4) + A3 * power(x2,3) + A2 * power(x2,2) + A1 *x2 + A0
   y3 = A5 * power(x3,5) + A4 * power(x3,4) + A3 * power(x3,3) + A2 * power(x3,2) + A1 *x3 + A0
   y4 = A5 * power(x4,5) + A4 * power(x4,4) + A3 * power(x4,3) + A2 * power(x4,2) + A1 *x4 + A0
   y5 = A5 * power(x5,5) + A4 * power(x5,4) + A3 * power(x5,3) + A2 * power(x5,2) + A1 *x5 + A0
   print("x =", x1, "; |y| = ", mp.fabs(y1))
   print("x =", x2, "; |y| = ", mp.fabs(y2))
   print("x =", x3, "; |y| = ", mp.fabs(y3))
   print("x =", x4, "; |y| = ", mp.fabs(y4))
   print("x =", x5, "; |y| = ", mp.fabs(y5))

   return True, x1, x2, x3, x4, x5

def my_round(x):
   y = mp.fabs(x)
   if mp.fabs(y - mp.floor(y)) < 0.5:
      return mp.sign(x) * mp.floor(y)
   else:
      return mp.sign(x) * mp.ceil(y)

def my_int(x):
   y = int(my_round(mp.re(x)))
   return y

def contains(lista, x):
   for cadaUm in lista:
      if cadaUm == x:
         return True
   return False

def testPoly(lista, x, a0, a1, a2, a3, a4, a5):
   y = -x
   soma1 = a0 + a1*x + a2*power(x,2) + a3*power(x,3) + a4*power(x,4) + a5*power(x,5) + power(x,6)
   if mp.fabs(soma1) < 1e-9:
      return lista, True, x
   soma2 = a0 + a1*y + a2*power(y,2) + a3*power(y,3) + a4*power(y,4) + a5*power(y,5) + power(y,6)
   if mp.fabs(soma2) < 1e-9:
      return lista, True, -x
   return lista, False, 0

# the last of the list is the root of the sextic. b6 = 1.
def divisors(b0, b1, b2, b3, b4, b5):
   lista = list()
   lista2 = list()
   if (mp.im(b0) != 0) or (mp.im(b1) != 0) or (mp.im(b2) != 0) or (mp.im(b3) != 0) or (mp.im(b4) != 0) or (mp.im(b5) != 0):
      return lista, False, 0
   s = mp.fabs(my_int(b0))
   if s == 0:
      lista.append(0)
      return testPoly(lista, 0, b0, b1, b2, b3, b4, b5)
   lista.append(1)
   if s == 1:
      return testPoly(lista, 1, b0, b1, b2, b3, b4, b5)
   primo = 2
   while (True):
      d = s % primo
      if d == 0:
         s = s / primo
         lista2.clear()
         for cadaUm in lista: # 1,2,3,6
            lista2.append(cadaUm * primo) # 1*5,2*5,3*5,6*5

         for cadaUm in lista2:
            if not contains(lista, cadaUm):
               lista.append(cadaUm)
               L, flag, root = testPoly(lista, cadaUm, b0, b1, b2, b3, b4, b5)
               if flag:
                  return lista, True, root

         if s == 1:
            break
         print("Factorizing", int(s))
      else:
         primo = nextPrime(primo)
         if primo * primo > s:
            primo = my_int(s)
   return lista, False, 0

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

def eq_solve_tangent(v):
   print("Tangent equation with v =", v)
   v2 = v*v
   return eq_solve(1, - 20 - 25*v2, 110 + 100*v2, - 100 - 110*v2, 25 + 20*v2, - v2)

def hyperg(p, q, a, b, z):
   result = 1
   termo = 1
   for i in range(0, 100):
      for j in range(0, p):
         termo = termo * (a[j] + i)
      for j in range(0, q):
         termo = termo / (b[j] + i)
      termo = termo * z / (i + 1) # factorial
      result = result + termo
   return result

def Cardano(A2, A1, A0):
   s = - A2
   q_1 = A1
   p_1 = - A0
   # 0 = t^3 - s t^2 + q_1 t - p_1
   # t = x + s/3
   p_2 = q_1 - fdiv(power(s,2), 3)
   q_2 = - 2 * fdiv(power(s,3), 27) + fdiv(q_1,3) * s - p_1

   x = mp.zeros(3, 1)

   #0 = x^3 + p_2 x + q_2
   delta = fdiv(power(q_2,2), 4) + fdiv(power(p_2,3), 27)
   z1 = - q_2/2 + mp.sqrt(delta)
   z2 = - q_2/2 - mp.sqrt(delta)
   for i in range (0, 3):
      w1 = mp.root(z1, 3, i)
      for j in range (0, 3):
         w2 = mp.root(z2, 3, j)
         if mp.fabs(w1 * w2 + fdiv(p_2,3)) < 1e-9:
            x[i] = w1 + w2

   t1 = x[0] + fdiv(s, 3)
   t2 = x[1] + fdiv(s, 3)
   t3 = x[2] + fdiv(s, 3)
   return t1, t2, t3

def Ferrari(A3, A2, A1, A0):
   s = - A3
   q = A2
   u = - A1
   p_1 = A0
   # 0 = t4 - st3 + qt2 - ut + p_1
   # t = x + s/4
   # 0 = x4 + p_2 x2 + q_2 x + r
   p_2 = -3 * fdiv(power(s,2), 8) + q
   q_2 = -2 * fdiv(power(s,3), 16) + fdiv(q*s, 2) - u
   r = -3 * fdiv(power(s,4), 256) + fdiv(q*power(s,2), 16) - fdiv(u*s, 4) + p_1

   # delta = 0 <=> y**3 + a1 y**2 + b1 y + c1 = 0
   a1 = 5 * fdiv(p_2, 2)
   b1 = 2* power(p_2,2) - r
   c1 = - fdiv(power(q_2,2), 8) + fdiv(power(p_2,3), 2) - fdiv(p_2* r, 2)

   y0, y1, y2 = Cardano(a1, b1, c1)
   if y0 == 0:
      y0 = y1
      if y0 == 0:
         y0 = y2
   #print("p2 =", p_2)
   #print("q2 =", q_2)
   #print("r =", r)
   #print("a1 =", a1)
   #print("b1 =", b1)
   #print("c1 =", c1)
   #print("y0 =", y0)

   A = 2*y0 + p_2
   if A == 0:
      return 0, 0, 0, 0  # would divide by zero
   B = - q_2

   # 0 = A(x^2 + p_2 + y0)^2 - (Ax + B/2)^2

   # (i) sqrtA (x^2 + p_2 + y0) + Ax + B/2 = 0
   alfa  = mp.sqrt(A)
   beta  = A
   gamma = mp.sqrt(A) * (p_2 + y0) + fdiv(B,2)
   delta = power(beta,2) - 4 * alfa * gamma
   x1 = (- beta + mp.sqrt(delta))/(2*alfa)
   x2 = (- beta - mp.sqrt(delta))/(2*alfa)

   # (ii) sqrtA (x^2 + p_2 + y0) - Ax - B/2 = 0
   alfa  = mp.sqrt(A)
   beta  = - A
   gamma = mp.sqrt(A) * (p_2 + y0) - fdiv(B,2)
   delta = power(beta,2) - 4 * alfa * gamma
   x3 = (- beta + mp.sqrt(delta))/(2*alfa)
   x4 = (- beta - mp.sqrt(delta))/(2*alfa)

   t1 = x1 + fdiv(s, 4)
   t2 = x2 + fdiv(s, 4)
   t3 = x3 + fdiv(s, 4)
   t4 = x4 + fdiv(s, 4)
   return t1, t2, t3, t4

def eq_solve_tangent2(v):
   print("Tangent equation with v =", v)
   # v2 = v*v
   # m, n, p, q, r = - 20 - 25*v2, 110 + 100*v2, - 100 - 110*v2, 25 + 20*v2, - v2
   # the output f(y) is very bad.
   m = -200
   n = 1340
   p = 12.34910
   q = -239.18200
   r = 339.2181700

   d, c, b, a, A, B = Tschirnhaus3(m, n, p, q, r)
   print("d =", d)
   print("c =", c)
   print("b =", b)
   print("a =", a)
   print("A =", A)
   print("B =", B)
   s = -B/power(-A, 5/4)
   print("s =", s)
   z = -s*hyperg(4, 3, [1/5,2/5,3/5,4/5],[1/2,3/4,5/4],3125/256*power(s, 4))
   print("f(z) =", power(z, 5) - z - s)
   y = power(-A, 1/4)*z
   print("f(y) =", power(y, 5) + A* y + B)

   # x4 + d x3 + c x2 + b x + a + y = 0
   # Ferrari
   y1, y2, y3, y4 = Ferrari(d, c, b, a + y)

   #now looking for the root that solves both the Quartic and the Quintic
   print("f1 =", power(y1, 5)+m*power(y1, 4)+n*power(y1, 3)+p*power(y1, 2)+q*y1+r)
   print("f2 =", power(y2, 5)+m*power(y2, 4)+n*power(y2, 3)+p*power(y2, 2)+q*y2+r)
   print("f3 =", power(y3, 5)+m*power(y3, 4)+n*power(y3, 3)+p*power(y3, 2)+q*y3+r)
   print("f4 =", power(y4, 5)+m*power(y4, 4)+n*power(y4, 3)+p*power(y4, 2)+q*y4+r)

   w = 1e100
   if mp.fabs(power(y1, 5)+m*power(y1, 4)+n*power(y1, 3)+p*power(y1, 2)+q*y1+r) < w:
      r1 = y1
   if mp.fabs(power(y2, 5)+m*power(y2, 4)+n*power(y2, 3)+p*power(y2, 2)+q*y2+r) < w:
      r1 = y2
   if mp.fabs(power(y3, 5)+m*power(y3, 4)+n*power(y3, 3)+p*power(y3, 2)+q*y3+r) < w:
      r1 = y3
   if mp.fabs(power(y4, 5)+m*power(y4, 4)+n*power(y4, 3)+p*power(y4, 2)+q*y4+r) < w:
      r1 = y4
   print("r1 =", r1)

   # briot ruffini
   #    | 1 |   m    |  n  |  p  |  q  |  r
   # r1 | 1 | m + r1 |  c  |  b  |  y  |  0
   d = m + r1
   c = d * r1 + n
   b = c * r1 + p
   a = b * r1 + q

   # x4 + d x3 + c x2 + b x + a = 0
   # Ferrari
   y1, y2, y3, y4 = Ferrari(d, c, b, a)

   #Do the roots of the Quartic satisfy the Quintic?
   print("r2 =", y1, " y =", power(y1, 5)+m*power(y1, 4)+n*power(y1, 3)+p*power(y1, 2)+q*y1+r)
   print("r3 =", y2, " y =", power(y2, 5)+m*power(y2, 4)+n*power(y2, 3)+p*power(y2, 2)+q*y2+r)
   print("r4 =", y3, " y =", power(y3, 5)+m*power(y3, 4)+n*power(y3, 3)+p*power(y3, 2)+q*y3+r)
   print("r5 =", y4, " y =", power(y4, 5)+m*power(y4, 4)+n*power(y4, 3)+p*power(y4, 2)+q*y4+r)
   return True, r1, y1, y2, y3, y4

# this is not used in this file.
# from [https://arxiv.org/abs/math/0005026v1]
def Tschirnhaus3(m, n, p, q, r):
   # x5 + m x4 + n x3 + p x2 + q x + r = 0
   # x4 + d x3 + c x2 + b x + a + y = 0
   # y5 + A y + B = 0
   # shall return d, c, b, a, A, B
   # nowadays it's not returning good numbers.

   if (m != 0) and (n != 0):
      alpha = 1/2*(-13*m*n-10*power(n,2)+4*power(m,3)+20*q+17*power(m,2)*n-4*power(m,4)+15*p-17*m*p+ mp.sqrt(-
      680*q*m*p+200*power(m,2)*r+30*power(m,3)*power(n,2)+360*p*power(m,2)*n-80*power(m,4)*p-500*n*r+260*q*power(m,2)*
      n-190*m*n*p-80*m*p*power(n,2)-15*power(n,2)*power(m,4)+60*power(n,3)*power(m,2)+80*p*power(n,2)+60*power(n,3)-170*power(m,3)*n
      *p-200*n*q+80*power(m,2)*q+40*power(m,5)*p-100*q*power(n,2)+400*power(q,2)-120*power(m,3)*r+225*power(p,2)+265*power(m,2)*power(p,2)+300*m*n*r-40*q*power(m,4)+60*n*power(p,2)+600*p*q-15*power(m,2)*power(n,2)+40*power(m,3)*p-510*m*power(p,2)-120*m*power(n,3)-40*power(m,3)*q-20*m*n*q))/(2*power(m,2)-5*n)

      xi3 = (580*power(m,3)*p*power(alpha,2)*n-80*power(m,5)*p*power(alpha,2)+1500*power(m,3)*power(p,2)*alpha+5200*power(m,2)
      *power(n,3)*q+1360*power(m,6)*n*q+1600*power(q,2)*power(m,2)*alpha+5000*power(q,2)*m*n-4000*power(q,3)+3200*q*power(n,3)*alpha-320*q*power(m,6)*alpha-5775*m*power(p,2)*n*alpha-4065*power(m,4)*power(n,2)*q-6625*power(m,2)*n*power(q,2)-5625*q*m*power(p,2)+3285*power(m,2)*power(p,2)*q+5820*power(m,4)*power(p,2)*n-160*q*power(m,4)*power(alpha,2)-8020*power(m,2)*power(p,2)*power(n,2)-1580*power(m,4)*power(p,2)*alpha+310*m*p*power(n,4)+3300*m*p*power(q,2)+860*power(m,7)*p*n-360
      *power(m,5)*p*q+5895*q*power(m,3)*power(n,2)-4000*power(q,2)*n*alpha+1040*q*power(m,4)*n-1990*q*power(m,2)*power(n,2)-2400*
      q*power(m,5)*n-180*power(n,5)+200*m*p*q*power(n,2)+1125*n*power(p,2)*power(alpha,2)-2250*power(n,2)*power(p,2)*alpha
      -375*power(n,2)*power(m,2)*r-1500*power(n,3)*m*r+1000*power(n,2)*p*r+375*power(n,2)*power(m,3)*r-5000*n*q*r+4950*
      power(m,2)*power(p,3)-400*q*m*p*n*alpha+760*q*power(m,4)*p+320*q*power(m,5)*alpha-2820*power(m,5)*p*power(n,2)
      +2585*power(m,3)*p*power(n,3)+3800*q*power(n,2)*p-2000*power(q,2)*power(m,3)-5300*q*m*power(n,3)+2250*q*power(p,2)-2250
      *m*power(p,3)+30*power(n,2)*power(m,4)*power(alpha,2)-160*q*power(m,6)-850*power(m,4)*power(p,2)+160*power(m,8)*p-80*power(m,7)*p+1045
      *power(n,3)*power(p,2)-2000*n*power(q,2)-3125*n*power(r,2)+1500*power(n,3)*r+1200*power(n,3)*q-400*q*power(m,3)*p+60*power(n,2)*power(m,6)*alpha+7055*power(m,2)*power(p,2)*n*alpha-1485*power(n,4)*power(m,3)+525*power(n,4)*power(m,2)+800*power(m,2)*power(q,2)
      +1250*power(m,2)*power(r,2)-240*power(n,3)*power(m,4)+540*power(n,3)*power(m,5)+5625*power(p,2)*r+1780*power(m,5)*power(p,2)-195*power(n,3)*
      power(m,2)*power(alpha,2)-675*power(n,2)*power(p,2)+300*power(n,4)*power(alpha,2)+320*q*power(m,7)-600*power(n,5)*alpha-2005*power(n,3)*power(m,2)*p+800*q*power(m,2)*power(alpha,2)*n+435*power(n,3)*power(m,3)*alpha-780*power(n,4)*m*alpha+2600*q*
      m*power(n,2)*alpha+2000*power(m,2)*q*r+1000*power(m,3)*r*p-450*power(m,2)*power(p,2)*power(alpha,2)-4275*power(p,3)*n-60
      *power(n,2)*power(m,7)-1140*power(n,4)*p-1000*power(m,4)*p*r+3375*power(p,3)*alpha-950*m*p*power(n,2)*power(alpha,2)+1140
      *power(n,5)*m-500*power(m,3)*q*r+30*power(n,2)*power(m,6)+7885*power(n,2)*m*power(p,2)-160*power(m,8)*q+5200*power(n,2)*power(q,2)
      -60*power(n,2)*power(m,5)*alpha-2200*power(n,4)*q+4230*power(n,2)*power(m,4)*p+1650*power(m,4)*power(q,2)+30*power(m,8)*power(n,2)-1155
      *power(m,2)*power(n,5)+7500*q*p*r+990*power(m,4)*power(n,4)-300*power(m,6)*power(n,3)+4500*q*power(p,2)*alpha-5700*q*
      power(p,2)*n-1840*q*power(m,3)*n*alpha+280*power(m,3)*p*q*n+900*power(n,3)*alpha*p-6375*m*power(p,2)*r-3825
      *m*power(p,3)*alpha+4845*m*power(p,3)*n-1170*q*power(m,2)*n*p-30*power(n,3)*m*p-3000*q*n*alpha*p
      -560*q*power(m,3)*p*alpha-160*power(m,7)*p*alpha-495*power(n,3)*power(m,4)*alpha+1170*power(n,4)*power(m,2)*alpha
      -1490*power(n,2)*power(m,3)*p+100*q*m*n*p+160*power(m,6)*alpha*p+700*power(m,5)*n*p-4750*n*r*m*p-
      1560*power(m,6)*n*p+4500*n*power(m,2)*p*r-250*n*m*q*r+1200*q*power(m,2)*alpha*p-3375*power(n,2)*power(m,3)*p*alpha+3700*n*power(m,2)*power(p,2)+2160*q*power(m,4)*n*alpha-4500*q*power(m,2)*power(n,2)*alpha-930*power(m,6)*power(p,2)-9440*n*power(m,3)*power(p,2)+880*power(n,3)*m*p*alpha+2245*power(n,2)*power(m,2)*alpha*p-80*power(m,9)*p+
      1440*power(m,5)*p*n*alpha-2720*power(m,3)*power(p,3)-1280*power(m,4)*n*alpha*p-1000*q*power(n,2)*power(alpha,2)+
      300*power(n,6))

      xi2 = (5640*power(m,6)*alpha*q*p+46000*m*power(q,2)*r-240*power(m,6)*alpha*power(p,2)+3400*power(m,4)*alpha
      *q*r-480*power(m,8)*alpha*q+4875*power(p,2)*alpha*n*r-990*power(m,5)*alpha*power(n,4)+1800*power(m,4)*power(alpha,2)*q*p-600*power(n,4)*power(alpha,2)*p+4750*power(n,2)*power(alpha,2)*power(p,2)*m+160*power(m,8)*alpha*r-1910
      *power(n,3)*power(alpha,2)*p*power(m,2)+240*power(m,7)*power(alpha,2)*q-4860*power(m,5)*alpha*power(q,2)+120*power(m,5)*power(alpha,2)*power(p,2)+60*power(m,5)*power(alpha,2)*power(n,3)-15000*p*alpha*q*r-4680*power(m,7)*alpha*q*n-7600*power(p,2)*alpha*power(m,2)*r-3900*power(n,3)*m*alpha*r+240*power(m,7)*alpha*power(p,2)+1500*power(n,3)*power(alpha,2)*r+
      12600*power(q,2)*alpha*m*p-160*n*power(alpha,2)*r*power(m,4)+600*power(n,5)*power(alpha,2)*m-19250*m*power(n,2)*
      power(r,2)+27500*n*p*q*r+4500*p*alpha*power(n,2)*r+5100*power(p,2)*alpha*q*n-200*power(m,6)*power(alpha,2)*n*p-2220*power(n,3)*p*q-8700*power(n,3)*p*r+3420*power(m,6)*alpha*power(n,2)*p+26250*n*p*power(r,2)+3400
      *n*p*power(q,2)-14750*power(m,2)*p*power(r,2)-400*power(m,8)*alpha*n*p-10980*power(m,4)*alpha*q*power(n,2)+280*
      power(m,7)*p*r-2250*power(p,3)*power(alpha,2)*n-520*power(m,5)*alpha*r*p-1800*power(p,2)*alpha*power(n,3)+900*power(p,3)*power(alpha,2)*power(m,2)-9375*p*alpha*power(r,2)+14820*power(m,5)*alpha*q*power(n,2)+6000*r*q*power(n,2)+1600
      *r*q*power(m,4)-6520*power(m,5)*alpha*n*power(p,2)+2460*power(m,2)*power(n,3)*r-5400*power(m,5)*alpha*q*p+400*power(m,7)*alpha*n*p-500*power(m,2)*n*power(r,2)-3020*power(m,5)*alpha*p*power(n,2)-280*power(m,6)*n*r-640*power(m,4)*power(n,2)
      *r-4560*m*power(n,5)*p+8700*m*power(n,4)*r-120*power(m,6)*alpha*power(n,3)-600*power(m,6)*alpha*n*r-1920*
      power(m,5)*power(alpha,2)*q*n+1360*power(m,4)*power(alpha,2)*power(n,2)*p-840*power(m,4)*alpha*power(n,2)*r-7320*power(m,4)*alpha
      *power(n,3)*p+870*power(m,4)*alpha*power(n,4)+3360*power(m,4)*alpha*power(q,2)-3720*power(m,7)*p*power(n,2)+4500*power(n,2)
      *power(alpha,2)*power(m,3)*q+14050*m*power(n,3)*p*r+1700*power(n,2)*power(alpha,2)*q*p-10095*power(p,2)*m*power(q,2)-10920
      *power(q,2)*alpha*power(m,2)*n-700*power(n,2)*power(alpha,2)*power(m,2)*r+11000*m*p*q*r-2200*n*power(alpha,2)
      *power(m,3)*power(p,2)-3380*power(m,5)*power(p,2)*n-4350*power(p,3)*power(m,2)*q-870*power(m,2)*p*power(n,4)-2560*power(m,3)*p*power(n,4)-3000
      *power(n,3)*power(alpha,2)*m*q-4000*power(m,3)*alpha*q*r+4200*n*power(alpha,2)*m*power(q,2)-1000*power(m,2)*power(p,2)*r-5000*n*power(alpha,2)*q*r+7120*power(m,2)*p*q*power(n,2)+6080*power(m,4)*power(p,2)*n*alpha+830*power(m,2)*power(p,2)*q*n-18300*power(m,4)*power(p,2)*q-47000*power(m,2)*p*q*r-38890*power(m,3)*p*q*power(n,2)-13100*power(m,2)*power(p,3)
      *n+12080*power(m,3)*power(p,2)*power(n,2)+23580*power(m,2)*power(p,2)*power(n,3)+31040*power(m,3)*power(p,3)*n+33660*power(m,5)*p*q*n
      -13480*power(m,4)*p*q*n+21850*m*power(p,2)*n*r+820*power(m,4)*p*n*r-8200*power(m,2)*n*q*r-3300*m*p
      *power(n,2)*r+200*power(m,5)*p*r+4660*power(m,3)*p*power(n,3)*alpha-480*power(m,6)*p*r-18800*power(m,2)*power(p,2)*power(n,2)*
      alpha-13500*power(m,2)*power(p,2)*q*alpha-200*power(m,4)*p*r*alpha+6100*m*power(p,2)*q*n+1500*m*power(p,2)*alpha*r+1000*power(m,3)*p*n*r-1870*power(m,2)*p*power(n,2)*r-2700*power(m,3)*power(p,3)*alpha-17250*q*
      alpha*power(m,3)*power(n,3)+2500*m*p*power(r,2)+4500*m*power(p,4)-25855*power(q,2)*alpha*power(m,2)*p+22705*power(q,2)*
      alpha*power(m,3)*n+20100*m*power(p,3)*n*alpha-4500*q*power(p,3)+700*power(m,3)*power(p,2)*r+41940*power(m,2)*power(q,2)*
      n*p-20200*power(m,4)*q*n*r-31500*power(m,4)*power(p,2)*power(n,2)+8400*power(m,3)*power(p,2)*q+7200*power(m,6)*power(p,2)*n-17400
      *power(m,2)*p*power(q,2)+40980*power(m,3)*p*power(q,2)+9200*power(q,3)*p-1650*m*power(p,2)*power(n,3)-26600*m*power(p,3)*power(n,2)+24275*power(m,2)*q*power(n,2)*r-18745*power(m,2)*q*power(n,3)*p+9500*q*alpha*power(n,2)*r-10000*power(q,2)*alpha
      *r+14300*q*alpha*power(m,3)*power(p,2)-5900*q*alpha*power(n,3)*p+7800*q*alpha*m*power(n,4)-1680*
      power(q,2)*power(alpha,2)*power(m,3)-16300*power(q,2)*alpha*m*power(n,2)+7800*q*alpha*power(n,3)*power(m,2)+8400*power(q,3)*alpha
      *m-8860*power(n,2)*q*power(p,2)*m+8550*power(p,4)*n-6750*power(p,4)*alpha-11250*power(p,3)*r+21780*power(m,5)
      *power(q,2)*n-27875*power(m,2)*power(q,2)*r-2760*power(m,9)*q*n-24630*power(m,4)*power(q,2)*p+3200*power(m,6)*q*r-20420
      *power(m,6)*q*n*p+33390*power(m,4)*q*power(n,2)*p+10260*power(m,5)*q*power(p,2)-9010*power(m,3)*q*n*power(p,2)+3240*power(m,8)
      *q*p+25700*power(m,3)*q*r*p+8000*power(q,2)*alpha*n*p-17880*power(m,6)*q*power(n,2)+25290*power(m,4)*q*power(n,3)+5040*power(m,8)*q*n+30960*power(m,2)*power(q,2)*power(n,2)+1350*power(n,2)*power(p,3)-34045*power(m,3)*power(q,2)*power(n,2)+16350*
      power(m,3)*q*power(n,4)-10000*r*power(q,2)-120*power(m,6)*power(n,2)*r+1460*power(m,3)*alpha*power(n,2)*r-900*r*power(n,4)-25000
      *power(r,2)*q-1000*power(r,2)*power(m,4)+2530*power(m,2)*power(n,5)*p+440*power(m,5)*alpha*n*r+7500*power(r,2)*power(n,2)+2340
      *power(m,3)*power(n,5)*alpha+2060*power(m,8)*power(n,2)*p+600*power(n,5)*r-200*power(m,3)*power(alpha,2)*p*r-600*power(n,6)*
      p+37000*power(m,3)*q*n*r+19740*power(m,5)*power(n,2)*power(p,2)-41500*m*q*power(n,2)*r-24900*power(m,3)*power(n,3)*power(p,2)+
      4730*power(m,4)*power(n,4)*p-6360*power(m,6)*power(n,3)*p+4200*power(n,4)*q*p-2700*power(n,3)*q*r-10600*power(n,2)*power(q,2)*
      p+220*power(m,2)*power(n,4)*p*alpha+24010*power(m,3)*power(n,2)*power(p,2)*alpha-12200*n*power(q,3)*m+3000*n*power(q,2)
      *r-620*power(m,3)*power(n,2)*r*p-4800*power(n,5)*q*m+13300*power(n,3)*power(q,2)*m+20860*power(n,3)*q*m*p-24460*
      n*power(q,2)*m*p-33300*power(m,4)*power(q,2)*n-15625*power(r,3)-14400*power(m,2)*q*power(n,4)-6460*power(p,2)*q*power(n,2)-160
      *power(m,7)*alpha*r+11250*power(p,3)*q*m-16125*power(p,2)*q*r-3820*power(p,2)*power(m,7)*n+3360*power(n,4)*alpha
      *m*p-360*m*power(n,6)+1870*power(p,2)*m*power(n,4)-9675*power(p,3)*q*alpha+12255*power(p,3)*q*n+500*power(m,3)*alpha
      *power(r,2)+3875*power(n,3)*alpha*power(m,2)*r+80*power(m,6)*power(alpha,2)*r+600*power(n,7)*m+6840*power(m,5)*q*power(n,2)-7080*power(m,3)*q*power(n,3)+2000*power(m,2)*power(alpha,2)*q*r+4200*power(m,6)*alpha*q*n-2280*power(m,7)*q*n-
      900*n*power(m,5)*r*p-8520*m*power(q,2)*power(n,2)+13000*n*m*alpha*q*r+13320*power(m,3)*power(q,2)*n+2280*
      power(m,2)*power(n,6)+3000*m*q*power(n,4)+29375*m*q*power(r,2)-6000*power(m,5)*q*r-24700*power(p,3)*power(m,2)*n*alpha-
      600*power(m,7)*power(n,4)-7260*power(p,2)*power(n,3)*m*alpha+4210*power(m,4)*power(n,3)*r+1980*power(m,5)*power(n,5)-7075*power(m,2)*
      power(n,4)*r+60*power(m,9)*power(n,3)+80*r*power(m,8)-17290*power(p,2)*power(m,2)*n*r+360*power(n,5)*p+11280*power(m,7)*q*power(n,2)-
      440*n*power(m,8)*r-200*n*power(m,10)*p+4500*power(p,3)*power(n,2)*alpha+3020*power(p,3)*alpha*power(m,4)+9000*power(p,4)*alpha*m+1020*power(p,2)*r*power(m,4)-8175*power(p,2)*power(n,2)*r+15000*power(p,3)*r*m-11400*power(p,4)*n*m+29390
      *power(p,3)*power(n,2)*power(m,2)-18360*power(p,3)*power(m,4)*n-13420*q*alpha*m*p*power(n,2)+3000*power(m,6)*p*q-6240
      *power(m,7)*p*q-200*power(m,8)*p*n+400*power(m,9)*p*n-3200*power(m,4)*p*power(n,3)+1660*power(m,6)*p*power(n,2)+9360*power(m,5)*p*power(n,3)-160*power(m,9)*r-390*power(n,4)*power(alpha,2)*power(m,3)+80*power(m,10)*r-1000*power(m,5)*power(r,2)-2880*power(m,5)
      *power(q,2)-2090*power(p,3)*power(n,3)+480*power(m,9)*alpha*q+5380*power(p,4)*power(m,3)+1620*power(p,3)*power(m,6)+120*power(m,7)*alpha
      *power(n,3)+1500*power(m,4)*power(p,3)-26580*power(m,4)*alpha*q*n*p-1560*power(n,5)*alpha*power(m,2)+240*power(m,11)
      *q-7130*power(m,3)*power(n,3)*r+1080*power(m,6)*power(n,4)+10500*power(m,3)*n*power(r,2)+8400*m*power(q,3)+720*power(m,7)*n*r+
      840*power(m,5)*power(n,2)*r-5180*n*power(alpha,2)*power(m,2)*q*p-1200*power(n,6)*alpha*m+1200*power(n,5)*alpha*p
      -2100*power(n,4)*alpha*r+625*n*m*alpha*power(r,2)+120*power(m,7)*power(p,2)-240*power(m,8)*power(p,2)+500*n*power(alpha,2)*r*m*p+6360*power(m,6)*power(q,2)+12525*power(m,3)*power(q,3)-1600*power(m,2)*p*n*alpha*r-3120*power(m,5)*power(p,3)
      -17250*q*alpha*power(m,2)*n*r+22960*power(m,3)*p*q*n*alpha+26750*q*alpha*r*m*p-2310*
      power(m,3)*power(n,6)-120*power(m,8)*power(n,3)-3480*power(m,7)*power(q,2)-480*power(m,10)*q-21000*power(m,2)*power(q,3)-20130*power(m,5)*q*
      power(n,3)+6140*power(m,3)*alpha*n*p*r+240*power(m,9)*q-2970*power(m,4)*power(n,5)-11750*n*q*r*m*p+7820*q
      *alpha*n*power(p,2)*m+19505*q*alpha*power(n,2)*p*power(m,2)-9900*power(p,4)*power(m,2)+120*power(p,2)*power(m,9)+2280*power(p,2)*power(n,4)+1050*power(m,3)*power(n,5)-7750*power(n,2)*alpha*r*m*p+60*power(m,7)*power(n,3)-480*power(m,5)*power(n,4))

      xi1 = (6850*power(m,2)*power(p,3)*r*alpha+38040*q*p*power(m,5)*power(n,3)-5745*q*power(m,3)*power(n,2)*power(alpha,2)*p-
      14500*n*power(m,2)*power(p,2)*r*alpha+14550*m*p*power(n,2)*power(r,2)-13790*power(q,2)*power(m,2)*power(n,3)*alpha+17540
      *power(q,2)*m*power(n,2)*p*alpha+4880*q*p*power(m,9)*n+9000*q*power(m,2)*power(r,2)+2720*q*power(m,9)*r-240*q*power(m,11)*p-2000*q*power(m,2)*power(n,4)*power(alpha,2)+7160*q*power(m,8)*power(n,3)+5315*power(q,2)*power(m,2)*power(alpha,2)*power(n,2)+19815
      *power(q,2)*power(m,4)*power(n,2)*alpha+13500*power(m,2)*p*power(r,2)*alpha-5625*q*power(p,4)*m-12265*q*power(m,6)*
      power(n,4)-2200*power(m,4)*power(p,3)*r-3040*q*power(m,8)*power(n,2)*alpha+320*q*power(m,10)*n*alpha+24550*power(m,3)*p
      *power(r,2)*n-3610*power(q,2)*power(m,4)*n*power(alpha,2)-27750*power(m,3)*p*power(r,2)*alpha+160*q*power(m,12)*n-500*q
      *power(n,2)*power(r,2)+10710*power(q,3)*power(m,4)*n+8835*power(q,2)*power(m,2)*power(n,4)-6250*q*power(r,2)*power(alpha,2)-14580*q*power(m,5)*power(p,3)+25000*q*power(m,4)*power(r,2)+23720*power(q,2)*power(m,2)*n*p*alpha-43230*q*power(p,2)*power(m,4)*power(n,2)+19190
      *power(m,2)*power(p,3)*n*r-1240*q*power(m,6)*power(n,2)*power(alpha,2)-3860*q*power(m,8)*power(p,2)-18600*power(m,5)*p*power(r,2)-5000
      *m*p*power(r,2)*power(alpha,2)+2700*q*power(n,3)*p*power(alpha,2)*m+1500*m*power(p,3)*r*alpha+160*q*power(m,8)*n*power(alpha,2)-45030*power(q,2)*power(p,2)*power(m,2)*n-40620*power(q,2)*p*power(m,5)*n+300*power(m,5)*power(p,3)*power(alpha,2)-
      300*power(m,3)*power(p,3)*r+6035*power(q,2)*power(p,2)*power(n,2)+10050*q*power(p,2)*power(m,2)*power(n,3)-13905*q*p*power(m,2)*power(n,2)*r
      -7550*q*p*power(m,4)*n*r-3980*power(q,2)*power(m,6)*n*alpha+7040*q*power(m,3)*power(n,2)*alpha*r+60*q*power(m,3)
      *n*power(alpha,2)*r-20000*q*power(m,5)*n*alpha*r+410*power(q,2)*power(m,6)*power(alpha,2)+15340*power(q,2)*power(m,6)*power(n,2)+17645*power(m,2)*power(p,4)*n*alpha+9400*n*power(m,2)*power(p,4)+4950*power(m,2)*power(p,5)-2070*q*power(m,4)*power(p,2)*power(alpha,2)+9600*n*power(m,3)*power(p,2)*r+8360*q*n*p*alpha*power(m,7)+20750*m*p*n*power(r,2)*alpha-6680
      *q*power(m,6)*power(p,2)*alpha+230*power(q,3)*power(m,4)*alpha+17310*q*power(p,3)*power(m,3)*n-21620*q*p*power(m,3)*power(n,4)
      -3800*m*power(p,3)*power(n,2)*power(alpha,2)-23980*q*p*power(m,7)*power(n,2)+2730*q*power(m,5)*n*power(alpha,2)*p+30940
      *q*power(p,2)*power(m,6)*n-2250*m*power(p,5)-1800*q*power(m,10)*power(n,2)-9000*power(m,3)*p*power(r,2)+570*power(m,3)*power(p,3)*power(alpha,2)*n+80*power(q,2)*power(m,7)*alpha+34800*power(m,4)*p*power(r,2)+4320*power(q,2)*power(m,7)*n-14600*q*m*n*p*r
      *alpha+28600*power(q,2)*power(m,2)*r*p+24660*q*power(m,4)*power(n,2)*alpha*p+4600*q*power(m,2)*power(n,5)*alpha+
      31455*power(q,2)*power(m,2)*power(p,2)*alpha+14160*q*p*power(m,2)*n*r*alpha-700*q*power(n,2)*power(p,2)*power(alpha,2)-
      1800*q*power(m,2)*p*power(alpha,2)*r-80*power(q,2)*power(m,8)*alpha-11140*power(q,3)*power(m,2)*power(n,2)-480*q*power(m,9)*p*
      alpha+20820*q*power(m,4)*p*alpha*r+5170*power(q,2)*power(m,5)*p*alpha-240*q*power(m,7)*p*power(alpha,2)-4050
      *power(q,2)*power(m,3)*n*r-11160*power(q,3)*m*alpha*p+10500*power(q,2)*m*power(alpha,2)*r-15050*power(q,2)*power(m,3)*alpha*r-14325*m*power(p,4)*n*alpha-19700*power(q,2)*m*alpha*n*r-7500*q*m*power(n,2)*power(alpha,2)*r-11550*power(q,2)*power(m,5)*r-2000*q*power(p,2)*power(n,4)+3640*power(q,2)*power(m,7)*p-600*power(m,3)*power(p,4)*alpha-5050
      *power(q,2)*n*power(p,2)*alpha+11500*q*m*power(n,3)*alpha*r+15930*power(q,3)*m*n*p-6745*q*n*power(p,3)
      *alpha*m+28895*power(q,2)*power(m,4)*power(p,2)+6350*power(q,2)*m*power(n,2)*r-14570*power(q,2)*m*power(n,3)*p-7300*q*power(n,4)*p*alpha*m-23780*power(q,2)*power(m,4)*power(n,3)-2320*power(q,2)*power(m,8)*n+19920*q*power(m,5)*power(n,2)*r-49380*
      power(q,2)*power(p,2)*power(m,3)-48590*power(q,2)*p*power(m,3)*n*alpha-5600*power(q,2)*power(n,3)*power(m,2)+320*power(q,3)*power(m,3)*alpha
      -23800*power(q,2)*power(m,5)*power(n,2)-21020*q*power(m,3)*r*power(p,2)+14720*q*power(m,6)*r*p-9750*q*power(m,2)*power(r,2)*n+
      33250*q*power(m,2)*power(r,2)*alpha-20900*m*power(p,3)*n*r+4250*q*n*p*power(alpha,2)*r-8700*q*power(n,2)*
      p*alpha*r+8465*q*n*r*m*power(p,2)+7245*power(q,2)*power(p,3)*m-16510*power(q,3)*power(m,3)*p-1000*power(m,2)*power(p,3)
      *r-1400*power(q,2)*power(p,2)*n-380*power(q,2)*m*power(n,4)-28400*q*r*alpha*m*power(p,2)-39100*power(m,2)*p*power(r,2)*
      n+2700*q*power(n,3)*power(p,2)*alpha-5350*power(q,2)*n*r*p+2855*q*power(m,4)*power(n,3)*power(alpha,2)+3105*q*power(m,2)*power(p,2)*power(alpha,2)*n-3300*power(m,3)*power(p,2)*power(alpha,2)*r-11200*power(q,3)*m*p-47120*power(q,2)*power(m,2)*power(n,2)
      *p+2020*power(q,3)*m*power(n,2)-4350*power(q,2)*m*power(alpha,2)*n*p-10280*q*power(m,4)*power(n,4)*alpha-15760*q
      *power(m,7)*n*r+4640*q*power(m,7)*r*alpha+21000*power(q,2)*power(p,2)*power(m,2)-3100*q*power(n,4)*r*m+8780*q*power(p,3)*power(n,2)*m+2500*q*power(n,3)*r*p+4600*q*p*power(n,5)*m-675*q*m*power(p,3)*power(alpha,2)-22750*q*m*p*
      power(r,2)+1020*q*power(m,5)*power(alpha,2)*r+3750*q*n*power(r,2)*alpha+600*power(m,4)*power(p,4)*alpha-7720*q*power(m,6)*n*p*alpha+5280*power(q,2)*power(m,3)*p*power(alpha,2)+23260*power(q,2)*m*n*power(p,2)+9345*q*power(m,4)*power(n,5)-20220
      *q*power(m,3)*power(p,3)*alpha+13000*power(q,2)*r*alpha*p+10220*q*m*power(n,2)*power(p,2)*alpha+14110
      *power(q,3)*power(m,2)*alpha*n-4410*power(q,3)*power(m,2)*power(alpha,2)-32940*q*power(m,3)*n*alpha*power(p,2)-6720*power(q,2)
      *power(m,6)*p-18600*power(q,3)*power(m,3)*n+8760*q*power(m,4)*n*alpha*r-12380*q*power(m,2)*power(n,3)*p*alpha+260
      *power(q,2)*m*alpha*power(n,3)-15600*power(q,2)*m*alpha*power(p,2)+40520*q*m*power(n,2)*p*r+400*q*power(m,2)*n*
      p*r-585*q*power(m,3)*power(n,3)*r+8920*power(q,2)*m*power(n,2)*p-3860*power(q,2)*power(m,4)*p*alpha-16720*q*p*power(m,3)*n*r-27520*power(q,2)*power(m,3)*n*p-8920*power(q,2)*power(m,3)*power(n,2)*alpha+2460*power(q,2)*power(m,5)*n*alpha+21820
      *power(q,2)*power(m,3)*power(n,3)-300*power(q,2)*power(n,2)*p*alpha-8200*q*power(m,3)*p*alpha*r+24000*power(q,2)*power(m,2)
      *n*r-1040*power(q,3)*m*alpha*n-2800*power(q,2)*m*r*n+66380*power(q,2)*p*power(m,4)*n+4280*q*power(m,6)*power(n,3)-30460*q*p*power(m,5)*power(n,2)*alpha+20100*q*p*power(m,2)*power(n,4)-9120*q*p*power(m,8)*n-4220*q*power(p,3)*
      power(m,2)*n+3280*q*power(m,9)*power(n,2)+380*power(q,2)*power(n,3)*p-2600*q*power(m,2)*power(n,6)+800*power(q,4)-46000*power(q,2)*m*
      r*p+4420*q*power(m,3)*power(n,4)*alpha-320*q*power(m,9)*n*alpha+3640*q*power(m,2)*power(n,2)*alpha*r+2660
      *q*power(p,3)*power(n,2)-2000*power(q,2)*power(m,6)*n+1620*q*power(n,5)*power(m,2)+39570*q*power(p,2)*power(m,3)*power(n,2)+2720*q*power(m,7)*power(n,2)*alpha+15900*q*power(m,2)*power(p,3)*alpha+480*q*power(m,8)*p*alpha-44220*q*power(m,4)*power(n,3)*p+
      15155*q*power(n,4)*power(m,5)-3520*q*power(m,6)*power(p,2)-4130*q*power(n,4)*power(m,4)-2000*power(q,4)*m+1250*power(q,2)*power(r,2)-
      2500*power(q,3)*m*r+1200*power(q,3)*p*alpha+450*power(q,2)*power(p,2)*power(alpha,2)+2000*power(q,3)*r+1250*power(q,4)*
      power(m,2)-6200*q*m*n*power(p,3)-2880*q*m*power(n,4)*p+4240*q*power(m,7)*n*p-2200*q*power(m,2)*power(n,2)*power(p,2)+1045
      *power(n,3)*power(p,4)-6820*q*power(m,5)*power(n,3)*alpha-1125*power(p,3)*r*power(alpha,2)-6000*p*power(r,2)*power(n,2)+5370
      *power(p,3)*r*power(n,2)+2500*power(p,2)*power(r,2)*m-2025*power(p,3)*r*n*alpha-4800*p*r*q*power(n,2)+12500*p*power(r,3)+8000*p*r*power(q,2)+720*p*r*power(n,4)+20000*p*power(r,2)*q-18375*power(p,2)*power(r,2)*n+5375*power(p,2)*power(r,2)*
      power(m,2)+5625*power(p,2)*power(r,2)*alpha+38580*q*p*power(m,6)*power(n,2)-51320*q*power(p,2)*power(m,5)*n-14800*q*m*power(n,3)*power(p,2)+6040*q*power(m,5)*power(p,2)*alpha+9200*q*power(m,3)*power(n,3)*p-15000*q*power(m,5)*power(n,2)*p-5040*q*
      power(m,8)*r+480*q*power(m,10)*p+2320*q*power(m,7)*r+160*q*power(m,10)*n-240*q*power(m,9)*p-1480*q*power(m,8)*power(n,2)+5840*q*power(m,3)*power(n,2)*r+25820*q*power(p,3)*power(m,4)-7960*q*power(n,5)*power(m,3)-2100*q*n*power(p,3)*alpha-320
      *q*power(m,11)*n-11600*q*power(p,3)*power(m,3)+1125*n*power(p,4)*power(alpha,2)-2250*power(n,2)*power(p,4)*alpha-16820
      *q*power(n,3)*power(m,2)*r+2040*q*power(n,3)*m*r-22345*power(n,2)*power(m,2)*power(p,4)-18700*q*power(p,2)*n*r+12000*q
      *power(p,2)*r*alpha+41600*q*power(p,2)*power(m,2)*r-7000*q*power(p,2)*m*r-3040*q*power(m,6)*r*alpha+24080
      *q*power(m,6)*n*r-12840*q*power(m,4)*power(n,2)*r+40460*q*power(p,2)*power(m,4)*n*alpha+22725*q*p*power(m,3)*power(n,3)
      *alpha-10675*q*power(p,2)*power(m,2)*power(n,2)*alpha+21160*q*power(m,4)*n*power(p,2)+7380*q*power(p,2)*power(m,7)-11280
      *q*power(n,3)*power(m,7)-195*power(n,5)*power(m,4)*power(alpha,2)+9620*power(q,2)*power(m,4)*power(n,2)+1020*q*power(p,2)*power(n,3)-10320*
      q*power(m,5)*r*n-7600*power(q,2)*power(m,3)*r-41500*q*power(m,3)*power(r,2)+3080*power(q,2)*power(m,5)*p+60365*power(q,2)*p*power(m,3)*power(n,2)+19500*power(q,2)*power(m,4)*r+7440*power(q,3)*power(m,2)*n+27760*power(q,3)*power(m,2)*p-500*power(q,2)*power(n,2)*r-1520
      *power(q,3)*n*p-240*power(n,2)*power(m,9)*p*alpha-1565*power(n,2)*power(m,4)*power(p,2)*power(alpha,2)+3830*power(n,3)*power(m,2)*power(p,2)*power(alpha,2)-495*power(n,5)*power(m,6)*alpha-16695*power(n,4)*power(p,2)*power(m,4)+12000*q*power(m,4)*p*r-25520*q*
      power(m,5)*p*r-7000*q*m*power(r,2)*n-440*power(q,3)*power(n,2)-1900*power(n,2)*power(m,8)*power(p,2)+30*power(n,4)*power(m,6)*power(alpha,2)
      -960*power(n,4)*power(m,3)*power(alpha,2)*p-120*power(n,2)*power(m,11)*p-8360*power(n,2)*power(m,9)*r+30*power(n,4)*power(m,10)+60*power(n,4)*power(m,8)*alpha+300*power(n,6)*power(m,2)*power(alpha,2)+1170*power(n,6)*power(m,4)*alpha+300*power(n,4)*power(p,2)*power(alpha,2)
      -2700*power(n,2)*power(m,2)*power(r,2)+29350*power(n,3)*power(p,3)*power(m,3)+2220*power(n,6)*p*power(m,3)-3540*power(n,4)*p*power(m,7)-600*
      power(n,5)*p*power(alpha,2)*m+13160*power(n,3)*power(p,2)*power(m,6)+1980*power(n,3)*p*alpha*power(m,7)-3900*power(n,2)*power(m,6)*power(p,2)*alpha+18715*power(n,2)*power(p,4)*m+70*power(n,5)*power(p,2)*power(m,2)+8205*power(n,3)*p*power(m,2)*r*alpha+14180*power(n,3)*power(m,5)*alpha*r+1875*power(n,2)*power(r,2)*power(alpha,2)-600*power(n,5)*power(p,2)*alpha+1250*m*n*power(r,3)+2145
      *power(n,5)*p*power(m,5)-16740*power(n,2)*power(m,5)*power(p,3)+1200*power(n,3)*p*power(m,9)+780*power(n,3)*power(m,5)*power(alpha,2)*p+15760
      *power(n,3)*power(m,7)*r-120*power(n,2)*power(m,7)*p*power(alpha,2)+1500*power(n,4)*m*power(alpha,2)*r-2100*power(n,5)*m*alpha
      *r+6380*power(n,3)*power(p,3)*alpha*m+4090*power(n,4)*p*power(m,2)*r-24850*power(n,2)*power(m,4)*power(r,2)+30300*power(n,3)*
      p*power(m,4)*r-3535*power(n,4)*power(m,3)*alpha*r+1835*power(n,3)*power(m,3)*power(alpha,2)*r-24960*power(n,2)*power(m,3)*power(p,3)*
      alpha+345*q*power(m,2)*power(p,4)+9720*n*power(m,4)*power(p,4)+1200*power(n,6)*p*alpha*m-6495*power(n,2)*power(m,2)*p*
      power(alpha,2)*r-600*power(n,7)*power(m,2)*alpha-160*power(n,5)*power(m,3)*r-1500*power(n,3)*p*power(alpha,2)*r+4920*power(n,3)
      *m*p*r*alpha-9300*power(n,3)*r*m*power(p,2)-600*power(n,5)*r*p+7200*n*power(m,4)*power(r,2)-2845*power(n,2)*r*
      alpha*m*power(p,2)-11175*power(n,4)*power(m,5)*r+2100*power(n,4)*p*alpha*r-21775*power(n,2)*power(m,2)*power(r,2)*alpha-38820
      *power(n,2)*power(m,6)*r*p-2180*power(n,4)*power(p,3)*m-780*power(n,6)*power(m,3)*alpha-600*power(n,7)*p*m-3410*power(n,2)
      *power(m,5)*power(alpha,2)*r+2415*power(n,4)*power(m,4)*alpha*p-11280*power(n,2)*power(m,7)*r*alpha-29890*power(n,2)*power(m,3)*r*power(p,2)+600*power(n,6)*r*m-1500*power(n,3)*power(r,2)*alpha+2425*power(n,3)*power(m,2)*power(r,2)+9300*q*power(m,6)*power(n,3)
      *alpha+2460*power(n,5)*power(m,2)*p*alpha-2580*power(n,4)*m*power(p,2)*alpha-13370*power(n,3)*power(m,3)*alpha*power(p,2)+720*power(m,5)*n*power(p,3)-13750*power(m,3)*power(r,3)+2250*q*power(p,4)-9840*power(n,4)*m*p*r-3420*power(n,6)*p*power(m,2)-7060*power(n,3)*power(m,4)*alpha*r-480*power(n,3)*power(m,2)*p*r-5290*power(q,3)*power(p,2)-40*power(q,2)*power(m,10)+19180*
      power(n,2)*power(m,3)*p*alpha*r-1740*power(n,3)*power(m,6)*p*alpha-3945*power(n,4)*p*power(m,5)*alpha+15350*power(n,4)*
      power(p,2)*power(m,3)-2160*power(n,3)*p*power(m,8)+22500*power(m,2)*power(r,3)-1155*power(n,7)*power(m,4)-8625*power(p,4)*m*r-300*power(n,5)
      *power(m,8)-6555*power(p,4)*q*n+5175*power(p,4)*q*alpha+8625*power(p,3)*q*r+6555*power(p,5)*m*n-5175*power(p,5)*
      m*alpha+140*power(q,3)*power(m,6)+60*power(q,2)*power(n,4)-40*power(q,2)*power(m,8)+80*power(q,2)*power(m,9)+40*power(q,3)*power(m,4)-180*power(q,3)*power(m,5)-26300*power(n,3)*p*power(m,3)*r+225*power(m,2)*power(p,4)*power(alpha,2)-630*power(n,4)*power(m,2)*power(p,2)-840*power(n,5)*power(m,3)*p-1710*power(n,4)*power(m,5)*p+3420*power(n,5)*m*power(p,2)-21580*power(n,3)*power(p,2)*power(m,5)+5130*power(n,4)*p*power(m,6)+525
      *power(n,6)*power(m,4)+900*power(n,3)*power(p,3)*alpha+240*power(n,2)*power(m,8)*p*alpha+21430*power(n,2)*power(m,2)*power(p,3)*alpha
      +300*power(n,6)*power(p,2)+300*power(n,4)*power(r,2)-1485*power(n,6)*power(m,5)+990*power(n,6)*power(m,6)-700*power(m,6)*power(p,3)*alpha+960
      *power(n,3)*power(m,7)*p+1680*power(n,3)*m*power(p,3)+360*power(n,6)*m*p-555*power(n,5)*power(m,4)*p-675*power(n,2)*power(p,4)-27750
      *power(n,3)*power(p,3)*power(m,2)-60*power(n,4)*power(m,7)*alpha+300*power(n,8)*power(m,2)+2100*power(n,2)*power(p,2)*m*r-360*power(n,5)*m*r
      +3980*power(n,2)*power(m,5)*power(p,2)*alpha+3780*power(n,5)*power(m,2)*r-1140*power(n,4)*power(p,3)+30*power(n,4)*power(m,8)+435*power(n,5)
      *power(m,5)*alpha-180*power(n,7)*power(m,2)+8440*power(n,3)*power(m,4)*power(p,2)-5240*power(n,2)*power(m,7)*r+13440*power(n,2)*power(m,8)*r
      -180*power(n,5)*power(p,2)+51420*power(n,2)*power(m,5)*p*r+8560*power(n,2)*power(m,6)*r*alpha-20240*power(n,3)*power(m,6)*r+240
      *power(n,2)*power(m,10)*p-13480*power(n,2)*power(p,3)*power(m,3)+30240*power(n,2)*power(p,3)*power(m,4)-60*power(n,4)*power(m,9)+3280*power(m,9)*n
      *alpha*r-2080*power(n,2)*power(m,6)*power(p,2)+8245*power(n,4)*power(m,4)*r+810*power(m,6)*power(p,4)-240*power(n,5)*power(m,6)+32590
      *power(n,2)*power(p,2)*power(m,2)*r-3600*power(n,2)*power(p,2)*r*alpha-6200*power(m,5)*power(p,2)*r-160*power(m,13)*r-18750*m*
      power(r,3)*alpha-780*power(n,4)*power(m,3)*r+31600*power(n,2)*power(m,3)*power(r,2)-14160*power(n,2)*power(m,4)*p*r+5840*power(n,3)*power(m,5)*r+3000*power(n,3)*m*power(r,2)+540*power(n,5)*power(m,7)+1140*power(n,7)*power(m,3)+4020*power(n,2)*power(p,2)*power(m,7)+40*power(m,12)*
      power(p,2)-660*power(n,5)*p*power(m,3)*alpha+40*power(m,10)*power(p,2)-4640*power(n,4)*power(p,2)*power(m,2)*alpha-1300*power(m,5)*power(p,4)-1800*power(m,6)*power(r,2)+16930*power(n,3)*power(p,2)*power(m,4)*alpha+440*power(m,9)*power(p,3)-3000*power(m,8)*power(r,2)+400*power(m,7)*power(p,3)-840*power(m,8)*power(p,3)+5600*power(m,7)*power(r,2)-80*power(m,11)*power(p,2)-120*power(n,2)*power(m,9)*p-100*power(m,6)*power(p,2)*power(alpha,2)*n-160*power(m,11)*r+40*power(m,8)*power(p,2)*power(alpha,2)+320*power(m,12)*r+6060*power(n,3)*power(p,2)*r-100*power(m,7)*power(p,3)*n+550*power(m,4)*power(p,4)-240*power(m,10)*power(p,2)*n+80*power(m,10)*power(p,2)*alpha+1340*power(m,5)*n*power(p,3)*alpha
      +7210*power(m,4)*n*p*power(alpha,2)*r+4750*n*power(m,2)*power(r,2)*power(alpha,2)-31110*power(n,2)*power(m,4)*p*alpha
      *r-1600*power(m,6)*p*power(alpha,2)*r-3760*power(m,8)*p*alpha*r+1360*power(m,7)*n*power(alpha,2)*r+740*
      power(m,7)*power(p,3)*alpha+21880*power(m,6)*p*n*r*alpha+16400*power(m,8)*p*n*r+260*power(m,7)*n*alpha*power(p,2)+6325*m*power(p,2)*n*power(alpha,2)*r+25100*power(m,4)*n*power(r,2)*alpha+18000*power(m,6)*power(r,2)*n-5200*power(m,6)*power(r,2)*alpha-7340*power(m,7)*r*power(p,2)+3600*power(m,5)*power(r,2)*alpha-9400*power(m,5)*r*alpha*power(p,2)-18520
      *power(m,5)*n*p*r*alpha+25800*power(m,5)*n*r*power(p,2)-1750*power(m,4)*power(r,2)*power(alpha,2)+1920*power(m,11)*n*
      r-320*power(m,11)*r*alpha-160*power(m,9)*power(alpha,2)*r-2160*power(m,10)*r*p+3600*power(m,7)*p*alpha*r-
      27600*power(m,7)*p*n*r-2960*power(m,8)*n*alpha*r+11360*power(m,6)*n*p*r-660*power(m,6)*power(p,3)*n-2000*
      power(m,8)*p*r+13100*power(m,6)*power(p,2)*r+4160*power(m,9)*p*r+3375*power(p,5)*alpha+5625*power(p,4)*r-4275*power(p,5)*n+320*power(m,10)*r*alpha-3520*power(m,10)*n*r+9400*power(m,4)*power(p,2)*r*alpha-160*power(m,8)*n*power(p,2)-
      80*power(m,9)*power(p,2)*alpha+400*power(m,9)*power(p,2)*n-32760*power(m,4)*power(p,2)*n*r+1600*power(m,9)*r*n-340*power(m,8)*
      power(p,2)*n*alpha-1740*power(m,4)*n*power(p,3)*alpha-30000*power(m,5)*power(r,2)*n-19320*n*power(m,3)*power(p,4)-1560*
      power(n,4)*power(m,2)*alpha*r-11700*n*power(m,3)*power(r,2)*alpha+11160*n*power(m,3)*r*alpha*power(p,2)-2300*power(m,3)
      *power(p,5))

      xi = (-xi2 + mp.sqrt(power(xi2,2)-4*xi3*xi1))/(2*xi3)

      eta = -(4*xi*power(m,4)-15*xi*p-21*power(m,2)*p*alpha+10*xi*power(n,2)+21*power(m,3)*n*alpha-4*xi*
      power(m,3)-56*power(m,3)*power(n,2)-58*m*n*q-20*xi*q-23*m*power(p,2)+4*power(m,6)+23*p*q-4*power(m,7)-10*xi*n*alpha
      +13*xi*m*n-17*xi*power(m,2)*n+4*xi*power(m,2)*alpha+17*xi*m*p+25*n*p*alpha+29*m*power(n,3)+31*power(m,3)*q+21*m*q*alpha-23*m*power(n,2)*alpha+15*power(p,2)+28*power(m,5)*n-29*p*power(n,2)-25*r*
      alpha+81*p*power(m,2)*n-6*power(n,3)+35*n*r-28*power(m,4)*p-4*power(m,5)*alpha-52*m*n*p-35*power(m,2)*r-24
      *n*power(m,4)+22*n*q-26*power(m,2)*q+30*m*r+35*power(m,2)*power(n,2)+26*power(m,3)*p)/(25*m*q-20*q+20*power(m,3)*n+19*n*p-22*power(m,2)*p-19*m*power(n,2)-16*power(m,2)*n+13*n*m*alpha+6*power(n,2)-15*p*alpha-25
      *r-4*power(m,3)*alpha+20*m*p-4*power(m,5)+4*power(m,4))

   elif (m == 0) and (n != 0):
      w = mp.sqrt(400*power(q,2)+600*p*q-100*q*power(n,2)+225*power(p,2)+80*p*power(n,2)-500*n*r-200*q*n+
      60*power(n,3)+60*n*power(p,2))

      Omega = (45562500*power(p,6)*q*power(r,2)-80000000*power(n,2)*power(r,2)*p*power(q,4)+36300000*power(n,4)*power(r,2)*power(p,2)*power(q,2)+25500000*power(n,5)*power(r,4)*p+11520*power(n,9)*power(p,3)*r+291600*power(p,9)*r*n+712800*power(p,5)*power(q,3)*power(n,3)-75937500*power(p,5)*power(r,3)*n-62500000*power(n,3)*power(r,4)*p*q-15673500*power(p,7)*q*r*n-13410000*
      power(p,2)*power(n,6)*power(r,3)-140625000*power(p,2)*power(r,5)*n+62500000*power(n,2)*power(r,5)*q+25000000*power(q,2)*power(n,3)*power(r,4)-299700*power(p,6)*power(n,3)*power(q,2)+25000000*power(n,2)*power(r,4)*power(q,2)+25312500*power(n,3)*power(r,4)*power(p,2)-6144000
      *power(q,7)*n*p+619520*power(q,5)*power(n,4)*power(p,2)-51840*power(n,10)*q*p*r+777600*power(p,8)*power(n,2)*r-1166400*
      power(n,9)*q*power(r,2)+34560*power(n,9)*power(p,2)*power(r,2)-32400000*power(p,5)*power(q,3)*r-3240000*power(p,6)*power(n,3)*r*q+4096000
      *power(n,3)*power(q,6)*p-84375000*n*power(r,4)*q*power(p,2)+26312500*power(p,2)*power(n,4)*power(r,4)+1795500*power(p,6)*power(n,3)*power(r,2)-58880*power(n,7)*power(q,4)*p+1350000*power(n,7)*power(r,4)-1600000*power(q,4)*power(n,4)*power(r,2)-7680000*power(q,6)
      *n*p*r+63281250*power(p,4)*power(r,4)+6681600*power(n,3)*power(q,5)*power(p,2)-64125000*power(p,4)*power(n,3)*power(r,3)+40000000
      *power(n,3)*power(q,3)*power(r,3)-59375000*p*power(n,3)*power(r,5)-2252800*power(n,4)*power(q,6)+39062500*power(n,2)*power(r,6)+77760
      *power(n,11)*power(r,2)-432000*power(n,8)*p*power(r,3)-546750*power(p,8)*power(q,2)+101250000*power(n,2)*power(r,3)*power(p,3)*q+103680
      *power(n,10)*power(r,2)*p-11250000*power(n,5)*power(r,4)*q+1473600*power(p,3)*power(n,7)*power(r,2)+207360*power(n,6)*power(p,5)
      *r+15360*power(n,9)*power(q,3)*p+8869500*power(n,5)*power(r,2)*power(p,4)+77760*power(p,7)*power(n,4)*r+5184000*power(q,5)*power(p,4)
      +1728000*power(p,4)*power(n,4)*power(q,3)-3840*power(p,3)*power(n,8)*power(q,2)-36160*power(q,4)*power(n,6)*power(p,2)-6696000*power(p,4)*power(n,2)*power(q,4)-650240*power(n,5)*power(q,5)*p-8775000*power(p,5)*power(n,2)*power(r,3)-8524800*power(q,5)*power(n,2)*power(p,3)-19440*power(p,6)*power(n,4)*power(q,2)+8437500*power(p,4)*power(r,4)*n+88080*power(p,4)*power(q,3)*power(n,5)+1468800*power(n,8)*power(r,2)*power(p,2)-4096000
      *power(n,4)*power(q,5)*r-57600000*power(p,3)*power(q,5)*r-1280*power(p,4)*power(n,7)*power(q,2)+252480*power(n,7)*power(q,3)*power(p,2)-
      2192000*power(n,5)*power(q,4)*power(p,2)-86400000*power(p,4)*power(q,4)*r+(1980000*power(p,2)*power(n,3)*power(r,2)*power(q,2)-460800
      *power(q,6)*power(p,2)-25920*power(n,2)*power(p,7)*r-1800000*power(n,4)*power(r,2)*power(q,2)*p+168960*power(q,5)*power(n,2)*power(p,2)-194400
      *power(p,7)*r*q+10125000*power(r,3)*power(p,3)*q*n+1395000*power(p,3)*power(r,2)*power(n,3)*q-345600*power(q,5)*power(p,3)-5760
      *power(n,7)*power(q,3)*p-442800*power(n,5)*power(r,2)*power(p,3)-6375000*power(p,2)*power(n,2)*power(r,4)+36450*power(p,7)*power(q,2)-3840
      *power(n,5)*r*power(p,5)+1350000*power(n,4)*power(r,3)*power(p,2)-60480*power(n,3)*power(p,6)*r-4218750*power(p,3)*power(r,4)+2160000
      *power(p,4)*power(q,3)*r-4050000*power(p,4)*power(q,2)*power(r,2)+6480*power(p,6)*power(q,2)*power(n,2)-1113750*power(n,2)*power(p,5)*power(r,2)-245760
      *power(n,3)*power(q,5)*p+15120*power(p,5)*power(q,2)*power(n,3)+307200*power(q,6)*n*p+2880000*power(p,3)*power(q,4)*r+162000
      *p*power(n,6)*power(r,3)+65280*power(n,5)*power(q,4)*p+1440*power(p,3)*power(n,6)*power(q,2)+960*power(p,4)*power(q,2)*power(n,5)-38880*power(n,8)*power(r,2)*p-2970000*power(p,4)*power(n,2)*power(r,2)*q-78240*power(p,3)*power(n,4)*power(q,3)-3037500*power(p,5)*power(r,2)*q+345600
      *power(n,2)*power(q,4)*power(p,3)+1920*power(q,4)*power(n,4)*power(p,2)-259200*power(q,4)*n*power(p,4)+24000*power(q,3)*power(n,5)*p*r-1125000
      *power(n,3)*power(r,4)*p+162000*power(p,6)*power(r,2)*n-5625000*power(r,4)*power(p,2)*q-3840*power(n,6)*power(p,2)*power(q,3)-27360
      *power(n,3)*power(p,4)*power(q,3)-25920*power(p,2)*power(n,7)*power(r,2)+48600*power(p,6)*power(q,3)+2137500*power(p,3)*power(n,3)*power(r,3)-145800
      *power(p,8)*r+4687500*p*power(r,5)*n+5062500*power(p,4)*power(r,3)*n-5760*power(n,6)*power(p,4)*r-226800*power(p,5)
      *power(q,3)*n-174000*power(p,4)*power(n,4)*power(r,2)-86400*power(p,2)*power(n,5)*power(r,2)*q+25920*power(n,7)*r*power(p,2)*q+453600
      *power(n,6)*power(r,2)*p*q+343200*power(p,4)*power(n,4)*q*r+2400000*power(q,3)*power(r,2)*power(n,2)*p-10800*power(p,3)*power(q,2)*power(n,4)*r-1920000*power(q,4)*r*power(p,2)*n-288000*power(n,5)*r*power(p,2)*power(q,2)+980100*power(p,6)*q*r*n+384000*power(q,5)*n*p*r+3000000*p*power(n,2)*power(r,3)*power(q,2)+3750000*n*power(r,4)*q*p-408000*power(q,3)*power(n,2)*power(p,3)*r+
      17280*power(n,6)*r*power(p,3)*q-4500000*power(p,2)*power(r,3)*power(n,2)*q-1350000*power(r,3)*p*q*power(n,4)+1248000*power(q,3)*r*power(p,2)*power(n,3)-1512000*power(p,4)*power(q,2)*power(n,2)*r-6000000*power(q,3)*n*power(p,2)*power(r,2)-192000*power(n,3)*p*power(q,4)*r+122400*power(p,5)*power(n,3)*r*q+1093500*power(p,5)*power(q,2)*n*r)*w-4860000*power(p,7)*n*power(r,2)+15360
      *power(n,8)*r*power(p,4)+9216000*power(q,7)*power(p,2)+577500*power(p,4)*power(n,4)*power(r,2)*q+768000*power(q,3)*power(n,5)*power(p,2)*r+12152000
      *power(p,3)*power(n,5)*power(r,2)*q+32400*power(p,2)*power(n,7)*power(r,2)*q+141562500*power(p,2)*power(n,2)*power(r,4)*q-40400000
      *power(q,3)*power(n,3)*power(p,2)*power(r,2)+120000000*power(q,4)*n*power(p,2)*power(r,2)+54337500*power(p,4)*power(n,2)*power(r,2)*power(q,2)+
      173600*power(p,3)*power(n,6)*r*power(q,2)-1059200*power(p,4)*power(n,6)*r*q-42750000*power(p,3)*power(n,3)*power(r,3)*q+2007000
      *power(p,5)*power(n,3)*r*power(q,2)-23040*power(p,3)*power(n,8)*r*q-391200*power(p,5)*power(n,5)*r*q-82800000*power(r,2)*power(p,3)*
      power(q,2)*power(n,3)-26190000*power(p,5)*power(q,3)*n*r-2418000*power(p,4)*power(n,4)*r*power(q,2)-202500000*power(r,3)*power(p,3)*power(q,2)*n-11200000*power(q,4)*power(n,3)*power(p,2)*r+26880000*power(q,5)*n*power(p,2)*r+126000000*power(q,3)*n*power(p,3)*power(r,2)+26000000*p*power(n,4)*power(r,3)*power(q,2)-12800000*r*p*power(q,5)*power(n,2)+748800*power(n,8)*power(q,2)*p*r-20250000
      *power(p,4)*n*power(q,2)*power(r,2)-540000*p*power(n,6)*power(r,3)*q+32000*power(q,4)*power(n,5)*p*r+26820000*power(q,3)*power(n,2)*power(p,4)*r+45000000*power(p,2)*power(n,2)*power(r,3)*power(q,2)-93750000*power(r,5)*p*q*n-18750000*power(n,4)*power(r,5)+
      11520*power(n,10)*power(q,3)+3645000*power(p,6)*power(q,3)*n-4416000*power(n,6)*p*r*power(q,3)-168960*power(n,8)*power(q,4)+12160000
      *power(n,4)*p*r*power(q,4)+8424000*power(q,4)*n*power(p,5)+3888000*power(p,7)*r*power(q,2)-1458000*power(p,7)*power(q,3)
      -648000*power(n,9)*power(r,3)-9072000*power(n,6)*power(r,2)*p*power(q,2)+273600*power(n,7)*power(p,2)*power(q,2)*r+121500000*power(p,5)*power(q,2)*power(r,2)+1198800*power(n,3)*power(p,7)*r+2816000*power(q,5)*power(n,3)*p*r+13824000*power(q,6)*power(p,3)+81000000
      *power(p,4)*power(q,3)*power(r,2)-54720*power(p,5)*power(n,5)*power(q,2)+16706250*power(p,6)*power(r,2)*power(n,2)-72900*power(p,8)*power(q,2)*
      n+2250000*power(n,6)*power(r,4)+5832000*power(p,8)*r*q-30375000*power(n,4)*power(r,3)*power(p,3)+5120000*power(q,6)*power(n,2)
      *r-2880*power(n,9)*power(p,2)*power(q,2)+191250000*power(p,3)*power(n,2)*power(r,4)+168750000*power(r,4)*power(p,3)*q+4572000*
      power(p,5)*power(n,4)*power(r,2)-16800000*power(n,5)*power(q,3)*power(r,2)+2048000*power(q,7)*power(n,2)-4531200*power(q,6)*power(n,2)*power(p,2)+926720
      *power(n,6)*power(q,5)+5120*power(n,8)*power(p,2)*power(q,3)+200000*power(q,3)*power(n,6)*power(r,2)-1113600*power(p,3)*power(n,7)*q*r+
      9632000*power(p,3)*power(n,5)*power(q,2)*r+29214000*power(n,2)*r*power(p,5)*power(q,2)+50400000*power(n,4)*power(r,2)*p*power(q,3)-22275000
      *power(p,4)*power(n,3)*q*power(r,2)-12546000*power(n,6)*power(r,2)*power(p,2)*q+218880*power(n,5)*r*power(p,6)+491600*power(p,4)*power(n,6)*power(r,2)+237440*power(n,6)*power(p,3)*power(q,3)-446400*power(q,4)*power(n,3)*power(p,4)+614400*power(q,4)*power(n,4)*power(p,3)-2700000
      *power(n,7)*p*power(r,3)+18000000*power(n,5)*p*power(r,3)*q-75000000*power(q,2)*power(r,4)*p*n-6912000*power(q,6)*n
      *power(p,2)+5120*power(p,5)*power(n,7)*r+28500000*power(p,2)*power(n,4)*power(r,3)*q-80000000*power(q,3)*power(n,2)*p*power(r,3)-303750000
      *power(r,3)*power(p,4)*q*n-35397000*power(p,6)*power(q,2)*r*n+15360000*power(q,4)*power(n,2)*power(p,3)*r+2835000*
      power(r,2)*power(p,6)*q*n-3392000*power(q,3)*power(n,4)*power(p,3)*r+4128000*power(p,2)*power(n,5)*power(r,2)*power(q,2)-33120000*power(p,3)
      *power(n,3)*power(q,3)*r-1668600*power(p,7)*power(n,2)*r*q+91260000*power(p,5)*power(n,2)*power(r,2)*q-64000*power(n,7)*p*power(q,3)*
      r-30000000*power(n,3)*p*power(r,3)*power(q,2)-15000000*power(n,4)*power(r,4)*q+16000000*power(n,3)*power(q,4)*power(r,2)+43200000
      *power(p,3)*n*power(q,4)*r-7511400*power(p,5)*power(n,4)*q*r-36000000*power(n,2)*power(r,2)*power(p,2)*power(q,3)-69120*power(p,2)
      *power(n,9)*q*r+112500000*power(r,4)*power(p,2)*power(q,2)-194400*power(p,7)*power(n,2)*power(q,2)-96000*power(n,8)*power(q,3)*r+7560000
      *power(n,7)*q*power(r,3)+6624000*power(n,7)*power(q,2)*power(r,2)+3200000*power(q,5)*power(n,2)*power(r,2)-972000*power(p,6)*power(q,4)-51840
      *power(p,4)*power(n,6)*power(q,2)+380700*power(p,6)*power(q,3)*power(n,2)-30000000*power(n,5)*power(q,2)*power(r,3)+5875200*power(q,5)*n
      *power(p,4)+2187000*power(p,9)*r-4300000*power(p,3)*power(n,5)*power(r,3)+1088000*power(n,6)*power(q,4)*r)

      alpha = 1/10*(-20*q-15*p+10*power(n,2)+w)/n

      eta = (-44*q*power(n,2)+2*w*n*(1/20*(400*power(q,2)*r-260*power(n,2)*q*r-375*p*power(r,2)+36*power(n,4)*r
      -27*power(p,3)*q+195*n*power(p,2)*r+48*n*power(q,2)*p-4*power(n,3)*q*p)*w/((12*power(n,4)*q-4*power(n,3)*power(p,2)-88*
      power(n,2)*power(q,2)-40*power(n,2)*p*r+125*n*power(r,2)+117*q*n*power(p,2)+160*power(q,3)-27*power(p,4)-300*r*p*q)*n)+
      1/20*(-1640*power(n,3)*p*power(q,2)-960*power(p,2)*power(n,3)*r+540*power(p,3)*power(q,2)+240*p*power(n,5)*q-2925*power(p,3)*r
      *n-11550*power(p,2)*n*r*q+3900*power(n,2)*r*p*q+405*power(p,4)*q-540*power(p,5)*n-6250*n*power(r,3)-8000*
      power(q,3)*r-80*power(p,3)*power(n,4)+5625*power(p,2)*power(r,2)+2720*power(q,3)*n*p-6000*power(q,2)*r*p+7500*power(r,2)*p*q-720
      *power(p,2)*n*power(q,2) + mp.sqrt(Omega) +4400*power(q,2)*power(n,2)*r-600*power(n,4)*r*q+2340*power(p,3)*power(n,2)*q+6750
      *p*power(n,2)*power(r,2)-540*power(n,4)*r*p+60*power(p,2)*power(n,3)*q)/((12*power(n,4)*q-4*power(n,3)*power(p,2)-88*power(n,2)*power(q,2)-
      40*power(n,2)*p*r+125*n*power(r,2)+117*q*n*power(p,2)+160*power(q,3)-27*power(p,4)-300*r*p*q)*n))+45*n*power(p,2)-5*p*n*w+12*power(n,4)+8*p*power(n,3)+54*p*q*n-100*r*q-75*p*r+5*r*w-20*power(n,2)*r)/(-3*p
      *w-40*q*n-50*n*r+8*p*power(n,2)+12*power(n,3)+60*p*q+45*power(p,2))

      xi = 1/20*(400*power(q,2)*r-260*power(n,2)*q*r-375*p*power(r,2)+36*power(n,4)*r-27*power(p,3)*q+195*n*power(p,2)*r+48*n*power(q,2)*p-4*power(n,3)*q*p)*w/((12*power(n,4)*q-4*power(n,3)*power(p,2)-88*power(n,2)*power(q,2)-40*power(n,2)*p*r
      +125*n*power(r,2)+117*q*n*power(p,2)+160*power(q,3)-27*power(p,4)-300*r*p*q)*n)+1/20*(-1640*power(n,3)*p*
      power(q,2)-960*power(p,2)*power(n,3)*r+540*power(p,3)*power(q,2)+240*p*power(n,5)*q-2925*power(p,3)*r*n-11550*power(p,2)*n*r*q
      +3900*power(n,2)*r*p*q+405*power(p,4)*q-540*power(p,5)*n-6250*n*power(r,3)-8000*power(q,3)*r-80*power(p,3)*power(n,4)+5625
      *power(p,2)*power(r,2)+2720*power(q,3)*n*p-6000*power(q,2)*r*p+7500*power(r,2)*p*q-720*power(p,2)*n*power(q,2) + mp.sqrt(
      Omega) + 4400*power(q,2)*power(n,2)*r-600*power(n,4)*r*q+2340*power(p,3)*power(n,2)*q+6750*p*power(n,2)*power(r,2)-540*power(n,4)*r*p+60*power(p,2)*power(n,3)*q)/((12*power(n,4)*q-4*power(n,3)*power(p,2)-88*power(n,2)*power(q,2)-40*power(n,2)*p*r+125*n*power(r,2)+117*q*n*power(p,2)+160*power(q,3)-27*power(p,4)-300*r*p*q)*n)

   else: #if (m == 0) and (n == 0)
      alpha = -1/5*(10*q-3*power(p,2)+25*r)/(4*q+3*p)

      xi = 1/10*(7360*power(q,4)*p+5520*power(p,2)*power(q,3)-4000*power(q,3)*r+270*power(q,2)*power(p,3)-10000*power(q,2)*power(r,2)-14100*power(q,2)*power(p,2)*r-12500*q*power(r,3)+3750*q*p*power(r,2)-10800*q*r*power(p,3)-1161*power(p,5)*q-810
      *power(p,6)-1125*power(r,2)*power(p,3) + mp.sqrt(1843200*power(q,7)*power(p,3)-172800*power(q,6)*power(p,4)+103680*power(q,5)*power(p,6)
      -194400*power(q,4)*power(p,7)-648000*power(p,5)*power(q,5)-72900*power(p,8)*power(q,3)+28125000*q*power(r,5)*power(p,3)+14062500
      *power(q,2)*power(p,2)*power(r,4)+8437500*q*power(p,4)*power(r,4)-891000*power(q,3)*power(p,7)*r+777600*power(q,2)*power(p,8)*r+25650000
      *power(q,2)*power(p,5)*power(r,3)+93750000*power(q,2)*power(r,5)*p+156250000*power(q,2)*power(r,6)-10935*power(p,10)*power(q,2)+
      112500000*power(q,3)*power(p,2)*power(r,4)+75000000*power(q,3)*power(r,4)*p+22500000*power(q,2)*power(r,4)*power(p,3)+9315000*
      power(q,2)*power(p,6)*power(r,2)+250000000*power(q,3)*power(r,5)-121500*power(q,4)*power(p,6)+67500000*power(q,3)*power(r,3)*power(p,3)+10125000
      *power(q,3)*power(p,4)*power(r,2)+100000000*power(q,4)*power(r,4)-7200000*power(q,5)*r*power(p,3)+2592000*power(q,3)*r*power(p,6)
      -1674000*power(p,5)*power(q,4)*r+24840000*power(p,5)*power(q,3)*power(r,2)+486000*power(p,7)*r*power(q,2)+43740*power(p,11)*r+
      6144000*power(q,8)*p+1152000*power(q,7)*power(p,2)+8192000*power(q,9)+1265625*power(r,4)*power(p,6)+12800000*power(q,7)
      *power(r,2)+20480000*power(q,8)*r+1883250*power(p,8)*q*power(r,2)+291600*q*r*power(p,9)+180000000*power(p,2)*power(q,4)
      *power(r,3)-38400000*power(p,2)*power(q,6)*r-15750000*power(q,4)*power(p,4)*power(r,2)-13680000*power(q,5)*power(p,4)*r+24000000
      *power(q,5)*power(p,2)*power(r,2)-80000000*power(q,5)*p*power(r,3)+2304000*power(q,6)*power(p,3)*r-128000000*power(q,6)*p*power(r,2)-43520000*power(q,7)*p*r+54000000*power(p,3)*power(q,4)*power(r,2)))/((160*power(q,3)-300*q*p*r-27*power(p,4))*
      (4*q+3*p))

      eta = (50*q*r-15*power(p,2)*r+125*power(r,2)+129*power(p,2)*q+45*power(p,3)+92*p*power(q,2)-80*power(q,2)*xi-120*q*xi
      *p-45*power(p,2)*xi)/(100*q*r+80*power(q,2)+30*p*q+9*power(p,3))

   #all cases
   d3 = (9/5*power(m,5)*q-9/5*power(m,4)*r+24/5*power(m,3)*r-p*power(alpha,3)-2/25*power(n,3)-56/25*n*power(p,2)+36
   /25*n*power(m,7)+84/25*n*power(m,5)+72/5*q*power(m,2)*n-63/25*power(p,2)*power(m,3)-10*q*m*p-9/5*m*power(n,4)+2/
   25*power(p,3)+6/5*power(n,2)*power(alpha,2)-36/25*p*power(m,6)-96/25*p*power(m,4)-4/25*power(m,9)-12/25*power(m,7)*alpha
   +27/5*q*power(n,2)*m+24/25*power(m,6)*alpha+12/25*power(m,4)*power(alpha,2)+power(p,2)+54/25*m*power(p,2)*n-38/
   5*q*n*m-5*r*power(alpha,2)-4*q*power(alpha,2)+2*r*m+162/25*power(m,3)*p*alpha-87/25*power(m,4)*p*alpha
   +11/5*q*p*alpha+14/5*m*power(alpha,2)*p-23/5*power(n,2)*p*alpha-3*power(m,2)*p*alpha-4/
   25*power(m,3)*power(alpha,3)-12/25*power(m,5)*power(alpha,2)+12/5*power(p,2)*alpha-3*r*power(n,2)-5*r*alpha-6/5*
   power(m,2)*q-3*m*power(q,2)-314/25*n*m*alpha*p+261/25*n*power(m,2)*alpha*p-8*n*m*alpha*q-12
   /5*power(n,3)*alpha+3*r*n-12/25*power(m,5)*alpha-5*r*power(m,2)+2*p*r+2/5*n*q+10*r*m*alpha+
   66/25*n*power(m,3)*power(alpha,2)+3/5*n*m*power(alpha,3)+19/5*n*p*power(alpha,2)-3*m*power(n,2)*power(alpha,2)+44/5
   *q*n*alpha+17/5*q*m*power(alpha,2)-42/5*q*power(m,2)*alpha+33/25*power(n,2)*power(m,2)+21/5*power(m,3)
   *q*alpha-58/25*m*power(p,2)*alpha+13/5*n*p*alpha-28/5*power(n,2)*q+6/5*power(n,4)+4*power(q,2)-24/
   5*q*power(m,4)+237/25*power(n,2)*power(m,4)-186/25*power(n,3)*power(m,2)+252/25*power(n,2)*m*p+279/25*power(m,2)*p*n-38
   /5*m*n*r-23/5*m*power(p,2)-69/25*p*power(n,2)-12/5*m*p*n+27/5*r*power(m,2)*n+27/5*power(m,2)*q*p+21/5
   *power(m,3)*q-12/5*m*p*r-12/5*q*p*n+23/5*q*p+69/25*m*power(n,3)+3*q*r-162/25*power(m,3)*
   power(n,2)-108/25*power(m,5)*power(n,2)+123/25*power(m,3)*power(n,3)+102/25*power(m,5)*p-78/5*power(m,3)*p*n+153/25*power(m,2)
   *power(p,2)-96/25*power(m,6)*n-12/25*power(m,7)+4/25*power(m,6)+21/5*m*alpha*power(n,3)+234/25*power(m,2)*alpha*
   power(n,2)+63/25*n*power(m,3)*alpha-36/5*n*power(m,3)*q-63/25*m*alpha*power(n,2)-183/25*power(m,3)*alpha*
   power(n,2)-189/25*power(m,2)*power(n,2)*p+7*r*n*alpha-29/5*r*power(m,2)*alpha+21/5*q*m*alpha+171/25
   *n*power(m,4)*p-6*n*power(m,4)*alpha+87/25*n*power(m,5)*alpha-54/25*n*power(m,2)*power(alpha,2)-76/25*power(m,2)*power(alpha,2)*p+12/25*power(m,8)-24/25*power(m,4)*n+6/5*power(m,3)*p+9/5*p*power(n,3))

   d2 = (-18/5*q*power(m,2)*eta+246/25*power(m,5)*q+12/25*eta*power(m,8)-138/25*power(m,6)*q-54/5*power(m,4)
   *r+28/5*power(m,3)*r+694/25*m*power(n,2)*p*alpha-308/25*m*q*p*alpha+162/25*power(m,3)*eta*p
   *alpha+234/25*eta*power(m,2)*alpha*power(n,2)-10*eta*q*m*p+72/5*eta*q*power(m,2)*n+24/5*power(m,7)
   *p-24/25*power(m,7)*eta-28/5*n*power(p,2)-24/5*n*power(m,8)+276/25*power(m,4)*power(p,2)+216/25*n*power(m,7)+6/5
   *q*n*eta+292/25*q*power(m,2)*n-468/25*power(p,2)*power(m,3)-48/5*q*m*p-198/25*m*power(n,4)-12/5*power(p,3)-6/5*power(n,3)*power(alpha,2)-228/25*p*power(m,6)+12/25*power(m,10)+6*power(m,5)*r-6/5*power(n,5)+3*power(p,2)*power(alpha,2)-24/25*power(m,9)-96/25*eta*power(m,6)*n+153/25*eta*power(m,2)*power(p,2)-78/5*eta*power(m,3)*p*n+102/25
   *eta*power(m,5)*p+252/25*eta*power(n,2)*m*p-186/25*eta*power(n,3)*power(m,2)-24/5*eta*q*power(m,4)+237/25
   *eta*power(n,2)*power(m,4)-28/5*eta*power(n,2)*q-24/25*power(m,7)*alpha+686/25*q*power(n,2)*m+5*power(r,2)+656/25
   *m*power(p,2)*n+3*eta*power(p,2)+12/5*power(p,2)*xi+88/25*power(m,3)*power(alpha,2)*p-24/25*power(m,5)*eta*alpha
   -186/25*power(m,4)*p*alpha+46/5*q*p*alpha-48/5*power(n,2)*q*alpha-12/5*power(n,3)*eta*alpha
   -38/5*power(n,2)*p*alpha-10*r*alpha*eta+24/25*power(m,4)*alpha*xi+24/25*power(m,8)*alpha+12/25
   *power(m,6)*power(alpha,2)-12/25*power(m,7)*xi+24/25*power(m,6)*xi-42/5*r*power(n,2)-5*r*xi-10*m*power(q,2)+
   14/5*p*m*power(alpha,2)*eta-152/25*power(m,2)*alpha*p*xi+34/5*q*m*alpha*xi+44/5*q*n*
   eta*alpha-42/5*q*power(m,2)*eta*alpha-38/5*r*m*n*eta+10*r*m*alpha*eta+22/5*n*
   q*power(alpha,2)+42/5*q*m*alpha*eta+572/25*n*power(m,2)*alpha*p-76/5*q*m*n*eta-314/25
   *n*m*xi*p+126/25*n*power(m,3)*alpha*eta-108/25*n*power(m,2)*alpha*xi+261/25*n*power(m,2)*xi
   *p-452/25*n*m*alpha*q-126/25*m*alpha*power(n,2)*eta-116/5*r*m*alpha*n+558/25
   *n*power(m,2)*eta*p+12/5*power(n,4)*alpha-76/5*r*m*q-12/5*power(n,3)*xi+8*p*r+8/5*power(q,2)*alpha
   +51/5*power(m,2)*power(q,2)-26/5*power(q,2)*n+28/5*m*alpha*p*xi+26/5*n*eta*p*alpha-6*power(m,2)*eta
   *p*alpha-816/25*n*power(m,3)*alpha*p+638/25*n*power(m,2)*alpha*q-8*n*m*xi*q-54/25*n
   *eta*power(m,2)*power(alpha,2)-6*n*eta*power(m,4)*alpha+9/5*n*m*power(alpha,2)*xi+132/25*n*power(m,3)*alpha
   *xi-42/5*n*m*p*power(alpha,2)+38/5*n*p*alpha*xi-6*m*power(n,2)*alpha*xi-314/25*n*eta
   *m*alpha*p+6*r*n*eta-10*r*power(m,2)*eta+10*r*m*xi-78/25*n*power(m,4)*power(alpha,2)+12/5
   *power(n,2)*alpha*xi+6/5*power(n,2)*eta*power(alpha,2)+129/25*power(m,2)*power(n,2)*power(alpha,2)-10*power(p,2)*n*alpha
   +12/5*power(p,2)*alpha*eta-528/25*power(m,3)*q*p+268/25*power(m,2)*power(p,2)*alpha-42/5*q*power(m,2)*xi
   +44/5*q*n*xi+24/5*r*power(m,3)*eta+6/5*eta*power(n,4)-3*power(m,2)*xi*p+4*eta*power(q,2)-63/25*m*xi
   *power(n,2)-87/25*power(m,4)*p*xi+162/25*power(m,3)*p*xi+11/5*q*p*xi+216/25*power(m,3)*q*alpha-8*
   m*power(p,2)*alpha-198/25*n*power(m,6)*alpha+516/25*power(m,4)*alpha*power(n,2)-444/25*power(m,2)*alpha*power(n,3)+21/5*power(m,3)*q*xi-58/25*m*power(p,2)*xi+13/5*n*p*xi-23/5*power(n,2)*p*xi+24/25*power(m,6)*eta
   *alpha+198/25*power(m,5)*p*alpha+12/25*power(m,4)*power(alpha,2)*eta-3*p*power(alpha,2)*xi-12/25*
   power(m,5)*xi+63/25*power(m,3)*xi*n-6/25*power(n,3)*eta+171/25*power(p,2)*power(n,2)+99/25*power(n,2)*power(m,2)*eta-32
   /25*power(n,2)*q+6/25*power(n,4)+4/5*power(q,2)-108/25*q*power(m,4)+234/25*power(n,2)*power(m,4)-168/25*power(n,3)*power(m,2)+
   312/25*power(n,2)*m*p-56/5*m*n*r+52/25*m*power(p,3)+84/5*power(m,2)*p*r+96/5*m*r*power(n,2)+152/5*
   r*power(m,2)*n-58/5*p*n*r+748/25*power(m,2)*q*p+18/5*power(m,3)*eta*p-72/25*power(m,4)*eta*n+654/25
   *q*n*m*p-104/5*m*p*r-476/25*q*p*n+12/25*power(m,6)*eta+10*q*r+6*q*power(n,3)-36/5*n
   *eta*m*p-642/25*power(m,5)*power(n,2)+696/25*power(m,3)*power(n,3)+108/25*power(m,5)*p-432/25*power(m,3)*p*n+38/
   5*power(m,2)*power(p,2)-96/25*power(m,6)*n-52/25*q*power(p,2)+321/25*power(n,4)*power(m,2)-24*power(m,3)*r*n-88/25*power(m,2)*
   power(alpha,2)*q-216/25*power(m,4)*q*alpha+186/25*m*alpha*power(n,3)+228/5*power(m,3)*p*power(n,2)-138/25
   *power(n,2)*eta*p-792/25*q*power(m,2)*power(n,2)-183/25*power(m,3)*xi*power(n,2)+21/5*m*xi*power(n,3)-324/25*power(m,3)
   *power(n,2)*eta-492/25*power(n,3)*m*p+87/25*n*power(m,5)*xi+678/25*n*q*power(m,4)-192/5*n*power(m,3)*q+234/25
   *power(m,2)*xi*power(n,2)-72/5*power(m,3)*alpha*power(n,2)-1296/25*power(m,2)*power(n,2)*p+138/25*m*power(n,3)*eta+
   56/5*r*power(m,3)*alpha+6*r*m*eta+10*r*n*alpha+10*r*p*alpha+4*r*m*power(alpha,2)-48/
   5*r*power(m,2)*alpha+7*r*n*xi-29/5*r*power(m,2)*xi+1122/25*n*power(m,4)*p+168/25*n*power(m,5)*eta-
   6*n*power(m,4)*xi+174/25*n*power(m,5)*alpha+42/5*q*power(m,3)*eta+46/5*q*p*eta-576/25*n*power(m,2)
   *power(p,2)-702/25*n*power(m,5)*p-192/25*p*power(m,4)*eta-24/25*power(m,5)*alpha*xi-46/5*m*power(p,2)*eta
   -12/25*power(m,3)*power(alpha,2)*xi+2*p*r*eta-8*q*alpha*xi-4*q*eta*power(alpha,2)-10*r*alpha
   *xi-56/25*power(p,2)*n*eta+84/5*power(m,6)*power(n,2)+12/25*power(m,8)-606/25*power(n,3)*power(m,4)+21/5*m*xi*q
   +198/25*p*power(n,3))

   d1 = (-18/5*q*power(m,2)*power(eta,2)+6/5*q*n*power(eta,2)-12/25*power(m,7)*power(eta,2)+31/5*power(p,3)*n-36/5*
   n*power(eta,2)*m*p+24/25*eta*power(m,8)-126/25*power(m,6)*q-31/5*power(p,2)*r+99/25*power(n,2)*power(m,2)*power(eta,2)+
   18/5*power(m,3)*power(eta,2)*p-72/25*power(m,4)*power(eta,2)*n-3*power(p,3)*alpha+87/5*n*power(p,2)*m*alpha+367/
   25*m*power(n,2)*q*alpha+152/5*r*n*power(m,2)*eta+579/25*power(m,4)*p*n*alpha-176/25*power(m,2)*alpha
   *q*xi-72/5*eta*power(m,3)*alpha*power(n,2)-1296/25*eta*power(m,2)*power(n,2)*p-63/25*m*alpha*power(n,2)
   *power(eta,2)+202/5*r*p*m*n+279/25*n*power(m,2)*power(eta,2)*p-126/25*eta*m*xi*power(n,2)-6*eta*power(m,2)*xi*p-282/25*power(q,2)*power(m,3)+141/25*power(m,7)*q-24/25*power(m,9)*eta-96/5*eta*q*m*p+584/25
   *eta*q*power(m,2)*n+126/25*power(m,7)*p-132/25*p*power(m,8)-24/5*n*power(m,8)-186/25*power(p,3)*power(m,2)+327/25
   *power(m,4)*power(p,2)-15*power(p,2)*power(m,5)-129/25*p*power(n,4)-12/25*power(m,11)+12/25*power(m,10)+12/25*power(m,6)*power(eta,2)-33/5*power(m,6)*r+6*power(m,5)*r-11*m*power(r,2)-6/25*power(n,5)+42/5*eta*m*xi*q-192/25*eta*power(m,6)*
   n+76/5*eta*power(m,2)*power(p,2)-864/25*eta*power(m,3)*p*n+216/25*eta*power(m,5)*p+624/25*eta*power(n,2)*
   m*p-336/25*eta*power(n,3)*power(m,2)-216/25*eta*q*power(m,4)+468/25*eta*power(n,2)*power(m,4)-64/25*eta*power(n,2)*q+129/25*m*power(n,5)+126/25*eta*power(m,3)*xi*n+6/5*power(n,2)*power(xi,2)+5*power(r,2)-4*q*power(xi,2)-12/5
   *power(p,3)*eta-5*r*power(xi,2)+3*power(p,2)*power(eta,2)-69/5*power(n,2)*power(m,5)*alpha-37/25*m*power(q,2)*alpha-123
   /25*m*power(n,4)*alpha-822/25*power(m,5)*n*q-12/25*power(m,9)*alpha-452/25*n*eta*m*alpha*q-
   24/25*eta*power(m,5)*xi-24/25*power(m,7)*xi+927/25*power(m,5)*power(n,3)-528/25*power(m,7)*power(n,2)+44/5*n*q*alpha
   *xi+13/5*p*n*power(eta,2)*alpha-3*p*power(m,2)*power(eta,2)*alpha+46/5*p*q*alpha*eta+24
   /25*power(m,4)*alpha*eta*xi-104/5*r*m*p*eta-112/5*r*m*n*eta-762/25*power(n,2)*power(m,2)*p*
   alpha-186/25*power(m,4)*eta*p*alpha+10*r*m*xi*eta+10*r*n*eta*alpha+8*r*m*alpha
   *xi-192/5*n*eta*power(m,3)*q+656/25*n*eta*m*power(p,2)+21/5*q*m*alpha*power(eta,2)-38/5*q*
   m*n*power(eta,2)+572/25*n*power(m,2)*xi*p+63/25*n*power(m,3)*alpha*power(eta,2)+186/25*eta*m*alpha
   *power(n,3)+686/25*eta*m*power(n,2)*q+79/5*r*power(m,2)*n*alpha-116/5*r*m*xi*n+132/25*power(m,9)*n
   -669/25*power(m,3)*power(n,4)-52/5*r*m*q+12/25*power(m,4)*power(xi,2)+14/5*m*p*power(xi,2)-54/25*power(m,2)*n*power(xi,2)+147/25*power(m,2)*power(q,2)-34/25*power(q,2)*n+28/5*p*m*alpha*xi*eta-8*q*eta*alpha*xi-8
   *power(p,2)*m*alpha*eta-10*p*n*q*alpha-38/5*p*power(n,2)*eta*alpha+259/25*q*power(m,2)*p*alpha
   -444/25*q*power(m,3)*n*alpha+216/25*q*power(m,3)*eta*alpha+748/25*p*q*power(m,2)*eta+26/
   5*n*eta*p*xi+176/25*power(m,3)*xi*p*alpha+174/25*n*eta*power(m,5)*alpha-452/25*n*m*xi
   *q+1122/25*n*eta*power(m,4)*p-1404/25*p*q*power(m,2)*n-42/5*p*r*m*alpha+9/5*n*m*alpha
   *power(xi,2)-156/25*n*power(m,4)*alpha*xi+12/5*power(n,2)*eta*alpha*xi+258/25*power(m,2)*power(n,2)*alpha
   *xi-48/5*r*power(m,2)*eta*alpha-476/25*n*eta*q*p-108/25*n*eta*power(m,2)*alpha*xi-
   84/5*n*m*p*alpha*xi-42/5*power(n,2)*r*eta+6*power(p,2)*alpha*xi+10*r*q*eta-5*r*power(m,2)*power(eta,2)+3*r*n*power(eta,2)-132/5*p*r*power(m,3)+19/5*n*p*power(xi,2)-12/5*power(n,3)*alpha*xi-10*power(p,2)*
   n*xi+12/5*power(p,2)*xi*eta-3*p*alpha*power(xi,2)-198/5*power(m,2)*r*power(n,2)-54/5*power(m,4)*r*eta+246
   /25*power(m,5)*eta*q-504/25*power(m,3)*q*p+217/25*q*power(p,2)*m+24/25*power(m,6)*alpha*xi+111/25*
   power(m,7)*n*alpha-222/25*power(m,3)*power(p,2)*alpha-111/25*power(m,6)*p*alpha-24/25*power(m,7)*eta*alpha
   +56/5*r*power(m,3)*eta+12/25*eta*power(n,4)+8/5*eta*power(q,2)-186/25*power(m,4)*p*xi+46/5*q*p*xi
   +216/25*power(m,3)*q*xi-8*m*power(p,2)*xi-38/5*power(n,2)*p*xi-5*r*alpha*power(eta,2)+5*p*power(n,3)*alpha
   -10*r*xi*eta-6/25*power(n,3)*power(eta,2)+47/5*power(p,2)*power(n,2)+26/5*m*power(p,3)+94/5*power(m,2)*p*r+94/5
   *m*r*power(n,2)-84/5*p*n*r+748/25*q*n*m*p+34/25*q*power(n,3)-26/5*q*power(p,2)-3*m*power(xi,2)*power(n,2)
   -31/25*p*power(q,2)+267/25*power(n,4)*power(m,2)-76/25*power(m,2)*power(xi,2)*p+27/5*r*power(n,3)+66/25*power(m,3)*power(xi,2)
   *n-24*power(m,3)*r*n+1314/25*power(n,2)*q*power(m,3)-27/5*power(m,4)*r*alpha+33*power(m,4)*r*n-516/25*power(n,3)
   *q*m-846/25*power(n,2)*power(p,2)*m+1218/25*n*power(p,2)*power(m,3)+252/5*power(m,3)*p*power(n,2)-198/25*eta*m*power(n,4)+69/25*m*power(n,3)*power(eta,2)-69/25*power(n,2)*power(eta,2)*p-132/5*q*power(m,2)*power(n,2)-72/5*power(m,3)*xi*power(n,2)
   -162/25*power(m,3)*power(n,2)*power(eta,2)+186/25*m*xi*power(n,3)-504/25*power(n,3)*m*p+301/25*n*power(q,2)*m+174/25
   *n*power(m,5)*xi+606/25*n*q*power(m,4)+84/25*n*power(m,5)*power(eta,2)+696/25*eta*power(m,3)*power(n,3)-642/
   25*eta*power(m,5)*power(n,2)+198/25*eta*power(n,3)*p+381/25*q*p*power(n,2)-54/5*q*n*r+109/5*q*power(m,2)*
   r+6*r*m*power(eta,2)+56/5*r*power(m,3)*xi+10*r*n*xi+10*r*p*xi+r*q*alpha-48/5*r*power(m,2)*xi
   +21/5*q*power(m,3)*power(eta,2)+23/5*q*p*power(eta,2)-5*r*power(n,2)*alpha-804/25*n*power(m,2)*power(p,2)-756/25
   *n*power(m,5)*p+216/25*n*eta*power(m,7)+183/5*p*power(m,6)*n-468/25*power(p,2)*power(m,3)*eta-96/25*p*power(m,4)*power(eta,2)-228/25*p*power(m,6)*eta+657/25*p*q*power(m,4)-1959/25*p*power(n,2)*power(m,4)+1362/25*p*power(n,3)*power(m,2)+402/25*power(n,3)*power(m,3)*alpha+111/25*q*power(m,5)*alpha-12/25*power(m,5)*power(eta,2)*alpha-23
   /5*m*power(p,2)*power(eta,2)-10*m*power(q,2)*eta-12/25*power(m,3)*alpha*power(xi,2)+16*p*r*eta-56/5*power(p,2)*n
   *eta+572/25*n*eta*power(m,2)*alpha*p+12/5*power(n,4)*xi+8/5*power(q,2)*xi-12/25*power(m,5)*power(xi,2)+417/25
   *power(m,6)*power(n,2)-582/25*power(n,3)*power(m,4)-12/5*power(n,3)*eta*xi-308/25*q*m*p*xi+638/25*q*power(m,2)*n*xi+44/5*q*n*eta*xi-42/5*q*power(m,2)*eta*xi+24/25*power(m,8)*xi+17/5*m*power(xi,2)*q-198/25
   *power(m,6)*n*xi+268/25*power(m,2)*power(p,2)*xi-816/25*power(m,3)*p*n*xi+198/25*power(m,5)*p*xi-314
   /25*n*eta*m*p*xi+24/25*power(m,6)*eta*xi-6*power(m,4)*eta*n*xi+162/25*power(m,3)*eta*p*xi+694/25
   *power(n,2)*m*p*xi-444/25*power(n,3)*power(m,2)*xi+516/25*power(n,2)*power(m,4)*xi-216/25*q*power(m,4)*xi-48/5
   *power(n,2)*q*xi+234/25*power(n,2)*power(m,2)*eta*xi)

   d0 = (14/25*power(q,2)*power(n,2)-528/25*power(n,2)*q*m*p-12/25*power(n,4)*q+408/25*power(n,3)*q*power(m,2)-72/5
   *power(m,5)*r*n-24*power(m,3)*r*n*eta+6*power(m,5)*r*eta-27/5*power(m,4)*r*xi+24*power(m,3)*r*power(n,2)+power(p,4)-708
   /25*n*power(p,2)*power(m,4)+87/5*n*power(p,2)*m*xi+47/5*power(n,2)*power(p,2)*eta-132/5*power(n,2)*q*power(m,4)+12/5*power(m,7)*r-5*r*power(n,2)*xi-48/5*power(m,3)*r*q-24/5*power(n,3)*power(p,2)-37/25*m*power(q,2)*xi-123/25*m*power(n,4)*xi
   +579/25*power(m,4)*p*n*xi-186/25*power(m,4)*eta*p*xi+259/25*q*power(m,2)*p*xi-444/25*q*power(m,3)
   *n*xi+216/25*q*power(m,3)*eta*xi+44/5*r*p*power(n,2)-132/5*eta*q*power(m,2)*power(n,2)+186/25*eta*
   m*xi*power(n,3)-63/25*m*xi*power(n,2)*power(eta,2)+234/25*power(m,4)*power(eta,2)*power(n,2)+33/25*power(m,2)*power(eta,3)*power(n,2)
   -168/25*power(n,3)*power(m,2)*power(eta,2)+312/25*power(n,2)*power(eta,2)*m*p-32/25*q*power(n,2)*power(eta,2)-432/25*n*
   power(m,3)*power(eta,2)*p-54/25*n*eta*power(m,2)*power(xi,2)-24/5*n*eta*power(m,8)+6*power(m,2)*power(r,2)+63/25*n*power(m,3)*
   xi*power(eta,2)+292/25*n*q*power(m,2)*power(eta,2)+6/25*power(n,4)*power(eta,2)-6/25*eta*power(n,5)-582/25*eta*power(n,3)*power(m,4)+34/25*eta*power(n,3)*q-72/5*eta*power(m,3)*xi*power(n,2)+267/25*eta*power(n,4)*power(m,2)+252/5*eta
   *power(m,3)*p*power(n,2)-504/25*eta*power(n,3)*m*p+56/5*q*m*n*r+417/25*eta*power(m,6)*power(n,2)-2/25*power(n,3)*power(eta,3)-4*n*power(r,2)+4/25*power(q,3)-48/5*n*power(p,3)*m+804/25*power(n,2)*power(p,2)*power(m,2)+2*r*m*power(eta,3)+367/25
   *m*power(n,2)*q*xi+r*q*xi+10*r*n*eta*xi-48/5*r*power(m,2)*eta*xi+79/5*r*power(m,2)*n*xi
   +327/25*power(m,4)*power(p,2)*eta-168/25*power(m,2)*power(p,2)*q-8/5*q*p*r-756/25*n*eta*power(m,5)*p+606
   /25*n*eta*q*power(m,4)+174/25*n*eta*power(m,5)*xi-108/25*q*power(m,4)*power(eta,2)-452/25*n*eta*m*
   xi*q-96/25*n*power(m,6)*power(eta,2)+21/5*q*m*xi*power(eta,2)-804/25*n*eta*power(m,2)*power(p,2)-24/25*n*
   power(m,4)*power(eta,3)+136/25*power(m,3)*power(p,3)+2/5*q*n*power(eta,3)-6/5*q*power(m,2)*power(eta,3)-48/5*q*m*p*power(eta,2)+162/25*power(m,6)*power(p,2)+4/5*power(q,2)*power(eta,2)+748/25*n*eta*q*m*p+572/25*n*eta*power(m,2)*xi*
   p-24/25*power(m,7)*eta*xi-12/25*power(m,5)*power(eta,2)*xi+28/5*q*n*power(p,2)-84/5*p*r*n*eta-144/
   5*p*r*power(m,2)*n-42/5*p*r*m*xi+12*p*r*power(m,4)+28/25*power(q,2)*m*p-42/5*n*m*p*power(xi,2)-78/
   25*n*power(m,4)*power(xi,2)+3/5*n*m*power(xi,3)+6/5*power(n,2)*eta*power(xi,2)+129/25*power(m,2)*power(n,2)*power(xi,2)-6/5*power(n,3)*power(xi,2)+5*power(r,2)*eta+4*r*m*power(xi,2)+4/25*power(m,6)*power(eta,3)+12/25*power(m,8)*power(eta,2)+147/25*power(m,2)*
   power(q,2)*eta-34/25*power(q,2)*n*eta+22/5*n*q*power(xi,2)-4*q*eta*power(xi,2)+94/5*p*r*power(m,2)*eta-38
   /5*p*power(n,2)*eta*xi-10*p*n*q*xi+108/25*power(m,5)*power(eta,2)*p+126/25*power(m,7)*eta*p-126/25
   *power(m,6)*eta*q+12/25*power(m,10)*eta-504/25*power(m,3)*eta*q*p-3*p*power(m,2)*power(eta,2)*xi+13/5*p*n
   *power(eta,2)*xi+46/5*p*q*xi*eta+14/5*p*m*power(xi,2)*eta+102/25*power(m,4)*power(q,2)-48/25*power(m,8)*q
   +4/25*power(m,12)+111/25*power(m,7)*n*xi-p*power(xi,3)-52/5*r*m*q*eta-56/5*r*m*n*power(eta,2)+94/5
   *r*m*power(n,2)*eta+28/5*r*power(m,3)*power(eta,2)-48/5*m*power(n,3)*r+2/25*power(n,6)+3*power(p,2)*power(xi,2)-3*power(p,3)*xi
   +6/5*power(m,3)*p*power(eta,3)-12/5*m*p*n*power(eta,3)+28/5*m*power(p,2)*r+8*p*r*power(eta,2)+816/25*power(m,3)
   *p*q*n+48/25*power(m,9)*p+26/5*power(p,3)*m*eta-26/5*power(p,2)*q*eta+38/5*power(m,2)*power(p,2)*power(eta,2)-384/25
   *power(m,7)*p*n-264/25*power(m,5)*p*q+204/5*power(m,5)*p*power(n,2)-1008/25*power(m,3)*p*power(n,3)+252/25*m
   *p*power(n,4)-28/5*power(p,2)*n*power(eta,2)-8*power(p,2)*m*xi*eta-762/25*power(n,2)*power(m,2)*p*xi+402/25*power(n,3)*
   power(m,3)*xi+216/25*power(m,8)*power(n,2)-48/25*power(m,10)*n-448/25*power(m,6)*power(n,3)+417/25*power(m,4)*power(n,4)-168/25
   *power(m,2)*n*power(q,2)+324/25*power(m,6)*n*q-132/25*power(m,2)*power(n,5)-69/5*power(n,2)*power(m,5)*xi+111/25*q*power(m,5)
   *xi+12/25*power(m,4)*power(xi,2)*eta+88/25*power(m,3)*power(xi,2)*p-88/25*power(m,2)*power(xi,2)*q-222/25*power(m,3)*power(p,2)*xi-111/25*power(m,6)*p*xi-4/25*power(m,3)*power(xi,3)+12/25*power(m,6)*power(xi,2)-12/25*power(m,9)*xi-5*r*xi*
   power(eta,2)+5*p*power(n,3)*xi+power(p,2)*power(eta,3))

   d = (1/6*power(36*d1*d2*d3-108*d0*power(d3,2)-8*power(d2,3)+12* mp.sqrt(3) * mp.sqrt(4*power(d1,3)*d3-power(d1,2)*power(d2,2)-18*d1*d2*d3*d0+27*power(d0,2)*power(d3,2)+4*d0*power(d2,3))*d3,1/3)/d3-2/3*(3*d1*
   d3-power(d2,2))/(d3*power(36*d1*d2*d3-108*d0*power(d3,2)-8*power(d2,3)+12* mp.sqrt(3)* mp.sqrt(4*power(d1,3)*d3
   -power(d1,2)*power(d2,2)-18*d1*d2*d3*d0+27*power(d0,2)*power(d3,2)+4*d0*power(d2,3))*d3,1/3))-1/3*d2/d3)

   b = alpha * d + xi
   c = d + eta

   a = (1/5*d*power(m,3)+1/5*b*m-3/5*d*m*n-2/5*power(n,2)+4/5*q-1/5*c*power(m,2)+2/5*c*n-4/5*
   m*p+4/5*power(m,2)*n+3/5*d*p-1/5*power(m,4))

   A = (power(m,2)*r*power(b,3)+6*power(c,2)*r*b*d*p-10*power(c,2)*r*b*a+r*power(d,3)*power(q,2)-2*r*power(b,3)*n+15*power(a,2)*
   b*r-10*power(q,2)*a*d*m*n-power(q,2)*c*n*d*p-4*power(d,2)*power(q,3)*c-9*c*r*p*power(b,2)+18*power(q,2)*power(a,2)-8*a*
   power(q,3)-16*q*power(a,3)-6*c*r*power(b,2)*d*n-4*power(c,2)*r*power(b,2)*m+3*c*r*b*power(d,2)*power(n,2)+6*c*r*b*power(p,2)-5
   *power(c,3)*power(r,2)-6*power(c,2)*r*d*power(p,2)+3*power(c,3)*r*b*n-5*m*power(q,2)*power(b,2)*d-8*m*r*a*power(c,2)*n+4*power(q,2)*a
   *power(n,2)-8*m*q*power(b,2)*r-2*power(m,2)*q*a*power(b,2)+power(d,4)*power(q,3)+3*power(r,2)*power(d,2)*power(n,2)-2*power(d,3)*n*power(q,2)*b-5*power(d,3)*power(r,2)*b+4*m*r*a*c*power(n,2)-d*r*power(b,3)*m+r*d*power(m,2)*n*power(b,2)-5*r*d*p*power(b,2)*m-r*b*d*p*power(n,2)-2*r*b*a*power(m,2)*n-2*power(c,3)*power(q,2)*n-4*r*d*q*a*c+r*b*power(d,2)*p*m*n+2*r*b*a*power(n,2)+2*r
   *a*power(b,2)*m+2*r*power(m,2)*p*power(b,2)-r*power(n,2)*power(b,2)*m+r*p*power(b,2)*n+2*power(r,2)*m*p*c+r*b*n*power(p,2)+3*power(b,2)*r*power(d,2)*p+4*d*r*a*c*m*p-power(d,3)*r*b*n*p-power(d,2)*r*power(b,2)*m*n+power(b,4)*q-2*power(b,2)*q*power(d,2)*m
   *p-3*m*power(q,3)*b+d*power(m,2)*q*power(b,3)+2*d*r*power(c,3)*m*p-8*a*n*power(r,2)-2*power(b,2)*q*c*power(n,2)+3*power(b,2)*q
   *c*d*p+power(b,2)*q*power(c,2)*n-2*a*power(d,3)*power(p,3)-2*power(c,2)*r*p*b*m+2*c*r*power(d,3)*power(p,2)+10*a*c*power(r,2)-
   12*q*power(a,2)*power(n,2)-7*p*b*power(r,2)-2*c*power(q,3)*n+13*power(d,2)*power(r,2)*b*m+power(c,2)*q*b*d*m*p+4*power(c,2)*r*
   m*power(p,2)+4*power(c,3)*r*a*m-2*power(c,2)*r*p*power(d,2)*n+4*q*n*power(r,2)-b*q*power(c,3)*p+b*q*power(d,3)*power(p,2)-power(c,2)*
   q*p*b*power(m,2)-4*power(m,2)*power(r,2)*power(c,2)+5*power(d,3)*r*b*m*q-8*power(c,2)*power(q,2)*a+4*d*r*power(b,2)*c*power(m,2)-4*power(d,2)*r*b*m*c*p-power(m,3)*q*power(b,3)+power(m,2)*power(q,2)*power(c,3)+3*power(m,2)*power(q,2)*power(b,2)+4*c*power(q,2)*power(b,2)-2*power(m,2)*r*power(c,3)*p-4*power(d,3)*power(r,2)*c*m-3*d*r*b*power(c,2)*m*n-9*power(d,2)*power(r,2)*c*n-2*power(d,2)*r*m*c*power(p,2)+3*power(m,2)*
   r*b*power(c,2)*n+8*power(r,2)*power(c,2)*n+10*power(d,2)*power(r,2)*a-6*a*power(p,3)*b+4*d*r*p*b*c*power(m,2)-4*power(m,3)*r*power(b,2)*c-3*n*power(q,2)*power(b,2)+power(q,2)*power(c,2)*power(n,2)+6*a*power(p,2)*power(b,2)+3*power(d,4)*power(r,2)*n-2*power(c,4)*r*p+power(b,2)*q*power(n,3)-c*power(q,2)*power(d,3)*p+6*power(m,2)*q*c*power(a,2)+power(c,4)*power(q,2)+d*r*power(c,3)*q+12*a*power(m,2)*power(r,2)+power(r,2)*power(d,2)*q+
   power(q,2)*c*power(p,2)+7*power(q,2)*b*r+12*power(a,2)*c*n*m*p+3*power(a,2)*c*n*d*p-15*power(a,2)*c*m*d*q-3*power(a,2)*
   c*n*b*m+3*power(a,2)*d*power(m,2)*n*b-9*power(a,2)*power(d,2)*p*m*n-3*power(a,2)*power(m,3)*n*b+9*power(a,2)*d*p*power(m,2)*n+
   12*power(a,2)*n*power(p,2)-12*power(a,2)*p*r+3*power(a,2)*power(d,2)*power(n,3)+9*power(a,2)*power(d,2)*power(p,2)+6*power(a,2)*d*p*c*power(m,2)+24
   *power(a,2)*m*n*r-3*power(a,2)*d*m*power(n,3)-9*power(a,2)*power(d,2)*n*q-12*power(a,2)*m*p*power(n,2)-6*power(a,2)*power(m,3)*p*c+9*
   power(a,2)*power(n,2)*b*m+3*power(a,2)*d*p*power(n,2)-15*power(a,2)*d*power(p,2)*m+9*power(a,2)*power(d,2)*power(m,2)*q-6*power(a,2)*power(c,2)*m*p
   -3*power(a,2)*c*power(n,2)*d*m+4*power(a,3)*power(m,4)+8*power(a,3)*power(n,2)+3*power(a,2)*power(n,4)-6*power(q,2)*a*c*power(m,2)+4*power(q,2)*c*n
   *a+12*power(a,3)*d*m*n+3*power(m,2)*p*power(a,2)*b+21*power(a,2)*d*power(m,2)*r+3*power(a,2)*c*power(n,2)*power(m,2)-6*power(a,2)*b*d
   *power(n,2)-15*power(a,2)*p*b*n+9*power(a,2)*b*c*p+12*power(a,2)*b*d*q-18*power(a,2)*c*m*r-21*power(a,2)*d*n*r+5
   *power(a,4)-2*power(q,2)*d*p*a+8*power(q,2)*a*m*p+4*a*c*m*d*power(q,2)+6*a*power(d,2)*power(m,2)*power(q,2)+power(q,2)*d*n*r+3
   *power(q,2)*p*b*n-5*power(q,2)*b*c*p+3*c*m*d*power(q,3)-16*a*b*d*power(q,2)+4*a*power(d,2)*n*power(q,2)+power(d,2)*n*power(q,3)+3*power(a,2)*power(c,2)*power(n,2)+4*power(a,3)*c*power(m,2)-4*power(a,3)*b*m-8*c*n*power(a,3)-12*d*p*power(a,3)-4*power(a,3)*d*power(m,3)
   +16*power(a,3)*m*p-16*power(a,3)*power(m,2)*n+3*power(a,2)*power(b,2)*n-6*power(a,2)*c*power(n,3)-12*power(a,2)*power(m,3)*r-9*power(a,2)*c*
   power(p,2)-4*power(q,2)*p*r+power(q,4)+4*b*d*power(q,3)-d*p*power(q,3)-3*d*p*power(a,2)*b*m+4*c*power(q,2)*b*d*n-3*d*power(q,2)*b*c*power(m,2)-d*power(q,2)*power(c,2)*m*n+power(c,2)*power(q,2)*b*m+power(d,2)*p*b*power(q,2)+15*d*r*c*power(a,2)-9*power(d,2)*r*m
   *power(a,2)+2*power(c,2)*power(q,3)-power(d,3)*power(q,3)*m+power(q,2)*c*n*b*m+power(d,2)*p*c*m*power(q,2)-m*p*b*d*power(q,2)+12*a*m*
   p*b*r-3*r*c*d*power(q,2)-r*power(d,2)*m*power(q,2)+3*power(c,2)*p*d*power(q,2)+2*a*power(c,3)*power(p,2)-2*a*power(m,2)*p*c*n*
   b+2*a*m*p*b*d*power(n,2)-2*a*m*power(p,2)*c*n*d+16*a*power(c,2)*p*r+2*a*c*power(p,2)*power(n,2)+2*a*power(m,2)*power(p,2)*power(c,2)-16*q*a*c*n*d*p+2*q*m*p*b*r+10*a*m*power(q,2)*b+4*power(m,3)*r*a*power(c,2)+6*q*a*d*p
   *power(n,2)+2*q*a*d*power(p,2)*m+2*q*a*power(n,2)*b*m-16*q*a*c*n*b*m-2*q*a*d*power(m,2)*n*b-6*q*a*
   power(d,2)*p*m*n+8*q*a*c*n*m*p+4*q*a*p*b*n+4*q*a*b*c*p+8*q*a*c*m*r+12*q*a*d*n
   *r-16*q*a*m*n*r+4*q*a*c*power(n,2)*d*m+2*q*a*d*p*c*power(m,2)+10*q*a*d*power(m,2)*r-4*q*a*c
   *power(n,3)+4*q*a*c*power(p,2)-8*q*a*n*power(p,2)+16*q*a*p*r-2*q*a*power(d,2)*power(p,2)+6*q*c*n*power(a,2)+15*q
   *d*p*power(a,2)-9*q*power(a,2)*d*power(m,3)-24*q*power(a,2)*m*p+12*q*power(a,2)*power(m,2)*n+4*q*a*power(b,2)*n-3*q*power(a,2)
   *b*m-10*q*power(m,2)*p*a*b+6*q*power(a,2)*d*m*n-4*q*power(c,2)*p*r+8*q*a*power(c,2)*power(n,2)+6*power(c,2)*q*power(a,2)+6*power(a,2)*power(m,2)*power(p,2)-3*q*m*p*power(b,2)*n-16*q*power(d,2)*r*m*a-q*b*p*c*power(n,2)+2*q*b*p*power(c,2)*n
   -q*power(d,2)*r*n*c*m-22*q*a*b*r+6*a*d*power(p,3)*c-2*a*d*power(p,3)*n+2*a*d*power(p,2)*r+11*q*power(d,2)
   *r*c*p-2*q*d*r*power(c,2)*n+power(d,3)*r*c*q*n+q*d*r*c*power(n,2)+3*q*power(d,3)*r*m*p-5*q*power(d,2)*r*b
   *n-5*q*power(d,2)*r*b*power(m,2)-q*c*p*power(b,2)*m+4*q*c*p*n*r+13*q*d*r*power(b,2)-q*power(d,2)*m*power(p,2)*b+
   3*q*power(p,2)*power(b,2)-6*q*c*power(r,2)-3*q*power(b,3)*p+2*q*d*power(m,2)*p*power(b,2)+10*q*r*b*d*m*n-2*a*power(b,3)
   *p-q*d*m*power(r,2)+3*q*d*power(p,2)*r+20*q*d*p*a*b*m+q*d*p*c*n*b*m+2*q*m*power(p,2)*b*c-8*
   q*d*p*c*m*r-3*q*power(d,2)*p*n*r+q*d*p*power(b,2)*n+5*d*power(r,3)-4*m*power(r,3)+2*a*power(p,4)+4*a*d*p*
   power(b,2)*n-6*a*power(d,2)*p*power(m,2)*r+2*a*power(d,2)*p*n*r+6*a*m*power(p,2)*b*n+2*a*d*p*c*n*b*m-8*a*
   m*power(p,2)*r+2*a*m*power(p,3)*power(d,2)-3*q*d*power(p,2)*b*c+2*a*m*power(p,2)*b*c+q*d*power(p,2)*b*n-2*a*d*power(p,2)*b*n-2*a*power(d,2)*p*b*power(n,2)-10*a*power(d,2)*p*b*q-6*a*d*power(p,2)*b*c+8*a*c*q*b*d*n-4*a*c
   *q*power(d,2)*power(n,2)+6*a*power(c,2)*q*b*m-6*a*m*p*power(b,2)*n+2*a*power(d,2)*power(p,2)*c*n-2*a*d*power(p,2)*power(c,2)*m
   +6*a*power(d,3)*p*n*q+4*a*b*p*c*power(n,2)-2*a*b*p*power(c,2)*n-2*a*b*p*power(n,3)+4*a*power(m,2)*p*c*r-8
   *a*c*q*power(b,2)+14*a*power(d,2)*r*b*n-8*a*power(d,2)*r*b*power(m,2)-14*a*power(d,2)*r*c*p-6*a*d*r*power(c,2)*n
   +14*a*d*r*b*c*m+12*a*d*r*c*power(n,2)+6*a*power(d,3)*r*m*p+10*a*power(d,2)*r*n*c*m-4*a*power(c,3)*
   q*n-4*a*power(m,2)*q*power(c,2)*n+6*a*power(m,3)*q*b*c+2*a*power(c,2)*p*d*q+2*a*c*p*power(b,2)*m-24*a*c*p
   *n*r-6*a*d*q*b*c*power(m,2)+4*a*d*q*power(c,2)*m*n+2*a*power(m,3)*p*power(b,2)-4*a*power(m,2)*power(p,2)*b*d-6*a
   *d*r*power(n,3)-6*a*power(d,3)*r*power(n,2)-10*a*d*r*power(b,2)+6*a*r*power(d,2)*power(n,2)*m-10*a*r*d*n*c*power(m,2)-20
   *a*r*b*d*m*n+8*a*r*b*d*power(m,3)-2*a*d*power(m,2)*p*power(b,2)+4*a*power(d,2)*m*power(p,2)*b-4*a*m*power(p,3)*
   c+8*a*r*p*power(n,2)-6*a*power(d,3)*power(q,2)*m+8*a*power(d,2)*power(q,2)*c-22*a*d*m*power(r,2)-4*a*power(c,2)*power(p,2)*n-2
   *a*power(d,2)*p*c*m*q+b*d*n*power(r,2)-5*p*d*n*power(r,2)-2*r*p*power(c,2)*power(n,2)+5*b*m*n*power(r,2)-8*b*d*power(m,2)*power(r,2)-2*b*c*m*power(r,2)+4*c*p*d*power(r,2)+2*r*power(c,2)*p*d*n*m-5*r*b*q*power(n,2)+4*r*power(c,3)*p*n
   -4*d*r*a*power(c,2)*power(m,2)+2*r*b*c*n*q+2*r*b*d*p*a-3*r*b*c*power(n,2)*d*m+3*r*b*c*power(n,3)-6
   *r*b*power(c,2)*power(n,2)+2*r*m*power(q,2)*c-8*r*p*c*n*b*m+5*power(b,2)*power(r,2)-5*d*power(r,2)*c*b-10*r*p*b*
   d*q+2*r*c*n*d*power(p,2)+4*power(d,2)*power(r,2)*c*power(m,2)-3*power(d,3)*power(r,2)*m*n+3*d*power(r,2)*power(c,2)*m+5*r*b*c*
   n*d*p-6*r*b*a*c*power(m,2)+8*r*b*c*n*a+r*d*q*power(c,2)*power(m,2)-2*c*r*power(p,3)+3*r*power(c,2)*q*b+11
   *r*c*n*power(b,2)*m+4*r*p*a*d*m*n+2*power(r,2)*d*n*c*m+2*power(r,2)*power(d,2)*m*p-3*power(r,2)*c*power(n,2)+2*power(p,2)*power(r,2)-2*power(d,3)*power(r,2)*p+2*power(d,2)*power(q,2)*m*b*n+3*m*q*power(b,3)*n+2*power(m,2)*q*b*c*r-2*d*power(q,2)*b
   *power(n,2)+5*c*r*power(b,3)-m*q*power(b,2)*d*power(n,2)+power(m,2)*q*c*n*power(b,2)+2*power(d,2)*power(q,2)*power(b,2)+3*power(d,2)*power(q,2)*b*c
   *m+2*power(d,2)*q*b*a*m*n-power(d,2)*q*b*c*n*p+6*power(d,3)*q*r*a-d*power(q,2)*power(c,3)*m-4*d*power(q,2)*power(c,2)*b
   +2*d*q*a*power(b,2)*m-7*power(d,2)*q*r*c*b-d*q*c*n*power(b,2)*m+power(d,2)*q*power(b,2)*power(n,2)-3*power(d,4)*q*r*p-2
   *d*q*power(b,3)*n-power(d,2)*q*r*power(c,2)*m+power(d,2)*power(q,2)*power(c,2)*n-2*power(c,2)*power(q,2)*p*m+5*power(d,2)*power(r,2)*power(c,2)-c*q
   *power(b,3)*m-q*power(p,3)*b)

   B = (3*m*power(r,2)*power(b,3)-3*r*power(p,2)*power(b,3)+2*m*power(r,3)*power(c,2)+a*power(d,4)*power(q,3)+power(d,4)*power(r,3)*m-power(b,3)*r*power(n,3)+5*a*power(b,2)*power(r,2)-5*power(c,2)*r*b*power(a,2)+power(r,3)*power(d,2)*p-3*r*b*power(a,2)*c*power(m,2)+4*r*b*c*n*power(a,2)+2*
   r*p*power(a,2)*d*m*n+power(d,2)*q*b*power(a,2)*m*n+d*q*power(a,2)*power(b,2)*m-power(a,2)*power(d,2)*p*c*m*q-2*d*r*power(a,2)*
   power(c,2)*power(m,2)+r*b*d*p*power(a,2)-power(m,2)*q*power(a,2)*power(b,2)+2*power(c,3)*r*power(a,2)*m+2*power(m,2)*q*c*power(a,3)+r*power(p,3)*power(b,2)+power(r,2)*power(c,3)*power(n,2)+power(a,2)*power(c,2)*p*d*q+power(a,2)*c*p*power(b,2)*m-12*power(a,2)*c*p*n*r-3*power(a,2)*d*q*b*c
   *power(m,2)+2*power(a,2)*d*q*power(c,2)*m*n-2*power(a,2)*power(m,2)*power(p,2)*b*d+3*power(a,2)*r*power(d,2)*power(n,2)*m-5*power(a,2)*r*d*n
   *c*power(m,2)-10*power(a,2)*r*b*d*m*n+4*power(a,2)*r*b*d*power(m,3)-power(a,2)*d*power(m,2)*p*power(b,2)-2*power(a,2)*m*power(p,3)*c+
   power(a,2)*power(d,2)*p*n*r+3*power(a,2)*m*power(p,2)*b*n+power(a,2)*d*p*c*n*b*m+power(a,2)*m*power(p,2)*b*c-power(a,2)*d*power(p,2)*
   b*n-power(a,2)*power(d,2)*p*b*power(n,2)-5*power(a,2)*power(d,2)*p*b*q-3*power(a,2)*d*power(p,2)*b*c+4*power(a,2)*c*q*b*d*n-2*
   power(a,2)*c*q*power(d,2)*power(n,2)+3*power(a,2)*power(c,2)*q*b*m-3*power(a,2)*m*p*power(b,2)*n+power(a,2)*power(d,2)*power(p,2)*c*n-power(a,2)*d*
   power(p,2)*power(c,2)*m+3*power(a,2)*power(d,3)*p*n*q+2*power(a,2)*b*p*c*power(n,2)-power(a,2)*b*p*power(c,2)*n+2*power(a,2)*power(m,2)*p*c*
   r+7*power(a,2)*power(d,2)*r*b*n-4*power(a,2)*power(d,2)*r*b*power(m,2)-7*power(a,2)*power(d,2)*r*c*p-3*power(a,2)*d*r*power(c,2)*n+2*
   power(a,2)*d*p*power(b,2)*n+6*power(a,2)*d*r*c*power(n,2)+3*power(a,2)*power(d,3)*r*m*p+5*power(a,2)*power(d,2)*r*n*c*m-2*power(a,2)*
   power(m,2)*q*power(c,2)*n+3*power(a,2)*power(m,3)*q*b*c+2*q*power(a,3)*d*m*n+4*q*power(a,2)*c*m*r+6*q*power(a,2)*d*n*r-
   8*q*power(a,2)*m*n*r+2*q*power(a,2)*c*power(n,2)*d*m+q*power(a,2)*d*p*c*power(m,2)+5*q*power(a,2)*d*power(m,2)*r+2*q*c*
   n*power(a,3)+5*q*d*p*power(a,3)-3*q*power(a,3)*d*power(m,3)-8*q*power(a,3)*m*p+4*q*power(a,3)*power(m,2)*n+2*q*power(a,2)*power(b,2)*
   n-q*power(a,3)*b*m+4*q*power(a,2)*power(c,2)*power(n,2)-11*q*power(a,2)*b*r+3*power(a,2)*d*power(p,3)*c+2*q*power(a,2)*b*c*p-5
   *q*power(m,2)*p*power(a,2)*b-8*q*power(d,2)*r*m*power(a,2)-power(a,2)*d*power(p,3)*n+power(a,2)*d*power(p,2)*r-4*power(a,2)*m*power(p,2)*r+power(a,2)*m*power(p,3)*power(d,2)-power(a,2)*b*p*power(n,3)-4*power(a,2)*c*q*power(b,2)-2*power(a,2)*power(c,3)*q*n+power(a,2)*power(m,3)*p*power(b,2)-3*power(a,2)*d*r*power(n,3)-3*power(a,2)*power(d,3)*r*power(n,2)-5*power(a,2)*d*r*power(b,2)+4*power(a,2)*r*p*power(n,2)-3*power(a,2)*power(d,3)*power(q,2)*m
   +4*power(a,2)*power(d,2)*power(q,2)*c-11*power(a,2)*d*m*power(r,2)-2*power(a,2)*power(c,2)*power(p,2)*n+3*power(d,3)*q*r*power(a,2)+power(a,2)*power(p,4)+
   2*power(a,2)*c*m*d*power(q,2)+5*d*r*c*power(a,3)-3*power(d,2)*r*m*power(a,3)+8*power(a,2)*power(c,2)*p*r+power(a,2)*c*power(p,2)*power(n,2)+
   power(a,2)*power(m,2)*power(p,2)*power(c,2)+5*power(a,2)*m*power(q,2)*b+2*power(m,3)*r*power(a,2)*power(c,2)-2*q*power(a,2)*c*power(n,3)+2*q*power(a,2)*c*
   power(p,2)-4*q*power(a,2)*n*power(p,2)+8*q*power(a,2)*p*r-q*power(a,2)*power(d,2)*power(p,2)+3*power(a,3)*d*p*power(m,2)*n+2*power(a,3)*d*p*
   c*power(m,2)+power(a,5)+2*a*power(p,2)*power(r,2)-3*power(a,3)*power(d,2)*p*m*n-power(a,3)*c*power(n,2)*d*m-d*p*power(a,3)*b*m+6*power(a,2)*
   m*p*b*r-power(a,2)*power(m,2)*p*c*n*b+power(a,2)*m*p*b*d*power(n,2)-power(a,2)*m*power(p,2)*c*n*d-8*q*power(a,2)*c*n*d*
   p+3*q*power(a,2)*d*p*power(n,2)+q*power(a,2)*d*power(p,2)*m+q*power(a,2)*power(n,2)*b*m-8*q*power(a,2)*c*n*b*m-q*power(a,2)*d*
   power(m,2)*n*b-3*q*power(a,2)*power(d,2)*p*m*n+4*q*power(a,2)*c*n*m*p+2*q*power(a,2)*p*b*n+4*power(a,3)*c*n*m*p+
   power(a,3)*c*n*d*p-5*power(a,3)*c*m*d*q-power(a,3)*c*n*b*m+power(a,3)*d*power(m,2)*n*b+power(a,4)*power(m,4)+2*power(a,4)*power(n,2)+
   power(a,3)*power(n,4)+a*power(q,4)-power(a,3)*power(m,3)*n*b+8*power(a,3)*m*n*r-power(a,3)*d*m*power(n,3)-3*power(a,3)*power(d,2)*n*q-4*power(a,3)*
   m*p*power(n,2)-2*power(a,3)*power(m,3)*p*c+3*power(a,3)*power(n,2)*b*m+power(a,3)*d*p*power(n,2)-5*power(a,3)*d*power(p,2)*m+3*power(a,3)*power(d,2)*power(m,2)*q-2*power(a,3)*power(c,2)*m*p-3*power(q,2)*power(a,2)*c*power(m,2)+2*power(q,2)*c*n*power(a,2)+3*power(a,4)*d*m*n+power(m,2)*p*
   power(a,3)*b+7*power(a,3)*d*power(m,2)*r+power(a,3)*c*power(n,2)*power(m,2)-2*power(a,3)*b*d*power(n,2)-5*power(a,3)*p*b*n+3*power(a,3)*b*c*
   p+4*power(a,3)*b*d*q-6*power(a,3)*c*m*r-7*power(a,3)*d*n*r-power(q,2)*d*p*power(a,2)+4*power(q,2)*power(a,2)*m*p+3*power(a,2)*
   power(d,2)*power(m,2)*power(q,2)-8*power(a,2)*b*d*power(q,2)+2*power(a,2)*power(d,2)*n*power(q,2)+6*power(q,2)*power(a,3)-4*power(a,2)*power(q,3)-4*q*power(a,4)+
   5*power(a,3)*b*r+a*power(d,2)*n*power(q,3)-4*a*power(q,2)*p*r-a*d*p*power(q,3)-a*power(d,3)*power(q,3)*m+10*q*d*p*power(a,2)*b
   *m-3*power(a,2)*power(d,2)*p*power(m,2)*r+7*power(a,2)*d*r*b*c*m+2*power(a,2)*power(d,2)*m*power(p,2)*b-3*a*power(r,2)*c*power(n,2)-2
   *a*power(d,3)*power(r,2)*p+5*a*c*r*power(b,3)+2*a*power(d,2)*power(q,2)*power(b,2)+5*a*power(d,2)*power(r,2)*power(c,2)-a*q*power(p,3)*b+5*a
   *d*power(r,3)+5*power(d,3)*power(r,3)*c-a*c*power(q,2)*power(d,3)*p+a*d*r*power(c,3)*q-4*a*power(d,3)*power(r,2)*c*m-3*a*d*r*b
   *power(c,2)*m*n-9*a*power(d,2)*power(r,2)*c*n-2*a*power(d,2)*r*m*c*power(p,2)+3*a*power(m,2)*r*b*power(c,2)*n+4*a*d*r*p
   *b*c*power(m,2)-4*a*power(m,3)*r*power(b,2)*c+4*a*c*power(q,2)*power(b,2)+8*a*power(r,2)*power(c,2)*n-3*a*n*power(q,2)*power(b,2)+a*power(q,2)*power(c,2)*power(n,2)+3*a*power(d,4)*power(r,2)*n-2*a*power(c,4)*r*p+a*power(b,2)*q*power(n,3)+a*power(r,2)*power(d,2)*q+7*a*power(q,2)*b
   *r-2*a*power(c,2)*r*p*b*m+2*a*c*r*power(d,3)*power(p,2)+13*a*power(d,2)*power(r,2)*b*m+a*power(c,2)*q*b*d*m*p+4*
   a*power(c,2)*r*m*power(p,2)-2*a*power(c,2)*r*p*power(d,2)*n-a*b*q*power(c,3)*p+a*b*q*power(d,3)*power(p,2)-a*power(c,2)*q*p*b*
   power(m,2)+5*a*power(d,3)*r*b*m*q+4*a*d*r*power(b,2)*c*power(m,2)-2*a*power(d,3)*n*power(q,2)*b-2*a*power(b,2)*q*power(d,2)*m*
   p+a*d*power(m,2)*q*power(b,3)+2*a*d*r*power(c,3)*m*p-2*a*power(b,2)*q*c*power(n,2)+3*a*power(b,2)*q*c*d*p-6*a*c*
   r*power(b,2)*d*n+3*a*c*r*b*power(d,2)*power(n,2)+6*a*c*r*b*power(p,2)-6*a*power(c,2)*r*d*power(p,2)+3*a*power(c,3)*r*b*
   n-5*a*m*power(q,2)*power(b,2)*d-8*a*m*q*power(b,2)*r-a*power(q,2)*c*n*d*p-4*a*power(d,2)*power(q,3)*c+3*a*power(r,2)*power(d,2)*power(n,2)-5*a*power(d,3)*power(r,2)*b-2*a*power(c,3)*power(q,2)*n-3*a*m*power(q,3)*b-7*a*p*b*power(r,2)-2*a*c*power(q,3)*n+
   4*a*q*n*power(r,2)-4*a*power(m,2)*power(r,2)*power(c,2)-a*power(m,3)*q*power(b,3)+a*power(m,2)*power(q,2)*power(c,3)+3*a*power(m,2)*power(q,2)*power(b,2)-
   9*a*c*r*p*power(b,2)+6*a*power(c,2)*r*b*d*p-4*a*power(d,2)*r*b*m*c*p-2*a*power(m,2)*r*power(c,3)*p+a*power(q,2)*
   c*power(p,2)-5*d*power(r,3)*power(c,2)+a*r*power(d,3)*power(q,2)-2*power(c,4)*power(r,2)*n+5*b*c*power(r,3)-3*b*n*power(r,3)-a*power(d,2)*q*
   r*power(c,2)*m+a*power(d,2)*power(q,2)*power(c,2)*n-2*a*power(c,2)*power(q,2)*p*m-a*c*q*power(b,3)*m+2*a*power(r,2)*d*n*c*m+2*
   a*power(d,2)*power(q,2)*m*b*n+3*a*m*q*power(b,3)*n+2*a*power(m,2)*q*b*c*r-2*a*d*power(q,2)*b*power(n,2)-a*m*q*power(b,2)*d*power(n,2)+a*power(m,2)*q*c*n*power(b,2)+3*a*power(d,2)*power(q,2)*b*c*m-a*power(d,2)*q*b*c*n*p-a*d*power(q,2)*power(c,3)*
   m-4*a*d*power(q,2)*power(c,2)*b-7*a*power(d,2)*q*r*c*b-a*d*q*c*n*power(b,2)*m+a*power(d,2)*q*power(b,2)*power(n,2)-3*a*
   power(d,4)*q*r*p-5*a*d*power(r,2)*c*b-10*a*r*p*b*d*q+2*a*r*c*n*d*power(p,2)+4*a*power(d,2)*power(r,2)*c*power(m,2)-3*a*power(d,3)*power(r,2)*m*n+3*a*d*power(r,2)*power(c,2)*m+5*a*r*b*c*n*d*p+a*r*d*q*power(c,2)*power(m,2)+3*a
   *r*power(c,2)*q*b+11*a*r*c*n*power(b,2)*m+2*a*power(r,2)*power(d,2)*m*p-5*a*p*d*n*power(r,2)-2*a*r*p*power(c,2)*
   power(n,2)+5*a*b*m*n*power(r,2)-8*a*b*d*power(m,2)*power(r,2)-2*a*b*c*m*power(r,2)+4*a*c*p*d*power(r,2)+2*a*r*power(c,2)*p*d*n*m-5*a*r*b*q*power(n,2)+4*a*r*power(c,3)*p*n+2*a*r*b*c*n*q-3*a*r*b*c*power(n,2)*d*m+
   3*a*r*b*c*power(n,3)-6*a*r*b*power(c,2)*power(n,2)+2*a*r*m*power(q,2)*c-a*q*d*m*power(r,2)+3*a*q*d*power(p,2)*r+
   a*q*d*p*c*n*b*m+2*a*q*m*power(p,2)*b*c-8*a*q*d*p*c*m*r-3*a*q*power(d,2)*p*n*r+a*q*d*
   p*power(b,2)*n-3*a*q*d*power(p,2)*b*c+a*q*d*power(p,2)*b*n+a*b*d*n*power(r,2)-8*a*r*p*c*n*b*m-2*a*
   d*q*power(b,3)*n-4*a*q*power(c,2)*p*r-3*a*q*m*p*power(b,2)*n-a*q*b*p*c*power(n,2)+13*a*q*d*r*power(b,2)+3
   *a*power(c,2)*p*d*power(q,2)+2*a*q*b*p*power(c,2)*n-a*q*power(d,2)*r*n*c*m+11*a*q*power(d,2)*r*c*p-2*a*q*
   d*r*power(c,2)*n+a*power(d,3)*r*c*q*n+a*q*d*r*c*power(n,2)+3*a*q*power(d,3)*r*m*p-5*a*q*power(d,2)*r*b*n-
   5*a*q*power(d,2)*r*b*power(m,2)-a*q*c*p*power(b,2)*m+4*a*q*c*p*n*r-a*q*power(d,2)*m*power(p,2)*b+2*a*q*d*
   power(m,2)*p*power(b,2)+10*a*q*r*b*d*m*n+4*a*c*power(q,2)*b*d*n-3*a*d*power(q,2)*b*c*power(m,2)-a*d*power(q,2)*power(c,2)*m*n+a*power(c,2)*power(q,2)*b*m+a*power(d,2)*p*b*power(q,2)+a*power(q,2)*c*n*b*m+a*power(d,2)*p*c*m*power(q,2)-a*m*p
   *b*d*power(q,2)-3*a*r*c*d*power(q,2)-a*r*power(d,2)*m*power(q,2)+2*a*q*m*p*b*r+a*power(q,2)*d*n*r+3*a*power(q,2)
   *p*b*n+3*a*c*m*d*power(q,3)+4*a*b*d*power(q,3)+2*power(d,4)*power(r,2)*b*p+4*d*power(r,3)*b*m+5*power(d,2)*power(r,2)*c
   *power(b,2)+2*d*r*power(b,4)*n-power(d,2)*r*power(b,3)*power(n,2)-2*r*d*q*c*power(a,2)+2*r*m*q*b*power(c,2)*p-r*b*q*c*power(p,2)+3*r*d*power(p,2)*power(b,2)*c+r*b*a*n*power(p,2)+r*b*d*p*power(q,2)-r*b*power(a,2)*power(m,2)*n+r*b*a*power(d,2)*p*m
   *n-r*b*a*d*p*power(n,2)-r*b*power(d,2)*p*c*m*q+r*b*q*c*n*d*p-3*r*b*power(c,2)*p*d*q-2*r*m*power(p,2)*power(b,2)*c-r*d*p*power(b,3)*n+r*a*d*power(m,2)*n*power(b,2)-r*a*power(n,2)*power(b,2)*m+2*r*power(m,2)*p*a*power(b,2)+r*power(d,2)*m*power(p,2)*power(b,2)+r*c*p*power(b,3)*m-r*d*p*c*n*power(b,2)*m-5*r*d*p*a*power(b,2)*m-3*r*q*p*power(b,2)*n
   +r*power(b,2)*p*c*power(n,2)-2*r*power(b,2)*p*power(c,2)*n+3*r*m*p*power(b,3)*n-r*d*power(p,2)*power(b,2)*n-r*power(d,2)*p*power(b,2)
   *q+r*m*p*power(b,2)*d*q-2*r*d*power(m,2)*p*power(b,3)+5*r*q*power(b,2)*c*p+r*a*p*power(b,2)*n-d*power(r,2)*power(c,3)*m
   *n-4*d*power(r,2)*b*power(c,2)*power(m,2)-d*power(r,2)*p*power(c,2)*n+power(r,2)*c*q*power(d,2)*n+power(d,2)*power(r,2)*p*power(c,2)*m-power(r,2)*p
   *c*d*q+power(r,2)*b*power(c,2)*m*n+2*power(r,2)*a*c*m*p+4*b*d*p*c*m*power(r,2)+2*b*power(d,2)*p*n*power(r,2)-b*q
   *d*n*power(r,2)-6*b*power(d,2)*power(r,2)*c*p+6*b*d*power(r,2)*power(c,2)*n-3*b*d*power(r,2)*c*power(n,2)+b*c*p*n*power(r,2)+7
   *b*power(r,2)*c*d*q+b*power(r,2)*power(d,2)*m*q+3*b*power(d,2)*power(r,2)*n*c*m-5*m*q*b*c*power(r,2)-power(d,5)*power(r,3)-7*d
   *power(r,2)*power(b,2)*c*m+3*power(d,2)*power(r,2)*power(b,2)*n+3*d*power(r,3)*c*n-4*power(d,2)*power(r,3)*c*m-2*b*d*power(p,2)*power(r,2)+3
   *b*q*p*power(r,2)-3*b*power(c,2)*p*power(r,2)-power(d,3)*q*power(r,2)*b+7*power(r,2)*power(b,2)*p*d-2*power(r,2)*q*power(c,2)*n+3*d*power(r,2)*power(c,3)*p+power(c,3)*power(r,2)*b*m-2*r*a*power(b,3)*n+r*b*power(a,2)*power(n,2)+r*power(a,2)*power(b,2)*m+2*power(c,3)*power(r,2)*q+power(m,2)*r*a*power(b,3)-3*m*r*power(b,4)*n+2*power(d,2)*power(r,2)*power(b,2)*power(m,2)-3*m*p*power(b,2)*power(r,2)-5*power(r,2)*power(b,2)*d*m*n
   +c*power(r,2)*power(q,2)+4*power(m,2)*power(r,2)*power(b,2)*c+c*r*power(b,4)*m-7*c*power(r,2)*power(b,2)*n+3*power(n,2)*power(r,2)*power(b,2)+d*r*power(n,2)*power(b,3)*m+power(d,2)*r*power(b,2)*c*n*p+d*r*c*n*power(b,3)*m-4*d*r*power(b,2)*c*n*q-2*power(d,2)*r*m*q*power(b,2)
   *n+2*d*r*power(b,2)*q*power(n,2)+power(m,2)*power(r,2)*power(c,4)-d*r*a*power(b,3)*m+d*r*b*m*q*power(c,2)*n-2*power(d,3)*power(r,2)*b
   *m*p-power(d,2)*r*b*q*power(c,2)*n+3*d*power(r,2)*q*m*power(c,2)-power(d,3)*r*b*n*p*a+4*power(d,2)*power(r,2)*b*power(c,2)*m+2
   *d*r*power(a,2)*c*m*p-power(d,3)*power(r,2)*q*c*m-power(d,2)*r*b*power(q,2)*n-power(d,2)*r*power(b,2)*a*m*n-3*power(d,3)*power(r,2)*c
   *b*n+2*power(d,3)*r*n*q*power(b,2)-d*power(r,2)*power(c,4)*m-5*d*power(r,2)*power(c,3)*b+power(d,2)*power(r,2)*power(c,3)*n-power(c,3)*r*b*q
   *power(m,2)+power(c,3)*r*b*q*d*m+power(c,2)*r*p*power(b,2)*power(m,2)+3*c*r*power(b,2)*d*power(m,2)*q-power(c,2)*r*power(b,2)*m*q-power(c,2)
   *r*power(b,2)*d*m*p-3*c*r*power(b,2)*power(d,2)*m*q-d*power(r,3)*q+power(m,3)*r*power(b,4)-m*r*power(b,2)*c*n*q-power(m,2)*r*c
   *n*power(b,3)+a*power(b,4)*q-5*a*power(q,2)*b*c*p-3*c*r*b*d*m*power(q,2)-5*d*power(r,2)*power(b,3)-2*c*power(r,3)*p-4*power(c,2)*power(r,2)*q*power(d,2)-power(d,3)*power(r,3)*n+power(c,5)*power(r,2)+2*a*power(c,2)*power(q,3)+c*power(r,2)*power(d,4)*q-power(c,2)*power(r,2)*power(d,3)*p-2
   *power(c,3)*power(r,2)*m*p-d*power(m,2)*r*power(b,4)-2*power(d,3)*m*power(r,2)*power(b,2)-5*a*power(c,3)*power(r,2)-3*q*power(b,2)*power(r,2)+a*power(b,2)
   *q*power(c,2)*n+b*r*c*q*power(d,3)*p+2*b*r*c*power(q,2)*n+power(b,2)*r*power(c,3)*p-4*power(b,2)*r*d*power(q,2)+5*power(b,3)*r
   *d*m*q-3*power(b,3)*r*c*d*p+2*power(b,3)*r*power(d,2)*m*p+3*power(b,2)*r*a*power(d,2)*p+4*power(b,2)*r*d*q*power(c,2)-2
   *power(b,3)*r*power(d,2)*q+3*power(b,3)*r*n*q-3*power(b,3)*r*power(m,2)*q-power(b,3)*r*power(c,2)*n-b*r*power(c,4)*q-b*r*power(d,4)*power(q,2)-power(b,5)*r-4*a*power(c,2)*r*power(b,2)*m-4*a*m*power(r,3)+power(c,2)*power(r,2)*power(p,2)+2*b*r*power(c,3)*q*n-b*r*q*power(c,2)
   *power(n,2)+3*r*power(b,4)*p-2*b*r*power(c,2)*power(q,2)-4*power(b,3)*r*c*q-power(b,2)*r*power(d,3)*power(p,2)+b*r*power(d,3)*power(q,2)*m+4
   *b*r*power(d,2)*power(q,2)*c+3*power(b,2)*r*m*power(q,2)+2*power(b,3)*r*c*power(n,2)+5*power(c,2)*power(r,2)*power(b,2)-4*m*r*power(a,2)*power(c,2)
   *n+2*power(q,2)*power(a,2)*power(n,2)-4*power(a,2)*n*power(r,2)-power(a,2)*power(d,3)*power(p,3)+5*power(a,2)*c*power(r,2)-4*q*power(a,3)*power(n,2)-4*power(c,2)
   *power(q,2)*power(a,2)+5*power(d,2)*power(r,2)*power(a,2)-3*power(a,2)*power(p,3)*b+3*power(a,2)*power(p,2)*power(b,2)+6*power(a,2)*power(m,2)*power(r,2)+4*power(a,3)*n
   *power(p,2)-4*power(a,3)*p*r+power(a,3)*power(d,2)*power(n,3)+3*power(a,3)*power(d,2)*power(p,2)+power(a,3)*power(c,2)*power(n,2)+power(a,4)*c*power(m,2)-power(a,4)*b*m
   -2*c*n*power(a,4)-3*d*p*power(a,4)-power(a,4)*d*power(m,3)+4*power(a,4)*m*p-4*power(a,4)*power(m,2)*n+power(a,3)*power(b,2)*n-2*power(a,3)*c
   *power(n,3)-4*power(a,3)*power(m,3)*r-3*power(a,3)*c*power(p,2)+power(a,2)*power(c,3)*power(p,2)+2*power(c,2)*q*power(a,3)+2*power(a,3)*power(m,2)*power(p,2)-power(a,2)
   *power(b,3)*p+power(r,4)-5*power(q,2)*power(a,2)*d*m*n+2*m*r*power(a,2)*c*power(n,2)+3*a*q*power(p,2)*power(b,2)-6*a*q*c*power(r,2)-3
   *a*q*power(b,3)*p-2*a*c*r*power(p,3)+a*power(c,4)*power(q,2)-b*r*power(q,3)-5*power(d,2)*power(r,3)*b)

   return d, c, b, a, A, B

mp.dps = 500
print("Example 1")
eq_solve(1, 0, 0, 0, 15, 12)

print("Example 2")
eq_solve(1, 0, 0, 0, -5, 12)

print("Example 3")
eq_solve(1, 0, -110, -55, 2310, 979)

eq_solve_tangent(1)

eq_solve_tangent(mp.tan(60 * mp.pi()/180))

# Release 0.1 from 2021/Jan/18
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# out of charity, there is no salvation at all.
# with charity, there is evolution.
