// measurements.h

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


// Measurements for algorithms from
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009


#ifndef EOP_MEASUREMENTS
#define EOP_MEASUREMENTS


#include "intrinsics.h"
#include "type_functions.h"
#include "eop.h"
#include "tests.h" // rational
#include "print.h"
#include "assertions.h"

#include <time.h> // measurements


struct measure_time
{
    typedef measure_time M;
    typedef long int N; // DistanceType(M)
    const int inverse_accuracy;
    const clock_t epsilon;
    const pointer(char) legend;
    const pointer(char) units;
    N n;
    clock_t t;
    measure_time(const pointer(char) legend) :
        inverse_accuracy(100),
        epsilon(CLOCKS_PER_SEC / clock_t(inverse_accuracy)),
        legend(legend),
        units("sec/10^6") { }
};

template<>
struct distance_type<measure_time>
{
    typedef long int type;
};

inline void start(measure_time& m, long int n)
{
    m.n = n; m.t = clock();
}

inline void stop(measure_time& m)
{
    m.t = clock() - m.t;
}

inline bool converged(const measure_time& m)
{
    return m.t >= m.epsilon;
}

inline double time_per_iter(const measure_time& m)
{
    return (double(m.t) / double(CLOCKS_PER_SEC))  * 1000000. / double(m.n);
}

template<typename M, typename F>
    requires(Measure(M) && Measurement(F))
M perform()
{
    typedef DistanceType(M) N;
    F f;
    M m(f.legend);
    N n(1);
    while (true) {
        N i(0);
        start(m, n);
        while (i < n) { // or use count_down
            f();
            i = successor(i);
        }
        stop(m);
        if (converged(m)) return m;
        n = twice(n);
    }
}

struct measure_clock
{
    const pointer(char) legend;
    clock_t t;
    measure_clock() : legend("clock()") { }
    inline void operator()() {
        t = clock();
    }
};

struct measure_gcd
{
    const pointer(char) legend;
    typedef rational<int> Q;
    Q t;
    measure_gcd() : legend("gcd<Q, Q>(Q(250, 1000), Q(750, 1000)") { }
    inline void operator()() {
        t = gcd<Q, Q>(Q(250, 1000), Q(750, 1000));
    }
};

struct measure_reverse_bidirectional
{
    const pointer(char) legend;
    typedef int T;
    int N;
    int REPETITIONS;
    array<T> a;
    pointer(T) f;
    pointer(T) l;
    measure_reverse_bidirectional() :
        legend("10 repetitions of reverse_bidirectional(f, f+10000000)"),
            N(10000000),
            REPETITIONS(100000000 / N),
            a(N, N, T(17)),
            f(begin(a)), l(end(a))
    { 
         Assert(size(a) == N && find_not(f, l, T(17)) == l);
    }
    inline void operator()() {
        for (int i = 0; i < REPETITIONS; ++i) reverse_bidirectional(f, l);
    }
};

// Adapted from SGI STL:
template <class T>
inline void __iter_swap(pointer(T) __a, pointer(T) __b) {
  T __tmp = *__a;
  *__a = *__b;
  *__b = __tmp;
}

template <class _RandomAccessIter>
inline
void __reverse(_RandomAccessIter __first, _RandomAccessIter __last,
               random_access_iterator_tag) {
  while (__first < __last)
    __iter_swap(__first++, --__last);
}

// From Visual Studio:
//template<class _RanIt> inline
//	void _Reverse(_RanIt _First, _RanIt _Last, random_access_iterator_tag)
//	{	// reverse elements in [_First, _Last), random-access iterators
////	_DEBUG_RANGE(_First, _Last);
//	for (; _First < _Last; ++_First)
//		std::iter_swap(_First, --_Last);
//	}

const pointer(char) tab = "\t";

template<typename T>
void print_labels()
{
    print("CLOCKS_PER_SEC = "); print(CLOCKS_PER_SEC); print_eol();
    print("sizeof(T) = "); print(sizeof(T)); print_eol();
    print("algorithm"); print(tab);
        print("seconds"); print(tab);
            print("N"); print(tab);
                print("repetitions"); print(tab);
                    print("bytes/sec"); print_eol();
}

template<typename T>
void print_result(const pointer(char) label, clock_t t0, clock_t t1, int N, int REPETITIONS)
{
    double seconds = (t1-t0) * 1.0 / CLOCKS_PER_SEC;
    print(label); print(tab);
        print(seconds); print(tab);
	    print(N); print(tab);
                print(REPETITIONS); print(tab);
                    print((sizeof(T)*N*REPETITIONS)/seconds); print_eol();
}

void measure_reverse_algorithms()
{
    typedef int T;
    print_labels<T>();

    for (int N = 10; N <= 100000000; N *= 10) {
        const int REPETITIONS = 100000000 / N;
        array<T> a(N, N, T(17));
        pointer(T) f = begin(a);
        pointer(T) l = end(a);
        Assert(size(a) == N && find_not(f, l, T(17)) == l);
	    reverse_bidirectional(f, l);
	    clock_t t0, t1;

        print_eol();

     //   t0 = clock();
     //   for (int i = 0; i < repetitions; ++i)
     //       reverse_n_forward(f, l-f);
	 //   t1 = clock();
     //   print_result<t>("rev_fwd: ", t0, t1, n, repetitions);

        t0 = clock();
        for (int i = 0; i < REPETITIONS; ++i)
            reverse_bidirectional(f, l);
	    t1 = clock();
        print_result<T>("rev_bi:  ", t0, t1, N, REPETITIONS);

        t0 = clock();
        for (int i = 0; i < REPETITIONS; ++i)
            reverse_n_bidirectional(f, l, l - f);
	    t1 = clock();
        print_result<T>("rev_n_bi:  ", t0, t1, N, REPETITIONS);

        t0 = clock();
        for (int i = 0; i < REPETITIONS; ++i)
            reverse_n_indexed(f, l - f);
	    t1 = clock();
        print_result<T>("rev_in:  ", t0, t1, N, REPETITIONS);

        t0 = clock();
        for (int i = 0; i < REPETITIONS; ++i)
            __reverse(f, l, random_access_iterator_tag());
	    t1 = clock();
        print_result<T>("rev_SGI: ", t0, t1, N, REPETITIONS);

//        t0 = clock();
//        for (int i = 0; i < REPETITIONS; ++i)
//            _Reverse(f, l, random_access_iterator_tag());
//	      t1 = clock();
//        print_result<T>("rev_VC:  ", t0, t1, N, REPETITIONS);

// #include <algorithm> // std::reverse
//         t0 = clock();
//         for (int i = 0; i < REPETITIONS; ++i)
//             std::reverse(f, l);
// 	    t1 = clock();
//         print_result<T>("rev_std: ", t0, t1, N, REPETITIONS);
    }
}

struct measure_sort_linked
{
    const pointer(char) legend;
    typedef int T;
    int N;
    int REPETITIONS;
    slist<T> a;
    iterator_type< slist<T> >::type f;
    iterator_type< slist<T> >::type l;
    measure_sort_linked() :
        legend("sort_linked(reverse(iota(100000)))"),
            N(100000),
            REPETITIONS(1)
    {
        after< slist<T> > pos(a, end(a));
        int i(0);
        while (i < N) {
            pos = insert(pos, i);
            i = successor(i);
        }
        // Assert(decreasing_range(f, l));
    }
    inline void operator()() {
        for (int i = 0; i < REPETITIONS; ++i)
            sort(a, less<int>());
    }
};

void measure_sort_n_adaptive_compares()
{
    for (int n = 64; n <= 32768; n *= 4) {
        typedef pointer(int) I;
//        typedef DistanceType(IteratorType(array<T>)) N;
        typedef ptrdiff_t N;
        array<int> a = array<int>(N(n), N(n), 0);
        iota(n, begin(a));
        reverse_bidirectional(begin(a), end(a));
        int c = 0;
        I f_buf(0);
        int n_buf(0);
        sort_n_adaptive(begin(a), size(a), f_buf, n_buf,
                        instrumented_less< less<int>, I >(less<int>(), &c));
        print("Required "); print(c);
            print(" compares for "); print(int(size(a)));
                print(" elements; ratio = "); print(double(c) / double(size(a)));
                    print_eol();
    }
}

struct measure_sort_n_adaptive
{
    const pointer(char) legend;
    typedef int T;
    int N;
    int REPETITIONS;
    array<T> a;
    pointer(T) f;
    pointer(T) l;
    array<T> b;
    measure_sort_n_adaptive() :
        legend("sort_n_adaptive(reverse(iota(100000)))"),
            N(100000),
            REPETITIONS(1),
            a(N, N, T(17)),
            f(begin(a)), l(end(a)),
            b(100000, 100000, T(0))
    { 
        iota(N, f);
        reverse_bidirectional(f, l);
        // Assert(decreasing_range(f, l));
    }
    inline void operator()() {
        for (int i = 0; i < REPETITIONS; ++i)
            sort_n_adaptive(f, N, begin(b), size(b), less<int>());
    }
};

template<typename M>
    requires(Measure(M))
void report(M m)
{
    print(m.legend); print(": ");
        print(time_per_iter(m)); print(" ");
            print(m.units); print(" ");
                print(m.n); print(" iterations\n");
}

void run_measurements()
{
    typedef measure_time M;
    print("time_measurement::inverse_accuracy: ");
        print(M("test").inverse_accuracy); print_eol();
    print("CLOCKS_PER_SEC: "); print(CLOCKS_PER_SEC); print_eol();
    report(perform<M, measure_sort_linked>());
    report(perform<M, measure_sort_n_adaptive>());
    measure_sort_n_adaptive_compares();
    report(perform<M, measure_clock>());
    report(perform<M, measure_gcd>());
    report(perform<M, measure_reverse_bidirectional>());
    measure_reverse_algorithms();
}

#endif // EOP_MEASUREMENTS
