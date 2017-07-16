//
//  Concepts.swift
//  ElementsOfProgramming
//

// MARK: Chapter 1

typealias Regular = Equatable & Comparable

//typealias FunctionalProcedure<T> = (Any, Any...) -> T

//typealias HomogeneousFunction<T, U: Regular> = (U, U ...) -> T

typealias UnaryFunction<T: Regular> = (T) -> Any

// MARK: Chapter 2

//typealias Predicate = (Any, Any...) -> Bool

//typealias HomogeneousPredicate<T: Regular> = (T, T ...) -> Bool

typealias UnaryPredicate<T: Regular> = (T) -> Bool
typealias P<T: Regular> = UnaryPredicate<T>

// typealias Operation<T: Regular> = (T, T ...) -> T

typealias UnaryOperation<T: Regular> = (T) -> T
typealias F<T: Regular> = UnaryOperation<T>

// typealias DefinitionSpacePredicate (Any, Any...) -> Bool
// precondition: Returns true if and only if the inputs are within the
//               definition space of the procedure

typealias Transformation<T: Regular> = UnaryOperation<T>

// MARK: Chapter 3

typealias BinaryOperation<T: Regular> = (T, T) -> T
typealias Op<T: Regular> = BinaryOperation<T>

// MARK: Chapter 4

typealias Relation<T: Regular> = (T, T) -> Bool

typealias TotallyOrdered = Comparable

// MARK: Chapter 5

typealias AdditiveSemigroup = Regular & Addable

typealias MultiplicativeSemigroup = Regular & Multipliable

typealias AdditiveMonoid = AdditiveSemigroup

typealias MultiplicativeMonoid = MultiplicativeSemigroup

typealias AdditiveGroup = AdditiveMonoid & Subtractable & Negateable

typealias MultiplicativeGroup = MultiplicativeMonoid & Divisible

typealias Semiring = AdditiveMonoid & MultiplicativeMonoid

typealias CommutativeSemiring = Semiring

typealias Ring = AdditiveGroup & Semiring

typealias CommutativeRing = AdditiveGroup & CommutativeSemiring
