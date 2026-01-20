//
//  SetUpPinScreen.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/15/26.
//

import SwiftUI
import MapKit
import PhotosUI
import SwiftData

struct SetUpPinScreen: View {
    let trip: Trip
    let coordinate: CLLocationCoordinate2D
    let onComplete: () -> Void
    var entryToEdit: JournalEntry? = nil  // NEW: Optional entry for edit mode
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel = JournalEntryViewModel()
    
    // Track if we're in edit mode
    private var isEditMode: Bool {
        entryToEdit != nil
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text(isEditMode ? "Edit Journal Entry" : "Complete Your Entry")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(isEditMode ? "Update your location details" : "Add details to your stop")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 24)
                
                // Show map for context
                if isEditMode {
                    Map {
                        Marker(viewModel.locationName.isEmpty ? "Location" : viewModel.locationName,
                               coordinate: coordinate)
                    }
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location Name")
                            .font(.headline)
                        
                        TextField("Enter location name", text: $viewModel.locationName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    DatePicker(
                        "Date",
                        selection: $viewModel.entryDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        TextEditor(text: $viewModel.entryDescription)
                            .frame(height: 150)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Photos")
                            .font(.headline)
                        
                        PhotosPicker(
                            selection: $viewModel.selectedPhotos,
                            maxSelectionCount: 10,
                            matching: .images
                        ) {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.title2)
                                Text("Add Photos")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                        }
                        .onChange(of: viewModel.selectedPhotos) { oldValue, newValue in
                            Task {
                                await viewModel.loadPhotos()
                            }
                        }
                        
                        if !viewModel.photoImages.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.photoImages.indices, id: \.self) { index in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: viewModel.photoImages[index])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                            
                                            Button {
                                                viewModel.removePhoto(at: index)
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.red)
                                                    .background(Circle().fill(.white))
                                            }
                                            .offset(x: 8, y: -8)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.bottom, 24)
                
                HStack(spacing: 16) {
                    if isEditMode {
                        Button(role: .destructive) {
                            deleteEntry()
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    
                    Button {
                        isEditMode ? updateEntry() : saveEntry()
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(isEditMode ? "Save Changes" : "Save Entry")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(viewModel.locationName.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.locationName.isEmpty)
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
            }
            .padding(.bottom, 40)
        }
        .navigationTitle(isEditMode ? "Edit Entry" : "Entry Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.pinCoordinate = coordinate
            
            // If editing, load existing data
            if let entry = entryToEdit {
                viewModel.loadEntryData(entry)
            }
        }
    }
    
    private func saveEntry() {
        print("Saving new entry for trip: \(trip.name)")
        
        if let entry = viewModel.createEntry(for: trip) {
            print("✅ Entry saved: \(entry.name)")
            onComplete()
        } else if let error = viewModel.errorMessage {
            print("❌ Failed to save entry: \(error)")
        }
    }
    
    private func updateEntry() {
        guard let entry = entryToEdit else { return }
        
        viewModel.updateEntry(entry)
        print("✅ Entry updated: \(entry.name)")
        onComplete()
    }
    
    private func deleteEntry() {
        guard let entry = entryToEdit else { return }
        
        withAnimation {
            if let index = trip.journalEntries.firstIndex(where: { $0.id == entry.id }) {
                trip.journalEntries.remove(at: index)
            }
            
            modelContext.delete(entry)
            modelContext.safeSave()
            print("🗑️ Entry deleted: \(entry.name)")
            onComplete()
        }
    }
}

#Preview("Create Mode") {
    NavigationStack {
        SetUpPinScreen(
            trip: Trip(name: "Summer Vacation", startDate: Date()),
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            onComplete: {}
        )
    }
    .modelContainer(for: [Trip.self, JournalEntry.self], inMemory: true)
}

#Preview("Edit Mode") {
    let container = try! ModelContainer(for: Trip.self, JournalEntry.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let trip = Trip(name: "Summer Vacation", startDate: Date())
    let entry = JournalEntry(
        name: "Nashville",
        entryDescription: "Never been to Nashville and I can't wait to try their famous BBQ",
        date: Date(),
        photos: [UIImage(systemName: "photo")!],
        coordinate: CLLocationCoordinate2D(latitude: 36.1627, longitude: -86.7816)
    )
    
    return NavigationStack {
        SetUpPinScreen(
            trip: trip,
            coordinate: entry.coordinate,
            onComplete: {},
            entryToEdit: entry
        )
    }
    .modelContainer(container)
}
