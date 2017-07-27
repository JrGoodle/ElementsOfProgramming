//
//  Chapter03.swift
//  ElementsOfProgramming
//

func powerLeftAssociated<DomainOp: Regular>(
    a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    assert(n > 0)
    if n == 1 { return a }
    return op(powerLeftAssociated(a: a, n: n - 1, op: op), a)
}

func powerRightAssociated<DomainOp: Regular>(
    a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    assert(n > 0)
    if n == 1 { return a }
    return op(a, powerRightAssociated(a: a, n: n - 1, op: op))
}

func power0<DomainOp: Regular>(
    a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n > 0)
    if n == 1 { return a }
    if n % 2 == 0 {
        return power0(a: op(a, a), n: n / 2, op: op)
    }
    return op(power0(a: op(a, a), n: n / 2, op: op), a)
}

func power1<DomainOp: Regular>(
    a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n > 0)
    if n == 1 { return a }
    var r = power1(a: op(a, a), n: n / 2, op: op)
    if n % 2 != 0 { r = op(r, a) }
    return r
}

func powerAccumulate0<DomainOp: Regular>(
    r: DomainOp, a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r
    // Precondition: associative(op)
    assert(n >= 0)
    if n == 0 { return r }
    if n % 2 != 0 { r = op(r, a) }
    return powerAccumulate0(r: r, a: op(a, a), n: n / 2, op: op)
}

func powerAccumulate1<DomainOp: Regular>(
    r: DomainOp, a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r
    // Precondition: associative(op)
    assert(n >= 0)
    if n == 0 { return r }
    if n == 1 { return op(r, a) }
    if n % 2 != 0 { r = op(r, a) }
    return powerAccumulate1(r: r, a: op(a, a), n: n / 2, op: op)
}

func powerAccumulate2<DomainOp: Regular>(
    r: DomainOp, a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r
    // Precondition: associative(op)
    assert(n >= 0)
    if n % 2 != 0 {
        r = op(r, a)
        if n == 1 { return r }
    } else if n == 0 {
        return r
    }
    return powerAccumulate2(r: r, a: op(a, a), n: n / 2, op: op)
}

func powerAccumulate3<DomainOp: Regular>(
    r: DomainOp, a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r, a = a, n = n
    // Precondition: associative(op)
    assert(n >= 0)
    if n % 2 != 0 {
        r = op(r, a)
        if n == 1 { return r }
    } else if n == 0 {
        return r
    }
    a = op(a, a)
    n = n / 2
    return powerAccumulate3(r: r, a: a, n: n, op: op)
}

func powerAccumulate4<DomainOp: Regular>(
    r: DomainOp, a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r, a = a, n = n
    // Precondition: associative(op)
    assert(n >= 0)
    while true {
        if n % 2 != 0 {
            r = op(r, a)
            if n == 1 { return r }
        } else if n == 0 {
            return r
        }
        a = op(a, a)
        n = n / 2
    }
}

func powerAccumulatePositive0<DomainOp: Regular>(
    r: DomainOp, a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r, a = a, n = n
    // Precondition: associative(op)
    assert(n > 0)
    while true {
        if n % 2 != 0 {
            r = op(r, a)
            if n == 1 { return r }
        }
        a = op(a, a)
        n = n / 2
    }
}

func powerAccumulate5<DomainOp: Regular>(
    r: DomainOp, a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n >= 0)
    if n == 0 { return r }
    return powerAccumulatePositive0(r: r, a: a, n: n, op: op)
}

func power2<DomainOp: Regular>(
    a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n > 0)
    return powerAccumulate5(r: a, a: a, n: n - 1, op: op)
}

func power3<DomainOp: Regular>(
    a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    var a = a, n = n
    // Precondition: associative(op)
    assert(n > 0)
    while n % 2 == 0 {
        a = op(a, a)
        n = n / 2
    }
    n = n / 2
    if n == 0 { return a }
    return powerAccumulatePositive0(r: a, a: op(a, a), n: n, op: op)
}

func powerAccumulatePositive<DomainOp: Regular>(
    r: DomainOp, a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r, a = a, n = n
    // Precondition: associative(op)
    assert(n > 0)
    while true {
        if n.isOdd() {
            r = op(r, a)
            if n.isEqualToOne() { return r }
        }
        a = op(a, a)
        n = n.halfNonnegative()
    }
}

func powerAccumulate<DomainOp: Regular>(
    r: DomainOp, a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n >= 0)
    if n.isEqualToZero() { return r }
    return powerAccumulatePositive(r: r, a: a, n: n, op: op)
}

func power<DomainOp: Regular>(
    a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>
) -> DomainOp {
    var a = a, n = n
    // Precondition: associative(op)
    assert(n > 0)
    while n.isEven() {
        a = op(a, a)
        n = n.halfNonnegative()
    }
    n = n.halfNonnegative()
    if n.isEqualToZero() { return a }
    return powerAccumulatePositive(r: a, a: op(a, a), n: n, op: op)
}

func power<DomainOp: Regular>(
    a: DomainOp,
    n: Int,
    op: BinaryOperation<DomainOp>,
    id: DomainOp
) -> DomainOp {
    // Precondition: associative(op)
    assert(n >= 0)
    if n.isEqualToZero() { return id }
    return power(a: a, n: n, op: op)
}

func fibonacciMatrixMultiply(
    x: Pair<Int, Int>,
    y: Pair<Int, Int>
) -> Pair<Int, Int> {
    return Pair(m0: x.m0 * (y.m1 + y.m0) + x.m1 * y.m0,
                m1: x.m0 * y.m0 + x.m1 * y.m1)
}

func fibonacci(n: Int) -> Int {
    assert(n >= 0)
    if n == 0 { return 0 }
    return power(a: Pair(m0: 1, m1: 0),
                 n: n,
                 op: fibonacciMatrixMultiply).m0
}
