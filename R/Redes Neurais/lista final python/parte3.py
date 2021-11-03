#isso aqui tira a primeira coluna do R
from mpmath import *
import csv
import numpy as np

mp.dps = 10

P = np.zeros((4000,2))
with open("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro\\saida2.csv", newline='') as f:
   reader = csv.reader(f, delimiter=',', quotechar='"')
   i = 0
   for row in reader:
      print(i)
      if i > 0:
         P[i-1,0] = int(row[1])
         P[i-1,1] = int(row[2])
      i = i + 1
with open('V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro\\saida_python.csv', 'w', newline='') as f:
   writer = csv.writer(f, delimiter=',')
   writer.writerows(P)
