//
//  Chapter11.swift
//  ElementsOfProgramming
//

import EOP

// Exercise 11.1:

func partitionedAtPoint<I: Readable & Iterator>(
    f: I, m: I, l: I,
    p: UnaryPredicate<I.Source>
) -> Bool {
    // Precondition: readable_bounded_range(f, l) ∧ m ∈ [f, l]
    return none(f: f, l: m, p: p) && all(f: m, l: l, p: p)
}


// Exercise 11.2:

func potentialPartitionPoint<I: Readable & ForwardIterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
) -> I? {
    // Precondition: readable_bounded_range(f, l)
    return countIfNot(f: f, l: l, p: p, j: f)
}

func partitionSemistable<I: Mutable & ForwardIterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
) -> I? {
    // Precondition: mutable_bounded_range(f, l)
    guard var i = findIf(f: f, l: l, p: p) else { return nil }
    guard i != l else { return i }
    guard var j = i.iteratorSuccessor else { return nil }
    while true {
        guard let fin = findIfNot(f: j, l: l, p: p) else { return nil }
        j = fin
        guard j != l else { return i }
        do { try swapStep(f0: &i, f1: &j) } catch { return nil }
    }
}

// Exercise 11.3: rewrite partition_semistable, expanding find_if_not inline and
// eliminating extra test against l


// Exercise 11.4: substitute copy_step(j, i) for swap_step(i, j) in partition_semistable

func removeIf<I: Mutable & ForwardIterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
) -> I? {
    // Precondition: mutable_bounded_range(f, l)
    guard var i = findIf(f: f, l: l, p: p) else { return nil }
    guard i != l else { return i }
    guard var j = i.iteratorSuccessor else { return nil }
    while true {
        guard let fin = findIfNot(f: j, l: l, p: p) else { return nil }
        j = fin
        guard j != l else { return i }
        do { try copyStep(fi: &j, fo: &i) } catch { return nil }
    }
}


// Exercise 11.5:

//template<typename I, typename P>
//    requires(Mutable(I) && ForwardIterator(I) &&
//        UnaryPredicate(P) && ValueType(I) == Domain(P))
//void partition_semistable_omit_last_predicate_evaluation(I f, I l, P p)
//{
//    // Precondition: mutable_bounded_range(f, l)
//    ...
//}

func partitionBidirectional<I: Mutable & BidirectionalIterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
) -> I? {
    var f = f, l = l
    // Precondition: mutable_bounded_range(f, l)
    while true {
        guard let fi = findIf(f: f, l: l, p: p) else { return nil }
        f = fi
        guard let fbin = findBackwardIfNot(f: f, l: l, p: p) else { return nil }
        l = fbin
        guard f != l else { return f }
        do { try reverseSwapStep(l0: &l, f1: &f) } catch { return nil }
    }
}

// Exercise 11.6:

func partitionForward<I: Mutable & ForwardIterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
) -> I? {
    var f = f
    // Precondition: mutable_bounded_range(f, l)
    guard let i = countIfNot(f: f, l: l, p: p, j: f) else { return nil }
    var j = i
    while true {
        guard let fin = findIfNot(f: j, l: l, p: p) else { return nil }
        j = fin
        guard j != l else { return i }
        guard let fiu = findIfUnguarded(f: f, p: p) else { return nil }
        f = fiu
        do { try swapStep(f0: &f, f1: &j) } catch { return nil }
    }
}

// Exercise 11.7: partition_single_cycle

func partitonSingleCycle<I: Mutable & BidirectionalIterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
) -> I? {
    var f = f, l = l
    // Precondition: mutable_bounded_range(f, l)
    guard let fi = findIf(f: f, l: l, p: p) else { return nil }
    f = fi
    guard let fbin = findBackwardIfNot(f: f, l: l, p: p) else { return nil }
    l = fbin
    guard f != l else { return f }
    guard let ip = l.iteratorPredecessor else { return nil }
    l = ip
    let tmp = f.source
    while true {
        f.sink = l.source
        guard let s = f.iteratorSuccessor,
              let sfi = findIf(f: s, l: l, p: p) else { return nil }
        f = sfi
        guard f != l else {
            l.sink = tmp
            return f
        }
        l.sink = f.source
        guard let fbinu = findBackwardIfNotUnguarded(l: l, p: p) else { return nil }
        l = fbinu
    }
}


// Exercise 11.8: partition_sentinel

func partitionBidirectionalUnguarded<I: Mutable & BidirectionalIterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
) -> I? {
    var f = f, l = l
    // Precondition:
    // (￢all(f, l, p) ∧ some(f, l, p)) ∨
    // (￢p(source(f-1)) ∧ p(source(l)))
    while true {
        guard let fiu = findIfUnguarded(f: f, p: p),
              let fbinu = findBackwardIfNotUnguarded(l: l, p: p) else { return nil }
        f = fiu
        l = fbinu
        guard let ls = l.iteratorSuccessor else { return nil }
        guard ls != f else { return f }
        exchangeValues(x: f, y: l)
        guard let fs = f.iteratorSuccessor else { return nil }
        f = fs // ￢p(source(f-1)) ∧ p(source(l))
    }
}

func partitionSentinel<I: Mutable & BidirectionalIterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
) -> I? {
    var f = f, l = l
    // Precondition: mutable_bounded_range(f, l)
    guard let fi = findIf(f: f, l: l, p: p) else { return nil }
    f = fi
    guard let fbin = findBackwardIfNot(f: f, l: l, p: p) else { return nil }
    l = fbin
    guard f != l else { return f }
    guard let ip = l.iteratorPredecessor else { return nil }
    l = ip
    exchangeValues(x: f, y: l)
    guard let s = f.iteratorSuccessor else { return nil }
    f = s
    return partitionBidirectionalUnguarded(f: f, l: l, p: p)
}


// Exercise 11.9: partition_single_cycle_sentinel


func partitionIndexed<I: Mutable & IndexedIterator>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
) -> I? {
    // Precondition: mutable_bounded_range(f, l)
    var i = N(0), j = l.distance(from: f)
    while true {
        while true {
            guard i != j else {
                guard let s = f.successor(at: i) else { return nil }
                return s
            }
            guard let tmp = f.successor(at: i),
                  let src = tmp.source else { return nil }
            guard !p(src) else { break }
            i = i.successor()
        }
        while true {
            j = j.predecessor()
            guard i != j else {
                guard let s = f.successor(at: j)?.iteratorSuccessor else {
                    return nil
                }
                return s
            }
            guard let tmp = f.successor(at: j),
                  let src = tmp.source else { return nil }
            guard p(src) else { break }
        }
        guard let fi = f.successor(at: i),
              let fj = f.successor(at: j) else { return nil }
        exchangeValues(x: fi, y: fj)
        i = i.successor()
    }
}

func partitionStableWithBuffer<
    I: Mutable & ForwardIterator & Regular,
    B: Mutable & ForwardIterator & Regular
>(
    f: I, l: I,
    fb: B,
    p: @escaping UnaryPredicate<I.Source>
) -> I?
where I.Source == B.Sink {
    // Precondition: mutable_bounded_range(f, l)
    // Precondition: mutable_counted_range(f_b, l - f)
    guard let x: Pair<I, B> = partitionCopy(fi: f, li: l,
                                            ff: f, ft: fb,
                                            p: p) else { return nil }
    _ = copy(fi: fb, li: x.m1, fo: x.m0)
    return x.m0
}

func partitionStableSingleton<I: Mutable & ForwardIterator>(
    f: I,
    p: UnaryPredicate<I.Source>
) -> Pair<I, I>? {
    var f = f
    // Precondition: readable_bounded_range(f, successor(f))
    guard let l = f.iteratorSuccessor,
          let src = f.source else { return nil }
    if !p(src) { f = l }
    return Pair(m0: f, m1: l)
}

func combineRanges<I: Mutable & ForwardIterator>(
    x: Pair<I, I>, y: Pair<I, I>
) -> Pair<I, I>? {
    // Precondition: mutable_bounded_range(x.m0, y.m0)
    // Precondition: x.m1 ∈ [x.m0, y.m0]
    guard let r = rotate(f: x.m0, m: x.m1, l: y.m0) else { return nil }
    return Pair(m0: r,
                m1: y.m1)
}

func partitionStableNNonempty<I: Mutable & ForwardIterator>(
    f: I,
    n: DistanceType,
    p: UnaryPredicate<I.Source>
) -> Pair<I, I>? {
    // Precondition: mutable_counted_range(f, n) ∧ n > 0
    guard n != 1 else { return partitionStableSingleton(f: f, p: p) }
    let h = n.halfNonnegative()
    guard let x = partitionStableNNonempty(f: f, n: h, p: p),
          let y = partitionStableNNonempty(f: x.m1, n: n - h, p: p) else {
        return nil
    }
    return combineRanges(x: x, y: y)
}

func partitionStableN<I: Mutable & ForwardIterator>(
    f: I,
    n: DistanceType,
    p: UnaryPredicate<I.Source>
) -> Pair<I, I>? {
    // Precondition: mutable_counted_range(f, n)
    guard n != 0 else { return Pair(m0: f, m1: f) }
    return partitionStableNNonempty(f: f, n: n, p: p)
}


// Exercise 11.10: partition_stable_n_adaptive


func partitionStable<I: Mutable & IndexedIterator & Regular>(
    f: I, l: I,
    p: UnaryPredicate<I.Source>
) -> I? {
    // Precondition: mutable_bounded_range(f, l)
    return partitionStableN(f: f, n: l.distance(from: f), p: p)?.m0
}

func partitionTrivial<I: Mutable & ForwardIterator>(
    p: @escaping UnaryPredicate<I.Source>
) -> UnaryFunction<I, Pair<I, I>> {
    return { i in
        return partitionStableSingleton(f: i, p: p)!
    }
}

func addToCounter<I: Mutable & ForwardIterator>(
    f: I, l: I,
    op: BinaryOperation<I.Source>,
    x: I.Source, z: I.Source
) -> I.Source? {
    var f = f, x = x
    guard x != z else { return z }
    while f != l {
        guard f.source != z else {
            f.sink = x
            return z
        }
        guard let src = f.source else { return nil }
        x = op(src, x)
        f.sink = z
        guard let s = f.iteratorSuccessor else { return nil }
        f = s
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
//        // Precondition: must not be called more than 2^{64}-1 times
//        let tmp = addToCounter(f: f, l: l, op: op, x: arg, z: z)
//        if tmp != z {
//            l.sink = tmp
//            l = l.iteratorSuccessor
//        }
//    }
//}

func transposeOperation<DomainOp: Regular>(
    op: @escaping BinaryOperation<DomainOp>
) -> BinaryOperation<DomainOp> {
    return { x, y in
        return op(y, x)
    }
}

// FIXME: Get this to work
//func reduceBalanced<I: Iterator, DomainOp: Regular>(f: I, l: I, op: @escaping BinaryOperation<DomainOp>, fun: UnaryFunction<I, DomainOp>, z: DomainOp) -> DomainOp {
//    var f = f
//    // Precondition: bounded_range(f, l) ∧ l - f < 2^{64}
//    // Precondition: partially_associative(op)
//    // Precondition: (∀x ∈ [f, l)), fun(x) is defined
//    let c = CounterMachine(op: op, z: z)
//    while f != l {
//        c.call(fun(f))
//        f = f.iteratorSuccessor
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
//    // Precondition: readable_bounded_range(f, l) ∧ l-f < 2^{33}
//    // Precondition: partially_associative(op)
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
//    // Precondition: bounded_range(f, l) ∧ l - f < 2^{64}
//    return reduce_balanced(
//        f, l,
//        combine_ranges<I>,
//        partition_trivial<I, P>(p),
//        pair<I, I>(f, f)
//        ).m0;
//}

func mergeNWithBuffer<
    I: Mutable & ForwardIterator & Regular,
    B: Mutable & ForwardIterator & Regular
>(
    f0: I, n0: DistanceType,
    f1: I, n1: DistanceType,
    fb: B,
    r: @escaping Relation<I.Source>
) -> I?
where I.Source == B.Source {
    // Precondition: mergeable(f_0, n_0, f_1, n_1, r)
    // Precondition: mutable_counted_range(f_b, n_0)
    _ = copyN(fi: f0, n: n0, fo: fb)
    return mergeCopyN(fi_0: fb, ni_0: n0,
                      fi_1: f1, ni_1: n1,
                      o: f0,
                      r: r)?.m2
}

func sortNWithBuffer<
    I: Mutable & IndexedIterator,
    B: Mutable & ForwardIterator
>(
    f: I,
    n: DistanceType,
    fb: B,
    r: @escaping Relation<I.Source>
) -> I?
where I.Source == B.Source {
    // Property:
    // mutable_counted_range(f, n) ∧ weak_ordering(r)
    // Precondition: mutable_counted_range(f_b, ⎡n/2⎤)
    let h = n.halfNonnegative()
    guard h != 0 else {
        guard let s = f.successor(at: n) else { return nil }
        return s
    }
    guard let m = sortNWithBuffer(f: f, n: h,
                                  fb: fb,
                                  r: r) else { return nil }
    _ = sortNWithBuffer(f: m, n: n - h,
                        fb: fb,
                        r: r)
    return mergeNWithBuffer(f0: f, n0: h,
                            f1: m, n1: n - h,
                            fb: fb,
                            r: r)
}

func mergeNStep_0<I: Mutable & IndexedIterator>(
    f0: I, n0: DistanceType,
    f1: I, n1: DistanceType,
    r: @escaping Relation<I.Source>,
    f00: inout I, n00: inout DistanceType,
    f01: inout I, n01: inout DistanceType,
    f10: inout I, n10: inout DistanceType,
    f11: inout I, n11: inout DistanceType
) throws {
    // Precondition: mergeable(f_0, n_0, f_1, n_1, r)
    f00 = f0
    n00 = n0.halfNonnegative()
    guard let f00s = f00.successor(at: n00) else { throw EOPError.noSuccessor }
    f01 = f00s
    guard let f01src = f01.source else { throw EOPError.noSource }
    guard let lbn = lowerBoundN(f: f1,
                                n: n1,
                                a: f01src,
                                r: r) else { throw EOPError.noSuccessor }
    f11 = lbn
    guard let r = rotate(f: f01, m: f1, l: f11) else { throw EOPError.failure }
    f10 = r
    n01 = f10.distance(from: f01)
    guard let f10s = f10.iteratorSuccessor else { throw EOPError.noSuccessor }
    f10 = f10s
    let tmp = n0 - n00
    n10 = tmp.predecessor()
    n11 = n1 - n01
}

func mergeNStep_1<I: Mutable & IndexedIterator>(
    f0: I, n0: DistanceType,
    f1: I, n1: DistanceType,
    r: @escaping Relation<I.Source>,
    f00: inout I, n00: inout DistanceType,
    f01: inout I, n01: inout DistanceType,
    f10: inout I, n10: inout DistanceType,
    f11: inout I, n11: inout DistanceType
) throws {
    // Precondition: mergeable(f_0, n_0, f_1, n_1, r)
    f00 = f0
    n01 = n1.halfNonnegative()
    guard let f1s = f1.successor(at: n01) else { throw EOPError.noSuccessor }
    f11 = f1s
    guard let f11src = f11.source else { throw EOPError.noSource }
    guard let ubn = upperBoundN(f: f0,
                                n: n0,
                                a: f11src,
                                r: r) else { throw EOPError.noSuccessor }
    f01 = ubn
    guard let f11s = f11.iteratorSuccessor else { throw EOPError.noSuccessor }
    f11 = f11s
    guard let r = rotate(f: f01, m: f1, l: f11) else { throw EOPError.failure }
    f10 = r
    n00 = f01.distance(from: f00)
    n10 = n0 - n00
    let tmp = n1 - n01
    n11 = tmp.predecessor()
}

func mergeNAdaptive<
    I: Mutable & IndexedIterator & Regular,
    B: Mutable & ForwardIterator & Regular
>(
    f0: I, n0: DistanceType,
    f1: I, n1: DistanceType,
    fb: B, nb: DistanceType,
    r: @escaping Relation<I.Source>
) -> I?
where I.Source == B.Source {
    // Precondition: mergeable(f_0, n_0, f_1, n_1, r)
    // Precondition: mutable_counted_range(f_b, n_b)
    guard !(n0 == 0 || n1 == 0) else {
        guard let s = f0.successor(at: n0)?.successor(at: n1) else {
            return nil
        }
        return s
    }
    guard n0 > nb else {
        return mergeNWithBuffer(f0: f0, n0: n0,
                                f1: f1, n1: n1,
                                fb: fb,
                                r: r)
    }
    var f00 = f0, f01 = f0, f10 = f1, f11 = f1
    var n00 = n0, n01 = n0, n10 = n1, n11 = n1
    if n0 < n1 {
        do { try mergeNStep_0(f0: f0, n0: n0,
                              f1: f1, n1: n1,
                              r: r,
                              f00: &f00, n00: &n00,
                              f01: &f01, n01: &n01,
                              f10: &f10, n10: &n10,
                              f11: &f11, n11: &n11) } catch { return nil }
    } else {
        do { try mergeNStep_1(f0: f0, n0: n0,
                              f1: f1, n1: n1,
                              r: r,
                              f00: &f00, n00: &n00,
                              f01: &f01, n01: &n01,
                              f10: &f10, n10: &n10,
                              f11: &f11, n11: &n11) } catch { return nil }
    }
    _ = mergeNAdaptive(f0: f00, n0: n00,
                       f1: f01, n1: n01,
                       fb: fb, nb: nb,
                       r: r)
    return mergeNAdaptive(f0: f10, n0: n10,
                          f1: f11, n1: n11,
                          fb: fb, nb: nb,
                          r: r)
}

func sortNAdaptive<
    I: Mutable & IndexedIterator & Regular,
    B: Mutable & ForwardIterator & Regular
>(
    f: I, n: DistanceType,
    fb: B, nb: DistanceType,
    r: @escaping Relation<I.Source>
) -> I?
where I.Source == B.Source {
    // Precondition:
    // mutable_counted_range(f, n) ∧ weak_ordering(r)
    // Precondition: mutable_counted_range(f_b, n_b)
    let h = n.halfNonnegative()
    guard h != 0 else {
        guard let s = f.successor(at: n) else { return nil }
        return s
    }
    guard let m = sortNAdaptive(f: f, n: h,
                                fb: fb, nb: nb,
                                r: r) else { return nil }
    _ = sortNAdaptive(f: m, n: n - h,
                      fb: fb, nb: nb,
                      r: r)
    return mergeNAdaptive(f0: f, n0: h,
                          f1: m, n1: n - h,
                          fb: fb, nb: nb,
                          r: r)
}

// TODO: Port this
//func sortN<I: Mutable & ForwardIterator>(
//    f: I,
//    n: DistanceType,
//    r: Relation<I.Source>
//) -> I
//where I.Source : Regular {
//    // Precondition: mutable_counted_range(f, n) ∧ weak_ordering(r)
//    temporary_buffer<ValueType(I)> b(half_nonnegative(n));
//    return sort_n_adaptive(f, n, begin(b), size(b), r);
//}
