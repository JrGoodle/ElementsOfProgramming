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

typealias UnaryProcedure<T> = (T) -> Void

typealias BinaryProcedure<T, U> = (T, U) -> Void

typealias HomogenousBinaryProcedure<T> = (T, T) -> Void

//typealias FunctionalProcedure<T> = (Any, ...Any) -> T

//typealias HomogeneousFunction<T, U: Regular> = (T, ...T) -> U

typealias UnaryFunction<T: Regular, U: Regular> = (T) -> U

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

typealias Relation<T: TotallyOrdered> = (T, T) -> Bool

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
    func source() -> Source?
}

protocol Iterator: Regular {
    func _successor() -> Self?
}

protocol ForwardIterator: Iterator { }

protocol IndexedIterator: ForwardIterator {
    static func +(lhs: Self, rhs: DistanceType) -> Self
    static func -(lhs: Self, rhs: DistanceType) -> Self
}

protocol BidirectionalIterator: ForwardIterator {
    func _predecessor() -> Self?
}

protocol RandomAccessIterator: IndexedIterator, BidirectionalIterator, TotallyOrdered {
    static func +(lhs: Self, rhs: DifferenceType) -> Self
    static func -(lhs: Self, rhs: DifferenceType) -> Self
    static func +(lhs: Self, rhs: Self) -> DifferenceType
}

