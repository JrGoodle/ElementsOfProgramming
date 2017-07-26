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

typealias Transformation<T: Distance> = UnaryOperation<T>

// MARK: Chapter 3

typealias BinaryOperation<T: Regular> = (T, T) -> T

// MARK: Chapter 4

typealias Relation<T: Regular> = (T, T) -> Bool

typealias BinaryRelation<T, U> = (T, U) -> Bool

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
    func empty() -> Bool
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
    func setLeftSuccessor(_ ls: Self)
    func setRightSuccessor(_ ls: Self)
}

protocol EmptyLinkedBifurcateCoordinate: LinkedBifurcateCoordinate {
    func empty() -> Bool
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


