//
//  Chapter02.swift
//  ElementsOfProgramming
//

import Darwin

func absoluteValue(x: Int) -> Int {
    if (x < 0) { return -x } else { return x }
} // unary operation

func euclideanNorm(x: Double, y: Double) -> Double {
    return sqrt(x * x + y * y)
} // binary operation

func euclideanNorm(x: Double, y: Double, z: Double) -> Double {
    return sqrt(x * x + y * y + z * z)
} // ternary operation

func powerUnary<DomainF: Distance>(
    x: DomainF,
    n: N,
    f: Transformation<DomainF>
) -> DomainF {
    logFunc()
    var x = x, n = n
    assert(n >= 0, "n >= 0")
    // Precondition:
    // n ≥ 0 ∧ (∀i ∈ N), 0 < i ≤ n ⇒ f^i(x) is defined
    
    while n != N(0) {
        n = n - N(1)
        x = f(x)
    }
    return x
}

// See Distance protocol
func distance<DomainF: Distance>(
    x: DomainF,
    y: DomainF,
    f: Transformation<DomainF>
) -> DistanceType {
    logFunc()
    var x = x
    // Precondition: y is reachable from x under f
    var n = N(0)
    while x != y {
        x = f(x)
        n = n + N(1)
    }
    return n
}

func collisionPoint<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
) -> DomainFP {
    logFunc()
    // Precondition: p(x) ⇔ f(x) is defined
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

func terminating<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
) -> Bool{
    logFunc()
    // Precondition: p(x) ⇔ f(x) is defined
    return !p(collisionPoint(x: x, f: f, p: p))
}

func collisionPointNonterminatingOrbit<DomainF: Distance>(
    x: DomainF,
    f: Transformation<DomainF>
) -> DomainF {
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

func circularNonterminatingOrbit<DomainF: Distance>(
    x: DomainF,
    f: Transformation<DomainF>
) -> Bool {
    logFunc()
    return x == f(collisionPointNonterminatingOrbit(x: x, f: f))
}

func circular<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
) -> Bool {
    logFunc()
    // Precondition: p(x) ⇔ f(x) is defined
    let y = collisionPoint(x: x, f: f, p: p)
    return p(y) && x == f(y)
}

func convergentPoint<DomainF: Distance>(
    x0: DomainF,
    x1: DomainF,
    f: Transformation<DomainF>
) -> DomainF {
    logFunc()
    var x0 = x0, x1 = x1
    // Precondition: (∃n ∈ DistanceType(F)), n ≥ 0 ∧ f^n(x0) = f^n(x1)
    while x0 != x1 {
        x0 = f(x0)
        x1 = f(x1)
    }
    return x0
}

func connectionPointNonterminatingOrbit<DomainF: Distance>(
    x: DomainF,
    f: Transformation<DomainF>
) -> DomainF {
    logFunc()
    return convergentPoint(x0: x,
                           x1: f(collisionPointNonterminatingOrbit(x: x, f: f)),
                           f: f)
}

func connectionPoint<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
) -> DomainFP {
    logFunc()
    // Precondition: p(x) ⇔ f(x) is defined
    let y = collisionPoint(x: x, f: f, p: p)
    if !p(y) { return y }
    return convergentPoint(x0: x, x1: f(y), f: f)
}

/// Exercise 2.3

func convergentPointGuarded<DomainF: Distance>(
    x0: DomainF,
    x1: DomainF,
    y: DomainF,
    f: Transformation<DomainF>
) -> DomainF {
    logFunc()
    var x0 = x0, x1 = x1
    // Precondition: reachable(x0, y, f) ∧ reachable(x1, y, f)
    let d0 = x0.distance(to: y, f: f)
    let d1 = x1.distance(to: y, f: f)
    if d0 < d1 {
        x1 = powerUnary(x: x1, n: N(d1 - d0), f: f)
    } else if d1 < d0 {
        x0 = powerUnary(x: x0, n: N(d0 - d1), f: f)
    }
    return convergentPoint(x0: x0, x1: x1, f: f)
}

func orbitStructureNonterminatingOrbit<DomainF: Distance>(
    x: DomainF,
    f: Transformation<DomainF>
) -> Triple<DistanceType, DistanceType, DomainF> {
    logFunc()
    let y = connectionPointNonterminatingOrbit(x: x, f: f)
    return Triple(m0: x.distance(to: y, f: f),
                  m1: f(y).distance(to: y, f: f),
                  m2: y)
}

func orbitStructure<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
) -> Triple<DistanceType, DistanceType, DomainFP> {
    logFunc()
    // Precondition: p(x) ⇔ f(x) is defined
    let y = connectionPoint(x: x, f: f, p: p)
    let m = x.distance(to: y, f: f)
    var n = N(0)
    if p(y) { n = f(y).distance(to: y, f: f) }
    // Terminating: m = h - 1 ∧ n = 0
    // Otherwise:   m = h ∧ n = c - 1
    return Triple(m0: m, m1: n, m2: y)
}
