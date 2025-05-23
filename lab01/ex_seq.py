# ex_seq.py

S = "python"
print(S[0])

# TypeError
# i = 123
# print(i[0])

for i in range(5):
    pass

for s in S:
    print(s)

# TypeError
# S[0] = 'P'

###############################
# tuple
###############################
i = 'x'

#         0           1          2
zoo = ('python', 'elephant', 'penguin')
print(zoo)
print(zoo[2])

# IndexError: tuple index out of range
# print(zoo[3])

# TypeError: tuple indices must be integers or slices, not str
print(zoo[i])

# TypeError: 'tuple' object does not support item assignment
# zoo[0] = 'lion'

sigleton = ('lion',)
print(type(sigleton))

# 패킹, 언패킹
numbers = 1, 2, 3
print(numbers)

i1 = numbers[0]
i2 = numbers[1]
i3 = numbers[2]

i1, i2, i3 = numbers