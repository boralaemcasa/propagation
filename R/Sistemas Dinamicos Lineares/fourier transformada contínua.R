rm(list = ls())
gc()

source("V:\\sem backup\\_4 anal sist dinamicos lineares\\lista 1\\util.R")

########### TRANSFORMADA DE FOURIER CONTÍNUA

X(jw) = integrate x(t) exp(-i w t) dt from -infty to infty

xhat(t) = 1/2/pi * integrate X(jw) exp(jw t) dw from -infty to infty

integrate abs(x(t) - xhat(t))^2 dt from -infty to infty = 0
somente se
integrate abs(x(t))^2 dt < infty

sinais periódicos: w = delta(w - k * omega0)

X(jw) = sum k = -infty to infty, a(k) * 2 pi delta(w - k * omega0)

x(t) = sum k = -infty to infty, a(k) exp(j   k * omega0 * t)

a(k) = 1/T0 * integrate x(t) exp(-j k*omega0*t) dt from 0 to T0

#############

Linearidade

1) z(t) = A x(t) + B y(t)
   Z(jw) = A X(jw) + B Y(jw)

Deslocamento no tempo

2) y(t) = x(t - t0)
   Y(jw) = exp(- j   w * t0) X(jw)

Deslocamento na frequência

3) y(t) = exp(j*omega0*t) x(t)
   Y(jw) = X(j (w - omega0))

Conjugação

4) y(t) = conjugate(x(t))
   Y(jw) = conjugate(X(-jw))

Reflexão no tempo

5) y(t) = x(-t)
   Y(jw) = X(-jw)

Escalonamento

6) y(t) = x(a   t)
   Y(jw) = 1/abs(a) X(jw/a)

Convolução

7) z(t) = x(t) ** y(t) = integral x(tau) y(t - tau) dtau from -infty to infty
   Z(jw) = X(jw) Y(jw)

Multiplicação / Modulação

8) z(t) = x(t) y(t)
   Z(jw) = 1/2/pi X(jw) ** Y(jw) = 1/2/pi * integral xx(tau) yy(w - tau) dtau from -infty to infty

Diferenciação no tempo

9) y(t) = x'(t)
   Y(jw) = jw * X(jw)

Diferenciação na frequência

10) y(t) = t^m * x(t)
    Y(jw) = j^m d^m\dw^m X(jw)

Integração

11) y(t) = integrate x(t) dt from -infty to t
    Y(jw) = 1/j/w * X(jw) + pi * X(0) * delta(w)

Sinais reais e pares

12) x(t) real e par
    X(jw) real e par

Sinais reais e ímpares

13) x(t) real e ímpar
    X(jw) puramente imaginário e ímpar

Relações de Parseval

14) integrate abs(x(t))^2 dt from -infty to infty = 1/2/pi * integrate abs(X(jw))^2 dw from -infty to infty

Dualidade

15) Dados x(t) e X(jw) = F(x(t));
    y(t) = X(jt)
    Y(jw) = 2 pi x(-w)

#############

X(jw) = delta(w - omega0)
x(t) = 1/2/pi exp(j*omega0*t)

#############

x(t) = exp(-at) u(t)
X(jw) = 1/(a + jw)
a >= 0

#############

X(jw) = 1, se abs(w) <= A
X(jw) = 0, se abs(w) > A
x(t) = 1/pi/t   sin(A t)
x(0) = A/pi

#############

x(t) = cos(at) = sum k = -infty to infty, a(k) exp(i   k   t) = 1/2 exp(i a t) + 1/2 exp (-i a t)
X(jw) = 1/2 * 2 pi delta(w + 1 a) + 1/2 * 2 pi delta(w - 1 a)

#############

x(t) = sin(at) = sum k = -infty to infty, a(k) exp(i   k   t) = -i/2 * exp(iat) + i/2 * exp(-iat)
X(jw) = sum k = -infty to infty, a(k) * 2 pi delta(w - k * omega0)
k = -a, a(k) = +i/2
k = +a, a(k) = -i/2
X(jw) = i/2 * 2 pi delta(w + 1 a) - i/2 * 2 pi delta(w - 1 a)

#############

x(t) = u(t)
X(jw) = 1/j/w + pi delta(w)

Pela reflexão no tempo,
y(t) = x(-t) = u(-t)
Y(jw) = X(-jw) = -1/j/w + pi delta(w)

Pela dualidade,
Y(jt) = -1/j/t + pi delta(t)
2 pi y(-w) = 2 pi u(w)

Dividindo por 2 pi,
Z(jw) = u(w)
z(t) = -1/2/pi/j/t + 1/2 delta(t)

#############

1) x(t) = exp(-at) u(t) # módulo de t
   X(jw) = 1/(a + jw)

   Pela reflexão no tempo,
   y(t) = x(-t) = exp(at) u(-t)
   Y(jw) = X(-jw) = 1/(a - jw)

   Pela linearidade,
   z(t) = x(t) + y(t)
   Z(jw) = X(jw) + Y(jw) = 1/(a + jw) + 1/(a - jw) = (2 a)/(a^2 + w^2)

#############

2) X(jw) = exp(-aw) u(w) + exp(aw) u(-w)

   Pela reflexão no tempo,
   y(t) = x(-t)
   Y(jw) = X(-jw) = X(jw)

   Pela dualidade,
   z(t) = Y(jt) = X(jt) = exp(-at) u(t) + exp(at) u(-t) => Z(jw) = (2 a)/(a^2 + w^2)
   Z(jw) = 2 pi y(-w) = (2 a)/(a^2 + w^2)
                 x(w) = a/pi/(a^2 + w^2)
                 x(t) = a/pi/(a^2 + t^2)

#############

3) x(t) = u(t + 2) - 2 u(t) + u(t - 2)

   y(t) = u(t)
   Y(jw) = 1/j/w + pi delta(w)

   Pelo deslocamento no tempo,
   z(t) = y(t - t0) = u(t - t0)
   Z(jw) = exp(- j   w * t0) Y(jw) = exp(- j   w   t0) (1/j/w + pi delta(w))

   Pela linearidade,
   x(t) = z_-2(t) - 2 y(t) + z_2(t)
   X(jw) = exp(+2 j   w) (1/j/w + pi delta(w)) - 2 (1/j/w + pi delta(w)) + exp(-2 j   w) (1/j/w + pi delta(w))
         = (4 i sin^2(w))/w = 2i/w (1 - cos(2w))

#############

4) x(t) = 8 exp(- 0.2 t) u(t)
   x(t) = 8 exp(-at) u(t), a = 0.2
   X(jw) = 8/(a + jw)

######## teste 12

1) x(t)
   X(jw)

   Y(jw) = A sin(B w) X(jw)
   result = y(t)

   Pela convolução,
   y(t) = x(t) ** z(t)
   Y(jw) = X(jw) Z(jw)

   Z(jw) = A sin(B w)

   Pela reflexão no tempo,
   s(t) = z(-t)
   S(jw) = Z(-jw) = - A sin(B w)

   Pela dualidade,
   p(t) = S(jt) = - A sin(B t)
   P(jw) = 2 pi s(-w) = - A i pi delta(w + B) + A i pi delta(w - B)
   z(t) = - A/2 i delta(t + B) + A/2 i delta(t - B)

   y(t) = integral x(t - tau) (- A/2 i delta(tau + B) + A/2 i delta(tau - B)) dtau from - infty to infty
        = -A/2 i x(t + B) + A/2 i x(t - B)
        = -A/2 i [x(t + B) - x(t - B)]
   
2) Y(jw) = A cos(B w) X(jw)
   result = y(t)

   Z(jw) = A cos(B w)

   Pela reflexão no tempo,
   s(t) = z(-t)
   S(jw) = Z(-jw) = Z(jw)

   Pela dualidade,
   p(t) = S(jt) = A cos(B t)
   P(jw) = 2 pi s(-w) = A pi delta(w + B) + A pi delta(w - B)
   z(t) = A/2 delta(t + B) + A/2 delta(t - B)
   
   y(t) = integral x(t - tau) (A/2 delta(tau + B) + A/2 delta(tau - B)) dtau from -infty to infty
        = A/2 x(t + B) + A/2 x(t - B)
      
3) x(t) = 1, de 1 a 2
   x(t) = 7, de 2 a 7
   x(t) = 1, de 7 a 8
   x(t) = 0, caso contrário
   result = X(jw) = integrate 1   exp(-i w t) dt from 1 to 2
                  + integrate 7   exp(-i w t) dt from 2 to 7
                  + integrate 1   exp(-i w t) dt from 7 to 8
   X(jw) = -i e^(-2 i w) (-1 + e^(i w))/w - 7 i e^(-7 i w) (-1 + e^(5 i w))/w - i e^(-8 i w) (-1 + e^(i w))/w
         = 2 e^(-9 i w/2) (6 sin(5 w/2) + sin(7 w/2))/w
         = e^(-9 i w/2) (30 sinc(5 w/2) + 7 sinc(7 w/2))
 
######## teste 13

1) h(t) = A exp(-B t) u(t)
   x(t) = C exp(-D t) u(t)
   result = y(t) = h(t) ** x(t)

   Pela convolução,
   Y(jw) = X(jw) H(jw) = A/(B + iw) * C/(D + iw) = E /(iw + B) + F/(iw + D)
   E + F = 0 => F = - E
   AC = B F + D E => AC/(D - B) = E
    
   Y(jw) = AC/(D - B) /(iw + B) - AC/(D - B)/(iw + D)
   y(t) = AC/(D - B) exp(-Bt) u(t) - AC/(D - B) exp(-Dt) u(t)

2) h(t) = A exp(-B t) u(t)
   x(t) = C exp(-B t) u(t)
   result = y(t) = h(t) ** x(t)

   y(t) = t exp(-t) u(t)
   Y(jw) = 1/(1 + i w)^2

   Pelo escalonamento,
   z(t) = y(at) = at exp(-at) u(at)
   Z(jw) = 1/abs(a) * Y(jw/a) = 1/abs(a)/(1 + i w/a)^2 = a^2/abs(a)/(a + i w)^2

   S(jw) = 1/(a + iw)^2
   s(t) = sgn(a) t exp(-at) u(t)
   
   Pela convolução,
   Y(jw) = X(jw) H(jw) = AC/(B + iw)^2
   y(t) = sgn(B) AC t exp(-Bt) u(t)

3) h(t) = t^2 exp(A t) u(-t)
   X(jw) = 1/(B + jw)
   y(t) = h(t) ** x(t)
   result = Y(j0)

   Pela reflexão no tempo,
   z(t) = h(-t) = t^2 exp(-A t) u(t) = = integrate t^2 exp(-A t) exp(-i w t) dt from 0 to infty
   Z(jw) = H(-jw) = 2/(A + i w)^3

   Pela convolução,
   Y(jw) = H(jw) X(jw)
   Y(j0) = 2/A^3 * 1/B
  
4) H(jw) = 1/(2 + jw)
   x(t) = exp(-2t) u(t)
   result = y(t) = h(t) ** x(t)

   h(t) = x(t)
   y(t) = sgn(B) AC t exp(-Bt) u(t), A = C = 1, B = 2
   
5) |X(jw)| = de 2/3 a 1, para w de -5 a 5
   |X(jw)| = 0, caso contrário
   T0 = 10/3
   da forma f(w) = - cos(omega0 * t) + b

   |H(jw)| = 2, de -2 a 2
   |H(jw)| = 0, caso contrário
   y(t) = x(t) ** h(t)
   result = |Y(jw)|
   
   |X(jw)| = 5/6 - 1/6 cos(2 pi * 3/10 * (t + 5)) 

   Pela convolução,
   Y(jw) = H(jw) X(jw)
   |Y(jw)| = 2 |X(jw)|, de -2 a 2, zero caso contrário

############# lista 2

2b) x(t) = t exp(-abs(t)) = t exp(-t) u(t) + t exp(t) u(-t)

    y(t) = t exp(-t) u(t)
    Y(jw) = 1/(1 + i w)^2

    Pela reflexão no tempo,
    z(t) = y(-t) = -t exp(t) u(-t)
    Z(jw) = Y(-jw) = 1/(1 - i w)^2

    x(t) = y(t) - z(t)
    X(jw) = Y(jw) - Z(jw) = 1/(1 + i w)^2 - 1/(1 - i w)^2 = -4 i w/(w^2 + 1)^2

2c) x(t) = t^2 exp(-abs(t)) = t^2 exp(-t) u(t) + t^2 exp(t) u(-t)

    y(t) = t^2 exp(-t) u(t)
    Y(jw) = 2/(1 + i w)^3

    Pela reflexão no tempo,
    z(t) = y(-t) = t^2 exp(t) u(-t)
    Z(jw) = Y(-jw) = 2/(1 - i w)^3

    x(t) = y(t) + z(t)
    X(jw) = Y(jw) + Z(jw) = 2/(1 + i w)^3 + 2/(1 - i w)^3 = (4 - 12 w^2)/(w^2 + 1)^3

2d) x(t) = 1/(it)

    u(t) = exp(-0t) u(t)
    U(jw) = 1/(0 + jw) = 1/(jw)

    Pela dualidade,
    x(t) = U(jt)
    X(jw) = 2 pi u(-w)

2e) x(t) = -(t + 1) g(t + 0.5, 1) + (1 - t) g(t - 0.5, 1)

    g(at - t0, T) = u(at - t0 + T/2) - u(at - t0 - T/2)

    g(-t, 2) = u(-t + 1) - u(-t - 1)
                 1 >= t     -1 >= t

    h(t) = p(t) g(at - t0, T)
    H(jw) = sgn(a) integrate p(t) exp(-i w t) dt from (t0-T/2)/a to (t0+T/2)/a

    X(jw) = integrate (-t - 1) exp(-i w t) dt from (-0.5-1/2) to (-0.5+1/2)
          + integrate (1 - t) exp(-i w t) dt from (0.5-1/2) to (0.5+1/2)

    X(jw) = (-i w + e^(i w) - 1)/w^2 + (-i w - e^(-i w) + 1)/w^2
          = 2 i (sin(w) - w)/w^2

2f) x(t) = t exp(-abs(t)) sin(2t)

    y(t) = t exp(-abs(t))
    Y(jw) = -4 i w/(w^2 + 1)^2

    z(t) = sin(2t)
    Z(jw) = i   pi delta(w + 2) - i   pi delta(w - 2)

    Pela multiplicação,
    x(t) = z(t) y(t)
    X(jw) = 1/2/pi Z(jw) ** Y(jw) = 8 (-3 w^4 + 6 w^2 + 25)/(w^4 - 6 w^2 + 25)^2

2g) x(t) = 4t/(1 + t^2)^2

    y(t) = - i t exp(-abs(t))
    Y(jw) = 4 w/(1 + w^2)^2

    Pela dualidade,
    x(t) = Y(jt)
    X(jw) = 2 pi y(-w) = 2 pi i w exp(-abs(w))

3) x(t) = (u(t+2) - u(t + 1)) (t + 2) + (u(t+1) - u(t - 1)) (-t) + (u(t-1) - u(t - 2)) (t - 2)
   X(jw) = integrate (t + 2) exp(-i w t) dt from -2 to -1
         + integrate (-t) exp(-i w t) dt from -1 to 1
         + integrate (t - 2) exp(-i w t) dt from 1 to 2
   X(jw) = e^(i w) (i w - e^(i w) + 1)/w^2
         + 2 i (sin(w) - w cos(w))/w^2
         + e^(-2 i w) (1 + i e^(i w) (w + i))/w^2
   X(jw) = -4 i sin(w) (cos(w) - 1)/w^2

5a) X(jw) = i   (u(w) - u(w + 1) + u(w) - u(w - 1))

    Pela reflexão,
    z(t) = x(-t)
    Z(jw) = X(-jw) = i   (u(-w) - u(-w + 1) + u(-w) - u(-w - 1))

    Pela dualidade,
    y(t) = Z(jt) = i   (u(-t) - u(-t + 1) + u(-t) - u(-t - 1))
                       t <= 0    t <= 1    t <= 0    t <= -1
    Y(jw) = 2 pi z(-w) = integrate (+i) exp(-i w t) dt from -1 to 0
                       + integrate (-i) exp(-i w t) dt from 0 to 1
    2 pi z(-w) = (-1 + e^(i w))/w + (-1 + e^(-i w))/w
               = (2 (cos(w) - 1))/w
    z(-w) = 1/pi/w   (cos(w) - 1)
     x(t) = 1/pi/t   (cos(t) - 1)

5b) X(jw) = -(w + 1) g(w + 0.5, 1) + (1 - w) g(w - 0.5, 1)

    Pela reflexão,
    z(t) = x(-t)
    Z(jw) = X(-jw) = (w - 1) g(-w + 0.5, 1) + (1 + w) g(-w - 0.5, 1)

    Pela dualidade,
    y(t) = Z(jt) = (t - 1) g(-t + 0.5, 1) + (1 + t) g(-t - 0.5, 1)
    Y(jw) = 2 pi z(-w) = - integrate (t - 1) exp(-i w t) dt from (+0.5+1/2) to (0.5-1/2)
                         - integrate (1 + t) exp(-i w t) dt from (-0.5+1/2) to (-0.5-1/2)
    - 2 pi x(w) = (-i w - e^(-i w) + 1)/w^2 + (-i w + e^(i w) - 1)/w^2 = 2 i (sin(w) - w)/w^2
    x(t) = i/pi (t - sin(t))/t^2

5c) X(jw) = w   g(w - 0.5, 1) + (2 - w) g(w - 2, 2) + (w - 4) g(w - 3.5, 1)

    Pela reflexão,
    z(t) = x(-t)
    Z(jw) = X(-jw) = -w   g(-w - 0.5, 1) + (2 + w) g(-w - 2, 2) + (-w - 4) g(-w - 3.5, 1)

    Pela dualidade,
    y(t) = Z(jt) = -t   g(-t - 0.5, 1) + (2 + t) g(-t - 2, 2) + (-t - 4) g(-t - 3.5, 1)
    Y(jw) = 2 pi z(-w) = - integrate (-t) exp(-i w t) dt from (-0.5+1/2) to (-0.5-1/2)
                         - integrate (2 + t) exp(-i w t) dt from (-2+2/2) to (-2-2/2)
                         - integrate (-t - 4) exp(-i w t) dt from (-3.5+1/2) to (-3.5-1/2)
    - 2 pi x(w) = (1 + e^(i w) (-1 + i w))/w^2 - (2 i e^(2 i w) (w cos(w) - sin(w)))/w^2
                + (e^((3 i) w) (1 + i w) - e^((4 i) w))/w^2
    x(t) = (-1 + e^(i t))^3 (1 + e^(i t))/t^2/2/pi
         = 8 sin^2(t/2) sin^2(t) cos(t)/(pi t^2) - 8 i sin^3(t/2) cos(t/2) cos(2 t)/(pi t^2)

5d) X(jw) = 2 pi exp(-abs(w)) g(w, 2)

    Pela reflexão,
    z(t) = x(-t)
    Z(jw) = X(-jw) = 2 pi exp(-abs(w)) g(-w, 2)
                   = 2 pi exp(-w) g(-w, 2) u(w) + 2 pi exp(w) g(-w, 2) u(-w)

    Pela dualidade,
    y(t) = Z(jt) = 2 pi exp(-t) (u(-t + 1) - u(-t - 1)) u(t) + 2 pi exp(t) (u(-t + 1) - u(-t - 1)) u(-t)
                                     -1 <= t <= 1       0 <= t                   -1 <= t <= 1          t <= 0

    Y(jw) = 2 pi z(-w) = integrate 2 pi exp(-t) exp(-i w t) dt from 0 to 1
                       + integrate 2 pi exp(t) exp(-i w t) dt from -1 to 0
    x(t) = (i - i e^(-1 - i w))/(-w + i) + (e - e^(i w))/(e - i e w)
         = (2 w sin(w) - 2 cos(w) + 2 e)/(e w^2 + e)

5e) X(jw) = 2 pi delta(w - a)

    X(jw) = sum k = -infty to infty, a(k) * 2 pi delta(w - k * omega0)
    omega0 = a, k = 1, a(1) = 1
    x(t) = sum k = -infty to infty, a(k) exp(j   k * omega0 * t)
         = 1 exp(j * 1   a   t) = e^(iat)

5f) X(jw) = - i w/( (iw)^2 + 3iw + 2 ) = 1/(iw + 1) - 2/(iw + 2)

    y(t) = exp(-t) u(t)
    Y(jw) = 1/(1 + jw)

    z(t) = exp(-2t) u(t)
    Z(jw) = 1/(2 + jw)

    X(jw) = Y(jw) - 2 Z(jw)
    x(t) = y(t) - 2 z(t) = exp(-t) u(t) - 2 exp(-2t) u(t)

5g) X(jw) = pi (delta(w + a) + delta(w - a))

    X(jw) = sum k = -infty to infty, a(k) * 2 pi delta(w - k * omega0)
    omega0 = a, k = -1, a(-1) = 1/2
               k = 1,   a(1) = 1/2
    x(t) = sum k = -infty to infty, a(k) exp(j   k * omega0 * t)
         = 1/2 exp(-iat) + 1/2 exp(iat) = cos(at)

6) y(t) = Phi(x(t)) = x(t) ** h(t)
   h(t) = Phi(delta(t)) = 2 exp(-2t) u(t)
   x(t) = 3 exp(-t) u(t)

   Pela convolução,
   Y(jw) = X(jw) H(jw) = 3/(1 + jw) * 2/(2 + jw) = -6 /(iw + 2) + 6/(iw + 1)
   y(t) = -6 exp(-2t) u(t) + 6 exp(-t) u(t)

9a) result = y(0)
    y(t) = x(t) ** x(-t) = integrate x(t - tau) x(-tau) dtau from -infty to infty
    x(t) real => abs(x)^2 = x^2
    integrate abs(X(jw))^2 dw from -infty to infty = 1
    y(0) = integrate x(-t)^2 dt from -infty to infty, t' = -t, dt' = - dt
         = - integrate x(t)^2 dt from -infty to infty

    Pelas relações de Parseval,
    integrate abs(x(t))^2 dt from -infty to infty = 1/2/pi * 1 = - y(0)
    y(0) = -1/2/pi

9a) result = y(0)
    y(t) = x(t) ** x(-t)
    X(jw) = g(w, pi) = u(w + pi/2) - u(w - pi/2) é real e par.
    x(t) é real e par.
    y(0) = - integrate x(t)^2 dt from -infty to infty

    Pelas relações de Parseval,
    - y(0) = 1/2/pi * integrate (u(w + pi/2) - u(w - pi/2))^2 dw from -infty to infty
    y(0) = -1/2/pi * integrate dw from -pi/2 to pi/2 = -1/2

10a) y(t) = x(t) ** z(t)
     x(t) = 1/(pi t)
     z(t) = sinc(t) = sin(pi t)/pi/t
     sin(pi x) = pi x sinc(x)
     sin(x) = x sinc(x/pi)

     x(t) = 1/(it) * i/pi
     X(jw) = 2 pi u(-w) * i/pi = 2 i u(-w)

     z(t) = 1/pi/t   sin(A t)
     Z(jw) = 1, se abs(w) <= A = pi
     Z(jw) = 0, se abs(w) > A
     Z(jw) = u(w + pi) - u(w - pi)

     Pela convolução,
     Y(jw) = X(jw) Z(jw) = 2 i u(-w) (u(w + pi) - u(w - pi))
     Y(jw) = 2 i (u(w + pi) - u(w))

     S(jw) = u(w)
     s(t) = -1/2/pi/j/t + 1/2 * delta(t)

     Pelo deslocamento na frequência,
     V(t) = exp(-j pi t) s(t) = -1/2/pi/j/t exp(-j pi t) + 1/2 delta(t) exp(-j pi t)
     V(jw) = S(j (w + pi)) = u(w + pi)

     y(t) = 2 i v(t) - 2 i s(t)
         = -1/pi/t exp(-i pi t) + 1/2 delta(t) exp(-i pi t) + 1/pi/t - i delta(t)
         = (1/2 - i) delta(t) + (1 - e^(-i pi t))/(pi t)

10b) result = integrate abs(y(t))^2 dt from -infty to infty = R

     Pelas relações de Parseval,
     R = 1/2/pi * integrate abs(Y(jw))^2 dw from -infty to infty
       = 1/2/pi * integrate 4 abs(u(w + pi) - u(w))^2 dw from -pi to 0 = 2

11) result = x(t) é real e não negativo;

    y(t) = A exp(-2t) u(t)
    Y(jw) = (1 + jw) X(jw) = A/(2 + jw)
    X(jw) = -A/(iw + 2) + A/(iw + 1)
    integrate abs(X(jw))^2 dw from -infty to infty = 2 pi
    A^2 integrate 1/(w^4 + 5 w^2 + 4) dw from -infty to infty = 2 pi
    integrate: 1/(3 (w^2 + 1)) - 1/(3 (w^2 + 4))
    A^2 = 12

    Pela reflexão no tempo,
    S(t) = x(-t)
    S(jw) = X(-jw) = A/(iw - 2) - A/(iw - 1)

    Pela dualidade,
    z(t) = S(jt) = A/(it - 2) - A/(it - 1)
    Z(jw) = 2 pi s(-w) = A exp(2w) u(w) - A exp(w) u(w)
    x(t) = A/2/pi exp(2t) u(t) - A/2/pi exp(t) u(t)
    x(t) = sqrt(3)/pi exp(2t) u(t) - sqrt(3)/pi exp(t) u(t)

12) h(t) = Phi(delta(t))
    H(jw) = exp(-jw)/(w^2 + 1)

    c) result = h(t)

       Pela reflexão no tempo,
       y(t) = h(-t)
       Y(jw) = H(-jw) = exp(iw)/(w^2 + 1)

       Pela dualidade,
       z(t) = Y(jt) = exp(it)/(t^2 + 1) = p(t) q(t)
       Z(jw) = 2 pi y(-t)

       p(t) = exp(j*1 t)
       P(jw) = 2 pi delta(w - 1)

       q(t) = 1/pi/(1^2 + t^2) pi
       Q(jw) = pi exp(-1w) u(w) + pi exp(1w) u(-w)

       Pela multiplicação,
       z(t) = p(t) q(t)
       Z(jw) = 1/2/pi P(jw) ** Q(jw) = pi delta(w - 1) ** (exp(-w) u(w) + exp(w) u(-w))
       Z(jw) = pi e^(w - 1) u(1 - w) + pi e^(1 - w) u(w - 1) = 2 pi h(w)
       h(t) = 1/2 e^(t - 1) u(1 - t) + 1/2 e^(1 - t) u(t - 1)

    a) result = integrate h(t) dt from -infty to infty = R
              = integrate 1/2 e^(t - 1) dt from -infty to 1
              + integrate 1/2 e^(1 - t) dt from 1 to infty
       R = 1/2 + 1/2 = 1

    b) result = integrate t h(t) dt from -infty to infty = R
              = integrate 1/2 t e^(t - 1) dt from -infty to 1
              + integrate 1/2 t e^(1 - t) dt from 1 to infty
       R = 0 + 1 = 1

13a) result = integrate sinc(t) dt from -infty to infty = R

     x(t) = sinc(t)
     X(jw) = integrate x(t) exp(-i w t) dt from -infty to infty = u(w + pi) - u(w - pi)
     R = X(j0) = u(pi) - u(- pi) = 1 - 0 = 1

13b) result = integrate sinc^2(t) dt from -infty to infty = R

     x(t) = sinc(t), real e par
     X(jw) = u(w + pi) - u(w - pi)

     Pelas Relações de Parseval,
     R = 1/2/pi * integrate abs(X(jw))^2 dw from -infty to infty
       = 1/2/pi * integrate dw from -pi to pi = 1

13c) result = integrate sinc^3(t) dt from -infty to infty = R

     x(t) = sinc(t)
     y(t) = sinc^2(t) = x(t) x(t)
     z(t) = sinc^3(t) = x(t) y(t)
     Z(jw) = integrate z(t) exp(-i w t) dt from -infty to infty
     R = Z(j0)

     Y(jw) = 1/2/pi * X(jw) ** X(jw) = 1/2/pi * [(2 pi + w) (u(w + 2 pi) - u(w)) + (2 pi - w) (u(w) - u(w - 2 pi))]
     Z(jw) = 1/2/pi * X(jw) ** Y(jw) = 1/4/pi^2 * X(jw) ** X(jw) ** X(jw)
           = 1/4/pi^2 [(3   pi w + w^2/2 + 9   pi^2/2) (u(w+3pi) - u(w+pi)) + (3 pi^2 - w^2) (u(w+pi)-u(w-pi)) + (9 pi^2/2 - 3 pi w + w^2/2) (u(w-pi)-u(w-3pi)) ]
     Z(j0) = [3 pi^2 - 0^2]/4/pi^2 = 1/4

     f <- function(t) {
        return (u(t + pi) - u(t - pi))
     }

     g <- function(t) {
        return ((2 pi + t) (u(t + 2 pi) - u(t)) + (2 pi - t) (u(t) - u(t - 2 pi)))
     }

     # f(x) = 3 pi^2 - bx^2
     # f(-pi) = 2 pi^2 = 3 pi^2 - b pi^2 => b = 1

     ff <- function(t) {
        if (t <= - pi)
            return(3   pi t + t^2/2 + 9   pi^2/2)
        if (t >= pi)
            return(9 pi^2/2 - 3 pi t + t^2/2)
        return (3 pi^2 - t^2)
     }

     convo <- function(t) {
        return (convolution(f, g, t))
     }

     dev.off()
     Mx1 <- -10
     Mx2 <- 10
     My1 <- -10
     My2 <- 30
     N <- 1000
     x <- matrix(0, N)
     y <- matrix(0, N)
     z <- matrix(0, N)
     w <- matrix(0, N)
     ww <- matrix(0, N)
     for (i in 1:N) {
         # t(1) = Mx1, t(N) = Mx2
         t <- (Mx2 - Mx1)/(N - 1) * (i - 1) + Mx1
         x[i] <- t
         y[i] <- f(t)
         z[i] <- g(t)
         w[i] <- convo(t)
         ww[i] <- ff(t) - 0.1
     }
     plot(x,y,type = 'l',col='blue',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
     par(new=T)
     plot(x,z,type = 'l',col='green',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')
     par(new=T)
     plot(x,w,type = 'l',col='red',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')

     par(new=T)
     plot(x,ww,type = 'l',col='blue',xlim=c(Mx1,Mx2),ylim = c(My1,My2),xlab='x',ylab='y')

     convolution(f, g, 0)/pi/pi

13d) result = integrate x'(t) dt from -infty to infty
     x(t) = sinc(t)
         
     Pela diferenciação no tempo,
     y(t) = x'(t)
     Y(jw) = jw * X(jw) = iw [u(w + pi) - u(w - pi)]
     Y(j0) = 0

13e) result = integrate abs(y(t))^2 dt from -infty to infty = R
     y(t) = integrate 1/pi/beta x(t - beta) dbeta from -infty to infty
     integrate abs(X(jw))^2 dw from -infty to infty = 2
    
     Pelas Relações de Parseval,
     integrate abs(x(t))^2 dt from -infty to infty = 1/pi
     R = 1/2/pi * integrate abs(Y(jw))^2 dw from -infty to infty
    
     y(t) = h(t) ** x(t)
     h(t) = 1/(pi t)
     H(jw) = 2 i u(-w)

     Pela convolução,
     Y(jw) = H(jw) X(jw) = 2 i u(-w) X(jw)
     R = -2/pi * integrate abs(X(jw))^2 dw from -infty to 0
    
     Vamos agora usar que o módulo de x, se for real, é -x e x.
     R = -2/pi * 1/2 * integrate abs(X(jw))^2 dw from -infty to infty
       = -2/pi

13f) result = integrate t exp(-abs(t)) sin(2t) dt from -infty to infty = R
     x(t) = t exp(-abs(t)) sin(2t)
     X(jw) = 8 (-3 w^4 + 6 w^2 + 25)/(w^4 - 6 w^2 + 25)^2
     R = X(j0) = 8/25
    
15) h(t) = Phi(delta(t))
    H(jw) = g(w, 3) = u(w + 3/2) - u(w - 3/2)
   
    a) result = y(t) = Phi(x(t))
       x(t) = sum k = -infty to infty, q(t - k*2 pi)
       q(t) = 100 pi ( (t + 1) * g(t + 0.5, 1) + (1 - t) * g(t - 0.5, 1) )
            = 100 pi ( (t + 1) * (u(t + 0.5 + 1/2) - u(t + 0.5 - 1/2)) + (1 - t) * (u(t - 0.5 + 1/2) - u(t - 0.5 - 1/2)) )
                    -1 <= t <= 0                                       0 <= t <= 1
       T0 = 2 pi
       X(jw) = sum k = -infty to infty, a(k) * 2 pi delta(w - k)
       a(k) = 1/2/pi * integrate q(t) exp(-i k t) dt from -pi to pi
            = 1/2/pi * integrate 100 pi (t + 1) exp(-i k t) dt from -1 to 0
            + 1/2/pi * integrate 100 pi (1 - t) exp(-i k t) dt from 0 to 1
            = -(50 (-i k + e^(i k) - 1))/k^2 + (50 (-i k - e^(-i k) + 1))/k^2
            = 100 (1 - cos(k))/k^2
       a(0) = 1/2/pi * integrate 100 pi (t + 1) dt from -1 to 0
            + 1/2/pi * integrate 100 pi (1 - t) dt from 0 to 1
            = 25 + 25 = 50
       X(jw) = 100 pi delta(w) + sum k = -infty to infty, k != 0, 200 pi (1 - cos(k))/k^2 delta(w - k)
      
       y(t) = h(t) ** x(t)
       Y(jw) = H(jw) X(jw) = truncar k(X) de -1.5 a 1.5
             = 100 pi delta(w) + sum k = -1 to 1, k != 0, 200 pi (1 - cos(k))/k^2 delta(w - k)
             = 100 pi delta(w) + 400 pi sin^2(1/2) delta(w + 1) + 400 pi sin^2(1/2) delta(w - 1)

       Z(jw) = delta(w - a)
       z(t) = 1/2/pi exp(i a t)
      
       y(t) = 100 pi * 1/2/pi + 400 pi sin^2(1/2) * 1/2/pi exp(-i t) + 400 pi sin^2(1/2) * 1/2/pi exp(i t)
            = 400 sin^2(1/2) cos(t) + 50
          
    b) result = 1/2/T0 * integrate abs(x(t))^2 dt from -T0 to T0 
              = 1/4/pi * integrate abs(100 pi (t + 1))^2 dt from -1 to 0
              + 1/4/pi * integrate abs(100 pi (1 - t))^2 dt from 0 to 1
              = 2500 pi/3 + 2500 pi/3 = 5000 pi/3

    c) result = 1/2/T0 * integrate abs(y(t))^2 dt from -T0 to T0
              = 1/4/pi * integrate abs(400 sin^2(1/2) cos(t) + 50)^2 dt from 0 to (2 pi)
              = 1250 + 40000 sin^4(1/2)

14) h(t) = Phi(delta(t))
    H(jw) = g(w + 10, 1) + g(w - 10, 1) = u(w + 10 + 1/2) - u(w + 10 - 1/2) + u(w - 10 + 1/2) - u(w - 10 - 1/2)

    a) result = y(t) = Phi(x(t))
       x(t) = 10 + 20 sin(3t) cos(7t)
            = -5 i e^(-4 i t) + 5 i e^(4 i t) + 5 i e^(-10 i t) - 5 i e^(10 i t) + 10
       T0 = pi

       Z(t) = exp(i a t)
       Z(jw) = 2 pi delta(w - a)
       X(jw) = -5 i * 2 pi delta(w + 4) + 5 i * 2 pi delta(w - 4) + 5 i * 2 pi delta(w + 10) - 5 i * 2 pi delta(w - 10) + 10 * 2 pi delta(w)
             = -10 i pi delta(w + 4) + 10 i pi delta(w - 4) + 10 i pi delta(w + 10) - 10 i pi delta(w - 10) + 20 pi delta(w)
         
       G(t) = g(t - b, c)
       G(jw) = integrate exp(-i w t) dt from (b-c/2) to (b+c/2)
             = 2 e^(-i b w) sin(c w/2)/w
       H(jw) = 2 e^(10 i w) sin(w/2)/w + 2 e^(-10 i w) sin(w/2)/w
             = 4 sin(w/2) cos(10 w)/w

       y(t) = h(t) ** x(t)
       Y(jw) = H(jw) X(jw) 
             = -10 i pi H(-4j) delta(w + 4) + 10 i pi H(4j) delta(w - 4) + 10 i pi H(-10j) delta(w + 10) 
               - 10 i pi H(10j) delta(w - 10) + 20 pi H(j0) delta(w)
             = -10 i pi sin(2) cos(40) delta(w + 4) + 10 i pi sin(2) cos(40) delta(w - 4) + 4 i pi sin(5) cos(100) delta(w + 10) 
               - 4 i pi sin(5) cos(100) delta(w - 10) + 40 pi delta(w)
      
       P(jw) = delta(w - a)
       p(t) = 1/2/pi exp(i a t)
      
       y(t) = -5 i sin(2) cos(40) exp(-4 i t) + 5 i sin(2) cos(40) exp(4 i t) + 2 i sin(5) cos(100) exp(- 10 i t) 
              - 2 i sin(5) cos(100) exp(10 i t) + 20
            = -10 sin(2) cos(40) sin(4 t) + 4 sin(5) cos(100) sin(10 t) + 20
      
    b) result = 1/2/T0 * integrate abs(x(t))^2 dt from -T0 to T0
              = 1/2/pi * integrate abs(10 + 20 sin(3t) cos(7t))^2 dt from -pi to pi
              = 200

    c) result = 1/2/T0 * integrate abs(y(t))^2 dt from -T0 to T0
              = 1/2/pi * integrate (100 sin^2(2) cos^2(40) sin^2(4 t) + 16 sin^2(5) cos^2(100) sin^2(10 t) + 400) dt from -pi to pi
              + 1/2/pi * integrate (- 80 sin(2) cos(40) sin(4 t) sin(5) cos(100) sin(10 t) - 200 sin(2) cos(40) sin(4 t) + 80 sin(5) cos(100) sin(10 t)) dt from -pi to pi
              = 50 sin^2(2) cos^2(40) + 8 sin^2(5) cos^2(100) + 400 = 423.85886976

y <- function(t) {
   return ((-10*sin(2)*cos(40)*sin(4*t) + 4*sin(5)*cos(100)*sin(10*t) + 20)^2)
}

dev.off()
grafico(y, -pi, pi, 0, 30, 'blue', 1000)

1/2/pi * integrar(-pi, pi, y, 0.00001)

16) h(t) = Phi(delta(t))
    H(jw) = 1/(jw + 3)
    h(t) = exp(-3t) u(t)

    result = x(t)
    y(t) = Phi(x(t)) = exp(-3t) u(t) - exp(-4t) u(t) = h(t) ** x(t)
   Y(jw) = H(jw) X(jw) = 1/(jw + 3) - 1/(jw + 4) = 1/(jw + 3) X(jw)
   X(jw) = 1 - (iw + 3)/(iw + 4) = 1/(4 + jw)
   x(t) = exp(-4t) u(t)

19) result = H(jw) = Y(jw)/X(jw)
    y'(t) + a y(t) = x(t)

    Pela diferenciação no tempo,
    z(t) = y'(t) = x(t) - a y(t)
    Z(jw) = jw * Y(jw) = X(jw) - a Y(jw)
   Y(jw)/X(jw) = 1/(jw + a)

20) x(t) = t exp(-at) u(t)

    Pela diferenciação na frequência,
    x(t) = t y(t)
    X(jw) = j d\dw Y(jw)

    y(t) = exp(-at) u(t)
   Y(jw) = 1/(jw + a)
   X(jw) = 1/(jw + a)^2

H(jw) = exp(-14iw)/(-iw^3 - 15w^2 + 66iw + 80)
      = e^(-14 i w)/((-5 - i w) (w - 2 i) (w - 8 i))
     
Pela diferenciação na frequência,
x(t) = t h(t)
X(jw) = i d\dw H(jw) = i e^(-14 i w) (14 w^3 - 213 i w^2 - 954 w + 1186 i)/((w - 2 i)^2 (w - 5 i)^2 (w - 8 i)^2)
X(j0) = i (1186 i)/((- 2 i)^2 (- 5 i)^2 (- 8 i)^2) = 0.1853125

##################

H(jw) = exp(-3iw)/(w^4 - 1.7iw^3 - 0.9w^2 + 0.144iw)
x(t) = h'(t)
X(jw) = jw * H(jw)
X(j0) = 0
