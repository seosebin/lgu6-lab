# ex_46.py
import random, pprint

N = int(input("몇 게임? ㅋㅋ "))

def lottery_game():
    lottery = []

    while len(lottery) < 6:
        # 번호 뽑기
        n = random.randrange(1,46)

        # if not (n in lottery):
        if n not in lottery:
            lottery.append(n)

        # dup = False
        # for j in lottery:
        #     if n == j:
        #         dup = True
        
        # if dup == False:
        #     lottery.append(n)
    return lottery

pprint.pprint(
    [lottery_game() for _ in range(N)],
    width=50
)