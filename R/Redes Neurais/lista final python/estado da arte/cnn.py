import tensorflow as tf
import numpy as np
from tensorflow.keras import optimizers
from sklearn.metrics import accuracy_score
import csv

from tensorflow.keras.datasets import mnist

#(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train = np.zeros((13017,28,28))
y_train = np.zeros(13017)
x_test = np.zeros((4000,28,28))
y_test = np.zeros(4000)
saida = np.zeros((4000,2))

with open("V:\\sem backup\\redes neurais 2021 prova 23 ago\\lista final 02 setembro\\dados\\trainReduzido.csv", newline='') as f:
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

with open("V:\\sem backup\\redes neurais 2021 prova 23 ago\\lista final 02 setembro\\dados\\validacao.csv", newline='') as f:
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

x_train, x_test = np.array(x_train, np.float32), np.array(x_test, np.float32)

x_train, x_test = x_train / 255-0.5, x_test / 255-0.5

y_train=tf.keras.utils.to_categorical(y_train,10)
y_test=tf.keras.utils.to_categorical(y_test,10)
x_train=np.expand_dims(x_train,axis=-1)
x_test=np.expand_dims(x_test,axis=-1)

def squeeze_excite_block2D(filters,input):                       # squeeze and exite is a good thing
    se = tf.keras.layers.GlobalAveragePooling2D()(input)
    se = tf.keras.layers.Reshape((1, filters))(se)
    se = tf.keras.layers.Dense(filters//32, activation='relu')(se)
    se = tf.keras.layers.Dense(filters, activation='sigmoid')(se)
    se = tf.keras.layers.multiply([input, se])
    return se

datagen = tf.keras.preprocessing.image.ImageDataGenerator(rotation_range=10, width_shift_range=0.1, shear_range=10,
                        height_shift_range=0.1, zoom_range=0.2)
datagen.fit(x_train)
datagen2 = tf.keras.preprocessing.image.ImageDataGenerator()
datagen2.fit(x_test)

def make_model():
        s = tf.keras.Input(shape=x_train.shape[1:])
        x = tf.keras.layers.Conv2D(128,(3,3),activation='relu',padding='same')(s)
        x = tf.keras.layers.Conv2D(128,(3,3),activation='relu',padding='same')(x)
        x = tf.keras.layers.Conv2D(128,(3,3),activation='relu',padding='same')(x)
        x = tf.keras.layers.BatchNormalization()(x)
        x = squeeze_excite_block2D(128,x)

        x = tf.keras.layers.Conv2D(128,(3,3),activation='relu',padding='same')(x)
        x = tf.keras.layers.Conv2D(128,(3,3),activation='relu',padding='same')(x)
        x = tf.keras.layers.Conv2D(128,(3,3),activation='relu',padding='same')(x)
        x = tf.keras.layers.BatchNormalization()(x)
        x = squeeze_excite_block2D(128,x)
        x = tf.keras.layers.AveragePooling2D(2)(x)


        x = tf.keras.layers.Conv2D(128,(3,3),activation='relu',padding='same')(x)
        x = tf.keras.layers.Conv2D(128,(3,3),activation='relu',padding='same')(x)
        x = tf.keras.layers.Conv2D(128,(3,3),activation='relu',padding='same')(x)
        x = tf.keras.layers.BatchNormalization()(x)
        x = squeeze_excite_block2D(128,x)
        x = tf.keras.layers.AveragePooling2D(2)(x)


        x = tf.keras.layers.concatenate([tf.keras.layers.GlobalMaxPooling2D()(x),
                                         tf.keras.layers.GlobalAveragePooling2D()(x)])

        x = tf.keras.layers.Dense(10,activation='softmax',use_bias=False,
                                  kernel_regularizer=tf.keras.regularizers.l1(0.00025))(x) # this make stacking better
        return tf.keras.Model(inputs=s, outputs=x)

batch_size=32
supermodel=[]
for i in range(20):
        np.random.seed(i)
        model=make_model()
        model.compile(optimizer=optimizers.Adam(lr=0.001), loss='categorical_crossentropy',metrics=['accuracy'])
        model.fit_generator(datagen.flow(x_train, y_train, batch_size=batch_size,shuffle=True),
                    steps_per_epoch=len(x_train) / batch_size, epochs=13,verbose=0)
        model.compile(optimizer=optimizers.Adam(lr=0.0001), loss='categorical_crossentropy',metrics=['accuracy'])
        model.fit_generator(datagen.flow(x_train, y_train, batch_size=batch_size,shuffle=True),
                    steps_per_epoch=len(x_train) / batch_size, epochs=3,verbose=0)
        model.compile(optimizer=optimizers.Adam(lr=0.00001), loss='categorical_crossentropy',metrics=['accuracy'])
        model.fit_generator(datagen.flow(x_train, y_train, batch_size=batch_size,shuffle=True),
                    steps_per_epoch=len(x_train) / batch_size, epochs=3,verbose=0)
        model.fit(x_train, y_train, batch_size=batch_size,shuffle=True, epochs=1,verbose=0)
        supermodel.append(model)
        print('********')
        print(i,'acc:',accuracy_score(np.argmax(y_test,axis=1),np.argmax(model.predict(x_test),axis=1)))

P=np.asarray([a.predict(x_test) for a in supermodel])

accuracy_score(np.argmax(y_test,axis=1),np.argmax(np.mean(P,axis=0),axis=1)) # 20 models stack accurasy

# after 15 run error was 0.16%,0.16%,0.18%,0.16%,0.17%,0.16%,0.18%,0.18%,0.17%,0.18%,0.16%,0.17%,0.18%,0.17%,0.17%

Z = np.argmax(model.predict(x_test),axis=1)

for i in range (0, 4000):
   saida[i,1] = Z[i]
saida = np.array(saida, int)

with open('V:\\sem backup\\redes neurais 2021 prova 23 ago\\lista final 02 setembro\\saida_estado_arte.csv', 'w', newline='') as f:
   writer = csv.writer(f, delimiter=',')
   writer.writerows(saida)
