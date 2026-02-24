//
//  User.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import Foundation

struct UserResponse: Codable {
    let results: [User]
}

struct User: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: Name
    let picture: Picture
    let gender: String?
    let location: Location?
    let email: String?
    let login: Login?
    let registered: Registered?
    let dob: Dob?
    let phone: String?
    let cell: String?
    let idInfo: ID?
    let nat: String?
    
    enum CodingKeys: String, CodingKey {
        case name, picture, gender, location, email, login, registered, dob, phone, cell, nat
        case idInfo = "id"
    }
    
    var fullName: String {
        return "\(name.title) \(name.first) \(name.last)"
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

// Supporting models remain the same as before...
