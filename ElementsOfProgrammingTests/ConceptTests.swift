//
//  ConceptTests.swift
//  ElementsOfProgrammingTests
//

import XCTest
import EOP

class Concept {

    // MARK: Chapter 1

    static func regular<T: Regular>(x: T) {
        // Default constructor (not really invoked until an object is initialized in Swift)
        var y: T

        // Equality
        XCTAssert(x == x)

        // Assignment
        y = x
        XCTAssert(y == x)

        // Copy constructor
        let xCopy = x
        XCTAssert(xCopy == x)

        // Default total ordering
        XCTAssert(!less(x: x, y: x))

        // Underlying type
        XCTAssert(type(of: x) == T.self)

        // Destructor
    }

    static func totallyOrdered<T: Regular>(x0: T, x1: T) {
        // Precondition: x0 < x1

        XCTAssert(x0 != x1)
        XCTAssert(!(x0 == x1))

        // Natural total ordering
        XCTAssert(!(x0 < x0))
        XCTAssert(x0 < x1)
        XCTAssert(x1 > x0)
        XCTAssert(x0 <= x1)
        XCTAssert(x1 >= x0)
        XCTAssert(!(x1 < x0))
        XCTAssert(!(x0 > x1))
        XCTAssert(!(x1 <= x0))
        XCTAssert(!(x0 >= x1))
    }

    // MARK: Chapter 2

    static func transformation<DomainF: Distance>(f: Transformation<DomainF>, x: DomainF) {
        typealias CodomainF = DomainF
        typealias X = DomainF
        typealias Y = CodomainF
        // X == Y
        var y = x
        XCTAssert(x == y)
        y = f(y)
        var n = N(1)
    }

    static func unaryPredicate<DomainP: Regular>(p: UnaryPredicate<DomainP>, x: DomainP) {
        typealias X = DomainP
        var x0: X, x1: X
        if p(x) {
            x0 = x
        } else {
            x1 = x
        }
    }

    // MARK: Chapter 3

    static func binaryOperation<DomainOp: Regular>(op: BinaryOperation<DomainOp>, x: DomainOp) {
        typealias CodomainOp = DomainOp
        typealias X = DomainOp
        typealias Y = CodomainOp
        var y = x
        XCTAssert(x == y)
        y = op(x, x)
    }

    static func integer(n: Int)  {
        typealias I = Int
        let k = I(11)
        Concept.regular(x: n)
        var m: I
        m = n + k
        m = n + k
        m = m - k
        m = m * k
        m = m / k
        m = m % k
        m = I(0) // ensure m < k
        Concept.totallyOrdered(x0: m, x1: k)
        m = n.successor()
        m = n.predecessor()
        m = m.twice()
        m = m.halfNonnegative()
        m = m.binaryScaleDownNonnegative(k: I(1))
        m = m.binaryScaleUpNonnegative(k: I(1))
        let bp = m.isPositive()
        let bn = m.isNegative()
        XCTAssert(!(bp && bn))
        let bz = m.isZero()
        XCTAssert((bz && !(bn || bp)) || (!bz && (bn || bp)))
        let b1 = m.isOne()
        XCTAssert(!(bz && b1))
        XCTAssert(!b1 || bp)
        let be = m.isEven()
        let bo = m.isOdd()
        XCTAssert(be != bo)
    }

    // MARK: Chapter 4

    static func relation<DomainR: Regular>(r: Relation<DomainR>, x: DomainR) {
        typealias X = DomainR
        let y: X, z: X
        if r(x,x) {
            y = x
        } else {
            z = x
        }
    }

    // MARK: Chapter 5

    static func orderedAdditiveSemigroup<T: OrderedAdditiveSemigroup>(x: T, y: T, z: T) {
        // Precondition: x < y
        Concept.regular(x: x)
        // + : T x T -> T
        let a = (x + y) + z
        let b = x + (y + z)
        XCTAssert(a == b)
        XCTAssert(x + y == y + x)
        Concept.totallyOrdered(x0: x, x1: y)
        XCTAssert(x + z < y + z)
    }

    static func orderedAdditiveMonoid<T: OrderedAdditiveMonoid>(x: T, y: T, z: T) {
        Concept.orderedAdditiveSemigroup(x: x, y: y, z: z)
        // 0 in T
        XCTAssert(x + T.additiveIdentity == x)
    }

    static func orderedAdditiveGroup<T: OrderedAdditiveGroup>(x: T, y: T, z: T) {
        // Precondition: x < y
        Concept.orderedAdditiveMonoid(x: x, y: y, z: z)
        // - : T -> T
        XCTAssert(x + (-x) == T.additiveIdentity)
    }

    static func cancellableMonoid<T: CancellableMonoid>(x: T, y: T, z: T) {
        // Precondition: x < y
        Concept.orderedAdditiveMonoid(x: x, y: y, z: z)
        // - : T x T -> T
        if x <= y {
            let z = y - x // defined
            XCTAssert(z + x == y)
        }
    }

    static func archimedeanMonoid<T: ArchimedeanMonoid>(x: T, y: T, z: T, n: QuotientType) {
        // Precondition: x < y
        Concept.cancellableMonoid(x: x, y: y, z: z)
        typealias N = QuotientType
        Concept.integer(n: n)
        // slow_remainder terminates for all positive arguments
    }

    static func archimedeanGroup<T: ArchimedeanGroup>(x: T, y: T, z: T, n: QuotientType) {
        // Precondition: x < y
        Concept.archimedeanMonoid(x: x, y: y, z: z, n: n)
        let tmp = x - y
        XCTAssert(tmp < T.additiveIdentity)
        XCTAssert(-tmp == y - x)
    }
}
