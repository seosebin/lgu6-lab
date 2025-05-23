import subprocess, random
from datetime import date
from days_utils import MONTH_DAYS, get_month_days
from main import my_days

DIGIT_ERR_MSG = "숫자만 입력하세요."
YEAR_ERR_MSG = "현재 연도는 태어난 연도 보다 커야 합니다."
RESULT_MSG1 = "내가 계산한 날 수      :  "
RESULT_MSG2 = "datetime이 계산한 날 수:  "


def test_main(test_input, expected_output):
    process = subprocess.Popen(['python', 'main.py'], 
                               stdin=subprocess.PIPE, 
                               stdout=subprocess.PIPE, text=True)
    stdout, stderr = process.communicate(test_input)
    
    result = stdout.replace("태어난 연도를 입력: ", "").\
        replace("태어난 달을 입력: ", "").\
        replace("태어난 일을 입력: ", "").\
        replace("현재 연도를 입력: ", "").\
        replace("현재 달을 입력: ", "").\
        replace("현재 일을 입력: ", "").strip()
    
    return result == expected_output

def get_random_year():
    if random.random() < 0.3:
        year = str(random.randrange(10, 21)) + random.choice(['_', '.', ',', '@']) + str(random.randrange(10, 100))
    else:
        year = str(random.randrange(990, 2024))

    return year

def get_random_month():
    if random.random() < 0.3:
        month = str(random.randrange(1, 13)) + random.choice(['_', '.', ',', '@']) 
    else:
        month = str(random.randrange(1, 13))

    return month

def get_random_day(year, month):
    days = get_month_days(int(year), int(month))

    if random.random() < 0.3:
        day = str(random.randrange(1, days)) + random.choice(['_', '.', ',', '@']) 
    else:
        day = str(random.randrange(1, days))

    return day

def make_test_cases(n):
    cases = []
    for i in range(n):
        inputs = []
        outputs = []
        # year1
        while True:
            year1 = get_random_year()
            inputs.append(year1)
            if not year1.isdigit():
                outputs.append(DIGIT_ERR_MSG)
            else:
                outputs.append('')
                break

        # month1
        while True:
            month1 = get_random_month()
            inputs.append(month1)
            if not month1.isdigit():
                outputs.append(DIGIT_ERR_MSG)
            else:
                outputs.append('')
                break
        
        # day1
        while True:
            day1 = get_random_day(year1, month1)
            inputs.append(day1)
            if not day1.isdigit():
                outputs.append(DIGIT_ERR_MSG)
            else:
                outputs.append('')
                break
            
        # year2
        while True:
            year2 = get_random_year()
            inputs.append(year2)
            if not year2.isdigit():
                outputs.append(DIGIT_ERR_MSG)
            elif int(year2) <= int(year1):
                outputs.append(YEAR_ERR_MSG)
            else:
                outputs.append('')
                break
        
        # month2
        while True:
            month2 = get_random_month()
            inputs.append(month2)
            if not month2.isdigit():
                outputs.append(DIGIT_ERR_MSG)
            else:
                outputs.append('')
                break
        
        # day2
        while True:
            day2 = get_random_day(year2, month2)
            inputs.append(day2)
            if not day2.isdigit():
                outputs.append(DIGIT_ERR_MSG)
            else:
                outputs.append('')
                break


        cleaned_input = [ int(inputs[i]) for i, outmsg in enumerate(outputs) if outmsg == '' ]

        # 날짜 차이 계산
        my_delta = my_days(
            cleaned_input[0], cleaned_input[1], cleaned_input[2],
            cleaned_input[3], cleaned_input[4], cleaned_input[5]
        )
        # 날짜 차이 정답
        d1 = date(cleaned_input[0], cleaned_input[1], cleaned_input[2])
        d2 = date(cleaned_input[3], cleaned_input[4], cleaned_input[5])
        delta = (d2 - d1).days
    
        #cases.append([inputs, outputs, delta])
        # outputs에서 ''제거
        outputs = [x for x in outputs if x != '']

        cases.append( 
            ( 
                '\n'.join(inputs), # 일련의 입력
                ( '\n'.join(outputs)+'\n'+RESULT_MSG1+str(my_delta)+'\n'+RESULT_MSG2+str(delta) ).strip(), # 기대되는 출력
                cleaned_input
            )
        )

    return cases

            
test_cases = make_test_cases(10)

# test_cases = [
#     ('2012\n12\n1\n2013\n1\n30\n', '내가 계산한 날 수      :  60\ndatetime이 계산한 날 수:  60'),
#     ('1.2\n2012\n12\n1\n2011\n2013\n1\n30\n', '숫자만 입력하세요.\n현재 연도는 태어난 연도 보다 커야 합니다.\n내가 계산한 날 수      :  60\ndatetime이 계산한 날 수:  60'),
# ]

# Run tests
for i, (test_input, expected_output, cleaned_input) in enumerate(test_cases):
    if test_main(test_input, expected_output):
        test_input = test_input.replace('\n', '|')
        print(f"[PASS] Test case {i + 1}: {test_input}", cleaned_input)
    else:
        print(f"[FAIL] Test case {i + 1}")
        print(f"Test case {i+1}:", test_cases[i])
        break