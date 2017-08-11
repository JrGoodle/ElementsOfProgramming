//
//  EOPError.swift
//  EOP
//

public enum EOPError : Error {
    case noSuccessor, noPredecessor
    case noLeftSuccessor, noRightSuccessor
    case noSource
    case failure
}
