from keras.datasets import mnist
import numpy as np
from RMDL import RMDL_Image as RMDL
import csv
from keras.callbacks import ModelCheckpoint

#(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train = np.zeros((13017,28,28))
y_train = np.zeros(13017)
x_test = np.zeros((4000,28,28))
y_test = np.zeros(4000)
saida = np.zeros((4000,2))

with open("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro\\trainReduzido.csv", newline='') as f:
   reader = csv.reader(f, delimiter=',', quotechar='"')
   i = 0
   for row in reader:
      print(i)
      if i > 0:
         j = 2
         y_train[i-1] = int(row[1])
         for u in range (0, 28):
            for v in range (0, 28):
               x_train[i-1,u,v] = int(row[j])
               j = j + 1
      i = i + 1

with open("V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro\\validacao.csv", newline='') as f:
   reader = csv.reader(f, delimiter=',', quotechar='"')
   i = 0
   for row in reader:
      print(i)
      if i > 0:
         j = 1
         #y_test[i-1] = int(row[1])
         saida[i-1] = int(row[0])
         for u in range (0, 28):
            for v in range (0, 28):
               x_test[i-1,u,v] = int(row[j])
               j = j + 1
      i = i + 1

print("ok")

x_train_D = x_train.reshape(x_train.shape[0], 28, 28, 1).astype('float32')
x_test_D = x_test.reshape(x_test.shape[0], 28, 28, 1).astype('float32')
x_train = x_train_D / 255.0
x_test = x_test_D / 255.0
number_of_classes = np.unique(y_train).shape[0]
shape = (28, 28, 1)

ModelCheckpoint(
    filepath='v:\\a.a',
    save_weights_only=True,
    monitor='val_acc',
    mode='max',
    save_best_only=True)

batch_size = 128
sparse_categorical = 0
n_epochs = [10, 5, 4]  ## 100 DNN-RNN-CNN
Random_Deep = [3, 3, 3]  ## 5 min + 1 hour + 12 hours. DNN-RNN-CNN

Z = RMDL.Image_Classification(x_train, y_train, x_test, y_test,shape,
                     batch_size=batch_size,
                     sparse_categorical=True,
                     random_deep=Random_Deep,
                     epochs=n_epochs)

for i in range (0, 4000):
   saida[i,1] = Z[i]
saida = np.array(saida, int)

with open('V:\\sem backup\\_redes neurais 2021 prova 23 ago\\lista final 02 setembro\\saida_estado_arte.csv', 'w', newline='') as f:
   writer = csv.writer(f, delimiter=',')
   writer.writerows(saida)
