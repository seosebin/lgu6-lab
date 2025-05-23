password = "1234"
success = False

for t in range(5):
    user_pw = input("PW: ")

    if user_pw == password:
        print("로그인 성공")
        success = True
        break
    else:
        print("다시 입력하세요.")
# else:
    # print("잠금")


# 잠글지 말지    
if success == False:
    print("잠금")