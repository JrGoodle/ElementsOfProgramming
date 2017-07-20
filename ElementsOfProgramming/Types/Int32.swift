//
//  Int32.swift
//  ElementsOfProgramming
//

extension Int32: Distance {}

extension Int32 : MultiplicativeIdentity {
    static func multiplicativeIdentity() -> Int32 {
        return 1
    }
}

extension Int32 : AdditiveIdentity {
    static func additiveIdentity() -> Int32 {
        return 0
    }
}

extension Int32: Halvable {
    func half() -> Int32 { return self / 2 }
}

extension Int32: MultiplicativeInverse {
    func multiplicativeInverse() -> Int32 {
        return Int32.multiplicativeIdentity() / self
    }
}

extension Int32: Remainder {
    func remainder(_ value: Int32) -> Int32 {
        return self % value
    }
}

extension Int32: Norm {
    func w() -> Int32 {
        if self < Int32.additiveIdentity() {
            return -self
        }
        return self
    }
}

extension Int32 : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse, Modulus {}

extension Int32: IntegerSpecialCaseProcedures, BinaryIntegerSpecialCaseProcedures {
    func successor() -> Int32 {
        return self + Int32(1)
    }
    
    func predecessor() -> Int32 {
        return self - Int32(1)
    }
    
    func twice() -> Int32 {
        return self + self
    }
    
    func halfNonnegative() -> Int32 {
        return self >> Int32(1)
    }
    
    func binaryScaleDownNonnegative(k: Int32) -> Int32 {
        return self >> k
    }
    
    func binaryScaleUpNonnegative(k: Int32) -> Int32 {
        return self << k
    }
    
    func positive() -> Bool {
        return Int32(0) < self
    }
    
    func negative() -> Bool {
        return self < Int32(0)
    }
    
    func zero() -> Bool {
        return self == Int32(0)
    }
    
    func one() -> Bool {
        return self == Int32(1)
    }
    
    func even() -> Bool {
        return (self & Int32(1)) == Int32(0)
    }
    
    func odd() -> Bool {
        return (self & Int32(1)) != Int32(0)
    }
}
