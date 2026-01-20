//
//  NewTripScreen.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/15/26.
//

import SwiftUI
import SwiftData

struct NewTripScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Binding var selectedTab: Int
    
    @StateObject private var viewModel = TripViewModel()
    
    @State private var navigateToPlacePin = false
    @State private var createdTrip: Trip?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                
                Image(systemName: "airplane.departure")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                VStack(spacing: 8) {
                    Text("Name Your Adventure")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Give your trip a memorable name")
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Enter trip name", text: $viewModel.tripName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button {
                    // Set the modelContext before creating trip
                    viewModel.modelContext = modelContext
                    
                    if let trip = viewModel.createTrip() {
                        createdTrip = trip
                        navigateToPlacePin = true
                    }
                } label: {
                    Text("Next")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.tripName.isEmpty ? .gray : .blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(viewModel.tripName.isEmpty)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .padding()
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .navigationDestination(isPresented: $navigateToPlacePin) {
                if let trip = createdTrip {
                    PlacePinScreen(
                        trip: trip,
                        onComplete: {
                            selectedTab = 2
                            dismiss()
                        }
                    )
                    .environment(\.modelContext, modelContext)
                }
            }
        }
    }
}

#Preview {
    NewTripScreen(selectedTab: .constant(0))
        .modelContainer(for: [Trip.self, JournalEntry.self], inMemory: true)
}
