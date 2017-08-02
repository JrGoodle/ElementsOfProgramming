//
//  Drivers.swift
//  ElementsOfProgramming
//

import EOP

func logFunc(functionName: String = #function) {
    print("\(functionName)")
}

func outputOrbitStructure<DomainFP: Distance & Regular>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
) {
    let t = orbitStructure(start: x,
                           transformation: f,
                           definitionSpace: p)
    if !p(t.m2) {
        print("terminating with h-1 = \(t.m0) and terminal point \(t.m2)")
    } else if t.m2 == x {
        let cp = collisionPoint(start: x,
                                transformation: f,
                                definitionSpace: p)
        print("circular with collision point \(cp) and c-1 = \(t.m1)")
    } else {
        let cp = collisionPoint(start: x,
                                transformation: f,
                                definitionSpace: p)
        print("rho-shaped with collision point \(cp) and")
        print("h = \(t.m0) and c-1 = \(t.m1) and connection point \(t.m2)")
    }
    print("")
}

func additiveCongruentialTransformation(
    modulus: Int,
    index: Int
) -> (Int) -> Int {
    return { x in (x + index) % modulus }
}

func alwaysDefined<T>() -> ((T) -> Bool) {
    return { _ in return true }
}

func testAdditiveCongruentialTransformation(modulus: Int, index: Int) {
    print("Running testAdditiveCongruentialTransformation")
    let f = additiveCongruentialTransformation(modulus: modulus, index: index)
    outputOrbitStructure(x: index,
                         f: f,
                         p: alwaysDefined())
}
