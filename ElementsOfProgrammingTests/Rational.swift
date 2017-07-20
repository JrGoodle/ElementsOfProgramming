//
//  Rational.swift
//  ElementsOfProgramming
//

import XCTest

struct Rational {
    var numerator: Int
    var denominator: Int
    
    init(numerator: Int, denominator: Int) {
        XCTAssert(denominator != Int(0))
        self.numerator = numerator
        self.denominator = denominator
    }
    
    init(_ n: Int) {
        self.init(numerator: n, denominator: Int(1))
    }
    
    func print() {
        if numerator.zero() {
            Swift.print("0")
        } else if denominator.one() {
            Swift.print(numerator)
        } else {
            Swift.print("\(numerator)/\(denominator)")
        }
        
    }
}

extension Rational: AdditiveInverse, Quotient { }

extension Rational: Addable {
    static func +(lhs: Rational, rhs: Rational) -> Rational {
        return Rational(numerator: rhs.denominator * lhs.numerator + lhs.denominator * rhs.numerator,
                        denominator: lhs.denominator * rhs.denominator)
    }
}

extension Rational: Negatable {
    static prefix func -(value: Rational) -> Rational {
        return Rational(numerator: -value.numerator,
                        denominator: value.denominator)
    }
}

extension Rational: Subtractable {
    static func -(lhs: Rational, rhs: Rational) -> Rational {
        return lhs + (-rhs)
    }
}

extension Rational: Multipliable {
    static func *(lhs: Rational, rhs: Rational) -> Rational {
        return Rational(numerator: lhs.numerator * rhs.numerator,
                        denominator: lhs.denominator * rhs.denominator)
    }
}

extension Rational: MultiplicativeInverse {
    func multiplicativeInverse() -> Rational {
        // Precondition: $x.p \neq 0$
        return Rational(numerator: self.denominator,
                        denominator: self.numerator)
    }
}

extension Rational: Divisible {
    static func /(lhs: Rational, rhs: Rational) -> Rational {
        return Rational(numerator: lhs.numerator * rhs.denominator,
                        denominator: lhs.denominator * rhs.numerator)
        // Postcondition: x * multiplicative_inverse(y)
    }
}

// Multiplication for rational<N> as a semimodule over integers
extension Rational {
    static func *(lhs: Int, rhs: Rational) -> Rational {
        return Rational(numerator: lhs * rhs.numerator,
                        denominator: rhs.denominator)
    }
}

extension Rational: Remainder {
    func remainder(_ value: Rational) -> Rational {
        return remainderNonnegative(a: self, b: value)
    }
}

extension Rational: Equatable {
    static func ==(lhs: Rational, rhs: Rational) -> Bool {
        return lhs.numerator * rhs.denominator == rhs.numerator * lhs.denominator
    }
}

extension Rational: Comparable {
    static func <(lhs: Rational, rhs: Rational) -> Bool {
        return lhs.numerator * rhs.denominator < rhs.numerator * lhs.denominator
    }
}

extension Rational: AdditiveIdentity {
    static func additiveIdentity() -> Rational {
        return Rational(0)
    }
}
