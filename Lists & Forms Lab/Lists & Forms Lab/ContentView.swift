//
//  ContentView.swift
//  Lists & Forms Lab
//
//  Created by AnnElaine on 10/7/25.
//

import SwiftUI

// ContentView: main screen showing the list of Classic Cars
struct ContentView: View {
    
    // Data Source
    // @State creates mutable data that SwiftUI watches for changes
    // When this array changes, Swift automatically updates the UI
    @State private var cars = [
        ClassicCar(vin: "1G1YY22G5V5100001", year: "1967", make: "Ford", model: "Mustang", miles: "45,000"),
        ClassicCar(vin: "2FABP63W2VX100002", year: "1968", make: "Chevrolet", model: "Camaro", miles: "67,000"),
        ClassicCar(vin: "1FAFP42X2VF100003", year: "1969", make: "Dodge", model: "Charger", miles: "120,000")
    ]
    
    // Tracks edit mode manually
    @State private var isEditing = false
    
    var body: some View {
        
        // Navigation Container - enables stack-based navigation between screens
        NavigationView {
            
            // List Definition - creates scrollable table view for data collections
            List {
                
                Section {
                
                // Title row
                Text("Classic Cars")
                    .font(.largeTitle.bold())
                    .padding(.top, 20)   // moves it down away from the Edit button
                    .padding(.bottom, 8) // space between title and first car
            }
                        .listRowInsets(EdgeInsets())      // remove default insets
                        .listRowBackground(Color.clear)   // keep background transparent
                    
                
                // ForEach($cars) = Binding to original array
                // $car = Binding to individual car (edits go back to original array)
                ForEach($cars) { $car in
                    
                    // Navigation Link - tapping pushes CarDetailForm onto navigation stack
                    NavigationLink {
                        // Destination: Pass Binding to car so edits persist
                        CarDetailForm(car: $car)
                    } label: {
                        
                        // LabeledContent = Built-in list row format (title + value)
                        Text("\(car.year) \(car.make) \(car.model) — \(car.miles) miles")
                    }
                    // Padding between list rows of cars
                    .padding(.vertical, 8)
                }
                // Swipe to Delete
                .onDelete(perform: deleteCar)
                
                // Reordering Rows
                .onMove(perform: moveCar)
            }
           
            // Toolbar Buttons
            .toolbar {
                
                // Add Car Button (Right side)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "Done" : "Edit") {
                        isEditing.toggle()
                    }
                    .font(.body.weight(.medium))
                    .foregroundColor(.black)
                    .frame(minWidth: 80) // Match to Add Car width
                }
                
                // Edit Button (Left side)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Car") {
                        addNewCar()
                    }
                    .font(.body.weight(.medium))
                    .foregroundColor(.black)
                    .frame(minWidth: 85) // Adds spacing between button and title
                }
            }
            // Enable edit mode when isEditing is true
            .environment(\.editMode, .constant(isEditing ? .active : .inactive))
        }
    }
    
    // Delete Car Function
    private func deleteCar(at offsets: IndexSet) {
        cars.remove(atOffsets: offsets)
    }
    
    // Move Car Function
    private func moveCar(from source: IndexSet, to destination: Int) {
        cars.move(fromOffsets: source, toOffset: destination)
    }
    
    // Add New Car Function
    private func addNewCar() {
        let newVin = "TEMP-\(UUID().uuidString.prefix(8))"
        cars.append(ClassicCar(vin: newVin, year: "2025", make: "New", model: "Car", miles: "0"))
    }
}

// PREVIEW OUTSIDE THE STRUCT
#Preview {
    ContentView()
}
