# ex_39.py

n = int(input("n: "))

# 1~n 리스트
# L = []
# for i in range(1, n+1):
#     L.append(i)
# [ 1,2,3,4,5,6,7,8,9,10 ]
L = [ i 
        for i in range(1, n+1) 
        if i % 2 == 0 
    ]


print(L)