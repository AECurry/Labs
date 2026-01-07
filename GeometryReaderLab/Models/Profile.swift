//
//  Profile.swift
//  GeometryReaderLab
//
//  Created by AnnElaine on 1/6/26.
//

import Foundation

// Profile Model
// Data structure representing a team member profile
// Conforms to Identifiable protocol for use in SwiftUI lists and grids
struct Profile: Identifiable {
    let id = UUID()                    // Unique identifier for SwiftUI diffing
    let name: String                   // Full name of team member
    let description: String            // Short professional role/title
    let detailedDescription: String    // Extended biography or detailed info
    let imageName: String             // SF Symbol name for profile image
}

// MARK: - Sample Data Extension
// Provides mock data for development, previews, and testing
extension Profile {
    static let sampleData: [Profile] = [
        Profile(
            name: "Alex Johnson",
            description: "iOS Developer",
            detailedDescription: "Passionate about SwiftUI and creating beautiful, responsive interfaces. Loves hiking and photography.",
            imageName: "person.crop.circle.fill"
        ),
        Profile(
            name: "Maria Garcia",
            description: "UI/UX Designer",
            detailedDescription: "Specializes in user-centered design with 5 years of experience in fintech apps.",
            imageName: "person.crop.square.fill"
        ),
        Profile(
            name: "David Chen",
            description: "Backend Engineer",
            detailedDescription: "Expert in distributed systems and cloud architecture. Enjoys playing chess.",
            imageName: "person.crop.rectangle.fill"
        ),
        Profile(
            name: "Sarah Miller",
            description: "Product Manager",
            detailedDescription: "Leads cross-functional teams to deliver innovative solutions. Avid reader and traveler.",
            imageName: "person.crop.artframe"
        ),
        Profile(
            name: "James Wilson",
            description: "Data Scientist",
            detailedDescription: "Machine learning specialist focusing on natural language processing.",
            imageName: "person.crop.circle.badge.checkmark"
        ),
        Profile(
            name: "Lisa Taylor",
            description: "QA Engineer",
            detailedDescription: "Ensures software quality with automated testing frameworks.",
            imageName: "person.crop.square.filled.and.at.rectangle"
        ),
        Profile(
            name: "Robert Kim",
            description: "DevOps Engineer",
            detailedDescription: "Builds and maintains CI/CD pipelines. Loves open source contributions.",
            imageName: "person.crop.rectangle.stack"
        ),
        Profile(
            name: "Emma Davis",
            description: "Frontend Developer",
            detailedDescription: "Creates responsive web applications using modern JavaScript frameworks.",
            imageName: "person.fill"
        )
    ]
}
