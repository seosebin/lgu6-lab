# ex_12.py
name = input("너의 이름")
kor = int(input("국어 점수: "))
eng = int(input("영어 점수: "))
mat = int(input("수학 점수: "))
sci = int(input("과학 점수: "))

total = kor + eng + mat + sci
mean = total / 4

print(f"{name}의 총점은 {total}이고 평균은 {mean}입니다.")