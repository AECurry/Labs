//
//  Student.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - User Role Enum
/// This file defines what a "user" is in the app - either a student or teacher.
/// It stores their basic info like name and email, generates their initials for profile pictures, and includes sample classroom data for testing. 
/// Determines access levels and available features
enum UserRole {
    case teacher    // Instructor with grading and management capabilities
    case student    // Learner with assignment submission and progress tracking
}

// MARK: - Student Model
/// Represents a user in the system with personal and academic information
/// Used for authentication, profile display, and role-based access
struct Student: Identifiable, Hashable {
    // MARK: - Core Properties
    let id = UUID()                    // Unique identifier for user tracking
    let name: String                   // Full name of the student or teacher
    let role: UserRole                 // Determines permissions and view access
    let email: String                  // Contact email and login identifier
    let profileImageName: String?      // Optional profile picture filename
    let password: String               // Login credential - placeholder for demo only
    
    // MARK: - Computed Properties
    /// Generates initials from full name for avatar fallback
    /// Example: "John Smith" becomes "JS"
    var initials: String {
        name.split(separator: " ").map { String($0.prefix(1)) }.joined()
    }
    
    /// Extracts first name for personalized greetings
    /// Example: "John Smith" becomes "John"
    var firstName: String {
        name.components(separatedBy: " ").first ?? name
    }
    
    // MARK: - Hashable Conformance
    /// Enables using Student objects in sets and as dictionary keys
    /// Uses the unique ID for consistent hashing
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Compares students by their unique identifier
    /// Ensures two students are considered equal only if they have the same ID
    static func == (lhs: Student, rhs: Student) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Demo Students Data
extension Student {
    /// Sample student data for development, testing, and previews
    /// Represents a typical classroom of iOS development students
    static let demoStudents = [
        Student(
            name: "Ann-Elaine Curry",
            role: UserRole.student,  // Explicitly specify UserRole.student
            email: "ann.curry3121@stu.mtec.edu",
            profileImageName: String?.none,  // Explicitly specify String?.none instead of nil
            password: "qeswiq-cuscev-4Hotsa"
        ),Student(
            name: "Katy Hoffman",
            role: UserRole.student,  // Explicitly specify UserRole.student
            email: "khoffman@student.mtec.edu",
            profileImageName: String?.none,  // Explicitly specify String?.none instead of nil
            password: "password123"
        ),
        Student(
            name: "Lester Wyatt",
            role: UserRole.student,  // Explicitly specify UserRole.student
            email: "lwyatt@student.mtec.edu",
            profileImageName: String?.none,  // Explicitly specify String?.none instead of nil
            password: "password123"
        ),
        Student(
            name: "Tate Oakland",
            role: UserRole.student,  // Explicitly specify UserRole.student
            email: "toakland@student.mtec.edu",
            profileImageName: String?.none,  // Explicitly specify String?.none instead of nil
            password: "password123"
        ),
        Student(
            name: "June Maxwell",
            role: UserRole.student,  // Explicitly specify UserRole.student
            email: "jmaxwell@student.mtec.edu",
            profileImageName: String?.none,  // Explicitly specify String?.none instead of nil
            password: "password123"
        ),
        Student(
            name: "Monroe Beckett",
            role: UserRole.student,  // Explicitly specify UserRole.student
            email: "mbeckett@student.mtec.edu",
            profileImageName: String?.none,  // Explicitly specify String?.none instead of nil
            password: "password123"
        ),
        Student(
            name: "Everlee Powell",
            role: UserRole.student,  // Explicitly specify UserRole.student
            email: "epowell@student.mtec.edu",
            profileImageName: String?.none,  // Explicitly specify String?.none instead of nil
            password: "password123"
        ),
        Student(
            name: "Sam McCaffery",
            role: UserRole.student,  // Explicitly specify UserRole.student
            email: "smccaffery@student.mtec.edu",
            profileImageName: String?.none,  // Explicitly specify String?.none instead of nil
            password: "password123"
        )
    ]
}
