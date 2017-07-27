//
//  Chapter05.swift
//  ElementsOfProgramming
//

func plus<T: AdditiveSemigroup>(x: T, y: T) -> T {
    return x + y
}

func multiplies<T: MultiplicativeSemigroup>(x: T, y: T) -> T {
    return x * y
}

func multipliesTransformation<
    DomainOp: MultiplicativeSemigroup & Distance
>(
    x: DomainOp,
    op: @escaping BinaryOperation<DomainOp>
) -> Transformation<DomainOp> {
    return { y in
        return op(x, y)
    }
}

func negate<T: AdditiveGroup>(x: T) -> T {
    return -x
}

func absoluteValue<T: OrderedAdditiveGroup>(_ a: T) -> T {
    if a < T.additiveIdentity() {
        return -a
    } else {
        return a
    }
}

func slowRemainder<T: CancellableMonoid>(a: T, b: T) -> T {
    var a = a
    precondition(a >= T.additiveIdentity())
    precondition(b > T.additiveIdentity())
    while b <= a {
        a = a - b
    }
    return a
}

func slowQuotient<T: ArchimedeanMonoid>(a: T, b: T) -> QuotientType {
    var a = a
    precondition(a >= T.additiveIdentity())
    precondition(b > T.additiveIdentity())
    var n = QuotientType(0)
    while b <= a {
        a = a - b
        n = n.successor()
    }
    return n
}

func remainderRecursive<T: ArchimedeanMonoid>(a: T, b: T) -> T {
    var a = a
    precondition(a >= b)
    precondition(b > T.additiveIdentity())
    if a - b >= b {
        a = remainderRecursive(a: a, b: b + b)
        if a < b { return a }
    }
    return a - b
}

func remainderNonnegative<T: ArchimedeanMonoid>(a: T, b: T) -> T {
    precondition(a >= T.additiveIdentity())
    precondition(b > T.additiveIdentity())
    if a < b { return a }
    return remainderRecursive(a: a, b: b)
}

/* The next function is due to:
 Robert W. Floyd and Donald E. Knuth.
 Addition machines.
 \emph{SIAM Journal on Computing},
 Volume 19, Number 2, 1990, pages 329--340.
 */

func remainderNonnegativeFibonacci<T: ArchimedeanMonoid>(a: T, b: T) -> T {
    var a = a, b = b
    precondition(a >= T.additiveIdentity())
    precondition(b > T.additiveIdentity())
    if a < b { return a }
    var c = b
    
    repeat {
        let tmp = c
        c = b + c
        b = tmp
    } while a >= c
    
    repeat {
        if a >= b { a = a - b }
        let tmp = c - b
        c = b
        b = tmp
    } while b < c
    
    return a
}

func largestDoubling<T: ArchimedeanMonoid>(a: T, b: T) -> T {
    var b = b
    precondition(a >= b)
    precondition(b > T.additiveIdentity())
    while b <= a - b { b = b + b }
    return b
}

func remainderNonnegativeIterative<T: HalvableMonoid>(a: T, b: T) -> T {
    var a = a
    precondition(a >= T.additiveIdentity())
    precondition(b > T.additiveIdentity())
    if a < b { return a }
    var c = largestDoubling(a: a, b: b)
    a = a - c
    while c != b {
        c = c.half()
        if c <= a { a = a - c }
    }
    return a
}

// Jon Brandt suggested this algorithm (it is not mentioned in chapter 5):

func remainderNonnegativeWithLargestDoubling<
    T: ArchimedeanMonoid
>(
    a: T, b: T
) -> T {
    var a = a
    precondition(a >= T.additiveIdentity())
    precondition(b > T.additiveIdentity())
    while b <= a {
        a = a - largestDoubling(a: a, b: b)
    }
    return a
}

func subtractiveGCDNonzero<T: ArchimedeanMonoid>(a: T, b: T) -> T {
    var a = a, b = b
    precondition(a > T.additiveIdentity())
    precondition(b > T.additiveIdentity())
    while true {
        if b < a {
            a = a - b
        } else if a < b {
            b = b - a
        } else {
            return a
        }
    }
}

func subtractiveGCD<T: EuclideanMonoid>(a: T, b: T) -> T {
    var a = a, b = b
    precondition(a >= T.additiveIdentity())
    precondition(b >= T.additiveIdentity())
    precondition(!(a == T.additiveIdentity() && b == T.additiveIdentity()))
    while true {
        if b == T.additiveIdentity() { return a }
        while b <= a { a = a - b }
        if a == T.additiveIdentity() { return b }
        while a <= b { b = b - a }
    }
}

func fastSubtractiveGCD<T: EuclideanMonoid>(a: T, b: T) -> T {
    var a = a, b = b
    precondition(a >= T.additiveIdentity())
    precondition(b >= T.additiveIdentity())
    precondition(!(a == T.additiveIdentity() && b == T.additiveIdentity()))
    while true {
        if b == T.additiveIdentity() { return a }
        a = remainderNonnegative(a: a, b: b)
        if a == T.additiveIdentity() { return b }
        b = remainderNonnegative(a: b, b: a)
    }
}

func gcdEuclideanSemiring<T: EuclideanSemiring>(a: T, b: T) -> T {
    var a = a, b = b
    precondition(!(a == T.additiveIdentity() && b == T.additiveIdentity()))
    while true {
        if b == T.additiveIdentity() { return a }
        a = a.remainder(b)
        if a == T.additiveIdentity() { return b }
        b = b.remainder(a)
    }
}

func gcdEuclideanSemimodule<T: EuclideanSemimodule>(a: T, b: T) -> T {
    var a = a, b = b
    precondition(!(a == T.additiveIdentity() && b == T.additiveIdentity()))
    while true {
        if b == T.additiveIdentity() { return a }
        a = a.remainder(b)
        if a == T.additiveIdentity() { return b }
        b = b.remainder(a)
    }
}


// Exercise 5.3:

func steinGCDNonnegative(a: Int, b: Int) -> Int {
    var a = a, b = b
    precondition(a >= 0)
    precondition(b >= 0)
    precondition(!(a == 0 && b == 0))
    if a.zero() { return b }
    if b.zero() { return a }
    var d = 0
    while a.even() && b.even() {
        a = a.halfNonnegative()
        b = b.halfNonnegative()
        d = d + 1
    }
    while a.even() { a = a.halfNonnegative() }
    while b.even() { b = b.halfNonnegative() }
    while true {
        if a < b {
            b = b - a
            repeat { b = b.halfNonnegative() } while b.even()
        } else if b < a {
            a = a - b
            repeat { a = a.halfNonnegative() } while a.even()
        } else {
            return a.binaryScaleUpNonnegative(k: d)
        }
    }
}

func quotientRemainderNonnegative<T: ArchimedeanMonoid>(
    a: T, b: T
) -> Pair<QuotientType, T> {
    var a = a
    precondition(a >= T.additiveIdentity())
    precondition(b > T.additiveIdentity())
    typealias N = QuotientType
    if a < b { return Pair(m0: N(0), m1: a) }
    if a - b < b { return Pair(m0: N(1), m1: a - b) }
    let q = quotientRemainderNonnegative(a: a, b: b + b)
    let m = q.m0.twice()
    a = q.m1
    if a < b {
        return Pair(m0: m, m1: a)
    } else {
        return Pair(m0: m.successor(), m1: a - b)
    }
}

func quotientRemainderNonnegativeIterative<T: HalvableMonoid>(
    a: T, b: T
) -> Pair<QuotientType, T> {
    var a = a
    precondition(a >= T.additiveIdentity())
    precondition(b > T.additiveIdentity())
    typealias N = QuotientType
    if a < b { return Pair(m0: N(0), m1: a) }
    var c = largestDoubling(a: a, b: b)
    a = a - c
    var n = N(1)
    while c != b {
        n = n.twice()
        c = c.half()
        if c <= a {
            a = a - c
            n = n.successor()
        }
    }
    return Pair(m0: n, m1: a)
}

func remainder<DomainOp: ArchimedeanGroup>(
    a: DomainOp, b: DomainOp,
    rem: BinaryOperation<DomainOp>
) -> DomainOp {
    typealias T = DomainOp
    precondition(b != T.additiveIdentity())
    var r: T
    if a < T.additiveIdentity() {
        if b < T.additiveIdentity() {
            r = -rem(-a, -b)
        } else {
            r =  rem(-a,  b)
            if r != T.additiveIdentity() { r = b - r }
        }
    } else {
        if b < T.additiveIdentity() {
            r =  rem(a, -b)
            if r != T.additiveIdentity() { r = b + r }
        } else {
            r =  rem(a,  b)
        }
    }
    return r
}

func quotientRemainder<DomainF: ArchimedeanGroup>(
    a: DomainF, b: DomainF,
    quoRem: BinaryHomogeneousFunction<DomainF,Pair<QuotientType, DomainF>>
) -> Pair<QuotientType, DomainF> {
    typealias T = DomainF
    precondition(b != T.additiveIdentity())
    var qr: Pair<QuotientType, T>
    if a < T.additiveIdentity() {
        if b < T.additiveIdentity() {
            qr = quoRem(-a, -b)
            qr.m1 = -qr.m1
        } else {
            qr = quoRem(-a, b)
            if qr.m1 != T.additiveIdentity() {
                qr.m1 = b - qr.m1
                qr.m0 = qr.m0.successor()
            }
            qr.m0 = -qr.m0
        }
    } else {
        if b < T.additiveIdentity() {
            qr = quoRem(a, -b)
            if qr.m1 != T.additiveIdentity() {
                qr.m1 = b + qr.m1
                qr.m0 = qr.m0.successor()
            }
            qr.m0 = -qr.m0
        } else {
            qr = quoRem(a, b)
        }
    }
    return qr
}
