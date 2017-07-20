//
//  Int64.swift
//  ElementsOfProgramming
//

extension Int64: Distance {}

extension Int64 : MultiplicativeIdentity {
    static func multiplicativeIdentity() -> Int64 {
        return 1
    }
}

extension Int64 : AdditiveIdentity {
    static func additiveIdentity() -> Int64 {
        return 0
    }
}

extension Int64: Halvable {
    func half() -> Int64 { return self / 2 }
}

extension Int64: MultiplicativeInverse {
    func multiplicativeInverse() -> Int64 {
        return Int64.multiplicativeIdentity() / self
    }
}

extension Int64: Remainder {
    func remainder(_ value: Int64) -> Int64 {
        return self % value
    }
}

extension Int64: Norm {
    func w() -> Int64 {
        if self < Int64.additiveIdentity() {
            return -self
        }
        return self
    }
}

extension Int64 : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse, Modulus {}

extension Int64: IntegerSpecialCaseProcedures, BinaryIntegerSpecialCaseProcedures {
    func successor() -> Int64 {
        return self + Int64(1)
    }
    
    func predecessor() -> Int64 {
        return self - Int64(1)
    }
    
    func twice() -> Int64 {
        return self + self
    }
    
    func halfNonnegative() -> Int64 {
        return self >> Int64(1)
    }
    
    func binaryScaleDownNonnegative(k: Int64) -> Int64 {
        return self >> k
    }
    
    func binaryScaleUpNonnegative(k: Int64) -> Int64 {
        return self << k
    }
    
    func positive() -> Bool {
        return Int64(0) < self
    }
    
    func negative() -> Bool {
        return self < Int64(0)
    }
    
    func zero() -> Bool {
        return self == Int64(0)
    }
    
    func one() -> Bool {
        return self == Int64(1)
    }
    
    func even() -> Bool {
        return (self & Int64(1)) == Int64(0)
    }
    
    func odd() -> Bool {
        return (self & Int64(1)) != Int64(0)
    }
}

