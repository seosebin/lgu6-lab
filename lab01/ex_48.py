# ex_48.py

# with open("file_w.txt", "w", encoding='utf-8') as f:
#     f.write("Hello Python\n")
#     f.write("안녕 파이썬")


# with open("file_w.txt", "r", encoding='utf-8') as f:
#     lines = f.readlines()
#     # print(lines, type(lines))
#     for line in lines:
#         print(line, end='')

import ex_45
import os

input_files = os.listdir('./data')

with open('ex_48.txt', 'w') as fw:
    for file in input_files:
        # print(file, type(file), file[-3:])
        if file[-3:] == 'txt':
            print(file)
                #   -5 -4 -3 -2 -1
            #    jisoo  .  t  x  t
            name = file[:-4]
            scores = []
            with open(f"./data/{file}", 'r', encoding='utf-8') as f:
                lines = f.readlines()
                # lines = int(lines)

                for line in lines:
                    scores.append( int(line) )
                
                print(scores)
            m = ex_45.mean(scores)
            sigma = ex_45.std(scores)

            fw.write(f"{name:>10}: {m}, {sigma}\n")








# if 1:


