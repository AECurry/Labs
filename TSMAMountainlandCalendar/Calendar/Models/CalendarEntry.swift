//
//  CalendarEntry.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import Foundation

// MARK: - Calendar Entry Model
/// Represents a single day in the academic calendar
/// Acts as a digital lesson plan containing all data for a specific date
/// Holds lesson details, assignments, and daily learning elements
struct CalendarEntry: Identifiable, Hashable {
    
    // MARK: - Core Properties
    let id: UUID                       // Unique identifier from API
    let date: Date                     // Date this entry represents
    let holiday: Bool                  // Indicates if the day is a holiday
    let dayID: String?                 // School day identifier (e.g., "TP17")
    let lessonName: String?            // Display name of the lesson
    let lessonID: UUID?                // Unique lesson identifier
    let mainObjective: String?         // Primary learning objective
    let readingDue: String?            // Reading assigned for the day
    let assignmentsDue: [Assignment]   // Assignments due today
    let newAssignments: [Assignment]   // Assignments introduced today
    let dailyCodeChallengeName: String? // Daily coding challenge title
    let wordOfTheDay: String?          // Vocabulary term for the day
    
    // MARK: - Computed Properties
    
    /// Indicates whether assignments are due today
    var hasAssignmentsDue: Bool {
        !assignmentsDue.isEmpty
    }
    
    /// Indicates whether new assignments are introduced today
    var hasNewAssignments: Bool {
        !newAssignments.isEmpty
    }
    
    /// Determines if this entry represents today
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    /// Indicates whether this day includes a lesson
    var hasLesson: Bool {
        !holiday && (lessonName != nil && !(lessonName?.isEmpty ?? true))
    }
    
    /// Formats the date for display
    /// Example: "Tuesday 11/17/2025"
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    /// Returns a user-friendly display name for the day
    var displayName: String {
        if holiday {
            return "Holiday"
        } else if let lessonName = lessonName, !lessonName.isEmpty {
            return lessonName
        } else {
            return "No Lesson"
        }
    }
}

// MARK: - Hashable Conformance
extension CalendarEntry {
    static func == (lhs: CalendarEntry, rhs: CalendarEntry) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - API Integration
extension CalendarEntry {
    
    /// Initializes a CalendarEntry from an API response
    /// Converts server data into the app’s internal model
    init(from dto: CalendarEntryResponseDTO) {
        self.id = dto.id
        self.date = dto.date
        self.holiday = dto.holiday
        self.dayID = dto.dayID
        self.lessonName = dto.lessonName
        self.lessonID = dto.lessonID
        self.mainObjective = dto.mainObjective
        self.readingDue = dto.readingDue
        self.dailyCodeChallengeName = dto.dailyCodeChallengeName
        self.wordOfTheDay = dto.wordOfTheDay
        
        // Convert assignment DTOs into Assignment models
        self.assignmentsDue = dto.assignmentsDue.map { Assignment(from: $0) }
        self.newAssignments = dto.newAssignments.map { Assignment(from: $0) }
    }
}

// MARK: - Placeholder Data
extension CalendarEntry {
    
    /// Sample calendar entries for previews and testing
    static var placeholders: [CalendarEntry] {
        let nov14 = createDate(year: 2025, month: 11, day: 14)
        let nov17 = createDate(year: 2025, month: 11, day: 17)
        let nov18 = createDate(year: 2025, month: 11, day: 18)
        let nov19 = createDate(year: 2025, month: 11, day: 19)
        let nov20 = createDate(year: 2025, month: 11, day: 20)
        
        // Shared lesson identifiers
        let lessonID14 = UUID(uuidString: "23DB24CD-51F5-48BB-AB70-9B1CD1429A8E") ?? UUID()
        let lessonID17 = UUID()
        let lessonID18 = UUID()
        let lessonID19 = UUID()
        let lessonID20 = UUID()
        
        return [
            // Full demo lesson (Nov 14)
            CalendarEntry(
                id: UUID(),
                date: nov14,
                holiday: false,
                dayID: "TT14",
                lessonName: "Pop-Up Feedback & Full Demo",
                lessonID: lessonID14,
                mainObjective: "Practice submitting feedback and demo the full Today/Calendar lesson view.",
                readingDue: "Design Patterns: Pop-up Interactions",
                assignmentsDue: [
                    Assignment(
                        assignmentID: "LAB14",
                        title: "Feedback Pop-up",
                        dueDate: nov14,
                        lessonID: "TT14",
                        assignmentType: .lab,
                        markdownDescription: "Implement and test the feedback pop-up for today's lesson.",
                        completionDate: nil,
                        assignedOn: nov14.addingTimeInterval(-86400 * 2),
                        faqs: []
                    )
                ],
                newAssignments: [
                    Assignment(
                        assignmentID: "PJ14",
                        title: "Showcase Full Demo",
                        dueDate: nov14.addingTimeInterval(86400 * 7),
                        lessonID: "TT14",
                        assignmentType: .project,
                        markdownDescription: "Demo all main and feedback components to instructor.",
                        completionDate: nil,
                        assignedOn: nov14,
                        faqs: []
                    )
                ],
                dailyCodeChallengeName: "Trigger and submit a demo feedback form.",
                wordOfTheDay: "Demo"
            ),
            CalendarEntry(
                id: UUID(),
                date: nov17,
                holiday: false,
                dayID: "A17",
                lessonName: "Intro to Variables",
                lessonID: lessonID17,
                mainObjective: "Learn Swift variables and data types.",
                readingDue: "Swift Programming: Chapter 1",
                assignmentsDue: [],
                newAssignments: [],
                dailyCodeChallengeName: "Create a Swift variable for your name.",
                wordOfTheDay: "Variable"
            ),
            CalendarEntry(
                id: UUID(),
                date: nov18,
                holiday: false,
                dayID: "A18",
                lessonName: "Control Flow",
                lessonID: lessonID18,
                mainObjective: "Learn if/else and loops.",
                readingDue: "Chapter 2: Control Flow",
                assignmentsDue: [],
                newAssignments: [],
                dailyCodeChallengeName: "Make a guessing game using a loop.",
                wordOfTheDay: "Loop"
            ),
            CalendarEntry(
                id: UUID(),
                date: nov19,
                holiday: false,
                dayID: "A19",
                lessonName: "Functions",
                lessonID: lessonID19,
                mainObjective: "Define and call functions.",
                readingDue: "Chapter 3: Functions",
                assignmentsDue: [],
                newAssignments: [],
                dailyCodeChallengeName: "Write a greeting function.",
                wordOfTheDay: "Function"
            ),
            CalendarEntry(
                id: UUID(),
                date: nov20,
                holiday: false,
                dayID: "A20",
                lessonName: "Project Practice",
                lessonID: lessonID20,
                mainObjective: "Practice building a full app.",
                readingDue: "Chapter 4: App Project",
                assignmentsDue: [],
                newAssignments: [],
                dailyCodeChallengeName: "Start your project.",
                wordOfTheDay: "Project"
            )
        ]
    }
    
    /// Returns today's calendar entry, if available
    static var today: CalendarEntry? {
        placeholders.first(where: { $0.isToday })
    }
    
    // MARK: - Helper Methods
    
    /// Creates a date using year, month, and day components
    /// Uses noon to avoid timezone-related issues
    private static func createDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        return Calendar.current.date(from: components) ?? Date()
    }
}
