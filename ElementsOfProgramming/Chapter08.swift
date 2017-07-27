//
//  Chapter08.swift
//  ElementsOfProgramming
//


// Models of ForwardLinker, BackwardLinker, and BidirectionalLinker
// assuming a particular representation of links

struct ForwardLinker<I: ForwardLinkedIterator> {
    static func setForwardLink(x: inout I, y: inout I) {
        x.forwardLink = y
    }
}

struct BackwardLinker<I: BackwardLinkedIterator> {
    static func setBackwardLink(x: inout I, y: inout I) {
        y.backwardLink = x
    }
}

struct BidirectionalLinker<I: BidirectionalLinkedIterator> {
    static func setForwardLink(x: inout I, y: inout I) {
        x.forwardLink = y
    }
    
    static func setBackwardLink(x: inout I, y: inout I) {
        y.backwardLink = x
    }
    
    static func setBidirectionalLink(x: inout I, y: inout I) {
        setForwardLink(x: &x, y: &y)
        setBackwardLink(x: &x, y: &y)
    }
}

func setLink<I: ForwardIterator>(t: inout I, f: inout I) {
    t = f
}

func advanceTail<I: ForwardIterator>(t: inout I, f: inout I) {
    // Precondition: successor(f) is defined
    t = f
    f = f.iteratorSuccessor!
}

func linkerToTail<I: ForwardLinkedIterator>(t: inout I, f: inout I) {
    // Precondition: successor(f) is defined
    ForwardLinker.setForwardLink(x: &t, y: &f)
    advanceTail(t: &t, f: &f)
}

func findLast<I: ForwardIterator>(f: I, l: I) -> I {
    var f = f
    // Precondition: bounded_range(f, l) ∧ f ≠ l
    // FIXME: Abusing impliticly unwrapped optionals to match the original C++
    var t : I?
    repeat {
        advanceTail(t: &t!, f: &f)
    } while f != l
    return t!
}

func splitLinkedS0<I: ForwardLinkedIterator>(
    f: inout I, l: inout I,
    t0: inout I, t1: inout I,
    h0: inout I, h1: inout I,
    p: UnaryPredicate<I>
) -> Pair<Pair<I, I>, Pair<I, I>> {
    if f == l {
        return splitLinkedS4(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    }
    if p(f) {
        h1 = f
        advanceTail(t: &t1, f: &f)
        return splitLinkedS3(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    } else {
        advanceTail(t: &t0, f: &f)
        return splitLinkedS0(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    }
}

func splitLinkedS1<I: ForwardLinkedIterator>(
    f: inout I, l: inout I,
    t0: inout I, t1: inout I,
    h0: inout I, h1: inout I,
    p: UnaryPredicate<I>
) -> Pair<Pair<I, I>, Pair<I, I>> {
    if f == l {
        return splitLinkedS4(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    }
    if p(f) {
        h1 = f
        advanceTail(t: &t1, f: &f)
        return splitLinkedS1(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    } else {
        h0 = f
        advanceTail(t: &t0, f: &f)
        return splitLinkedS2(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    }
}

func splitLinkedS2<I: ForwardLinkedIterator>(
    f: inout I, l: inout I,
    t0: inout I, t1: inout I,
    h0: inout I, h1: inout I,
    p: UnaryPredicate<I>
) -> Pair<Pair<I, I>, Pair<I, I>> {
    if f == l {
        return splitLinkedS4(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    }
    if p(f) {
        linkerToTail(t: &t1, f: &f)
        return splitLinkedS3(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    } else {
        advanceTail(t: &t0, f: &f)
        return splitLinkedS2(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    }
}

func splitLinkedS3<I: ForwardLinkedIterator>(
    f: inout I, l: inout I,
    t0: inout I, t1: inout I,
    h0: inout I, h1: inout I,
    p: UnaryPredicate<I>
) -> Pair<Pair<I, I>, Pair<I, I>> {
    if f == l {
        return splitLinkedS4(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    }
    if p(f) {
        advanceTail(t: &t1, f: &f)
        return splitLinkedS3(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    } else {
        linkerToTail(t: &t0, f: &f)
        return splitLinkedS2(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    }
}

func splitLinkedS4<I: ForwardIterator>(
    f: inout I, l: inout I,
    t0: inout I, t1: inout I,
    h0: inout I, h1: inout I,
    p: UnaryPredicate<I>
) -> Pair<Pair<I, I>, Pair<I, I>> {
    return Pair(m0: Pair(m0: h0, m1: t0),
                m1: Pair(m0: h1, m1: t1))
}

func splitLinked<I: ForwardLinkedIterator>(
    f: I, l: I,
    p: UnaryPredicate<I>
) -> Pair<Pair<I, I>, Pair<I, I>> {
    var f = f, l = l
    // Precondition: bounded_range(f, l)
    var h0 = l, h1 = l
    var t0 = l, t1 = l
    if f == l {
        return splitLinkedS4(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    }
    if p(f) {
        h1 = f
        advanceTail(t: &t1, f: &f)
        return splitLinkedS1(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    } else {
        h0 = f
        advanceTail(t: &t0, f: &f)
        return splitLinkedS0(f: &f, l: &l,
                             t0: &t0, t1: &t1,
                             h0: &h0, h1: &h1,
                             p: p)
    }
}


// Exercise 8.1: Explain the postcondition of split_linked


func combineLinkedNonemptyS0<I: ForwardLinkedIterator>(
    f0: inout I, l0: inout I,
    f1: inout I, l1: inout I,
    h: inout I, t: inout I,
    r: Relation<I>
) -> Triple<I, I, I> {
    if f0 == l0 {
        return combineLinkedNonemptyS2(f0: &f0, l0: &l0,
                                       f1: &f1, l1: &l1,
                                       h: &h, t: &t,
                                       r: r)
    }
    if r(f1, f0) {
        linkerToTail(t: &t, f: &f1)
        return combineLinkedNonemptyS1(f0: &f0, l0: &l0,
                                       f1: &f1, l1: &l1,
                                       h: &h, t: &t,
                                       r: r)
    } else {
        advanceTail(t: &t, f: &f0)
        return combineLinkedNonemptyS0(f0: &f0, l0: &l0,
                                       f1: &f1, l1: &l1,
                                       h: &h, t: &t,
                                       r: r)
    }
}

func combineLinkedNonemptyS1<I: ForwardLinkedIterator>(
    f0: inout I, l0: inout I,
    f1: inout I, l1: inout I,
    h: inout I, t: inout I,
    r: Relation<I>
) -> Triple<I, I, I> {
    if f1 == l1 {
        return combineLinkedNonemptyS3(f0: &f0, l0: &l0,
                                       f1: &f1, l1: &l1,
                                       h: &h, t: &t,
                                       r: r)
    }
    if r(f1, f0) {
        advanceTail(t: &t, f: &f1)
        return combineLinkedNonemptyS1(f0: &f0, l0: &l0,
                                       f1: &f1, l1: &l1,
                                       h: &h, t: &t,
                                       r: r)
    } else {
        linkerToTail(t: &t, f: &f0)
        return combineLinkedNonemptyS0(f0: &f0, l0: &l0,
                                       f1: &f1, l1: &l1,
                                       h: &h, t: &t,
                                       r: r)
    }
}

func combineLinkedNonemptyS2<I: ForwardLinkedIterator>(
    f0: inout I, l0: inout I,
    f1: inout I, l1: inout I,
    h: inout I, t: inout I,
    r: Relation<I>
) -> Triple<I, I, I> {
    ForwardLinker.setForwardLink(x: &t, y: &f1)
    return Triple(m0: h, m1: t, m2: l1)
}

func combineLinkedNonemptyS3<I: ForwardLinkedIterator>(
    f0: inout I, l0: inout I,
    f1: inout I, l1: inout I,
    h: inout I, t: inout I,
    r: Relation<I>
) -> Triple<I, I, I> {
    ForwardLinker.setForwardLink(x: &t, y: &f0)
    return Triple(m0: h, m1: t, m2: l0)
}

func combineLinkedNonempty<I: ForwardLinkedIterator>(
    f0: I, l0: I,
    f1: I, l1: I,
    r: Relation<I>
) -> Triple<I, I, I> {
    var f0 = f0, f1 = f1
    var l0 = l0, l1 = l1
    // Precondition: bounded_range(f0, l0) ∧ bounded_range(f1, l1)
    // Precondition: f0 ≠ l0 ∧ f1 ≠ l1 ∧ disjoint(f0, l0, f1, l1)
    var h: I
    // FIXME: Abusing impliticly unwrapped optionals to match the original C++
    var t: I?
    if r(f1, f0) {
        h = f1
        advanceTail(t: &t!, f: &f1)
        return combineLinkedNonemptyS1(f0: &f0, l0: &l0,
                                       f1: &f1, l1: &l1,
                                       h: &h, t: &t!,
                                       r: r)
    } else {
        h = f0
        linkerToTail(t: &t!, f: &f0)
        return combineLinkedNonemptyS0(f0: &f0, l0: &l0,
                                       f1: &f1, l1: &l1,
                                       h: &h, t: &t!,
                                       r: r)
    }
}


// Exercise 8.2: combine_linked


func linkerToHead<I: ForwardLinkedIterator>(h: inout I, f: inout I) {
    // Precondition: successor(f) is defined
    let tmp = f.iteratorSuccessor!
    ForwardLinker.setForwardLink(x: &f, y: &h)
    h = f
    f = tmp
}

func reverseAppend<I: ForwardLinkedIterator>(f: I, l: I, h: I) -> I {
    var f = f, h = h
    // Precondition: bounded_range(f, l) ∧ h ∉ [f, l)
    while f != l { linkerToHead(h: &h, f: &f) }
    return h
}

func predicateSource<I: Readable>(
    p: @escaping UnaryPredicate<I.Source>
) -> UnaryPredicate<I> {
    return { i in
        return p(i.source!)
    }
}

func partitionLinked<I: Readable & ForwardLinkedIterator>(
    f: I, l: I,
    p: @escaping UnaryPredicate<I.Source>
) -> Pair<Pair<I, I>, Pair<I, I>> {
    // Precondition: bounded_range(f, l)
    let ps: UnaryPredicate<I> = predicateSource(p: p)
    return splitLinked(f: f, l: l, p: ps)
}

func relationSource<
    I0: Readable,
    I1: Readable
>(
    r: @escaping Relation<I0.Source>
) -> BinaryRelation<I0, I1>
where I0.Source == I1.Source {
    return { i0, i1 in
        return r(i0.source!, i1.source!)
    }
}

func mergeLinkedNonempty<I: Readable & ForwardLinkedIterator>(
    f0: I, l0: I,
    f1: I, l1: I,
    r: @escaping Relation<I.Source>
) -> Pair<I, I> {
    var l1 = l1
    // Precondition: f0 ≠ l0 ∧ f1 ≠ l1
    // Precondition: increasing_range(f0, l0, r)
    // Precondition: increasing_range(f1, l1, r)
    let rs: Relation<I> = relationSource(r: r)
    let t = combineLinkedNonempty(f0: f0, l0: l0, f1: f1, l1: l1, r: rs)
    var last = findLast(f: t.m1, l: t.m2)
    ForwardLinker.setForwardLink(x: &last, y: &l1)
    return Pair(m0: t.m0, m1: l1)
}

func sortLinkedNonempty<I: Readable & ForwardLinkedIterator>(
    f: I,
    n: DistanceType,
    r: @escaping Relation<I.Source>
) -> Pair<I, I> {
    // Precondition: counted_range(f, n) ∧
    //                n > 0 ∧ weak_ordering(r)
    if n == N(1) { return Pair(m0: f, m1: f.iteratorSuccessor!) }
    let h = n.halfNonnegative()
    let p0 = sortLinkedNonempty(f: f, n: h, r: r)
    let p1 = sortLinkedNonempty(f: p0.m1, n: n - h, r: r)
    return mergeLinkedNonempty(f0: p0.m0, l0: p0.m1, f1: p1.m0, l1: p1.m1, r: r)
}


// Exercise 8.3: Complexity of sort_linked_nonempty_n


// Exercise 8.4: unique


func treeRotate<C: EmptyLinkedBifurcateCoordinate>(
    curr: inout C,
    prev: inout C
) {
    // Precondition: ￢empty(curr)
    let tmp = curr.leftSuccessor!
    curr.leftSuccessor = curr.rightSuccessor!
    curr.rightSuccessor = prev
    if tmp.isEmpty() {
        prev = tmp
        return
    }
    prev = curr
    curr = tmp
}

func traverseRotating<
    C: EmptyLinkedBifurcateCoordinate,
    P: UnaryProcedure
>(
    c: C,
    proc: P
) -> P
where P.UnaryProcedureType == C {
    // Precondition: tree(c)
    if c.isEmpty() { return proc }
    var curr = c
    // FIXME: Abusing impliticly unwrapped optionals to match the original C++
    var prev: C?
    repeat {
        proc.call(curr)
        treeRotate(curr: &curr, prev: &prev!)
    } while curr != c
    repeat {
        proc.call(curr)
        treeRotate(curr: &curr, prev: &prev!)
    } while curr != c
    proc.call(curr)
    treeRotate(curr: &curr, prev: &prev!)
    return proc
}


// Exercise 8.5: Diagram each state of traverse_rotating
// for a complete binary tree with 7 nodes


class Counter<T>: UnaryProcedure {
    var n: N
    
    init() {
        n = N(0)
    }
    
    init(n: N) {
        self.n = n
    }

    func call(_ arg: T) {
        n = n.successor()
    }
}

func weightRotating<C: EmptyLinkedBifurcateCoordinate>(c: C) -> WeightType {
    // Precondition: tree(c)
    let counter = Counter<C>()
    return traverseRotating(c: c, proc: counter).n / N(3)
}

class PhasedApplicator<P: UnaryProcedure>: UnaryProcedure {
    // Invariant: n, phase ∈ [0, period)
    var period: N
    var phase: N
    var n: N
    var proc: P
    
    init(period: N, phase: N, n: N, proc: P) {
        self.period = period
        self.phase = phase
        self.n = n
        self.proc = proc
    }
    
    func call(_ arg: P.UnaryProcedureType) {
        if n == phase { proc.call(arg) }
        n = n.successor()
        if n == period { n = 0 }
    }
}

func traversePhasedRotating<
    C: EmptyLinkedBifurcateCoordinate,
    P: UnaryProcedure
>(
    c: C,
    phase: N, proc: P
) -> P
where P.UnaryProcedureType == C {
    // Precondition: tree(c) ∧ 0 ≤ phase < 3
    let applicator = PhasedApplicator(period: 3,
                                      phase: phase,
                                      n: 0,
                                      proc: proc)
    return traverseRotating(c: c, proc: applicator).proc
}
