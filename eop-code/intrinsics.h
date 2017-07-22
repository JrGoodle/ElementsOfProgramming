// intrinsics.h

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


// Implementations from Appendix B.2 of
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009


#ifndef EOP_INTRINSICS
#define EOP_INTRINSICS


#include <new> // placement operator new


// As explained in Appendix B.2, to allow the language defined in Appendix B.1
// to compile as a valid C++ program, a few macros and structure
// definitions are necessary.


// Template constraints

//  The requires clause is implemented with this macro (this
//  implementation treats requirements as documentation only):

#define requires(...)


// Intrinsics

//  pointer(T) and addressof(x) are introduced to give us a simple
//  linear notation and allow simple top-down parsing. They are
//  implemented as:

#define pointer(T) T*

template<typename T>
pointer(T) addressof(T& x)
{
    return &x;
}


// In-place construction and destruction (not in Appendix B.2)

template<typename T>
    requires(Regular(T))
void construct(T& p)
{
    // Precondition: $p$ refers to raw memory, not an object
    // Postcondition: $p$ is in a default-constructed state
    new (&p) T();
}

template<typename T, typename U>
    requires(Regular(T) && Constructible(T, U))
void construct(T& p, const U& initializer)
{
    // Precondition: $p$ refers to raw memory, not an object
    // Postcondition: Default makes $p = initializer$
    // Override $\func{construct}$ to specialize construction of a part of a 
    new (&p) T(initializer);
}    

template<typename T>
    requires(Regular(T))
void destroy(T& p)
{
    // Precondition: $p$ is in a partially-formed state
    // Postcondition: $p$ refers to raw memory, not an object
    p.~T();
}

template<typename T, typename U>
    requires(Regular(T))
void destroy(T& p, U& finalizer)
{
    // Precondition: $p$ is in a partially-formed state
    // Postcondition: $p$ refers to raw memory, not an object
    // Override $\func{destroy}$ to specialize destruction of a part of a container
    destroy(p);
}


// Type functions: see type_functions.h

#endif // EOP_INTRINSICS

