/*:
## App Exercise - Users and Distance
 
 >These exercises reinforce Swift concepts in the context of a fitness tracking app.
 
 For most apps you'll need to have a data structure to hold information about a user. Create a `User` struct that has properties for basic information about a user. At a minimum, it should have properties to represent a user's name, age, height, weight, and activity level. You could do this by having `name` be a `String`, `age` be an `Int`, `height` and `weight` be of type `Double`, and `activityLevel` be an `Int` that will represent a scoring 1-10 of how active they are. Implement this now.
 */
struct User {
    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var activityLevel: Int
    
    init(name: String, age: Int, height: Double, weight: Double, activityLevel: Int) {
           self.name = name
           self.age = age
           self.height = height
           self.weight = weight
           self.activityLevel = activityLevel
       }
   }

let exampleUser = User(name: "Alice", age: 28, height: 65.0, weight: 140.0, activityLevel: 7)

//:  Create a variable instance of `User` and call it your name. Use the memberwise initializer to pass in information about yourself. Then print out a description of your `User` instance using the instance's properties.
var ann = User(name: "Ann", age: 30, height: 65.0, weight: 140.0, activityLevel: 7)

    // Print a description using the instance's properties
    print("User Description:")
    print("Name: \(ann.name)")
    print("Age: \(ann.age)")
    print("Height: \(ann.height) inches")
    print("Weight: \(ann.weight) lbs")
    print("Activity Level: \(ann.activityLevel)/10")


/*:
 In previous app exercises, you've worked with distance in the fitness tracking app example as a simple number. However, distance can be represented using a variety of units of measurement. Create a `Distance` struct that will represent distance in various units of measurement. At a minimum, it should have a `meters` property and a `feet` property. Create a custom initializer corresponding to each property (i.e. if you only have the two properties for meters and feet you will then have two initializers) that will take in a distance in one unit of measurement and assign the correct value to both units of measurements. Hint: *1 meter = 3.28084 feet*.

 - Example: If you use the initializer for meters and pass in a distance of 1600, the initializer should set `meters` to 1600 and `feet` to 5249.344.
 */
struct Distance {
    var meters: Double
    var feet: Double
    
    init(meters: Double) {
        self.meters = meters
        self.feet = meters * 3.28084
    }
    
    init(feet: Double) {
        self.feet = feet
        self.meters = feet / 3.28084
    }
}


//:  Now create an instance of `Distance` called `mile`. Use the initializer for meters to set the distance to 1600. Print out the property for feet and verify that it is equal to 5249.344.
var mile = Distance(meters: 1600)

print("Distance in feet: \(mile.feet)")

if mile.feet == 5249.344 {
    print("Feet value is correct!")
} else {
    print("Check the calculation.")
}

//:  Now create another instance of `Distance` and give it some other distance. Ensure that both properties are set correctly.
var runDistance = Distance(feet: 3280.84)

print("Distance: \(runDistance.meters) meters, \(runDistance.feet) feet")


if runDistance.meters == 1000 && runDistance.feet == 3280.84 {
    print("Both properties are set correctly!")
} else {
    print("Check the calculation.")
}


/*:
[Previous](@previous)  |  page 4 of 10  |  [Next: Exercise - Methods](@next)
 */
