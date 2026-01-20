//
//  JournalEntryDetailView.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/20/26.
//

import SwiftUI
import MapKit

struct JournalEntryDetailView: View {
    let entry: JournalEntry
    let trip: Trip
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingEditSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Map {
                    Marker(entry.name, coordinate: entry.coordinate)
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(entry.date.formatted(date: .long, time: .omitted))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if !entry.entryDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            
                            Text(entry.entryDescription)
                                .font(.body)
                        }
                    }
                    
                    if !entry.photos.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Photos")
                                .font(.headline)
                            
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 12)
                            ], spacing: 12) {
                                ForEach(entry.uiImages.indices, id: \.self) { index in
                                    Image(uiImage: entry.uiImages[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Journal Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Edit button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingEditSheet = true
                } label: {
                    Text("Edit")
                        .fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                SetUpPinScreen(
                    trip: trip,
                    coordinate: entry.coordinate,
                    onComplete: {
                        dismiss() // Dismiss both sheets
                    },
                    entryToEdit: entry  // Pass entry for edit mode
                )
            }
            .environment(\.modelContext, modelContext)
        }
    }
}
