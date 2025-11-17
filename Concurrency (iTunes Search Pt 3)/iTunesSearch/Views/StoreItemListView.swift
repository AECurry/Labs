//
//  StoreItemListView.swift
//  iTunesSearch
//
//  Created by AnnElaine on 11/14/25.
//

import SwiftUI

struct StoreItemListView: View {
    @State var viewModel = StoreItemListViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Media Type", selection: $viewModel.selectedMediaType) {
                    ForEach(MediaType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .top])

                TextField("Search...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.search)
                    .onSubmit {
                        viewModel.fetchMatchingItems()
                    }
                    .padding([.horizontal, .bottom])

                if viewModel.isLoading {
                    ProgressView("Searching...")
                        .padding()
                } else if viewModel.items.isEmpty {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "magnifyingglass",
                        description: Text("Search for \(viewModel.selectedMediaType.rawValue)")
                    )
                } else {
                    List(viewModel.items, id: \.self) { item in
                        ItemCellView(item: item) {
                            viewModel.fetchPreview(item: item)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("iTunes Search")
        }
    }
}

#Preview {
    StoreItemListView()
}
