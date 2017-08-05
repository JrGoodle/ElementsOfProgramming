//
//  Rational.swift
//  ElementsOfProgramming
//

import EOP

struct Rational {
    var numerator: Int
    var denominator: Int
    
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
        let gcd = gcdEuclideanSemiring(a: numerator, b: denominator)
        numerator = numerator / gcd
        denominator = denominator / gcd
    }
    
    private mutating func normalize() {
        if (numerator < 0 && denominator < 0) ||
            denominator < 0 {
            numerator = numerator * -1
            denominator = denominator * -1
        }
    }
}

extension Rational: AdditiveInverse, ArchimedeanMonoid {
    static func -(lhs: Rational, rhs: Rational) -> Rational {
        return lhs + (-rhs)
    }
    
    static func <(lhs: Rational, rhs: Rational) -> Bool {
        return lhs.numerator * rhs.denominator < rhs.numerator * lhs.denominator
    }
    
    static var additiveIdentity: Rational {
        return Rational(0)
    }
}

extension Rational: Addable {
    static func +(lhs: Rational, rhs: Rational) -> Rational {
        return Rational(numerator: rhs.denominator * lhs.numerator + lhs.denominator * rhs.numerator,
                        denominator: lhs.denominator * rhs.denominator)!
    }
}

extension Rational: Negatable {
    static prefix func -(value: Rational) -> Rational {
        return Rational(numerator: -value.numerator,
                        denominator: value.denominator)!
    }
}

extension Rational: Multipliable {
    static func *(lhs: Rational, rhs: Rational) -> Rational {
        return Rational(numerator: lhs.numerator * rhs.numerator,
                        denominator: lhs.denominator * rhs.denominator)!
    }
}

extension Rational: MultiplicativeInverse {
    func multiplicativeInverse() -> Rational {
        // Precondition: $x.p ≠ 0$
        return Rational(numerator: self.denominator,
                        denominator: self.numerator)!
    }
}

extension Rational: Divisible {
    static func /(lhs: Rational, rhs: Rational) -> Rational {
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

extension Rational: Remainder {
    func remainder(_ value: Rational) -> Rational {
        return remainderNonnegative(a: self, b: value)
    }
}

extension Rational: Regular {
    static func ==(lhs: Rational, rhs: Rational) -> Bool {
        return lhs.numerator * rhs.denominator == rhs.numerator * lhs.denominator
    }
}

extension Rational: MultiplicativeIdentity {
    static var multiplicativeIdentity: Rational {
        return Rational(1)
    }
    

}

extension Rational: Halvable {
    func half() -> Rational {
        return Rational(numerator: numerator,
                        denominator: denominator.twice())!
    }
}

extension Rational: IntegerSpecialCaseProcedures {
    func successor() -> Rational {
        return self + Rational(1)
    }
    
    func predecessor() -> Rational {
        return self - Rational(1)
    }
    
    func twice() -> Rational {
        return self + self
    }
    
    func halfNonnegative() -> Rational {
        let n = numerator < 0 ? -numerator : numerator
        let d = denominator < 0 ? -denominator : denominator
        return Rational(numerator: n, denominator: d.twice())!
    }
    
    func isPositive() -> Bool {
        return Rational(0) < self
    }
    
    func isNegative() -> Bool {
        return self < Rational.additiveIdentity
    }
    
    func isZero() -> Bool {
        return self == Rational(0)
    }
    
    func isOne() -> Bool {
        return self == Rational(1)
    }
    
    func isEven() -> Bool {
        if numerator < denominator { return false }
        if numerator % denominator != 0 { return false }
        if (numerator / denominator) % 2 != 0 { return false }
        return true
    }
    
    func isOdd() -> Bool {
        return !self.isEven()
    }
}
