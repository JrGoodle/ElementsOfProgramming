//
//  Chapter03.swift
//  ElementsOfProgramming
//

func powerLeftAssociated<DomainOp: RegularType>(a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    // Precondition: $n > 0$
    if n == Integer(1) { return a }
    return op(powerLeftAssociated(a: a, n: n - Integer(1), op: op), a)
}

func powerRightAssociated<DomainOp: RegularType>(a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    // Precondition: $n > 0$
    if n == Integer(1) { return a }
    return op(a, powerRightAssociated(a: a, n: n - Integer(1), op: op))
}

func power0<DomainOp: RegularType>(a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    // Precondition: $\func{associative}(op) \wedge n > 0$
    if n == Integer(1) { return a }
    if n % Integer(2) == Integer(0) {
        return power0(a: op(a, a), n: n / Integer(2), op: op);
    }
    return op(power0(a: op(a, a), n: n / Integer(2), op: op), a);
}

func power1<DomainOp: RegularType>(a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    // Precondition: $\func{associative}(op) \wedge n > 0$
    if n == Integer(1) { return a }
    var r = power1(a: op(a, a), n: n / Integer(2), op: op)
    if n % Integer(2) != Integer(0) { r = op(r, a) }
    return r
}

func powerAccumulate0<DomainOp: RegularType>(r: DomainOp, a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    var _r = r
    // Precondition: $\func{associative}(op) \wedge n \geq 0$
    if n == Integer(0) { return _r }
    if n % Integer(2) != Integer(0) { _r = op(_r, a) }
    return powerAccumulate0(r: _r, a: op(a, a), n: n / Integer(2), op: op)
}

func powerAccumulate1<DomainOp: RegularType>(r: DomainOp, a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    var _r = r
    // Precondition: $\func{associative}(op) \wedge n \geq 0$
    if n == Integer(0) { return _r }
    if n == Integer(1) { return op(_r, a) }
    if n % Integer(2) != Integer(0) { _r = op(_r, a) }
    return powerAccumulate1(r: _r, a: op(a, a), n: n / Integer(2), op: op)
}

func powerAccumulate2<DomainOp: RegularType>(r: DomainOp, a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    var _r = r
    // Precondition: $\func{associative}(op) \wedge n \geq 0$
    if n % Integer(2) != Integer(0) {
        _r = op(_r, a)
        if n == Integer(1) { return _r }
    } else if n == Integer(0) {
        return _r
    }
    return powerAccumulate2(r: _r, a: op(a, a), n: n / Integer(2), op: op)
}

func powerAccumulate3<DomainOp: RegularType>(r: DomainOp, a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    var _r = r, _a = a, _n = n
    // Precondition: $\func{associative}(op) \wedge n \geq 0$
    if _n % Integer(2) != Integer(0) {
        _r = op(_r, _a)
        if _n == Integer(1) { return _r }
    } else if _n == Integer(0) {
        return _r
    }
    _a = op(_a, _a)
    _n = _n / Integer(2)
    return powerAccumulate3(r: _r, a: _a, n: _n, op: op)
}

func powerAccumulate4<DomainOp: RegularType>(r: DomainOp, a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    var _r = r, _a = a, _n = n
    // Precondition: $\func{associative}(op) \wedge n \geq 0$
    while true {
        if _n % Integer(2) != Integer(0) {
            _r = op(_r, _a)
            if _n == Integer(1) { return _r }
        } else if _n == Integer(0) {
            return _r
        }
        _a = op(_a, _a)
        _n = _n / Integer(2)
    }
}

func powerAccumulatePositive0<DomainOp: RegularType>(r: DomainOp, a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    var _r = r, _a = a, _n = n
    // Precondition: $\func{associative}(op) \wedge n > 0$
    while true {
        if _n % Integer(2) != Integer(0) {
            _r = op(_r, _a)
            if _n == Integer(1) { return _r }
        }
        _a = op(_a, _a)
        _n = _n / Integer(2)
    }
}

func powerAccumulate5<DomainOp: RegularType>(r: DomainOp, a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    // Precondition: $\func{associative}(op) \wedge n \geq 0$
    if n == Integer(0) { return r }
    return powerAccumulatePositive0(r: r, a: a, n: n, op: op)
}

func power2<DomainOp: RegularType>(a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    // Precondition: $\func{associative}(op) \wedge n > 0$
    return powerAccumulate5(r: a, a: a, n: n - Integer(1), op: op)
}

func power3<DomainOp: RegularType>(a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    var _a = a, _n = n
    // Precondition: $\func{associative}(op) \wedge n > 0$
    while n % Integer(2) == Integer(0) {
        _a = op(_a, _a)
        _n = _n / Integer(2)
    }
    _n = _n / Integer(2)
    if _n == Integer(0) { return a }
    return powerAccumulatePositive0(r: _a, a: op(_a, _a), n: _n, op: op)
}

func powerAccumulatePositive<DomainOp: RegularType>(r: DomainOp, a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    var _r = r, _a = a, _n = n
    // Precondition: $\func{associative}(op) \wedge \func{positive}(n)$
    while true {
        if _n.odd() {
            _r = op(_r, _a)
            if _n.one() { return r }
        }
        _a = op(_a, _a)
        _n = _n.halfNonnegative()
    }
}

func powerAccumulate<DomainOp: RegularType>(r: DomainOp, a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    // Precondition: $\func{associative}(op) \wedge \neg \func{negative}(n)$
    if n.zero() { return r }
    return powerAccumulatePositive(r: r, a: a, n: n, op: op)
}

func power<DomainOp: RegularType>(a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>) -> DomainOp {
    var _a = a, _n = n
    // Precondition: $\func{associative}(op) \wedge \func{positive}(n)$
    while _n.even() {
        _a = op(_a, _a)
        _n = _n.halfNonnegative()
    }
    _n = _n.halfNonnegative()
    if _n.zero() { return _a }
    return powerAccumulatePositive(r: _a, a: op(_a, _a), n: _n, op: op)
}

func power<DomainOp: RegularType>(a: DomainOp, n: Integer, op: BinaryOperation<DomainOp>, id: DomainOp) -> DomainOp {
    // Precondition: $\func{associative}(op) \wedge \neg \func{negative}(n)$
    if n.zero() { return id }
    return power(a: a, n: n, op: op)
}

func fibonacciMatrixMultiply(x: Pair<Integer, Integer>, y: Pair<Integer, Integer>) -> Pair<Integer, Integer> {
    return Pair(m0: x.m0 * (y.m1 + y.m0) + x.m1 * y.m0,
                m1: x.m0 * y.m0 + x.m1 * y.m1)
}

func fibonacci(n: Integer) -> Integer {
    // Precondition: $n \geq 0$
    if n == Integer(0) { return Integer(0) }
    return power(a: Pair(m0: Integer(1), m1: Integer(0)),
                 n: n,
                 op: fibonacciMatrixMultiply).m0
}
