//
//  ContentView.swift
//  AdvancedLayoutsAndGridsLab
//
//  Created by AnnElaine on 1/7/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ShoppingViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - SECTION 1: HATS (View-Aligned - One row)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Hats")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 24) {
                                ForEach(viewModel.hats) { hat in
                                    ClothingCardView(clothing: hat, width: 150)
                                        .frame(height: 180)
                                }
                            }
                            .scrollTargetLayout()
                            .padding(.horizontal, 24)
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .frame(height: 200)
                    }
                    
                    Spacer()
                        .frame(height: 24)
                    
                    
                    // MARK: - SECTION 2: SHIRTS (Free Scrolling - Two fixed rows)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Shirts")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(
                                rows: [
                                    GridItem(.fixed(140), spacing: 24),
                                    GridItem(.fixed(140), spacing: 24)
                                ],
                                spacing: 24
                            ) {
                                ForEach(viewModel.shirts) { shirt in
                                    ClothingCardView(clothing: shirt, width: 160)
                                        .frame(height: 140)
                                }
                            }
                            .scrollTargetLayout()
                            .padding(.horizontal, 24)
                        }
                        // NO .scrollTargetBehavior for FREE scrolling
                        .frame(height: 310)
                    }
                    
                    Spacer()
                        .frame(height: 24)
                    
                    // MARK: - SECTION 3: PANTS (Paging - 4 ADAPTIVE rows)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Pants")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 24)

                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(
                                rows: [
                                    GridItem(.adaptive(minimum: 110), spacing: 24),
                                    GridItem(.adaptive(minimum: 110), spacing: 24),
                                    GridItem(.adaptive(minimum: 110), spacing: 24),
                                    GridItem(.adaptive(minimum: 110), spacing: 24)
                                ],
                                spacing: 24
                            ) {
                                ForEach(viewModel.pants) { pant in
                                    ClothingCardView(clothing: pant, width: 160)
                                }
                            }
                            .scrollTargetLayout()
                            .padding(.horizontal, 24)
                        }
                        .scrollTargetBehavior(.paging)
                        .frame(height: 520)
                    }


                }
                .padding(.vertical, 24)
            }
            .navigationTitle("Clothing Store")
        }
    }
}

// Preview
#Preview {
    ContentView()
}
