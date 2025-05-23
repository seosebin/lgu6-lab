# ex_36.py

# c = ai*bi
# a = [1,2,3,4]
# b = [4,5,6,7]

# c = 0
# for i in range(len(a)):
#     c += a[i]*b[i]

# print(c)

# A:(3,4), B:(4,2), C:(3,2)
A = [[1,0,1,2],
     [0,2,0,3],
     [1,2,1,7]]
B = [[2,3],
     [0,1],
     [1,1],
     [3,2]]

row = len(A)
col = len(B[0])
C = []
for i in range(row):
    temp = []
    for j in range(col):
        temp.append(0)
    C.append(temp)
# C = [[0,0],
#      [0,0],
#      [0,0]]

for i in range(len(A)):
    for j in range(len(B[0])):
        # A의 i행과 B의 j행을 내적
        for k in range(len(A[0])):
            C[i][j] += A[i][k] * B[k][j]

print(C)

    
