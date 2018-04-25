//
//  Chapter05Tests.swift
//  ElementsOfProgrammingTests
//

import XCTest
import EOP

class Chapter05Tests: XCTestCase {

    func testAlgorithmAbs() {
        algorithmAbs(Int32(1))
        algorithmAbs(Int64(1))
        algorithmAbs(Float(1.0))
        algorithmAbs(Double(1.0))
        algorithmAbs(Rational(numerator: 1, denominator: 2)!)
    }

    func testConceptArchimedeanGroupInt() {
        typealias T = Int
        let x = T(0)
        let y = T(1)
        let z = T(2)
        let n = QuotientType(3)
        Concept.archimedeanGroup(x: x, y: y, z: z, n: n)
    }

    func testConceptArchimedeanGroupRational() {
        typealias T = Rational
        let x = T(0)
        let y = T(1)
        let z = T(2)
        let n = QuotientType(3)
        Concept.archimedeanGroup(x: x, y: y, z: z, n: n)
    }

    func testConceptArchimedeanGroupDouble() {
        typealias T = Double
        let x = T(0.0)
        let y = T(1.0)
        let z = T(2.0)
        let n = QuotientType(3)
        Concept.archimedeanGroup(x: x, y: y, z: z, n: n)
    }

    func testAlgorithmsSlowQR() {
        algorithmsSlowQR(max: Int32(1000))
        algorithmsSlowQR(max: Int64(1000))
        algorithmsSlowQR(max: Rational(1000))
    }

    func testAlgorithmsQRNonnegative() {
        algorithmsSlowQRNonnegative(max: Int32(1000))
        algorithmsSlowQRNonnegative(max: Int64(1000))
        algorithmsSlowQRNonnegative(max: Rational(1000))
    }

    func testAlgorithmsQRNonnegativeFibonacci() {
        algorithmsSlowQRNonnegativeFibonacci(max: Int32(1000))
        algorithmsSlowQRNonnegativeFibonacci(max: Int64(1000))
        // FIXME: Fix this
//        algorithmsSlowQRNonnegativeFibonacci(max: Relation(1000))
    }

    func testAlgorithmsQRNonnegativeIterative() {
        algorithmsSlowQRNonnegativeIterative(max: Int32(1000))
        algorithmsSlowQRNonnegativeIterative(max: Int64(1000))
        // FIXME: Fix this
//        algorithmsSlowQRNonnegativeIterative(max: Relation(1000))
    }

    func testAlgorithmLargestDoubling() {
        algorithmsLargestDoubling(max: Int32(1000))
        algorithmsLargestDoubling(max: Int64(1000))
        algorithmsLargestDoubling(max: Double(1000.0))
        algorithmsLargestDoubling(max: Rational(1000))
    }

    func testSubtractiveGCDNonzero() {
        XCTAssert(subtractiveGCDNonzero(a: Int(1000), b: Int(990)) == Int(10))
        XCTAssert(subtractiveGCDNonzero(a: UInt(1000), b: UInt(990)) == UInt(10))
        XCTAssert(subtractiveGCDNonzero(a: Double(0.75), b: Double(0.5)) == Double(0.25))
        XCTAssert(subtractiveGCDNonzero(a: Rational(numerator: 3, denominator: 4)!,
                                        b: Rational(numerator: 1, denominator: 2)!) == Rational(numerator: 1, denominator: 4)!)
    }

    func testSubtractiveGCD() {
        XCTAssert(subtractiveGCD(a: 1000, b: 990) == 10)
        XCTAssert(subtractiveGCD(a: 1000, b: 0) == 1000)
        XCTAssert(subtractiveGCD(a: 0, b: 990) == 990)
        XCTAssert(subtractiveGCD(a: UInt(1000), b: UInt(990)) == UInt(10))
        XCTAssert(subtractiveGCD(a: UInt(1000), b: UInt(0)) == UInt(1000))
        XCTAssert(subtractiveGCD(a: UInt(0), b: UInt(990)) == UInt(990))
        XCTAssert(subtractiveGCD(a: 0.75, b: 0.5) == 0.25)
        XCTAssert(subtractiveGCD(a: 0.75, b: 0.0) == 0.75)
        XCTAssert(subtractiveGCD(a: 0.0, b: 0.5) == 0.5)
        XCTAssert(subtractiveGCD(a: Rational(numerator: 3, denominator: 4)!,
                                 b: Rational(numerator: 1, denominator: 2)!) == Rational(numerator: 1, denominator: 4)!)
        XCTAssert(subtractiveGCD(a: Rational(numerator: 3, denominator: 4)!,
                                 b: Rational(numerator: 0, denominator: 2)!) == Rational(numerator: 3, denominator: 4)!)
        XCTAssert(subtractiveGCD(a: Rational(numerator: 0, denominator: 4)!,
                                 b: Rational(numerator: 1, denominator: 2)!) == Rational(numerator: 1, denominator: 2)!)
    }

    func testFastSubtractiveGCD() {
        XCTAssert(fastSubtractiveGCD(a: 1000, b: 990) == 10)
        XCTAssert(fastSubtractiveGCD(a: 1000, b: 0) == 1000)
        XCTAssert(fastSubtractiveGCD(a: 0, b: 990) == 990)
        XCTAssert(fastSubtractiveGCD(a: UInt(1000), b: UInt(990)) == UInt(10))
        XCTAssert(fastSubtractiveGCD(a: UInt(1000), b: UInt(0)) == UInt(1000))
        XCTAssert(fastSubtractiveGCD(a: UInt(0), b: UInt(990)) == UInt(990))
        XCTAssert(fastSubtractiveGCD(a: 0.75, b: 0.5) == 0.25)
        XCTAssert(fastSubtractiveGCD(a: 0.75, b: 0.0) == 0.75)
        XCTAssert(fastSubtractiveGCD(a: 0.0, b: 0.5) == 0.5)
        XCTAssert(fastSubtractiveGCD(a: Rational(numerator: 3, denominator: 4)!,
                                     b: Rational(numerator: 1, denominator: 2)!) == Rational(numerator: 1, denominator: 4)!)
        XCTAssert(fastSubtractiveGCD(a: Rational(numerator: 3, denominator: 4)!,
                                     b: Rational(numerator: 0, denominator: 2)!) == Rational(numerator: 3, denominator: 4)!)
        XCTAssert(fastSubtractiveGCD(a: Rational(numerator: 0, denominator: 4)!,
                                     b: Rational(numerator: 1, denominator: 2)!) == Rational(numerator: 1, denominator: 2)!)
    }

    func testGCDEuclideanSemiring() {
        XCTAssert(gcdEuclideanSemiring(a: 1000, b: 990) == 10)
        XCTAssert(gcdEuclideanSemiring(a: 1000, b: 0) == 1000)
        XCTAssert(gcdEuclideanSemiring(a: 0, b: 990) == 990)
        XCTAssert(gcdEuclideanSemiring(a: UInt(1000), b: UInt(990)) == UInt(10))
        XCTAssert(gcdEuclideanSemiring(a: UInt(1000), b: UInt(0)) == UInt(1000))
        XCTAssert(gcdEuclideanSemiring(a: UInt(0), b: UInt(990)) == UInt(990))

        // TODO: Implement this test
//        typedef polynomial< rational<int> > Q_X
//        Q_X a = shift_left(Q_X(1), 2) - Q_X(1) // x^2 - 1
//        Q_X b = shift_left(Q_X(1), 1) + Q_X(1) // x   + 1
//        XCTAssert(gcdEuclideanSemiring<Q_X>(a, b) == b)
    }

//    func testGCDEuclideanSemimodule() {
//        // FIXME: Fix this
//        XCTAssert(gcdEuclideanSemimodule(a: 1000, b: 990) == 10)
//        XCTAssert(gcdEuclideanSemimodule(a: 1000, b: 0) == 1000)
//        XCTAssert(gcdEuclideanSemimodule(a: 0, b: 990) == 990)
//        XCTAssert(gcdEuclideanSemimodule(a: UInt(1000), b: UInt(990)) == UInt(10))
//        XCTAssert(gcdEuclideanSemimodule(a: UInt(1000), b: UInt(0)) == UInt(1000))
//        XCTAssert(gcdEuclideanSemimodule(a: UInt(0), b: UInt(990)) == UInt(990))
//        XCTAssert(gcdEuclideanSemimodule<double, long int>(0.75, 0.5) == 0.25)
//        XCTAssert(gcdEuclideanSemimodule<double, long int>(0.75, 0.0) == 0.75)
//        XCTAssert(gcdEuclideanSemimodule<double, long int>(0.0, 0.5) == 0.5)
//        XCTAssert(gcdEuclideanSemimodule(a: Rational(numerator: 3, denominator: 4)!,
//                                         b: Rational(numerator: 1, denominator: 2)!) == Rational(numerator: 1, denominator: 4)!)
//        XCTAssert(gcdEuclideanSemimodule(a: Rational(numerator: 3, denominator: 4)!,
//                                         b: Rational(numerator: 0, denominator: 2)!) == Rational(numerator: 3, denominator: 4)!)
//        XCTAssert(gcdEuclideanSemimodule(a: Rational(numerator: 0, denominator: 4)!,
//                                         b: Rational(numerator: 1, denominator: 2)!) == Rational(numerator: 1, denominator: 2)!)
//    }

    func testAlgorithmsSignedQR() {
        algorithmsSignedQR(min: Int32(-10), max: Int32(10))
        algorithmsSignedQR(min: Int64(-10), max: Int64(10))
        algorithmsSignedQR(min: Rational(-10), max: Rational(10))
    }

    func algorithmAbs<T: OrderedAdditiveGroup>(_ something: T) {
        // We need a nonzero number to test with; OrderedAdditiveGroup doesn't guarantee one
        XCTAssert(something > T.additiveIdentity)
        let x = something
        let y = x + something
        let z = y + something
        Concept.orderedAdditiveGroup(x: x, y: y, z: z) // need x < y < z

        XCTAssert(absoluteValue(T.additiveIdentity) == T.additiveIdentity)
        XCTAssert(absoluteValue(something) == something)
        XCTAssert(absoluteValue(-something) == something)
    }

    func algorithmsSlowQR<T: ArchimedeanMonoid & IntegerSpecialCaseProcedures>(max: T) {
        var a = T.additiveIdentity
        while a < max {
            var b = T.additiveIdentity.successor()
            while b < max {
                let r = slowRemainder(a: a, b: b)
                let q = slowQuotient(a: a, b: b)
                XCTAssert(power(a: b, n: q, op: plus, id: T.additiveIdentity) + r == a)
                b = b.successor()
            }
            a = a.successor()
        }
    }

    func algorithmsSlowQRNonnegative<T: ArchimedeanMonoid & IntegerSpecialCaseProcedures>(max: T) {
        var a = T.additiveIdentity
        while a < max {
            var b = T.additiveIdentity.successor()
            while b < max {
                let r = remainderNonnegative(a: a, b: b)
                let qr = quotientRemainderNonnegative(a: a, b: b)
                XCTAssert(qr.m1 == r)
                XCTAssert(power(a: b, n: qr.m0, op: plus, id: T.additiveIdentity) + r == a)
                b = b.successor()
            }
            a = a.successor()
        }
    }

    func algorithmsSlowQRNonnegativeFibonacci<T: ArchimedeanMonoid & IntegerSpecialCaseProcedures>(max: T) {
        var a = T.additiveIdentity
        while a < max {
            var b = T.additiveIdentity.successor()
            while b < max {
                let r = remainderNonnegativeFibonacci(a: a, b: b)
                // FIXME: Fix this
//                let qr = quotientRemainderNonnegativeFibonacci
//                XCTAssert(Int(r) == Int(a) % Int(b))
//                XCTAssert(qr.m1 == r)
//                XCTAssert(power(a: b, n: qr.m0, op: plus, id: T.additiveIdentity) + r == a)
                b = b.successor()
            }
            a = a.successor()
        }
    }

    func algorithmsSlowQRNonnegativeIterative<T: ArchimedeanMonoid & IntegerSpecialCaseProcedures & Halvable>(max: T) {
        var a = T.additiveIdentity
        while a < max {
            var b = T.additiveIdentity.successor()
            while b < max {
                let r = remainderNonnegativeFibonacci(a: a, b: b)
                let qr = quotientRemainderNonnegativeIterative(a: a, b: b)
                // FIXME: Fix this
//                XCTAssert(Int(r) == Int(a) % Int(b))
                XCTAssert(qr.m1 == r)
//                XCTAssert(Int(qr.m0) == Int(a) / Int(b))
                XCTAssert(power(a: b, n: qr.m0, op: plus, id: T.additiveIdentity) + r == a)
                b = b.successor()
            }
            a = a.successor()
        }
    }

    func algorithmsLargestDoubling<T: ArchimedeanMonoid & IntegerSpecialCaseProcedures & Halvable>(max: T) {
        var a = T.additiveIdentity
        while a < max {
            var b = T.additiveIdentity.successor()
            while b <= a {
                let d = largestDoubling(a: a, b: b)
                // FIXME: Fix this
//                XCTAssert(Int(d) % Int(b) == 0) // it is an integral multiple of b
//                let = Int(d) / Int(b) // n = the integral multiple
//                XCTAssert(largestPowerOfTwo(n) == n) // n is a power of 2; it is a doubling
                XCTAssert(d <= a && d > a - d) // it is the largest
                b = b.successor()
            }
            a = a.successor()
        }
    }

    func algorithmsSignedQR<T: ArchimedeanGroup & IntegerSpecialCaseProcedures>(min: T, max: T) {
        var a = min
        while a <= max {
            var b = a
            while b <= max {
                if b != T.additiveIdentity {
                    let r = remainder(a: a, b: b, rem: remainderNonnegative)
                    XCTAssert(absoluteValue(r) < absoluteValue(b))
                    let qr = quotientRemainder(a: a, b: b, quoRem: agQuotientRemainder)
                    XCTAssert(qr.m1 == r)
                    // FIXME: Fix this
//                    XCTAssert(qr.m0 * b + r == a)
                }
                b = b.successor()
            }
            a = a.successor()
        }
    }

    func agQuotientRemainder<T: ArchimedeanGroup>(a: T, b: T) -> Pair<QuotientType, T> {
        XCTAssert(a >= T.additiveIdentity && b > T.additiveIdentity)
        return quotientRemainderNonnegative(a: a, b: b)
    }
}
