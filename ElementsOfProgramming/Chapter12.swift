//
//  Chapter12.swift
//  ElementsOfProgramming
//


// pair type: see Chapter 1 of this file


// Exercise 12.1: less< pair<T0, T1> > using less<T0> and less<T1>


// triple type: see Chapter 1 of this file


// Exercise 12.2: triple type


// array_k type

struct ArrayK<T: Regular>: Linearizable {
    var a: UnsafeMutablePointer<T>
    let k: Int
    
    subscript(index: Int) -> T {
        // Precondition: $0 \leq i < \func{size}(x)$
        get {
            return a[index]
        }
        set(newValue) {
            a[index] = newValue
        }
    }
    
    var begin: UnsafeMutablePointer<T> {
        return a
    }
    
    var end: UnsafeMutablePointer<T> {
        return a + k
    }
    
    static func ==(lhs: ArrayK, rhs: ArrayK) -> Bool {
        return lexicographicalEqual(f0: lhs.begin, l0: lhs.end, f1: rhs.begin, l1: rhs.end)
    }
    
    static func <(lhs: ArrayK, rhs: ArrayK) -> Bool {
        return lexicographicalLess(f0: lhs.begin, l0: lhs.end, f1: rhs.begin, l1: rhs.end)
    }
    
    var size: Int {
        return k
    }
    
    func isEmpty() -> Bool {
        return false
    }
}


// concept Linearizeable

//  Since we already defined ValueType for any (regular) T,
//  C++ will not let us define it for any linearizable T like this:

// template<typename W>
//     requires(Linearizable(W))
// struct value_type
// {
//     typedef ValueType(IteratorType(W)) type;
// };

// Instead, each type W that models Linearizable must provide
//      the corresponding specialization of value_type


func linearizableEqual<W: Linearizable>(x: W, y: W) -> Bool {
    return lexicographicalEqual(f0: x.begin, l0: x.end, f1: y.begin, l1: y.end)
}








