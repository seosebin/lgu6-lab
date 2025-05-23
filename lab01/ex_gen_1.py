# ex_gen_1.py

def get_number_generator(n):
    for i in range(n):
        # print("before yield")
        yield i
        # print("after yield")

# number = get_number_generator(3)
# print(next(number, 'end'))
# print()

# print(next(number, 'end'))
# print()

# print(next(number, 'end'))
# print()

# g = get_number_generator(10)

# for i in g:
#     print(i)


# 무한 제너레이터
def inf_number_gen():
    i = 1

    while True:
        yield i
        i += 1

g = inf_number_gen()
print(type(g))
print(next(g))
print(next(g))
print(next(g))
print(next(g))
