# ex_str.py

# s = "Hello Python"
# print(s)

# s = 'Hello Python'
# print(s)

# s = "Hello \"EASY\" Python"
# print(s)

# s = 'Hello "EASY" Python'
# print(s)

# s = 'Hello,\n "EASY" Python'
# print(s)
# print(type(s))

# s = """Hello,
#        "EASY" Python
# """
# print(s)

# ############################
# # F-string
# ############################
# a = 10.0
# b = 20.0
# c = a * b
# # print('c:', c, 'SUCCESS')
# # print(f"c: {c} SUCCESS")
# print(f"{a1:5.2f} x {b:5.2f} = {c:.3f}")


# d = 5.2
# e = 21.234
# f = d * e
# print(f"{d:5.2f} x {e:5.2f} = {f:.3f}")

# a = "hello"
# print(f"{a:_^15}")

s = "python,python"
print(type(s))

# count()
print( s.count('python') )

# find()
print( s.find('p') ) # 처음만나는 p의 인덱스
print( s.find('x') ) # 없으면 -1

# replace()
print( s.replace('python', 'PYTHON') )
print( s )

# split()
print( s.split() ) # 기본값은 ' '
print( s.split(',') )
 
# join()
L = ['python', 'java', 'c++']
print( ', '.join(L) )

# strip()
s = " python \n\t"
print(f'|{s.strip()}|')

s = "@<python>!"
print(f"|{s.strip('<>@!')}|")

# isdigit(), isalpha(), isalnum()
s = "123"
print( s.isdigit() )

print( s.isalpha() )

print( s.isalnum() )

# upper(), lower()
s = 'PyThOn'
print(s.upper())
print(s.lower())