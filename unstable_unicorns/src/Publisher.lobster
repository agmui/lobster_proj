import std
import from "../../"
import utils
import terminal_colors

set_print_depth(3)

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

// this is a hack
class SubInterface:
    def notify(msg):
        pass()

class Publisher<T>:
    name: string
    subs: [SubInterface] = []

    def add_sub(sub:SubInterface):
        subs.push(sub)

    def remove_sub(sub:SubInterface):
        subs.remove_obj(sub)

    //TODO: test
    // def publish():
    //     if T{} is Empty:
    //         print("[{name}] publishing")
    //         for(subs)s:
    //             s.notify(Msg<Empty>{Empty{}})

    def publish(msg:T):
        print("{BLK}[{name}] publishing{reset}")
        for(subs)s:
        // assert subs is Subscriber<T> // can turn Sub back into interface
            s.notify(Msg<T>{msg})
            

class Subscriber<T,U>:SubInterface
    notify_func:notify_format = fn(msg:Wrap):
                    error("subscriber object has uninitialized callback")
    caller: U? = nil
    // pubs: [Publisher<T>] = []

    def set_func(f):
        notify_func = f

    def set_caller(c):
        caller = c

    def subscribe(publisher):
        publisher.add_sub(this)
        // pubs.push(publisher)

    def unsubscribe(publisher):
        publisher.remove_sub(this)
        // pubs.remove_obj(publisher)
    
    //TODO:
    // def unsubscribe_all():
    //     for(pubs)p:
    //         unsubscribe(p)

    def notify(msg:Msg<T>):
        assert caller is U
        let cmsg = CMsg<T,U>{msg.data,caller}
        def do2(f,a): return f(a)  
        do2(notify_func, cmsg)

    def delete():
        caller = nil
        //TODO: unsub

//NOTE: bc of the assertion in notify 
// you must always have the pub arg accompanied with the caller arg
constructor Subscriber<T,U>(pub:Publisher<T>, caller:U ,fun):
    let sub = Subscriber<T,U>{}
    sub.subscribe(pub)
    sub.set_caller(caller)
    sub.set_func(fun)
    return sub

//TODO:
// constructor Subscriber<T,U>(pub:[Publisher<T>], caller:U ,fun):
//     let sub = Subscriber<T,U>{}
//     for(pub)p:
//         sub.subscribe(p)
//     sub.set_caller(caller)
//     sub.set_func(fun)
//     return sub

constructor Subscriber<T,U>(caller:U ,fun):
    let sub = Subscriber<T,U>{}
    sub.set_caller(caller)
    sub.set_func(fun)
    return sub


constructor Subscriber<T,U>(fun):
    let sub = Subscriber<T,U>{}
    sub.set_func(fun)
    return sub

constructor Subscriber<T,U>():
    return Subscriber<T,U>{}


// -- examples--
/*

let pub = Publisher<int>{"test"}
let pub2 = Publisher<string>{"test2"}

class B: 
    // sub = Subscriber<int,B>(pub,this)msg:
    //     let data, this = msg.get_data<int,B>()
    //     print(data,this.only_in_B)

    sub = Subscriber<int,B>()
    only_in_B: string = "only in B"

constructor B():
    let b = B{}
    b.sub = Subscriber<int>(pub, b)msg:
        let data, this = msg.get_data<int,B>()
        print(data,this.only_in_B)
    return b

let b = B()

class C: 

    sub = Subscriber<string,C>()
    only_in_C: string = "only in C"

constructor C():
    let c = C{}
    c.sub = Subscriber<string>(pub2, c)msg:
        let data, this = msg.get_data<string,C>()
        print(data,this.only_in_C)
    return c

let c = C()

pub.publish(69) // broadcast a message
pub2.publish("hi")

b.sub.delete() // frees the subscriber object 
c.sub.delete()
//prevents not create a circular reface
// */