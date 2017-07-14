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

func powerUnary<DomainF: RegularType>(x: DomainF, n: N, f: Transformation<DomainF>) -> DomainF {
    logFunc()
    var _x = x
    var _n = n
    precondition(n >= 0, "n >= 0")
    // Precondition:
    // $n \geq 0 \wedge (\forall i \in N)\,0 < i \leq n \Rightarrow f^i(x)$ is defined
    
    while _n != N(0) {
        _n = _n - N(1)
        _x = f(_x)
    }
    return _x
}

///

func distance<DomainF: RegularType>(x: DomainF, y: DomainF, f: Transformation<DomainF>) -> DistanceType {
    logFunc()
    var _x = x
    // Precondition: $y$ is reachable from $x$ under $f$
    typealias N = DistanceType
    var n = N(0)
    while _x != y {
        _x = f(_x)
        n = n + N(1)
    }
    return n
}

///

func collisionPoint<DomainFP: RegularType>(x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) -> DomainFP {
    logFunc()
    // Precondition: $p(x) \Leftrightarrow \text{$f(x)$ is defined}$
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

func terminating<DomainFP: RegularType>(x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) -> Bool{
    logFunc()
    // Precondition: $p(x) \Leftrightarrow \text{$f(x)$ is defined}$
    return !p(collisionPoint(x: x, f: f, p: p))
}

///

func collisionPointNonterminatingOrbit<DomainF: RegularType>(x: DomainF, f: Transformation<DomainF>) -> DomainF {
    logFunc()
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

func circularNonterminatingOrbit<DomainF: RegularType>(x: DomainF, f: Transformation<DomainF>) -> Bool {
    logFunc()
    return x == f(collisionPointNonterminatingOrbit(x: x, f: f))
}

///

func circular<DomainFP: RegularType>(x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) -> Bool {
    logFunc()
    // Precondition: $p(x) \Leftrightarrow \text{$f(x)$ is defined}$
    let y = collisionPoint(x: x, f: f, p: p)
    return p(y) && x == f(y)
}

///

func convergentPoint<DomainF: RegularType>(x0: DomainF, x1: DomainF, f: Transformation<DomainF>) -> DomainF {
    logFunc()
    // Precondition: $(\exists n \in \func{DistanceType}(F))\,n \geq 0 \wedge f^n(x0) = f^n(x1)$
    var _x0 = x0
    var _x1 = x1
    
    while _x0 != _x1 {
        _x0 = f(_x0)
        _x1 = f(_x1)
    }
    return _x0
}

///

func connectionPointNonterminatingOrbit<DomainF: RegularType>(x: DomainF, f: Transformation<DomainF>) -> DomainF {
    logFunc()
    return convergentPoint(x0: x,
                           x1: f(collisionPointNonterminatingOrbit(x: x, f: f)),
                           f: f)
}

///

func connectionPoint<DomainFP: RegularType>(x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) -> DomainFP {
    logFunc()
    // Precondition: $p(x) \Leftrightarrow \text{$f(x)$ is defined}$
    let y = collisionPoint(x: x, f: f, p: p)
    if !p(y) { return y }
    return convergentPoint(x0: x, x1: f(y), f: f)
}

/// Exercise 2.3

func convergentPointGuarded<DomainF: RegularType>(x0: DomainF, x1: DomainF, y: DomainF, f: Transformation<DomainF>) -> DomainF {
    logFunc()
    var _x0 = x0
    var _x1 = x1
    // Precondition: $\func{reachable}(x0, y, f) \wedge \func{reachable}(x1, y, f)$
    typealias N = DistanceType
    let d0 = distance(x: _x0, y: y, f: f)
    let d1 = distance(x: _x1, y: y, f: f)
    if d0 < d1 {
        _x1 = powerUnary(x: _x1, n: d1 - d0, f: f)
    } else if d1 < d0 {
        _x0 = powerUnary(x: _x0, n: d0 - d1, f: f)
    }
    return convergentPoint(x0: _x0, x1: _x1, f: f)
}

///

func orbitStructureNonterminatingOrbit<DomainF>(x: DomainF, f: Transformation<DomainF>) -> Triple<DistanceType, DistanceType, DomainF> {
    logFunc()
    typealias N = DistanceType
    let y = connectionPointNonterminatingOrbit(x: x, f: f)
    return Triple(m0: distance(x: x, y: y, f: f),
                  m1: distance(x: f(y), y: y, f: f),
                  m2: y)
}

///

func orbitStructure<DomainFP>(x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) -> Triple<DistanceType, DistanceType, DomainFP> {
    logFunc()
    // Precondition: $p(x) \Leftrightarrow \text{$f(x)$ is defined}$
    typealias N = DistanceType
    let y = connectionPoint(x: x, f: f, p: p)
    let m = distance(x: x, y: y, f: f)
    var n = N(0)
    if p(y) { n = distance(x: f(y), y: y, f: f) }
    // Terminating: $m = h - 1 \wedge n = 0$
    // Otherwise:   $m = h \wedge n = c - 1$
    return Triple(m0: m, m1: n, m2: y)
}
