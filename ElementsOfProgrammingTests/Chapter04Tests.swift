//
//  Chapter04Tests.swift
//  ElementsOfProgrammingTests
//

import XCTest
import EOP

class Chapter04Tests: XCTestCase {

    func testDerivedRelations() {
        let lt: Relation<Int> = less
        let ge = complement(r: lt)
        let gt = converse(r: lt)
        let le = complementOfConverse(r: lt)
        let eq = symmetricComplement(r: lt)
        let ne = complement(r: eq)

        propertyTotalOrdering(r: lt, x0: 0, x1: 1, x2: 2)
        propertyReflexiveTotalOrdering(r: ge, x0: 2, x1: 1, x2: 0)
        propertyTotalOrdering(r: gt, x0: 2, x1: 1, x2: 0)
        propertyReflexiveTotalOrdering(r: le, x0: 0, x1: 1, x2: 2)
        propertyTransitive(r: eq, x: 0, y: 0, z: 0)

        XCTAssert(ge(4, 3))
        XCTAssert(gt(4, 3))
        XCTAssert(le(3, 4))
        XCTAssert(le(4, 4))
        XCTAssert(eq(4, 4))
        XCTAssert(ne(3, 4))
    }

    func testKeyOrdering() {
        typealias PID = Pair<Int, Double>
        let fst: UnaryFunction<Pair<Int, Double>, Int> = first
        let ls: Relation<Int> = less
        let ko = keyOrdering(f: fst, r: ls)
        XCTAssert(ko(PID(m0: 1, m1: 2.0), PID(m0: 2, m1: 1.0)))
        XCTAssert(!ko(PID(m0: 1, m1: 2.0), PID(m0: 1, m1: 1.0)))
        XCTAssert(!ko(PID(m0: 1, m1: 1.0), PID(m0: 1, m1: 2.0)))

        // clusters: != > <= >= -- see concept_TotallyOrdered
    }

    func testOrderSelection() {
        let a = 3
        let b = 3
        let c = 4
        let d = 4
        XCTAssert(select_0_2(a: a, b: b, r: less) == a)
        XCTAssert(select_0_2(a: b, b: a, r: less) == b)
        XCTAssert(select_0_2(a: a, b: c, r: less) == a)
        XCTAssert(select_0_2(a: c, b: a, r: less) == a)
        XCTAssert(select_0_2(a: a, b: c, r: less) == a)
        XCTAssert(select_0_2(a: c, b: a, r: less) == a)

        XCTAssert(select_1_2(a: a, b: b, r: less) == b)
        XCTAssert(select_1_2(a: b, b: a, r: less) == a)
        XCTAssert(select_1_2(a: a, b: c, r: less) == c)
        XCTAssert(select_1_2(a: c, b: a, r: less) == c)
        XCTAssert(select_1_2(a: a, b: c, r: less) == c)
        XCTAssert(select_1_2(a: c, b: a, r: less) == c)

        let p1 = Pair(m0: 1, m1: 1)
        let p2 = Pair(m0: 1, m1: 2)
        XCTAssert(select_0_2(ia: 1, ib: 2, a: p1, b: p2, r: lessFirst) == p1)
        XCTAssert(select_0_2(ia: 1, ib: 2, a: p2, b: p1, r: lessFirst) == p2)
        XCTAssert(select_1_2(ia: 1, ib: 2, a: p1, b: p2, r: lessFirst) == p2)
        XCTAssert(select_1_2(ia: 1, ib: 2, a: p2, b: p1, r: lessFirst) == p1)

        XCTAssert(select_0_3(a: a, b: b, c: c, r: less) == a)
        XCTAssert(select_0_3(a: a, b: c, c: b, r: less) == a)
        XCTAssert(select_0_3(a: b, b: a, c: c, r: less) == b)
        XCTAssert(select_0_3(a: b, b: c, c: a, r: less) == b)
        XCTAssert(select_0_3(a: c, b: a, c: b, r: less) == a)
        XCTAssert(select_0_3(a: c, b: b, c: a, r: less) == b)
        XCTAssert(select_0_3(a: a, b: c, c: d, r: less) == a)
        XCTAssert(select_0_3(a: c, b: a, c: d, r: less) == a)
        XCTAssert(select_0_3(a: d, b: c, c: a, r: less) == a)

        XCTAssert(select_2_3(a: b, b: c, c: d, r: less) == d)
        XCTAssert(select_2_3(a: c, b: b, c: d, r: less) == d)
        XCTAssert(select_2_3(a: b, b: d, c: c, r: less) == c)
        XCTAssert(select_2_3(a: d, b: b, c: c, r: less) == c)
        XCTAssert(select_2_3(a: c, b: d, c: b, r: less) == d)
        XCTAssert(select_2_3(a: d, b: c, c: b, r: less) == c)
        XCTAssert(select_2_3(a: a, b: c, c: d, r: less) == d)
        XCTAssert(select_2_3(a: c, b: a, c: d, r: less) == c)
        XCTAssert(select_2_3(a: d, b: c, c: a, r: less) == c)

        // Test select13ab

        XCTAssert(select_1_3(a: a, b: b, c: c, r: less) == b)
        XCTAssert(select_1_3(a: a, b: c, c: b, r: less) == b)
        XCTAssert(select_1_3(a: b, b: a, c: c, r: less) == a)
        XCTAssert(select_1_3(a: b, b: c, c: a, r: less) == a)
        XCTAssert(select_1_3(a: c, b: a, c: b, r: less) == b)
        XCTAssert(select_1_3(a: c, b: b, c: a, r: less) == a)
        XCTAssert(select_1_3(a: a, b: c, c: d, r: less) == c)
        XCTAssert(select_1_3(a: c, b: a, c: d, r: less) == c)
        XCTAssert(select_1_3(a: d, b: c, c: a, r: less) == c)

        // Test select_1_4_ab_cd
        // Test select_1_4_ab
        // FIXME: Fix these tests
//        algorithmSelect_1_4()
//        algorithmSelect_1_4_stabilityIndices()
        algorithmSelect_2_5_stabilityIndices()
    }

    // FIXME: Fix this test
//    func testMedian() {
//        let ca = 1, cb = 2, cc = 3, cd = 4, ce = 5
//        let b = 12, d = 14
//        XCTAssert(median_5(a: 1, b: cb, c: b, d: d, e: 15, r: less) == 12)
//        XCTAssert(median_5(a: ca, b: cb, c: cc, d: cd, e: ce, r: less) == 3)
//        algorithmMedian5()
//    }

    func testMinMax() {
        typealias P = Pair
        XCTAssert(minSelect(a: P(m0: "a", m1: 3), b: P(m0: "a", m1: 4)) == P(m0: "a", m1: 3))
        XCTAssert(minSelect(a: P(m0: "a", m1: 4), b: P(m0: "a", m1: 3)) == P(m0: "a", m1: 3))
        XCTAssert(maxSelect(a: P(m0: "a", m1: 3), b: P(m0: "a", m1: 4)) == P(m0: "a", m1: 4))
        XCTAssert(maxSelect(a: P(m0: "a", m1: 4), b: P(m0: "a", m1: 3)) == P(m0: "a", m1: 4))
    }

    func propertyTotalOrdering<DomainR: Regular>(r: Relation<DomainR>, x0: DomainR, x1: DomainR, x2: DomainR) {
        // Precondition: total_ordering(r) /\ r(x0, x1) /\ r(x1, x2)

        XCTAssert(r(x0, x1) && r(x1, x2))

        propertyTransitive(r: r, x: x0, y: x1, z: x2)

        XCTAssert(r(x0, x1) && !(x0 == x1) && !r(x1, x0)) // trichotomy
        XCTAssert(!r(x0, x0)) // irreflexive
    }

    func propertyTransitive<DomainR: Regular>(r: Relation<DomainR>, x: DomainR, y: DomainR, z: DomainR) {
        Concept.relation(r: r, x: x)
        XCTAssert(!r(x, y) || !r(y, z) || r(x, z))
    }

    func propertyReflexiveTotalOrdering<DomainR: Regular>(r: Relation<DomainR>, x0: DomainR, x1: DomainR, x2: DomainR) {
        // Precondition: total_ordering(r) /\ r(x0, x1) /\ r(x1, x2)

        XCTAssert(r(x0, x1) && r(x1, x2))

        propertyTransitive(r: r, x: x0, y: x1, z: x2)
        propertyTransitive(r: r, x: x0, y: x0, z: x1)
        propertyTransitive(r: r, x: x0, y: x1, z: x1)
        propertyTransitive(r: r, x: x0, y: x0, z: x0)

        XCTAssert(!r(x0, x1) || !r(x1, x0) || x0 == x1) // antisymmetric
        XCTAssert(r(x0, x0)) // reflexive
    }

    func first<T, U>(x: Pair<T, U>) -> T {
        return x.m0
    }

    func keyOrdering<DomainFR: Regular, CodomainFR: Regular>(
        f: @escaping UnaryFunction<DomainFR, CodomainFR>,
        r: @escaping Relation<CodomainFR>)
        -> Relation<DomainFR> {
        return { x, y in
            return r(f(x), f(y))
        }
    }

    func lessFirst<T0, T1>(p0: Pair<T0, T1>, p1: Pair<T0, T1>) -> Bool {
        return p0.m0 < p1.m0
    }

    // FIXME: Fix these methods
//    func algorithmSelect_1_4() {
//        typealias T = Pair
//        let t = pointer(T(m0: 1, m1: 1), T(m0: 2, m1: 2), T(m0: 2, m1: 3), T(m0: 3, m1: 4))
//        let l = t.advanced(by: 4)
//        let ls: Relation<Pair<Int, Int>> = lessSecond
//        repeat {
//            let fst: UnaryFunction<Pair<Int, Int>, Int> = first
//            let ls: Relation<Int> = less
//            let ko = keyOrdering(f: fst, r: ls)
//            let r = select_1_4(a: t[0], b: t[1], c: t[2], d: t[3], r: ko)
//            let eqf: UnaryPredicate<Pair<Int, Int>> = eqFirst(x: 2)
//            let f = findIf(f: t, l: l, p: eqf)
//            XCTAssert(f != l && source(f) == r)
//        } while nextPermutation(f: t, l: l, r: ls)
//    }
//
//    func algorithmSelect_1_4_stabilityIndices() {
//        typealias T = Pair
//        let t = pointer(T(m0: 1, m1: 1), T(m0: 2, m1: 2), T(m0: 2, m1: 3), T(m0: 3, m1: 4))
//        let l = t.advanced(by: 4)
//        let ls: Relation<Pair<Int, Int>> = lessSecond
//        repeat {
//            let fst: UnaryFunction<Pair<Int, Int>, Int> = first
//            let ls: Relation<Int> = less
//            let ko = keyOrdering(f: fst, r: ls)
//            let r = select_1_4(ia: 0, ib: 1, ic: 2, id: 3, a: t[0], b: t[1], c: t[2], d: t[3], r: ko)
//            let eqf: UnaryPredicate<Pair<Int, Int>> = eqFirst(x: 2)
//            let f = findIf(f: t, l: l, p: eqf)
//            XCTAssert(f != l && source(f) == r)
//        } while nextPermutation(f: t, l: l, r: ls)
//    }

    func algorithmSelect_2_5_stabilityIndices() {
        typealias P = Pair
        let R: Relation<Pair<String, Int>> = lessFirst
        let p0 = P(m0: "x", m1: 0)
        let p1 = P(m0: "x", m1: 1)
        let p2 = P(m0: "x", m1: 2)
        let p3 = P(m0: "x", m1: 3)
        let p4 = P(m0: "x", m1: 4)
        XCTAssert(select_2_5(ia: 0, ib: 1, ic: 2, id: 3, ie: 4, a: p0, b: p1, c: p2, d: p3, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 1, ic: 2, id: 4, ie: 3, a: p0, b: p1, c: p2, d: p4, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 1, ic: 3, id: 2, ie: 4, a: p0, b: p1, c: p3, d: p2, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 1, ic: 3, id: 4, ie: 2, a: p0, b: p1, c: p3, d: p4, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 1, ic: 4, id: 2, ie: 3, a: p0, b: p1, c: p4, d: p2, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 1, ic: 4, id: 3, ie: 2, a: p0, b: p1, c: p4, d: p3, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 2, ic: 1, id: 3, ie: 4, a: p0, b: p2, c: p1, d: p3, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 2, ic: 1, id: 4, ie: 3, a: p0, b: p2, c: p1, d: p4, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 2, ic: 3, id: 1, ie: 4, a: p0, b: p2, c: p3, d: p1, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 2, ic: 3, id: 4, ie: 1, a: p0, b: p2, c: p3, d: p4, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 2, ic: 4, id: 1, ie: 3, a: p0, b: p2, c: p4, d: p1, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 2, ic: 4, id: 3, ie: 1, a: p0, b: p2, c: p4, d: p3, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 3, ic: 1, id: 2, ie: 4, a: p0, b: p3, c: p1, d: p2, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 3, ic: 1, id: 4, ie: 2, a: p0, b: p3, c: p1, d: p4, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 3, ic: 2, id: 1, ie: 4, a: p0, b: p3, c: p2, d: p1, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 3, ic: 2, id: 4, ie: 1, a: p0, b: p3, c: p2, d: p4, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 3, ic: 4, id: 1, ie: 2, a: p0, b: p3, c: p4, d: p1, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 3, ic: 4, id: 2, ie: 1, a: p0, b: p3, c: p4, d: p2, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 4, ic: 1, id: 2, ie: 3, a: p0, b: p4, c: p1, d: p2, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 4, ic: 1, id: 3, ie: 2, a: p0, b: p4, c: p1, d: p3, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 4, ic: 2, id: 1, ie: 3, a: p0, b: p4, c: p2, d: p1, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 4, ic: 2, id: 3, ie: 1, a: p0, b: p4, c: p2, d: p3, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 4, ic: 3, id: 1, ie: 2, a: p0, b: p4, c: p3, d: p1, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 0, ib: 4, ic: 3, id: 2, ie: 1, a: p0, b: p4, c: p3, d: p2, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 0, ic: 2, id: 3, ie: 4, a: p1, b: p0, c: p2, d: p3, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 0, ic: 2, id: 4, ie: 3, a: p1, b: p0, c: p2, d: p4, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 0, ic: 3, id: 2, ie: 4, a: p1, b: p0, c: p3, d: p2, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 0, ic: 3, id: 4, ie: 2, a: p1, b: p0, c: p3, d: p4, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 0, ic: 4, id: 2, ie: 3, a: p1, b: p0, c: p4, d: p2, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 0, ic: 4, id: 3, ie: 2, a: p1, b: p0, c: p4, d: p3, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 2, ic: 0, id: 3, ie: 4, a: p1, b: p2, c: p0, d: p3, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 2, ic: 0, id: 4, ie: 3, a: p1, b: p2, c: p0, d: p4, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 2, ic: 3, id: 0, ie: 4, a: p1, b: p2, c: p3, d: p0, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 2, ic: 3, id: 4, ie: 0, a: p1, b: p2, c: p3, d: p4, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 2, ic: 4, id: 0, ie: 3, a: p1, b: p2, c: p4, d: p0, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 2, ic: 4, id: 3, ie: 0, a: p1, b: p2, c: p4, d: p3, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 3, ic: 0, id: 2, ie: 4, a: p1, b: p3, c: p0, d: p2, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 3, ic: 0, id: 4, ie: 2, a: p1, b: p3, c: p0, d: p4, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 3, ic: 2, id: 0, ie: 4, a: p1, b: p3, c: p2, d: p0, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 3, ic: 2, id: 4, ie: 0, a: p1, b: p3, c: p2, d: p4, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 3, ic: 4, id: 0, ie: 2, a: p1, b: p3, c: p4, d: p0, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 3, ic: 4, id: 2, ie: 0, a: p1, b: p3, c: p4, d: p2, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 4, ic: 0, id: 2, ie: 3, a: p1, b: p4, c: p0, d: p2, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 4, ic: 0, id: 3, ie: 2, a: p1, b: p4, c: p0, d: p3, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 4, ic: 2, id: 0, ie: 3, a: p1, b: p4, c: p2, d: p0, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 4, ic: 2, id: 3, ie: 0, a: p1, b: p4, c: p2, d: p3, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 4, ic: 3, id: 0, ie: 2, a: p1, b: p4, c: p3, d: p0, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 1, ib: 4, ic: 3, id: 2, ie: 0, a: p1, b: p4, c: p3, d: p2, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 0, ic: 1, id: 3, ie: 4, a: p2, b: p0, c: p1, d: p3, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 0, ic: 1, id: 4, ie: 3, a: p2, b: p0, c: p1, d: p4, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 0, ic: 3, id: 1, ie: 4, a: p2, b: p0, c: p3, d: p1, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 0, ic: 3, id: 4, ie: 1, a: p2, b: p0, c: p3, d: p4, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 0, ic: 4, id: 1, ie: 3, a: p2, b: p0, c: p4, d: p1, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 0, ic: 4, id: 3, ie: 1, a: p2, b: p0, c: p4, d: p3, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 1, ic: 0, id: 3, ie: 4, a: p2, b: p1, c: p0, d: p3, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 1, ic: 0, id: 4, ie: 3, a: p2, b: p1, c: p0, d: p4, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 1, ic: 3, id: 0, ie: 4, a: p2, b: p1, c: p3, d: p0, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 1, ic: 3, id: 4, ie: 0, a: p2, b: p1, c: p3, d: p4, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 1, ic: 4, id: 0, ie: 3, a: p2, b: p1, c: p4, d: p0, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 1, ic: 4, id: 3, ie: 0, a: p2, b: p1, c: p4, d: p3, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 3, ic: 0, id: 1, ie: 4, a: p2, b: p3, c: p0, d: p1, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 3, ic: 0, id: 4, ie: 1, a: p2, b: p3, c: p0, d: p4, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 3, ic: 1, id: 0, ie: 4, a: p2, b: p3, c: p1, d: p0, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 3, ic: 1, id: 4, ie: 0, a: p2, b: p3, c: p1, d: p4, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 3, ic: 4, id: 0, ie: 1, a: p2, b: p3, c: p4, d: p0, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 3, ic: 4, id: 1, ie: 0, a: p2, b: p3, c: p4, d: p1, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 4, ic: 0, id: 1, ie: 3, a: p2, b: p4, c: p0, d: p1, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 4, ic: 0, id: 3, ie: 1, a: p2, b: p4, c: p0, d: p3, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 4, ic: 1, id: 0, ie: 3, a: p2, b: p4, c: p1, d: p0, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 4, ic: 1, id: 3, ie: 0, a: p2, b: p4, c: p1, d: p3, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 4, ic: 3, id: 0, ie: 1, a: p2, b: p4, c: p3, d: p0, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 2, ib: 4, ic: 3, id: 1, ie: 0, a: p2, b: p4, c: p3, d: p1, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 0, ic: 1, id: 2, ie: 4, a: p3, b: p0, c: p1, d: p2, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 0, ic: 1, id: 4, ie: 2, a: p3, b: p0, c: p1, d: p4, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 0, ic: 2, id: 1, ie: 4, a: p3, b: p0, c: p2, d: p1, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 0, ic: 2, id: 4, ie: 1, a: p3, b: p0, c: p2, d: p4, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 0, ic: 4, id: 1, ie: 2, a: p3, b: p0, c: p4, d: p1, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 0, ic: 4, id: 2, ie: 1, a: p3, b: p0, c: p4, d: p2, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 1, ic: 0, id: 2, ie: 4, a: p3, b: p1, c: p0, d: p2, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 1, ic: 0, id: 4, ie: 2, a: p3, b: p1, c: p0, d: p4, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 1, ic: 2, id: 0, ie: 4, a: p3, b: p1, c: p2, d: p0, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 1, ic: 2, id: 4, ie: 0, a: p3, b: p1, c: p2, d: p4, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 1, ic: 4, id: 0, ie: 2, a: p3, b: p1, c: p4, d: p0, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 1, ic: 4, id: 2, ie: 0, a: p3, b: p1, c: p4, d: p2, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 2, ic: 0, id: 1, ie: 4, a: p3, b: p2, c: p0, d: p1, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 2, ic: 0, id: 4, ie: 1, a: p3, b: p2, c: p0, d: p4, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 2, ic: 1, id: 0, ie: 4, a: p3, b: p2, c: p1, d: p0, e: p4, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 2, ic: 1, id: 4, ie: 0, a: p3, b: p2, c: p1, d: p4, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 2, ic: 4, id: 0, ie: 1, a: p3, b: p2, c: p4, d: p0, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 2, ic: 4, id: 1, ie: 0, a: p3, b: p2, c: p4, d: p1, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 4, ic: 0, id: 1, ie: 2, a: p3, b: p4, c: p0, d: p1, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 4, ic: 0, id: 2, ie: 1, a: p3, b: p4, c: p0, d: p2, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 4, ic: 1, id: 0, ie: 2, a: p3, b: p4, c: p1, d: p0, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 4, ic: 1, id: 2, ie: 0, a: p3, b: p4, c: p1, d: p2, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 4, ic: 2, id: 0, ie: 1, a: p3, b: p4, c: p2, d: p0, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 3, ib: 4, ic: 2, id: 1, ie: 0, a: p3, b: p4, c: p2, d: p1, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 0, ic: 1, id: 2, ie: 3, a: p4, b: p0, c: p1, d: p2, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 0, ic: 1, id: 3, ie: 2, a: p4, b: p0, c: p1, d: p3, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 0, ic: 2, id: 1, ie: 3, a: p4, b: p0, c: p2, d: p1, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 0, ic: 2, id: 3, ie: 1, a: p4, b: p0, c: p2, d: p3, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 0, ic: 3, id: 1, ie: 2, a: p4, b: p0, c: p3, d: p1, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 0, ic: 3, id: 2, ie: 1, a: p4, b: p0, c: p3, d: p2, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 1, ic: 0, id: 2, ie: 3, a: p4, b: p1, c: p0, d: p2, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 1, ic: 0, id: 3, ie: 2, a: p4, b: p1, c: p0, d: p3, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 1, ic: 2, id: 0, ie: 3, a: p4, b: p1, c: p2, d: p0, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 1, ic: 2, id: 3, ie: 0, a: p4, b: p1, c: p2, d: p3, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 1, ic: 3, id: 0, ie: 2, a: p4, b: p1, c: p3, d: p0, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 1, ic: 3, id: 2, ie: 0, a: p4, b: p1, c: p3, d: p2, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 2, ic: 0, id: 1, ie: 3, a: p4, b: p2, c: p0, d: p1, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 2, ic: 0, id: 3, ie: 1, a: p4, b: p2, c: p0, d: p3, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 2, ic: 1, id: 0, ie: 3, a: p4, b: p2, c: p1, d: p0, e: p3, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 2, ic: 1, id: 3, ie: 0, a: p4, b: p2, c: p1, d: p3, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 2, ic: 3, id: 0, ie: 1, a: p4, b: p2, c: p3, d: p0, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 2, ic: 3, id: 1, ie: 0, a: p4, b: p2, c: p3, d: p1, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 3, ic: 0, id: 1, ie: 2, a: p4, b: p3, c: p0, d: p1, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 3, ic: 0, id: 2, ie: 1, a: p4, b: p3, c: p0, d: p2, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 3, ic: 1, id: 0, ie: 2, a: p4, b: p3, c: p1, d: p0, e: p2, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 3, ic: 1, id: 2, ie: 0, a: p4, b: p3, c: p1, d: p2, e: p0, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 3, ic: 2, id: 0, ie: 1, a: p4, b: p3, c: p2, d: p0, e: p1, r: R).m1 == p2.m1)
        XCTAssert(select_2_5(ia: 4, ib: 3, ic: 2, id: 1, ie: 0, a: p4, b: p3, c: p2, d: p1, e: p0, r: R).m1 == p2.m1)
    }

    // FIXME: Fix this method
//    func algorithmMedian5() {
//        let i1 = 1, i2 = 2, i3 = 3, i4 = 4, i5 = 5
//        XCTAssert(select_2_5_ab_cd(ia: 0, ib: 1, ic: 2, id: 3, ie: 4, a: i4, b: i5, c: i2, d: i3, e: i1, r: less) == i3)
//        XCTAssert(select_2_5_ab(ia: 0, ib: 1, ic: 2, id: 3, ie: 4, a: i4, b: i5, c: i2, d: i3, e: i1, r: less) == i3)
//        XCTAssert(select_2_5(ia: 0, ib: 1, ic: 2, id: 3, ie: 4, a: i4, b: i5, c: i2, d: i3, e: i1, r: less) == i3)
//
//        let p = pointer(1, 2, 3, 4, 5)
//        let ls: Relation<Int> = less
//        repeat {
//            let m = select_2_5(ia: 0, ib: 1, ic: 2, id: 3, ie: 4, a: p[0], b: p[1], c: p[2], d: p[3], e: p[4], r: less)
//            XCTAssert(m == 3)
//        } while nextPermutation(f: p, l: p.advanced(by: 1), r: ls)
//    }

    // FIXME: Fix this method
//    func nextPermutation<T: Regular, DomainR: Regular>(f: Pointer<T>, l: Pointer<T>, r: Relation<DomainR>) -> Bool {
//        // Precondition: weak_ordering(r)
//        if (f == l || f.successor() == l) { return false }
//        var i = l.iteratorPredecessor!
//
//        while true {
//            let ii = i
//            i = i.predecessor()
//            if r(i.source!, ii.source!) {
//                var j = l
//                repeat {
//                    j = j.predecessor()
//                } while !r(i.source!, j.source!)
//                exchangeValues(x: i, y: j)
//                reverseBidirectional(f: ii, l: l)
//                return true
//            }
//            if i == f {
//                reverseBidirectional(f: f, l: l)
//                return false
//            }
//        }
//    }

    func eqFirst<T0, T1>(x: T0) -> UnaryPredicate<Pair<T0, T1>> {
        return { p in
            return p.m0 == x
        }
    }

    func lessSecond<T0, T1>(p0: Pair<T0, T1>, p1: Pair<T0, T1>) -> Bool {
        return p0.m1 < p1.m1
    }
}
