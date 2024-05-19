import std

// let x = 1
// let y = 1
// let z = 1

// print(x)
// print(x,y,z)
// print(x, y, z)
// print x
// print(1)
// print(1,2,3)
// print 1

let logging = fn something: print get_stack_trace()
def test_log():
    let x = 1
    let y = 1
    // test_log(x)
    logging(y)
    // print get_stack_trace() 
    x+1

test_log()