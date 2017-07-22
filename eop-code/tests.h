// tests.h

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


// Regression tests for algorithms from
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009


// To do: move rational, polynomial to eop.h ?


#ifndef EOP_TESTS
#define EOP_TESTS


#include "intrinsics.h"
#include "type_functions.h"
#include "eop.h"
#include "print.h"
#include "assertions.h"


// Naming conventions:

// property_X checks that property X is satisfied for a given set of values
// concept_X checks for minimal syntactic requirements of concept X;
//   it also performs nominal checks of the properties corresponding to the axioms
// type_X checks that a that X satisfies the minimal syntactic requirements of the corresponding concept(s)
// algorithm_X (or algorithms_X) checks that an algorithm or group of algorithms
//   satisfies postconditions
// test_X performs checks on properties, concepts, types, and algorithms in area X,
//   e.g., a chapter


bool verbose = false;

void toggle_verbose()
{
    verbose = !verbose;
    if (verbose) print("verbose now true");
    else         print("verbose now false");
    print_eol();
}


// Chapter 1. Foundations


template<typename T>
void concept_Regular(T& x)
{
    // Default constructor
    T y;

    // Equality
    Assert(x == x);

    // Assignment
    y = x;
    Assert(y == x);

    // Copy constructor
    T x_copy(x);
    Assert(x_copy == x);

    // Default total ordering
    less<T> lt;
    Assert(!lt(x, x));

    // Underlying type
    UnderlyingType(T) u;

    // Destructor
}

template<typename T>
    requires(TotallyOrdered(T))
void concept_TotallyOrdered(T& x0, T& x1)
{
    // Precondition: x0 < x1

    Assert(x0 != x1);
    Assert(!(x0 == x1));

    // Natural total ordering
    Assert(!(x0 < x0));
    Assert(x0 < x1); Assert(x1 > x0);
    Assert(x0 <= x1); Assert(x1 >= x0);
    Assert(!(x1 < x0)); Assert(!(x0 > x1));
    Assert(!(x1 <= x0)); Assert(!(x0 >= x1));
}

template<typename T0, typename T1>
  requires(Regular(T0) && Regular(T1))
void type_pair(const T0& x00, const T0& x01, const T1& x10, const T1& x11)
{
    // Precondition: x00 < x01 || (x00 == x01 && x10 < x11)
    Assert(x00 < x01 || (x00 == x01 && x10 < x11));

    typedef pair<T0, T1> P01;

    // Pair constructor
    P01 p0(x00, x10);
    P01 p1(x01, x11);

    // Regular
    concept_Regular(p0);
    concept_TotallyOrdered(p0, p1);

    // Member selection
    Assert(p0.m0 == x00 && p0.m1 == x10);
}

template<typename T0, typename T1, typename T2>
  requires(Regular(T0) && Regular(T1) && Regular T2)
void type_triple(const T0& x00, const T0& x01,
                 const T1& x10, const T1& x11,
                 const T2& x20, const T2& x21)
{
    Assert(x00 < x01 || (x00 == x01 && (x10 < x11 || (x10 == x11 && x20 < x21))));

    typedef triple<T0, T1, T2> T;

    // Triple constructor
    T t0(x00, x10, x20);  // triple constructor
    T t1(x01, x11, x21);

    // Regular
    concept_Regular(t0);
    concept_TotallyOrdered(t0, t1);

    // Member selection
    Assert(t0.m0 == x00 &&
           t0.m1 == x10 &&
           t0.m2 == x20);
}

void test_tuples()
{
    typedef pair<int, char> P;

    print("    pair\n");
    type_pair<int, char>(0, 99, 'a', 'a');
    type_pair<int, char>(0, 0, 'a', 'z');

    char a[] = {'a', 'Z'};
    type_pair<P, pointer(char)>(P(0, 'a'), P(1, 'Z'), &(a[0]), &(a[1]));

    array<int> a0;
    array<int> a1(3, 3, 0);
    iota(3, begin(a1));
    type_pair< array<int>, char >(a0, a1, 'a', 'z');

    slist<int> l0;
    slist<int> l1(a0);
    type_pair< slist<int>, char >(l0, l1, 'a', 'z');

    type_pair< array<int>, slist<int> >(a0, a1, l0, l1);

    print("    triple\n");
    type_triple<int, char, double>(0, 99, 'a', 'z', 1.0, 2.0);
}

template<typename T>
    requires(MultiplicativeSemigroup(T))
struct times
{
    T operator()(const T& a, const T& b) { return a * b; }
};

template<typename T>
    requires(MultiplicativeSemigroup(T))
struct input_type<times<T>, 0> { typedef T type; };

void test_ch_1()
{
    print("  Chapter 1\n");

    int n0(0);
    int n1(1);
    concept_Regular(n0);
    concept_TotallyOrdered(n0, n1); // *****concept_Integer ?????

    // We check the most important fact in arithmetic
    Assert(plus_0(3 * 3, 4 * 4) == 5 * 5);
    Assert(plus_1(3 * 3, 4 * 4) == 5 * 5);
    int a = 3 * 3;
    int b = 4 * 4;
    int c;
    plus_2(&a, &b, &c);
    Assert(c == 5 * 5);

    Assert(square(3) == 9);
    Assert(square(3, times<int>()) == 9);

    test_tuples();
}


// Chapter 2. Transformations and their orbits


template<typename F>
    requires(Transformation(F))
void concept_Transformation(F f, Domain(F) x)
{
    typedef Domain(F) X;
    typedef Codomain(F) Y;
    // X == Y
    Y y;
    y = x;
    Assert(x == y);
    y = f(x);
    typedef DistanceType(F) N;
    N n(1);
}

template<typename P>
    requires(UnaryPredicate(P))
void concept_UnaryPredicate(P p, Domain(P) x)
{
    typedef Domain(P) X;
    X x0;
    X x1;
    if (p(x)) x0 = x;
    else      x1 = x;
}

template<typename T>
    requires(MultiplicativeSemigroup(T))
struct sq {
    T operator()(const T& x)
    {
        return x * x;
    }
};

template<typename T>
    requires(MultiplicativeSemigroup(T))
struct input_type< sq<T>, 0 >
{
    typedef T type;
};

template<typename T>
    requires(MultiplicativeSemigroup(T))
struct codomain_type< sq<T> >
{
    typedef T type;
};

template<typename T>
    requires(MultiplicativeSemigroup(T))
struct distance_type< sq<T> >
{
    typedef T type;
};

template<typename I, typename N>
    requires(Integer(I) && Integer(N) && DistanceType(I) = N)
struct gen_orbit_predicate // definition space predicate
{
    I x_0;
    N h;
    N c;
    gen_orbit_predicate(I x_0, N h, N c) : x_0(x_0), h(h), c(c)
    {
        // Precondition: h < N(MaximumValue(I)) && c < N(MaximumValue(I))
        // Precondition: !negative(h) && !negative(c)
    }
    bool operator()(const I& x)
    {
        return x_0 <= x && x < x_0 + I(h) + I(c);
    }
};

template<typename I, typename N>
    requires(Integer(I) && Integer(N) && DistanceType(I) = N)
struct input_type<gen_orbit_predicate<I, N>, 0>
{
    typedef I type;
};

template<typename I, typename N>
    requires(Integer(I) && Integer(N) && DistanceType(I) = N)
struct gen_orbit // transformation
{
    gen_orbit_predicate<I, N> p;
    gen_orbit(I x_0, N h, N c) : p(x_0, h, c)
    {
        // Precondition: h < N(MaximumValue(I)) && c < N(MaximumValue(I))
        // Precondition: !negative(h) && !negative(c)
    }
    I operator() (I x)
    {
        Assert(p(x));
        x = successor(x);
        if (x == p.x_0 + I(p.h) + I(p.c)) x = p.x_0 + I(p.h);
        return x; 
    }
};

template<typename I, typename N>
    requires(Integer(I) && Integer(N) && DistanceType(I) = N)
struct input_type<gen_orbit<I, N>, 0>
{
    typedef I type;
};

template<typename I, typename N>
    requires(Integer(I) && Integer(N) && DistanceType(I) = N)
struct codomain_type< gen_orbit<I, N> >
{
    typedef I type;
};

template<typename I, typename N>
    requires(Integer(I) && Integer(N) && DistanceType(I) = N)
struct distance_type< gen_orbit<I, N> >
{
    typedef N type;
};

template<typename F>
    requires(Transformation(F))
void algorithms_orbit(Domain(F) x, DistanceType(F) h, DistanceType(F) c)
{
    typedef Domain(F) T;
    typedef DistanceType(F) N;
    F f(x, h, c);
    Assert(zero(c) == terminating(x, f, f.p));
    if (zero(h) && !zero(c)) {
        Assert(circular(x, f, f.p));
        Assert(circular_nonterminating_orbit(x, f));
    } else if (!zero(h)) {
        Assert(!circular(x, f, f.p));
        if (!zero(c))
            Assert(!circular_nonterminating_orbit(x, f));
    }
    T y = connection_point(x, f, f.p);
    Assert(power_unary<F>(x, h, f) == y);
    if (!zero(c))
        Assert(y == connection_point_nonterminating_orbit(x, f));
    triple<unsigned, unsigned, int> t = orbit_structure(x, f, f.p);
    if (zero(c)) { // terminating
        Assert(t.m0 == h);
        Assert(zero(t.m1));
        Assert(t.m2 == collision_point(x, f, f.p));
    } else if (zero(h)) { // circular
        Assert(zero(t.m0));
        Assert(t.m1 == predecessor(c));
        Assert(t.m2 == x);
    } else { // rho-shaped
        Assert(t.m0 == h);
        Assert(t.m1 == predecessor(c));
        Assert(t.m2 == y);
    }
    if (!zero(c)) {
        triple<N, N, T> t =
            orbit_structure_nonterminating_orbit(x, f);
        if (zero(h)) { // circular
            Assert(zero(t.m0));
            Assert(t.m1 == predecessor(c));
            Assert(t.m2 == x);
        } else { // rho-shaped
            Assert(t.m0 == h);
            Assert(t.m1 == predecessor(c));
            Assert(t.m2 == y);
        }
    }
}

template<typename N>
    requires(Integer(N))
struct hf {
    N operator()(const N& x)
    {
        return x / N(2);
    }
};

template<typename N>
    requires(Integer(N))
struct input_type< hf<N>, 0 >
{
    typedef N type;
};

template<typename N>
    requires(Integer(N))
struct codomain_type< hf<N> >
{
    typedef N type;
};

template<typename N>
    requires(Integer(N))
struct distance_type< hf<N> >
{
    typedef N type;
};

void test_ch_2()
{
    print("  Chapter 2\n");
    for (int i = 1; i < 100000000; i = 10 * i) {
        Assert(abs(i) == i);
        Assert(abs(-i) == i);
    }

    Assert(euclidean_norm(3., 4.) == 5.);
    Assert(euclidean_norm(3., 4., 5.) == euclidean_norm(euclidean_norm(3., 4.), 5.));

    concept_Transformation(sq<int>(), 2);
    concept_Transformation(gen_orbit<int, unsigned>(0, 0u, 5u), 0);
    concept_Transformation(hf<int>(), 16);

    concept_UnaryPredicate(gen_orbit<int, unsigned>(0, 0u, 5u).p, 0);

    for (int i = 2; i < 5; i = successor(i))
        for (int j = 1; j < 5; j = successor(j)) {
            int tmp = power_unary(i, predecessor(j), sq<int>());
            Assert(power_unary(i, j, sq<int>()) == tmp * tmp);
        }

    Assert(distance(2, 65536, sq<int>()) == 4);

    // Cyclic
    algorithms_orbit< gen_orbit<int, unsigned> >(0, 0u, 5u);

    // Rho-shaped
    algorithms_orbit< gen_orbit<int, unsigned> >(0, 2u, 11u);
    algorithms_orbit< gen_orbit<int, unsigned> >(7, 97u, 17u);
    algorithms_orbit< gen_orbit<int, unsigned> >(0, 4u, 2u);

    // Terminating
    algorithms_orbit< gen_orbit<int, unsigned> >(0, 101u, 0u);

    Assert(convergent_point_guarded(1024, 64, 1, hf<int>()) == 64);
    Assert(convergent_point_guarded(1025, 65, 1, hf<int>()) == 32);
    Assert(convergent_point_guarded(64, 1024, 1, hf<int>()) == 64);
    Assert(convergent_point_guarded(65, 1025, 1, hf<int>()) == 32);
    Assert(convergent_point_guarded(1024, 2047, 1, hf<int>()) == 1);
}


// Chapter 3. Associative operations


template<typename Op>
    requires(BinaryOperation(Op))
void concept_BinaryOperation(Op op, Domain(Op) x)
{
    typedef Domain(Op) X;
    typedef Codomain(Op) Y;
    // X == Y
    Y y;
    y = x;
    Assert(x == y);
    y = op(x, x);
}

int minus_int(int a, int b) { return a - b; }

int times_int(int a, int b) { return a * b; }

void algorithm_power(int (*pow)(int, int, int (*)(int, int)))
{
    Assert(pow(1, 1, times_int) == 1);
    Assert(pow(10, 1, times_int) == 10);
    Assert(pow(1, 10, times_int) == 1);
    Assert(pow(2, 2, times_int) == 4);
    Assert(pow(2, 10, times_int) == 1024);
    Assert(pow(10, 2, times_int) == 100);
}

void algorithm_power_accumulate(int (*pow)(int, int, int, int (*)(int, int)))
{
    Assert(pow(99, 1, 1, times_int) == 99 * 1);
    Assert(pow(99, 10, 1, times_int) == 99 * 10);
    Assert(pow(99, 1, 10, times_int) == 99 * 1);
    Assert(pow(99, 2, 2, times_int) == 99 * 4);
    Assert(pow(99, 2, 10, times_int) == 99 * 1024);
    Assert(pow(99, 10, 2, times_int) == 99 * 100);

    Assert(pow(99, 1, 0, times_int) == 99);
}

void algorithm_power_accumulate_positive(int (*pow)(int, int, int, int (*)(int, int)))
{
    Assert(pow(99, 1, 1, times_int) == 99 * 1);
    Assert(pow(99, 10, 1, times_int) == 99 * 10);
    Assert(pow(99, 1, 10, times_int) == 99 * 1);
    Assert(pow(99, 2, 2, times_int) == 99 * 4);
    Assert(pow(99, 2, 10, times_int) == 99 * 1024);
    Assert(pow(99, 10, 2, times_int) == 99 * 100);
}

void algorithm_power_with_identity(int (*pow)(int, int, int (*)(int, int), int))
{
    Assert(pow(1, 1, times_int, 1) == 1);
    Assert(pow(10, 1, times_int, 1) == 10);
    Assert(pow(1, 10, times_int, 1) == 1);
    Assert(pow(2, 2, times_int, 1) == 4);
    Assert(pow(2, 10, times_int, 1) == 1024);
    Assert(pow(10, 2, times_int, 1) == 100);

    Assert(pow(1, 0, times_int, 1) == 1);
    Assert(pow(1, 0, times_int, 99) == 99);
}

template<typename I>
    requires(Integer(I))
void concept_Integer(I n)
{
    I k(11);
    concept_Regular<I>(n);
    I m;
    m = n + k;
    m = m - k;
    m = m * k;
    m = m / k;
    m = m % k;
    m = I(0); // ensure m < k
    concept_TotallyOrdered<I>(m, k);
    m = successor(n);
    m = predecessor(m);
    m = twice(m);
    m = half_nonnegative(m);
    m = binary_scale_down_nonnegative(m, I(1));
    m = binary_scale_up_nonnegative(m, I(1));
    bool bp = positive(m);
    bool bn = negative(m);
    Assert(!(bp && bn));
    bool bz = zero(m);
    Assert(bz && !(bn || bp) || !bz && (bn || bp));
    bool b1 = one(m);
    Assert(!(bz && b1));
    Assert(!b1 || bp);
    bool be = even(m);
    bool bo = odd(m);
    Assert(be != bo);
}

void test_ch_3()
{
    print("  Chapter 3\n");

    concept_BinaryOperation(minus_int, 7);
    concept_BinaryOperation(times_int, 8);

    Assert(power_left_associated(-2, 3, minus_int) == 2); // (-2 - -2) - -2 = 2
    Assert(power_left_associated(-2, 4, minus_int) == 4); // ((-2 - -2) - -2) - -2 = 4
    algorithm_power(power_left_associated<int, int (*)(int, int)>);
    Assert(power_right_associated(-2, 3, minus_int) == -2); // -2 - (-2 - -2) = -2
    Assert(power_right_associated(-2, 4, minus_int) == 0); // -2 - (-2 - (-2 - -2) = 0
    algorithm_power(power_right_associated<int, int (*)(int, int)>);
    algorithm_power(power_0<int, int (*)(int, int)>);
    algorithm_power(power_1<int, int (*)(int, int)>);
    algorithm_power_accumulate(power_accumulate_0<int, int (*)(int, int)>);
    algorithm_power_accumulate(power_accumulate_1<int, int (*)(int, int)>);
    algorithm_power_accumulate(power_accumulate_2<int, int (*)(int, int)>);
    algorithm_power_accumulate(power_accumulate_3<int, int (*)(int, int)>);
    algorithm_power_accumulate(power_accumulate_4<int, int (*)(int, int)>);
    algorithm_power_accumulate_positive(
        power_accumulate_positive_0<int, int (*)(int, int)>);
    algorithm_power_accumulate(power_accumulate_5<int, int (*)(int, int)>);
    algorithm_power(power_2<int, int (*)(int, int)>);
    algorithm_power(power_3<int, int (*)(int, int)>);
    algorithm_power_accumulate_positive(
        power_accumulate_positive<int, int (*)(int, int)>);
    algorithm_power_accumulate(power_accumulate<int, int (*)(int, int)>);
    algorithm_power(power<int, int (*)(int, int)>);
    algorithm_power_with_identity(power<int, int (*)(int, int)>);

    typedef long long N;
    typedef pair<N, N> Fib;

    concept_Integer(N(7));
    concept_BinaryOperation(fibonacci_matrix_multiply<N>, Fib(N(1), N(0)));

    Fib f10(55, 34);
    Fib f11(89, 55);
    Fib f21 = fibonacci_matrix_multiply(f10, f11);
    Assert(f21.m0 == 10946 && f21.m1 == 6765);
    Assert(fibonacci<N>(10) == N(55));
    Assert(fibonacci<N>(20) == N(6765));
};


// Chapter 4. Linear orderings


template<typename R>
    requires(Relation(R))
void concept_Relation(R r, Domain(R) x)
{
    typedef Domain(R) X;
    X y;
    X z;
    if (r(x, x)) y = x;
    else         z = x;
}

template<typename R>
    requires(Relation(R))
void property_transitive(R r, Domain(R) x, Domain(R) y, Domain(R) z)
{
    concept_Relation(r, x);
    Assert(!r(x, y) || !r(y, z) || r(x, z));
}

template<typename R>
    requires(Relation(R))
void property_total_ordering(R r, const Domain(R)& x0,
                                  const Domain(R)& x1,
                                  const Domain(R)& x2)
{
    // Precondition: total_ordering(r) /\ r(x0, x1) /\ r(x1, x2)

    Assert(r(x0, x1) && r(x1, x2));

    property_transitive(r, x0, x1, x2);

    Assert( r(x0, x1) && !(x0 == x1) && !r(x1, x0)); // trichotomy
    Assert(!r(x0, x0)                             ); // irreflexive
}

template<typename R>
    requires(Relation(R))
void property_reflexive_total_ordering(R r, const Domain(R)& x0,
                                            const Domain(R)& x1,
                                            const Domain(R)& x2)
{
    // Precondition: total_ordering(r) /\ r(x0, x1) /\ r(x1, x2)

    Assert(r(x0, x1) && r(x1, x2));

    property_transitive(r, x0, x1, x2);
    property_transitive(r, x0, x0, x1);
    property_transitive(r, x0, x1, x1);
    property_transitive(r, x0, x0, x0);

    Assert(!r(x0, x1) || !r(x1, x0) || x0 == x1); // antisymmetric
    Assert(r(x0, x0)                           ); // reflexive
}
template<typename T, typename U>
    requires(Regular(T) && Regular(U))
struct first
{
    T operator()(const pair<T, U>& x)
    {
        return x.m0;
    }
};

template<typename T, typename U>
    requires(Regular(T) && Regular(U))
struct input_type< first<T, U>, 0 >
{
    typedef pair<T, U> type;
};

template <typename T0, typename T1>
    requires(TotallyOrdered(T0))
struct less_first
{
    bool operator()(const pair<T0, T1>& p0, const pair<T0, T1>& p1)
    {
        return p0.m0 < p1.m0;
    }
};

template <typename T0, typename T1>
    requires(TotallyOrdered(T0))
struct input_type< less_first<T0, T1>, 0 >
{
    typedef pair<T0, T1> type;
};

template <typename T0, typename T1>
    requires(TotallyOrdered(T0))
struct less_second
{
    bool operator()(const pair<T0, T1>& p0, const pair<T0, T1>& p1)
    {
        return p0.m1 < p1.m1;
    }
};

template <typename T0, typename T1>
    requires(TotallyOrdered(T0))
struct input_type< less_second<T0, T1>, 0 >
{
    typedef pair<T0, T1> type;
};

template<typename T0, typename T1>
    requires(Regular(T0))
struct eq_first
{
    T0 x0;
    eq_first(T0 x0) : x0(x0) { }
    bool operator()(const pair<T0, T1>& x)
    {
        return x.m0 == x0;
    }
};

template <typename T0, typename T1>
    requires(Regular(T0))
struct input_type< eq_first<T0, T1>, 0 >
{
    typedef pair<T0, T1> type;
};

template<typename I, typename R>
    requires(Mutable(I) && BidirectionalIterator(I) &&
        Relation(R))
bool next_permutation(I f, I l, R r)
{
    // Precondition: weak_ordering(r)
    if (f == l || successor(f) == l) return false;
    I i = predecessor(l);

    while (true) {
        I ii = i;
        i = predecessor(i);
        if (r(source(i), source(ii))) {
            I j = l;
            do j = predecessor(j); while (!r(source(i), source(j)));
            exchange_values(i, j);
            reverse_bidirectional(ii, l);
            return true;
        }
        if (i == f) {
            reverse_bidirectional(f, l);
            return false;
        }
    }
}

template<typename F, typename R>
    requires(UnaryFunction(F) && Relation(R) &&
        Codomain(F) == Domain(R))
struct key_ordering
{
    F f;
    R r;
    key_ordering(F f, R r) : f(f), r(r) { }
    bool operator()(const Domain(F)& x,
                    const Domain(F)& y)
    {
        return r(f(x), f(y));
    }
};

template<typename F, typename R>
    requires(Function(F) && Arity(F) == 1 &&
        Relation(R) && Codomain(F) == Domain(R))
struct input_type< key_ordering<F, R>, 0 >
{
    typedef Domain(F) type;
};

void algorithm_select_1_4()
{
    print("    select_1_4\n");
    typedef pair<int, int> T;
    T t[] = {T(1, 1), T(2, 2), T(2, 3), T(3, 4)};
    pointer(T) l = t + sizeof(t) / sizeof(T);
    do {
        if (verbose) {
            print("      2nd of ("); print_range(t, l); print(") is ");
        }
        T r = select_1_4(t[0], t[1], t[2], t[3],
                         key_ordering< first<int, int>, less<int> >(first<int, int>(), less<int>()));
        pointer(T) f = find_if(t, l, eq_first<int, int>(2));
        Assert(f != l && source(f) == r);
        if (verbose) {
            print(r);
            print_eol();
        }
    } while (next_permutation(t, l, less_second<int, int>()));
}

void algorithm_select_1_4_stability_indices()
{
    print("    select_1_4 with stability indices\n");
    typedef pair<int, int> T;
    T t[] = {T(1, 1), T(2, 2), T(2, 3), T(3, 4)};
    pointer(T) l = t + sizeof(t) / sizeof(T);
    do {
        if (verbose) {
            print("      2nd of ("); print_range(t, l); print(") is ");
        }
        T r = select_1_4<0,1,2,3>(t[0], t[1], t[2], t[3],
                                  key_ordering< first<int, int>, less<int> >(first<int, int>(), less<int>()));
        pointer(T) f = find_if(t, l, eq_first<int, int>(2));
        Assert(f != l && source(f) == r);
        if (verbose) {
            print(r);
            print_eol();
        }
    } while (next_permutation(t, l, less_second<int, int>()));
}

void algorithm_select_2_5_stability_indices()
{
    print("    select_2_5 with stability indices\n");
    typedef pair<char, int> P;
    typedef less_first<char, int> R;
    P p0('x', 0);
    P p1('x', 1);
    P p2('x', 2);
    P p3('x', 3);
    P p4('x', 4);
    Assert(select_2_5<0,1,2,3,4>(p0,p1,p2,p3,p4,R()).m1 == p2.m1);
    Assert(select_2_5<0,1,2,4,3>(p0,p1,p2,p4,p3,R()).m1 == p2.m1);
    Assert(select_2_5<0,1,3,2,4>(p0,p1,p3,p2,p4,R()).m1 == p2.m1);
    Assert(select_2_5<0,1,3,4,2>(p0,p1,p3,p4,p2,R()).m1 == p2.m1);
    Assert(select_2_5<0,1,4,2,3>(p0,p1,p4,p2,p3,R()).m1 == p2.m1);
    Assert(select_2_5<0,1,4,3,2>(p0,p1,p4,p3,p2,R()).m1 == p2.m1);
    Assert(select_2_5<0,2,1,3,4>(p0,p2,p1,p3,p4,R()).m1 == p2.m1);
    Assert(select_2_5<0,2,1,4,3>(p0,p2,p1,p4,p3,R()).m1 == p2.m1);
    Assert(select_2_5<0,2,3,1,4>(p0,p2,p3,p1,p4,R()).m1 == p2.m1);
    Assert(select_2_5<0,2,3,4,1>(p0,p2,p3,p4,p1,R()).m1 == p2.m1);
    Assert(select_2_5<0,2,4,1,3>(p0,p2,p4,p1,p3,R()).m1 == p2.m1);
    Assert(select_2_5<0,2,4,3,1>(p0,p2,p4,p3,p1,R()).m1 == p2.m1);
    Assert(select_2_5<0,3,1,2,4>(p0,p3,p1,p2,p4,R()).m1 == p2.m1);
    Assert(select_2_5<0,3,1,4,2>(p0,p3,p1,p4,p2,R()).m1 == p2.m1);
    Assert(select_2_5<0,3,2,1,4>(p0,p3,p2,p1,p4,R()).m1 == p2.m1);
    Assert(select_2_5<0,3,2,4,1>(p0,p3,p2,p4,p1,R()).m1 == p2.m1);
    Assert(select_2_5<0,3,4,1,2>(p0,p3,p4,p1,p2,R()).m1 == p2.m1);
    Assert(select_2_5<0,3,4,2,1>(p0,p3,p4,p2,p1,R()).m1 == p2.m1);
    Assert(select_2_5<0,4,1,2,3>(p0,p4,p1,p2,p3,R()).m1 == p2.m1);
    Assert(select_2_5<0,4,1,3,2>(p0,p4,p1,p3,p2,R()).m1 == p2.m1);
    Assert(select_2_5<0,4,2,1,3>(p0,p4,p2,p1,p3,R()).m1 == p2.m1);
    Assert(select_2_5<0,4,2,3,1>(p0,p4,p2,p3,p1,R()).m1 == p2.m1);
    Assert(select_2_5<0,4,3,1,2>(p0,p4,p3,p1,p2,R()).m1 == p2.m1);
    Assert(select_2_5<0,4,3,2,1>(p0,p4,p3,p2,p1,R()).m1 == p2.m1);
    Assert(select_2_5<1,0,2,3,4>(p1,p0,p2,p3,p4,R()).m1 == p2.m1);
    Assert(select_2_5<1,0,2,4,3>(p1,p0,p2,p4,p3,R()).m1 == p2.m1);
    Assert(select_2_5<1,0,3,2,4>(p1,p0,p3,p2,p4,R()).m1 == p2.m1);
    Assert(select_2_5<1,0,3,4,2>(p1,p0,p3,p4,p2,R()).m1 == p2.m1);
    Assert(select_2_5<1,0,4,2,3>(p1,p0,p4,p2,p3,R()).m1 == p2.m1);
    Assert(select_2_5<1,0,4,3,2>(p1,p0,p4,p3,p2,R()).m1 == p2.m1);
    Assert(select_2_5<1,2,0,3,4>(p1,p2,p0,p3,p4,R()).m1 == p2.m1);
    Assert(select_2_5<1,2,0,4,3>(p1,p2,p0,p4,p3,R()).m1 == p2.m1);
    Assert(select_2_5<1,2,3,0,4>(p1,p2,p3,p0,p4,R()).m1 == p2.m1);
    Assert(select_2_5<1,2,3,4,0>(p1,p2,p3,p4,p0,R()).m1 == p2.m1);
    Assert(select_2_5<1,2,4,0,3>(p1,p2,p4,p0,p3,R()).m1 == p2.m1);
    Assert(select_2_5<1,2,4,3,0>(p1,p2,p4,p3,p0,R()).m1 == p2.m1);
    Assert(select_2_5<1,3,0,2,4>(p1,p3,p0,p2,p4,R()).m1 == p2.m1);
    Assert(select_2_5<1,3,0,4,2>(p1,p3,p0,p4,p2,R()).m1 == p2.m1);
    Assert(select_2_5<1,3,2,0,4>(p1,p3,p2,p0,p4,R()).m1 == p2.m1);
    Assert(select_2_5<1,3,2,4,0>(p1,p3,p2,p4,p0,R()).m1 == p2.m1);
    Assert(select_2_5<1,3,4,0,2>(p1,p3,p4,p0,p2,R()).m1 == p2.m1);
    Assert(select_2_5<1,3,4,2,0>(p1,p3,p4,p2,p0,R()).m1 == p2.m1);
    Assert(select_2_5<1,4,0,2,3>(p1,p4,p0,p2,p3,R()).m1 == p2.m1);
    Assert(select_2_5<1,4,0,3,2>(p1,p4,p0,p3,p2,R()).m1 == p2.m1);
    Assert(select_2_5<1,4,2,0,3>(p1,p4,p2,p0,p3,R()).m1 == p2.m1);
    Assert(select_2_5<1,4,2,3,0>(p1,p4,p2,p3,p0,R()).m1 == p2.m1);
    Assert(select_2_5<1,4,3,0,2>(p1,p4,p3,p0,p2,R()).m1 == p2.m1);
    Assert(select_2_5<1,4,3,2,0>(p1,p4,p3,p2,p0,R()).m1 == p2.m1);
    Assert(select_2_5<2,0,1,3,4>(p2,p0,p1,p3,p4,R()).m1 == p2.m1);
    Assert(select_2_5<2,0,1,4,3>(p2,p0,p1,p4,p3,R()).m1 == p2.m1);
    Assert(select_2_5<2,0,3,1,4>(p2,p0,p3,p1,p4,R()).m1 == p2.m1);
    Assert(select_2_5<2,0,3,4,1>(p2,p0,p3,p4,p1,R()).m1 == p2.m1);
    Assert(select_2_5<2,0,4,1,3>(p2,p0,p4,p1,p3,R()).m1 == p2.m1);
    Assert(select_2_5<2,0,4,3,1>(p2,p0,p4,p3,p1,R()).m1 == p2.m1);
    Assert(select_2_5<2,1,0,3,4>(p2,p1,p0,p3,p4,R()).m1 == p2.m1);
    Assert(select_2_5<2,1,0,4,3>(p2,p1,p0,p4,p3,R()).m1 == p2.m1);
    Assert(select_2_5<2,1,3,0,4>(p2,p1,p3,p0,p4,R()).m1 == p2.m1);
    Assert(select_2_5<2,1,3,4,0>(p2,p1,p3,p4,p0,R()).m1 == p2.m1);
    Assert(select_2_5<2,1,4,0,3>(p2,p1,p4,p0,p3,R()).m1 == p2.m1);
    Assert(select_2_5<2,1,4,3,0>(p2,p1,p4,p3,p0,R()).m1 == p2.m1);
    Assert(select_2_5<2,3,0,1,4>(p2,p3,p0,p1,p4,R()).m1 == p2.m1);
    Assert(select_2_5<2,3,0,4,1>(p2,p3,p0,p4,p1,R()).m1 == p2.m1);
    Assert(select_2_5<2,3,1,0,4>(p2,p3,p1,p0,p4,R()).m1 == p2.m1);
    Assert(select_2_5<2,3,1,4,0>(p2,p3,p1,p4,p0,R()).m1 == p2.m1);
    Assert(select_2_5<2,3,4,0,1>(p2,p3,p4,p0,p1,R()).m1 == p2.m1);
    Assert(select_2_5<2,3,4,1,0>(p2,p3,p4,p1,p0,R()).m1 == p2.m1);
    Assert(select_2_5<2,4,0,1,3>(p2,p4,p0,p1,p3,R()).m1 == p2.m1);
    Assert(select_2_5<2,4,0,3,1>(p2,p4,p0,p3,p1,R()).m1 == p2.m1);
    Assert(select_2_5<2,4,1,0,3>(p2,p4,p1,p0,p3,R()).m1 == p2.m1);
    Assert(select_2_5<2,4,1,3,0>(p2,p4,p1,p3,p0,R()).m1 == p2.m1);
    Assert(select_2_5<2,4,3,0,1>(p2,p4,p3,p0,p1,R()).m1 == p2.m1);
    Assert(select_2_5<2,4,3,1,0>(p2,p4,p3,p1,p0,R()).m1 == p2.m1);
    Assert(select_2_5<3,0,1,2,4>(p3,p0,p1,p2,p4,R()).m1 == p2.m1);
    Assert(select_2_5<3,0,1,4,2>(p3,p0,p1,p4,p2,R()).m1 == p2.m1);
    Assert(select_2_5<3,0,2,1,4>(p3,p0,p2,p1,p4,R()).m1 == p2.m1);
    Assert(select_2_5<3,0,2,4,1>(p3,p0,p2,p4,p1,R()).m1 == p2.m1);
    Assert(select_2_5<3,0,4,1,2>(p3,p0,p4,p1,p2,R()).m1 == p2.m1);
    Assert(select_2_5<3,0,4,2,1>(p3,p0,p4,p2,p1,R()).m1 == p2.m1);
    Assert(select_2_5<3,1,0,2,4>(p3,p1,p0,p2,p4,R()).m1 == p2.m1);
    Assert(select_2_5<3,1,0,4,2>(p3,p1,p0,p4,p2,R()).m1 == p2.m1);
    Assert(select_2_5<3,1,2,0,4>(p3,p1,p2,p0,p4,R()).m1 == p2.m1);
    Assert(select_2_5<3,1,2,4,0>(p3,p1,p2,p4,p0,R()).m1 == p2.m1);
    Assert(select_2_5<3,1,4,0,2>(p3,p1,p4,p0,p2,R()).m1 == p2.m1);
    Assert(select_2_5<3,1,4,2,0>(p3,p1,p4,p2,p0,R()).m1 == p2.m1);
    Assert(select_2_5<3,2,0,1,4>(p3,p2,p0,p1,p4,R()).m1 == p2.m1);
    Assert(select_2_5<3,2,0,4,1>(p3,p2,p0,p4,p1,R()).m1 == p2.m1);
    Assert(select_2_5<3,2,1,0,4>(p3,p2,p1,p0,p4,R()).m1 == p2.m1);
    Assert(select_2_5<3,2,1,4,0>(p3,p2,p1,p4,p0,R()).m1 == p2.m1);
    Assert(select_2_5<3,2,4,0,1>(p3,p2,p4,p0,p1,R()).m1 == p2.m1);
    Assert(select_2_5<3,2,4,1,0>(p3,p2,p4,p1,p0,R()).m1 == p2.m1);
    Assert(select_2_5<3,4,0,1,2>(p3,p4,p0,p1,p2,R()).m1 == p2.m1);
    Assert(select_2_5<3,4,0,2,1>(p3,p4,p0,p2,p1,R()).m1 == p2.m1);
    Assert(select_2_5<3,4,1,0,2>(p3,p4,p1,p0,p2,R()).m1 == p2.m1);
    Assert(select_2_5<3,4,1,2,0>(p3,p4,p1,p2,p0,R()).m1 == p2.m1);
    Assert(select_2_5<3,4,2,0,1>(p3,p4,p2,p0,p1,R()).m1 == p2.m1);
    Assert(select_2_5<3,4,2,1,0>(p3,p4,p2,p1,p0,R()).m1 == p2.m1);
    Assert(select_2_5<4,0,1,2,3>(p4,p0,p1,p2,p3,R()).m1 == p2.m1);
    Assert(select_2_5<4,0,1,3,2>(p4,p0,p1,p3,p2,R()).m1 == p2.m1);
    Assert(select_2_5<4,0,2,1,3>(p4,p0,p2,p1,p3,R()).m1 == p2.m1);
    Assert(select_2_5<4,0,2,3,1>(p4,p0,p2,p3,p1,R()).m1 == p2.m1);
    Assert(select_2_5<4,0,3,1,2>(p4,p0,p3,p1,p2,R()).m1 == p2.m1);
    Assert(select_2_5<4,0,3,2,1>(p4,p0,p3,p2,p1,R()).m1 == p2.m1);
    Assert(select_2_5<4,1,0,2,3>(p4,p1,p0,p2,p3,R()).m1 == p2.m1);
    Assert(select_2_5<4,1,0,3,2>(p4,p1,p0,p3,p2,R()).m1 == p2.m1);
    Assert(select_2_5<4,1,2,0,3>(p4,p1,p2,p0,p3,R()).m1 == p2.m1);
    Assert(select_2_5<4,1,2,3,0>(p4,p1,p2,p3,p0,R()).m1 == p2.m1);
    Assert(select_2_5<4,1,3,0,2>(p4,p1,p3,p0,p2,R()).m1 == p2.m1);
    Assert(select_2_5<4,1,3,2,0>(p4,p1,p3,p2,p0,R()).m1 == p2.m1);
    Assert(select_2_5<4,2,0,1,3>(p4,p2,p0,p1,p3,R()).m1 == p2.m1);
    Assert(select_2_5<4,2,0,3,1>(p4,p2,p0,p3,p1,R()).m1 == p2.m1);
    Assert(select_2_5<4,2,1,0,3>(p4,p2,p1,p0,p3,R()).m1 == p2.m1);
    Assert(select_2_5<4,2,1,3,0>(p4,p2,p1,p3,p0,R()).m1 == p2.m1);
    Assert(select_2_5<4,2,3,0,1>(p4,p2,p3,p0,p1,R()).m1 == p2.m1);
    Assert(select_2_5<4,2,3,1,0>(p4,p2,p3,p1,p0,R()).m1 == p2.m1);
    Assert(select_2_5<4,3,0,1,2>(p4,p3,p0,p1,p2,R()).m1 == p2.m1);
    Assert(select_2_5<4,3,0,2,1>(p4,p3,p0,p2,p1,R()).m1 == p2.m1);
    Assert(select_2_5<4,3,1,0,2>(p4,p3,p1,p0,p2,R()).m1 == p2.m1);
    Assert(select_2_5<4,3,1,2,0>(p4,p3,p1,p2,p0,R()).m1 == p2.m1);
    Assert(select_2_5<4,3,2,0,1>(p4,p3,p2,p0,p1,R()).m1 == p2.m1);
    Assert(select_2_5<4,3,2,1,0>(p4,p3,p2,p1,p0,R()).m1 == p2.m1);
}

void algorithm_median_5()
{
    print("    median_5\n");
    int i1 = 1;
    int i2 = 2;
    int i3 = 3;
    int i4 = 4;
    int i5 = 5;
    // ...
    Assert(&select_2_5_ab_cd<0, 1, 2, 3, 4, less<int> >(
        i4, i5, i2, i3, i1, less<int>()) == &i3);
    Assert(&select_2_5_ab<0, 1, 2, 3, 4, less<int> >(
        i4, i5, i2, i3, i1, less<int>()) == &i3);
    Assert(&select_2_5<0, 1, 2, 3, 4, less<int> >(
        i4, i5, i2, i3, i1, less<int>()) == &i3);
    //
    int p[5] = {1, 2, 3, 4, 5};
    do {
        if (verbose) {
            print("      median of ("); print(p[0]); print(" "); print(p[1]);
            print(" "); print(p[2]); print(" "); print(p[3]);
            print(" "); print(p[4]); print(") is ");
        }
        int m = select_2_5<0, 1, 2, 3, 4,less<int> >(
            p[0], p[1], p[2], p[3], p[4], less<int>());
        Assert(m == 3);
        if (verbose) { print(m); print_eol(); }
    } while (next_permutation(p, p + sizeof(p) / sizeof(int), less<int>()));
}

typedef pair<int, int> int_pair;

void test_ch_4()
{
    print("  Chapter 4\n");

    // Test derived relations
    less<int> lt;
    complement< less< int > > ge(lt);
    converse< less< int > > gt(lt);
    complement_of_converse< less< int > > le(lt);
    symmetric_complement< less< int> > eq(lt);
    complement< symmetric_complement< less< int> > > ne(eq);

    property_total_ordering(lt, 0, 1, 2);
    property_reflexive_total_ordering(ge, 2, 1, 0);
    property_total_ordering(gt, 2, 1, 0);
    property_reflexive_total_ordering(le, 0, 1, 2);
    property_transitive(eq, 0, 0, 0);

    Assert(ge(4, 3));
    Assert(gt(4, 3));
    Assert(le(3, 4));
    Assert(le(4, 4));
    Assert(eq(4, 4));
    Assert(ne(3, 4));

    // Test key_ordering
    typedef first<int, double> F;
    F fst;
    typedef pair<int, double> PID;
    key_ordering< F, less<int> > ko(fst, less<int>());
    Assert(ko(PID(1, 2.0), PID(2, 1.0)));
    Assert(!ko(PID(1, 2.0), PID(1, 1.0)));
    Assert(!ko(PID(1, 1.0), PID(1, 2.0)));

    // clusters: != > <= >= -- see concept_TotallyOrdered

    // Test order selection
    int a = 3;
    int b = 3;
    int c = 4;
    int d = 4;
    Assert(&select_0_2(a, b, less<int>()) == &a);
    Assert(&select_0_2(b, a, less<int>()) == &b);
    Assert(&select_0_2(a, c, less<int>()) == &a);
    Assert(&select_0_2(c, a, less<int>()) == &a);
    Assert(select_0_2(a, c, less<int>()) == a);
    Assert(select_0_2(c, a, less<int>()) == a);

    Assert(&select_1_2(a, b, less<int>()) == &b);
    Assert(&select_1_2(b, a, less<int>()) == &a);
    Assert(&select_1_2(a, c, less<int>()) == &c);
    Assert(&select_1_2(c, a, less<int>()) == &c);
    Assert(select_1_2(a, c, less<int>()) == c);
    Assert(select_1_2(c, a, less<int>()) == c);

    int_pair p1(1, 1);
    int_pair p2(1, 2);
    typedef less_first<int, int> R;
    Assert(select_0_2<1, 2, R>(p1, p2, R()) == p1);
    Assert(select_0_2<1, 2, R>(p2, p1, R()) == p2);
    Assert(select_1_2<1, 2, R>(p1, p2, R()) == p2);
    Assert(select_1_2<1, 2, R>(p2, p1, R()) == p1);

    Assert(&select_0_3(a, b, c, less<int>()) == &a);
    Assert(&select_0_3(a, c, b, less<int>()) == &a);
    Assert(&select_0_3(b, a, c, less<int>()) == &b);
    Assert(&select_0_3(b, c, a, less<int>()) == &b);
    Assert(&select_0_3(c, a, b, less<int>()) == &a);
    Assert(&select_0_3(c, b, a, less<int>()) == &b);
    Assert(select_0_3(a, c, d, less<int>()) == a);
    Assert(select_0_3(c, a, d, less<int>()) == a);
    Assert(select_0_3(d, c, a, less<int>()) == a);

    Assert(&select_2_3(b, c, d, less<int>()) == &d);
    Assert(&select_2_3(c, b, d, less<int>()) == &d);
    Assert(&select_2_3(b, d, c, less<int>()) == &c);
    Assert(&select_2_3(d, b, c, less<int>()) == &c);
    Assert(&select_2_3(c, d, b, less<int>()) == &d);
    Assert(&select_2_3(d, c, b, less<int>()) == &c);
    Assert(select_2_3(a, c, d, less<int>()) == d);
    Assert(select_2_3(c, a, d, less<int>()) == c);
    Assert(select_2_3(d, c, a, less<int>()) == c);

    // Test select_1_3_ab

    Assert(&select_1_3(a, b, c, less<int>()) == &b);
    Assert(&select_1_3(a, c, b, less<int>()) == &b);
    Assert(&select_1_3(b, a, c, less<int>()) == &a);
    Assert(&select_1_3(b, c, a, less<int>()) == &a);
    Assert(&select_1_3(c, a, b, less<int>()) == &b);
    Assert(&select_1_3(c, b, a, less<int>()) == &a);
    Assert(select_1_3(a, c, d, less<int>()) == c);
    Assert(select_1_3(c, a, d, less<int>()) == c);
    Assert(select_1_3(d, c, a, less<int>()) == c);

    // Test select_1_4_ab_cd
    // Test select_1_4_ab
    algorithm_select_1_4();
    algorithm_select_1_4_stability_indices();
    algorithm_select_2_5_stability_indices();

    {
        const int ca = 1, cb = 2, cc = 3, cd = 4, ce = 5;
        int b = 12, d = 14;
        Assert(median_5(1, cb, b, d, 15, less<int>()) == 12);
        Assert(median_5(ca, cb, cc, cd, ce, less<int>()) == 3);
        algorithm_median_5();
    }

    {
        typedef pair<char, int> P;
        Assert(min<P>(P('a', 3), P('a', 4)) == P('a', 3));
        Assert(min<P>(P('a', 4), P('a', 3)) == P('a', 3));
        Assert(max<P>(P('a', 3), P('a', 4)) == P('a', 4));
        Assert(max<P>(P('a', 4), P('a', 3)) == P('a', 4));
    }

}


// Chapter 5. Ordered algebraic structures

template<typename T>
    requires(OrderedAdditiveSemigroup(T))
void concept_OrderedAdditiveSemigroup(T& x, T& y, T& z)
{
    // Precondition: x < y
    concept_Regular(x);
    // + : T x T -> T
    Assert((x + y) + z == x + (y + z));
    Assert(x + y == y + x);
    concept_TotallyOrdered(x, y);
    Assert(x + z < y + z);
}

template<typename T>
    requires(OrderedAdditiveMonoid(T))
void concept_OrderedAdditiveMonoid(T& x, T& y, T& z)
{
    concept_OrderedAdditiveSemigroup(x, y, z);
    // 0 in T
    Assert(x + T(0) == x);
}

template<typename T>
    requires(OrderedAdditiveGroup(T))
void concept_OrderedAdditiveGroup(T& x, T& y, T& z)
{
    // Precondition: x < y
    concept_OrderedAdditiveMonoid(x, y, z);
    // - : T -> T
    Assert(x + (-x) == T(0));
}


template<typename T>
    requires(OrderedAdditiveGroup(T))
void algorithm_abs(const T& something)
{
    // We need a nonzero number to test with; OrderedAdditiveGroup doesn't guarantee one
    T zero(0);
    Assert(something > zero);
    T x(something);
    T y(x + something);
    T z(y + something);
    concept_OrderedAdditiveGroup(x, y, z); // need x < y < z

    Assert(abs(zero) == zero);
    Assert(abs( something) == something);
    Assert(abs(-something) == something);
}

template<typename T>
    requires(CancellableMonoid(T)) 
void concept_CancellableMonoid(T& x, T& y, T& z)
{
    // Precondition: x < y
    concept_OrderedAdditiveMonoid(x, y, z);
    // - : T x T -> T
    if (x <= y) {
        T z = y - x; // defined
        Assert(z + x == y);
    }
}

template<typename T>
    requires(ArchimedeanMonoid(T)) 
void concept_ArchimedeanMonoid(T& x, T& y, T& z, QuotientType(T) n)
{
    // Precondition: x < y
    concept_CancellableMonoid(x, y, z);
    typedef QuotientType(T) N;
    concept_Integer<N>(n);
    // slow_remainder terminates for all positive arguments
}

template<typename T>
    requires(ArchimedeanGroup(T)) 
void concept_ArchimedeanGroup(T& x, T& y, T& z, QuotientType(T) n)
{
    // Precondition: x < y
    concept_ArchimedeanMonoid(x, y, z, n);
    T tmp = x - y;
    Assert(tmp < 0);
    Assert(-tmp == y - x);
}

template<typename T>
    requires(ArchimedeanMonoid(T)) // + numerals, successor
void algorithms_slow_q_and_r()
{
    typedef long Z;
    plus<T> plus_T;
    typedef QuotientType(T) N;
    T max(1000);
    T a(0);
    while (a < max) {
        T b(1);
        while (b < max) {
            T r = slow_remainder(a, b);
            N q = slow_quotient(a, b);
            Assert(power(b, q, plus_T, T(0)) + r == a);
            b = successor(b);
        }
        a = successor(a);
    }
}

template<typename T>
    requires(ArchimedeanMonoid(T)) // + numerals, successor
void algorithms_q_and_r_nonnegative()
{
    typedef long Z;
    plus<T> plus_T;
    typedef QuotientType(T) N;
    T max(1000);
    T a(0);
    while (a < max) {
        T b(1);
        while (b < max) {
            T r = remainder_nonnegative(a, b);
            pair<N, T> qr = quotient_remainder_nonnegative(a, b);
            Assert(qr.m1 == r);
            Assert(power(b, qr.m0, plus_T, T(0)) + r == a);
            b = successor(b);
        }
        a = successor(a);
    }
}

template<typename T>
    requires(ArchimedeanMonoid(T)) // + numerals, successor
void algorithms_q_and_r_nonnegative_fibonacci()
{
    typedef long Z;
    plus<T> plus_T;
    typedef QuotientType(T) N;
    T max(1000);
    T a(0);
    while (a < max) {
        T b(1);
        while (b < max) {
            T r = remainder_nonnegative_fibonacci(a, b);
//             pair<N, T> qr = quotient_remainder_nonnegative_fibonacci(a, b);
             Assert(Z(r) == Z(a) % Z(b));
//             Assert(qr.m1 == r);
//             Assert(Z(qr.m0) == Z(a) / Z(b));
//             Assert(power(b, qr.m0, plus_T, T(0)) + r == a);
             b = successor(b);
        }
        a = successor(a);
    }
}

template<typename T>
    requires(ArchimedeanMonoid(T)) // + numerals, successor
void algorithms_q_and_r_nonnegative_iterative()
{
    typedef long Z;
    plus<T> plus_T;
    typedef QuotientType(T) N;
    T max(1000);
    T a(0);
    while (a < max) {
        T b(1);
        while (b < max) {
            T r = remainder_nonnegative_iterative(a, b);
            pair<N, T> qr = quotient_remainder_nonnegative_iterative(a, b);
            Assert(Z(r) == Z(a) % Z(b));
            Assert(qr.m1 == r);
            Assert(Z(qr.m0) == Z(a) / Z(b));
            Assert(power(b, qr.m0, plus_T, T(0)) + r == a);
            b = successor(b);
        }
        a = successor(a);
    }
}

template<typename T>
    requires(ArchimedeanMonoid(T))
T largest_power_of_two(T a)
{
    // Precondition: $a > 0$
    T b(1);
    while (b <= a - b) b = b + b;
    return b;
    // Postcondition: $(\exists i \geq 0)\,b = 2^i \wedge b \leq a < b+b
}

template<typename T>
    requires(ArchimedeanMonoid(T)) // + numerals, successor
void algorithm_largest_doubling()
{
    typedef long Z;
    T max(1000);
    T a(1);
    while (a < max) {
        T b(1);
        while (b <= a) {
            T d = largest_doubling(a, b);
//            Assert(Z(d) % Z(b) == 0); // it is an integral multiple of b
//            Z n = Z(d) / Z(b); // n = the integral multiple
//            Assert(largest_power_of_two(n) == n); // n is a power of 2; it is a doubling
            Assert(d <= a && d > a - d); // it is the largest
            b = successor(b);
        }
        a = successor(a);
    }
}


// remainder for double as EuclideanSemimodule

double remainder(double x, double y)
{
    return remainder_nonnegative(x, y);
}


// concept IntegralDomain(T) means
//     CommutativeSemiring(T) 
//  /\ (all a,b in T) a*b = T(0) => (a = T(0) \/ b = T(0)) 

// We vary from the usual definition by allowing a semiring rather than a ring.
// The second condition means there are no zero divisors.


// See van der Waerden, Modern Algebra, volume 1, chapter 3, section 13,
// for the construction of a field of quotients from an integral domain.

template<typename N>
    requires(IntegralDomain(N))
struct rational
{
    typedef rational T;
    N p; // numerator
    N q; // denominator
    rational() { }
    rational(const N& p, const N& q) : p(p), q(q)
    {
        Assert(q != N(0));
    }
    rational(const N& x) : p(x), q(N(1)) { }
};

template<typename N>
    requires(IntegralDomain(N))
struct quotient_type< rational<N> >
{
    typedef N type;
};

template<typename N>
    requires(IntegralDomain(N))
rational<N> operator+(const rational<N>& x, const rational<N>& y)
{
    return rational<N>(y.q * x.p + x.q * y.p, x.q * y.q);
}

template<typename N>
    requires(IntegralDomain(N))
rational<N> operator-(const rational<N>& x)
{
    return rational<N>(-x.p, x.q);
}

template<typename N>
    requires(IntegralDomain(N))
rational<N> operator-(const rational<N>& x, const rational<N>& y)
{
    return x + (-y);
}

template<typename N>
    requires(IntegralDomain(N))
rational<N> operator*(const rational<N>& x, const rational<N>& y)
{
    return rational<N>(x.p * y.p, x.q * y.q);
}

template<typename N>
    requires(IntegralDomain(N))
rational<N> multiplicative_inverse(const rational<N>& x)
{
    // Precondition: $x.p \neq 0$
    return rational<N>(x.q, x.p);
}

template<typename N>
    requires(IntegralDomain(N))
rational<N> operator/(const rational<N>& x, const rational<N>& y)
{
    return rational<N>(x.p * y.q, x.q * y.p);
    // Postcondition: x * multiplicative_inverse(y)
}

// Multiplication for rational<N> as a semimodule over integers

template<typename N>
    requires(IntegralDomain(N))
rational<N> operator*(const N& n, const rational<N>& x)
{
    return rational<N>(n * x.p, x.q);
}

template<typename N>
    requires(IntegralDomain(N))
rational<N> remainder(const rational<N>& x, const rational<N>& y)
{
    return remainder_nonnegative(x, y);
}

template<typename N>
    requires(IntegralDomain(N))
bool operator==(const rational<N>& x, const rational<N>& y)
{
    return x.p * y.q == y.p * x.q;
}

template<typename N>
    requires(IntegralDomain(N))
bool operator<(const rational<N>& x, const rational<N>& y)
{
    return x.p * y.q < y.p * x.q;
}

template<typename N>
    requires(IntegralDomain(N))
void print(const rational<N>& x)
{
    if (zero(x.p)) print("0");
    else if (one(x.q)) print(x.p);
    else {
        print(x.p); print("/"); print(x.q);
    }
}

template<typename T>
    requires(ArchimedeanGroup(T))
struct ag_quotient_remainder
{
    pair<QuotientType(T), T> operator()(T a, T b)
    {
        Assert(a >= T(0) && b > T(0));
        return quotient_remainder_nonnegative(a, b);
    }
};

template<typename T>
    requires(ArchimedeanGroup(T))
struct input_type< ag_quotient_remainder<T>, 0 >
{
    typedef T type;
};

template<typename T>
    requires(ArchimedeanGroup(T)) // + numerals, successor
void algorithms_signed_q_and_r()
{
    typedef long Z;
    typedef QuotientType(T) N;
    T min(-10);
    T max(10);
    T a(min);
    while (a <= max) {
        T b(a);
        while (b <= max) {
            if (b != T(0)) {
                T r = remainder(a, b, remainder_nonnegative<T>);
                Assert(abs(r) < abs(b));
                pair<N, T> qr = quotient_remainder(a, b, ag_quotient_remainder<T>());
                Assert(qr.m1 == r);
                Assert(qr.m0 * b + r == a);
            }
            b = successor(b);
        }
        a = successor(a);
    }
}

typedef rational<int> Q;

bool operator<(const Q& x, const Q& y)
{
    return x.p * y.q < y.p * x.q;
}

template<>
struct quotient_type<double>
{
    typedef long type; // ***** what should this be ?????
};


// polynomial<T> is a type constructor; it models the following concept
// There could be other models, such as sparse representations.

// PolynomialRing(T) equals by definition
//     ValueType : Polynomial -> CommutativeSemiring
//     IndexType : Polynomial -> Integer
//  /\ degree : T -> IndexType(T)
//  /\ coefficient : T x IndexType(T) -> ValueType(T)
//  /\ lc : T –> ValueType(T)
//            a \mapsto coefficient(a, degree(a))
//  /\ tc : T –> ValueType(T)
//            a \mapsto coefficient(a, 0)
//  /\ indeterminate : -> T
//  /\ evaluate : T x ValueType(T) -> ValueType(T)
//  /\ · : ValueType(T) x T -> T
//  /\ + : T x T -> T
//  /\ · : T x T -> T
//  /\ shift_left : T x Integer -> T
//        (a, n) \mapsto power(indeterminate(), n, ·) · a
//  /\  ...


template<typename T>
    requires(Ring(T))
struct polynomial
{
    typedef int IndexType;
    array<T> coeff;
    // Invariant: degree(f) = size(f.coeff) - 1 /\
    //            coefficient(f, i) = f.coeff[degree(f) - i]
    polynomial() : coeff(IndexType(1), IndexType(1), T(0)) { }     // f(x) = 0
    polynomial(T x_0) : coeff(IndexType(1), IndexType(1), x_0) { } // f(x) = x_0
};

template<typename T>
    requires(Ring(T))
struct value_type< polynomial<T> >
{
    typedef T type;
};

template<typename T>
    requires(Ring(T))
struct index_type;

#define IndexType(T) typename index_type< T >::type

template<typename T>
    requires(Ring(T))
struct index_type< polynomial<T> >
{
    typedef typename polynomial<T>::IndexType type;
};

template<typename T>
    requires(Ring(T))
IndexType(polynomial<T>) operator==(const polynomial<T>& f, const polynomial<T>& g)
{
    return f.coeff == g.coeff;
}

template<typename T>
    requires(Ring(T))
IndexType(polynomial<T>) operator<(const polynomial<T>& f, const polynomial<T>& g)
{
    return degree(f) < degree(g) ||
          degree(g) == degree(f) && f.coeff < g.coeff;
}

template<typename T>
    requires(Ring(T))
IndexType(polynomial<T>) degree(const polynomial<T>& f)
{
    // ***** Should degree(polynomial<T>(0)) = -infinity ?????
    return predecessor(size(f.coeff));
}

template<typename T>
    requires(Ring(T))
void shift_add_in_place(polynomial<T>& f, const T& x_0)
{
    insert(back< array<T> >(f.coeff), x_0);
    // Postcondition: f'(x) = x * f(x) + x_0
}

template<typename T>
    requires(Ring(T))
void shift_left_in_place(polynomial<T>& f, IndexType(polynomial<T>) n)
{
    // Precondition: n >= 0
    while (count_down(n)) shift_add_in_place(f, T(0));
    // Postcondition: f'(x) = x^n * f(x)
}

template<typename T>
    requires(Ring(T))
T coefficient(const polynomial<T>& f, IndexType(polynomial<T>) i)
{
    // Precondition: $0 \leq i \leq \func{degree}(f)$
    return f.coeff[degree(f) - i]; // not a reference, to guarantee the invariant holds
}

template<typename T>
    requires(Ring(T))
T lc(const polynomial<T>& f) // leading coefficient
{
    return f.coeff[0];
    // Poscondition: returns coefficient(f, degree(f))
}

template<typename T>
    requires(Ring(T))
T tc(const polynomial<T>& f) // trailing coefficient
{
    return f.coeff[size(f.coeff) - 1];
    // Poscondition: returns coefficient(f, 0)
}

template<typename T>
    requires(Ring(T))
bool monic(const polynomial<T>& f)
{
    return lc(f) == T(1);
}

template<typename T>
    requires(Ring(T))
polynomial<T> indeterminate()
{
    polynomial<T> f(T(1)); // f(x) = 1
    shift_add_in_place(f, T(0)); // f'(x) = f(x) * x + 0 = 1 * x = x
    return f; // could be a static const member
    // Postcondition: returns f(x) = x
}

template<typename T>
    requires(Ring(T))
polynomial<T> evaluate(const polynomial<T>& f, const T& x_0)
{
    typedef IndexType(polynomial<T>) I;
    I n(degree(f));
    // Horner's scheme
    T r = coefficient(f, n);
    while (!negative(n)) {
        n = predecessor(n);
        r = (r * x_0) + coefficient(f, n);
    }
    return r;
    // Postcondition: r = f(x_0)
}

template<typename T>
    requires(Ring(T))
polynomial<T> add(const polynomial<T>& f, const polynomial<T>& g,
                  IndexType(polynomial<T>) d, IndexType(polynomial<T>) n_g)
{
    // Precondition: $0 < d = degree(f) - degree(g) \wedge n_g = degree(g)$
    typedef IndexType(polynomial<T>) I;
    polynomial<T> h(lc(f));
    I i(1);
    while (i != d) {
        shift_add_in_place(h, f.coeff[i]);
        i = successor(i);
    }
    I j(0);
    while (j <= n_g) {
        shift_add_in_place(h, f.coeff[i] + g.coeff[j]);
        i = successor(i);
        j = successor(j);
    }
    return h;
    // Postcondition: h(x) = f(x) + g(x)
}

template<typename T>
    requires(Ring(T))
polynomial<T> operator+(const polynomial<T>& f, const polynomial<T>& g)
{
    typedef IndexType(polynomial<T>) I;
    I n_f = degree(f);
    I n_g = degree(g);
    if (n_f > n_g) return add(f, g, n_f - n_g, n_g);
    else if (n_g > n_f) return add(g, f, n_g - n_f, n_f);
    I i(0);
    T x;
    while (i <= n_f) {
        x = f.coeff[i] + g.coeff[i];
        if (x != T(0)) break;
        i = successor(i);
    }
    polynomial<T> h(x);
    while (i < n_f) {
        i = successor(i);
        shift_add_in_place(h, f.coeff[i] + g.coeff[i]);
    };
    return h;
    // Postcondition: h(x) = f(x) + g(x)
}

template<typename T, typename F>
    requires(Ring(T) && Transformation(F) &&
        T == Domain(F))
void transform_coefficients_in_place(polynomial<T>& f, F trans)
{
    typedef IndexType(polynomial<T>) I;
    I i(0);
    I n = degree(f);
    while (i <= n) {
        f.coeff[i] = trans(f.coeff[i]);
        i = successor(i);
    }
}

template<typename T>
    requires(Ring(T))
polynomial<T> operator-(polynomial<T> f) // f is a copy
{
    transform_coefficients_in_place(f, negate<T>());
    return f;
    // Postcondition: f'(x) = -f(x)
}

template<typename T>
    requires(Ring(T))
polynomial<T> operator-(const polynomial<T>& f, const polynomial<T>& g)
{
    return f + (-g);
    // Postcondition: returns h(x) = f(x) - g(x)
}

template<typename T>
    requires(Ring(T))
polynomial<T> product(const polynomial<T>& f, const polynomial<T>& g)
{
    // Precondition: degree(f) <= degree(g)
    typedef IndexType(polynomial<T>) I;
    I n_f = degree(f);
    I n = n_f + degree(g);
    polynomial<T> h(lc(f) * lc(g));
    n = predecessor(n);
    // Invariant: shift_left(r, n) is the
    //            (deg(f)+deg(g)-n) highest-order coefficients of the result
    while (!negative(n)) {
        T sum(0);
        I i_f(0);
        while (i_f <= min(n_f, n)) {
            sum = sum + coefficient(f, i_f) * coefficient(g, n - i_f);
            i_f = successor(i_f);
        }
        shift_add_in_place(h, sum);
        n = predecessor(n);
    }
    return h;
    // Postcondition: h(x) = f(x) * g(x)
}

template<typename T>
    requires(Ring(T))
polynomial<T> operator*(const polynomial<T>& f, const polynomial<T>& g)
{
    if (degree(f) <= degree(g)) return product(f, g);
    else                        return product(g, f);
}

template<typename T>
    requires(Ring(T))
polynomial<T> operator*(T x_0, const polynomial<T>& f)
{
    polynomial<T> h(f);
    transform_coefficients_in_place(
        h, multiplies_transformation< multiplies<T> >(x_0, multiplies<T>()));
    return h;
    // Postcondition: h(x) = x_0 * f(x)
}

template<typename T>
    requires(Ring(T))
polynomial<T> shift_left(const polynomial<T>& f, IndexType(polynomial<T>) n)
{
    polynomial<T> h(f);
    shift_left_in_place(h, n);
    return h;
    // Postcondition: h(x) = x^n * f(x)
}

template<typename T>
    requires(Ring(T))
pair< polynomial<T>, polynomial<T> >
quotient_remainder(const polynomial<T>& f, const polynomial<T>&g) {
    // Precondition: unit(lc(g))
    T u = multiplicative_inverse(lc(g));
    polynomial<T> q(0);
    polynomial<T> r = f;
    while (degree(r) >= degree(g)) {
        // Invariant: f = q * g + r
        polynomial<T> q_i =  shift_left(polynomial<T>(lc(r) * u), degree(r) - degree(g));
        q = q + q_i;
        r = r - q_i * g;
    }
    return pair< polynomial<T>, polynomial<T> >(q, r);
    // Postcondition: f = q * g + r /\ degree(r) < degree(g)
}

template<typename T>
    requires(Ring(T))
polynomial<T> remainder(const polynomial<T>& f, const polynomial<T>&g) {
    // Precondition: unit(lc(g))
    return quotient_remainder(f, g).m1;
}

template<typename T>
    requires(Ring(T))
void print_coefficient(T c, IndexType(polynomial<T>) i)
{
    if (!one(c) || zero(i)) {
        print(c);
        if (positive(i)) print("*");
    }
    if (positive(i)) {
        print("x");
        if (i > IndexType(polynomial<T>)(1)) {
            print("^"); print(i);
        }
    }
}

template<typename T>
    requires(Ring(T))
void print(const polynomial<T>& f)
{
    typedef IndexType(polynomial<T>) I;
    print("polynomial(");
        I i = degree(f);
        T c = coefficient(f, i);
        print_coefficient(c, i);
        i = predecessor(i);
        while (!negative(i)) {
            c = coefficient(f, i);
            if (!zero(c)) {
                if (negative(c)) { print(" - "); c = -c; }
                else               print(" + ");
                print_coefficient(c, i);
            }
            i = predecessor(i);
        }
    print(")");
}

void test_ch_5()
{
    print("  Chapter 5\n");

    algorithm_abs<int>(1);
    algorithm_abs<long long>(1l);
    algorithm_abs<double>(1.0);
    algorithm_abs<long double>(1.0l);
    algorithm_abs< rational<int> >(rational<int>(1, 2));

    // type_functions.h defines QuotientType for several built-in integral types
    {
        typedef int T;
        T x(0);
        T y(1);
        T z(2);
        quotient_type<T>::type n(3);
        concept_ArchimedeanGroup<T>(x, y, z, n);
    }
    {
        typedef long int T;
        T x(0);
        T y(1);
        T z(2);
        quotient_type<T>::type n(3);
        concept_ArchimedeanGroup<T>(x, y, z, n);
    }
    {
        typedef Q T;
        T x(0);
        T y(1);
        T z(2);
        quotient_type<T>::type n(3);
        concept_ArchimedeanGroup<T>(x, y, z, n);
    }
    {
        typedef double T;
        T x(0.0);
        T y(1.0);
        T z(2.0);
        quotient_type<T>::type n(3);
        concept_ArchimedeanGroup<T>(x, y, z, n);
    }

    algorithms_slow_q_and_r<int>();
    algorithms_slow_q_and_r<long>();
    algorithms_slow_q_and_r<Q>();

    algorithms_q_and_r_nonnegative<int>();
    algorithms_q_and_r_nonnegative<long>();
    algorithms_q_and_r_nonnegative<Q>();

    algorithms_q_and_r_nonnegative_fibonacci<int>();
    algorithms_q_and_r_nonnegative_fibonacci<long>();
//    algorithms_q_and_r_nonnegative_fibonacci<Q>();

    algorithms_q_and_r_nonnegative_iterative<int>();
    algorithms_q_and_r_nonnegative_iterative<long>();
//    algorithms_q_and_r_nonnegative_iterative<Q>();

    algorithm_largest_doubling<int>();
    algorithm_largest_doubling<long>();
    algorithm_largest_doubling<double>();
    algorithm_largest_doubling<Q>();

    Assert(subtractive_gcd_nonzero(1000, 990) == 10);
    Assert(subtractive_gcd_nonzero(1000u, 990u) == 10u);
    Assert(subtractive_gcd_nonzero(0.75, 0.5) == 0.25);
    Assert(subtractive_gcd_nonzero(Q(3, 4), Q(1, 2)) == Q(1, 4));

    Assert(subtractive_gcd(1000, 990) == 10);
    Assert(subtractive_gcd(1000, 0) == 1000);
    Assert(subtractive_gcd(0, 990) == 990);
    Assert(subtractive_gcd(1000u, 990u) == 10u);
    Assert(subtractive_gcd(1000u, 0u) == 1000u);
    Assert(subtractive_gcd(0u, 990u) == 990u);
    Assert(subtractive_gcd(0.75, 0.5) == 0.25);
    Assert(subtractive_gcd(0.75, 0.0) == 0.75);
    Assert(subtractive_gcd(0.0, 0.5) == 0.5);
    Assert(subtractive_gcd(Q(3, 4), Q(1, 2)) == Q(1, 4));
    Assert(subtractive_gcd(Q(3, 4), Q(0, 2)) == Q(3, 4));
    Assert(subtractive_gcd(Q(0, 4), Q(1, 2)) == Q(1, 2));

    Assert(fast_subtractive_gcd(1000, 990) == 10);
    Assert(fast_subtractive_gcd(1000, 0) == 1000);
    Assert(fast_subtractive_gcd(0, 990) == 990);
    Assert(fast_subtractive_gcd(1000u, 990u) == 10u);
    Assert(fast_subtractive_gcd(1000u, 0u) == 1000u);
    Assert(fast_subtractive_gcd(0u, 990u) == 990u);
    Assert(fast_subtractive_gcd(0.75, 0.5) == 0.25);
    Assert(fast_subtractive_gcd(0.75, 0.0) == 0.75);
    Assert(fast_subtractive_gcd(0.0, 0.5) == 0.5);
    Assert(fast_subtractive_gcd(Q(3, 4), Q(1, 2)) == Q(1, 4));
    Assert(fast_subtractive_gcd(Q(3, 4), Q(0, 2)) == Q(3, 4));
    Assert(fast_subtractive_gcd(Q(0, 4), Q(1, 2)) == Q(1, 2));

    // gcd for EuclideanSemiring
    Assert(gcd<int>(1000, 990) == 10);
    Assert(gcd<int>(1000, 0) == 1000);
    Assert(gcd<int>(0, 990) == 990);
    Assert(gcd<unsigned>(1000u, 990u) == 10u);
    Assert(gcd<unsigned>(1000u, 0u) == 1000u);
    Assert(gcd<unsigned>(0u, 990u) == 990u);
    {
        typedef polynomial< rational<int> > Q_X;
        Q_X a = shift_left(Q_X(1), 2) - Q_X(1); // x^2 - 1
        Q_X b = shift_left(Q_X(1), 1) + Q_X(1); // x   + 1
        if (verbose) {
            print("    poly 1 = "); print(Q_X(1)); print_eol();
            print("    poly a = "); print(a); print_eol();
            print("    poly 2*a = "); print(Q_X(2) * a); print_eol();
            print("    poly b = "); print(b); print_eol();
            print("    poly a * b = "); print(a * b); print_eol();
            pair<Q_X, Q_X> p = quotient_remainder(a, b);
            print("    poly a / b = "); print(p.m0);
                print(" remainder "); print(p.m1); print_eol();
        }
        Assert(gcd<Q_X>(a, b) == b);
    }

    // gcd for EuclideanSemimodule
    Assert(gcd<int, int>(1000, 990) == 10);
    Assert(gcd<int, int>(1000, 0) == 1000);
    Assert(gcd<int, int>(0, 990) == 990);
    Assert(gcd<unsigned, unsigned>(1000u, 990u) == 10u);
    Assert(gcd<unsigned, unsigned>(1000u, 0u) == 1000u);
    Assert(gcd<unsigned, unsigned>(0u, 990u) == 990u);
    Assert(gcd<double, long int>(0.75, 0.5) == 0.25);
    Assert(gcd<double, long int>(0.75, 0.0) == 0.75);
    Assert(gcd<double, long int>(0.0, 0.5) == 0.5);
    Assert(gcd<Q, Q>(Q(3, 4), Q(1, 2)) == Q(1, 4));
    Assert(gcd<Q, Q>(Q(3, 4), Q(0, 2)) == Q(3, 4));
    Assert(gcd<Q, Q>(Q(0, 4), Q(1, 2)) == Q(1, 2));

    algorithms_signed_q_and_r<int>();
    algorithms_signed_q_and_r<long>();
    algorithms_signed_q_and_r<Q>();
}


// Chapter 6. Iterators


// "Thunk"-style iterator

template<typename T>
    requires(Semiring(T))
struct square_of_i { 
    T i;
    square_of_i(T i) : i(i) { }
};

template<typename T>
    requires(Semiring(T))
struct value_type< square_of_i<T> >
{
    typedef T type;
};

template<typename T>
    requires(Semiring(T))
square_of_i<T> successor(const square_of_i<T>& x)
{
    return square_of_i<T>(x.i + T(1));
}

template<typename T>
    requires(Semiring(T))
T source(const square_of_i<T>& x)
{
    return x.i * x.i;
}

template<typename T>
    requires(Semiring(T))
bool operator==(const square_of_i<T>& x, const square_of_i<T>& y)
{
    return x.i == y.i;
}

template<typename Op>
    requires(BinaryOperation(Op))
struct accumulate
{
    typedef Domain(Op) T;
    Op op;
    T sum;
    accumulate(Op op, const T& x) : op(op), sum(x) { }
    void operator()(const T& x) { sum = op(sum, x); }
};

template<typename Op>
    requires(BinaryOperation)
struct input_type< accumulate<Op>, 0 >
{
    typedef Domain(Op) type;
};

template<typename T>
    requires(Regular(T))
struct identity
{
    T operator()(const T& x) { return x; }
};

template<typename T>
    requires(Regular(T))
struct input_type<identity<T>, 0>
{
    typedef T type;
};

void test_ch_6()
{
    print("  Chapter 6\n");

    {
        int i;
        i = int(0); increment(i); Assert(i == int(1));
        i = int(99); increment(i); Assert(i == int(100));
        double x[100];
        pointer(double) fx;
        fx = x; increment(fx); Assert(fx == x + 1);
        fx = &x[99]; increment(fx); Assert(fx == x + 100);
    }

    {
        typedef int Z; // Integer(Z)
        Z a[] = {0, 1, 2, 3, 4, 5};
        slist<Z> l(counted_range<Z*>(a, sizeof(a)/sizeof(Z)));
        typedef iterator_type< slist<Z> >::type I;
        typedef distance_type< I >::type N; // Integer(N)
        slist_iterator<Z> f = begin(l) + N(3);
        Assert(source(f) == Z(3));
        Assert(f - begin(l) == N(3));
        Assert(begin(l) - begin(l) == N(0));

        Assert(for_each(begin(l), end(l),
                        accumulate< plus<Z> >(plus<Z>(), Z(0))).sum == 15);

        Assert(find(begin(l), end(l), Z(-1)) == end(l));
        Assert(find(begin(l), end(l), Z(5)) == begin(l) + N(5));

        Z b[] = {1, 1, 1};
        slist<Z> lb(counted_range<Z*>(b, sizeof(b)/sizeof(Z)));
        Assert(find_not(begin(lb), end(lb), Z(1)) == end(lb));
        Assert(find_not(begin(lb), end(lb), Z(0)) == begin(lb));

        Assert(find_if(begin(l), end(l), negative<Z>) == end(l));
        Assert(find_if(begin(l), end(l),
                       lower_bound_predicate< less<Z> >(3, less<Z>())) == begin(l) + N(3));

        Assert(find_if_not(begin(lb), end(lb), positive<Z>) == end(lb));
        Assert(find_if_not(begin(l), end(l), positive<Z>) == begin(l));

        Assert(all(begin(lb), end(lb), positive<Z>));
        Assert(none(begin(l), end(l), negative<Z>));
        Assert(some(begin(l), end(l), positive<Z>));
        Assert(not_all(begin(l), end(l), positive<Z>));
        Assert(all(Z(1), Z(100), positive<Z>));
        Assert(none(Z(1), Z(100), negative<Z>));
        Assert(some(Z(0), Z(100), odd<Z>));
        Assert(not_all(Z(0), Z(100), odd<Z>));

        Assert(count_if(begin(l), end(l), even<Z>, Z(100)) == Z(100) + Z(3));
        Assert(count_if(begin(l), end(l), even<Z>) == Z(3));
        Assert(count_if_not(begin(l), end(l), positive<Z>, Z(-1)) == Z(-1) + Z(1));
        Assert(count_if_not(begin(l), end(l), positive<Z>) == Z(1));
        Assert(count(begin(l), end(l), Z(2), Z(100)) == Z(100) + Z(1));
        Assert(count(begin(l), end(l), Z(2)) == Z(1));
        Assert(count_not(begin(l), end(l), Z(2), Z(100)) == Z(100) + Z(5));
        Assert(count_not(begin(l), end(l), Z(2)) == Z(5));

        Assert(reduce_nonempty(0, 50, plus<Z>(), identity<Z>()) == Z(49*50/2));
        Assert(reduce_nonempty(0, 1, plus<Z>(), identity<Z>()) == Z(0));
        Assert(reduce_nonempty(begin(l), end(l), plus<Z>()) == Z(15));
        Assert(reduce_nonempty(begin(l), successor(begin(l)), plus<Z>()) == Z(0));

        Assert(reduce(0, 0, plus<Z>(), identity<Z>(), Z(0)) == Z(0));
        Assert(reduce(0, 50, plus<Z>(), identity<Z>(), Z(0)) == Z(49*50/2));
        Assert(reduce(0, 1, plus<Z>(), identity<Z>(), Z(0)) == Z(0));
        Assert(reduce(begin(l), begin(l), plus<Z>(), Z(0)) == Z(0));
        Assert(reduce(begin(l), end(l), plus<Z>(), Z(0)) == Z(15));
        Assert(reduce(begin(l), successor(begin(l)), plus<Z>(), Z(0)) == Z(0));

        Z c[] = {0, 1, 0, 2, 0, 3, 0, 4, 0, 5};
        slist<Z> lc(counted_range<Z*>(c, sizeof(c)/sizeof(Z)));
        Assert(reduce_nonzeroes(0, 0, plus<Z>(), identity<Z>(), Z(0)) == Z(0));
        Assert(reduce_nonzeroes(0, 50, plus<Z>(), identity<Z>(), Z(0)) == Z(49*50/2));
        Assert(reduce_nonzeroes(0, 1, plus<Z>(), identity<Z>(), Z(0)) == Z(0));
        Assert(reduce_nonzeroes(begin(lc), begin(lc), plus<Z>(), Z(0)) == Z(0));
        Assert(reduce_nonzeroes(begin(lc), end(lc), plus<Z>(), Z(0)) == Z(15));
        Assert(reduce_nonzeroes(
            begin(lc), successor(begin(lc)), plus<Z>(), Z(0)) == Z(0));

        Assert(reduce(begin(l), end(l)) == Z(15));
        Assert(reduce(begin(lb), end(lb)) == Z(3));
        Assert(reduce(begin(lc), end(lc)) == Z(15));

        {
            pair<accumulate< plus<Z> >, iterator_type< slist<Z> >::type> p =
                for_each_n(begin(l), size(l),
                           accumulate< plus<Z> >(plus<Z>(), Z(0)));
            Assert(p.m0.sum == 15 && p.m1 == end(l));
        }

        {
            pair<iterator_type< slist<Z> >::type, N> p =
                find_n(begin(l), size(l), Z(-1));
            Assert(p.m0 == end(l) && p.m1 == 0);
            p = find_n(begin(l), size(l), Z(5));
            Assert(p.m0 == begin(l) + N(5) && p.m1 == N(1));
        }


        Assert(find_if(
            begin(l), end(l), lower_bound_predicate< less<Z> >(3, less<Z>())) != end(l));
        Assert(find_if_unguarded(
            begin(l), lower_bound_predicate< less<Z> >(3, less<Z>())) == begin(l) + N(3));

        Assert(find_if_not(begin(l), end(l), positive<Z>) != end(l));
        Assert(find_if_not_unguarded(begin(l), positive<Z>) == begin(l));

        {
            pair<I, Z> p0 = find_mismatch(begin(l), end(l), Z(0), Z(6), equal<Z>());
            Assert(p0.m0 == end(l) && p0.m1 == Z(6));
            p0 = find_mismatch(begin(l), end(l), Z(0), Z(7), equal<Z>());
            Assert(p0.m0 == end(l) && p0.m1 == Z(6));
            p0 = find_mismatch(begin(l), end(l), Z(0), Z(4), equal<Z>());
            Assert(p0.m0 == begin(l) + N(4) && p0.m1 == Z(4));
            Z d[] = {0, 1, 2, 3, -4, 5};
            slist<Z> ld(counted_range<Z*>(d, sizeof(d)/sizeof(Z)));
            pair<I, I> p1 = find_mismatch(
                begin(l), end(l), begin(ld), end(ld), equal<Z>());
            Assert(p1.m0 == begin(l) + N(4) && p1.m1 == begin(ld) + N(4));

        }
        {
            Assert(find_adjacent_mismatch(begin(lb), end(lb), equal<Z>()) == end(lb));
            Z e[] = {0, 0, 0, 1, 0, 0};
            slist<Z> le(counted_range<Z*>(e, sizeof(e)/sizeof(Z)));
            Assert(find_adjacent_mismatch(begin(le), end(le), equal<Z>()) == begin(le) + N(3));

            Assert(find_adjacent_mismatch_forward(
                begin(lb), end(lb), equal<Z>()) == end(lb));
            Assert(find_adjacent_mismatch_forward(
                begin(le), end(le), equal<Z>()) == begin(le) + N(3));
        }

        Assert(relation_preserving(begin(l), begin(l), less<Z>()));
        Assert(relation_preserving(begin(l), end(l), less<Z>()));

        Assert(strictly_increasing_range(begin(l), begin(l), less<Z>()));
        Assert(strictly_increasing_range(begin(l), end(l), less<Z>()));
        Assert(!strictly_increasing_range(begin(lb), end(lb), less<Z>()));
        Assert(!strictly_increasing_range(begin(lc), end(lc), less<Z>()));

        Assert(relation_preserving(
            begin(l), end(l), complement_of_converse< less<Z> >(less<Z>())));
        {
            less<Z> lt;
            complement_of_converse< less<Z> > leq(lt);
            Assert(leq(Z(0), Z(0)));
            Assert(leq(Z(0), Z(1)));
            Assert(!leq(Z(1), Z(0)));
        }

        Assert(increasing_range(begin(l), begin(l), less<Z>()));
        Assert(increasing_range(begin(l), end(l), less<Z>()));
        Assert(increasing_range(begin(lb), end(lb), less<Z>()));
        Assert(!increasing_range(begin(lc), end(lc), less<Z>()));
        {
            Z f[] = {0, 0, 1, 1, 2, 3, 5, 5};
            slist<Z> lf(counted_range<Z*>(f, sizeof(f)/sizeof(Z)));
            Assert(!strictly_increasing_range(begin(lf), end(lf), less<Z>()));
            Assert(increasing_range(begin(lf), end(lf), less<Z>()));
        }

        Assert(partitioned(begin(l), begin(l), negative<Z>));
        Assert(partitioned(begin(l), end(l), negative<Z>));
        Assert(!partitioned(begin(l), end(l), zero<Z>));
        Assert(partitioned(begin(lb), end(lb), even<Z>));
        Assert(partitioned(begin(lb), end(lb), odd<Z>));
        Assert(partitioned(
            begin(l), end(l), lower_bound_predicate< less<Z> >(3, less<Z>())));
        Assert(partitioned(
            begin(l), end(l), upper_bound_predicate< less<Z> >(3, less<Z>())));
        {
            Z g[] = {0, 2, 4, 1, 3, 5};
            slist<Z> lg(counted_range<Z*>(g, sizeof(g)/sizeof(Z)));
            Assert(partitioned(begin(lg), end(lg), odd<Z>));
            Assert(!partitioned(begin(lg), end(lg), even<Z>));
        }

        Assert(partition_point_n(begin(lb), size(lb), zero<Z>) == end(lb));
        Assert(partition_point_n(begin(lb), size(lb), odd<Z>) == begin(lb));
        Assert(partition_point_n(
            begin(l), size(l), lower_bound_predicate< less<Z> >(3, less<Z>())) ==
            begin(l) + N(3));

        Assert(partition_point(begin(lb), end(lb), zero<Z>) == end(lb));
        Assert(partition_point(begin(lb), end(lb), odd<Z>) == begin(lb));
        Assert(partition_point(
            begin(l), end(l), lower_bound_predicate< less<Z> >(3, less<Z>())) ==
            begin(l) + N(3));

        { // bidirectional iterators
            Z h[] = {0, 1, 2, 3, 4, 5};
            list<Z> ah(counted_range<Z*>(h, sizeof(h)/sizeof(Z)));
            Assert(end(ah) - 1 == begin(ah) + (size(ah) - 1));

            Assert(find_backward_if(begin(ah), end(ah), zero<Z>) == successor(begin(ah)));
            Assert(find_backward_if(begin(ah), end(ah), negative<Z>) == begin(ah));
            Assert(find_backward_if_unguarded(end(ah), zero<Z>) == begin(ah));

            Assert(find_backward_if_not(begin(ah), end(ah), zero<Z>) == end(ah));
            Assert(find_backward_if_not(begin(ah), end(ah), positive<Z>) == successor(begin(ah)));
            Assert(find_backward_if_not_unguarded(end(ah), positive<Z>) == begin(ah));
        }
        { // random access iterators
            Z h[] = {0, 1, 2, 3, 4, 5};
            array<Z> ah(counted_range<Z*>(h, sizeof(h)/sizeof(Z)));
            Assert(end(ah) - 1 == begin(ah) + (size(ah) - 1));

            Assert(find_backward_if(begin(ah), end(ah), zero<Z>) == successor(begin(ah)));
            Assert(find_backward_if(begin(ah), end(ah), negative<Z>) == begin(ah));

            Assert(find_backward_if_not(begin(ah), end(ah), zero<Z>) == end(ah));
            Assert(find_backward_if_not(begin(ah), end(ah), positive<Z>) == successor(begin(ah)));
        }

     }

    int a[] = {0, 1, 2, 2, 4, 4, 5};
    pointer(int) f = a;
    pointer(int) l = a + sizeof(a) / sizeof(int);
    distance_type<int*>::type n = l - f;
    pointer(int) m;

    m = lower_bound_n(f, n, 2, less<int>()); Assert(m == a + 2);
    m = upper_bound_n(f, n, 2, less<int>()); Assert(m == a + 4);
    m = lower_bound_n(f, n, 3, less<int>()); Assert(m == a + 4);
    m = upper_bound_n(f, n, 3, less<int>()); Assert(m == a + 4);

    {
        const int N = 9;
        int s0 = reduce(square_of_i<int>(0), square_of_i<int>(N + 1), plus<int>(), 0);
        int s1 = reduce_balanced(
            square_of_i<int>(0), square_of_i<int>(N + 1), plus<int>(), 0);
        if (verbose) {
            print("    reduction of thunk iterator\n");
            print("      reduce(square(i), 0<=i<10, +) = ");
                print(s0);
                print_eol();
            print("      reduce(square(i), 0<=i<10, +) = ");
                print(s1);
                print_eol();
        }
        Assert(s0 == s1);
        Assert(s0 == (2 * N * N * N + 3 * N * N + N) / 6);
    }
}


// Chapter 7. Coordinate structures


template<typename C>
    requires(BifurcateCoordinate(C))
struct count_visits
{
    int n_pre, n_in, n_post;
    count_visits() : n_pre(0), n_in(0), n_post(0) { }
    void operator()(visit v, C)
    {
        switch (v) {
        case pre:  n_pre  = successor(n_pre);  break;
        case in:   n_in   = successor(n_in);   break;
        case post: n_post = successor(n_post); break;
        }
    }
};

template<typename Z, typename X>
void algorithms_lexicographical()
{
    print("    lexicographical\n");
    print("      ***** to do: parameterize by range type\n");

    verify_conservation<int> v(slist_node_count);

    Z a[] = {0, 1, 2, 3, 4, 5};
    typedef pointer(Z) I;
    I f_a = a;
    I l_a = f_a + (sizeof(a) / sizeof(Z));
    slist<Z> la(counted_range<Z*>(a, sizeof(a) / sizeof(Z)));
    Z b[] = {0, 1, 2, 3, 4, -5};
    I f_b = b;
    I l_b = f_b + (sizeof(b) / sizeof(Z));
    Assert(lexicographical_equivalent(f_a, l_a, begin(la), end(la), equal<Z>()));
    Assert(lexicographical_equal(f_a, l_a, begin(la), end(la)));
    Assert(!lexicographical_equal(f_b, l_b, begin(la), end(la)));

    Assert(size(la) == 6 &&
        lexicographical_equal_k<6, I, IteratorType(slist<Z>)>()(f_a, begin(la)));

    typedef DistanceType(I) NP;
    Assert( lexicographical_compare(f_a, f_a, f_a, l_a, less<Z>()));
    Assert( lexicographical_compare(f_a, f_a + NP(4), f_a, l_a, less<Z>()));
    Assert( lexicographical_compare(f_a, f_a + NP(5), f_a, l_a, less<Z>()));
    Assert(!lexicographical_compare(f_a, f_a + NP(6), f_a, l_a, less<Z>()));
    Assert(!lexicographical_compare(f_a, l_a, f_a, f_a + NP(4), less<Z>()));

    less<Z> lt;
    comparator_3_way< less<Z> > comp(lt);
    Assert(lexicographical_compare_3way(f_a, l_a, f_b, l_b, comp) == -1);
    Assert(lexicographical_compare_3way(f_a, l_a, f_a, l_a, comp) ==  0);
    Assert(lexicographical_compare_3way(f_b, l_b, f_a, l_a, comp) ==  1);

    Assert( lexicographical_less(f_a, f_a, f_a, l_a));
    Assert( lexicographical_less(f_a, f_a + NP(4), f_a, l_a));
    Assert( lexicographical_less(f_a, f_a + NP(5), f_a, l_a));
    Assert(!lexicographical_less(f_a, f_a + NP(6), f_a, l_a));
    Assert(!lexicographical_less(f_a, l_a, f_a, f_a + NP(4)));

    Assert(!lexicographical_less_k<6, I, I>()(f_a, f_b));
    Assert(lexicographical_less_k<6, I, I>()(f_b, f_a));

}

template<typename T, typename T_X>
    requires(Tree(T) && Tree(T_X))
void algorithms_bifurcate_coordinates()
{
    print("    bifurcate coordinates\n");

    typedef CoordinateType(T) C;
    typedef WeightType(T) N;
    typedef CoordinateType(T_X) C_X;

    T t0;
    T t4(4);
    T t3_45(3, t4, T(5));
    T t2_345_678(2, t3_45, T(6, T(7), T(8)));
    T t(1, t2_345_678, T(9, T(10, T(11), T(12)), T(13, T(14), T(15))));
    if (verbose) {
        print("t4:         "); print(t4); print_eol();
        print("t3_45:      "); print(t3_45); print_eol();
        print("t2_345_678: "); print(t2_345_678); print_eol();
        print("t:          "); print(t); print_eol();
    }

    C r = begin(t);
    Assert(!empty(r));
    Assert(has_left_successor(r));
    C r_l = left_successor(r);
    Assert(!empty(r_l));
    Assert(has_left_successor(r_l));
    C r_l_l = left_successor(r_l);

    Assert(empty(begin(t0)));
    Assert(weight_recursive(begin(t0))         == N(0));
    Assert(weight_recursive(begin(t4))         == N(1));
    Assert(weight_recursive(begin(t3_45))      == N(3));
    Assert(weight_recursive(begin(t2_345_678)) == N(7));
    Assert(weight_recursive(begin(t))          == N(15));
    Assert(height_recursive(begin(t0))         == N(0));
    Assert(height_recursive(begin(t4))         == N(1));
    Assert(height_recursive(begin(t3_45))      == N(2));
    Assert(height_recursive(begin(t2_345_678)) == N(3));
    Assert(height_recursive(begin(t))          == N(4));

    count_visits<C> proc;
    proc = traverse_nonempty(begin(t), proc);
    Assert(proc.n_pre == N(15) && proc.n_in == N(15) && proc.n_post == N(15));

    C c_r = begin(t3_45);

    T s4(-4);
    T s3_45(-3, t4, T(-5));
    T s2_345_678(-2, t3_45, T(-6, T(-7), T(-8)));
    T s(-1, t2_345_678, T(-9, T(-10, T(-11), T(-12)), T(-13, T(-14), T(-15))));
    T_X x4('d');
    T_X x3_45('c', x4, T_X('e'));
    T_X x2_345_678('b', x3_45, T_X('f', T_X('g'), T_X('h')));
    T_X x('a', x2_345_678, T_X('i', T_X('j', T_X('k'), T_X('l')),
                                    T_X('m', T_X('n'), T_X('o'))));

    Assert(bifurcate_isomorphic_nonempty(begin(t), begin(t)));
    Assert(bifurcate_isomorphic_nonempty(begin(t), begin(s)));
    Assert(!bifurcate_isomorphic_nonempty(begin(t), begin(t2_345_678)));
    Assert(bifurcate_isomorphic_nonempty(begin(t), begin(x)));
    Assert(bifurcate_isomorphic_nonempty(
        left_successor(begin(t)), right_successor(begin(x))));

    T u(t);
    if (verbose) {
        print("u(t):       "); print(u); print_eol();
    }
    Assert(t == u);
    Assert(bifurcate_equivalent_nonempty(
        begin(t), begin(u), equal<ValueType(T)>()));
    Assert(!bifurcate_equivalent_nonempty(
        begin(t), begin(t2_345_678), equal<ValueType(T)>()));

    // These exercise bifurcate_compare_nonempty
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
}

template <typename T, typename T_X>
    requires(Tree(T) && Tree(T_X) && Integer(ValueType(T)) && Character(ValueType(T_X)))
void algorithms_bidirectional_bifurcate_coordinates()
{
    print("    bidirectional bifurcate coordinates\n");

    typedef ValueType(T) Z;
    typedef CoordinateType(T) C;
    typedef WeightType(T) N;
    typedef CoordinateType(T_X) C_X;

    T t0;
    T t4(4);
    T t3_45(3, t4, T(5));
    T t2_345_678(2, t3_45, T(6, T(7), T(8)));
    T t(1, t2_345_678, T(9, T(10, T(11), T(12)), T(13, T(14), T(15))));
    if (verbose) {
        print("t4:         "); print(t4); print_eol();
        print("t3_45:      "); print(t3_45); print_eol();
        print("t2_345_678: "); print(t2_345_678); print_eol();
        print("t:          "); print(t); print_eol();
    }

    C root = begin(t);

    Assert(has_left_successor(root));
    C root_l = left_successor(root);
    Assert(is_left_successor(root_l));
    Assert(!is_right_successor(root_l));

    Assert(has_right_successor(root));
    C root_r = right_successor(root);
    Assert(is_right_successor(root_r));
    Assert(!is_left_successor(root_r));

    Assert(has_left_successor(root_l));
    C root_l_l = left_successor(root_l);

    count_visits<C> proc;
    proc = traverse(begin(t), proc);
    Assert(proc.n_pre == N(15) && proc.n_in == N(15) && proc.n_post == N(15));

    C c_r = begin(t3_45);
    C c = c_r;
    visit v(pre);
    int dh;
    dh = traverse_step(v, c);
    Assert(dh == 1 && c == left_successor(c_r) && v == pre);
    dh = traverse_step(v, c);
    Assert(dh == 0 && c == left_successor(c_r) && v == in);
    dh = traverse_step(v, c);
    Assert(dh == 0 && c == left_successor(c_r) && v == post);
    dh = traverse_step(v, c);
    Assert(dh == -1 && c == c_r && v == in);
    dh = traverse_step(v, c);
    Assert(dh == 1 && c == right_successor(c_r) && v == pre);
    dh = traverse_step(v, c);
    Assert(dh == 0 && c == right_successor(c_r) && v == in);
    dh = traverse_step(v, c);
    Assert(dh == 0 && c == right_successor(c_r) && v == post);
    dh = traverse_step(v, c);
    Assert(dh == -1 && c == c_r && v == post);

    Assert(reachable(root, root_l_l));
    Assert(!reachable(root_l_l, root));

    Assert(weight(begin(t0))         == N(0));
    Assert(weight(begin(t4))         == N(1));
    Assert(weight(begin(t3_45))      == N(3));
    Assert(weight(begin(t2_345_678)) == N(7));
    Assert(weight(begin(t))          == N(15));
    Assert(height(begin(t0))         == N(0));
    Assert(height(begin(t4))         == N(1));
    Assert(height(begin(t3_45))      == N(2));
    Assert(height(begin(t2_345_678)) == N(3));
    Assert(height(begin(t))          == N(4));

    proc.n_pre = 0; proc.n_in = 0; proc.n_post = 0;
    proc = traverse(begin(t0), proc);
    Assert(proc.n_pre == N(0) && proc.n_in == N(0) && proc.n_post == N(0));
    proc = traverse(begin(t), proc);
    Assert(proc.n_pre == N(15) && proc.n_in == N(15) && proc.n_post == N(15));

    T s4(-4);
    T s3_45(-3, t4, T(-5));
    T s2_345_678(-2, t3_45, T(-6, T(-7), T(-8)));
    T s(-1, t2_345_678, T(-9, T(-10, T(-11), T(-12)), T(-13, T(-14), T(-15))));
    T_X x4('d');
    T_X x3_45('c', x4, T_X('e'));
    T_X x2_345_678('b', x3_45, T_X('f', T_X('g'), T_X('h')));
    T_X x('a', x2_345_678, T_X('i', T_X('j', T_X('k'), T_X('l')),
                                    T_X('m', T_X('n'), T_X('o'))));

    Assert(bifurcate_isomorphic_nonempty(begin(t), begin(t)));
    Assert(bifurcate_isomorphic_nonempty(begin(t), begin(s)));
    Assert(!bifurcate_isomorphic_nonempty(begin(t), begin(t2_345_678)));
    Assert(bifurcate_isomorphic_nonempty(begin(t), begin(x)));
    Assert(bifurcate_isomorphic_nonempty(
        left_successor(begin(t)), right_successor(begin(x))));

    Assert(bifurcate_isomorphic(begin(t0), begin(t0)));
    Assert(!bifurcate_isomorphic(begin(t), begin(t0)));
    Assert(!bifurcate_isomorphic(begin(t0), begin(t)));
    Assert(bifurcate_isomorphic(begin(t), begin(t)));
    Assert(bifurcate_isomorphic(begin(t), begin(s)));
    Assert(!bifurcate_isomorphic(begin(t), begin(t2_345_678)));
    Assert(bifurcate_isomorphic(begin(t), begin(x)));
    Assert(bifurcate_isomorphic(
        left_successor(begin(t)), right_successor(begin(x))));

    T tt(t);
    Assert(t == tt);
    Assert(bifurcate_equivalent_nonempty(begin(t), begin(tt), equal<Z>()));
    Assert(!bifurcate_equivalent_nonempty(begin(t), begin(t2_345_678), equal<Z>()));
    Assert(bifurcate_equivalent(begin(t0), begin(t0), equal<Z>()));
    Assert(!bifurcate_equivalent(begin(t), begin(t0), equal<Z>()));
    Assert(!bifurcate_equivalent(begin(t0), begin(t), equal<Z>()));
    Assert(bifurcate_equivalent(begin(t), begin(tt), equal<Z>()));
    Assert(!bifurcate_equivalent(begin(t), begin(t2_345_678), equal<Z>()));

    // Test equivalence for two coordinate types
    typedef stree<Z> U;
    U u0;
    U u4(4);
    U u3_45(3, u4, U(5));
    U u2_345_678(2, u3_45, U(6, U(7), U(8)));
    U u(1, u2_345_678, U(9, U(10, U(11), U(12)), U(13, U(14), U(15))));
    Assert( bifurcate_equivalent_nonempty(begin(t), begin(u), equal<Z>()));
    Assert( bifurcate_equivalent_nonempty(begin(t), begin(u), equal<Z>()));
    Assert(!bifurcate_equivalent_nonempty(
        left_successor(begin(t)), begin(u), equal<Z>()));

    // These exercise bifurcate_less and bifurcate_compare
    Assert(!(t < tt) && !(tt < t));
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

    Assert( bifurcate_shape_compare(begin(t0), begin(t4)));
    Assert(!bifurcate_shape_compare(begin(t4), begin(t0)));
    Assert(!bifurcate_shape_compare(left_successor(begin(t)), right_successor(begin(t))));
    Assert(!bifurcate_shape_compare(right_successor(begin(t)), left_successor(begin(t))));
    Assert( bifurcate_shape_compare(begin(t2_345_678), begin(t)));
    Assert(!bifurcate_shape_compare(begin(t), begin(t2_345_678)));
}

template <typename Z, typename X>
    requires(Integer(Z) && Regular(X))
void test_ch_7()
{
    print("  Chapter 7\n");

    algorithms_lexicographical<Z, X>();

    verify_conservation<int> vs(stree_node_count);
    verify_conservation<int> v(tree_node_count);

    algorithms_bifurcate_coordinates< stree<Z>, stree<X> >();
    algorithms_bifurcate_coordinates< tree<Z>, tree<X> >();
    algorithms_bidirectional_bifurcate_coordinates< tree<Z>, tree<X> >();
}


// Chapter 8. Coordinates with mutable successors


template<typename L>
    requires(List(L))
void algorithms_linked()
{
    typedef ValueType(L) Z;
    typedef IteratorType(L) I;
    typedef DistanceType(I) N;
    const int n = 500;
    array<Z> a(n, n, Z(0));
    typedef IteratorType(array<Z>) Ia;

    Ia f = begin(a);
    iota(n, f);
    Ia t;
    advance_tail(t, f);
    Assert(t == begin(a) && f == successor(t));

    // ***** to do: linker_to_tail

    L la(a);
    L lb;

    Assert(size(lb) == 0);
    I last = find_last(begin(la), end(la));
    Assert(source(last) == predecessor(n) && successor(last) == end(la));

    // ***** to do: split_linked, combine_linked_nonempty

    // ***** to do: linker_to_head

    // ***** rewrite these tests in terms of procedures on raw coordinates ?????

    reverse(la);
    Assert(size(la) == n);
    equal_iota_reverse(begin(la), end(la));
    reverse(la);
    Assert(size(la) == n);
    Assert(equal_iota(begin(la), end(la)));

    partition(la, lb, even<Z>);
    Assert(size(la) + size(lb) == n);
    Assert(all(begin(la), end(la), odd<Z>));
    Assert(all(begin(lb), end(lb), even<Z>));

    merge(la, lb, less<Z>());
    Assert(size(la) == n && empty(lb));
    Assert(equal_iota(begin(la), end(la)));

    reverse(la);
    sort(la, less<Z>());
    Assert(size(la) == n);
    Assert(equal_iota(begin(la), end(la)));
}

template<typename Z>
    requires(Integer(Z))
void algorithms_linked_iterators()
{
    print("    linked iterators\n");

    verify_conservation<int> vs(slist_node_count);
    verify_conservation<int> v(list_node_count);

    algorithms_linked< slist<Z> >();
    algorithms_linked< list<Z> >();
}

template<typename C>
    requires(Readable(C) && AdditiveMonoid(ValueType(C)))
struct sum_source
{
    typedef ValueType(C) T;
    T sum;
    sum_source() : sum(T(0)) { }
    void operator()(C c) { sum = sum + source(c); }
};

template<typename C>
    requires(Readable(C) && AdditiveMonoid(ValueType(C)))
struct input_type< sum_source<C>, 0 >
{
    typedef C type;
};

template<typename Z>
    requires(Integer(Z))
void algorithms_linked_bifurcate_coordinates()
{
    print("    linked bifurcate coordinates\n");

    verify_conservation<int> v(stree_node_count);

    typedef stree<Z> T;
    typedef CoordinateType(T) C;
    typedef WeightType(C) N;

    // ***** to do: test tree_rotate on single-node tree 

    {
        T t0_12(0, T(1), T(2));
        C root = begin(t0_12);
        N n = weight_recursive(root);
        Assert(n == 3);
        C null = C(); // empty(null)
        C l = left_successor(root);
        C r = right_successor(root);
        C curr = root;
        C prev = null;
        
        tree_rotate(curr, prev);
        Assert(left_successor(root) == r &&
            right_successor(root) == null &&
            curr == l &&
            prev == root);
        tree_rotate(curr, prev);
        tree_rotate(curr, prev);
        tree_rotate(curr, prev);
        tree_rotate(curr, prev);
        tree_rotate(curr, prev);
        tree_rotate(curr, prev);
        tree_rotate(curr, prev);
        tree_rotate(curr, prev);
        Assert(curr == root && prev == null);
        Assert(weight_recursive(root) == n &&
            source(root) == Z(0) &&
            source(left_successor(root)) == Z(1) &&
            source(right_successor(root)) == Z(2));

        // ***** to do: more verification of individual tree_rotate steps 
    }
    T t4(4);
    T t3_45(3, t4, T(5));
    T t2_345_678(2, t3_45, T(6, T(7), T(8)));
    T t1__15(1, t2_345_678, T(9, T(10, T(11), T(12)), T(13, T(14), T(15))));
    // weight_rotating exercises counter
    Assert(weight_rotating(begin(t3_45)) == N(3));
    Assert(weight_rotating(begin(t1__15)) == N(15));

    // traverse_phased_rotating exercises phased_applicator
    Assert(traverse_phased_rotating(
            begin(t1__15),
            0,
            sum_source<C>()
        ).sum == N(120));
}

template <typename Z>
    requires(Integer(Z))
void test_bifurcate_copy_Andrej()
{

    typedef stree<Z> T;
    typedef CoordinateType(T) C;
    typedef WeightType(C) N;

    T tt4(4, T(5), T());
    T tt2(2, T(3), tt4);
    T tt1(1, tt2, T(6));
    T tt0(0, T(), tt1);

    T t(tt0); // invokes bifurcate_copy
    Assert(t == tt0);
    
}

template<typename Z>
    requires(Integer(Z))
void test_ch_8()
{
    print("  Chapter 8\n");

    // ***** to do: predicate_source
    // ***** to do: relation_source

    algorithms_linked_iterators<Z>();
    algorithms_linked_bifurcate_coordinates<Z>();

    test_bifurcate_copy_Andrej<Z>();
}


// Chapter 9. Copying


template<typename S>
    requires(DynamicSequence(S))
void extend_sequence_n(S& s, DistanceType(IteratorType(S)) n, const ValueType(S)& x)
{
    typedef after<S> AP;
    while (count_down(n)) AP ap = insert(AP(s, begin(s)), x);
}

template<typename I>
    requires(Readable(I) && Iterator(I) &&
        Integer(ValueType(I)))
bool equal_iota_reverse(I f, I l)
{
    ValueType(I) n(l - f);
    while (f != l) {
        n = predecessor(n);
        if (source(f) != n) return false;
        f = successor(f);
    }
    return true;
}

template<typename T>
    requires(Regular(T))
struct equal_to_x
{
    T x;
    equal_to_x(const T& x) : x(x) { }
    bool operator()(const T& y) { return x == y; }
};

template<typename T>
    requires(Regular(T))
struct input_type< equal_to_x<T>, 0 >
{
    typedef T type;
};

template<typename I0, typename I1>
    requires(Mutable(I0) && ForwardIterator(I0) &&
        Mutable(I1) && ForwardIterator(I1) &&
        ValueType(I0) == ValueType(I1) &&
        Integer(ValueType(I0)))
void algorithms_copy_forward(I0 f0, I0 l0, I1 f1, I1 l1)
{
    // Precondition: $l0 - f0 <= l1 - f1$
    typedef ValueType(I0) T;
    typedef DistanceType(I0) N0;
    typedef DistanceType(I1) N1;
    N0 n = l0 - f0;
    N0 n_over_2(half_nonnegative(n));
    Assert(n <= N0(l1 - f1));

    // test fill_step (used for other tests)
    {
        {
            I1 f = f1;
            while (f != l1) {
                sink(f) = 0;
                f = successor(f);
            }
        }
        I1 f_o = f1;
        fill_step(f_o, -1);
        Assert(f_o == successor(f1));
        Assert(source(f1) == -1);
    }

    // test fill
    {
        {
            I1 f = f1;
            while (f != l1) {
                sink(f) = T(-1);
                f = successor(f);
            }
        }
        I1 l_o = f1 + N1(n - N0(2));
        I1 m1 = fill(successor(f1), l_o, T(0));
        Assert(m1 == l_o);
        Assert(all(successor(f1), m1, equal_to_x<T>(T(0))));
        Assert(source(f1) == -1 && source(f1 + N1(n - N0(1))) == T(-1));

    }

    // test fill_n
    {
        {
            I1 f = f1;
            while (f != l1) {
                sink(f) = T(-1);
                f = successor(f);
            }
        }
        N1 n1 = N1(n - N0(2));
        I1 m1 = fill_n(successor(f1), n1, T(0));
        Assert(m1 == successor(f1) + n1);
        Assert(all(successor(f1), m1, equal_to_x<T>(T(0))));
        Assert(source(f1) == -1 && source(f1 + N1(n - N0(1))) == T(-1));

    }

    // test copy_step
    {
        I0 f_i = f0;
        iota(n, f0);
        I1 f_o = f1;
        fill_n(f1, l1 - f1, -1);
        copy_step(f_i, f_o);
        Assert(f_i == successor(f0));
        Assert(f_o == successor(f1));
        Assert(source(f1) == source(f0));
    }

    // test copy, not aliased
    {
        iota(n, f0);
        I0 m0 = f0 + (n - N0(2));
        fill_n(f1, n, -1);
        I1 m1 = copy(f0, m0, successor(f1));
        Assert(m1 == f1 + N1(n - N0(1)));
        Assert(lexicographical_equal(f0, m0, successor(f1), m1));
        Assert(source(f1) == -1 && source(f1 + (n - N0(1))) == -1);

    }

    // test copy, aliased backward
    {
        iota(n, f0);
        I1 m1 = copy(f0 + N0(2), l0, f1); // save original values
        I0 m0 = copy(f0 + N0(2), l0, f0);
        Assert(m0 == f0 + (n - N0(2)));
        Assert(lexicographical_equal(f0, m0, f1, m1));
        Assert(source(m0) == m0 - f0 && source(successor(m0)) == successor(m0 - f0));
    }

    // test copy_bounded
    {
        iota(n, f0);
        fill_n(f1, n, -1);
        pair<I0, I1> pio = copy_bounded(f0, l0, f1, f1 + N1(n_over_2));
        Assert(pio.m0 == f0 + n_over_2 && pio.m1 == f1 + N1(n_over_2));
        Assert(lexicographical_equal(f0, pio.m0, f1, pio.m1));
        Assert(source(f1 + N1(successor(n_over_2))) == -1);
    }

    // test count_down
    {
        N0 i;
        N0 n;
        n = N0(5);
        i = N0(0);
        while (count_down(n)) i = successor(i);
        Assert(i == N0(5));
        n = N0(0);
        i = N0(0);
        while (count_down(n)) i = successor(i);
        Assert(i == N0(0));
    }

    // test copy_n
    {
        N0 n0 = (n - N0(2));
        fill_n(f1, n, -1);
        pair<I0, I1> pio = copy_n(f0, n0, successor(f1));
        Assert(pio.m0 == f0 + n0);
        Assert(pio.m1 == f1 + N1(n - N0(1)));
        Assert(lexicographical_equal(f0, f0 + n0, successor(f1), pio.m1));
        Assert(source(f1) == -1 && source(f1 + (n - N0(1))) == -1);
    }

    // test copy_select
    {
        iota(n, f0);
        predicate_source< I0, bool (*)(const T&) > es(even<T>);
        I1 m1 = copy_select(f0, l0, f1, es);
        Assert(m1 - f1 == count_if(f0, l0, even<T>));
        Assert(all(f1, m1, even<T>));
    }

    // test copy_if
    {
        iota(n, f0);
        I1 m1 = copy_if(f0, l0, f1, odd<T>);
        Assert(m1 - f1 == count_if(f0, l0, odd<T>));
        Assert(all(f1, m1, odd<T>));
    }

    // test split_copy
    {
        iota(n, f0);
        I0 f_f = f0;
        I1 f_t = f1;
        predicate_source< I0, bool (*)(const T&) > es(even<T>);
        N0 n_f = count_if(f0, l0, odd<T>);
        N1 n_t = count_if(f0, l0, even<T>);
        pair<I0, I1> pft = split_copy(f0, l0, f_f, f_t, es);
        Assert(pft.m0 - f_f == n_f);
        Assert(pft.m1 - f_t == n_t);
        Assert(all(f_f, pft.m0, odd<T>));
        Assert(all(f_t, pft.m1, even<T>));
    }

    // test split_copy_n
    {
        iota(n, f0);
        I0 f_f = f0;
        I1 f_t = f1;
        predicate_source< I0, bool (*)(const T&) > es(even<T>);
        N0 n_f = count_if(f0, l0, odd<T>);
        N1 n_t = count_if(f0, l0, even<T>);
        pair<I0, I1> pft = split_copy_n(f0, n, f_f, f_t, es);
        Assert(pft.m0 - f_f == n_f);
        Assert(pft.m1 - f_t == n_t);
        Assert(all(f_f, pft.m0, odd<T>));
        Assert(all(f_t, pft.m1, even<T>));
    }

    // test partition_copy
    {
        iota(n, f0);
        I0 f_f = f0;
        I1 f_t = f1;
        N0 n_f = count_if(f0, l0, even<T>);
        N1 n_t = count_if(f0, l0, odd<T>);
        pair<I0, I1> pft = partition_copy(f0, l0, f_f, f_t, odd<T>);
        Assert(pft.m0 - f_f == n_f);
        Assert(pft.m1 - f_t == n_t);
        Assert(all(f_f, pft.m0, even<T>));
        Assert(all(f_t, pft.m1, odd<T>));
    }

    // test partition_copy_n
    {
        iota(n, f0);
        I0 f_f = f0;
        I1 f_t = f1;
        N0 n_f = count_if(f0, l0, even<T>);
        N1 n_t = count_if(f0, l0, odd<T>);
        pair<I0, I1> pft = partition_copy_n(f0, n, f_f, f_t, odd<T>);
        Assert(pft.m0 - f_f == n_f);
        Assert(pft.m1 - f_t == n_t);
        Assert(all(f_f, pft.m0, even<T>));
        Assert(all(f_t, pft.m1, odd<T>));
    }

    // test combine_copy
    {
        I0 m0 = iota(n_over_2, f0);
        iota(n - n_over_2, m0);
        less<ValueType(I0)> lt;
        relation_source< I0, I0, less<ValueType(I0)> > lts(lt);
        I1 m1 = combine_copy(f0, m0, m0, l0, f1, lts);
        Assert(m1 - f1 == n);
        Assert(increasing_range(f1, m1, less<T>()));
    }

    // test combine_copy_n
    {
        I0 m0 = iota(n_over_2, f0);
        iota(n - n_over_2, m0);
        less<ValueType(I0)> lt;
        relation_source< I0, I0, less<ValueType(I0)> > lts(lt);
        triple<I0, I0, I1> t = combine_copy_n(f0, m0 - f0, m0, l0 - m0, f1, lts);
        Assert(t.m0 == m0 && t.m1 == l0 && t.m2 - f1 == n);
        Assert(increasing_range(f1, t.m2, less<T>()));
    }

    // test merge_copy
    {
        I0 m0 = iota(n_over_2, f0);
        iota(n - n_over_2, m0);
        less<ValueType(I0)> lt;
        I1 m1 = merge_copy(f0, m0, m0, l0, f1, lt);
        Assert(m1 - f1 == n);
        Assert(increasing_range(f1, m1, less<T>()));
    }

    // test exchange_values, swap_step
    {
        I0 f_0 = f0;
        I1 f_1 = f1;
        sink(f_0) = 137;
        sink(f_1) = -99;
        exchange_values(f0, f1);

        Assert(f_0 == f0 && f_1 == f1);
        Assert(source(f0) == -99 && source(f1) == 137);

        swap_step(f_0, f_1);

        Assert(f_0 == successor(f0) && f_1 == successor(f1));
        Assert(source(f0) == 137 && source(f1) == -99);
    }

    // test swap_ranges
    {
        iota(n, f0);
        fill_n(f1, n, T(-1));
        I1 m1 = swap_ranges(f0, l0, f1);
        Assert(m1 == f1 + N1(n));
        Assert(equal_iota(f1, m1));
        Assert(all(f0, l0, equal_to_x<T>(-1)));
    }

    // test swap_ranges_ bounded
    {
        iota(n, f0);
        N1 n1(n_over_2);
        fill_n(f1, n1, T(-1));
        pair<I0, I1> p01 = swap_ranges_bounded(f0, l0, f1, f1 + n1);
        Assert(p01.m0 == f0 + N0(n1));
        Assert(p01.m1 == f1 + n1);
        Assert(equal_iota(f1, p01.m1));
        Assert(all(f0, p01.m0, equal_to_x<T>(-1)));
    }

    // test swap_ranges_n
    {
        iota(n, f0);
        fill_n(f1, n, T(-1));
        pair<I0, I1> p01 = swap_ranges_n(f0, f1, n);
        Assert(p01.m0 == f0 + n);
        Assert(p01.m1 == f1 + N1(n));
        Assert(equal_iota(f1, p01.m1));
        Assert(all(f0, l0, equal_to_x<T>(-1)));
    }
}

template<typename I0, typename I1>
    requires(Readable(I0) && BidirectionalIterator(I0) &&
        Writable(I1) && BidirectionalIterator(I1) &&
        ValueType(I0) == ValueType(I1))
void algorithms_copy_backward(I0 f0, I0 l0, I1 f1, I1 l1)
{
    // Precondition: $l0 - f0 <= l1 - f1$
    typedef ValueType(I0) T;
    typedef DistanceType(I0) N0;
    typedef DistanceType(I1) N1;
    N0 n = l0 - f0;
    N0 n_over_2(half_nonnegative(n));
    Assert(n <= N0(l1 - f1));

    // test copy_backward_step
    {
        I0 l_i = l0;
        iota(n, f0);
        I1 l_o = l1;
        fill_n(f1, l1 - f1, -1);
        copy_backward_step(l_i, l_o);
        Assert(l_i == predecessor(l0));
        Assert(l_o == predecessor(l1));
        Assert(source(predecessor(l1)) == source(predecessor(l0)));
    }

    // test copy_backward
    {
        I0 m0 = l0 - (n - N0(2));
        fill_n(f1, n, -1);
        I1 m1 = copy_backward(m0, l0, predecessor(l1));
        Assert(m1 == l1 - N1(n - N0(1)));
        Assert(lexicographical_equal(m0, l0, m1, predecessor(l1)));
        Assert(source(predecessor(m1)) == -1 && source(predecessor(l1)) == -1);
    }

    // test copy_backward_n
    {
        const N0 n_minus_2 = n - N0(2);
        I0 m0 = l0 - n_minus_2;
        fill_n(f1, n, -1);
        pair<I0, I1> p = copy_backward_n(l0, n_minus_2, predecessor(l1));
        Assert(p.m1 == l1 - N1(n - N0(1)));
        Assert(lexicographical_equal(m0, l0, p.m1, predecessor(l1)));
        Assert(source(predecessor(p.m1)) == -1 && source(predecessor(l1)) == -1);
    }

    // test combine_copy_backward
    {
        I0 m0 = iota(n_over_2, f0);
        iota(n - n_over_2, m0);
        less<ValueType(I0)> lt;
        relation_source< I0, I0, less<ValueType(I0)> > lts(lt);
        I1 m1 = combine_copy_backward(f0, m0, m0, l0, l1, lts);
        Assert(l1 - m1 == n);
        Assert(increasing_range(m1, l1, less<T>()));
    }

    // test combine_copy_backward_n
    {
        I0 m0 = iota(n_over_2, f0);
        iota(n - n_over_2, m0);
        less<ValueType(I0)> lt;
        relation_source< I0, I0, less<ValueType(I0)> > lts(lt);
        triple<I0, I0, I1> t = combine_copy_backward_n(m0, m0 - f0, l0, l0 - m0, l1, lts);
        Assert(t.m0 == f0 && t.m1 == m0 && l1 - t.m2 == n);
        Assert(increasing_range(t.m2, l1, less<T>()));
    }

    // test merge_copy_backward
    {
        I0 m0 = iota(n_over_2, f0);
        iota(n - n_over_2, m0);
        less<ValueType(I0)> lt;
        I1 m1 = merge_copy_backward(f0, m0, m0, l0, l1, lt);
        Assert(l1 - m1 == n);
        Assert(increasing_range(m1, l1, less<T>()));
    }

    // test merge_copy_backward_n
    {
        I0 m0 = iota(n_over_2, f0);
        iota(n - n_over_2, m0);
        less<ValueType(I0)> lt;
        triple<I0, I0, I1> t = merge_copy_backward_n(m0, m0 - f0, l0, l0 - m0, l1, lt);
        Assert(t.m0 == f0 && t.m1 == m0 && l1 - t.m2 == n);
        Assert(increasing_range(t.m2, l1, less<T>()));
    }
}

template<typename I0, typename I1>
    requires(Mutable(I0) && BidirectionalIterator(I0) &&
        Mutable(I1) && BidirectionalIterator(I1) &&
        ValueType(I0) == ValueType(I1))
void algorithms_copy_reverse(I0 f0, I0 l0, I1 f1, I1 l1)
{
    // Precondition: $l0 - f0 == l1 - f1$
    typedef ValueType(I0) T;
    typedef DistanceType(I0) N0;
    typedef DistanceType(I1) N1;
    N0 n = l0 - f0;
    N0 n_over_2(half_nonnegative(n));
    Assert(n == N0(l1 - f1));

    // test reverse_copy_step
    {
        if (verbose) print("        reverse_copy_step\n");
        I0 l_i = l0;
        iota(n, f0);
        I1 f_o = f1;
        fill_n(f1, l1 - f1, -1);
        reverse_copy_step(l_i, f_o);
        Assert(l_i == predecessor(l0));
        Assert(f_o == successor(f1));
        Assert(source(f1) == source(predecessor(l0)));
    }

    // test reverse_copy_backward_step
    {
        if (verbose) print("        reverse_copy_backward_step\n");
        I0 f_i = f0;
        iota(n, f0);
        I1 l_o = l1;
        fill_n(f1, l1 - f1, -1);
        reverse_copy_backward_step(f_i, l_o);
        Assert(f_i == successor(f0));
        Assert(l_o == predecessor(l1));
        Assert(source(predecessor(l1)) == source(f0));
    }

    // test reverse_copy
    {
        if (verbose) print("        reverse_copy\n");
        iota(n, f0);
        fill_n(f1, l1 - f1, -1);
        I1 f_o = successor(f1);
        I1 l_o = reverse_copy(f0, l0 - N0(2), f_o);
        Assert(l_o == predecessor(l1));
        N1 n_o(n - N0(2));
        while (count_down(n_o)) {
            Assert(source(f_o) == n_o);
            f_o = successor(f_o);
        }
        Assert(source(f1) == -1 && source(predecessor(l1)) == -1);
    }
    
    // test reverse_copy_backward
    {
        if (verbose) print("        reverse_copy_backward\n");
        iota(n, f0);
        fill_n(f1, n, -1);
        I1 l_o = predecessor(l1);
        I1 f_o = reverse_copy_backward(f0, l0 - N0(2), l_o);
        Assert(f_o == successor(f1));
        N1 n_o(n - N0(2));
        while (count_down(n_o)) {
            Assert(source(f_o) == n_o);
            f_o = successor(f_o);
        }
        Assert(source(f1) == -1 && source(predecessor(l1)) == -1);
    }

    // test reverse_swap_step
    {
        if (verbose) print("        reverse_swap_step\n");
        I0 l_0 = l0;
        I1 f_1 = f1;
        sink(predecessor(l_0)) = 137;
        sink(f_1) = -99;
        reverse_swap_step(l_0, f_1);
        Assert(l_0 == predecessor(l0) && f_1 == successor(f1));
        Assert(source(predecessor(l0)) == -99 && source(f1) == 137);
    }

    // test reverse_swap_ranges
    {
        if (verbose) print("        reverse_swap_ranges\n");
        iota(n, f0);
        fill_n(f1, n, T(-1));
        I1 m1 = reverse_swap_ranges(f0, l0, f1);
        Assert(m1 == f1 + N1(n));
        Assert(equal_iota_reverse(f1, m1));
        Assert(all(f0, l0, equal_to_x<T>(-1)));
    }

    // test reverse_swap_ranges_bounded
    {
        if (verbose) print("        reverse_swap_ranges_bounded\n");
        I0 m0 = f0 + n_over_2;
        iota(n_over_2, f0);
        fill(f1, l1, T(-1));
        pair<I0, I1> p01 = reverse_swap_ranges_bounded(f0, m0, f1, l1);
        Assert(p01.m0 == f0);
        Assert(p01.m1 == f1 + N1(n_over_2));
        Assert(equal_iota_reverse(f1, p01.m1));
        Assert(all(f0, m0, equal_to_x<T>(-1)));
    }

    // test reverse_swap_ranges_n
    {
        if (verbose) print("        reverse_swap_ranges_n\n");
        iota(n, f0);
        fill_n(f1, n, T(-1));
        pair<I0, I1> p01 = reverse_swap_ranges_n(l0, f1, n);
        Assert(p01.m0 == f0);
        Assert(p01.m1 == f1 + N1(n));
        Assert(equal_iota_reverse(f1, p01.m1));
        Assert(all(f0, l0, equal_to_x<T>(-1)));
    }
}

template<typename T>
    requires(Regular(T))
void test_ch_9()
{
    print("  Chapter 9\n");

    print("    copy/split/combine/swap\n");

    const int k = 50;
    array_k<k, T> ca;
    array<T> da(k, k, T());
    slist<T> l;
    print("      ***** replace list with slist and list ?????\n");
    int n = k;
    extend_sequence_n(l, n, T(-1));

    Assert(size(ca) == k && size(da) == k && size(l) == k);

    print("      forward"); print_eol();
    print("        ***** to do: split into iterator and forward iterator\n");
    print("        ***** to do: split into readable/writable/mutable ?????\n");
    algorithms_copy_forward(begin(ca), end(ca), begin(da), end(da));
    algorithms_copy_forward(begin(ca), end(ca), begin(l), end(l));
    algorithms_copy_forward(begin(da), end(da), begin(ca), end(ca));
    algorithms_copy_forward(begin(da), end(da), begin(l), end(l));
    algorithms_copy_forward(begin(l), end(l), begin(ca), end(ca));
    algorithms_copy_forward(begin(l), end(l), begin(da), end(da));
    print("        ***** to do: various iterator types for split/combine/partition/merge\n");
    print("        ***** to do: copy_bounded/copy_n backward overlapped\n");

    print("      backward"); print_eol();
    algorithms_copy_backward(begin(ca), end(ca), begin(da), end(da));
    algorithms_copy_backward(begin(da), end(da), begin(ca), end(ca));
    print("        ***** to do: copy_backward forward overlapped\n");

    print("      reverse\n");
    print("        ***** to do: split into finer iterator concept combinations\n");
    print("        ***** to do: split into readable/writable/mutable ?????\n");
    algorithms_copy_reverse(begin(ca), end(ca), begin(da), end(da));
    algorithms_copy_reverse(begin(da), end(da), begin(ca), end(ca));
}


// Chapter 10. Rearrangements


template<typename I>
    requires(RandomAccessIterator(I))
struct successor_cyclic
{
    I f;
    I l;
    successor_cyclic(I f, I l) : f(f), l(l) { }
    I operator()(I i)
    {
        i = successor(i);
        if (i == l) i = f;
        return i;
    }
};

void algorithm_cycle_to()
{
    typedef int N;
    const int k = 17;
    array_k<k, N> a;
    typedef iterator_type< array_k<k, N> >::type I;
    I f = begin(a);
    I l = end(a);
    iota(k, f);
    cycle_to(f, successor_cyclic<I>(f, l));
    Assert(source(f) == predecessor(k));
    Assert(equal_iota(successor(f), l));
}

template<typename T, typename N>
    requires(Regular(T) && Integer(N))
void type_temporary_buffer(N n)
{
    {
        temporary_buffer<T> b(n);
        DistanceType(pointer(T)) m = size(b);
        Assert(0 < m && m <= n);
        if (verbose) {
            print("size(temporary_buffer<T>(");
            print(n);
            print(") = ");
            print(m);
            print(" where sizeof(T) = ");
            print(sizeof(T));
            print_eol();
        }
    }
}

void algorithms_reverse()
{
    typedef int T;
    const int k = 50;
    array_k<k, int> ca;
//    typedef DistanceType(IteratorType(array<T>)) N;
    typedef ptrdiff_t N;
    array<int> da = array<int>(N(k), N(k), T(0)); 
    slist<int> l;
    extend_sequence_n(l, k, T(-1));

    iota(k, begin(ca));

    iota(k, begin(ca));
    reverse_n_indexed(begin(ca), size(ca));
    equal_iota_reverse(begin(ca), end(ca));

    iota(k, begin(ca));
    reverse_bidirectional(begin(ca), end(ca));
    equal_iota_reverse(begin(ca), end(ca));

    iota(k, begin(ca));
    reverse_n_bidirectional(begin(ca), end(ca), size(ca));
    equal_iota_reverse(begin(ca), end(ca));

    iota(k, begin(l));
    reverse_n_with_buffer(begin(l), k, begin(ca));
    equal_iota_reverse(begin(l), end(l));

    iota(k, begin(l));
    reverse_n_forward(begin(l), k);
    equal_iota_reverse(begin(l), end(l));

    iota(k, begin(l));
    reverse_n_adaptive(begin(l), k, begin(ca), half_nonnegative(k));
    equal_iota_reverse(begin(l), end(l));

    iota(k, begin(l));
    reverse_n_adaptive(begin(l), k, begin(ca), half_nonnegative(k));
    equal_iota_reverse(begin(l), end(l));

    iota(k, begin(da));
    reverse_indexed(begin(da), end(da));
    equal_iota_reverse(begin(da), end(da));

    iota(k, begin(l));
    reverse_n_with_temporary_buffer(begin(l), k);
    equal_iota_reverse(begin(l), end(l));
}

typedef pointer(int) int_pointer;

template<typename C>
    requires(IteratorConcept(C))
void algorithms_rotate_Concept(int_pointer a, int n)
{
    Assert(n != 0);
    fill_n(a, n, int(7));
    int_pointer f = a;
    int_pointer l = f + n;
    iota(n, f);
    if (verbose) {
        print("      Initial a:        "); print_range(a, a+n); print_eol();
    }
    int_pointer c = successor(f);
    while (c != l) {
        Assert(f != c && c != l); // guard required since we're invoking "inner" versions
        rotate_nontrivial(f, c, l, C());
        c = successor(c);
    }
    if (verbose) {
        print("      After rotating a: "); print_range(a, a+n); print_eol();
    }
    if (even(n)) for (int i = 0; i < n; ++i) Assert(source(f + i) == (i + n / 2) % n);
    else         for (int i = 0; i < n; ++i) Assert(source(f + i) == i);
}

void algorithm_rotate_forward_annotated(int_pointer a, int n)
{
    Assert(n != 0);
    fill_n(a, n, int(7));
    int_pointer f = a;
    int_pointer l = f + n;
    iota(n, f);
    if (verbose) {
        print("      Initial a:        "); print_range(a, a+n); print_eol();
    }
    int_pointer c = successor(f);
    while (c != l) {
        Assert(f != c && c != l); // guard required since we're invoking "inner" versions
        rotate_forward_annotated(f, c, l);
        c = successor(c);
    }
    if (verbose) {
        print("      After rotating a: "); print_range(a, a+n); print_eol();
    }
    if (even(n)) for (int i = 0; i < n; ++i) Assert(source(f + i) == (i + n / 2) % n);
    else         for (int i = 0; i < n; ++i) Assert(source(f + i) == i);
}

template<typename I, typename B>
    requires(ForwardIterator(I) && ForwardIterator(B))
void algorithms_rotate_Concept_with_buffer(I f, DistanceType(I) n, B f_b,
                                           I (*algo)(I, I, I, B))
{
    Assert(n != 0);
    fill_n(f, n, int(7));
    I l = f + n;
    iota(n, f);
    if (verbose) {
        print("      Initial range:        "); print_range(f, l); print_eol();
    }
    int_pointer c = successor(f);
    while (c != l) {
        Assert(f != c && c != l); // guard required since we're invoking "inner" versions
        algo(f, c, l, f_b);
        c = successor(c);
    }
    if (verbose) {
        print("      After rotating range: "); print_range(f, l); print_eol();
    }
    if (even(n))
        for (int i = 0; i < n; ++i)
            Assert(source(f + i) == (i + half_nonnegative(n)) % n);
    else
        for (int i = 0; i < n; ++i)
            Assert(source(f + i) == i);
}

template<typename N>
    requires(Integer(N))
void algorithm_rotate_partial(N n)
{
    Assert(n > N(1));
    array<N> a(twice(n), twice(n), N(-1));
    typedef IteratorType(array<N>) I;
    I f = begin(a) + n / N(4);
    I l = f + n;
    I m = f + 1;
    while (m != l) {
        iota(n, f);
        I m_prime = rotate_partial_nontrivial(f, m, l);
        Assert(source(predecessor(f)) == N(-1) && source(l) == N(-1));
        Assert(m_prime + (m - f) == l);
        Assert(equal_iota(f, m_prime, m - f));
        DistanceType(I) k = (l - f) % (m - f);
        rotate(m_prime, l - k, l);
        Assert(equal_iota(m_prime, l));
        m = successor(m);
    }
}

void algorithms_rotate()
{
    print("    rotate\n");

    // Directly or indirectly tests these algorithms:
    //   cycle_from
    //   k_rotate_from_permutation_random_access
    //   k_rotate_from_permutation_indexed
    //   rotate_cycles
    //   rotate_indexed_nontrivial
    //   rotate_random_access_nontrivial
    //   rotate_bidirectional_nontrivial
    //   rotate_forward_annotated
    //   rotate_forward_step
    //   rotate_forward_nontrivial
    //   rotate_with_buffer_nontrivial
    //   rotate_with_buffer_backward_nontrivial
    typedef pointer(int) I;
    int a[8];
    int b[8];
    for (int n = 6; n < 8; ++n) {
        algorithm_rotate_forward_annotated(a, n);
        algorithms_rotate_Concept<forward_iterator_tag>(a, n);
        algorithms_rotate_Concept<bidirectional_iterator_tag>(a, n);
        algorithms_rotate_Concept<indexed_iterator_tag>(a, n);
        algorithms_rotate_Concept<random_access_iterator_tag>(a, n);
        algorithms_rotate_Concept_with_buffer(
            a, n, b, rotate_with_buffer_nontrivial<I,I>);
        algorithms_rotate_Concept_with_buffer(
            a, n, b, rotate_with_buffer_backward_nontrivial<I,I>);
    }
    int n = 41;
    while (n < 50) {
      algorithm_rotate_partial(n);
      n = n + 2;
    }
}

void test_ch_10()
{
    print("  Chapter 10\n");
    algorithm_cycle_to();
    type_temporary_buffer< char >(1000);
    type_temporary_buffer< char >(100000);
    type_temporary_buffer< array_k<10,char> >(1000);
    type_temporary_buffer< array_k<10,char> >(100000);
    algorithms_reverse();
    algorithms_rotate();
}


// Chapter 11. Partition and merging


void algorithms_reduce_balanced()
{
    // tests counter_machine, add_to_counter, transpose_operation, reduce_nonzeroes
    typedef int Z; // Integer(Z)
    Z a[] = {0, 1, 2, 3, 4, 5};
    slist<Z> l(counted_range<Z*>(a, sizeof(a)/sizeof(Z)));

    Assert(reduce_balanced(0, 0, plus<Z>(), identity<Z>(), Z(0)) == Z(0));
    Assert(reduce_balanced(0, 50, plus<Z>(), identity<Z>(), Z(0)) == Z(49*50/2));
    Assert(reduce_balanced(0, 1, plus<Z>(), identity<Z>(), Z(0)) == Z(0));

    Assert(reduce_balanced(begin(l), begin(l), plus<Z>(), Z(0)) == Z(0));
    Assert(reduce_balanced(begin(l), end(l), plus<Z>(), Z(0)) == Z(15));
    Assert(reduce_balanced(begin(l), successor(begin(l)), plus<Z>(), Z(0)) == Z(0));
}

bool even_int(int x) { return even<int>(x); }
bool odd_int(int x) { return odd<int>(x); }
typedef bool (*int_pred_type)(int);

struct partition_algorithm_tester
{
    typedef pointer(int) I;
    typedef distance_type<I>::type N;
    const pointer(char) name;
    array_k<6, int> a;
    I f;
    I l;
    N n;
    bool (*p)(int);
    slist<int> b;
    I m_potential;
    partition_algorithm_tester(const pointer(char) name) :
        name(name),
        a(),
        f(begin(a)),
        l(end(a)),
        n(l - f),
        p(even_int),
        b(a)
    {
        Assert(size(b) == n);
        iota(int(n), f);
        m_potential = potential_partition_point(f, l, even<int>);
        if (verbose) {
            print("      Before ");
            print(name);
            print(" partition with even: ");
            print_range(f, l);
            print_eol();
        }
    }
    void validate(I m) {
        if (verbose) {
            print("       After ");
            print(name);
            print(" partition with even: ");
            print_range(f, l);
            print_eol();
        }
        Assert(m_potential == m);
        Assert(partitioned(f, l, even<int>));
        Assert(partitioned_at_point(f, m, l, even<int>));
        Assert(m == partition_point(f, l, even<int>));
    }
    void validate_false(I m) {
        if (verbose) {
            print("       After ");
            print(name);
            print(" partition with even: ");
            print_range(f, l);
            print_eol();
        }
        Assert(m_potential == m);
        Assert(none(f, m, p));
    }
};

void algorithms_partition()
{
    {
        int a[] = {0, 2, 4, 1, 3, 5};
        pointer(int) f = a;
        pointer(int) l = a + sizeof(a) / sizeof(int);
        // exercise
        pointer(int) m = potential_partition_point(f, l, odd<int>);
        // exercise
        Assert(partitioned_at_point(f, m, l, odd<int>));
    }

    { // book
        partition_algorithm_tester t("semistable");
        t.validate(partition_semistable(t.f, t.l, t.p));
    }
    { // exercise
        partition_algorithm_tester t("remove_if");
        t.validate_false(remove_if(t.f, t.l, t.p));
    }
    { // book
        partition_algorithm_tester t("bidirectional");
        t.validate(partition_bidirectional(t.f, t.l, t.p));
    }
    { // could have been exercise
        partition_algorithm_tester t("indexed");
        t.validate(partition_indexed(t.f, t.l, t.p));
    }
    { // exercise
        partition_algorithm_tester t("forward");
        t.validate(partition_forward(t.f, t.l, t.p));
    }
    { // exercise
        partition_algorithm_tester t("single_cycle");
        t.validate(partition_single_cycle(t.f, t.l, t.p));
    }
    { // exercise
        partition_algorithm_tester t("sentinel");
        t.validate(partition_sentinel(t.f, t.l, t.p));
    }

    // ***** to do: exercise - single_cycle_sentinel

    { // book
        partition_algorithm_tester t("stable_with_buffer");
        t.validate(partition_stable_with_buffer(t.f, t.l, begin(t.b), t.p));
    }
    { // book
        // uses partition_stable_singleton, partition_stable_combine
        partition_algorithm_tester t("stable_n_nonempty");
        typedef partition_algorithm_tester::I I;
        pair<I, I> p = partition_stable_n_nonempty(t.f, t.l - t.f, t.p);
        Assert(p.m1 == t.l);
        t.validate(p.m0);
    }
    { // book
        partition_algorithm_tester t("stable_n");
        typedef partition_algorithm_tester::I I;
        pair<I, I> p;
        p = partition_stable_n(t.f, 0, t.p);
        Assert(p.m0 == t.f && p.m1 == t.f);
        p = partition_stable_n(t.f, t.n, t.p);
        Assert(p.m1 == t.l);
        t.validate(p.m0);
    }
    { // additional
        partition_algorithm_tester t("advanced stable_n");
        typedef partition_algorithm_tester::I I;
        pair<I, I> p;
        p = advanced_partition_stable_n(t.f, 0, t.p);
        Assert(p.m0 == t.f && p.m1 == t.f);
        p = advanced_partition_stable_n(t.f, t.n, t.p);
        Assert(p.m1 == t.l);
        t.validate(p.m0);
    }
    { // for completeness
        partition_algorithm_tester t("stable");
        t.validate(partition_stable(t.f, t.l, t.p));
    }
    { // book
        partition_algorithm_tester t("stable iterative");
        t.validate(partition_stable_iterative(t.f, t.l, t.p));
    }
}

char force_lower(char a)
{
    if ('A' <= a && a <= 'Z') return 'a' + (a - 'A');
    return a;
}

struct less_ignoring_case
{
    bool operator()(char a, char b) const
    {
        return force_lower(a) < force_lower(b);
    }
};

template<>
struct input_type<less_ignoring_case, 0>
{
    typedef char type;
};

struct equal_ignoring_case
{
    bool operator()(char a, char b) const
    {
        return force_lower(a) == force_lower(b);
    }
};

template<>
struct input_type<equal_ignoring_case, 0>
{
    typedef char type;
};

int size_unguarded(const pointer(char) a)
{
    int n(0);
    while (source(a) != char(0)) {
        n = successor(n);
        a = successor(a);
    }
    return n;
}

const pointer(char) begin(const pointer(char) a) { return a; }

const pointer(char) end(const pointer(char) a) { return begin(a) + size_unguarded(a); }

template<typename M, typename R, typename E>
    requires(WrappedMerger(M) &&
        Relation(R) && Domain(R) == char &&
        Relation(E) && Domain(E) == char)
struct merge_case
{
    M merger;
    R r;
    E e;
    bool commutative;
    merge_case(M merger, R r, E e, bool commutative) :
        merger(merger), r(r), e(e), commutative(commutative)
    {
        // Precondition: $\property{weak\_ordering}(r)
        // Precondition: $\property{equivalence}(e)
    }
    void subcase(
        const pointer(char) a, int n_a,
        const pointer(char) b, int n_b,
        const pointer(char) c, int n_c)
    {
        array<char> tmp(n_c, n_c, char(0));
        pointer(char) f_ab = begin(tmp);
        pointer(char) m_ab = copy_n(begin(a), n_a, f_ab).m1;
        pointer(char) l_ab = copy_n(begin(b), n_b, m_ab).m1;
        Assert(l_ab == end(tmp));

        merger(f_ab, n_a, m_ab, n_b, r);

        Assert(lexicographical_equivalent(f_ab, l_ab, begin(c), end(c), e));
        if (verbose) {
            print("      ");
            print(a); print(" merge "); print(b);
            print(" equiv "); print(c);
            print_eol();
        }
    }
    void operator()(const pointer(char) a, const pointer(char) b, const pointer(char) c)
    {
        int n_a = size_unguarded(a) ;
        int n_b = size_unguarded(b);
        int n_c = size_unguarded(c);
        Assert(n_a + n_b == n_c);
        subcase(a, n_a, b, n_b, c, n_c);
        if (commutative) subcase(b, n_b, a, n_a, c, n_c);
    }
};

template<typename M>
    requires(Merger(M))
void merge_cases(M m)
{
    merge_case<M, less_ignoring_case, equal_ignoring_case>
        c(m, less_ignoring_case(), equal_ignoring_case(), true);
    merge_case<M, less_ignoring_case, equal<char> >
        n(m, less_ignoring_case(), equal<char>(), false);

    n("", "", "");
    c("a", "", "a");
    
    n("a", "A", "aA");
    
    n("a", "a", "aa");
    c("a", "b", "ab");
    c("a", "bc", "abc");
    c("b", "ac", "abc");
    c("c", "ab", "abc");

    n("ab", "AB", "aAbB");

    c("ab", "cd", "abcd");
    c("ac", "bd", "abcd");
    c("ad", "bc", "abcd");

    n("abcdefghijklmnopqrstuvwxyz", "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
      "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ");

    // And so on.
}
template<typename I, typename R>
    requires(Mutable(I) && ForwardIterator(I) &&
        Relation(R) && ValueType(I) == Domain(R))
I wrapped_merge_n_with_buffer(I f0, DistanceType(I) n0,
                              I f1, DistanceType(I) n1, R r)
{
    array<ValueType(I)> b(n0, n0, ValueType(I)());
    return merge_n_with_buffer(f0, n0, f1, n1, begin(b), r);
}

template<typename I, typename R>
    requires(Mutable(I) && ForwardIterator(I) &&
        Relation(R) && ValueType(I) == Domain(R))
I wrapped_merge_n_adaptive(I f0, DistanceType(I) n0,
                           I f1, DistanceType(I) n1, R r)
{
    const DistanceType(I) n = half_nonnegative(n0);
    array<ValueType(I)>  b(n, n, ValueType(I)());
    return merge_n_adaptive(f0, n0, f1, n1, begin(b), size(b), r);
}

void algorithms_merge()
{
    typedef pointer(char) I;

    merge_cases(wrapped_merge_n_with_buffer<I, less_ignoring_case>);
    merge_cases(wrapped_merge_n_adaptive<I, less_ignoring_case>);
}

template <typename S>
    requires(Sequence(S) && Integer(ValueType(S)))
void algorithms_sort(S& s)
{
    typedef IteratorType(S) I;
    typedef DistanceType(I) N;
    typedef ValueType(I) T;

    I f = begin(s);
    I l = end(s);
    N n = size(s);
    Assert(n == l - f);
    I m;

    less<int> ls;
    converse< less<int> > greater(ls);
    {
        iota(n, f);
            int n_b = half_nonnegative(n);
            array<int> buffer(n_b, n_b, 0);
            m = sort_n_with_buffer(f, n, begin(buffer), greater);
        Assert(m == l && equal_iota_reverse(f, l));
    }
    {
        iota(n, f);
            array<int> buffer(50, 50, 0);
            pointer(int) f_b = begin(buffer);
            int n_b = size(buffer);
            m = sort_n_adaptive(f, n, f_b, n_b, greater);
        Assert(m == l && equal_iota_reverse(f, l));
    }
    {
        iota(n, f);
            m = sort_n(f, n, greater);
        Assert(m == l && equal_iota_reverse(f, l));
    }
    {
        iota(n, f);
            m = advanced_sort_n(f, n, greater);
        Assert(m == l && equal_iota_reverse(f, l));
    }
}

void test_ch_11()
{
    print("  Chapter 11\n");

    print("    reduce_balanced\n");
    algorithms_reduce_balanced();

    print("    partition\n");
    algorithms_partition();

    print("    merge\n");
    algorithms_merge();

    const int n = 500;
    typedef int T;
    array_k<n, T> ca;
    array<T> a(n, n, T());
    slist<T> sl(a);
    list<T> l(a);

    print("    sort\n");
    algorithms_sort(ca);
    algorithms_sort(a);
    algorithms_sort(sl);
    algorithms_sort(l);
}


// Chapter 12. Composite objects


template<typename T>
    requires(Regular(T))
void nothing(const T&)
{
}

template<typename W>
    requires(Linearizable(W))
void concept_Linearizable(W& w)
{
    // Regular
    concept_Regular(w);

    // Type functions
    typedef IteratorType(W) I;
    typedef ValueType(W) T;
    typedef SizeType(W) N;

    // Procedures and operators
    I f = begin(w);
    I l = end(w);
    N n = size(w);
    bool e = empty(w);
    Assert(n == (l - f));
    Assert(e == (n == 0));
    for_each(f, l, nothing<T>);

    N i(0);
    while (f != l) {
        Assert(addressof(w[i]) == addressof(source(f)));
        i = successor(i);
        f = successor(f);
    }
}

template<typename S>
    requires(Sequence(S))
void concept_Sequence(S& s0, S& s1, ValueType(S)& x)
{
    // Precondition: s0 < s1 /\ !empty(s1) /\ x != s1[0]
    Assert(begin(s1) != end(s1));
    Assert(x != s1[0]);

    concept_Linearizable(s1);
    concept_TotallyOrdered(s0, s1);

    // (all s in S)(all i in [begin(s), end(s)) deref(i) is a part of s
    S s11(s1);
    Assert(s11 == s1);
    s11[0] = x; // change the copy
    Assert(s11 != s1);

    // Equality and total ordering are lexicographical
}

template<typename T0, typename T1>
    requires(ConstantSizeSequence(T0) && ConstantSizeSequence(T1) &&
        ValueType(T0) == ValueType(T1))
void concept_ConstantSizeSequence(T0& a0, T1& a1, ValueType(T1)& x)
{
    // Precondition: a0 < a1 /\ x != a1[0]

    if (verbose) {
        print("      "); print(a1); print_eol();
    }
    concept_Sequence(a0, a1, x);

    // size is fixed, and agrees with Size type attribute
    Assert(size(a0) == Size(T0));
    Assert(size(a1) == Size(T1));

    // size is positive, at least for array_k
    Assert(!empty(a0));
    Assert(!empty(a1));

    // Iterator is pointer(T)
    Assert(begin(a0) == addressof(a0[0]));

    // Equality behavior
    Assert(a0 != a1);

    // Total ordering behavior
    // ***** to do: move this to concept_Sequence ?????
    Assert(a0 < a1);
    Assert(!(a1 < a0));
}

void type_array_k()
{
    {
        array_k<10, int> a0;
        array_k<10, int> a1;
        a0[0] = -39; a1[0] = 17; // establish a0 < a1
        int x(99);
        concept_ConstantSizeSequence(a0, a1, x);
    }
    {
        typedef pair<int, char> P;
        array_k<3, P> a0;
        array_k<3, P> a1;
        a0[0] = P(0, 'a'); a1[0] = P(1, 'Z'); // establish a0 < a1
        P x(2, '0');
        concept_ConstantSizeSequence(a0, a1, x);
    }
    {
        typedef array<int> DA;
        DA da0;
        DA da1(3, 3, 0);
        iota(3, begin(da1));
        typedef array_k< 4, DA > A_DA;
        A_DA a0;
        A_DA a1;
        if (verbose) {
            print("      da0:"); print(da0); print_eol();
            print("      da1:"); print(da1); print_eol();
        }
        a0[0] = da0; a1[0] = da1; // establish a0 < a1
        if (verbose) {
            print("      a0:"); print(a0); print_eol();
            print("      a1:"); print(a1); print_eol();
        }
        Assert(a0 != a1);
        concept_ConstantSizeSequence(a0, a1, da0);

        {
            typedef slist<int> SL;
            SL sl0;
            SL sl1;
            extend_sequence_n(sl0, 3, 3);
            extend_sequence_n(sl1, 4, 4);
            typedef array_k< 5, SL > A_SL;
            A_SL a0;
            A_SL a1;
            a0[0] = sl0; a1[0] = sl1; // establish a0 < a1
            concept_ConstantSizeSequence(a0, a1, sl0);
        }

        typedef slist< DA > SL;
        SL sl0;
        SL sl1;
        extend_sequence_n(sl0, 3, da0);
        extend_sequence_n(sl1, 4, da1);
        typedef array_k< 3, SL > A_SL;
        A_SL a_sl0;
        A_SL a_sl1;
        a_sl0[0] = sl0; a_sl1[0] = sl1; // establish a0 < a1
        concept_ConstantSizeSequence(a_sl0, a_sl1, sl0);
    }
}

template<typename I>
    requires(Readable(I) && Iterator(I))
void type_bounded_range(I f, I l)
{
    typedef bounded_range<I> T;
    T r(f, l);
    concept_Linearizable(r); // but not totally ordered
}

template<typename I>
    requires(Readable(I) && Iterator(I))
void type_counted_range(I f, DistanceType(I) n)
{
    typedef counted_range<I> T;
    T r(f, n);
    concept_Linearizable(r); // but not totally ordered
}

template<typename P>
    requires(Position(P))
void concept_Position(P p, BaseType(P)& s, IteratorType(P) i)
{
    typedef BaseType(P) B;
    typedef IteratorType(P) I;
    typedef ValueType(P) T;
    typedef SizeType(P) N;

    // Not regular: lacks default constructor, copy constructor, assignment
    B& b = base(p);
    Assert(addressof(b) == addressof(s));
    I cur = current(p);
    Assert(cur - begin(s) >= N(0) && end(s) - cur >= N(0));
        // i.e., cur \in [begin(s), end(s))
    Assert(begin(p) == begin(s));
    Assert(end(p) == end(s));
}

template<typename S>
    requires(DynamicSequence(S))
void test_Position(S& s, IteratorType(S) i)
{
    before<S> bef(s, i);
    concept_Position(bef, s, i);
    Assert(current(bef) == i);

    after<S> aft(s, i);
    concept_Position(aft, s, i);
    Assert(current(bef) == i);

    front<S> fr(s);
    concept_Position(fr, s, i);
    Assert(current(fr) == begin(s));

    back<S> bk(s);
    concept_Position(bk, s, i);
    Assert(current(bk) == end(s));

    at<S> a(s, i);
    concept_Position(a, s, i);
    Assert(current(bef) == i);
}

template<typename S>
    requires(DynamicSequence(S))
void concept_DynamicSequence(S& s0, S& s1, ValueType(S)& x)
{
    // Precondition: s0 < s1 /\ x != s1[0]
    typedef IteratorType(S) I;

    concept_Sequence(s0, s1, x);

    // construct from linearizable
    bounded_range<I> br(begin(s1), end(s1));
    S s11(br);
    Assert(s11 == s1);

    // insert
    // insert_range
    // erase
    // erase_range
}

template<typename L>
    requires(List(L) && ValueType(L) == int)
void type_list()
{
    const SizeType(L) k0 = 10;
    {
        const SizeType(L) k1 = 15;
        L l0;
        L l1;
        extend_sequence_n(l0, k0, 0);
        extend_sequence_n(l1, k1, 1);
        int i(2);
        concept_DynamicSequence(l0, l1, i);
    }

    L l0;
    L l1;
    extend_sequence_n(l0, k0, 0);

    // algorithms: reverse, partition, merge, sort
    iota(k0, begin(l0));
    reverse(l0);
    Assert(equal_iota_reverse(begin(l0), end(l0)));
    reverse(l0);
    Assert(equal_iota(begin(l0), end(l0)));
    Assert(size(l0) == k0);

    if (verbose) { print("      l0 before partition: "); print(l0); print_eol(); }
    partition(l0, l1, even<int>);
    if (verbose) { print("      l0 after: "); print(l0); print_eol(); }
    if (verbose) { print("      l1 after: "); print(l1); print_eol(); }
    Assert(all(begin(l0), end(l0), odd<int>));
    Assert(all(begin(l1), end(l1), even<int>));

    L l2;
    L l3;
    partition(l2, l3, even<int>);
    Assert(empty(l2) && empty(l3));

    merge(l0, l1, less<int>());
    Assert(equal_iota(begin(l0), end(l0)) && size(l0) == k0 && empty(l1));

    reverse(l0);
    sort(l0, less<int>());
    Assert(equal_iota(begin(l0), end(l0)) && size(l0) == k0);

    print("    ***** to do: slist, list");
    print(" (including erase, erase_first, erase_after, set_link_backward\n");
}

template<typename S>
    requires(SingleExtentArray(S))
void type_single_extent_array(S& s0, S& s1, ValueType(S)& x)
{
    // Precondition: s0 < s1 /\ x != s1[0]
    concept_DynamicSequence(s0, s1, x);

    // construct from capacity
    // construct from size, capacity, and value
    // construct from counted_range

    // end_of_storage
    // capacity
    // full
    // reserve_basic/reserve
    array<int> a;
    typedef SizeType(array<int>) N;
    Assert(empty(a));
    Assert(full(a));
    Assert(capacity(a) == N(0));
    Assert(end(a) == end_of_storage(a));
    reserve(a, N(1));
    Assert(empty(a));
    Assert(!full(a));
    Assert(capacity(a) == N(1));
    Assert(end(a) + N(1) == end_of_storage(a));
    insert(back< array<int> >(a), 1);
    Assert(size(a) == N(1));
    Assert(end(a) == end_of_storage(a));
    Assert(full(a));
    erase(back< array<int> >(a));
    Assert(empty(a));
    Assert(full(a));
}

void type_array()
{
    {
        array<int> a0(10, 10, -39);
        array<int> a1(10, 10, 17); // establish a0 < a1
        int x(99);
        type_single_extent_array(a0, a1, x);
    }
    {
        typedef pair<int, char> P;
        array<P> a0(3, 3, P());
        array<P> a1(3, 3, P());
        a0[0] = P(0, 'a'); a1[0] = P(1, 'Z'); // establish a0 < a1
        P x(2, '0');
        type_single_extent_array(a0, a1, x);
    }
    {
        typedef array_k<4, int> CA;
        CA ca0;
        CA ca1;
        fill_n(begin(ca0), size(ca0), 0);
        iota(4, begin(ca1)); // establish ca0 < ca1
        typedef array<CA> A_CA;
        A_CA a0(3, 3, ca0);
        A_CA a1(3, 3, ca1); // establish a0 < a1
        if (verbose) {
            print("      a0:"); print(a0); print_eol();
            print("      a1:"); print(a1); print_eol();
        }
        if (verbose) {
            print("      a0:"); print(a0); print_eol();
            print("      a1:"); print(a1); print_eol();
        }
        Assert(a0 != a1);
        type_single_extent_array(a0, a1, ca0);

        {
            typedef slist<int> SL;
            SL sl0;
            SL sl1;
            extend_sequence_n(sl0, 3, 3);
            extend_sequence_n(sl1, 4, 4);
            typedef array< SL > A_SL;
            A_SL a0(2, 2, sl0);
            A_SL a1(2, 2, sl1); // establish a0 < a1
            type_single_extent_array(a0, a1, sl0);
        }

        typedef slist< CA > SL;
        SL sl0;
        SL sl1;
        extend_sequence_n(sl0, 3, ca0);
        extend_sequence_n(sl1, 4, ca1);
        typedef array< SL > A_SL;
        A_SL a_sl0(4, 4, sl0);
        A_SL a_sl1(4, 4, sl1); // establish a0 < a1
        type_single_extent_array(a_sl0, a_sl1, sl0);
    }
}

template<typename T, typename T0>
    requires(T == array<T0>)
void algorithm_underlying_ref_array(T0& x)
{
    typedef UnderlyingType(T) U;
    T t(2, 2, x);
    U u = underlying_ref(t);
    Assert(u.p == t.p);
}

template<typename T, typename T0>
    requires(T == array<T0>)
void type_underlying_iterator_array(T0& x)
{
    typedef IteratorType(T) I;
    typedef underlying_iterator<I> UI;
    T t(2, 2, x);
    I f(begin(t));
    I l(end(t));
    UI uf(f);
    UI ul(l);
    Assert(uf != ul);
    Assert(predecessor(successor(uf)) == uf);
    Assert(ul - uf == l - f);
    Assert((uf + 1) - 1 == uf);
    Assert(uf < ul);
    Assert(addressof(sink(uf)) == addressof(source(uf)) &&
        addressof(sink(uf)) == addressof(deref(uf)));
    Assert(original(uf) == f);

    while (uf != ul) {
        Assert(source(uf).p == source(f).p);
        f = successor(f);
        uf = successor(uf);
    }
    Assert(f == l);
}

template<typename T, typename T0>
    requires(T == array<T0>)
void algorithm_original_ref_array(T0& x)
{
    typedef UnderlyingType(T) U;
    T t0(2, 2, x);
    T t1(3, 3, x);
    Assert(t0 < t1);
    U u0 = underlying_ref(t0);
    U u1 = underlying_ref(t1);
    Assert(original_ref<T>(u0) < original_ref<T>(u1));
}

template<typename T, typename P>
    requires(Predicate(P) && T == Domain(P))
void algorithm_underlying_predicate(T& x0, T& x1, P p)
{
    // Precondition: !p(x0) && p(x1)
    Assert(!p(x0) && p(x1));

    underlying_predicate<P> up(p);
    Assert(!up(underlying_ref(x0)) && up(underlying_ref(x1)));
}

template<typename T, typename R>
    requires(Relation(R) && T == Domain(R))
void algorithm_underlying_relation(T& x0, T& x1, R r)
{
    // Precondition: r(x0, x1) && !r(x1, x0)
    typedef UnderlyingType(T) U;
    Assert(r(x0, x1) && !r(x1, x0));

    underlying_relation<R> ur(r);
    U& ux0(underlying_ref(x0));
    U& ux1(underlying_ref(x1));
    Assert(ur(ux0, ux1) && !ur(ux1, ux0));
}

template<typename T>
    requires(Linearizable(T))
bool nonempty(const T& x)
{
    return !empty(x);
}

void test_ch_12()
{
    print("  Chapter 12\n");

    print("    array_k\n");
    type_array_k();

    print("    bounded_range\n");
    array_k<3, int> ca;
    type_bounded_range(begin(ca), end(ca));
    array< array_k<3, int> > da(5, 5, ca);
    type_bounded_range(begin(da), end(da));
    slist< array< array_k<3, int> > > sl;
    extend_sequence_n(sl, 7, da);
    type_bounded_range(begin(sl), end(sl));

    print("    counted_range\n");
    type_counted_range(begin(ca), size(ca));
    type_counted_range(begin(da), size(da));
    type_counted_range(begin(sl), size(sl));

    {
        print("    before, after, front, back, at\n");
        const int N = 10;
        array<int> da(N, N, 0);
        iota(N, begin(da));
        slist<int> sl(da);
        list<int> l(da);
        test_Position(da, successor(begin(da)));
        test_Position(sl, successor(begin(sl)));
        test_Position(l, successor(begin(l)));
    }

    print("    slist\n");
    type_list< slist<int> >();

    print("    list\n");
    type_list< list<int> >();

    print("    ***** to do: stree, tree\n");

    print("    array\n");
    type_array();

    print("    ***** to do: iterators/coordinates for slist, list, stree, tree, array\n");

    print("    underlying type\n");

    {
        int i = 1;
        int j = 2;
        swap_basic(i, j);
        Assert(i == 2 && j == 1);
        const int N = 10;
        array<int> a0(N, N, 0);
        array<int> a1(N, N, 1);
        pointer(int) p0 = begin(a0);
        pointer(int) p1 = begin(a1);
        swap(a0, a1);
        Assert(all(begin(a0), end(a0), equal_to_x<int>(1)));
        Assert(all(begin(a1), end(a1), zero<int>));
        Assert(p0 == begin(a1) && p1 == begin(a0)); // remote parts were swapped
    }

    int i(0);
    algorithm_underlying_ref_array< array<int>, int >(i);
    array<int> ai(1, 1, 1);
    algorithm_underlying_ref_array< array< array<int> > , array<int> >(ai);

    type_underlying_iterator_array< array< array<int> > >(ai);

    algorithm_original_ref_array< array< array<int> > , array<int> >(ai);

    array< array<int> > a_empty;
    array< array<int> > a_nonempty(1, 1, ai);
    algorithm_underlying_predicate(a_empty, a_nonempty, nonempty< array< array<int> > >);

    less< array< array<int> > > lt;
    algorithm_underlying_relation(a_empty, a_nonempty, lt);

    /*
        reverse_n_with_temporary_buffer using underlying_iterator
    */
}

void run_tests()
{
    // Call each procedure at least once.

    verify_conservation<int> vsl(slist_node_count);
    verify_conservation<int> vl(list_node_count);
    verify_conservation<int> vst(stree_node_count);
    verify_conservation<int> vt(tree_node_count);

    test_ch_1();
    test_ch_2();
    test_ch_3();
    test_ch_4();
    test_ch_5();
    test_ch_6();
    test_ch_7<int, char>();
    test_ch_8<int>();
    test_ch_9<int>();
    test_ch_10();
    test_ch_11();
    test_ch_12();
}

#endif // EOP_TESTS
