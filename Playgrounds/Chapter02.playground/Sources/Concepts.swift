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

public protocol Regular:
    Comparable {} // Equatable

//typealias Procedure<T> = (Any, ...Any) -> Void

//typealias FunctionalProcedure<T> = (Any, ...Any) -> T

//typealias HomogeneousFunction<T, U> = (T, ...T) -> U

public typealias UnaryFunction<
    T: Regular,
    U: Regular
> = (T) -> U

public typealias BinaryFunction<
    T: Regular,
    U: Regular,
    V: Regular
> = (T, U) -> V

public typealias BinaryHomogeneousFunction<
    T: Regular,
    U: Regular
> = (T, T) -> U

// MARK: Chapter 2

//typealias Predicate = (Any, ...Any) -> Bool

//typealias HomogeneousPredicate<T: Regular> = (T, ...T) -> Bool

public typealias UnaryPredicate<T: Regular> = (T) -> Bool

// typealias Operation<T: Regular> = (T, ...T) -> T

public typealias UnaryOperation<T: Regular> = (T) -> T

// typealias DefinitionSpacePredicate (Any, ...Any) -> Bool
// precondition: Returns true if and only if the inputs are within the
//               definition space of the procedure

public typealias Transformation<T: Distance> = UnaryOperation<T>

// MARK: Chapter 3

public typealias BinaryOperation<T: Regular> = (T, T) -> T

// MARK: Chapter 4

public typealias Relation<T: Regular> = (T, T) -> Bool

public typealias BinaryRelation<T, U> = (T, U) -> Bool

// FIXME: Strictly speaking, TotallyOrdered shouldn't conform to Equatable, just <
//protocol TotallyOrdered: Comparable {}

// MARK: Chapter 5

public protocol AdditiveSemigroup:
    Regular,
    Addable {}

public protocol MultiplicativeSemigroup:
    Regular,
    Multipliable {}

public protocol AdditiveMonoid:
    AdditiveSemigroup,
    AdditiveIdentity {}

public protocol MultiplicativeMonoid:
    MultiplicativeSemigroup,
    MultiplicativeIdentity {}

public protocol Semiring:
    AdditiveMonoid,
    MultiplicativeMonoid {}

public protocol AdditiveGroup:
    AdditiveMonoid,
    Subtractable,
    AdditiveInverse {}

public protocol MultiplicativeGroup:
    MultiplicativeMonoid,
    MultiplicativeInverse,
    Divisible {}

public protocol CommutativeSemiring:
    Semiring {}
    //& Commutative

public protocol Ring:
    AdditiveGroup,
    Semiring {}

public protocol CommutativeRing:
    AdditiveGroup,
    CommutativeSemiring {}

public protocol Semimodule: AdditiveMonoid {
    associatedtype CS: CommutativeSemiring
    static func *(lhs: CS, rhs: Self) -> Self
}

public protocol Module:
    Semimodule,
    AdditiveGroup where CS: Ring {}

public protocol OrderedAdditiveSemigroup:
    AdditiveSemigroup {}

public protocol OrderedAdditiveMonoid:
    OrderedAdditiveSemigroup,
    AdditiveMonoid {}

public protocol OrderedAdditiveGroup:
    OrderedAdditiveMonoid,
    AdditiveGroup {}

public protocol CancellableMonoid:
    OrderedAdditiveMonoid,
    Subtractable {}

public protocol ArchimedeanMonoid:
    CancellableMonoid,
    Quotient {}

public protocol HalvableMonoid:
    ArchimedeanMonoid,
    Halvable {}

public protocol EuclideanMonoid:
    ArchimedeanMonoid {}
    //, SubtractiveGCDNonzero

public protocol EuclideanSemiring:
    CommutativeSemiring,
    Norm,
    Remainder,
    Quotient {}

public protocol EuclideanSemimodule:
    Semimodule,
    Remainder,
    Quotient {}

public protocol ArchimedeanGroup:
    ArchimedeanMonoid,
    AdditiveGroup {}

public protocol DiscreteArchimedeanSemiring:
    CommutativeSemiring,
    ArchimedeanMonoid,
    Discrete {}

public protocol NonnegativeDiscreteArchimedeanSemiring:
    DiscreteArchimedeanSemiring {}
    //& Nonnegative

public protocol DiscreteArchimedeanRing:
    DiscreteArchimedeanSemiring,
    AdditiveGroup {}

// MARK: Chapter 6

public protocol Readable: Regular {
    associatedtype Source: Regular
    var source: Source? { get }
}

public protocol Iterator: Distance {
    var iteratorSuccessor: Self? { get }
    func distance(to end: Self) -> DistanceType
}

public protocol ForwardIterator: Iterator {
    // iteratorSuccessor is a Regular Unary Function
}

public protocol IndexedIterator: ForwardIterator {
    func successor(at distance: DistanceType) -> Self?
    func distance(from precedingIterator: Self) -> DistanceType
}

public protocol BidirectionalIterator: ForwardIterator {
    var iteratorPredecessor: Self? { get }
    func predecessor(at distance: DistanceType) -> Self?
}

public protocol RandomAccessIterator: IndexedIterator, BidirectionalIterator {
    func iterator(at difference: DifferenceType) -> Self?
    func difference(from iterator: Self) -> DifferenceType
}

//typealias UnaryProcedure<T> = (T) -> Void
public protocol UnaryProcedure {
    associatedtype UnaryProcedureType
    func call(_ arg: UnaryProcedureType)
}

//typealias BinaryProcedure<T, U> = (T, U) -> Void
public protocol BinaryProcedure {
    associatedtype BinaryProcedureType1
    associatedtype BinaryProcedureType2
    func call(_ arg1: BinaryProcedureType1, _ arg2: BinaryProcedureType2)
}

//typealias BinaryHomogeneousProcedure<T> = (T, T) -> Void
public protocol BinaryHomogeneousProcedure {
    associatedtype BinaryHomogeneousProcedureType
    func call(_ arg1: BinaryHomogeneousProcedureType,
              _ arg2: BinaryHomogeneousProcedureType)
}

// MARK: Chapter 7

public typealias WeightType = UInt

public protocol BifurcateCoordinate: Regular {
    func isEmpty() -> Bool
    var leftSuccessor: Self? { get }
    var rightSuccessor: Self? { get }
}

public protocol BidirectionalBifurcateCoordinate: BifurcateCoordinate {
    var iteratorPredecessor: Self? { get }
}

// MARK: Chapter 8

public protocol ForwardLinkedIterator: ForwardIterator {
    var forwardLink: Self? { get set }
}

public protocol BackwardLinkedIterator: BidirectionalIterator {
    var backwardLink: Self? { get set }
}

public protocol BidirectionalLinkedIterator:
    ForwardLinkedIterator,
    BackwardLinkedIterator { }

public protocol LinkedBifurcateCoordinate: BifurcateCoordinate {
    var leftSuccessor: Self? { get set }
    var rightSuccessor: Self? { get set }
}

public protocol EmptyLinkedBifurcateCoordinate: LinkedBifurcateCoordinate {
    func isEmpty() -> Bool
}

// MARK: Chapter 9

public protocol Writable {
    associatedtype Sink
    // Shouldn't really be gettable, but can't do that in Swift
    var sink: Sink? { get set }
}

public protocol Mutable: Readable, Writable where Source == Sink {
    var deref: Source? { get set }
}

// Chapter 11

public protocol Linearizable: Regular {
    associatedtype LinearizableIteratorType: Regular
    associatedtype LinearizableValueType: Regular

    var begin: LinearizableIteratorType { get }
    var end: LinearizableIteratorType { get }
    var size: Int { get }
    func isEmpty() -> Bool
    subscript(index: Int) -> LinearizableValueType { get set }
}
