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

func copy<I: Readable & Iterator, O: Writable & Iterator>(fi: I, n: N, fo: O) -> Pair<I, O> where I.Source == O.Sink {
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
