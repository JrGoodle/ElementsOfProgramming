//
//  Float.swift
//  ElementsOfProgramming
//

extension Float : MultiplicativeIdentity {
    static func multiplicativeIdentity() -> Float {
        return 1.0
    }
}

extension Float : AdditiveIdentity {
    static func additiveIdentity() -> Float {
        return 0.0
    }
}

extension Float: Halvable {
    func half() -> Float { return self / 2.0 }
}

extension Float: MultiplicativeInverse {
    func multiplicativeInverse() -> Float {
        return Float.multiplicativeIdentity() / self
    }
}

extension Float: Norm {
    func w() -> Float {
        if self < Float.additiveIdentity() {
            return -self
        }
        return self
    }
}

extension Float : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse { }
