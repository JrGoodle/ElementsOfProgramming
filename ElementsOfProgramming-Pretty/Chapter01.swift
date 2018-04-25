//
//  Chapter01.swift
//  ElementsOfProgramming
//

import EOP

func plus_0(a: Int, b: Int) -> Int {
    return a + b
}

// Swift dosen't have a way to express a const &
func plus_1(a: inout Int, b: inout Int) -> Int {
    return a + b
}

class IntReference {
    var value: Int

    init(_ value: Int) {
        self.value = value
    }
}

func plus_2(a: IntReference,
           b: IntReference,
           c: IntReference) {
    c.value = a.value + b.value
}

func square(n: Int) -> Int { return n * n }

func square<DomainOp: Regular>(
    x: DomainOp,
   op: BinaryOperation<DomainOp>
) -> DomainOp {
    return op(x, x)
}

public func equal<T: Regular>(x: T, y: T) -> Bool { return x == y }

// InputType(F, i)
// Returns the type of the ith parameter (counting from 0)

// type pair (see chapter 12 of Elements of Programming)
// model Regular(Pair)

// Pair<T0, T1>
// See EOP/Types/Tuples.swift

// type triple (see Exercise 12.2 of Elements of Programming)
// model Regular(triple)

// Triple<T0, T1, T2>
// See EOP/Types/Tuples.swift

