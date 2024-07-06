from mpmath import *
import matplotlib.pyplot as plt
mp.dps = 40
p = mp.pi()
t1 = mp.rand() * 2 * p #0
t2 = mp.rand() * 2 * p #p/12
t4 = mp.rand() * 2 * p #p/3*2
t5 = mp.rand() * 2 * p #p/180*179
cos_t1, sin_t1 = mp.cos(t1), mp.sin(t1)
cos_t2, sin_t2 = mp.cos(t2), mp.sin(t2)
cos_t4, sin_t4 = mp.cos(t4), mp.sin(t4)
cos_t5, sin_t5 = mp.cos(t5), mp.sin(t5)
L_15 = (-cos_t5 * sin_t1 + cos_t1 * sin_t5)/(cos_t1 - cos_t5)
L_14 = (-cos_t4 * sin_t1 + cos_t1 * sin_t4)/(cos_t1 - cos_t4)
L_24 = (-cos_t4 * sin_t2 + cos_t2 * sin_t4)/(cos_t2 - cos_t4)
a = (sin_t2 - L_15)/cos_t2
a2 = a*a
for eps6 in list([-1,1]):
	cos_t6 = (-a*L_15 + eps6 * mp.sqrt(1 + a2 - L_15*L_15))/(1 + a2)
	sin_t6 = a * cos_t6 + L_15
	c = (sin_t6 - L_14)/cos_t6
	c2 = c*c
	for eps3 in list([-1,1]):
		cos_t3 = (-L_14*c + eps3 * mp.sqrt(1 + c2 - L_14*L_14))/(1 + c2)
		sin_t3 = c*cos_t3 + L_14
		L_35 = (-cos_t5 * sin_t3 + cos_t3 * sin_t5)/(cos_t3 - cos_t5)
		M = mp.matrix([[1,-1],[-cos_t4,cos_t2]])
		AB = 1/(cos_t2-cos_t4) * M * mp.matrix([[sin_t2],[sin_t4]])
		M = mp.matrix([[1,-1],[-cos_t5,cos_t3]])
		CD = 1/(cos_t3 - cos_t5) * M * mp.matrix([[sin_t3],[sin_t5]])
		cx = (CD[1]-AB[1])/(AB[0]-CD[0])
		cy = AB[0]*cx + AB[1]
		if mp.fabs(cx) < 1e-9:
			x = [cos_t4, 0,    cos_t1, 0,    cos_t5, 0,    cos_t3, cos_t6, cos_t2, 0,    cos_t4]
			y = [sin_t4, L_14, sin_t1, L_15, sin_t5, L_35, sin_t3, sin_t6, sin_t2, L_24, sin_t4]
			plt.plot(x, y, 'g')
			print("x_C =", cx)
			print("y_C =", cy)
			x = [0, 0]
			y = [min([L_15, L_14, L_35]), max([L_15, L_14, L_35])]
			plt.plot(x, y, 'r')
			x = mp.arange(0, 2*p, 2*p/500)
			y = mp.arange(0, 2*p, 2*p/500)
			for i in range(0,500):
				x[i], y[i] = mp.cos(x[i]), mp.sin(x[i])
			plt.plot(x, y, 'y')
			plt.title("e_6 = " + str(eps6) + "; e_3 = " + str(eps3) + "; diff = " + str(L_35-L_24))
			x = [cos_t4, cos_t1, cos_t5, cos_t3, cos_t6, cos_t2, cos_t4]
			y = [sin_t4, sin_t1, sin_t5, sin_t3, sin_t6, sin_t2, sin_t4]
			plt.plot(x, y, 'b')
			plt.show()
			exit()