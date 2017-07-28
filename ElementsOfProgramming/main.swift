//
//  main.swift
//  ElementsOfProgramming
//
// Algorithms from
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009
//

import Foundation
import EOP

//// MARK: Chapter 1
//
//print("Test square")
//print(square(2) { $0 * $1 })
//print(square("a") { $0 + $1 })
//
//// MARK: Chapter 2
//
////print("Test powerUnary")
//var x = 0
//var n = 100
//print(powerUnary(x, n) { $0 + 2 })
//
//print("Test distance")
//x = 0
//let y = 100
//print(distance(x, y) { $0 + 2 })

func runTests() {
    print("Max Int value: \(Int.max)")
    let t = Triple(m0: 1, m1: 2, m2: 3)
    print("Triple: \(t)")
    print("triple.m1: \(t.m1)")
    testAdditiveCongruentialTransformation(modulus: 9, index: 2)
    testAdditiveCongruentialTransformation(modulus: 100, index: 2)
    testAdditiveCongruentialTransformation(modulus: 1245142, index: 3)
    testAdditiveCongruentialTransformation(modulus: 127846594, index: 13)
}

runTests()

