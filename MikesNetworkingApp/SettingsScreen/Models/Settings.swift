//
//  Settings.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import Foundation

struct Settings: Codable {
    var numberOfUsers: Int = 10
    var showGender: Bool = true
    var showLocation: Bool = true
    var showEmail: Bool = true
    var showLogin: Bool = false
    var showRegistered: Bool = false
    var showDob: Bool = true
    var showPhone: Bool = true
    var showCell: Bool = false
    var showID: Bool = false
    var showNationality: Bool = true

    
    var selectedFields: [String] {
        var fields = ["name", "picture"]
        if showGender      { fields.append("gender") }
        if showLocation    { fields.append("location") }
        if showEmail       { fields.append("email") }
        if showLogin       { fields.append("login") }
        if showRegistered  { fields.append("registered") }
        if showDob         { fields.append("dob") }
        if showPhone       { fields.append("phone") }
        if showCell        { fields.append("cell") }
        if showID          { fields.append("id") }
        if showNationality { fields.append("nat") }
        return fields
    }
}

