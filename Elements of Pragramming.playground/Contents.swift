// Elements of Programming

//import Foundation

// Chapter 1

typealias Op<T> = (T, T) -> T

func square<DomainOp>(_ x: DomainOp, op: Op<DomainOp>) -> DomainOp {
    return op(x, x)
}

square(2) { $0 * $1 }
square("a") { $0 + $1 }

// Chapter 2

typealias N = Int
typealias F<T> = (T) -> T // Homogeneous Functional Procedure
func powerUnary<DomainF>(_ x: inout DomainF, n: inout N, f: F<DomainF>) -> DomainF {
    while n != N(0) {
        n = n - N(1)
        x = f(x)
    }
    return x
}

var x = 0
var n = 100
powerUnary(&x, n: &n) { $0 + 2 }

///

typealias DistanceType = Int
func distance<DomainF: Equatable>(_ x: inout DomainF, _ y: DomainF, f: F<DomainF>) -> DistanceType {
    typealias N = DistanceType
    var n = 0
    while x != y {
        x = f(x)
        n = n + N(1)
    }
    return n
}

x = 0
let y = 100
distance(&x, y) { $0 + 2 }

///

typealias P<T> = (T) -> Bool // Predicate
func collisionPoint<DomainFP: Equatable>(_ x: inout DomainFP, f: F<DomainFP>, p: P<DomainFP>) -> DomainFP {
    if !p(x) { return x }
    
    var slow = x
    var fast = f(x)
    
    while fast != slow {
        slow = f(slow)
        if !p(fast) { return fast }
        fast = f(fast)
        if !p(fast) { return fast }
        fast = f(fast)
    }
    return fast
}

///

func terminating<DomainFP: Equatable>(_ x: inout DomainFP, f: F<DomainFP>, p: P<DomainFP>) -> Bool{
    return !p(collisionPoint(&x, f: f, p: p))
}

///

func collisionPointNonterminatingOrbit<DomainF: Equatable>(_ x: inout DomainF, f: F<DomainF>) -> DomainF {
    var slow = x
    var fast = f(x)
    
    while fast != slow {
        slow = f(slow)
        fast = f(fast)
        fast = f(fast)
    }
    return fast
}

///

func circularNonterminatingOrbit<DomainF: Equatable>(_ x: inout DomainF, f: F<DomainF>) -> Bool {
    return x == f(collisionPointNonterminatingOrbit(&x, f: f))
}

///

func circular<DomainFP: Equatable>(x: inout DomainFP, f: F<DomainFP>, p: P<DomainFP>) -> Bool {
    let y = collisionPoint(&x, f: f, p: p)
    return p(y) && x == f(y)
}
