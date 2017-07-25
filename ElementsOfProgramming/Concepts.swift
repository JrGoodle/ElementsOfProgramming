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

typealias Regular = Equatable

//typealias Procedure<T> = (Any, ...Any) -> Void

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

//typealias FunctionalProcedure<T> = (Any, ...Any) -> T

//typealias HomogeneousFunction<T, U: Regular> = (T, ...T) -> U

typealias UnaryFunction<T: Regular, U: Regular> = (T) -> U

typealias BinaryFunction<T: Regular, U: Regular, V: Regular> = (T, U) -> V

typealias BinaryHomogeneousFunction<T: Regular, U: Regular> = (T, T) -> U

// MARK: Chapter 2

//typealias Predicate = (Any, ...Any) -> Bool

//typealias HomogeneousPredicate<T: Regular> = (T, ...T) -> Bool

typealias UnaryPredicate<T: Regular> = (T) -> Bool
typealias P<T: Regular> = UnaryPredicate<T>

// typealias Operation<T: Regular> = (T, ...T) -> T

typealias UnaryOperation<T: Regular> = (T) -> T
typealias F<T: Regular> = UnaryOperation<T>

// typealias DefinitionSpacePredicate (Any, ...Any) -> Bool
// precondition: Returns true if and only if the inputs are within the
//               definition space of the procedure

typealias Transformation<T: Distance> = UnaryOperation<T>

// MARK: Chapter 3

typealias BinaryOperation<T: Regular> = (T, T) -> T
typealias Op<T: Regular> = BinaryOperation<T>

// MARK: Chapter 4

typealias BinaryRelation<T, U> = (T, U) -> Bool

typealias BinaryHomogeneousRelation<T> = (T, T) -> Bool

typealias Relation<T: TotallyOrdered> = BinaryHomogeneousRelation<T>

typealias TotallyOrdered = Comparable & Regular

// MARK: Chapter 5

typealias AdditiveSemigroup = Regular & Addable

typealias MultiplicativeSemigroup = Regular & Multipliable

typealias AdditiveMonoid = AdditiveSemigroup & AdditiveIdentity

typealias MultiplicativeMonoid = MultiplicativeSemigroup & MultiplicativeIdentity

typealias Semiring = AdditiveMonoid & MultiplicativeMonoid

typealias AdditiveGroup = AdditiveMonoid & Subtractable & AdditiveInverse & Negatable

typealias MultieplicativeGroup = MultiplicativeMonoid & MultiplicativeInverse & Divisible

typealias CommutativeSemiring = Semiring //& Commutative

typealias Ring = AdditiveGroup & Semiring

typealias CommutativeRing = AdditiveGroup & CommutativeSemiring

typealias Semimodule = AdditiveMonoid & CommutativeSemiring //& Relational

typealias Module = Semimodule & AdditiveGroup & Ring

typealias OrderedAdditiveSemigroup = AdditiveSemigroup & TotallyOrdered

typealias OrderedAdditiveMonoid = OrderedAdditiveSemigroup & AdditiveMonoid

typealias OrderedAdditiveGroup = OrderedAdditiveMonoid & AdditiveGroup

typealias CancellableMonoid = OrderedAdditiveMonoid & Subtractable

typealias ArchimedeanMonoid = CancellableMonoid & Quotient

typealias HalvableMonoid = ArchimedeanMonoid & Halvable

typealias EuclideanMonoid = ArchimedeanMonoid //& SubtractiveGCDNonzero

typealias EuclideanSemiring = CommutativeSemiring & Norm & Remainder & Quotient

typealias EuclideanSemimodule = Semimodule & Remainder & Quotient

typealias ArchimedeanGroup = ArchimedeanMonoid & AdditiveGroup

typealias DiscreteArchimedeanSemiring = CommutativeSemiring & ArchimedeanMonoid & Discrete

typealias NonnegativeDiscreteArchimedeanSemiring = DiscreteArchimedeanSemiring

typealias DiscreteArchimedeanRing = DiscreteArchimedeanSemiring & AdditiveGroup

// MARK: Chapter 6

protocol Readable: Regular {
    associatedtype Source: Regular
    var source: Source? { get }
}

protocol Iterator: Regular {
    var iteratorSuccessor: Self? { get }
}

protocol ForwardIterator: Iterator { }

protocol IndexedIterator: ForwardIterator {
    static func +(lhs: Self, rhs: DistanceType) -> Self
    static func -(lhs: Self, rhs: DistanceType) -> Self
}

protocol BidirectionalIterator: ForwardIterator {
    var iteratorPredecessor: Self? { get }
}

protocol RandomAccessIterator: IndexedIterator, BidirectionalIterator, TotallyOrdered {
    static func +(lhs: Self, rhs: DifferenceType) -> Self
    static func -(lhs: Self, rhs: DifferenceType) -> Self
    static func -(lhs: Self, rhs: Self) -> DifferenceType
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
    var sink: Sink? { get set }
}

protocol Mutable: Readable, Writable where Source == Sink {
    func deref() -> Source?
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


