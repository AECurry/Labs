// Calculator Project: our overall goal is to recreate the functionality of an actual calculator as possible while using functions in the place of buttons. To that end, your mathematical functions must not accept any parameters. Instead, you must have one function for inputting a value, then "press" the other functions for adding, subtracting, multiplying, dividing, invert sign (+/-) and percentage, as well as C/AC to clear the current value. Use print statements to output the running total of the calculator. that this code is complete and funcional?: import UIKit

import UIKit

struct Calculator {
    var runningTotal: Double = 0
    //Keeps track of the total value after operations (+,-,*,/) are applied
    var currentInput: Double = 0
    //Stores the number the user is currently typing
    var pendingOperation: Math?
    //Remembers which Math operation (+,-,*,/) was pressed so that when the use hits the "=" it knows how to solve the problem
    
    
    var isDecimal = false
    //Used to handle numbers with decimals
    var decimalPlace = 0.1
    //Keeps track of where to place the next digit after the decimal point
    
    enum Math {
    //These are my fixed set of options to create my calculator. //This supports the switch code I use latter on and is safer than a string.
        case addition
        case subtraction
        case multiplication
        case division
        case invert
        case percent
        case clear
    }
    
    mutating func clear() {
    //This resets the calculator back to its starting state - like hitting the "C/AC" button on a real calculator
    //It's mutating because it changes (mutates) the properties of the Calculator struct
        runningTotal = 0
        currentInput = 0
        pendingOperation = nil
        isDecimal = false
        decimalPlace = 0.1
    }
    
    mutating func inputDecimalPoint() {
    //This starts decimal mode when the user presses the decimal point button
    //Setting decimalPlace to 0.1 ensures the first decimal digit is placed correctly
        if !isDecimal {
            isDecimal = true
            decimalPlace = 0.1
        }
        print(currentInput)
    }
    
    mutating func inputNumber(_ number: Int) {
    //This tell the calculator if we are in Int mode multiply by 10 so the digits "shifts" to the left and goes from the ones spot to the 10's, or from the 10's spot to the 100's
    //If the calculator is being asked to work in decimal mode then it will use the "else" feature and divide by 10 and move it from .1 to .01
        if !isDecimal {
            currentInput = currentInput * 10 + Double(number)
        } else {
            currentInput += Double(number) * decimalPlace
            decimalPlace /= 10
        }
        print(currentInput)
    }
    
    mutating func performOperation(_ operation: Math) {
    //This is where the math operations actually happen
    //If the operation is clear, I just call my clear() function
    //This resets currentInput to 0 so the user can type the second number
        
        if operation == .clear {
            clear()
            return
        }
        
        guard let pending = pendingOperation else {
        // This checks if there is already a (stored) pending operation.
        // If there is not one save the first number in "runningTotal", clear "currentInput" so user can put in the next number and wait for the next "currentInput" or "pendingOperation"
            runningTotal = currentInput
            currentInput = 0
            pendingOperation = operation
            return
        }
        
        switch pending {
        // This performs the Math operation the user chose
        // Each of these switch cases perfectly matches with the enum above that way if I choose to add more operations later, I just add another case here
        case .addition: runningTotal += currentInput
        case .subtraction: runningTotal -= currentInput
        case .multiplication: runningTotal *= currentInput
        case .division:
        // I put this guard here to stop the program if someone tried dividing by 0 so the code would not crash
            guard currentInput != 0 else {
                return
            }
            runningTotal /= currentInput
        default:
            break
        }
        
        // This allows the calculator to keep running without resetting after every operation so it can keep going until given an "=" sign. (5 * 3 + 2 - 7...
        currentInput = 0
        pendingOperation = (operation == .clear || operation == .invert) ? nil : operation
    }
    
    mutating func invert() {
    // Changes the sign of the current input from 25 to -25 or back again
        currentInput *= -1
        print(currentInput)
    }
    
    mutating func percent() {
    // Divides by 100 and changes the current input into a percentage Ex: 50 -> % -> 0.5
        currentInput /= 100
        print(currentInput)
    }
    
    mutating func addition() {
    // Tells the calculator to prepare for an addition operation
        performOperation(.addition)
        print(runningTotal)
    }
    
    mutating func subtraction() {
    // Tells the calculator to prepare for a subtraction operation
        performOperation(.subtraction)
        print(runningTotal)
    }
    
    mutating func multiplication() {
    // Tells the calculator to prepare for a multiplication operation
        performOperation(.multiplication)
        print(runningTotal)
    }
    
    mutating func division() {
    // Tells the calculator to prepare for a division operation
        performOperation(.division)
        print(runningTotal)
    }
    
    mutating func clearButton() {
    // Calls the clear() function to reset everything back to zero
        clear()
        print(runningTotal)
    }
    
    mutating func equals() {
    // This is pressed when the user wants to see the result
    // Defaults to addition if no pendingOperation was set
        performOperation(pendingOperation ?? .addition)
    //Once the result is calculated, the calculator is clear and ready for a new sequence
        pendingOperation = nil
        print(runningTotal)
    }
}

// *testing for each function

var calc = Calculator()

print("Testing addition:")
calc.clearButton()

//first numbers
calc.inputNumber(1)
calc.inputNumber(5)
calc.inputNumber(8)
print("currentInput: \(calc.currentInput), runningTotal: \(calc.runningTotal)")

//performing operation
calc.addition()
print(calc.runningTotal)

//second numbers
calc.inputNumber(4)
calc.inputNumber(2)
print("currentInput: \(calc.currentInput), runningTotal: \(calc.runningTotal)")

//performing operation
calc.equals()
print(calc.runningTotal)



print("Testing subtraction:")
calc.clearButton()

calc.inputNumber(1)
calc.inputNumber(5)
calc.inputNumber(8)
print("currentInput: \(calc.currentInput), runningTotal: \(calc.runningTotal)")

calc.subtraction()
print(calc.runningTotal)

calc.inputNumber(4)
calc.inputNumber(2)
print("currentInput: \(calc.currentInput), runningTotal: \(calc.runningTotal)")

calc.equals()
print(calc.runningTotal)



print("Testing multiplication:")
calc.clearButton()

calc.inputNumber(1)
calc.inputNumber(5)
calc.inputNumber(8)
print("currentInput: \(calc.currentInput), runningTotal: \(calc.runningTotal)")

calc.multiplication()
print(calc.runningTotal)

calc.inputNumber(2)
print("currentInput: \(calc.currentInput), runningTotal: \(calc.runningTotal)")

calc.equals()
print(calc.runningTotal)



print("Testing division:")
calc.clearButton()

calc.inputNumber(1)
calc.inputNumber(5)
calc.inputNumber(8)
print("currentInput: \(calc.currentInput), runningTotal: \(calc.runningTotal)")

calc.division()
print(calc.runningTotal)

calc.inputNumber(2)
print("currentInput: \(calc.currentInput), runningTotal: \(calc.runningTotal)")

calc.equals()
print(calc.runningTotal)



print("Testing invert:")
calc.clearButton()

calc.inputNumber(1)
calc.inputNumber(5)
calc.inputNumber(8)
print("currentInput: \(calc.currentInput), runningTotal: \(calc.runningTotal)")

calc.invert()
print(calc.runningTotal)



print("Testing percent:")

calc.inputNumber(1)
calc.inputNumber(5)
calc.inputNumber(8)
print("currentInput: \(calc.currentInput), runningTotal: \(calc.runningTotal)")

calc.percent()
print(calc.runningTotal)


