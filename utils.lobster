//TODO: make this for any type
let int2float = fn (val:int)->float: val+0.0

let cdr = fn arr: slice(arr,1,-1)

def print<T>(x:T,str_name:string):
    print(str_name+":", x)


def print(a, b, c):
    print "{a} {b} {c}"
def len<T>(xs:[T])->int:
    return length(xs)