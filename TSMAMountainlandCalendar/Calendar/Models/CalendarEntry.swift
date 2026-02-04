//
//  CalendarEntry.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import Foundation

// MARK: - Calendar Entry Model
/// Represents a single day in the academic calendar
/// Defines what a "school day" looks like in the app - it's like a digital lesson plan that contains everything happening on a specific date
/// Follows Single Responsibility Principle - only handles calendar data

struct CalendarEntry: Identifiable, Hashable {
    // MARK: - Core Properties
    let id = UUID()                    // Unique identifier for SwiftUI lists
    let date: Date                     // The instructional date this entry represents
    let lessonID: String               // Unique lesson identifier (e.g., "TP17")
    let lessonName: String             // Display name of the day's lesson
    let mainObjective: String          // Primary learning goal for the day
    let readingDue: String             // Reading assignments due for this lesson
    let assignmentsDue: [Assignment]   // Assignments that must be submitted today
    let newAssignments: [Assignment]   // New assignments introduced today
    let codeChallenge: String          // Daily coding challenge title
    let wordOfTheDay: String           // Vocabulary term for the day
    let instructor: String             // Teacher leading the lesson
    let lessonOutline: String          // Detailed lesson plan in markdown format
    
    // MARK: - Computed Properties
    /// Checks if any assignments are due today
    /// Follows SOLID's Open/Closed principle - extendable without modification
    var hasAssignmentsDue: Bool {
        !assignmentsDue.isEmpty
    }
    
    /// Checks if new assignments are being introduced today
    var hasNewAssignments: Bool {
        !newAssignments.isEmpty
    }
    
    /// Determines if this calendar entry represents the current date
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    /// Formats the date for user-friendly display
    /// Example: "Tuesday 11/17/2025"
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM/dd/yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Placeholder Data
extension CalendarEntry {
    /// Sample calendar entries for development, testing, and previews
    /// Represents a week of iOS development lessons with full academic content
    /// Nov 14 (full demo), Nov 17–20 mock

    static var placeholders: [CalendarEntry] {
        let nov14 = createDate(year: 2025, month: 11, day: 14)
        let nov17 = createDate(year: 2025, month: 11, day: 17)
        let nov18 = createDate(year: 2025, month: 11, day: 18)
        let nov19 = createDate(year: 2025, month: 11, day: 19)
        let nov20 = createDate(year: 2025, month: 11, day: 20)
        
        return [
            // FULL DEMO LESSON FOR TODAY (Nov 14)
            CalendarEntry(
                date: nov14,
                lessonID: "TT14",
                lessonName: "Pop-Up Feedback & Full Demo",
                mainObjective: "Practice submitting feedback and demo the full Today/Calendar lesson view.",
                readingDue: "Design Patterns: Pop-up Interactions",
                assignmentsDue: [
                    Assignment(
                        assignmentID: "Lab14",
                        title: "Feedback Pop-up",
                        dueDate: nov14,
                        lessonID: "TT14",
                        assignmentType: .lab,
                        markdownDescription: "Implement and test the feedback pop-up for today's lesson.",
                        completionDate: nil
                    )
                ],
                newAssignments: [
                    Assignment(
                        assignmentID: "PJ14",
                        title: "Showcase Full Demo",
                        dueDate: nov14.addingTimeInterval(86400*7),
                        lessonID: "TT14",
                        assignmentType: .project,
                        markdownDescription: "Demo all main and feedback components to instructor.",
                        completionDate: nil
                    )
                ],
                codeChallenge: "Trigger and submit a demo feedback form.",
                wordOfTheDay: "Demo",
                instructor: "Ms. Taylor",
                lessonOutline: "Use Today and Calendar view to show full card stack, assignments, and feedback pop-up."
            ),
            CalendarEntry(
                date: nov17,
                lessonID: "A17",
                lessonName: "Intro to Variables",
                mainObjective: "Learn Swift variables and data types.",
                readingDue: "Swift Programming: Chapter 1",
                assignmentsDue: [],
                newAssignments: [],
                codeChallenge: "Create a Swift variable for your name.",
                wordOfTheDay: "Variable",
                instructor: "Ms. Taylor",
                lessonOutline: "Intro, Variables, Practice"
            ),
            CalendarEntry(
                date: nov18,
                lessonID: "A18",
                lessonName: "Control Flow",
                mainObjective: "Learn if/else and loops.",
                readingDue: "Chapter 2: Control Flow",
                assignmentsDue: [],
                newAssignments: [],
                codeChallenge: "Make a guessing game using a loop.",
                wordOfTheDay: "Loop",
                instructor: "Ms. Taylor",
                lessonOutline: "Conditionals, Loops, Practice"
            ),
            CalendarEntry(
                date: nov19,
                lessonID: "A19",
                lessonName: "Functions",
                mainObjective: "Define and call functions.",
                readingDue: "Chapter 3: Functions",
                assignmentsDue: [],
                newAssignments: [],
                codeChallenge: "Write a greeting function.",
                wordOfTheDay: "Function",
                instructor: "Ms. Taylor",
                lessonOutline: "Functions, Return Values"
            ),
            CalendarEntry(
                date: nov20,
                lessonID: "A20",
                lessonName: "Project Practice",
                mainObjective: "Practice building a full app.",
                readingDue: "Chapter 4: App Project",
                assignmentsDue: [],
                newAssignments: [],
                codeChallenge: "Start your project.",
                wordOfTheDay: "Project",
                instructor: "Ms. Taylor",
                lessonOutline: "Project Review"
            )
        ]
    }
    
    /// Returns today's calendar entry or nil if today isn't found
    static var today: CalendarEntry? {
        placeholders.first(where: { $0.isToday })
    }
    
    // MARK: - Helper Function
    /// Creates a date from year, month, and day components
    /// Uses noon to avoid timezone-related date calculation issues
    private static func createDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12 // Set to noon to avoid timezone issues
        return Calendar.current.date(from: components) ?? Date()
    }
}

// MARK: - API Integration Extension
extension CalendarEntry {
    /// Initializes a CalendarEntry model from an API response DTO
    /// Converts server-side data transfer objects to internal application models
    /// Handles optional values with sensible defaults for missing or null data
    /// - Parameter dto: CalendarEntryResponseDTO containing raw API response data
    init(from dto: CalendarEntryResponseDTO) {
        self.init(
            // Required date field - always present in API response
            date: dto.date,
            
            // Lesson identifier with fallback for missing or holiday entries
            lessonID: dto.lessonID?.uuidString ?? "Unknown",
            
            // Lesson name with default for days without scheduled instruction
            lessonName: dto.lessonName ?? "No Lesson",
            
            // Main objective with empty string fallback for holidays or missing data
            mainObjective: dto.mainObjective ?? "",
            
            // Reading assignments with empty string fallback
            readingDue: dto.readingDue ?? "",
            
            // Convert API assignment DTOs to internal Assignment models
            assignmentsDue: Assignment.array(from: dto.assignmentsDue),
            
            // Convert API assignment DTOs to internal Assignment models for new assignments
            newAssignments: Assignment.array(from: dto.newAssignments),
            
            // Daily code challenge name with empty string fallback
            codeChallenge: dto.dailyCodeChallengeName ?? "",
            
            // Vocabulary word of the day with empty string fallback
            wordOfTheDay: dto.wordOfTheDay ?? "",
            
            // Placeholder instructor name (TODO: Populate from API if available)
            instructor: "Instructor",
            
            // Placeholder lesson outline (TODO: Fetch separately if needed)
            lessonOutline: ""
        )
    }
}
