//
//  Chapter06.swift
//  ElementsOfProgramming
//

func increment<I: Iterator>(x: inout I) {
    // Precondition: $\func{successor}(x)$ is defined
    x = x.iteratorSuccessor!
}

func +<I: Iterator>(f: I, n: DistanceType) -> I {
    var f = f, n = n
    // Precondition: \property{weak\_range}(f, n)$
    precondition(n >= 0)
    while !n.zero() {
        n = n.predecessor()
        f = f.iteratorSuccessor!
    }
    return f
}

func -<I: Iterator>(l: I, f: I) -> DistanceType {
    var f = f
    // Precondition: $\property{bounded\_range}(f, l)$
    var n = DistanceType(0)
    while f != l {
        n = n.successor()
        f = f.iteratorSuccessor!
    }
    return n
}

func forEach<I: Readable & Iterator, P: UnaryProcedure>(f: I, l: I, proc: P) -> P where P.UnaryProcedureType == I.Source {
    var f = f
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l {
        proc.call(f.source!)
        f = f.iteratorSuccessor!
    }
    return proc
}

func find<I: Readable & Iterator>(f: I, l: I, x: I.Source) -> I {
    var f = f
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l && f.source! != x { f = f.iteratorSuccessor! }
    return f
}

func findNot<I: Readable & Iterator>(f: I, l: I, x: I.Source) -> I {
    var f = f
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l && f.source! == x { f = f.iteratorSuccessor! }
    return f
}

func findIf<I: Readable & Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    var f = f
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l && !p(f.source!) { f = f.iteratorSuccessor! }
    return f
}

func findIfNot<I: Readable & Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    var f = f
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l && p(f.source!) { f = f.iteratorSuccessor! }
    return f
}

// Exercise 6.1: quantifier functions

func all<I: Readable & Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> Bool {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    return l == findIfNot(f: f, l: l, p: p)
}

func none<I: Readable & Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> Bool {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    return l == findIf(f: f, l: l, p: p)
}

func notAll<I: Readable & Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> Bool {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    return !all(f: f, l: l, p: p)
}

func some<I: Readable & Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> Bool {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    return !none(f: f, l: l, p: p)
}

func countIf<I: Readable & Iterator, J: Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>, j: J) -> J {
    var f = f, j = j
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l {
        if p(f.source!) { j = j.iteratorSuccessor! }
        f = f.iteratorSuccessor!
    }
    return j
}

// Exercise 6.2: implement count_if using for_each

func countIf<I: Readable & Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> DistanceType {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    return countIf(f: f, l: l, p: p, j: DistanceType(0))
}

func count<I: Readable & Iterator, J: Iterator>(f: I, l: I, x: I.Source, j: J) -> J{
    var f = f, j = j
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l {
        if f.source! == x { j = j.iteratorSuccessor! }
        f = f.iteratorSuccessor!
    }
    return j
}

func count<I: Readable & Iterator>(f: I, l: I, x: I.Source) -> DistanceType {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    return count(f: f, l: l, x: x, j: DistanceType(0))
}

func countNot<I: Readable & Iterator, J: Iterator>(f: I, l: I, x: I.Source, j: J) -> J {
    var f = f, j = j
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l {
        if f.source! != x { j = j.iteratorSuccessor! }
        f = f.iteratorSuccessor!
    }
    return j
}

func countNot<I: Readable & Iterator>(f: I, l: I, x: I.Source) -> DistanceType {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    return countNot(f: f, l: l, x: x, j: DistanceType(0))
}

func countIfNot<I: Readable & Iterator, J: Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>, j: J) -> J {
    var f = f, j = j
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while f != l {
        if !p(f.source!) { j = j.iteratorSuccessor! }
        f = f.iteratorSuccessor!
    }
    return j
}

func countIfNot<I: Readable & Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> DistanceType {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    return countIfNot(f: f, l: l, p: p, j: DistanceType(0))
}

func reduceNonempty<I: Iterator, DomainOp: Regular>(f: I, l: I, op: BinaryOperation<DomainOp>, fun: UnaryFunction<I, DomainOp>) -> DomainOp {
    var f = f
    // Precondition: $\property{bounded\_range}(f, l) \wedge f \neq l$
    // Precondition: $\property{partially\_associative}(op)$
    // Precondition: $(\forall x \in [f, l))\,fun(x)$ is defined
    var r = fun(f)
    f = f.iteratorSuccessor!
    while f != l {
        r = op(r, fun(f))
        f = f.iteratorSuccessor!
    }
    return r
}

func reduceNonempty<I: Readable & Iterator>(f: I, l: I, op: BinaryOperation<I.Source>) -> I.Source {
    var f = f
    // Precondition: $\property{readable\_bounded\_range}(f, l) \wedge f \neq l$
    // Precondition: $\property{partially\_associative}(op)$
    var r = f.source!
    f = f.iteratorSuccessor!
    while f != l {
        r = op(r, f.source!)
        f = f.iteratorSuccessor!
    }
    return r
}

func reduce<I: Iterator, DomainOp: Regular>(f: I, l: I, op: BinaryOperation<DomainOp>, fun: UnaryFunction<I, DomainOp>, z: DomainOp) -> DomainOp {
    // Precondition: $\property{bounded\_range}(f, l)$
    // Precondition: $\property{partially\_associative}(op)$
    // Precondition: $(\forall x \in [f, l))\,fun(x)$ is defined
    if f == l { return z }
    return reduceNonempty(f: f, l: l, op: op, fun: fun)
}

func reduce<I: Readable & Iterator>(f: I, l: I, op: BinaryOperation<I.Source>, z: I.Source) -> I.Source {
    // Precondition: $\property{readable\_bounded\_range}(f, l)$
    // Precondition: $\property{partially\_associative}(op)$
    if f == l { return z }
    return reduceNonempty(f: f, l: l, op: op)
}

func reduceNonzeroes<I: Iterator, DomainOp: Regular>(f: I, l: I, op: BinaryOperation<DomainOp>, fun: UnaryFunction<I, DomainOp>, z: DomainOp) -> DomainOp {
    var f = f
    // Precondition: $\property{bounded\_range}(f, l)$
    // Precondition: $\property{partially\_associative}(op)$
    // Precondition: $(\forall x \in [f, l))\,fun(x)$ is defined
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

func reduceNonzeroes<I: Readable & Iterator>(f: I, l: I, op: BinaryOperation<I.Source>, z: I.Source) -> I.Source {
    var f = f
    // Precondition: $\property{readable\_bounded\_range}(f, l)$
    // Precondition: $\property{partially\_associative}(op)$
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

func reduce<I: Readable & Iterator>(f: I, l: I) -> I.Source where I.Source : AdditiveMonoid {
    // Precondition: $\property{readable\_bounded\_range}(f, l)$
    typealias T = I.Source
    return reduce(f: f, l: l, op: plus, z: T.additiveIdentity())
}

// FIXME: Figure out a way to make this work
//func forEachN<I: Readable & Iterator>(f: I, n: DistanceType, proc: UnaryProcedure<I.Source>) -> Pair<UnaryProcedure<I.Source>, I> {
//    var f = f, n = n
//    // Precondition: $\property{readable\_weak\_range}(f, n)$
//    while !n.zero() {
//        n = n.predecessor()
//        proc(f.source()!)
//        f = f.successor!
//    }
//    return Pair(proc, f)
//}

func findN<I: Readable & Iterator>(f: I, n: DistanceType, x: I.Source) -> Pair<I, DistanceType> {
    var f = f, n = n
    // Precondition: $\property{readable\_weak\_range}(f, n)$
    while !n.zero() && f.source! != x {
        n = n.predecessor()
        f = f.iteratorSuccessor!
    }
    return Pair(m0: f, m1: n)
}


// Exercise 6.3: implement variations taking a weak range instead of a bounded range
// of all the versions of find, quantifiers, count, and reduce


func findIfUnguarded<I: Readable & Iterator>(f: I, p: UnaryPredicate<I.Source>) -> I {
    var f = f
    // Precondition:
    // $(\exists l)\,\func{readable\_bounded\_range}(f, l) \wedge \func{some}(f, l, p)$
    while !p(f.source!) { f = f.iteratorSuccessor! }
    return f
    // Postcondition: $p(\func{source}(f))$
}

func findIfNotUnguarded<I: Readable & Iterator>(f: I, p: UnaryPredicate<I.Source>) -> I {
    var f = f
    // Let $l$ be the end of the implied range starting with $f$
    // Precondition:
    // $\func{readable\_bounded\_range}(f, l) \wedge \func{not\_all}(f, l, p)$
    while p(f.source!) { f = f.iteratorSuccessor! }
    return f
}

func findMismatch<I0: Readable & Iterator, I1: Readable & Iterator>(f0: I0, l0: I0, f1: I1, l1: I1, r: Relation<I0.Source>) -> Pair<I0, I1> where I0.Source : TotallyOrdered, I0.Source == I1.Source {
    var f0 = f0, f1 = f1
    // Precondition: $\func{readable\_bounded\_range}(f0, l0)$
    // Precondition: $\func{readable\_bounded\_range}(f1, l1)$
    while f0 != l0 && f1 != l1 && r(f0.source!, f1.source!) {
        f0 = f0.iteratorSuccessor!
        f1 = f1.iteratorSuccessor!
    }
    return Pair(m0: f0, m1: f1)
}

func findAdjacentMismatch<I: Readable & Iterator>(f: I, l: I, r: Relation<I.Source>) -> I where I.Source : TotallyOrdered {
    var f = f
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    if f == l { return l }
    var x = f.source!
    while f != l && r(x, f.source!) {
        x = f.source!
        f = f.iteratorSuccessor!
    }
    return f
}

func relationPreserving<I: Readable & Iterator>(f: I, l: I, r: Relation<I.Source>) -> Bool where I.Source : TotallyOrdered {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    return l == findAdjacentMismatch(f: f, l: l, r: r)
}

func strictlyIncreasingRange<I: Readable & Iterator>(f: I, l: I, r: Relation<I.Source>) -> Bool where I.Source : TotallyOrdered {
    // Precondition:
    // $\func{readable\_bounded\_range}(f, l) \wedge \func{weak\_ordering}(r)$
    return relationPreserving(f: f, l: l, r: r)
}

func increasingRange<I: Readable & Iterator>(f: I, l: I, r: @escaping Relation<I.Source>) -> Bool where I.Source : TotallyOrdered {
    // Precondition:
    // $\func{readable\_bounded\_range}(f, l) \wedge \func{weak\_ordering}(r)$
    return relationPreserving(f: f,
                              l: l,
                              r: complementOfConverse(r: r))
}

func partitioned<I: Readable & Iterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> Bool {
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    return l == findIfNot(f: findIf(f: f, l: l, p: p),
                          l: l,
                          p: p)
}


// Exercise 6.6: partitioned_n


func findAdjacentMismatch<I: Readable & ForwardIterator>(f: I, l: I, r: Relation<I.Source>) -> I where I.Source : TotallyOrdered {
    var f = f
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    if f == l { return l }
    var t: I
    repeat {
        t = f
        f = f.iteratorSuccessor!
    } while f != l && r(t.source!, f.source!)
    return f
}

func partitionPointN<I: Readable & ForwardIterator>(f: I, n: DistanceType, p: UnaryPredicate<I.Source>) -> I {
    var f = f, n = n
    // Precondition:
    // $\func{readable\_counted\_range}(f, n) \wedge \func{partitioned\_n}(f, n, p)$
    while !n.zero() {
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

func partitionPoint<I: Readable & ForwardIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    // Precondition:
    // $\func{readable\_bounded\_range}(f, l) \wedge \func{partitioned}(f, l, p)$
    return partitionPointN(f: f, n: l - f, p: p)
}

func lowerBoundPredicate<DomainR: TotallyOrdered>(a: DomainR, r: @escaping Relation<DomainR>) -> UnaryPredicate<DomainR> {
    return { x in !r(x, a) }
}

func lowerBoundN<I: Readable & ForwardIterator>(f: I, n: DistanceType, a: I.Source, r: @escaping Relation<I.Source>) -> I where I.Source : TotallyOrdered {
    // Precondition:
    // $\property{weak\_ordering(r)} \wedge \property{increasing\_counted\_range}(f, n, r)$
    let p = lowerBoundPredicate(a: a, r: r)
    return partitionPointN(f: f, n: n, p: p)
}

func upperBoundPredicate<DomainR: TotallyOrdered>(a: DomainR, r: @escaping Relation<DomainR>) -> UnaryPredicate<DomainR> {
    return { x in r(a, x) }
}

func upperBoundN<I: Readable & ForwardIterator>(f: I, n: DistanceType, a: I.Source, r: @escaping Relation<I.Source>) -> I where I.Source : TotallyOrdered {
    // Precondition:
    // $\property{weak\_ordering(r)} \wedge \property{increasing\_counted\_range}(f, n, r)$
    let p = upperBoundPredicate(a: a, r: r)
    return partitionPointN(f: f, n: n, p: p)
}


// Exercise 6.7: equal_range

func -<I: BidirectionalIterator>(l: I, n: DistanceType) -> I {
    var l = l, n = n
    // Precondition: $n \geq 0 \wedge (\exists f \in I)\,(\func{weak\_range}(f, n) \wedge l = f+n)$
    while !n.zero() {
        n = n.predecessor()
        l = l._predecessor()!
    }
    return l
}

func findBackwardIf<I: Readable & BidirectionalIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    var l = l
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while l != f && !p(l._predecessor()!.source!) {
        l = l._predecessor()!
    }
    return l
}

func findBackwardIfNot<I: Readable & BidirectionalIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    var l = l
    // Precondition: $\func{readable\_bounded\_range}(f, l)$
    while l != f && p(l._predecessor()!.source!) {
        l = l._predecessor()!
    }
    return l
}


// Exercise 6.8: optimized find_backward_if


// Exercise 6.9: palindrome predicate


func findBackwardIfUnguarded<I: Readable & BidirectionalIterator>(l: I, p: UnaryPredicate<I.Source>) -> I {
    var l = l
    // Precondition:
    // $(\exists f \in I)\,\property{readable\_bounded\_range}(f, l) \wedge \property{some}(f, l, p)$
    repeat { l = l._predecessor()! } while !p(l.source!)
    return l
    // Postcondition: $p(\func{source}(l))$
}

func findBackwardIfNotUnguarded<I: Readable & BidirectionalIterator>(l: I, p: UnaryPredicate<I.Source>) -> I {
    var l = l
    // Precondition:
    // $(\exists f \in I)\,\property{readable\_bounded\_range}(f, l) \wedge \property{not\_all}(f, l, p)$
    repeat { l = l._predecessor()! } while p(l.source!)
    return l
    // Postcondition: $\neg p(\func{source}(l))$
}
