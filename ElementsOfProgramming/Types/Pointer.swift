//
//  Pointer.swift
//  ElementsOfProgramming
//

typealias Pointer<T> = UnsafeMutablePointer<T>

//TODO: Uncomment once recursive protocol constraints are available
//extension UnsafeMutablePointer: Readable {
//    func source<T: Iterator>() -> T {
//        return self.pointee as! T
//    }
//}

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
    
    typealias Source = Pair<Int, Int>
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
