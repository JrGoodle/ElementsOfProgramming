//
//  Chapter05.swift
//  ElementsOfProgramming
//

//TODO: ArchimedeanGroup
func remainder(_ a: Int, _ b: Int, rem: BinaryOperation<Int>) -> Int {
    // Precondition: $b \neq 0$
    typealias T = Int
    var r: T
    if a < T(0) {
        if (b < T(0)) {
            r = -rem(-a, -b)
        } else {
            r =  rem(-a,  b)
            if r != T(0) { r = b - r }
        }
    } else {
        if b < T(0) {
            r =  rem(a, -b)
            if r != T(0) { r = b + r }
        } else {
            r =  rem(a,  b)
        }
    }
    return r
}
