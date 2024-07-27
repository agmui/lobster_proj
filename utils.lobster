import terminal_colors

//TODO: make this for any type

let cdr = fn arr: slice(arr,1,-1)
let cons = fn x, arr: insert(arr, 0, x)

// def print<T>(x:T,str_name:string):
//     print(str_name+":", x)


def print(a, b, c):
    print "{a} {b} {c}"
def print(a, b, c, d):
    print "{a} {b} {c} {d}"
def print(a, b, c, d, e):
    print "{a} {b} {c} {d} {e}"

def len<T>(xs:[T])->int:
    return length(xs)

def round(x,i):
    pass()

def error(a):
    print(RED+"ERROR: "+a+reset)

def remove_substring(str, start, end):
    return substring(str, 0, start)+substring(str, end+1, str.length-end-1)

def hprint<T>(arr:[[T]], min_pad_size=5,colum_size=2):
    var biggest = arr[0].len()
    for(arr)a:
        if biggest < a.len():
            biggest = a.len()
    
    let longest_char = max(map(arr)a: max(map(a)c: string(c).length))
    let pad_size = max(longest_char, min_pad_size)

    let pad = fn len: repeat_string(" ", len)
    var str = ""
    for(biggest)i:
        for(arr)a:
            if i < a.len:
                let c = string(a[i])
                str += BLUHB
                str += c
                str += pad(pad_size-c.strip_ansi_code.length)//repeat_string(" ", pad_size - c.length)// pad with spaces
                str += reset
            else:
                str += pad(pad_size) //repeat_string(" ", pad_size)
            str += pad(colum_size) //repeat_string(" ", colum_size)
        str +="\n"
    print(str)