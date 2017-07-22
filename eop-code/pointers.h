// pointers.h

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


// Definitions of type functions and global functions from concepts
// Readable, Writeable, Mutable, Iterator, BidirectionalIterator
// for types const T& and pointer(T) from
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009


#ifndef EOP_POINTERS
#define EOP_POINTERS


#include "intrinsics.h"
#include "type_functions.h"

#include <cstddef> // ptrdiff_t


template<typename T>
    requires(Regular(T))
struct value_type<pointer(T)>
{
    typedef T type;
};

template<typename T>
    requires(Regular(T))
const T& source(pointer(T) x)
{
    return *x;
}

template<typename T>
    requires(Regular(T))
const T& source(const T& x)
{
    return x;
}

template<typename T>
    requires(Regular(T))
struct distance_type<pointer(T)>
{
    typedef ptrdiff_t type;
};

template<typename T>
    requires(Regular(T))
pointer(T) successor(pointer(T) x)
{
    return x + ptrdiff_t(1);
}

template<typename T>
    requires(Regular(T))
pointer(T) predecessor(pointer(T) x)
{
    return x - ptrdiff_t(1);
}

template<typename T>
    requires(Regular(T))
T& sink(pointer(T) x)
{
    return *x;
}

template<typename T>
    requires(Regular(T))
T& sink(T& x)
{
    return x;
}

template<typename T>
    requires(Regular(T))
T& deref(pointer(T) x)
{
    return *x;
}

//template<typename T>
//    requires(Regular(T))
//T& deref(T& x)
//{
//    return x;
//}

template<typename T>
    requires(Regular(T))
struct iterator_concept<T*>
{
    typedef random_access_iterator_tag concept;
};

#endif // EOP_POINTERS

