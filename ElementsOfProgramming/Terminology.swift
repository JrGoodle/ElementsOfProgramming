//
//  Terminology.swift
//  ElementsOfProgramming
//

typealias ArchimedeanGroup = (Int) -> Int // ?

protocol Remainder {
    static func %(lhs: Self, rhs: Self) -> Self
}

protocol Addable {
    static func +(lhs: Self, rhs: Self) -> Self
}
extension Int : Addable {}

protocol Subtractable {
    static func -(lhs: Self, rhs: Self) -> Self
}
extension Int : Subtractable {}

protocol Negateable {
    static prefix func -(value: Self) -> Self
}
extension Int : Negateable {}

protocol Multipliable {
    static func *(lhs: Self, rhs: Self) -> Self
}
extension Int : Multipliable {}

protocol Divisible {
    static func/(lhs: Self, rhs: Self) -> Self
}
extension Int : Divisible {}

// Natural Numbers
typealias N = Int

// Concept
// 1. Other Concepts
// 2. Type Attributes
// 3. Type Functions
// 4. Procedures
