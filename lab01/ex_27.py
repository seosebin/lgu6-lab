# ex_27.py

# for i in range(5):
#     # 구문들.....

#     for j in range(5):
#         print(i,j)

for i in range(2, 10):
    for j in range(1, 10):
        print(f"{i} x {j} = {i*j:>2}")
    
    if i < 9:
        print('-'*20)

