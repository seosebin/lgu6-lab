# ex_15.py

x = float(input("x: "))
mu = float(input("mu: "))
sigma = float(input("sigma: "))

e = 2.718
sqrt_2pi = 2.506
var = sigma*sigma

normal = (1 / (sigma*sqrt_2pi)) * e ** ( (-(x-mu)**2) / (2*var)  )
print(normal)
         