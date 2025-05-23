lang1 = "Python"
lang2 = "C++"
lang3 = "Java"
lang4 = "Pascal"

author1 = "Guido van Rossum"
author2 = "Bjarne Stroustrup"
author3 = "Jame Gosling"
author4 = "Niklaus Wirth"

sep = " : "

print("#"* 25)
# print(lang1 + sep + author1)
print(lang1, author1, sep=sep) 
print(lang2, author2, sep=sep)
print(lang3, author3, sep=sep)
print(lang4, author4, sep=sep)
print("#"* 25)

print("#"* 27)
print(f"{lang1:>7}{sep}{author1}")
print(f"{lang2:>7}{sep}{author2}")
print(f"{lang3:>7}{sep}{author3}")
print(f"{lang4:>7}{sep}{author4}")
print("#"* 27)