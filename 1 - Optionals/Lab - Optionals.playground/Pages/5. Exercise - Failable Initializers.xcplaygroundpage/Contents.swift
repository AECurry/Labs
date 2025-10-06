/*:
 ## Exercise - Failable Initializers
 
 Create a `Computer` struct with two properties, `ram` and `yearManufactured`, where both parameters are of type `Int`. Create a failable initializer that will only create an instance of `Computer` if `ram` is greater than 0, and if `yearManufactured` is greater than 1970, and less than 2020.
 */
struct Computer {
    var ram: Int
    var yearManufactured: Int
    
    init?(ram: Int, yearManufacutred: Int) {
        if ram > 0 && yearManufacutred > 1970 && yearManufacutred < 2020 {
            self.ram = ram
            self.yearManufactured = yearManufacutred
        } else {
            return nil
        }
    }
}
//:  Create two instances of `Computer?` using the failable initializer. One instance should use values that will have a value within the optional, and the other should result in `nil`. Use if-let syntax to unwrap each of the `Computer?` objects and print the `ram` and `yearManufactured` if the optional contains a value.
let validComputer: Computer? = Computer(ram: 16, yearManufacutred: 2015)
let invalidComputer: Computer? = Computer(ram: 0, yearManufacutred: 2025)

if let computer = validComputer {
    print("Valid computer created: \(computer.ram)GB RAB, Year: \(computer.yearManufactured)")
} else {
    print("Failed to create valid computer.")
}

if let computer = invalidComputer {
    print("Invalid computer created: \(computer.ram)GB RAM, Year: \(computer.yearManufactured)")
} else {
    print("Failed to create invalid computer")
}

/*:
 [Previous](@previous)  |  page 5 of 6  |  [Next: App Exercise - Workout or Nil](@next)
 */
