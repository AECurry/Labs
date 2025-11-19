/*:
## Exercise - Generic Functions
 
 The `duplicate` function below works only when working with Ints, but its body could work with any type. Rewrite the function to use a generic type `<T>` instead. Test your new function by calling it several times, using a String, an Int, and a Double.
 */

import Foundation

// <T> makes this a generic function that can accept any type
// The compiler will create specialized versions as needed
func duplicate<T>(_ value: T) -> (T, T) {
    // Returns a tuple containing the same value twice
    return (value, value)
}

// Testing with different types
let intDuplicates = duplicate(5) // Int
let stringDuplicates = duplicate("Hello") // String
let doubleDuplicates = duplicate(3.14) // Double

// Test
print(intDuplicates)
print(stringDuplicates)
print(doubleDuplicates)

//:  The function below retrieves a random value from an array of Ints and then deletes that value. The `inout` keyword means that it modifies the array passed into it directly. This function could work with an array of any type, so long as the type conforms to Equatable. Rewrite the function to use a generic type `<U>` instead, constraining to Equatable types. Test your new function by calling it several times, using an array of Strings, of Ints, and of Doubles.
// Generic function that removes and returns a random element from an array
func pullRandomElement<U: Equatable>(_ array: inout [U]) -> U? {
    
    // Get a random element from the array without removing it
        // randomElement() returns an optional in case the array is empty
    let randomElement = array.randomElement()
    
    // Guard statement with multiple optional bindings, if either operation fails, return nil
    guard let randomElement, let index = array.firstIndex(of: randomElement) else { return nil }
    
    // This physically take the element out of the array
    array.remove(at: index)
    
    // Returns the randomly selected and removed element
    return randomElement
}


//:  The function below sorts an array, then returns a new array containing only the first and last Strings of the array after sorting. This function could work with an array of any type, so long as the type conforms to Comparable. Rewrite the function to use a generic type `<V>` instead, constraining to Comparable types. Test your new function by calling it several times, using an array of Strings, of Ints, and of Doubles.
// Returns an array containing the smallest and largest elements from the input array
// Works with any type V that can be compared (String, Int, Double, etc.)
func minMaxArray<V: Comparable>(_ array: [V]) -> [V] {
    var output: [V] = []
    
    // Find smallest element in array
    let minElement = array.min()
    // Find largest element in array
    let maxElement = array.max()
    
    // Add smallest element to result if found
    if let minElement {
        output.append(minElement)
    }
    
    // Add largest element to result if found
    if let maxElement {
        output.append(maxElement)
    }
    
    // Returns [min, max] or empty array if input was empty
    return output
}

// Examples
let stringArray = ["Zebra", "Apple", "Monkey", "Banana"]
let stringResult = minMaxArray(stringArray)
print("Strings: \(stringResult)")

let intArray = [5, 2, 8, 1, 9]
let intResult = minMaxArray(intArray)
print("Ints: \(intResult)")

let doubleArray = [3.15, 1.55, 2.65, 4.33]
let doubleResult = minMaxArray(doubleArray)
print("Doubles: \(doubleResult)")
/*:
page 1 of 4  |  [Next: Exercise - Generic Types](@next)
 */
