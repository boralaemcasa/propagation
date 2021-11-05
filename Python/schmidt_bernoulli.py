from mpmath import *
from sympy import Matrix
import random

def power(x, y):
   if (y / 2 == mp.floor(y / 2)) and (mp.im(x) == 0) and (mp.re(x) < 0):
      return mp.exp(y * mp.ln(-x))
   else:
      return mp.exp(y * mp.ln(x))

def sgn(xx):
   x = mp.re(xx)
   if x > 0:
      return 1
   elif x < 0:
      return -1
   return 0

def my_round(x):
   y = mp.fabs(x)
   if mp.fabs(y - mp.floor(y)) < 0.5:
      return mp.sign(x) * mp.floor(y)
   else:
      return mp.sign(x) * mp.ceil(y)

def my_int(x):
   y = int(my_round(x))
   return y

def fatorial(x):
   result = 1
   while x > 1:
     result = result * x
     x = x - 1
   return result

def binom(n, p):
   if (mp.im(p) == 0) and (mp.re(n) < mp.re(p)):
      return 0
   result = 1
   for i in range(0, p):
      result = result * (n - i) / (i + 1)
   return result

def Bernoulli(n):
   # \sum k = 1 to n + 1 of (-1)^(k + 1) / k  binom(n + 1, k) \sum j = 1 to k of (j^n)
   res = 0
   s = 1
   soma = 0
   for k in range (1, n + 2):
      soma = soma + power(k, n)
      res = res + s/k * binom(n + 1, k) * soma
      s = - s
   return res

def polar(B, p, q):
   if p >= q:
      S = mp.sqrtm(B.T * B)
      Oh = B * mp.inverse(S)
   else:
      S = mp.sqrtm(B * B.T)
      Oh = mp.inverse(S) * B
   return S, Oh

def schmidt(V, n, signal):
   Delta = mp.zeros(n, n)
   W = mp.zeros(n, n)

   for k in range (0, n):
      for i  in range (0, n):
         W[i, k] = V[i, k]
         for j in range (0, k):
            W[i, k] = W[i, k] - Delta[j, k] * W[i, j]

      # norm of column W[:,k]
      Delta[k, k] = W[0, k] * W[0, k]
      for i in range (1, n):
         Delta[k, k] = Delta[k, k] + W[i, k] * W[i, k]
      Delta[k, k] = mp.sqrt(Delta[k, k])

      if mp.fabs(Delta[k, k]) < 1e-9:
         Delta = mp.zeros(n, n)
         for k in range (0, n):
            Delta[k, k] = 1
         return Delta, V, 0 # identity * V = V and det V = 0

      for i in range (0, n):
         W[i, k] = W[i, k] / Delta[k, k]

      if k < n - 1:
         for i in range (0, k + 1):
            # Delta[i][k + 1] = produtoInterno(V, k + 1, W, i, n);
            Delta[i, k + 1] = V[0, k + 1] * W[0, i]
            for j in range (1, n):
               Delta[i, k + 1] = Delta[i, k + 1] + V[j, k + 1] * W[j, i]

   # at this moment, V = W * Delta
   # W is orthogonal <=> |det W| = 1.0
   # Delta is triangular
   prod = Delta[0, 0]
   for i in range (1, n):
      prod = prod * Delta[i, i]
   prod2 = 1

   if signal:
      A = mp.zeros(n, n)
      for k in range (0, n):
         for i  in range (0, n):
            A[i, k] = W[i, k]

      #*** Sometimes the sgn(det) is wrong.
      # What did I try here?
      # product rule det[ a  b] = k det[a b] and sum rule: det[ 1  a] = -b + a = det[ 1    a  ]
      #                 [kc kd]        [c d]                  [-1 -b]               [ 0  a - b]

      for pivoti in range (0, n):
         pivotj = pivoti

         while ((mp.fabs(A[pivoti, pivotj]) < 1e-9) and (pivoti < n)):
            pivoti = pivoti + 1

         #if (pivoti >= n) throw new Exception("Singular matrix.")

         if pivotj != pivoti:
            for j in range (0, n):
               # xchg A[pivoti][*], A[pivotj][*]
               A[pivoti, j], A[pivotj, j] = A[pivoti, j], A[pivotj, j]
            pivoti = pivotj

         for i in range (0, n):
           if mp.fabs(A[i, pivotj]) > 1e-9:
              for j in range (0, n):
                if j != pivotj:
                   A[i, j] = A[i, j] / A[i, pivotj] # column pivotj = 1
              if i >= pivoti:
                 prod2 = - prod2 * sgn(A[i, pivotj])
                 if i == pivoti:
                    prod2 = - prod2
              A[i, pivotj] = 1

         for i in range (pivoti + 1, n):
            if ((i != pivoti) and (mp.fabs(A[i, pivotj]) > 1e-9)):
               for j in range (0, n):
                  # line i -= line pivoti. column pivotj become full of zeroes
                  A[i, j] = A[i, j] - A[pivoti, j]

   # prod = det V = 1.0 * det Delta
   return W, Delta, prod * prod2

def Cramer(A, b, n):
   print("detA")
   Oh, Triang, detA = schmidt(A, n, False)
   x = mp.zeros(n, 1)
   M = mp.zeros(n, n)
   for i in range (0, n):
      for k in range (0, n):
         M[i, k] = A[i, k]
   for k in range (0, n):
      for i in range (0, n): # xchg column k
         M[i, k] = b[i]
      print("det M", k)
      Oh, Triang, detM = schmidt(M, n, True) #*** False
      for i in range (0, n): # restoring
         M[i, k] = A[i, k]
      x[k] = detM/detA

   return x

   y = mp.zeros(n + 1, 1)
   for i in range (0, n):
      y[i] = A[0, i] * x[i]
   y[n] = b[0]

   y = simplex(y, n + 1)

   return x

def partial_schmidt(V, n, col):
   Delta = mp.zeros(n, col)
   W = mp.zeros(n, col)

   for k in range (0, col):
      for i  in range (0, n):
         W[i, k] = V[i, k]
         for j in range (0, k):
            W[i, k] = W[i, k] - Delta[j, k] * W[i, j]

      # norm of column W[:,k]
      Delta[k, k] = W[0, k] * W[0, k]
      for i in range (1, n):
         Delta[k, k] = Delta[k, k] + W[i, k] * W[i, k]
      Delta[k, k] = mp.sqrt(Delta[k, k])

      if mp.fabs(Delta[k, k]) < 1e-9:
         return V

      for i in range (0, n):
         W[i, k] = W[i, k] / Delta[k, k]

      if k < col - 1:
         for i in range (0, k + 1):
            # Delta[i][k + 1] = produtoInterno(V, k + 1, W, i, n);
            Delta[i, k + 1] = V[0, k + 1] * W[0, i]
            for j in range (1, n):
               Delta[i, k + 1] = Delta[i, k + 1] + V[j, k + 1] * W[j, i]

   return W

def simplex(y, n):
   col, li = n + n + 1 + 1, n + 2
   c = mp.zeros(col + li, 1)
   c[col - 2] = -1 # target = 0^{2n} -1 0
   A = mp.zeros(li, col + li)
   b = mp.zeros(li)
   for i in range (0, n):
      A[i, i], A[i + n], b[i] = 1, 1, 1 # negative + positive == 1
      A[n, i], A[n, i + n] = y[i], - y[i]
      A[n + 1, i], A[n + 1, i + n] = y[i], - y[i]

   A[n, col - 2], A[n, col - 1] = -1,  1         # <: [y] [-y] -1  1 == 0
   A[n + 1, col - 2], A[n + 1, col - 1] = -1, -1 # >: [y] [-y] -1 -1 == 0

   for i in range (1, li + 1):
      A[li - i, col + li - i] = 1 # aux variables := identity

   opNovaA = mp.zeros(li, li)
   for i in range (0, li):
      opNovaA[i, i] = 1
   novaA = mp.zeros(li, col + li)
   for i in range (0, li):
      for j in range (0, col + li):
         novaA[i, j] = A[i, j]
   novoB = mp.zeros(li, 1)
   for i in range (0, li):
      novoB[i] = b[i]
   novaC = mp.zeros(col + li, 1)
   for i in range (0, col + li):
      novaC[i] = c[i]
   opNovaC = mp.zeros(li, 1)
   novow0 = 0
   pivotLoop = list()

"""
   *** to do: translate [part of] the simplex from C to [Grand] PieThon...

   for (li = 1; li <= novaA->rowCount; li++)
      Pivotear(novaA->colCount - li, novaA->rowCount - li, novaA, opNovaA,
                   novoB, novaC, novow0, opNovaC, pivotLoop);

   do {
      alterou = Primal(novaC, novaA, novoB, pivotLoop, opNovaA, novow0, opNovaC, *A, *b, *c, NULL, NULL);
      alterou = Dual(novaC, novaA, novoB, pivotLoop, opNovaA, novow0, opNovaC, *A, *b, *c, NULL, NULL) || alterou;
   } while (alterou);

   for (col = 0; col < A->colCount - A->rowCount; col++)
      li = Canonica(col, *novaC, *novaA);

   A->colCount = novaA->colCount - novaA->rowCount;
   A->v = malloc(A->colCount * A->rowCount * sizeof(TString));
   for (col = 0; col < A->colCount; col++)
      for (li = 0; li < novaA->rowCount; li++)
         SetCell(*A, col, li, newStringByLen(GetCell(*novaA, col, li)));

   for (li = 0; li < novaA->colCount * novaA->rowCount; li++)
      free(novaA->v[li]);
   free(novaA->v);
   novaA->colCount = A->colCount;
   novaA->v = A->v;

   TStringVector x = malloc(novaA->colCount * sizeof(TString));

   for (col = 0; col < novaA->colCount; col++) {
      x[col] = Pivot(col, *novaA, *novoB, *novaC);
   }

   return x

def Canonica(int coluna, TStringVector novaC, TMatriz novaA):
  int li, contador, pivo;
  if (FracCompare(novaC[coluna], "0"))
    return (-1);

  contador = 0;
  pivo = 0;
  for (li = 0; li < novaA.rowCount; li++)
    if (FracCompare(GetCell(novaA, coluna, li), "0")) {
      contador++;
      pivo = li;
    }

  if (contador != 1)
    return (-1);
  else if (FracCompare(GetCell(novaA, coluna, pivo), "1"))
    return (-1);
  else
    return pivo;

def Pivotear(int pcol, int pli, TMatriz * novaA, TMatriz * opNovaA, TStringVector * novoB,
         TStringVector * novaC, TString * novow0, TStringVector * opNovaC, TPivotVector * pivotLoop):
  int li, col;
  TString temp, s;
  if (Canonica(pcol, *novaC, *novaA) == pli)
    return;

  s = GetCell(*novaA, pcol, pli);
  if (s[0] == '0')
    return;
  temp = newStringByLen(s);
  for (col = 0; col < opNovaA->colCount; col++) {
    s = GetCell(*opNovaA, col, pli);
    SetCell(*opNovaA, col, pli, FracDiv(s, temp));
    free(s);
  }
  for (col = 0; col < novaA->colCount; col++) {
    s = GetCell(*novaA, col, pli);
    SetCell(*novaA, col, pli, FracDiv(s, temp));
    free(s);
  }
  s = (*novoB)[pli];
  (*novoB)[pli] = FracDiv((*novoB)[pli], temp);
  free(s);
  free(temp);
  temp = newStringByLen((*novaC)[pcol]);
  for (col = 0; col < novaA->colCount; col++) {
    s = (*novaC)[col];
    (*novaC)[col] = FracbMenosAx((*novaC)[col], temp, GetCell(*novaA, col, pli));
    free(s);
  }

  s = *novow0;
  *novow0 = FracbMenosAx(*novow0, temp, (*novoB)[pli]);
  free(s);

  for (col = 0; col < novaA->rowCount; col++) {
    s = (*opNovaC)[col];
    (*opNovaC)[col] = FracbMenosAx((*opNovaC)[col], temp, GetCell(*opNovaA, col, pli));
    free(s);
  }

  for (li = 0; li < novaA->rowCount; li++)
    if (li != pli) {
      free(temp);
      temp = newStringByLen(GetCell(*novaA, pcol, li));
      if (temp[0] != '0') {
        for (col = 0; col < novaA->colCount; col++) {
          s = GetCell(*novaA, col, li);
          SetCell(*novaA, col, li, FracbMenosAx(s, temp, GetCell(*novaA, col, pli)));
          free(s);
        }

        s = (*novoB)[li];
        (*novoB)[li] = FracbMenosAx((*novoB)[li], temp, (*novoB)[pli]);
        free(s);
        for (col = 0; col < opNovaA->colCount; col++) {
          s = GetCell(*opNovaA, col, li);
          SetCell(*opNovaA, col, li, FracbMenosAx(s, temp, GetCell(*opNovaA, col, pli)));
          free(s);
        }
      }
    }

  pivotVectorLinesAdd(pcol, pli, pivotLoop);
  return

def Pivot(int coluna, TMatriz novaA, TStringVector novoB, TStringVector novaC):
  int li, contador, pivo;
  if (FracCompare(novaC[coluna], "0"))
    return newString("0", 1);
  contador = 0;
  pivo = 0;
  for (li = 0; li < novaA.rowCount; li++)
    if (FracCompare(GetCell(novaA, coluna, li), "0")) {
      contador++;
      pivo = li;
    }
  if (contador != 1)
    return newString("0", 1);
  else if (FracCompare(GetCell(novaA, coluna, pivo), "1"))
    return newString("0", 1);
  else {
    for (li = 0; li < coluna; li++)
      if (Canonica(li, novaC, novaA) == pivo)
        return newString("0", 1);

    return newStringByLen(novoB[pivo]);
  }

def pivotSearch(int col, int li, TPivotVector pivotLoop):
  int i;
  for (i = 0; i < pivotLoop.count; i++)
    if ((col == pivotLoop.lines[i].col) && (li == pivotLoop.lines[i].li))
      return true;

  return false; // nao achou

def pivotVectorLinesAdd(int col, int li, TPivotVector * pivotVector):
  TPivot * novaLines = malloc((pivotVector->count + 1) * sizeof(TPivot));
  int i;
  for (i = 0; i < pivotVector->count; i++)
    novaLines[i] = pivotVector->lines[i];
  if (pivotVector->count)
    free(pivotVector->lines);
  pivotVector->lines = novaLines;
  pivotVector->lines[pivotVector->count].col = col;
  pivotVector->lines[pivotVector->count].li = li;
  pivotVector->count++;
  return

def Primal(TStringVector * novaC, TMatriz * novaA, TStringVector * novoB, TPivotVector * pivotLoop,
    TMatriz * opNovaA, TString * novow0, TStringVector * opNovaC,
    TMatriz A, TStringVector b, TStringVector c, TPivotVector * pivotVector, int * contaAlteracoes):
  char flagSaida, alterou = false;
  int col, li;
  do {
    flagSaida = true;
    col = 0;
    if (! isILIMITADA(*novaA, *novoB, *novaC))
      if (! isINVIAVEL(*novaA, *novoB))
        if (! isOTIMA(A, *opNovaA, c, *opNovaC, b, *novaA, *novoB, *novaC)) {
          while (col < novaA->colCount) {
            if (FracCompare((*novaC)[col], "0") < 0) {
              if (EscolherLinha(&col, &li, *novaA, *novoB, *pivotLoop, *novaC)) {
              	if (contaAlteracoes) {
              	  int invcol = pivotColunaInversa(col, li, *novaC, *novaA);
	 			  pivotVectorLinesAdd(invcol, li, pivotVector);
	 			  (*contaAlteracoes)++;
				}
                Pivotear(col, li, novaA, opNovaA, novoB, novaC, novow0, opNovaC, pivotLoop);
                alterou = true;
                flagSaida = false;
                break;
              }
            }
            col++;
          }
    }
  } while (! flagSaida);

  return alterou;

def Dual(TStringVector * novaC, TMatriz * novaA, TStringVector * novoB, TPivotVector * pivotLoop,
    TMatriz * opNovaA, TString * novow0, TStringVector * opNovaC,
    TMatriz A, TStringVector b, TStringVector c, TPivotVector * pivotVector, int * contaAlteracoes):
  char flagSaida, alterou = false;
  int col, li;
  do {
    flagSaida = true;
    li = 0;
    if (! isILIMITADA(*novaA, *novoB, *novaC))
      if (! isINVIAVEL(*novaA, *novoB))
        if (! isOTIMA(A, *opNovaA, c, *opNovaC, b, *novaA, *novoB, *novaC)) {
          while (li < novaA->rowCount) {
            if (FracCompare((*novoB)[li], "0") < 0) {
              if (EscolherColuna(&col, &li, *novaA, *novoB, *pivotLoop, *novaC)) {
              	if (contaAlteracoes) {
              	  int invcol = pivotColunaInversa(col, li, *novaC, *novaA);
	 			  pivotVectorLinesAdd(invcol, li, pivotVector);
	 			  (*contaAlteracoes)++;
				}
                OpostoLinha(li, novaA, opNovaA, novoB);
                Pivotear(col, li, novaA, opNovaA, novoB, novaC, novow0, opNovaC, pivotLoop);
                alterou = true;
                flagSaida = false;
                break;
              }
            }
            li++;
          }
    }
  } while (! flagSaida);

  return alterou;

def OpostoLinha(int linha, TMatriz * novaA, TMatriz * opNovaA, TStringVector * novoB):
  int col;
  TString s;
  for (col = 0; col < novaA->colCount; col++) {
    s = FracOposto(GetCell(*novaA, col, linha));
    FreeCell(*novaA, col, linha);
    SetCell(*novaA, col, linha, s);
  }
  s = FracOposto((*novoB)[linha]);
  free((*novoB)[linha]);
  (*novoB)[linha] = s;
  for (col = 0; col < opNovaA->colCount; col++) {
    s = FracOposto(GetCell(*opNovaA, col, linha));
    FreeCell(*opNovaA, col, linha);
    SetCell(*opNovaA, col, linha, s);
  }
  return

def EscolherLinha(int * pcoluna, int * plinha, TMatriz novaA, TStringVector novoB,
      TPivotVector pivotLoop, TStringVector novaC):
  int minlinha;

  while (TudoZeroNoVetor(novaA.colCount, novaC)
     && (*pcoluna <= novaA.colCount - 1)
     && (Canonica(*pcoluna, novaC, novaA) >= 0))
    (*pcoluna)++;

  if (*pcoluna == novaA.colCount)
    return false;

  *plinha = 0;
  while (FracCompare(GetCell(novaA, *pcoluna, *plinha), "0") <= 0) {
    (*plinha)++;
    if (*plinha == novaA.rowCount)
    return false;
  }
  minlinha = *plinha;

  do {
    (*plinha)++;
    if (*plinha >= novaA.rowCount)
      break;
    if (FracCompare(GetCell(novaA, *pcoluna, *plinha), "0") <= 0)
      continue;

    TString s1 = FracDiv(novoB[*plinha], GetCell(novaA, *pcoluna, *plinha));
    TString s2 = FracAbs(s1);
    TString s3 = FracDiv(novoB[minlinha], GetCell(novaA, *pcoluna, minlinha));
    TString s4 = FracAbs(s3);

    if (FracCompare(s2, s4) < 0)
      if (! pivotSearch(*pcoluna, minlinha, pivotLoop))
        minlinha = *plinha;

    free(s1); free(s2); free(s3); free(s4);
  } while (true);

  *plinha = minlinha;
  return (*plinha < novaA.rowCount)
      && (FracCompare(GetCell(novaA, *pcoluna, *plinha), "0") > 0)
      && (! pivotSearch(*pcoluna, minlinha, pivotLoop));

def EscolherColuna(int * pcoluna, int * plinha, TMatriz novaA, TStringVector novoB,
      TPivotVector pivotLoop, TStringVector novaC):
  int mincoluna;

  while (TudoZeroNoVetor(novaA.rowCount, novoB)
     && (*plinha <= novaA.rowCount - 1))
    (*plinha)++;

  if (*plinha == novaA.rowCount)
    return false;

  *pcoluna = 0;
  while (FracCompare(GetCell(novaA, *pcoluna, *plinha), "0") >= 0) {
    (*pcoluna)++;
    if (*pcoluna == novaA.colCount)
    return false;
  }
  mincoluna = *pcoluna;

  do {
    (*pcoluna)++;
    if (*pcoluna >= novaA.colCount)
      break;
    if (FracCompare(GetCell(novaA, *pcoluna, *plinha), "0") >= 0)
      continue;

    TString s1 = FracDiv(novaC[*pcoluna], GetCell(novaA, *pcoluna, *plinha));
    TString s2 = FracAbs(s1);
    TString s3 = FracDiv(novaC[mincoluna], GetCell(novaA, mincoluna, *plinha));
    TString s4 = FracAbs(s3);

    if (FracCompare(s2, s4) > 0)
      if (! pivotSearch(mincoluna, *plinha, pivotLoop))
        mincoluna = *pcoluna;

    free(s1); free(s2); free(s3); free(s4);
  } while (true);

  *pcoluna = mincoluna;
  return (*pcoluna < novaA.colCount)
      && (FracCompare(GetCell(novaA, *pcoluna, *plinha), "0") < 0)
      && (! pivotSearch(mincoluna, *plinha, pivotLoop));

def isOTIMA(TMatriz A, TMatriz opNovaA, TStringVector c, TStringVector opNovaC, TStringVector b,
                TMatriz novaA, TStringVector novoB, TStringVector novaC):
  int col, li;
  TString s, s2, yTb;
  TStringVector cTMenosyTa, x;
  cTMenosyTa = malloc(A.colCount * sizeof(TString));

  for (li = 0; li < A.colCount; li++) {
    s = newString("0", 1);
    for (col = 0; col < opNovaA.rowCount; col++) {
      s2 = FracbMaisAx(s, opNovaC[col], GetCell(A, li, col));
      free(s);
      s = s2;
    }

    cTMenosyTa[li] = FracSub(c[li], s);
    if (FracCompare(cTMenosyTa[li], "0") > 0) {
      do {
        free(cTMenosyTa[li]);
        li--;
      } while (li >= 0);
      free(cTMenosyTa);
      free(s);
      return false;
    }
  }

  x = malloc(A.colCount * sizeof(TString));
  for (col = 0; col < A.colCount; col++) {
    x[col] = Pivot(col, novaA, novoB, novaC);
    if (FracCompare(x[col], "0") < 0) {
      do {
        free(x[col]);
        col--;
      } while (col >= 0);
      free(x);
      free(s);
      for (li = 0; li < novaA.colCount; li++)
        free(cTMenosyTa[li]);
      free(cTMenosyTa);
      return false;
    }
  }
  free(s);
  s = newString("0", 1);
  for (col = 0; col < A.colCount; col++) {
    s2 = FracbMaisAx(s, c[col], x[col]);
    free(s);
    s = s2;
  }
  yTb = newString("0", 1);
  for (col = 0; col < A.rowCount; col++) {
    s2 = FracbMaisAx(yTb, b[col], opNovaC[col]);
    free(yTb);
    yTb = s2;
  }
  if (FracCompare(s, yTb)) {
    for (li = 0; li < novaA.colCount; li++)
      free(x[li]);
    free(x);
    free(s);
    for (li = 0; li < novaA.colCount; li++)
      free(cTMenosyTa[li]);
    free(cTMenosyTa);
    free(yTb);
    return false;
  }
  char Result = true;
  for (li = 0; li < A.rowCount; li++) {
    free(s);
    s = newString("0", 1);
    for (col = 0; col < A.colCount; col++) {
      s2 = FracbMaisAx(s, GetCell(A, col, li), x[col]);
      free(s);
      s = s2;
    }
    if (FracCompare(s, b[li])) {
      Result = false;
      break;
    }
  }
  for (li = 0; li < novaA.colCount; li++)
    free(x[li]);
  free(x);
  free(s);
  for (li = 0; li < novaA.colCount; li++)
    free(cTMenosyTa[li]);
  free(cTMenosyTa);
  free(yTb);
  return Result;

def TudoZeroNoVetor(int rowCount, TStringVector vetor):
  int col;
  for (col = 0; col < rowCount; col++)
    if (FracCompare(vetor[col], "0"))
      return false;

  return true;
"""

# https://twitter.com/mathspiritual/status/1371110143807610883
def convolution(f, g, x, n, a):
   m = 10
   mm = my_int(power(2 * m - 1, n))
   dV = power(m, -n)
   soma = mp.zeros(a, 1)
   v = mp.zeros(n, 1)
   for j in range (0, n):
      v[j] = -m + 1
   hh = mp.zeros(n, 1)
   for i in range (0, mm):
      u = 1/m * v
      prod = dV
      for j in range (0, n):
         hh[j] = u[j]/(1 - mp.fabs(u[j]))
         prod = prod * mp.power(1 - mp.fabs(u[j]), -2)
      ff = f(x - hh)
      soma = soma + prod * ff.T * g(hh)

      v[n - 1] = v[n - 1] + 1
      j = 1
      while v[n - j] >= m:
         v[n - j] = -m + 1
         v[n - j - 1] = v[n - j - 1] + 1
         j = j + 1
         if n - j < 0:
            break
   return soma

# 2 x 3
def G(x):
   y = mp.exp(- x[0]*x[0] - x[1]*x[1])
   return mp.matrix([[y, y, y], [y, y, y]])

# 2 x 1
def H(x):
   y = mp.exp(- x[0]*x[0] - x[1]*x[1])
   return mp.matrix([y, y])

def g(x):
   return mp.matrix([mp.exp(- x[0]*x[0])])

mp.dps = 10
print("convolution 1 =", convolution(g, g, mp.matrix([0]), 1, 1))
print("convolution 2 =", convolution(G, H, mp.matrix([0, 0]), 2, 3))
for i in range (1, 10):
   print("B", i, "=", Bernoulli(i))
A = mp.matrix([[0, 1, 0], [0, 0, 1], [-24, -26, -9]])
m = Matrix(A)
V, D = m.jordan_form()
print("V =", V)
print("D =", D)
print("A =", V * D * mp.inverse(V))
B = mp.matrix([[1, 2, 3, 4], [11, -2, 3, -0.4], [2.1, 3.5, 7.3, -0.9]])
S, O2 = polar(B, 3, 4)
print(S)
print(O2)
Oh, Triang, dets = schmidt(S, 3, True)
print("det S1 =", dets)
print(S * O2)
B = mp.matrix([[1, 2, 3], [11, -2, 8], [0, -5, 6], [2.1, 3.5, 7.3]])
S, O2 = polar(B, 4, 3)
print(O2)
print(S)
Oh, Triang, dets = schmidt(S, 3, True)
print("det S2 =", dets)
print(O2 * S)
Delta = partial_schmidt(B, 4, 3)
print(Delta)
n = 100
B = mp.zeros(n, n)
for i in range (0, n):
   for j in range (0, n):
      B[i, j] = random.randrange(120)/10
      if random.randrange(2) == 0:
         B[i, j] = - B[i, j]
print("Now we're going to find the determinant of a 100 x 100 matrix:")
Oh, Triang, detb = schmidt(B, n, False)
print(Oh)
print(Triang)
print("det B =", detb)
print(Oh * Triang)
print("Now Cramer with 32 variables:")
n = 32
B = mp.zeros(n, n)
for i in range (0, n):
   for j in range (0, n):
      B[i, j] = random.randrange(120)/10
      if random.randrange(2) == 0:
         B[i, j] = - B[i, j]
v = mp.zeros(n, 1)
for i in range (0, n):
   v[i] = random.randrange(120)/10
   if random.randrange(2) == 0:
      v[i] = - v[i]
x = Cramer(B, v, n)
print("x =", x.T)
w = B * x - v
print("error =", w.T)

# Release 0.1 from 2021/Apr/11th
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.
