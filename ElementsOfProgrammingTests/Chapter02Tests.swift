//
//  Chapter02Tests.swift
//  Chapter02Tests
//

import XCTest

class ElementsOfProgrammingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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
        conceptTransformation(f: sq, x: 2)
        
        let f = genOrbitTransformation(x: 0, h: 0, c: 5)
        conceptTransformation(f: f, x: 0)
        
        conceptTransformation(f: hf, x: 16)
    }
    
    func testUnaryPredicate() {
        conceptUnaryPredicate(p: genOrbitPredicate(x: 0, h: 0, c: 5), x: 0)
    }
    
    func testPowerUnary() {
        for i in 2..<5 {
            for j in 1..<5 {
                let tmp = powerUnary(x: i, n: j - 1, f: sq)
                XCTAssert(powerUnary(x: i, n: j, f: sq) == tmp * tmp)
            }
        }
    }
    
    func testDistance() {
        XCTAssert(distance(x: 2, y: 65536, f: { $0 * $0 }) == 4)
    }
    
    func testAlgorithmsOrbit() {
        algorithmsOrbit(x: 0, h: 2, c: 11)
        algorithmsOrbit(x: 7, h: 97, c: 17)
        algorithmsOrbit(x: 0, h: 4, c: 2)
    }
    
    func testConvergentPointGuarded() {
        var cpg = convergentPointGuarded(x0: 1024, x1: 64, y: 1, f: hf)
        XCTAssert(cpg == 64)
        cpg = convergentPointGuarded(x0: 1025, x1: 65, y: 1, f: hf)
        XCTAssert(cpg == 32)
        cpg = convergentPointGuarded(x0: 64, x1: 1024, y: 1, f: hf)
        XCTAssert(cpg == 64)
        cpg = convergentPointGuarded(x0: 65, x1: 1025, y: 1, f: hf)
        XCTAssert(cpg == 32)
        cpg = convergentPointGuarded(x0: 1024, x1: 2047, y: 1, f: hf)
        XCTAssert(cpg == 1)
    }
    
    func conceptTransformation<DomainF: RegularType>(f: Transformation<DomainF>, x: DomainF) {
        typealias CodomainF = DomainF
        typealias X = DomainF
        typealias Y = CodomainF
        // X == Y
        var y = x
        XCTAssert(x == y)
        y = f(y)
        typealias N = DistanceType
        var n = N(1)
    }
    
    func conceptUnaryPredicate<DomainP>(p: UnaryPredicate<DomainP>, x: DomainP) {
        typealias X = DomainP
        var x0: X, x1: X
        if p(x) {
            x0 = x
        } else {
            x1 = x
        }
    }
    
    func sq<T: Multipliable>(x: T) -> T { return x * x }
    
    func hf(x: Int) -> Int { return x / N(2) }
    
    func genOrbitTransformation(x: Int, h: N, c: N) -> ((Int) -> Int) {
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
    
    func genOrbitPredicate(x: Int, h: N, c: N) -> ((Int) -> Bool) {
        return { y in
            // Precondition: h < N(MaximumValue(I)) && c < N(MaximumValue(I))
            // Precondition: !negative(h) && !negative(c)
            return x <= y && y < x + Int(h) + Int(c)
        }
    }
    
    func algorithmsOrbit(x: Int, h: DistanceType, c: DistanceType) {
        typealias T = Int
        typealias N = DistanceType
        let p = genOrbitPredicate(x: x, h: h, c: c)
        let f = genOrbitTransformation(x: x, h: h, c: c)
        XCTAssert(zero(c) == terminating(x: x, f: f, p: p))
        if zero(h) && !zero(c) {
            XCTAssert(circular(x: x, f: f, p: p))
            XCTAssert(circularNonterminatingOrbit(x: x, f: f))
        } else if !zero(h) {
            XCTAssert(!circular(x: x, f: f, p: p))
            if !zero(c) {
                XCTAssert(!circularNonterminatingOrbit(x: x, f: f))
            }
        }
        let y = connectionPoint(x: x, f: f, p: p)
        XCTAssert(powerUnary(x: x, n: h, f: f) == y)
        if !zero(c) {
            XCTAssert(y == connectionPointNonterminatingOrbit(x: x, f: f))
        }
        var t = orbitStructure(x: x, f: f, p: p)
        if zero(c) { // terminating
            XCTAssert(t.m0 == h)
            XCTAssert(zero(t.m1))
            XCTAssert(t.m2 == collisionPoint(x: x, f: f, p: p))
        } else if zero(h) { // circular
            XCTAssert(zero(t.m0))
            XCTAssert(t.m1 == (c - 1))
            XCTAssert(t.m2 == x)
        } else { // rho-shaped
            XCTAssert(t.m0 == h)
            XCTAssert(t.m1 == (c - 1))
            XCTAssert(t.m2 == y)
        }
        if !zero(c) {
            t = orbitStructureNonterminatingOrbit(x: x, f: f)
            if zero(h) { // circular
                XCTAssert(zero(t.m0))
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
