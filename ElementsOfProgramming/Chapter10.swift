//
//  Chapter10.swift
//  ElementsOfProgramming
//

import EOP

func cycleTo<I: Mutable & Distance>(i: I, f: Transformation<I>) {
    // Precondition: The orbit of i under f is circular
    // Precondition: (∀n ∈ ℕ), deref(f^n(i)) is defined
    var k = f(i)
    while k != i {
        exchangeValues(x: i, y: k)
        k = f(k)
    }
}


// Exercise 10.3: cycle_to variant doing 2n-1 assignments


func cycleFrom<I: Mutable & Distance>(i: I, f: Transformation<I>) {
    // Precondition: The orbit of i under f is circular
    // Precondition: (∀n ∈ ℕ), deref(f^n(i)) is defined
    let tmp = i.source!
    var j = i
    var k = f(i)
    while k != i {
        j.sink = k.source!
        j = k
        k = f(k)
    }
    j.sink = tmp
}


// Exercise 10.4: arbitrary rearrangement using array of n boolean values
// Exercise 10.5: arbitrary rearrangement using total ordering on iterators


public func reverseNIndexed<I: Mutable & IndexedIterator>(
    f: I,
    n: DistanceType
) throws {
    var n = n
    // Precondition: mutable_counted_range(f, n)
    var i = DistanceType(0)
    n = n.predecessor()
    while i < n {
        // n = (n_original - 1) - i
        guard let fi = f.successor(at: i),
              let fn = f.successor(at: n) else {
            throw EOPError.noSuccessor
        }
        exchangeValues(x: fi, y: fn)
        i = i.successor()
        n = n.predecessor()
    }
}

func reverseBidirectional<I: Mutable & BidirectionalIterator>(
    f: I,
    l: I
) throws {
    var f = f, l = l
    // Precondition: mutable_bounded_range(f, l)
    while true {
        guard f != l else { return }
        guard let p = l.iteratorPredecessor else { throw EOPError.noPredecessor }
        l = p
        guard f != l else { return }
        exchangeValues(x: f, y: l)
        guard let s = f.iteratorSuccessor else { throw EOPError.noSuccessor }
        f = s
    }
}

func reverseNBidirectional<I: Mutable & BidirectionalIterator>(
    f: I, l: I,
    n: DistanceType
) throws {
    // Precondition: mutable_bounded_range(f, l) ∧ 0 ≤ n ≤ l - f
    let n = n.halfNonnegative()
    _ = reverseSwapRangesN(l0: l, f1: f, n: n)
}

func reverseNWithBuffer<
    I: Mutable & ForwardIterator,
    B: Mutable & BidirectionalIterator
>(
    fi: I,
    n: DistanceType,
    fb: B
) -> I?
where I.Source == B.Source {
    // Precondition: mutable_counted_range(f_i, n)
    // Precondition: mutable_counted_range(f_b, n)
    guard let p = copyN(fi: fi, n: n, fo: fb) else { return nil }
    return reverseCopy(fi: fb, li: p.m1, fo: fi)
}

func reverseNForward<I: Mutable & ForwardIterator>(
    f: I,
    n: DistanceType
) -> I? {
    // Precondition: mutable_counted_range(f, n)
    guard n >= N(2) else {
        guard let s = f.successor(at: n) else { return nil }
        return s
    }
    let h = n.halfNonnegative()
    let nmod2 = n - h.twice()
    guard let m = reverseNForward(f: f, n: h)?.successor(at: nmod2) else {
        return nil
    }
    let l = reverseNForward(f: m, n: h)
    _ = swapRangesN(f0: f, f1: m, n: h)
    return l
}

func reverseNAdaptive<
    I: Mutable & ForwardIterator,
    B: Mutable & BidirectionalIterator
>(
    fi: I,
    ni: DistanceType,
    fb: B,
    nb: DistanceType
) -> I?
where I.Source == B.Source {
    // Precondition: mutable_counted_range(f_i, n_i)
    // Precondition: mutable_counted_range(f_b, n_b)
    guard ni >= N(2) else {
        guard let s = fi.successor(at: ni) else { return nil }
        return s
    }
    guard ni > nb else { return reverseNWithBuffer(fi: fi, n: ni, fb: fb) }
    let hi = ni.halfNonnegative()
    let nmod2 = ni - hi.twice()
    guard let mi = reverseNAdaptive(fi: fi, ni: hi,
                                    fb: fb, nb: nb)?.successor(at: nmod2) else {
        return nil
    }
    let li = reverseNAdaptive(fi: mi, ni: hi,
                              fb: fb, nb: nb)
    guard let _ = swapRangesN(f0: fi, f1: mi, n: hi) else { return nil }
    return li
}

func kRotateFromPermutationRandomAccess<I: RandomAccessIterator>(
    f: I, m: I, l: I
) -> UnaryOperation<I>? {
    // Precondition: bounded_range(f, l) ∧ m ∈ [f, l)
    let k = l - m
    let n_minus_k = m - f
    guard let m_prime = f.successor(at: l.distance(from: m)) else {
        return nil
    }
    return { x in
        // Precondition: x ∈ [f, l)
        guard x >= m_prime else { return x.successor(at: N(n_minus_k))! }
        return x.successor(at: N(k))!
    }
}

func kRotateFromPermutationIndexed<I: IndexedIterator>(
    f: I, m: I, l: I
) -> UnaryOperation<I> {
    // Precondition: bounded_range(f, l) ∧ m ∈ [f, l)
    let k = l.distance(from: m)
    let n_minus_k = m.distance(from: f)
    return { x in
        // Precondition: x ∈ [f, l)
        let i = x.distance(from: f)
        guard i >= k else { return x.successor(at: n_minus_k)! }
        return f.successor(at: i - k)!
    }
}

func rotateCycles<I: Mutable & IndexedIterator & Distance>(
    f: I, m: I, l: I,
    from: Transformation<I>
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ m ∈ [f, l]
    // Precondition: from is a from-permutation on [f, l)
    var d = gcdEuclideanSemiring(a: m.distance(from: f), b: l.distance(from: m))
    while countDown(n: &d) {
        guard let s = f.successor(at: d) else { return nil }
        cycleFrom(i: s, f: from)
    }
    return f.successor(at: l.distance(from: m))!
}

func rotateIndexedNontrivial<I: Mutable & IndexedIterator & Distance>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    let p = kRotateFromPermutationIndexed(f: f, m: m, l: l)
    return rotateCycles(f: f, m: m, l: l, from: p)
}

func rotateRandomAccessNontrivial<
    I: Mutable & RandomAccessIterator & Distance
>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    guard let p = kRotateFromPermutationRandomAccess(f: f, m: m, l: l) else {
        return nil
    }
    return rotateCycles(f: f, m: m, l: l, from: p)
}

func rotateBidirectionalNonTrivial<
    I: Mutable & BidirectionalIterator & Regular
>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    do {
        try reverseBidirectional(f: f, l: m)
        try reverseBidirectional(f: m, l: l)
    } catch { return nil }
    guard let p = reverseSwapRangesBounded(f0: m, l0: l, f1: f, l1: m) else {
        return nil
    }
    do { try reverseBidirectional(f: p.m1, l: p.m0) } catch { return nil }
    guard m == p.m0 else { return p.m0 }
    return p.m1
}

func rotateForwardAnnotated<I: Mutable & ForwardIterator & Regular>(
    f: I, m: I, l: I
) throws {
    var f = f, m = m
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    var a = m.distance(from: f)
    var b = l.distance(from: m)
    while true {
        guard let p = swapRangesBounded(f0: f, l0: m, f1: m, l1: l) else {
            throw EOPError.failure
        }
        guard !(p.m0 == m && p.m1 == l) else {
            assert(a == b )
            return
        }
        f = p.m0
        if f == m {
            assert(b > a)
            m = p.m1
            b = b - a
        } else {
            assert(a > b)
            a = a - b
        }
    }
}

func rotateForwardStep<I: Mutable & ForwardIterator>(
    f: inout I, m: inout I,
    l: I
) throws {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    var c = m
    repeat {
        try swapStep(f0: &f, f1: &c)
        if f == m { m = c }
    } while c != l
}

func rotateForwardNontrivial<I: Mutable & ForwardIterator>(
    f: I, m: I, l: I
) -> I? {
    var f = f, m = m
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    do { try rotateForwardStep(f: &f, m: &m, l: l) } catch { return nil }
    let m_prime = f
    while m != l {
        do { try rotateForwardStep(f: &f, m: &m, l: l) } catch { return nil }
    }
    return m_prime
}

func rotatePartialNontrivial<I: Mutable & ForwardIterator>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    return swapRanges(f0: m, l0: l, f1: f)
}

// swap_ranges_backward
// rotate_partial_backward_nontrivial

func rotateWithBufferNontrivial<
    I: Mutable & ForwardIterator,
    B: Mutable & ForwardIterator
>(
    f: I, m: I, l: I,
    fb: B
) -> I?
where I.Source == B.Source {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    // Precondition: mutable_counted_range(f_b, l-f)
    guard let lb = copy(fi: f, li: m, fo: fb),
          let m_prime = copy(fi: m, li: l, fo: f) else { return nil }
    _ = copy(fi: fb, li: lb, fo: m_prime)
    return m_prime
}

func rotateWithBufferBackwardNontrivial<
    I: Mutable & BidirectionalIterator,
    B: Mutable & ForwardIterator
>(
    f: I, m: I, l: I,
    fb: B
) -> I?
where I.Source == B.Source {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    // Precondition: mutable_counted_range(f_b, l-f)
    guard let lb = copy(fi: m, li: l, fo: fb) else { return nil }
    _ = copyBackward(fi: f, li: m, lo: l)
    return copy(fi: fb, li: lb, fo: f)
}


// Section 10.5. Algorithm selection


func reverseIndexed<I: Mutable & IndexedIterator>(f: I, l: I) throws {
    // Precondition: mutable_bounded_range(f, l)
    try reverseNIndexed(f: f, n: l.distance(from: f))
}


// temporary_buffer type

//func constructAll<I: Writable & ForwardIterator>(f: I, l: I) {
//    // Precondition:
//    // (∀i ∈ [f, l)) sink(i) refers to raw memory, not an object
//    // Postcondition:
//    // (∀i ∈ [f, l)) sink(i) is in a default-constructed state
//    // We assume if an iterator is writeable, its value can be constructed
//
//}
//
//func constructAll<I: Writable & ForwardIterator>(f: I, l: I, b: Bool) {
//    if b {
//        // Precondition:
//        // (∀i ∈ [f, l)) sink(i) refers to raw memory, not an object
//        // Postcondition:
//        // (∀i ∈ [f, l)) sink(i) is in a partially-formed state
//        // We assume if an iterator is writeable, its value can be constructed
//        while f != l {
//            construct(f.sink)
//            f = f.iteratorSuccessor
//        }
//    } else {
//        // Precondition:
//        // (∀i ∈ [f, l)) sink(i) is in a partially-formed state
//        // Postcondition:
//        // (∀i ∈ [f, l)) sink(i) is in a partially-formed state
//    }
//}
//
//template<typename I>
//requires(Writeable(I) && ForwardIterator(I))
//void destroy_all(I f, I l)
//{
//    // Precondition:
//    // (∀i ∈ [f, l)) sink(i) is in a partially-formed state
//    // Postcondition:
//    // (∀i ∈ [f, l)) sink(i) refers to raw memory, not an object
//    // We assume if an iterator is writeable, its value can be destroyed
//    destroy_all(f, l, NeedsDestruction(ValueType(I))());
//}
//
//template<typename I>
//requires(Writeable(I) && ForwardIterator(I))
//void destroy_all(I f, I l, true_type)
//{
//    // Precondition: (∀i ∈ [f, l)) sink(i) is in a partially-formed state
//    // Postcondition: (∀i ∈ [f, l)) sink(i) refers to raw memory, not an object
//    // We assume if an iterator is writeable, its value can be destroyed
//    while (f != l) {
//        destroy(sink(f));
//        f = successor(f);
//    }
//}
//
//template<typename I>
//requires(Writeable(I) && ForwardIterator(I) &&
//    NeedsDestruction(ValueType(I)) == false_type)
//void destroy_all(I /*f*/, I /*l*/, false_type)
//{
//    // Precondition:
//    // (∀i ∈ [f, l)) sink(i) is in a partially-formed state
//    // Postcondition:
//    // (∀i ∈ [f, l)) sink(i) is in a partially-formed state
//}
//
//// NeedsConstruction and NeedsDestruction should be overloaded for every POD type
//
//template<typename T>
//requires(Regular(T))
//struct temporary_buffer
//{
//    typedef pointer(T) P;
//    typedef DistanceType(P) N;
//    P p;
//    N n;
//    temporary_buffer(N n_) : n(n_)
//    {
//    while (true) {
//    p = P(malloc(n * sizeof(T)));
//    if (p != P(0)) {
//    construct_all(p, p + n);
//    return;
//    }
//    n = half_nonnegative(n);
//    }
//    }
//    ~temporary_buffer()
//    {
//    destroy_all(p, p + n);
//    free(p);
//    }
//    private:
//    // We use private only to signal lack of regularity of a type
//    temporary_buffer(const temporary_buffer&) { }
//    void operator=(const temporary_buffer&) { }
//};
//
//template<typename T>
//requires(Regular(T))
//DistanceType(pointer(T)) size(const temporary_buffer<T>& b)
//{
//    return b.n;
//}
//
//template<typename T>
//requires(Regular(T))
//pointer(T) begin(temporary_buffer<T>& b)
//{
//    return b.p;
//}
//
//func reverseNWithTemporaryBuffer<I: Mutable & ForwardIterator>(f: I, n: DistanceType) {
//    // Precondition: mutable_counted_range(f, n)
//    temporary_buffer<ValueType(I)> b(n);
//    reverseNAdaptive(fi: f, ni: n, fb: b.begin(), nb: b.size())
//}

func rotate<I: Mutable & ForwardIterator>(f: I, m: I, l: I) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ m ∈ [f, l]
    guard m != f else { return l }
    guard m != l else { return f }
    return rotateNontrivialForward(f: f, m: m, l: l)
}

func rotate<I: Mutable & BidirectionalIterator & Regular>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ m ∈ [f, l]
    guard m != f else { return l }
    guard m != l else { return f }
    return rotateNontrivialBidirectional(f: f, m: m, l: l)
}

func rotate<I: Mutable & IndexedIterator & Distance>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ m ∈ [f, l]
    guard m != f else { return l }
    guard m != l else { return f }
    return rotateNontrivialIndexed(f: f, m: m, l: l)
}

func rotate<I: Mutable & RandomAccessIterator & Distance>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ m ∈ [f, l]
    guard m != f else { return l }
    guard m != l else { return f }
    return rotateNontrivialRandomAccess(f: f, m: m, l: l)
}

func rotateNontrivialForward<I: Mutable & ForwardIterator>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    return rotateForwardNontrivial(f: f, m: m, l: l)
}

func rotateNontrivialBidirectional<
    I: Mutable & BidirectionalIterator & Regular
>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    return rotateBidirectionalNonTrivial(f: f, m: m, l: l)
}

func rotateNontrivialIndexed<I: Mutable & IndexedIterator & Distance>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    return rotateIndexedNontrivial(f: f, m: m, l: l)
}

func rotateNontrivialRandomAccess<
    I: Mutable & RandomAccessIterator & Distance
>(
    f: I, m: I, l: I
) -> I? {
    // Precondition: mutable_bounded_range(f, l) ∧ f ≺ m ≺ l
    return rotateRandomAccessNontrivial(f: f, m: m, l: l)
}
