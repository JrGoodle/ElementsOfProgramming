//
//  Chapter01.swift
//  ElementsOfProgramming
//

func square<DomainOp>(_ x: DomainOp, op: BinaryOperation<DomainOp>) -> DomainOp {
    return op(x, x)
}

// InputType(F, i)
// Returns the type of the ith parameter (counting from 0)

// type pair (see chapter 12 of Elements of Programming)
// model Regular(Pair)

struct Pair<T0: TotallyOrderd, T1: TotallyOrderd> {
    var m0: T0
    var m1: T1
    
    static func < (x: Pair, y: Pair) -> Bool {
        return x.m0 < y.m0 || (!(y.m0 < x.m0) && x.m1 < y.m1)
    }
}

// type triple (see Exercise 12.2 of Elements of Programming)
// model Regular(triple)

struct Triple<T0: TotallyOrderd, T1: TotallyOrderd, T2: TotallyOrderd> {
    var m0: T0
    var m1: T1
    var m2: T2
    
    static func < (x: Triple, y: Triple) -> Bool {
        return x.m0 < y.m0 ||
            (!(y.m0 < x.m0) && x.m1 < y.m1) ||
            (!(y.m1 < x.m1) && x.m2 < y.m2)
    }
}
