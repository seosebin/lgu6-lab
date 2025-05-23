# ex_22.py
n = int(input("n: "))

S = 0
for i in range(1, n+1):
    print(f"합산 전 S:{S},i:{i}")
    S += i
    print(f"합산 후 S:{S},i:{i}")
    print("============================")

print(S)