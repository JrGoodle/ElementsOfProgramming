// eop.cpp

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


// Main program for interactive use, regression testing, and measurement
//   of algorithms from
// Elements of Programming
// by Alexander Stepanov and Paul McJones
// Addison-Wesley Professional, 2009


#include "eop.h" // array
#include "intrinsics.h" // pointer
#include "pointers.h"
#include "print.h"
#include "read.h"
#include "drivers.h" // push
#include "tests.h" // print, read
#include "measurements.h"

#include <cstddef> // ptrdiff_t


struct cmd
{
    const pointer(char) name;
    void (*action)();
    cmd() { }
    cmd(const pointer(char) name, void (*action)()) : name(name), action(action) { }
};

int main()
{
    array<cmd> c;

    // General

    push(c, cmd("toggle verbose", &toggle_verbose));
    push(c, cmd("tests", &run_tests));
    push(c, cmd("measurements", &run_measurements));

    // Drivers for running algorithms with arbitrary arguments

    // Chapter 1 - Foundations

    // ***** square

    // Chapter 2 - Transformations and their orbits
    push(c, cmd("additive_congruential_transformation", &run_additive_congruential_transformation));
    push(c, cmd("table_transformation", &run_table_transformation));
    push(c, cmd("srand_transformation", &run_srand_transformation));
    push(c, cmd("lcg_transformation", &run_lcg_transformation));
    push(c, cmd("any_lcg_transformation", &run_any_lcg_transformation));

    // Chapter 3 - Associative operations
    push(c, cmd("idempotent_power", run_idempotent_power));
    push(c, cmd("fibonacci", run_fibonacci));
    push(c, cmd("egyptian_multiplication", &run_egyptian_multiplication));

    // Chapter 4 - Linear orderings

    // Chapter 5 - Ordered algebraic structures
    push(c, cmd("quotient_remainder", &run_quotient_remainder));
    push(c, cmd("gcd", &run_gcd));

    // Chapter 6 - Iterators
    // Chapter 7 - Coordinate structures
    // Chapter 8 - Coordinates with mutable successors
    // Chapter 9 - Copying
    // Chapter 10 - Rearrangements
    // Chapter 11 - Partition and merging

    // Chapter 12 - Composite objects
    // ***** to do: replace these with (Assert-based) tests
    push(c, cmd("slist", &run_slist_tests));
    push(c, cmd("list", &run_list_tests));
    push(c, cmd("stree", &run_stree_tests));
    push(c, cmd("tree", &run_tree_tests));
    push(c, cmd("array", &run_array_tests<0>));

    while (true) {
        print("\nElements of Programming: enter an index (out of range to end):\n");
        for (ptrdiff_t j = int(0); j < size(c); ++j) {
            print("  "); print(int(j)); print(" "); print(begin(c)[j].name); print_eol();
        }
        int i;
        read(i);
        if (i < 0 || size(c) <= ptrdiff_t(i)) return 0;
        print("Running "); print(begin(c)[ptrdiff_t(i)].name); print(".\n");
        begin(c)[ptrdiff_t(i)].action();
    }

    return 0;
}
