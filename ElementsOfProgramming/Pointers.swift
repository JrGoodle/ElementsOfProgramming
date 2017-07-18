//
//  Pointers.swift
//  ElementsOfProgramming
//

// TODO: Implement once conditional protocol conformances are available
//protocol Interator {
//    associatedtype T
//    associatedtype U
//
//    func source<T: Regular>() -> T
//
//    func successor<U>() -> U
//
//    func predecessor<U>() -> U
//
//    func sink<T: Regular>() -> T
//
//    func deref<T: Regular>() -> T
//}
//
//extension UnsafeMutablePointer: Iterator where T == Pair<Int, Int> {
//    func source<T: Regular>() -> T {
//        return self.pointee
//    }
//
//    func successor<T: Regular>() -> UnsafeMutablePointer<T> {
//        return self + 1
//    }
//
//    func predecessor<T: Regular>() -> UnsafeMutablePointer<T> {
//        return self - 1
//    }
//
//    func sink<T: Regular>() -> T {
//        return self.pointee
//    }
//
//    func deref<T: Regular>() -> T {
//        return self.pointee
//    }
//
//    //func address<T>(of x: UnsafeMutablePointer<T>) -> {
//    //
//    //}
//}

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

//func address<T>(of x: UnsafeMutablePointer<T>) -> {
//
//}

func pointer<T: Regular>(_ args: T...) -> UnsafeMutablePointer<T> {
    let a = UnsafeMutablePointer<T>.allocate(capacity: args.count)
    a.initialize(to: args[0], count: args.count)
    var i = 0
    for arg in args {
        a[i] = arg
        i += 1
    }
    return a
}
