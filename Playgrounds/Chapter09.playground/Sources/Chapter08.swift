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

func advanceTail<I: ForwardIterator>(t: inout I, f: inout I) throws {
    // Precondition: successor(f) is defined
    guard let s = f.iteratorSuccessor else { throw EOPError.noSuccessor }
    t = f
    f = s
}

func linkerToTail<I: ForwardLinkedIterator>(t: inout I, f: inout I) throws {
    // Precondition: successor(f) is defined
    ForwardLinker.setForwardLink(x: &t, y: &f)
    try advanceTail(t: &t, f: &f)
}

func findLast<I: ForwardIterator>(f: I, l: I) -> I? {
    var f = f,  t = f
    // Precondition: bounded_range(f, l) ∧ f ≠ l
    repeat {
        do { try advanceTail(t: &t, f: &f) } catch { return nil }
    } while f != l
    return t
}

func splitLinked_s0<I: ForwardLinkedIterator>(
    f: inout I, l: inout I,
    t0: inout I, t1: inout I,
    h0: inout I, h1: inout I,
    p: UnaryPredicate<I>
) -> Pair<Pair<I, I>, Pair<I, I>>? {
    guard f != l else {
        return splitLinked_s4(f: &f, l: &l,
                              t0: &t0, t1: &t1,
                              h0: &h0, h1: &h1,
                              p: p)
    }
    guard p(f) else {
        do { try advanceTail(t: &t0, f: &f) } catch { return nil }
        return splitLinked_s0(f: &f, l: &l,
                              t0: &t0, t1: &t1,
                              h0: &h0, h1: &h1,
                              p: p)
    }
    h1 = f
    do { try advanceTail(t: &t1, f: &f) } catch { return nil }
    return splitLinked_s3(f: &f, l: &l,
                          t0: &t0, t1: &t1,
                          h0: &h0, h1: &h1,
                          p: p)
}

func splitLinked_s1<I: ForwardLinkedIterator>(
    f: inout I, l: inout I,
    t0: inout I, t1: inout I,
    h0: inout I, h1: inout I,
    p: UnaryPredicate<I>
) -> Pair<Pair<I, I>, Pair<I, I>>? {
    guard f != l else {
        return splitLinked_s4(f: &f, l: &l,
                              t0: &t0, t1: &t1,
                              h0: &h0, h1: &h1,
                              p: p)
    }
    guard p(f) else {
        h0 = f
        do { try advanceTail(t: &t0, f: &f) } catch { return nil }
        return splitLinked_s2(f: &f, l: &l,
                              t0: &t0, t1: &t1,
                              h0: &h0, h1: &h1,
                              p: p)
    }
    h1 = f
    do { try advanceTail(t: &t1, f: &f) } catch { return nil }
    return splitLinked_s1(f: &f, l: &l,
                          t0: &t0, t1: &t1,
                          h0: &h0, h1: &h1,
                          p: p)
}

func splitLinked_s2<I: ForwardLinkedIterator>(
    f: inout I, l: inout I,
    t0: inout I, t1: inout I,
    h0: inout I, h1: inout I,
    p: UnaryPredicate<I>
) -> Pair<Pair<I, I>, Pair<I, I>>? {
    guard f != l else {
        return splitLinked_s4(f: &f, l: &l,
                              t0: &t0, t1: &t1,
                              h0: &h0, h1: &h1,
                              p: p)
    }
    guard p(f) else {
        do { try advanceTail(t: &t0, f: &f) } catch { return nil }
        return splitLinked_s2(f: &f, l: &l,
                              t0: &t0, t1: &t1,
                              h0: &h0, h1: &h1,
                              p: p)
    }
    do { try linkerToTail(t: &t1, f: &f) } catch { return nil }
    return splitLinked_s3(f: &f, l: &l,
                          t0: &t0, t1: &t1,
                          h0: &h0, h1: &h1,
                          p: p)
}

func splitLinked_s3<I: ForwardLinkedIterator>(
    f: inout I, l: inout I,
    t0: inout I, t1: inout I,
    h0: inout I, h1: inout I,
    p: UnaryPredicate<I>
) -> Pair<Pair<I, I>, Pair<I, I>>? {
    guard f != l else {
        return splitLinked_s4(f: &f, l: &l,
                              t0: &t0, t1: &t1,
                              h0: &h0, h1: &h1,
                              p: p)
    }
    guard p(f) else {
        do { try linkerToTail(t: &t0, f: &f) } catch { return nil }
        return splitLinked_s2(f: &f, l: &l,
                              t0: &t0, t1: &t1,
                              h0: &h0, h1: &h1,
                              p: p)
    }
    do { try advanceTail(t: &t1, f: &f) } catch { return nil }
    return splitLinked_s3(f: &f, l: &l,
                          t0: &t0, t1: &t1,
                          h0: &h0, h1: &h1,
                          p: p)
}

func splitLinked_s4<I: ForwardIterator>(
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
) -> Pair<Pair<I, I>, Pair<I, I>>? {
    var f = f, l = l
    // Precondition: bounded_range(f, l)
    var h0 = l, h1 = l
    var t0 = l, t1 = l
    guard f != l else {
        return splitLinked_s4(f: &f, l: &l,
                              t0: &t0, t1: &t1,
                              h0: &h0, h1: &h1,
                              p: p)
    }
    guard p(f) else {
        h0 = f
        do { try advanceTail(t: &t0, f: &f) } catch { return nil }
        return splitLinked_s0(f: &f, l: &l,
                              t0: &t0, t1: &t1,
                              h0: &h0, h1: &h1,
                              p: p)
    }
    h1 = f
    do { try advanceTail(t: &t1, f: &f) } catch { return nil }
    return splitLinked_s1(f: &f, l: &l,
                          t0: &t0, t1: &t1,
                          h0: &h0, h1: &h1,
                          p: p)
}


// Exercise 8.1: Explain the postcondition of split_linked


func combineLinkedNonempty_s0<I: ForwardLinkedIterator>(
    f0: inout I, l0: inout I,
    f1: inout I, l1: inout I,
    h: inout I, t: inout I,
    r: Relation<I>
) -> Triple<I, I, I>? {
    guard f0 != l0 else {
        return combineLinkedNonempty_s2(f0: &f0, l0: &l0,
                                        f1: &f1, l1: &l1,
                                        h: &h, t: &t,
                                        r: r)
    }
    guard r(f1, f0) else {
        do { try advanceTail(t: &t, f: &f0) } catch { return nil }
        return combineLinkedNonempty_s0(f0: &f0, l0: &l0,
                                        f1: &f1, l1: &l1,
                                        h: &h, t: &t,
                                        r: r)
    }
    do { try linkerToTail(t: &t, f: &f1) } catch { return nil }
    return combineLinkedNonempty_s1(f0: &f0, l0: &l0,
                                    f1: &f1, l1: &l1,
                                    h: &h, t: &t,
                                    r: r)
}

func combineLinkedNonempty_s1<I: ForwardLinkedIterator>(
    f0: inout I, l0: inout I,
    f1: inout I, l1: inout I,
    h: inout I, t: inout I,
    r: Relation<I>
) -> Triple<I, I, I>? {
    guard f1 != l1 else {
        return combineLinkedNonempty_s3(f0: &f0, l0: &l0,
                                        f1: &f1, l1: &l1,
                                        h: &h, t: &t,
                                        r: r)
    }
    guard r(f1, f0) else {
        do { try linkerToTail(t: &t, f: &f0) } catch { return nil }
        return combineLinkedNonempty_s0(f0: &f0, l0: &l0,
                                        f1: &f1, l1: &l1,
                                        h: &h, t: &t,
                                        r: r)
    }
    do { try advanceTail(t: &t, f: &f1) } catch { return nil }
    return combineLinkedNonempty_s1(f0: &f0, l0: &l0,
                                    f1: &f1, l1: &l1,
                                    h: &h, t: &t,
                                    r: r)
}

func combineLinkedNonempty_s2<I: ForwardLinkedIterator>(
    f0: inout I, l0: inout I,
    f1: inout I, l1: inout I,
    h: inout I, t: inout I,
    r: Relation<I>
) -> Triple<I, I, I> {
    ForwardLinker.setForwardLink(x: &t, y: &f1)
    return Triple(m0: h, m1: t, m2: l1)
}

func combineLinkedNonempty_s3<I: ForwardLinkedIterator>(
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
) -> Triple<I, I, I>? {
    var f0 = f0, f1 = f1
    var l0 = l0, l1 = l1
    // Precondition: bounded_range(f0, l0) ∧ bounded_range(f1, l1)
    // Precondition: f0 ≠ l0 ∧ f1 ≠ l1 ∧ disjoint(f0, l0, f1, l1)
    var h: I, t = f0
    guard r(f1, f0) else {
        h = f0
        do { try linkerToTail(t: &t, f: &f0) } catch { return nil }
        return combineLinkedNonempty_s0(f0: &f0, l0: &l0,
                                        f1: &f1, l1: &l1,
                                        h: &h, t: &t,
                                        r: r)
    }
    h = f1
    do { try advanceTail(t: &t, f: &f1) } catch { return nil }
    return combineLinkedNonempty_s1(f0: &f0, l0: &l0,
                                    f1: &f1, l1: &l1,
                                    h: &h, t: &t,
                                    r: r)
}


// Exercise 8.2: combine_linked


func linkerToHead<I: ForwardLinkedIterator>(h: inout I, f: inout I) throws {
    // Precondition: successor(f) is defined
    guard let tmp = f.iteratorSuccessor else { throw EOPError.noSuccessor }
    ForwardLinker.setForwardLink(x: &f, y: &h)
    h = f
    f = tmp
}

func reverseAppend<I: ForwardLinkedIterator>(f: I, l: I, h: I) -> I? {
    var f = f, h = h
    // Precondition: bounded_range(f, l) ∧ h ∉ [f, l)
    while f != l {
        do { try linkerToHead(h: &h, f: &f) } catch { return nil }
    }
    return h
}

public func predicateSource<I: Readable>(
    p: @escaping UnaryPredicate<I.Source>
) -> UnaryPredicate<I> {
    return { i in
        return p(i.source!)
    }
}

func partitionLinked<I: Readable & ForwardLinkedIterator>(
    f: I, l: I,
    p: @escaping UnaryPredicate<I.Source>
) -> Pair<Pair<I, I>, Pair<I, I>>? {
    // Precondition: bounded_range(f, l)
    let ps: UnaryPredicate<I> = predicateSource(p: p)
    return splitLinked(f: f, l: l, p: ps)
}

public func relationSource<
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
) -> Pair<I, I>? {
    var l1 = l1
    // Precondition: f0 ≠ l0 ∧ f1 ≠ l1
    // Precondition: increasing_range(f0, l0, r)
    // Precondition: increasing_range(f1, l1, r)
    let rs: Relation<I> = relationSource(r: r)
    guard let t = combineLinkedNonempty(f0: f0, l0: l0,
                                        f1: f1, l1: l1,
                                        r: rs),
          var last = findLast(f: t.m1, l: t.m2) else { return nil }
    ForwardLinker.setForwardLink(x: &last, y: &l1)
    return Pair(m0: t.m0, m1: l1)
}

func sortLinkedNonempty<I: Readable & ForwardLinkedIterator>(
    f: I,
    n: DistanceType,
    r: @escaping Relation<I.Source>
) -> Pair<I, I>? {
    // Precondition: counted_range(f, n) ∧
    //                n > 0 ∧ weak_ordering(r)
    guard n != 1 else {
        guard let s = f.iteratorSuccessor else { return nil }
        return Pair(m0: f, m1: s)
    }
    let h = n.halfNonnegative()
    guard let p0 = sortLinkedNonempty(f: f, n: h, r: r),
          let p1 = sortLinkedNonempty(f: p0.m1, n: n - h, r: r) else {
        return nil
    }
    return mergeLinkedNonempty(f0: p0.m0, l0: p0.m1, f1: p1.m0, l1: p1.m1, r: r)
}


// Exercise 8.3: Complexity of sort_linked_nonempty_n


// Exercise 8.4: unique


func treeRotate<C: EmptyLinkedBifurcateCoordinate>(
    curr: inout C,
    prev: inout C
) throws {
    // Precondition: ￢empty(curr)
    guard let tmp = curr.leftSuccessor else { throw EOPError.noLeftSuccessor }
    guard let crs = curr.rightSuccessor else { throw EOPError.noRightSuccessor }
    curr.leftSuccessor = crs
    curr.rightSuccessor = prev
    guard !tmp.isEmpty() else {
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
) -> P?
where P.UnaryProcedureType == C {
    // Precondition: tree(c)
    guard !c.isEmpty() else { return proc }
    var curr = c, prev = c
    repeat {
        proc.call(curr)
        do { try treeRotate(curr: &curr, prev: &prev) } catch { return nil }
    } while curr != c
    repeat {
        proc.call(curr)
        do { try treeRotate(curr: &curr, prev: &prev) } catch { return nil }
    } while curr != c
    proc.call(curr)
    do { try treeRotate(curr: &curr, prev: &prev) } catch { return nil }
    return proc
}


// Exercise 8.5: Diagram each state of traverse_rotating
// for a complete binary tree with 7 nodes


class Counter<T>: UnaryProcedure {
    var n: N

    init() {
        n = 0
    }

    init(n: N) {
        self.n = n
    }

    func call(_ arg: T) {
        n = n.successor()
    }
}

func weightRotating<C: EmptyLinkedBifurcateCoordinate>(
    c: C
) -> WeightType? {
    // Precondition: tree(c)
    let counter = Counter<C>()
    guard let tr = traverseRotating(c: c, proc: counter) else { return nil }
    return tr.n / 3
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
) -> P?
where P.UnaryProcedureType == C {
    // Precondition: tree(c) ∧ 0 ≤ phase < 3
    let applicator = PhasedApplicator(period: 3,
                                      phase: phase,
                                      n: 0,
                                      proc: proc)
    return traverseRotating(c: c, proc: applicator)?.proc
}
