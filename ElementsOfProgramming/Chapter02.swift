//
//  Chapter02.swift
//  ElementsOfProgramming
//

import Darwin

//func abs(x: Int) -> Int {
//    if (x < 0) { return -x } else { return x }
//} // unary operation

func euclideanNorm(x: Double, y: Double) -> Double {
    return sqrt(x * x + y * y)
} // binary operation

func euclideanNorm(x: Double, y: Double, z: Double) -> Double {
    return sqrt(x * x + y * y + z * z)
} // ternary operation

func powerUnary<DomainF>(_ x: inout DomainF, n: inout N, f: Transformation<DomainF>) -> DomainF {
    precondition(n >= 0, "n >= 0")
    // Precondition: For all values of natural number i where 0 < i <= n, fi(x) is defined
    while n != N(0) {
        n = n - N(1)
        x = f(x)
    }
    return x
}

///

func distance<DomainF: RegularType>(_ x: inout DomainF, _ y: DomainF, f: Transformation<DomainF>) -> DistanceType {
    // Precondition: y is reachable from x under f
    typealias N = DistanceType
    var n = N(0)
    while x != y {
        x = f(x)
        n = n + N(1)
    }
    return n
}

///

func collisionPoint<DomainFP: RegularType>(_ x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) -> DomainFP {
    // Precondition: p(x) <=> f(x) is defined
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
    // Postcondition: return value is terminal point or collision point
}

///

func terminating<DomainFP: RegularType>(_ x: DomainFP, f: F<DomainFP>, p: P<DomainFP>) -> Bool{
    return !p(collisionPoint(x, f: f, p: p))
}

///

func collisionPointNonterminatingOrbit<DomainF: RegularType>(_ x: DomainF, f: F<DomainF>) -> DomainF {
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

func circularNonterminatingOrbit<DomainF: RegularType>(_ x: inout DomainF, f: F<DomainF>) -> Bool {
    return x == f(collisionPointNonterminatingOrbit(x, f: f))
}

///

func circular<DomainFP: RegularType>(x: DomainFP, f: F<DomainFP>, p: P<DomainFP>) -> Bool {
    let y = collisionPoint(x, f: f, p: p)
    return p(y) && x == f(y)
}
