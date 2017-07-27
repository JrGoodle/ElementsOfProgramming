//
//  UInt+Additions.swift
//  ElementsOfProgramming
//

// Natural Numbers
typealias N = UInt

extension UInt : MultiplicativeIdentity {
    static func multiplicativeIdentity() -> UInt {
        return 1
    }
}

extension UInt : AdditiveIdentity {
    static func additiveIdentity() -> UInt {
        return 0
    }
}

extension UInt: Halvable {
    func half() -> UInt { return self / 2 }
}

extension UInt: MultiplicativeInverse {
    func multiplicativeInverse() -> UInt {
        return UInt.multiplicativeIdentity() / self
    }
}

extension UInt: Remainder {
    func remainder(_ value: UInt) -> UInt {
        return self % value
    }
}

extension UInt: Norm {
    func w() -> UInt {
        return self
    }
}

extension UInt : Addable, Subtractable, Multipliable, Divisible, Quotient, Discrete, Modulus, Distance, AdditiveSemigroup, MultiplicativeSemigroup, AdditiveMonoid, MultiplicativeMonoid, Semiring, CommutativeSemiring, EuclideanSemiring {}

extension UInt: IntegerSpecialCaseProcedures, BinaryIntegerSpecialCaseProcedures {
    func successor() -> UInt {
        return self + 1
    }
    
    func predecessor() -> UInt {
        return self - 1
    }
    
    func twice() -> UInt {
        return self + self
    }
    
    func halfNonnegative() -> UInt {
        return self >> 1
    }
    
    func binaryScaleDownNonnegative(k: UInt) -> UInt {
        return self >> k
    }
    
    func binaryScaleUpNonnegative(k: UInt) -> UInt {
        return self << k
    }
    
    func isPositive() -> Bool {
        return 0 < self
    }
    
    func isNegative() -> Bool {
        return self < 0
    }
    
    func isEqualToZero() -> Bool {
        return self == 0
    }
    
    func isEqualToOne() -> Bool {
        return self == 1
    }
    
    func isEven() -> Bool {
        return (self & 1) == 0
    }
    
    func isOdd() -> Bool {
        return (self & 1) != 0
    }
}

extension UInt: Iterator {
    var iteratorSuccessor: UInt? {
        return self + 1
    }
}

