//
//  Rational.swift
//  ElementsOfProgramming
//

public struct Rational {
    private(set) var numerator: Int
    private(set) var denominator: Int

    init?(numerator: Int, denominator: Int) {
        if denominator == 0 { return nil }
        self.numerator = numerator
        self.denominator = denominator
        reduce()
        normalize()
    }

    init(_ n: Int) {
        numerator = n
        denominator = 1
    }

    func print() {
        if numerator == 0 {
            Swift.print("0")
        } else if denominator.isOne() {
            Swift.print(numerator)
        } else {
            Swift.print("\(numerator)/\(denominator)")
        }
    }

    private mutating func reduce() {
        let d = gcd()
        numerator = numerator / d
        denominator = denominator / d
    }

    private mutating func normalize() {
        if (numerator < 0 && denominator < 0) ||
            denominator < 0 {
            numerator = numerator * -1
            denominator = denominator * -1
        }
    }

    private func gcd() -> Int {
        // gcdEuclideanSemiring
        var a = numerator, b = denominator
        assert(!(a == 0 && b == 0))
        while true {
            if b == 0 { return a }
            a = a % b
            if a == 0 { return b }
            b = b % a
        }
    }
}

extension Rational: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = Rational(value)
    }
}

extension Rational: AdditiveInverse, ArchimedeanMonoid {
    public static func -(lhs: Rational, rhs: Rational) -> Rational {
        return lhs + (-rhs)
    }

    public static func <(lhs: Rational, rhs: Rational) -> Bool {
        return lhs.numerator * rhs.denominator < rhs.numerator * lhs.denominator
    }

    public static var additiveIdentity: Rational {
        return Rational(0)
    }
}

extension Rational: Addable {
    public static func +(lhs: Rational, rhs: Rational) -> Rational {
        return Rational(numerator: rhs.denominator * lhs.numerator + lhs.denominator * rhs.numerator,
                        denominator: lhs.denominator * rhs.denominator)!
    }
}

extension Rational: Negatable {
    public static prefix func -(value: Rational) -> Rational {
        return Rational(numerator: -value.numerator,
                        denominator: value.denominator)!
    }
}

extension Rational: Multipliable {
    public static func *(lhs: Rational, rhs: Rational) -> Rational {
        return Rational(numerator: lhs.numerator * rhs.numerator,
                        denominator: lhs.denominator * rhs.denominator)!
    }
}

extension Rational: MultiplicativeInverse {
    public func multiplicativeInverse() -> Rational {
        // Precondition: $x.p ≠ 0$
        return Rational(numerator: self.denominator,
                        denominator: self.numerator)!
    }
}

extension Rational: Divisible {
    public static func /(lhs: Rational, rhs: Rational) -> Rational {
        return Rational(numerator: lhs.numerator * rhs.denominator,
                        denominator: lhs.denominator * rhs.numerator)!
        // Postcondition: x * multiplicative_inverse(y)
    }
}

// Multiplication for rational<N> as a semimodule over integers
extension Rational {
    static func *(lhs: Int, rhs: Rational) -> Rational {
        return Rational(numerator: lhs * rhs.numerator,
                        denominator: rhs.denominator)!
    }
}

//extension Rational: Remainder {
//    public func remainder(_ value: Rational) -> Rational {
//        return remainderNonnegative(a: self, b: value)
//    }
//}

extension Rational: Regular {
    public static func ==(lhs: Rational, rhs: Rational) -> Bool {
        return lhs.numerator * rhs.denominator == rhs.numerator * lhs.denominator
    }
}

extension Rational: MultiplicativeIdentity {
    public static var multiplicativeIdentity: Rational {
        return Rational(1)
    }
}

extension Rational: Halvable {
    public func half() -> Rational {
        return Rational(numerator: numerator,
                        denominator: denominator.twice())!
    }
}

extension Rational: IntegerSpecialCaseProcedures {
    public func successor() -> Rational {
        return self + Rational(1)
    }

    public func predecessor() -> Rational {
        return self - Rational(1)
    }

    public func twice() -> Rational {
        return self + self
    }

    public func halfNonnegative() -> Rational {
        let n = numerator < 0 ? -numerator : numerator
        let d = denominator < 0 ? -denominator : denominator
        return Rational(numerator: n, denominator: d.twice())!
    }

    public func isPositive() -> Bool {
        return Rational(0) < self
    }

    public func isNegative() -> Bool {
        return self < Rational.additiveIdentity
    }

    public func isZero() -> Bool {
        return self == Rational(0)
    }

    public func isOne() -> Bool {
        return self == Rational(1)
    }

    public func isEven() -> Bool {
        if numerator < denominator { return false }
        if numerator % denominator != 0 { return false }
        if (numerator / denominator) % 2 != 0 { return false }
        return true
    }

    public func isOdd() -> Bool {
        return !self.isEven()
    }
}
