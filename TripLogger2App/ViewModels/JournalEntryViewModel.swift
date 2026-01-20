//
//  JournalEntryViewModel.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/20/26.
//

import SwiftUI
import SwiftData
import CoreLocation
import PhotosUI
import Combine

@MainActor
class JournalEntryViewModel: ObservableObject {
    @Published var locationName = ""
    @Published var entryDescription = ""
    @Published var entryDate = Date()
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var photoImages: [UIImage] = []
    @Published var pinCoordinate: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var modelContext: ModelContext?
    
    init() {
        // Simple default init
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func createEntry(for trip: Trip) -> JournalEntry? {
        guard !locationName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Location name cannot be empty"
            return nil
        }
        
        guard let coordinate = pinCoordinate else {
            errorMessage = "Please select a location on the map"
            return nil
        }
        
        guard let modelContext = modelContext else {
            errorMessage = "Database not available"
            return nil
        }
        
        let entry = JournalEntry(
            name: locationName.trimmingCharacters(in: .whitespaces),
            entryDescription: entryDescription,
            date: entryDate,
            photos: photoImages,
            coordinate: coordinate
        )
        
        modelContext.insert(entry)
        entry.trip = trip
        trip.journalEntries.append(entry)
        
        do {
            try modelContext.save()
            errorMessage = nil
            return entry
        } catch {
            errorMessage = "Failed to save entry: \(error.localizedDescription)"
            return nil
        }
    }
    
    func updateEntry(_ entry: JournalEntry) {
        entry.name = locationName
        entry.entryDescription = entryDescription
        entry.date = entryDate
        entry.photos = photoImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
        
        if let coordinate = pinCoordinate {
            entry.latitude = coordinate.latitude
            entry.longitude = coordinate.longitude
        }
        
        modelContext?.safeSave()
        print("✅ Entry updated: \(entry.name)")
    }
    
    func loadPhotos() async {
        isLoading = true
        var newImages: [UIImage] = []
        
        for item in selectedPhotos {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                newImages.append(image)
            }
        }
        
        photoImages.append(contentsOf: newImages)
        selectedPhotos.removeAll()
        isLoading = false
    }
    
    func removePhoto(at index: Int) {
        guard index < photoImages.count else { return }
        photoImages.remove(at: index)
    }
    
    func reset() {
        locationName = ""
        entryDescription = ""
        entryDate = Date()
        photoImages = []
        selectedPhotos = []
        pinCoordinate = nil
        errorMessage = nil
    }
    
    func loadEntryData(_ entry: JournalEntry) {
        locationName = entry.name
        entryDescription = entry.entryDescription
        entryDate = entry.date
        photoImages = entry.uiImages
        pinCoordinate = entry.coordinate
    }
}
