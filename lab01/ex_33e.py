# ex_33e.py

# scores = [ [90, 85, 93], 
#            [78, 92, 89], ]

# # 지수의 수학 점수
# # print(scores[0][1])

# total_by_students = []
# # st: 0, 1, sb: 0, 1, 2
# # print(len(scores))
# for st in range(len(scores)):
#     # print(scores[st])
#     total = 0
#     for sb in range(len(scores[0])):
#         # print(scores[st][sb])
#         total += scores[st][sb]

#     total_by_students.append(total)

# print(total_by_students)


# total_by_subjects = []
# # sb: 0, 1, 2, st: 0, 1
# for sb in range(len(scores[0])):
#     total = 0
#     for st in range(len(scores)):
#         # print(scores[st][sb])
#         total += scores[st][sb]
#     # print()
#     total_by_subjects.append(total)

# print(total_by_subjects)

# ###############################################
# total_by_students = [0, 0]
# total_by_subjects = [0, 0, 0]
# for st in range(len(scores)):
#     for sb in range(len(scores[0])):
#         total_by_students[st] += scores[st][sb]
#         total_by_subjects[sb] += scores[st][sb]

# print(total_by_students)
# print(total_by_subjects)

####################################################

A = [[1, 2, 3], [4,5,6], [7,8,9]]
R = []

for row in A:
    temp = []
    for a in row:
        temp.append(a*2)
    print(temp)
    R.append(temp)

print(R)