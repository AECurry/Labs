import SwiftUI

struct CarDetailForm: View {
    // Change from @State to @Binding to connect to the original data
    @Binding var car: ClassicCar
    
    var body: some View {
        Form {
            Section("Car Information") {
                Text("VIN: \(car.vin)")
                    .foregroundColor(.gray)
                TextField("Year", text: $car.year)
                TextField("Make", text: $car.make)
                TextField("Model", text: $car.model)
                TextField("Miles", text: $car.miles)
            }
        }
        .navigationTitle("Car Details")
    }
}
