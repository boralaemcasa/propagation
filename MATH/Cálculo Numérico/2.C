#include <math.h>

float f(float x, float y) {
  return (x * x - 3 * x - 1 - y);
}

float g(float x) {
  return (0.55 * exp(1-x) + x * x - 5 * x + 4);
}

void DOPRI(float a, float b, float m, float y0) {
  int i;
  float h, xt, yt, VetX[101], VetY[101], EG[101], x, y,
    k1, k2, k3, k4, k5, k6, k7, ErroGlobal, Erro,
  a21 = 1.0/5,
  a31 = 3.0/40,
  a32 = 9.0/40,
  a41 = 44.0/45,
  a42 = -56.0/15,
  a43 = 32.0/9,
  a51 = 19372.0/6561,
  a52 = -25360.0/2187,
  a53 = 64448.0/6561,
  a54 = -212.0/729,
  a61 = 9017.0/3168,
  a62 = -355.0/33,
  a63 = 46732.0/5247,
  a64 = 49.0/176,
  a65 = -5103.0/18656,
  a71 = 35.0/384,
  a73 = 500.0/1113,
  a74 = 125.0/192,
  a75 = -2187.0/6784,
  a76 = 11.0/84,
  c2 = 1.0/5,
  c3 = 3.0/10,
  c4 = 4.0/5,
  c5 = 8.0/9,
  c6 = 1.0,
  c7 = 1.0,
  e1 = 71.0/57600,
  e3 = -71.0/16695,
  e4 = 71.0/1920,
  e5 = -17253.0/339200,
  e6 = 22.0/525,
  e7 = -1.0/40;
  h = (b - a)/m;
  xt = a;
  yt = y0;
  VetX[1] = xt;
  VetY[1] = yt;
  EG[1] = 0;
  printf(" i   x              y              ErroGlobal    Erro\n");
  printf("%2d  %13.10f  %13.10f\n", 0, xt, yt);
  for(i = 1; i <= m; i++) {
    x = xt;
    y = yt;
    k1 = h * f(x,y);
    x = xt + c2 * h;
    y = yt + a21 * k1;
    k2 = h * f(x,y);
    x = xt + c3 * h;
    y = yt + a31 * k1 + a32 * k2;
    k3 = h * f(x,y);
    x = xt + c4 * h;
    y = yt + a41 * k1 + a42 * k2 + a43 * k3;
    k4 = h * f(x,y);
    x = xt + c5 * h;
    y = yt + a51 * k1 + a52 * k2 + a53 * k3 + a54 * k4;
    k5 = h * f(x,y);
    x = xt + c6 * h;
    y = yt + a61 * k1 + a62 * k2 + a63 * k3 + a64 * k4 + a65 * k5;
    k6 = h * f(x,y);
    x = xt + c7 * h;
    y = yt + a71 * k1 + a73 * k3 + a74 * k4 + a75 * k5 + a76 * k6;
    k7 = h * f(x,y);
    xt = a + i * h;
    yt = yt + a71 * k1 + a73 * k3 + a74 * k4 + a75 * k5 + a76 * k6;
    ErroGlobal = e1 * k1 + e3 * k3 + e4 * k4 + e5 * k5 + e6 * k6 + e7 * k7;
    VetX[i + 1] = xt;
    VetY[i + 1] = yt;
    EG[i + 1] = ErroGlobal;
    printf("%2d  %13.10f  %13.10f  %13.10f %13.10f\n", i, xt, yt, ErroGlobal, abs(yt - g(xt)));
    getch();
  }
}

void main() {
  clrscr();
  DOPRI(1, 2, 50, 0.55);
}