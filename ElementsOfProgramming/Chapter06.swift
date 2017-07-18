//
//  Chapter06.swift
//  ElementsOfProgramming
//

// TODO: Readable, Iterator
func findIf<DomainP: Regular>(f: UnsafeMutablePointer<DomainP>, l: UnsafeMutablePointer<DomainP>, p: UnaryPredicate<DomainP>) -> UnsafeMutablePointer<DomainP> {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    var f = f
    var src = source(f)
    while f != l && !p(src) {
        f = successor(f)
        src = source(f)
    }
    return f
}
