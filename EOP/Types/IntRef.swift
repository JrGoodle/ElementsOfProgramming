//
//  IntRef.swift
//  EOP
//

public class IntRef {
    public var value: Int
    
    public init(_ value: Int) {
        self.value = value
    }
}

extension IntRef: Regular {
    public static func <(lhs: IntRef, rhs: IntRef) -> Bool {
        return lhs.value < rhs.value
    }
    
    public static func ==(lhs: IntRef, rhs: IntRef) -> Bool {
        return lhs.value == rhs.value
    }
}
