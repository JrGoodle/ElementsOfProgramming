//
//  UInt+Additions.swift
//  ElementsOfProgramming
//

// Natural Numbers
public typealias N = UInt

extension UInt : MultiplicativeIdentity {
    public static func multiplicativeIdentity() -> UInt {
        return 1
    }
}

extension UInt : AdditiveIdentity {
    public static func additiveIdentity() -> UInt {
        return 0
    }
}

extension UInt: Halvable {
    public func half() -> UInt { return self / 2 }
}

extension UInt: MultiplicativeInverse {
    public func multiplicativeInverse() -> UInt {
        return UInt.multiplicativeIdentity() / self
    }
}

extension UInt: Remainder {
    public func remainder(_ value: UInt) -> UInt {
        return self % value
    }
}

extension UInt: Norm {
    public func w() -> UInt {
        return self
    }
}

extension UInt : Addable, Subtractable, Multipliable, Divisible, Quotient, Discrete, Modulus, Distance, AdditiveSemigroup, MultiplicativeSemigroup, AdditiveMonoid, MultiplicativeMonoid, Semiring, CommutativeSemiring, EuclideanSemiring {}

extension UInt: IntegerSpecialCaseProcedures {
    public func successor() -> UInt {
        return self + 1
    }
    
    public func predecessor() -> UInt {
        return self - 1
    }
    
    public func twice() -> UInt {
        return self + self
    }
    
    public func halfNonnegative() -> UInt {
        return self / 2
    }
    
    public func isPositive() -> Bool {
        return 0 < self
    }
    
    public func isNegative() -> Bool {
        return self < 0
    }
    
    public func isEqualToZero() -> Bool {
        return self == 0
    }
    
    public func isEqualToOne() -> Bool {
        return self == 1
    }
    
    public func isEven() -> Bool {
        return (self % 2) == 0 ? true : false
    }
    
    public func isOdd() -> Bool {
        return (self % 2) == 0 ? false : true
    }
}

extension UInt: Iterator {
    public var iteratorSuccessor: UInt? {
        return self + 1
    }
}
