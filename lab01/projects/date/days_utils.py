# BLANK
import random

# 각 월의 일수를 저장하는 리스트
MONTH_DAYS = (0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

# [!주의!] 이 함수의 코드를 수정하지 마세요
# 주어진 해가 평년인지 윤년인지 검사하는 함수
# 평년이면 365일, 윤년이면 366일
def is_leap_year(year):
    # 1700은 4의 배수, 100의 배수, 400의 배수 아니므로 평년
    # 1600은 4의 배수, 100의 배수, 400의 배수 이므로 윤년
    # 1996은 4의 배수, 100의 배수 아님, 400의 배수 아님 윤년
    if year %  4 == 0 and (year % 100 != 0 or year % 400 == 0):
        return True
    else:
        return False








#####################################################################      
# Mission 1 : 년도와 달을 입력받아 그 달의 날 수를 반환하는 함수를 완성하시오.
# 주어진 월의 총 일수를 반환하는 함수
# 단 이때 2월은 윤년이면 29, 평년이면 28을 반환해야 하므로 연도도 함께 전달 받음
# is_leap_year(year) 함수를 활용하시오.
# 함수가 완셩되었다면 이 파일을 메인 실행파일로 실행하여
# 1988년, 1995년에 대해서 제대로 된 결과를 출력하는지 확인하시오.
def get_month_days(year, month):
    # 달의 날짜 수에 +1해야되는 경우를 여기서 처리하시오.
    # if 문에서 year이 윤년인지는 이미 체크되고 있고 
    # month가 2월인지 추가로 체크하는 논리식을 and로 연결하시오.
    if is_leap_year(year) and None:
        # 이 함수가 전달받은 month 변수를 이용하여 
        # 모든 달의 날짜가 적혀있는 MONTH_DAYS에서 해당 달의 날짜를 
        # 조회 하시오.
        return MONTH_DAYS[None] + 1
    else:
        return MONTH_DAYS[None]
    







############################################################################################
# [!주의!] 이 함수의 코드를 수정하지 마시오.
# 무작위 날짜를 샘플링하는 함수
def sampling_days(test_term=60, from_next_year=False):
    # test_term: 앞 연도부터 몇년 간격안에서 샘플링할지 지정하는 숫자 기본 60년
    # from_next_year: 뒤 연도를 앞 연도 한해 후 부터 할지 아니면 앞 연도 부터 할지 지정

    birth_year = random.choice(range(1900, 2150))
    birth_month = random.choice(range(1,13))

    if birth_month == 2 and is_leap_year(birth_year):
        month_day = MONTH_DAYS[birth_month] + 1
    else:
        month_day = MONTH_DAYS[birth_month]

    birth_day = random.choice(range(1, month_day+1))

    # print(birth_year, birth_month, birth_day)

    year_delta = random.choice( range(1, test_term) )
    if from_next_year:
        cur_year = random.choice(range(birth_year+1, birth_year+year_delta+1))
    else:
        cur_year = random.choice(range(birth_year, birth_year+year_delta))

    if birth_year == cur_year:
        cur_month = random.choice( range(birth_month,13) )
    else:
        cur_month = random.choice(range(1,13))

    if birth_year == cur_year and birth_month == cur_month:
        if birth_month == 2 and is_leap_year(birth_year):
            cur_day = random.choice( range(birth_day, MONTH_DAYS[birth_month]+1+1) )
        else:
            cur_day = random.choice( range(birth_day, MONTH_DAYS[birth_month]+1) )
    else:
        if cur_month == 2 and is_leap_year(cur_year):
            cur_day = MONTH_DAYS[cur_month] + 1
        else:
            cur_day = MONTH_DAYS[cur_month]

    # print(cur_year, cur_month, cur_day)

    return birth_year, birth_month, birth_day, cur_year, cur_month, cur_day

if __name__ == '__main__':
    # 현재 이 파일을 python days_utils.py 로 실행하면 다음 두줄이 실행되면서
    # 두 출력의 결과는 29, 28, 29로 나와야 함.
    print('1988년 2월의 날수 ', get_month_days(1988, 2))
    print('1995년 2월의 날수 ', get_month_days(1995, 2))
    print('1996년 2월의 날수 ', get_month_days(1996, 2))

    # 두 출력의 결과는 31, 31, 31로 나와야 함.
    print('1988년 3월의 날수 ', get_month_days(1988, 3))
    print('1995년 3월의 날수 ', get_month_days(1995, 3))
    print('1996년 3월의 날수 ', get_month_days(1996, 3))