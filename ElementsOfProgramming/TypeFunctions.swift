//
//  TypeFunctions.swift
//  ElementsOfProgramming
//

// MARK: Chapter 1

// MARK: Chapter 2

// Domain: UnaryFunction -> Regular

// Distance: Transformation -> Integer
typealias DistanceType = Int

protocol Distance: Regular {
    func distance(to: Self, f: Transformation<Self>) -> Int
}

extension Distance {
    func distance(to end: Self, f: Transformation<Self>) -> Int {
        var x = self
        let y = end
        // Precondition: $y$ is reachable from $x$ under $f$
        typealias N = DistanceType
        var n = N(0)
        while x != y {
            x = f(x)
            n = n + N(1)
        }
        return n
    }
}

protocol MultiplicativeIdentity {
    func multiplicativeIdentity() -> Self
}

protocol AdditiveIdentity {
    func additiveIdentity() -> Self
}

protocol AdditiveInverse: Negatable {
    func additiveInverse() -> Self
}

protocol MultiplicativeInverse: Divisible {
    func multiplicativeInverse() -> Self
}

protocol Remainder {
    static func %(lhs: Self, rhs: Self) -> Self
}

protocol Addable {
    static func +(lhs: Self, rhs: Self) -> Self
}

protocol Subtractable {
    static func -(lhs: Self, rhs: Self) -> Self
}

protocol Negatable {
    static prefix func -(value: Self) -> Self
}

protocol Multipliable {
    static func *(lhs: Self, rhs: Self) -> Self
}

protocol Divisible {
    static func/(lhs: Self, rhs: Self) -> Self
}

protocol Relational {
    associatedtype T: AdditiveMonoid
    associatedtype S: CommutativeSemiring
    func relation(from commutativeSemiring: S, to additiveMonoid: T) -> T
}

protocol Quotient {
    func quotient() -> Int
}

protocol Halvable: Divisible {
    func half() -> Self
}

protocol SubtractiveGCDNonzero {
    func subtractiveGCDNonzero()
}
