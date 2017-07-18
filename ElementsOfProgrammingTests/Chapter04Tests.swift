//
//  Chapter04Tests.swift
//  ElementsOfProgrammingTests
//

import XCTest

class Chapter04Testts: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDerivedRelations() {
        let lt: Relation<Int> = less
        let ge = complement(r: lt)
        let gt = converse(r: lt)
        let le = complementOfConverse(r: lt)
        let eq = symmetricComplement(r: lt)
        let ne = complement(r: eq)
        
        propertyTotalyOrdering(r: lt, x0: 0, x1: 1, x2: 2)
        propertyReflexiveTotalOrdering(r: ge, x0: 2, x1: 1, x2: 0)
        propertyTotalyOrdering(r: gt, x0: 2, x1: 1, x2: 0)
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
//        typealias F = first<int, double>
//        F fst
//        typedef pair<int, double> PID
//        key_ordering< F, less<int> > ko(fst, less)
//        Assert(ko(PID(1, 2.0), PID(2, 1.0)))
//        Assert(!ko(PID(1, 2.0), PID(1, 1.0)))
//        Assert(!ko(PID(1, 1.0), PID(1, 2.0)))
        
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
        // TODO: Finish implementing
        let a = 3
        let b = 3
        let c = 4
        let d = 4
        XCTAssert(select02(a: a, b: b, r: less) == a)
        XCTAssert(select02(a: b, b: a, r: less) == b)
        XCTAssert(select02(a: a, b: c, r: less) == a)
        XCTAssert(select02(a: c, b: a, r: less) == a)
        XCTAssert(select02(a: a, b: c, r: less) == a)
        XCTAssert(select02(a: c, b: a, r: less) == a)

        XCTAssert(select12(a: a, b: b, r: less) == b)
        XCTAssert(select12(a: b, b: a, r: less) == a)
        XCTAssert(select12(a: a, b: c, r: less) == c)
        XCTAssert(select12(a: c, b: a, r: less) == c)
        XCTAssert(select12(a: a, b: c, r: less) == c)
        XCTAssert(select12(a: c, b: a, r: less) == c)

//        let p1 = Pair(m0: 1, m1: 1)
//        let p2 = Pair(m0: 1, m1: 2)
//        let R: Relation<Pair<Int, Int>> = lessFirst
//        XCTAssert(select02(ia: 1, ib: 2, a: p1, b: p2, r: lessFirst))
//        XCTAssert(select02<1, 2, R>(p1, p2, R()) == p1)
//        XCTAssert(select02<1, 2, R>(p2, p1, R()) == p2)
//        XCTAssert(select12<1, 2, R>(p1, p2, R()) == p2)
//        XCTAssert(select12<1, 2, R>(p2, p1, R()) == p1)

        XCTAssert(select03(a: a, b: b, c: c, r: less) == a)
        XCTAssert(select03(a: a, b: c, c: b, r: less) == a)
        XCTAssert(select03(a: b, b: a, c: c, r: less) == b)
        XCTAssert(select03(a: b, b: c, c: a, r: less) == b)
        XCTAssert(select03(a: c, b: a, c: b, r: less) == a)
        XCTAssert(select03(a: c, b: b, c: a, r: less) == b)
        XCTAssert(select03(a: a, b: c, c: d, r: less) == a)
        XCTAssert(select03(a: c, b: a, c: d, r: less) == a)
        XCTAssert(select03(a: d, b: c, c: a, r: less) == a)

        XCTAssert(select23(a: b, b: c, c: d, r: less) == d)
        XCTAssert(select23(a: c, b: b, c: d, r: less) == d)
        XCTAssert(select23(a: b, b: d, c: c, r: less) == c)
        XCTAssert(select23(a: d, b: b, c: c, r: less) == c)
        XCTAssert(select23(a: c, b: d, c: b, r: less) == d)
        XCTAssert(select23(a: d, b: c, c: b, r: less) == c)
        XCTAssert(select23(a: a, b: c, c: d, r: less) == d)
        XCTAssert(select23(a: c, b: a, c: d, r: less) == c)
        XCTAssert(select23(a: d, b: c, c: a, r: less) == c)

        // Test select13ab

        XCTAssert(select13(a: a, b: b, c: c, r: less) == b)
        XCTAssert(select13(a: a, b: c, c: b, r: less) == b)
        XCTAssert(select13(a: b, b: a, c: c, r: less) == a)
        XCTAssert(select13(a: b, b: c, c: a, r: less) == a)
        XCTAssert(select13(a: c, b: a, c: b, r: less) == b)
        XCTAssert(select13(a: c, b: b, c: a, r: less) == a)
        XCTAssert(select13(a: a, b: c, c: d, r: less) == c)
        XCTAssert(select13(a: c, b: a, c: d, r: less) == c)
        XCTAssert(select13(a: d, b: c, c: a, r: less) == c)

        // Test select14abcd
        // Test select14ab
        algorithmSelect14()
        algorithmSelect14StabilityIndices()
        algorithmSelect25StabilityIndices()
    }
    
    func testMedian() {
        let ca = 1, cb = 2, cc = 3, cd = 4, ce = 5
        let b = 12, d = 14
        XCTAssert(median5(a: 1, b: cb, c: b, d: d, e: 15, r: less) == 12)
        XCTAssert(median5(a: ca, b: cb, c: cc, d: cd, e: ce, r: less) == 3)
        algorithmMedian5()
    }
    
    func testMinMax() {
        typealias P = Pair
        XCTAssert(minSelect(a: P(m0: "a", m1: 3), b: P(m0: "a", m1: 4)) == P(m0: "a", m1: 3))
        XCTAssert(minSelect(a: P(m0: "a", m1: 4), b: P(m0: "a", m1: 3)) == P(m0: "a", m1: 3))
        XCTAssert(maxSelect(a: P(m0: "a", m1: 3), b: P(m0: "a", m1: 4)) == P(m0: "a", m1: 4))
        XCTAssert(maxSelect(a: P(m0: "a", m1: 4), b: P(m0: "a", m1: 3)) == P(m0: "a", m1: 4))
    }
    
    func propertyTotalyOrdering<DomainR: Regular>(r: Relation<DomainR>, x0: DomainR, x1: DomainR, x2: DomainR) {
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
    
    func keyOrdering<DomainFR: TotallyOrdered, CodomainFR: TotallyOrdered>(
        f: @escaping UnaryFunction<DomainFR, CodomainFR>,
        r: @ escaping Relation<CodomainFR>)
        -> Relation<DomainFR> {
        return { x, y in
            return r(f(x), f(y))
        }
    }

    func lessFirst<T0, T1>(p0: Pair<T0, T1>, p1: Pair<T0, T1>) -> Bool {
        return p0.m0 < p1.m0
    }
    
    func algorithmSelect14() {
        // TODO: Implement
        typealias T = Pair
        let l = pointer(T(m0: 1, m1: 1), T(m0: 2, m1: 2), T(m0: 2, m1: 3), T(m0: 3, m1: 4))
        repeat {
            let fst: UnaryFunction<Pair<Int, Int>, Int> = first
            let ls: Relation<Int> = less
            let ko = keyOrdering(f: fst, r: ls)
            let r = select14(a: l[0], b: l[1], c: l[2], d: l[3], r: ko)
            let eqf: (Pair<Int, Int>) -> Bool = eqFirst(x: 2)
//            let f = findIf(f: l.pointee, l: l, p: eqf)
//            XCTAssert(f != l && source(f) == r)
        } while false
    }
    
    func algorithmSelect14StabilityIndices() {
        // TODO: Implement
    }
    
    func algorithmSelect25StabilityIndices() {
        // TODO: Implement
    }
    
    func algorithmMedian5() {
        // TODO: Implement
    }
    
    func nextPermutation<I, DomainR: TotallyOrdered>(f: I, l: I, r: Relation<DomainR>) -> Bool {
        // TODO: Implement
        // Precondition: weak_ordering(r)
        return false
    }
    
    func eqFirst<T0, T1>(x: T0) -> UnaryPredicate<Pair<T0, T1>> {
        return { p in
            return p.m0 == x
        }
    }
}
