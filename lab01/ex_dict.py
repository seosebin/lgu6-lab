# ex_dict.py

d = {}

d = {
    'foo': 'foo@naver.com',
    'bar': 'bar@gmail.com',
    'egg': 'egg@kakao.com'
}

print(d)

# d[0]
print(d['foo'])

# 값 삭제
del d['foo']
print(d)

# 새로운값 추가
d['foo'] = 'foo@naver.com'
print(d)

# 기존값 업데이트
d['foo'] = 'foo@kdt.co.kr'
print(d)

# 
d['list'] = [1,2,3,4,5]
print(d)

# print(d.keys())

# for key in d.keys():
#     print(d[key])

# for key in d:
#     print(d[key])

# for value in d.values():
#     print(value)

for key, value in d.items():
    print(key, value)