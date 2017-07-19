//
//  Pointers.swift
//  ElementsOfProgramming
//

protocol Iterator: Regular {
    associatedtype T: Regular

    func source<T: Regular>() -> T
    func successor() -> Self
    func predecessor() -> Self
    func sink<T: Regular>() -> T
    func deref<T: Regular>() -> T
}

// TODO: Implement once conditional protocol conformances are available
extension UnsafeMutablePointer: Iterator {
    func source<T: Regular>() -> T {
        return self.pointee as! T
    }
    
    func sink<T: Regular>() -> T {
        return self.pointee as! T
    }
    
    func deref<T: Regular>() -> T {
        return self.pointee as! T
    }
    
    typealias T = Pair<Int, Int>
}

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
