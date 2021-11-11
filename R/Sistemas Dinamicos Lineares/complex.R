rm(list = ls())
gc()

z <- complex(real = 1, imaginary = 1)
w <- complex(real = 1, imaginary = -1)
t <- complex(real = 2, imaginary = -sqrt(3))
z <- z / w * t
Mod(z)^2

j <- complex(imaginary = 1)
