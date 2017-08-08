# Elements Of Programming

Swift implementation of [Elements of Programming](https://www.amazon.com/gp/product/032163537X/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=032163537X&linkCode=as2&tag=roodl05-20&linkId=0167e9e125bbfdaa3115ad5def8b3d6d) by [Alexander Stepanov](http://stepanovpapers.com/) and [Paul McJones](http://www.mcjones.org/paul/).

## Contents

- [ElementsOfProgramming](https://github.com/JrGoodle/ElementsOfProgramming/tree/master/ElementsOfProgramming)
    - Algorithms from [Elements of Programming](https://www.amazon.com/gp/product/032163537X/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=032163537X&linkCode=as2&tag=roodl05-20&linkId=0167e9e125bbfdaa3115ad5def8b3d6d)
    - Includes conditional compilation blocks used in Swift Playgrounds
- [EOP](https://github.com/JrGoodle/ElementsOfProgramming/tree/master/EOP)
    - Concepts, type functions, and extensions on various types
- [eop-code](https://github.com/JrGoodle/ElementsOfProgramming/tree/master/eop-code)
    - [Original C++ sample code](http://elementsofprogramming.com/)

## Generated Code

- [ElementsOfProgramming-Pretty](https://github.com/JrGoodle/ElementsOfProgramming/tree/master/ElementsOfProgramming-Pretty)
    - A prettified version of the `ElementsOfProgramming` code without conditional compilation blocks used in Swift Playgrounds
- [Playgrounds](https://github.com/JrGoodle/ElementsOfProgramming/tree/master/Playgrounds)
    - Swift Playgrounds for algorithms from each chapter
    - Code delimited by `#if !XCODE` blocks is used for Swift Playground visualization
    - Test function invocations beginning with `playground` can be uncommented to view the output

## Requirements

### macOS

- [Xcode 9](https://developer.apple.com/xcode/)

### Linux (currently untested)

- [Swift 4](https://swift.org/download/#snapshots)

## Progress

The initial port of the original C++ code primarily consisted of translating the concepts and type functions into protocols and generic function typealiases, expressing certain C++ constructs like [functors](https://stackoverflow.com/questions/356950/c-functors-and-their-uses) in Swift, and incorporating concept requirements in function signatures. The algorithms themselves closely resembled the C++ versions. The code was then refactored to make it more Swifty (using protocol methods and computed properties instead of free functions, renaming methods and functions, etc.). The conversion of early returns to `guard` statements may be a bit excessive in places, but I think the semantic meaning maps well to algorithms with algebraic preconditions.

Possibly undefined functions are represented as optionals (`leftSuccessor`, `rightSuccessor`, `source`, etc.) or throw errors when there's no return value. Optional idioms are used for boolean existence tests rather than separate functions (`hasLeftSuccessor()` and `hasRightSuccessor()`). Even though the algorithms may be a bit less elegant due to the extra code dealing with these scenarios, I think optionals and errors are a natural way to express certain properties of concepts in Swift.

I started a few attempts at converting the C++ code dealing with pointers to Swift using `UnsafePointer`, but since pointers aren't a first class citizen in Swift it never felt very natural. So rather than trying to replicate the usage of pointers in the original C++ with `UnsafePointer`, I plan on trying to take advantage of the reference semantics of classes to hopefully achieve the same goals.

 Although I've naively ported most of the original sample code up to chapter 11, I'm only now rigorously working my way through the book along with the code. Tests and playground examples are missing for most of the chapters, and I'm sure there are bugs from the initial porting effort and subsequent "Swiftifying".

## Contributing

See [CONTRIBUTING.md](https://github.com/JrGoodle/ElementsOfProgramming/blob/master/CONTRIBUTING.md)
