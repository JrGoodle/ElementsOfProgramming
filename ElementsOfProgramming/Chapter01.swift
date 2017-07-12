//
//  Chapter01.swift
//  ElementsOfProgramming
//

func square<DomainOp>(_ x: DomainOp, op: Op<DomainOp>) -> DomainOp {
    return op(x, x)
}
