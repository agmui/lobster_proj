import std
import dictionary
import utils

import testing
/*
This is a basic graph lib for lobster
Note:
all graphs are consider simple in this lib
so vertices do not point to them selfs 
*/

set_print_depth(3)
// namespace GraphTheory


class Edge

class Vertex:
    name: string
    adj: [Vertex]
    edge_indexes: [Edge]//TODO: fix


class Edge:
    u: Vertex?
    v: Vertex?
    weight: float

enum graph_classes:
    path        // P_n
    cycle       // C_n
    tree        // T acyclic & biparted (star, caliper, tree)
    clique      // K_n
    hypercube   // Q_n (n-cube) binary verts labeling with ham distance of 1 between each vert
    biparted    // K_n,m
    k_regular   // all verts have deg = k
    //wheel?    // W_n = C_n + K_1
    planer      // fits on a plane without crossing edges
    n_coloring  // there is an n coloring to the graph
    eulerian    // visits all edges once (can visit the same vert many times)
    hamiltonian // visits all verts once 

enum digraphs:
    tournament
    perfect

// multi graph idk?

class Graph<T>:
    private adj_matrix: [[T]]
    private V: [Vertex] 
    private E: [Edge]
    private vert2id: dictionary<Vertex,int>// = dictionary<Vertex,int>()
    private diam:int = 0


    def connected()->bool:
        return false
        //TODO: do this using the matrix
        // def DFS(v: Vertex, seen:[int]):
        //     let v_id:int = vert2id.get(v, -1) 
        //     check(v_id!=-1,"vertex {v.name} not in graph:\n{this.fmt()}")
        //     if seen[v_id]:
        //         return []
        //     seen[v_id] = 1
        //     map(v.adj):DFS((_), seen)
        //     return seen
        // var arr:[int] = map(V):0
        // DFS(V[0],arr)
        // return false

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
        let v_id: int = vert2id.get(v,-1)//FIXME: use instead of .get() []
        check(v_id!=-1,"vertex {v.name} not in graph:\n{this.fmt()}")
        // for(v.edge_indexes)e_id:
        //     remove(this.E, e_id)
        let new_arr:[[T]] = map(length(adj_matrix)-1): map(length(adj_matrix)-1):0// create 2D arr of 0's
        for (this.adj_matrix) r,i:
            for (r) c, j:
                if(i != v_id and j != v_id):
                    let past_i = i>=v_id
                    let past_j = j>=v_id
                    new_arr[i-past_i][j-past_j] = c
        this.adj_matrix = new_arr
        remove_obj(this.V, v)
        this.vert2id.del(v)
    
    def operator-(v:Vertex)->Graph<T>:
        let v_id: int = vert2id.get(v,-1)//FIXME: use instead of .get() []
        check(v_id!=-1,"vertex {v.name} not in graph:\n{this.fmt()}")
        let new_arr:[[T]] = map(length(adj_matrix)-1): map(length(adj_matrix)-1):0// create 2D arr of 0's
        for (this.adj_matrix) r,i:
            for (r) c, j:
                if(i != v_id and j != v_id):
                    let past_i = i>=v_id
                    let past_j = j>=v_id
                    new_arr[i-past_i][j-past_j] = c
        let new_V:[Vertex] = deepcopy(filter(V):_==v,2) // TODO: check if removed v
        let new_E:[Edge] = deepcopy(E,2)//TODO: remove edges
        let new_dict = dictionary<Vertex,int>(length(new_V))
        for(new_V)new_v,i: 
            new_dict.add(new_v,i)
        let ret = Graph(new_arr, new_V,new_E,new_dict)
        return ret
    
    def operator-()->Graph<T>:
        return this
        
    
    def complement():
        pass()
        
    def tortis_and_hare():
        pass()
        
    def geodesic():
        pass()
    
    def prim():
        pass()

    def kruskal():
        pass()

    def MST():
        pass()
    
    //do longest shortest path
    def long_short_path():
        pass()

    def floyed():
        pass()
    
    // find min number of colors to color the graph
    def X():
        pass()
    
    def fmt()->string:
        // return sum(map(adj_matrix)i:
        //     if i == int(inf): "i\n" else: "{i}\n")
        return sum(
            map(adj_matrix)row:
                "[ "+ sum(map(row)e:
                            if e==int(inf): "I " else: "{e} ") +"]\n")


    def del():
        for (V)vert:
            vert.adj = []





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

def V<T>(G:Graph<T>)->[Vertex]:
    return G.V
def E<T>(G:Graph<T>)->Graph<T>:
    return G.E
    
constructor Graph<T>(adj_matrix:[[T]]):
    //TODO: check for negitive vals and is square
    let rez = exists(adj_matrix):exists(_)e: e<0
    // let g = fn guard(rez):
    check(rez,"graph has negative edges")

    let edges:[Edge] = map(filter(flatten(adj_matrix))i:i!=0 and i!=int(inf)):Edge{nil,nil,_}
    let verts:[Vertex] = map(length(adj_matrix)):Vertex{string(_), [], []}
    let dict = dictionary<Vertex,int>(length(verts))
    for(verts)v,i: 
        dict.add(v,i)
    for(verts)v,i://TODO: merge with top code
        for(adj_matrix[i])vert_val,j:
            if vert_val!= 0 and vert_val != int(inf):
                push(v.adj,verts[j])
                // push(v.edge_indexes,j)
    return Graph<T> {
        adj_matrix, 
        verts,
        edges,
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


print G.fmt()
let v:Vertex = V(G)[1]
print v
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
print(G2.fmt())


G.del(v)
print(G.fmt())

// run_test("Graph tests"):
//     do():
//         let G_test = Graph([[0,1,int(inf)],
//                 [1,0,1],
//                 [int(inf),1,0] ])

//         assert G_test.connected() == true
//         let v_test = G_test.get_verts()[0]
//         print G_test-v_test


clear_verts(G)