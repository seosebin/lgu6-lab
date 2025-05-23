# ex_func.py

# def dummy():
#     print("I am a dummy function.")
#     print("end function")

# print( dummy() )

# # 모두 함수
# # print(), range(), int()
# # float(), bool(), type()

# def dummy2():
#     print('I am a dummy function2')
#     return 10

# print( dummy2() )
# r = dummy2()

# def add(a, b):
#     c = a + b
#     # print(c)c
#     return c

# c = add(1, 2)
# print(c)

#######################################

# x = 'global variable'

# def print_x():
#     print(x)
#     x = 'local variable'
#     print(x)

# print_x()
# print(x)


#############################
# 기본 인자
def greet(name, greeting="Hello"):
    print(f"{greeting}, {name}")

greet('홍길동', '안녕')
greet('홍길동')