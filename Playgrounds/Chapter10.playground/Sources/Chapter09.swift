//
//  Chapter09.swift
//  ElementsOfProgramming
//


func copyStep<
    I: Readable & Iterator,
    O: Writable & Iterator
>(
    fi: inout I,
    fo: inout O
) throws
where I.Source == O.Sink {
    // Precondition: source(f_i) and sink(f_o) are defined
    guard let fis = fi.iteratorSuccessor,
          let fos = fo.iteratorSuccessor else { throw EOPError.noSuccessor }
    fo.sink = fi.source
    fi = fis
    fo = fos
}

public func copy<
    I: Readable & Iterator,
    O: Writable & Iterator
>(
    fi: I, li: I,
    fo: O
) -> O?
where I.Source == O.Sink {
    var fi = fi, fo = fo
    // Precondition: not_overlapped_forward(f_i, l_i, f_o, f_o + (l_i - f_i))
    while fi != li {
        do { try copyStep(fi: &fi, fo: &fo) } catch { return nil }
    }
    return fo
}

func fillStep<I: Writable & Iterator>(fo: inout I, x: I.Sink) throws {
    guard let s = fo.iteratorSuccessor else { throw EOPError.noSuccessor }
    fo.sink = x
    fo = s
}

func fill<I: Writable & Iterator>(f: I, l: I, x: I.Sink) -> I? {
    var f = f
    while f != l {
        do { try fillStep(fo: &f, x: x) } catch { return nil }
    }
    return f
}

// like APL \iota
func iota<O: Writable & Iterator>(
    n: Int,
    o: O
) -> O?
where O.Sink == Int {
    // Precondition: writable_counted_range(o, n) ∧ n ≥ 0
    return copy(fi: 0, li: n, fo: o)
}

// Useful for testing in conjunction with iota
func iotaEqual<I: Readable & Iterator>(
    f: I, l: I,
    n: Int = 0
) -> Bool
where I.Source == Int {
    var f = f, n = n
    // Precondition: readable_bounded_range(f, l)
    while f != l {
        guard f.source == n,
              let s = f.iteratorSuccessor else { return false }
        n = n.successor()
        f = s
    }
    return true
}

func copyBounded<
    I: Readable & Iterator,
    O: Writable & Iterator
>(
    fi: I, li: I,
    fo: O, lo: O
) -> Pair<I, O>?
where I.Source == O.Sink {
    var fi = fi, fo = fo
    // Precondition: not_overlapped_forward(f_i, l_i, f_o, l_o)
    while fi != li && fo != lo {
        do { try copyStep(fi: &fi, fo: &fo) } catch { return nil }
    }
    return Pair(m0: fi, m1: fo)
}

public func countDown(n: inout N) -> Bool {
    assert(n >= 0)
    guard n != 0 else { return false }
    n = n.predecessor()
    return true
}

public func copyN<
    I: Readable & Iterator,
    O: Writable & Iterator
>(
    fi: I,
    n: N,
    fo: O
) -> Pair<I, O>?
where I.Source == O.Sink {
    var fi = fi, n = n, fo = fo
    // Precondition: not_overlapped_forward(f_i, f_i + n, f_o, f_o + n)
    while countDown(n: &n) {
        do { try copyStep(fi: &fi, fo: &fo) } catch { return nil }
    }
    return Pair(m0: fi, m1: fo)
}

func fillN<I: Writable & Iterator>(
    f: I,
    n: DistanceType,
    x: I.Sink
) -> I? {
    var f = f, n = n
    while countDown(n: &n) {
        do { try fillStep(fo: &f, x: x) } catch { return nil }
    }
    return f
}

func copyBackwardStep<
    I: Readable & BidirectionalIterator,
    O: Writable & BidirectionalIterator
>(
    li: inout I,
    lo: inout O
) throws
where I.Source == O.Sink {
    // Precondition: source(predecessor(l_i)) and sink(predecessor(l_o))
    //               are defined
    guard let lip = li.iteratorPredecessor,
          let lop = lo.iteratorPredecessor else { throw EOPError.noPredecessor }
    li = lip
    lo = lop
    lo.sink = li.source
}

public func copyBackward<
    I: Readable & BidirectionalIterator,
    O: Writable & BidirectionalIterator
>(
    fi: I, li: I,
    lo: O
) -> O?
where I.Source == O.Sink {
    var li = li, lo = lo
    // Precondition: not_overlapped_backward(f_i, l_i, l_o-(l_i - f_i), l_o)
    while fi != li {
        do { try copyBackwardStep(li: &li, lo: &lo) } catch { return nil }
    }
    return lo
}

func copyBackwardN<
    I: Readable & BidirectionalIterator,
    O: Writable & BidirectionalIterator
>(
    li: I,
    n: DistanceType,
    lo: O
) -> Pair<I, O>?
where I.Source == O.Sink {
    var li = li, n = n, lo = lo
    while countDown(n: &n) {
        do { try copyBackwardStep(li: &li, lo: &lo) } catch { return nil }
    }
    return Pair(m0: li, m1: lo)
}

func reverseCopyStep<
    I: Readable & BidirectionalIterator,
    O: Writable & Iterator
>(
    li: inout I,
    fo: inout O
) throws
where I.Source == O.Sink {
    // Precondition: source(predecessor(l_i)) and sink(f_o) are defined
    guard let lip = li.iteratorPredecessor else { throw EOPError.noPredecessor }
    guard let fos = fo.iteratorSuccessor else { throw EOPError.noSuccessor }
    li = lip
    fo.sink = li.source
    fo = fos
}

func reverseCopyBackwardStep<
    I: Readable & Iterator,
    O: Writable & BidirectionalIterator
>(
    fi: inout I,
    lo: inout O
) throws
where I.Source == O.Sink {
    // Precondition: source(f_i) and sink(predecessor(l_o)) are defined
    guard let lop = lo.iteratorPredecessor else { throw EOPError.noPredecessor }
    guard let fis = fi.iteratorSuccessor else { throw EOPError.noSuccessor }
    lo = lop
    lo.sink = fi.source
    fi = fis
}

public func reverseCopy<
    I: Readable & BidirectionalIterator,
    O: Writable & Iterator
>(
    fi: I, li: I,
    fo: O
) -> O?
where I.Source == O.Sink {
    var li = li, fo = fo
    // Precondition: not_overlapped(f_i, l_i, f_o, f_o + (l_i - f_i))
    while fi != li {
        do { try reverseCopyStep(li: &li, fo: &fo) } catch { return nil }
    }
    return fo
}

func reverseCopyBackward<
    I: Readable & Iterator,
    O: Writable & BidirectionalIterator
>(
    fi: I, li: I,
    lo: O
) -> O?
where I.Source == O.Sink {
    var fi = fi, lo = lo
    // Precondition: not_overlapped(f_i, l_i, l_o - (l_i - f_i), l_o)
    while fi != li {
        do { try reverseCopyBackwardStep(fi: &fi, lo: &lo) } catch { return nil}
    }
    return lo
}

func copySelect<
    I: Readable & Iterator,
    O: Writable & Iterator
>(
    fi: I, li: I,
    ft: O,
    p: UnaryPredicate<I>
) -> O?
where I.Source == O.Sink {
    var fi = fi, ft = ft
    // Precondition: not_overlapped_forward(f_i, l_i, f_t, f_t + n_t)
    // where n_t is an upper bound for the number of iterators satisfying p
    while fi != li {
        if p(fi) {
            do { try copyStep(fi: &fi, fo: &ft) } catch { return nil }
        } else {
            guard let s = fi.iteratorSuccessor else { return nil }
            fi = s
        }
    }
    return ft
}

func copyIf<
    I: Readable & Iterator,
    O: Writable & Iterator
>(
    fi: I, li: I,
    ft: O,
    p: @escaping UnaryPredicate<I.Source>
) -> O?
where I.Source == O.Sink {
    // Precondition: same as for copy_select
    let ps: UnaryPredicate<I> = predicateSource(p: p)
    return copySelect(fi: fi, li: li, ft: ft, p: ps)
}

func splitCopy<
    I: Readable & Iterator,
    OF: Writable & Iterator,
    OT: Writable & Iterator
>(
    fi: I, li: I,
    ff: OF,
    ft: OT,
    p: UnaryPredicate<I>
) -> Pair<OF, OT>?
where I.Source == OF.Sink, I.Source == OT.Sink {
    var fi = fi, ff = ff, ft = ft
    // Precondition: see section 9.3 of Elements of Programming
    while fi != li {
        if p(fi) {
            do { try copyStep(fi: &fi, fo: &ft) } catch { return nil }
        } else {
            do { try copyStep(fi: &fi, fo: &ff) } catch { return nil }
        }
    }
    return Pair(m0: ff, m1: ft)
}

func splitCopyN<
    I: Readable & Iterator,
    OF: Writable & Iterator,
    OT: Writable & Iterator
>(
    fi: I,
    ni: DistanceType,
    ff: OF,
    ft: OT,
    p: UnaryPredicate<I>
) -> Pair<OF, OT>?
where I.Source == OF.Sink, I.Source == OT.Sink {
    var fi = fi, ni = ni, ft = ft
    // Precondition: see exercise 9.2 of Elements of Programming
    while countDown(n: &ni) {
        if p(fi) {
            do { try copyStep(fi: &fi, fo: &ft) } catch { return nil }
        } else {
            do { try copyStep(fi: &fi, fo: &ft) } catch { return nil }
        }
    }
    return Pair(m0: ff, m1: ft)
}

func partitionCopy<
    I: Readable & Iterator,
    OF: Writable & Iterator,
    OT: Writable & Iterator
>(
    fi: I, li: I,
    ff: OF,
    ft: OT,
    p: @escaping UnaryPredicate<I.Source>
) -> Pair<OF, OT>?
where I.Source == OF.Sink, I.Source == OT.Sink {
    // Precondition: same as split_copy
    let ps: UnaryPredicate<I> = predicateSource(p: p)
    return splitCopy(fi: fi, li: li, ff: ff, ft: ft, p: ps)
}

func partitionCopyN<
    I: Readable & Iterator,
    OF: Writable & Iterator,
    OT: Writable & Iterator
>(
    fi: I,
    n: DistanceType,
    ff: OF,
    ft: OT,
    p: @escaping UnaryPredicate<I.Source>
) -> Pair<OF, OT>?
where I.Source == OF.Sink, I.Source == OT.Sink {
    // Precondition: see partition_copy
    let ps: UnaryPredicate<I> = predicateSource(p: p)
    return splitCopyN(fi: fi, ni: n, ff: ff, ft: ft, p: ps)
}

func combineCopy<
    I0: Readable & Iterator,
    I1: Readable & Iterator,
    O: Writable & Iterator
>(
    fi0: I0, li0: I0,
    fi1: I1, li1: I1,
    fo: O,
    r: BinaryRelation<I1, I0>
) -> O?
where I0.Source == O.Sink, I1.Source == O.Sink {
    var fi0 = fi0, fi1 = fi1
    var fo = fo
    // Precondition: see section 9.3 of Elements of Programming
    while fi0 != li0 && fi1 != li1 {
        if r(fi1, fi0) {
            do { try copyStep(fi: &fi1, fo: &fo) } catch { return nil }
        } else {
            do { try copyStep(fi: &fi0, fo: &fo) } catch { return nil }
        }
    }
    guard let c = copy(fi: fi0, li: li0, fo: fo) else { return nil }
    return copy(fi: fi1, li: li1, fo: c)
}

func combineCopyN<
    I0: Readable & Iterator,
    I1: Readable & Iterator,
    O: Writable & Iterator
>(
    fi_0: I0, ni_0: DistanceType,
    fi_1: I1, ni_1: DistanceType,
    fo: O,
    r: BinaryRelation<I1, I0>
) -> Triple<I0, I1, O>?
where I0.Source == O.Sink, I1.Source == O.Sink {
    var fi_0 = fi_0, ni_0 = ni_0
    var fi_1 = fi_1, ni_1 = ni_1
    var fo = fo
    // Precondition: see combine_copy
    while true {
        guard ni_0 != 0 else {
            guard let p = copyN(fi: fi_1, n: ni_1, fo: fo) else { return nil }
            return Triple(m0: fi_0, m1: p.m0, m2: p.m1)
        }
        guard ni_1 != 0 else {
            guard let p = copyN(fi: fi_0, n: ni_0, fo: fo) else { return nil }
            return Triple(m0: p.m0, m1: fi_1, m2: p.m1)
        }
        if r(fi_1, fi_0) {
            do { try copyStep(fi: &fi_1, fo: &fo) } catch { return nil }
            ni_1 = ni_1.predecessor()
        } else {
            do { try copyStep(fi: &fi_0, fo: &fo) } catch { return nil }
            ni_0 = ni_0.predecessor()
        }
    }
}

func combineCopyBackward<
    I0: Readable & BidirectionalIterator,
    I1: Readable & BidirectionalIterator,
    O: Writable & BidirectionalIterator
>(
    fi0: I0, li0: I0,
    fi1: I1, li1: I1,
    lo: O,
    r: BinaryRelation<I1, I0>
) -> O?
where I0.Source == O.Sink, I1.Source == O.Sink {
    var li0 = li0, li1 = li1, lo = lo
    // Precondition: see section 9.3 of Elements of Programming
    while fi0 != li0 && fi1 != li1 {
        guard let li1p = li1.iteratorPredecessor,
              let li0p = li0.iteratorPredecessor else {
            return nil
        }
        if r(li1p, li0p) {
            do { try copyBackwardStep(li: &li0, lo: &lo) } catch { return nil }
        } else {
            do { try copyBackwardStep(li: &li1, lo: &lo) } catch { return nil }
        }
    }
    guard let cb = copyBackward(fi: fi1, li: li1, lo: lo) else { return nil }
    return copyBackward(fi: fi0, li: li0, lo: cb)
}

func combineCopyBackwardN<
    I0: Readable & BidirectionalIterator,
    I1: Readable & BidirectionalIterator,
    O: Writable & BidirectionalIterator
>(
    li_0: I0, ni_0: DistanceType,
    li_1: I1, ni_1: DistanceType,
    lo: O,
    r: BinaryRelation<I1, I0>
) -> Triple<I0, I1, O>?
where I0.Source == O.Sink, I1.Source == O.Sink {
    var li_0 = li_0, ni_0 = ni_0
    var li_1 = li_1, ni_1 = ni_1
    var lo = lo
    // Precondition: see combine_copy_backward
    while true {
        guard ni_0 != 0 else {
            guard let p = copyBackwardN(li: li_1, n: ni_1, lo: lo) else {
                return nil
            }
            return Triple(m0: li_0, m1: p.m0, m2: p.m1)
        }
        guard ni_1 != 0 else {
            guard let p = copyBackwardN(li: li_0, n: ni_0, lo: lo) else {
                return nil
            }
            return Triple(m0: p.m0, m1: li_1, m2: p.m1)
        }
        guard let li_1p = li_1.iteratorPredecessor,
              let li_0p = li_0.iteratorPredecessor else {
            return nil
        }
        if r(li_1p, li_0p) {
            do { try copyBackwardStep(li: &li_0, lo: &lo) } catch { return nil }
            ni_0 = ni_0.predecessor()
        } else {
            do { try copyBackwardStep(li: &li_1, lo: &lo) } catch { return nil }
            ni_1 = ni_1.predecessor()
        }
    }
}

func mergeCopy<
    I0: Readable & Iterator,
    I1: Readable & Iterator,
    O: Writable & Iterator
>(
    fi0: I0, li0: I0,
    fi1: I1, li1: I1,
    fo: O,
    r: @escaping Relation<I0.Source>
) -> O?
where I0.Source == O.Sink, I1.Source == O.Sink {
    // Precondition: in addition to that for combine_copy:
    //               weak_ordering(r) ∧
    //               increasing_range(f_{i_0}, l_{i_0}, r) ∧
    //               increasing_range(f_{i_1}, l_{i_1}, r)
    let rs: BinaryRelation<I1, I0> = relationSource(r: r)
    return combineCopy(fi0: fi0, li0: li0,
                       fi1: fi1, li1: li1,
                       fo: fo,
                       r: rs)
}

func mergeCopyN<
    I0: Readable & Iterator,
    I1: Readable & Iterator,
    O: Writable & Iterator
>(
    fi_0: I0, ni_0: DistanceType,
    fi_1: I1, ni_1: DistanceType,
    o: O,
    r: @escaping Relation<I0.Source>
) -> Triple<I0, I1, O>?
where I0.Source == O.Sink, I1.Source == O.Sink {
    // Precondition: see merge_copy
    let rs: BinaryRelation<I1, I0> = relationSource(r: r)
    return combineCopyN(fi_0: fi_0, ni_0: ni_0,
                        fi_1: fi_1, ni_1: ni_1,
                        fo: o,
                        r: rs)
}

func mergeCopyBackward<
    I0: Readable & BidirectionalIterator,
    I1: Readable & BidirectionalIterator,
    O: Writable & BidirectionalIterator
>(
    fi0: I0, li0: I0,
    fi1: I1, li1: I1,
    lo: O,
    r: @escaping Relation<I0.Source>
) -> O?
where I0.Source == O.Sink, I1.Source == O.Sink {
    // Precondition: in addition to that for combine_copy_backward:
    //               weak_ordering(r) ∧
    //               increasing_range(f_{i_0}, l_{i_0}, r) ∧
    //               increasing_range(f_{i_1}, l_{i_1}, r)
    let rs: BinaryRelation<I1, I0> = relationSource(r: r)
    return combineCopyBackward(fi0: fi0, li0: li0,
                               fi1: fi1, li1: li1,
                               lo: lo,
                               r: rs)
}

func mergeCopyBackwardN<
    I0: Readable & BidirectionalIterator,
    I1: Readable & BidirectionalIterator,
    O: Writable & BidirectionalIterator
>(
    li_0: I0, ni_0: DistanceType,
    li_1: I1, ni_1: DistanceType,
    lo: O,
    r: @escaping Relation<I0.Source>
) -> Triple<I0, I1, O>?
where I0.Source == O.Sink, I1.Source == O.Sink {
    // Precondition: see merge_copy_backward
    let rs: BinaryRelation<I1, I0> = relationSource(r: r)
    return combineCopyBackwardN(li_0: li_0, ni_0: ni_0,
                                li_1: li_1, ni_1: ni_1,
                                lo: lo,
                                r: rs)
}

public func exchangeValues<
    I0: Mutable,
    I1: Mutable
>(
    x: I0,
    y: I1
) where I0.Source == I1.Source {
    var x = x, y = y
    // Precondition: deref(x) and deref(y) are defined
    let t = x.source
    x.sink = y.source
    y.sink = t
}

public func swapStep<
    I0: Mutable & ForwardIterator,
    I1: Mutable & ForwardIterator
>(
    f0: inout I0,
    f1: inout I1
) throws
where I0.Source == I1.Source {
    // Precondition: deref(f_0) and deref(f_1) are defined
    exchangeValues(x: f0, y: f1)
    guard let f0s = f0.iteratorSuccessor,
          let f1s = f1.iteratorSuccessor else { throw EOPError.noSuccessor }
    f0 = f0s
    f1 = f1s
}

public func swapRanges<
    I0: Mutable & ForwardIterator,
    I1: Mutable & ForwardIterator
>(
    f0: I0, l0: I0,
    f1: I1
) -> I1?
where I0.Source == I1.Source {
    var f0 = f0, f1 = f1
    // Precondition: mutable_bounded_range(f_0, l_0)
    // Precondition: mutable_counted_range(f_1, l_0 - f_0)
    while f0 != l0 {
        do { try swapStep(f0: &f0, f1: &f1) } catch { return nil }
    }
    return f1
}


public func swapRangesBounded<
    I0: Mutable & ForwardIterator,
    I1: Mutable & ForwardIterator
>(
    f0: I0, l0: I0,
    f1: I1, l1: I1
) -> Pair<I0, I1>?
where I0.Source == I1.Source {
    var f0 = f0, f1 = f1
    // Precondition: mutable_bounded_range(f_0, l_0)
    // Precondition: mutable_bounded_range(f_1, l_1)
    while f0 != l0 && f1 != l1 {
        do { try swapStep(f0: &f0, f1: &f1) } catch { return nil }
    }
    return Pair(m0: f0, m1: f1)
}

public func swapRangesN<
    I0: Mutable & ForwardIterator,
    I1: Mutable & ForwardIterator
>(
    f0: I0,
    f1: I1,
    n: N
) -> Pair<I0, I1>?
where I0.Source == I1.Source {
    var f0 = f0, f1 = f1, n = n
    // Precondition: mutable_counted_range(f_0, n)
    // Precondition: mutable_counted_range(f_1, n)
    while countDown(n: &n) {
        do { try swapStep(f0: &f0, f1: &f1) } catch { return nil }
    }
    return Pair(m0: f0, m1: f1)
}

func reverseSwapStep<
    I0: Mutable & BidirectionalIterator,
    I1: Mutable & ForwardIterator
>(
    l0: inout I0,
    f1: inout I1
) throws
where I0.Source == I1.Source {
    // Precondition: deref(predecessor(l_0)) and deref(f_1) are defined
    guard let p = l0.iteratorPredecessor else { throw EOPError.noPredecessor }
    l0 = p
    exchangeValues(x: l0, y: f1)
    guard let s = f1.iteratorSuccessor else { throw EOPError.noSuccessor }
    f1 = s
}

func reverseSwapRanges<
    I0: Mutable & BidirectionalIterator,
    I1: Mutable & ForwardIterator
>(
    f0: I0, l0: I0,
    f1: I1
) -> I1?
where I0.Source == I1.Source {
    var l0 = l0, f1 = f1
    // Precondition: mutable_bounded_range(f_0, l_0)
    // Precondition: mutable_counted_range(f_1, l_0 - f_0)
    while f0 != l0 {
        do { try reverseSwapStep(l0: &l0, f1: &f1) } catch { return nil }
    }
    return f1
}

public func reverseSwapRangesBounded<
    I0: Mutable & BidirectionalIterator,
    I1: Mutable & ForwardIterator
>(
    f0: I0, l0: I0,
    f1: I1, l1: I1
) -> Pair<I0, I1>?
where I0.Source == I1.Source {
    var l0 = l0, f1 = f1
    // Precondition: mutable_bounded_range(f_0, l_0)
    // Precondition: mutable_bounded_range(f_1, l_1)
    while f0 != l0 && f1 != l1 {
        do { try reverseSwapStep(l0: &l0, f1: &f1) } catch { return nil }
    }
    return Pair(m0: l0, m1: f1)
}

public func reverseSwapRangesN<
    I0: Mutable & BidirectionalIterator,
    I1: Mutable & ForwardIterator
>(
    l0: I0,
    f1: I1,
    n: N
) -> Pair<I0, I1>?
where I0.Source == I1.Source {
    var l0 = l0, f1 = f1, n = n
    // Precondition: mutable_counted_range(l_0 - n, n)
    // Precondition: mutable_counted_range(f_1, n)
    while countDown(n: &n) {
        do { try reverseSwapStep(l0: &l0, f1: &f1) } catch { return nil }
    }
    return Pair(m0: l0, m1: f1)
}
