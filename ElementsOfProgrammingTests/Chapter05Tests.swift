//
//  Chapter05Tests.swift
//  ElementsOfProgrammingTests
//

import XCTest

class Chapter05Testts: XCTestCase {
    
    func testAlgorithmAbs() {
        algorithmAbs(Int32(1))
        algorithmAbs(Int64(1))
        algorithmAbs(Float(1.0))
        algorithmAbs(Double(1.0))
        algorithmAbs(Rational(numerator: 1, denominator: 2))
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
        // TODO: Implement
    }

    func testAlgorithmsQRNonnegative() {
        // TODO: Implement
    }
    
    func testAlgorithmsQRNonnegativeFibonacci() {
        // TODO: Implement
    }
    
    func testAlgorithmsQRNonnegativeIterative() {
        // TODO: Implement
    }
    
    func testAlgorithmLargestDoubling() {
        // TODO: Implement
    }
    
    func testSubtractiveGCDNonzero() {
        // TODO: Implement
    }
    
    func testSubtractiveGCD() {
        // TODO: Implement
    }
    
    func testFastSubtractiveGCD() {
        // TODO: Implement
    }
    
    func testGCDEuclideanSemiring() {
        // TODO: Implement
    }
    
    func testGCDEuclideanModule() {
        // TODO: Implement
    }
    
    func testAlgorithmsSignedQR() {
        // TODO: Implement
    }
    
    func algorithmAbs<T: OrderedAdditiveGroup>(_ something: T) {
        // We need a nonzero number to test with; OrderedAdditiveGroup doesn't guarantee one
        XCTAssert(something > T.additiveIdentity())
        let x = something
        let y = x + something
        let z = y + something
        Concept.orderedAdditiveGroup(x: x, y: y, z: z) // need x < y < z
        
        XCTAssert(absoluteValue(T.additiveIdentity()) == T.additiveIdentity())
        XCTAssert(absoluteValue(something) == something)
        XCTAssert(absoluteValue(-something) == something)
    }
}
