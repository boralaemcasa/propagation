from mpmath import *

mp.dps = 40
n = 20
v = mp.zeros(2,n)
v[0,0] = 2
print("2 [2]") # Euler numbers for the cube: 1 - (-1)^n
for i in range(1,n):
	v[1,0] = v[0,0] * 2
	v[1,i] = v[0,i-1] + 2
	if i >= 2:
		for k in range(1,i):
			v[1,k] = v[0,k-1] + 2*v[0,k]
	v[0,:] = v[1,:]
	s = str(int(v[0,0]))
	soma = v[0,0]
	sinal = -1
	for k in range(1,i+1):
		s = s + " " + str(int(v[0,k]))
		soma = soma + sinal * v[0,k]
		sinal = - sinal
	s = s + " [" + str(int(soma)) + "]"
	print(s)

# Release 0.1 from 2024/Ago/15
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# out of charity, there is no salvation at all.
# with charity, there is evolution.
