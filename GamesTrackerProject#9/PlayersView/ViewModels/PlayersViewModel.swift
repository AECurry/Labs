//
//  PlayersViewModel.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI
import SwiftData
import Observation

@Observable
class PlayersViewModel {
    var students: [Student] = []
    var isLoading = false
    var searchText = ""
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadStudents()
    }
    
    var filteredStudents: [Student] {
        if searchText.isEmpty {
            return students
        }
        return students.filter { student in
            student.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func loadStudents() {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let descriptor = FetchDescriptor<Student>(
                sortBy: [SortDescriptor(\.name)]
            )
            students = try modelContext.fetch(descriptor)
        } catch {
            print("Error loading students: \(error)")
        }
    }
    
    func addStudent(_ student: Student) {
        modelContext.insert(student)
        saveContext()
        loadStudents()
    }
    
    func deleteStudent(_ student: Student) {
        modelContext.delete(student)
        saveContext()
        loadStudents()
    }
    
    func deleteStudents(at offsets: IndexSet) {
        let studentsToDelete = offsets.map { filteredStudents[$0] }
        
        for student in studentsToDelete {
            modelContext.delete(student)
        }
        
        saveContext()
        loadStudents()
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    func refreshStudents() {
        loadStudents()
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
