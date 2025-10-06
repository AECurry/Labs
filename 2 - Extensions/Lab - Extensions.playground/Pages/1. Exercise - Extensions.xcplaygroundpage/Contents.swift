/*:
 ## Exercise - Extensions
 
 Define an extension to `Character` that includes a function `isVowel()`. The function returns `true` if the character is a vowel (a,e,i,o,u), and `false` otherwise. Be sure to properly handle uppercase and lowercase characters.
 */
extension Character {
    func isVowel() -> Bool {
        return["a", "e", "i", "o", "u"].contains(Character(self.lowercased()))
    }
}

let char1: Character = "A"
let char2: Character = "e"
let char3: Character = "b"

print("\(char1) is a vowel? \(char1.isVowel())")
print("\(char2) is a vowel? \(char2.isVowel())")
print("\(char3) is a vowel? \(char3.isVowel())")

//:  Create two `Character` constants, `myVowel` and `myConsonant`, and set them to a vowel and a consonant, respectively. Use the `isVowel()` methods on each constant to determine whether or not it's a vowel.
let myVowel: Character = "A"
let myConsonant: Character = "B"

print("\(myVowel) is a vowel? \(myVowel.isVowel())")
print("\(myConsonant) is a vowel? \(myConsonant.isVowel())")
//:  Create a `Rectangle` struct with two variable properties, `length` and `width`, both of type `Double`. Below the definition, write an extension to `Rectangle` that includes a function, `halved()`. This function returns a new `Rectangle` instance with half the length and half the width of the original rectangle.
struct Rectangle {
    var length: Double
    var width: Double
}

extension Rectangle {
    func halved() -> Rectangle {
        return Rectangle(length: self.length / 2, width: self.width / 2)
    }
    
    mutating func half() {
        self = self.halved()
    }
}

var myRectangle = Rectangle(length: 10, width: 5)
let mySmallerRectangle = myRectangle.halved()

myRectangle.half()

print("original rectangle after half(): \(myRectangle.length) * \(myRectangle.width)")
print("Smaller rectangle from halved(): \(mySmallerRectangle.length) * \(mySmallerRectangle.width)")

/*:
 Within the existing `Rectangle` extension, add a new mutating function, `half()`, which updates the original rectangle to have half the length and half the width. Use the `halved()` function as part of the implementation for `half()`.
 
 Below, create a variable `Rectangle` called `myRectangle`, and set its length to 10 and its width to 5. Create a second instance, `mySmallerRectangle`, that's the result of calling `halved()` on `myRectangle`. Then update the values of `myRectangle` by calling `half()` on itself. Print each of the instances.
 */
// Answer given above

/*:
 page 1 of 2  |  [Next: App Exercise - Workout Extensions](@next)
 */
