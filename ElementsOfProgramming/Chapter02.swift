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

func powerUnary<DomainF: RegularType>(_ _x: DomainF, _ _n: N, f: Transformation<DomainF>) -> DomainF {
    var x = _x
    var n = _n
    precondition(n >= 0, "n >= 0")
    // Precondition: For all values of natural number i where 0 < i <= n, fi(x) is defined
    
    while n != N(0) {
        n = n - N(1)
        x = f(x)
    }
    return x
}

///

func distance<DomainF: RegularType>(_ _x: DomainF, _ y: DomainF, f: Transformation<DomainF>) -> DistanceType {
    var x = _x
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

func terminating<DomainFP: RegularType>(_ x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) -> Bool{
    // Precondition: $p(x) \Leftrightarrow \text{$f(x)$ is defined}$
    return !p(collisionPoint(x, f: f, p: p))
}

///

func collisionPointNonterminatingOrbit<DomainF: RegularType>(_ x: DomainF, f: Transformation<DomainF>) -> DomainF {
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

func circularNonterminatingOrbit<DomainF: RegularType>(_ x: DomainF, f: Transformation<DomainF>) -> Bool {
    return x == f(collisionPointNonterminatingOrbit(x, f: f))
}

///

func circular<DomainFP: RegularType>(_ x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) -> Bool {
    let y = collisionPoint(x, f: f, p: p)
    return p(y) && x == f(y)
}

///

func convergentPoint<DomainF: RegularType>(_ _x0: DomainF, _ _x1: DomainF, f: Transformation<DomainF>) -> DomainF {
    // Precondition: $(\exists n \in \func{DistanceType}(F))\,n \geq 0 \wedge f^n(x0) = f^n(x1)$
    var x0 = _x0
    var x1 = _x1
    
    while x0 != x1 {
        x0 = f(x0)
        x1 = f(x1)
    }
    return x0
}

///

func connectionPointNonterminatingOrbit<DomainF: RegularType>(_ x: DomainF, f: Transformation<DomainF>) -> DomainF {
    return convergentPoint(x,
                           f(collisionPointNonterminatingOrbit(x, f: f)),
                           f: f)
}

///

func connectionPoint<DomainFP: RegularType>(_ x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) -> DomainFP {
    // Precondition: $p(x) \Leftrightarrow \text{$f(x)$ is defined}$
    let y = collisionPoint(x, f: f, p: p)
    if !p(y) { return y }
    return convergentPoint(x, f(y), f: f)
}

/// Exercise 2.3

func convergentPointGuarded<DomainF: RegularType>(_x0: DomainF, _x1: DomainF, y: DomainF, f: Transformation<DomainF>) -> DomainF {
    var x0 = _x0
    var x1 = _x1
    // Precondition: $\func{reachable}(x0, y, f) \wedge \func{reachable}(x1, y, f)$
    typealias N = DistanceType
    let d0 = distance(x0, y, f: f)
    let d1 = distance(x1, y, f: f)
    if d0 < d1 {
        x1 = powerUnary(x1, d1 - d0, f: f)
    } else if d1 < d0 {
        x0 = powerUnary(x0, d0 - d1, f: f)
    }
    return convergentPoint(x0, x1, f: f)
}

///

func orbitStructureNonterminatingOrbit<DomainF>(_ x: DomainF, f: Transformation<DomainF>) -> Triple<DistanceType, DistanceType, DomainF> {
    typealias N = DistanceType
    let y = connectionPointNonterminatingOrbit(x, f: f)
    return Triple(m0: distance(x, y, f: f),
                  m1: distance(f(y), y, f: f),
                  m2: y)
}

///

func orbitStructure<DomainFP>(_ x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) -> Triple<DistanceType, DistanceType, DomainFP> {
    // Precondition: $p(x) \Leftrightarrow \text{$f(x)$ is defined}$
    typealias N = DistanceType
    let y = connectionPoint(x, f: f, p: p)
    let m = distance(y, y, f: f)
    var n = N(0)
    if p(y) { n = distance(f(y), y, f: f) }
    // Terminating: $m = h - 1 \wedge n = 0$
    // Otherwise:   $m = h \wedge n = c - 1$
    return Triple(m0: m, m1: n, m2: y)
}
