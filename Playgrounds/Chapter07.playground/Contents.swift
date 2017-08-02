//
//  Chapter07.swift
//  ElementsOfProgramming
//


func weightRecursive<C: BifurcateCoordinate>(c: C) -> WeightType {
    // Precondition: tree(c)
    if c.isEmpty() { return N(0) }
    var l = N(0)
    var r = N(0)
    if c.hasLeftSuccessor() {
        l = weightRecursive(c: c.leftSuccessor!)
    }
    if c.hasRightSuccessor() {
        r = weightRecursive(c: c.rightSuccessor!)
    }
    let t = l + r
    return t.successor()
}

func heightRecursive<C: BifurcateCoordinate>(c: C) -> WeightType {
    // Precondition: tree(c)
    if c.isEmpty() { return N(0) }
    var l = N(0)
    var r = N(0)
    if c.hasLeftSuccessor() {
        l = heightRecursive(c: c.leftSuccessor!)
    }
    if c.hasRightSuccessor() {
        r = heightRecursive(c: c.rightSuccessor!)
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
    if c.hasLeftSuccessor() {
        proc = traverseNonempty(c: c.leftSuccessor!, proc: proc)
    }
    proc.call(.in, c)
    if c.hasRightSuccessor() {
        proc = traverseNonempty(c: c.rightSuccessor!, proc: proc)
    }
    proc.call(.post, c)
    return proc
}

func isLeftSuccessor<T: BidirectionalBifurcateCoordinate>(j: T) -> Bool {
    // Precondition: has_predecessor(j)
    let i = j.iteratorPredecessor!
    return i.hasLeftSuccessor() && i.leftSuccessor! == j
}

func isRightSuccessor<T: BidirectionalBifurcateCoordinate>(j: T) -> Bool {
    // Precondition: has_predecessor(j)
    let i = j.iteratorPredecessor!
    return i.hasRightSuccessor() && i.rightSuccessor! == j
}

func traverseStep<C: BidirectionalBifurcateCoordinate>(
    v: inout Visit,
    c: inout C
) -> Int {
    // Precondition: has_predecessor(c) ∨ v ≠ post
    switch v {
    case .pre:
        if c.hasLeftSuccessor() {
            c = c.leftSuccessor!
            return 1
        }
        v = .in
        return 0
    case .in:
        if c.hasRightSuccessor() {
            v = .pre
            c = c.rightSuccessor!
            return 1
        }
        v = .post
        return 0
    case .post:
        if isLeftSuccessor(j: c) {
            v = .in
        }
        c = c.iteratorPredecessor!
        return -1
    }
}

func reachable<C: BidirectionalBifurcateCoordinate>(
    x: C, y: C
) -> Bool {
    var x = x
    // Precondition: tree(x)
    if x.isEmpty() { return false }
    let root = x
    var v = Visit.pre
    repeat {
        if x == y { return true }
        _ = traverseStep(v: &v, c: &x)
    } while x != root || v != .post
    return false
}

func weight<C: BidirectionalBifurcateCoordinate>(c: C) -> WeightType {
    var c = c
    // Precondition: tree(c)
    if c.isEmpty() { return N(0) }
    let root = c
    var v = Visit.pre
    var n = N(1) // Invariant: n is count of .pre visits so far
    repeat {
        _ = traverseStep(v: &v, c: &c)
        if v == .pre { n = n.successor() }
    } while c != root || v != .post
    return n
}

func height<C: BidirectionalBifurcateCoordinate>(c: C) -> WeightType {
    var c = c
    // Precondition: tree(c)
    if c.isEmpty() { return N(0) }
    let root = c
    var v = Visit.pre
    var n = N(1) // Invariant: n is max of height of .pre visits so far
    var m = N(1) // Invariant: m is height of current .pre visit
    repeat {
        m = (m - N(1)) + N(traverseStep(v: &v, c: &c) + 1)
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
) -> P
where P.BinaryProcedureType1 == Visit, P.BinaryProcedureType2 == C {
    var c = c
    // Precondition: tree(c)
    if c.isEmpty() { return proc }
    let root = c
    var v = Visit.pre
    proc.call(.pre, c)
    repeat {
        _ = traverseStep(v: &v, c: &c)
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
    if c0.hasLeftSuccessor() {
        if c1.hasLeftSuccessor() {
            if !bifurcateIsomorphicNonempty(c0: c0.leftSuccessor!,
                                            c1: c1.leftSuccessor!) {
                return false
            }
        } else { return false }
    } else if c1.hasLeftSuccessor() { return false }
    
    if c0.hasRightSuccessor() {
        if c0.hasRightSuccessor() {
            if !bifurcateIsomorphicNonempty(c0: c0.rightSuccessor!,
                                            c1: c1.rightSuccessor!) {
                return false
            }
        } else { return false }
    } else if c1.hasRightSuccessor() { return false }
    
    return true
}

func bifurcateIsomorphic<
    C0: BidirectionalBifurcateCoordinate,
    C1: BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1
) -> Bool {
    var c0 = c0, c1 = c1
    // Precondition: tree(c0) ∧ tree(c1)
    if c0.isEmpty() { return c1.isEmpty() }
    if c1.isEmpty() { return false }
    let root0 = c0
    var v0 = Visit.pre
    var v1 = Visit.pre
    while true {
        _ = traverseStep(v: &v0, c: &c0)
        _ = traverseStep(v: &v1, c: &c1)
        if v0 != v1 { return false }
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
) -> Bool
where I0.Source == I1.Source {
    // Precondition: readable_bounded_range(f0, l0)
    // Precondition: readable_bounded_range(f1, l1)
    // Precondition: equivalence(r)
    let p: Pair<I0, I1> = findMismatch(f0: f0, l0: l0,
                                       f1: f1, l1: l1,
                                       r: r)
    return p.m0 == l0 && p.m1 == l1
}

func lexicographicalEqual<
    I0: Readable & Iterator,
    I1: Readable & Iterator
>(
    f0: I0, l0: I0,
    f1: I1, l1: I1
) -> Bool
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
) -> Bool
where I0.Source == I1.Source {
    if k == 0 { return true }
    if f0.source! != f1.source! { return false }
    return lexicographicalEqual(k: k - 1,
                                f0: f0.iteratorSuccessor!,
                                f1: f1.iteratorSuccessor!)
}

func bifurcateEquivalentNonempty<
    C0: Readable & BifurcateCoordinate,
    C1: Readable & BifurcateCoordinate
>(
    c0: C0,
    c1: C1,
    r: Relation<C0.Source>
) -> Bool
where C0.Source == C1.Source {
    // Precondition: readable_tree(c0) ∧ readable_tree(c1)
    // Precondition: ￢empty(c0) ∧ ￢empty(c1)
    // Precondition: equivalence(r)
    if !r(c0.source!, c1.source!) { return false }
    if c0.hasLeftSuccessor() {
        if c1.hasLeftSuccessor() {
            if !bifurcateEquivalentNonempty(c0: c0.leftSuccessor!,
                                            c1: c1.leftSuccessor!,
                                            r: r) {
                return false
            }
        } else { return false }
    } else if c1.hasLeftSuccessor() { return false }
    
    if c0.hasRightSuccessor() {
        if c1.hasRightSuccessor() {
            if !bifurcateEquivalentNonempty(c0: c0.rightSuccessor!,
                                            c1: c1.rightSuccessor!,
                                            r: r) {
                return false
            }
        } else { return false }
    } else if c1.hasRightSuccessor() { return false }
    
    return true
}

func bifurcateEquivalent<
    C0: Readable & BidirectionalBifurcateCoordinate,
    C1: Readable & BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1,
    r: Relation<C0.Source>
) -> Bool
where C0.Source == C1.Source {
    var c0 = c0, c1 = c1
    // Precondition: readable_tree(c0) ∧ readable_tree(c1)
    // Precondition: equivalence(r)
    if c0.isEmpty() { return c1.isEmpty() }
    if c1.isEmpty() { return false }
    let root0 = c0
    var v0 = Visit.pre
    var v1 = Visit.pre
    while true {
        if v0 == .pre && !r(c0.source!, c1.source!) {
            return false
        }
        _ = traverseStep(v: &v0, c: &c0)
        _ = traverseStep(v: &v1, c: &c1)
        if v0 != v1 { return false }
        if c0 == root0 && v0 == .post { return true }
    }
}

func bifurcateEqual<
    C0: Readable & BidirectionalBifurcateCoordinate,
    C1: Readable & BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1
) -> Bool
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
) -> Bool
where I0.Source == I1.Source {
    var f0 = f0, f1 = f1
    // Precondition: readable_bounded_range(f0, l0)
    // Precondition: readable_bounded_range(f1, l1)
    // Precondition: weak_ordering(r)
    while true {
        if f1 == l1 { return false }
        if f0 == l0 { return true }
        if r(f0.source!, f1.source!) { return true }
        if r(f1.source!, f0.source!) { return false }
        f0 = f0.iteratorSuccessor!
        f1 = f1.iteratorSuccessor!
    }
}

func lexicographicalLess<
    I0: Readable & Iterator,
    I1: Readable & Iterator
>(
    f0: I0, l0: I0,
    f1: I1, l1: I1
) -> Bool
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
) -> Bool
where I0.Source == I1.Source {
    if k == 0 { return false }
    if f0.source! < f1.source! { return true }
    if f0.source! > f1.source! { return false }
    return lexicographicalLess(k: k - 1, f0: f0.iteratorSuccessor!, f1: f1.iteratorSuccessor!)
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
) -> Int
where I0.Source == I1.Source {
    var f0 = f0, f1 = f1
    // Precondition: readable_bounded_range(f0, l0)
    // Precondition: readable_bounded_range(f1, l1)
    // Precondition: three_way_compare(comp)
    while true {
        if f0 == l0 {
            if f1 == l1 { return 0 }
            else { return 1 }
        }
        if f1 == l1 { return -1 }
        let tmp = comp(f0.source!, f1.source!)
        if tmp != 0 { return tmp }
        f0 = f0.iteratorSuccessor!
        f1 = f1.iteratorSuccessor!
    }
}

func bifurcateCompareNonempty<
    C0: Readable & BifurcateCoordinate,
    C1: Readable & BifurcateCoordinate
>(
    c0: C0,
    c1: C1,
    comp: BinaryHomogeneousFunction<C0.Source, Int>
) -> Int
where C0.Source == C1.Source {
    // Precondition: readable_tree(c0) ∧ readable_tree(c1)
    // Precondition: ￢empty(c0) ∧ ￢empty(c1)
    // Precondition: three_way_compare(comp)
    var tmp = comp(c0.source!, c1.source!)
    if tmp != 0 { return tmp }
    if c0.hasLeftSuccessor() {
        if c1.hasLeftSuccessor() {
            tmp = bifurcateCompareNonempty(c0: c0.leftSuccessor!,
                                           c1: c1.leftSuccessor!,
                                           comp: comp)
            if tmp != 0 { return tmp }
        } else { return -1 }
    } else if c1.hasLeftSuccessor() { return 1 }
    
    if c0.hasRightSuccessor() {
        if c1.hasRightSuccessor() {
            tmp = bifurcateCompareNonempty(c0: c0.rightSuccessor!,
                                           c1: c1.rightSuccessor!,
                                           comp: comp)
            if tmp != 0 { return tmp }
        } else { return -1 }
    } else if c1.hasRightSuccessor() { return 1 }
    
    return 0
}

func bifurcateCompare<
    C0: Readable & BidirectionalBifurcateCoordinate,
    C1: Readable & BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1,
    r: Relation<C0.Source>
) -> Bool
where C0.Source == C1.Source {
    var c0 = c0, c1 = c1
    // Precondition: readable_tree(c0) ∧ readable_tree(c1) ∧ weak_ordering(r)
    if c1.isEmpty() { return false }
    if c0.isEmpty() { return true }
    let root0 = c0
    var v0 = Visit.pre
    var v1 = Visit.pre
    while true {
        if v0 == .pre {
            if r(c0.source!, c1.source!) { return true }
            if r(c1.source!, c0.source!) { return false }
        }
        _ = traverseStep(v: &v0, c: &c0)
        _ = traverseStep(v: &v1, c: &c1)
        if v0 != v1 { return v0 > v1 }
        if c0 == root0 && v0 == .post { return false }
    }
}

func bifurcateLess<
    C0: Readable & BidirectionalBifurcateCoordinate,
    C1: Readable & BidirectionalBifurcateCoordinate
>(
    c0: C0,
    c1: C1
) -> Bool
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
) -> Bool
where C0.Source == C1.Source {
    // Precondition: readable_tree(c0) ∧ readable_tree(c1)
    return bifurcateCompare(c0: c0, c1: c1, r: alwaysFalse)
}