import std
import from "../../"
import utils
import terminal_colors

//TODO: add namespace



/*
class Empty:

class Wrap

class Msg<T>: Wrap
    data: T

    def get_msg():
        return data

class CMsg<T,U>: Msg<T>
    caller: U

class Wrap:
    def get_data<T,U>():
        let error_print = fn(): 
            // error("TODO: types T,U are wrong for get_data()")
            true
        assert this is CMsg<T,U> and error_print()
        return this.caller, this.data

def notify_format(msg:Wrap) -> void //):
def send_rev_format(msg:Wrap) -> Wrap //):

abstract class SubInterface //):
abstract class PubInterface //):
class pub<T>: 
    name: string
    subs: [T] = []

    def add_sub(sub):
        subs.push(sub)

    def remove_sub(sub):
        subs.remove_obj(sub)
class sub<T>:
    notify_func: T

    def set_func(f):
        notify_func = f

    def subscribe(publisher:PubInterface, a):
        publisher.get_p.add_sub(a)

    def unsubscribe(publisher:PubInterface):
        publisher.get_p.remove_sub(this)
    
    // def notify(msg):
    //     error("nothing")
    //     pass()

    def delete():
        // TODO: unsubnc:T
        pass()


class Subscribe<T,obj_type>: SubInterface
    s = sub<notify_format>{fn(msg:Wrap): error("hi")}
    caller: obj_type

    def notify(msg:Msg<T>):
        assert caller is obj_type
        let cmsg = CMsg<T,obj_type>{msg.data,caller}
        def do2(f,a): return f(a)  
        do2(s.notify_func, cmsg)

abstract class helper: SubInterface
class Client<T,obj_type,reT>: helper//SubInterface
    s = sub<send_rev_format>{fn(msg:Wrap)->Wrap: Wrap{}}
    caller: obj_type

    def notify(msg:Msg<T>)->Msg<reT>://):
        print("notify")
        assert caller is obj_type
        let cmsg = CMsg<T,obj_type>{msg.data,caller}
        def do2(f,a): return f(a)  
        let res = do2(s.notify_func, cmsg)
        assert res is Msg<reT>
        return res

constructor Client<T,obj_type,reT>(s,caller):
    let cli = Client<T,obj_type,reT>{caller}
    cli.s = s
    return cli
        




class Publisher<T>: PubInterface
    p: pub<SubInterface>
    def get_p():
        return p

    def publish(msg:T):
        print("{BLK}[{p.name}] publishing{reset}")
        for(p.subs)s:
            s.notify(Msg<T>{msg})
            
// constructor Publisher<T>(name):
//     return Publisher<T>{pub<SubInterface>{name}}
    

class Server<T,reT>: PubInterface
// class Server<T,reT>: pub<sub<send_rev_format> > //PubInterface
    p: pub<helper>//sub<send_rev_format> >
    def get_p():
        return p

    def publish(msg:T):
        print("{BLK}[{p.name}] publishing{reset}")
        // map(p.subs)s: s.notify(Msg<T>{msg})
        for(p.subs)s:
            s.notify(Msg<T>{msg})
        return []

// let pub = Publisher<int>{"pub"}
// let fun:notify_format = fn(msg:Msg<int>): print(msg)
// let sub = Subscribe<int,Empty>{fun,Empty{}}

// sub.subscribe(pub)
// pub.publish(69)


let ser = Server<int,string>{pub<helper >{"ser"}}
let fun2:send_rev_format = fn(msg:Msg<int>)->Msg<string>: 
                                print(msg)
                                Msg<string>{"{msg}"}
let cli = Client<int,Empty,string>(sub<send_rev_format>{fun2},Empty{})

cli.s.subscribe(ser,cli)
ser.publish(69)//.print()
*/

class Empty:

class Wrap:
class Msg<T>: Wrap
    data: T

    def get_msg():
        return data

class CMsg<T,U>: Msg<T>
    caller: U


def notify_format(msg:Wrap) -> void //):
def send_rev_format(msg:Wrap) -> Wrap //):


abstract class SubInterface: //):
// abstract class PubInterface //):

abstract class pub<T>:// PubInterface
    name: string
    subs: [T] = []

    def add_sub(sub):
        subs.push(sub)

    def remove_sub(sub):
        subs.remove_obj(sub)
abstract class sub<T>: SubInterface
    notify_func: T

    def set_func(f):
        notify_func = f

    // def subscribe(pub:pub<sub<T>>)://TODO: try to get this to work
    def subscribe(pub):
        pub.add_sub(this)

    def unsubscribe(pub):
        pub.remove_sub(this)

    def delete():
        // TODO: unsubnc:T
        pass()

    
class Publisher<T>: pub<SubInterface>
    def publish(msg:T):
        print("{BLK}[{name}] publishing{reset}")
        for(subs)s:
            s.notify(Msg<T>{msg})
            

class Server<T,reT>: pub<sub<send_rev_format>>
    def publish(msg:T):
        print("{BLK}[{name}] publishing{reset}")
        return map(subs)s: s.notify(Msg<T>{msg})


class Subscriber2<T>: sub<notify_format>
    def notify(msg:Msg<T>):
        def do2(f,a): return f(a)
        do2(notify_func,msg)
constructor Subscriber2<T>(fun):
    let func_wrapper = fn(msg):
        assert msg is Msg<T>
        fun(msg.data)

    return Subscriber2<T>{func_wrapper}
    


class Subscriber<T,obj_type>: sub<notify_format>
    caller: obj_type?

    def set_caller(c:obj_type):
        caller = c

    def notify(msg:Msg<T>):
        assert caller is obj_type
        let cmsg = CMsg<T,obj_type>{msg.data,caller}
        def do2(f,a): return f(a)
        do2(notify_func, cmsg)
    def delete():
        caller = nil

constructor Subscriber<T,obj_type>(pub:Publisher<T>,caller:obj_type,fun):
    let func_wrapper = fn(msg):
        assert msg is CMsg<T,obj_type>
        fun(msg.caller,msg.data)
    let sub = Subscriber<T,obj_type>{func_wrapper,caller}
    sub.subscribe(pub)
    return Subscriber<T,obj_type>{func_wrapper,caller}

constructor Subscriber<T,obj_type>(caller:obj_type,fun):
    let func_wrapper = fn(msg):
        assert msg is CMsg<T,obj_type>
        fun(msg.caller,msg.data)
    return Subscriber<T,obj_type>{func_wrapper,caller}

constructor Subscriber<T,obj_type>(fun):
    let func_wrapper = fn(msg):
        assert msg is CMsg<T,obj_type>
        fun(msg.caller,msg.data)
    return Subscriber<T,obj_type>{func_wrapper,nil}

constructor Subscriber<T,obj_type>():
    return Subscriber<T,obj_type>{fn(msg):pass(),nil}

class Client2<T,reT>: sub<send_rev_format>
    def notify(msg:Msg<T>)->Msg<reT>: //):
        def do2(f,a): return f(a)
        let res = do2(notify_func,msg)
        assert res is Msg<reT>//TODO: try returning with CMsg
        return res
constructor Client2<T,reT>(fun):
    let func_wrapper = fn(msg):
        assert msg is Msg<T>
        Msg<reT>{fun(msg.data)}

    return Client2<T,reT>{func_wrapper}
        


class Client<T,obj_type,reT>: sub<send_rev_format>
    caller: obj_type?

    def set_caller(c:obj_type):
        caller = c

    def notify(msg:Msg<T>)->Msg<reT>://):
        assert caller is obj_type
        let cmsg = CMsg<T,obj_type>{msg.data,caller}
        def do2(f,a): return f(a)
        let res = do2(notify_func, cmsg)
        assert res is Msg<reT>
        return res
    def delete():
        caller = nil
constructor Client<T,obj_type,reT>(caller, fun):
    let func_wrapper = fn(msg):
        assert msg is CMsg<T,obj_type>
        Msg<reT,obj_type>{fun(msg.caller,msg.data)}

    return Client<T,obj_type,reT>{func_wrapper,caller}
constructor Client<T,obj_type,reT>():
    return Client<T,obj_type,reT>{fn(msg):Wrap{},nil}
        

// --examples--

let pub = Publisher<int>{"pub"}
let ser = Server<int,string>{"ser"}

let sub2 = Subscriber2<int>()data:
                            print("in sub2: {data}")


let cli2 = Client2<int,string>()data:
                            print("in cli2: {data}")
                            "{data}"

class A:
    sub = Subscriber<int,A>()
    only_in_a = "a"
constructor A():
    let a = A{}
    a.sub = Subscriber<int,A>(a)this,data:
                                    print("in sub: {this.only_in_a}, {data}")
    return a


class B:
    cli = Client<int,B,string>()
    only_in_b = "b"
constructor B():
    let b = B{}
    b.cli = Client<int,B,string>(b)this,data:
                                    print("in cli: {this.only_in_b}, {data}")
                                    "{data}"
    return b

sub2.subscribe(pub)

cli2.subscribe(pub)
cli2.subscribe(ser)

let a = A()
a.sub.subscribe(pub)

let b = B()
b.cli.subscribe(pub)
b.cli.subscribe(ser)

pub.publish(69)
ser.publish(69).print

a.sub.delete()
b.cli.delete()