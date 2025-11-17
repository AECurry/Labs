//
//  ContentView.swift
//  iTunesSearchLab
//
//  Created by AnnElaine Curry on 11/3/25.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = StoreItemListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Media Type", selection: $viewModel.selectedMediaType) {
                    ForEach(MediaType.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .top])
                
                TextField("Search...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.search)
                    .onSubmit { viewModel.fetchMatchingItems() }
                    .padding([.horizontal, .bottom])

                List(viewModel.items, id: \.self) { item in
                    ItemCellView(item: item) {
                        viewModel.fetchPreview(item: item)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("iTunes Search")
            .onAppear { viewModel.fetchMatchingItems() }
        }
    }
}

#Preview {
    ContentView()
}
