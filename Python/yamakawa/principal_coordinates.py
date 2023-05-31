import numpy as np

def cart2pol(x, y):
    rho = np.sqrt(x**2 + y**2)
    phi = np.arctan2(y, x)
    return phi, rho

def pol2cart(rho, phi):
    x = rho * np.cos(phi)
    y = rho * np.sin(phi)
    return x, y

def sphCoordinates(xp):  # r sin t1, r cos t1 sin t2, r cos t1 cos t2 sin t3, r cos t1 cos t2 cos t3
    x = xp[::-1]
    n = np.shape(x)[1]-1
    v = np.copy(x)
    v[0,0] = np.linalg.norm(x)
    tmp = v[0,0]
    for i in range(0, n-1):
        v[0,i+1] = np.arcsin(x[0,i]/tmp)
        tmp = tmp * np.cos(v[0,i+1])
    v[0,n], r = cart2pol(x[0,n], x[0,n-1])
    return v

def cartCoordinates(x):
    v = np.copy(x)
    tmp = x[0,0]
    n = np.shape(x)[1]
    for i in range(0, n-1):
        v[0,i] = tmp * np.sin(x[0,i+1])
        tmp = tmp * np.cos(x[0,i+1])
    v[0,n-1] = tmp
    return v[::-1]

print(cartCoordinates(sphCoordinates(np.array([[-2,3,-4]], dtype=float))))
print(cartCoordinates(sphCoordinates(np.array([[2,3,-4]], dtype=float))))
print(cartCoordinates(sphCoordinates(np.array([[-2,3,-4,5,-6,7,-8]], dtype=float))))
