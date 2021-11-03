#include <stdio.h>
#include <math.h>

typedef float Matriz[101] [101];
typedef float Vetor[101];

float Sqr(float x) {
  return x * x;
}

void Transpor(int n, Matriz L) { // retornar L^t
  int i, j;
  float reg;
  for (i = 1; i <= n; i++)
    for (j = i + 1; j <= n; j++) {
      reg = L[i][j];
      L[i][j] = L[j][i];
      L[j][i] = reg;
    }
}

// Lx = c, retornar x
void Subst_Sucessivas(int n, Matriz L, Vetor x, Vetor c) {
  int i, j;
  float soma;

  x[1] = c[1] / L[1][1];
  for(i = 2; i <= n; i++) {
    soma = 0;
    for(j = 1; j <= i - 1; j++)
      soma = soma + L[i][j] * x[j];

    x[i] = (c[i] - soma) / L[i][i];
  }
}

// Ux = d, retornar x
void Subst_Retroativas(int n, Matriz U, Vetor x, Vetor d) {
  int i, j;
  float soma;

  x[n] = d[n] / U[n][n];
  for (i = n - 1; i >= 1; i--) {
    soma = 0;
    for (j = i + 1; j <= n; j++)
      soma = soma + U[i][j] * x[j];

    x[i] = (d[i] - soma) / U[i][i];
  }
}

int LDL_t(int n, Matriz A, Matriz L, Matriz D) {
  int i, j, k;
  float soma;

  for (j = 1; j <= n; j++)
    L[j][j] = 1;

  for (j = 1; j <= n; j++) {
    soma = 0;
    for (k = 1; k <= j - 1; k++)
      soma = soma + Sqr(L[j][k]) * D[k][k];

    D[j][j] = A[j][j] - soma;
    if (D[j][j] <= 0) {
      printf("A matriz nao eh definida positiva");
      return 1; // 1 para sair do bloco "main"
    }

    for (i = j + 1; i <= n; i++) {
      soma = 0;
      for (k = 1; k <= j - 1; k++)
	soma = soma + L[i][k] * D[k][k] * L[j][k];

      L[i][j] = (A[i][j] - soma) / D[j][j];
    }
  }
  return 0;
}

void main() {
  int i, j, n;
  Matriz A, L, D;
  Vetor b, t, x, y;

  clrscr();
  printf("Digite n (m ximo de 100): ");
  scanf("%d", &n);
  if (n > 100) return;
  for (i = 1; i <= n; i++)
    for (j = 1; j <= n; j++) {
      printf("Digite A[%d,%d]: ", i, j);
      scanf("%f", &A[i] [j]);
      L[i][j] = 0; // inicializa L
      D[i][j] = 0; // inicializa D
    }

  for (i = 1; i <= n; i++) {
    printf("Digite b[%d]: ", i);
    scanf("%f", &b[i]);
  }

  if (LDL_t(n, A, L, D))
    return;

  Subst_Sucessivas(n, L, y, b);
//como D eh diagonal, podemos usar as subst. sucessivas abaixo:
  Subst_Sucessivas(n, D, t, y);

  Transpor(n, L);
  Subst_Retroativas(n, L, x, t); // L^t ú x = y

//exibir L
  Transpor(n, L); // (L^t)^t = L
  printf("\n\nPela decomposicao LDL_t:\n");

  for (i = 1; i <= n; i++)
    for (j = 1; j <= n; j++)
      printf("L[%d,%d] = %8.10f\n", i, j, L[i] [j]);

  getch();

//exibir D
  printf("\n\nTambem pela decomposicao LDL_t:\n");

  for (i = 1; i <= n; i++)
    for (j = 1; j <= n; j++)
      printf("D[%d,%d] = %8.10f\n", i, j, D[i] [j]);

  getch();

//exibir y, t
  printf("\nPelas substituicoes sucessivas:\n");

  for (i = 1; i <= n; i++)
    printf("y[%d] = %8.10f\n", i, y[i]);

  printf("\n");
  for (i = 1; i <= n; i++)
    printf("t[%d] = %8.10f\n", i, t[i]);

  getch();

//exibir x
  printf("\nPelas substituicoes retroativas:\n");

  for (i = 1; i <= n; i++)
    printf("x[%d] = %8.10f\n", i, x[i]);

  getch();
}