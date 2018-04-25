//
//  Chapter01Tests.swift
//  ElementsOfProgrammingTests
//

import XCTest
import EOP

class Chapter01Tests: XCTestCase {

    func testConceptRegular() {
        let n = Int(0)
        Concept.regular(x: n)
    }

    func testConceptTotallyOrderd() {
        let n0 = Int(0)
        let n1 = Int(1)
        Concept.regular(x: n0)
        Concept.totallyOrdered(x0: n0, x1: n1) // *****Concept.integer ?????
    }

    func testPlus() {
        XCTAssert(plus_0(a: 3 * 3, b: 4 * 4) == 5 * 5)
        var a = 3 * 3, b = 4 * 4
        XCTAssert(plus_1(a: &a, b: &b) == 5 * 5)

        // FIXME: Get this working again
//        let a = Pointer<Int>.allocate(capacity: 1)
//        a.initialize(to: 0, count: 1)
//        a.pointee = Int(3 * 3)
//        let b = Pointer<Int>.allocate(capacity: 1)
//        b.initialize(to: 0, count: 1)
//        b.pointee = Int(4 * 4)
//        let c = Pointer<Int>.allocate(capacity: 1)
//        c.initialize(to: 0, count: 1)
//        plus2(a: a, b: b, c: c)
//        XCTAssert(c.pointee == 5 * 5)
    }

    func testSquare() {
        XCTAssert(square(n: 3) == 9)
        XCTAssert(square(x: 3, op: times) == 9)
    }

    func testTuples() {
        typealias P = Pair

        typePair(x00: 0, x01: 99, x10: "a", x11: "a")
        typePair(x00: 0, x01: 0, x10: "a", x11: "z")

        let a = "aZ".cString(using: .utf8)
        typePair(x00: P(m0: 0, m1: "a"), x01: P(m0: 1, m1: "Z"), x10: a![0], x11: a![1])

        // TODO: Implement this once related structs/functions are written
//        array<int> a0
//        array<int> a1(3, 3, 0)
//        iota(3, begin(a1))
//        type_pair< array<int>, char >(a0, a1, 'a', 'z')
//
//        slist<int> l0
//        slist<int> l1(a0)
//        type_pair< slist<int>, char >(l0, l1, 'a', 'z')
//
//        type_pair< array<int>, slist<int> >(a0, a1, l0, l1)

        typeTriple(x00: 0, x01: 99, x10: "a", x11: "z", x20: 1.0, x21: 2.0)
    }

    func typePair<T0: Regular, T1: Regular>(x00: T0, x01: T0, x10: T1, x11: T1) {
        // Precondition: x00 < x01 || (x00 == x01 && x10 < x11)
        XCTAssert(x00 < x01 || (x00 == x01 && x10 < x11))

        typealias P01 = Pair

        // Pair constructor
        let p0 = P01(m0: x00, m1: x10)
        let p1 = P01(m0: x01, m1: x11)

        // Regular
        Concept.regular(x: p0)
        Concept.totallyOrdered(x0: p0, x1: p1)

        // Member selection
        XCTAssert(p0.m0 == x00 && p0.m1 == x10)
    }

    func typeTriple<T0: Regular, T1: Regular, T2: Regular>(
        x00: T0, x01: T0,
        x10: T1, x11: T1,
        x20: T2, x21: T2) {
        XCTAssert(x00 < x01 || (x00 == x01 && (x10 < x11 || (x10 == x11 && x20 < x21))))

        typealias T = Triple

        // Triple constructor
        let t0 = Triple(m0: x00, m1: x10, m2: x20)
        let t1 = Triple(m0: x01, m1: x11, m2: x21)

        // Regular
        Concept.regular(x: t0)
        Concept.totallyOrdered(x0: t0, x1: t1)

        // Member selection
        XCTAssert(t0.m0 == x00 &&
                  t0.m1 == x10 &&
                  t0.m2 == x20)
    }

    func times<T: MultiplicativeSemigroup>(a: T, b: T) -> T {
        return a * b
    }
}
