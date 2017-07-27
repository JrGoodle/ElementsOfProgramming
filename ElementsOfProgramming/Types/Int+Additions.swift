//
//  Int+Additions.swift
//  ElementsOfProgramming
//

extension Int : MultiplicativeIdentity {
    static func multiplicativeIdentity() -> Int {
        return 1
    }
}

extension Int : AdditiveIdentity {
    static func additiveIdentity() -> Int {
        return 0
    }
}

extension Int: Halvable {
    func half() -> Int { return self / 2 }
}

extension Int: MultiplicativeInverse {
    func multiplicativeInverse() -> Int {
        return Int.multiplicativeIdentity() / self
    }
}

extension Int: Remainder {
    func remainder(_ value: Int) -> Int {
        return self % value
    }
}

extension Int: Norm {
    func w() -> Int {
        if self < Int.additiveIdentity() {
            return -self
        }
        return self
    }
}

extension Int : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse, Modulus, Distance, AdditiveSemigroup, MultiplicativeSemigroup, AdditiveMonoid, MultiplicativeMonoid, Semiring, CommutativeSemiring, EuclideanSemiring {}

protocol IntegerSpecialCaseProcedures {
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

protocol BinaryIntegerSpecialCaseProcedures {
    func binaryScaleDownNonnegative(k: Self) -> Self
    func binaryScaleUpNonnegative(k: Self) -> Self
}

extension Int: IntegerSpecialCaseProcedures, BinaryIntegerSpecialCaseProcedures {
    func successor() -> Int {
        return self + 1
    }
    
    func predecessor() -> Int {
        return self - 1
    }
    
    func twice() -> Int {
        return self + self
    }
    
    func halfNonnegative() -> Int {
        return self >> 1
    }
    
    func binaryScaleDownNonnegative(k: Int) -> Int {
        return self >> k
    }
    
    func binaryScaleUpNonnegative(k: Int) -> Int {
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

extension Int: Iterator {
    var iteratorSuccessor: Int? {
        return self + 1
    }
}

extension Int: Readable {
    var source: Int? {
        return self
    }
}
