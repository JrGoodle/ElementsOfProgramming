// print.h

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


// Printing various types to standard output for
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009


#ifndef EOP_PRINT
#define EOP_PRINT


#include "intrinsics.h"
#include "eop.h"

#include <cstdio> // printf


void print(const char* x)
{
    printf("%s", x);
}

void print(const char x)
{
    printf("%c", x);
}

void print(const int x)
{
    printf("%d", x);
}

void print(const unsigned int x)
{
    printf("%u", x);
}

void print(const double x)
{
    printf("%f", x);
}

void print(const long int x)
{
    printf("%ld", x);
}

// Same as int in Visual C++:
//void print(const ptrdiff_t x)
//{
//    printf("%lu", x);
//}

void print(const long unsigned x)
{
    printf("%lu", x);
}

void print(const long long int x)
{
    printf("%lld", x);
}

void print(const long long unsigned x)
{
    printf("%llu", x);
}

void print_eol()
{
    print("\n");
}

template<typename T0, typename T1>
    requires(Regular(T0) && Regular(T1))
void print(const pair<T0, T1>& x)
{
    print("pair(");
        print(x.m0); print(", "); print(x.m1);
    print(")");
}

template<typename I>
    requires(Readable(I) && Iterator(I))
void print_range(I f, I l)
{
    // Precondition: $\property{readable\_bounded\_range}(f, l)$
    while (f != l) {
        print(source(f));
        f = successor(f);
        if (f != l) print(" ");
    }
}

template<typename T>
    requires(Regular(T))
void print(const slist<T>& x)
{
    print("slist[");
        print(int(size(x)));
    print("](");
        print_range(begin(x), end(x));
    print(")");
}

template<typename T>
    requires(Regular(T))
void print(const list<T>& x)
{
    print("list[");
        print(int(size(x)));
    print("](");
        print_range(begin(x), end(x));
    print(")");
}

template<typename C>
    requires(BifurcateCoordinate(C))
struct print_visit
{
    bool b_pre, b_in, b_post;
    print_visit(bool b_pre, bool b_in, bool b_post) : 
        b_pre(b_pre), b_in(b_in), b_post(b_post) { }
    void operator()(visit v, C c)
    {
        if (v == pre && b_pre || v == in && b_in || v == post && b_post) {
            print(source(c));
            print(" ");
        }
    }
};

template<typename C>
    requires(BifurcateCoordinate(C))
void print_bifurcate(C c)
{
    if (empty(c)) {
        print("/");
        return;
    }
    print("(");
        print(source(c));
        if (has_left_successor(c) || has_right_successor(c)) {
            print(".");
            print_bifurcate(left_successor(c));
            print(".");
            print_bifurcate(right_successor(c));
        }
    print(")");
}

template<typename C>
    requires(BifurcateCoordinate(C))
void print_node(C c)
{
    if (empty(c)) print("/");
    else print(source(c));
}

template<typename C>
    requires(BifurcateCoordinate(C))
void print_coordinate(C c)
{
    if (empty(c)) print("/");
    else { print(source(c)); print(","); }
}

template<typename T>
    requires(Regular(T))
void print(const stree<T>& x)
{
    print_bifurcate(begin(x));
}

template<typename T>
    requires(Regular(T))
void print(const tree<T>& x)
{
    print_bifurcate(begin(x));
}

template<int k, typename T>
    requires(Regular(T))
void print(const array_k<k, T>& x)
{
    print("array_k[");
        print(int(size(x)));
    print("](");
        print_range(begin(x), end(x));
    print(")");
}

template<typename T>
    requires(Regular(T))
void print(const array<T>& x)
{
    print("array[");
        print(int(size(x)));
    print("](");
        print_range(begin(x), end(x));
    print(")");
}


#endif // EOP_PRINT
