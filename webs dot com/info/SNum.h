#include "stdlib.h"
#include "strings.h"

typedef
  struct {
    char * n, *d;
  } SFrac;

#define false 0
#define true  1

//String uteis
  char* newString(char * s, int tamanho);
  void delete(char* s, int pos, int qtde);
  void leftConcat(char *a, char *b);
  void charLeftConcat(char c, char * b);
  void Copy(char * destino, char *s, int partir, int qtde);
  char * copy(char *s, int partir, int qtde);
  int pos(char sub, char * s);
  void ZeroLTrim(char *s);

  char* Valida(char* s);
  char* FracValida(char* s);

//as fun�oes abaixo j� partem de q as strings sao v�lidas
  char* Soma(char* y, char *z);
  char* Subtrai(char* y, char *z);
  char* Multiplica(char* a, char *b);
  void  Divide(char * alinha, char * blinha, char * q, char *r);
  char* Potencia(char* a, char *b);
  char* mdc(char * x, char * y);

  char* SNumAbs(char* a);
  short SNumCompare(char* a, char *b);
  char* SNumOposto(char *s);

//fra�oes
  SFrac Str2Frac(char *x);
  void  FracReduz(char *x);

  char* FracAdd(char *x, char *y);
  char* FracSub(char *x, char *y);
  char* FracMul(char *x, char *y);
  char* FracDiv(char *x, char *y);
  char* FracOposto(char *s);
  short FracCompare(char *x, char *y);
  char* FracAbs(char *a);

//IMPLEMENTATION
  
  char* newString(char * s, int tamanho) {
    char * Result = malloc(tamanho + 1);
    strcpy(Result, s);
    return Result;
  }
  void delete(char* s, int pos, int qtde) {      
    int i;
    for(i = pos - 1; s[i]; i++)
      s[i] = s[i + qtde];
  }
  void leftConcat(char *a, char *b) {
    int i = strlen(b);
    int j = strlen(a);
    for (; i >= 0; i--)
      b[i + j] = b[i];
    for(i = 0; i < j; i++)
      b[i] = a[i];
  }
  void charLeftConcat(char c, char * b) {
    char letra[2];
    letra[0] = c;
    letra[1] = 0;
    leftConcat(letra, b);
  }
  void Copy(char * destino, char *s, int partir, int qtde) {
    int i;
    for (i = 0; i <= qtde - 1; i++)
      destino[i] = s[partir - 1 + i];
    destino[qtde] = 0;
  }
  char * copy(char *s, int partir, int qtde) {
    char * Result = newString("", qtde);
    Copy(Result, s, partir, qtde);
    return Result;
  }
  int pos(char sub, char * s) {
    int i = 0;
    while (s[i] && (s[i] != sub))
      i++;
    if (s[i] == sub)
      return i;
    else return 0;
  }

void ZeroLTrim(char *s) {
  while ((s[0] == '0') && (s[1] != '/'))
    delete(s, 1, 1);
}

char* Soma(char* y, char *z) {
  if (y[0] == '0')
    return newString(z, strlen(z));
  if (z[0] == '0')
    return newString(y, strlen(y));
  
  int i, x;
  char carry, minus, *Result;

  i = strlen(y);
  x = strlen(z);
  if (x > i)
    i = x;
  char * a = newString(y, i);
  char * b = newString(z, i);

  minus = false;
  if (a[0] == '-') {
    delete(a, 1, 1);
    if (b[0] == '-') {
      delete(b, 1, 1);
      // -a + (-b) == -(a + b)
      minus = true;
    } else {
    // -a + b == b - a
      Result = Subtrai(b, a);
      free(a);
      free(b);
      return Result;
    }
  } else if (b[0] == '-') {
    delete(b, 1, 1);
    // a + (-b) == a - b
    Result = Subtrai(a, b);
    free(a);
    free(b);
    return Result;
  }

  if (strlen(a) > strlen(b)) {
    Result = a;
    a = b;
    b = Result;
  }

  x = strlen(b);
  while (strlen(a) < x)
    leftConcat("0", a);

//008765
//123400
  i = x;
  while ((i > 1) && (b[i-1] == '0'))
    i--;

  Result = malloc(x + 3);
  Copy(Result, a, i + 1, x - i);
  delete(a, i + 1, x - i);
  delete(b, i + 1, x - i);

  carry = 0;
  for (; i >= 1; i--) {
    x = a[i-1] - 48 + b[i-1] - 48 + carry;
    if (x >= 10) {
      carry = 1;
      x -= 10;
    } else carry = 0;
    charLeftConcat(x + 48, Result);
  }
  if (carry != 0)
     leftConcat("1", Result);
  if (minus)
     leftConcat("-", Result);
     
  free(a);
  free(b);
  return Result;
}

char* Subtrai(char* y, char *z) {
  if (y[0] == '0')
    return SNumOposto(z);
  if (z[0] == '0')
    return newString(y, strlen(y));
  if (! strcmp(y, z))
    return newString("0", 1);
  
  int i, x;
  char carry, *Result;

  i = strlen(y);
  x = strlen(z);
  if (x > i)
    i = x;
  char * a = newString(y, i);
  char * b = newString(z, i);

  if (a[0] == '-') {
    delete(a, 1, 1);
    if (b[0] == '-') {
      delete(b, 1, 1);
      // -a - (-b) == b - a
      Result = Subtrai(b, a);
      free(a);
      free(b);
      return Result;
    } else {
    // -a - b == -(a + b)
      char * c = Soma(a, b);
      Result = newString(c, strlen(c) + 1);
      leftConcat("-", Result);
      free(a);
      free(b);
      free(c);
      return Result;
    }
  } else if (b[0] == '-') {
    delete(b, 1, 1);
    // a - (-b) == a + b
    Result = Soma(a, b);
    free(a);
    free(b);
    return Result;
  } else if (SNumCompare(a, b) < 0) {
  // a < b ==> a - b == -(b - a)
    char * c = Subtrai(b, a);
    Result = newString(c, strlen(c) + 1);
    leftConcat("-", Result);
    free(a);
    free(b);
    free(c);
    return Result;
  }
// 923
// 199
   x = strlen(a);
   while (strlen(b) < x)
     leftConcat("0", b);
   Result = newString("", x);
   carry = 0;
   for (i = strlen(a); i >= 1; i--) {
     x = a[i-1] - 48 - b[i-1] + 48 - carry;
     if (x < 0) {
       carry = 1;
       x += 10;
     } else carry = 0;
     charLeftConcat(x + 48, Result);
   }

  ZeroLTrim(Result);
  free(a);
  free(b);
  return Result;
}

char* Multiplica(char* y, char *z) {
  if ((y[0] == '0') || (z[0] == '0'))
    return newString("0", 1);
  if (! strcmp(y, "1"))
    return newString(z, strlen(z));
  if (! strcmp(z, "1"))
    return newString(y, strlen(y));
  if (! strcmp(y, "-1"))
    return SNumOposto(z);
  if (! strcmp(z, "-1"))
    return SNumOposto(y);
  int i, j;
  char x, carry, minus, * subtotal, * Result;
  char ** multAlgarismo = malloc(10 * sizeof(char*));

  char * a = newString(y, strlen(y));
  char * b = newString(z, strlen(z));

  minus = (a[0] == '-');
  if (minus) delete(a, 1, 1);
  if (b[0] == '-') {
    delete(b, 1, 1);
    minus = ! minus;
  }

  for (i = 2; i <= 9; i++) {
    multAlgarismo[i] = newString("", strlen(a) + 1);
    carry = 0;

  // multiplicar i por cada algarismo de a
    for (j = strlen(a); j >= 1; j--) {
      x = (a[j-1] - 48) * i + carry;
      carry = x / 10;
      x = x % 10;
      charLeftConcat(x + 48, multAlgarismo[i]);
    }

    if (carry != 0)
      charLeftConcat(carry + 48, multAlgarismo[i]);
  }

  subtotal = newString("", strlen(a) + strlen(b));
  Result = newString("0", 1);
  for (i = strlen(b); i >= 1; i--)
    if (b[i-1] != '0') {
      subtotal[0] = 0;
      // zeros aa direita
      if (i < strlen(b))
        for (j = 1; j <= strlen(b) - i; j++)
          leftConcat("0", subtotal);

      if (b[i-1] == '1')
        leftConcat(a, subtotal);
      else leftConcat(multAlgarismo[b[i-1] - 48], subtotal);

      // o Resultado � a soma dos subtotais
      char * sigma = Soma(Result, subtotal);
      free(Result);
      Result = sigma;
    }

  ZeroLTrim(Result);

  free(subtotal);
  if (minus && (strcmp(Result, "0") != 0)) {
    subtotal = newString(Result, strlen(Result) + 1);
    free(Result);
    Result = subtotal;
    leftConcat("-", Result);   
  }
      
  free(a);
  free(b);
  for (i = 2; i <= 9; i++)
    free(multAlgarismo[i]);
  free(multAlgarismo);
      
  return Result;
}

// alocar para q: strlen(a) + 1
//        para r: strlen(b) + 2
void Divide(char * alinha, char * blinha, char * q, char *r) {
  if (! strcmp(blinha, "0")) {
    strcpy(q, "0");
    strcpy(r, "0");
    return;
  }
  if (alinha[0] == '0') {
    strcpy(q, "0");
    strcpy(r, "0");
    return;
  }
  if (! strcmp(blinha, "1")) {
    strcpy(q, alinha);
    strcpy(r, "0");
    return;
  }
  if (! strcmp(alinha, blinha)) {
    strcpy(q, "1");
    strcpy(r, "0");
    return;
  }
  char * a = SNumOposto(alinha);
  if (! strcmp(a, blinha)) {
    strcpy(q, "-1");
    strcpy(r, "0");
    free(a);
    return;
  }
  if (! strcmp(blinha, "-1")) {
    strcpy(q, a);
    strcpy(r, "0");
    free(a);
    return;
  }
  
  char minusa, minusb, x;
  int index;

  free(a);
  a = newString(alinha, strlen(alinha));
  char * b = newString(blinha, strlen(blinha));

  minusa = (a[0] == '-');
  minusb = (b[0] == '-');
  if (minusa) delete(a, 1, 1);
  if (minusb) delete(b, 1, 1);

  q[0] = 0;
  index = strlen(b);
  Copy(r, a, 1, index);
  do {   
    x = 0;
    while (SNumCompare(r, b) >= 0) {
      x++;
      char * rr = Subtrai(r, b);
      strcpy(r, rr);
      free(rr);
    }
    q[strlen(q) + 1] = 0;
    q[strlen(q)] = x + 48;
    if (index >= strlen(a)) break;

    // "baixar" o pr�ximo
    index++;
    if (! strcmp(r, "0")) r[0] = 0; // zero de resto nao vai virar zero aa esq
    r[strlen(r) + 1] = 0;
    r[strlen(r)] = a[index-1];
  } while (true);

  ZeroLTrim(q);

//  7 /  4 == ( 1, 3)     a < 0, r > 0:  incrementar o m�dulo do quociente
// -7 /  4 == (-2, 1)                   complementar o resto
//  7 / -4 == (-1, 3)     exatamente um negativo: sinal '-' no quociente
// -7 / -4 == ( 2, 1)
  if (minusa && (strcmp(r, "0") != 0)) {
    char * qq = Soma(q, "1");
    char * rr = Subtrai(b, r);
    strcpy(q, qq);
    strcpy(r, rr);
    free(qq);
    free(rr);
  }
  if ((minusa && (! minusb)) || ((! minusa) && minusb))
    leftConcat("-", q);
      
  free(a);
  free(b);
}

char * SNumOposto(char *s) {
  char * Result; 
      
  if (s[0] == '0') {
    Result = newString("0", 1);
  }
  else if (s[0] == '-') {
    Result = newString(s, strlen(s));  
    delete(Result, 1, 1);
  }
  else {
    Result = newString(s, strlen(s) + 1);
    leftConcat("-", Result);
  }

  return Result;
}

char* SNumAbs(char * a) {
  if (a[0] != '-')
    return newString(a, strlen(a));
  else
    return SNumOposto(a);
}

char* FracAbs(char* a) {
  if (a[0] != '-')
    return newString(a, strlen(a));
  else
    return FracOposto(a);
}

char * Potencia(char * a, char * b) {
  char * Result, * n;
  n = newString(b, strlen(b));  
  
  if ((n[0] == '0') || (n[0] == '-'))
    Result = newString("1", 1);
  else {
    Result = newString(a, strlen(a));
    while (strcmp(n, "1")) {
      char * rr = Multiplica(Result, a);
      char * nn = Subtrai(n, "1");
      free(Result);
      free(n);
      Result = rr;
      n = nn;      
    }
  }
  free(n);
  return Result;
} 

char * FracAdd(char * x, char * y) {
  if (x[0] == '0')
    return newString(y, strlen(y));
  if (y[0] == '0')
    return newString(x, strlen(x));
  if ((! pos('/', x)) && (! pos('/', y)))
    return Soma(x, y);
  
  SFrac a, b;
  char* Result;
  a = Str2Frac(x);
  b = Str2Frac(y);
  char * anbd = Multiplica(a.n, b.d);
  char * adbn = Multiplica(a.d, b.n);
  char * adbd = Multiplica(a.d, b.d);
  char * s = Soma(anbd, adbn);
  Result = newString(s, strlen(s) + 1 + strlen(adbd));
  Result[strlen(Result) + 1] = 0;
  Result[strlen(Result)] = '/';
  strcat(Result, adbd);
  
  FracReduz(Result);
  free(anbd);
  free(adbn);
  free(adbd);
  free(s);
  free(a.n);  free(a.d);
  free(b.n);  free(b.d);
  return Result;
}

char * FracSub(char * x, char * y) {
  if (x[0] == '0')
    return FracOposto(y);
  if (y[0] == '0')
    return newString(x, strlen(x));
  if (! strcmp(x, y))
    return newString("0", 1);
  if ((! pos('/', x)) && (! pos('/', y)))
    return Subtrai(x, y);
  SFrac a, b;
  char* Result;
  a = Str2Frac(x);
  b = Str2Frac(y);
  char * bn = SNumOposto(b.n);
  free(b.n);
  b.n = bn;
  char * anbd = Multiplica(a.n, b.d);
  char * adbn = Multiplica(a.d, b.n);
  char * adbd = Multiplica(a.d, b.d);
  char * s = Soma(anbd, adbn);
  Result = newString(s, strlen(s) + 1 + strlen(adbd));
  Result[strlen(Result) + 1] = 0;
  Result[strlen(Result)] = '/';
  strcat(Result, adbd);
  
  FracReduz(Result);
  free(anbd);
  free(adbn);
  free(adbd);
  free(s);
  free(a.n);  free(a.d);
  free(b.n);  free(b.d);
  return Result;
}

char * FracMul(char * x, char * y) {
  if ((x[0] == '0') || (y[0] == '0'))
    return newString("0", 1);
  if (! strcmp(x, "1"))
    return newString(y, strlen(y));
  if (! strcmp(y, "1"))
    return newString(x, strlen(x));
  if (! strcmp(x, "-1"))
    return FracOposto(y);
  if (! strcmp(y, "-1"))
    return FracOposto(x);
  if ((! pos('/', x)) && (! pos('/', y)))
    return Multiplica(x, y);
  
  SFrac a, b;
  char* Result;
  a = Str2Frac(x);
  b = Str2Frac(y);
  char * anbn = Multiplica(a.n, b.n);
  char * adbd = Multiplica(a.d, b.d);
  
  Result = newString(anbn, strlen(anbn) + 1 + strlen(adbd));
  Result[strlen(Result) + 1] = 0;
  Result[strlen(Result)] = '/';
  strcat(Result, adbd);
  
  FracReduz(Result);
  free(anbn);
  free(adbd);
  free(a.n);  free(a.d);
  free(b.n);  free(b.d);
  return Result;
}

char * FracDiv(char * x, char * y) {
  if (! strcmp(y, "1"))
    return newString(x, strlen(x));
  if (! strcmp(y, "-1"))
    return FracOposto(x);
  if ((x[0] == '0') || (y[0] == '0'))
    return newString("0", 1);
  if (! strcmp(x, y))
    return newString("1", 1);
  
  SFrac a, b;
  char* Result;
  a = Str2Frac(x);
  b = Str2Frac(y);
  char * aux = b.n;
  b.n = b.d;
  b.d = aux;
  if (b.d[0] == '-') {
    char * bn = SNumOposto(b.n);
    char * bd = SNumOposto(b.d);
    free(b.n);
    free(b.d);
    b.n = bn;
    b.d = bd;
  }

  char * anbn = Multiplica(a.n, b.n);
  char * adbd = Multiplica(a.d, b.d);
  
  Result = newString(anbn, strlen(anbn) + 1 + strlen(adbd));
  Result[strlen(Result) + 1] = 0;
  Result[strlen(Result)] = '/';
  strcat(Result, adbd);
  
  FracReduz(Result);
  free(anbn);
  free(adbd);
  free(a.n);  free(a.d);
  free(b.n);  free(b.d);
  return Result;
}

void FracReduz(char * x) {
  if (! pos('/', x))
    return;
    
  SFrac a, b;
  char *m, *r;

  a = Str2Frac(x);
  m = mdc(a.n, a.d);
  if (strcmp(m, "1")) {
    b.n = newString("", strlen(a.n));
    b.d = newString("", strlen(a.d));
    r = newString("", strlen(m) + 1);
    Divide(a.n, m, b.n, r);
    Divide(a.d, m, b.d, r);
    free(r);

    strcpy(x, b.n);
    if (strcmp(b.d, "1")) {
      x[strlen(x) + 1] = 0;
      x[strlen(x)] = '/';
    strcat(x, b.d);
    }
    free(b.n); free(b.d);  
  }
  else if (! strcmp(a.d, "1"))
    strcpy(x, a.n);
  
  free(m);
  free(a.n); free(a.d);
}

char * Valida(char * s) {
  char * Result;
  int i = 1;
  if (s[0] == 0) return newString("0", 1);
  Result = newString(s, strlen(s));
  if (Result[0] == '-') i++;
  while (i <= strlen(Result)) {
    if ((Result[i-1] >= '0') && (Result[i-1] <= '9'))
      i++;
    else delete(Result, i, 1);
  }

  ZeroLTrim(Result);
  if (strcmp(Result, "-0") == 0)
    strcpy(Result, "0");
     
  return Result;
}

char * FracValida(char *s) {
  char * Result;
  int i = 1;
  
  if (s[0] == '0') return newString("0", 1);
  Result = newString(s, strlen(s));
  if (Result[0] == '-') i++;
  while (i <= strlen(Result)) {
    if ((Result[i-1] >= '0') && (Result[i-1] <= '9') || (Result[i-1] == '/'))
      i++;
    else delete(Result, i, 1);
  }

  if ((Result[0] == '-') && (Result[1] == '0'))
    delete(Result, 1, 1);

  i = pos('/', Result);
  if (i > 0)
    Result[i] = 32;

  i = 1;
  if (Result[0] == '-') i++;
  while (i <= strlen(Result)) {
    if ((Result[i-1] >= '0') && (Result[i-1] <= '9') || (Result[i-1] == 32))
      i++;
    else delete(Result, i, 1);
  }

  i = pos(32, Result);
  if (i > 0)
    Result[i] = '/';

  ZeroLTrim(Result);
  FracReduz(Result);
  return Result;
}

short SNumCompare(char* a, char *b) {
  char minus;
  short Result = 0;
  if (! strcmp(a, b)) return Result;
  minus = false;
  if (a[0] == '-')
    if (b[0] == '-')
      minus = true;
    else Result = -1;
  else if (b[0] == '-')
    Result = -1;

  if (Result) return Result;

  if (b[0] == '0')
    return 1;
  if (a[0] == '0')
    return -1;

  int tamanho1 = strlen(a);
  int tamanho2 = strlen(b);
  if (tamanho2 > tamanho1)
    tamanho1 = tamanho2;
     
  char * alinha = newString(a, tamanho1);
  char * blinha = newString(b, tamanho1);

  if (minus) {
    delete(alinha, 1, 1);
    delete(blinha, 1, 1);
  }

  while (strlen(blinha) < strlen(alinha))
    leftConcat("0", blinha);
  while (strlen(alinha) < strlen(blinha))
    leftConcat("0", alinha);

// positivos
  if (strcmp(alinha, blinha) > 0)
    Result = 1;
  else Result = -1;

// negativos inverte
  if (minus) Result = - Result;
  free(alinha);
  free(blinha);
  return Result;
}

SFrac Str2Frac(char * x) {
  SFrac Result;
  int i = pos('/', x);
  if (i > 0) {
    Result.n = copy(x, 1, i);
    Result.d = newString(x, strlen(x));
    delete(Result.d, 1, i + 1);
  }
  else {
    Result.n = newString(x, strlen(x));
    Result.d = newString("1", 1);
  }
  return Result;
}

char* mdc(char *x, char *y) {
  char * q, * r;

  if (x[0] == '0')
    return newString(y, strlen(y));

  if (y[0] == '0')
    return newString(x, strlen(x));

  char * xx, * yy;

  xx = SNumAbs(x);
  yy = SNumAbs(y);
  
  if (SNumCompare(yy, xx) > 0) {
    q = xx;
    xx = yy;
    yy = q;
  }

  do {
    q = newString("", strlen(xx));
    r = newString("", strlen(yy) + 1);
    Divide(xx, yy, q, r);
    free(q);
    if ((! strcmp(r, "1")) || (! strcmp(r, "0"))) 
      break;  
    strcpy(xx, yy);
    strcpy(yy, r);
    free(r);
  } while (true);

  free(xx);

  if (! strcmp(r, "1")) {
    free(r);
    free(yy);
    return newString("1", 1);
  }
  else {
    free(r);
    char * z = newString(yy, strlen(yy));
    free(yy);
    return z;
  }
}

char * FracOposto(char * s) {
  return SNumOposto(s); // apelei
/*    
  char * Result;
  SFrac a = Str2Frac(s);
  char * an = SNumOposto(a.n);
  free(a.n);
  a.n = an;
  if (strcmp(a.d, "1") == 0)
    Result = newString(a.n, strlen(a.n));
  else {
    Result = newString(a.n, strlen(a.n) + 1 + strlen(a.d));
    Result[strlen(Result) + 1] = 0;
    Result[strlen(Result)] = '/';
    strcat(Result, a.d);
  }
  free(a.n);  free(a.d);
  return Result;
*/
}

short FracCompare(char *x, char *y) {
  if (y[0] == '0') {
    if (x[0] == '0')
      return 0;
    else if (x[0] == '-')
      return -1;
    else
      return 1;
  }
  
  if ((! pos('/', x)) && (! pos('/', y)))
    return SNumCompare(x, y);

  char * dif = FracSub(x, y);
  SFrac s = Str2Frac(dif);
  short Result = SNumCompare(s.n, "0");
  free(s.n);  free(s.d);
  free(dif);
  return Result;
}