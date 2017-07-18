//
//  TypeFunctions.swift
//  ElementsOfProgramming
//

// MARK: Chapter 1

// MARK: Chapter 2

// Domain: UnaryFunction -> Regular

// Distance: Transformation -> Integer
typealias DistanceType = Int

protocol Distance: Regular {
    func distance(to: Self, f: Transformation<Self>) -> Int
}

extension Distance {
    func distance(to end: Self, f: Transformation<Self>) -> Int {
        var x = self
        let y = end
        // Precondition: $y$ is reachable from $x$ under $f$
        typealias N = DistanceType
        var n = N(0)
        while x != y {
            x = f(x)
            n = n + N(1)
        }
        return n
    }
}

extension Int: Distance {}

