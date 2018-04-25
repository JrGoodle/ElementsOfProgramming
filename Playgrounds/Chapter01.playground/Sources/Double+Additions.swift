//
//  Double+Extensions.swift
//  ElementsOfProgramming
//

extension Double : MultiplicativeIdentity {
    public static var multiplicativeIdentity: Double {
        return 1.0
    }
}

extension Double : AdditiveIdentity {
    public static var additiveIdentity: Double {
        return 0.0
    }
}

extension Double: Halvable {
    public func half() -> Double { return self / 2.0 }
}

extension Double: MultiplicativeInverse {
    public func multiplicativeInverse() -> Double {
        return Double.multiplicativeIdentity / self
    }
}

extension Double: Norm {
    public func w() -> Double {
        if self < Double.additiveIdentity {
            return -self
        }
        return self
    }
}

extension Double : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, AdditiveInverse { }

extension Double: IntegerSpecialCaseProcedures {
    public func successor() -> Double {
        return self + Double(1)
    }

    public func predecessor() -> Double {
        return self - Double(1)
    }

    public func twice() -> Double {
        return self + self
    }

    public func halfNonnegative() -> Double {
        // FIXME: Fix this
        return Double(0)
//        return self >> Double(1)
    }

    public func isPositive() -> Bool {
        return Double(0) < self
    }

    public func isNegative() -> Bool {
        return self < Double(0)
    }

    public func isZero() -> Bool {
        return self == Double(0)
    }

    public func isOne() -> Bool {
        return self == Double(1)
    }

    public func isEven() -> Bool {
        // FIXME: Fix this
        return false
//        return (self & Double(1)) == Double(0)
    }

    public func isOdd() -> Bool {
        // FIXME: Fix this
        return false
//        return (self & Double(1)) != Double(0)
    }
}
