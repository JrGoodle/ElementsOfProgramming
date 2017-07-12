//
//  Chapter02.swift
//  ElementsOfProgramming
//

func powerUnary<DomainF>(_ x: inout DomainF, n: inout N, f: F<DomainF>) -> DomainF {
    while n != N(0) {
        n = n - N(1)
        x = f(x)
    }
    return x
}

///

func distance<DomainF: Equatable>(_ x: inout DomainF, _ y: DomainF, f: F<DomainF>) -> DistanceType {
    typealias N = DistanceType
    var n = 0
    while x != y {
        x = f(x)
        n = n + N(1)
    }
    return n
}

///

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
