//
//  Concepts.swift
//  ElementsOfProgramming
//

// MARK: Concept
// 1. Other Concepts
// 2. Type Attributes
// 3. Type Functions
// 4. Procedures

// MARK: Chapter 1

protocol Regular: Comparable {} // Equatable

//typealias Procedure<T> = (Any, ...Any) -> Void

//typealias FunctionalProcedure<T> = (Any, ...Any) -> T

//typealias HomogeneousFunction<T, U> = (T, ...T) -> U

typealias UnaryFunction<T: Regular, U: Regular> = (T) -> U

typealias BinaryFunction<T: Regular, U: Regular, V: Regular> = (T, U) -> V

typealias BinaryHomogeneousFunction<T: Regular, U: Regular> = (T, T) -> U

// MARK: Chapter 2

//typealias Predicate = (Any, ...Any) -> Bool

//typealias HomogeneousPredicate<T: Regular> = (T, ...T) -> Bool

typealias UnaryPredicate<T: Regular> = (T) -> Bool

// typealias Operation<T: Regular> = (T, ...T) -> T

typealias UnaryOperation<T: Regular> = (T) -> T

// typealias DefinitionSpacePredicate (Any, ...Any) -> Bool
// precondition: Returns true if and only if the inputs are within the
//               definition space of the procedure

// Distance: Transformation -> Integer
typealias DistanceType = UInt

protocol Distance: Regular {
    func distance(to: Self, f: Transformation<Self>) -> UInt
}

typealias Transformation<T: Distance> = UnaryOperation<T>

// MARK: Chapter 3

typealias BinaryOperation<T: Regular> = (T, T) -> T

// MARK: Chapter 4

typealias Relation<T: Regular> = (T, T) -> Bool

typealias BinaryRelation<T, U> = (T, U) -> Bool

// FIXME: Strictly speaking, TotallyOrdered shouldn't conform to Equatable, just <
//protocol TotallyOrdered: Comparable {}

// MARK: Chapter 5

protocol AdditiveSemigroup: Regular, Addable {}

protocol MultiplicativeSemigroup: Regular, Multipliable {}

protocol AdditiveMonoid: AdditiveSemigroup, AdditiveIdentity {}

protocol MultiplicativeMonoid: MultiplicativeSemigroup, MultiplicativeIdentity {}

protocol Semiring: AdditiveMonoid, MultiplicativeMonoid {}

protocol AdditiveGroup: AdditiveMonoid, Subtractable, AdditiveInverse {}

protocol MultiplicativeGroup: MultiplicativeMonoid, MultiplicativeInverse, Divisible {}

protocol CommutativeSemiring: Semiring {} //& Commutative

protocol Ring: AdditiveGroup, Semiring {}

protocol CommutativeRing: AdditiveGroup, CommutativeSemiring {}

protocol Semimodule: AdditiveMonoid {
    associatedtype CS: CommutativeSemiring
    static func *(lhs: CS, rhs: Self) -> Self
}

protocol Module: Semimodule, AdditiveGroup where CS: Ring {}

protocol OrderedAdditiveSemigroup: AdditiveSemigroup {}

protocol OrderedAdditiveMonoid: OrderedAdditiveSemigroup, AdditiveMonoid {}

protocol OrderedAdditiveGroup: OrderedAdditiveMonoid, AdditiveGroup {}

protocol CancellableMonoid: OrderedAdditiveMonoid, Subtractable {}

protocol ArchimedeanMonoid: CancellableMonoid, Quotient {}

protocol HalvableMonoid: ArchimedeanMonoid, Halvable {}

protocol EuclideanMonoid: ArchimedeanMonoid {} //& SubtractiveGCDNonzero

protocol EuclideanSemiring: CommutativeSemiring, Norm, Remainder, Quotient {}

protocol EuclideanSemimodule: Semimodule, Remainder, Quotient {}

protocol ArchimedeanGroup: ArchimedeanMonoid, AdditiveGroup {}

protocol DiscreteArchimedeanSemiring: CommutativeSemiring, ArchimedeanMonoid, Discrete {}

protocol NonnegativeDiscreteArchimedeanSemiring: DiscreteArchimedeanSemiring {} //& Nonnegative

protocol DiscreteArchimedeanRing: DiscreteArchimedeanSemiring, AdditiveGroup {}

// MARK: Chapter 6

protocol Readable: Regular {
    associatedtype Source: Regular
    var source: Source? { get }
}

protocol Iterator: Distance {
    var iteratorSuccessor: Self? { get }
    func distance(toStart start: Self) -> DistanceType?
}

protocol ForwardIterator: Iterator { } // iteratorSuccessor is a Regular Unary Function

protocol IndexedIterator: ForwardIterator {
    static func +(lhs: Self, rhs: DistanceType) -> Self
    static func -(lhs: Self, rhs: DistanceType) -> Self
}

protocol BidirectionalIterator: ForwardIterator {
    var iteratorPredecessor: Self? { get }
}

protocol RandomAccessIterator: IndexedIterator, BidirectionalIterator {
    static func +(lhs: Self, rhs: DifferenceType) -> Self
    static func -(lhs: Self, rhs: DifferenceType) -> Self
    static func -(lhs: Self, rhs: Self) -> DifferenceType
}

//typealias UnaryProcedure<T> = (T) -> Void
protocol UnaryProcedure {
    associatedtype UnaryProcedureType
    func call(_ arg: UnaryProcedureType)
}

//typealias BinaryProcedure<T, U> = (T, U) -> Void
protocol BinaryProcedure {
    associatedtype BinaryProcedureType1
    associatedtype BinaryProcedureType2
    func call(_ arg1: BinaryProcedureType1, _ arg2: BinaryProcedureType2)
}

//typealias BinaryHomogeneousProcedure<T> = (T, T) -> Void
protocol BinaryHomogeneousProcedure {
    associatedtype BinaryHomogeneousProcedureType
    func call(_ arg1: BinaryHomogeneousProcedureType, _ arg2: BinaryHomogeneousProcedureType)
}

// MARK: Chapter 7

typealias WeightType = UInt

protocol BifurcateCoordinate: Regular {
    func isEmpty() -> Bool
    func hasLeftSuccessor() -> Bool
    func hasRightSuccessor() -> Bool
    var leftSuccessor: Self? { get }
    var rightSuccessor: Self? { get }
}

protocol BidirectionalBifurcateCoordinate: BifurcateCoordinate {
    func hasPredecessor() -> Bool
    var iteratorPredecessor: Self? { get }
}

// MARK: Chapter 8

protocol ForwardLinkedIterator: ForwardIterator {
    var forwardLink: Self? { get set }
}

protocol BackwardLinkedIterator: BidirectionalIterator {
    var backwardLink: Self? { get set }
}

protocol BidirectionalLinkedIterator: ForwardLinkedIterator, BackwardLinkedIterator { }

protocol LinkedBifurcateCoordinate: BifurcateCoordinate {
    var leftSuccessor: Self? { get set }
    var rightSuccessor: Self? { get set }
}

protocol EmptyLinkedBifurcateCoordinate: LinkedBifurcateCoordinate {
    func isEmpty() -> Bool
}

// MARK: Chapter 9

protocol Writable {
    associatedtype Sink
    // Shouldn't really be gettable, but can't do that in Swift
    var sink: Sink? { get set }
}

protocol Mutable: Readable, Writable where Source == Sink {
    var deref: Source? { get set }
}

// Chapter 11

protocol Linearizable: Regular {
    associatedtype LinearizableIteratorType: Regular
    associatedtype LinearizableValueType: Regular
    
    var begin: LinearizableIteratorType { get }
    var end: LinearizableIteratorType { get }
    var size: Int { get }
    func isEmpty() -> Bool
    subscript(index: Int) -> LinearizableValueType { get set }
}

// MARK: Type Functions

//
//  TypeFunctions.swift
//  ElementsOfProgramming
//

// MARK: Chapter 2

//
//  Chapter01.swift
//  ElementsOfProgramming
//

func plus0(a: Int, b: Int) -> Int {
    return a + b
}

// Swift dosen't have a way to express a const &
func plus1(a: inout Int, b: inout Int) -> Int {
    return a + b
}

func plus2(a: UnsafePointer<Int>,
           b: UnsafePointer<Int>,
           c: UnsafeMutablePointer<Int>) {
    c.pointee = a.pointee + b.pointee
}

func square(n: Int) -> Int { return n * n }

func square<DomainOp: Regular>(
    x: DomainOp,
    op: BinaryOperation<DomainOp>
    ) -> DomainOp {
    return op(x, x)
}

func equal<T: Regular>(x: T, y: T) -> Bool { return x == y }

// InputType(F, i)
// Returns the type of the ith parameter (counting from 0)

// type pair (see chapter 12 of Elements of Programming)
// model Regular(Pair)

struct Pair<T0: Regular, T1: Regular>: Regular {
    var m0: T0
    var m1: T1
    
    static func == (x: Pair, y: Pair) -> Bool {
        return x.m0 == y.m0 && x.m1 == y.m1
    }
    
    static func < (x: Pair, y: Pair) -> Bool {
        return x.m0 < y.m0 || (!(y.m0 < x.m0) && x.m1 < y.m1)
    }
}

// type triple (see Exercise 12.2 of Elements of Programming)
// model Regular(triple)

struct Triple<T0: Regular, T1: Regular, T2: Regular>: Regular {
    var m0: T0
    var m1: T1
    var m2: T2
    
    static func == (x: Triple, y: Triple) -> Bool {
        return x.m0 == y.m0 && x.m1 == y.m1 && x.m2 == y.m2
    }
    
    static func < (x: Triple, y: Triple) -> Bool {
        return x.m0 < y.m0 ||
            (!(y.m0 < x.m0) && x.m1 < y.m1) ||
            (!(y.m1 < x.m1) && x.m2 < y.m2)
    }
}

// MARK: Chapter 1

// MARK: Chapter 2

// Domain: UnaryFunction -> Regular

extension Distance {
    func distance(to end: Self, f: Transformation<Self>) -> UInt {
        var x = self
        let y = end
        // Precondition: y is reachable from x under f
        var n = N(0)
        while x != y {
            x = f(x)
            n = n + N(1)
        }
        return n
    }
}

extension Iterator {
    func distance(toStart f: Self) -> DistanceType? {
        let l = self
        var f = f
        // Precondition: $\property{bounded\_range}(f, l)$
        var n = DistanceType(0)
        while f != l {
            n = n.successor()
            guard let s = f.iteratorSuccessor else { return nil }
            f = s
        }
        return n
    }
}

protocol MultiplicativeIdentity {
    static func multiplicativeIdentity() -> Self
}

protocol AdditiveIdentity {
    static func additiveIdentity() -> Self
}

protocol AdditiveInverse: Negatable {
    func additiveInverse() -> Self
}

extension AdditiveInverse {
    func additiveInverse() -> Self {
        return -self
    }
}

protocol MultiplicativeInverse {
    func multiplicativeInverse() -> Self
}


protocol Modulus {
    static func %(lhs: Self, rhs: Self) -> Self
}

protocol Remainder {
    func remainder(_ value: Self) -> Self
}

protocol Addable {
    static func +(lhs: Self, rhs: Self) -> Self
}

protocol Subtractable {
    static func -(lhs: Self, rhs: Self) -> Self
}

protocol Negatable {
    static prefix func -(value: Self) -> Self
}

protocol Multipliable {
    static func *(lhs: Self, rhs: Self) -> Self
}

protocol Divisible {
    static func/(lhs: Self, rhs: Self) -> Self
}

protocol Relational {
    associatedtype T: AdditiveMonoid
    associatedtype S: CommutativeSemiring
    static func relation(from commutativeSemiring: S,
                         to additiveMonoid: T) -> T
}

typealias QuotientType = Int

protocol Quotient: Divisible {
    associatedtype T
    func quotient(_ value: Self) -> T
}

extension Quotient {
    func quotient(_ value: Self) -> Self {
        return self / value
    }
}

protocol Halvable: Divisible {
    func half() -> Self
}

protocol SubtractiveGCDNonzero {
    func subtractiveGCDNonzero()
}

typealias NormType = Int

protocol Norm: AdditiveIdentity, Regular {
    func w() -> Self
}

//protocol Associative { }

//protocol Commutative { }

protocol Discrete { }

typealias DifferenceType = Int

// MARK: Int

//
//  Int+Additions.swift
//  ElementsOfProgramming
//

extension Int : MultiplicativeIdentity {
    static func multiplicativeIdentity() -> Int {
        return 1
    }
}

extension Int : AdditiveIdentity {
    static func additiveIdentity() -> Int {
        return 0
    }
}

extension Int: Halvable {
    func half() -> Int { return self / 2 }
}

extension Int: MultiplicativeInverse {
    func multiplicativeInverse() -> Int {
        return Int.multiplicativeIdentity() / self
    }
}

extension Int: Remainder {
    func remainder(_ value: Int) -> Int {
        return self % value
    }
}

extension Int: Norm {
    func w() -> Int {
        if self < Int.additiveIdentity() {
            return -self
        }
        return self
    }
}

extension Int : Addable, Subtractable, Negatable, Multipliable, Divisible, Quotient, Discrete, AdditiveInverse, Modulus, Distance, AdditiveSemigroup, MultiplicativeSemigroup, AdditiveMonoid, MultiplicativeMonoid, Semiring, CommutativeSemiring, EuclideanSemiring {}

protocol IntegerSpecialCaseProcedures {
    func successor() -> Self
    func predecessor() -> Self
    func twice() -> Self
    func halfNonnegative() -> Self
    func isPositive() -> Bool
    func isNegative() -> Bool
    func isEqualToZero() -> Bool
    func isEqualToOne() -> Bool
    func isEven() -> Bool
    func isOdd() -> Bool
}

protocol BinaryIntegerSpecialCaseProcedures {
    func binaryScaleDownNonnegative(k: Self) -> Self
    func binaryScaleUpNonnegative(k: Self) -> Self
}

extension Int: IntegerSpecialCaseProcedures, BinaryIntegerSpecialCaseProcedures {
    func successor() -> Int {
        return self + 1
    }
    
    func predecessor() -> Int {
        return self - 1
    }
    
    func twice() -> Int {
        return self + self
    }
    
    func halfNonnegative() -> Int {
        return self >> 1
    }
    
    func binaryScaleDownNonnegative(k: Int) -> Int {
        return self >> k
    }
    
    func binaryScaleUpNonnegative(k: Int) -> Int {
        return self << k
    }
    
    func isPositive() -> Bool {
        return 0 < self
    }
    
    func isNegative() -> Bool {
        return self < 0
    }
    
    func isEqualToZero() -> Bool {
        return self == 0
    }
    
    func isEqualToOne() -> Bool {
        return self == 1
    }
    
    func isEven() -> Bool {
        return (self & 1) == 0
    }
    
    func isOdd() -> Bool {
        return (self & 1) != 0
    }
}

extension Int: Iterator {
    var iteratorSuccessor: Int? {
        return self + 1
    }
}

extension Int: Readable {
    var source: Int? {
        return self
    }
}

// MARK: UInt

//
//  UInt+Additions.swift
//  ElementsOfProgramming
//

// Natural Numbers
typealias N = UInt

extension UInt : MultiplicativeIdentity {
    static func multiplicativeIdentity() -> UInt {
        return 1
    }
}

extension UInt : AdditiveIdentity {
    static func additiveIdentity() -> UInt {
        return 0
    }
}

extension UInt: Halvable {
    func half() -> UInt { return self / 2 }
}

extension UInt: MultiplicativeInverse {
    func multiplicativeInverse() -> UInt {
        return UInt.multiplicativeIdentity() / self
    }
}

extension UInt: Remainder {
    func remainder(_ value: UInt) -> UInt {
        return self % value
    }
}

extension UInt: Norm {
    func w() -> UInt {
        return self
    }
}

extension UInt : Addable, Subtractable, Multipliable, Divisible, Quotient, Discrete, Modulus, Distance, AdditiveSemigroup, MultiplicativeSemigroup, AdditiveMonoid, MultiplicativeMonoid, Semiring, CommutativeSemiring, EuclideanSemiring {}

extension UInt: IntegerSpecialCaseProcedures {
    func successor() -> UInt {
        return self + 1
    }
    
    func predecessor() -> UInt {
        return self - 1
    }
    
    func twice() -> UInt {
        return self + self
    }
    
    func halfNonnegative() -> UInt {
        return self / 2
    }
    
    func isPositive() -> Bool {
        return 0 < self
    }
    
    func isNegative() -> Bool {
        return self < 0
    }
    
    func isEqualToZero() -> Bool {
        return self == 0
    }
    
    func isEqualToOne() -> Bool {
        return self == 1
    }
    
    func isEven() -> Bool {
        return (self % 2) == 0 ? true : false
    }
    
    func isOdd() -> Bool {
        return (self % 2) == 0 ? false : true
    }
}

extension UInt: Iterator {
    var iteratorSuccessor: UInt? {
        return self + 1
    }
}

// MARK: Chapter 2

//
//  Chapter02.swift
//  ElementsOfProgramming
//

import Darwin

func absoluteValue(x: Int) -> Int {
    if (x < 0) { return -x } else { return x }
} // unary operation

func euclideanNorm(x: Double, y: Double) -> Double {
    return sqrt(x * x + y * y)
} // binary operation

func euclideanNorm(x: Double, y: Double, z: Double) -> Double {
    return sqrt(x * x + y * y + z * z)
} // ternary operation

func powerUnary<DomainF: Distance>(
    x: DomainF,
    n: N,
    f: Transformation<DomainF>
    ) -> DomainF {
    var x = x, n = n
    assert(n >= 0, "n >= 0")
    // Precondition: n ≥ 0 ∧ (∀i ∈ N), 0 < i ≤ n ⇒ f^i(x) is defined
    
    while n != N(0) {
        n = n - N(1)
        x = f(x)
    }
    return x
}

// See Distance protocol
func distance<DomainF: Distance>(
    x: DomainF,
    y: DomainF,
    f: Transformation<DomainF>
    ) -> DistanceType {
    var x = x
    // Precondition: y is reachable from x under f
    var n = N(0)
    while x != y {
        x = f(x)
        n = n + N(1)
    }
    return n
}

func collisionPoint<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
    ) -> DomainFP {
    // Precondition: p(x) ⇔ f(x) is defined
    if !p(x) { return x }
    
    var slow = x
    var fast = f(x)
    
    var fastTotal = [x, fast]
    while fast != slow {
        slow = f(slow)
        if !p(fast) { return fast }
        fast = f(fast)
        fastTotal.append(fast)
        if !p(fast) { return fast }
        fast = f(fast)
        fastTotal.append(fast)
    }
    fastTotal.map { $0 }
    return fast
    // Postcondition: return value is terminal point or collision point
}

let f: Transformation<DistanceType> = { x in
    return (x % 153 + 1)
}
let p: UnaryPredicate<DistanceType> = { _ in return true }
//collisionPoint(x: UInt(0), f: f, p: p)

func terminating<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
    ) -> Bool{
    // Precondition: p(x) ⇔ f(x) is defined
    return !p(collisionPoint(x: x, f: f, p: p))
}

func collisionPointNonterminatingOrbit<DomainF: Distance>(
    x: DomainF,
    f: Transformation<DomainF>
    ) -> DomainF {
    var slow = x
    var fast = f(x)
    
    var fastTotal = [x, fast]
    while fast != slow {
        slow = f(slow)
        fast = f(fast)
        fastTotal.append(fast)
        fast = f(fast)
        fastTotal.append(fast)
    }
    fastTotal.map { $0 }
    return fast
}

collisionPointNonterminatingOrbit(x: UInt(2), f: f)

func circularNonterminatingOrbit<DomainF: Distance>(
    x: DomainF,
    f: Transformation<DomainF>
    ) -> Bool {
    return x == f(collisionPointNonterminatingOrbit(x: x, f: f))
}

func circular<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
    ) -> Bool {
    // Precondition: p(x) ⇔ f(x) is defined
    let y = collisionPoint(x: x, f: f, p: p)
    return p(y) && x == f(y)
}

func convergentPoint<DomainF: Distance>(
    x0: DomainF,
    x1: DomainF,
    f: Transformation<DomainF>
    ) -> DomainF {
    var x0 = x0, x1 = x1
    // Precondition: (∃n ∈ DistanceType(F)), n ≥ 0 ∧ f^n(x0) = f^n(x1)
    while x0 != x1 {
        x0 = f(x0)
        x1 = f(x1)
    }
    return x0
}

func connectionPointNonterminatingOrbit<DomainF: Distance>(
    x: DomainF,
    f: Transformation<DomainF>
    ) -> DomainF {
    return convergentPoint(x0: x,
                           x1: f(collisionPointNonterminatingOrbit(x: x, f: f)),
                           f: f)
}

func connectionPoint<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
    ) -> DomainFP {
    // Precondition: p(x) ⇔ f(x) is defined
    let y = collisionPoint(x: x, f: f, p: p)
    if !p(y) { return y }
    return convergentPoint(x0: x, x1: f(y), f: f)
}

/// Exercise 2.3

func convergentPointGuarded<DomainF: Distance>(
    x0: DomainF,
    x1: DomainF,
    y: DomainF,
    f: Transformation<DomainF>
    ) -> DomainF {
    var x0 = x0, x1 = x1
    // Precondition: reachable(x0, y, f) ∧ reachable(x1, y, f)
    let d0 = x0.distance(to: y, f: f)
    let d1 = x1.distance(to: y, f: f)
    if d0 < d1 {
        x1 = powerUnary(x: x1, n: N(d1 - d0), f: f)
    } else if d1 < d0 {
        x0 = powerUnary(x: x0, n: N(d0 - d1), f: f)
    }
    return convergentPoint(x0: x0, x1: x1, f: f)
}

func orbitStructureNonterminatingOrbit<DomainF: Distance>(
    x: DomainF,
    f: Transformation<DomainF>
    ) -> Triple<DistanceType, DistanceType, DomainF> {
    let y = connectionPointNonterminatingOrbit(x: x, f: f)
    return Triple(m0: x.distance(to: y, f: f),
                  m1: f(y).distance(to: y, f: f),
                  m2: y)
}

func orbitStructure<DomainFP: Distance>(
    x: DomainFP,
    f: Transformation<DomainFP>,
    p: UnaryPredicate<DomainFP>
    ) -> Triple<DistanceType, DistanceType, DomainFP> {
    // Precondition: p(x) ⇔ f(x) is defined
    let y = connectionPoint(x: x, f: f, p: p)
    let m = x.distance(to: y, f: f)
    var n = N(0)
    if p(y) { n = f(y).distance(to: y, f: f) }
    // Terminating: m = h - 1 ∧ n = 0
    // Otherwise:   m = h ∧ n = c - 1
    return Triple(m0: m, m1: n, m2: y)
}

orbitStructure(x: UInt(1), f: f, p: p)


