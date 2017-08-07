//
//  Chapter01.swift
//  ElementsOfProgramming
//

import EOP

func plus0(a: Int, b: Int) -> Int {
    return a + b
}

// Swift dosen't have a way to express a const &
func plus1(a: inout Int, b: inout Int) -> Int {
    return a + b
}

class IntReference {
    var value: Int?
}

func plus2(a: IntReference,
           b: IntReference,
           c: IntReference) throws {
    guard let av = a.value, let bv = b.value else { throw EOPError.failure }
    c.value = av + bv
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
// See Tuples.swift

// type triple (see Exercise 12.2 of Elements of Programming)
// model Regular(triple)

// Triple<T0, T1, T2>
// See Tuples.swift

#if !XCODE
    // MARK: Playground examples
    
    func playgroundPlus2() {
        let a = IntReference(), b = IntReference(), c = IntReference()
        a.value = 2
        b.value = 2
        print(String(describing: c.value))
        try! plus2(a: a, b: b, c: c)
        print(String(describing: c.value))
    }
//    playgroundPlus2()
#endif
