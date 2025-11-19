/*:
## Exercise - Generic Types
 
 While most collections involve working with values at the beginning, end, or a specific index or the collection, this array only allows you to retrieve items from the center of the array. You know when you look at a stack of plates in the cupboard and the top one didn't get clean enough or it's a little bit dusty, but getting the bottom one would be too hrd to fish out, so you grab one from the middle of the stack? So this will be our "StackOfPlates" collection type.
 */
import Foundation

// A generic stack that removes from the MIDDLE instead of the top
struct StackOfPlates<T> {
    private var array: [T]

    // Initialize with array or empty array by default
    init(array: [T] = []) {
        self.array = array
    }
    // Add element to the END of the stack (normal stack behavior)
    mutating func push(_ value: T) {
        array.append(value)
    }

    // Returns nil if stack is empty, otherwise removes middle element
    mutating func pop() -> T? {
        guard !array.isEmpty else { return nil }
        
        // Finds center index
        let middleIndex = (array.count - 1) / 2
        
        // Removes middle element
        return array.remove(at: middleIndex)
    }
}

// Adds unique identification capability
extension StackOfPlates: Identifiable {
    var id: UUID {
        
        // Generates new unique ID each time accessed
        return UUID()
    }
}


// Examples
var stringStack = StackOfPlates(array: ["Clean", "Dusty", "Clean"])
stringStack.push("Very Clean")
print("Popped from string stack: \(stringStack.pop() ?? "nil")")

var intStack = StackOfPlates(array: [1, 2, 3, 4, 5])
intStack.push(6)
print("Popped from int stack: \(intStack.pop() ?? 0)")

var doubleStack = StackOfPlates(array: [0.5, 1.2, 0.8, 1.5])
doubleStack.push(2.1)
print("Popped from double stack: \(doubleStack.pop() ?? 0.0)")

//:  Convert the StackOfPlates struct to be a generic type so that it can hold any type, not just String. Test it below by creating several StackOfPlates instances using different types.
// Answer given above
//: Use an extension of StackOfPlates to conform it to Identifiable so that one stack of plates has a separate ID than another.
// Answer given above
/*:
[Previous](@previous)  |  page 2 of 4  |  [Next: Exercise - Associated Types](@next)
 */
