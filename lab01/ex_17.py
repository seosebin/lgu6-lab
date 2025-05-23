# ex_17.py

height = float(input("키(m): "))
weight = float(input("몸무게(kg): "))

bmi = round(weight / height**2, 3)

if bmi < 18.5:
    print("저체중", "BMI: ", bmi)
# elif 18.5 <= bmi and bmi < 23:
elif 18.5 <= bmi < 23:
    print("정상", "BMI: ", bmi)
# elif 23 <= bmi and bmi < 25:
elif 23 <= bmi < 25:
    print("과체중", "BMI: ", bmi)
else:
    print("비만", "BMI: ", bmi)

if bmi >= 25:
    print("비만", "BMI: ", bmi)
elif bmi >=23:
    print("과체중", "BMI: ", bmi)
elif bmi >=18.5:
    print("정상", "BMI: ", bmi)
else:
    print("저체중", "BMI: ", bmi)



# a = 0

# if a > 0:
#     print("positive")
# elif a < 0:
#     print("negative")
# else:
#     print("zero")

