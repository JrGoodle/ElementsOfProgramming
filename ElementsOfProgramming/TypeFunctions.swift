//
//  TypeFunctions.swift
//  ElementsOfProgramming
//

// MARK: Chapter 1

// MARK: Chapter 2

// Domain: UnaryFunction -> Regular

// Distance: Transformation -> Integer
typealias DistanceType = Int
protocol Distance {
    func distance<T: Regular>(to: Self, f: Transformation<T>) -> Int
}

//extension Distance where Self: Regular {
//    func distance(to start: Self, f: Transformation<Self>) -> Int {
//        var x = self
//        let y = start
//        // Precondition: $y$ is reachable from $x$ under $f$
//        typealias N = DistanceType
//        var n = N(0)
//        while x != y {
//            x = f(x)
//            n = n + N(1)
//        }
//        return n
//    }
//}

//extension Int: Distance {
//    func distance<T>(to: Int, f: (T) -> T) -> Int where T : Equatable {
//        var x = self
//        let y = to
//        // Precondition: $y$ is reachable from $x$ under $f$
//        typealias N = DistanceType
//        var n = N(0)
//        while x != y {
//            x = f(x)
//            n = n + N(1)
//        }
//        return n
//    }
//}

