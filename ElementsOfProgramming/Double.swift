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

extension Double : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, Norm, AdditiveInverse { }
