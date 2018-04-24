//
//  Chapter07.swift
//  ElementsOfProgramming
//


func weightRecursive<C: BifurcateCoordinate>(c: C) -> WeightType {
    // Precondition: tree(c)
    guard !c.isEmpty() else { return 0 }
    var l = N(0), r = N(0)
    if let ls = c.leftSuccessor {
        l = weightRecursive(c: ls)
    }
    if let rs = c.rightSuccessor {
        r = weightRecursive(c: rs)
    }
    let t = l + r
    return t.successor()
}

func heightRecursive<C: BifurcateCoordinate>(c: C) -> WeightType {
    // Precondition: tree(c)
    guard !c.isEmpty() else { return 0 }
    var l = N(0), r = N(0)
    if let ls = c.leftSuccessor {
        l = heightRecursive(c: ls)
    }
    if let rs = c.rightSuccessor {
        r = heightRecursive(c: rs)
    }
    return maxSelect(a: l, b: r).successor()
}

enum Visit: Int, Comparable {
    case pre = 1, `in` = 2, post = 3

    static func <(lhs: Visit, rhs: Visit) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

func traverseNonempty<
    C: BifurcateCoordinate,
    P: BinaryProcedure
>(
    c: C,
    proc: P
) -> P
where P.BinaryProcedureType1 == Visit, P.BinaryProcedureType2 == C {
    var proc = proc
    // Precondition: tree(c) ∧ ￢empty(c)
    proc.call(.pre, c)
    if let ls = c.leftSuccessor {
        proc = traverseNonempty(c: ls, proc: proc)
    }
    proc.call(.in, c)
    if let rs = c.rightSuccessor {
        proc = traverseNonempty(c: rs, proc: proc)
    }
    proc.call(.post, c)
    return proc
}

func isLeftSuccessor<T: BidirectionalBifurcateCoordinate>(j: T) -> Bool? {
    // Precondition: has_predecessor(j)
    guard let i = j.iteratorPredecessor else { return nil }
    guard let ls = i.leftSuccessor else { return false }
    return ls == j
}

func isRightSuccessor<T: BidirectionalBifurcateCoordinate>(j: T) -> Bool? {
    // Precondition: has_predecessor(j)
    guard let i = j.iteratorPredecessor else { return nil }
    guard let rs = i.rightSuccessor else { return false }
    return rs == j
}

func traverseStep<C: BidirectionalBifurcateCoordinate>(
    v: inout Visit,
    c: inout C
) -> Int? {
    // Precondition: has_predecessor(c) ∨ v ≠ post
    switch v {
    case .pre:
        guard let ls = c.leftSuccessor else {
            v = .in
            return 0
        }
        c = ls
        return 1
    case .in:
        guard let rs = c.rightSuccessor else {
            v = .post
            return 0
        }
        v = .pre
        c = rs
        return 1
    case .post:
        guard let ils = isLeftSuccessor(j: c) else { return nil }
        if ils {
            v = .in
        }
        guard let p = c.iteratorPredecessor else { return nil }
        c = p
        return -1
    }
}

func reachable<C: BidirectionalBifurcateCoordinate>(
    x: C, y: C
) -> Bool {
    var x = x
    // Precondition: tree(x)
    guard !x.isEmpty() else { return false }
    let root = x
    var v = Visit.pre
    repeat {
        guard x != y else { return true }
        guard let _ = traverseStep(v: &v, c: &x) else { return false }
    } while x != root || v != .post
    return false
}

func weight<C: BidirectionalBifurcateCoordinate>(c: C) -> WeightType? {
    var c = c
    // Precondition: tree(c)
    guard !c.isEmpty() else { return 0 }
    let root = c
    var v = Visit.pre
    var n = N(1) // Invariant: n is count of .pre visits so far
    repeat {
        guard let _ = traverseStep(v: &v, c: &c) else { return nil }
        if v == .pre { n = n.successor() }
    } while c != root || v != .post
    return n
}

func height<C: BidirectionalBifurcateCoordinate>(c: C) -> WeightType? {
    var c = c
    // Precondition: tree(c)
    guard !c.isEmpty() else { return 0 }
    let root = c
    var v = Visit.pre
    var n = N(1) // Invariant: n is max of height of .pre visits so far
    var m = N(1) // Invariant: m is height of current .pre visit
    repeat {
        guard let ts = traverseStep(v: &v, c: &c) else { return nil }
        m = (m - 1) + N(ts + 1)
        n = max(n, m)
    } while c != root || v != .post
    return n
}

func traverse<
    C: BidirectionalBifurcateCoordinate,
    P: BinaryProcedure
>(
    c: C,
    proc: P
) -> P?
where P.BinaryProcedureType1 == Visit, P.BinaryProcedureType2 == C {
    var c = c
    // Precondition: tree(c)
    guard !c.isEmpty() else { return proc }
    let root = c
    var v = Visit.pre
    proc.call(.pre, c)
    repeat {
        guard let _ = traverseStep(v: &v, c: &c) else { return nil }
        proc.call(v, c)
    } while c != root || v != .post
    return proc
}


// Exercise 7.3: Use traverse_step and the procedures of Chapter 2 to determine
// whether the descendants of a bidirectional bifurcate coordinate form a DAG


func bifurcateIsomorphicNonempty<
    C0: BifurcateCoordinate,
    C1: BifurcateCoordinate
>(
    c0: C0,
    c1: C1
) -> Bool {
    // Precondition: tree(c0) ∧ tree(c1) ∧ ￢empty(c0) ∧ ￢empty(c1)
    if let c0ls = c0.leftSuccessor, let c1ls = c1.leftSuccessor {
        guard bifurcateIsomorphicNonempty(c0: c0ls,
                                          c1: c1ls) else { return false }
    } else if let _ = c1.leftSuccessor { return false }
    if let c0rs = c0.rightSuccessor, let c1rs = c1.rightSuccessor {
        guard bifurcateIsomorphicNonempty(c0: c0rs,
                                          c1: c1rs) else { return false }
    } else if let _ = c1.rightSuccessor { return false }
    return true
}

func bifurcateIsomorphic<
    C0: BidirectionalBifurcateCoordinate,
    C1: BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1
) -> Bool? {
    var c0 = c0, c1 = c1
    // Precondition: tree(c0) ∧ tree(c1)
    guard !c0.isEmpty() else { return c1.isEmpty() }
    guard !c1.isEmpty() else { return false }
    let root0 = c0
    var v0 = Visit.pre
    var v1 = Visit.pre
    while true {
        guard let _ = traverseStep(v: &v0, c: &c0),
              let _ = traverseStep(v: &v1, c: &c1) else { return nil }
        guard v0 == v1 else { return false }
        if c0 == root0 && v0 == .post { return true }
    }
}

func lexicographicalEquivalent<
    I0: Readable & Iterator,
    I1: Readable & Iterator
>(
    f0: I0, l0: I0,
    f1: I1, l1: I1,
    r: Relation<I0.Source>
) -> Bool?
where I0.Source == I1.Source {
    // Precondition: readable_bounded_range(f0, l0)
    // Precondition: readable_bounded_range(f1, l1)
    // Precondition: equivalence(r)
    guard let p: Pair<I0, I1> = findMismatch(f0: f0, l0: l0,
                                             f1: f1, l1: l1,
                                             r: r) else { return nil }
    return p.m0 == l0 && p.m1 == l1
}

func lexicographicalEqual<
    I0: Readable & Iterator,
    I1: Readable & Iterator
>(
    f0: I0, l0: I0,
    f1: I1, l1: I1
) -> Bool?
where I0.Source == I1.Source {
    return lexicographicalEquivalent(f0: f0, l0: l0,
                                     f1: f1, l1: l1,
                                     r: equal)
}

// Could specialize to use lexicographic_equal for k > some cutoff

func lexicographicalEqual<
    I0: Readable & ForwardIterator,
    I1: Readable & ForwardIterator
>(
    k: Int,
    f0: I0,
    f1: I1
) -> Bool?
where I0.Source == I1.Source {
    guard k != 0 else { return true }
    guard f0.source == f1.source else { return false }
    guard let f0s = f0.iteratorSuccessor,
          let f1s = f1.iteratorSuccessor else { return nil }
    return lexicographicalEqual(k: k - 1,
                                f0: f0s,
                                f1: f1s)
}

func bifurcateEquivalentNonempty<
    C0: Readable & BifurcateCoordinate,
    C1: Readable & BifurcateCoordinate
>(
    c0: C0,
    c1: C1,
    r: Relation<C0.Source>
) -> Bool?
where C0.Source == C1.Source {
    // Precondition: readable_tree(c0) ∧ readable_tree(c1)
    // Precondition: ￢empty(c0) ∧ ￢empty(c1)
    // Precondition: equivalence(r)
    guard let c0src = c0.source,
          let c1src = c1.source else { return nil }
    guard r(c0src, c1src) else { return false }
    if let c0ls = c0.leftSuccessor, let c1ls = c1.leftSuccessor {
        guard let b = bifurcateEquivalentNonempty(c0: c0ls,
                                                  c1: c1ls,
                                                  r: r) else { return nil }
        guard b else { return false }
    } else if let _ = c1.leftSuccessor { return false }
    if let c0rs = c0.rightSuccessor, let c1rs = c1.rightSuccessor {
        guard let b = bifurcateEquivalentNonempty(c0: c0rs,
                                                  c1: c1rs,
                                                  r: r) else { return nil }
        guard b else { return false }
    } else if let _ = c1.rightSuccessor { return false }
    return true
}

func bifurcateEquivalent<
    C0: Readable & BidirectionalBifurcateCoordinate,
    C1: Readable & BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1,
    r: Relation<C0.Source>
) -> Bool?
where C0.Source == C1.Source {
    var c0 = c0, c1 = c1
    // Precondition: readable_tree(c0) ∧ readable_tree(c1)
    // Precondition: equivalence(r)
    guard !c0.isEmpty() else { return c1.isEmpty() }
    guard !c1.isEmpty() else { return false }
    let root0 = c0
    var v0 = Visit.pre
    var v1 = Visit.pre
    while true {
        guard let c0src = c0.source,
              let c1src = c1.source else { return nil }
        guard !(v0 == .pre && !r(c0src, c1src)) else { return false }
        guard let _ = traverseStep(v: &v0, c: &c0),
              let _ = traverseStep(v: &v1, c: &c1) else { return nil }
        guard v0 == v1 else { return false }
        if c0 == root0 && v0 == .post { return true }
    }
}

func bifurcateEqual<
    C0: Readable & BidirectionalBifurcateCoordinate,
    C1: Readable & BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1
) -> Bool?
where C0.Source == C1.Source {
    return bifurcateEquivalent(c0: c0, c1: c1, r: equal)
}

func lexicographicalCompare<
    I0: Readable & Iterator,
    I1: Readable & Iterator
>(
    f0: I0, l0: I0,
    f1: I1, l1: I1,
    r: Relation<I0.Source>
) -> Bool?
where I0.Source == I1.Source {
    var f0 = f0, f1 = f1
    // Precondition: readable_bounded_range(f0, l0)
    // Precondition: readable_bounded_range(f1, l1)
    // Precondition: weak_ordering(r)
    while true {
        guard f1 != l1 else { return false }
        guard f0 != l0 else { return true }
        guard let f0src = f0.source,
              let f1src = f1.source else { return nil }
        guard !r(f0src, f1src) else { return true }
        guard !r(f1src, f0src) else { return false }
        guard let f0s = f0.iteratorSuccessor,
              let f1s = f1.iteratorSuccessor else { return nil }
        f0 = f0s
        f1 = f1s
    }
}

func lexicographicalLess<
    I0: Readable & Iterator,
    I1: Readable & Iterator
>(
    f0: I0, l0: I0,
    f1: I1, l1: I1
) -> Bool?
where I0.Source == I1.Source {
    return lexicographicalCompare(f0: f0, l0: l0,
                                  f1: f1, l1: l1,
                                  r: less)
}

func lexicographicalLess<
    I0: Readable & ForwardIterator,
    I1: Readable & ForwardIterator
>(
    k: Int,
    f0: I0,
    f1: I1
) -> Bool?
where I0.Source == I1.Source {
    guard k != 0 else { return false }
    guard let f0src = f0.source,
          let f1src = f1.source else { return nil }
    guard f0src >= f1src else { return true }
    guard f0src <= f1src else { return false }
    guard let f0s = f0.iteratorSuccessor,
          let f1s = f1.iteratorSuccessor else { return nil }
    return lexicographicalLess(k: k - 1, f0: f0s, f1: f1s)
}


// Exercise 7.6: bifurcate_compare_nonempty (using 3-way comparsion)

// concept Comparator3Way(F) is
//     HomogeneousFunction(F)
//  /\ Arity(F) = 2
//  /\ Codomain(F) = int

// property(F : Comparator3Way)
// three_way_compare : F
//  f |- (all a,b in Domain(F)) f(a, b) in {-1, 0, 1}

//  Also need axioms equivalent to weak_order : transitivity, etc.
//  We could relax this to OrderedAdditiveGroup
//  (allowing subtraction as the comparator for numbers)
//  Should sense of positive/negative be flipped?


func comparatorThreeWay<DomainR: Regular>(
    r: @escaping Relation<DomainR>
) -> BinaryHomogeneousFunction<DomainR, Int> {
    // Precondition: weak_ordering(r)
    // Postcondition: three_way_compare(comparator_3_way(r))
    return { a, b in
        if r(a, b) { return 1 }
        if r(b, a) { return -1 }
        return 0
    }
}

func lexicographicalCompareThreeWay<
    I0: Readable & Iterator,
    I1: Readable & Iterator
>(
    f0: I0, l0: I0,
    f1: I1, l1: I1,
    comp: BinaryHomogeneousFunction<I0.Source, Int>
) -> Int?
where I0.Source == I1.Source {
    var f0 = f0, f1 = f1
    // Precondition: readable_bounded_range(f0, l0)
    // Precondition: readable_bounded_range(f1, l1)
    // Precondition: three_way_compare(comp)
    while true {
        guard f0 != l0 else {
            guard f1 == l1 else { return 1 }
            return 0
        }
        guard f1 != l1 else { return -1 }
        guard let f0src = f0.source,
              let f1src = f1.source else { return nil }
        let tmp = comp(f0src, f1src)
        guard tmp == 0 else { return tmp }
        guard let f0s = f0.iteratorSuccessor,
              let f1s = f1.iteratorSuccessor else { return nil }
        f0 = f0s
        f1 = f1s
    }
}

func bifurcateCompareNonempty<
    C0: Readable & BifurcateCoordinate,
    C1: Readable & BifurcateCoordinate
>(
    c0: C0,
    c1: C1,
    comp: BinaryHomogeneousFunction<C0.Source, Int>
) -> Int?
where C0.Source == C1.Source {
    // Precondition: readable_tree(c0) ∧ readable_tree(c1)
    // Precondition: ￢empty(c0) ∧ ￢empty(c1)
    // Precondition: three_way_compare(comp)
    guard let c0src = c0.source,
          let c1src = c1.source else { return nil }
    var tmp = comp(c0src, c1src)
    guard tmp == 0 else { return tmp }
    if let c0ls = c0.leftSuccessor {
        guard let c1ls = c1.leftSuccessor else { return -1 }
        guard let t = bifurcateCompareNonempty(c0: c0ls,
                                               c1: c1ls,
                                               comp: comp) else { return nil }
        tmp = t
        guard tmp == 0 else { return tmp }
    } else if let _ = c1.leftSuccessor { return 1 }
    if let c0rs = c0.rightSuccessor {
        guard let c1rs = c1.rightSuccessor else { return -1 }
        guard let t = bifurcateCompareNonempty(c0: c0rs,
                                               c1: c1rs,
                                               comp: comp) else { return nil }
        tmp = t
        guard tmp == 0 else { return tmp }
    } else if let _ = c1.rightSuccessor { return 1 }
    return 0
}

func bifurcateCompare<
    C0: Readable & BidirectionalBifurcateCoordinate,
    C1: Readable & BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1,
    r: Relation<C0.Source>
) -> Bool?
where C0.Source == C1.Source {
    var c0 = c0, c1 = c1
    // Precondition: readable_tree(c0) ∧ readable_tree(c1) ∧ weak_ordering(r)
    guard !c1.isEmpty() else { return false }
    guard !c0.isEmpty() else { return true }
    let root0 = c0
    var v0 = Visit.pre
    var v1 = Visit.pre
    while true {
        if v0 == .pre {
            guard let c0src = c0.source,
                  let c1src = c1.source else { return nil }
            guard !r(c0src, c1src) else { return true }
            guard !r(c1src, c0src) else { return false }
        }
        guard let _ = traverseStep(v: &v0, c: &c0),
              let _ = traverseStep(v: &v1, c: &c1) else { return nil }
        guard v0 == v1 else { return v0 > v1 }
        if c0 == root0 && v0 == .post { return false }
    }
}

func bifurcateLess<
    C0: Readable & BidirectionalBifurcateCoordinate,
    C1: Readable & BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1
) -> Bool?
where C0.Source == C1.Source {
    // Precondition: readable_tree(c0) ∧ readable_tree(c1)
    let ls: Relation<C0.Source> = less
    return bifurcateCompare(c0: c0, c1: c1, r: ls)
}

func alwaysFalse<T: Regular>(x: T, y: T) -> Bool {
    return false
}

func bifurcateShapeCompare<
    C0: Readable & BidirectionalBifurcateCoordinate,
    C1: Readable & BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1
) -> Bool?
where C0.Source == C1.Source {
    // Precondition: readable_tree(c0) ∧ readable_tree(c1)
    return bifurcateCompare(c0: c0, c1: c1, r: alwaysFalse)
}
