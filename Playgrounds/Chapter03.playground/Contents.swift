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
    guard n != 1 else { return a }
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
    guard n != 1 else { return a }
    let pra = powerRightAssociated(a,
                                   power: n - 1,
                                   operation: op)
    return op(a, pra)
}

func power_0<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n > 0)
    guard n != 1 else { return a }
    guard n % 2 != 0 else {
        return power_0(op(a, a),
                       power: n / 2,
                       operation: op)
    }
    let p0 = power_0(op(a, a),
                     power: n / 2,
                     operation: op)
    return op(p0, a)
}

func power_1<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n > 0)
    guard n != 1 else { return a }
    var r = power_1(op(a, a),
                    power: n / 2,
                    operation: op)
    if n % 2 != 0 { r = op(r, a) }
    return r
}

func powerAccumulate_0<DomainOp: Regular>(
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r
    // Precondition: associative(op)
    assert(n >= 0)
    guard n != 0 else { return r }
    if n % 2 != 0 { r = op(r, a) }
    return powerAccumulate_0(op(a, a),
                             accumulate: r,
                             power: n / 2,
                             operation: op)
}

func powerAccumulate_1<DomainOp: Regular>(
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    var r = r
    // Precondition: associative(op)
    assert(n >= 0)
    guard n != 0 else { return r }
    guard n != 1 else { return op(r, a) }
    if n % 2 != 0 { r = op(r, a) }
    return powerAccumulate_1(op(a, a),
                             accumulate: r,
                             power: n / 2,
                             operation: op)
}

func powerAccumulate_2<DomainOp: Regular>(
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
        guard n != 1 else { return r }
    } else if n == 0 {
        return r
    }
    return powerAccumulate_2(op(a, a),
                             accumulate: r,
                             power: n / 2,
                             operation: op)
}

func powerAccumulate_3<DomainOp: Regular>(
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
        guard n != 1 else { return r }
    } else if n == 0 {
        return r
    }
    a = op(a, a)
    n = n / 2
    return powerAccumulate_3(a,
                             accumulate: r,
                             power: n,
                             operation: op)
}

func powerAccumulate_4<DomainOp: Regular>(
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
            guard n != 1 else { return r }
        } else if n == 0 {
            return r
        }
        a = op(a, a)
        n = n / 2
    }
}

func powerAccumulatePositive_0<DomainOp: Regular>(
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

func powerAccumulate_5<DomainOp: Regular>(
    _ a: DomainOp,
    accumulate r: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n >= 0)
    guard n != 0 else { return r }
    return powerAccumulatePositive_0(a,
                                     accumulate: r,
                                     power: n,
                                     operation: op)
}

func power_2<DomainOp: Regular>(
    _ a: DomainOp,
    power n: Int,
    operation op: BinaryOperation<DomainOp>
) -> DomainOp {
    // Precondition: associative(op)
    assert(n > 0)
    return powerAccumulate_5(a,
                             accumulate: a,
                             power: n - 1,
                             operation: op)
}

func power_3<DomainOp: Regular>(
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
    guard n != 0 else { return a }
    return powerAccumulatePositive_0(op(a, a),
                                     accumulate: a,
                                     power: n,
                                     operation: op)
}

// Exercise 3.2 - Implement special case procedures for Int types
// See IntegerSpecialCaseProcedures and BinaryIntegerSpecialCaseProcedures
// protocols in EOP/Types/IntegerSpecialCaseProcedures.swift and
// type extensions on Int types in EOP/Types

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
            if n == 1 { return r }
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
    guard n != 0 else { return r }
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
    guard n != 0 else { return a }
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
    guard n != 0 else { return id }
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
    guard n != 0 else { return 0 }
    return power(Pair(m0: 1, m1: 0),
                 power: n,
                 operation: fibonacciMatrixMultiply).m0
}
