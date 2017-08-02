//
//  Float+Additions
//  ElementsOfProgramming
//

extension Float : MultiplicativeIdentity {
    public static var multiplicativeIdentity: Float {
        return 1.0
    }
}

extension Float : AdditiveIdentity {
    public static var additiveIdentity: Float {
        return 0.0
    }
}

extension Float: Halvable {
    public func half() -> Float { return self / 2.0 }
}

extension Float: MultiplicativeInverse {
    public func multiplicativeInverse() -> Float {
        return Float.multiplicativeIdentity / self
    }
}

extension Float: Norm {
    public func w() -> Float {
        if self < Float.additiveIdentity {
            return -self
        }
        return self
    }
}

extension Float : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse { }
