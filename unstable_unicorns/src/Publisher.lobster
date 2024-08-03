import std
import from "../../"
import utils

set_print_depth(3)


class Wrap

class Msg<T>: Wrap
    data: T

    def get_msg():
        return data

class CMsg<T,U>: Msg<T>
    caller: U

class Wrap:
    def get_data<T,U>():
        assert this is CMsg<T,U>
        return this.data, this.caller

def notify_format(msg:Wrap) -> void //):

abstract class Sub
class Publisher<T>:
    name: string
    subs: [Sub] = []

    def add_sub(sub:Sub):
        subs.push(sub)

    def remove_sub(sub:Sub):
        subs.remove_obj(sub)

    def publish(msg:T):
        print("[{name}] publishing")
        for(subs)s:
            s.notify(Msg<T>{msg})
class Subscriber<T,U>:Sub
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
// let pub2 = Publisher<int>{"test2"}

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

pub.publish(69) // broadcast a message

b.sub.delete() // frees the subscriber object 
//prevents not create a circular reface
// */