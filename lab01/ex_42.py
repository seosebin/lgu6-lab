# ex_42.py

def mean(l):
    # l: List[int|float]
    S = 0
    # for x_k in l:
    #     S += x_k
    for k in range(len(l)):
        x_k = l[k]
        S += x_k
        
    N = len(l)
    m = S / N

    return m

X = [[78, 80, 95, 55, 67, 43], 
     [45, 67, 90, 87, 88, 93]]

AVG = [ round(mean(x),2)  for x in X ]

# AVG = []
# for x in X:
#     m = mean(x)
#     # print(m)
#     AVG.append( round(m,2)) 

print(AVG)
