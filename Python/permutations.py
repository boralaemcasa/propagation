from mpmath import *

def fatorial(x):
   result = 1
   while x > 1:
     result = result * x
     x = x - 1
   return result
   
def permutations(n):
   nfat = fatorial(n)
   mat = mp.zeros(nfat, n)
   for j in range (0, n):
      mat[0,j] = j + 1
   
   for i in range(1, nfat):
      for j in range (0, n):
         mat[i, j] = mat[i - 1, j]
      boo = True
      while (boo):
         mat[i, n - 1] = mat[i, n - 1] + 1
         j = 1
         while mat[i, n - j] > n:
            mat[i, n - j] = 1
            mat[i, n - j - 1] = mat[i, n - j - 1] + 1
            j = j + 1
            if j == n:
               break
         boo = False
         for j in range (0, n - 1):
            for k in range (j + 1, n):
               if mat[i, j] == mat[i, k]:
                  boo = True
                  break
   return mat
   
def decomposition(n, sigma):
   lista = list()
   for k in range (1, n + 1):
      boo = False
      for i in range (0, n):
         if sigma[i] == k:
            boo = True
            break
      if not boo:
         print("Error")
         return
   
   contador = 0
   for i in range (0, n - 1):
      if sigma[i] != i + 1:
         k = sigma[i] - 1
         sigma[i], sigma[k] = i + 1, k + 1
         s = "(" + str(i + 1) + ", " + str(k + 1) + ")"
         lista.insert(0, s)
         contador = contador + 1
         
   s = ""
   for cadaUm in lista:
     s = s + cadaUm
   print("sigma =", s)
   print("size =", contador)
   return

mp.dps = 10
mat = permutations(4)
print(mat)
decomposition(10, [6, 9, 7, 3, 10, 5, 1, 4, 8, 2])

# Release 0.1 from 2021/Fev/15
# Vinicius Claudino Ferraz @ Santa Luzia, MG, Brazil
# Out of charity, there is no salvation at all.
# With charity, there is Evolution.