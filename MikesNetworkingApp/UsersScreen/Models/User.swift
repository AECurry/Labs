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
    let idInfo: UserID?
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

// MARK: - Name
struct Name: Codable, Hashable {
    let title: String
    let first: String
    let last: String
}

// MARK: - Picture
struct Picture: Codable, Hashable {
    let large: String
    let medium: String
    let thumbnail: String
}

// MARK: - Location
struct Location: Codable, Hashable {
    let street: Street?
    let city: String?
    let state: String?
    let country: String?
    let postcode: Postcode?
    
    var formattedAddress: String {
        var address = ""
        if let street = street {
            address += "\(street.number) \(street.name)"
        }
        if let city = city {
            address += ", \(city)"
        }
        if let state = state {
            address += ", \(state)"
        }
        if let country = country {
            address += "\n\(country)"
        }
        return address
    }
}

// MARK: - Street
struct Street: Codable, Hashable {
    let number: Int
    let name: String
}

// MARK: - Postcode (can be Int or String)
enum Postcode: Codable, Hashable {
    case int(Int)
    case string(String)
    
    var value: String {
        switch self {
        case .int(let int): return String(int)
        case .string(let string): return string
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            self = .string("")
        }
    }
}

// MARK: - Login
struct Login: Codable, Hashable {
    let uuid: String?
    let username: String?
    let password: String?
    let salt: String?
    let md5: String?
    let sha1: String?
    let sha256: String?
}

// MARK: - Registered
struct Registered: Codable, Hashable {
    let date: String?
    let age: Int?
}

// MARK: - Dob
struct Dob: Codable, Hashable {
    let date: String?
    let age: Int?
    
    var formattedDate: String {
        guard let dateString = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
}

// MARK: - ID
struct UserID: Codable, Hashable {
    let name: String?
    let value: String?
}

