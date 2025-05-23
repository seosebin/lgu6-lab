# ex_45.py
import math

# ex_41.py
def mean(l):
    # l: List[int|float]
    S = 0
    for k in range(len(l)):
        x_k = l[k]
        S += x_k

    N = len(l)
    m = S / N

    return m

def std(l):
    m = mean(l)
    # S = 0
    # for x_k in l:
    #     S += (x_k - m)**2
    # var = S / len(l)
    var = mean([ (x_k - m)**2 for x_k in l ])
    sigma = math.sqrt(var) 
    return sigma


L = [1,2,3,4,5,6,7,8,9,10]
print(std(L))