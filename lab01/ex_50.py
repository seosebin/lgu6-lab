# ex_50.py

import random

class Linear:        #      3,          2
    def __init__(self, in_feature, out_feature):
        self.in_feature = in_feature
        self.out_feature = out_feature
        
        self.weight = [
            [random.random() for _ in range(out_feature)]
            for _ in range(in_feature)
        ]
        self.bias = [ random.random() for _ in range(out_feature) ]

    def matmul(self, A, B):
        # 행렬곱 A, B를 해서 결과 행렬 C를 반환
        row = len(A)
        col = len(B[0])
        C = []
        for i in range(row):
            temp = []
            for j in range(col):
                temp.append(0)
            C.append(temp)
        
        for i in range(len(A)):
            for j in range(len(B[0])):
                # A의 i행과 B의 j행을 내적
                for k in range(len(A[0])):
                    C[i][j] += A[i][k] * B[k][j]
        return C

    def forward(self, x):
        # x * self.weight + self.bias
        Z = self.matmul(x, self.weight)
        # [
        #     [3.825175258031387, 5.095947909552372], <--- i=0
        #     [9.722201604484098, 12.951142323117391] <--- i=1
        # ]         j = 0               j = 1 
        # bias : [b1, b2]
        # y = Z + self.bias
        # print(Z)
        for i in range(len(Z)): # 모든 입력 샘플 개수에 대해서
            for j in range(self.out_feature): # 모든 출력 위치에 대해서
                Z[i][j] = Z[i][j] + self.bias[j]
       
        return Z

linear = Linear(4, 2)
x = [ [1,2,3,1], 
      [4,5,6,1],
      [7,8,9,1] ]

print( linear.forward(x) ) # 결과는 2행 2열

################################################
# 확인용
import numpy as np

x_np = np.array(x)
W_np = np.array(linear.weight)
b_np = np.array(linear.bias)

y_np = np.dot(x_np, W_np) + b_np
print(y_np)