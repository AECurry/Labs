//
//  TripViewModel.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/20/26.
//

import SwiftUI
import SwiftData
import CoreLocation
import Combine

@MainActor
class TripViewModel: ObservableObject {
    @Published var tripName = ""
    @Published var errorMessage: String?
    
    var modelContext: ModelContext?
    
    init() {
        
    }
    
    func createTrip() -> Trip? {
        guard !tripName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Trip name cannot be empty"
            return nil
        }
        
        guard let modelContext = modelContext else {
            errorMessage = "Database not available"
            return nil
        }
        
        let trip = Trip(name: tripName.trimmingCharacters(in: .whitespaces))
        
        do {
            modelContext.insert(trip)
            try modelContext.save()
            errorMessage = nil
            return trip
        } catch {
            errorMessage = "Failed to save trip: \(error.localizedDescription)"
            return nil
        }
    }
    
    func deleteTrip(_ trip: Trip) {
        modelContext?.delete(trip)
        modelContext?.safeSave()
    }
    
    func updateTripName(_ trip: Trip, newName: String) {
        guard !newName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        trip.name = newName
        modelContext?.safeSave()
    }
}
