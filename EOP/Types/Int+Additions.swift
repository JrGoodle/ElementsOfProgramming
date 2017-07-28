//
//  Int+Additions.swift
//  ElementsOfProgramming
//

extension Int : MultiplicativeIdentity {
    public static func multiplicativeIdentity() -> Int {
        return 1
    }
}

extension Int : AdditiveIdentity {
    public static func additiveIdentity() -> Int {
        return 0
    }
}

extension Int: Halvable {
    public func half() -> Int { return self / 2 }
}

extension Int: MultiplicativeInverse {
    public func multiplicativeInverse() -> Int {
        return Int.multiplicativeIdentity() / self
    }
}

extension Int: Remainder {
    public func remainder(_ value: Int) -> Int {
        return self % value
    }
}

extension Int: Norm {
    public func w() -> Int {
        if self < Int.additiveIdentity() {
            return -self
        }
        return self
    }
}

extension Int : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse, Modulus, Distance, AdditiveSemigroup, MultiplicativeSemigroup, AdditiveMonoid, MultiplicativeMonoid, Semiring, CommutativeSemiring, EuclideanSemiring {}

public protocol IntegerSpecialCaseProcedures {
    func successor() -> Self
    func predecessor() -> Self
    func twice() -> Self
    func halfNonnegative() -> Self
    func isPositive() -> Bool
    func isNegative() -> Bool
    func isEqualToZero() -> Bool
    func isEqualToOne() -> Bool
    func isEven() -> Bool
    func isOdd() -> Bool
}

public protocol BinaryIntegerSpecialCaseProcedures {
    func binaryScaleDownNonnegative(k: Self) -> Self
    func binaryScaleUpNonnegative(k: Self) -> Self
}

extension Int: IntegerSpecialCaseProcedures, BinaryIntegerSpecialCaseProcedures {
    public func successor() -> Int {
        return self + 1
    }
    
    public func predecessor() -> Int {
        return self - 1
    }
    
    public func twice() -> Int {
        return self + self
    }
    
    public func halfNonnegative() -> Int {
        return self >> 1
    }
    
    public func binaryScaleDownNonnegative(k: Int) -> Int {
        return self >> k
    }
    
    public func binaryScaleUpNonnegative(k: Int) -> Int {
        return self << k
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
        return (self & 1) == 0
    }
    
    public func isOdd() -> Bool {
        return (self & 1) != 0
    }
}

extension Int: Iterator {
    public var iteratorSuccessor: Int? {
        return self + 1
    }
}

extension Int: Readable {
    public var source: Int? {
        return self
    }
}
