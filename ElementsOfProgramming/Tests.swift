//
//  Tests.swift
//  ElementsOfProgramming
//

func logFunc(functionName: String = #function) {
    print("\(functionName)")
}

func outputOrbitStructure<DomainFP: TotallyOrdered>(x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) {
    logFunc()
    let t = orbitStructure(x: x, f: f, p: p)
    if !p(t.m2) {
        print("terminating with h-1 = \(t.m0) and terminal point \(t.m2)")
    } else if t.m2 == x {
        print("circular with collision point \(collisionPoint(x: x, f: f, p: p)) and c-1 = \(t.m1)")
    } else {
        print("rho-shaped with collision point \(collisionPoint(x: x, f: f, p: p)) and")
        print("h = \(t.m0) and c-1 = \(t.m1) and connection point \(t.m2)")
    }
    print("")
}

func testAdditiveCongruentialTransformation(modulus: Int, index: Int) {
    logFunc()
    print("Running testAdditiveCongruentialTransformation")
    let additiveCongruentialTransformation: (Int) -> Int = { x in
        return (x + index) % modulus
    }

    outputOrbitStructure(x: index,
                         f: additiveCongruentialTransformation,
                         p: { _ in return true })
}
