//
//  TypeFunctions.swift
//  ElementsOfProgramming
//

// MARK: Chapter 1

// MARK: Chapter 2

// Domain: UnaryFunction -> Regular

// Distance: Transformation -> Integer
typealias DistanceType = UInt

protocol Distance: Regular {
    func distance(to: Self, f: Transformation<Self>) -> UInt
}

extension Distance {
    func distance(to end: Self, f: Transformation<Self>) -> UInt {
        var x = self
        let y = end
        // Precondition: y is reachable from x under f
        var n = N(0)
        while x != y {
            x = f(x)
            n = n + N(1)
        }
        return n
    }
}

protocol MultiplicativeIdentity {
    static func multiplicativeIdentity() -> Self
}

protocol AdditiveIdentity {
    static func additiveIdentity() -> Self
}

protocol AdditiveInverse: Negatable {
    func additiveInverse() -> Self
}

extension AdditiveInverse {
    func additiveInverse() -> Self {
        return -self
    }
}

protocol MultiplicativeInverse {
    func multiplicativeInverse() -> Self
}


protocol Modulus {
    static func %(lhs: Self, rhs: Self) -> Self
}

protocol Remainder {
    func remainder(_ value: Self) -> Self
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
    static func relation(from commutativeSemiring: S,
                         to additiveMonoid: T) -> T
}

typealias QuotientType = Int

protocol Quotient: Divisible {
    associatedtype T
    func quotient(_ value: Self) -> T
}

extension Quotient {
    func quotient(_ value: Self) -> Self {
        return self / value
    }
}

protocol Halvable: Divisible {
    func half() -> Self
}

protocol SubtractiveGCDNonzero {
    func subtractiveGCDNonzero()
}

typealias NormType = Int

protocol Norm: AdditiveIdentity, Regular {
    func w() -> Self
}

//protocol Associative { }

//protocol Commutative { }

protocol Discrete { }

typealias DifferenceType = Int
