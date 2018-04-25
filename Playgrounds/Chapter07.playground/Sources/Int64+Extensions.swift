//
//  Int64+Extensions.swift
//  ElementsOfProgramming
//

extension Int64 : MultiplicativeIdentity {
    public static var multiplicativeIdentity: Int64 {
        return 1
    }
}

extension Int64 : AdditiveIdentity {
    public static var additiveIdentity: Int64 {
        return 0
    }
}

extension Int64: Halvable {
    public func half() -> Int64 { return self / 2 }
}

extension Int64: MultiplicativeInverse {
    public func multiplicativeInverse() -> Int64 {
        return Int64.multiplicativeIdentity / self
    }
}

extension Int64: Remainder {
    public func remainder(_ value: Int64) -> Int64 {
        return self % value
    }
}

extension Int64: Norm {
    public func w() -> Int64 {
        if self < Int64.additiveIdentity {
            return -self
        }
        return self
    }
}

extension Int64 : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse, Modulus, Distance {}

extension Int64: IntegerSpecialCaseProcedures, BinaryIntegerSpecialCaseProcedures {
    public func successor() -> Int64 {
        return self + 1
    }

    public func predecessor() -> Int64 {
        return self - 1
    }

    public func twice() -> Int64 {
        return self + self
    }

    public func halfNonnegative() -> Int64 {
        return self >> 1
    }

    public func binaryScaleDownNonnegative(k: Int64) -> Int64 {
        return self >> k
    }

    public func binaryScaleUpNonnegative(k: Int64) -> Int64 {
        return self << k
    }

    public func isPositive() -> Bool {
        return 0 < self
    }

    public func isNegative() -> Bool {
        return self < 0
    }

    public func isZero() -> Bool {
        return self == 0
    }

    public func isOne() -> Bool {
        return self == 1
    }

    public func isEven() -> Bool {
        return (self & 1) == 0
    }

    public func isOdd() -> Bool {
        return (self & 1) != 0
    }
}

