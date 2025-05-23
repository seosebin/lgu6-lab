# ex_29.py

n = 5
for i in range(n):
    row = ''
    for j in range(n-i): # i=0, 1, 2, 3, 4
        row += '*'
    print(row)

for i in range(n):
    for j in range(n-i): # i=0, 1, 2, 3, 4
        print('*', end='')
    print()

for i in range(n, 0, -1): # 5, 4, 3, 2, 1
    print('*' * i)