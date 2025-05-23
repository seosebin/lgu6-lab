# ex_44.py

# 연산자와 해당하는 람다 함수를 딕셔너리에 직접 매핑
operations = {
    '+': lambda x, y: x + y,
    '-': lambda x, y: x - y,
    '*': lambda x, y: x * y,
    '/': lambda x, y: x / y if y != 0 else "오류: 0으로 나눌 수 없습니다"
}

# 두 수와 연산자를 사용자로부터 입력받고
# 입력된 연산을 operations를 이용하여 수행하기
# print( operations['+'](10,2) )

x = float(input("x: "))
y = float(input("y: "))
op = input("연산자(+, -, *, /): ")

if op in operations.keys(): #  ['+', '-', '*', '/']:
    result = operations[op](x, y)
    print(result)
else:
    print("올바른 연산이 아닙니다.")