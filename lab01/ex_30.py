# ex_30.py

n = 5

# i    : 0, 1, 2, 3, 4
# 공백 : 4, 3, 2, 1, 0
# 별표 : 1, 3, 5, 7, 9

for i in range(n):
    star = ''
    space = ''

    # ex-29
    for j in range(n-i-1): # i=0, 1, 2, 3, 4
        space += ' '

    # ex-28
    for k in range(i*2+1):
        star += '*'

    row = space + star

    print(row)




for i in range(n):
    # ex-29
    for j in range(n-i-1): # i=0, 1, 2, 3, 4
        print(' ', end='')

    # ex-28
    for k in range(i*2+1):
        print('*', end='')

    print()


for i in range(n):
    print(f"{'*' * (i*2+1):^{n*2-1}}")