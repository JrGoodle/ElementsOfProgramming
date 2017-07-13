// Elements of Programming

// Definitions

typealias RegularType = Equatable
typealias TotallyOrdered = Comparable & Equatable
typealias N = Int
typealias Integer = Int

// Type Functions

typealias DistanceType = Int

// Concepts

typealias UnaryFunction<T> = (T) -> Any where T: TotallyOrdered

typealias UnaryPredicate<T> = (T) -> Bool
typealias P<T> = UnaryPredicate<T>

typealias UnaryOperation<T> = (T) -> T
typealias F<T> = UnaryOperation<T>

typealias BinaryOperation<T> = (T, T) -> T
typealias Op<T> = BinaryOperation<T>

typealias Transformation<T> = UnaryOperation<T>

// Scratch Pad

struct Triple<T0: TotallyOrdered, T1: TotallyOrdered, T2: TotallyOrdered>: TotallyOrdered {
    var m0: T0
    var m1: T1
    var m2: T2
    
    static func == (x: Triple, y: Triple) -> Bool {
        return x.m0 == y.m0 && x.m1 == y.m1 && x.m2 == y.m2
    }
    
    static func < (x: Triple, y: Triple) -> Bool {
        return x.m0 < y.m0 ||
            (!(y.m0 < x.m0) && x.m1 < y.m1) ||
            (!(y.m1 < x.m1) && x.m2 < y.m2)
    }
}

func outputOrbitStructure(x: Int, p: UnaryPredicate<Int>) {
    let t = Triple(m0: 1000000000, m1: 200000000000, m2: 3000000000000)
    if !p(t.m2) {
        print("if")
    } else if t.m2 == x {
        print("else if")
    } else {
        print("else")
    }
    print("")
}

outputOrbitStructure(x: 10, p: { _ in return true })

