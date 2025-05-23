# ex_51.py
import ex_45

s = input("평균을 구할 숫자 입력하세요(콤마 또는 공백으로 구분): ")
print(s)
print(
    ex_45.mean(
        [ int(i) for i in s.replace(',', ' ').split() ]
    )
)