# ex_37.py

en2ko = {
    'book': '책',
    'snake': '뱀',
    'language': '언어'
}

ko2en = {}

for k, v in en2ko.items():
    ko2en[v] = k

print(ko2en)