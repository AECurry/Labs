//
//  MainAppView.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/12/26.
//

// Main DUMB parent file for the entire app

import SwiftUI
import SwiftData

struct MainAppView: View {
    @State private var selectedTab = 0
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabContainerView(selectedTab: $selectedTab)
            .onAppear {
                // Test that SwiftData is configured
                print("ModelContext loaded")
                
                let descriptor = FetchDescriptor<Trip>()
                if let trips = try? modelContext.fetch(descriptor) {
                    print("Number of trips in database: \(trips.count)")
                    for trip in trips {
                        print("Trip: \(trip.name) - \(trip.journalEntries.count) entries")
                    }
                }
            }
    }
}

struct TabContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Trip.startDate, order: .reverse) private var trips: [Trip]
    
    @Binding var selectedTab: Int
    @State private var selectedTrip: Trip?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    NavigationStack {
                        HomeScreen(selectedTab: $selectedTab)
                    }
                case 1:
                    if !trips.isEmpty {
                        NavigationStack {
                            TripMapScreen(trips: trips, selectedTab: $selectedTab)
                        }
                    } else {
                        EmptyMapView(selectedTab: $selectedTab)
                    }
                case 2:
                    if !trips.isEmpty {
                        NavigationStack {
                            if trips.count == 1 {
                                JournalScreen(trip: trips[0], selectedTab: $selectedTab)
                            } else {
                                TripSelectionScreen(
                                    trips: trips,
                                    selectedTab: $selectedTab
                                )
                            }
                        }
                    } else {
                        EmptyJournalView(selectedTab: $selectedTab)
                    }
                default:
                    NavigationStack {
                        HomeScreen(selectedTab: $selectedTab)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            BottomNavigationBar(selectedTab: $selectedTab)
        }
    }
}

struct TripSelectionScreen: View {
    let trips: [Trip]
    @Binding var selectedTab: Int
    @State private var selectedTrip: Trip?
    
    var body: some View {
        List(trips) { trip in
            Button {
                selectedTrip = trip
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(trip.name)
                            .font(.headline)
                        Text("\(trip.journalEntries.count) entries")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Select Trip")
        .navigationDestination(item: $selectedTrip) { trip in
            JournalScreen(trip: trip, selectedTab: $selectedTab)
    
        }
    }
}

struct EmptyMapView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "map")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .opacity(0.7)
            
            Text("No Trips Yet")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 16)
            
            Text("Create your first trip to see it on the map")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 8)
            
            Spacer()
        }
        .padding(.bottom, 100)
    }
}

struct EmptyJournalView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .opacity(0.7)
            
            Text("No Trips Yet")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 16)
            
            Text("Create your first trip to start your journal")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 8)
            
            Spacer()
        }
        .padding(.bottom, 100)
    }
}

#Preview {
    MainAppView()
        .modelContainer(for: [Trip.self, JournalEntry.self], inMemory: true)
}
