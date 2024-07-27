import std


//------------------------------------------------------------
// weird nilable type guard check
//------------------------------------------------------------
class Int:
    n:int

class A:
    x: Int?

    def check():
        return x != nil
    def func():
        if check(): // should be identical with bottom line
        // if x != nil:
            return x.n+1
        return 0

let a:A = A{nil}

print(a.func())
//------------------------------------------------------------
// the _ in _caller causes an error
//------------------------------------------------------------

class A:
    _caller = 1

    def func():
        print(_caller)
//------------------------------------------------------------
// function overloading
//
// i wana a shorter version of func
//------------------------------------------------------------
class test:
    def func(x:string, z=true)://util function
        print("1")
        func(x,x.substring(0, 1),z)

    def func(x:string, y:string, z=true):
        print("2")

let t = test{}
let str = "abc"
t.func(str,str.substring(0, 1),false)
t.func(str,false)//shortened version from above

//------------------------------------------------------------
// Contravariance
//error:
// scratch.lobster(14): error: `func2` (1st argument) requires type `[Parent]`, got `[Child]`
//   in scratch.lobster(11): func1(p_arr:[Child]) { }
//
// solution:
// replace [Child{}] with [Child{}]::Parent
// it forces the array to contain type Parent
// or 
// just put def func1(p_arr:[Parent]):
//------------------------------------------------------------

class Parent:
class Child: Parent

func1([Child{}])

def func1(p_arr):
    func2(p_arr)

def func2(p_arr: [Parent]):
    pass()

//------------------------------------------------------------
// enum types conflict with var
// quote from da man:
//"yes, not all possible combinations of symbol types are handled well.. recommend prefixing enum vals with their type, e.g. ph_action"
// scratch.lobster(12): error: illegal left hand side of assignment
// in: action += "foo"
// at: ^^^^^^
//------------------------------------------------------------
enum phase:
    action

var action = ""
action += "foo"
print(action)

//------------------------------------------------------------
// circular import 
// file A has an enum and class Game
// file B has a class Cards

// Game contains arr of cards
// each card contains ref of A
// in file A we import, in file B we forward declare
// however we still need the enum in file B


//------------------------------------------------------------
// class function name collisions
//

class A:
    def myfunc(x):
        pass()

class B:
    def myfunc(y, z=1):
        pass()
        pass()
//------------------------------------------------------------


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