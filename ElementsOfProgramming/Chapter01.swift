//
//  Chapter01.swift
//  ElementsOfProgramming
//

func plus0(a: Int, b: Int) -> Int {
    return a + b
}

func plus1(a: Int, b: Int) -> Int {
    return a + b
}

func plus2(a: UnsafePointer<Int>, b: UnsafePointer<Int>, c: Pointer<Int>) {
    c.pointee = a.pointee + b.pointee
}

func square(n: Int) -> Int { return n * n }

func square<DomainOp: Regular>(x: DomainOp, op: BinaryOperation<DomainOp>) -> DomainOp {
    return op(x, x)
}

func equal<T: Regular>(x: T, y: T) -> Bool { return x == y }

// InputType(F, i)
// Returns the type of the ith parameter (counting from 0)

// type pair (see chapter 12 of Elements of Programming)
// model Regular(Pair)

// TODO: Conditional conformance
//struct Pair<T0, T1> {
struct Pair<T0: TotallyOrdered, T1: TotallyOrdered> {
    var m0: T0
    var m1: T1
}

// TODO: Conditional conformance
//extension Pair: Regular where T0: Regular, T1: Regular {
extension Pair: Regular {
    static func == (x: Pair, y: Pair) -> Bool {
        logFunc()
        return x.m0 == y.m0 && x.m1 == y.m1
    }
}

// TODO: Conditional conformance
//extension Pair: TotallyOrdered where T0: TotallyOrdered, T1: TotallyOrdered {
extension Pair: TotallyOrdered {
    static func < (x: Pair, y: Pair) -> Bool {
        logFunc()
        return x.m0 < y.m0 || (!(y.m0 < x.m0) && x.m1 < y.m1)
    }
}

// type triple (see Exercise 12.2 of Elements of Programming)
// model Regular(triple)

struct Triple<T0: TotallyOrdered, T1: TotallyOrdered, T2: TotallyOrdered> {
    var m0: T0
    var m1: T1
    var m2: T2
}

extension Triple: Regular {
    static func == (x: Triple, y: Triple) -> Bool {
        logFunc()
        return x.m0 == y.m0 && x.m1 == y.m1 && x.m2 == y.m2
    }
}

extension Triple: TotallyOrdered {
    static func < (x: Triple, y: Triple) -> Bool {
        logFunc()
        return x.m0 < y.m0 ||
            (!(y.m0 < x.m0) && x.m1 < y.m1) ||
            (!(y.m1 < x.m1) && x.m2 < y.m2)
    }
}
