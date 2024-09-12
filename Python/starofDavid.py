# https://www.johndcook.com/blog/2024/09/10/separable-functions/

from mpmath import *
import numpy as np
import matplotlib.pyplot as plt

def binom(n, p):
   result = 1
   for i in range(0, p):
      result = fdiv(fmul(result, n - i), i + 1)
   return result

def gcd3(x,y,z):
	return gcd(gcd(int(x),int(y)),int(z))
   
def gcd(x,y):
	if x == 0:
		return y
	if y == 0:
		return x
	x, y = abs(x), abs(y)
	if y > x:
		x, y = y, x
	while True:
		q, r = int(fdiv(x,y)), int(fmod(x,y))
		if r == 1 or r == 0:
			break
		x, y = y, r
	if r == 1:
		return 1
	return y

mp.dps = 40
for n in range(100,101):
	for r in range(0,n+1):
		a = binom(n-1, r-1)
		b = binom(n, r+1)
		c = binom(n+1, r)
		d = binom(n-1, r)
		e = binom(n+1, r+1)
		f = binom(n, r-1)
		if r == 67:
			plt.figure(figsize=(16,9))
			p = mp.pi()
			x = np.array([mp.cos(p/2), mp.cos(p/2+2*p/3), mp.cos(p/2+4*p/3), mp.cos(p/2)])
			x = np.hstack((x, -x))
			y = np.array([mp.sin(p/2), mp.sin(p/2+2*p/3), mp.sin(p/2+4*p/3), mp.sin(p/2)])
			y = np.hstack((y, -y))
			colors = ['red', 'blue', 'green', 'red', 'purple', 'orange', 'black', 'purple']
			labels = [str(int(a))+" (-1,-1)",str(int(b))+" (0,1)",str(int(c))+" (1,0)",a,str(int(d))+" (-1,0)",str(int(e))+" (1,1)",str(int(f))+" (0,-1)",d]
			plt.plot(x[:4], y[:4])
			plt.plot(x[4:], y[4:])
			for i in (0,1,2,4,5,6):
				plt.scatter(x[i], y[i], color=colors[i], label=labels[i])
			plt.legend(loc='upper left')
			plt.show()
		print(n,r, gcd3(a,b,c), gcd3(d,e,f))

# Release 0.1 from 2024/Sep/12
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# out of charity, there is no salvation at all.
# with charity, there is evolution.
