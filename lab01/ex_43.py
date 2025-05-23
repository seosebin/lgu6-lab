# ex_43.py

# def op(x, z, y):
#     return (x+y)*z

# x = 2
# y = 3
# z = 4

# # 위치 인자 방식 호출
# print( op(x, z, y) )
# print( op(x, y, z) )

# # 키워드 인자 방식 호출 
# print( op(x=x, y=y, z=z) )
# # def op(x, z, y):

# # 위치, 키워드 혼합 방식
# print( op(x, y=y, z=z) )

# 혼합할때 순서 잘못
# print( op(y=y, x, z) )

# def my_print(*args):
#     print(args, type(args))
# my_print('a', 'b', 'c')

# def my_print2(**kwargs):
#     print(kwargs, type(kwargs))
# my_print2(x='a', y='b', z='c')

def print_all(*args, **kwargs):
    print(args)
    print(kwargs)

print_all(1, 2, 3, 4, 5, 6, x=100, y=300, z=400)