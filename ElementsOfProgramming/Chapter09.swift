//
//  Chapter09.swift
//  ElementsOfProgramming
//

func exchangeValues<T: Regular>(x: Pointer<T>, y: Pointer<T>) {
    // Precondition: $\func{deref}(x)$ and $\func{deref}(y)$ are defined
    let t = source(x)
    x.pointee = source(y)
    y.pointee = t
}

func reverseBidirectional<T: Regular>(f: Pointer<T>, l: Pointer<T>) {
    var f = f, l = l
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    while true {
        if f == l { return }
        l = l.predecessor()
        if f == l { return }
        exchangeValues(x: f, y: l)
        f = f.successor()
    }
}
