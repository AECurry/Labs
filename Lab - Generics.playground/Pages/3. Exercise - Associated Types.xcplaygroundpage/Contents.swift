/*:
## Exercise - Associated Types
 
 The `Toolbox` type only allows one type of item to be stored in each toolbox. The `MechanicToolbox` and `ArtToolbox` both conform to `Toolbox`. `MechanicToolbox` uses an explicit typealias declaration, while `ArtToolbox` allows the compiler to infer the asosociated type from the `listTools()` function's return type. For brevity's sake, the `Wrench`, `Brush`, and `WatchmakerTools` structs have been left blank; you may add properties to them to differentiate between instances of them better if you wish.
 */

// Protocol with associated type - defines requirement for any toolbox
protocol Toolbox {
    // Placeholder for whatever tool type this toolbox holds
    associatedtype Tool
    // Must return array of specific tool type
    func listTools() -> [Tool]
}

// Different tool types that various toolboxes can contain
struct Wrench {
    let size: String
    let brand: String
}

struct Brush {
    let bristleType: String
    let color: String
}
struct WatchmakerTools {
    let precision: String
    let material: String
}

// Mechanic's toolbox
struct MechanicToolbox: Toolbox {
    // Explicitly declare Wrench as the Tool type
    typealias Tool = Wrench
    func listTools() -> [Wrench] {
        return [
            Wrench(size: "10mm", brand: "Craftsman"),
            Wrench(size: "15mm", brand: "Snap-on")
        ]
    }
}

// Artist's toolbox
struct ArtToolbox: Toolbox {
    // Explicitly declare Brush as the Tool type
    func listTools() -> [Brush] {
        return [
            Brush(bristleType: "Synthetic", color: "Brown"),
            Brush(bristleType: "Natural", color: "Black")
        ]
    }
}

// Watchmaker's toolbox
struct WatchmakerToolbox: Toolbox {
    // Explicitly declares Watchmaker tool type
    typealias Tool = WatchmakerTools
    
    // Implements the required listTools() method from Toolbox protocol
    // Returns an array of three specialized watchmaking tools
    func listTools() -> [WatchmakerTools] {
        return [
            WatchmakerTools(precision: "High", material: "Steel"),
            WatchmakerTools(precision: "Ultra", material: "Titanium"),
            WatchmakerTools(precision: "Standard", material: "Brass")
        ]
    }
}


// Use Examples
let mechanicBox = MechanicToolbox()
let artBox = ArtToolbox()

print("Mechanic Tools:")
for tool in mechanicBox.listTools() {
    print(" - \(tool.brand) \(tool.size) wrench")
}

print("\nArt Tools:")
for tool in artBox.listTools() {
    print(" - \(tool.color) \(tool.bristleType) brush")
}

let watchmakerBox = WatchmakerToolbox()

print("Watchmaker's Tools:")
for (index, tool) in watchmakerBox.listTools().enumerated() {
    print(" \(index + 1). \(tool.material) \(tool.precision) percision tool")
}
//:  Create another struct, `WatchmakersToolbox` that conforms to `Toolbox`. Use an explicit `typealias` declaration to specify the type for `Tool`.
// Answer given above

//:  Create another protocl, `DeliveryService`. Give it the associatedtype `Parcel` and a function `deliver(parcel: Parcel`). Create two more structs, `FoodCourier` and `MailCourier` that conform to `DeliveryService`, with reasonable associated types.

// Protocol with associated type - defines requirement for any delivery service
protocol DeliveryService {
    // Placeholder for the type of parcel this service delivers
    associatedtype Parcel
    // Must be able to deliver its specific parcel type
    func deliver(parcel: Parcel)
}

// Different parcel types for different delivery services
struct FoodParcel {
    let foodType: String
    let temperature: String
    let restaurant: String
    let deliveryTime: Int
}

struct MailParcel {
    let packageType: String
    let weight: Double
    let destination: String
    let priority: String
}

// Food delivery service that specializes in FoodParcels
struct FoodCourier: DeliveryService {
    // Explicitly declare this service handles FoodParcels
    typealias Parcel = FoodParcel
    
    // Implements delivery for food parcels with restaurant details
    func deliver(parcel: FoodParcel) {
        print("Food Delivery:")
        print("Restaurant: \(parcel.restaurant)")
        print("Order: \(parcel.foodType)")
        print("Temperature: \(parcel.temperature)")
        print("Estimated time: \(parcel.deliveryTime) minutes")
    }
}

// Mail delivery service that specializes in MailParcels
struct MailCourier: DeliveryService {
    
    // Type inferred automatically - no typealias needed
    // Implements delivery for mail parcels with shipping details
    func deliver(parcel: MailParcel) {
        print("Mail Delivery:")
        print("Package: \(parcel.packageType)")
        print("Weight: \(parcel.weight)kg")
        print("Destination: \(parcel.destination)")
        print("Priority: \(parcel.priority)")
    }
}
/*:
[Previous](@previous)  |  page 3 of 4  |  [Next: App Exercise - Workout API](@next)
 */
