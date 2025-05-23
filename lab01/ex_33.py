# ex_33.py

jisoo  = [90, 85, 93]
mansoo = [78, 92, 89]

total = []

# for i in len(jisoo):
# for i in range(jisoo):
for i in range(len(jisoo)):
    total.append( jisoo[i] + mansoo[i] )

# (), [], {} 내부에서 들여쓰기 무시
# total = [ 
#           jisoo[0] + mansoo[0], 
#           jisoo[1] + mansoo[1], 
#           jisoo[2] + mansoo[2] 
#         ]

print(total)

for i, score in enumerate(jisoo):
    # i = jisoo.index(score)

    score + mansoo[i]

