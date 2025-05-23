# ex_32.py

teams = ['타이거즈', '라이온즈', '트윈스', '베어스', '위즈',
         '랜더스', '자이언츠', '이글스', '다이노스즈', '히어로즈']

# [주의] teams[team]이라고 인덱싱 하지 않기
for team in teams:
    print(teams.index(team)+1, team)

i = 1
for team in teams:
    print(i, team)
    i += 1 

for i, team  in enumerate(teams):
    print(f"{i+1}위 {team}")