//
//  RepresentativeDataModel.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/23/25.
//

import Foundation

// MARK: - API Response Model
struct RepresentativeAPIResponse: Codable {
    let results: [Representative]
}

// MARK: - Representative Model
struct Representative: Identifiable, Codable, Equatable {
    var id: String { name + district }
    
    let name: String
    let party: String
    let state: String
    let district: String
    let phone: String
    let office: String
    let link: String
    
    // Computed property for display
    var displayTitle: String {
        if district.isEmpty || district == "Senate" {
            return "Senator"
        } else {
            return "Representative - District \(district)"
        }
    }
}

// MARK: - Representative State
struct RepresentativeState {
    var representatives: [Representative] = []
    var isLoading = false
    var error: String?
    var searchedZipCode: String = ""
    var hasSearched = false
    
    var isEmpty: Bool {
        representatives.isEmpty && hasSearched && !isLoading
    }
}
