# this is a 3D plotting program.
import numpy as np
from mpmath import *
import matplotlib.pyplot as plt

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
plt.show()
# Release 0.1 from 2024/July/23
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.