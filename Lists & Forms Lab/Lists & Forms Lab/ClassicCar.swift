//
//  ClassicCar.swift
//  Lists & Forms Lab
//
//  Created by AnnElaine on 10/7/25.
//

import Foundation

// This struct defines what a "ClassicCar" is in the app
// "Indentifiable" allows SiftUI Lists to track each car uniquely
struct ClassicCar: Identifiable {
    
// Properties
    // Vehicle Identificaiton Number - unique for each car
    var vin: String
    
    // Manufacturing year
    var year: String
    
    // Manufacturing Maker (Ford, Cheverolet, Dodge, etc.)
    var make: String
    
    // Specific model name (Mustang, Camaro, Charger, etc.)
    var model: String
    
    // Mileage on the vehicle
    var miles: String
    
    // Comuted property that satisfies Identifiable protocol
    // SwiftUI Lists uses this 'id' to track each item for animations and updates
    var id: String { vin }
}
