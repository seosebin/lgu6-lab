# SOLUTION
from days_utils import *
from main import *

num_test = 100000
increment = num_test // 10

incorrect = 0
for i in range(num_test):
    birth_year, birth_month, birth_day, cur_year, cur_month, cur_day = sampling_days(test_term=150, from_next_year=True)
    a = my_days(birth_year, birth_month, birth_day, cur_year, cur_month, cur_day)
    b = true_days(birth_year, birth_month, birth_day, cur_year, cur_month, cur_day)
    
    if (i + 1) % increment == 0:
        # calculate the percentage completed
        percent_complete = (i + 1) / num_test * 100
        # print the progress
        print(f"{percent_complete:.0f}% complete")
              
    if a != b:
        print(a, b)
        print("다음 경우 검증 통과 못함")
        print(birth_year, birth_month, birth_day, cur_year, cur_month, cur_day)
        incorrect += 1

    
print(f'{num_test}개 중 {incorrect}개 통과 못함')



