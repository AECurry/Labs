//
//  Models.swift
//  Meet My Family Project
//
//  Created by AnnElaine on 10/9/25.
//

import SwiftUI
import Observation

@Observable
class FamilyData {
    var familyMembers: [FamilyMember] = []
    
    init() {
        self.familyMembers = FamilyMember.createSampleFamily()
    }
    
    func markAsViewed(_ member: FamilyMember) {
        if let index = familyMembers.firstIndex(where: { $0.id == member.id }) {
            familyMembers[index].hasBeenViewed = true
        }
    }
    
    func addNewFamilyMember() {
        let newMember = FamilyMember(
            name: "",
            assetPhotoName: nil,  // Remove imageName, use assetPhotoName instead
            relationship: "",
            bio: "",
            age: 0,
            hobbies: []
        )
        familyMembers.append(newMember)
    }
    
    func updateMember(_ updatedMember: FamilyMember) {
        if let index = familyMembers.firstIndex(where: { $0.id == updatedMember.id }) {
            familyMembers[index] = updatedMember
        }
    }
}

struct FamilyMember: Identifiable {
    let id = UUID()
    var name: String
    var assetPhotoName: String?
    var relationship: String
    var bio: String
    var age: Int
    var hobbies: [String]
    var hasBeenViewed: Bool = false
    
    static func createSampleFamily() -> [FamilyMember] {
        return [
            FamilyMember(
                name: "Ann",
                assetPhotoName: "Ann",
                relationship: "Me",
                bio: "Loves gardening and cooking amazing family meals. Always there with a warm hug and great advice.",
                age: 48,
                hobbies: ["Gardening", "Cooking", "Reading", "Yoga"]
            ),
            FamilyMember(
                name: "Sara",
                assetPhotoName: "Sara",
                relationship: "Sister",
                bio: "Enjoys her free time where she gets to make a craft, play piano, swim in her pool, or cook with the vegetables from her garden",
                age: 46,
                hobbies: ["Drawing", "Piano", "Soccer", "Baking"]
            ),
            FamilyMember(
                name: "Joseph",
                assetPhotoName: "Joe",
                relationship: "Brother",
                bio: "High school student who loves art and music. Always has her headphones on and sketchbook handy.",
                age: 41,
                hobbies: ["Pickleball", "Long Board", "Hiking", "Paddleboard"]
            ),
            FamilyMember(
                name: "Lincoln",
                assetPhotoName: "Lincoln",
                relationship: "Nephew",
                bio: "Loves video games and building LEGO creations. Future engineer in the making!",
                age: 12,
                hobbies: ["Gaming", "LEGO", "Basketball", "Science"]
            )
        ]
    }
}
