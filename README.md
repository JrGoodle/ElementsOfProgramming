# Elements Of Programming [![Build Status](https://travis-ci.org/JrGoodle/ElementsOfProgramming.svg?branch=master)](https://travis-ci.org/JrGoodle/ElementsOfProgramming)

Swift port of the algorithms from [Elements of Programming](https://www.amazon.com/gp/product/032163537X/) by [Alexander Stepanov](http://stepanovpapers.com/) and [Paul McJones](http://www.mcjones.org/paul/).

## Contents

- [ElementsOfProgramming](https://github.com/JrGoodle/ElementsOfProgramming/tree/master/ElementsOfProgramming)
    - Algorithms from **Elements of Programming** organized by chapter
    - Includes conditional compilation blocks used in Swift Playgrounds
- [EOP](https://github.com/JrGoodle/ElementsOfProgramming/tree/master/EOP)
    - Concepts, type functions, and extensions on various types
- [eop-code](https://github.com/JrGoodle/ElementsOfProgramming/tree/master/eop-code)
    - [Original C++ sample code](http://elementsofprogramming.com/code.html) from the book's [official web site](http://elementsofprogramming.com/)

## Generated Code

- [ElementsOfProgramming-Pretty](https://github.com/JrGoodle/ElementsOfProgramming/tree/master/ElementsOfProgramming-Pretty)
    - A prettified version of the `ElementsOfProgramming` code without conditional compilation blocks used in Swift Playgrounds
- [Playgrounds](https://github.com/JrGoodle/ElementsOfProgramming/tree/master/Playgrounds)
    - Swift Playgrounds for algorithms from each chapter
    - Code delimited by `#if !XCODE` blocks is used for Swift Playground visualization
    - Test function invocations beginning with `playground` can be uncommented to view the visualizations and play around with the algorithms

## Requirements

### macOS

- [Xcode 9 beta 5 with Swift 4](https://developer.apple.com/download/)

### Linux (currently untested)

- [Swift 4](https://swift.org/download/#snapshots)

## Progress

The following gives a rough idea of the decisions made thus far, and mentions some areas that still need work. Eventually the relevant parts from this section will likely be moved to a dedicated design rationale doc, and the outdated parts will be removed as the code base matures.

The initial port of the original C++ code primarily consisted of translating the concepts and type functions into [protocols](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html) and [generic function typealiases](https://github.com/apple/swift-evolution/blob/master/proposals/0048-generic-typealias.md), expressing certain C++ constructs like [functors](https://stackoverflow.com/questions/356950/c-functors-and-their-uses) in Swift, and incorporating concept requirements in function signatures. The algorithms themselves closely resembled the C++ versions. The code was then refactored to make it more Swifty (using protocol methods and [computed properties](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html#//apple_ref/doc/uid/TP40014097-CH14-ID259) instead of free functions, renaming, using [guard statements for early exits](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID525), safely handling [optionals](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID330), etc.).

Functions and properties that could possibly be undefined are represented with optionals (`leftSuccessor`, `rightSuccessor`, `source`, etc.), and functions that deal with optionals and have no return value throw [errors](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/ErrorHandling.html). Boolean existence tests use optional idioms rather than functions (`hasLeftSuccessor()` and `hasRightSuccessor()` aren't necessary). Even though the algorithms may be a bit less elegant due to the extra code for dealing with this, I think optionals are a natural way to express certain properties of concepts in Swift. I may reevaluate some of the current uses of optionals as I work through the book.

I started a few attempts at converting the C++ code dealing with pointers to [UnsafeMutablePointer](https://developer.apple.com/documentation/swift/unsafemutablepointer), but I don't have a lot of experience with the API's and it never felt very natural to be venturing into unsafe Swift. So instead I plan on trying to utilize class reference semantics to hopefully achieve the same goals.

 Although I've naively ported most of the original sample code up to chapter 11, I'm only now rigorously working my way through the book along with the code. Tests and playground examples are missing for most of the chapters, and I'm sure there are bugs from the initial porting effort and subsequent Swiftifying.

## Contributing

See [CONTRIBUTING.md](https://github.com/JrGoodle/ElementsOfProgramming/blob/master/CONTRIBUTING.md)
