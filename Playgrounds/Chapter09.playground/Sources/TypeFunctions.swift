//
//  TypeFunctions.swift
//  ElementsOfProgramming
//

// MARK: Chapter 1

// MARK: Chapter 2

// Domain: UnaryFunction -> Regular

// Distance: Transformation -> Integer
public typealias DistanceType = UInt

public protocol Distance: Regular {
    func distance(to: Self, transformation: Transformation<Self>) -> UInt
}

extension Distance {
    public func distance(to end: Self, transformation f: Transformation<Self>) -> UInt {
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

public protocol MultiplicativeIdentity {
    static func multiplicativeIdentity() -> Self
}

public protocol AdditiveIdentity {
    static func additiveIdentity() -> Self
}

public protocol AdditiveInverse: Negatable {
    func additiveInverse() -> Self
}

public extension AdditiveInverse {
    func additiveInverse() -> Self {
        return -self
    }
}

public protocol MultiplicativeInverse {
    func multiplicativeInverse() -> Self
}


public protocol Modulus {
    static func %(lhs: Self, rhs: Self) -> Self
}

public protocol Remainder {
    func remainder(_ value: Self) -> Self
}

public protocol Addable {
    static func +(lhs: Self, rhs: Self) -> Self
}

public protocol Subtractable {
    static func -(lhs: Self, rhs: Self) -> Self
}

public protocol Negatable {
    static prefix func -(value: Self) -> Self
}

public protocol Multipliable {
    static func *(lhs: Self, rhs: Self) -> Self
}

public protocol Divisible {
    static func/(lhs: Self, rhs: Self) -> Self
}

public protocol Relational {
    associatedtype T: AdditiveMonoid
    associatedtype S: CommutativeSemiring
    static func relation(from commutativeSemiring: S,
                         to additiveMonoid: T) -> T
}

public typealias QuotientType = Int

public protocol Quotient: Divisible {
    associatedtype T
    func quotient(_ value: Self) -> T
}

extension Quotient {
    public func quotient(_ value: Self) -> Self {
        return self / value
    }
}

public protocol Halvable: Divisible {
    func half() -> Self
}

public protocol SubtractiveGCDNonzero {
    func subtractiveGCDNonzero()
}

public typealias NormType = Int

public protocol Norm: AdditiveIdentity, Regular {
    func w() -> Self
}

//protocol Associative { }

//protocol Commutative { }

public protocol Discrete { }

public typealias DifferenceType = Int
