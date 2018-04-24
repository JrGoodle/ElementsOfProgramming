//
//  Int+Extensions.swift
//  ElementsOfProgramming
//

extension Int : MultiplicativeIdentity {
    public static var multiplicativeIdentity: Int {
        return 1
    }
}

extension Int : AdditiveIdentity {
    public static var additiveIdentity: Int {
        return 0
    }
}

extension Int: Halvable {
    public func half() -> Int { return self / 2 }
}

extension Int: MultiplicativeInverse {
    public func multiplicativeInverse() -> Int {
        return Int.multiplicativeIdentity / self
    }
}

extension Int: Remainder {
    public func remainder(_ value: Int) -> Int {
        return self % value
    }
}

extension Int: Norm {
    public func w() -> Int {
        if self < Int.additiveIdentity {
            return -self
        }
        return self
    }
}

extension Int : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse, Modulus, Distance, AdditiveSemigroup, MultiplicativeSemigroup, AdditiveMonoid, MultiplicativeMonoid, Semiring, CommutativeSemiring, EuclideanSemiring {}

extension Int: IntegerSpecialCaseProcedures, BinaryIntegerSpecialCaseProcedures {
    public func successor() -> Int {
        return self + 1
    }

    public func predecessor() -> Int {
        return self - 1
    }

    public func twice() -> Int {
        return self + self
    }

    public func halfNonnegative() -> Int {
        return self >> 1
    }

    public func binaryScaleDownNonnegative(k: Int) -> Int {
        return self >> k
    }

    public func binaryScaleUpNonnegative(k: Int) -> Int {
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

extension Int: IndexedIterator {
    public func distance(from precedingIterator: Int) -> DistanceType {
        assert(self > precedingIterator)
        if self < 0 && precedingIterator < 0 {
            return UInt(abs(self) - abs(precedingIterator))
        } else if self > 0 && precedingIterator > 0 {
            return UInt(self - precedingIterator)
        }
        return UInt(abs(self) + abs(precedingIterator))
    }

    public func successor(at distance: DistanceType) -> Int? {
        return self + Int(distance)
    }
}

extension Int: Iterator {
    public var iteratorSuccessor: Int? {
        return self + 1
    }
}

extension Int: Readable {
    public var source: Int? {
        return self
    }
}
