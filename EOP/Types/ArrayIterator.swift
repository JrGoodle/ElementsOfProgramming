//
//  ArrayIterator.swift
//  EOP
//

public final class ArrayIterator<T: Regular>: BidirectionalIterator, Mutable {
    
    private class ArrayRef<U: Regular> {
        var value: [U?]
        
        init(_ value: [U?]) {
            self.value = value
        }
    }
    
    private var array: ArrayRef<T>
    private var index = 0
    
    public init(_ array: [T?]) {
        self.array = ArrayRef(array)
    }
    
    public init(_ array: [T]) {
        self.array = ArrayRef(array)
    }
    
    private init(_ array: ArrayRef<T>, _ index: Int) {
        self.array = array
        self.index = index
    }
    
    public var sink: T? {
        get {
            return array.value[index]
        }
        set {
            array.value[index] = newValue
        }
    }
    
    public var iteratorSuccessor: ArrayIterator? {
        return ArrayIterator(array, index + 1)
    }
    
    public var iteratorPredecessor: ArrayIterator? {
        return ArrayIterator(array, index - 1)
    }
    
    public var deref: T? {
        get {
            return array.value[index]
        }
        set {
            if let newValue = newValue {
                array.value[index] = newValue
            }
        }
    }
    
    public func predecessor(at distance: DistanceType) -> ArrayIterator? {
        var i: ArrayIterator?
        for _ in 0..<distance {
            guard let p = self.iteratorPredecessor else { return nil }
            i = p
        }
        return i
    }
    
    public static func <(lhs: ArrayIterator, rhs: ArrayIterator) -> Bool {
        // FIXME: Actually implement this
        return false
    }
    
    public static func ==(lhs: ArrayIterator, rhs: ArrayIterator) -> Bool {
        return lhs.index == rhs.index &&
               lhs.array.value[lhs.index] == rhs.array.value[rhs.index]
    }
    
    public func advanced(by steps: Int) -> ArrayIterator? {
        return ArrayIterator(array, index + steps)
    }
    
    public var source: T? {
        return array.value[index]
    }
}
