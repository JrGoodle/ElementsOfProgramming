//
//  Chapter03.swift
//  ElementsOfProgramming
//


func powerLeftAssociated<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    assert(n > 0)
    if n == 1 { return a }
    let pla = powerLeftAssociated(a,
                                  power: n - 1,
                                  operation: op)
    return op(pla, a)
}

func powerRightAssociated<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    assert(n > 0)
    if n == 1 { return a }
    let pra = powerRightAssociated(a,
                                   power: n - 1,
                                   operation: op)
    return op(a, pra)
}

func power0<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n > 0)
    if n == 1 { return a }
    if n % 2 == 0 {
        return power0(op(a, a),
                      power: n / 2,
                      operation: op)
    }
    return op(power0(op(a, a),
                     power: n / 2,
                     operation: op), a)
}

func power1<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n > 0)
    if n == 1 { return a }
    var r = power1(op(a, a),
                   power: n / 2,
                   operation: op)
    if n % 2 != 0 { r = op(r, a) }
    return r
}

func powerAccumulate0<DomainOp: Regular>(
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r
    // Precondition: associative(op)
    assert(n >= 0)
    if n == 0 { return r }
    if n % 2 != 0 { r = op(r, a) }
    return powerAccumulate0(op(a, a),
                            accumulate: r,
                            power: n / 2,
                            operation: op)
}

func powerAccumulate1<DomainOp: Regular>(
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r
    // Precondition: associative(op)
    assert(n >= 0)
    if n == 0 { return r }
    if n == 1 { return op(r, a) }
    if n % 2 != 0 { r = op(r, a) }
    return powerAccumulate1(op(a, a),
                            accumulate: r,
                            power: n / 2,
                            operation: op)
}

func powerAccumulate2<DomainOp: Regular>(
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
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
    return powerAccumulate2(op(a, a),
                            accumulate: r,
                            power: n / 2,
                            operation: op)
}

func powerAccumulate3<DomainOp: Regular>(
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
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
    return powerAccumulate3(a,
                            accumulate: r,
                            power: n,
                            operation: op)
}

func powerAccumulate4<DomainOp: Regular>(
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
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
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
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
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n >= 0)
    if n == 0 { return r }
    return powerAccumulatePositive0(a,
                                    accumulate: r,
                                    power: n,
                                    operation: op)
}

func power2<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n > 0)
    return powerAccumulate5(a,
                            accumulate: a,
                            power: n - 1,
                            operation: op)
}

func power3<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
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
    return powerAccumulatePositive0(op(a, a),
                                    accumulate: a,
                                    power: n,
                                    operation: op)
}

func powerAccumulatePositive<DomainOp: Regular>(
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r, a = a, n = n
    // Precondition: associative(op)
    assert(n > 0)
    while true {
        if n.isOdd() {
            r = op(r, a)
            if n.isOne() { return r }
        }
        a = op(a, a)
        n = n.halfNonnegative()
    }
}

func powerAccumulate<DomainOp: Regular>(
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n >= 0)
    if n.isZero() { return r }
    return powerAccumulatePositive(a,
                                   accumulate: r,
                                   power: n,
                                   operation: op)
}

func power<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    var a = a, n = n
    // Precondition: associative(op)
    assert(n > 0)
    while n.isEven() {
        a = op(a, a)
        n = n.halfNonnegative()
    }
    n = n.halfNonnegative()
    if n.isZero() { return a }
    return powerAccumulatePositive(op(a, a),
                                   accumulate: a,
                                   power: n,
                                   operation: op)
}

func power<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>,
    id: DomainOp
) -> DomainOp {
    // Precondition: associative(op)
    assert(n >= 0)
    if n.isZero() { return id }
    return power(a,
                 power: n,
                 operation: op)
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
    return power(Pair(m0: 1, m1: 0),
                 power: n,
                 operation: fibonacciMatrixMultiply).m0
}
