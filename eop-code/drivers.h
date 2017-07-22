// drivers.h

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


// Drivers for interactive use of algorithms from
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009


#ifndef EOP_DRIVERS
#define EOP_DRIVERS


#include "intrinsics.h"
#include "type_functions.h"
#include "integers.h"
#include "eop.h"
#include "print.h"
#include "read.h"
#include "assertions.h"


// Chapter 2 - Transformations and their orbits


template<typename F, typename P>
    requires(Transformation(F) && T == Domain(F) &&
        UnaryPredicate(P) && Domain(F) == Domain(P))
void output_orbit_structure(Domain(F) x, F f, P p)
{
    triple<DistanceType(F), DistanceType(F), Domain(F)> t =
        orbit_structure(x, f, p);
    if (!p(t.m2)) {
        print("terminating with h-1 = "); print(t.m0);
        print(" and terminal point "); print(t.m2);
    } else if (t.m2 == x) {
        print("circular with collision point "); print(collision_point(x, f, p));
        print(" and c-1 = "); print(t.m1);
    } else {
        print("rho-shaped with collision point "); print(collision_point(x, f, p));
        print(" and h = "); print(t.m0);
        print(" and c-1 = "); print(t.m1);
        print(" and connection point "); print(t.m2);
    }
    print_eol();
}

template<typename I>
    requires(Integer(I))
struct additive_congruential_transformation
{
    I modulus;
    I index;
    additive_congruential_transformation(I modulus, I index) :
        modulus(modulus), index(index) { }
    I operator()(I x) { return remainder(x + index, modulus); }
};

template<typename I>
    requires(Integer(I))
struct input_type<additive_congruential_transformation<I>, 0>
{
    typedef I type;
};


// Definition space predicate for total transformation

template <typename T>
bool always_defined(const T&)
{
    return true;
}

template<>
struct distance_type< additive_congruential_transformation<int> >
{
    typedef unsigned int type;
};

void run_additive_congruential_transformation()
{
    print("Enter a positive integer modulus:\n");
    int modulus;
    read(modulus);
    print("Enter an integer starting element less than the modulus, or 99 to end.\n");
    while (true) {
        int x;
        read(x);
        if (x == 99) return;
        output_orbit_structure(
            x,
            additive_congruential_transformation<int>(modulus, x), always_defined<int>);
    }        
}

template<typename I>
    requires(Readable(I) && IndexedIterator(I) && ValueType(I) == DistanceType(I))
struct table_transformation
{
    typedef DistanceType(I) N;
    const I p;
    const N n;
    table_transformation(const I p, const N n) : p(p), n(n) {}    
    int operator()(N x)
    {
        return source(p + x);
    }    
};

template<typename I>
    requires(Readable(I) && IndexedIterator(I) && ValueType(I) == DistanceType(I))
struct table_transformation_definition_space_predicate
{
    typedef table_transformation<I> T;
    typedef DistanceType(I) N;
    const T& tbl;
    table_transformation_definition_space_predicate(const T& tbl) : tbl(tbl) { }
    bool operator()(N x)
    {
        return N(0) <= x && x < tbl.n;
    }
};

template<typename I>
    requires(Readable(I) && IndexedIterator(I) && ValueType(I) == DistanceType(I))
struct input_type<table_transformation<I>, 0>
{
    typedef ValueType(I) type;
};

template<typename I>
    requires(Readable(I) && IndexedIterator(I) && ValueType(I) == DistanceType(I))
struct distance_type< table_transformation<I> >
{
    typedef DistanceType(I) type;
};

void run_table_transformation()
{
    print(
        "Enter sequence of integers terminated by negative integer;\n"
        "enter empty sequence (a single negative integer) to end:\n");
    while (true) {
        typedef array<int> T_0;
        typedef size_type< T_0 >::type N_0;
        typedef array<N_0> T;
        typedef size_type< T   >::type N; // hopefully N = N_0
        typedef iterator_type< T >::type I; // i.e., pointer(int)
        T a;
        while (true) {
  	        N x;
	        read(x);
            if (x < 0) break;
            insert(back< T >(a), x);
        }
        if (empty(a)) return;
        table_transformation<I> trans(begin(a), size(a));
        table_transformation_definition_space_predicate<I> pred(trans);
        output_orbit_structure(N(0), trans, pred);
    }
}

struct srand_transformation // Transformation(srand_transformation)
{
    int operator()(int x)
    {
        srand(x);
        return rand();
    }
};

template<>
struct input_type<srand_transformation, 0>
{
    typedef int type;
};

template<>
struct distance_type<srand_transformation>
{
    typedef unsigned int type;
};

void run_srand_transformation()
{     
    print("Enter an integer or zero to end:\n");
    while (true) {
        int x;
        read(x);
        if (x == 0) return;
        output_orbit_structure(x, srand_transformation(), always_defined<int>);
    }        
}

template<typename T>
    requires(Regular(T))
void push(array<T>& x, const T& y) {
    insert(back< array<T> >(x), y);
}

struct LCG // linear congruential generator
{
    typedef long long T;
    T m, a, b, x0;
    const pointer(char) name;
    LCG(T m, T a, T b, T x0, const pointer(char) name) :
        m(m), a(a), b(b), x0(x0), name(name) { }
    T operator()(T x) { return (a * x + b) % m; }
};

template<>
struct input_type<LCG, 0>
{
    typedef long long type;
};

template<>
struct distance_type<LCG>
{
    typedef unsigned long long type;
};

void run_lcg_transformation()
{
    array<LCG> lcg;
    // From:
    //   A collection of classical pseudorandom number generators with linear structures -
    //       advanced version
    //   Karl Entacher, June 16, 2000
    //   http://crypto.mat.sbg.ac.at/results/karl/server/server.html
    push(lcg, LCG(100000000ll+1ll,          23ll,     0ll, 47594118ll, "Lehmer 1949"));
                                                              // c-1 =    5882351
    push(lcg, LCG( 0x80000000ll,   11035135245ll, 12345ll, 12345ll,    "ANSIC"));
                                                              // c-1 = 2147483647 = 2^31-1
    push(lcg, LCG( 0x80000000ll, /*7^5*/ 16807ll,     0ll,     1ll,    "MINSTD"));
                                                              // c-1 =  268435455
    push(lcg, LCG( 0x80000000ll,   0x10000ll+3ll,     0ll,     1ll,    "RANDU"));
                                                              // c-1 =  536870911
    push(lcg, LCG( 0x80000000ll-1ll, 630360016ll,     0ll,     1ll,    "SIMSCRIPT"));
                                                              // c-1 = 2147483645
    push(lcg, LCG(0x800000000ll, /*5^15*/ 30517578125ll, 7261067085ll, 0ll, "BCSLIB"));
                                                              // c-1 = 4294967295 on 32-bit machine or:
                                                              //      34359738367
    push(lcg, LCG( 0x80000000ll,     452807053ll,     0ll,     1ll,    "URN12"));
                                                              // c-1 =  536870911
    push(lcg, LCG(0x800000000ll, /*5^13*/ 1220703125ll, 0ll, 1ll,      "APPLE"));
                                                              // c-1 = 4294967295 on 32-bit machine or:
                                                              //       8589934591
    push(lcg, LCG(0x100000000ll,         69069ll,     0ll, 1ll,        "Super-Duper"));
                                                              // c-1 = 1073741823
    push(lcg, LCG(0x100000000ll, 2147001325ll, 715136305ll, 0ll,       "BCPL"));
                                                              // c-1 = 4294967295
    push(lcg, LCG(576460752303423488ll,302875106592253ll,0ll,530242871347629333ll,
                                                                       "NAG"));
    push(lcg, LCG(281474976710656ll,25214903917ll,    11,  0ll,        "DRAND48"));
    push(lcg, LCG(281474976710656ll, 44485709377909ll, 0ll, 1ll,       "RANF"));
    push(lcg, LCG(999999999989ll, 427619669081ll,      0ll, 1ll,       "MAPLE"));
                                                              // c-1 =    399149
    push(lcg, LCG(0x100000000ll, 1664525,     1013904223ll, 0ll, "Numerical Recipes in C"));
                                                              // c-1 = 4294967295 = 2^32-1

    print("Enter an index (out of range to end)"
          " and a seed (negative to use default):\n");
    int i(0);
    pointer(LCG) p = begin(lcg);
    while (i < size(lcg)) {
        print("  "); print(i); print(" "); print(source(p + i).name); print_eol();
        i = successor(i);
    }
    while (true) {
        int i;
        LCG::T x;
        read(i);
        read(x);
        if (!(0 <= i && int(i) < size(lcg))) return;
        if (x < 0) x = source(p + i).x0;
        print("orbit of "); print(x);
        print(" under "); print(source(p + i).name);
        print(": ");
        output_orbit_structure(source(p + i).x0, source(p + i), always_defined<LCG::T>);
    }        
}

void run_any_lcg_transformation()
{
    print("Enter m, a, b, and seed:\n");
    LCG::T m, a, b, x0;
    read(m); read(a); read(b); read(x0);
    print("orbit of "); print(x0);
    print(" under LCG("); print(m);
    print(","); print(a); print(","); print(b);
    print("): ");
    output_orbit_structure(x0, LCG(m, a, b, x0, "any"), always_defined<LCG::T>);
}


// Chapter 3 - Ordered algebraic structures

template<typename T>
    requires(DiscreteEuclideanSemiring(T))
struct multiplies_modulo {
    T m;
    multiplies_modulo(const T& m) : m(m) { }
    T operator()(const T& x, const T& y) const { return (x * y) % m; }
};

template<typename T>
    requires(DiscreteEuclideanSemiring(T))
struct input_type< multiplies_modulo<T>, 0 >
{
    typedef T type;
};

void run_idempotent_power()
{     
    print("Enter a pair of integers (starting element and modulus)");
    print(" or two zeroes to end:\n");
    while (true)
    {
        typedef multiplies_modulo<int> M;
        int n, m;
        read(n); read(m);
        if (n == 0 && m == 0) return;
        multiplies_transformation< M > g(n, M(m));
        int p = collision_point(n, g, always_defined<int>);
        print("idempotent_power()("); print(n); print(", multiplication modulo ");
            print(m); print(") == ");
        	print(p); print_eol();
        Assert(p == multiplies_modulo<int>(m)(p, p));
    }      
}

void run_fibonacci()
{     
    print("Enter an integer or a negative integer to end:\n");
    while (true)
    {
        int n;
        read(n);
        if (n < 0) return;
        print("fibonacci("); print(n); print(") == ");
        print(fibonacci<long long>(n)); print_eol();
    }      
}

template<typename T>
    requires(AdditiveMonoid(T))
struct annotated_plus
{
    T operator()(const T& x, const T& y)
    {
        T tmp = x + y;
        print(x); print(" + "); print(y); print(" == "); print(tmp); print_eol();
        return tmp;
    }
};

template<typename T>
    requires(AdditiveMonoid(T))
struct input_type< annotated_plus<T>, 0>
{
    typedef T type;
};

template<typename T>
    requires(AdditiveMonoid(T))
struct codomain_type< annotated_plus<T> >
{
    typedef T type;
};

template<typename T>
    requires(AdditiveMonoid(T))
struct annotated_negate
{
    T operator()(const T& x)
    {
        T tmp = -x;
        print("0 - "); print(x); print(" == "); print(tmp); print_eol();
        return tmp;
    }
};

template<typename T>
    requires(AdditiveGroup(T))
annotated_negate<T> inverse_operation(annotated_plus<T>& plus)
{
    return annotated_negate<T>(source(plus.o));
}

void run_egyptian_multiplication()
{     
    print("Enter two integers or two zeros to end:\n");
    while (true)
    {
        int x, n;
        read(x); read(n);
        if (x == 0 && n == 0) return;
        print("\nslow_power\n");
        power_0(x, n, annotated_plus<int>());
        print("\npower\n");
        power(x, n, annotated_plus<int>());
    }
}


// Chapter 4 - Linear orderings


// Chapter 5 - Combining concepts

template<typename T>
    requires(EuclideanSemiring(T))
struct modulus
{
    T operator()(const T& x, const T& y) const { return x % y; }
};

template<typename T>
    requires(EuclideanSemiring(T))
struct input_type< modulus<T>, 0 >
{
    typedef T type;
};

template<typename T>
    requires(EuclideanSemiring(T))
struct quo_rem
{
    typedef QuotientType(T) I;
    pair<I, T> operator()(const T& a, const T& b)
    {
        return pair<I, T>(a / b, a % b);
    }
};

template<typename T>
    requires(EuclideanSemiring(T))
struct input_type< quo_rem<T>, 0 >
{
    typedef T type;
};

void run_quotient_remainder()
{
    print("Enter two integers, or two zeroes to terminate:\n");
    while (true) {
        int a;
        int b;
        read(a); read(b);
        if (a == 0 && b == 0) return;
        print("                             slow_remainder = ");
            print(slow_remainder(a, b)); print_eol();
        print("remainder_nonnegative_with_largest_doubling = ");
            print(remainder_nonnegative_with_largest_doubling(a, b)); print_eol();
        print("                                  remainder = ");
            print(remainder(a, b, modulus<int>())); print_eol();
        pair<int, int> p;
        p = quotient_remainder(a, b, quo_rem<int>());
        print("                         quotient_remainder = ");
            print(p.m0); print("   "); print(p.m1); print_eol();
        p = quotient_remainder_nonnegative_iterative<int>(a, b);
        print("               quotient_remainder_iterative = ");
            print(p.m0); print("   "); print(p.m1); print_eol();
    }      
}


// Default remainder for EuclideanSemiring

template<typename T>
    requires(EuclideanSemiring(T))
T remainder(T a, T b)
{
    return a % b;
}


// Default remainder for EuclideanSemimodule

template<typename T, typename S>
    requires(EuclideanSemimodule(T, S))
T remainder(T a, T b)
{
    return remainder_nonnegative(a, b);
}

void run_gcd()
{
    print("Enter two integers, or two zeroes to terminate\n");
    while (true) {
        int a;
        int b;
        read(a); read(b);
        if (a == 0 && b == 0) return;
        print("fast_subtractive_gcd = ");
            print(fast_subtractive_gcd(a, b)); print_eol();
        print("gcd<int, int> = ");
            print(gcd<int, int>(a, b)); print_eol();
        print("binary_gcd_nonnegative(abs(), abs()) = ");
            print(stein_gcd_nonnegative(abs(a), abs(b))); print_eol();
    }      
}


// Chapter 6 - Iterators
// Chapter 7 - Coordinate structures
// Chapter 8 - Coordinates with mutable successors
// Chapter 9 - Copying
// Chapter 10 - Rearrangements
// Chapter 11 - Partition and merging


// Chapter 12 - Composite objects

template<typename T>
    requires(Regular(T))
struct verify_conservation
{
    const T* t;
    T t_0;
    verify_conservation(const T& t) : t(addressof(t)), t_0(t) { }
    ~verify_conservation()
    {
      Assert(source(t) == t_0);
    }
};

void run_slist_tests()
{
    verify_conservation<int> v(slist_node_count);

    int a1[] = {1, 3, 5};
    slist<int> l1(counted_range<int*>(a1, 3));
    print("l1: "); print(l1); print_eol();
    int a2[] = {2, 4, 6};
    slist<int> l2(counted_range<int*>(a2, 3));
    print("l2: "); print(l2); print_eol();
    merge(l1, l2, less<int>());
    print("merge: "); print(l1); print_eol();
    partition(l1, l2, odd<int>);
    print("partition     odd: "); print(l2); print_eol();
    print("partition not odd: "); print(l1); print_eol();
    erase_all(l1);
    merge_copy_n(a1, 3, a2, 3, insert_iterator< after< slist<int> > >(
        after< slist<int> >(l1, end(l1))), less<int>());
    print("merge copy: "); print(l1); print_eol();

    int a[] = {17, 29, 0, 1001, 47, 3, 2, 1, 124, 49, 981, 3, 29};
    const int a_size = sizeof(a) / sizeof(int);
    print("List:          "); print_range(a, a + a_size); print_eol();
    slist<int> l(counted_range<int*>(a, a_size));
    slist<int> ll(l);
    print("Initial slist: "); print(l); print_eol();
    print("Copy:          "); print(ll); print_eol();
    sort(l, less<int>());
    print("Sorted:        "); print(l); print_eol();
}

void run_list_tests()
{
    
    verify_conservation<int> v(list_node_count);

    int a1[] = {1, 3, 5};
    list<int> l1(counted_range<int*>(a1, 3));
    print("l1: "); print(l1); print_eol();
    int a2[] = {2, 4, 6};
    list<int> l2(counted_range<int*>(a2, 3));
    print("l2: "); print(l2); print_eol();
    merge(l1, l2, less<int>());
    print("merge: "); print(l1); print_eol();
    partition(l1, l2, odd<int>);
    print("partition     odd: "); print(l2); print_eol();
    print("partition not odd: "); print(l1); print_eol();
    erase_all(l1);
    merge_copy_n(a1, 3, a2, 3, insert_iterator< after< list<int> > >(
        after< list<int> >(l1, end(l1))), less<int>());
    print("merge copy: "); print(l1); print_eol();

    int a[] = {17, 29, 0, 1001, 47, 3, 2, 1, 124, 49, 981, 3, 29};
    const int a_size = sizeof(a) / sizeof(int);
    print("List:         "); print_range(a, a + a_size); print_eol();
    list<int> l(counted_range<int*>(a, a_size));
    list<int> ll(l);
    print("Initial list: "); print(l); print_eol();
    print("Copy:         "); print(ll); print_eol();
    sort(l, less<int>());
    print("Sorted:       "); print(l); print_eol();
}

template<typename C>
     requires(EmptyLinkedBifurcateCoordinate(C))
struct serializer
{
    typedef WeightType(C) N;
    N n;
    serializer() : n(0) { }
    void operator()(C c) {
        if (n == 0) { print(source(c)); print(" "); }
        else        print(". ");
        if (empty(left_successor(c))) print("/ ");
        n = successor(n);
        if (n == 3) n = 0;
    }
};

template<typename C>
    requires(EmptyLinkedBifurcateCoordinate(C))
void stree_serialize(C c)
{
    traverse_rotating(c, serializer<C>());
}

template<typename C>
    requires(EmptyLinkedBifurcateCoordinate(C))
void tree_serialize(C c)
{
    traverse_rotating(c, serializer<C>());
}

void run_stree_tests()
{
    typedef stree<int> T;
    typedef stree<char> TT;
    typedef stree_coordinate<int> I;
    typedef stree_coordinate<char> II;

    verify_conservation<int> v(stree_node_count);
    T t4(4);
    print("t4:         "); print(t4); print_eol();
    T t3_45(3, t4, T(5));
    print("t3_45:      "); print(t3_45); print_eol();
    T t2_345_678(2, t3_45, T(6, T(7), T(8)));
    //T u2_345_678(t2_345_678);
    print("t2_345_678: "); print(t2_345_678); print_eol();
    T t(1, t2_345_678, T(9, T(10, T(11), T(12)), T(13, T(14), T(15))));
    print("t:          "); print(t); print_eol();
    traverse_rotating(begin(t3_45), print_coordinate<I>); print_eol();
    traverse_rotating(begin(t3_45), print_coordinate<I>); print_eol();
    traverse_rotating(begin(t3_45), print_coordinate<I>); print_eol();
    traverse_rotating(begin(t3_45), print_coordinate<I>); print_eol();
    traverse_rotating(begin(t2_345_678), print_coordinate<I>); print_eol();
    traverse_rotating(begin(t), print_coordinate<I>); print_eol();
    print("stree_serialize of t3_45: "); stree_serialize(begin(t3_45)); print_eol();
    T u(t);
    print("Preorder  traversal of t: ");
        traverse(t, print_visit<I>(true, false, false)); print_eol();
    print("Inorder   traversal of t: ");
        traverse(t, print_visit<I>(false, true, false)); print_eol();
    print("Postorder traversal of t: ");
        traverse(t, print_visit<I>(false, false, true)); print_eol();
    Assert(t == u);
    Assert(!(t < u) && !(u < t));
    Assert(T() < T(0));
    Assert(!(T(0) < T()));
    Assert(T(0) < T(1));
    Assert(!(T(1) < T(0)));
    Assert(T(0, T(1, T(), T()), T()) < T(1, T(), T()));
    Assert(!(T(1, T(), T()) < T(0, T(1, T(), T()), T())));
    Assert(T(0, T(), T()) < T(0, T(0), T()));
    Assert(!(T(0, T(0), T()) < T(0, T(), T())));
    Assert(T(0, T(), T()) < T(0, T(), T(0)));
    Assert(!(T(0, T(), T(0)) < T(0, T(), T())));
    Assert(T(0, T(0), T()) < T(0, T(0), T(0)));
    Assert(!(T(0, T(0), T(0)) < T(0, T(0), T())));
    {
        array< T > a;
        push(a, T(0, T(0), T()));
        push(a, T(0, T(0), T(0)));
        push(a, T(0, T(), T()));
        push(a, T(0, T(), T(0)));
        push(a, T(0, T(), T()));
        push(a, T(0, T(0), T()));
        push(a, T(0, T(1, T(), T()), T()));
        push(a, T(1, T(), T()));
        push(a, T(0));
        push(a, T(1));
        push(a, T());
        push(a, T(0));
        push(a, T());
        push(a, T(0));
        {
            slist< T > sl(a);
            list< T > l(a);

            print("a before sorting: "); print(a); print_eol();
            sort(a, less<T>());
            print("a after  sorting: "); print(a); print_eol();

            print("sl before sorting: "); print(sl); print_eol();
            sort(sl, less<T>());
            print("sl after  sorting: "); print(sl); print_eol();

            print("l before sorting: "); print(l); print_eol();
            sort(l, less<T>());
            print("l after  sorting: "); print(l); print_eol();
        }
    }

    print("stree_serialize of t: ");
    stree_serialize(begin(t));
    print_eol();

    TT tt('a', TT('b', TT(), TT('d', TT('f'), TT('g'))), TT('c', TT('e'), TT()));
    print("stree_serialize of tt: ");
    stree_serialize(begin(tt));
    print_eol();
}

void run_tree_tests()
{
    typedef tree<int> T;
    typedef tree<char> TT;
    typedef tree_coordinate<int> I;
    typedef tree_coordinate<char> II;

    verify_conservation<int> v(tree_node_count);
    T t4(4);
    print("t4:         "); print(t4); print_eol();
    T t3_45(3, t4, T(5));
    print("t3_45:      "); print(t3_45); print_eol();
    T t2_345_678(2, t3_45, T(6, T(7), T(8)));
    //T u2_345_678(t2_345_678);
    print("t2_345_678: "); print(t2_345_678); print_eol();
    T t(1, t2_345_678, T(9, T(10, T(11), T(12)), T(13, T(14), T(15))));
    print("t:          "); print(t); print_eol();
    traverse_rotating(begin(t3_45), print_coordinate<I>); print_eol();
    traverse_rotating(begin(t3_45), print_coordinate<I>); print_eol();
    traverse_rotating(begin(t3_45), print_coordinate<I>); print_eol();
    traverse_rotating(begin(t3_45), print_coordinate<I>); print_eol();
    traverse_rotating(begin(t2_345_678), print_coordinate<I>); print_eol();
    traverse_rotating(begin(t), print_coordinate<I>); print_eol();
    print("tree_serialize of t3_45: "); tree_serialize(begin(t3_45)); print_eol();
    T u(t);
    print("Preorder  traversal of t: ");
        traverse(t, print_visit<I>(true, false, false)); print_eol();
    print("Inorder   traversal of t: ");
        traverse(t, print_visit<I>(false, true, false)); print_eol();
    print("Postorder traversal of t: ");
        traverse(t, print_visit<I>(false, false, true)); print_eol();
    Assert(t == u);
    Assert(!(t < u) && !(u < t));
    Assert(T() < T(0));
    Assert(!(T(0) < T()));
    Assert(T(0) < T(1));
    Assert(!(T(1) < T(0)));
    Assert(T(0, T(1, T(), T()), T()) < T(1, T(), T()));
    Assert(!(T(1, T(), T()) < T(0, T(1, T(), T()), T())));
    Assert(T(0, T(), T()) < T(0, T(0), T()));
    Assert(!(T(0, T(0), T()) < T(0, T(), T())));
    Assert(T(0, T(), T()) < T(0, T(), T(0)));
    Assert(!(T(0, T(), T(0)) < T(0, T(), T())));
    Assert(T(0, T(0), T()) < T(0, T(0), T(0)));
    Assert(!(T(0, T(0), T(0)) < T(0, T(0), T())));
    {
        array< T > a;
        push(a, T(0, T(0), T()));
        push(a, T(0, T(0), T(0)));
        push(a, T(0, T(), T()));
        push(a, T(0, T(), T(0)));
        push(a, T(0, T(), T()));
        push(a, T(0, T(0), T()));
        push(a, T(0, T(1, T(), T()), T()));
        push(a, T(1, T(), T()));
        push(a, T(0));
        push(a, T(1));
        push(a, T());
        push(a, T(0));
        push(a, T());
        push(a, T(0));
        {
            slist< T > sl(a);
            list< T > l(a);

            print("a before sorting: "); print(a); print_eol();
            sort(a, less<T>());
            print("a after  sorting: "); print(a); print_eol();

            print("sl before sorting: "); print(sl); print_eol();
            sort(sl, less<T>());
            print("sl after  sorting: "); print(sl); print_eol();

            print("l before sorting: "); print(l); print_eol();
            sort(l, less<T>());
            print("l after  sorting: "); print(l); print_eol();
        }
    }

    print("tree_serialize of t: ");
    tree_serialize(begin(t));
    print_eol();

    TT tt('a', TT('b', TT(), TT('d', TT('f'), TT('g'))), TT('c', TT('e'), TT()));
    print("tree_serialize of tt: ");
    tree_serialize(begin(tt));
    print_eol();
}

template<typename R, typename I>
    requires(Relation(R) && Mutable(I) && Integer(ValueType(I)))
struct instrumented_less
{
    R r;
    I p;
    instrumented_less(R r, I p) : r(r), p(p) { }
    bool operator()(const Domain(R)& x, const Domain(R)& y)
    {
        ++sink(p);
        return r(x, y);
    }
};

template<typename R, typename I>
    requires(Relation(R) && Mutable(I) && Integer(ValueType(I)))
struct input_type< instrumented_less<R, I>, 0 >
{
    typedef Domain(R) type;
};

template<typename T>
    requires(Regular(T))
struct tracer
{
    T t;
    tracer(const T& t) : t(t)
    {
        print("Constructing tracer("); print(t); print(")\n");
    }
    tracer(const tracer& x) : t(x.t)
    {
        print("Copying tracer("); print(t); print(")\n");
    }
    ~tracer()
    {
        print("Destroying tracer("); print(t); print(")\n");
    }
    void operator=(const T& u)
    {
        print("Assigning "); print(u); print(" to tracer("); print(t); print(")\n");
        t = u;
    }
};

template<>
struct needs_construction_type< underlying_type< array<double> > >
{
    typedef false_type type;
};

template<>
struct needs_destruction_type< underlying_type< array<double> > >
{
    typedef false_type type;
};

template<int kkkk>
void run_array_tests()
{
    {
        print("Entering block with traced array\n");
        array< tracer<int> > traced_array;
        push(traced_array, tracer<int>(0));
        push(traced_array, tracer<int>(1));
        print("Leaving block with traced array\n");
    }

    array<int> v;
    int buf[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    insert_range(back< array<int> >(v), counted_range< pointer(int) >(buf, 9));
    print("v: "); print(v); print_eol();
    array< array<int> > vv(12, 12, v);
    print("vv: "); print(vv); print_eol();
    array<int> v1;
    array< array<int> > uu(12, 12, v);
    print("uu: "); print(uu); print_eol();

    const int matrix_size = 10;
    typedef array< double > row;
    typedef array< row > matrix;
    matrix m;
    for (int i = 0; i < matrix_size; ++i) {
        push(m, row());
        row& row = sink(begin(m) + i);
        for (int j = 0; j < matrix_size; ++j)
            push(row, 1.0 / double(i + j + 1));
    }

    print_eol();
    print("matrix:  "); print(m); print_eol();
    sort(m, less<row>());
    print_eol();
    print("sorted:  "); print(m); print_eol();

    typedef DistanceType(IteratorType(matrix)) N;
    N n = max(size(m) / N(10), N(100));
    UnderlyingType(row) r;
    array<UnderlyingType(row)> buffer(n, n, r);
    //reverse_n_adaptive(begin(m), size(m), begin(buffer), size(buffer));
    //print("reversed: "); print(m); print_eol();

    int aa[] = {1, 3, 5, 2, 4, 6};
    array<int> a(counted_range<int*>(aa, 6));
    array<int> copy_of_a(a);
    print_eol();
    print("array: "); print_range(begin(a), end(a)); print_eol();
    typedef pointer(int) I;

    print("merge: "); print_range(begin(a), end(a)); print_eol();
    pair<int*, int*> p = partition_stable_n(begin(a), 6, odd<int>);
    print("partition not odd: "); print_range(begin(a), p.m0); print_eol();
    print("partition     odd: "); print_range(p.m0, p.m1); print_eol();

    int bb[] = {17, 29, 0, 1001, 47, 3, 2, 1, 124, 49, 981, 3, 29};
    print("Array:  "); print_range(bb, bb + sizeof(bb) / sizeof(int)); print_eol();
    array<int> b(counted_range<int*>(bb, sizeof(bb) / sizeof(int)));
    I f_buf(0);
    int n_buf(0);
    sort_n_adaptive(begin(b), size(b), f_buf, n_buf, less<int>());
    print("Sorted: "); print_range(begin(b), end(b)); print_eol();

    // Test sorting a large array (exercising adaptivity)
    array<int> big(1000000, 1000000, 0);
    const int N_BIG_BUFFER = 100000;
    int big_buffer[N_BIG_BUFFER];
    iota(1000000, begin(big));
    reverse_bidirectional(begin(big), end(big));
    //sort(big, less<int>());
    sort_n_adaptive(begin(big), size(big), big_buffer, N_BIG_BUFFER, less<int>());
    Assert(equal_iota(begin(big), end(big)));
}


#endif // EOP_DRIVERS
