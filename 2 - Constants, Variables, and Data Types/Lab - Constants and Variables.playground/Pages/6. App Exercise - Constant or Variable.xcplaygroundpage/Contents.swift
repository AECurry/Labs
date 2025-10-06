/*:
## App Exercise - Fitness Tracker: Constant or Variable?
 
 >These exercises reinforce Swift concepts in the context of a fitness tracking app.
 
 There are all sorts of things that a fitness tracking app needs to keep track of in order to display the right information to the user. Similar to the last exercise, declare either a constant or a variable for each of the following items, and assign each a sensible value. Be sure to use proper naming conventions.
 
- Name: The user's name
- Age: The user's age
- Number of steps taken today: The number of steps that a user has taken today
- Goal number of steps: The user's goal for number of steps to take each day
- Average heart rate: The user's average heart rate over the last 24 hours
 */
let userName: String = "Amy Applegate"
print("I choose a constant for the user name because it is a name that the user will not change.")
var userAge: Int = 25
print("I choose a variable for the user age because the user's age may change over time.")
var stepsTakenToday: Int = 6_425
print("I choose a variable for the steps taken beacuse the number of steps taken today may change over time.")
let goalNumberOfSteps: Int = 10_000
print("I choose a constant for the goal number of steps because the user's goal for number of steps to take each day is unlikely to change.")
var averageHeartRate: Double = 72.2
print("I choose a variable for the average heart rate because the user's average heart rate over the last 24 hours may change over time.")
/*:
 Now go back and add a line after each constant or variable declaration. On those lines, print a statement explaining why you chose to declare the piece of information as a constant or variable.
 
[Previous](@previous)  |  page 6 of 10  |  [Next: Exercise - Types and Type Safety](@next)
 */
