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
	t = M**(-1) * mp.matrix([[X[c] - X[a]], [Y[c] - Y[a]]])
	Ax = X[a] + t[0] * (X[b] - X[a])
	Ay = Y[a] + t[0] * (Y[b] - Y[a])
	line(X[a], Y[a], Ax, Ay, 'g')
	line(X[c], Y[c], Ax, Ay, 'g')
	line(X[a], Y[a], X[b], Y[b], 'b')
	line(X[c], Y[c], X[d], Y[d], 'b')
	return mp.matrix([[Ax], [Ay]])
	
mp.dps = 40
p = mp.pi()
t = mp.zeros(6,3)
for i in range(0,6):
	t[i,0] = mp.rand() * 2 - 1#0
	t[i,1] = mp.cosh(t[i,0])
	t[i,2] = mp.sinh(t[i,0])
x = mp.arange(-1, 1, 2/500)
y = mp.arange(-1, 1, 2/500)
for i in range(0,500):
	x[i], y[i] = mp.cosh(x[i]), mp.sinh(x[i])
plt.plot(x, y, 'y')
#x, y = mp.zeros(7,1), mp.zeros(7,1)
#x[:-1,0], y[:-1,0] = t[:,1], t[:,2]
#x[6,0],   y[6,0]   = t[0,1], t[0,2]
#plt.plot(x, y, 'b')
A = intersect(t[:,1], t[:,2], 1-1, 5-1, 2-1, 6-1)
B = intersect(t[:,1], t[:,2], 1-1, 4-1, 3-1, 6-1)
C = intersect(t[:,1], t[:,2], 2-1, 4-1, 3-1, 5-1)
line(A[0], A[1], B[0], B[1], 'r')
line(B[0], B[1], C[0], C[1], 'r')
Lambda1 = (C[0] - A[0])/(B[0] - A[0])
Lambda2 = (C[1] - A[1])/(B[1] - A[1])
print(Lambda2 - Lambda1)
plt.show()
# Release 0.1.1 from 2024/July/16
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.
