//
//  AssignmentsViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import Foundation
import Observation
import SwiftData

// *Assignments ViewModel
/// Manages curriculum modules, assignment categories, and completion tracking
/// Provides reactive state for the assignments section
/// Integrates with APIController for fetching and updating real assignment data
/// Uses @Observable for SwiftUI state binding following MVVM architecture
@Observable
class AssignmentsViewModel {
    
    // *Core Properties
    var assignments: [Assignment] = []                     // All assignments fetched from API
    var selectedModule: CurriculumModule?                 // Currently selected module
    var selectedAssignmentType: AssignmentTypeSummary?    // Currently selected assignment type
    var isLoading = false                                 // Indicates whether data is being loaded
    var errorMessage: String?                             // Holds API or processing errors
    
    // *Load Assignments
    /// Fetches all assignments from the API and updates local state
    /// Handles authentication, API errors, and state updates on MainActor
    func loadAssignments() async {
        print("🚀 loadAssignments() called")
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
                print("✅ loadAssignments() finished")
            }
        }
        
        print("🔐 Checking authentication...")
        print("   isAuthenticated: \(APIController.shared.isAuthenticated)")
        print("   userSecret: \(APIController.shared.userSecret?.uuidString ?? "NIL")")
        
        guard APIController.shared.isAuthenticated else {
            print("❌ Not authenticated - returning early")
            await MainActor.run {
                errorMessage = "Please log in to access assignments"
            }
            return
        }
        
        print("✅ Authenticated - fetching assignments...")
        
        do {
            let apiAssignments = try await APIController.shared.fetchAllAssignments()
            
            // 🔍 DEBUG: Print what we're actually getting
            print("📦 API returned \(apiAssignments.count) assignments")
            if let first = apiAssignments.first {
                print("📝 Sample assignment:")
                print("   ID: \(first.id)")
                print("   Name: \(first.name)")
                print("   Type: \(first.assignmentType)")
                print("   Due Date: \(first.dueOn?.description ?? "NIL")")
                print("   Assigned On: \(first.assignedOn?.description ?? "NIL")")
                print("   Body preview: \(first.body?.prefix(100) ?? "NIL")")
            }
            
            let convertedAssignments = apiAssignments.map { Assignment(from: $0) }
            
            await MainActor.run {
                assignments = convertedAssignments
            }
            
        } catch {
            print("❌ Error fetching assignments: \(error)")
            await MainActor.run {
                errorMessage = handleAPIError(error)
            }
        }
    }
    
    // *Toggle Assignment Completion (API Only)
    /// Marks an assignment as complete or not started and updates the API
    /// Returns true if the operation succeeds
    /// Note: Assignment completion is now primarily managed by SwiftData
    /// This method is for API synchronization only
    func toggleAssignmentCompletion(_ assignment: Assignment) async -> Bool {
        print("🌐 Toggling assignment completion via API: \(assignment.title)")
        
        // Determine new progress state for API
        let newProgress = assignment.isCompleted ? "notStarted" : "complete"
        
        // Validate assignment ID can be converted to UUID
        guard let assignmentUUID = UUID(uuidString: assignment.assignmentID) else {
            print("❌ Invalid assignment identifier format: \(assignment.assignmentID)")
            await MainActor.run {
                errorMessage = "Invalid assignment identifier format"
            }
            return false
        }
        
        do {
            // Submit progress to API
            print("📡 Submitting progress to API: \(newProgress)")
            _ = try await APIController.shared.submitAssignmentProgress(
                assignmentID: assignmentUUID,
                progress: newProgress
            )
            
            print("✅ API progress update successful")
            return true
            
        } catch {
            print("❌ Error updating API: \(error)")
            await MainActor.run {
                errorMessage = handleAPIError(error)
            }
            return false
        }
    }
    
    // *Toggle Assignment Completion with SwiftData Support
    /// Comprehensive completion toggle that updates both SwiftData and API
    /// Primary method for handling assignment completion in the app
    /// Returns true if operation succeeds on both fronts (or at least SwiftData)
    func toggleAssignmentCompletion(_ assignment: Assignment, context: ModelContext? = nil) async -> Bool {
        print("🔄 Comprehensive toggle for: \(assignment.title)")
        
        // First update SwiftData if context is provided
        var swiftDataSuccess = true
        if let context = context {
            swiftDataSuccess = await toggleAssignmentInSwiftData(assignment, context: context)
        }
        
        // Then update API (secondary, for synchronization)
        let apiSuccess = await toggleAssignmentCompletion(assignment)
        
        // Return success if either operation succeeded
        // SwiftData success is prioritized since it's required for UI
        return swiftDataSuccess || apiSuccess
    }
    
    // *Toggle Assignment in SwiftData
    /// Updates assignment completion status in local SwiftData storage
    /// Primary method for persistent completion tracking
    private func toggleAssignmentInSwiftData(_ assignment: Assignment, context: ModelContext) async -> Bool {
        print("💾 Toggling assignment in SwiftData: \(assignment.title)")
        
        do {
            // Fetch all assignments to find the matching one
            let descriptor = FetchDescriptor<Assignment>()
            let allAssignments = try context.fetch(descriptor)
            
            // Find assignment by ID
            if let assignmentToUpdate = allAssignments.first(where: { $0.assignmentID == assignment.assignmentID }) {
                // Toggle completion date
                assignmentToUpdate.completionDate = assignmentToUpdate.isCompleted ? nil : Date()
                
                // Save to SwiftData
                try context.save()
                
                // Update local array reference
                await MainActor.run {
                    if let index = assignments.firstIndex(where: { $0.assignmentID == assignment.assignmentID }) {
                        assignments[index] = assignmentToUpdate
                    }
                }
                
                print("✅ SwiftData update successful: \(assignmentToUpdate.isCompleted)")
                return true
            } else {
                print("⚠️ Assignment not found in SwiftData: \(assignment.assignmentID)")
                return false
            }
        } catch {
            print("❌ Error updating SwiftData: \(error)")
            return false
        }
    }
    
    // *Error Handling
    /// Converts API or Swift errors into user-friendly messages
    private func handleAPIError(_ error: Error) -> String {
        if let apiError = error as? APIError {
            switch apiError {
            case .notAuthenticated:
                return "Please log in to access assignments"
            case .networkError:
                return "Network error. Please check your internet connection"
            case .serverError(let code):
                if code == 404 {
                    return "Assignment API endpoint is not available yet. Please try again later."
                }
                return "Server error (code: \(code)). Please try again."
            case .decodingError:
                return "Error processing data from server. Please contact support."
            case .unknown:
                return "An unexpected error occurred. Please try again."
            }
        }
        return "Failed to load assignments: \(error.localizedDescription)"
    }
    
    // *Assignment Filtering
    /// Returns assignments grouped by status: overdue, upcoming, completed
    func assignmentsByStatus() -> (overdue: [Assignment],
                                   upcoming: [Assignment],
                                   completed: [Assignment]) {
        let overdue = assignments.filter { $0.isOverdue }
        let completed = assignments.filter { $0.isCompleted }
        let upcoming = assignments.filter { !$0.isCompleted && !$0.isOverdue }
        
        return (overdue, upcoming, completed)
    }
    
    // *Selection Methods
    /// Sets the currently selected module and resets assignment type selection
    func selectModule(_ module: CurriculumModule) {
        selectedModule = module
        selectedAssignmentType = nil
    }
    
    /// Sets the currently selected assignment type
    func selectAssignmentType(_ assignmentType: AssignmentTypeSummary) {
        selectedAssignmentType = assignmentType
    }
    
    // *Computed Properties
    /// Total number of assignments loaded
    var totalAssignments: Int {
        assignments.count
    }
    
    /// Number of completed assignments
    var completedAssignments: Int {
        assignments.filter { $0.isCompleted }.count
    }
    
    /// Overall completion percentage (0.0 to 1.0)
    var overallCompletionPercentage: Double {
        guard totalAssignments > 0 else { return 0.0 }
        return Double(completedAssignments) / Double(totalAssignments)
    }
}
