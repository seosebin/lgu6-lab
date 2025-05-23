# ex_49.py

class BankAccount:
    def __init__(self, owner, passwd, balance=0):
        self.owner = owner
        self.balance = balance
        self.passwd = passwd
        print(f"{owner}님의 계좌가 잔액 {balance}원으로 개설되었습니다.")

    def deposit(self, amount):
        if amount > 0:
            self.balance += amount
            print(f"{amount}원이 입금되었습니다.")
        else:
            print("0보다 큰 금액을 입금해주세요.")

    def withdraw(self, amount):
        if 0 < amount <= self.balance:
            self.balance -= amount
            print(f"{amount}원이 출금되었습니다.")
        else:
            print("출금 금액이 잔액을 초과하거나 잘못되었습니다.")

    def get_balance(self):
        pw = input("비번을 입력하세요: ")
        if self.passwd == pw:
            print(f"계좌의 현재 잔액은 {self.balance}원입니다.")
        else:
            print("비번 오류")

    def remittance(self, amount, account):
        print(f"{account.owner}님 계좌료 {amount}원 송금합니다.")
        
        # amount 만큼 금액 차감
        self.withdraw(amount)

        # amount만큼 account에 입금
        account.deposit(amount)



# 계좌생성
account1 = BankAccount("홍길동",  '1234', 10000)
account1.deposit(5000)
account1.get_balance()

account1.withdraw(3000)
account1.get_balance()

account2 = BankAccount("김길동", '0000', 1000000)
account2.get_balance()

account2.remittance(500000, account1)
account1.get_balance()