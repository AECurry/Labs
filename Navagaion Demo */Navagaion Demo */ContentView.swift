//
//  ContentView.swift
//  Navagaion Demo *
//
//  Created by AnnElaine on 10/8/25.
//

import SwiftUI

struct Student: Identifiable {
    var id: UUID = UUID()
    var name: String
    var favoriteColor: Color
}

//list of student names

let students = [
    Student(name: "Alice", favoriteColor: .red),
    Student(name: "Bob", favoriteColor: .blue),
    Student(name: "Charlie", favoriteColor: .green),
    Student(name: "Diana", favoriteColor: .purple),
    Student(name: "Ethatn", favoriteColor: .orange),
    Student(name: "Fiona", favoriteColor: .pink)
]

struct ContentView: View {
    @State private var isPresentingSheet = false
    @State private var path
    
    var body: some View {
        NavigationStack {
            VStack {
                button("Present Sheet") {
                    isPresentingSheet = true
                }
                
                List(students) { student in
                    NavigaitonLink {
                        student.favoriteColor
                            .ignoresSafeArea()
                    } lable: {
                        Text(student.name)
                    }
                    NavigationLink(value: student.favorieColor) {
                        Text(student.name)
                    }
                }
            }
            .navigationTitle("Students")
            .sheet(isPresented: $isPresentingSheet) {
                NavigationStack {
                    
                }
                Text("Sheet happens")
            }
        }
    }
}

#Preview {
    ContentView()
}
