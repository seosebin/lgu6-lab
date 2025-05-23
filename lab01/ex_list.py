# ex_list.py

# shoplist = ['apple', 'mango', 'carrot', 'banana']
# print(shoplist)
# print(type(shoplist))

# print( list( range(5) ) )

# # for i in range(5):
# for i in list(range(5)):
#     print(i)

# ##########################################
# # 자주쓰는 기능
# ##########################################

# # 특정 위치값 변경
# shoplist[0] = 'melon'
# print(shoplist)

# # 마지막에 요소 추가
# shoplist.append('lego')
# print(shoplist)

# # 리스트나 시퀀스 추가
# shoplist.extend(['소고기', '닭고기'])
# print(shoplist)

# print(shoplist + ['소고기', '닭고기'])
# print(shoplist)

# # 제거 remove(value)
# shoplist.remove('소고기')
# print(shoplist)

# # 제거 del index
# del shoplist[0]
# print(shoplist)

# # index
# i = shoplist.index('banana')
# print(i)
# ##########################################

# # 리스트의 길이
# print(len(shoplist))

# # 빈리스트
# L = []

# # 정렬
# L = [3, 5, 2, 1, 0, 4]
# L.sort(reverse=True)
# print(L)


# L = [3, 5, 2, 1, 0, 4]
# L_sorted = sorted(L, reverse=True)
# print(L)
# print(L_sorted)


# ##############################################
# # 인덱싱과 슬라이싱
# #    0  1  2  3  4  5  6  7
# L = [1, 2, 3, 4, 5, 6, 7, 8]
# #   -8 -7 -6 -5 -4 -3 -2 -1
# print(L[3])

# # IndexError
# # print(L[8])

# i = -1
# print(L[i])

# # 슬라이싱
# # L[start:end:stride]
# print( L[1:3:1] )

# # 셋다 생략
# print(L[::])

# # start,stride 생략
# print(L[:3])

# # end, stride 생략
# print(L[3:])

# # start,end 생략
# print(L[::2])

# # 음수인덱스를 사용한 슬라이싱
# print(L[-3:])
# print(L[-7:-4])

# # 음수인덱스를 이용해서 역순으로 슬라이싱
# print(L[-2:-6:-1])

# print(L[len(L)-3:])
# print(L[-3:])


#####################################
# 다른 자료형을 담고있는 리스트
L = [1, 'foo', True, 3.14, (1, 2)]
print(L)
t = L[4]
print(t[1])
print(L[4][1])


L = [[1,2,3],
     [4,5,6,7]]

print(L[0][3])
print(L[1][3])