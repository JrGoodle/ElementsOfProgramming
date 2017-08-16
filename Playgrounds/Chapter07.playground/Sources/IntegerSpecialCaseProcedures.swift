//
//  IntegerSpecialCaseProcedures.swift
//  EOP
//

public protocol IntegerSpecialCaseProcedures {
    func successor() -> Self
    func predecessor() -> Self
    func twice() -> Self
    func halfNonnegative() -> Self
    func isPositive() -> Bool
    func isNegative() -> Bool
    func isZero() -> Bool
    func isOne() -> Bool
    func isEven() -> Bool
    func isOdd() -> Bool
}

public protocol BinaryIntegerSpecialCaseProcedures {
    func binaryScaleDownNonnegative(k: Self) -> Self
    func binaryScaleUpNonnegative(k: Self) -> Self
}
