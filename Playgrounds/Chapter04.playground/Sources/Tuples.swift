//
//  Tuples.swift
//  EOP
//

// type pair (see chapter 12 of Elements of Programming)
// model Regular(Pair)

public struct Pair<T0: Regular, T1: Regular>: Regular {
    public var m0: T0
    public var m1: T1

    public init(m0: T0, m1: T1) {
        self.m0 = m0
        self.m1 = m1
    }

    public static func == (x: Pair, y: Pair) -> Bool {
        return x.m0 == y.m0 && x.m1 == y.m1
    }

    public static func < (x: Pair, y: Pair) -> Bool {
        return x.m0 < y.m0 || (!(y.m0 < x.m0) && x.m1 < y.m1)
    }
}

// type triple (see Exercise 12.2 of Elements of Programming)
// model Regular(triple)

public struct Triple<T0: Regular, T1: Regular, T2: Regular>: Regular {
    public var m0: T0
    public var m1: T1
    public var m2: T2

    public init(m0: T0, m1: T1, m2: T2) {
        self.m0 = m0
        self.m1 = m1
        self.m2 = m2
    }

    public static func == (x: Triple, y: Triple) -> Bool {
        return x.m0 == y.m0 && x.m1 == y.m1 && x.m2 == y.m2
    }

    public static func < (x: Triple, y: Triple) -> Bool {
        return x.m0 < y.m0 ||
            (!(y.m0 < x.m0) && x.m1 < y.m1) ||
            (!(y.m1 < x.m1) && x.m2 < y.m2)
    }
}
