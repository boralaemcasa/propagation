# this is a 3D plotting program.
import numpy as np
from mpmath import *
import matplotlib.pyplot as plt

def line(A, B, color):
	t = mp.arange(0, 1, 1/500)
	x = mp.zeros(500,3)
	for i in range(0,500):
		x[i,0] = A[0] + t[i] * (B[0] - A[0])
		x[i,1] = A[1] + t[i] * (B[1] - A[1])
		x[i,2] = A[2] + t[i] * (B[2] - A[2])
	ax.plot(x[:,0], x[:,1], x[:,2], color)

def intersect(t, a, b, c, d, e):
	a,b,c,d,e = a-1,b-1,c-1,d-1,e-1
	X, Y, Z = t[:,0], t[:,1], t[:,2]
	M = mp.matrix([[X[b] - X[a], X[c] - X[d], X[c] - X[e]], [Y[b] - Y[a], Y[c] - Y[d], Y[c] - Y[e]], [Z[b] - Z[a], Z[c] - Z[d], Z[c] - Z[e]]])
	U = mp.zeros(7,3)
	if mp.fabs(mp.det(M)) < 1e-6:
		z = np.random.permutation(7)
		for i in (0,7):
			U[i,0] = X[int(z[i])]
			U[i,1] = Y[int(z[i])]
			U[i,2] = Y[int(z[i])]
		t = U
		return 0, False
	u = M**(-1) * mp.matrix([[X[c] - X[a]], [Y[c] - Y[a]], [Z[c] - Z[a]]])
	Ax = X[a] + u[0] * (X[b] - X[a])
	Ay = Y[a] + u[0] * (Y[b] - Y[a])
	Az = Z[a] + u[0] * (Z[b] - Z[a])
	return mp.matrix([[Ax], [Ay], [Az]]), True

mp.dps = 40
p = mp.pi()
a = mp.zeros(10,1)
#for i in range(0,10):
#	a[i] = mp.rand() * 2 - 1
a[0] = mp.rand()
a[1] = mp.rand()
a[2] = mp.rand() * 2 - 1
a[9] = - mp.rand()

def raio(lon, lat):
	# a0 x^2 + a1 y^2 + a2 z^2 + a3 xy + a4 xz + a5 yz + a6 x + a7 y + a8 z + a9 = 0
	# x = r cos lon cos lat, y = r sin lon cos lat, z = r sin lat
	# A r^2 + B r + C = 0
	clon, slon, clat, slat = mp.cos(lon), mp.sin(lon), mp.cos(lat), mp.sin(lat)
	A = a[0] * clon**2 * clat**2 + a[1] * slon**2 * clat**2 + a[2] * slat**2 + a[3] * clon*clat * slon*slat + a[4] * clon*clat * slat + a[5] * slon*clat * slat
	B = a[6] * clon*clat + a[7] * slon*clat + a[8] * slat
	C = a[9]
	Delta = B*B - 4*A*C
	if Delta < 0 or mp.fabs(A) < 1e-6:
		return mp.nan
	result = (-B + mp.sqrt(Delta))/2/A
	if result == 0:
		return mp.nan
	return result

n = 30
y = mp.arange(0, 2*p, 2*p/n)    # longitude
z = mp.arange(-p/2, p/2, p/n)   # latitude
x = mp.zeros(n*n,3)
i = 0
for k in range(0,n):
	for j in range(0, n):
		x[i,0] = raio(y[j], z[k])
		c = mp.cos(z[k])
		x[i,0], x[i,1], x[i,2] = x[i,0] * mp.cos(y[j]) * c, x[i,0] * mp.sin(y[j]) * c, x[i,0] * mp.sin(z[k])
		i = i + 1
fig, ax = plt.subplots(subplot_kw={"projection": "3d"}, figsize=(16,9))
surf = ax.plot(x[:,0], x[:,1], x[:,2], 'y')

t = mp.zeros(7,3)
for i in range(0,7):
	contador = 0
	while True:
		t[i,1] = mp.rand() * 2 * p
		t[i,2] = mp.rand() * p - p/2
		t[i,0] = raio(t[i,1], t[i,2])
		c = mp.cos(t[i,2])
		t[i,0], t[i,1], t[i,2] = t[i,0] * mp.cos(t[i,1]) * c, t[i,0] * mp.sin(t[i,1]) * c, t[i,0] * mp.sin(t[i,2])
		if not mp.isnan(t[i,0]):
			break
		contador = contador + 1
		if contador >= 500:
			exit()

contador = 0
while True:
	A, flag1 = intersect(t, 1, 5, 2, 6, 7)
	B, flag2 = intersect(t, 1, 4, 3, 6, 7)
	C, flag3 = intersect(t, 2, 4, 3, 5, 7)
	D, flag4 = intersect(t, 4, 7, 2, 3, 5)
	if flag1 and flag2 and flag3 and flag4:
		break
	contador = contador + 1
	if contador >= 500:
		exit()
			
line(t[0,:], t[1,:], 'r')
plt.show()
# Release 0.0.9 from 2024/July/26
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.