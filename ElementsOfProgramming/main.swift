//
//  main.swift
//  ElementsOfProgramming
//
//  Created by goodle on 7/12/17.
//  Copyright © 2017 PolkaDotCat. All rights reserved.
//

import Foundation

// MARK: Chapter 1

print("Test square")
print(square(2) { $0 * $1 })
print(square("a") { $0 + $1 })

// MARK: Chapter 2

print("Test powerUnary")
var x = 0
var n = 100
print(powerUnary(&x, n: &n) { $0 + 2 })

print("Test distance")
x = 0
let y = 100
print(distance(&x, y) { $0 + 2 })
