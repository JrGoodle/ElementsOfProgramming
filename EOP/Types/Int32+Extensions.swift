//
//  Int32+Extensions.swift
//  ElementsOfProgramming
//

extension Int32 : MultiplicativeIdentity {
    public static var multiplicativeIdentity: Int32 {
        return 1
    }
}

extension Int32 : AdditiveIdentity {
    public static var additiveIdentity: Int32 {
        return 0
    }
}

extension Int32: Halvable {
    public func half() -> Int32 { return self / 2 }
}

extension Int32: MultiplicativeInverse {
    public func multiplicativeInverse() -> Int32 {
        return Int32.multiplicativeIdentity / self
    }
}

extension Int32: Remainder {
    public func remainder(_ value: Int32) -> Int32 {
        return self % value
    }
}

extension Int32: Norm {
    public func w() -> Int32 {
        if self < Int32.additiveIdentity {
            return -self
        }
        return self
    }
}

extension Int32 : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse, Modulus, Distance {}

extension Int32: IntegerSpecialCaseProcedures, BinaryIntegerSpecialCaseProcedures {
    public func successor() -> Int32 {
        return self + 1
    }

    public func predecessor() -> Int32 {
        return self - 1
    }

    public func twice() -> Int32 {
        return self + self
    }

    public func halfNonnegative() -> Int32 {
        return self >> 1
    }

    public func binaryScaleDownNonnegative(k: Int32) -> Int32 {
        return self >> k
    }

    public func binaryScaleUpNonnegative(k: Int32) -> Int32 {
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
