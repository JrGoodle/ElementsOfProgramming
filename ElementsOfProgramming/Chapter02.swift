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
    x: DomainF,
    n: N,
    f: Transformation<DomainF>
) -> DomainF {
    var x = x, n = n
    assert(n >= 0, "n >= 0")
    // Precondition: n ≥ 0 ∧ (∀i ∈ N), 0 < i ≤ n ⇒ f^i(x) is defined
    
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
    // Precondition: p(x) ⇔ f(x) is defined
    if !p(x) { return x }
    
    var slow = x            // $slow = f^0(x)$
    var fast = f(x)         // $fast = f^1(x)$
                            // $n \gets 0$ (completed iterations)
    #if !XCODE
        var ft = [x, fast]
        var st = [x]
    #endif
    
    while fast != slow {    // $slow = f^n(x) \wedge fast = f^{2 n + 1}(x)$
        slow = f(slow)      // $slow = f^{n+1}(x) \wedge fast = f^{2 n + 1}(x)$
        
        #if !XCODE
            st.append(slow)
        #endif
        
        if !p(fast) { return fast }
        fast = f(fast)      // $slow = f^{n+1}(x) \wedge fast = f^{2 n + 2}(x)$
        
        #if !XCODE
            ft.append(fast)
        #endif
        
        if !p(fast) { return fast }
        fast = f(fast)      // $slow = f^{n+1}(x) \wedge fast = f^{2 n + 3}(x)$
        
        #if !XCODE
            ft.append(fast)
        #endif
    }                       // $n \gets n + 1$
    
    #if !XCODE
        ft.map { $0 }
        st.map { $0 }
    #endif
    
    return fast             // $slow = f^n(x) \wedge fast = f^{2 n + 1}(x)$
    // Postcondition: return value is terminal point or collision point
}

func terminating<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
) -> Bool{
    // Precondition: p(x) ⇔ f(x) is defined
    return !p(collisionPoint(x: x, f: f, p: p))
}

func collisionPointNonterminatingOrbit<DomainF: Distance>(
    x: DomainF,
    f: Transformation<DomainF>
) -> DomainF {
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
    return x == f(collisionPointNonterminatingOrbit(x: x, f: f))
}

func circular<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
) -> Bool {
    // Precondition: p(x) ⇔ f(x) is defined
    let y = collisionPoint(x: x, f: f, p: p)
    return p(y) && x == f(y)
}

func convergentPoint<DomainF: Distance>(
    x0: DomainF,
    x1: DomainF,
    f: Transformation<DomainF>
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
    x: DomainF,
    f: Transformation<DomainF>
) -> DomainF {
    return convergentPoint(x0: x,
                           x1: f(collisionPointNonterminatingOrbit(x: x, f: f)),
                           f: f)
}

func connectionPoint<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
) -> DomainFP {
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
    // Precondition: p(x) ⇔ f(x) is defined
    let y = connectionPoint(x: x, f: f, p: p)
    let m = x.distance(to: y, f: f)
    var n = N(0)
    if p(y) { n = f(y).distance(to: y, f: f) }
    // Terminating: m = h - 1 ∧ n = 0
    // Otherwise:   m = h ∧ n = c - 1
    return Triple(m0: m, m1: n, m2: y)
}

//definitionSpacePredicate32BitSignedAddition(x: Int32.max, y: Int32.min)
//definitionSpacePredicate32BitSignedAddition(x: Int32.max - 1, y: Int32.max)
//definitionSpacePredicate32BitSignedAddition(x: Int64.max, y: Int64.min)
//definitionSpacePredicate32BitSignedAddition(x: Int64.max - 1, y: Int64.max)
//definitionSpacePredicate32BitSignedAddition(x: UInt.max, y: UInt.min)
//definitionSpacePredicate32BitSignedAddition(x: UInt.max - 1, y: UInt.max)

//let f: Transformation<UInt> = { ($0 % 113 + 2) * 2 }
//let p: UnaryPredicate<UInt> = { _ in return true }
//let x: UInt = 0
//orbitStructure(x: x, f: f, p: p)
