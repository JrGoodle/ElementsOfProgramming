//
//  Chapter06.swift
//  ElementsOfProgramming
//

func increment<I: Iterator>(x: inout I) {
    // Precondition: $\func{successor}(x)$ is defined
    x = x._successor()!
}

func +<I: Iterator>(f: I, n: DistanceType) -> I {
    var f = f, n = n
    // Precondition: \property{weak\_range}(f, n)$
    precondition(n >= 0)
    while !n.zero() {
        n = n.predecessor()
        f = f._successor()!
    }
    return f
}

func -<I: Iterator>(l: I, f: I) -> DistanceType {
    var f = f
    // Precondition: $\property{bounded\_range}(f, l)$
    var n = DistanceType(0)
    while f != l {
        n = n.successor()
        f = f._successor()!
    }
    return n
}

func forEach<I: Iterator & Readable>(f: I, l: I, proc: @escaping UnaryProcedure<I.Source>) -> UnaryProcedure<I.Source> {
    var f = f
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l {
        proc(f.source()!)
        f = f._successor()!
    }
    return proc
}

// TODO: Readable, Iterator
func findIf<DomainP: Regular>(f: UnsafeMutablePointer<DomainP>, l: UnsafeMutablePointer<DomainP>, p: UnaryPredicate<DomainP>) -> UnsafeMutablePointer<DomainP> {
    var f = f
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l && !p(source(f)) {
        f = successor(f)
    }
    return f
}

