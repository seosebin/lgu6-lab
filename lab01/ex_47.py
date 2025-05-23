# ex_47.py

import pandas as pd

df = pd.read_excel("./data/scores.xlsx")

# print(df, type(df))

df = df.T.to_dict() 
data = [v for k, v in df.items()]
print(data)

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
