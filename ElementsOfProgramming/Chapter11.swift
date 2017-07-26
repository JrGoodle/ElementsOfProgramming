//
//  Chapter11.swift
//  ElementsOfProgramming
//

// Exercise 11.1:

func partitionedAtPoint<I: Readable & Iterator>(f: I, m: I, l: I, p: UnaryPredicate<I.Source>) -> Bool {
    // Precondition: $\property{readable\_bounded\_range}(f, l) \wedge m \in [f, l]$
    return none(f: f, l: m, p: p) && all(f: m, l: l, p: p)
}


// Exercise 11.2:

func potentialPartitionPoint<I: Readable & ForwardIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    // Precondition: $\property{readable\_bounded\_range}(f, l)$
    return countIfNot(f: f, l: l, p: p, j: f)
}

func partitionSemistable<I: Mutable & ForwardIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    var i = findIf(f: f, l: l, p: p)
    if i == l { return i }
    var j = i.iteratorSuccessor!
    while true {
        j = findIfNot(f: j, l: l, p: p)
        if j == l { return i }
        swapStep(f0: &i, f1: &j)
    }
}

// Exercise 11.3: rewrite partition_semistable, expanding find_if_not inline and
// eliminating extra test against l


// Exercise 11.4: substitute copy_step(j, i) for swap_step(i, j) in partition_semistable

func removeIf<I: Mutable & ForwardIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    var i = findIf(f: f, l: l, p: p)
    if i == l { return i }
    var j = i.iteratorSuccessor!
    while true {
        j = findIfNot(f: j, l: l, p: p)
        if j == l { return i }
        copyStep(fi: &j, fo: &i)
    }
}


// Exercise 11.5:

//template<typename I, typename P>
//    requires(Mutable(I) && ForwardIterator(I) &&
//        UnaryPredicate(P) && ValueType(I) == Domain(P))
//void partition_semistable_omit_last_predicate_evaluation(I f, I l, P p)
//{
//    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
//    ...
//}

func partitionBidirectional<I: Mutable & BidirectionalIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    var f = f, l = l
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    while true {
        f = findIf(f: f, l: l, p: p)
        l = findBackwardIfNot(f: f, l: l, p: p)
        if f == l { return f }
        reverseSwapStep(l0: &l, f1: &f)
    }
}

// Exercise 11.6:

func partitionForward<I: Mutable & ForwardIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    var f = f
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    let i = countIfNot(f: f, l: l, p: p, j: f)
    var j = i
    while true {
        j = findIfNot(f: j, l: l, p: p)
        if j == l { return i }
        f = findIfUnguarded(f: f, p: p)
        swapStep(f0: &f, f1: &j)
    }
}

// Exercise 11.7: partition_single_cycle

func partitonSingleCycle<I: Mutable & BidirectionalIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    var f = f, l = l
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    f = findIf(f: f, l: l, p: p)
    l = findBackwardIfNot(f: f, l: l, p: p)
    if f == l { return f }
    l = l.iteratorPredecessor!
    let tmp = f.source!
    while true {
        f.sink = l.source
        f = findIf(f: f.iteratorSuccessor!, l: l, p: p)
        if f == l {
            l.sink = tmp
            return f
        }
        l.sink = f.source!
        l = findBackwardIfNotUnguarded(l: l, p: p)
    }
}


// Exercise 11.8: partition_sentinel

func partitionBidirectionalUnguarded<I: Mutable & BidirectionalIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    var f = f, l = l
    // Precondition:
    // $(\neg \func{all}(f, l, p) \wedge \func{some}(f, l, p)) \vee
    // (\neg p(\func{source}(f-1)) \wedge p(\func{source}(l)))$
    while true {
        f = findIfUnguarded(f: f, p: p)
        l = findBackwardIfNotUnguarded(l: l, p: p)
        if l.iteratorSuccessor! == f { return f }
        exchangeValues(x: f, y: l)
        f = f.iteratorSuccessor! // $\neg p(\func{source}(f-1)) \wedge p(\func{source}(l))$
    }
}

func partitionSentinel<I: Mutable & BidirectionalIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    var f = f, l = l
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    f = findIf(f: f, l: l, p: p)
    l = findBackwardIfNot(f: f, l: l, p: p)
    if f == l { return f }
    l = l.iteratorPredecessor!
    exchangeValues(x: f, y: l)
    f = f.iteratorSuccessor!
    return partitionBidirectionalUnguarded(f: f, l: l, p: p)
}


// Exercise 11.9: partition_single_cycle_sentinel


func partitionIndexed<I: Mutable & IndexedIterator>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    var i = N(0)
    var j = l - f
    while true {
        while true {
            if i == j { return f + i }
            let tmp = f + i
            if p(tmp.source!) { break }
            i = i.successor()
        }
        while true {
            j = j.predecessor()
            if i == j { return f + j + 1 }
            let tmp = f + j
            if !p(tmp.source!) { break }
        }
        exchangeValues(x: f + i, y: f + j)
        i = i.successor()
    }
}

func partitionStableWithBuffer<I: Mutable & ForwardIterator & Regular, B: Mutable & ForwardIterator & Regular>(f: I, l: I, fb: B, p: @escaping UnaryPredicate<I.Source>) -> I where I.Source == B.Sink {
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    // Precondition: $\property{mutable\_counted\_range}(f_b, l-f)$
    let x: Pair<I, B> = partitionCopy(fi: f, li: l, ff: f, ft: fb, p: p)
    _ = copy(fi: fb, li: x.m1, fo: x.m0)
    return x.m0
}

func partitionStableSingleton<I: Mutable & ForwardIterator>(f: I, p: UnaryPredicate<I.Source>) -> Pair<I, I> {
    var f = f
    // Precondition: $\property{readable\_bounded\_range}(f, \func{successor}(f))$
    let l = f.iteratorSuccessor!
    if !p(f.source!) { f = l }
    return Pair(m0: f, m1: l)
}

func combineRanges<I: Mutable & ForwardIterator>(x: Pair<I, I>, y: Pair<I, I>) -> Pair<I, I> {
    // Precondition: $\property{mutable\_bounded\_range}(x.m0, y.m0)$
    // Precondition: $x.m1 \in [x.m0, y.m0]$
    return Pair(m0: rotate(f: x.m0, m: x.m1, l: y.m0), m1: y.m1)
}

func partitionStableNNonempty<I: Mutable & ForwardIterator>(f: I, n: DistanceType, p: UnaryPredicate<I.Source>) -> Pair<I, I> {
    // Precondition: $\property{mutable\_counted\_range}(f, n) \wedge n > 0$
    if n.one() { return partitionStableSingleton(f: f, p: p) }
    let h = n.halfNonnegative()
    let x = partitionStableNNonempty(f: f, n: h, p: p)
    let y = partitionStableNNonempty(f: x.m1, n: n - h, p: p)
    return combineRanges(x: x, y: y)
}

func partitionStableN<I: Mutable & ForwardIterator>(f: I, n: DistanceType, p: UnaryPredicate<I.Source>) -> Pair<I, I> {
    // Precondition: $\property{mutable\_counted\_range}(f, n)$
    if n.zero() { return Pair(m0: f, m1: f) }
    return partitionStableNNonempty(f: f, n: n, p: p)
}


// Exercise 11.10: partition_stable_n_adaptive


func partitionStable<I: Mutable & ForwardIterator & Regular>(f: I, l: I, p: UnaryPredicate<I.Source>) -> I {
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    return partitionStableN(f: f, n: l - f, p: p).m0
}

func partitionTrivial<I: Mutable & ForwardIterator>(p: @escaping UnaryPredicate<I.Source>) -> UnaryFunction<I, Pair<I, I>> {
    return { i in
        return partitionStableSingleton(f: i, p: p)
    }
}

func addToCounter<I: Mutable & ForwardIterator>(f: I, l: I, op: BinaryOperation<I.Source>, x: I.Source, z: I.Source) -> I.Source {
    var f = f, x = x
    if x == z { return z }
    while f != l {
        if f.source! == z {
            f.sink = x
            return z
        }
        x = op(f.source!, x)
        f.sink = z
        f = f.iteratorSuccessor!
    }
    return x
}

// FIXME: Get this to work
//class CounterMachine<S: Regular>: UnaryProcedure {
//    var op: BinaryOperation<S>
//    var z: S
//    var f: Pointer<S>
//    var l: Pointer<S>
//
//    init(op: @escaping BinaryOperation<S>, z: S) {
//        self.op = op
//        self.z = z
//        l = pointer(count: 64, value: z)
//    }
//
//    func call(_ arg: S) {
//        // FIXME: Don't think this applies anymore in the Swift version
//        // Precondition: must not be called more than $2^{64}-1$ times
//        let tmp = addToCounter(f: f, l: l, op: op, x: arg, z: z)
//        if tmp != z {
//            l.sink = tmp
//            l = l.iteratorSuccessor!
//        }
//    }
//}

func transposeOperation<DomainOp: Regular>(op: @escaping BinaryOperation<DomainOp>) -> BinaryOperation<DomainOp> {
    return { x, y in
        return op(y, x)
    }
}

// FIXME: Get this to work
//func reduceBalanced<I: Iterator, DomainOp: Regular>(f: I, l: I, op: @escaping BinaryOperation<DomainOp>, fun: UnaryFunction<I, DomainOp>, z: DomainOp) -> DomainOp {
//    var f = f
//    // Precondition: $\property{bounded\_range}(f, l) \wedge l - f < 2^{64}$
//    // Precondition: $\property{partially\_associative}(op)$
//    // Precondition: $(\forall x \in [f, l))\,fun(x)$ is defined
//    let c = CounterMachine(op: op, z: z)
//    while f != l {
//        c.call(fun(f))
//        f = f.iteratorSuccessor!
//    }
//    let top = transposeOperation(op: op)
//    return reduceNonzeroes(f: c.f, l: c.l, op: top, z: z)
//}

// TODO: Port this
//template<typename I, typename Op>
//requires(ReadableIterator(I) && BinaryOperation(Op) &&
//ValueType(I) == Domain(Op))
//Domain(Op) reduce_balanced(I f, I l, Op op, const Domain(Op)& z)
//{
//    // Precondition: $\property{readable\_bounded\_range}(f, l) \wedge l-f < 2^{33}$
//    // Precondition: $\property{partially\_associative}(op)$
//    counter_machine<Op> c(op, z);
//    while (f != l) {
//        c(source(f));
//        f = successor(f);
//    }
//    transpose_operation<Op> t_op(op);
//    return reduce_nonzeroes(c.f, c.l, t_op, z);
//}
//
//template<typename I, typename P>
//requires(ForwardIterator(I) && UnaryPredicate(P) &&
//ValueType(I) == Domain(P))
//I partition_stable_iterative(I f, I l, P p)
//{
//    // Precondition: $\property{bounded\_range}(f, l) \wedge l - f < 2^{64}$
//    return reduce_balanced(
//        f, l,
//        combine_ranges<I>,
//        partition_trivial<I, P>(p),
//        pair<I, I>(f, f)
//        ).m0;
//}

func mergeNWithBuffer<I: Mutable & ForwardIterator & Regular, B: Mutable & ForwardIterator & Regular>(f0: I,n0: DistanceType, f1: I, n1: DistanceType, fb: B, r: @escaping Relation<I.Source>) -> I where I.Source == B.Source {
    // Precondition: $\func{mergeable}(f_0, n_0, f_1, n_1, r)$
    // Precondition: $\property{mutable\_counted\_range}(f_b, n_0)$
    _ = copyN(fi: f0, n: n0, fo: fb)
    return mergeCopyN(fi0: fb, ni0: n0, fi1: f1, ni1: n1, o: f0, r: r).m2
}

func sortNWithBuffer<I: Mutable & ForwardIterator, B: Mutable & ForwardIterator>(f: I, n: DistanceType, fb: B, r: @escaping Relation<I.Source>) -> I where I.Source == B.Source {
    // Property:
    // $\property{mutable\_counted\_range}(f, n) \wedge \property{weak\_ordering}(r)$
    // Precondition: $\property{mutable\_counted\_range}(f_b, \lceil n/2 \rceil)$
    let h = n.halfNonnegative()
    if h.zero() { return f + n }
    let m = sortNWithBuffer(f: f, n: h, fb: fb, r: r)
    _ = sortNWithBuffer(f: m, n: n - h, fb: fb, r: r)
    return mergeNWithBuffer(f0: f, n0: h, f1: m, n1: n - h, fb: fb, r: r)
}

func mergeNStep0<I: Mutable & ForwardIterator>(f0: I, n0: DistanceType, f1: I, n1: DistanceType, r: @escaping Relation<I.Source>, f00: inout I, n00: inout DistanceType, f01: inout I, n01: inout DistanceType, f10: inout I, n10: inout DistanceType, f11: inout I, n11: inout DistanceType) {
    // Precondition: $\property{mergeable}(f_0, n_0, f_1, n_1, r)$
    f00 = f0
    n00 = n0.halfNonnegative()
    f01 = f00 + n00
    f11 = lowerBoundN(f: f1, n: n1, a: f01.source!, r: r)
    f10 = rotate(f: f01, m: f1, l: f11)
    n01 = f10 - f01
    f10 = f10.iteratorSuccessor!
    let tmp = n0 - n00
    n10 = tmp.predecessor()
    n11 = n1 - n01
}

func mergeNStep1<I: Mutable & ForwardIterator>(f0: I, n0: DistanceType, f1: I, n1: DistanceType, r: @escaping Relation<I.Source>, f00: inout I, n00: inout DistanceType, f01: inout I, n01: inout DistanceType, f10: inout I, n10: inout DistanceType, f11: inout I, n11: inout DistanceType) {
    // Precondition: $\property{mergeable}(f_0, n_0, f_1, n_1, r)$
    f00 = f0
    n01 = n1.halfNonnegative()
    f11 = f1 + n01
    f01 = upperBoundN(f: f0, n: n0, a: f11.source!, r: r)
    f11 = f11.iteratorSuccessor!
    f10 = rotate(f: f01, m: f1, l: f11)
    n00 = f01 - f00
    n10 = n0 - n00
    let tmp = n1 - n01
    n11 = tmp.predecessor()
}

func mergeNAdaptive<I: Mutable & ForwardIterator & Regular, B: Mutable & ForwardIterator & Regular>(f0: I, n0: DistanceType, f1: I, n1: DistanceType, fb: B, nb: DistanceType, r: @escaping Relation<I.Source>) -> I where I.Source == B.Source {
    // Precondition: $\property{mergeable}(f_0, n_0, f_1, n_1, r)$
    // Precondition: $\property{mutable\_counted\_range}(f_b, n_b)$
    if n0.zero() || n1.zero() { return f0 + n0 + n1 }
    if n0 <= N(nb) {
        return mergeNWithBuffer(f0: f0, n0: n0, f1: f1, n1: n1, fb: fb, r: r)
    }
    // FIXME: Optional abuse to match original C++
    var f00: I?, f01: I?, f10: I?, f11: I?
    var n00: N?, n01: N?, n10: N?, n11: N?
    if n0 < n1 {
        mergeNStep0(f0: f0, n0: n0, f1: f1, n1: n1, r: r, f00: &f00!, n00: &n00!, f01: &f01!, n01: &n01!, f10: &f10!, n10: &n10!, f11: &f11!, n11: &n11!)
    } else {
        mergeNStep1(f0: f0, n0: n0, f1: f1, n1: n1, r: r, f00: &f00!, n00: &n00!, f01: &f01!, n01: &n01!, f10: &f10!, n10: &n10!, f11: &f11!, n11: &n11!)
    }
    _ = mergeNAdaptive(f0: f00!, n0: n00!, f1: f01!, n1: n01!, fb: fb, nb: nb, r: r)
    return mergeNAdaptive(f0: f10!, n0: n10!, f1: f11!, n1: n11!, fb: fb, nb: nb, r: r)
}

func sortNAdaptive<I: Mutable & ForwardIterator & Regular, B: Mutable & ForwardIterator & Regular>(f: I, n: DistanceType, fb: B, nb: DistanceType, r: @escaping Relation<I.Source>) -> I where I.Source == B.Source {
    // Precondition:
    // $\property{mutable\_counted\_range}(f, n) \wedge \property{weak\_ordering}(r)$
    // Precondition: $\property{mutable\_counted\_range}(f_b, n_b)$
    let h = n.halfNonnegative()
    if h.zero() { return f + n }
    let m = sortNAdaptive(f: f, n: h, fb: fb, nb: nb, r: r)
    _ = sortNAdaptive(f: m, n: n - h, fb: fb, nb: nb, r: r)
    return mergeNAdaptive(f0: f, n0: h, f1: m, n1: n - h, fb: fb, nb: nb, r: r)
}

// TODO: Port this
//func sortN<I: Mutable & ForwardIterator>(f: I, n: DistanceType, r: Relation<I.Source>) -> I where I.Source : Regular {
//    // Precondition:
//    // $\property{mutable\_counted\_range}(f, n) \wedge \property{weak\_ordering}(r)$
//    temporary_buffer<ValueType(I)> b(half_nonnegative(n));
//    return sort_n_adaptive(f, n, begin(b), size(b), r);
//}
