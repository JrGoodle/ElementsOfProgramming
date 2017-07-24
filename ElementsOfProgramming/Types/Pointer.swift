//
//  Pointer.swift
//  ElementsOfProgramming
//

typealias Pointer<T> = UnsafeMutablePointer<T>

extension Pointer: Iterator {
    var iteratorSuccessor: Pointer<Pointee>? {
        return self + 1
    }
}

extension Pointer: BidirectionalIterator {
    func _predecessor() -> Pointer<Pointee>? {
        return self - 1
    }
}

extension Pointer: Readable {
    var source: Pair<Int, Int>? {
        return self.pointee as? Pair<Int, Int>
    }
    
    typealias Source = Pair<Int, Int>
}

func source<T: Regular>(_ x: Pointer<T>) -> T {
    return x.pointee
}

func successor<T: Regular>(_ x: Pointer<T>) -> Pointer<T> {
    return x + 1
}

func predecessor<T: Regular>(_ x: Pointer<T>) -> Pointer<T> {
    return x - 1
}

func sink<T: Regular>(_ x: Pointer<T>) -> T {
    return x.pointee
}

func deref<T: Regular>(_ x: Pointer<T>) -> T {
    return x.pointee
}

//func address<T>(of x: Pointer<T>) -> {
//
//}

func pointer<T: Regular>(_ args: T...) -> Pointer<T> {
    let a = Pointer<T>.allocate(capacity: args.count)
    a.initialize(to: args[0], count: args.count)
    var i = 0
    for arg in args {
        a[i] = arg
        i += 1
    }
    return a
}

func pointer<T: Regular>(count: Int, value: T) -> Pointer<T> {
    let a = Pointer<T>.allocate(capacity: count)
    a.initialize(to: value, count: count)
    return a
}
