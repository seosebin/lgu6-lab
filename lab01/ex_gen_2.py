# ex_gen_2.py

def fibonacci_dp(n):
    if n == 0:
        return [0]

    fib = [0] * (n+1)

    fib[0] = 0
    fib[1] = 1

    for i in range(2, n+1):
        fib[i] = fib[i-2] + fib[i-1]

    return fib


def fibonacci(n):
    a, b = 0, 1
    print(f"a: {a}, b: {b}")
    for _ in range(n+1):
        yield a
        a, b = b, a+b
        print(f"a: {a}, b: {b}")


n = 5
print( fibonacci_dp(n) )

print( list( fibonacci(n) ) )