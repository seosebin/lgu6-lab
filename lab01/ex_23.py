# ex_23.py
ID = "python"
PW = "abcd"

user_id = input("user_id: ")
if ID == user_id:
    user_pw = input("user_pw: ")
    if PW == user_pw:
        print("로그인 성공")
    else:
        print("비번이 틀렸습니다.")
else:
    print("그런 아이디는 존재하지 않습니다.")

