

func progressUpdate(steps: Int, goals: Int) {
  
        if steps <= (goals / 10) {
            print("You're off to a good start.")
        } else if steps <= (goals / 2) {
            print("You're halfway there!")
        } else if Double(steps) <= (Double(goals) / 0.9) {
            print("You're almost there!")
        } else
            { print("You beat your goal!")
            
        }
    }
    progressUpdate(steps: 2_345, goals: 10_000)
//:  Your fitness tracking app is going to help runners stay on pace to reach their goals. Write a function called pacing that takes four `Double` parameters called `currentDistance`, `totalDistance`, `currentTime`, and `goalTime`. Your function should calculate whether or not the user is on pace to hit or beat `goalTime`. If yes, print "Keep it up!", otherwise print "You've got to push it just a bit harder!"
func pacing(currentDistance: Double, totalDistance: Double, currentTime: Double, goalTime: Double) {
    
let currentPace = currentTime / currentDistance
let predictedTime = currentPace + totalDistance
    
    if predictedTime <= goalTime {
        print("Keep it up!")
    } else {
        print("You've got to push jus a bit harder!")
    }
}



/*:
[Previous](@previous)  |  page 4 of 6  |  [Next: Exercise - Return Values](@next)
 */
