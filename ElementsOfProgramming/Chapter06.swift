//
//  Chapter06.swift
//  ElementsOfProgramming
//

// TODO: Readable, Iterator
func findIf<DomainP: Regular>(f: UnsafeMutablePointer<DomainP>, l: UnsafeMutablePointer<DomainP>, p: UnaryPredicate<DomainP>) -> UnsafeMutablePointer<DomainP> {
    var f = f
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l && !p(source(f)) {
        f = successor(f)
    }
    return f
}
