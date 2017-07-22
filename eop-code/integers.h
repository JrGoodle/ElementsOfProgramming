// integers.h

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


// Implementation for integral types of special-case Integer procedures from
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009


#ifndef EOP_INTEGERS
#define EOP_INTEGERS


#include "intrinsics.h"

#include <ciso646> // bitand


// Exercise 3.2

template<typename I>
    requires(Integer(I))
I successor(const I& a)
{
    return a + I(1);
}

template<typename I>
    requires(Integer(I))
I predecessor(const I& a)
{
    return a - I(1);
}

template<typename I>
    requires(Integer(I))
I twice(const I& a)
{
    return a + a;
}

template<typename I>
    requires(Integer(I))
I half_nonnegative(const I& a)
{
    return a >> I(1);
}

template<typename I>
    requires(Integer(I))
I binary_scale_down_nonnegative(const I& a, const I& k)
{
    return a >> k;
}

template<typename I>
    requires(Integer(I))
I binary_scale_up_nonnegative(const I& a, const I& k)
{
    return a << k;
}

template<typename I>
    requires(Integer(I))
bool positive(const I& a)
{
    return I(0) < a;
}

template<typename I>
    requires(Integer(I))
bool negative(const I& a)
{
    return a < I(0);
}

template<typename I>
    requires(Integer(I))
bool zero(const I& a)
{
    return a == I(0);
}

template<typename I>
    requires(Integer(I))
bool one(const I& a)
{
    return a == I(1);
}

template<typename I>
    requires(Integer(I))
bool even(const I& a)
{
    return (a bitand I(1)) == I(0);
}

template<typename I>
    requires(Integer(I))
bool odd(const I& a)
{
    return (a bitand I(1)) != I(0);
}


// Chapter 5: definition of half for Integer types, to model HalvableMonoid:

template<typename I>
    requires(Integer(I))
I half(const I& x) { return half_nonnegative(x); }


#endif // EOP_INTEGERS

