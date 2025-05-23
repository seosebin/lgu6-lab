# ex_34.py

numbers = [-10, -4, -5, -1, -6, -12, -40]

p = numbers[1::2]

S = 0
for i in range(len(p)):
    S += p[i]
print(S)

S = 0
for i in p:
    S += i
print(S)

print( sum(p) )

print( max(numbers) )

maximum = numbers[0]
# maximum = -1000000000000000
for i in numbers[1:]:
    if i > maximum:
        maximum = i
print(maximum)