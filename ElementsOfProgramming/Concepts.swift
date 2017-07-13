//
//  Concepts.swift
//  ElementsOfProgramming
//

// MARK: Chapter 1

//typealias FunctionalProcedure<T> = (Any, Any ...) -> T

//typealias HomogeneousFunction<T, U> = (U, U ...) -> T

typealias UnaryFunction<T> = (T) -> Any where T: RegularType

// MARK: Chapter 2

//typealias Predicate = (Any, Any ...) -> Bool

//typealias HomogeneousPredicate<T> = (T, T ...) -> Bool

typealias UnaryPredicate<T> = (T) -> Bool
typealias P<T> = UnaryPredicate<T>

// typealias Operation<T> = (T, T ...) -> T

// Unary Operation
typealias F<T> = (T) -> T

// Binary Operation
typealias BinaryOperation<T> = (T, T) -> T
typealias Op<T> = BinaryOperation<T>

// typealias DefinitionSpacePredicate (Any, Any ...) -> Bool
// precondition: Returns true if and only if the inputs are within the
//               definition space of the procedure

typealias Transformation<T> = (T) -> T

