import std
import dictionary
import utils

import testing

set_print_depth(3)

class Edge

class Vertex:
    name: string
    edge_indexes: [Edge]


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
    // eulerian trail
    eulerian    // visits all edges once (can visit the same vert many times)
    // hamiltonian path
    hamiltonian // visits all verts once 
    k_edge      // k-edge connected

enum digraphs:
    tournament
    perfect

// multi graph idk?


abstract class Graph:
    diam:int = -1
    /* stuff maybe to add:
    * ISOMORPHIC
    * bridges
    * cut verts
    * components
    * nonseparable
    * edge-cycle
    * blocks
    * vert-cut/minimal/minimum
    * edge-cut
    */

class MatrixGraph<T>: Graph
    private adj_matrix: [[T]]
    private vert2id: dictionary<Vertex,int>

    def add(v:Vertex):
        pass()
    def operator+=(v:Vertex)->Graph:
        pass()
    def operator+(v:Vertex)->Graph:
        pass()
    
    def add(e:Edge):
        pass()
    def operator+=(e:Edge)->Graph:
        pass()
    def add(u:Vertex,v:Vertex):
        pass()
    def operator+=(u:Vertex,v:Vertex)->Graph:
        pass()
    def operator+(e:Edge)->Graph:
        pass()
    def operator+(u:Vertex,v:Vertex)->Graph:
        pass()

    def del(v:Vertex):
        pass()

    def operator-(v:Vertex)->Graph:
        return this
    
    def del(e:Edge):
        pass()
    def operator-=(e:Edge)->Graph:
        pass()
    def del(u:Vertex,v:Vertex):
        pass()
    def operator-=(u:Vertex,v:Vertex)->Graph:
        pass()
    def operator-(e:Edge)->Graph:
        pass()
    def operator-(u:Vertex,v:Vertex)->Graph:
        pass()
    
    def adj_to(v:Vertex)->[Vertex]:
        pass()
    
    def complement():
        pass()

    def operator-()->Graph:
        return this

    def connected()->bool:
        return false

    def V()->[Vertex]:
        return vert2id.get_keys()

    def get_verts()->[Vertex]:
        return V()
    
    def order()->int:
        return length(V())
    
    def E()->[Edge]:
        return []
    
    def get_edges()->[Edge]:
        return E()

    def size()->int:
        return -1
    
    def has(v:Vertex)->bool:
        return false
    def has(e:Edge)->bool:
        return false

    def has(u:Vertex, v:Vertex)->bool:
        return false


    def has_cycle()->bool:
        def tortis_and_hare():
            pass()
        return false
        
    def get_vert(v:int)->Vertex:
        pass()
    def get_vert(v:string)->Vertex:
        pass()

    // ---------- 
    //TODO: maybe move these into Vertex class
    def deg(v:Vertex)->int:
        pass()
    def id(v:Vertex)->int:
        pass()
    def od(v:Vertex)->int:
        pass()
    //---------- 

    def geodesic(u:Vertex, v:Vertex)->int:
        pass()
    def d(u:Vertex, v:Vertex)->int:
        return geodesic(u,v)
    
    def prim():
        pass()

    def kruskal():
        pass()

    def MST():
        pass()

    def num_spanning_tree():
        //Kirchhoff's theorem   
        pass()

    //do longest shortest path
    def long_short_path():
        pass()

    def floyed():
        pass()
    
    // K(G) <= Lambda(G) <= delta(G)
    // Kappa
    def K()->int:
        pass()
    
    def Lambda()->int:
        pass()
    
    // min degree
    def delta()->int:
        pass()

    // max degree
    def Delta()->int:
        pass()
    
    // find min number of colors to color the graph
    def X()->int:
        pass()

    // little omega: finds biggest K_n subgraph
    def w()->int:
        pass()
    
    //little alpha: finds size of biggest independent set
    def a()->int:
        pass()
    
    def fmt()->string:
        return sum(
            map(adj_matrix)row:
                "[ "+ sum(map(row)e:
                            if e==int(inf): "I " else: "{e} ") +"]\n")


constructor MatrixGraph<T>(adj_matrix:[[T]]):
    //TODO: check for negitive vals and is square
    let rez = exists(adj_matrix):exists(_)e: e<0
    // let g = fn guard(rez):
    check(rez,"graph has negative edges")

    let verts:[Vertex] = map(length(adj_matrix)):Vertex{string(_), []}
    let dict = dictionary<Vertex,int>(length(verts))
    for(verts)v,i: 
        dict.add(v,i)
    return MatrixGraph<T> { adj_matrix, dict }

class ListGraph: Graph
    adj_list: dictionary<Vertex,[Vertex]>

    def add(v:Vertex):
        pass()
    def operator+=(v:Vertex)->Graph:
        pass()
    def operator+(v:Vertex)->Graph:
        pass()
    
    def add(e:Edge):
        pass()
    def operator+=(e:Edge)->Graph:
        pass()
    def add(u:Vertex,v:Vertex):
        pass()
    def operator+=(u:Vertex,v:Vertex)->Graph:
        pass()
    def operator+(e:Edge)->Graph:
        pass()
    def operator+(u:Vertex,v:Vertex)->Graph:
        pass()

    def del(v:Vertex):
        pass()

    def operator-(v:Vertex)->Graph:
        pass()
    
    def del(e:Edge):
        pass()
    def operator-=(e:Edge)->Graph:
        pass()
    def del(u:Vertex,v:Vertex):
        pass()
    def operator-=(u:Vertex,v:Vertex)->Graph:
        pass()
    def operator-(e:Edge)->Graph:
        pass()
    def operator-(u:Vertex,v:Vertex)->Graph:
        pass()
    
    def adj_to(v:Vertex)->[Vertex]:
        pass()
    
    def complement():
        pass()

    def operator-()->Graph:
        return this

    def connected()->bool:
        return false

    def V()->[Vertex]:
        pass()

    def get_verts()->[Vertex]:
        return V()
    
    def order()->int:
        return length(V())
    
    def E()->[Edge]:
        return []
    
    def get_edges()->[Edge]:
        return E()

    def size()->int:
        return -1
    
    def has(v:Vertex)->bool:
        return false
    def has(e:Edge)->bool:
        return false

    def has(u:Vertex, v:Vertex)->bool:
        return false


    def has_cycle()->bool:
        def tortis_and_hare():
            pass()
        return false
        
    def get_vert(v:int)->Vertex:
        pass()
    def get_vert(v:string)->Vertex:
        pass()

    // ---------- 
    //TODO: maybe move these into Vertex class
    def deg(v:Vertex)->int:
        pass()
    def id(v:Vertex)->int:
        pass()
    def od(v:Vertex)->int:
        pass()
    //---------- 

    def geodesic(u:Vertex, v:Vertex)->int:
        pass()
    def d(u:Vertex, v:Vertex)->int:
        return geodesic(u,v)
    
    def prim():
        pass()

    def kruskal():
        pass()

    def MST():
        pass()

    def num_spanning_tree():
        //Kirchhoff's theorem   
        pass()

    //do longest shortest path
    def long_short_path():
        pass()

    def floyed():
        pass()
    
    // K(G) <= Lambda(G) <= delta(G)
    // Kappa
    def K()->int:
        pass()
    
    def Lambda()->int:
        pass()
    
    // min degree
    def delta()->int:
        pass()

    // max degree
    def Delta()->int:
        pass()
    
    // find min number of colors to color the graph
    def X()->int:
        pass()

    // little omega: finds biggest K_n subgraph
    def w()->int:
        pass()
    
    //little alpha: finds size of biggest independent set
    def a()->int:
        pass()
    
    def fmt()->string:
        pass()


def V(G:Graph)->[Vertex]:
    return G.V()

def E(G:Graph)->[Edge]:
    return G.E()

def tmp_function():// FIXME: plz delete
    pass()

class Unweighted:
    G: Graph

class Weighted:
    G: Graph

class Digraph:
    G: Graph
    def strongly_connected()->bool:
        pass()
    def Dijkstra():
        pass()

class MultiGraphs:
    G: Graph

//TODO: merge with testing.lobster file and add cli args idk
def test_type()->void
let tests_suite:[test_type] = []
def add_test(test):
    push(tests_suite, test)

//TODO: idk make some setup func that runs before all tests
let test1 = fn :
        print("test")
        let G:Graph = MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])

        // assert G.connected() == true
        let v_test = G.get_verts()[0]
        print G-v_test
        return
add_test(test1)


let test2 = fn :
        print("add vert")
        let G:Graph = MatrixGraph([[0,1,int(inf)],
                    [1,0,1],
                    [int(inf),1,0]])
        return 
add_test(test2)


let test3 = fn :
        print("add edge")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test3)

let test4 = fn :
        print("del vert")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test4)

let test5 = fn :
        print("del edge")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test5)

let test6 = fn :
        print("adj_to")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test6)

let test7 = fn :
        print("complement")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test7)

let test8 = fn :
        print("connected")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return nil

add_test(test8)


let test9 = fn :
        print("V")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test9)


let test10 = fn :
        print("E")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test10)

let test11 = fn :
        print("has vert")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test11)

let test12 = fn :
        print("has edge")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test12)

let test13 = fn :
        print("has cycle")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test13)


let test14 = fn :
        print("get_vert")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test14)

let test15 = fn :
        print("deg")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test15)

let test16 = fn :
        print("id/od")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test16)

let test17 = fn :
        print("geodesic")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test17)

let test18 = fn :
        print("prim kruskal")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test18)


let test19 = fn :
        print("MST")
        let G:Graph =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test19)


let test20 = fn :
        print("num_spanning_tree")
        let G =
         MatrixGraph([[0,1,int(inf)],
                [1,0,1],
                [int(inf),1,0] ])
        return 

add_test(test20)

/* TODO: write tests for:
* long_short_path
* floyed
* K
* Lambda
* delta
* Delta
* X
* w
* a
*/

run_test("Graph tests"):
    print("==================== Tests start ====================")
    var passed = 0
    let total = length(tests_suite)
    for (tests_suite)t,i:
        print("-- test: {i+1} --")
        t()
        print("\n\n")
    print("passed: {passed}/{total}")



//============================== DEMOS  ==============================
def demos():
    pass()
    // K_3
    // K_4
    // K_5
    // K_6

    //K_3,3

    // C_3
    // C_4
    // C_5

    // Q_2
    // Q_3
    // Q_4

    // Peterson graph

    // Butterfly graph

    // 20-fullerene

    // R_3 cube
    // R_4 Octahedron
    // R_5 dodecahedron
    // R_6 icosahedron

    // S_3 star
    // S_4 star
    // S_5 star

    // W_4 wheel
    // W_5 wheel
    // W_6 wheel
    // W_7 wheel

    // Binary tree

    /* random cool stuff
    * self complementary then n or n − 1 is divisible by 4 since G must have size (n choose 2) /2 = n(n − 1)/4
    * Havel-Hakimi
    * graph reconstruction
    * Ore's Theorem
    * Cayley’s Spanning Tree Formula
    * Ramsey's theory

    idk random graph from paper about group theory
    * https://msp.org/involve/2023/16-5/involve-v16-n5-p05-s.pdf

    * https://www.youtube.com/watch?v=3LYCjjYkdvo
    */