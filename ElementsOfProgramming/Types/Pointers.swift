//
//  Pointers.swift
//  ElementsOfProgramming
//

//extension Pointer: Iterator {
//    var iteratorSuccessor: Pointer<Pointee>? {
//        return self + 1
//    }
//}
//
//extension Pointer: ForwardIterator { }
//
//extension Pointer: BidirectionalIterator {
//    var iteratorPredecessor: Pointer<Pointee>? {
//        return self - 1
//    }
//}

// MARK: Pointer wrappers

struct IntPointer: Regular {
    var p: UnsafeMutablePointer<Int>
    
    static func ==(lhs: IntPointer, rhs: IntPointer) -> Bool {
        return lhs.p == rhs.p
    }
}

extension IntPointer: Readable {
    var source: Int? {
        return p.pointee
    }
}

extension IntPointer: Writable {
    var sink: Int? {
        get {
            return nil
        }
        set {
            p.pointee = newValue!
        }
    }
}

extension IntPointer: Mutable {
    var deref: Int? {
        get {
            return p.pointee
        }
        set {
            p.pointee = newValue!
        }
    }
}

// MARK: Functions

func source<T: Regular>(_ x: UnsafeMutablePointer<T>) -> T {
    return x.pointee
}

func successor<T: Regular>(_ x: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> {
    return x + 1
}

func predecessor<T: Regular>(_ x: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> {
    return x - 1
}

func sink<T: Regular>(_ x: UnsafeMutablePointer<T>) -> T {
    return x.pointee
}

func deref<T: Regular>(_ x: UnsafeMutablePointer<T>) -> T {
    return x.pointee
}

//func address<T>(of x: Pointer<T>) -> {
//
//}

func pointer<T: Regular>(_ args: T...) -> UnsafeMutablePointer<T> {
    let a = UnsafeMutablePointer<T>.allocate(capacity: args.count)
    a.initialize(to: args[0], count: args.count)
    for n in 0..<args.count {
        a[n] = args[n]
    }
    return a
}

func pointer<T: Regular>(count: Int, value: T) -> UnsafeMutablePointer<T> {
    let a = UnsafeMutablePointer<T>.allocate(capacity: count)
    a.initialize(to: value, count: count)
    return a
}
