//
//  TripMapScreen.swift
//  TripLogger2App
//
//  Created by Your Name on 1/20/26.
//

import SwiftUI
import MapKit

struct TripMapScreen: View {
    let trips: [Trip]
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map {
                ForEach(trips.indices, id: \.self) { index in
                    let trip = trips[index]
                    let sortedEntries = trip.journalEntries.sorted { $0.date < $1.date }
                    
                    ForEach(sortedEntries) { entry in
                        Marker(entry.name, coordinate: entry.coordinate)
                            .tint(colorForTrip(at: index))
                    }
                    
                    if sortedEntries.count > 1 {
                        MapPolyline(coordinates: sortedEntries.map { $0.coordinate })
                            .stroke(colorForTrip(at: index), lineWidth: 3)
                    }
                }
            }
            .mapStyle(.standard)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 8) {
                    Text("All Trips Map")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    let totalEntries = trips.flatMap { $0.journalEntries }.count
                    Text("\(trips.count) trips • \(totalEntries) locations")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top)
                
                Spacer()
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func colorForTrip(at index: Int) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red]
        return colors[index % colors.count]
    }
}

#Preview {
    let trips = [
        Trip(name: "California Road Trip"),
        Trip(name: "European Adventure")
    ]
    
    return TripMapScreen(trips: trips, selectedTab: .constant(1))
}
