import std
import dictionary
import utils

import testing

set_print_depth(3)
// namespace GraphTheory

class Vertex:
    name: string
    adj: [string]//[Vertex]
    //TODO: maybe add id field?


class Edge:
    u: Vertex?
    v: Vertex?
    weight: float

class Graph<T>:
    private matrix: [[T]]
    private V: [Vertex] 
    private E: [Edge]
    private vert2id: dictionary<Vertex,int>// = dictionary<Vertex,int>()

    def connected()->bool:
        return false

    def prim():
        pass()
    
    def order()->int:
        return length(V)

    def size()->int:
        return length(E)

    def get_verts():
        return V
    
    def add():
        pass()

    def del(v:Vertex):
        //TODO: check if v is in G
        // print vert2id.get(v, -1)
        pass() 
    
    def operator-(v:Vertex)->Graph<T>:
        let v_id: int = vert2id.get(v,-1)//FIXME: []
        let new_arr:[[T]] = map(length(matrix)-1):map(_a):0// create 2D arr of 0's
        for (new_arr) r,i:
            for (r) c, j:
                if(i!= v_id or j != v_id):
                    new_arr[i][j] = c
        let new_V:[Vertex] = deepcopy(V,2)
        let new_E:[Edge] = deepcopy(E,2)
        let new_dict = deepcopy(vert2id,2)
        new_dict.del(v)
        let ret = Graph(new_arr, new_V,new_E,new_dict)
        return ret
        
        
        
    
    //do longest shortest path
    def long_short_path():
        pass()

    def floyed():
        pass()
    
    def fmt()->string:
        return sum(map(matrix): "{_}\n")






let deg_ = fn(v:Vertex)->int: length(v.adj)//if v.adj != nil: length(v.adj) else: -1
def deg(v:Vertex)->int:
    return deg_(v)
def deg<T>(G:Graph<T>):
    return fn(v:Vertex): 
        // assert 1==1
        deg_(v)
def deg(G, v:Vertex)->int:
    return -1
def deg(G, v:string)->int:
    return -1
    
constructor Graph<T>(matrix:[[T]]):
    // guard map()//TODO: check for negitive vals and is square
    let verts:[Vertex] = map(length(matrix)):Vertex{string(_), []}
    for(verts)v,i://TODO: merge with top code
        v.adj = map( filter(matrix[i]):_a!=round(inf) and _a!=0): verts[_].name
        // print(map(filter(matrix[i]): _a!=round(inf) and _a!=0): verts[_])
    let dict = dictionary<Vertex,int>(length(matrix))
    for(verts)v,i: 
        dict.add(v,i)
    return Graph<T> {
        matrix, 
        verts,
        map(flatten(matrix)):Edge{nil,nil,_},
        dict
    }




// constructor Graph(matrix:[[int]]):
//     let float_matrix = map(matrix):map(_a,int2float)
//     return Graph (float_matrix)


constructor Graph<T>(matrix:[[T]], V:[Vertex], E:[Edge], dict: dictionary<Vertex, int>):
    return Graph<T>{matrix,V,E,dict}


let G = Graph([[0,1,int(inf)],
               [1,0,1],
               [int(inf),1,0] ])



// print G.fmt()
let v:Vertex = G.get_verts()[1]
// print get_stack_trace()

print v.adj
// print G.vert2id.get_keys()

// G.del(v)
// let f = deg(G)//(v)
// print("a:",f(v))
// print deg(G)(v)
// print deg(v)



// deg(G,v)
// deg(G,"a")
// let G2 = G-v
// G.del(v)

/*
run_test("Graph tests"):
    let G: Graph = Graph([[1,1],[1,1]])
    assert G.connected() == true
    let v = G.get_verts()[0]
    print G-v
    */