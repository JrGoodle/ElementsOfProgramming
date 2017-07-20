//
//  Integer.swift
//  ElementsOfProgramming
//

typealias Integer = Int

// Natural Numbers
typealias N = Int

extension Int: Distance {}

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

extension Int : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, Norm, AdditiveInverse, Modulus {}

protocol IntegerSpecialCaseProcedures {
    associatedtype T
    
    func successor() -> T
    func predecessor() -> T
    func twice() -> T
    func halfNonnegative() -> T
    func binaryScaleDownNonnegative(k: T) -> T
    func binaryScaleUpNonnegative(k: T) -> T
    func positive() -> Bool
    func negative() -> Bool
    func zero() -> Bool
    func one() -> Bool
    func even() -> Bool
    func odd() -> Bool
}

extension Int: IntegerSpecialCaseProcedures {
    func successor() -> Int {
        return self + Integer(1)
    }
    
    func predecessor() -> Int {
        return self - Integer(1)
    }
    
    func twice() -> Int {
        return self + self
    }
    
    func halfNonnegative() -> Int {
        return self >> Integer(1)
    }
    
    func binaryScaleDownNonnegative(k: Int) -> Int {
        return self >> k
    }
    
    func binaryScaleUpNonnegative(k: Int) -> Int {
        return self << k
    }
    
    func positive() -> Bool {
        return Integer(0) < self
    }
    
    func negative() -> Bool {
        return self < Integer(0)
    }
    
    func zero() -> Bool {
        return self == Integer(0)
    }
    
    func one() -> Bool {
        return self == Integer(1)
    }
    
    func even() -> Bool {
        return (self & Integer(1)) == Integer(0)
    }
    
    func odd() -> Bool {
        return (self & Integer(1)) != Integer(0)
    }
    
    typealias T = Int
}
