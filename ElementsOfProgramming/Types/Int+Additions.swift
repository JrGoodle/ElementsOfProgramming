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

extension Int : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse, Modulus, Distance {}

protocol IntegerSpecialCaseProcedures {
    func successor() -> Self
    func predecessor() -> Self
    func twice() -> Self
    func halfNonnegative() -> Self
    func positive() -> Bool
    func negative() -> Bool
    func zero() -> Bool
    func one() -> Bool
    func even() -> Bool
    func odd() -> Bool
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
    
    func positive() -> Bool {
        return 0 < self
    }
    
    func negative() -> Bool {
        return self < 0
    }
    
    func zero() -> Bool {
        return self == 0
    }
    
    func one() -> Bool {
        return self == 1
    }
    
    func even() -> Bool {
        return (self & 1) == 0
    }
    
    func odd() -> Bool {
        return (self & 1) != 0
    }
}
