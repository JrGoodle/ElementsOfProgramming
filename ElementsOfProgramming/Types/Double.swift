//
//  Double.swift
//  ElementsOfProgramming
//

extension Double : MultiplicativeIdentity {
    static func multiplicativeIdentity() -> Double {
        return 1.0
    }
}

extension Double : AdditiveIdentity {
    static func additiveIdentity() -> Double {
        return 0.0
    }
}

extension Double: Halvable {
    func half() -> Double { return self / 2.0 }
}

extension Double: MultiplicativeInverse {
    func multiplicativeInverse() -> Double {
        return Double.multiplicativeIdentity() / self
    }
}

extension Double: Norm {
    func w() -> Double {
        if self < Double.additiveIdentity() {
            return -self
        }
        return self
    }
}

extension Double : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, AdditiveInverse { }

extension Double: IntegerSpecialCaseProcedures {
    func successor() -> Double {
        return self + Double(1)
    }
    
    func predecessor() -> Double {
        return self - Double(1)
    }
    
    func twice() -> Double {
        return self + self
    }
    
    func halfNonnegative() -> Double {
        // FIXME: Fix this
        return Double(0)
//        return self >> Double(1)
    }
    
    func positive() -> Bool {
        return Double(0) < self
    }
    
    func negative() -> Bool {
        return self < Double(0)
    }
    
    func zero() -> Bool {
        return self == Double(0)
    }
    
    func one() -> Bool {
        return self == Double(1)
    }
    
    func even() -> Bool {
        // FIXME: Fix this
        return false
//        return (self & Double(1)) == Double(0)
    }
    
    func odd() -> Bool {
        // FIXME: Fix this
        return false
//        return (self & Double(1)) != Double(0)
    }
}
