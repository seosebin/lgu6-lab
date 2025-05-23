# ex_cls.py

class Person:
    def __init__(self, name, height, weight):
        print('__init__')
        self.name = name
        self.height = height
        self.weight = weight

    def speed(self):
        return (self.height / self.weight) * 5


p1 = Person("Tom", 170, 100)
print(type(p1))
print(p1.name, p1.height, p1.weight)

p2 = Person("Kim", 180, 85)
print(p2.name, p2.height, p2.weight)

print( p1.speed() )
print( p2.speed() )

##############################################

p1d = {
    'name': 'Tom',
    'height': 170,
    'weight': 100
}
print(p1d['name'], p1d['height'], p1d['weight'])

def speed(d):
    return (d['height'] / d['weight']) * 5

print(speed(p1d))