//
//  Terminology.swift
//  ElementsOfProgramming
//

typealias RegularType = Equatable

typealias TotallyOrdered = Comparable & Equatable

typealias ArchimedeanGroup = (Int) -> Int // ?

protocol Remainder {
    static func %(lhs: Self, rhs: Self) -> Self
}

protocol Multipliable {
    static func*(lhs: Self, rhs: Self) -> Self
}
extension Int : Multipliable {}

protocol Divisible {
    static func/(lhs: Self, rhs: Self) -> Self
}
extension Int : Divisible {}

// Natural Numbers
typealias N = Int

typealias Integer = Int

// Concept
// 1. Other Concepts
// 2. Type Attributes
// 3. Type Functions
// 4. Procedures
