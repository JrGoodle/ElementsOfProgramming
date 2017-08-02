//
//  Chapter02.swift
//  ElementsOfProgramming
//

import Darwin
import EOP

func absoluteValue(x: Int) -> Int {
    if (x < 0) { return -x } else { return x }
} // unary operation

func euclideanNorm(x: Double, y: Double) -> Double {
    return sqrt(x * x + y * y)
} // binary operation

func euclideanNorm(x: Double, y: Double, z: Double) -> Double {
    return sqrt(x * x + y * y + z * z)
} // ternary operation

// Exercise 2.1

func definitionSpacePredicateIntegerAddition<T: FixedWidthInteger>(
    x: T,
    y: T
) -> Bool {
    // Precondition: T.min <= x <= T.max ∧ T.min <= y <= T.max
    if x > 0 && y > 0 {
        return y <= T.max - x
    } else if x < 0 && y < 0 {
        return y >= T.min - x
    }
    return true
}

func powerUnary<DomainF: Distance>(
    _ x: DomainF,
    power n: N,
    transformation: Transformation<DomainF>
) -> DomainF {
    var x = x, n = n
    assert(n >= 0)
    // Precondition: n ≥ 0 ∧ (∀i ∈ N), 0 < i ≤ n ⇒ f^i(x) is defined
    
    while n != N(0) {
        n = n - N(1)
        x = transformation(x)
    }
    return x
}

// See Distance protocol in TypeFunctions.swift
//func distance<DomainF: Distance>(
//    x: DomainF,
//    y: DomainF,
//    f: Transformation<DomainF>
//) -> DistanceType {
//    var x = x
//    // Precondition: y is reachable from x under f
//    var n = N(0)
//    while x != y {
//        x = f(x)
//        n = n + N(1)
//    }
//    return n
//}

func collisionPoint<DomainFP: Distance>(
    start x: DomainFP,
    transformation f: Transformation<DomainFP>,
    definitionSpace p: UnaryPredicate<DomainFP>
) -> DomainFP {
    // Precondition: p(x) ⇔ f(x) is defined
    if !p(x) { return x }
    
    var slow = x            // slow = f^0(x)
    var fast = f(x)         // fast = f^1(x)
                            // n ← 0 (completed iterations)
    while fast != slow {    // slow = f^n(x) ∧ fast = f^{2n+1}(x)
        slow = f(slow)      // slow = f^{n+1}(x) ∧ fast = f^{2n+1}(x)
        if !p(fast) { return fast }
        fast = f(fast)      // slow = f^{n+1}(x) ∧ fast = f^{2n+2}(x)
        if !p(fast) { return fast }
        fast = f(fast)      // slow = f^{n+1}(x) ∧ fast = f^{2n+3}(x)
    }                       // n ← n + 1
    return fast             // slow = f^n(x) ∧ fast = f^{2n+1}(x)
    // Postcondition: return value is terminal point or collision point
}

func terminating<DomainFP: Distance>(
    start x: DomainFP,
    transformation f: Transformation<DomainFP>,
    definitionSpace p: UnaryPredicate<DomainFP>
) -> Bool{
    // Precondition: p(x) ⇔ f(x) is defined
    return !p(collisionPoint(start: x,
                             transformation: f,
                             definitionSpace: p))
}

func collisionPointNonterminatingOrbit<DomainF: Distance>(
    start x: DomainF,
    transformation f: Transformation<DomainF>
) -> DomainF {
    var slow = x            // slow = f^0(x)
    var fast = f(x)         // fast = f^1(x)
                            // n ← 0 (completed iterations)
    while fast != slow {    // slow = f^n(x) ∧ fast = f^{2 n + 1}(x)
        slow = f(slow)      // slow = f^{n+1}(x) ∧ fast = f^{2n+1}(x)
        fast = f(fast)      // slow = f^{n+1}(x) ∧ fast = f^{2n+2}(x)
        fast = f(fast)      // slow = f^{n+1}(x) ∧ fast = f^{2n+3}(x)
    }                       // n ← n + 1
    return fast             // slow = f^n(x) ∧ fast = f^{2n+1}(x)
    // Postcondition: return value is collision point
}

func circularNonterminatingOrbit<DomainF: Distance>(
    start x: DomainF,
    transformation f: Transformation<DomainF>
) -> Bool {
    let cp = collisionPointNonterminatingOrbit(start: x,
                                               transformation: f)
    return x == f(cp)
}

func circular<DomainFP: Distance>(
    start x: DomainFP,
    transformation f: Transformation<DomainFP>,
    definitionSpace p: UnaryPredicate<DomainFP>
) -> Bool {
    // Precondition: p(x) ⇔ f(x) is defined
    let y = collisionPoint(start: x,
                           transformation: f,
                           definitionSpace: p)
    return p(y) && x == f(y)
}

func convergentPoint<DomainF: Distance>(
    x0: DomainF,
    x1: DomainF,
    transformation f: Transformation<DomainF>
) -> DomainF {
    var x0 = x0, x1 = x1
    // Precondition: (∃n ∈ DistanceType(F)), n ≥ 0 ∧ f^n(x0) = f^n(x1)
    while x0 != x1 {
        x0 = f(x0)
        x1 = f(x1)
    }
    return x0
}

func connectionPointNonterminatingOrbit<DomainF: Distance>(
    start x: DomainF,
    transformation f: Transformation<DomainF>
) -> DomainF {
    let cp = collisionPointNonterminatingOrbit(start: x,
                                               transformation: f)
    return convergentPoint(x0: x,
                           x1: f(cp),
                           transformation: f)
}

func connectionPoint<DomainFP: Distance>(
    start x: DomainFP,
    transformation f: Transformation<DomainFP>,
    definitionSpace p: UnaryPredicate<DomainFP>
) -> DomainFP {
    // Precondition: p(x) ⇔ f(x) is defined
    let y = collisionPoint(start: x,
                           transformation: f,
                           definitionSpace: p)
    if !p(y) { return y }
    return convergentPoint(x0: x,
                           x1: f(y),
                           transformation: f)
}

/// Exercise 2.3

func convergentPointGuarded<DomainF: Distance>(
    x0: DomainF,
    x1: DomainF,
    y: DomainF,
    transformation f: Transformation<DomainF>
) -> DomainF {
    var x0 = x0, x1 = x1
    // Precondition: reachable(x0, y, f) ∧ reachable(x1, y, f)
    let d0 = x0.distance(to: y, transformation: f)
    let d1 = x1.distance(to: y, transformation: f)
    if d0 < d1 {
        x1 = powerUnary(x1, power: N(d1 - d0), transformation: f)
    } else if d1 < d0 {
        x0 = powerUnary(x0, power: N(d0 - d1), transformation: f)
    }
    return convergentPoint(x0: x0,
                           x1: x1,
                           transformation: f)
}

func orbitStructureNonterminatingOrbit<DomainF: Distance>(
    start x: DomainF,
    transformation f: Transformation<DomainF>
) -> Triple<DistanceType, DistanceType, DomainF> {
    let y = connectionPointNonterminatingOrbit(start: x,
                                               transformation: f)
    return Triple(m0: x.distance(to: y, transformation: f),
                  m1: f(y).distance(to: y, transformation: f),
                  m2: y)
}

func orbitStructure<DomainFP: Distance>(
    start x: DomainFP,
    transformation f: Transformation<DomainFP>,
    definitionSpace p: UnaryPredicate<DomainFP>
) -> Triple<DistanceType, DistanceType, DomainFP> {
    // Precondition: p(x) ⇔ f(x) is defined
    let y = connectionPoint(start: x,
                            transformation: f,
                            definitionSpace: p)
    let m = x.distance(to: y, transformation: f)
    var n = N(0)
    if p(y) { n = f(y).distance(to: y, transformation: f) }
    // Terminating: m = h - 1 ∧ n = 0
    // Otherwise:   m = h ∧ n = c - 1
    return Triple(m0: m, m1: n, m2: y)
}

