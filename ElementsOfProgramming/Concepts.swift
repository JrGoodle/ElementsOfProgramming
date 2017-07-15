//
//  Concepts.swift
//  ElementsOfProgramming
//

// MARK: Chapter 1

//typealias FunctionalProcedure<T> = (Any, Any...) -> T

//typealias HomogeneousFunction<T, U> = (U, U ...) -> T

typealias UnaryFunction<T: RegularType> = (T) -> Any

// MARK: Chapter 2

//typealias Predicate = (Any, Any...) -> Bool

//typealias HomogeneousPredicate<T> = (T, T ...) -> Bool

typealias UnaryPredicate<T: RegularType> = (T) -> Bool
typealias P<T: RegularType> = UnaryPredicate<T>

// typealias Operation<T> = (T, T ...) -> T

typealias UnaryOperation<T: RegularType> = (T) -> T
typealias F<T: RegularType> = UnaryOperation<T>

typealias BinaryOperation<T: RegularType> = (T, T) -> T
typealias Op<T: RegularType> = BinaryOperation<T>

// typealias DefinitionSpacePredicate (Any, Any...) -> Bool
// precondition: Returns true if and only if the inputs are within the
//               definition space of the procedure

typealias Transformation<T: RegularType> = UnaryOperation<T>
