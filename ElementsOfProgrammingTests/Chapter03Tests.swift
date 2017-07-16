//
//  Chapter03Tests.swift
//  ElementsOfProgrammingTests
//

import XCTest

class Chapter03Testts: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConceptBinaryOperation() {
        conceptBinaryOperation(op: minusInt, x: 7)
        conceptBinaryOperation(op: timesInt, x: 8)
    }
    
    func testPower() {
        XCTAssert(powerLeftAssociated(a: -2, n: 3, op: minusInt) == 2) // (-2 - -2) - -2 = 2
        XCTAssert(powerLeftAssociated(a: -2, n: 4, op: minusInt) == 4) // ((-2 - -2) - -2) - -2 = 4
        algorithmPower(pow: powerLeftAssociated)
        XCTAssert(powerRightAssociated(a: -2, n: 3, op: minusInt) == -2) // -2 - (-2 - -2) = -2
        XCTAssert(powerRightAssociated(a: -2, n: 4, op: minusInt) == 0) // -2 - (-2 - (-2 - -2) = 0
        algorithmPower(pow: powerRightAssociated)
        algorithmPower(pow: power0)
        algorithmPower(pow: power1)
        algorithmPowerAccumulate(pow: powerAccumulate0)
        algorithmPowerAccumulate(pow: powerAccumulate1)
        algorithmPowerAccumulate(pow: powerAccumulate2)
        algorithmPowerAccumulate(pow: powerAccumulate3)
        algorithmPowerAccumulate(pow: powerAccumulate4)
        algorithmPowerAccumulatePositive(pow: powerAccumulatePositive0)
        algorithmPowerAccumulate(pow: powerAccumulate5)
        algorithmPower(pow: power2)
        algorithmPower(pow: power3)
        algorithmPowerAccumulatePositive(pow: powerAccumulatePositive)
        algorithmPowerAccumulate(pow: powerAccumulate)
        algorithmPower(pow: power)
        algorithmPowerWithIdentity(pow: power)
    }
    
    func testConceptInteger() {
        typealias N = Int
        conceptInteger(n: N(7))
    }
    
    func testFibonacci() {
        typealias N = Int
        typealias Fib = Pair<N, N>
        
        conceptBinaryOperation(op: fibonacciMatrixMultiply, x: Fib(m0: N(1), m1: N(0)))
        
        let f10 = Fib(m0: 55, m1: 34)
        let f11 = Fib(m0: 89, m1: 55)
        let f21 = fibonacciMatrixMultiply(x: f10, y: f11)
        XCTAssert(f21.m0 == 10946 && f21.m1 == 6765)
        XCTAssert(fibonacci(n: 10) == N(55))
        XCTAssert(fibonacci(n: 20) == N(6765))
    }
    
    func conceptBinaryOperation<DomainOp: Regular>(op: BinaryOperation<DomainOp>, x: DomainOp) {
        typealias CodomainOp = DomainOp
        typealias X = DomainOp
        typealias Y = CodomainOp
        var y = x
        XCTAssert(x == y)
        y = op(x, x)
    }
    
    func minusInt(a: Int, b: Int) -> Int { return a - b }
    
    func timesInt(a: Int, b: Int) -> Int { return a * b }
    
    func algorithmPower(pow: (Int, Int, (Int, Int) -> Int) -> Int) {
        XCTAssert(pow(1, 1, timesInt) == 1)
        XCTAssert(pow(10, 1, timesInt) == 10)
        XCTAssert(pow(1, 10, timesInt) == 1)
        XCTAssert(pow(2, 2, timesInt) == 4)
        XCTAssert(pow(2, 10, timesInt) == 1024)
        XCTAssert(pow(10, 2, timesInt) == 100)
    }
    
    func algorithmPowerAccumulate(pow: (Int, Int, Int, (Int, Int) -> Int) -> Int) {
        XCTAssert(pow(99, 1, 1, timesInt) == 99 * 1)
        XCTAssert(pow(99, 10, 1, timesInt) == 99 * 10)
        XCTAssert(pow(99, 1, 10, timesInt) == 99 * 1)
        XCTAssert(pow(99, 2, 2, timesInt) == 99 * 4)
        XCTAssert(pow(99, 2, 10, timesInt) == 99 * 1024)
        XCTAssert(pow(99, 10, 2, timesInt) == 99 * 100)
        
        XCTAssert(pow(99, 1, 0, timesInt) == 99)
    }
    
    func algorithmPowerAccumulatePositive(pow: (Int, Int, Int, (Int, Int) -> Int) -> Int) {
        XCTAssert(pow(99, 1, 1, timesInt) == 99 * 1)
        XCTAssert(pow(99, 10, 1, timesInt) == 99 * 10)
        XCTAssert(pow(99, 1, 10, timesInt) == 99 * 1)
        XCTAssert(pow(99, 2, 2, timesInt) == 99 * 4)
        XCTAssert(pow(99, 2, 10, timesInt) == 99 * 1024)
        XCTAssert(pow(99, 10, 2, timesInt) == 99 * 100)
    }
    
    func algorithmPowerWithIdentity(pow: (Int, Int, (Int, Int) -> Int, Int) -> Int) {
        XCTAssert(pow(1, 1, timesInt, 1) == 1)
        XCTAssert(pow(10, 1, timesInt, 1) == 10)
        XCTAssert(pow(1, 10, timesInt, 1) == 1)
        XCTAssert(pow(2, 2, timesInt, 1) == 4)
        XCTAssert(pow(2, 10, timesInt, 1) == 1024)
        XCTAssert(pow(10, 2, timesInt, 1) == 100)
        
        XCTAssert(pow(1, 0, timesInt, 1) == 1)
        XCTAssert(pow(1, 0, timesInt, 99) == 99)
    }
    
    func conceptInteger(n: Integer)  {
        // TODO: Implement
        typealias I = Integer
        let k = I(11)
        conceptRegular(x: n)
        var m: I
        m = n + k
        m = n + k
        m = m - k
        m = m * k
        m = m / k
        m = m % k
        m = I(0) // ensure m < k
        conceptTotallyOrdered(x0: m, x1: k)
        m = n.successor()
        m = n.predecessor()
        m = m.twice()
        m = m.halfNonnegative()
        m = m.binaryScaleDownNonnegative(k: I(1))
        m = m.binaryScaleUpNonnegative(k: I(1))
        let bp = m.positive();
        let bn = m.negative();
        XCTAssert(!(bp && bn));
        let bz = m.zero();
        XCTAssert(bz && !(bn || bp) || !bz && (bn || bp));
        let b1 = m.one();
        XCTAssert(!(bz && b1));
        XCTAssert(!b1 || bp);
        let be = m.even();
        let bo = m.odd();
        XCTAssert(be != bo);
    }
}
