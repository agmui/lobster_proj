import std


//------------------------------------------------------------
// circular refrance
// let a:Vertex = Vertex{"a", []}
// let b:Vertex = Vertex{"b", [a]}
// a.adj = [b]

//------------------------------------------------------------
// currying & weird printout
let fun1 = fn(v)->int: 1
def fun2():
    return fn(v): 
        assert 1==1
        let a = fun1(v)
        print("in func:",a)
        a
let f = fun2()//(v)
// let a = fun2()() //does not work

// weird thing when only the first one is uncommendted vs when both or just the second line
print("outside:",f(1))
// print(f(1))

//------------------------------------------------------------
//weird class thing


class Graph:
    def new_obj():
        // let rez = Graph()
        // return rez
        return Graph()

constructor Graph():
    return Graph{}

let G = Graph()
let x = G.new_obj()//ok
// G.new_obj() //not ok