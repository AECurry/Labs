//
//  AssignmentsViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import Foundation
import Observation

// MARK: - Assignments ViewModel
/// Manages curriculum modules, assignment categories, and completion tracking
/// Provides navigation state and assignment organization for the assignments section
/// Uses @Observable for reactive UI updates following MVVM architecture
/// Integrates with APIController for real assignment data from the server
@Observable
class AssignmentsViewModel {
    // MARK: - State Properties
    
    /// All assignments loaded from the API for the current cohort
    /// Contains complete assignment data with progress tracking and due dates
    /// Used for displaying assignments in lists and organizing by status
    var assignments: [Assignment] = []
    
    /// Currently selected curriculum module for navigation
    /// Used when drilling down into a specific course section
    var selectedModule: CurriculumModule?
    
    /// Currently selected assignment type within a module
    /// Used when viewing individual assignments in a category
    var selectedAssignmentType: AssignmentTypeSummary?
    
    /// Loading state indicator for asynchronous operations
    /// Controls UI display of progress indicators during API calls
    var isLoading = false
    
    /// Error message for display when operations fail
    /// Provides user-friendly error feedback for network or API issues
    var errorMessage: String?
    
    // MARK: - Data Loading
    
    /// Loads all assignments for the current cohort from the API
    /// Fetches comprehensive assignment data including progress and FAQs
    /// Implements proper error handling and loading state management
    func loadAssignments() async {
        // Set loading state
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Ensure loading state is reset regardless of success or failure
        // Uses defer block for guaranteed cleanup to maintain code robustness
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            // Fetch from API using standardized APIController service method
            let apiAssignments = try await APIController.shared.fetchAllAssignments()
            
            // Convert API DTO responses to internal Assignment models
            // Uses Assignment's from(dto:) initializer for consistent data transformation
            let convertedAssignments = apiAssignments.map { Assignment(from: $0) }
            
            // Update state on main thread for thread-safe UI updates
            await MainActor.run {
                assignments = convertedAssignments
            }
            
        } catch {
            // Handle API errors gracefully with user-friendly messages
            await MainActor.run {
                errorMessage = handleAPIError(error)
            }
        }
    }
    
    // MARK: - Assignment Progress Management
    
    /// Toggles assignment completion status via API with proper result handling
    /// Updates local state after successful API submission for immediate UI feedback
    /// - Parameter assignment: The assignment to toggle completion status for
    /// - Returns: Boolean indicating success (true) or failure (false) of the operation
    /// Implements robust error handling and state synchronization
    func toggleAssignmentCompletion(_ assignment: Assignment) async -> Bool {
        // Determine the new progress state based on current completion status
        // Supports three valid states: "notStarted", "inProgress", and "complete"
        let newProgress = assignment.isCompleted ? "notStarted" : "complete"
        
        // Validate assignment ID can be converted to UUID for API compatibility
        // Prevents API calls with invalid or malformed assignment identifiers
        guard let assignmentUUID = UUID(uuidString: assignment.assignmentID) else {
            await MainActor.run {
                errorMessage = "Invalid assignment identifier format"
            }
            return false
        }
        
        do {
            // Submit progress update to API and capture returned data
            // The API returns updated AssignmentResponseDTO with new progress state
            // The underscore (_) discards the unused return value intentionally
            // We update local state directly instead of using returned DTO
            _ = try await APIController.shared.submitAssignmentProgress(
                assignmentID: assignmentUUID,
                progress: newProgress
            )
            
            // Create updated local assignment with new completion status
            // Uses current date as completion timestamp for "complete" state
            // Sets completionDate to nil for "notStarted" state
            var updatedAssignment = assignment
            updatedAssignment.completionDate = (newProgress == "complete") ? Date() : nil
            
            // Update local assignments array on main thread
            // Maintains data consistency between server and client state
            await MainActor.run {
                if let index = assignments.firstIndex(where: { $0.assignmentID == assignment.assignmentID }) {
                    assignments[index] = updatedAssignment
                }
            }
            
            return true
            
        } catch {
            // Handle API errors with user-friendly messaging
            await MainActor.run {
                errorMessage = handleAPIError(error)
            }
            return false
        }
    }
    
    // MARK: - Error Handling Utility
    
    /// Converts raw API errors to user-friendly localized messages
    /// Provides appropriate messaging for different error types and HTTP status codes
    /// - Parameter error: The raw Error object from failed API operation
    /// - Returns: Localized string suitable for display in user interface
    private func handleAPIError(_ error: Error) -> String {
        if let apiError = error as? APIError {
            switch apiError {
            case .notAuthenticated:
                return "Please log in to access assignments"
            case .networkError:
                return "Network error. Please check your internet connection"
            case .serverError(let code):
                // Special handling for 404 errors during API development phase
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
    
    // MARK: - Assignment Organization Methods
    
    /// Organizes assignments by their current academic status for clear UI presentation
    /// Categorizes assignments into three logical groups: overdue, upcoming, and completed
    /// - Returns: Tuple containing three filtered arrays of Assignment objects
    ///   - overdue: Assignments past due date and not completed
    ///   - upcoming: Assignments not due yet and not completed
    ///   - completed: Assignments marked as complete by the user
    /// Uses computed properties on Assignment model for clean, declarative filtering
    func assignmentsByStatus() -> (overdue: [Assignment],
                                   upcoming: [Assignment],
                                   completed: [Assignment]) {
        // Filter assignments using computed properties for clean, readable code
        // The 'isOverdue' property handles date comparison logic internally
        let overdue = assignments.filter { $0.isOverdue }
        
        // The 'isCompleted' property checks for non-nil completionDate
        let completed = assignments.filter { $0.isCompleted }
        
        // Combine both conditions for upcoming assignments (not complete, not overdue)
        let upcoming = assignments.filter { !$0.isCompleted && !$0.isOverdue }
        
        return (overdue, upcoming, completed)
    }
    
    // MARK: - Navigation State Management
    
    /// Selects a curriculum module for detailed view navigation
    /// Updates navigation state and clears any previous assignment type selection
    /// - Parameter module: The curriculum module to select for detailed viewing
    func selectModule(_ module: CurriculumModule) {
        selectedModule = module
        selectedAssignmentType = nil // Clear assignment type selection
    }
    
    /// Selects an assignment type for individual assignment list view
    /// Updates navigation state for drilling down into specific assignment categories
    /// - Parameter assignmentType: The assignment category to select for detailed viewing
    func selectAssignmentType(_ assignmentType: AssignmentTypeSummary) {
        selectedAssignmentType = assignmentType
    }
    
    // MARK: - Computed Properties for Data Analysis
    
    /// Returns total number of assignments loaded from API
    /// Provides quick count for UI displays and progress calculations
    var totalAssignments: Int {
        assignments.count
    }
    
    /// Returns total number of completed assignments
    /// Used for progress tracking and completion statistics
    var completedAssignments: Int {
        assignments.filter { $0.isCompleted }.count
    }
    
    /// Calculates overall completion percentage across all assignments
    /// Returns value between 0.0 (no assignments complete) and 1.0 (all assignments complete)
    /// Used for progress visualization and completion tracking UI elements
    var overallCompletionPercentage: Double {
        guard totalAssignments > 0 else { return 0.0 }
        return Double(completedAssignments) / Double(totalAssignments)
    }
}
