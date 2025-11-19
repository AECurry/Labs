//
//  iTunesListView.swift
//  iTunesSearch
//
//  Created by AnnElaine on 11/14/25.
//

import SwiftUI

// MARK: - Main iTunes List View
// Primary view for displaying and searching iTunes store items
struct iTunesListView: View {
    // State property that holds the view model managing the data and business logic
    @State var viewModel = StoreItemListViewModel()
    
    // The main body of the view that defines its content and layout
    var body: some View {
        // NavigationStack provides navigation capabilities and a navigation bar
        NavigationStack {
            ZStack {
                // Realistic bubbles background - fills entire screen
                BubblesBackground()
                
                // Main content stack arranged vertically
                VStack(spacing: 0) {
                    // MARK: - Fixed Header Section
                    VStack(spacing: 0) {
                        // Custom title with full control over size and positioning
                        Text("iTunes Search")
                            .font(.system(size: 36, weight: .bold))
                            .frame(alignment: .leading)
                            .padding(.leading, 48)
                            .padding(.top, 32)
                            .padding(.bottom, 24)
                        
                        // MARK: - Media Type Picker (Compact Size)
                        Picker("Media Type", selection: $viewModel.selectedMediaType) {
                            ForEach(MediaType.allCases, id: \.self) { type in
                                Text(type.rawValue.capitalized)
                                    .font(.system(size: 14, weight: .medium))
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .scaleEffect(0.9)
                        
                        // MARK: - Search Bar (Full Width to Match Navigation Bar)
                        HStack {
                            TextField("Search...", text: $viewModel.searchText)
                                .textFieldStyle(.plain)
                                .submitLabel(.search)
                                .onSubmit {
                                    viewModel.fetchMatchingItems()
                                }
                                .font(.system(size: 16))
                                .padding(10)
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 20) // Add bottom padding to separate from content
                        .frame(maxWidth: 353)
                    }
                    .background(Color.clear)
                    
                    // MARK: - Content Area (Now separate from fixed header)
                    Group {
                        if viewModel.isLoading {
                            // Enhanced loading state with proper spacing
                            VStack {
                                Spacer()
                                ProgressView("Searching...")
                                    .scaleEffect(1.2)
                                    .padding()
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        } else if viewModel.items.isEmpty {
                            // Empty state
                            VStack {
                                Spacer()
                                ContentUnavailableView(
                                    "No Results",
                                    systemImage: "magnifyingglass",
                                    description: Text("Search for \(viewModel.selectedMediaType.rawValue)")
                                )
                                Spacer()
                            }
                            .padding()
                            
                        } else {
                            // Results list
                            List(viewModel.items, id: \.self) { item in
                                ItemCellView(item: item) {
                                    viewModel.fetchPreview(item: item)
                                }
                                .listRowBackground(Color.clear)
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                        }
                    }
                    .transition(.opacity) // Smooth transition between states
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.items.isEmpty)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Preview
// Preview for Xcode canvas - shows how the view looks during development
#Preview {
    iTunesListView()
}
