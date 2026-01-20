//
//  JournalEntry.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/16/26.
//

import Foundation
import SwiftData
import CoreLocation
import UIKit

@Model
class Trip {
    @Attribute(.unique) var id: UUID
    var name: String
    var startDate: Date
    @Relationship(deleteRule: .cascade, inverse: \JournalEntry.trip)
    var journalEntries: [JournalEntry]
    
    init(name: String, startDate: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.startDate = startDate
        self.journalEntries = []
    }
}

@Model
class JournalEntry {
    @Attribute(.unique) var id: UUID
    var name: String
    var entryDescription: String
    var date: Date
    var photos: [Data]
    var latitude: Double
    var longitude: Double
    
    var trip: Trip?
    
    @Transient var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    @Transient var uiImages: [UIImage] {
        photos.compactMap { UIImage(data: $0) }
    }
    
    init(name: String,
         entryDescription: String = "",
         date: Date = Date(),
         photos: [UIImage] = [],
         coordinate: CLLocationCoordinate2D) {
        self.id = UUID()
        self.name = name
        self.entryDescription = entryDescription
        self.date = date
        self.photos = photos.compactMap { $0.jpegData(compressionQuality: 0.8) }
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.trip = nil
    }
}
