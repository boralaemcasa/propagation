function ydot=dvCord1(y,u,t)
ydot = (2.13e-2 * u^4 - 2.41e-2 * y^4 + 3.46 * y^3 - 2.63 * y^2 * u) * 1e-10;
