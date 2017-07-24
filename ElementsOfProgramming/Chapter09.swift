//
//  Chapter09.swift
//  ElementsOfProgramming
//

func copyStep<I: Readable & Iterator, O: Writable & Iterator>(fi: inout I, fo: inout O) where I.Source == O.Sink {
    // Precondition: $\func{source}(f_i)$ and $\func{sink}(f_o)$ are defined
    fo.sink = fi._source()!
    fi = fi._successor()!
    fo = fo._successor()!
}

func copy<I: Readable & Iterator, O: Writable & Iterator>(fi: I, li: I, fo: O) -> O where I.Source == O.Sink {
    var fi = fi, fo = fo
    // Precondition:
    // $\property{not\_overlapped\_forward}(f_i, l_i, f_o, f_o + (l_i - f_i))$
    while fi != li { copyStep(fi: &fi, fo: &fo) }
    return fo
}

func fillStep<I: Writable & Iterator>(fo: inout I, x: I.Sink) {
    fo.sink = x
    fo = fo._successor()!
}

func fill<I: Writable & Iterator>(f: I, l: I, x: I.Sink) -> I {
    var f = f
    while f != l { fillStep(fo: &f, x: x) }
    return f
}

// like APL $\iota$
func iota<O: Writable & Iterator>(n: Int, o: O) -> O where O.Sink == Int {
    // Precondition: $\property{writable\_counted\_range}(o, n) \wedge n \geq 0$
    return copy(fi: 0, li: n, fo: o)
}

// Useful for testing in conjunction with iota
func iotaEqual<I: Readable & Iterator>(f: I, l: I, n: Int = 0) -> Bool where I.Source == Int {
    var f = f, n = n
    // Precondition: $\property{readable\_bounded\_range}(f, l)$
    while f != l {
        if f._source()! != n { return false }
        n = n.successor()
        f = f._successor()!
    }
    return true
}

func copyBounded<I: Readable & Iterator, O: Writable & Iterator>(fi: I, li: I, fo: O, lo: O) -> Pair<I, O> where I.Source == O.Sink {
    var fi = fi, fo = fo
    // Precondition: $\property{not\_overlapped\_forward}(f_i, l_i, f_o, l_o)$
    while fi != li && fo != lo { copyStep(fi: &fi, fo: &fo) }
    return Pair(m0: fi, m1: fo)
}

func countDown(n: inout N) -> Bool {
    precondition(n >= 0)
    if n.zero() { return false }
    n = n.predecessor()
    return true
}

func copyN<I: Readable & Iterator, O: Writable & Iterator>(fi: I, n: N, fo: O) -> Pair<I, O> where I.Source == O.Sink {
    var fi = fi, n = n, fo = fo
    // Precondition: $\property{not\_overlapped\_forward}(f_i, f_i+n, f_o, f_o+n)$
    while countDown(n: &n) { copyStep(fi: &fi, fo: &fo) }
    return Pair(m0: fi, m1: fo)
}

func fillN<I: Writable & Iterator>(f: I, n: DistanceType, x: I.Sink) -> I {
    var f = f, n = n
    while countDown(n: &n) { fillStep(fo: &f, x: x) }
    return f
}

func copyBackwardStep<I: Readable & BidirectionalIterator, O: Writable & BidirectionalIterator>(li: inout I, lo: inout O) where I.Source == O.Sink{
    // Precondition: $\func{source}(\property{predecessor}(l_i))$ and
    //               $\func{sink}(\property{predecessor}(l_o))$
    //               are defined
    li = li._predecessor()!
    lo = lo._predecessor()!
    lo.sink = li._source()!
}

func copyBackward<I: Readable & BidirectionalIterator, O: Writable & BidirectionalIterator>(fi: I, li: I, lo: O) -> O where I.Source == O.Sink {
    var li = li, lo = lo
    // Precondition: $\property{not\_overlapped\_backward}(f_i, l_i, l_o-(l_i-f_i), l_o)$
    while fi != li { copyBackwardStep(li: &li, lo: &lo) }
    return lo
}

func copyBackwardN<I: Readable & BidirectionalIterator, O: Writable & BidirectionalIterator>(li: I, n: DistanceType, lo: O) -> Pair<I, O> where I.Source == O.Sink {
    var li = li, n = n, lo = lo
    while countDown(n: &n) { copyBackwardStep(li: &li, lo: &lo) }
    return Pair(m0: li, m1: lo)
}

func reverseCopyStep<I: Readable & BidirectionalIterator, O: Writable & Iterator>(li: inout I, fo: inout O) where I.Source == O.Sink {
    // Precondition: $\func{source}(\func{predecessor}(l_i))$ and
    //               $\func{sink}(f_o)$ are defined
    li = li._predecessor()!
    fo.sink = li._source()!
    fo = fo._successor()!
}

func reverseCopyBackwardStep<I: Readable & Iterator, O: Writable & BidirectionalIterator>(fi: inout I, lo: inout O) where I.Source == O.Sink {
    // Precondition: $\func{source}(f_i)$ and
    //               $\func{sink}(\property{predecessor}(l_o))$ are defined
    lo = lo._predecessor()!
    lo.sink = fi._source()!
    fi = fi._successor()!
}

func reverseCopy<I: Readable & BidirectionalIterator, O: Writable & Iterator>(fi: I, li: I, fo: O) -> O where I.Source == O.Sink {
    var li = li, fo = fo
    // Precondition: $\property{not\_overlapped}(f_i, l_i, f_o, f_o+(l_i-f_i))$
    while fi != li { reverseCopyStep(li: &li, fo: &fo) }
    return fo
}

func reverseCopyBackward<I: Readable & Iterator, O: Writable & BidirectionalIterator>(fi: I, li: I, lo: O) -> O where I.Source == O.Sink {
    var fi = fi, lo = lo
    // Precondition: $\property{not\_overlapped}(f_i, l_i, l_o-(l_i-f_i), l_o)$
    while fi != li { reverseCopyBackwardStep(fi: &fi, lo: &lo) }
    return lo
}

func copySelect<I: Readable & Iterator, O: Writable & Iterator>(fi: I, li: I, ft: O, p: UnaryPredicate<I>) -> O where I.Source == O.Sink {
    var fi = fi, ft = ft
    // Precondition: $\property{not\_overlapped\_forward}(f_i, l_i, f_t, f_t+n_t)$
    // where $n_t$ is an upper bound for the number of iterators satisfying $p$
    while fi != li {
        if p(fi) { copyStep(fi: &fi, fo: &ft) }
        else { fi = fi._successor()! }
    }
    return ft
}

func copyIf<I: Readable & Iterator, O: Writable & Iterator>(fi: I, li: I, ft: O, p: @escaping UnaryPredicate<I.Source>) -> O where I.Source == O.Sink {
    // Precondition: same as for $\func{copy\_select}$
    let ps: UnaryPredicate<I> = predicateSource(p: p)
    return copySelect(fi: fi, li: li, ft: ft, p: ps)
}

func splitCopy<I: Readable & Iterator, OF: Writable & Iterator, OT: Writable & Iterator>(fi: I, li: I, ff: OF, ft: OT, p: UnaryPredicate<I>) -> Pair<OF, OT> where I.Source == OF.Sink, I.Source == OT.Sink {
    var fi = fi, ff = ff, ft = ft
    // Precondition: see section 9.3 of Elements of Programming
    while fi != li {
        if p(fi) { copyStep(fi: &fi, fo: &ft) }
        else { copyStep(fi: &fi, fo: &ff) }
    }
    return Pair(m0: ff, m1: ft)
}

func splitCopyN<I: Readable & Iterator, OF: Writable & Iterator, OT: Writable & Iterator>(fi: I, ni: DistanceType, ff: OF, ft: OT, p: UnaryPredicate<I>) -> Pair<OF, OT> where I.Source == OF.Sink, I.Source == OT.Sink {
    var fi = fi, ni = ni, ft = ft
    // Precondition: see exercise 9.2 of Elements of Programming
    while countDown(n: &ni) {
        if p(fi) { copyStep(fi: &fi, fo: &ft) }
        else { copyStep(fi: &fi, fo: &ft) }
    }
    return Pair(m0: ff, m1: ft)
}

func partitionCopy<I: Readable & Iterator, OF: Writable & Iterator, OT: Writable & Iterator>(fi: I, li: I, ff: OF, ft: OT, p: @escaping UnaryPredicate<I.Source>) -> Pair<OF, OT> where I.Source == OF.Sink, I.Source == OT.Sink {
    // Precondition: same as $\func{split\_copy}$
    let ps: UnaryPredicate<I> = predicateSource(p: p)
    return splitCopy(fi: fi, li: li, ff: ff, ft: ft, p: ps)
}

func partitionCopyN<I: Readable & Iterator, OF: Writable & Iterator, OT: Writable & Iterator>(fi: I, n: DistanceType, ff: OF, ft: OT, p: @escaping UnaryPredicate<I.Source>) -> Pair<OF, OT> where I.Source == OF.Sink, I.Source == OT.Sink {
    // Precondition: see $\func{partition_copy}$
    let ps: UnaryPredicate<I> = predicateSource(p: p)
    return splitCopyN(fi: fi, ni: n, ff: ff, ft: ft, p: ps)
}

func combineCopy<I0: Readable & Iterator, I1: Readable & Iterator, O: Writable & Iterator>(fi0: I0, li0: I0, fi1: I1, li1: I1, fo: O, r: BinaryPredicate<I1, I0>) -> O where I0.Source == O.Sink, I1.Source == O.Sink {
    var fi0 = fi0, fi1 = fi1, fo = fo
    // Precondition: see section 9.3 of Elements of Programming
    while fi0 != li0 && fi1 != li1 {
        if r(fi1, fi0) { copyStep(fi: &fi1, fo: &fo) }
        else { copyStep(fi: &fi0, fo: &fo) }
    }
    return copy(fi: fi1, li: li1, fo: copy(fi: fi0, li: li0, fo: fo))
}

func combineCopyN<I0: Readable & Iterator, I1: Readable & Iterator, O: Writable & Iterator>(fi0: I0, ni0: DistanceType, fi1: I1, ni1: DistanceType, fo: O, r: BinaryPredicate<I1, I0>) -> Triple<I0, I1, O> where I0.Source == O.Sink, I1.Source == O.Sink {
    var fi0 = fi0, ni0 = ni0, fi1 = fi1, ni1 = ni1, fo = fo
    // Precondition: see $\func{combine_copy}$
    while true {
        if ni0.zero() {
            let p = copyN(fi: fi1, n: ni1, fo: fo)
            return Triple(m0: fi0, m1: p.m0, m2: p.m1)
        }
        if ni1.zero() {
            let p = copyN(fi: fi0, n: ni0, fo: fo)
            return Triple(m0: p.m0, m1: fi1, m2: p.m1)
        }
        if r(fi1, fi0) {
            copyStep(fi: &fi1, fo: &fo)
            ni1 = ni1.predecessor()
        } else {
            copyStep(fi: &fi0, fo: &fo)
            ni0 = ni0.predecessor()
        }
    }
}

func combineCopyBackward<I0: Readable & BidirectionalIterator, I1: Readable & BidirectionalIterator, O: Writable & BidirectionalIterator>(fi0: I0, li0: I0, fi1: I1, li1: I1, lo: O, r: BinaryPredicate<I1, I0>) -> O where I0.Source == O.Sink, I1.Source == O.Sink {
    var li0 = li0, li1 = li1, lo = lo
    // Precondition: see section 9.3 of Elements of Programming
    while fi0 != li0 && fi1 != li1 {
        if r(li1._predecessor()!, li0._predecessor()!) {
            copyBackwardStep(li: &li0, lo: &lo)
        } else {
            copyBackwardStep(li: &li1, lo: &lo)
        }
    }
    return copyBackward(fi: fi0, li: li0, lo: copyBackward(fi: fi1, li: li1, lo: lo))
}

func combineCopyBackwardN<I0: Readable & BidirectionalIterator, I1: Readable & BidirectionalIterator, O: Writable & BidirectionalIterator>(li0: I0, ni0: DistanceType, li1: I1, ni1: DistanceType, lo: O, r: BinaryPredicate<I1, I0>) -> Triple<I0, I1, O> where I0.Source == O.Sink, I1.Source == O.Sink {
    var li0 = li0, ni0 = ni0, li1 = li1, ni1 = ni1, lo = lo
    // Precondition: see $\func{combine\_copy\_backward}$
    while true {
        if ni0.zero() {
            let p = copyBackwardN(li: li1, n: ni1, lo: lo)
            return Triple(m0: li0, m1: p.m0, m2: p.m1)
        }
        if ni1.zero() {
            let p = copyBackwardN(li: li0, n: ni0, lo: lo)
            return Triple(m0: p.m0, m1: li1, m2: p.m1)
        }
        if r(li1._predecessor()!, li0._predecessor()!) {
            copyBackwardStep(li: &li0, lo: &lo)
            ni0 = ni0.predecessor()
        } else {
            copyBackwardStep(li: &li1, lo: &lo)
            ni1 = ni1.predecessor()
        }
    }
}

func mergeCopy<I0: Readable & Iterator, I1: Readable & Iterator, O: Writable & Iterator>(fi0: I0, li0: I0, fi1: I1, li1: I1, fo: O, r: @escaping Relation<I0.Source>) -> O where I0.Source == O.Sink, I1.Source == O.Sink, I0.Source : TotallyOrdered {
    // Precondition: in addition to that for $\func{combine\_copy}$:
    // \hspace*{1em} $\property{weak\_ordering}(r) \wedge {}$
    // \hspace*{1em} $\func{increasing\_range}(f_{i_0}, l_{i_0}, r) \wedge
    //                \property{increasing\_range}(f_{i_1}, l_{i_1}, r)$
    let rs: BinaryRelation<I1, I0> = relationSource(r: r)
    return combineCopy(fi0: fi0, li0: li0, fi1: fi1, li1: li1, fo: fo, r: rs)
}

func mergeCopyN<I0: Readable & Iterator, I1: Readable & Iterator, O: Writable & Iterator>(fi0: I0, ni0: DistanceType, fi1: I1, ni1: DistanceType, o: O, r: @escaping Relation<I0.Source>) -> Triple<I0, I1, O> where I0.Source == O.Sink, I1.Source == O.Sink, I0.Source : TotallyOrdered {
    // Precondition: see $\func{merge\_copy}$
    let rs: BinaryPredicate<I1, I0> = relationSource(r: r)
    return combineCopyN(fi0: fi0, ni0: ni0, fi1: fi1, ni1: ni1, fo: o, r: rs)
}

func mergeCopyBackward<I0: Readable & BidirectionalIterator, I1: Readable & BidirectionalIterator, O: Writable & BidirectionalIterator>(fi0: I0, li0: I0, fi1: I1, li1: I1, lo: O, r: @escaping Relation<I0.Source>) -> O where I0.Source == O.Sink, I1.Source == O.Sink, I0.Source : TotallyOrdered {
    // Precondition: in addition to that for $\func{combine\_copy\_backward}$:
    //               $\property{weak\_ordering}(r) \wedge {}$
    //               $\func{increasing\_range}(f_{i_0}, l_{i_0}, r) \wedge
    //                \property{increasing\_range}(f_{i_1}, l_{i_1}, r)$
    let rs: BinaryPredicate<I1, I0> = relationSource(r: r)
    return combineCopyBackward(fi0: fi0, li0: li0, fi1: fi1, li1: li1, lo: lo, r: rs)
}

func mergeCopyBackwardN<I0: Readable & BidirectionalIterator, I1: Readable & BidirectionalIterator, O: Writable & BidirectionalIterator>(li0: I0, ni0: DistanceType, li1: I1, ni1: DistanceType, lo: O, r: @escaping Relation<I0.Source>) -> Triple<I0, I1, O> where I0.Source == O.Sink, I1.Source == O.Sink, I0.Source : TotallyOrdered {
    // Precondition: see $\func{merge\_copy\_backward}$
    let rs: BinaryPredicate<I1, I0> = relationSource(r: r)
    return combineCopyBackwardN(li0: li0, ni0: ni0, li1: li1, ni1: ni1, lo: lo, r: rs)
}

func exchangeValues<I0: Mutable, I1: Mutable>(x: I0, y: I1) where I0.Source == I1.Source {
    var x = x, y = y
    // Precondition: $\func{deref}(x)$ and $\func{deref}(y)$ are defined
    let t = x._source()!
    x.sink = y._source()!
    y.sink = t
}

func swapStep<I0: Mutable & ForwardIterator, I1: Mutable & ForwardIterator>(f0: inout I0, f1: inout I1) where I0.Source == I1.Source {
    // Precondition: $\func{deref}(f_0)$ and $\func{deref}(f_1)$ are defined
    exchangeValues(x: f0, y: f1)
    f0 = f0._successor()!
    f1 = f1._successor()!
}

func swapRanges<I0: Mutable & ForwardIterator, I1: Mutable & ForwardIterator>(f0: I0, l0: I0, f1: I1) -> I1 where I0.Source == I1.Source {
    var f0 = f0, f1 = f1
    // Precondition: $\property{mutable\_bounded\_range}(f_0, l_0)$
    // Precondition: $\property{mutable\_counted\_range}(f_1, l_0-f_0)$
    while f0 != l0 { swapStep(f0: &f0, f1: &f1) }
    return f1
}


func swapRangesBounded<I0: Mutable & ForwardIterator, I1: Mutable & ForwardIterator>(f0: I0, l0: I0, f1: I1, l1: I1) -> Pair<I0, I1> where I0.Source == I1.Source {
    var f0 = f0, f1 = f1
    // Precondition: $\property{mutable\_bounded\_range}(f_0, l_0)$
    // Precondition: $\property{mutable\_bounded\_range}(f_1, l_1)$
    while f0 != l0 && f1 != l1 { swapStep(f0: &f0, f1: &f1) }
    return Pair(m0: f0, m1: f1)
}

func swapRangesN<I0: Mutable & ForwardIterator, I1: Mutable & ForwardIterator>(f0: I0, f1: I1, n: N) -> Pair<I0, I1> where I0.Source == I1.Source {
    var f0 = f0, f1 = f1, n = n
    // Precondition: $\property{mutable\_counted\_range}(f_0, n)$
    // Precondition: $\property{mutable\_counted\_range}(f_1, n)$
    while countDown(n: &n) { swapStep(f0: &f0, f1: &f1) }
    return Pair(m0: f0, m1: f1)
}

func reverseSwapStep<I0: Mutable & BidirectionalIterator, I1: Mutable & ForwardIterator>(l0: inout I0, f1: inout I1) where I0.Source == I1.Source {
    // Precondition: $\func{deref}(\func{predecessor}(l_0))$ and
    //               $\func{deref}(f_1)$ are defined
    l0 = l0._predecessor()!
    exchangeValues(x: l0, y: f1)
    f1 = f1._successor()!
}

func reverseSwapRanges<I0: Mutable & BidirectionalIterator, I1: Mutable & ForwardIterator>(f0: I0, l0: I0, f1: I1) -> I1 where I0.Source == I1.Source {
    var l0 = l0, f1 = f1
    // Precondition: $\property{mutable\_bounded\_range}(f_0, l_0)$
    // Precondition: $\property{mutable\_counted\_range}(f_1, l_0-f_0)$
    while f0 != l0 { reverseSwapStep(l0: &l0, f1: &f1) }
    return f1
}

func reverseSwapRangesBounded<I0: Mutable & BidirectionalIterator, I1: Mutable & ForwardIterator>(f0: I0, l0: I0, f1: I1, l1: I1) -> Pair<I0, I1> where I0.Source == I1.Source {
    var l0 = l0, f1 = f1
    // Precondition: $\property{mutable\_bounded\_range}(f_0, l_0)$
    // Precondition:  $\property{mutable\_bounded\_range}(f_1, l_1)$
    while f0 != l0 && f1 != l1 {
        reverseSwapStep(l0: &l0, f1: &f1)
    }
    return Pair(m0: l0, m1: f1)
}

func reverseSwapRangesN<I0: Mutable & BidirectionalIterator, I1: Mutable & ForwardIterator>(l0: I0, f1: I1, n: N) -> Pair<I0, I1> where I0.Source == I1.Source {
    var l0 = l0, f1 = f1, n = n
    // Precondition: $\property{mutable\_counted\_range}(l_0-n, n)$
    // Precondition: $\property{mutable\_counted\_range}(f_1, n)$
    while countDown(n: &n) { reverseSwapStep(l0: &l0, f1: &f1) }
    return Pair(m0: l0, m1: f1)
}
