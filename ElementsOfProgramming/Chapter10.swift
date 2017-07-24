//
//  Chapter10.swift
//  ElementsOfProgramming
//

func cycleTo<I: Mutable & Distance>(i: I, f: Transformation<I>) {
    // Precondition: The orbit of $i$ under $f$ is circular
    // Precondition: $(\forall n \in \mathbb{N})\,\func{deref}(f^n(i))$ is defined
    var k = f(i)
    while k != i {
        exchangeValues(x: i, y: k)
        k = f(k)
    }
}


// Exercise 10.3: cycle_to variant doing 2n-1 assignments


func cycleFrom<I: Mutable & Distance>(i: I, f: Transformation<I>) {
    // Precondition: The orbit of $i$ under $f$ is circular
    // Precondition: $(\forall n \in \mathbb{N})\,\func{deref}(f^n(i))$ is defined
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


func reverseNIndexed<I: Mutable & IndexedIterator>(f: I, n: DistanceType) {
    var n = n
    // Precondition: $\property{mutable\_counted\_range}(f, n)$
    var i = DistanceType(0)
    n = n.predecessor()
    while i < n {
        // $n = (n_\text{original} - 1) - i$
        exchangeValues(x: f + i, y: f + n)
        i = i.successor()
        n = n.predecessor()
    }
}

func reverseBidirectional<I: Mutable & BidirectionalIterator>(f: I, l: I) {
    var f = f, l = l
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    while true {
        if f == l { return }
        l = l.iteratorPredecessor!
        if f == l { return }
        exchangeValues(x: f, y: l)
        f = f.iteratorSuccessor!
    }
}

func reverseNBidirectional<I: Mutable & BidirectionalIterator>(f: I, l: I, n: DistanceType) where I : TotallyOrdered {
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge 0 \leq n \leq l - f$
    let n = n.halfNonnegative()
    _ = reverseSwapRangesN(l0: l, f1: f, n: n)
}

func reverseNWithBuffer<I: Mutable & ForwardIterator, B: Mutable & BidirectionalIterator>(fi: I, n: DistanceType, fb: B) -> I where I.Source == B.Source, I : TotallyOrdered , B : TotallyOrdered {
    // Precondition: $\property{mutable\_counted\_range}(f_i, n)$
    // Precondition: $\property{mutable\_counted\_range}(f_b, n)$
    let p = copyN(fi: fi, n: n, fo: fb)
    return reverseCopy(fi: fb, li: p.m1, fo: fi)
}

func reverseNForward<I: Mutable & ForwardIterator>(f: I, n: DistanceType) -> I where I : TotallyOrdered {
    // Precondition: $\property{mutable\_counted\_range}(f, n)$
    if n < N(2) { return f + n }
    let h = n.halfNonnegative()
    let nmod2 = n - h.twice()
    let m = reverseNForward(f: f, n: h) + nmod2
    let l = reverseNForward(f: m, n: h)
    _ = swapRangesN(f0: f, f1: m, n: h)
    return l
}

func reverseNAdaptive<I: Mutable & ForwardIterator, B: Mutable & BidirectionalIterator>(fi: I, ni: DistanceType, fb: B, nb: DistanceType) -> I where I.Source == B.Source, I : TotallyOrdered, B : TotallyOrdered {
    // Precondition: $\property{mutable\_counted\_range}(f_i, n_i)$
    // Precondition: $\property{mutable\_counted\_range}(f_b, n_b)$
    if ni < N(2) {
        return fi + ni
    }
    if ni <= nb {
        return reverseNWithBuffer(fi: fi, n: ni, fb: fb)
    }
    let hi = ni.halfNonnegative()
    let nmod2 = ni - hi.twice()
    let mi = reverseNAdaptive(fi: fi, ni: hi, fb: fb, nb: nb) + nmod2
    let li = reverseNAdaptive(fi: mi, ni: hi, fb: fb, nb: nb)
    _ = swapRangesN(f0: fi, f1: mi, n: hi)
    return li
}

func kRotateFromPermutationRandomAccess<I: RandomAccessIterator>(f: I, m: I, l: I) -> UnaryOperation<I> {
    // Precondition: $\property{bounded\_range}(f, l) \wedge m \in [f, l)$
    let k = l - m
    let n_minus_k = m - f
    let m_prime = f + (l - m)
    return { x in
        // Precondition: $x \in [f, l)$
        if x < m_prime { return x + n_minus_k }
        else { return x - k }
    }
}

func kRotateFromPermutationIndexed<I: IndexedIterator>(f: I, m: I, l: I) -> UnaryOperation<I> {
    // Precondition: $\property{bounded\_range}(f, l) \wedge m \in [f, l)$
    let k = l - m
    let n_minus_k = m - f
    return { x in
        // Precondition: $x \in [f, l)$
        let i = x - f
        if i < k { return x + n_minus_k }
        else { return f + (i - k) }
    }
}

func rotateCycles<I: Mutable & IndexedIterator & Distance>(f: I, m: I, l: I, from: Transformation<I>) -> I {
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge m \in [f, l]$
    // Precondition: $from$ is a from-permutation on $[f, l)$
    var d = gcdEuclideanSemiring(a: m - f, b: l - m)
    while countDown(n: &d) { cycleFrom(i: f + d, f: from) }
    return f + (l - m)
}

func rotateIndexedNontrivial<I: Mutable & IndexedIterator & Distance>(f: I, m: I, l: I) -> I {
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge f \prec m \prec l$
    let p = kRotateFromPermutationIndexed(f: f, m: m, l: l)
    return rotateCycles(f: f, m: m, l: l, from: p)
}

func rotateRandomAccessNontrivial<I: Mutable & RandomAccessIterator & Distance>(f: I, m: I, l: I) -> I {
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge f \prec m \prec l$
    let p = kRotateFromPermutationRandomAccess(f: f, m: m, l: l)
    return rotateCycles(f: f, m: m, l: l, from: p)
}

func rotateBidirectionalNonTrivial<I: Mutable & BidirectionalIterator & TotallyOrdered>(f: I, m: I, l: I) -> I {
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge f \prec m \prec l$
    reverseBidirectional(f: f, l: m)
    reverseBidirectional(f: m, l: l)
    let p = reverseSwapRangesBounded(f0: m, l0: l, f1: f, l1: m)
    reverseBidirectional(f: p.m1, l: p.m0)
    if m == p.m0 { return p.m1 }
    else { return p.m0 }
}

func rotateForwardAnnotated<I: Mutable & ForwardIterator & TotallyOrdered>(f: I, m: I, l: I) {
    var f = f, m = m
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge f \prec m \prec l$
    var a = m - f
    var b = l - m
    while true {
        let p = swapRangesBounded(f0: f, l0: m, f1: m, l1: l)
        if p.m0 == m && p.m1 == l {
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

func rotateForwardStep<I: Mutable & ForwardIterator>(f: inout I, m: inout I, l: I) {
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge f \prec m \prec l$
    var c = m
    repeat {
        swapStep(f0: &f, f1: &c)
        if f == m { m = c }
    } while c != l
}

func rotateForwardNontrivial<I: Mutable & ForwardIterator>(f: I, m: I, l: I) -> I {
    var f = f, m = m
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge f \prec m \prec l$
    rotateForwardStep(f: &f, m: &m, l: l)
    let m_prime = f
    while m != l { rotateForwardStep(f: &f, m: &m, l: l) }
    return m_prime
}

func rotatePartialNontrivial<I: Mutable & ForwardIterator>(f: I, m: I, l: I) -> I {
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge f \prec m \prec l$
    return swapRanges(f0: m, l0: l, f1: f)
}

// swap_ranges_backward
// rotate_partial_backward_nontrivial

func rotateWithBufferNontrivial<I: Mutable & ForwardIterator, B: Mutable & ForwardIterator>(f: I, m: I, l: I, fb: B) -> I where I.Source == B.Source {
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge f \prec m \prec l$
    // Precondition: $\property{mutable\_counted\_range}(f_b, l-f)$
    let lb = copy(fi: f, li: m, fo: fb)
    let m_prime = copy(fi: m, li: l, fo: f)
    _ = copy(fi: fb, li: lb, fo: m_prime)
    return m_prime
}

func rotateWithBufferBackwardNontrivial<I: Mutable & BidirectionalIterator, B: Mutable & ForwardIterator>(f: I, m: I, l: I, fb: B) -> I where I.Source == B.Source {
    // Precondition: $\property{mutable\_bounded\_range}(f, l) \wedge f \prec m \prec l$
    // Precondition: $\property{mutable\_counted\_range}(f_b, l-f)$
    let lb = copy(fi: m, li: l, fo: fb)
    _ = copyBackward(fi: f, li: m, lo: l)
    return copy(fi: fb, li: lb, fo: f)
}


// Section 10.5. Algorithm selection


func reverseIndexed<I: Mutable & IndexedIterator>(f: I, l: I) {
    // Precondition: $\property{mutable\_bounded\_range}(f, l)$
    reverseNIndexed(f: f, n: l - f)
}


// temporary_buffer type

//func constructAll<I: Writable & ForwardIterator>(f: I, l: I) {
//    // Precondition:
//    // $(\forall i \in [f, l)) \func{sink}(i) \text{refers to raw memory, not an object}$
//    // Postcondition:
//    // $(\forall i \in [f, l)) \func{sink}(i) \text{is in a default-constructed state}$
//    // We assume if an iterator is writeable, its value can be constructed
//
//}
//
//func constructAll<I: Writable & ForwardIterator>(f: I, l: I, b: Bool) {
//    if b {
//        // Precondition:
//        // $(\forall i \in [f, l)) \func{sink}(i) \text{refers to raw memory, not an object}$
//        // Postcondition:
//        // $(\forall i \in [f, l)) \func{sink}(i) \text{is in a partially-formed state}$
//        // We assume if an iterator is writeable, its value can be constructed
//        while f != l {
//            construct(f.sink)
//            f = f.iteratorSuccessor!
//        }
//    } else {
//        // Precondition:
//        // $(\forall i \in [f, l)) \func{sink}(i) \text{is in a partially-formed state}$
//        // Postcondition:
//        // $(\forall i \in [f, l)) \func{sink}(i) \text{is in a partially-formed state}$
//    }
//}





