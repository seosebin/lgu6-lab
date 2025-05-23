# ex_18.py

number = int(input("숫자: "))
if number <= 0:
    print("양수 입력하라고..")
else:
    count = 0
    # print(f"while 이전: number:{number}, count:{count}")
    
    while number > 0:
        print('현재 숫자: ', number)
        number -= 1
        count += 1
        # print(f"while 안: number:{number}, count:{count}")

    print('반복 횟수:', count)
        