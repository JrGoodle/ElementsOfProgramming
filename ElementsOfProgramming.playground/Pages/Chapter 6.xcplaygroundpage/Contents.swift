//
//  Chapter06.swift
//  ElementsOfProgramming
//

func plus<T: AdditiveSemigroup>(x: T, y: T) -> T {
    return x + y
}

func complementOfConverse<DomainR: Regular>(
    r: @escaping Relation<DomainR>
    ) -> Relation<DomainR> {
    return { a, b in
        return !r(b, a)
    }
}

///

func increment<I: Iterator>(x: inout I) {
    // Precondition: successor(x) is defined
    x = x.iteratorSuccessor!
}

func +<I: Iterator>(f: I, n: DistanceType) -> I {
    var f = f, n = n
    // Precondition: weak_range(f, n)
    assert(n >= 0)
    while !n.isEqualToZero() {
        n = n.predecessor()
        f = f.iteratorSuccessor!
    }
    return f
}

func -<I: Iterator>(l: I, f: I) -> DistanceType {
    var f = f
    // Precondition: bounded_range(f, l)
    var n = DistanceType(0)
    while f != l {
        n = n.successor()
        f = f.iteratorSuccessor!
    }
    return n
}

func forEach<
    I: Readable & Iterator,
    P: UnaryProcedure
    >(
    f: I, l: I,
    proc: P
    ) -> P where P.UnaryProcedureType == I.Source {
    var f = f
    // Precondition: readable_bounded_range(f, l)
    while f != l {
        proc.call(f.source!)
        f = f.iteratorSuccessor!
    }
    return proc
}

func find<I: Readable & Iterator>(f: I, l: I, x: I.Source) -> I {
    var f = f
    // Precondition: readable_bounded_range(f, l)
    while f != l && f.source! != x { f = f.iteratorSuccessor! }
    return f
}

func findNot<I: Readable & Iterator>(f: I, l: I, x: I.Source) -> I {
    var f = f
    // Precondition: readable_bounded_range(f, l)
    while f != l && f.source! == x { f = f.iteratorSuccessor! }
    return f
}

func findIf<I: Readable & Iterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> I {
    var f = f
    // Precondition: readable_bounded_range(f, l)
    while f != l && !p(f.source!) { f = f.iteratorSuccessor! }
    return f
}

func findIfNot<I: Readable & Iterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> I {
    var f = f
    // Precondition: readable_bounded_range(f, l)
    while f != l && p(f.source!) { f = f.iteratorSuccessor! }
    return f
}

// Exercise 6.1: quantifier functions

func all<I: Readable & Iterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> Bool {
    // Precondition: readable_bounded_range(f, l)
    return l == findIfNot(f: f, l: l, p: p)
}

func none<I: Readable & Iterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> Bool {
    // Precondition: readable_bounded_range(f, l)
    return l == findIf(f: f, l: l, p: p)
}

func notAll<I: Readable & Iterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> Bool {
    // Precondition: readable_bounded_range(f, l)
    return !all(f: f, l: l, p: p)
}

func some<I: Readable & Iterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> Bool {
    // Precondition: readable_bounded_range(f, l)
    return !none(f: f, l: l, p: p)
}

func countIf<
    I: Readable & Iterator,
    J: Iterator
    >(
    f: I, l: I,
    p: UnaryPredicate<I.Source>, j: J
    ) -> J {
    var f = f, j = j
    // Precondition: readable_bounded_range(f, l)
    while f != l {
        if p(f.source!) { j = j.iteratorSuccessor! }
        f = f.iteratorSuccessor!
    }
    return j
}

// Exercise 6.2: implement count_if using for_each

func countIf<I: Readable & Iterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> DistanceType {
    // Precondition: readable_bounded_range(f, l)
    return countIf(f: f, l: l, p: p, j: DistanceType(0))
}

func count<
    I: Readable & Iterator,
    J: Iterator
    >(
    f: I, l: I,
    x: I.Source,
    j: J
    ) -> J{
    var f = f, j = j
    // Precondition: readable_bounded_range(f, l)
    while f != l {
        if f.source! == x { j = j.iteratorSuccessor! }
        f = f.iteratorSuccessor!
    }
    return j
}

func count<I: Readable & Iterator>(
    f: I, l: I,
    x: I.Source
    ) -> DistanceType {
    // Precondition: readable_bounded_range(f, l)
    return count(f: f, l: l, x: x, j: DistanceType(0))
}

func countNot<
    I: Readable & Iterator,
    J: Iterator
    >(
    f: I, l: I,
    x: I.Source,
    j: J
    ) -> J {
    var f = f, j = j
    // Precondition: readable_bounded_range(f, l)
    while f != l {
        if f.source! != x { j = j.iteratorSuccessor! }
        f = f.iteratorSuccessor!
    }
    return j
}

func countNot<I: Readable & Iterator>(
    f: I, l: I,
    x: I.Source
    ) -> DistanceType {
    // Precondition: readable_bounded_range(f, l)
    return countNot(f: f, l: l, x: x, j: DistanceType(0))
}

func countIfNot<
    I: Readable & Iterator,
    J: Iterator
    >(
    f: I, l: I,
    p: UnaryPredicate<I.Source>,
    j: J
    ) -> J {
    var f = f, j = j
    // Precondition: readable_bounded_range(f, l)
    while f != l {
        if !p(f.source!) { j = j.iteratorSuccessor! }
        f = f.iteratorSuccessor!
    }
    return j
}

func countIfNot<I: Readable & Iterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> DistanceType {
    // Precondition: readable_bounded_range(f, l)
    return countIfNot(f: f, l: l, p: p, j: DistanceType(0))
}

func reduceNonempty<
    I: Iterator,
    DomainOp: Regular
    >(
    f: I, l: I,
    op: BinaryOperation<DomainOp>,
    fun: UnaryFunction<I, DomainOp>
    ) -> DomainOp {
    var f = f
    // Precondition: bounded_range(f, l) ∧ f ≠ l
    // Precondition: partially_associative(op)
    // Precondition: (∀x ∈ [f, l)), fun(x) is defined
    var r = fun(f)
    f = f.iteratorSuccessor!
    while f != l {
        r = op(r, fun(f))
        f = f.iteratorSuccessor!
    }
    return r
}

func reduceNonempty<I: Readable & Iterator>(
    f: I, l: I,
    op: BinaryOperation<I.Source>
    ) -> I.Source {
    var f = f
    // Precondition: readable_bounded_range(f, l) ∧ f ≠ l
    // Precondition: partially_associative(op)
    var r = f.source!
    f = f.iteratorSuccessor!
    while f != l {
        r = op(r, f.source!)
        f = f.iteratorSuccessor!
    }
    return r
}

func reduce<
    I: Iterator,
    DomainOp: Regular
    >(
    f: I, l: I,
    op: BinaryOperation<DomainOp>,
    fun: UnaryFunction<I, DomainOp>,
    z: DomainOp
    ) -> DomainOp {
    // Precondition: bounded_range(f, l)
    // Precondition: partially_associative(op)
    // Precondition: (∀x ∈ [f, l)), fun(x) is defined
    if f == l { return z }
    return reduceNonempty(f: f, l: l, op: op, fun: fun)
}

func reduce<I: Readable & Iterator>(
    f: I, l: I,
    op: BinaryOperation<I.Source>,
    z: I.Source
    ) -> I.Source {
    // Precondition: readable_bounded_range(f, l)
    // Precondition: partially_associative(op)
    if f == l { return z }
    return reduceNonempty(f: f, l: l, op: op)
}

func reduceNonzeroes<
    I: Iterator,
    DomainOp: Regular
    >(
    f: I, l: I,
    op: BinaryOperation<DomainOp>,
    fun: UnaryFunction<I, DomainOp>,
    z: DomainOp
    ) -> DomainOp {
    var f = f
    // Precondition: bounded_range(f, l)
    // Precondition: partially_associative(op)
    // Precondition: (∀x ∈ [f, l)), fun(x) is defined
    var x: DomainOp
    repeat {
        if f == l { return z }
        x = fun(f)
        f = f.iteratorSuccessor!
    } while x == z
    
    while f != l {
        let y = fun(f)
        if y != z { x = op(x, y) }
        f = f.iteratorSuccessor!
    }
    return x
}

func reduceNonzeroes<I: Readable & Iterator>(
    f: I, l: I,
    op: BinaryOperation<I.Source>,
    z: I.Source
    ) -> I.Source {
    var f = f
    // Precondition: readable_bounded_range(f, l)
    // Precondition: partially_associative(op)
    var x: I.Source
    repeat {
        if f == l { return z }
        x = f.source!
        f = f.iteratorSuccessor!
    } while x == z
    
    while f != l {
        let y = f.source!
        if y != z { x = op(x, y) }
        f = f.iteratorSuccessor!
    }
    return x
}

func reduce<I: Readable & Iterator>(
    f: I, l: I
    ) -> I.Source
    where I.Source : AdditiveMonoid {
        // Precondition: readable_bounded_range(f, l)
        typealias T = I.Source
        return reduce(f: f, l: l, op: plus, z: T.additiveIdentity())
}

// FIXME: Figure out a way to make this work
//func forEachN<I: Readable & Iterator>(
//    f: I, n: DistanceType,
//    proc: UnaryProcedure<I.Source>
//) -> Pair<UnaryProcedure<I.Source>, I> {
//    var f = f, n = n
//    // Precondition: readable_weak_range(f, n)
//    while !n.isZero() {
//        n = n.predecessor()
//        proc(f.source()!)
//        f = f.successor!
//    }
//    return Pair(proc, f)
//}

func findN<I: Readable & Iterator>(
    f: I,
    n: DistanceType,
    x: I.Source
    ) -> Pair<I, DistanceType> {
    var f = f, n = n
    // Precondition: readable_weak_range(f, n)
    while !n.isEqualToZero() && f.source! != x {
        n = n.predecessor()
        f = f.iteratorSuccessor!
    }
    return Pair(m0: f, m1: n)
}


// Exercise 6.3: implement variations taking a weak range instead of a bounded range
// of all the versions of find, quantifiers, count, and reduce


func findIfUnguarded<I: Readable & Iterator>(
    f: I,
    p: UnaryPredicate<I.Source>
    ) -> I {
    var f = f
    // Precondition: (∃l), readable_bounded_range(f, l) ∧ some(f, l, p)
    while !p(f.source!) { f = f.iteratorSuccessor! }
    return f
    // Postcondition: p(source(f))
}

func findIfNotUnguarded<I: Readable & Iterator>(
    f: I,
    p: UnaryPredicate<I.Source>
    ) -> I {
    var f = f
    // Let l be the end of the implied range starting with f
    // Precondition: readable_bounded_range(f, l) ∧ not_all(f, l, p)
    while p(f.source!) { f = f.iteratorSuccessor! }
    return f
}

func findMismatch<
    I0: Readable & Iterator,
    I1: Readable & Iterator
    >(
    f0: I0, l0: I0,
    f1: I1, l1: I1,
    r: Relation<I0.Source>
    ) -> Pair<I0, I1>
    where I0.Source == I1.Source {
        var f0 = f0, f1 = f1
        // Precondition: readable_bounded_range(f0, l0)
        // Precondition: readable_bounded_range(f1, l1)
        while f0 != l0 && f1 != l1 && r(f0.source!, f1.source!) {
            f0 = f0.iteratorSuccessor!
            f1 = f1.iteratorSuccessor!
        }
        return Pair(m0: f0, m1: f1)
}

func findAdjacentMismatch<I: Readable & Iterator>(
    f: I, l: I,
    r: Relation<I.Source>
    ) -> I {
    var f = f
    // Precondition: readable_bounded_range(f, l)
    if f == l { return l }
    var x = f.source!
    while f != l && r(x, f.source!) {
        x = f.source!
        f = f.iteratorSuccessor!
    }
    return f
}

func relationPreserving<I: Readable & Iterator>(
    f: I, l: I,
    r: Relation<I.Source>
    ) -> Bool {
    // Precondition: readable_bounded_range(f, l)
    return l == findAdjacentMismatch(f: f, l: l, r: r)
}

func strictlyIncreasingRange<I: Readable & Iterator>(
    f: I, l: I,
    r: Relation<I.Source>
    ) -> Bool {
    // Precondition:
    // readable_bounded_range(f, l) ∧ weak_ordering(r)
    return relationPreserving(f: f, l: l, r: r)
}

func increasingRange<I: Readable & Iterator>(
    f: I, l: I,
    r: @escaping Relation<I.Source>
    ) -> Bool {
    // Precondition:
    // readable_bounded_range(f, l) ∧ weak_ordering(r)
    return relationPreserving(f: f,
                              l: l,
                              r: complementOfConverse(r: r))
}

func partitioned<I: Readable & Iterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> Bool {
    // Precondition: readable_bounded_range(f, l)
    return l == findIfNot(f: findIf(f: f, l: l, p: p),
                          l: l,
                          p: p)
}


// Exercise 6.6: partitioned_n


func findAdjacentMismatch<I: Readable & ForwardIterator>(
    f: I, l: I,
    r: Relation<I.Source>
    ) -> I {
    var f = f
    // Precondition: readable_bounded_range(f, l)
    if f == l { return l }
    var t: I
    repeat {
        t = f
        f = f.iteratorSuccessor!
    } while f != l && r(t.source!, f.source!)
    return f
}

func partitionPointN<I: Readable & ForwardIterator>(
    f: I,
    n: DistanceType,
    p: UnaryPredicate<I.Source>
    ) -> I {
    var f = f, n = n
    // Precondition:
    // readable_counted_range(f, n) ∧ partitioned_n(f, n, p)
    while !n.isEqualToZero() {
        let h = n.halfNonnegative()
        let m = f + h
        if p(m.source!) {
            n = h
        } else {
            n = n - h.successor()
            f = m.iteratorSuccessor!
        }
    }
    return f
}

func partitionPoint<I: Readable & ForwardIterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> I {
    // Precondition:
    // readable_bounded_range(f, l) ∧ partitioned(f, l, p)
    return partitionPointN(f: f, n: l - f, p: p)
}

func lowerBoundPredicate<DomainR: Regular>(
    a: DomainR,
    r: @escaping Relation<DomainR>
    ) -> UnaryPredicate<DomainR> {
    return { x in !r(x, a) }
}

func lowerBoundN<I: Readable & ForwardIterator>(
    f: I,
    n: DistanceType,
    a: I.Source,
    r: @escaping Relation<I.Source>
    ) -> I {
    // Precondition:
    // weak_ordering(r) ∧ increasing_counted_range(f, n, r)
    let p = lowerBoundPredicate(a: a, r: r)
    return partitionPointN(f: f, n: n, p: p)
}

func upperBoundPredicate<DomainR: Regular>(
    a: DomainR,
    r: @escaping Relation<DomainR>
    ) -> UnaryPredicate<DomainR> {
    return { x in r(a, x) }
}

func upperBoundN<I: Readable & ForwardIterator>(
    f: I,
    n: DistanceType,
    a: I.Source,
    r: @escaping Relation<I.Source>
    ) -> I {
    // Precondition:
    // weak_ordering(r) ∧ increasing_counted_range(f, n, r)
    let p = upperBoundPredicate(a: a, r: r)
    return partitionPointN(f: f, n: n, p: p)
}


// Exercise 6.7: equal_range

func -<I: BidirectionalIterator>(
    l: I,
    n: DistanceType
    ) -> I {
    var l = l, n = n
    // Precondition: n ≥ 0 ∧ (∃f ∈ I), (weak_range(f, n) ∧ l = f + n)
    while !n.isEqualToZero() {
        n = n.predecessor()
        l = l.iteratorPredecessor!
    }
    return l
}

func findBackwardIf<
    I: Readable & BidirectionalIterator
    >(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> I {
    var l = l
    // Precondition: readable_bounded_range(f, l)
    while l != f && !p(l.iteratorPredecessor!.source!) {
        l = l.iteratorPredecessor!
    }
    return l
}

func findBackwardIfNot<
    I: Readable & BidirectionalIterator
    >(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
    ) -> I {
    var l = l
    // Precondition: readable_bounded_range(f, l)
    while l != f && p(l.iteratorPredecessor!.source!) {
        l = l.iteratorPredecessor!
    }
    return l
}


// Exercise 6.8: optimized find_backward_if


// Exercise 6.9: palindrome predicate


func findBackwardIfUnguarded<
    I: Readable & BidirectionalIterator
    >(
    l: I,
    p: UnaryPredicate<I.Source>
    ) -> I {
    var l = l
    // Precondition:
    // (∃f ∈ I), readable_bounded_range(f, l) ∧ some(f, l, p)
    repeat { l = l.iteratorPredecessor! } while !p(l.source!)
    return l
    // Postcondition: p(source(l))
}

func findBackwardIfNotUnguarded<
    I: Readable & BidirectionalIterator
    >(
    l: I,
    p: UnaryPredicate<I.Source>
    ) -> I {
    var l = l
    // Precondition:
    // (∃f ∈ I), readable_bounded_range(f, l) ∧ not_all(f, l, p)
    repeat { l = l.iteratorPredecessor! } while p(l.source!)
    return l
    // Postcondition: ￢p(source(l))
}

