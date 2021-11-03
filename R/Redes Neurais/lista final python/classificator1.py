from mpmath import *
import csv
import numpy as np

mp.dps = 10
constante = 13017
comparar = 1

if comparar == 1:
   P = mp.zeros(constante,1)
   with open("V:\\sem backup\\_redes neurais 2021\\lista final\\parameters.csv", newline='') as f:
      reader = csv.reader(f, delimiter=',', quotechar='"')
      i = 0
      for row in reader:
         print(i)
         P[i] = mpf(row[0])
         i = i + 1
         #if i == 4:
         #   break
   A = np.zeros((constante,1))
   M = mp.zeros(constante,constante)
   B = mp.zeros(constante,1)
   with open("V:\\sem backup\\_redes neurais 2021\\lista final\\trainReduzido.csv", newline='') as f:
      reader = csv.reader(f, delimiter=',', quotechar='"')
      i = 0
      for row in reader:
         if i > 0:
            for j in range (0, 784):
               M[i-1,j] = int(row[j+2]) + 1
            B[i-1] = int(row[1])*1e9 - 3e9
            if B[i-1] < 0:
               B[i-1] = 1e9
            for j in range (0, 784):
               for k in range (2, 17):
                  M[i-1, (k-1)*784 + j] = M[i-1, j]**k
            for j in range (0, 472):
               M[i-1, 16*784 + j] = M[i-1, j]**17
            M[i-1, 13016] = 1
            A[i-1] = - B[i-1]
            for j in range (0, constante):
               A[i-1] = A[i-1] + M[i-1, j] * P[j]
            print("A[", i-1, "] =", A[i-1])
         i = i + 1
         #if i == 4:
         #   break
   print("vou salvar")
   with open('V:\\sem backup\\_redes neurais 2021\\lista final\\diferenca.csv', 'w', newline='') as f:
      writer = csv.writer(f, delimiter=',')
      writer.writerows(A)
else:
   M = np.zeros((constante,constante))
   B = np.zeros((constante,1))
   with open("V:\\sem backup\\_redes neurais 2021\\lista final\\trainReduzido.csv", newline='') as f:
      reader = csv.reader(f, delimiter=',', quotechar='"')
      i = 0
      for row in reader:
         print(i)
         if i > 0:
            for j in range (0, 784):
               M[i-1,j] = int(row[j+2]) + 1
            B[i-1] = int(row[1])*1e9 - 3e9
            if B[i-1] < 0:
               B[i-1] = 1e9
         i = i + 1
         #if i == 4:
         #   break
   for i in range (0, constante):
      print(i)
      for j in range (0, 784):
         for k in range (2, 17):
            M[i, (k-1)*784 + j] = M[i, j]**k
      for j in range (0, 472):
         M[i, 16*784 + j] = M[i, j]**17
      M[i, 13016] = 1
   print("agora solve")
   P, p2, p3, p4 = np.linalg.lstsq(M, B)
   print("vou salvar")
   with open('V:\\sem backup\\_redes neurais 2021\\lista final\\parameters.csv', 'w', newline='') as f:
      writer = csv.writer(f, delimiter=',')
      writer.writerows(P)
