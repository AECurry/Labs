//
//  JournalScreen.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/12/26.
//

import SwiftUI
import SwiftData
import MapKit

struct JournalScreen: View {
    let trip: Trip
    @Binding var selectedTab: Int
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingAddEntry = false
    @State private var showingEditTrip = false
    @State private var showingDeleteTripAlert = false
    @State private var showingRenameTrip = false
    @State private var newTripName = ""
    
    private var sortedEntries: [JournalEntry] {
        trip.journalEntries.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                entriesSection
            }
            .padding(.bottom, 88)
        }
        .navigationTitle("Journal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Add button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddEntry = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            // Navigate to PlacePinScreen to add a new entry
            NavigationStack {
                PlacePinScreen(
                    trip: trip,
                    onComplete: {
                        showingAddEntry = false
                        selectedTab = 2 // Stay on Journal tab
                    }
                )
                .environment(\.modelContext, modelContext)
            }
        }
        // NEW: Simple rename trip alert
        .alert("Rename Trip", isPresented: $showingRenameTrip) {
            TextField("Trip Name", text: $newTripName)
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                trip.name = newTripName
                modelContext.safeSave()
            }
        } message: {
            Text("Enter a new name for your trip.")
        }
        // Delete Trip alert
        .alert("Delete Trip", isPresented: $showingDeleteTripAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteTrip()
            }
        } message: {
            Text("Are you sure you want to delete '\(trip.name)'? This will also delete all \(trip.journalEntries.count) journal entries. This action cannot be undone.")
        }
    }
    
    private var entriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Journal Entries")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(trip.journalEntries.count)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.top)
            
            if trip.journalEntries.isEmpty {
                JournalEmptyView()
                    .padding(.horizontal)
            } else {
                ForEach(sortedEntries) { entry in
                    NavigationLink {
                        JournalEntryDetailView(entry: entry, trip: trip)
                    } label: {
                        JournalEntryCard(entry: entry)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        // Delete button
                        Button(role: .destructive) {
                            deleteEntry(entry)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }
    
    private func deleteEntry(_ entry: JournalEntry) {
        withAnimation {
            if let index = trip.journalEntries.firstIndex(where: { $0.id == entry.id }) {
                trip.journalEntries.remove(at: index)
            }
            
            modelContext.delete(entry)
            
            do {
                try modelContext.save()
                print("Entry deleted and saved")
            } catch {
                print("Failed to delete entry: \(error)")
            }
        }
    }
    
    private func deleteTrip() {
        withAnimation {
            modelContext.delete(trip)
            modelContext.safeSave()
            selectedTab = 0 // Go to home tab
        }
    }
}

// MARK: - Journal Entry Card (Horizontal Layout)
struct JournalEntryCard: View {
    let entry: JournalEntry
    
    var body: some View {
        HStack(spacing: 12) {
            if let firstImage = entry.uiImages.first {
                Image(uiImage: firstImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Empty Journal View
struct JournalEmptyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 60))
                .foregroundColor(.blue.opacity(0.7))
            
            VStack(spacing: 8) {
                Text("No Journal Entries Yet")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Tap + to add your first stop")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    let container = try! ModelContainer(for: Trip.self, JournalEntry.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let trip = Trip(name: "California Road Trip", startDate: Date())
    
    let sfImage = UIImage(systemName: "photo")!
    let yosemiteImage = UIImage(systemName: "leaf")!
    
    let entry1 = JournalEntry(
        name: "San Francisco",
        entryDescription: "Golden Gate Bridge and Fisherman's Wharf",
        date: Date().addingTimeInterval(-86400 * 2),
        photos: [sfImage, sfImage],
        coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    )
    
    let entry2 = JournalEntry(
        name: "Yosemite",
        entryDescription: "Hiked to Half Dome with amazing views",
        date: Date().addingTimeInterval(-86400 * 1),
        photos: [yosemiteImage],
        coordinate: CLLocationCoordinate2D(latitude: 37.8651, longitude: -119.5383)
    )
    
    trip.journalEntries = [entry1, entry2]
    
    return NavigationStack {
        JournalScreen(trip: trip, selectedTab: .constant(2))
    }
    .modelContainer(container)
}
