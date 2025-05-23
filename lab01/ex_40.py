# ex-40.py
q = 0
r = 0 

def Qr(x, y):
    global q

    while True:
        x -= y
        if x > 0:
            q += 1
        elif x < 0:
            r = x + y
            break
        else:
            q += 1
            break

    return (q, r)

x = 10
y = 3

ret = Qr(x, y)
print(ret[0], ret[1])