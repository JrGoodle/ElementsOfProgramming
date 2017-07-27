//
//  Chapter01.swift
//  ElementsOfProgramming
//

func plus0(a: Int, b: Int) -> Int {
    return a + b
}

// Swift dosen't have a way to express a const &
func plus1(a: inout Int, b: inout Int) -> Int {
    return a + b
}

func plus2(a: UnsafePointer<Int>,
           b: UnsafePointer<Int>,
           c: UnsafeMutablePointer<Int>) {
    c.pointee = a.pointee + b.pointee
}

func square(n: Int) -> Int { return n * n }

func square<DomainOp: Regular>(
    x: DomainOp,
   op: BinaryOperation<DomainOp>
) -> DomainOp {
    return op(x, x)
}

func equal<T: Regular>(x: T, y: T) -> Bool { return x == y }

// InputType(F, i)
// Returns the type of the ith parameter (counting from 0)

// type pair (see chapter 12 of Elements of Programming)
// model Regular(Pair)

struct Pair<T0: Regular, T1: Regular>: Regular {
    var m0: T0
    var m1: T1

    static func == (x: Pair, y: Pair) -> Bool {
        logFunc()
        return x.m0 == y.m0 && x.m1 == y.m1
    }

    static func < (x: Pair, y: Pair) -> Bool {
        logFunc()
        return x.m0 < y.m0 || (!(y.m0 < x.m0) && x.m1 < y.m1)
    }
}

// type triple (see Exercise 12.2 of Elements of Programming)
// model Regular(triple)

struct Triple<T0: Regular, T1: Regular, T2: Regular>: Regular {
    var m0: T0
    var m1: T1
    var m2: T2

    static func == (x: Triple, y: Triple) -> Bool {
        logFunc()
        return x.m0 == y.m0 && x.m1 == y.m1 && x.m2 == y.m2
    }

    static func < (x: Triple, y: Triple) -> Bool {
        logFunc()
        return x.m0 < y.m0 ||
            (!(y.m0 < x.m0) && x.m1 < y.m1) ||
            (!(y.m1 < x.m1) && x.m2 < y.m2)
    }
}
