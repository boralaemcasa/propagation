# this is a 2D plotting program. for a 3D one, see pg3.py
import numpy as np
from mpmath import *
import matplotlib.pyplot as plt

def line(Xa, Ya, Xb, Yb, color):
	t = mp.arange(0, 1, 1/500)
	for i in range(0,500):
		x[i] = Xa + t[i] * (Xb - Xa)
		y[i] = Ya + t[i] * (Yb - Ya)
	plt.plot(x, y, color)

def intersect(X, Y, a, b, c, d):
	#X[a] + t1 (X[b] - X[a]) = X[c] + t2 (X[d] - X[c])
	M = mp.matrix([[X[b] - X[a], X[c] - X[d]], [Y[b] - Y[a], Y[c] - Y[d]]])
	U = mp.zeros(6,2)
	if mp.fabs(mp.det(M)) < 1e-6:
		z = np.random.permutation(6)
		for i in (0,6):
			U[i,0] = X[int(z[i])]
			U[i,1] = Y[int(z[i])]
		X = U[:,0]
		Y = U[:,1]
		return 0, False
	t = M**(-1) * mp.matrix([[X[c] - X[a]], [Y[c] - Y[a]]])
	Ax = X[a] + t[0] * (X[b] - X[a])
	Ay = Y[a] + t[0] * (Y[b] - Y[a])
	line(X[a], Y[a], Ax, Ay, 'g')
	line(X[c], Y[c], Ax, Ay, 'g')
	line(X[a], Y[a], X[b], Y[b], 'b')
	line(X[c], Y[c], X[d], Y[d], 'b')
	return mp.matrix([[Ax], [Ay]]), True
	
mp.dps = 40
fig = plt.figure(figsize=(16,9))
p = mp.pi()

a = mp.zeros(6,1)
for i in range(0,6):
	a[i] = mp.rand() * 2 - 1

# (y+x + 1)(y - 2x + 1) = y^2 - 2x^2 - 2xy + xy + y + x + y - 2x + 1
# a = mp.matrix([[-2,1,-1,-1,2,1]]).T

def raio(t):
	cc, ss = mp.cos(t), mp.sin(t)
	A = cc*cc * (a[0] - a[1]) + a[2] * cc * ss + a[1]
	B = a[3] * cc + a[4] * ss
	C = a[5]
	Delta = B*B - 4*A*C
	if Delta < 0 or mp.fabs(A) < 1e-6:
		return mp.nan
	result = (-B + mp.sqrt(Delta))/2/A
	if result == 0:
		return mp.nan
	return result

t = mp.zeros(6,3)
for i in range(0,6):
	contador = 0
	while True:
		t[i,0] = mp.rand() * 2 * p
		t[i,1] = raio(t[i,0])
		t[i,1], t[i,2] = t[i,1]*mp.cos(t[i,0]),t[i,1]*mp.sin(t[i,0])
		if not mp.isnan(t[i,1]):
			break
		contador = contador + 1
		if contador >= 500:
			exit()
x = mp.arange(0, 2*p, 2*p/500)
y = mp.arange(0, 2*p, 2*p/500)
for i in range(0,500):
	y[i] = raio(x[i])
	x[i], y[i] = y[i] * mp.cos(x[i]), y[i] * mp.sin(x[i])
plt.plot(x, y, 'y')
#x, y = mp.zeros(7,1), mp.zeros(7,1)
#x[:-1,0], y[:-1,0] = t[:,1], t[:,2]
#x[6,0],   y[6,0]   = t[0,1], t[0,2]
#plt.plot(x, y, 'b')
contador = 0
while True:
	A, flag1 = intersect(t[:,1], t[:,2], 1-1, 5-1, 2-1, 6-1)
	B, flag2 = intersect(t[:,1], t[:,2], 1-1, 4-1, 3-1, 6-1)
	C, flag3 = intersect(t[:,1], t[:,2], 2-1, 4-1, 3-1, 5-1)
	if flag1 and flag2 and flag3:
		break
	contador = contador + 1
	if contador >= 500:
		exit()
line(A[0], A[1], B[0], B[1], 'r')
line(B[0], B[1], C[0], C[1], 'r')
Lambda1 = (C[0] - A[0])/(B[0] - A[0])
Lambda2 = (C[1] - A[1])/(B[1] - A[1])
print(Lambda2 - Lambda1)
xl1 = np.float32(min([min(t[:,1]),A[0],B[0],C[0]]))
xl2 = np.float32(max([max(t[:,1]),A[0],B[0],C[0]]))
yl1 = np.float32(min([min(t[:,2]),A[1],B[1],C[1]]))
yl2 = np.float32(max([max(t[:,2]),A[1],B[1],C[1]]))
plt.xlim(xl1, xl2)
plt.ylim(yl1, yl2)
plt.show()
# Release 0.1.3.1 from 2024/July/26
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.