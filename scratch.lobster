import utils
import std

class A:
    x: int
    def operator-(a:A):
        return 2

class B<T>:
    y: T

    def hi(z):
        this.y = z
        return y

    def operator-(a:A)->B<T>:
        return 2
    def operator-(a:B<T>):
        return 2


let a: A = A{1}
let b = B<int>{1}
let c = B<int>{1}

let arr = []

// let rez = a-a
// print get_stack_trace()
print(a,b)
// let rez = b-a
// let rez = b-c
print b.hi(3)
// print rez