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

//typealias FunctionalProcedure<T> = (Any, ...Any) -> T

//typealias HomogeneousFunction<T, U: Regular> = (T, ...T) -> U

typealias UnaryFunction<T: Regular, U: Regular> = (T) -> U

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

typealias AdditiveGroup = AdditiveMonoid & Subtractable & AdditiveInverse & Negatable

typealias MultieplicativeGroup = MultiplicativeMonoid & MultiplicativeInverse & Divisible

typealias Semiring = AdditiveMonoid & MultiplicativeMonoid

typealias CommutativeSemiring = Semiring

typealias Ring = AdditiveGroup & Semiring

typealias CommutativeRing = AdditiveGroup & CommutativeSemiring

typealias Semimodule = AdditiveMonoid & CommutativeSemiring & Relational

typealias Module = Semimodule & AdditiveGroup & Ring

typealias OrderedAdditiveSemigroup = AdditiveSemigroup & TotallyOrdered

typealias OrderedAdditiveMonoid = OrderedAdditiveSemigroup & AdditiveMonoid

typealias OrderedAdditiveGroup = OrderedAdditiveMonoid & AdditiveGroup

typealias CancellableMonoid = OrderedAdditiveMonoid & Subtractable

typealias ArchimedeanMonoid = CancellableMonoid & Quotient

typealias HalvableMonoid = ArchimedeanMonoid & Halvable

typealias EuclideanMonoid = ArchimedeanMonoid & SubtractiveGCDNonzero
