/*:
## Exercise - Numeric Type Conversion

 Create an integer constant `x` with a value of 10, and a double constant `y` with a value of 3.2. Create a constant `multipliedAsIntegers` equal to `x` times `y`. Does this compile? If not, fix it by converting your `Double` to an `Int` in the mathematical expression. Print the result.
 */
let x: Int = 10
let y: Double = 3.2
let multipliedAsIntergers = x * y
// no this does not comply because Ints can't work with Doubles and Doubles can't work with Ints. They both have to be either an Int or an Double

let multipliedAsIntergers = x * Int(y)
    print(multipliedAsIntergers)
//:  Create a constant `multipliedAsDoubles` equal to `x` times `y`, but this time convert the `Int` to a `Double` in the expression. Print the result.
let multipliedAsDoubles = Double(x) + y
    print(multipliedAsIntergers)

//:  Are the values of `multipliedAsIntegers` and `multipliedAsDoubles` different? Print a statement to the console explaining why.
// Yes the values are different becasue when you convert a doulbe to an Int you go down in value to the nearest whole number, but by converting both numbers to a double the value given should be greater and more accurtate.

/*:
[Previous](@previous)  |  page 7 of 8  |  [Next: App Exercise - Converting Types](@next)
 */
