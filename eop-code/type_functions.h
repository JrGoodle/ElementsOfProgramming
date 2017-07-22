// type_functions.h

// Copyright (c) 2009 Alexander Stepanov and Paul McJones
//
// Permission to use, copy, modify, distribute and sell this software
// and its documentation for any purpose is hereby granted without
// fee, provided that the above copyright notice appear in all copies
// and that both that copyright notice and this permission notice
// appear in supporting documentation. The authors make no
// representations about the suitability of this software for any
// purpose. It is provided "as is" without express or implied
// warranty.


// Implementations of type functions for
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009


#ifndef TYPE_FUNCTIONS
#define TYPE_FUNCTIONS


#include "intrinsics.h"


//  As explained in Appendix B.2, to allow the language defined above
//  to compile as a valid C++ program, a few macros and structure
//  definitions are necessary.


// Type functions

//  Type functions are implemented using a C++ technique called a
//  trait class. For each type function, say ValueType, we define a
//  corresponding structure template, say value_type<T>. The structure
//  template contains one typedef, named type by convention; if
//  appropriate, a default can be provided in the base structure
//  template:

// template<typename T>
// struct value_type
// {
//     typedef T type;
// };

// To provide a convenient notation, we define a macro that extracts
// the typedef as the result of the type function (such a macro works
// only inside a template definition because of the use of the keyword
// typename):

// #define ValueType(T) typename value_type< T >::type

// We refine the global definition for a particular type by
// specializing:
          
// template<typename T>
// struct value_type<pointer(T)>
// {
//     typedef T type;
// };


// Chapter 1 - Foundations


// Codomain : FunctionalProcedure -> Regular

template<typename T>
    requires(FunctionalProcedure(T))
struct codomain_type;

#define Codomain(T) typename codomain_type< T >::type


// InputType : FunctionalProcedure x unsigned int -> Regular

template<typename T, int i>
    requires(FunctionalProcedure(T))
struct input_type;

#define InputType(T, i) typename input_type< T, i >::type


// Domain : HomogeneousFunction -> Regular

#define Domain(T) InputType(T, 0)


// Chapter 2 - Transformations and their orbits


// See the discussion of distance types in section 2.2.

// DistanceType : Transformation -> Integer

template<typename F>
    requires(Transformation(F))
struct distance_type;

// If all transformations on a type T have the same distance type,
// then DistanceType(T) is defined and returns that type.

// For any fixed-size type T, there is an integral type of the same
// size that is a valid distance type for T.

template<>
struct distance_type<int>
{
    typedef unsigned int type;
};

template<>
struct distance_type<long long>
{
    typedef unsigned long long type;
};


#define DistanceType(T) typename distance_type< T >::type


// Chapter 3 - Associative operations

template<typename T> 
    requires(Regular(T)) 
struct input_type<T (*)(T x, T y), 0> 
{ 
    typedef T type; 
};

template<typename T> 
    requires(Regular(T)) 
struct codomain_type<T (*)(T x, T y)> 
{ 
    typedef T type; 
};

template<typename T> 
    requires(Regular(T)) 
struct input_type<T (*)(const T& x, const T& y), 0> 
{ 
    typedef T type; 
};

template<typename T> 
    requires(Regular(T)) 
struct codomain_type<T (*)(const T& x, const T& y)> 
{ 
    typedef T type; 
};


// Chapter 4 - Linear orderings


// Domain type function for Predicate

template<typename T> 
    requires(Regular(T)) 
struct input_type<bool (*)(T x), 0> 
{ 
    typedef T type; 
};

template<typename T> 
    requires(Regular(T)) 
struct input_type<bool (*)(const T& x), 0> 
{ 
    typedef T type; 
};


// Domain type function for Relation

template<typename T> 
    requires(Regular(T)) 
struct input_type<bool (*)(T x, T y), 0> 
{ 
    typedef T type; 
};

template<typename T> 
    requires(Regular(T)) 
struct input_type<bool (*)(const T& x, const T& y), 0> 
{ 
    typedef T type; 
};


// Chapter 5 - Ordered algebraic structures

template<typename T>
    requires(ArchimedeanMonoid(T))
struct quotient_type;
#define QuotientType(T) typename quotient_type< T >::type


// Lemma: For an integral type T, QuotientType(T) has to be at least as large as T.

template<>
struct quotient_type<int>
{
    typedef int type;
};

template<>
struct quotient_type<long>
{
    typedef long type;
};


// Chapter 6 - Iterators


// ValueType : Readable -> Regular

template<typename T>
    requires(Regular(T))
struct value_type
{
    typedef T type;
};

#define ValueType(T) typename value_type< T >::type


// DifferenceType : RandomAccessIterator -> Integer

template<typename I>
    requires(RandomAccessIterator(I))
struct difference_type;

#define DifferenceType(T) typename difference_type< T >::type


// Chapter 7 - Coordinate structures


// WeightType : BifurcateCoordinate -> Integer

template<typename T>
    requires(WeakBifurcateCoordinate(T))
struct weight_type;

#define WeightType(T) typename weight_type< T >::type


// Chapter 8 - Coordinates with mutable successors


// IteratorType : ForwardLinker -> ForwardIterator
// IteratorType : BackwardLinker -> BidirectionalIterator

template<typename T>
    requires(ImplementsIteratorType(T))
struct iterator_type;

#define IteratorType(T) typename iterator_type< T >::type


// Chapter 10 - Rearrangements


// The IteratorTag concept has the following models:

struct iterator_tag               {};
struct forward_iterator_tag       {};
struct bidirectional_iterator_tag {};
struct indexed_iterator_tag       {};
struct random_access_iterator_tag {};


// IteratorConcept : Iterator -> IteratorTag

template<typename T>
    requires(Iterator(T))
struct iterator_concept
{
    typedef iterator_tag concept;
};

#define IteratorConcept(T) typename iterator_concept< T >::concept


// Chapter 12 - Composite objects


// SizeType : Linearizeable -> Integer

template<typename W>
    requires(Linearizable(W))
struct size_type;

#define SizeType(W) typename size_type<W>::type


// Size : ConstantSizeSequence -> Integer

// Size is a type attribute

template<typename S>
    requires(ConstantSizeSequence(S))
struct size_value;

#define Size(S) size_value<S>::value


// BaseType : Position -> DynamicSequence

template<typename S>
    requires(DynamicSequence(S))
struct base_type;

#define BaseType(T) typename base_type<T>::type


// concept BooleanType(T) means T represents a boolean value within the type system

// BooleanType has the following two models:

struct true_type {};
struct false_type {};

// NeedsConstruction : Regular -> BooleanType
// NeedsDestruction  : Regular -> BooleanType

template<typename T>
    requires(Regular(T))
struct needs_construction_type
{
    typedef true_type type; // default
};

#define NeedsConstruction(T) typename needs_construction_type<T>::type

template<typename T>
    requires(Regular(T))
struct needs_destruction_type
{
    typedef true_type type; // default
};

#define NeedsDestruction(T) typename needs_destruction_type<T>::type

template<>
struct needs_construction_type<int>
{
    typedef false_type type;
};

template<>
struct needs_destruction_type<int>
{
    typedef false_type type;
};

// NeedsConstruction and NeedsDestruction should be similarly overloaded
// for every POD type


// CoordinateType : Container -> Coordinate

template<typename T>
    requires(Container(T))
struct coordinate_type;

#define CoordinateType(T) typename coordinate_type<T>::type


// UnderlyingType : Regular -> Regular

template<typename T> requires(Regular(T))
struct underlying_type
{
    typedef T type; // default
};

#define UnderlyingType(T) typename underlying_type<T>::type


#endif // TYPE_FUNCTIONS
