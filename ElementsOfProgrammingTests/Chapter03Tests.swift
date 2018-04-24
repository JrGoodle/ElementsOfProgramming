//
//  Chapter03Tests.swift
//  ElementsOfProgrammingTests
//

import XCTest
import EOP

class Chapter03Tests: XCTestCase {

    func testConceptBinaryOperation() {
        Concept.binaryOperation(op: minusInt, x: 7)
        Concept.binaryOperation(op: timesInt, x: 8)
    }

    func testPowerLeftAssociated() {
        // (-2 - -2) - -2 = 2
        XCTAssert(powerLeftAssociated(-2, power: 3, operation: minusInt) == 2)

        // ((-2 - -2) - -2) - -2 = 4
        XCTAssert(powerLeftAssociated(-2, power: 4, operation: minusInt) == 4)

        algorithmPower(pow: powerLeftAssociated)
    }

    func testPowerRightAssociated() {
        // -2 - (-2 - -2) = -2
        XCTAssert(powerRightAssociated(-2, power: 3, operation: minusInt) == -2)

        // -2 - (-2 - (-2 - -2) = 0
        XCTAssert(powerRightAssociated(-2, power: 4, operation: minusInt) == 0)

        algorithmPower(pow: powerRightAssociated)
    }

    func testPower_N() {
        algorithmPower(pow: power_0)
        algorithmPower(pow: power_1)
        algorithmPower(pow: power_2)
        algorithmPower(pow: power_3)
    }

    func testPowerAccumulate() {
        algorithmPowerAccumulate(pow: powerAccumulate_0)
        algorithmPowerAccumulate(pow: powerAccumulate_1)
        algorithmPowerAccumulate(pow: powerAccumulate_2)
        algorithmPowerAccumulate(pow: powerAccumulate_3)
        algorithmPowerAccumulate(pow: powerAccumulate_4)
        algorithmPowerAccumulatePositive(pow: powerAccumulatePositive_0)
        algorithmPowerAccumulate(pow: powerAccumulate_5)
        algorithmPowerAccumulatePositive(pow: powerAccumulatePositive)
        algorithmPowerAccumulate(pow: powerAccumulate)
    }

    func testPower() {
        algorithmPower(pow: power)
        algorithmPowerWithIdentity(pow: power)
    }

    func testConceptInteger() {
        typealias N = Int
        Concept.integer(n: 7)
    }

    func testFibonacci() {
        typealias N = Int
        typealias Fib = Pair<N, N>

        Concept.binaryOperation(op: fibonacciMatrixMultiply, x: Fib(m0: 1, m1: 0))

        let f10 = Fib(m0: 55, m1: 34)
        let f11 = Fib(m0: 89, m1: 55)
        let f21 = fibonacciMatrixMultiply(x: f10, y: f11)
        XCTAssert(f21.m0 == 10946 && f21.m1 == 6765)
        XCTAssert(fibonacci(n: 10) == 55)
        XCTAssert(fibonacci(n: 20) == 6765)
    }

    func minusInt(a: Int, b: Int) -> Int { return a - b }

    func timesInt(a: Int, b: Int) -> Int { return a * b }

    func algorithmPower(pow: (Int, Int, BinaryOperation<Int>) -> Int) {
        XCTAssert(pow(1, 1, timesInt) == 1)
        XCTAssert(pow(10, 1, timesInt) == 10)
        XCTAssert(pow(1, 10, timesInt) == 1)
        XCTAssert(pow(2, 2, timesInt) == 4)
        XCTAssert(pow(2, 10, timesInt) == 1024)
        XCTAssert(pow(10, 2, timesInt) == 100)
    }

    func algorithmPowerAccumulate(pow: (Int, Int, Int, BinaryOperation<Int>) -> Int) {
        XCTAssert(pow(1, 99, 1, timesInt) == 99 * 1)
        XCTAssert(pow(10, 99, 1, timesInt) == 99 * 10)
        XCTAssert(pow(1, 99, 10, timesInt) == 99 * 1)
        XCTAssert(pow(2, 99, 2, timesInt) == 99 * 4)
        XCTAssert(pow(2, 99, 10, timesInt) == 99 * 1024)
        XCTAssert(pow(10, 99, 2, timesInt) == 99 * 100)
        XCTAssert(pow(1, 99, 0, timesInt) == 99)
    }

    func algorithmPowerAccumulatePositive(pow: (Int, Int, Int, BinaryOperation<Int>) -> Int) {
        XCTAssert(pow(1, 99, 1, timesInt) == 99 * 1)
        XCTAssert(pow(10, 99, 1, timesInt) == 99 * 10)
        XCTAssert(pow(1, 99, 10, timesInt) == 99 * 1)
        XCTAssert(pow(2, 99, 2, timesInt) == 99 * 4)
        XCTAssert(pow(2, 99, 10, timesInt) == 99 * 1024)
        XCTAssert(pow(10, 99, 2, timesInt) == 99 * 100)
    }

    func algorithmPowerWithIdentity(pow: (Int, Int, BinaryOperation<Int>, Int) -> Int) {
        XCTAssert(pow(1, 1, timesInt, 1) == 1)
        XCTAssert(pow(10, 1, timesInt, 1) == 10)
        XCTAssert(pow(1, 10, timesInt, 1) == 1)
        XCTAssert(pow(2, 2, timesInt, 1) == 4)
        XCTAssert(pow(2, 10, timesInt, 1) == 1024)
        XCTAssert(pow(10, 2, timesInt, 1) == 100)
        XCTAssert(pow(1, 0, timesInt, 1) == 1)
        XCTAssert(pow(1, 0, timesInt, 99) == 99)
    }
}
