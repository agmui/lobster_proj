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
    private adj_matrix: [[T]]
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
        print v
        print this.fmt()
        let v_id: int = vert2id.get(v,-1)//FIXME: use instead of .get() []
        let new_arr:[[T]] = map(length(adj_matrix)-1): map(length(adj_matrix)-1):0// create 2D arr of 0's
        for (this.adj_matrix) r,i:
            for (r) c, j:
                if(i != v_id and j != v_id):
                    let past_i = i>=v_id
                    let past_j = j>=v_id
                    new_arr[i-past_i][j-past_j] = c
        let new_V:[Vertex] = deepcopy(V,2)
        let new_E:[Edge] = deepcopy(E,2)
        let new_dict = deepcopy(vert2id,2)
        new_dict.del(v)
        let ret = Graph(new_arr, new_V,new_E,new_dict)
        return ret
    
    def operator-()->Graph<T>:
        return this
        
    
    def complement():
        pass()
        
    def tortis_and_hare():
        pass()
        
    
    //do longest shortest path
    def long_short_path():
        pass()

    def floyed():
        pass()
    
    def fmt()->string:
        // return sum(map(adj_matrix)i:
        //     if i == int(inf): "i\n" else: "{i}\n")
        return sum(
            map(adj_matrix)row:
                "[ "+ sum(map(row)e:
                            if e==int(inf): "I " else: "{e} ") +"]\n")






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

def V<T>(G:Graph<T>)->Graph<T>:
    return G.V
def E<T>(G:Graph<T>)->Graph<T>:
    return G.E
    
constructor Graph<T>(adj_matrix:[[T]]):
    //TODO: check for negitive vals and is square
    let rez = exists(adj_matrix):exists(_)e: e<0
    // let g = fn guard(rez):
    check(rez,"graph has negative edges")
    let verts:[Vertex] = map(length(adj_matrix)):Vertex{string(_), []}
    for(verts)v,i://TODO: merge with top code
        for(adj_matrix[i])vert_val,j:
            if vert_val!= 0 and vert_val != int(inf):
                push(v.adj,string(j))
    let dict = dictionary<Vertex,int>(length(adj_matrix))
    for(verts)v,i: 
        dict.add(v,i)
    return Graph<T> {
        adj_matrix, 
        verts,
        map(flatten(adj_matrix)):Edge{nil,nil,_},
        dict
    }




// constructor Graph(adj_matrix:[[int]]):
//     let float_adj_matrix = map(matrix):map(_a,int2float)
//     return Graph (float_adj_matrix)


constructor Graph<T>(adj_matrix:[[T]], V:[Vertex], E:[Edge], dict: dictionary<Vertex, int>):
    return Graph<T>{adj_matrix,V,E,dict}


let G = Graph([[0,1,int(inf)],
               [1,0,1],
               [int(inf),1,0] ])


// print G.fmt()
let v:Vertex = G.get_verts()[1]
// print get_stack_trace()

// print v.adj
// print ""
// print G.vert2id.get_keys()

// G.del(v)
// let f = deg(G)//(v)
// print("a:",f(v))
// print deg(G)(v)
// print deg(v)
// print -G



// deg(G,v)
// deg(G,"a")
let G2 = G-v
// G.del(v)

print(G2.fmt())

/*
run_test("Graph tests"):
    let G: Graph = Graph([[1,1],[1,1]])
    assert G.connected() == true
    let v = G.get_verts()[0]
    print G-v
    */
