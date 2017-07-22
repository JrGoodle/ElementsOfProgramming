// read.h

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


// Reading various types from standard input for
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009


#ifndef EOP_READ
#define EOP_READ


#include <cstdio> // scanf


void read(int& x)
{
    scanf("%d", &x);
}

void read(long int& x)
{
    scanf("%ld", &x);
}

void read(long long int& x)
{
    scanf("%lld", &x);
}


#endif // EOP_READ
