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

extension Pointer: ForwardIterator { }

extension Pointer: BidirectionalIterator {
    var iteratorPredecessor: Pointer<Pointee>? {
        return self - 1
    }
}

typealias PointeeType = Int

extension Pointer: Readable {
    var source: PointeeType? {
        return self.pointee as? PointeeType
    }
}

extension Pointer: Writable {
    var sink: PointeeType? {
        get {
            return nil
        }
        set {
            self.pointee = newValue as! Pointee
        }
    }
}

extension Pointer: Mutable {
    func deref() -> PointeeType? {
        return self.pointee as! PointeeType
    }
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
    for n in 0..<args.count {
        a[n] = args[n]
    }
    return a
}

func pointer<T: Regular>(count: Int, value: T) -> Pointer<T> {
    let a = Pointer<T>.allocate(capacity: count)
    a.initialize(to: value, count: count)
    return a
}
