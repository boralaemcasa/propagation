from mpmath import *

def my_round(x):
   y = mp.fabs(x)
   if mp.fabs(y - mp.floor(y)) < 0.5:
      return mp.sign(x) * mp.floor(y)
   else:
      return mp.sign(x) * mp.ceil(y)
	  
def power(x, y):
   if (y / 2 == mp.floor(y / 2)) and (mp.im(x) == 0) and (mp.re(x) < 0):
      return mp.exp(y * mp.ln(-x))
   else:
      return mp.exp(y * mp.ln(x))

def binom(n, p):
   result = 1
   for i in range(0, p):
      result = result * (n - i) / (i + 1)
   return result

# https://x.com/mathspiritual/status/1825271206599070068
def f(n,p):
	return power(2, n-p+1) * binom(n+1,p)

mp.dps = 40
n = 20
v = mp.zeros(2,n)
v[0,0] = 2
print(int(my_round(f(0,0))), "[2]")
print(int(v[0,0]), "[2]") # Euler numbers for the cube: 1 - (-1)^n
for i in range(1,n):
	v[1,0] = v[0,0] * 2
	v[1,i] = v[0,i-1] + 2
	if i >= 2:
		for k in range(1,i):
			v[1,k] = v[0,k-1] + 2*v[0,k]
	v[0,:] = v[1,:]
	s = str(int(v[0,0]))
	t = str(int(my_round(f(i,0))))
	soma = v[0,0]
	sinal = -1
	for k in range(1,i+1):
		s = s + " " + str(int(v[0,k]))
		t = t + " " + str(int(my_round(f(i,k))))
		soma = soma + sinal * v[0,k]
		sinal = - sinal
	s = s + " [" + str(int(soma)) + "]"
	t = t + " [" + str(int(soma)) + "]"
	print(s)
	print(t)

# Release 0.1 from 2024/Ago/19
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# out of charity, there is no salvation at all.
# with charity, there is evolution.
