//TODO: make this for any type
let int2float = fn (val:int)->float: val+0.0

let cdr = fn arr: slice(arr,1,-1)

def print(a, b, c):
    print "{a} {b} {c}"