# ex_28.py

# 변수 이용
n = 5
for i in range(n):
    row = ''
    for j in range(i+1):
        row += '*'
    print(row)

# print() 옵션이용
for i in range(n):
    for j in range(i+1):
        print('*', end='')
    print()

# pythonic
for i in range(n):
    print('*'*(i+1))

