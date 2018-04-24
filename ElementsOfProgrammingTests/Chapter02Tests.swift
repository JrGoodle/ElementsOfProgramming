//
//  Chapter02Tests.swift
//  Chapter02Tests
//

import XCTest
import EOP

class Chapter02Tests: XCTestCase {

    func testAbs() {
        var i = 1
        while i < 100000000 {
            XCTAssert(abs(i) == i)
            XCTAssert(abs(-i) == i)
            i = 10 * i
        }
    }

    func testEuclideanNorm() {
        XCTAssert(euclideanNorm(x: 3, y: 4) == 5)
        XCTAssert(euclideanNorm(x: 3, y: 4, z: 5) == euclideanNorm(x: euclideanNorm(x: 3, y: 4), y: 5))
    }

    func testConceptTransformation() {
        Concept.transformation(f: sq, x: 2)

        let f = genOrbitTransformation(x: 0, h: 0, c: 5)
        Concept.transformation(f: f, x: 0)

        Concept.transformation(f: hf, x: 16)
    }

    func testUnaryPredicate() {
        Concept.unaryPredicate(p: genOrbitPredicate(x: 0, h: 0, c: 5), x: 0)
    }

    func testPowerUnary() {
        for i in 2..<5 {
            for j in 1..<5 {
                let tmp = powerUnary(i, power: N(j - 1), transformation: sq)
                XCTAssert(powerUnary(i, power: N(j),
                                     transformation: sq) == tmp * tmp)
            }
        }
    }

    func testDistance() {
        XCTAssert(2.distance(to: 65536, transformation: { $0 * $0 }) == 4)
    }

    func testAlgorithmsOrbit() {
        algorithmsOrbit(x: 0, h: 2, c: 11)
        algorithmsOrbit(x: 7, h: 97, c: 17)
        algorithmsOrbit(x: 0, h: 4, c: 2)
    }

    func testConvergentPointGuarded() {
        var cpg = convergentPointGuarded(x0: 1024, x1: 64,
                                         y: 1,
                                         transformation: hf)
        XCTAssert(cpg == 64)
        cpg = convergentPointGuarded(x0: 1025, x1: 65,
                                     y: 1,
                                     transformation: hf)
        XCTAssert(cpg == 32)
        cpg = convergentPointGuarded(x0: 64, x1: 1024,
                                     y: 1,
                                     transformation: hf)
        XCTAssert(cpg == 64)
        cpg = convergentPointGuarded(x0: 65, x1: 1025,
                                     y: 1,
                                     transformation: hf)
        XCTAssert(cpg == 32)
        cpg = convergentPointGuarded(x0: 1024, x1: 2047,
                                     y: 1,
                                     transformation: hf)
        XCTAssert(cpg == 1)
    }

    typealias IntType = Int32

    func testPerformanceAddingPreventingOverflow() {
        let value1: IntType = 1
        self.measure {
            for _ in 1...IntType.max / 100 {
                let _ = value1.addingPreventingOverflow(IntType.max)
            }
        }
    }

    func testPerformanceAddingReportingOverflow() {
        let value2: IntType = 1
        self.measure {
            for _ in 1...IntType.max / 100 {
                let _ = value2.addingReportingOverflow(IntType.max)
            }
        }
    }

    func sq<T: Multipliable>(x: T) -> T { return x * x }

    func hf(x: Int) -> Int { return x / 2 }

    func genOrbitTransformation(x: Int, h: N, c: N) -> Transformation<Int> {
        return { y in
            // Precondition: h < N(MaximumValue(I)) && c < N(MaximumValue(I))
            // Precondition: !negative(h) && !negative(c)
            var z = y
            let p = self.genOrbitPredicate(x: x, h: h, c: c)
            XCTAssert(p(z))
            z += 1
            if z == x + Int(h) + Int(c) {
                z = x + Int(h)
            }
            return z
        }
    }

    func genOrbitPredicate(x: Int, h: N, c: N) -> UnaryPredicate<Int> {
        return { y in
            // Precondition: h < N(MaximumValue(I)) && c < N(MaximumValue(I))
            // Precondition: !negative(h) && !negative(c)
            return x <= y && y < x + Int(h) + Int(c)
        }
    }

    func algorithmsOrbit(x: Int, h: DistanceType, c: DistanceType) {
        let p = genOrbitPredicate(x: x, h: h, c: c)
        let f = genOrbitTransformation(x: x, h: h, c: c)
        XCTAssert(c.isZero() == terminating(start: x,
                                            transformation: f,
                                            definitionSpace: p))
        if h.isZero() && !c.isZero() {
            XCTAssert(circular(start: x, transformation: f, definitionSpace: p))
            XCTAssert(circularNonterminatingOrbit(start: x, transformation: f))
        } else if !h.isZero() {
            XCTAssert(!circular(start: x, transformation: f, definitionSpace: p))
            if !c.isZero() {
                XCTAssert(!circularNonterminatingOrbit(start: x,
                                                       transformation: f))
            }
        }
        let y = connectionPoint(start: x, transformation: f, definitionSpace: p)
        XCTAssert(powerUnary(x, power: h, transformation: f) == y)
        if !c.isZero() {
            XCTAssert(y == connectionPointNonterminatingOrbit(start: x,
                                                              transformation: f))
        }
        var t = orbitStructure(start: x, transformation: f, definitionSpace: p)
        if c.isZero() { // terminating
            XCTAssert(t.m0 == h)
            XCTAssert(t.m1.isZero())
            XCTAssert(t.m2 == collisionPoint(start: x,
                                             transformation: f,
                                             definitionSpace: p))
        } else if h.isZero() { // circular
            XCTAssert(t.m0.isZero())
            XCTAssert(t.m1 == (c - 1))
            XCTAssert(t.m2 == x)
        } else { // rho-shaped
            XCTAssert(t.m0 == h)
            XCTAssert(t.m1 == (c - 1))
            XCTAssert(t.m2 == y)
        }
        if !c.isZero() {
            t = orbitStructureNonterminatingOrbit(start: x,
                                                  transformation: f)
            if h.isZero() { // circular
                XCTAssert(t.m0.isZero())
                XCTAssert(t.m1 == (c - 1))
                XCTAssert(t.m2 == x)
            } else { // rho-shaped
                XCTAssert(t.m0 == h)
                XCTAssert(t.m1 == (c - 1))
                XCTAssert(t.m2 == y)
            }
        }
    }

    func zero(_ a: Int) -> Bool {
        return a == 0
    }
}

extension FixedWidthInteger {
    func addingPreventingOverflow(
        _ rhs: Self
    ) -> (partialValue: Self, overflow: Bool) {
        if definitionSpacePredicateIntegerAddition(x: self, y: rhs) {
            return self.addingReportingOverflow(rhs)
        }
        return (self, false)
    }
}
