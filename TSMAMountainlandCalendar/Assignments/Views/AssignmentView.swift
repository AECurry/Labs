//
//  AssignmentView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

/// Main assignments screen displaying hierarchical course curriculum
/// Uses original professional design with course sections → assignment types → individual assignments
/// Primary assignments screen in the bottom navigation tab
struct AssignmentView: View {
    let currentUser: Student
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeader(
                title: "iOS Development",
                subtitle: "Fall/Spring - 25/26"
            )
            
            CourseSectionView(currentUser: currentUser)
        }
    }
}

#Preview {
    AssignmentView(currentUser: Student.demoStudents[0])
}
