//
//  UInt.swift
//  ElementsOfProgramming
//

extension UInt: Distance {}

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

extension UInt : Addable, Subtractable, Multipliable, Divisible, Quotient, Discrete, Modulus {}

extension UInt: IntegerSpecialCaseProcedures, BinaryIntegerSpecialCaseProcedures {
    func successor() -> UInt {
        return self + UInt(1)
    }
    
    func predecessor() -> UInt {
        return self - UInt(1)
    }
    
    func twice() -> UInt {
        return self + self
    }
    
    func halfNonnegative() -> UInt {
        return self >> UInt(1)
    }
    
    func binaryScaleDownNonnegative(k: UInt) -> UInt {
        return self >> k
    }
    
    func binaryScaleUpNonnegative(k: UInt) -> UInt {
        return self << k
    }
    
    func positive() -> Bool {
        return UInt(0) < self
    }
    
    func negative() -> Bool {
        return self < UInt(0)
    }
    
    func zero() -> Bool {
        return self == UInt(0)
    }
    
    func one() -> Bool {
        return self == UInt(1)
    }
    
    func even() -> Bool {
        return (self & UInt(1)) == UInt(0)
    }
    
    func odd() -> Bool {
        return (self & UInt(1)) != UInt(0)
    }
}

