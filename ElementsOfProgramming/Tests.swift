//
//  Tests.swift
//  ElementsOfProgramming
//

func outputOrbitStructure<DomainFP: TotallyOrdered>(x: DomainFP, f: Transformation<DomainFP>, p: UnaryPredicate<DomainFP>) {
    let t = orbitStructure(x, f: f, p: p)
    if !p(t.m2) {
        print("terminating with h-1 = \(t.m0) and terminal point \(t.m2)")
    } else if t.m2 == x {
        print("circular with collision point \(collisionPoint(x, f: f, p: p)) and c-1 = \(print(t.m1))")
    } else {
        print("rho-shaped with collision point \(collisionPoint(x, f: f, p: p)) and h = \(t.m0)")
        print(" and c-1 = \(print(t.m1)) and connection point \(print(t.m2))")
    }
    print("")
}

func testAdditiveCongruentialTransformation() {
    print("Running testAdditiveCongruentialTransformation")
    let modulus = 100
    let index = 50
    let additiveCongruentialTransformation: (Int) -> Int = { x in
        return (x + index) % modulus
    }

    outputOrbitStructure(x: index,
                         f: additiveCongruentialTransformation,
                         p: { _ in return true })
}
