# ex_38.py

data = [
    {'name': '철수', 'math': 85, 'eng': 90, 'sci':75},
    {'name': '준호', 'math': 73, 'eng': 85, 'sci':93},
    {'name': '영희', 'math': 82, 'eng': 88, 'sci':90}
]

result = {}

for d in data:
    # total = d['math'] + d['eng'] + d['sci']
    # avg = total/3
    total = 0
    count = 0
    for k, v in d.items():
        if k != 'name':
            total += v
            count += 1
    avg = total / count

    result[ d['name'] ] = [total, round(avg,4)]

print(result)